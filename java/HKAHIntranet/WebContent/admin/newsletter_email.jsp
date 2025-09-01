<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String email = request.getParameter("email");
String enlID = request.getParameter("enlID");
String patientType = request.getParameter("patientType");
System.out.println("enlID: "+enlID);
System.out.println("[patientType]"+patientType);
if (email != null && email.length() > 0) {
	if (AdmissionDB.sendEmailNotifyClient(userBean,"cherry.wong@hkah.org.hk")) {
		%><blank>Email Sent to <%=email %>!</blank><%
	} else {
		%><blank>Fail to Send Email to <%=email %>!</blank><%
	}
}
%>