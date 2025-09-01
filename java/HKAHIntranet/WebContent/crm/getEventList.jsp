<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%!
public static ArrayList getEvent(String campaign) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT CO_EVENT_ID, CO_EVENT_DESC, CRM_CAMPAIGN_ID ");	
	sqlStr.append("FROM CO_EVENT ");
	sqlStr.append("WHERE CRM_CAMPAIGN_ID = '" + campaign + "' ");
	sqlStr.append("AND CO_ENABLED = 1 ");
	sqlStr.append("ORDER BY CO_EVENT_DESC ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
String campaign = ParserUtil.getParameter(request, "campaign");
boolean allowAll = "Y".equals(request.getParameter("allowAll"));
ArrayList eventID = new ArrayList();
ArrayList eventDesc = new ArrayList();
ArrayList record = getEvent(campaign);
if (record.size() > 0) {
	for (int i=0; i<record.size();i++){
		ReportableListObject row = (ReportableListObject) record.get(i);
		eventID.add(row.getValue(0));
		eventDesc.add(row.getValue(1));
	}
	
}

%>
<option value=""><%=allowAll?"--- All Events ---":"" %></option>
<% for(int e=0;e<eventID.size();e++){%>
	<option value="<%=eventID.get(e) %>"><%=eventDesc.get(e) %></option>
<%} %>