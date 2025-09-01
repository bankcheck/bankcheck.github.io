<%@ page language="java" contentType="text/html; charset=big5"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"%><%
String procedure = request.getParameter("procedure");
String leaflet = null;

ArrayList<ReportableListObject> record = null;

if (procedure != null) {
	record = UtilDBWeb.getReportableListHATS("SELECT REFURL FROM FIN_PROC WHERE PROCCODE = ?", new String[] { procedure });
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);

		leaflet = row.getValue(0);
	}
}
%><input type="hidden" id="hats_leaflet" name="hats_leaflet" value="<%=leaflet != null && leaflet.length() > 0 ? leaflet : "" %>" />
