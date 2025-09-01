<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
	private ArrayList fetchStaff() {
		// fetch appeal
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT DISTINCT AC.AC_USER_ID, S.CO_LASTNAME, S.CO_FIRSTNAME ");
		sqlStr.append("FROM AC_USER_GROUPS AC,CO_STAFFS S ");
		sqlStr.append("WHERE AC.AC_USER_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND S.CO_ENABLED = 1 ");		
		sqlStr.append("ORDER BY S.CO_LASTNAME, S.CO_FIRSTNAME ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String staffID = request.getParameter("staffID");
boolean isFilterValues = ConstantsVariable.YES_VALUE.equals(request.getParameter("isFilterValues"));
String[] filterValues = null;
if (isFilterValues) {
	filterValues = (String[]) request.getAttribute("clientACIDCMB_filterValues");
}

boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All AC Users ---";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = fetchStaff();
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
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(staffID)?" selected":"" %>><%=row.getValue(1) %>, <%=row.getValue(2) %></option><%
		}
	}
}
%>