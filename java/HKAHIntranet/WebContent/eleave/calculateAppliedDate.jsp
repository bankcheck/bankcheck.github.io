<%@ page import="com.hkah.web.db.*"%>
<%
String fromDateStr = request.getParameter("fromDate");
String fromDateUnit = request.getParameter("fromDateUnit");
String toDateStr = request.getParameter("toDate");
String toDateUnit = request.getParameter("toDateUnit");

String[] dateRange = ELeaveDB.parseDateRange(fromDateStr, fromDateUnit, toDateStr, toDateUnit);
if (dateRange != null) {
	%><%=dateRange[2] %><%
} else {
	 %>N/A<%
} %>