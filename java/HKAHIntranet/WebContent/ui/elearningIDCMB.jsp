<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.*"%>

<%
UserBean userBean = new UserBean(request);

String moduleCode = request.getParameter("moduleCode");
String deptCode = request.getParameter("deptCode");
String eventID = request.getParameter("eventID");
String elearningID = request.getParameter("elearningID");
String eventCategory = request.getParameter("eventCategory");
String eventType = request.getParameter("eventType");

// if not admin, use login dept code as default dept code
if (!userBean.isAdmin() && (deptCode == null || deptCode.length() == 0)) {
	deptCode = userBean.getDeptCode();
}
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = MessageResources.getMessage(session, "label.selectAllTest");
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = ELearning.getElearningEvent(eventType);
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>-<%=row.getValue(1) %>"<%=(row.getValue(0).equals(eventID) && row.getValue(1).equals(elearningID))?" selected":"" %>><%=row.getValue(2) %></option><%
	}
}
%>