package com.hkah.web.schedule;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;

public class NotifyOBDischargeJob implements Job {

	// ======================================================================
	private static String sqlStr_getLastEmailRecord = null;
	private static String sqlStr_insertEmailRecord = null;
	private static String sqlStr_getInpatDetails = null;
	private static final String dblink = ConstantsServerSide.DEBUG ? "@iweb_uat" : "@iweb";

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		String lastEmailDate = "";
		String seqDceID = getDceID();
		ArrayList<ReportableListObject> lastEmailRecord = UtilDBWeb.getReportableList(sqlStr_getLastEmailRecord);
		if (lastEmailRecord.size() > 0) {
			ReportableListObject lastEmailRow = (ReportableListObject) lastEmailRecord.get(0);
			lastEmailDate = lastEmailRow.getValue(1);

			UtilDBWeb.updateQueue(sqlStr_insertEmailRecord, new String[] { seqDceID });
			ArrayList<ReportableListObject> dischargeRecord = getOutStandingDischLog(lastEmailDate);

			for (int i = 0; i < dischargeRecord.size(); i++) {
				ReportableListObject dischargeRow = (ReportableListObject) dischargeRecord.get(i);
				String emailType = "";
				String title = "";
				String oldDDate = dischargeRow.getValue(1);
				String newDDate = dischargeRow.getValue(2);
				String displayDDate = "";

				if ((oldDDate != null && oldDDate.length() > 0) && (newDDate == null || newDDate.length() == 0)) {
					emailType = "C";
					title = "OSB Patient Discharge Cancelled";
					displayDDate = oldDDate;
				} else if ((oldDDate == null || oldDDate.length() == 0)
						&& (newDDate != null && newDDate.length() > 0)) {
					emailType = "D";
					title = "OSB Patient Discharge";
					displayDDate = newDDate;
				}

				if ("C".equals(emailType) || "D".equals(emailType)) {
					ArrayList<ReportableListObject> patDetailsRecord = UtilDBWeb
							.getReportableList(sqlStr_getInpatDetails, new String[] { dischargeRow.getValue(0) });
					if (patDetailsRecord.size() > 0) {
						ReportableListObject patDetailsRow = (ReportableListObject) patDetailsRecord.get(0);
						String wardCode = patDetailsRow.getValue(4);
						String wardName = patDetailsRow.getValue(5);
						String bed = patDetailsRow.getValue(6);
						String classType = patDetailsRow.getValue(7);
						String patientName = patDetailsRow.getValue(3);
						String doctorName = patDetailsRow.getValue(8);

						title = (ConstantsServerSide.DEBUG ? "[UAT-HKAH] " : "") + title + ": " + wardCode + "-" + bed
								+ " (" + classType + ") " + displayDDate;

						StringBuffer content = new StringBuffer();
						if (ConstantsServerSide.DEBUG) {
							content.append("<p><b>[UAT-HKAH]</b><br />");
						}
						content.append("<u>" + ("C".equals(emailType) ? "Cancelled " : "") + "Discharge</u>: "
								+ displayDDate + "<br />");
						content.append("Ward: " + wardName + "<br />");
						content.append("Bed no.: " + bed + "<br />");
						content.append("Patient Admitted Class: " + classType + "<br />");
						content.append("Patient: " + patientName + "<br />");
						content.append("Admission Doctor: Dr. " + doctorName);

						// String[] sendTo = new String[] {"booking-team@hkah.org.hk"};
						// String[] sendBcc = null;
						// if (ConstantsServerSide.DEBUG) {
						// sendBcc = new String[] {"ricky.leung@hkah.org.hk"};
						// }

						boolean emailSuccess = EmailAlertDB.sendEmail("osb.discharge", title, content.toString());
					}
				}
			}
		} else {
			String title = "OSB Patient Discharge Scheduler - Fail to get last email record";
			String content = "[NotifyOBDischargeThread] Fail to get last email record. Process stopped. Please check:\n "
					+ sqlStr_getLastEmailRecord.toString();
			EmailAlertDB.sendEmail("admin", title, content.toString());
		}
	}

	// ======================================================================
	private static ArrayList getOutStandingDischLog(String lastEmailDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(
				" SELECT     INPID , TO_CHAR(INPDDATE_O, 'dd-MM-yyyy hh24:mi'), TO_CHAR(INPDDATE_N, 'dd-MM-yyyy hh24:mi') ");
		sqlStr.append(" FROM       DISCHARGEDATE_LOG" + dblink + " ");
		if (lastEmailDate != null && lastEmailDate.length() > 0) {
			sqlStr.append(" WHERE      DDLGDATE >= TO_DATE('" + lastEmailDate + "','DD/MM/YYYY hh24:mi:ss') ");
		}
		sqlStr.append(" ORDER BY   DDLGID ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	// ======================================================================
	private static String getDceID() {
		String dceID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CO_DCEID) + 1 FROM CO_DISCHARGE_EMAIL");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			dceID = reportableListObject.getValue(0);

			// set 1 for initial
			if (dceID == null || dceID.length() == 0)
				return "1";
		}
		return dceID;
	}

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append(
				" select  REG.REGID, REG.SLPNO, REG.PATNO,PAT.PATFNAME	|| ' ' || PAT.PATGNAME, WA.WRDCODE, WA.WRDNAME, BED.BEDCODE, AC.ACMNAME, D.DOCFNAME	|| ' ' || D.DOCGNAME ");
		sqlStr.append(" FROM    Reg" + dblink + " reg, Inpat" + dblink + " inp, Patient" + dblink + " pat, Package"
				+ dblink + " pck, Bed" + dblink + " bed, Room" + dblink + " rom , WARD" + dblink + " WA, ACM" + dblink
				+ " AC, DOCTOR" + dblink + " D ");
		sqlStr.append(" WHERE   reg.patno = pat.patno ");
		sqlStr.append(" AND     inp.bedcode = bed.bedcode(+) ");
		sqlStr.append(" and     REG.PKGCODE = PCK.PKGCODE ");
		sqlStr.append(" and     inp.doccode_A = d.doccode ");
		sqlStr.append(" and     BED.ROMCODE = ROM.ROMCODE(+) ");
		sqlStr.append(" and     REG.INPID = INP.INPID (+) ");
		sqlStr.append(" and     ROM.WRDCODE=WA.WRDCODE (+) ");
		sqlStr.append(" and     inp.ACMCODE=AC.ACMCODE (+) ");
		sqlStr.append(" AND     INP.INPID = ? ");
		sqlStr_getInpatDetails = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append(" select   CO_DCEID, TO_CHAR(CO_LASTEMAILSEND_DATE, 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append(" FROM     CO_DISCHARGE_EMAIL ");
		sqlStr.append(" WHERE    CO_ENABLED = '1' ");
		sqlStr.append(" ORDER BY CO_DCEID DESC ");
		sqlStr_getLastEmailRecord = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_DISCHARGE_EMAIL (");
		sqlStr.append("CO_DCEID)");
		sqlStr.append("VALUES (?) ");
		sqlStr_insertEmailRecord = sqlStr.toString();
	}
}