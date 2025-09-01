<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%!
	private ArrayList<ReportableListObject> fetchQueue(boolean filter) {
		// show 4 hours
		if (filter) {
			return UtilDBWeb.getReportableList("SELECT Q.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID, TO_CHAR(Q.PH_PRESCRIPTION_DATE, 'HH24:MI'), TO_CHAR(Q.PH_DISPENSING_DATE, 'HH24:MI'), TO_CHAR(Q.PH_CHARGED_DATE, 'HH24:MI'), TO_CHAR(Q.PH_COLLECTION_DATE, 'HH24:MI'), TO_CHAR(Q.PH_CREATED_DATE, 'HH24:MI'), TO_CHAR((SYSDATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), DECODE(Q.PH_EST_COMPLETED_DATE, NULL, 'N/A', TO_CHAR((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0')), TO_CHAR(TRUNC((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60, 3600)/60),'FM00'), TO_CHAR(TRUNC((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60,3600)/60),'FM00') FROM PH_TICKET_QUEUE Q INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID AND L.PH_LOC_TYPE = 'I' WHERE Q.PH_STATUS != -1 AND Q.PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND Q.PH_DISPENSING_DATE IS NULL AND Q.PH_CHARGED_DATE IS NULL AND Q.PH_COLLECTION_DATE IS NULL ORDER BY Q.PH_CREATED_DATE ASC, Q.PH_TICKET_QUEUE_ID ASC");
		} else {
			return UtilDBWeb.getReportableList("SELECT Q.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID, TO_CHAR(Q.PH_PRESCRIPTION_DATE, 'HH24:MI'), TO_CHAR(Q.PH_DISPENSING_DATE, 'HH24:MI'), TO_CHAR(Q.PH_CHARGED_DATE, 'HH24:MI'), TO_CHAR(Q.PH_COLLECTION_DATE, 'HH24:MI'), TO_CHAR(Q.PH_CREATED_DATE, 'HH24:MI'), TO_CHAR((SYSDATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), DECODE(Q.PH_EST_COMPLETED_DATE, NULL, 'N/A', TO_CHAR((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0')), TO_CHAR(TRUNC((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60, 3600)/60),'FM00'), TO_CHAR(TRUNC((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60,3600)/60),'FM00') FROM PH_TICKET_QUEUE Q INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID AND L.PH_LOC_TYPE = 'I' WHERE Q.PH_STATUS != -1 AND Q.PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND (Q.PH_CHARGED_DATE IS NULL OR Q.PH_CHARGED_DATE > SYSDATE - 1/144) ORDER BY Q.PH_CREATED_DATE ASC, Q.PH_TICKET_QUEUE_ID ASC");
		}
	}
%><%

int totalRecPerRow = 4;
int totalRecPerColumn = 6;

String table = request.getParameter("table");
boolean filter = "Y".equals(request.getParameter("filter"));
boolean resize = "Y".equals(request.getParameter("resize"));
if (resize) {
	totalRecPerRow = 6;
	totalRecPerColumn = 8;
}
int tableInt = 0;
try {
	tableInt = Integer.parseInt(table);
} catch (Exception e) {}

ArrayList<ReportableListObject> record = fetchQueue(filter);
ReportableListObject row = null;
int count = record.size();
int startcount = tableInt * totalRecPerRow * totalRecPerColumn;
int endcount = (tableInt + 1) * totalRecPerRow * totalRecPerColumn;
String locID = null;
String ticketDate = null;
String ticketNo = null;
boolean faxedFlag = false;
boolean pickupFlag = false;
boolean ackFlag = false;
boolean naFlag = false;
double timeDiff1 = 0;
double timeDiff2 = 60;
double timeDiff3 = 120;
//double alertPercentage = 0.7;
boolean emptyAlert = false;
String bgcolor = null;
String alertBgColor = null;
String alertFgColor = null;
String lastUpdateTime = null;

