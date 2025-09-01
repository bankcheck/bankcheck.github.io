<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String category = "title.education";
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

String elearningID = request.getParameter("elearningID");
String eventID = null;
String topic = null;
String questionNumPerTest = null;
String passGrade = null;
String deptCode = request.getParameter("deptCode");

String message = "";
String errorMessage = "";

try {
	// load data from database
	if (elearningID != null && elearningID.length() > 0) {
		ArrayList record = ELearning.get(elearningID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			eventID = row.getValue(0);
			topic = row.getValue(1);
			questionNumPerTest = row.getValue(2);
			passGrade = row.getValue(3);

			request.setAttribute("elearning_list", EnrollmentDB.getAttendedClass("education", eventID, null, elearningID, "staff", null, deptCode, date_from, date_to));
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
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
	<jsp:param name="pageTitle" value="function.eLesson.view" />
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="elearning_result_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.topic" /></td>
		<td class="infoData" width="70%"><%=topic %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.passGrade" /></td>
		<td class="infoData"><%=passGrade %>/<%=questionNumPerTest %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="35%" colspan="3">
			<select name="deptCode">
				<option value=""><bean:message key="label.selectAllDepartment" /></option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" value="<%=date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			-
			<input type="textfield" name="date_to" id="date_to" value="<%=date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)<br>
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
<input type="hidden" name="elearningID" value="<%=elearningID %>"/>
</form>
<bean:define id="functionLabel"><bean:message key="function.classEnrollment.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="elearning_result.jsp" method="post">
<display:table id="row" name="requestScope.elearning_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.staffName" style="width:25%">
		<c:out value="${row.fields9}" /> (<c:out value="${row.fields6}" />)
	</display:column>
	<display:column titleKey="prompt.department" style="width:25%">
		<c:out value="${row.fields10}" />
	</display:column>
	<display:column titleKey="prompt.attendDate" style="width:10%">
		<c:out value="${row.fields7}" /> <c:out value="${row.fields8}" />
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<logic:equal name="row" property="fields11" value="">
			<button disabled><bean:message key="button.view" /></button>
		</logic:equal>
		<logic:notEqual name="row" property="fields11" value="">
			<button onclick="return submitAction('<c:out value="${row.fields2}" />', '<c:out value="${row.fields6}" />');"><bean:message key="button.view" /></button>
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</form>
<script language="javascript">
<!--
	function submitSearch(){
		if (document.search_form.date_from.value == "") {
			alert("<bean:message key="error.date.required" />.");
			document.search_form.date_from.focus();
			return false;
		}
		if (document.search_form.date_to.value == "") {
			alert("<bean:message key="error.date.required" />.");
			document.search_form.date_to.focus();
			return false;
		}
		document.search_form.submit();
	}

	function clearSearch() {
	}

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

	function submitAction(eid, sid) {
		callPopUpWindow(document.form1.action + "?command=&eventID=<%=eventID %>&elearningID=<%=elearningID %>&enrollID=" + eid + "&staffID=" + sid);
		return false;
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>