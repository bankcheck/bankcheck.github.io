<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String status = request.getParameter("status");
request.setAttribute("summary_list", ProjectSummaryDB.getList(userBean, status));

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
	<jsp:param name="pageTitle" value="function.projectSummary.list" />
	<jsp:param name="category" value="group.pmp" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="post" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="80%">
			<input type="radio" name="status" value="" checked><bean:message key="label.active" />
			<input type="radio" name="status" value="preparation"<%="preparation".equals(status)?" checked":"" %>><bean:message key="label.preparation" />
			<input type="radio" name="status" value="launch"<%="launch".equals(status)?" checked":"" %>><bean:message key="label.launch" />
			<input type="radio" name="status" value="pilotRun"<%="pilotRun".equals(status)?" checked":"" %>><bean:message key="label.pilotRun" />
			<input type="radio" name="status" value="monitoring"<%="monitoring".equals(status)?" checked":"" %>><bean:message key="label.monitoring" />
			<input type="radio" name="status" value="close"<%="close".equals(status)?" checked":"" %>><bean:message key="label.close" />
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
			<button type="reset"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<bean:define id="functionLabel"><bean:message key="function.projectSummary.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="summary.jsp" method="post">
<display:table id="row" name="requestScope.summary_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" titleKey="prompt.description" style="width:30%" />
	<display:column property="fields3" titleKey="prompt.requestFrom" style="width:25%" />
	<display:column titleKey="prompt.status" style="width:10%">
		<logic:equal name="row" property="fields5" value="preparation">
			<bean:message key="label.preparation" />
		</logic:equal>
		<logic:equal name="row" property="fields5" value="launch">
			<bean:message key="label.launch" />
		</logic:equal>
		<logic:equal name="row" property="fields5" value="pilotRun">
			<bean:message key="label.pilotRun" />
		</logic:equal>
		<logic:equal name="row" property="fields5" value="monitoring">
			<bean:message key="label.monitoring" />
		</logic:equal>
		<logic:equal name="row" property="fields5" value="close">
			<bean:message key="label.close" />
		</logic:equal>
	</display:column>
	<display:column property="fields6" titleKey="prompt.modifiedDate" style="width:20%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key='button.view' /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	if (userBean.isAccessible("function.projectSummary.create")) { %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.projectSummary.create" /></button></td>
	</tr>
</table>
<%	} %>
</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		return false;
	}

	function submitAction(cmd, pid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&projectID=" + pid);
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>