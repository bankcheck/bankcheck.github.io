<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.io.PrintWriter" %>

<%
String drugName = TextUtil.parseStrUTF8(
		java.net.URLDecoder.decode(
				request.getParameter("drugName").replaceAll("%", "%25")));
JSONObject dataJSON = new JSONObject();

ArrayList record = PHDrugDB.getDrugNameList(drugName);
ReportableListObject row = null;

if (record.size() > 0) {
	for(int i = 0 ; i < record.size(); i++){
		row = (ReportableListObject)record.get(i);
	
		dataJSON.put(i, row.getValue(0));
	}
}

response.setContentType("text/javascript");
PrintWriter writer = response.getWriter();
writer.print(request.getParameter("callback")+"("+dataJSON.toString()+ ");");
writer.close();
%>