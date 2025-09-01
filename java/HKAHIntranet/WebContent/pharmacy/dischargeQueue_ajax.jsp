<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%!
	private ArrayList<ReportableListObject> fetchQueue(boolean filter) {
		StringBuffer strbuf = new StringBuffer();

		strbuf.append("SELECT Q.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID, TO_CHAR(Q.PH_PRESCRIPTION_DATE, 'HH24:MI'), TO_CHAR(Q.PH_DISPENSING_DATE, 'HH24:MI'), TO_CHAR(Q.PH_CHARGED_DATE, 'HH24:MI'), "); // 0, 1, 2, 3, 4, 5
		strbuf.append("       TO_CHAR(Q.PH_COLLECTION_DATE, 'HH24:MI'), TO_CHAR(Q.PH_CREATED_DATE, 'HH24:MI'), TO_CHAR((SYSDATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 6, 7, 8
		strbuf.append("       DECODE(Q.PH_EST_COMPLETED_DATE, NULL, 'N/A', TO_CHAR((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0')), "); // 9
		strbuf.append("       TO_CHAR(TRUNC((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60, 3600)/60),'FM00'), "); // 10
		strbuf.append("       TO_CHAR(TRUNC((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60, 3600) / 60),'FM00'), "); // 11
		strbuf.append("       Q.PH_PATNO, P.PATFNAME || ' ' || P.PATGNAME, I.BEDCODE, Q.PH_STATUS, Q.PH_REMARK "); // 12, 13, 14, 15, 16
		strbuf.append("FROM PH_TICKET_QUEUE Q ");
		strbuf.append("INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID AND L.PH_LOC_TYPE = 'D' ");
		strbuf.append("LEFT JOIN PATIENT@IWEB P ON Q.PH_PATNO = P.PATNO ");
		strbuf.append("LEFT JOIN REG@IWEB R ON Q.PH_REGID = R.REGID ");
		strbuf.append("LEFT JOIN INPAT@IWEB I ON R.INPID = I.INPID ");
		strbuf.append("WHERE Q.PH_STATUS != -1 ");
		strbuf.append("AND Q.PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') ");

		// show 4 hours
		if (filter) {
			strbuf.append("AND Q.PH_DISPENSING_DATE IS NULL AND Q.PH_CHARGED_DATE IS NULL AND Q.PH_COLLECTION_DATE IS NULL ");
		} else {
			strbuf.append("AND (Q.PH_COLLECTION_DATE IS NULL OR Q.PH_COLLECTION_DATE > SYSDATE - 3/1440) "); // 3 minute
		}
		strbuf.append("ORDER BY Q.PH_CREATED_DATE ASC, Q.PH_TICKET_QUEUE_ID ASC ");

		return UtilDBWeb.getReportableList(strbuf.toString());
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
String patNo = null;
String patName = null;
String bedCode = null;
boolean faxedFlag = false;
boolean pickupFlag = false;
boolean ackFlag = false;
boolean naFlag = false;
boolean isOnHold = false;
String remark = null;
double timeDiff1 = 0;
double timeDiff2 = 20;
double timeDiff3 = 60;
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
		patNo = row.getValue(12);
		patName = row.getValue(13);
		bedCode = row.getValue(14);
		isOnHold = "999".equals(row.getValue(15));
		remark = row.getValue(16);

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

		if (naFlag) {
			bgcolor = "rgb(198,217,241)";
			lastUpdateTime = row.getValue(6);
		} else if (ackFlag) {
			bgcolor = "rgb(177,217,088)";
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

		if (timeDiff1 != -1 && timeDiff1 > timeDiff3) {
			alertBgColor = "red";
			alertFgColor = "white";
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
			<td colspan="10"><center><font color='brown' SIZE='8'><%=locID %>-<%=ticketNo.substring(4) %></font></center></td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
			<td colspan="2" rowspan="3"><%=naFlag?"<font color='black' SIZE='6'>" + lastUpdateTime + "</font>":"&nbsp;" %></td>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="3"><font color='black' SIZE='5'><%=row.getValue(7) %></font></td>
			<td colspan="3"><font color='black' SIZE='5'><%=naFlag?"":lastUpdateTime %></font></td>
			<td>&nbsp;</td>
		</tr>
		<tr>

			<td colspan="4">&nbsp;</td>
			<td colspan="4"><center><font color='red' SIZE='5'><%=isOnHold?"On-Hold":"&nbsp;" %></font></center></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2"><%=(patNo!=null&&patNo.length()>0)?"PATNO":"" %></td>
			<td>&nbsp;</td>
			<td colspan="5"><font color='black' SIZE='3'><%=patNo==null?"":patNo %></font></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2"><%=(patName!=null&&patName.trim().length()>0)?"NAME":"" %></td>
			<td>&nbsp;</td>
			<td colspan="6"><font color='black' SIZE='3'><%=patName==null?"":(patName.length() > 20?patName.substring(0, 20):patName) %></font></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2"><%=(bedCode!=null&&bedCode.length()>0)?"BEDCODE":"" %></td>
			<td>&nbsp;</td>
			<td colspan="5"><font color='black' SIZE='3'><%=bedCode==null?"":bedCode %></font></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="8"><%=remark==null || remark.length()==0?"&nbsp;":"REMARK: <font color='red' SIZE='5'>" + remark + "</font>" %></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="8" style='background-color:<%=alertBgColor %>'><font color='<%=alertFgColor %>' SIZE='5'><%=row.getValue(10) %><!--/<%=emptyAlert?"00:10:00":row.getValue(11) %>--></font></td>
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