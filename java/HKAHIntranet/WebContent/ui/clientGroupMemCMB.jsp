<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchGroup(String groupID) {
		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT  CRM_CLIENT_ID, CRM_LASTNAME||','||CRM_FIRSTNAME ,CRM_EMAIL,CRM_MOBILE_NUMBER ");
		sqlStr.append("FROM    CRM_CLIENTS ");
		sqlStr.append("WHERE   CRM_ENABLED = 1 ");
		sqlStr.append("AND     CRM_ISTEAM20 = 1 ");
		sqlStr.append("AND     CRM_GROUP_ID = "+groupID+" ");
		sqlStr.append("ORDER   BY CRM_LASTNAME, CRM_FIRSTNAME ");
		 
		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String groupID = request.getParameter("groupID");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All Clients ---";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = fetchGroup(groupID);
ReportableListObject row = null;
boolean isSelected = false;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		isSelected = false;
		if (groupID != null && groupID.length() > 0) {
				if (row.getValue(1).equals(groupID)) {
					isSelected = true;
				}
			
		}
%><option value="<%=row.getValue(0) %>" email="<%=row.getValue(2)%>" sms="<%=row.getValue(3)%>" <%=isSelected?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>