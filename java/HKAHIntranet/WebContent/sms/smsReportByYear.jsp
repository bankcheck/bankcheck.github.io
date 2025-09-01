<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getSmsRecord(String searchYear, String type) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(S.CREATE_DATE, 'MM'), ");
		sqlStr.append("SUM(NO_OF_MSG), ");
		sqlStr.append("SUM(DECODE(S.REV_AREA_CODE, '852', NO_OF_MSG, 0)), ");
		sqlStr.append("SUM(DECODE(S.REV_AREA_CODE, '86', NO_OF_MSG, 0)), ");
		sqlStr.append("SUM(DECODE(S.REV_AREA_CODE, '853', NO_OF_MSG, 0)), ");
		sqlStr.append("SUM(DECODE(S.REV_AREA_CODE, '852', 0, '86', 0, '853', 0, NO_OF_MSG)), ");
		sqlStr.append("SUM(DECODE(NO_OF_SUCCESS, 0, 0, null, 0, 1)), ");
		sqlStr.append("SUM(DECODE(S.SUCCESS, 1, NO_OF_SUCCESS, 0)), ");
		sqlStr.append("SUM(DECODE(S.REV_AREA_CODE, '852', DECODE(S.SUCCESS, 1, NO_OF_SUCCESS, 0), 0)), ");
		sqlStr.append("SUM(DECODE(S.REV_AREA_CODE, '86', DECODE(S.SUCCESS, 1, NO_OF_SUCCESS, 0), 0)), ");
		sqlStr.append("SUM(DECODE(S.REV_AREA_CODE, '853', DECODE(S.SUCCESS, 1, NO_OF_SUCCESS, 0), 0)), ");
		sqlStr.append("SUM(DECODE(S.REV_AREA_CODE, '852', 0, '86', 0, '853', 0, DECODE(S.SUCCESS, 1, NO_OF_SUCCESS, 0))), ");
		sqlStr.append("SUM(DECODE(S.SUCCESS, 1, 1, 0)) ");
		
		sqlStr.append("FROM   SMS_LOG S ");
		if (type.equals("inpatient")) {
			sqlStr.append("WHERE  S.ACT_TYPE = 'INPAT' ");
		} else if(type.equals("oncology")) {
			sqlStr.append("WHERE  S.ACT_TYPE = 'ONCOLOGY' ");		
		}else {
			sqlStr.append("WHERE  S.ACT_TYPE = 'OUTPAT' ");
		}
		sqlStr.append("AND    S.CREATE_DATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    S.CREATE_DATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("GROUP BY TO_CHAR(S.CREATE_DATE,'MM') ");
		//System.out.println(sqlStr.toString());
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

	private StringBuffer parseTable(HashMap booking, HashMap success) {
		String key = null;
		int valueB = 0;
		int totalValueB = 0;
		int valueS = 0;
		int totalValueS = 0;

		// initial string buffer
		StringBuffer strbuf = new StringBuffer();

		for (int i = 1; i <= 12; i++) {
			strbuf.append("<td align=\"center\" width=\"05%\">");
			key = (i < 10 ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.EMPTY_VALUE) + i;
			valueB = 0;
			valueS = 0;
			
			if (success.containsKey(key)) {
				try {
					valueS = Integer.parseInt((String) success.get(key));
				} catch (Exception e) {}
			}
			if (valueS == 0) {
				strbuf.append("--");
			} else {
				strbuf.append(valueS);
				totalValueS += valueS;
			}
			
			if (booking.containsKey(key)) {
				try {
					valueB = Integer.parseInt((String) booking.get(key));
				} catch (Exception e) {}
			}
			strbuf.append("/");
			if (valueB == 0) {
				strbuf.append("--");
			} else {
				strbuf.append(valueB);
				totalValueB += valueB;
			}
			
			strbuf.append("<br/>(");
			strbuf.append(totalValueS);
			strbuf.append("/");
			strbuf.append(totalValueB);
			strbuf.append(")</td>");
		}
		return strbuf;
	}
%>

<%
UserBean userBean = new UserBean(request);
String searchYear = request.getParameter("searchYear_yy");
if (searchYear == null) {
	searchYear = String.valueOf(DateTimeUtil.getCurrentYear());
}
String site = null;
String type = request.getParameter("type");
String funID = "";
if(type.equals("inpatient")){
	funID = "function.sms.report2";
}else if(type.equals("oncology")){
	funID = "function.sms.report3";
}else{
	funID = "function.sms.report1";
}

String displayTitle = "";
if(type.equals("inpatient")){
	displayTitle = "SMS Yearly Report (Inpatient)";
}else if(type.equals("oncology")){
	displayTitle = "SMS Yearly Report (Oncology)";
}else{
	displayTitle = "SMS Yearly Report (Outpatient)";
}
if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital - Stubbs Road";
}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}

