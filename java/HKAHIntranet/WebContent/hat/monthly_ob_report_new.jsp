<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>

<%!
	private static DecimalFormat pctFormat = new DecimalFormat();

	private ArrayList getDoctorWaitingByMonth(String searchYear) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(OB_EXPECTED_DELIVERYDATE, 'MM'), COUNT(1), ");
		sqlStr.append("       SUM(DECODE(OB_DOC_TYPE, 'L', 0, 'C', 0, 1)), ");
		sqlStr.append("       SUM(CASE WHEN (DECODE(OB_DOC_TYPE, 'L', 1, 'C', 1, 0) + DECODE(OB_KIN_DOC_TYPE, NULL, 0, 'L', 0, 'C', 0, 1) = 2) THEN 1 ELSE 0 END), ");
		sqlStr.append("       SUM(CASE WHEN (DECODE(OB_DOC_TYPE, 'L', 1, 'C', 1, 0) + DECODE(OB_KIN_DOC_TYPE, NULL, 1, 'L', 1, 'C', 1, 0) = 2) THEN 1 ELSE 0 END) ");
		sqlStr.append("FROM   OB_BOOKINGS ");
		sqlStr.append("WHERE  OB_BOOKING_STATUS = 'W' ");
		sqlStr.append("AND    OB_ENABLED = '1' ");
		sqlStr.append("AND    OB_EXPECTED_DELIVERYDATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    OB_EXPECTED_DELIVERYDATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("GROUP BY TO_CHAR(OB_EXPECTED_DELIVERYDATE, 'MM') ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getDoctorBookingByMonth(String searchYear) {
		// No. of booking created = Booking no. start from "B" + Booking no. start from "S"
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(BPBHDATE, 'MM'), COUNT(1), SUM(DECODE(BPBSTS, 'N', 1, 0)), SUM(DECODE(BPBSTS, 'F', 1, 0)), ");
		sqlStr.append("       SUM(DECODE(SLPNO, NULL, 0, 1)), SUM(CASE WHEN BPBRMK LIKE '%STAFF%' THEN 1 ELSE 0 END), ");
		sqlStr.append("       SUM(DECODE(PATDOCTYPE, 'L', 0, 'C', 0, 1)), ");
		sqlStr.append("       SUM(CASE WHEN (DECODE(PATDOCTYPE, 'L', 1, 'C', 1, 0) + DECODE(HUSDOCTYPE, NULL, 0, 'L', 0, 'C', 0, 1) = 2) THEN 1 ELSE 0 END), ");
		sqlStr.append("       SUM(CASE WHEN (DECODE(PATDOCTYPE, 'L', 1, 'C', 1, 0) + DECODE(HUSDOCTYPE, NULL, 1, 'L', 1, 'C', 1, 0) = 2) THEN 1 ELSE 0 END) ");
		sqlStr.append("FROM   BEDPREBOK@IWEB ");
		sqlStr.append("WHERE (BPBNO LIKE 'B%' OR BPBNO LIKE 'S%') ");
		sqlStr.append("AND    BPBHDATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BPBHDATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BPBSTS != 'D' ");
		sqlStr.append("AND    WRDCODE IN ('OB', 'U100') ");
		sqlStr.append("AND    FORDELIVERY = '-1' ");
		sqlStr.append("GROUP BY TO_CHAR(BPBHDATE, 'MM') ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getDoctorBooking(String searchYear, String docCode) {
		// No. of doctor's booking = Booking no. start from "B" + Booking no. start from "S"+ doctor code
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(BPBHDATE, 'MM'), COUNT(1) ");
		sqlStr.append("FROM   BEDPREBOK@IWEB ");
		sqlStr.append("WHERE (BPBNO LIKE 'B%' OR BPBNO LIKE 'S%') ");
		sqlStr.append("AND    BPBHDATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BPBHDATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    DOCCODE = '");
		sqlStr.append(docCode);
		sqlStr.append("' ");
		sqlStr.append("AND    BPBSTS != 'D' ");
		sqlStr.append("AND    WRDCODE = 'OB' ");
		sqlStr.append("AND    FORDELIVERY = '-1' ");
		sqlStr.append("GROUP BY TO_CHAR(BPBHDATE, 'MM') ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getNoOfActualDeliveryByMonth(String searchYear) {
		// view patient table, birthdate = search year, patnb = -1
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(BB_DOB, 'MM'), COUNT(1), ");
		sqlStr.append("       SUM(DECODE(MO_TRAVELDOCTYPE, 'L', 0, 'C', 0, 1)), ");
		sqlStr.append("       SUM(CASE WHEN (DECODE(MO_TRAVELDOCTYPE, 'L', 1, 'C', 1, 0) + DECODE(FA_TRAVELDOCTYPE, NULL, 0, 'L', 0, 'C', 0, 1) = 2) THEN 1 ELSE 0 END), ");
		sqlStr.append("       SUM(CASE WHEN (DECODE(MO_TRAVELDOCTYPE, 'L', 1, 'C', 1, 0) + DECODE(FA_TRAVELDOCTYPE, NULL, 1, 'L', 1, 'C', 1, 0) = 2) THEN 1 ELSE 0 END) ");
		sqlStr.append("FROM   EBIRTHDTL@IWEB ");
		sqlStr.append("WHERE  BB_DOB >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BB_DOB <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("GROUP BY TO_CHAR(BB_DOB, 'MM') ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private HashMap<String, String> arrayList2HashMapInString(ArrayList record, int index) {
		HashMap<String, String> dataSearch = new HashMap<String, String>();
		ReportableListObject row = null;

		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				dataSearch.put(row.getValue(0), row.getValue(index));
			}
		}
		return dataSearch;
	}

	private StringBuffer parseTable(HashMap booking) {
		String key = null;
		int value = 0;
		int totalValue = 0;

		// initial string buffer
		StringBuffer strbuf = new StringBuffer();

		for (int i = 1; i <= 12; i++) {
			strbuf.append("<td align=\"center\" width=\"05%\">");
			key = (i < 10 ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.EMPTY_VALUE) + i;
			value = 0;
			if (booking.containsKey(key)) {
				try {
					value = Integer.parseInt((String) booking.get(key));
				} catch (Exception e) {}
			}
			if (value == 0) {
				strbuf.append("--");
			} else {
				strbuf.append(value);
				totalValue += value;
			}
			strbuf.append("<br/>(");
			strbuf.append(totalValue);
			strbuf.append(")</td>");
		}
		return strbuf;
	}

	private StringBuffer parseTable(HashMap booking, HashMap booking2) {
		String key = null;

		// initial string buffer
		StringBuffer strbuf = new StringBuffer();

		for (int i = 1; i <= 12; i++) {
			strbuf.append("<td align=\"center\" width=\"05%\">");
			key = (i < 10 ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.EMPTY_VALUE) + i;
			if (booking.containsKey(key)) {
				if (booking.containsKey(key)) {
					strbuf.append((String) booking.get(key));
				} else {
					strbuf.append("--");
				}
				strbuf.append(" / ");
				if (booking2.containsKey(key)) {
					strbuf.append((String) booking2.get(key));
				} else {
					strbuf.append("--");
				}
			} else {
				strbuf.append("--");
			}
			strbuf.append("</td>");
		}
		return strbuf;
	}

	private StringBuffer parseTable(ArrayList record) {
		ReportableListObject row = null;
		String key = null;
		String value = null;
		HashMap booking = new HashMap();
		int totalValue = 0;

		// initial string buffer
		StringBuffer strbuf = new StringBuffer();

		// loop the result
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				booking.put(row.getValue(0), row.getValue(1));
			}
		}

		for (int i = 1; i <= 12; i++) {
			strbuf.append("<td align=\"center\" width=\"05%\">");
			key = (i < 10 ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.EMPTY_VALUE) + i;
			if (booking.containsKey(key)) {
				value = (String) booking.get(key);
				strbuf.append(value);
				try {
					totalValue += Integer.parseInt(value);
				} catch (Exception e) {}
			} else {
				strbuf.append("--");
			}
			strbuf.append("<br/>(");
			strbuf.append(totalValue);
			strbuf.append(")</td>");
		}

		if (totalValue > 0) {
			return strbuf;
		} else {
			return null;
		}
	}

	private StringBuffer parseTableWithPercentage(HashMap booking, HashMap booking2) {
		String key = null;
		int value1 = 0;
		int value2 = 0;
		int diff = 0;

		// initial string buffer
		StringBuffer strbuf = new StringBuffer();

		for (int i = 1; i <= 12; i++) {
			strbuf.append("<td align=\"center\" width=\"05%\">");
			key = (i < 10 ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.EMPTY_VALUE) + i;
			if (booking.containsKey(key)) {
				value1 = 0;
				value2 = 0;
				try {
					value1 = Integer.parseInt((String) booking.get(key));
				} catch (Exception e) {}
				try {
					value2 = Integer.parseInt((String) booking2.get(key));
				} catch (Exception e) {}
				diff = value1 - value2;
				strbuf.append(diff);
				strbuf.append("<br/>");
				strbuf.append(pctFormat.format( 1.00 * diff / value2));
			} else {
				strbuf.append("--");
			}
			strbuf.append("</td>");
		}
		return strbuf;
	}
	
	private int getSumOfBooking(ArrayList record) {
		ReportableListObject row = null;
		int sumOfBooking = 0;
		// loop the result
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				int noOfBooking = Integer.parseInt(row.getValue(1));
				sumOfBooking = sumOfBooking + noOfBooking;
			}
		}
		
		return sumOfBooking;
	}
	
