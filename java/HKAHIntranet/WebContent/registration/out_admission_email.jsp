<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>

<%
UserBean userBean = new UserBean(request);
String email = request.getParameter("email");
String appointmentDate = request.getParameter("appointmentDate");
String appointmentTime_hh = request.getParameter("appointmentTime_hh");
String appointmentTime_mi = request.getParameter("appointmentTime_mi");
String attendDoctor = request.getParameter("attendDoctor");
String sendDT = "";

Calendar cal = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy kk:mm", Locale.ENGLISH);

if (email != null && email.length() > 0) {
	if (AdmissionDB.sendEmailNotifyClient(userBean, email, "out", appointmentDate, appointmentTime_hh, appointmentTime_mi, attendDoctor)) {
		%><blank>Email Sent to <%=email %> !</blank><%
	} else {
		%><blank>Fail to Send Email to <%=email %>!</blank><%
	}
}
%>