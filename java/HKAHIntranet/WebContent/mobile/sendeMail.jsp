<%@ page import="java.net.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean =  new UserBean(request);
String rtnFlag = null;
String receiverEMail = request.getParameter("receiverEMail");
String subject = request.getParameter("subject");
if (subject != null) {
	subject = new String(subject.getBytes("ISO-8859-1"), "UTF-8");
}
String content = request.getParameter("content");
if (content != null) {
	content = new String(content.getBytes("ISO-8859-1"), "UTF-8");
}
String command = request.getParameter("command");
String message = null;
String errorMessage = null;

Calendar calendar = Calendar.getInstance();
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");
String sysDate = dateFormat.format(calendar.getTime());

System.err.println("[receiverEMail]:"+receiverEMail+";[subject]:"+subject+";[content]:"+content);
boolean forward = false;

if (forward) {
	try {
		if (ConstantsServerSide.SITE_CODE_HKAH.equals("hkah")) {
			%><%=ServerUtil.connectServer("http://160.100.2.80/intranet/mobile/sendeMail.jsp", "receiverEMail=" + receiverEMail + "&subject=" + subject + "&content=" + URLEncoder.encode(content, "UTF-8")) %><%
		} else {
			%><%=ServerUtil.connectServer("http://192.168.0.20/intranet/mobile/sendeMail.jsp", "receiverEMail=" + receiverEMail + "&subject=" + subject + "&content=" + URLEncoder.encode(content, "UTF-8")) %><%
		}
	} catch (Exception e) {}
} else {
	if (EMailDB.sendEmail(receiverEMail, subject, content)) {
		UtilMail.insertEmailLog(userBean, sysDate, "MOBILE", "EMAIL", true, null);
		message = "Mail resent success";
	} else {
		errorMessage = "Mail resent failed";
	}
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
		<%="<u>The Status of Email</u><br/>Success:<br/>"+message+"<br/>Fail:<br/>"+errorMessage%>
    </body>
</html>
<%}%>