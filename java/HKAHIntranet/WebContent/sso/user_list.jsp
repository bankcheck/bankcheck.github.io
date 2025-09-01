<%@ page import="com.hkah.web.common.*"%>
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
	<jsp:param name="pageTitle" value="function.ssoUser.list" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="mustLogin" value="Y" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="post" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">SSO User ID</td>
		<td class="infoData" width="70%"><input type="text" name="ssoUserId" value="" maxlength="10" size="50" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Staff No</td>
		<td class="infoData" width="70%"><input type="text" name="staffNo" value="" maxlength="10" size="50" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Name / 中文姓名</td>
		<td class="infoData" width="70%"><input type="text" name="name" value="" maxlength="30" size="50" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Active</td>
		<td class="infoData" width="70%">
			<select name="enabled">
				<option value="1" selected>Yes</option>
				<option value="0">No</option>
			</select>
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
<form name="form1" action="<html:rewrite page="/sso/user.jsp" />" method="post">
<span id="user_list_result"></span>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '', '');"><bean:message key="function.ssoUser.create" /></button></td>
	</tr>
</table>
</form>
<script language="javascript">
	// ajax
	var http = createRequestObject();

	function submitSearch() {
		var ssoUserId = document.search_form.ssoUserId.value;
		var staffNo = document.search_form.staffNo.value;
		var name = document.search_form.name.value;
		var enabled = document.search_form.enabled.value;
		
		//show loading image
		document.getElementById("user_list_result").innerHTML = '<img src="../images/wait30trans.gif">';

		//make a connection to the server ... specifying that you intend to make a GET request
		//to the server. Specifiy the page name and the URL parameters to send
		//http.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
		http.open('post', 'user_list_result.jsp?ssoUserId=' + ssoUserId + '&staffNo=' + staffNo + '&name=' + name + '&enabled=' + enabled + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function submitAction(cmd, uid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&ssoUserId=" + uid);
		return false;
	}

	function clearSearch() {
		document.search_form.ssoUserId.value = "";
		document.search_form.name.value = "";
		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){

			//read and assign the response from the server
			var response = http.responseText;

			//do additional parsing of the response, if needed

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("user_list_result").innerHTML = response;

			//If the server returned an error message like a 404 error, that message would be shown within the div tag!!.
			//So it may be worth doing some basic error before setting the contents of the <div>
		}
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>