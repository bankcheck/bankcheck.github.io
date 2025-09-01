<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
%>
<%!
 
	private static DecimalFormat pctFormat = new DecimalFormat();
	
	private ArrayList getNoOfBooking(String searchYear, Integer bkId,String Type, Boolean isTotal){
		return getNoOfBooking(searchYear,bkId,Type,isTotal,false,false);
	}

 	private ArrayList getNoOfBooking(String searchYear, Integer bkId,String Type, Boolean isTotal, Boolean isOther,Boolean isStaff) {
		// No. of booking created = Booking no. start from "B" + Booking no. start from "S"
		StringBuffer sqlStr = new StringBuffer();
		if(isTotal){sqlStr.append("SELECT BK.BKSID, COUNT(1) "); }
		else{sqlStr.append("SELECT TO_CHAR(BKGCDATE,'MM'), COUNT(1) ");}
		sqlStr.append(" FROM BOOKING@IWEB  BK ");
		if (!isStaff && !isOther) {
			sqlStr.append(" INNER JOIN BOOKINGSRC@IWEB BKSRC ");
			sqlStr.append(" ON BK.BKSID = BKSRC.BKSID ");
		}
		sqlStr.append(" INNER JOIN SCHEDULE@IWEB SCE ");
		sqlStr.append(" ON BK.SCHID = SCE.SCHID ");
		sqlStr.append(" INNER JOIN DOCTOR@IWEB DR ");
		sqlStr.append(" ON SCE.DOCCODE = DR.DOCCODE ");
		sqlStr.append(" LEFT JOIN "); 
		sqlStr.append("(SELECT PATNO,COUNT(1) AS ISSTAFF "); 
		sqlStr.append(" FROM PATALTLINK@IWEB  "); 
		sqlStr.append(" WHERE ALTID IN ('43','44','45','46') "); 
		sqlStr.append(" AND USRID_C IS NULL AND PALCDATE IS NULL "); 
		sqlStr.append(" GROUP BY PATNO  ) PA "); 
		sqlStr.append(" ON BK.PATNO = PA.PATNO "); 
		sqlStr.append(" WHERE BK.BKGCDATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BK.BKGCDATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append(" AND DR.SPCCODE");
		if("GP".equals(Type)){
		sqlStr.append(" like 'GP' ");
		}
		if("SP".equals(Type)){
			sqlStr.append(" not like 'GP' ");	
		}
		if (isOther) {
			sqlStr.append(" AND BK.BKSID is null ");
		} else if (!isStaff){
			sqlStr.append(" AND BK.BKSID = ");
			sqlStr.append(bkId);
		}
		if (isStaff) {
			sqlStr.append(" AND (PA.ISSTAFF > 0) ");
		} else {
			sqlStr.append(" AND (PA.ISSTAFF < 1 OR PA.ISSTAFF IS NULL) ");
		}
		if(isTotal){sqlStr.append(" GROUP BY BK.BKSID ");}
		else{sqlStr.append("GROUP BY TO_CHAR(BKGCDATE, 'MM') ");}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	} 
	
 	private ArrayList getTotal(String searchYear,Boolean countTotal) {
		StringBuffer sqlStr = new StringBuffer();
		
		if(countTotal){sqlStr.append("SELECT COUNT(1) "); }
		else{sqlStr.append("SELECT TO_CHAR(BKGCDATE,'MM'), COUNT(1) ");}
		sqlStr.append(" FROM BOOKING@IWEB  BK ");
		sqlStr.append(" INNER JOIN SCHEDULE@IWEB SCE ");
		sqlStr.append(" ON BK.SCHID = SCE.SCHID ");
		sqlStr.append(" INNER JOIN DOCTOR@IWEB DR ");
		sqlStr.append(" ON SCE.DOCCODE = DR.DOCCODE ");
		sqlStr.append(" WHERE BK.BKGCDATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BK.BKGCDATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		if(!countTotal){sqlStr.append("GROUP BY TO_CHAR(BKGCDATE, 'MM') ");}

		return UtilDBWeb.getReportableList(sqlStr.toString());
	} 

	private ArrayList getIdOrder() {
		// view patient table, birthdate = search year, patnb = -1
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(" SELECT BKSID, BKSDESC, BKSORD ");
		sqlStr.append(" FROM BOOKINGSRC@IWEB WHERE BKSID NOT IN ('70','65') ");
		sqlStr.append(" ORDER BY BKSORD ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}


	private StringBuffer parseTable(ArrayList record) {
		ReportableListObject row = null;
		String key = null;
		int value = 0;
		int totalCount = 0;
		HashMap booking = new HashMap();

		// initial string buffer
		StringBuffer strbuf = new StringBuffer();

		// loop the result
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				booking.put(row.getValue(0), row.getValue(1));
				totalCount = totalCount + Integer.parseInt(row.getValue(1));
			}
		}

		for (int i = 1; i <= 12; i++) {
			strbuf.append("<td align=\"center\" width=\"05%\">");
			key = (i < 10 ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.EMPTY_VALUE) + i;
			if (booking.containsKey(key)) {
				value = 0;
				try {
					value = Integer.parseInt((String) booking.get(key));
				} catch (Exception e) {}
				strbuf.append(value);
			} else {
				strbuf.append("--");
			}
			strbuf.append("<br/>");
			strbuf.append("</td>");
			
			if(i== 12) {
				strbuf.append("<td align=\"center\" width=\"05%\">");
				if (totalCount > 0){
					strbuf.append(totalCount);
				} else {
					strbuf.append("--");
				}
				strbuf.append("<br/>");
				strbuf.append("</td>");
			}
		}
		return strbuf;
	}

	private StringBuffer parseTable(ArrayList record, ArrayList record2) {
		ReportableListObject row = null;
		String key = null;
		int value1 = 0;
		int value2 = 0;
		int diff = 0;
		HashMap booking = new HashMap();
		HashMap booking2 = new HashMap();

		// initial string buffer
		StringBuffer strbuf = new StringBuffer();

		// loop the result
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				booking.put(row.getValue(0), row.getValue(1));
			}
		}

		if (record2.size() > 0) {
			for (int i = 0; i < record2.size(); i++) {
				row = (ReportableListObject) record2.get(i);
				booking2.put(row.getValue(0), row.getValue(1));
			}
		}
		
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
%>
<%

String searchYear = request.getParameter("searchYear_yy");
String site = request.getParameter("site");

if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital- Stubbs Road";
}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}

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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%String PageTitle = "OPD Booking Source Report"; %>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.bookingsource.report" />
	<jsp:param name="category" value="Report" />
