<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getAlertList() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  BKAID, BKADESC ");
		sqlStr.append("FROM    BOOKINGALERT@IWEB ");
		sqlStr.append("WHERE ( BKAQUOTAD = -1 ) ");
		sqlStr.append("AND     BKASTS = -1 ");
		sqlStr.append("AND   ( GET_CURRENT_STECODE@IWEB = 'TWAH' OR BKAID NOT IN ('35')) ");
		sqlStr.append("ORDER BY BKAORD ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getQuotaCheckList(String bkaid, String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT H.HPTYPE, H.HPKEY, H.HPSTATUS, H.HPRMK ");
		sqlStr.append("FROM   HPSTATUS@IWEB H ");
		sqlStr.append("INNER JOIN BOOKINGALERT@IWEB A ON H.HPKEY = A.BKAID ");
		sqlStr.append("WHERE  H.HPTYPE like 'QUOTA%' ");
		sqlStr.append("AND    H.HPKEY = ? ");
		sqlStr.append("AND (( A.BKAQUOTAD = -1 ");
		sqlStr.append("AND    TO_DATE(H.HPSTATUS, 'DD/MM/YYYY') >= TO_DATE(?, 'DD/MM/YYYY') ");
		sqlStr.append("AND    TO_DATE(H.HPSTATUS, 'DD/MM/YYYY') <= TO_DATE(?, 'DD/MM/YYYY') ) ");
		sqlStr.append("OR   ( A.BKAQUOTAM = -1 ");
		sqlStr.append("AND    TO_DATE('01/' || H.HPSTATUS, 'DD/MM/YYYY') >= TO_DATE('01/' || ?, 'DD/MM/YYYY') ");
		sqlStr.append("AND    TO_DATE('01/' || H.HPSTATUS, 'DD/MM/YYYY') <= TO_DATE('01/' || ?, 'DD/MM/YYYY') )) ");
		sqlStr.append("AND    H.HPACTIVE = A.BKASTS ");
		sqlStr.append("AND    A.BKASTS = -1 ");
		sqlStr.append("ORDER BY H.HPSDATE ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { bkaid, dateFrom, dateTo, dateFrom.substring(3, 10), dateTo.substring(3, 10) });
	}
%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
boolean createAction = false;
if ("create".equals(command)) {
	createAction = true;
}

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String bkaid = ParserUtil.getParameter(request, "bkaid");
String[] current_month = DateTimeUtil.getCurrentMonthRange();

String dateFrom_dd = ParserUtil.getParameter(request, "dateFrom_dd");
String dateFrom_mm = ParserUtil.getParameter(request, "dateFrom_mm");
String dateFrom_yy = ParserUtil.getParameter(request, "dateFrom_yy");
String dateFrom = current_month[0];
if (dateFrom_dd!= null && dateFrom_mm != null && dateFrom_yy != null) {
	try {
		dateFrom = dateFrom_dd + "/" + dateFrom_mm + "/" + dateFrom_yy;
		Date dateFromDate = DateTimeUtil.parseDate(dateFrom);
	} catch (Exception e) {
		e.printStackTrace();
		dateFrom = current_month[0];
	}
}

String dateTo_dd = ParserUtil.getParameter(request, "dateTo_dd");
String dateTo_mm = ParserUtil.getParameter(request, "dateTo_mm");
String dateTo_yy = ParserUtil.getParameter(request, "dateTo_yy");
String dateTo = current_month[1];
if (dateTo_dd != null && dateTo_mm != null && dateTo_yy != null) {
	try {
		dateTo = dateTo_dd + "/" + dateTo_mm + "/" + dateTo_yy;
		Date dateToDate = DateTimeUtil.parseDate(dateTo);
	} catch (Exception e) {
		e.printStackTrace();
		dateTo = current_month[1];
	}
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

request.setAttribute("quota_check_list", getQuotaCheckList(bkaid, dateFrom, dateTo));

ReportableListObject row2 = null;
ArrayList record = null;
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.hats.quotaCheck.list" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="search_form" action="quota_check_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
		<tr class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Initial Assessed: </td>
			<td class="infoData" width="70%">
				<select name="bkaid"><%
			record = getAlertList();
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row2 = (ReportableListObject) record.get(i);
%><option value="<%=row2.getValue(0) %>"<%=row2.getValue(0).equals(bkaid)?" selected":"" %>><%=row2.getValue(1) %></option><%
				}
			}
%></select>
			</td>
		</tr>
		<tr class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Date Range: </td>
			<td class="infoData" width="70%">
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="dateFrom" />
	<jsp:param name="date" value="<%=dateFrom %>" />
	<jsp:param name="isShowNextYear" value="Y" />
	<jsp:param name="isFromCurrYear" value="Y" />
</jsp:include> -
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="dateTo" />
	<jsp:param name="date" value="<%=dateTo %>" />
	<jsp:param name="isShowNextYear" value="Y" />
	<jsp:param name="isFromCurrYear" value="Y" />
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

<form name="form1" action="quota_check_list.jsp" method="post">
<display:table id="row" name="requestScope.quota_check_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column title="Date" style="width:25%" media="html"><c:out value="${row.fields2}" /></display:column>
	<display:column title="Quota" style="width:25%" media="html"><c:out value="${row.fields3}" /></display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields2}" />');"><bean:message key="button.view" /></button>
	</display:column>
</display:table>
<%if (userBean.isAccessible("function.hats.quotaCheck.update")) { %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.hats.quotaCheck.create" /></button></td>
	</tr>
</table>
<%} %>
</form>
</DIV>

</DIV>
</DIV>
<script>
function submitSearch() {
	document.search_form.submit();
}

function clearSearch() {
	document.search_form.bkaid.value = '';
}

function submitAction(cmd, hptype, hpkey, hpstatus) {
	if (cmd == 'create' || cmd == 'view') {
		callPopUpWindow("quota_check.jsp?command=" + cmd + "&hptype=" + hptype + "&hpkey=" + hpkey + "&hpstatus=" + hpstatus);
		return false;
	}
}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
