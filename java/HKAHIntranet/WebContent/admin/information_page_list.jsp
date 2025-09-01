<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
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

String infoCategory = request.getParameter("infoCategory");

// Disallow search all for non-admin users
infoCategory = (infoCategory == null && userBean.isAdmin()) ? "" : infoCategory;
String allowAll = userBean.isAdmin() ? ConstantsVariable.YES_VALUE : null;
String allowEmpty = ConstantsVariable.YES_VALUE.equals(allowAll) ? null : ConstantsVariable.YES_VALUE;

ArrayList info_list = new ArrayList();
if (infoCategory != null) {
	infoCategory = "".equals(infoCategory) ? null : infoCategory;
	info_list = InformationDB.getList(infoCategory,100);
}
request.setAttribute("info_list", info_list);

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
	<jsp:param name="pageTitle" value="function.info.list" />
	<jsp:param name="category" value="prompt.admin" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.category" /></td>
		<td class="infoData" width="70%">
			<select name="infoCategory">
<jsp:include page="../ui/infoCategoryCMB.jsp" flush="false">
	<jsp:param name="infoCategory" value="<%=infoCategory %>" />
	<jsp:param name="allowAll" value="<%=allowAll %>" />
	<jsp:param name="allowEmpty" value="<%=allowEmpty %>" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
		</td>
	</tr>
</table>
</form>
<form name="form1" action="<html:rewrite page="/admin/information.jsp" />" method="post">
<bean:define id="functionLabel"><bean:message key="function.info.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.info_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column titleKey="prompt.category" style="width:10%">
		<%	try {
			%><bean:message key="<%=((ReportableListObject)row).getValue(2) %>" /><%
			} catch (Exception e) {
				%><%=((ReportableListObject)row).getValue(1) %><%
			}
		%>
	</display:column>
	<display:column property="fields2" titleKey="prompt.type" style="width:10%"/>
	<display:column property="fields3" titleKey="prompt.description" style="width:30%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.info.create" /></button></td>
	</tr>
</table>
</form>
<script language="javascript">
<!--
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.infoCategory.value = "";
	}

	function submitAction(cmd, cid, nid) {
		if (cmd == 'create') {
			cid = document.search_form.infoCategory.value;
		}
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&infoCategory=" + cid + "&infoID=" + nid);
		return false;
	}
	
-->
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>