<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String level = request.getParameter("level");
String parentValue = request.getParameter("parentValue");
String currentValue = request.getParameter("currentValue");
String FOSValue = request.getParameter("FOSValue");
String fOSCat = request.getParameter("fOSCat");

ArrayList record = FosDB.getCodeTableList(fOSCat, FOSValue);
ReportableListObject row = null;
String key = null;
String value = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		key = row.getValue(1);
		value = row.getValue(2);
%><option value="<%=key %>"<%=key.equals(FOSValue)?" selected":"" %>><%=value==null?ConstantsVariable.EMPTY_VALUE:value.toUpperCase() %></option><%
	}
} else {
%><option value="">N/A</option><%
}
%>