%>
<%
UserBean userBean = new UserBean(request);

pctFormat.applyPattern("0.00%");

String docCode = request.getParameter("docCode");
String searchYear = request.getParameter("searchYear_yy");
int currentYear = DateTimeUtil.getCurrentYear();

if (searchYear == null) {
	searchYear = String.valueOf(currentYear);
}

int previousYear = currentYear;
try {
	previousYear = Integer.parseInt(searchYear) - 1;
} catch (Exception e) {
}
String prevSearchYear = String.valueOf(previousYear);

ArrayList recordYear1_waiting = getDoctorWaitingByMonth(searchYear);
ArrayList recordYear1 = getDoctorBookingByMonth(searchYear);
ArrayList recordYear2 = getDoctorBookingByMonth(prevSearchYear);
ArrayList recordYear1_actual = getNoOfActualDeliveryByMonth(searchYear);
ArrayList recordYear2_actual = getNoOfActualDeliveryByMonth(prevSearchYear);

HashMap<String, String> noOfActualDeliveryYear1 = arrayList2HashMapInString(recordYear1_actual, 1);
HashMap<String, String> noOfActualDeliveryYear2 = arrayList2HashMapInString(recordYear2_actual, 1);

ArrayList record = UtilDBWeb.getFunctionResults("HAT_CMB_DOCTOR", new String[] { "" });
ReportableListObject row = null;

