<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.mail.*"%>

<%
UserBean userBean = new UserBean(request);

String email = request.getParameter("email");
String type = request.getParameter("type");
String preBID = request.getParameter("BPBID");
String admDate = request.getParameter("admDate");
String sendDT = "";

Calendar cal = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy kk:mm", Locale.ENGLISH);

if (email != null && email.length() > 0) {
	if (AdmissionDB.sendEmailNotifyClient(userBean, email, "in")) {
		if(type != null && type.equals("INPAT")) {
			UtilMail.insertEmailLog(userBean, preBID, type, "EMAIL", true, null);
			sendDT = InPatientPreBookDB.updateSentDT("EMAIL", preBID, null);
		}
		%><blank>Email Sent to <%=email %> <%=((type != null && type.equals("INPAT"))?("on "+sdf.format(cal.getTime())):"") %>!</blank><%
	} else {
		if(type != null && type.equals("INPAT")) {
			UtilMail.insertEmailLog(userBean, preBID, type, "EMAIL", false, null);
		}
		%><blank>Fail to Send Email to <%=email %>!</blank><%
	}
} 
%>