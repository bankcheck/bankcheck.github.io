<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);

String eventDesc = request.getParameter("eventDesc");
request.setAttribute("event_list", ScheduleDB.getList("crm", null, eventDesc, "ORDER BY CS.CO_SCHEDULE_START DESC"));
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
<jsp:include page="../common/header.jsp" />
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
<form name="search_form" action="event_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.event" /></td>
		<td class="infoData" width="70%"><input type="textfield" name="eventDesc" value="<%=eventDesc==null?"":eventDesc %>" maxlength="100" size="50"></td>
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
<form name="form1" action="event.jsp" method="post">
<display:table id="row" name="requestScope.event_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields3" titleKey="prompt.event" style="width:25%" />
	<display:column property="fields8" titleKey="prompt.eventDate" style="width:15%" />
	<display:column titleKey="prompt.available" style="width:15%">
		<logic:equal name="row" property="fields13" value="0">
			<c:out value="${row.fields14}" /> <bean:message key="label.enrolled" />
		</logic:equal>
		<logic:notEqual name="row" property="fields13" value="0">
			<c:out value="${row.fields15}" />/<c:out value="${row.fields13}" />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.status" style="width:20%">
		<logic:equal name="row" property="fields17" value="open">
			<bean:message key="label.open" />
		</logic:equal>
		<logic:equal name="row" property="fields17" value="suspend">
			<bean:message key="label.suspend" />
		</logic:equal>
		<logic:equal name="row" property="fields17" value="close">
			<bean:message key="label.close" />
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<% if (userBean.isAccessible("function.event.view")) { %>
			<button onclick="return submitAction('view', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />');"><bean:message key="button.view" /></button>
		<% } else { %>
			N/A
		<% } %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%
	if (userBean.isAccessible("function.event.create")) {
%>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '', '');"><bean:message key="function.event.create" /></button></td>
	</tr>
</table>
<%
	}
%>
</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.eventDesc.value = '';
	}

	function submitAction(cmd, cid, sid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&eventID=" + cid + "&scheduleID=" + sid);
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>