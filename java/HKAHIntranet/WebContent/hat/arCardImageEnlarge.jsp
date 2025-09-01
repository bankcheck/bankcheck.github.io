<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.file.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%!
	private String getFolderPath(String parcde) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT Param1 ");
		sqlStr.append("FROM   Sysparam@IWEB ");
		sqlStr.append("WHERE  Parcde = ?");

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { parcde });
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		}
		return null;
	}
%><%
try {
	UtilFile.getServerImage(request, response, getFolderPath("ACTPHOPATH"), request.getParameter("arcard"));
} catch (Exception e) {
	%><img src="/hats/images/Photo Not Available.jpg"><%
}
%>