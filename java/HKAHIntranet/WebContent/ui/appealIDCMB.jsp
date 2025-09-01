<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchAppeal() {
		// fetch appeal
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_APPEAL_ID, CRM_APPEAL_DESC ");
		sqlStr.append("FROM   CRM_APPEALS ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("ORDER BY CRM_APPEAL_DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String appealID = request.getParameter("appealID");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	%><option value="">--- All Appeals ---</option><%
}
ArrayList record = fetchAppeal();
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(appealID)?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>