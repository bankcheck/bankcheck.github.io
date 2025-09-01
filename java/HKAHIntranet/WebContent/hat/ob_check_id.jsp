<%@ page import="com.hkah.web.db.*"%><%
String patientID = request.getParameter("patientID");

if (OBBookingDB.checkPatientID(patientID)) {
	out.print("OK");
} else {
	out.print("NOK");
}
%>