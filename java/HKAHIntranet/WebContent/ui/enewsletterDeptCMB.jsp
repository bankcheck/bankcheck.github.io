<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String enlID = request.getParameter("enlID");
String patientType = request.getParameter("patientType");
String Dept = request.getParameter("Dept");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All Dept in E-Newsletter ---";
	}
%><option value=""><%=emptyLabel %></option><%
}

ArrayList record = ENewsletterDB.getColumnTitle(enlID,patientType );
ReportableListObject row = null;
String value = null;
%><option value=""></option><%
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		value = row.getValue(0);
%><option value="<%=value %>"<%=value.equals(Dept)?" selected":"" %>><%=value==null?ConstantsVariable.EMPTY_VALUE:value.toUpperCase() %></option><%
	}
} else {
%><option value=""></option><%
}
%>