String temp_docCode = null;
String temp_docFName = null;
String temp_docGName = null;
int sumOfBooking = 0;

StringBuffer docBookingTest = null;
ArrayList<DoctorInformation> listOfDoctors = new ArrayList<DoctorInformation>();

if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		
		temp_docCode = row.getValue(0);
		temp_docFName = row.getValue(1);
		temp_docGName = row.getValue(2);
		sumOfBooking =  getSumOfBooking(getDoctorBooking(searchYear, temp_docCode));
		
		if(sumOfBooking > 0){
			listOfDoctors.add(new DoctorInformation(temp_docCode, temp_docFName, temp_docGName, sumOfBooking));
		}			
	}	
	Collections.sort(listOfDoctors, new DoctorInformation());	
}

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
<%@ page language="java" contentType="text/html; charset=big5" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.monthly.ob.report3" />
	<jsp:param name="category" value="Report" />
</jsp:include>
<form name="search_form" action="monthly_ob_report_new.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Doctor</td>
		<td class="infoData" width="70%">
			<select name="docCode">
				<option value="">--- Select Doctor ---</option>
<jsp:include page="../ui/docCodeCMB.jsp" flush="false">
	<jsp:param name="doccode" value="<%=docCode %>" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Search Year</td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="searchYear" />
	<jsp:param name="day_yy" value="<%=searchYear %>" />
	<jsp:param name="yearRange" value="1" />
	<jsp:param name="isYearOnly" value="Y" />
</jsp:include>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<table border="1" width="100%">
	<tr>
		<td class="infoCenterLabel" width="20%"><%=searchYear %></td>
		<td class="infoCenterLabel" width="05%">Jan</td>
		<td class="infoCenterLabel" width="05%">Feb</td>
		<td class="infoCenterLabel" width="05%">Mar</td>
		<td class="infoCenterLabel" width="05%">Apr</td>
		<td class="infoCenterLabel" width="05%">May</td>
		<td class="infoCenterLabel" width="05%">Jun</td>
		<td class="infoCenterLabel" width="05%">Jul</td>
		<td class="infoCenterLabel" width="05%">Aug</td>
		<td class="infoCenterLabel" width="05%">Sep</td>
		<td class="infoCenterLabel" width="05%">Oct</td>
		<td class="infoCenterLabel" width="05%">Nov</td>
		<td class="infoCenterLabel" width="05%">Dec</td>
	</tr>
	<tr>
		<td align="center">No. of booking created<br/>YTM</td>
<%=parseTable(arrayList2HashMapInString(recordYear1, 1)) %>
	</tr>
	<tr>
		<td align="center" width="20%">No. of deposit paid<br/>YTM</td>
<%=parseTable(arrayList2HashMapInString(recordYear1, 4)) %>
	</tr>
