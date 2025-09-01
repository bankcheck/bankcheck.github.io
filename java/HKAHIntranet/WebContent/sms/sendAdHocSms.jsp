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
String docCode = ParserUtil.getParameter(request, "docCode");
String docMobile = ParserUtil.getParameter(request, "docMobile"); 
String keyID = ParserUtil.getParameter(request, "keyID");

String content = "";
boolean success = true;

				
		//String phoneNo = "69010602";
		 String phoneNo =
		UtilSMS.getPhoneNo(docMobile.trim(), "852",null, null, "ENG", "ic", UtilSMS.SMS_OUTPAT);
	
	if (phoneNo == null) {
		success = false;
	} else {
		content = "[HKAH-SR (Final notice)] If you have yet to complete this Self-Declaration form, https://forms.gle/rGreb6A6doMxcNKq7 kindly note that booking of patient beds and admission cannot proceed, thank you!";

 		if (content != null) {
			
  			 UtilSMS.sendSMS(null, new String[] { phoneNo },
					content,
					UtilSMS.SMS_OUTPAT, keyID, "ENG", "ic");  


			} else {
			//error
			 UtilSMS.saveLog("Cannot retrieve any template",
					 keyID, UtilSMS.SMS_OUTPAT, "", "ic");
			success = false; 
		} 
	}


%>
<%=success%>