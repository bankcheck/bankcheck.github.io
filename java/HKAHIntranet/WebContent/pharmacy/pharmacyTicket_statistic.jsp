<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
public ArrayList getMonthTicketTotal(String dayStartDate, String dayEndDate) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT TO_CHAR(Q.PH_CREATED_DATE, 'dd'), DECODE(L.PH_LOC_TYPE, 'I', 'IP', L.PH_LOC_ID), COUNT(1) ");
	sqlStr.append("FROM   PH_TICKET_QUEUE Q ");
	sqlStr.append("INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID ");
	sqlStr.append("WHERE  Q.PH_CREATED_DATE >= TO_DATE('");
	sqlStr.append(dayStartDate);
	sqlStr.append(" 00:00:00', 'dd/MM/yyyy hh24:mi:ss') ");
	sqlStr.append("AND    Q.PH_CREATED_DATE <= TO_DATE('");
	sqlStr.append(dayEndDate);
	sqlStr.append(" 23:59:59', 'dd/MM/yyyy hh24:mi:ss') ");
	sqlStr.append("GROUP BY TO_CHAR(Q.PH_CREATED_DATE, 'dd'), DECODE(L.PH_LOC_TYPE, 'I', 'IP', L.PH_LOC_ID) ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public ArrayList getMonthRecordTotal(String dayStartDate, String dayEndDate, int categoryTimeZone) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT TO_CHAR(Q.PH_CREATED_DATE, 'dd'), DECODE(L.PH_LOC_TYPE, 'I', 'IP', L.PH_LOC_ID), ");
	sqlStr.append("TO_CHAR(AVG(Q.PH_PRESCRIPTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
	sqlStr.append("TO_CHAR(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Q.PH_PRESCRIPTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
	sqlStr.append("TO_CHAR(AVG(Q.PH_DISPENSING_DATE - Q.PH_PRESCRIPTION_DATE) * 1440, 'FM99999999999999990.0'), ");
	sqlStr.append("TO_CHAR(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Q.PH_DISPENSING_DATE - Q.PH_PRESCRIPTION_DATE) * 1440, 'FM99999999999999990.0'), ");
	sqlStr.append("TO_CHAR(AVG(Q.PH_DISPENSING_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
	sqlStr.append("TO_CHAR(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Q.PH_DISPENSING_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0') ");
	sqlStr.append("FROM   PH_TICKET_QUEUE Q ");
	sqlStr.append("INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID ");
	sqlStr.append("WHERE  Q.PH_CREATED_DATE >= TO_DATE('");
	sqlStr.append(dayStartDate);
	sqlStr.append(" 00:00:00', 'dd/MM/yyyy hh24:mi:ss') ");
	sqlStr.append("AND    Q.PH_CREATED_DATE <= TO_DATE('");
	sqlStr.append(dayEndDate);
	sqlStr.append(" 23:59:59', 'dd/MM/yyyy hh24:mi:ss') ");
	if (categoryTimeZone == 0) {
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24') >= '00' ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24') <= '08' ");
	} else if (categoryTimeZone == 1) {
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24') >= '09' ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24') <= '13' ");
	} else if (categoryTimeZone == 2) {
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24') >= '14' ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24') <= '17' ");
	} else if (categoryTimeZone == 3) {
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24') >= '18' ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24') <= '23' ");
	}
	sqlStr.append("GROUP BY TO_CHAR(Q.PH_CREATED_DATE, 'dd'), DECODE(L.PH_LOC_TYPE, 'I', 'IP', L.PH_LOC_ID) ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public String getTable(
		ArrayList monthRecordTotal,
		int categoryString, int maxDaysInMonth, boolean isTicket) {

	StringBuffer sqlStr = new StringBuffer();

	String dayofMonth = null;
	for (int i = 1; i<= maxDaysInMonth; i++) {
		if (i < 10) {
			dayofMonth = "0" + String.valueOf(i);
		} else {
			dayofMonth = String.valueOf(i);
		}

		sqlStr.append("<td style='text-align:center;' valign='top'>");

		sqlStr.append(getCount(monthRecordTotal, categoryString, dayofMonth, isTicket));

		sqlStr.append("</td>");
	}
	return sqlStr.toString();
}

