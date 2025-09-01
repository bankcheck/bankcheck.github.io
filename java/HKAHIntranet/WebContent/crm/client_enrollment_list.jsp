<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);

String command = request.getParameter("command");
String step = request.getParameter("step");
int current_yy = DateTimeUtil.getCurrentYear();
String date_from = request.getParameter("date_from");
if (date_from == null || date_from.length() == 0) {
	date_from = "01/01/2000";
}
String date_to = request.getParameter("date_to");
if (date_to == null || date_to.length() == 0) {
	date_to = "31/12/" + current_yy;
}
String eventID = request.getParameter("eventID");
String scheduleID = request.getParameter("scheduleID");
String enrollID = request.getParameter("enrollID");

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";

boolean takeAction = false;
boolean withdrawAction = false;

if ("take".equals(command)) {
	takeAction = true;
} else if ("withdraw".equals(command)) {
	withdrawAction = true;
}

try {
	if ("1".equals(step)) {
		if (takeAction) {
			int returnValue = EnrollmentDB.enroll(userBean, "crm", eventID, scheduleID, "patient", clientID);
			if (returnValue == 0) {
				message = "Seminar enrolled.";
			} else if (returnValue == -1) {
				errorMessage = "Seminar enrolled prevous.";
			} else {
				errorMessage = "Seminar enroll fail.";
			}
		} else if (withdrawAction) {
			int returnValue = EnrollmentDB.withdraw(userBean, "crm", eventID, scheduleID, enrollID, "patient", clientID);
			if (returnValue == 0) {
				message = "Seminar withdrawn.";
				// display other class after withdraw
				scheduleID = "";
			} else if (returnValue == -1) {
				errorMessage = "Seminar haven't enrolled yet.";
			} else {
				errorMessage = "Seminar withdraw fail.";
			}
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

request.setAttribute("attended_class_list", EnrollmentDB.getAttendedClass("crm", null, null, "patient", clientID, date_from, date_to));
request.setAttribute("enroll_class_others_list", ScheduleDB.getList("crm", null, "lmc", "patient", clientID, 1, true));
request.setAttribute("enroll_class_520_list", ScheduleDB.getList("crm", "lmc", null, "patient", clientID, 1, true));
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
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.event.list" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="4" />
</jsp:include>
<form name="search_form" action="client_enrollment_list.jsp" method="post">
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
			<!-- button onclick="lockCol('row')" id="toggle">Lock First Column</button -->
		</td>
	</tr>
</table>
<input type="hidden" name="command">
<input type="hidden" name="step" value="0">
</form>
<bean:define id="functionLabel"><bean:message key="prompt.event" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<table width="100%" border="0">
	<tr><td>&nbsp;</td></tr>
	<tr class="smallText">
		<td class="portletCaption"><bean:message key="label.attended" /></td>
	</tr>
</table>
<display:table id="row1" name="requestScope.attended_class_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row1_rowNum")%>)</display:column>
	<display:column property="fields3" titleKey="prompt.eventDescription" style="width:30%" />
	<display:column property="fields7" titleKey="prompt.attendDate" style="width:30%" />
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<button onclick="return submitAction('view', 0, '<c:out value="${row1.fields1}" />', '<c:out value="${row1.fields4}" />', '');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<form name="form1" action="client_enrollment_list.jsp" method="post">
<table width="100%" border="0">
	<tr><td>&nbsp;</td></tr>
	<tr class="smallText">
		<td class="portletCaption"><bean:message key="prompt.event" /> (<bean:message key="label.others" />)</td>
	</tr>
</table>
<display:table id="row2" name="requestScope.enroll_class_others_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row2_rowNum")%>)</display:column>
	<display:column titleKey="prompt.eventDescription" style="width:30%">
		<c:out value="${row2.fields3}" />
		<logic:notEqual name="row2" property="fields4" value="">
			(<c:out value="${row2.fields4}" />)
		</logic:notEqual>
	</display:column>
	<display:column property="fields8" titleKey="prompt.eventDate" style="width:20%" />
	<display:column titleKey="prompt.available" style="width:15%">
		<logic:equal name="row2" property="fields13" value="0">
			<c:out value="${row2.fields14}" /> <bean:message key="label.enrolled" />
		</logic:equal>
		<logic:notEqual name="row2" property="fields13" value="0">
			<c:out value="${row2.fields15}" />/<c:out value="${row2.fields13}" />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.status" style="width:10%">
		<logic:equal name="row2" property="fields16" value="">
			<bean:message key="label.notYetEnroll" />
		</logic:equal>
		<logic:notEqual name="row2" property="fields16" value="">
			<bean:message key="label.enrolled" />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<logic:equal name="row2" property="fields16" value="">
			<button onclick="return submitAction('take', 1, '<c:out value="${row2.fields2}" />', '<c:out value="${row2.fields7}" />', '');"><bean:message key="button.enroll" /></button>
		</logic:equal>
		<logic:notEqual name="row2" property="fields16" value="">
			<button onclick="return submitAction('withdraw', 1, '<c:out value="${row2.fields2}" />', '<c:out value="${row2.fields7}" />', '<c:out value="${row2.fields16}" />');"><bean:message key="button.withdraw" /></button>
			<button onclick="return submitAction('view', 0, '<c:out value="${row2.fields2}" />', '<c:out value="${row2.fields7}" />', '<c:out value="${row2.fields16}" />');"><bean:message key="button.view" /></button>
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table width="100%" border="0">
	<tr><td>&nbsp;</td></tr>
	<tr class="smallText">
		<td class="portletCaption"><bean:message key="prompt.event" /> (<bean:message key="department.520" />)</td>
	</tr>
