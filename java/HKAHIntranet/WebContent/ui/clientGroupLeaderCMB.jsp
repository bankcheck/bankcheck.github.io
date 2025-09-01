<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
	private ArrayList fetchClient(String type, String groupID) {
		// fetch appeal
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("select    C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME "); 
		sqlStr.append("from      CRM_GROUP_COMMITTEE G, CRM_CLIENTS C ");
		sqlStr.append("where     G.CRM_CLIENT_ID  = C.CRM_CLIENT_ID ");
		sqlStr.append("and       G.CRM_ENABLED = 1 ");
		
		sqlStr.append("and   G.CRM_GROUP_ID = '"+groupID+"' ");
		
		if("leader".equals(type)){
			sqlStr.append("and   G.CRM_GROUP_ID = C.CRM_GROUP_ID ");
			sqlStr.append("and       G.CRM_GROUP_POSITION = 'team_leader' ");
		}else if("manager".equals(type)){
			sqlStr.append("and       G.CRM_GROUP_POSITION = 'case_manager' ");
		}
		sqlStr.append("ORDER BY  C.CRM_LASTNAME, C.CRM_FIRSTNAME ");
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String clientID = request.getParameter("clientID");
String type = request.getParameter("type");
String groupID = request.getParameter("groupID");
boolean isFilterValues = ConstantsVariable.YES_VALUE.equals(request.getParameter("isFilterValues"));
String[] filterValues = null;
if (isFilterValues) {
	filterValues = (String[]) request.getAttribute("clientGroupLeaderCMB_filterValues");
}

boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All Clients ---";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = fetchClient(type,groupID);
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);

		boolean showOption = false;		
		if (isFilterValues)
			showOption = false;
		else
			showOption = true;

		if (isFilterValues && filterValues != null) {
			for (int j = 0; showOption == false && j < filterValues.length; j++) {
				if (row.getValue(0) != null && row.getValue(0).equals(filterValues[j])) {
					showOption = true;					
				}
			}
		}
		
		if (showOption) {
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(clientID)?" selected":"" %>><%=row.getValue(1) %>, <%=row.getValue(2) %></option><%
		}
	}
}
%>