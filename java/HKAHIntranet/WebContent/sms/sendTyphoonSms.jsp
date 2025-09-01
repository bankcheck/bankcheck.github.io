<%@ page import="com.hkah.web.common.UserBean"%>
<%@ page import="com.hkah.util.ParserUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.PatientDB"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.util.sms.UtilSMS"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.web.schedule.NotifyPatientAppointment"%>
<%@ page import="com.hkah.web.common.ReportableListObject"%>
<%@ page import="com.hkah.config.MessageResources"%>

<%
UserBean userBean = new UserBean(request);
String bkID = ParserUtil.getParameter(request, "bkID");
String smcid = ParserUtil.getParameter(request, "smcid");
String docCode = ParserUtil.getParameter(request, "docCode");
String docMobile = ParserUtil.getParameter(request, "docMobile"); 
String sendType = ParserUtil.getParameter(request, "sendType");
String appDate = ParserUtil.getParameter(request, "appDate");

ArrayList record = null;
if (!"doctor".equals(sendType)) {
	 record = PatientDB.getAppointmentInformation(bkID);
}
String content = "";
boolean success = true;


if (record!= null && record.size() > 0) {
	String lang = "";
	ReportableListObject row = (ReportableListObject)record.get(0);

	lang = row.getValue(0);

	if (lang.length() <= 0) {
		lang = "ENG";
	}

	//lang = "JAP";//for testing only

 	String phoneNo =
		NotifyPatientAppointment.getPhoneNo(row.getValue(4).trim(), row.getValue(18).trim(),
				row.getValue(14).trim(), row.getValue(12), lang, "typhoon", UtilSMS.SMS_OUTPAT,(ConstantsServerSide.isHKAH()?row.getValue(24).trim():null)); 
	//String phoneNo = "69010602";

	if (phoneNo == null) {
		success = false;
	} else {
		content = UtilSMS.getTyphoonSmsContent(smcid, lang);

		if (content != null) {
/*
			UtilMail.sendMail(
					"alert@hkah.org.hk",
					new String[] { "andrew.lau@hkah.org.hk" },
					null,
					null,
					"Hong Kong Adventist Hospital - SMS TESTING",
					"SMS: <br/>BKGID: "+bkID+" PHONENO: "+phoneNo+
					"<br/><br/>"+content,false);
*/

				 UtilSMS.sendSMS(userBean, new String[] { phoneNo },
						content,
						UtilSMS.SMS_OUTPAT, row.getValue(12), lang, "typhoon"+smcid); 



		} else {
			//error
			UtilSMS.saveLog("Cannot retrieve any template",
				bkID, UtilSMS.SMS_OUTPAT, "", "typhoon");
			success = false;
		}
	}
} else if ("doctor".equals(sendType)) {
	 String phoneNo =
		NotifyPatientAppointment.getPhoneNo(docMobile.replace(" ",""), "852",
				"", "", "ENG", "typhoon", UtilSMS.SMS_OUTPAT, null); 
				
		//String phoneNo = "69010602";
	
	if (phoneNo == null) {
		success = false;
	} else {
		content = UtilSMS.getTyphoonSmsContent("12", "ENG");

		if (content != null) {
			
  			 UtilSMS.sendSMS(userBean, new String[] { phoneNo },
					content,
					UtilSMS.SMS_OUTPAT, "T"+appDate+docCode, "ENG", "typhoon12");  
/*
			UtilMail.sendMail(
					"alert@hkah.org.hk",
					new String[] { "andrew.lau@hkah.org.hk" },
					null,
					null,
					"Hong Kong Adventist Hospital - SMS TESTING",
					"SMS: <br/>BKGID: "+bkID+" PHONENO: "+phoneNo+
					"<br/><br/>"+content,false);
*/

			} else {
			//error
			 UtilSMS.saveLog("Cannot retrieve any template",
				bkID, UtilSMS.SMS_OUTPAT, "", "typhoon");
			success = false; 
		}
	}
} else {
	//Fail
	UtilSMS.saveLog("Cannot find any record with this BKGID",
			bkID, UtilSMS.SMS_OUTPAT, "", "typhoon");
	success = false;
}

%>
<%=success%>