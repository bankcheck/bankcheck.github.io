package com.hkah.web.schedule;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

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
import com.hkah.web.db.helper.OTDocDetail;
import com.hkah.web.db.helper.OTSurgDetail;

public class NotifySendOTSmsJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " " + this.getClass().getSimpleName() + " execute");
		
		Calendar tommorowDate = Calendar.getInstance();
		tommorowDate.add(Calendar.DATE, 1);
		SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);			
		ArrayList otSurgList = getSMSList(smf, tommorowDate);
		ArrayList<OTDocDetail> doctorDetailList = new ArrayList<OTDocDetail>();
		
		//System.out.println("otSurgList.size() = " + otSurgList.size());		
		
		for (int i = 0; i < otSurgList.size(); i++) {
			ReportableListObject row = (ReportableListObject) otSurgList.get(i);				
			String otaId = row.getValue(0);
			String patNo = row.getValue(1);				
			String docCode = row.getValue(4);
			String surgDate = row.getValue(5);
			String surgDesc = row.getValue(6);
			String procRemark = row.getValue(7);
			String surgDescSec = row.getValue(8);
			String doctype = row.getValue(9);
			String anaesthetist = row.getValue(10);
			
			boolean foundDocCode = false;
			for (OTDocDetail d : doctorDetailList) {
				if (d.docCode.equals(docCode)) {
					foundDocCode = true;
					d.otSurgDetailList.add(new OTSurgDetail(otaId, patNo, surgDate, surgDesc, procRemark, surgDescSec, anaesthetist));
					d.docType = doctype;
					break;
				} 
			}
			if (foundDocCode == false) {			
				String[] tPhone = getDocPhone(docCode);
				OTDocDetail tDoc = new OTDocDetail(docCode, tPhone[0], tPhone[1], doctype);
				tDoc.otSurgDetailList.add(new OTSurgDetail(otaId, patNo, surgDate, surgDesc, procRemark, surgDescSec, anaesthetist));
				doctorDetailList.add(tDoc);
			}
		}

		int i = 0;
		for (OTDocDetail d : doctorDetailList) {
			if ((d.phone != null && d.phone.length() > 0) || (d.phone2 != null && d.phone2.length() > 0)) {
				List<String> strings = getSMSMessage(d);					
//System.out.println("============" + d.docCode + "===============");
//System.out.println("phone1 = " + d.phone + " phone2 = " + d.phone2);						
				for (String s : strings) {
					try {

//System.out.println("[SEND] d.docCode=" + d.docCode+ ", phone1 = " + d.phone + " phone2 = " + d.phone2 + ", s="+s);			

						sendSms(d.phone, s, d.otSurgDetailList);
						sendSms(d.phone2, s, d.otSurgDetailList);
						TimeUnit.SECONDS.sleep(5);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}	
			}
		}
		
		EmailAlertDB.sendSysAlertLogEmail(this.getClass().getSimpleName(), null);
	}
	
	private static void sendSms(String phone, String smsContent, ArrayList<OTSurgDetail> otSurgList) {
		if (phone != null && phone.length() > 0) {
			try {						
				String msgId = UtilSMS.sendSMS("", new String[] { StringUtils.deleteWhitespace(phone) },
						smsContent,
						"OT",  "" , "ENG", "");
				
				if (getSuccessOfSMS(msgId)) {
					for (OTSurgDetail ot : otSurgList ) {
//						updateSuccessTimeAndMsg(ot.otaid, msgId);						
					}
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
					
	private static boolean updateSuccessTimeAndMsg(String id, String msgId) {
		StringBuffer sqlStr = new StringBuffer();
		if (checkOtAppExtraRecord(id)) {
			sqlStr.append("UPDATE	OT_APP_EXTRA@IWEB ");
			sqlStr.append("set ");
			sqlStr.append("SMSSDT     = SYSDATE, ");        
			sqlStr.append("SMSSDTOK = (SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = '"+msgId+"'), ");
			sqlStr.append("SMSRTNMSG = (SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = '"+msgId+"') ");
			sqlStr.append("WHERE	OTAID = '"+id+"' ");
		} else {			
			sqlStr.append("INSERT INTO OT_APP_EXTRA@IWEB(");
			sqlStr.append(" OTAID, SMSSDT, SMSSDTOK, SMSRTNMSG) ");
			sqlStr.append("VALUES (");
			sqlStr.append("'"+id+"', ");
			sqlStr.append("SYSDATE, ");			
			sqlStr.append("(SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = '"+msgId+"')," );
			sqlStr.append("(SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = '"+msgId+"')) ");
		}
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
			
	private static List<String> getSMSMessage(OTDocDetail d) {
		StringBuffer smsContent = new StringBuffer();
		
		List<String> strings = new ArrayList<String>();
		int numTillSplit = 765;
					
		String docname = null;
		if (ConstantsServerSide.isTWAH()) {
			smsContent.append("Message from HKAH-TW:\n");
			docname = getDoctorSurName(d.docCode);
		} else {
			smsContent.append("Message from HKAH-SR:\n");
			docname = getDoctorName(d.docCode, false);
		}
		smsContent.append("To Dr." + docname + "\n");
		for (int i = 0; i < d.otSurgDetailList.size(); i++) {
			String tOtaid =  d.otSurgDetailList.get(i).otaid;
			String tSurgDate =  d.otSurgDetailList.get(i).surgDate;
			String tSurgDesc =  d.otSurgDetailList.get(i).surgDesc;
			String tProcRemark = d.otSurgDetailList.get(i).procRemark;
			String tSurgDescSec = d.otSurgDetailList.get(i).surgDescSec;
			String tAnaesthetistCode  = d.otSurgDetailList.get(i).anaesthetist ;
			String tAnaesthetistName = getDoctorName(tAnaesthetistCode, false);
			StringBuffer tempSmsContent = new StringBuffer();
			
			tempSmsContent.append("(" + (i + 1) + ") Surgery Date: " + tSurgDate + "\n");
			tempSmsContent.append("Procedure: " + tSurgDesc);
			if (tSurgDescSec != null && !tSurgDescSec.isEmpty()) {
				tempSmsContent.append(", ");
				tempSmsContent.append(tSurgDescSec);
			}
			
			if (tProcRemark != null && tProcRemark.length() > 0) {
				tempSmsContent.append(" (" + tProcRemark + ")");
			}
			tempSmsContent.append("\n");
			tempSmsContent.append("Anaesthetist: " + tAnaesthetistName + "\n");
			if (tempSmsContent.length() + smsContent.length() >= numTillSplit) {
				strings.add(smsContent.toString());
				smsContent.setLength(0);
				smsContent.append(tempSmsContent);
			} else {
				smsContent.append(tempSmsContent);
			}				
		}
		
		String footerString = "A".equals(d.docType) ? "" : "Please complete Financial Estimation if applicable";
		if (smsContent.length() +  footerString.length() >= numTillSplit) {
			strings.add(smsContent.toString());
			strings.add(footerString);
		} else {
			smsContent.append(footerString);
			strings.add(smsContent.toString());
		}
		
		return strings;
	}

	private static ArrayList getSMSList(SimpleDateFormat smf, Calendar tommorowDate) {
		StringBuffer sqlStr = new StringBuffer();
/*
		sqlStr.append("SELECT * FROM (SELECT A.OTAID AS OTAID, A.PATNO AS PATNO, A.OTAFNAME AS OTAFNAME, A.OTAGNAME AS OTAGNAME, A.DOCCODE_S AS DOCCODE, "); 
		sqlStr.append("to_char(A.OTAOSDATE, 'Mon dd @ hh24:mi', 'NLS_DATE_LANGUAGE=AMERICAN') AS OTAOSDATE, P.OTPDESC AS OTPDESC, OTAPROCRMK  AS OTAPROCRMK ");
		sqlStr.append("FROM		 OT_APP@IWEB A, OT_PROC@IWEB P, OT_APP_EXTRA@IWEB E, DOCTOR_EXTRA@IWEB D "); 
		sqlStr.append("WHERE	 A.OTAOSDATE >= 		   	TO_DATE('"+smf.format(tommorowDate.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') "); 
		sqlStr.append("AND  	 A.OTAOSDATE <= 			TO_DATE('"+smf.format(tommorowDate.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND  	A.OTASTS IN ('N' , 'F') AND	    A.OTPID = P.OTPID AND	    A.OTAID = E.OTAID(+) ");
		sqlStr.append("AND      A.DOCCODE_S = D.DOCCODE AND    (D.SMSTYPE = '1' OR D.SMSTYPE = '3') ");
		sqlStr.append("UNION ");
		sqlStr.append("SELECT 	 A.OTAID AS OTAID, A.PATNO AS PATNO, A.OTAFNAME AS OTAFNAME, A.OTAGNAME AS OTAGNAME, A.DOCCODE_A AS DOCCODE, "); 
		sqlStr.append("to_char(A.OTAOSDATE, 'Mon dd @ hh24:mi', 'NLS_DATE_LANGUAGE=AMERICAN') AS OTAOSDATE, P.OTPDESC  AS OTPDESC, OTAPROCRMK AS OTAPROCRMK ");
		sqlStr.append("FROM		 OT_APP@IWEB A, OT_PROC@IWEB P, OT_APP_EXTRA@IWEB E, DOCTOR_EXTRA@IWEB D "); 
		sqlStr.append("WHERE	 A.OTAOSDATE >= 		   	TO_DATE('"+smf.format(tommorowDate.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') "); 
		sqlStr.append("AND  	 A.OTAOSDATE <= 			TO_DATE('"+smf.format(tommorowDate.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND  	A.OTASTS IN ('N' , 'F') AND	    A.OTPID = P.OTPID AND	    A.OTAID = E.OTAID(+) ");
		sqlStr.append("AND      A.DOCCODE_A = D.DOCCODE AND    (D.SMSTYPE = '1' OR D.SMSTYPE = '3') ");
		sqlStr.append("UNION ");
		sqlStr.append("SELECT 	 A.OTAID AS OTAID, A.PATNO AS PATNO, A.OTAFNAME AS OTAFNAME, A.OTAGNAME AS OTAGNAME, OA.DOCCODE AS DOCCODE, "); 
		sqlStr.append("to_char(A.OTAOSDATE, 'Mon dd @ hh24:mi', 'NLS_DATE_LANGUAGE=AMERICAN') AS OTAOSDATE, P.OTPDESC  AS OTPDESC, OTAPROCRMK  AS OTAPROCRMK ");
		sqlStr.append("FROM		 OT_APP@IWEB A, OT_PROC@IWEB P, OT_APP_EXTRA@IWEB E, OT_APP_SURG@IWEB OA, DOCTOR_EXTRA@IWEB D "); 
		sqlStr.append("WHERE	 A.OTAOSDATE >= 		   	TO_DATE('"+smf.format(tommorowDate.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND  	 A.OTAOSDATE <= 			TO_DATE('"+smf.format(tommorowDate.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND       A.OTAID = OA.OTAID ");
		sqlStr.append("AND  	A.OTASTS IN ('N' , 'F') AND	    A.OTPID = P.OTPID AND	    A.OTAID = E.OTAID(+) ");
		sqlStr.append("AND      OA.DOCCODE = D.DOCCODE AND    (D.SMSTYPE = '1' OR D.SMSTYPE = '3')) ");
		sqlStr.append("ORDER BY OTAOSDATE ");		
*/
		
		sqlStr.append("SELECT * FROM "); 
		sqlStr.append("(SELECT distinct A.OTAID AS OTAID, A.PATNO AS PATNO, A.OTAFNAME AS OTAFNAME, A.OTAGNAME AS OTAGNAME, A.DOCCODE_S AS DOCCODE, "); 
		sqlStr.append("to_char(A.OTAOSDATE, 'Mon dd @ hh24:mi', 'NLS_DATE_LANGUAGE=AMERICAN') AS OTAOSDATE, P.OTPDESC AS OTPDESC, OTAPROCRMK  AS OTAPROCRMK ");
		sqlStr.append("  ,(SELECT LISTAGG(op.otpdesc, ', ') WITHIN GROUP (ORDER BY op.otpdesc) sec_otpid  ");
		sqlStr.append("    from OT_APP_PROC@iweb oap join ot_proc@iweb op on oap.otpid = op.otpid ");
		sqlStr.append("    where oap.otaid = A.OTAID ");
		sqlStr.append("    GROUP BY oap.otaid ");
		sqlStr.append("  ) sec_otpdescs, 'S' doctype, A.DOCCODE_A AS Anaesthetist ");
//		sqlStr.append("FROM   OT_APP@IWEB A, OT_PROC@IWEB P, OT_APP_EXTRA@IWEB E, DOCTOR_EXTRA@IWEB D, doctor@iweb m ");  
		sqlStr.append("FROM   OT_APP@IWEB A, OT_PROC@IWEB P, OT_APP_EXTRA@IWEB E, HPSTATUS@IWEB D, doctor@iweb m ");			
		sqlStr.append("WHERE   A.OTAOSDATE >=                         TO_DATE('"+smf.format(tommorowDate.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') "); 
		sqlStr.append("AND     A.OTAOSDATE <=                            TO_DATE('"+smf.format(tommorowDate.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') "); 
		sqlStr.append("AND     A.OTASTS IN ('N' , 'F') AND         A.OTPID = P.OTPID AND     A.OTAID = E.OTAID(+) "); 
//		sqlStr.append("AND     A.DOCCODE_S=m.doccode  and (nvl(m.mstrdoccode,m.doccode) = D.DOCCODE or m.doccode = D.DOCCODE) "); 
		sqlStr.append("AND     A.DOCCODE_S=m.doccode  and (nvl(m.mstrdoccode,m.doccode) = D.HPKEY or m.doccode = D.HPKEY) ");			
//		sqlStr.append("AND    (D.SMSTYPE = '1' OR D.SMSTYPE = '3') "); 
		sqlStr.append("AND 	   D.HPSTATUS IN ('1','3') AND D.HPTYPE = 'DSMSTYPE' AND D.HPACTIVE = -1 ");			
		sqlStr.append("UNION "); 			 
		sqlStr.append("SELECT distinct A.OTAID AS OTAID, A.PATNO AS PATNO, A.OTAFNAME AS OTAFNAME, A.OTAGNAME AS OTAGNAME, A.DOCCODE_A AS DOCCODE, ");
		sqlStr.append("to_char(A.OTAOSDATE, 'Mon dd @ hh24:mi', 'NLS_DATE_LANGUAGE=AMERICAN') AS OTAOSDATE, P.OTPDESC  AS OTPDESC, OTAPROCRMK AS OTAPROCRMK ");
		sqlStr.append("  ,(SELECT LISTAGG(op.otpdesc, ', ') WITHIN GROUP (ORDER BY op.otpdesc) sec_otpid  ");
		sqlStr.append("    from OT_APP_PROC@iweb oap join ot_proc@iweb op on oap.otpid = op.otpid ");
		sqlStr.append("    where oap.otaid = A.OTAID ");
		sqlStr.append("    GROUP BY oap.otaid ");
		sqlStr.append("  ) sec_otpdescs, 'A' doctype, A.DOCCODE_A AS Anaesthetist ");			
//		sqlStr.append("FROM     OT_APP@IWEB A, OT_PROC@IWEB P, OT_APP_EXTRA@IWEB E, DOCTOR_EXTRA@IWEB D, doctor@iweb m ");  
		sqlStr.append("FROM     OT_APP@IWEB A, OT_PROC@IWEB P, OT_APP_EXTRA@IWEB E, HPSTATUS@IWEB D, doctor@iweb m ");			
		sqlStr.append("WHERE    A.OTAOSDATE >=                         TO_DATE('"+smf.format(tommorowDate.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') "); 
		sqlStr.append("AND      A.OTAOSDATE <=                            TO_DATE('"+smf.format(tommorowDate.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') "); 
		sqlStr.append("AND      A.OTASTS IN ('N' , 'F') AND  A.OTPID = P.OTPID AND  A.OTAID = E.OTAID(+) "); 
//		sqlStr.append("AND     A.DOCCODE_A=m.doccode  and (nvl(m.mstrdoccode,m.doccode) = D.DOCCODE or m.doccode = D.DOCCODE) ");
		sqlStr.append("AND     A.DOCCODE_A=m.doccode  and (nvl(m.mstrdoccode,m.doccode) = D.HPKEY or m.doccode = D.HPKEY) ");			
//		sqlStr.append("AND    (D.SMSTYPE = '1' OR D.SMSTYPE = '3') ");
		sqlStr.append("AND 	   D.HPSTATUS IN ('1','3') AND D.HPTYPE = 'DSMSTYPE' AND D.HPACTIVE = -1 ");			
		sqlStr.append("UNION "); 
		sqlStr.append("SELECT distinct A.OTAID AS OTAID, A.PATNO AS PATNO, A.OTAFNAME AS OTAFNAME, A.OTAGNAME AS OTAGNAME, OA.DOCCODE AS DOCCODE, "); 
		sqlStr.append("to_char(A.OTAOSDATE, 'Mon dd @ hh24:mi', 'NLS_DATE_LANGUAGE=AMERICAN') AS OTAOSDATE, P.OTPDESC  AS OTPDESC, OTAPROCRMK  AS OTAPROCRMK ");
		sqlStr.append("  ,(SELECT LISTAGG(op.otpdesc, ', ') WITHIN GROUP (ORDER BY op.otpdesc) sec_otpid  ");
		sqlStr.append("    from OT_APP_PROC@iweb oap join ot_proc@iweb op on oap.otpid = op.otpid ");
		sqlStr.append("    where oap.otaid = A.OTAID ");
		sqlStr.append("    GROUP BY oap.otaid ");
		sqlStr.append("  ) sec_otpdescs, 'S2' doctype, A.DOCCODE_A AS Anaesthetist ");
//		sqlStr.append("FROM  OT_APP@IWEB A, OT_PROC@IWEB P, OT_APP_EXTRA@IWEB E, OT_APP_SURG@IWEB OA, DOCTOR_EXTRA@IWEB D, doctor@iweb m ");
		sqlStr.append("FROM  OT_APP@IWEB A, OT_PROC@IWEB P, OT_APP_EXTRA@IWEB E, OT_APP_SURG@IWEB OA, HPSTATUS@IWEB D, doctor@iweb m ");			
		sqlStr.append("WHERE       A.OTAOSDATE >=                         TO_DATE('"+smf.format(tommorowDate.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') "); 
		sqlStr.append("AND            A.OTAOSDATE <=                            TO_DATE('"+smf.format(tommorowDate.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') "); 
		sqlStr.append("AND       A.OTAID = OA.OTAID "); 
		sqlStr.append("AND           A.OTASTS IN ('N' , 'F') AND         A.OTPID = P.OTPID AND     A.OTAID = E.OTAID(+) "); 
//		sqlStr.append("AND     OA.DOCCODE=m.doccode  and (nvl(m.mstrdoccode,m.doccode) = D.DOCCODE or m.doccode = D.DOCCODE) ");
		sqlStr.append("AND     OA.DOCCODE=m.doccode  and (nvl(m.mstrdoccode,m.doccode) = D.HPKEY or m.doccode = D.HPKEY) ");			
//		sqlStr.append("AND    (D.SMSTYPE = '1' OR D.SMSTYPE = '3') ");
		sqlStr.append("AND 	   D.HPSTATUS IN ('1','3') AND D.HPTYPE = 'DSMSTYPE' AND D.HPACTIVE = -1 ");			
		// send to endoscopist
		if (ConstantsServerSide.isHKAH()) {
			sqlStr.append("UNION "); 
			sqlStr.append("SELECT distinct A.OTAID AS OTAID, A.PATNO AS PATNO, A.OTAFNAME AS OTAFNAME, A.OTAGNAME AS OTAGNAME, A.DOCCODE_E AS DOCCODE, "); 
			sqlStr.append("to_char(A.OTAOSDATE, 'Mon dd @ hh24:mi', 'NLS_DATE_LANGUAGE=AMERICAN') AS OTAOSDATE, P.OTPDESC AS OTPDESC, OTAPROCRMK  AS OTAPROCRMK ");
			sqlStr.append("  ,(SELECT LISTAGG(op.otpdesc, ', ') WITHIN GROUP (ORDER BY op.otpdesc) sec_otpid  ");
			sqlStr.append("    from OT_APP_PROC@iweb oap join ot_proc@iweb op on oap.otpid = op.otpid ");
			sqlStr.append("    where oap.otaid = A.OTAID ");
			sqlStr.append("    GROUP BY oap.otaid ");
			sqlStr.append("  ) sec_otpdescs, 'E' doctype, A.DOCCODE_A AS Anaesthetist ");				
//			sqlStr.append("FROM   OT_APP@IWEB A, OT_PROC@IWEB P, OT_APP_EXTRA@IWEB E, DOCTOR_EXTRA@IWEB D, doctor@iweb m ");
			sqlStr.append("FROM   OT_APP@IWEB A, OT_PROC@IWEB P, OT_APP_EXTRA@IWEB E, HPSTATUS@IWEB D, doctor@iweb m ");
			sqlStr.append("WHERE   A.OTAOSDATE >=                         TO_DATE('"+smf.format(tommorowDate.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') "); 
			sqlStr.append("AND     A.OTAOSDATE <=                            TO_DATE('"+smf.format(tommorowDate.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') "); 
			sqlStr.append("AND     A.OTASTS IN ('N' , 'F') AND         A.OTPID = P.OTPID AND     A.OTAID = E.OTAID(+) "); 
//			sqlStr.append("AND     A.DOCCODE_E=m.doccode  and (nvl(m.mstrdoccode,m.doccode) = D.DOCCODE or m.doccode = D.DOCCODE) "); 
			sqlStr.append("AND     A.DOCCODE_E=m.doccode  and (nvl(m.mstrdoccode,m.doccode) = D.HPKEY or m.doccode = D.HPKEY) ");				
//			sqlStr.append("AND    (D.SMSTYPE = '1' OR D.SMSTYPE = '3') ");
			sqlStr.append("AND 	   D.HPSTATUS IN ('1','3') AND D.HPTYPE = 'DSMSTYPE' AND D.HPACTIVE = -1 ");				
		}
		sqlStr.append(") ");
		sqlStr.append("ORDER BY OTAOSDATE ");
		
		System.out.println(sqlStr.toString());
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
	
	private static boolean checkOtAppExtraRecord(String otaId) {
		StringBuffer sql_getSuccessStats = new StringBuffer();

		sql_getSuccessStats.append("SELECT OTAID ");
		sql_getSuccessStats.append("FROM OT_APP_EXTRA@IWEB ");
		sql_getSuccessStats.append("WHERE OTAID = '"+otaId+"' ");

		ArrayList record = UtilDBWeb.getReportableList(sql_getSuccessStats.toString());
		ReportableListObject row = null;

		if (record.size() > 0) {
			return true;
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