package com.hkah.web.schedule;

import java.util.ArrayList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;

public class NotifyPatientUpdateJob implements Job {

	// ======================================================================
	private static String sqlStr_getLastEmailRecord = null;
	private static String sqlStr_insertEmailRecord = null;
	private static final String dblink = ConstantsServerSide.DEBUG ? "@iweb_uat" : "@iweb";

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		String lastEmailDate = "";
		ArrayList<ReportableListObject> lastEmailRecord = UtilDBWeb.getReportableList(sqlStr_getLastEmailRecord);
		if (lastEmailRecord.size()>0) {
			ReportableListObject lastEmailRow = (ReportableListObject)lastEmailRecord.get(0);
			lastEmailDate = lastEmailRow.getValue(1);
		}
		UtilDBWeb.updateQueue(sqlStr_insertEmailRecord);
		ArrayList<ReportableListObject> patUpdateRecord = getOutStandingPatUpdateLog(lastEmailDate);

			for (int i = 0; i < patUpdateRecord.size(); i++) {
				ReportableListObject patUpdateRow = (ReportableListObject) patUpdateRecord.get(i);
				String patNo = patUpdateRow.getValue(1);
				String oldPatFName = patUpdateRow.getValue(2);
				String oldPatGName = patUpdateRow.getValue(3);
				String oldPatCName = patUpdateRow.getValue(4);
				String oldPatSex   = patUpdateRow.getValue(5);
				String oldPatBDate = patUpdateRow.getValue(6);
				String newPatFName = patUpdateRow.getValue(7);
				String newPatGName = patUpdateRow.getValue(8);
				String newPatCName = patUpdateRow.getValue(9);
				String newPatSex = patUpdateRow.getValue(10);
				String newPatBDate = patUpdateRow.getValue(11);

				 String title = (ConstantsServerSide.DEBUG ? "[UAT-HKAH] " : "") + "Patient data changed (#" + patNo + ")";

				 StringBuffer content = new StringBuffer();
				 if (ConstantsServerSide.DEBUG) {
					 content.append("<p><b>[UAT-HKAH]</b><br />");
				 }
				 content.append("Patient # : " + patNo );
				 content.append("<table>");
				 content.append("	<tr>");
				 content.append("		<td style='text-align:right'>From :</td><td style='text-align:right'>Patient Name :</td><td>" + oldPatFName + " " + oldPatGName + "</td>");
				 content.append("	</tr>");
				 if (oldPatCName.length() > 0) {
					 content.append("	<tr>");
					 content.append("		<td></td><td></td><td>" + oldPatCName + "</td>");				 //
					 content.append("	</tr>");
				 }
				 content.append("	<tr>");
				 content.append("		<td></td><td style='text-align:right'>Sex :</td><td>" + oldPatSex  + "</td>");
				 content.append("	</tr>");
				 content.append("	<tr>");
				 content.append("		<td></td><td style='text-align:right'>DOB :</td><td>" + oldPatBDate  + "</td>");
				 content.append("	</tr>");

				 content.append("	</tr><td>&nbsp;</td></tr>");

				 content.append("	<tr>");
				 content.append("		<td style='text-align:right'>To :</td><td style='text-align:right'>Patient Name :</td><td>" + newPatFName + " " + newPatGName + "</td>");
				 content.append("	</tr>");
				 if (newPatCName.length() > 0) {
					 content.append("	<tr>");
					 content.append("		<td></td><td></td><td>" + newPatCName + "</td>");				 //
					 content.append("	</tr>");
				 }
				 content.append("	<tr>");
				 content.append("		<td></td><td style='text-align:right'>Sex :</td><td>" + newPatSex  + "</td>");
				 content.append("	</tr>");
				 content.append("	<tr>");
				 content.append("		<td></td><td style='text-align:right'>DOB :</td><td>" + newPatBDate  + "</td>");
				 content.append("	</tr>");
				 content.append("</table>");

				 boolean emailSuccess = EmailAlertDB.sendEmail("patient.update", title, content.toString());
				 //boolean emailSuccess = UtilMail.sendMail(ConstantsServerSide.MAIL_ALERT, "nfsit1988@gmail.com", title, content.toString());
			}
	}

	// ======================================================================
	private static ArrayList getOutStandingPatUpdateLog(String lastEmailDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(" SELECT     PULID, PATNO, OLDPATFNAME, OLDPATGNAME, OLDPATCNAME, OLDPATSEX, TO_CHAR(OLDPATBDATE, 'dd-MM-yyyy'), ");
		sqlStr.append(" 						 NEWPATFNAME, NEWPATGNAME, NEWPATCNAME, NEWPATSEX, TO_CHAR(NEWPATBDATE, 'dd-MM-yyyy') ");
		sqlStr.append(" FROM       PATIENT_UPDATE_LOG" + dblink + " ");
		if (lastEmailDate != null && lastEmailDate.length() > 0 ) {
			sqlStr.append(" WHERE      PULDATE >= TO_DATE('" + lastEmailDate + "','DD/MM/YYYY hh24:mi:ss') ");
		}
		sqlStr.append(" ORDER BY   PULID ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	// ======================================================================
	private static String getPueID() {
		String pueID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CO_PUEID) + 1 FROM CO_PATIENT_UPDATE_EMAIL");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			pueID = reportableListObject.getValue(0);

			// set 1 for initial
			if (pueID == null || pueID.length() == 0) return "1";
		}
		return pueID;
	}

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append(" select   CO_PUEID, TO_CHAR(CO_LASTEMAILSEND_DATE, 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append(" FROM     CO_PATIENT_UPDATE_EMAIL ");
		sqlStr.append(" WHERE    CO_ENABLED = '1' ");
		sqlStr.append(" ORDER BY CO_PUEID DESC ");
		sqlStr_getLastEmailRecord= sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_PATIENT_UPDATE_EMAIL (");
		sqlStr.append("CO_PUEID)");
		sqlStr.append("select MAX(CO_PUEID) + 1 from CO_PATIENT_UPDATE_EMAIL");
		sqlStr_insertEmailRecord = sqlStr.toString();
	}
}