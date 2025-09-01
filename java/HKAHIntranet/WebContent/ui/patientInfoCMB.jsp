<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.io.PrintWriter" %>

<%
String patNo = request.getParameter("patno");

ArrayList record = PatientDB.getPatInfo(patNo);
ReportableListObject row = null;
JSONObject patientJSON = new JSONObject();

if(record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	
	patientJSON.put("PATNO", row.getValue(0));
	patientJSON.put("PATSEX", row.getValue(1));
	patientJSON.put("PATNAME", row.getValue(3));
	patientJSON.put("PATCNAME", row.getValue(4));
	patientJSON.put("PATBDATE", row.getValue(10));
	patientJSON.put("AGE", row.getValue(5));
	patientJSON.put("PATFNAME", row.getValue(11));
	patientJSON.put("PATGNAME", row.getValue(12));
	patientJSON.put("PATMSTS", row.getValue(13));
	patientJSON.put("RELIGIOUS", row.getValue(14));
	patientJSON.put("OCCUPATION", row.getValue(15));
	patientJSON.put("EMERPERSON", row.getValue(16));
	
	response.setContentType("text/javascript");
	PrintWriter writer = response.getWriter();
	writer.print(request.getParameter("callback")+"("+patientJSON.toString()+ ");");
	writer.close();
}
%>