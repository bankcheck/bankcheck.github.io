<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getMobileBooking(String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("select list_date, sum(no_of_appt_thr_app), sum(no_of_linkup), sum(ttl_appt), nvl(sum(no_of_appt_thr_app)/sum(ttl_appt), 0) ");
		sqlStr.append("from ");
		sqlStr.append(" ( select to_char(b.bkgfdate, 'yyyy-mm-dd') as list_date, ");
		sqlStr.append("    count(b.patno) as no_of_appt_thr_app, ");
		sqlStr.append("    0 as no_of_linkup, ");
		sqlStr.append("    0 as ttl_appt ");
		sqlStr.append("  from booking@IWEB b ");
		sqlStr.append("  where b.bkgfdate >= TO_DATE(? || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("  and b.bkgfdate <= TO_DATE(? || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("  and b.bkgsts <> 'C' ");
		sqlStr.append("  and b.usrid = 'MOBILE' ");
		sqlStr.append("  group by to_char(b.bkgfdate, 'yyyy-mm-dd') ");
		sqlStr.append("union ");
		sqlStr.append("select to_char(p.APPLINKUPTIME, 'yyyy-mm-dd') as list_date, ");
		sqlStr.append("    0 as no_of_appt_thr_app, ");
		sqlStr.append("    count(p.patno) as no_of_linkup, ");
		sqlStr.append("    0 as ttl_appt ");
		sqlStr.append("  from patient_extra@IWEB p ");
		sqlStr.append("  where p.applinkuptime >= TO_DATE(? || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("  and p.applinkuptime  <= TO_DATE(? || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("  group by to_char(p.applinkuptime, 'yyyy-mm-dd') ");
		sqlStr.append("union ");
		sqlStr.append("  select to_char(b.bkgfdate, 'yyyy-mm-dd') as list_date, ");
		sqlStr.append("    0 as no_of_appt_thr_app, ");
		sqlStr.append("    0 as no_of_linkup, ");
		sqlStr.append("    count(b.patno) as ttl_appt ");
		sqlStr.append("  from booking@IWEB b ");
		sqlStr.append("  where b.bkgfdate >= TO_DATE(? || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("  and b.bkgfdate <= TO_DATE(? || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("  and b.bkgsts <> 'C' ");
		sqlStr.append("  group by to_char(b.bkgfdate, 'yyyy-mm-dd') ");
		sqlStr.append(")  data ");
		sqlStr.append("group by list_date ");
		sqlStr.append("order by list_date ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {dateFrom, dateTo, dateFrom, dateTo, dateFrom, dateTo});
	}
%>
<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

String reportStartDate = request.getParameter("reportStartDate");
String reportEndDate = request.getParameter("reportEndDate");
// default search current date
if (reportStartDate == null || reportStartDate.length() == 0) {
	reportStartDate = DateTimeUtil.getCurrentDate();
}
if (reportEndDate == null || reportEndDate.length() == 0) {
	reportEndDate = DateTimeUtil.getCurrentDate();
}

int appt_thr_app = 0;
int no_of_linkup = 0;
int total_appt = 0;
ArrayList record = getMobileBooking(reportStartDate, reportEndDate);
ReportableListObject row_rec = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row_rec = (ReportableListObject) record.get(i);
		appt_thr_app += Integer.parseInt(row_rec.getValue(1));
		no_of_linkup += Integer.parseInt(row_rec.getValue(2));
		total_appt += Integer.parseInt(row_rec.getValue(3));
	}
}
ReportableListObject row_total = new ReportableListObject(5);
row_total.setValue(0, "Total:");
row_total.setValue(1, String.valueOf(appt_thr_app));
row_total.setValue(2, String.valueOf(no_of_linkup));
row_total.setValue(3, String.valueOf(total_appt));
row_total.setValue(4, String.valueOf((float) appt_thr_app/total_appt));
record.add(row_total);

request.setAttribute("mobile_app_list", record);

%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Mobile App Report" />
</jsp:include>

<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<form name="search_form" method="post" >
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Date Period</td>
		<td class="infoData" width="70%">
			<input type="text" name="reportStartDate" id="reportStartDate" class="datepickerfield" value="<%=reportStartDate == null ? "" : reportStartDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
			-
			<input type="text" name="reportEndDate" id="reportEndDate" class="datepickerfield" value="<%=reportEndDate == null ? "" : reportEndDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /><br>
			(DD/MM/YYYY) - (DD/MM/YYYY)
		</td>
	</tr>
</table>

<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>

<bean:define id="functionLabel">Mobile App report</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.mobile_app_list" export="false" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%">
		<logic:notEqual name="row" property="fields0" value="Total:">
			<%=pageContext.getAttribute("row_rowNum")%>)
		</logic:notEqual>
	</display:column>
	<display:column property="fields0" title="List Date" style="width:15%;text-align:center" />
	<display:column property="fields1" title="# of appt thr app" style="width:20%;text-align:center" />
	<display:column property="fields2" title="# of linkup" style="width:20%;text-align:center" />
	<display:column property="fields3" title="Total Appt" style="width:20%;text-align:center" />
	<display:column title="Usage %" style="width:20%;text-align:center">
		<fmt:formatNumber type="percent" maxIntegerDigits="3" minFractionDigits="2" value="${row.fields4}"/>
	</display:column>
</display:table>

<script language="javascript">
	function submitSearch() {
		if (document.search_form.reportStartDate.value == '') {
			alert('Empty Start Date.');
			document.search_form.reportStartDate.focus();
			return false;
		} else if (document.search_form.reportEndDate.value == '') {
			alert('Empty End Date.');
			document.search_form.reportEndDate.focus();
			return false;
		}
		document.search_form.submit();
		return true;
	}

	function clearSearch() {
		document.search_form.reportStartDate.value = "<%=reportStartDate %>";
		document.search_form.reportEndDate.value = "<%=reportEndDate %>";
		return true;
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>