package com.hkah.web.schedule;

import java.io.IOException;
import java.util.ArrayList;

import org.apache.commons.lang.StringUtils;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;
import com.hkah.web.db.helper.IPAppointDetail;
import com.hkah.web.db.helper.IPDocDetail;
import com.hkah.web.db.helper.IPWardDetail;

public class NotifySendIPSmsJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " " + this.getClass().getSimpleName() + " execute");
		
		ArrayList ipList = getSMSList();
		ArrayList<IPDocDetail> doctorDetailList = new ArrayList<IPDocDetail>();

		for (int i = 0; i < ipList.size(); i++) {
			ReportableListObject row = (ReportableListObject) ipList.get(i);

			String regId = row.getValue(4);
			String patNo = row.getValue(6);
			String wardCode = row.getValue(5);
			String docCode = row.getValue(0);
			String wardName = row.getValue(7);
			String bedCode = row.getValue(8);
			String phone1 = row.getValue(2);
			String phone2 = row.getValue(3);
			String currdateStr = row.getValue(9);
			boolean foundDocCode = false;
			for (IPDocDetail d : doctorDetailList) {
				if (d.docCode.equals(docCode)) {
					foundDocCode = true;
					d.ipAppointDetailList.add(new IPAppointDetail(regId, patNo, wardCode, wardName, bedCode, currdateStr));
					break;
				}
			}
			if (foundDocCode == false) {
				IPDocDetail tDoc = new IPDocDetail(docCode, phone1, phone2);
				tDoc.ipAppointDetailList.add(new IPAppointDetail(regId, patNo, wardCode, wardName, bedCode, currdateStr));
				doctorDetailList.add(tDoc);
			}
		}

