<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchGroup() {
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_CUS_GROUP_ID, CRM_CUS_GROUP_DESC, ");
		sqlStr.append("TO_CHAR(CRM_MODIFIED_DATE, 'DD/MM/YYYY') ");
		sqlStr.append("FROM CRM_SMSEMAIL_CUS_GROUP ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("ORDER BY CRM_CUS_GROUP_DESC ");
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String groupID = request.getParameter("groupID");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = fetchGroup();
ReportableListObject row = null;
boolean isSelected = false;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		isSelected = false;
		if (groupID != null && groupID.length() > 0) {
				if (row.getValue(0).equals(groupID)) {
					isSelected = true;
				}
			
		}
%><option value="<%=row.getValue(0) %>"<%=isSelected?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>