</table>
<display:table id="row3" name="requestScope.enroll_class_520_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row3_rowNum")%>)</display:column>
	<display:column titleKey="prompt.eventDescription" style="width:30%">
		<c:out value="${row3.fields3}" />
		<logic:notEqual name="row3" property="fields4" value="">
			(<c:out value="${row3.fields4}" />)
		</logic:notEqual>
	</display:column>
	<display:column property="fields8" titleKey="prompt.eventDate" style="width:20%" />
	<display:column titleKey="prompt.available" style="width:15%">
		<logic:equal name="row3" property="fields13" value="0">
			<c:out value="${row3.fields14}" /> <bean:message key="label.enrolled" />
		</logic:equal>
		<logic:notEqual name="row3" property="fields13" value="0">
			<c:out value="${row3.fields15}" />/<c:out value="${row3.fields13}" />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.status" style="width:10%">
		<logic:equal name="row3" property="fields16" value="">
			<bean:message key="label.notYetEnroll" />
		</logic:equal>
		<logic:notEqual name="row3" property="fields16" value="">
			<bean:message key="label.enrolled" />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<logic:equal name="row3" property="fields16" value="">
			<button onclick="return submitAction('take', 1, '<c:out value="${row3.fields2}" />', '<c:out value="${row3.fields7}" />', '');"><bean:message key="button.enroll" /></button>
		</logic:equal>
		<logic:notEqual name="row3" property="fields16" value="">
			<button onclick="return submitAction('withdraw', 1, '<c:out value="${row3.fields2}" />', '<c:out value="${row3.fields7}" />', '<c:out value="${row3.fields16}" />');"><bean:message key="button.withdraw" /></button>
			<button onclick="return submitAction('view', 0, '<c:out value="${row3.fields2}" />', '<c:out value="${row3.fields7}" />', '<c:out value="${row3.fields16}" />');"><bean:message key="button.view" /></button>
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="eventID" />
<input type="hidden" name="scheduleID" />
<input type="hidden" name="enrollID" />
</form>
<script language="javascript">
<!--
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
	}

	function submitAction(cmd, stp, eid, sid, eid2) {
		if (cmd == 'view') {
			document.form1.action = "client_enrollment.jsp";
		} else {
			document.form1.action = "client_enrollment_list.jsp";
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.eventID.value = eid;
		document.form1.scheduleID.value = sid;
		document.form1.enrollID.value = eid2;
		document.form1.submit();
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>