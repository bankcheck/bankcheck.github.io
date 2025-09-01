<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.io.PrintWriter" %>

<%
String staffId = request.getParameter("staffid");

ArrayList record = StaffDB.get(staffId);
ReportableListObject row = null;
JSONObject staffJSON = new JSONObject();

if(record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	
	staffJSON.put("STAFFID", staffId);
	staffJSON.put("STAFFNAME", row.getValue(3));
	staffJSON.put("DEPTCODE", row.getValue(1));
	staffJSON.put("PATNO", row.getValue(11));
	staffJSON.put("DEPTDESC", row.getValue(2));
	if(row.getValue(11).length() > 0 ) {
		ArrayList patRec = PatientDB.getPatInfo(row.getValue(11));
		ReportableListObject patRow = null;
		if(patRec.size() > 0) {
			patRow = (ReportableListObject) patRec.get(0);
			staffJSON.put("STAFFSEX", patRow.getValue(1));
		}
	}
	
	response.setContentType("text/javascript");
	PrintWriter writer = response.getWriter();
	writer.print(request.getParameter("callback")+"("+staffJSON.toString()+ ");");
	writer.close();
}
%>