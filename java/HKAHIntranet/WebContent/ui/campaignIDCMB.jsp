<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchCampaign() {
		// fetch campaign
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_CAMPAIGN_ID, CRM_CAMPAIGN_DESC ");
		sqlStr.append("FROM   CRM_CAMPAIGN ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("ORDER BY CRM_CAMPAIGN_DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String campaignID = request.getParameter("campaignID");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	%><option value="">--- All Campaigns ---</option><%
}
ArrayList record = fetchCampaign();
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(campaignID)?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>