//		int i = 0;
		for (IPDocDetail d : doctorDetailList) {
			String smsContent = "";
			if ((d.phone != null && d.phone.length() > 0) || (d.phone2 != null && d.phone2.length() > 0)) {
				smsContent = getSMSMessage(d);
//				System.out.println("============" + d.docCode + "===============");
//				System.out.println(smsContent);

				if (smsContent != null) {
					//if ( i == 0) {
//						System.out.println("phone1 = " + d.phone + " phone2 = " + d.phone2);
//						d.phone = "54120233";
						sendSms(d.phone, smsContent, d.ipAppointDetailList);
						sendSms(d.phone2, smsContent, d.ipAppointDetailList);
					//}
					//i++;
				}
			}
		}
		
		EmailAlertDB.sendSysAlertLogEmail(this.getClass().getSimpleName(), null);
	}

	private static void sendSms(String phone, String smsContent, ArrayList<IPAppointDetail> ipWardList) {

		if (phone != null && phone.length() > 0) {
			try {
				String msgId = UtilSMS.sendSMS("", new String[] { StringUtils.deleteWhitespace(phone) },
						smsContent,
						"INPATDOCNUM",  "" , "ENG", "");
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	private static String getSMSMessage(IPDocDetail d) {
		StringBuffer smsContent = new StringBuffer();

		String currdateStr = null;
		if (!d.ipAppointDetailList.isEmpty()) {
			currdateStr = d.ipAppointDetailList.get(0).dateStr;
		}

		String docname = null;
		if (ConstantsServerSide.isTWAH()) {
			smsContent.append("Message from HKAH-TW: Current IP" + (currdateStr == null ? "" : " as of " + currdateStr) + "\n");
			docname = getDoctorSurName(d.docCode);
		} else {
			smsContent.append("Message from HKAH-SR: Current IP" + (currdateStr == null ? "" : " as of " + currdateStr) + "\n");
			docname = getDoctorName(d.docCode, false);
		}

		smsContent.append("To Dr." + docname + "\n");
		ArrayList<IPWardDetail> wardList = new ArrayList<IPWardDetail>();
		for (int i = 0; i < d.ipAppointDetailList.size(); i++) {
			String tWardCode =  d.ipAppointDetailList.get(i).wardCode;
			String tWardName =  d.ipAppointDetailList.get(i).wardName;
			String tBedCode = d.ipAppointDetailList.get(i).bedCode;
			boolean foundDocCode = false;
			for (IPWardDetail w : wardList) {
				if (w.wardCode.equals(tWardCode)) {
					foundDocCode = true;
					w.numCount++;
					w.bedString = w.bedString + ", " + tBedCode;
					break;
				}
			}
			if (foundDocCode == false) {
				IPWardDetail tWard = new IPWardDetail(tWardCode, tWardName, 1, tBedCode);
				wardList.add(tWard);
			}
		}
		for (IPWardDetail w : wardList) {
			smsContent.append(w.wardName + ": " + w.numCount + " (" + w.bedString + ")" + "\n" );
		}

		return smsContent.toString();
	}

	public static ArrayList getSMSList() {
		StringBuffer sqlStr = new StringBuffer();
/* OLD SQL
		sqlStr.append("SELECT k.idoccode, k.iregid, k.wrdcode, k.patno, k.wrdname, k.bedcode FROM (select d.doccode as idoccode, d.docfname||' '||d.docgname doctor_name, i.* ");
		sqlStr.append("from doctor@iweb d , (select h.sec_dr1, h.sec_dr2, h.sec_dr3, h.sec_dr4, h.sec_dr5 , ");
		sqlStr.append("h.sec_dr1_name, h.sec_dr2_name, h.sec_dr3_name, h.sec_dr4_name, h.sec_dr5_name , h.sec_dr1_show, ");
		sqlStr.append("h.sec_dr2_show, h.sec_dr3_show, h.sec_dr4_show, h.sec_dr5_show , h.sec_dr1_rmk, h.sec_dr2_rmk, ");
		sqlStr.append("h.sec_dr3_rmk, h.sec_dr4_rmk, h.sec_dr5_rmk , a.patno, a.patename, a.patsex, a.patage , ");
		sqlStr.append("a.regdate, a.bedcode, a.doccode , a.regid as iregid,  (select x.wrdcode from ward@iweb x, Room@iweb xr,Bed@iweb xb ");
		sqlStr.append("where x.wrdcode=xr.wrdcode and xr.romcode = xb.romcode and xb.bedcode = a.bedcode) as wrdcode , ");
		sqlStr.append("(select wrdname from ward@iweb x, Room@iweb xr,Bed@iweb xb  where x.wrdcode=xr.wrdcode ");
		sqlStr.append("and xr.romcode = xb.romcode and xb.bedcode = a.bedcode) as wrdname , p.patbdate ");
		sqlStr.append("from qry_inpatient@cis A, DOCTOR@iweb D, nx_handover@cis h, PATIENT@iweb P ");
		sqlStr.append("where inpddate is null AND A.DOCCODE=D.DOCCODE AND A.PATNO=P.PATNO and a.regid=h.regid(+) ");
		sqlStr.append(") i ");
		sqlStr.append("where d.doccode=i.doccode  or (d.doccode = i.sec_dr1 and i.sec_dr1_show<>'N') or (d.doccode = i.sec_dr2 ");
		sqlStr.append("and i.sec_dr2_show<>'N') or (d.doccode = i.sec_dr3 and i.sec_dr3_show<>'N') or (d.doccode = i.sec_dr4 ");
		sqlStr.append("and i.sec_dr4_show<>'N') or (d.doccode = i.sec_dr5 and i.sec_dr5_show<>'N')) k, DOCTOR_EXTRA@IWEB DC ");
		sqlStr.append("WHERE    k.idoccode = DC.DOCCODE AND    (DC.SMSTYPE = '2' OR DC.SMSTYPE = '3') ORDER BY k.idoccode, k.wrdcode, k.bedCode ");
*/
		sqlStr.append("SELECT sms.master_doctor, sms.doccode, smstel, smstel2 ");
//		sqlStr.append("--, k.doccode, k.treatment_doctor ");
		sqlStr.append(", k.regid, k.wrdcode, k.patno, k.wrdname, k.bedcode ");
		sqlStr.append(", to_char(sysdate, 'Mon dd @ hh24:mi', 'NLS_DATE_LANGUAGE=AMERICAN') AS CURRDATE ");
		sqlStr.append("FROM qry_drs_patient@cis k ");
		sqlStr.append(", (select nvl(d.mstrdoccode,d.doccode) as master_doctor, m.* ");
//		sqlStr.append("from doctor@iweb d, DOCTOR_EXTRA@IWEB m ");
		sqlStr.append("from doctor@iweb d, DOCTOR_EXTRA@IWEB m, HPSTATUS@IWEB h ");
//		sqlStr.append("where d.doccode=m.doccode and m.smstype in ('2','3') ");
		sqlStr.append("where  d.doccode=m.doccode(+) and d.doccode=h.HPKEY ");
		sqlStr.append("and h.HPSTATUS in ('2') AND h.HPACTIVE = -1 and h.HPTYPE = 'DSMSTYPE' ");
		sqlStr.append(") sms ");
		sqlStr.append("WHERE k.master_doctor = sms.master_doctor ");
		// remove duplicated records for non-master code
		sqlStr.append("AND sms.master_doctor = sms.doccode ");
		sqlStr.append("ORDER BY sms.master_doctor, k.wrdcode, k.bedCode ");

//		System.out.println("[NotifySendIPSmsThread] getSMSList=" + sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private static String[] getDocPhone(String docCode) {
		String[] phone = new String[2];
		phone[0] = "";
		phone[1] = "";

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	 DOCCODE, SMSTEL, SMSTEL2 ");
		sqlStr.append("FROM 	 DOCTOR_EXTRA@IWEB ");
		sqlStr.append("WHERE 	 DOCCODE = '" + docCode + "'");

		ArrayList docList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < docList.size(); i++) {
			ReportableListObject row = (ReportableListObject) docList.get(0);
			if (row.getValue(1) != null && row.getValue(1).length() > 0) {
				phone[0] = row.getValue(1);
			}
			if (row.getValue(2) != null && row.getValue(2).length() > 0) {
				phone[1] = row.getValue(2);
			}
			break;
		}
		return phone;
	}

	private static boolean getSuccessOfSMS(String msgId) {
		StringBuffer sql_getSuccessStats = new StringBuffer();

		sql_getSuccessStats.append("SELECT SUCCESS ");
		sql_getSuccessStats.append("FROM SMS_LOG ");
		sql_getSuccessStats.append("WHERE MSG_BATCH_ID = '"+msgId+"' ");

		ArrayList record = UtilDBWeb.getReportableList(sql_getSuccessStats.toString());
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject)record.get(0);

			return row.getValue(0).equals("1");
		} else {
			return false;
		}
	}

	private static String getDoctorSurName(String docCode) {
		return getDoctorName(docCode, true);
	}

	private static String getDoctorName(String docCode, boolean surNameOnly) {
		String docName = "";
		String docFName = null;
		String docGName = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCFNAME, DOCGNAME FROM DOCTOR@IWEB WHERE UPPER(DOCCODE) = UPPER('"+docCode+"')");

		ArrayList docList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < docList.size(); i++) {
			ReportableListObject row = (ReportableListObject) docList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				docFName = row.getValue(0);
				docGName = row.getValue(1);
			}
		}

		if (surNameOnly) {
			docName = docFName;
		} else {
			docName = docFName + " " + docGName;	// chinese only
		}

		if (StringUtils.isBlank(docName)) {
			docName = docCode;
		}

		return docName;
	}
}