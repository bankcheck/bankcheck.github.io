<%@ page language="java" contentType="text/html; charset=big5"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"%><%
String procedure = request.getParameter("procedure");

String procedure1 = null;
String procedure2 = null;

ArrayList<ReportableListObject> record = null;

if (procedure != null) {
	record = UtilDBWeb.getReportableListHATS("SELECT P.TYPECODE, P.PROCCODE FROM FIN_PROC P, FIN_CODE C WHERE P.PROCCODE = C.PROCCODE AND P.STATUS = -1 AND (C.REFCODE = ? OR C.HATSCODE = ?)", new String[] { procedure.toUpperCase(), procedure.toUpperCase() });
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);

		procedure1 = row.getValue(0);
		procedure2 = row.getValue(1);
	}
}

%><%=record != null && record.size() > 0 ? 1 : 0 %>
<input type="hidden" name="hats_procedure1" value="<%=procedure1==null||procedure1.length()==0?"--":procedure1 %>" />
<input type="hidden" name="hats_procedure2" value="<%=procedure2==null||procedure2.length()==0?"--":procedure2 %>" />