if (count > startcount) {
	%><tr><%
	for (int i = 0; i < totalRecPerColumn; i++ ) {
		if (i == 0) {
			%><td width='<%=100/totalRecPerColumn %>%' height='1'></td><%
		} else {
			%><td width='<%=100/totalRecPerColumn %>%'></td><%
		}
	}
	%></tr><%
	for (int i = startcount; i < count && i < endcount; i++) {
		row = (ReportableListObject) record.get(i);
		locID = row.getValue(0);
		ticketDate = row.getValue(1);
		ticketNo = row.getValue(2);
		faxedFlag = row.getValue(3).length() > 0;
		pickupFlag = row.getValue(4).length() > 0;
		ackFlag = row.getValue(5).length() > 0;
		naFlag = row.getValue(6).length() > 0;
		if (i % totalRecPerColumn == 0) {
			if (i == startcount) {
				%><tr><%
			} else {
				%></tr><tr><%
			}
		}
		timeDiff1 = -1;
//		timeDiff2 = -1;
		try {
			timeDiff1 = Double.parseDouble(row.getValue(8));
		} catch (Exception e) {
			timeDiff1 = -1;
		}
//		try {
//			timeDiff2 = Double.parseDouble(row.getValue(9));
//		} catch (Exception e) {
//			timeDiff2 = 10;
//		}
		emptyAlert = "::".equals(row.getValue(11));

		if (ackFlag) {
			bgcolor = "rgb(198,217,241)";
			lastUpdateTime = row.getValue(5);
		} else if (pickupFlag) {
			bgcolor = "rgb(214,227,188)";
			lastUpdateTime = row.getValue(4);
		} else if (faxedFlag) {
			bgcolor = "rgb(242,219,219)";
			lastUpdateTime = row.getValue(3);
		} else {
			bgcolor = "white";
			lastUpdateTime = "";
		}

		if (naFlag) {
			lastUpdateTime = "NA";
		}

		if (ackFlag) {
			alertBgColor = "rgb(198,217,241)";
			alertFgColor = "gray";
//		} else if (timeDiff1 != -1 && timeDiff1 > timeDiff2) {
		} else if (timeDiff1 != -1 && timeDiff1 > timeDiff3) {
			alertBgColor = "red";
			alertFgColor = "white";
//		} else if (timeDiff1 != -1 && timeDiff1 > timeDiff2 * alertPercentage) {
		} else if (timeDiff1 != -1 && timeDiff1 > timeDiff2) {
			alertBgColor = "yellow";
			alertFgColor = "black";
		} else {
			alertBgColor = "green";
			alertFgColor = "white";
		}
%>
<td class='box' style='background-color:<%=bgcolor %>' id='<%=ticketNo %>-all' width='<%=100/totalRecPerColumn %>%' height='160' align='center' valign='middle' class='box' onclick="performAction('<%=locID %>-<%=ticketNo.substring(4) %>', '<%=ticketNo %>');">
	<table width='100%' border='0' cellspacing='0' cellpadding='0'>
		<tr>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="10"><center><font color='<%=ackFlag?"gray":"brown" %>'<%=ackFlag?"style='text-decoration:line-through'":"" %> SIZE='8'><%=locID %>-<%=ticketNo.substring(4) %></font></center></td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
			<td colspan="2" rowspan="3"><%=naFlag?"<font color='" + (ackFlag?"gray' style='text-decoration:line-through":"black") + "' SIZE='6'>" + lastUpdateTime + "</font>":"&nbsp;" %></td>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="3"><font color='<%=ackFlag?"gray":"black" %>'<%=ackFlag?"style='text-decoration:line-through'":"" %> SIZE='5'><%=row.getValue(7) %></font></td>
			<td colspan="3"><font color='<%=ackFlag?"gray":"black" %>'<%=ackFlag?"style='text-decoration:line-through'":"" %> SIZE='5'><%=naFlag?"":lastUpdateTime %></font></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="8" style='background-color:<%=alertBgColor %>'><font color='<%=alertFgColor %>'<%=ackFlag?"style='text-decoration:line-through'":"" %> SIZE='5'><%=row.getValue(10) %><!--/<%=emptyAlert?"00:10:00":row.getValue(11) %>--></font></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>
	</table>
</td>
<%
	}
%>
</tr>
<tr>
	<td style='background-color:rgb(255,255,204);text-align:center;' colspan='<%=totalRecPerColumn %>'><font color='black' SIZE='3'>Total Number in Queue: <%=count %></font></td>
</tr>
<%} %>