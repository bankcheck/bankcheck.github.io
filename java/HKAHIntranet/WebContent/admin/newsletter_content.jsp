<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String patientType = request.getParameter("patientType");
UserBean userBean = new UserBean(request);
String enlID = request.getParameter("enlID");
String Dept = request.getParameter("Dept");
if(patientType != null){
	request.setAttribute("issue_list",ENewsletterDB.getIssueContent(enlID,patientType,Dept));
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
	<jsp:param name="pageTitle" value="E-Newsletter" />
</jsp:include>

<form name="search_form" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Patient Type</td>
		<td class="infoData" width="70%">
			<select name="Dept">
			<jsp:include page="../ui/enewsletterDeptCMB.jsp" flush="false">
			<jsp:param name="Dept" value="<%=Dept %>" />
			<jsp:param name="enlID" value="<%=enlID %>" />
			<jsp:param name="patientType" value="<%=patientType %>" /> 			
			</jsp:include>
			</select>
		</td>
	</tr>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>

<form name="form1" action="<html:rewrite page="/admin/newsletter.jsp" />" method="post">
<%if (patientType != null) { %>
<bean:define id="functionLabel">E-Newsletter</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.issue_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields2" title="Department" style="width:20%"/>
	<display:column property="fields0" title="Title" style="width:65%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view','<%=patientType %>','<%=enlID %>','<c:out value="${row.fields2}" />','<c:out value="${row.fields3}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<%} %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"></td>
		<td align="center"><button onclick="return submitAction('create','<%=patientType %>','<%=enlID %>','','');">Create E-Newsletter Content</button></td>
	</tr>
</table>
<input type="hidden" name="command" />
</form>

<script language="javascript">

function submitSearch() {
	document.search_form.submit();
}

function clearSearch() {
	document.search_form.Dept.value = "";
}
function submitAction(cmd, ptype, eid, dept, cid) {
	if (cmd == 'create') {
		dept = document.search_form.Dept.value;
	}
	
	callPopUpWindow(document.form1.action + "?command=" + cmd + "&patientType=" + ptype + "&enlID=" + eid + "&Dept="+dept+"&contentID="+cid);
	return false;
}


</script>
</DIV>
</DIV>
</DIV>
</body>
</html:html>