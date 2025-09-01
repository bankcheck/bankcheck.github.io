<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String projectID = request.getParameter("projectID");
String ignoreProjectID = request.getParameter("ignoreProjectID");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All Projects ---";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = ProjectSummaryDB.getList(userBean, null);
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		if (!row.getValue(0).equals(ignoreProjectID)) {
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(projectID)?" selected":"" %>><%=row.getValue(1) %></option><%
		}
	}
}
%>