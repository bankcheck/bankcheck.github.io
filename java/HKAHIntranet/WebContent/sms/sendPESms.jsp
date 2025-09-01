<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.common.UserBean"%>
<%@ page import="com.hkah.util.ParserUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.PatientDB"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.util.sms.UtilSMS"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.web.common.ReportableListObject"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%!
private String getPESmsContent(String lang) {
	String content = null;
	if (lang == null) {
		return null;
	}
	
	if (lang.equals("ENG")) {
		content = "HKAH-SR: It’s time to take charge of your health! Booking and Enquiries (852) 3651 8789. Online booking: https://goo.gl/Nqh9XP";
	} else if (lang.equals("TRC")) {
		content = "香港港安：定期身體檢查有助了解自己的健康狀況，預防及減低嚴重疾病帶來的威脅！預約及查詢：(852) 3651 8789。網上即時預約：https://goo.gl/GBQp9S";
	} else if (lang.equals("SMC")) {
		content = "香港港安：定期身体检查有助了解自己的健康状况，预防及减低严重疾病带来的威胁！预约及查询：(852) 3651 8789。网上即时预约：https://goo.gl/GBQp9S";
	} else if (lang.equals("JAP")) {
		content = "定期健康診断でご自身の健康管理をしましょう！ご予約・お問い合わせ(852) 3651 8789、オンライン予約：https://goo.gl/wqfp3a";
	}

	return content;
}

private ArrayList getTmpPeSms() {
	return getTmpPeSms(null);
}

private ArrayList getTmpPeSms(String patno) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT PATNO, PATNAME, PATMTEL, MOTHCODE FROM TMP_PE_SMS");
	if (patno != null && !patno.isEmpty()) {
		sqlStr.append(" WHERE PATNO = '" + patno + "'");
	}
	
	System.out.println("[sendPESms] getTmpPeSms sql="+sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
/*
Patient list from Kenneth Ho:
1. Have done PE between Jun 2013 to May 2016
2. Have not done PE after May 2016
5. Package name not start with RENAL or STAFF
4. Patient status is -1
5. Coucode is 852
6. Mobile phone is 8 digits and not null

Table : TMP_PE_SMS
Total size: 1619 (20170620)
*/

UserBean userBean = new UserBean(request);
if(!userBean.isAdmin()) {
	return;
}

System.out.println("[sendPESms] === Health Assessment send physical exam reminder SMS (" + new Date() + ") ===");

String smcid = "pe.reminder1";
String patno = ParserUtil.getParameter(request, "patno");
String lang = null;
String phoneNo = null;
String content = "";
String responseStr = null;
String run = ParserUtil.getParameter(request, "run");
boolean success = true;

if ("1".equals(run)) {
	ArrayList record = getTmpPeSms(patno);
	System.out.println("[sendPESms] record size="+record.size());
	
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			ReportableListObject row = (ReportableListObject)record.get(i);
			
			patno = row.getValue(0);
			lang = row.getValue(3);
			if (lang.length() <= 0) {
				lang = "ENG";
			}
			phoneNo = row.getValue(2);
		
			if (phoneNo == null) {
				success = false;
			} else {
				content = getPESmsContent(lang);
		
				if (content != null) {
		/*
					UtilMail.sendMail(
							"alert@hkah.org.hk",
							new String[] { "ricky.leung@hkah.org.hk" },
							null,
							null,
							"Hong Kong Adventist Hospital SR - SMS TESTING",
							"SMS: <br/>BKGID: "+bkID+" PHONENO: "+phoneNo+
							"<br/><br/>"+content,false);
		*/
	
					responseStr = UtilSMS.sendSMS(null, new String[] { phoneNo },
								content,
								UtilSMS.SMS_HA, patno, lang, smcid);
	
				} else {
					//error
					UtilSMS.saveLog("Cannot retrieve any template",
							patno, UtilSMS.SMS_HA, "", smcid);
					success = false;
				}
			}
			
			System.out.println("[sendPESms] (" + i + ") patno="+patno+", phoneNo="+phoneNo+", lang="+lang+", success="+success+", response=["+responseStr+"]");
			//System.out.println("[sendPESms]  content="+content);
		}
	} else {
		// No record found to send
		UtilSMS.saveLog("Cannot find any record to send",
				patno, UtilSMS.SMS_HA, "", smcid);
		success = false;
		
		System.out.println("[sendPESms] Cannot find any record to send");
	}
%>
Done
<%
} else {
%>
Please pass in query parameter run=1
<%
}
%>