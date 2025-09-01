<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String status = request.getParameter("status");
String reqNo = request.getParameter("reqNo");

String command = request.getParameter("command");

String message = request.getParameter("message");
if (message == null) {
	message = "";	
}
String errorMessage = "";

if ("delete".equals(command)){
	if (RequestDB.delete(reqNo)) {
		message = "Request deleted.";
	} else {
		errorMessage = "Request delete fail.";
	}
	request.setAttribute("request_list", RequestDB.getRequestList(userBean, status, null));
} else {
	request.setAttribute("request_list", RequestDB.getRequestList(userBean, status, reqNo));
}
	
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
	<jsp:param name="pageTitle" value="function.worksheet.maintenance" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="post" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqNo" /></td>
		<td class="infoData" width="80%">
			<input type="textfield" name="reqNo" id="reqNo" maxlength="10" size="10" >
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="80%">
			<input type="radio" name="status" value="" checked>All
			<input type="radio" name="status" value="Live Run"<%="Live Run".equals(status)?" checked":"" %>>Live Run
			<input type="radio" name="status" value="Cancelled"<%="Cancelled".equals(status)?" checked":"" %>>Cancelled
			<input type="radio" name="status" value="In Progress"<%="In Progress".equals(status)?" checked":"" %>>In Progress
			<input type="radio" name="status" value="Hold"<%="Hold".equals(status)?" checked":"" %>>Hold
			<input type="radio" name="status" value="Reject"<%="Reject".equals(status)?" checked":"" %>>Reject
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
			<button type="reset"><bean:message key="button.clear" /></button>
			<button onclick="return submitAction('new', '');"><bean:message key="button.add" /></button>
		</td>
	</tr>
</table>
</form>
<bean:define id="functionLabel"><bean:message key="function.worksheet.maintenance" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="request.jsp" method="post">
<display:table id="row" name="requestScope.request_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column property="fields5" titleKey="prompt.reqDate" style="width:8%" />
	<display:column property="fields0" titleKey="prompt.reqNo" style="width:7%" />
	<display:column property="fields1" titleKey="prompt.description" style="width:46%" />
	<display:column property="fields3" titleKey="prompt.reqBy" style="width:19%" />
	<display:column property="fields4" titleKey="prompt.status" style="width:7%">
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:14%; text-align:center">
		<button onclick="return submitAction('edit', '<c:out value="${row.fields0}" />');"><bean:message key='button.edit' /></button>
		<button onclick="return deleteAction('<c:out value="${row.fields0}" />');"><bean:message key='button.delete' /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</form>
<script language="javascript">
<!--
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		return false;
	}

	function submitAction(cmd, req) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&reqNo=" + req);
		return false;
	}
	
	function deleteAction(req) {
		document.form1.action = "request_list.jsp?command=delete&reqNo=" + req;
		document.form1.submit();
		return false;
	}
-->	
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>