public String getCount(ArrayList monthRecordTotal, int categoryString, String dayofMonth, boolean isTicket) {
	String count = "\\";
	try {
		String arraylistDayOfMonth = null;
		String loc = null;
		if (categoryString == 0 || categoryString == 1) {
			loc = "OW";
		} else if (categoryString == 2 || categoryString == 3) {
			loc = "NW";
		} else if (categoryString == 4 || categoryString == 5) {
			loc = "IP";
		} else if (categoryString == 6 || categoryString == 7) {
			loc = "DIS";
		}
		String arraylistLoc = null;
		ReportableListObject arraylistRecord = null;
		for (int i = 0; i < monthRecordTotal.size(); i++) {
			arraylistRecord = (ReportableListObject) monthRecordTotal.get(i);
			arraylistDayOfMonth = arraylistRecord.getValue(0);
			arraylistLoc = arraylistRecord.getValue(1);
			if ((dayofMonth == null || arraylistDayOfMonth.equals(dayofMonth)) && arraylistLoc.equals(loc)) {
				if (categoryString % 2 == 0) {
					if (!isTicket && categoryString >= 6) {
						count = arraylistRecord.getValue(6);
					} else if (!isTicket && categoryString >= 4) {
						count = arraylistRecord.getValue(4);
					} else {
						count = arraylistRecord.getValue(2);
					}
				} else {
					if (!isTicket && categoryString >= 6) {
						count = arraylistRecord.getValue(7);
					} else if (!isTicket && categoryString >= 4) {
						count = arraylistRecord.getValue(5);
					} else {
						count = arraylistRecord.getValue(3);
					}
				}
				break;
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	}

	return count;
}

public static boolean isLeapYear(int year) {
	if (year % 4 != 0) {
		return false;
	} else if (year % 400 == 0) {
		return true;
	} else if (year % 100 == 0) {
		return false;
	} else {
		return true;
	}
}
%>
<%
String sSelectedYear = request.getParameter("searchDate_yy");
String sSelectedMonth = request.getParameter("searchDate_mm");

int selectedYear = 0;
int selectedMonth = 0;
if (sSelectedYear != null && sSelectedMonth != null) {
	selectedYear = Integer.parseInt(sSelectedYear);
	selectedMonth = Integer.parseInt(sSelectedMonth);
} else {
	selectedYear = DateTimeUtil.getCurrentYear();
	selectedMonth = DateTimeUtil.getCurrentMonth();
}

String selectedYearString = Integer.toString(selectedYear);
String selectedYearMonth = Integer.toString(selectedMonth);

int maxDaysInMonth = 0;
if (selectedMonth == 4 || selectedMonth == 6 || selectedMonth == 9 || selectedMonth == 11) {
	maxDaysInMonth = 30;
} else if (selectedMonth == 2) {
	if (isLeapYear(selectedYear)) {
		maxDaysInMonth = 29;
	} else {
		maxDaysInMonth = 28;
	}
} else {
	maxDaysInMonth = 31;
}

String dayStartDate = "01/" + Integer.toString(selectedMonth) + "/" + Integer.toString(selectedYear);
String dayEndDate = maxDaysInMonth + "/" + Integer.toString(selectedMonth) + "/" + Integer.toString(selectedYear);
ArrayList monthTicketTotal = getMonthTicketTotal(dayStartDate, dayEndDate);
ArrayList monthRecordTotal[] = new ArrayList[4];
monthRecordTotal[0] = getMonthRecordTotal(dayStartDate, dayEndDate, 0);
monthRecordTotal[1] = getMonthRecordTotal(dayStartDate, dayEndDate, 1);
monthRecordTotal[2] = getMonthRecordTotal(dayStartDate, dayEndDate, 2);
monthRecordTotal[3] = getMonthRecordTotal(dayStartDate, dayEndDate, 3);
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>

.dataSummary {
	border-left:1px solid #000;
	border-top:1px solid #000;
	border-right:1px solid #CCC;
	border-bottom:1px solid #ccc;
	cursor: pointer;
}
</style>
<body>
<DIV id=indexWrapper style="width:100%">
<DIV id=mainFrame style="width:100%">
<DIV id=contentFrame style="width:100%">
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Pharmacy Ticket Report" />
	<jsp:param name="category" value="prompt.admin" />
</jsp:include>
<form name="search_form" action="pharmacyTicket_statistic.jsp" method="get">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch search" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Search Year</td>
		<td class="infoData" width="70%">
		<jsp:include page="../ui/dateCMB.jsp" flush="false">
		<jsp:param name="label" value="searchDate" />
		<jsp:param name="day_yy" value="<%=sSelectedYear %>" />
		<jsp:param name="day_mm" value="<%=sSelectedMonth %>" />
		<jsp:param name="yearRange" value="10" />
		<jsp:param name="YearAndMonth" value="Y" />
		</jsp:include>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="submitSearch()">Submit</button>
			<button type='button' onclick="clearSearch()">Reset</button>
		</td>
	</tr>
</table>
</form>

<table id="pharmacyTable" border="1" width="100%">
	<tr>
		<th width="5%">&nbsp;</th>
		<th width="5%">Date</th>
<%
	for (int i = 1; i <= maxDaysInMonth; i++) {
%>
		<th width="3%"><%=i %></th>
<%
	}
%>
	</tr>
<%
	String[] categoryString = new String[8];
	categoryString[0] = "OW Start to pt 1 average";
	categoryString[1] = "OW Start to pt 1 75th";
	categoryString[2] = "NW Start to pt 1 average";
	categoryString[3] = "NW Start to pt 1 75th";
	categoryString[4] = "IP T7 average";
	categoryString[5] = "IP T7 75th";
	categoryString[6] = "Discharge T7 average";
	categoryString[7] = "Discharge T7 75th";

	String[] categoryTimeZone = new String[4];
	categoryTimeZone[0] = "0000-0859";
	categoryTimeZone[1] = "0900-1359";
	categoryTimeZone[2] = "1400-1759";
	categoryTimeZone[3] = "1800-2359";

	String[] categoryColor = new String[8];
	categoryColor[0] = "#FDE9D9";
	categoryColor[1] = "#FDE9D9";
	categoryColor[2] = "#DBEEF3";
	categoryColor[3] = "#DBEEF3";
	categoryColor[4] = "#E5E0EC";
	categoryColor[5] = "#E5E0EC";
	categoryColor[6] = "#EAF1DD";
	categoryColor[7] = "#EAF1DD";

	for (int i = 0; i < 8; i++) {
		if (i % 2 == 0) {
%>
	<tr bgcolor="<%=categoryColor[i] %>">
		<td valign='top'>&nbsp;</td>
		<td valign='top'><font color='red'>#ticket</font></td>
		<%=getTable(monthTicketTotal, i, maxDaysInMonth, true)%>
	</tr>
<%
		}
		for (int j = 0; j < 4; j++) {
%>
	<tr bgcolor="<%=categoryColor[i] %>">
		<td valign='top'><%=categoryString[i] %></td>
		<td valign='top'><%=categoryTimeZone[j] %></td>
		<%=getTable(monthRecordTotal[j], i, maxDaysInMonth, false)%>
	</tr>
<%
		}
		if (i % 2 == 1) {
%>
	<tr>
		<td valign='top' colspan='<%=(maxDaysInMonth + 2) %>'>&nbsp;</td>
	</tr>
<%
		}
	}
%>
</table>
<script language="javascript">
	$(document).ready(function() {
	});

	function submitSearch() {
		document.forms["search_form"].submit();
		return true;
	}

	function clearSearch() {
		var month = (new Date).getMonth()+1;
		if (month < 10) {
			month = "0" + month;
		}

		$('table.contentFrameSearch').find('select#searchDate_yy').val((new Date).getFullYear());
		$('table.contentFrameSearch').find('select#searchDate_mm').val(month);
	}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>