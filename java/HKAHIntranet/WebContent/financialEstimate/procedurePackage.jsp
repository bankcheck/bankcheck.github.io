<%@ page language="java" contentType="text/html; charset=big5" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.db.*" %>
<%@ page import="com.hkah.web.common.*" %>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> fetchProcPackage(String procedure) {
		if (ConstantsServerSide.isTWAH()) {
			return UtilDBWeb.getReportableListHATS("SELECT ACMCODE, MAX(LOS) FROM FIN_PACKAGE WHERE PROCCODE = ? AND ACMCODE = (SELECT MIN(ACMCODE) FROM FIN_PACKAGE WHERE PROCCODE = ?) GROUP BY ACMCODE ORDER BY ACMCODE DESC", new String[] { procedure, procedure });
		} else {
			return UtilDBWeb.getReportableListHATS("SELECT ACMCODE, MIN(LOS) FROM FIN_PACKAGE WHERE PROCCODE = ? AND ACMCODE = (SELECT MAX(ACMCODE) FROM FIN_PACKAGE WHERE PROCCODE = ?) GROUP BY ACMCODE ORDER BY ACMCODE DESC", new String[] { procedure, procedure });
		}
	}
%>
<%
String procedure = request.getParameter("procedure");
String packageAcmCode = null;
String packageLOS = null;

ArrayList<ReportableListObject> record = fetchProcPackage(procedure);
ReportableListObject row = null;
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	packageAcmCode = row.getValue(0);
	packageLOS = row.getValue(1);
}

%><input type="hidden" name="hats_PackageAcmCode" value="<%=packageAcmCode==null||packageAcmCode.length()==0?"--":packageAcmCode %>" />
<input type="hidden" name="hats_PackageLOS" value="<%=packageLOS==null||packageLOS.length()==0?"--":packageLOS %>" />