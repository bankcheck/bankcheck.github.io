<%@ page language="java" contentType="text/html; charset=big5"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"%><%!

	private ArrayList<ReportableListObject> getDoctorHistory(String doccode, String procedure) {
		return UtilDBWeb.getReportableListHATS("select COUNT(1) from fin_estimate e, fin_acm a where e.acmcode = a.acmcode and e.doccode = ? and e.code IN (SELECT REFCODE FROM FIN_CODE WHERE PROCCODE = ?) order by e.acmcode, e.los, e.hosp_fee", new String[] { doccode, procedure});
	}
%><%
UserBean userBean = new UserBean(request);

String doccode = request.getParameter("doccode");
String hatsDoccode = userBean.getStaffID();
String procedure = request.getParameter("procedure");
String doctorHistory = null;

if (hatsDoccode != null && hatsDoccode.length() > 2) {
	int index = hatsDoccode.indexOf("DR");
	if (index >= 0) {
		hatsDoccode = hatsDoccode.substring(2);
	}
}

ArrayList<ReportableListObject> record = null;

if (procedure != null) {
	record = getDoctorHistory(doccode, procedure);
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);

		doctorHistory = row.getValue(0);
	}
}
%><input type="hidden" id="hats_doctorHistory" name="hats_doctorHistory" value="<%=doctorHistory != null && doctorHistory.length() > 0 ? doctorHistory : "" %>" />
