<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%!
	private ArrayList<ReportableListObject> fetchQueue(String locID) {
		return UtilDBWeb.getReportableList("SELECT PH_TICKET_QUEUE_ID, PH_PRESCRIPTION_DATE, PH_DISPENSING_DATE, PH_CHARGED_DATE, PH_COLLECTION_DATE FROM PH_TICKET_QUEUE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_CREATED_DATE > SYSDATE - 1/12 ORDER BY PH_TICKET_QUEUE_ID ASC", new String[] { locID });
	}
%><%

int totalRecPerTable = 8;
String locid = request.getParameter("locid");
boolean isNWStyle = false;
int collen = 20;
if (locid != null && "NW".equals(locid)) {
//	isNWStyle = true;
//	collen = 15;
} else {
	locid = "OW";
//	isNWStyle = false;
//	collen = 20;
}
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
boolean medicationFlag = false;

if (count > startcount) { %><tr>
<td class='box'><table width='100%' border='0'><tr>
	<td class='box'><table width='100%' border='0'><tr>
	<td width=2% style="border-top: 3px solid #f5b6cd; border-left: 3px solid #f5b6cd" align="right" valign=middle></td>
	<td width=30% style="border-top: 3px solid #f5b6cd" align="center" valign=middle><b><font face="微軟正黑體" size=3>Ticket no.</font></b></td>
	<td width=<%=collen %>% style="border-top: 3px solid #f5b6cd" align="center" valign=middle><b><font face="微軟正黑體" size=3>Prescription Verification</font></b></td>
<%	if (isNWStyle) { %>
	<td width=<%=collen %>% style="border-top: 3px solid #f5b6cd" align="center" valign=middle><b><font face="微軟正黑體" size=3>Dispensing</font></b></td>
<%	} %>
	<td width=<%=collen %>% style="border-top: 3px solid #f5b6cd" align="center" valign=middle><b><font face="微軟正黑體" size=3>Charge Slip Collection</font></b></td>
	<td width=<%=collen %>% style="border-top: 3px solid #f5b6cd" align="center" valign=middle><b><font face="微軟正黑體" size=3>Medication Collection after Payment </font></b></td>
	<td width=2% style="border-top: 3px solid #f5b6cd; border-right: 3px solid #f5b6cd" align="left" valign=middle></td>
</tr>
<tr>
<td style="border-left: 3px solid #f5b6cd" align="right" valign=middle></td>
<td align="center" valign=middle><b><font face="AR PL SungtiL GB" size=5 color="#AA0066">票號</font></b></td>
<td align="center" valign=middle><b><font face="AR PL SungtiL GB" size=5 color="#AA0066">核實處方</font></b></td>
<%	if (isNWStyle) { %>
<td align="center" valign=middle><b><font face="AR PL SungtiL GB" size=5 color="#AA0066">調配藥物</font></b></td>
<%	} %>
<td align="center" valign=middle><b><font face="AR PL SungtiL GB" size=5 color="#AA0066">領取繳費單</font></b></td>
<td align="center" valign=middle><b><font face="AR PL SungtiL GB" size=5 color="#AA0066">繳費後領藥</font></b></td>
<td style="border-right: 3px solid #f5b6cd" align="left" valign=middle></td>
</tr>
<tr>
<td style="border-left: 3px solid #f5b6cd" align="right" valign=middle></td>
<td></td>
<td align="center" valign=middle bgcolor="#AA0066"><b><font face="AR PL SungtiL GB" size=5 color="#FFFFFF">1</font></b></td>
<td align="center" valign=middle bgcolor="#AA0066"><b><font face="AR PL SungtiL GB" size=5 color="#FFFFFF">2</font></b></td>
<td align="center" valign=middle bgcolor="#AA0066"><b><font face="AR PL SungtiL GB" size=5 color="#FFFFFF">3</font></b></td>
<%	if (isNWStyle) { %>
<td align="center" valign=middle bgcolor="#AA0066"><b><font face="AR PL SungtiL GB" size=5 color="#FFFFFF">4</font></b></td>
<%	} %>
<td style="border-right: 3px solid #f5b6cd" align="left" valign=middle></td>
</tr>
</table></td></tr>
<%
	for (int i = startcount; i < count && i < endcount; i++) {
		row = (ReportableListObject) record.get(i);
		ticketNo = row.getValue(0);
		prescriptionFlag = row.getValue(1).length() > 0;
		dispensingFlag = row.getValue(2).length() > 0;
		chargeFlag = row.getValue(3).length() > 0;
		medicationFlag = row.getValue(4).length() > 0;
%>
<tr>
<td class='box'><table width='100%' border='0'><tr>
<td width=2% style="border-left: 3px solid #f5b6cd" align="right" valign=middle></td>
<td width=30% align='center' valign=middle id='<%=ticketNo %>' align='center' valign='middle'><div><font face='微軟正黑體' color='Black' SIZE='8'><%=ticketNo %></font></div></td>
<td width=<%=collen %>% align='center' valign=middle id='Brown<%=ticketNo %>' <%if (prescriptionFlag) { %>style='background-color:#FCD5B5;KhtmlOpacity=0.9;opacity:0.9;'<%} %>>&nbsp;</td>
<%	if (isNWStyle) { %>
<td width=<%=collen %>% align='center' valign=middle id='Green<%=ticketNo %>' <%if (dispensingFlag) { %>style='background-color:#E6B9B8;KhtmlOpacity=0.9;opacity:0.9;'<%} %>>&nbsp;</td>
<%	} %>
<td width=<%=collen %>% align='center' valign=middle id='Fuchsia<%=ticketNo %>' <%if (chargeFlag) { %>style='background-color:#B3A2C7;KhtmlOpacity=0.9;opacity:0.9;'<%} %>>&nbsp;</td>
<td width=<%=collen %>% align='center' <%if (medicationFlag) { %>class="blink" <%} %>valign=middle id='Orange<%=ticketNo %>' <%if (medicationFlag) { %>style='background-color:#6F4084;KhtmlOpacity=0.9;opacity:0.9;'<%} %>><%if (medicationFlag) { %><img src="../images/tick_amber_small.gif"><%} %></td>
<td width=2% style="border-right: 3px solid #f5b6cd" align="left" valign=middle></td>
</tr>
</table></td></tr>
<%
	}
%>
<tr>
<td class='box'><table width='100%' border='0'><tr>
<td style="border-bottom: 3px solid #f5b6cd; border-left: 3px solid #f5b6cd" align="left" valign=middle><font face="微軟正黑體" color="#000000"><br></font></td>
<td style="border-bottom: 3px solid #f5b6cd" align="left" valign=middle><font face="Wingdings" color="#000000"><br></font></td>
<td style="border-bottom: 3px solid #f5b6cd; border-right: 3px solid #f5b6cd" align="left" valign=middle><font face="微軟正黑體" color="#000000"><br></font></td>
</table></td></tr>
</tr>
<%} %>