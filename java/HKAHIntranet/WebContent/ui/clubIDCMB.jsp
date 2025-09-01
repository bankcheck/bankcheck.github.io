<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchClub() {
		// fetch club
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_CLUB_ID, CRM_CLUB_DESC ");
		sqlStr.append("FROM   CRM_CLUBS ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("ORDER BY CRM_CLUB_DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String[] clubID = request.getParameterValues("clubID");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All Clubs ---";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = fetchClub();
ReportableListObject row = null;
boolean isSelected = false;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		isSelected = false;
		if (clubID != null && clubID.length > 0) {
			for (int j = 0; j < clubID.length && !isSelected; j++) {
				if (row.getValue(0).equals(clubID[j])) {
					isSelected = true;
				}
			}
		}
%><option value="<%=row.getValue(0) %>"<%=isSelected?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>