<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String documentID = request.getParameter("documentID");
boolean allowEmpty = !"N".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- Empty Document ---";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = DocumentDB.getList();
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(documentID)?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>