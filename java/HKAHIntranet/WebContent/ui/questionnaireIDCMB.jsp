<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchQuestionaire() {
		// fetch questionnaire
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_QUESTIONAIRE_ID, CRM_QUESTIONAIRE_DESC ");
		sqlStr.append("FROM   CRM_QUESTIONAIRE ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("ORDER BY CRM_QUESTIONAIRE_DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String questionnaireID = request.getParameter("questionnaireID");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All Questionnaires ---";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = fetchQuestionaire();
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(questionnaireID)?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>