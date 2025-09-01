<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getMobileBooking(String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(B.BKGFDATE, 'DD/MM/YYYY HH24:MI:SS'), B.PATNO ");
		sqlStr.append("FROM   BOOKING@IWEB B ");
		sqlStr.append("WHERE  B.BKGFDATE >= TO_DATE(? || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND    B.BKGFDATE <= TO_DATE(? || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND    B.BKGSTS = 'F' ");
		sqlStr.append("ORDER BY B.BKGFDATE ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { dateFrom, dateTo });
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

request.setAttribute("sample_list", getMobileBooking(reportStartDate, reportEndDate));

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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Sample Report" />
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


<bean:define id="functionLabel">Sample report</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.sample_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Date" style="width:50%" />
	<display:column property="fields1" title="Patient No" style="width:45%" />
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