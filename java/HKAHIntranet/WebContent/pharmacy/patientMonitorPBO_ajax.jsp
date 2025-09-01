<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%!
	private ArrayList<ReportableListObject> fetchQueue(String locID) {
		return UtilDBWeb.getReportableList("SELECT PH_TICKET_QUEUE_ID, PH_PRESCRIPTION_DATE, PH_DISPENSING_DATE, PH_CHARGED_DATE, PH_COLLECTION_DATE FROM PH_TICKET_QUEUE WHERE PH_LOC_ID = ? AND PH_DISPENSING_DATE IS NOT NULL AND PH_COLLECTION_DATE IS NULL AND PH_STATUS = 1 AND PH_CREATED_DATE > SYSDATE - 1/12 ORDER BY PH_TICKET_QUEUE_ID ASC", new String[] { locID });
	}
%><%

int totalRecPerTable = 10;
String locid = request.getParameter("locid");
String table = request.getParameter("table");
int tableInt = 0;
try {
	tableInt = Integer.parseInt(table);
} catch (Exception e) {}

ArrayList<ReportableListObject> record = fetchQueue(locid);
ReportableListObject row = null;
int count = record.size();
int startcount = tableInt * totalRecPerTable;
int endcount = (tableInt + 1) * totalRecPerTable;
String ticketNo = null;
boolean prescriptionFlag = false;
boolean dispensingFlag = false;
boolean chargeFlag = false;

if (count > startcount) { %>
	<td width="50%" align="center" valign="top" bgcolor="#E5DFEC"><div><table width="70%">
<%
	for (int i = startcount; i < count && i < endcount; i++) {
		row = (ReportableListObject) record.get(i);
		ticketNo = row.getValue(0);
		prescriptionFlag = row.getValue(1).length() > 0;
		dispensingFlag = row.getValue(2).length() > 0;
		chargeFlag = row.getValue(3).length() > 0;
%>
	<tr><td width="25"%" height="130">&nbsp;</td><td align="center" width="50"%" height="130"><font face="微軟正黑體" color="black"><p style="font-size:96px"><%=ticketNo %></p></font><td width="25"%" height="130"><%=chargeFlag?"<img src='../images/tick1.gif' width='50' height='50'>":"&nbsp;" %></td></td></tr>
<%
		if (i + 1 == startcount + (totalRecPerTable / 2)) {
%>
	</table></div></td><td width="50%" align="center" valign="top" bgcolor="#E5DFEC"><div><table width="70%">
<%
		}
	}

	if (startcount < count && endcount > count) {
		for (int i = count; i < endcount; i++) {
%>
	<tr><td colspan="3" height="130">&nbsp;</td></tr>
<%
			if (i + 1 == startcount + (totalRecPerTable / 2)) {
%>
	</table></div></td><td width="50%" align="center" valign="top" bgcolor="#E5DFEC"><div><table width="70%">
<%
			}
		}
	}
%>
	</table></div></td>
<%} %>