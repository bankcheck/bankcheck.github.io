<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String clientID = request.getParameter("clientID");

ArrayList record = GHCClientDB.getRejectDateList(clientID);
if (record.size() > 0) {
	ReportableListObject row = null;
	for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			%><%=row.getValue(0) %>&nbsp;<%
	}
}
%>