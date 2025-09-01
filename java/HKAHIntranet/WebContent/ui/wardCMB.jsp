<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String wrdCode = request.getParameter("wrdCode");
boolean allowAll = "Y".equals(request.getParameter("allowAll"));
boolean allowEmpty = !"N".equals(request.getParameter("allowEmpty"));

if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%><option value=""><%=emptyLabel %></option><%
}
if (allowAll) {
%>
<option value="">--- ALL ---</option>
<%
}
ArrayList record = OsbDB.getWards();
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(wrdCode)?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>