</jsp:include>
<form name="search_form" action="opd_BookingSource_report.jsp" method="post">
<table  width="100%">
	<tr class="bigText">
		<td width="30%"></td>
		<%DateFormat shortFormat = DateFormat.getDateTimeInstance( DateFormat.LONG, DateFormat.SHORT);  %>
		<td  width="70%" align="right">Print Date/Time: <%= shortFormat.format(new java.util.Date())%></td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">

	<tr class="bigText">
		<td width="30%"></td>
		<td  width="70%" align="center"><%=site %></td>
	</tr>
	<tr class="bigText">
		<td  width="30%"></td>
		<td  width="70%" align="center">OP Clinic Booking Source Report<br>(for all status of appointments)</td>
		
	</tr>
	<tr class="smallText" >
		<td class="infoLabel" width="30%"></td>
		<td class="infoData" width="70%" >For Year
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
		<td class="infoCenterLabel" width="05%"></td>
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
		<td class="infoCenterLabel" width="05%">Total</td>
	</tr>
<%
	ArrayList orderOfDesc = getIdOrder();
 	for(int i =0;i<orderOfDesc.size();i++){
	 ReportableListObject rowDesc = (ReportableListObject) orderOfDesc.get(i); 
%>
	<tr>
		<td align="center" rowspan="2"><%=rowDesc.getFields1() %></td>
		<td align="center">GP</td>
		<%=parseTable(getNoOfBooking(searchYear,Integer.parseInt(rowDesc.getFields0()),"GP",false)) %>
	</tr>
	<tr>
		<td align="center">SP</td>
		<%=parseTable(getNoOfBooking(searchYear,Integer.parseInt(rowDesc.getFields0()),"SP",false)) %>
	</tr>
<%	 
 }
%>
 	<tr>
		<td align="center" rowspan="2">Other</td>
		<td align="center">GP</td>
		<%=parseTable(getNoOfBooking(searchYear,null,"GP",false,true,false)) %>
	</tr>
	<tr>
		<td align="center">SP</td>
		<%=parseTable(getNoOfBooking(searchYear,null,"SP",false,true,false)) %>
	</tr>
	
	 	<tr>
		<td align="center" rowspan="2">Staff</td>
		<td align="center">GP</td>
		<%=parseTable(getNoOfBooking(searchYear,null,"GP",false,false,true)) %>
	</tr>
	<tr>
		<td align="center">SP</td>
		<%=parseTable(getNoOfBooking(searchYear,null,"SP",false,false,true)) %>
	</tr>
	
	
	<tr>
		<td align="center" colspan="2">Total</td>
		<%=parseTable(getTotal(searchYear,false)) %>
	</tr> 
	
</table>
<span id="current_report_result"></span>
<br/><p/><br/>

</DIV>

</DIV></DIV>

<script language="javascript">
<!--
	// ajax
	var http = createRequestObject();
	var selectedCurrentYear = "<%=searchYear %>";
	var selectedPreviousYear = "<%=previousYear %>";
	var div_indicator;


	function submitSearch() {
		var searchYear = document.forms["search_form"].elements["searchYear_yy"].value;

		if (searchYear == selectedCurrentYear) {
			submitSearchHelper(docCode, selectedCurrentYear, "current_report_result");
			return false;
		} else {
			document.forms["search_form"].submit();
			return true;
		}
	}

	function submitSearchHelper(searchYear, indicator) {
		// show loading image
		//document.getElementById("report_result").innerHTML = '<img src="../images/wait30trans.gif">';

		// make a connection to the server ... specifying that you intend to make a GET request
		// to the server. Specifiy the page name and the URL parameters to send
		http.open('get', 'opd_BookingSource_report.jsp?searchYear_yy=' + searchYear + '&timestamp=<%=(new java.util.Date()).getTime() %>');

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
				submitSearchHelper(selectedPreviousYear, "previous_report_result");
			}
		}
	}

	function clearSearch() {
		document.forms["search_form"].elements["searchYear_yy"].value = "<%=currentYear %>";

		document.getElementById("report_result").innerHTML = '';
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>