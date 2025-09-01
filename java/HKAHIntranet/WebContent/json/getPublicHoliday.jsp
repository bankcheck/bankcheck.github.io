<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="net.sf.json.*" %>
<%@ page import="java.io.PrintWriter" %>

<%
ArrayList records = null;

String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");
JSONObject leaveJSON = new JSONObject();
JSONArray jsonArray = new JSONArray();

//System.out.println(startDate);
//System.out.println(endDate);

if (startDate != null && endDate != null && startDate.length() > 0 &&
		endDate.length() > 0) {
	records = ELeaveDB.getLeaveHoliday(startDate, endDate);
}
else {
	records = ELeaveDB.getLeaveHoliday();
}

if (records.size() > 0) {
	ReportableListObject row = null;
	for (int i = 0; i < records.size(); i++) {
		row = (ReportableListObject) records.get(i);
		leaveJSON.put(String.valueOf(i), row.getValue(0).replaceAll("/", ""));
	}
}
response.setContentType("application/json");
//System.out.println(leaveJSON.toString());
PrintWriter writer = response.getWriter();
writer.print(request.getParameter("callback")+"("+leaveJSON.toString()+ ");");
writer.close();
%>