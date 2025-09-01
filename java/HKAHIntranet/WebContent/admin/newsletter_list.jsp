<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String patientType = request.getParameter("patientType");
UserBean userBean = new UserBean(request);
if(patientType != null){
	request.setAttribute("issue_list",ENewsletterDB.getIssue(patientType));
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
			<select name="patientType">
			<option value="1"<%="1".equals(patientType)?" selected":"" %>>Type A</option>
			<option value="2"<%="2".equals(patientType)?" selected":"" %>>Type B</option>
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

<form name="form1" action="<html:rewrite page="/admin/newsletter_list.jsp" />" method="post">
<%if (patientType != null) { %>
<bean:define id="functionLabel">E-Newsletter</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.issue_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" title="Newsletter Title" style="width:85%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '<%=patientType %>');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<%} %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"></td>
		<td align="center"><button onclick="return submitAction('create', '');">Create E-Newsletter</button></td>
	</tr>
	<tr class="smallText">
		<td align="center"></td>
		    <td align="center" class="infoData" width="70%"><input type="text" name="email" value="" maxlength="50" size="25" /><font color="blue"><span id="showEmail_indicator"></span></font>
			<button onclick="return submitAction('email', '');" class="btn-click">Email</button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" />
</form>

<script language="javascript">

function submitSearch() {
	document.search_form.submit();
}

function clearSearch() {
	document.search_form.patientType.value = "";
}
function submitAction(cmd, eid,ptype) {
	if (cmd == 'email') {
		var email = document.form1.email.value;
		if (email.length > 0) {
			submitEmail();
		}
	}
	else{
		callPopUpWindow("newsletter_content.jsp?command=" + cmd + "&enlID=" + eid + "&patientType=" + ptype);
		
	} 
	return false;
}

var http = createRequestObject();

function submitEmail() {
	var email = document.form1.email.value;

	if (email.length > 0) {
		http.open('get', 'newsletter_email.jsp?email=' + email + '&timestamp=<%=(new java.util.Date()).getTime()%>+&enlID=1&patientType=1');

		//assign a handler for the response
		http.onreadystatechange = processResponseEmail;

		//actually send the request to the server
		http.send(null);
	} else {
		alert('Empty email.');
		document.form1.email.focus();
	}
}
function processResponseEmail() {
	//check if the response has been received from the server
	if (http.readyState == 4){
		//read and assign the response from the server
		var response = http.responseText;

		//in this case simply assign the response to the contents of the <div> on the page.
		document.getElementById("showEmail_indicator").innerHTML = response;
	}
}

</script>
</DIV>
</DIV>
</DIV>
</body>
</html:html>