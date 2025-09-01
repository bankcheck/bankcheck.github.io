<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
	private ArrayList fetchClient(boolean isTeam20) {
		// fetch appeal
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME ");
		sqlStr.append("FROM   CRM_CLIENTS ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		if(isTeam20){
			sqlStr.append("AND  CRM_ISTEAM20 = 1 ");
		}
		sqlStr.append("ORDER BY CRM_LASTNAME, CRM_FIRSTNAME");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String clientID = request.getParameter("clientID");
boolean isFilterValues = ConstantsVariable.YES_VALUE.equals(request.getParameter("isFilterValues"));
boolean isTeam20 = ConstantsVariable.YES_VALUE.equals(request.getParameter("isTeam20"));
String[] filterValues = null;
if (isFilterValues) {
	filterValues = (String[]) request.getAttribute("clientIDCMB_filterValues");
}

boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All Clients ---";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = fetchClient(isTeam20);
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