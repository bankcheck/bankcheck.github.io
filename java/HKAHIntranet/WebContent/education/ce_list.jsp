<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
HashMap statusDesc = new HashMap();
statusDesc.put("O", MessageResources.getMessage(session, "label.waiting.for.approve"));
statusDesc.put("M", MessageResources.getMessage(session, "label.waiting.for.admin.confirm"));
statusDesc.put("A", MessageResources.getMessage(session, "label.waiting.for.hr.confirm"));
statusDesc.put("H", MessageResources.getMessage(session, "label.confirmed"));
statusDesc.put("R", MessageResources.getMessage(session, "label.rejected"));
statusDesc.put("C", MessageResources.getMessage(session, "label.cancelled"));

UserBean userBean = new UserBean(request);

String category = "title.education";
String deptCode = request.getParameter("deptCode");
int current_yy = DateTimeUtil.getCurrentYear();
String date_from = request.getParameter("date_from");
if (date_from == null || date_from.length() == 0) {
	date_from = "01/01/" + current_yy;
}
String date_to = request.getParameter("date_to");
if (date_to == null || date_to.length() == 0) {
	date_to = "31/12/" + current_yy;
}

request.setAttribute("ce_list", CE.getList(userBean, deptCode, date_from, date_to));

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
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.ce.list" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="ce_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
<%if (userBean.isAdmin() || userBean.isAuthor()){ %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
			<select name="deptCode">
				<option value="">--- All Departments ---</option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
</jsp:include>
			</select>
		</td>
	</tr>
<%} else {
	deptCode = userBean.getDeptCode();
}%>
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
<bean:define id="functionLabel"><bean:message key="function.ce.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="ce_form" action="ce.jsp" method="post">
<display:table id="row" name="requestScope.ce_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.staffID" style="width:25%">
		<c:out value="${row.fields1}" /> (<c:out value="${row.fields2}" />, <c:out value="${row.fields3}" />)
	</display:column>
	<display:column property="fields4" titleKey="prompt.date" style="width:20%" />
	<display:column titleKey="prompt.dayOrHour" style="width:15%">
		<c:out value="${row.fields5}" /> <bean:message key="prompt.dayOrHour" />
	</display:column>
	<display:column titleKey="prompt.status" style="width:15%">
		<%=statusDesc.get(((ReportableListObject)pageContext.getAttribute("row")).getFields6()) %>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', 0);"><bean:message key='button.view' /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	if (false) { %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.ce.create" /></button></td>
	</tr>
</table>
<%	} %>
</form>
<script language="javascript">
<!--
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
	}

	function submitAction(cmd, ceid, stp) {
		callPopUpWindow(document.ce_form.action + "?command=" + cmd + "&ceID=" + ceid + "&step=" + stp);
		return false;
	}
-->
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>