</table>
<br/><p/><br/>
<table border="1" width="100%">
	<tr>
		<td class="infoCenterLabel" width="20%"><%=searchYear %></td>
		<td class="infoCenterLabel" width="05%">Jan</td>
		<td class="infoCenterLabel" width="05%">Feb</td>
		<td class="infoCenterLabel" width="05%">Mar</td>
		<td class="infoCenterLabel" width="05%">Apr</td>
		<td class="infoCenterLabel" width="05%">May</td>
		<td class="infoCenterLabel" width="05%">Jun</td>
		<td class="infoCenterLabel" width="05%">Jul</td>
		<td class="infoCenterLabel" width="05%">Aug</td>
		<td class="infoCenterLabel" width="05%">Sep</td>
		<td class="infoCenterLabel" width="05%">Oct</td>
		<td class="infoCenterLabel" width="05%">Nov</td>
		<td class="infoCenterLabel" width="05%">Dec</td>
	</tr>
	<tr class="warning">
		<td align="center">No. of actual delivery<br/>YTM</td>
<%=parseTable(noOfActualDeliveryYear1) %>
	</tr>
	<tr>
		<td align="center">Local/Expatriate Parents (Actual)</td>
<%=parseTable(arrayList2HashMapInString(recordYear1_actual, 2)) %>
	</tr>
	<tr>
		<td align="center">Mainland Mother + Local/Expatriate Father (Actual)</td>
<%=parseTable(arrayList2HashMapInString(recordYear1_actual, 3)) %>
	</tr>
	<tr class="warning">
		<td align="center">Changes Compare with Prev Year</td>
<%=parseTableWithPercentage(noOfActualDeliveryYear1, noOfActualDeliveryYear2) %>
	</tr>
</table>
<span id="current_report_result"></span>
<br/><p/><br/>
<table border="1" width="100%">
	<tr>
		<td class="infoCenterLabel" colspan="13"><font size="2">OB Doctor's Booking</font></td>
	</tr>
	<tr>
		<td class="infoCenterLabel" width="20%">Doctor</td>
		<td class="infoCenterLabel" width="05%">Jan</td>
		<td class="infoCenterLabel" width="05%">Feb</td>
		<td class="infoCenterLabel" width="05%">Mar</td>
		<td class="infoCenterLabel" width="05%">Apr</td>
		<td class="infoCenterLabel" width="05%">May</td>
		<td class="infoCenterLabel" width="05%">Jun</td>
		<td class="infoCenterLabel" width="05%">Jul</td>
		<td class="infoCenterLabel" width="05%">Aug</td>
		<td class="infoCenterLabel" width="05%">Sep</td>
		<td class="infoCenterLabel" width="05%">Oct</td>
		<td class="infoCenterLabel" width="05%">Nov</td>
		<td class="infoCenterLabel" width="05%">Dec</td>
	</tr>
<%
	StringBuffer docBooking = null;
		for (DoctorInformation d : listOfDoctors) {			
			docBooking = parseTable(getDoctorBooking(searchYear, d.docCode));
			if (docBooking != null) {
%>
	<tr>
		<td width="20%">Dr. <%=d.docFName %> <%=d.docGName %></td>
<%=docBooking %>
	</tr>
<%
			}
		}	
%>
</table>
<br/><p/><br/>
</DIV>

</DIV></DIV>

<script language="javascript">
<!--
	// ajax
	var http = createRequestObject();
	var selectedCurrentYear = "<%=searchYear %>";
	var div_indicator;

	var currDocCode = document.forms["search_form"].elements["docCode"].value;

	if (currDocCode != '') {
		submitSearchHelper(currDocCode, selectedCurrentYear, "current_report_result");
	}

	function submitSearch() {
		var docCode = document.forms["search_form"].elements["docCode"].value;
		var searchYear = document.forms["search_form"].elements["searchYear_yy"].value;

		if (searchYear == selectedCurrentYear) {
			submitSearchHelper(docCode, selectedCurrentYear, "current_report_result");
			return false;
		} else {
			document.forms["search_form"].submit();
			return true;
		}
	}

	function submitSearchHelper(docCode, searchYear, indicator) {
		// show loading image
		//document.getElementById("report_result").innerHTML = '<img src="../images/wait30trans.gif">';

		// make a connection to the server ... specifying that you intend to make a GET request
		// to the server. Specifiy the page name and the URL parameters to send
		http.open('get', 'monthly_ob_report_result.jsp?docCode=' + docCode + '&searchYear_yy=' + searchYear + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		div_indicator = indicator;

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			document.getElementById(div_indicator).innerHTML += http.responseText;

			if (div_indicator == 'current_report_result') {
				var docCode = document.forms["search_form"].elements["docCode"].value;
			}
		}
	}

	function clearSearch() {
		document.forms["search_form"].elements["docCode"].value = "";
		document.forms["search_form"].elements["searchYear_yy"].value = "<%=currentYear %>";

		document.getElementById("report_result").innerHTML = '';
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>