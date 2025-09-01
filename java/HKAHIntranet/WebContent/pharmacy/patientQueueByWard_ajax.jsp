<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%!
	private ArrayList<ReportableListObject> fetchQueue(String locID) {
		// show 4 hours
		return UtilDBWeb.getReportableList("SELECT PH_TICKET_DT, PH_TICKET_QUEUE_ID, TO_CHAR(PH_PRESCRIPTION_DATE, 'HH24:MI'), TO_CHAR(PH_DISPENSING_DATE, 'HH24:MI'), TO_CHAR(PH_CHARGED_DATE, 'HH24:MI'), TO_CHAR(PH_COLLECTION_DATE, 'HH24:MI'), TO_CHAR(PH_CREATED_DATE, 'HH24:MI'), TO_CHAR((SYSDATE - PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), DECODE(PH_EST_COMPLETED_DATE, NULL, 'N/A', TO_CHAR((PH_EST_COMPLETED_DATE - PH_CREATED_DATE) * 1440, 'FM99999999999999990.0')), TO_CHAR(TRUNC((SYSDATE - PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((SYSDATE - PH_CREATED_DATE) * 24 * 60 * 60,3600)/60),'FM00') || ':' || TO_CHAR(MOD((SYSDATE - PH_CREATED_DATE) * 24 * 60 * 60,60),'FM00'), TO_CHAR(TRUNC((PH_EST_COMPLETED_DATE - PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((PH_EST_COMPLETED_DATE - PH_CREATED_DATE) * 24 * 60 * 60,3600)/60),'FM00') || ':' || TO_CHAR(MOD((PH_EST_COMPLETED_DATE - PH_CREATED_DATE) * 24 * 60 * 60,60),'FM00'), TO_CHAR(PH_COMPLETED_DATE, 'HH24:MI') FROM PH_TICKET_QUEUE WHERE PH_LOC_ID = ? AND PH_STATUS != -1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND (PH_CHARGED_DATE IS NULL OR PH_CHARGED_DATE > SYSDATE - 1/144) ORDER BY PH_TICKET_QUEUE_ID ASC", new String[] { locID });
	}

	private ArrayList<ReportableListObject> fetchFullQueue() {
		// show 4 hours
		return UtilDBWeb.getReportableList("SELECT 1 FROM PH_TICKET_QUEUE Q INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID AND L.PH_LOC_TYPE = 'I' WHERE Q.PH_STATUS != -1 AND Q.PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND (Q.PH_CHARGED_DATE IS NULL OR Q.PH_CHARGED_DATE > SYSDATE - 1/144) ORDER BY Q.PH_CREATED_DATE ASC, Q.PH_TICKET_QUEUE_ID ASC");
	}
%><%
int totalRecPerRow = 2;
int totalRecPerColumn = 8;
String locid = request.getParameter("locid");
String table = request.getParameter("table");
int tableInt = 0;
try {
	tableInt = Integer.parseInt(table);
} catch (Exception e) {}

ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
record = fetchFullQueue();
int count_full = record.size();
record = fetchQueue(locid);
int count = record.size();
int startcount = tableInt * totalRecPerRow * totalRecPerColumn;
int endcount = (tableInt + 1) * totalRecPerRow * totalRecPerColumn;
String ticketDt = null;
String ticketNo = null;
boolean faxedFlag = false;
boolean pickupFlag = false;
boolean ackFlag = false;
boolean naFlag = false;
double timeDiff1 = 0;
double timeDiff2 = 0;
double alertPercentage = 0.7;
boolean emptyAlert = false;

