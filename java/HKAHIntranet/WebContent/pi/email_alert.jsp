<%@ page language="java" contentType="text/html; charset=big5"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"%><%!
%><%
UserBean userBean = new UserBean(request);

String pirID = request.getParameter("pirid");
String staffid = request.getParameter("staffid");
String incident_classification = null;
String emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());
String emailToList = StaffDB.getStaffEmail(staffid);
ReportableListObject row = null;

if (pirID != null && pirID.length() > 0) {
	ArrayList record = PiReportDB.fetchReportBasicInfo(pirID);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		incident_classification = row.getValue(10);
	}
}

// submit email
PiReportDB.sendEmailSubmit(userBean, incident_classification, pirID, "Submit", emailFromList, emailToList);
%>