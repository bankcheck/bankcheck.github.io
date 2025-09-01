<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String loginDeptCode = userBean.getDeptCode();
String loginDeptDesc = userBean.getDeptDesc();

String moduleCode = request.getParameter("moduleCode");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = MessageResources.getMessage(session, "label.selectAllTest");
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = SsoUserDB.getSsoModuleList();
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(moduleCode)?" selected":"" %>><%=row.getValue(1) %> (<%=row.getValue(0) %>)</option><%
	}
}
%>