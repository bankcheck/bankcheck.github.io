<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String loccode = request.getParameter("loccode");

ArrayList record = UtilDBWeb.getFunctionResults("NHS_CMB_LOCATION", null);
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(record)?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>