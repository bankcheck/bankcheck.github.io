<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String haaID = request.getParameter("HaaID");
String enabled = request.getParameter("enabled");

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

boolean archiveAction = false;

if ("archive".equals(command)) {
	archiveAction = true;
}

try {
	if (archiveAction) {
		// archive ha
		if (HAACheckListDB.archive(userBean, haaID)) {
			message = "Corporation archived.";
			archiveAction = false;
		} else {
			errorMessage = "Corporation archive fail.";
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (enabled == null) {
	enabled = ConstantsVariable.ONE_VALUE;
}

// clear all expired file
HAACheckListDB.expiredContract(userBean);

request.setAttribute("check_list", HAACheckListDB.getList( userBean, enabled ));

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
	<jsp:param name="pageTitle" value="function.haa.list" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="search_form" action="check_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Status</td>
		<td class="infoData" width="70%">
			<select name="enabled">
				<option value="">All</option>
				<option value="1"<%="1".equals(enabled)?" selected":"" %>>Normal</option>
				<option value="2"<%="2".equals(enabled)?" selected":"" %>>Archive</option>
			</select>
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
<bean:define id="functionLabel"><bean:message key="function.haa.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="check_list.jsp" method="post">
<display:table id="row" name="requestScope.check_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" title="Corporation Name" style="width:20%"/>
	<display:column title="Business Type" style="width:10%">
		<logic:equal name="row" property="fields2" value="NB">
			New Business
		</logic:equal>
		<logic:equal name="row" property="fields2" value="RB">
			Renewal Business
		</logic:equal>
		<logic:equal name="row" property="fields2" value="PM">
			Promotion
		</logic:equal>
	</display:column>
	<display:column title="Contract Date" style="width:10%">
		<c:out value="${row.fields3}" /> - <c:out value="${row.fields4}" />
	</display:column>
	<display:column title="Status" style="width:5%">
		<logic:equal name="row" property="fields5" value="0">
			Deleted
		</logic:equal>
		<logic:equal name="row" property="fields5" value="1">
			Normal
		</logic:equal>
		<logic:equal name="row" property="fields5" value="2">
			Archive
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key='button.view' /></button>
<% if (userBean.isAccessible("function.haa.update")) { %>
		<logic:equal name="row" property="fields5" value="1">
			<button onclick="return submitAction('archive', '<c:out value="${row.fields0}" />');"><bean:message key='label.archive' /></button>
		</logic:equal>
<% } %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<% if (userBean.isAccessible("function.haa.create")) { %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.haa.create" /></button></td>
	</tr>
</table>
<% } %>
<input type="hidden" name="command">
<input type="hidden" name="HaaID">
</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
	}

	function submitAction(cmd, haaid) {
		if (cmd == 'archive') {
			document.form1.command.value = cmd;
			document.form1.HaaID.value = haaid;
			document.form1.submit();
			return true;
		} else {
			callPopUpWindow("checkitem.jsp?command=" + cmd + "&HaaID=" + haaid);
			return false;
		}
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>