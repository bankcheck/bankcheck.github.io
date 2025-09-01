<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.math.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.convert.*"%>
<%@ page import="java.io.*"%>
<%!
%>
<%	
UserBean userBean = new UserBean(request);

String hatsSearchCode = request.getParameter("hatsSearchCode");
String command = request.getParameter("command");

String lastNameFromSearch = "";
String givenNameFromSearch = "";

String hkidFromSearch = "";
String dobFromSearch = "";

if(hatsSearchCode != null){
	request.setAttribute("lis_doc_info", CMSDB.getLISDocInfo(hatsSearchCode));
	request.setAttribute("hats_doc_info", CMSDB.getHATSDocInfo(hatsSearchCode));
}

if("create".equals(command)){
	String hatsCode = request.getParameter("hatsCode");
	String portalLoginID = request.getParameter("portalLoginID");
	String lastName = request.getParameter("lastName");
	String givenName = request.getParameter("givenName");
	String accountPassword = request.getParameter("accountPassword");
	
	RISDB.insertSSOUserMaping(hatsCode, portalLoginID);	
	RISDB.insertSSOUser(hatsCode, portalLoginID, lastName, givenName);
	RISDB.insertPortalAccount(hatsCode, portalLoginID, lastName, givenName, accountPassword);
} else if("sendEmail".equals(command)){
	System.out.println("Send DI Email");	
	RISDB.sendRISEmails();
}

%>
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
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="DI Report" />
	<jsp:param name="isHideTitle" value="Y" />
</jsp:include>
<style>
</style>
<body style="width:100%">
<form name="search_form" action="di_email_create_user.jsp" method="post" onsubmit="return submitSearch();">
<table>
	<tr>
		<td class="infoLabel">
			Enter HATS Code
		</td>
		<td class="infoData" >
			<input type="text" name="hatsSearchCode" value="<%=hatsSearchCode == null ? "" : hatsSearchCode %>"  size="50" />
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="4" align="center">
			<button type="submit"><bean:message key="button.search" /></button>			
		</td>
	</tr>
</table>	
</form>

<display:table id="row2" name="requestScope.lis_doc_info" export="false" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row2_rowNum")%>)</display:column>
	<c:set var="lastNameFromSearch" value="${row2.fields0}"/>		
	<% lastNameFromSearch = (String)pageContext.getAttribute("lastNameFromSearch");%>
	<display:column property="fields0" title="Last Name" style="width:20%" />
	<c:set var="givenNameFromSearch" value="${row2.fields1}"/>		
	<% givenNameFromSearch = (String)pageContext.getAttribute("givenNameFromSearch");%>	
	<display:column property="fields1" title="Given Name" style="width:20%" />
	<display:column property="fields2" title="LIS Code" style="width:20%" />
	<display:column property="fields3" title="HATS Code" style="width:20%" />
</display:table>
<br>
<display:table id="row3" name="requestScope.hats_doc_info" export="false" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row3_rowNum")%>)</display:column>	
	<display:column property="fields0" title="HATS Code" style="width:20%" />
	<display:column property="fields1" title="HKID" style="width:20%" />
	<c:set var="hkidFromSearch" value="${row3.fields1}"/>		
	<% hkidFromSearch = (String)pageContext.getAttribute("hkidFromSearch");%>
	<display:column property="fields2" title="DOB (dd/mm/yyyy)" style="width:20%" />
	<c:set var="dobFromSearch" value="${row3.fields2}"/>		
	<% dobFromSearch = (String)pageContext.getAttribute("dobFromSearch");%>
	<display:column property="fields3" title="HATS MasterDocCode" style="width:20%" />
</display:table>
<br>
<hr>
<br>
<% if(!RISDB.drPortalAccExist(hatsSearchCode)){ %> 
<form name="create_form" action="di_email_create_user.jsp" method="post">
<table>
	<tr>
		<td class="infoLabel">
			HATS Code
		</td>
		<td class="infoData" >
			<input type="text" name="hatsCode" value="<%=hatsSearchCode == null ? "" : hatsSearchCode %>"  size="50" />
		</td>
	</tr>
	<tr>
		<td class="infoLabel">
			PortalLoginID
		</td>
		<td class="infoData" >
			<input type="text" name="portalLoginID" value="<%=hatsSearchCode == null ? "" : "DI-" + hatsSearchCode %>"  size="50" />
		</td>
	</tr>
	<tr>
		<td class="infoLabel">
			Dr Last Name
		</td>
		<td class="infoData" >
			<input type="text" name="lastName" value="<%=lastNameFromSearch == null ? "" : lastNameFromSearch %>"  size="50" />
		</td>
	</tr>
	<tr>
		<td class="infoLabel">
			Dr Given Name
		</td>
		<td class="infoData" >
			<input type="text" name="givenName" value="<%=givenNameFromSearch == null ? "" : givenNameFromSearch %>"  size="50" />
		</td>
	</tr>
	<tr>
		<td class="infoLabel">
			Account Password (HKID first 4 char + mm + dd)
		</td>
		<td>
<%
String hkidFirstFourChar = "";
if(hkidFromSearch != null && hkidFromSearch.length() > 0){
	hkidFirstFourChar = hkidFromSearch.substring(0, Math.min(hkidFromSearch.length(), 4));
}
String mmForPW = "";
String ddForPW = "";
if(dobFromSearch != null && dobFromSearch.length() > 0){
String[] splitDOB = dobFromSearch.split("/");
	if(splitDOB.length == 3){
		mmForPW = splitDOB[1];
		ddForPW = splitDOB[0];
}
}
%>		
			<input type="text" name="accountPassword" value="<%=hkidFirstFourChar + mmForPW + ddForPW %>" size="50" />
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="4" align="center">
			<button onclick="return submitAction('create');" class="btn-click">Create User</button>
		</td>
		<td colspan="4" align="center">
			<button onclick="return sendMailAction('sendEmail');" class="btn-click">Send Email</button>
		</td>
	</tr>
</table>	
<input type="hidden" name="command" value=""/>
<input type="hidden" name="hatsSearchCode" value="<%=hatsSearchCode%>"/>
</form>
<% } else { %>
Portal Account Exists
<% } %>
<script type="text/javascript" language="JavaScript">
function submitSearch() {
	document.search_form.submit();
}

function submitAction(cmd) {
	var hatsCode = document.forms["create_form"]["hatsCode"].value;
    if (hatsCode == null || hatsCode == "") {
        alert("HatsCode must be filled out");
        return false;
    }
    var portalLoginID = document.forms["create_form"]["portalLoginID"].value;
    if (portalLoginID == null || portalLoginID == "") {
        alert("Portal LoginID must be filled out");
        return false;
    }
    var lastName = document.forms["create_form"]["lastName"].value;
    if (lastName == null || lastName == "") {
        alert("LastName must be filled out");
        return false;
    }
    var givenName = document.forms["create_form"]["givenName"].value;
    if (givenName == null || givenName == "") {
        alert("Given Name must be filled out");
        return false;
    }
    var accountPassword = document.forms["create_form"]["accountPassword"].value;
    if (accountPassword == null || accountPassword == "") {
        alert("Account password must be filled out ");
        return false;
    } else if(accountPassword != null && accountPassword.length != 8){
    	alert("Account password format incorrect");
        return false;
    }
	document.create_form.command.value = cmd;
	return true;
}	

function sendMailAction(cmd) {	
	document.create_form.command.value = cmd;
	return true;
}	

</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>