if (count > startcount) { %>
<tr>
<%
	for (int i = 0; i < totalRecPerRow; i++) {
%>
	<th width='19%'>Ticket Number</th>
	<!--th width='10%'>Time Generated</th-->
	<th width='10%'>Fax Received</th>
	<th width='10%'>Ready for Pick Up</th>
	<th width='10%'>Nurse Acknowledged</th>
<%
	}
%>
</tr>
<%
	int current = 0;
	for (int i = 0; i < totalRecPerColumn; i++) {
		for (int j = 0; j < totalRecPerRow; j++) {
			if (j == 0) {
				%><tr><%
			}
			current = startcount + i + j * totalRecPerColumn;
			if (startcount > current || current > endcount || current >= count ) {

			} else {
				row = (ReportableListObject) record.get(current);
				ticketDt = row.getValue(0);
				ticketNo = row.getValue(1);
				faxedFlag = row.getValue(2).length() > 0;
				pickupFlag = row.getValue(3).length() > 0;
				ackFlag = row.getValue(4).length() > 0;
				naFlag = row.getValue(5).length() > 0;
				timeDiff1 = -1;
				timeDiff2 = -1;
				try {
					timeDiff1 = Double.parseDouble(row.getValue(7));
				} catch (Exception e) {
					timeDiff1 = -1;
				}
				try {
					timeDiff2 = Double.parseDouble(row.getValue(8));
				} catch (Exception e) {
					timeDiff2 = 10;
				}
				emptyAlert = "::".equals(row.getValue(10));
%>
	<td class='box' onclick="performAction('<%=ticketDt %>', '<%=ticketNo %>');" id='<%=ticketNo %>-all'>
		<font color='<%=ackFlag?"gray":"brown" %>' SIZE='6' style='<%=ackFlag?"text-decoration:line-through":"" %>'><%=locid %>-<%=ticketNo.substring(4) %></font>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<font style='text-align:right' color='<%=ackFlag?"gray":"black" %>' SIZE='3'><%=row.getValue(6) %></font>
	</td>
<!--
	<td class='box' style='background-color:<%=ackFlag?"rgb(198,217,241)":pickupFlag?"white":(timeDiff1!=-1&&timeDiff1>timeDiff2?"red":(timeDiff1!=-1&&timeDiff1>timeDiff2*alertPercentage?"yellow":"rgb(252,253,218)")) %>'>
		<font color='<%=ackFlag?"gray":pickupFlag?"black":(timeDiff1>timeDiff2?"white":(timeDiff1!=-1&&timeDiff1>timeDiff2*alertPercentage?"black":"black")) %>'>
			<%if (!ackFlag) { %><%=row.getValue(9) %>/<%=emptyAlert?"00:10:00":row.getValue(10) %><%} %>
		</font>
	</td>
-->
	<td class='box' <%if (faxedFlag) { %>style='background-color:rgb(242,219,219);text-align:center;'<%} /* Fax Received */ %>><%if (!pickupFlag && !ackFlag) { %><%=row.getValue(2).length()>0?"("+row.getValue(2)+")":"" %><%} %></td>
	<td class='box' <%if (pickupFlag || naFlag) { %>style='background-color:rgb(214,227,188);text-align:center;'<%} /* Ready for Pick up */ %>><%if (!ackFlag) { %><%=naFlag?"<font SIZE='5'>N/A</font> - " + (row.getValue(5).length()>0?"("+row.getValue(5)+")":""):(row.getValue(3).length()>0?"("+row.getValue(3)+")":"") %><%} %></td>
	<td class='box' <%if (ackFlag) { %>style='background-color:rgb(198,217,241);text-align:center;'<%} /* Nurse Acknowledged */ %>><%=ackFlag && naFlag?"<font color='grey' SIZE='5'>N/A</font> - ":"" %><font color='grey' SIZE='3'><%=row.getValue(4).length()>0?"("+row.getValue(4)+")":"" %></font></td>
<%
			}
			if (j == totalRecPerRow - 1) {
				%></tr><%
			}
		}
	}
%>
<tr>
	<td style='background-color:rgb(255,255,204);text-align:center;' colspan='<%=totalRecPerRow * totalRecPerColumn %>'><font color='black' SIZE='3'>Total Number in Queue: <%=count %> (<%=locid %> Only) / <%=count_full %> (All Wards)</font></td>
</tr>
<%
}
%>