<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);

String eventCategory = request.getParameter("eventCategory");
String eventType = request.getParameter("eventType");

String[] current_year = DateTimeUtil.getCurrentYearRange();
String date_from = request.getParameter("date_from");
if (date_from == null || date_from.length() == 0) {
	date_from = DateTimeUtil.getRollDate(current_year[0], 0, 0, 0);
}
String date_to = request.getParameter("date_to");
if (date_to == null || date_to.length() == 0) {
	date_to = current_year[1];
}
String[] current_month = DateTimeUtil.getCurrentMonthRange();
String curent_date = DateTimeUtil.getCurrentDate();

request.setAttribute("event_enrollment_list", ScheduleDB.getListByDate("crm", null, eventCategory, eventType, date_from, date_to));

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.event.list" />
	<jsp:param name="category" value="group.crm" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="event_enrollment_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
			<input type="radio" name="eventCategory" value="" checked><bean:message key="label.all" />
			<input type="radio" name="eventCategory" value="lmc"<%="lmc".equals(eventCategory)?" checked":"" %>><bean:message key="department.520" />
			<input type="radio" name="eventCategory" value="chaplaincy"<%="chaplaincy".equals(eventCategory)?" checked":"" %>><bean:message key="department.660" />
			<input type="radio" name="eventCategory" value="foundation"<%="foundation".equals(eventCategory)?" checked":"" %>><bean:message key="department.670" />
			<input type="radio" name="eventCategory" value="marketing"<%="marketing".equals(eventCategory)?" checked":"" %>><bean:message key="department.750" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.eventType" /></td>
		<td class="infoData" width="70%">
			<input type="radio" name="eventType" value="" checked><bean:message key="label.all" />
			<input type="radio" name="eventType" value="seminar"<%="seminar".equals(eventType)?" checked":"" %>>Seminar
			<input type="radio" name="eventType" value="newstart"<%="newstart".equals(eventType)?" checked":"" %>>Newstart
			<input type="radio" name="eventType" value="funfit"<%="funfit".equals(eventType)?" checked":"" %>>Funfit
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			-
			<input type="textfield" name="date_to" id="date_to" class="datepickerfield" value="<%=date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)<br>
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(1);"><bean:message key="label.today" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(2);"><bean:message key="label.thisMonth" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(3);" checked><bean:message key="label.thisYear" />
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
<bean:define id="functionLabel"><bean:message key="function.event.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="event_enrollment.jsp" method="post">
<display:table id="row" name="requestScope.event_enrollment_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.department" style="width:20%">
		<logic:equal name="row" property="fields5" value="lmc">
			<bean:message key="department.520" />
		</logic:equal>
		<logic:equal name="row" property="fields5" value="marketing">
			<bean:message key="department.750" />
		</logic:equal>
		<logic:equal name="row" property="fields5" value="chaplaincy">
			<bean:message key="department.660" />
		</logic:equal>
		<logic:equal name="row" property="fields5" value="foundation">
			<bean:message key="department.670" />
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.eventDescription" style="width:20%">
		<c:out value="${row.fields3}" />
		<logic:notEqual name="row" property="fields4" value="">
			(<c:out value="${row.fields4}" />)
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.eventDate" style="width:15%">
		<c:out value="${row.fields8}" />
	</display:column>
	<display:column titleKey="prompt.available" style="width:10%">
		<logic:equal name="row" property="fields13" value="0">
			<c:out value="${row.fields14}" /> <bean:message key="label.enrolled" />
		</logic:equal>
		<logic:notEqual name="row" property="fields13" value="0">
			<c:out value="${row.fields15}" />/<c:out value="${row.fields13}" />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<logic:equal name="row" property="fields14" value="0">
			N/A
		</logic:equal>
		<logic:notEqual name="row" property="fields14" value="0">
			<button onclick="return submitAction('view', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />');"><bean:message key='button.view' /></button>
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="eventID">
<input type="hidden" name="scheduleID">
</form>
<script language="javascript">
<!--
	function setDateRange(select) {
		if (select == 1) {
			document.search_form.date_from.value = '<%=curent_date %>';
			document.search_form.date_to.value = '<%=curent_date %>';
		} else if (select == 2) {
			document.search_form.date_from.value = '<%=current_month[0] %>';
			document.search_form.date_to.value = '<%=current_month[1] %>';
		} else if (select == 3) {
			document.search_form.date_from.value = '<%=current_year[0] %>';
			document.search_form.date_to.value = '<%=current_year[1] %>';
		}
	}

	function submitSearch(eid, sid) {
		document.search_form.eventID = eid;
		document.search_form.scheduleID = sid;
		document.search_form.submit();
	}

	function clearSearch() {
	}

	function submitAction(cmd, eid, sid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&eventID=" + eid + "&scheduleID=" + sid);
		return false;
	}
-->
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>