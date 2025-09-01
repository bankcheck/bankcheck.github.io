<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String level = request.getParameter("level");
String parentValue = request.getParameter("parentValue");
String currentValue = request.getParameter("currentValue");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
%><option value=""><%=emptyLabel %></option><%
}

ArrayList record = EventType.getList(level, parentValue);
ReportableListObject row = null;
String key = null;
String value = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		key = row.getValue(2);
		value = row.getValue(3);
%><option value="<%=key %>"<%=key.equals(currentValue)?" selected":"" %>><%=value==null?ConstantsVariable.EMPTY_VALUE:value.toUpperCase() %></option><%
	}
} else {
%><option value="">N/A</option><%
}
%>