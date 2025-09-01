<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String eventID = request.getParameter("eventID");
String scheduleID = request.getParameter("scheduleID");
String clientID = request.getParameter("clientID");

boolean updateAction = "update".equals(request.getParameter("commandType"));

// get seminar physical list
ArrayList record = CRMPhysicalDB.getClientPhysicalList(eventID, scheduleID, clientID);
HashSet figureIDSet = new HashSet();
if (record.size() > 0) {
%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
<%
	String currentGroupID = null;
	ReportableListObject row = null;
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%if (!row.getValue(0).equals(currentGroupID)) { %><%=row.getValue(1) %><%} %></td>
		<td class="infoData" width="20%"><%=row.getValue(3) %></td>
		<td class="infoData" width="50%"><%
		if (updateAction) {
			figureIDSet.add(row.getValue(2));
%><input type="textfield" name="figureID_<%=row.getValue(2) %>" value="<%=row.getValue(5) %>"><%
		} else {
%><%=row.getValue(5) %><%
		} %> <%=row.getValue(4) %><br><%
		currentGroupID = row.getValue(0);
	}
%>
		</td>
	</tr>
</table>
<%
}
if (updateAction) {
	// store figure id set in the session
	session.setAttribute("crm.figureID", figureIDSet);
}
%>