ArrayList record = getSmsRecord(searchYear, type);
HashMap<String, String> noOfSMS = arrayList2HashMapInString(record, 1);
HashMap<String, String> noOfSMSSuccess = arrayList2HashMapInString(record, 7);
HashMap<String, String> noOfSMSHK = arrayList2HashMapInString(record, 2);
HashMap<String, String> noOfSMSHKSuccess = arrayList2HashMapInString(record, 8);
HashMap<String, String> noOfSMSChina = arrayList2HashMapInString(record, 3);
HashMap<String, String> noOfSMSChinaSuccess = arrayList2HashMapInString(record, 9);
HashMap<String, String> noOfSMSMacau = arrayList2HashMapInString(record, 4);
HashMap<String, String> noOfSMSMacauSuccess = arrayList2HashMapInString(record, 10);
HashMap<String, String> noOfSMSOthers = arrayList2HashMapInString(record, 5);
HashMap<String, String> noOfSMSOthersSuccess = arrayList2HashMapInString(record, 11);
HashMap<String, String> noOfPatient = arrayList2HashMapInString(record, 6);
HashMap<String, String> noOfPatientSuccess = arrayList2HashMapInString(record, 12);
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
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%String PageTitle = "SMS Report"; %>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=funID %>" />
	<jsp:param name="displayTitle" value="<%=displayTitle %>" />
	<jsp:param name="category" value="Report" />
</jsp:include>

<form name="search_form" action="smsReportByYear.jsp" method="post">
<table  width="100%">.
	<tr class="bigText">
		<td width="30%"></td>
		<%DateFormat shortFormat = DateFormat.getDateTimeInstance( DateFormat.LONG, DateFormat.SHORT);  %>
		<td  width="70%" align="right">Print Date/Time: <%= shortFormat.format(new java.util.Date())%></td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="bigText">
		<td colspan="4" align="center"><%=site %></td>
	</tr>
	<tr class="bigText">
		<td colspan="4" align="center">SMS Report</td>
	</tr>	
	<tr class="smallText" >
		<td class="infoLabel" width="30%">For Year</td>
		<td class="infoData" width="70%" >
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
<input type="hidden" name="type" value="<%=type %>">
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
	<tr class="warning">
		<td align="center">No. of SMS (Success/Sent)<br/>YTM</td>
<%=parseTable(noOfSMS, noOfSMSSuccess) %>
	</tr>
	<tr>
		<td align="center">No. of SMS (HK)<br/>YTM</td>
<%=parseTable(noOfSMSHK, noOfSMSHKSuccess) %>
	</tr>
	<tr>
		<td align="center">No. of SMS (China)<br/>YTM</td>
<%=parseTable(noOfSMSChina, noOfSMSChinaSuccess) %>
	</tr>
	<tr>
		<td align="center">No. of SMS (Macau)<br/>YTM</td>
<%=parseTable(noOfSMSMacau, noOfSMSMacauSuccess) %>
	</tr>
	<tr>
		<td align="center">No. of SMS (Others)<br/>YTM</td>
<%=parseTable(noOfSMSOthers, noOfSMSOthersSuccess) %>
	</tr>
	<tr>
		<td align="center">No. of Patient<br/>YTM</td>
<%=parseTable(noOfPatient, noOfPatientSuccess) %>
	</tr>
</table>

<script language="javascript">
<!--//
	function submitSearch() {
		document.forms["search_form"].submit();
	}
//-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>