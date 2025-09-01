<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String eventID = request.getParameter("eventID");
String scheduleID = request.getParameter("scheduleID");

boolean updateAction = "update".equals(request.getParameter("commandType"));

if (eventID != null && scheduleID != null) {
	HashSet seminarPhysicalList = new HashSet();

	// get seminar physical list
	ArrayList record = CRMPhysicalDB.getSeminarPhysicalList(eventID, scheduleID);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			seminarPhysicalList.add(row.getValue(0));
		}
	}

	// get all physical list
	record = CRMPhysicalDB.getPhysicalList("9");
	if (record.size() > 0) {
%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
<%
		boolean checkFlag = false;
		String currentGroupID = null;
		int counter = 0;

		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			checkFlag = seminarPhysicalList.contains(row.getValue(2));
			if (!row.getValue(0).equals(currentGroupID)) {
				counter = 0;
%>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=row.getValue(1) %></td>
		<td class="infoData" width="70%">
<%
			}
			if (updateAction) {
%>			<input type="checkbox" name="figureID" value="<%=row.getValue(2) %>"<%=checkFlag?" checked":"" %>><%=row.getValue(3) %><%
				// change another line
				if (counter % 5 == 4) out.println("<br>");
			} else if (checkFlag) {
%>			<%=row.getValue(3) %><%
			}
			currentGroupID = row.getValue(0);
			counter++;
		}
%>
		</td>
	</tr>
</table>
<%
	}
}
%>