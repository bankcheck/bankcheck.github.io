<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String selectedHoliday = request.getParameter("selectedHoliday");
ArrayList record = ELeaveDB.getLeaveHoliday();
ReportableListObject row = null;
if (record.size() > 0) {
%>
<option value=""></option>
<%
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(selectedHoliday)?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>