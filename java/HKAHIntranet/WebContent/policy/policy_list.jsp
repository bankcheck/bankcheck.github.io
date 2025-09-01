<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
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

String prNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "prNo"));
String prName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "prName"));
String sortBy = request.getParameter("sortBy");
String skipHeader = request.getParameter("skipHeader");
int sortByInt = 0;

try {
	sortByInt = Integer.parseInt(sortBy);
} catch (Exception e) {}

request.setAttribute("policy_reminder_list", PolicyReminderDB.getList(userBean, prNo, prName, sortByInt));


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
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html:html xhtml="true" lang="true">
<%if (!"Y".equals(skipHeader)) { %>
	<jsp:include page="../common/header.jsp"/>
<% } %>
<body>
<%
String keepRef = "Y";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.policy_reminder.list" />
	<jsp:param name="keepReferer" value="<%=keepRef %>" />
</jsp:include>

<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<%
/*
	search_form is not working in www-server, but cannot delete it
	user search_form_policy_reminder_list instead
*/
%>
<form id="search_form_policy_reminder_list" name="search_form_policy_reminder_list" method="post">

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">

	<tr class="smallText">
		<td class="infoLabel" width="30%">
			<bean:message key="prompt.prNo" />
		</td>
		<td class="infoData" width="70%">
			<input type="text" name="prNo" value="<%=prNo == null ? "" : prNo %>" size="50" />
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">
			<bean:message key="prompt.prName" />
		</td>
		<td class="infoData" width="70%">
			<input type="text" name="prName" value="<%=prName == null ? "" : prName %>" size="100" />
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Sort By</td>
		<td class="infoData" width="70%">
			<select name="sortBy">
				<option value="0" <%=sortByInt == 0 ? " selected=\"selected\"" : "" %>>Created Date (Chronological Order)</option>
				<option value="1" <%=sortByInt == 1 ? " selected=\"selected\"" : "" %>>Review Date (Chronological Order)</option>
				<option value="2" <%=sortByInt == 2 ? " selected=\"selected\"" : "" %>>Review Date (Reverse Chronological Order)</option>
			</select>
		</td>
	</tr>
</table>
	<br><b><font size="2" color="blue">N.B. Email reminder will be sent 90, 60 or 30 days before the Review Date of each reminder.
	If it is expired, the email reminder will be sent daily until review finish.</font></b></br>
	<br></br>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>


<form name="form1_policy_reminder" action="<html:rewrite page="/policy/policy_reminder.jsp" />" method="post">
<%if (prNo != null || prName != null) { %>
<bean:define id="functionLabel"><bean:message key="function.policy_reminder.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.policy_reminder_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>

	<display:column property="fields1" titleKey="prompt.prNo" style="width:10%"/>
	<display:column property="fields2" titleKey="prompt.prName" style="width:10%"/>
	<display:column property="fields3" titleKey="prompt.prOwner" style="width:10%"/>
	<%--<display:column property="fields4" titleKey="prompt.prEmail" style="width:10%"/> --%>
	<display:column property="fields5" titleKey="prompt.prToBeReviewedDate" style="width:10%"/>
	<%--<display:column property="fields6" titleKey="prompt.prSuggestedReference" style="width:10%"/> --%>
	<%--<display:column property="fields7" titleKey="prompt.createdDate" style="width:10%"/> --%>

	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<%--<button onclick="return submitAction('view', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button> --%>
		<button onclick="return submitAction('view', '<c:out value="${row.fields1}" />', '<c:out value="${fn:escapeXml(row.fields2)}" />', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>

		<% // temp solution to single quote/double quote in policy name %>
		<c:set var="prName" value="${row.fields2}"/>
		<% String prNameRow = (String)pageContext.getAttribute("prName"); %>
		<%--<button onclick="return submitAction('view', '<c:out value="${row.fields1}" />', '<%=prNameRow.replaceAll("'", "\\\\'").replaceAll("\"","&#034;") %>', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>--%>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<%--<display:setProperty name="sort.amount" value="list"/> --%>

</display:table>
<%} %>

<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.policy_reminder.create" /></button></td>
	</tr>
</table>
</form>
<script language="javascript">

	function submitSearch() {
		document.search_form_policy_reminder_list.submit();
	}

	function clearSearch() {
		document.search_form_policy_reminder_list.prNo.value = "";
		document.search_form_policy_reminder_list.prName.value = "";
	}

	function submitAction(cmd, prNo, prName, pid) {
		<%--alert('cmd='+cmd);--%>
		<%-- alert('cmd= ' + cmd)--%>
		<%-- alert('pid= ' + pid)--%>
		<%-- alert('prNo= ' + prNo)--%>
		<%-- alert('prName= ' + prName)--%>
		callPopUpWindow(document.form1_policy_reminder.action + "?command=" + cmd + "&prID=" + pid + "&prNo=" + prNo + "&prName=" + prName);
		return false;
	}

	// ajax
	var http = createRequestObject();

</script>
</DIV>
</DIV>
</DIV>

<%if (!"Y".equals(skipHeader)) { %>
	<jsp:include page="../common/footer.jsp" flush="false" />
<%} %>
</body>
</html:html>