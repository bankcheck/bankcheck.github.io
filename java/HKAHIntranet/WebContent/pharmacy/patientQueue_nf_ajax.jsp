<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%!
	private ArrayList<ReportableListObject> fetchQueue(String locID) {
		StringBuffer strbuf = new StringBuffer();

		strbuf.append("SELECT Q.PH_TICKET_QUEUE_ID, Q.PH_PRESCRIPTION_DATE, Q.PH_DISPENSING_DATE, Q.PH_CHARGED_DATE, Q.PH_COLLECTION_DATE, ");
		strbuf.append("       TO_CHAR(Q.PH_CREATED_DATE, 'HH24:MI'), TO_CHAR((SYSDATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		strbuf.append("       DECODE(Q.PH_EST_COMPLETED_DATE, NULL, 'N/A', TO_CHAR((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0')), ");
		strbuf.append("       TO_CHAR(TRUNC((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60,3600)/60),'FM00') || ':' || TO_CHAR(MOD((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60,60),'FM00'), TO_CHAR(TRUNC((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60,3600)/60),'FM00') || ':' || TO_CHAR(MOD((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60,60),'FM00'), ");
		strbuf.append("       Q.PH_PATNO, P.PATFNAME || ' ' || P.PATGNAME ");
		strbuf.append("FROM PH_TICKET_QUEUE Q ");
		strbuf.append("LEFT JOIN PATIENT@IWEB P ON Q.PH_PATNO = P.PATNO ");
		strbuf.append("WHERE Q.PH_LOC_ID = ? ");
		strbuf.append("AND   Q.PH_STATUS = 1 ");
		strbuf.append("AND   Q.PH_CREATED_DATE > SYSDATE - 1/12 ");
		strbuf.append("ORDER BY Q.PH_TICKET_QUEUE_ID ASC");

		return UtilDBWeb.getReportableList(strbuf.toString(), new String[] { locID });
	}

	private ArrayList<ReportableListObject> fetchQueuePBO(String locID) {
		StringBuffer strbuf = new StringBuffer();

		strbuf.append("SELECT Q.PH_TICKET_QUEUE_ID, Q.PH_PRESCRIPTION_DATE, Q.PH_DISPENSING_DATE, Q.PH_CHARGED_DATE, Q.PH_COLLECTION_DATE, ");
		strbuf.append("       TO_CHAR(Q.PH_CREATED_DATE, 'HH24:MI'), TO_CHAR((SYSDATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		strbuf.append("       DECODE(Q.PH_EST_COMPLETED_DATE, NULL, 'N/A', TO_CHAR((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0')), ");
		strbuf.append("       TO_CHAR(TRUNC((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60,3600)/60),'FM00') || ':' || TO_CHAR(MOD((SYSDATE - Q.PH_CREATED_DATE) * 24 * 60 * 60,60),'FM00'), TO_CHAR(TRUNC((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60,3600)/60),'FM00') || ':' || TO_CHAR(MOD((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 24 * 60 * 60,60),'FM00'), ");
		strbuf.append("       Q.PH_PATNO, P.PATFNAME || ' ' || P.PATGNAME ");
		strbuf.append("FROM PH_TICKET_QUEUE Q ");
		strbuf.append("LEFT JOIN PATIENT@IWEB P ON Q.PH_PATNO = P.PATNO ");
		strbuf.append("WHERE Q.PH_LOC_ID = ? ");
		strbuf.append("AND   Q.PH_STATUS = 1 ");
		strbuf.append("AND   Q.PH_PRESCRIPTION_DATE IS NOT NULL ");
		strbuf.append("AND   Q.PH_CHARGED_DATE IS NULL ");
		strbuf.append("AND   Q.PH_CREATED_DATE > SYSDATE - 1/12 ");
		strbuf.append("ORDER BY Q.PH_TICKET_QUEUE_ID ASC");

		return UtilDBWeb.getReportableList(strbuf.toString(), new String[] { locID });
	}
%><%

int totalRecPerRow = 5;
int totalRecPerColumn = 6;
String locid = request.getParameter("locid");
if (locid == null) {
	locid = "OW";
}
String table = request.getParameter("table");
int tableInt = 0;
try {
	tableInt = Integer.parseInt(table);
} catch (Exception e) {}
boolean isPBO = "Y".equals(request.getParameter("isPBO"));
boolean showPatInfo = "Y".equals(request.getParameter("showPatInfo"));

ArrayList<ReportableListObject> record = null;
if (isPBO) {
	record = fetchQueuePBO(locid);
} else {
	record = fetchQueue(locid);
}
ReportableListObject row = null;
int count = record.size();
int startcount = tableInt * totalRecPerRow * totalRecPerColumn;
int endcount = (tableInt + 1) * totalRecPerRow * totalRecPerColumn;
String ticketNo = null;
String patNo = null;
String patName = null;
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
<%
	for (int i = 0; i < totalRecPerColumn; i++) {
%>
	<td width='<%=100/totalRecPerColumn %>%' height='1'></td>
<%
	}
%>
</tr>
<%
	for (int i = startcount; i < count && i < endcount; i++) {
		row = (ReportableListObject) record.get(i);
		ticketNo = row.getValue(0);
		patNo = row.getValue(10);
		patName = row.getValue(11);
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
<td id='<%=ticketNo %>-all' width='<%=100/totalRecPerColumn %>%' height='160' align='center' valign='middle' class='box' onclick="performAction('<%=ticketNo %>');">
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
<%	if (isPBO) { %>
			<td colspan="6" id='Fuchsia<%=ticketNo %>' <%if (dispensingFlag) { %>style='background-color:#5F497A;KhtmlOpacity=0.9;opacity:0.9;'<%} %>><center><font <%if (dispensingFlag) { %>color='#FCFCFC' <%} %>SIZE='8'><%if (dispensingFlag) { %>Ready<%} else { %>&nbsp;<%} %></font></center></td>
<%	} else { %>
			<td colspan="2" id='Brown<%=ticketNo %>' <%if (prescriptionFlag) { %>style='background-color:#5F497A;KhtmlOpacity=0.9;opacity:0.9;'<%} %>><center><font <%if (prescriptionFlag) { %>color='#FCFCFC' <%} %>SIZE='8'><%if (prescriptionFlag) { %>1<%} else { %>&nbsp;<%} %></font></center></td>
			<td colspan="2" id='Fuchsia<%=ticketNo %>' <%if (chargeFlag) { %>style='background-color:#FCD5B5;KhtmlOpacity=0.9;opacity:0.9;'<%} %>><center><font <%if (chargeFlag) { %>color='#FCFCFC' <%} %>SIZE='8'><%if (chargeFlag) { %>2<%} else { %>&nbsp;<%} %></font></center></td>
			<td colspan="2" id='Orange<%=ticketNo %>' <%if (medicationFlag) { %>style='background-color:#76923C;KhtmlOpacity=0.9;opacity:0.9;'<%} %>><center><font <%if (medicationFlag) { %>color='#FCFCFC' <%} %>SIZE='8'><%if (medicationFlag) { %>3<%} else { %>&nbsp;<%} %></font></center></td>
<%	} %>
			<td colspan="3"><div align="right"><%=row.getValue(8) %></div></td>
			<td>&nbsp;</td>
		</tr>
<%	if (showPatInfo) { %>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2"><%=(patNo!=null&&patNo.length()>0)?"PATNO":"" %></td>
			<td>&nbsp;</td>
			<td colspan="6"><font color='black' SIZE='3'><%=patNo==null?"":patNo %></font></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2"><%=(patName!=null&&patName.trim().length()>0)?"NAME":"" %></td>
			<td>&nbsp;</td>
			<td colspan="6"><font color='black' SIZE='3'><%=patName==null?"":(patName.length() > 20?patName.substring(0, 20):patName) %></font></td>
			<td>&nbsp;</td>
		</tr>
<%	} else { %>
		<tr>
			<td colspan="11">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="11">&nbsp;</td>
		</tr>
<%	} %>
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
			<td colspan="7">&nbsp;</td>
			<td colspan="3" style='background-color:<%=medicationFlag?"white":(timeDiff1!=-1&&timeDiff1>timeDiff2?"red":(timeDiff1!=-1&&timeDiff1>timeDiff2*alertPercentage?"yellow":"green")) %>'><div align="right"><font color='<%=medicationFlag?"black":(timeDiff1>timeDiff2?"white":(timeDiff1!=-1&&timeDiff1>timeDiff2*alertPercentage?"black":"white")) %>'><%=emptyAlert?"00:10:00":row.getValue(9) %></font></div></td>
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