<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%!
	private ArrayList<ReportableListObject> fetchQueue(String locID) {
		return UtilDBWeb.getReportableList("SELECT PH_TICKET_QUEUE_ID, PH_PRESCRIPTION_DATE, PH_DISPENSING_DATE, PH_CHARGED_DATE, PH_COLLECTION_DATE, TO_CHAR(PH_CREATED_DATE, 'HH24:MI'), TO_CHAR((SYSDATE - PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), DECODE(PH_EST_COMPLETED_DATE, NULL, 'N/A', TO_CHAR((PH_EST_COMPLETED_DATE - PH_CREATED_DATE) * 1440, 'FM99999999999999990.0')), TO_CHAR(TRUNC((SYSDATE - PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((SYSDATE - PH_CREATED_DATE) * 24 * 60 * 60,3600)/60),'FM00') || ':' || TO_CHAR(MOD((SYSDATE - PH_CREATED_DATE) * 24 * 60 * 60,60),'FM00'), TO_CHAR(TRUNC((PH_EST_COMPLETED_DATE - PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((PH_EST_COMPLETED_DATE - PH_CREATED_DATE) * 24 * 60 * 60,3600)/60),'FM00') || ':' || TO_CHAR(MOD((PH_EST_COMPLETED_DATE - PH_CREATED_DATE) * 24 * 60 * 60,60),'FM00') FROM PH_TICKET_QUEUE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_CREATED_DATE > SYSDATE - 1/12 ORDER BY PH_TICKET_QUEUE_ID ASC", new String[] { locID });
	}
%><%

int totalRecPerRow = 5;
int totalRecPerColumn = 5;
String locid = request.getParameter("locid");
boolean isNWStyle = false;
if (locid != null && "NW".equals(locid)) {
//	isNWStyle = true;
} else {
	locid = "OW";
//	isNWStyle = false;
}
String table = request.getParameter("table");
int tableInt = 0;
try {
	tableInt = Integer.parseInt(table);
} catch (Exception e) {}

ArrayList<ReportableListObject> record = fetchQueue(locid);
ReportableListObject row = null;
int count = record.size();
int startcount = tableInt * totalRecPerRow * totalRecPerColumn;
int endcount = (tableInt + 1) * totalRecPerRow * totalRecPerColumn;
String ticketNo = null;
boolean prescriptionFlag = false;
boolean dispensingFlag = false;
boolean chargeFlag = false;
boolean medicationFlag = false;
double timeDiff1 = 0;
double timeDiff2 = 0;
double alertPercentage = 0.7;
boolean emptyAlert = false;

if (count > startcount) { %>
<tr>
	<td width='20%' height='1'></td>
	<td width='20%'></td>
	<td width='20%'></td>
	<td width='20%'></td>
	<td width='20%'></td>
</tr>
<%
	for (int i = startcount; i < count && i < endcount; i++) {
		row = (ReportableListObject) record.get(i);
		ticketNo = row.getValue(0);
		prescriptionFlag = row.getValue(1).length() > 0;
		dispensingFlag = row.getValue(2).length() > 0;
		chargeFlag = row.getValue(3).length() > 0;
		medicationFlag = row.getValue(4).length() > 0;
		if (i % totalRecPerColumn == 0) {
			if (i == startcount) {
%>
<tr>
<%
			} else {
%>
</tr><tr>
<%
			}
		}
		timeDiff1 = -1;
		timeDiff2 = -1;
		try {
			timeDiff1 = Double.parseDouble(row.getValue(6));
		} catch (Exception e) {
			timeDiff1 = -1;
		}
		try {
			timeDiff2 = Double.parseDouble(row.getValue(7));
		} catch (Exception e) {
			timeDiff2 = 10;
		}
		emptyAlert = "::".equals(row.getValue(9));
%>
<td id='<%=ticketNo %>-all' width='20%' height='160' align='center' valign='middle' class='box' onclick="performAction('<%=ticketNo %>');">
	<table width='100%' border='0' cellspacing='0' cellpadding='0'>
		<tr>
			<td width="5%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="5%">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" id='Brown<%=ticketNo %>' <%if (prescriptionFlag) { %>style='background-color:#FCD5B5;KhtmlOpacity=0.9;opacity:0.9;'<%} %>><center><font <%if (prescriptionFlag) { %>color='#FCFCFC' <%} %>SIZE='8'><%if (prescriptionFlag) { %>1<%} else { %>&nbsp;<%} %></font></center></td>
<%	if (isNWStyle) { %>
			<td colspan="2" id='Purple<%=ticketNo %>' <%if (dispensingFlag) { %>style='background-color:#E6B9B8;KhtmlOpacity=0.9;opacity:0.9;'<%} %>><center><font <%if (dispensingFlag) { %>color='#FCFCFC' <%} %>SIZE='8'><%if (dispensingFlag) { %>2<%} else { %>&nbsp;<%} %></font></center></td>
<%	} %>
			<td colspan="2" id='Fuchsia<%=ticketNo %>' <%if (chargeFlag) { %>style='background-color:#B3A2C7;KhtmlOpacity=0.9;opacity:0.9;'<%} %>><center><font <%if (chargeFlag) { %>color='#FCFCFC' <%} %>SIZE='8'><%if (chargeFlag) { %><%if (isNWStyle) { %>3<%} else { %>2<%} %><%} else { %>&nbsp;<%} %></font></center></td>
			<td colspan="2" id='Orange<%=ticketNo %>' <%if (medicationFlag) { %>style='background-color:#6F4084;KhtmlOpacity=0.9;opacity:0.9;'<%} %>><center><font <%if (medicationFlag) { %>color='#FCFCFC' <%} %>SIZE='8'><%if (medicationFlag) { %><%if (isNWStyle) { %>4<%} else { %>3<%} %><%} else { %>&nbsp;<%} %></font></center></td>

			<td colspan="<%=(isNWStyle)?"1":"3" %>"><div align="right"><%=row.getValue(8) %></div></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="11">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
			<td colspan="3"><center><font color='black' SIZE='3'>(<%=row.getValue(5) %>)</font></center></td>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
			<td colspan="3"><center><font color='brown' SIZE='5'><%=ticketNo %></font></center></td>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="11">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="<%=(isNWStyle)?"9":"7" %>">&nbsp;</td>
			<td colspan="<%=(isNWStyle)?"1":"3" %>" style='background-color:<%=medicationFlag?"white":(timeDiff1!=-1&&timeDiff1>timeDiff2?"red":(timeDiff1!=-1&&timeDiff1>timeDiff2*alertPercentage?"yellow":"green")) %>'><div align="right"><font color='<%=medicationFlag?"black":(timeDiff1>timeDiff2?"white":(timeDiff1!=-1&&timeDiff1>timeDiff2*alertPercentage?"black":"white")) %>'><%=emptyAlert?"00:10:00":row.getValue(9) %></font></div></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="11">&nbsp;</td>
		</tr>
	</table>
</td>
<%
	}
%>
</tr>
<%} %>