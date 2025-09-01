<%@	page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.EnrollmentDB"%>
<%
UserBean userBean = new UserBean(request);

String staffID = (String) session.getAttribute("staffID");

int current_yy = DateTimeUtil.getCurrentYear();
String date_from = request.getParameter("date_from");
if (date_from == null || date_from.length() == 0) {
	date_from = "01/01/" + current_yy;
}
String date_to = request.getParameter("date_to");
if (date_to == null || date_to.length() == 0) {
	date_to = "31/12/" + current_yy;
}

request.setAttribute("staff_education_list", 
		EnrollmentDB.getEnrolledClass("education", null, null, "staff", staffID, "1", null, null, date_from, date_to, false, null));

boolean searchAction = true;

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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.staffEducation.list" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<jsp:include page="staff_brief.jsp" flush="false">
	<jsp:param name="tabId" value="2" />
</jsp:include>
<form name="search_form" action="staff_education_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			-
			<input type="textfield" name="date_to" id="date_to" class="datepickerfield" value="<%=date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
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
<%if (searchAction) { %>
<bean:define id="functionLabel"><bean:message key="function.staff.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="staff_education.jsp" method="post">
<display:table id="row" name="requestScope.staff_education_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column title="Staff Name" media="csv excel xml pdf" style="width:10%"><c:out value="${row.fields10}" /> </display:column>
	<display:column titleKey="prompt.courseDescription" class="smallText" style="width:35%" >
		<logic:equal name="row" property="fields16" value="">
			<c:out value="${row.fields1}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields16" value="">
			<c:out value="${row.fields1}" /> - <c:out value="${row.fields16}" />
		</logic:notEqual>	
	</display:column>
	<display:column property="fields17" title="Course Category" class="smallText" style="width:5%" />
	<display:column property="fields18" title="Course Type" class="smallText" style="width:5%" />
	<display:column property="fields7" titleKey="prompt.attendDate" class="smallText" style="width:15%" />
	<display:column titleKey="prompt.testPassDate" class="smallText" style="width:15%">
		<logic:equal name="row" property="fields19" value="Y">
			<c:out value="${row.fields13}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields19" value="Y">
			N/A
		</logic:notEqual>	
	</display:column>
	<display:column titleKey="prompt.duration" style="width:10%">
		<logic:equal name="row" property="fields5" value="">
			<c:out value="N/A" />
		</logic:equal>
		<logic:notEqual name="row" property="fields5" value="">
			<c:out value="${row.fields5}" />-<c:out value="${row.fields6}" />
			( <c:out value="${row.fields22}" /> <bean:message key="label.hours" /> )	
		</logic:notEqual>		
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>

<input type="hidden" name="command" />
<input type="hidden" name="eventID" />
<input type="hidden" name="enrollID" />
</form>
<script language="javascript">
<!--
	function submitSearch() {
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
		document.search_form.date_from.value = '';
		document.search_form.date_to.value = '';
	}

	function submitAction(cmd, eid, rid) {
		document.form1.action= "staff_education.jsp";
		document.form1.command.value = cmd;
		document.form1.eventID.value = eid;
		document.form1.enrollID.value = rid;
		document.form1.submit();
	}
	-->
</script>
<%} %>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>