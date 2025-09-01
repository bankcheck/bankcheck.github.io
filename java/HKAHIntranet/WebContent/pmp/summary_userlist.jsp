<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String projectID = request.getParameter("projectID");

ReportableListObject row = null;

ArrayList record = ProjectSummaryDB.getUserList(projectID);
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		%><%=row.getValue(1) %>; <%
	}
}
%>