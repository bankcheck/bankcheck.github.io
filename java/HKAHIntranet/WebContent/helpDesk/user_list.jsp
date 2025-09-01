<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.util.PasswordUtil"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.ReportableListObject"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="org.apache.commons.codec.binary.Hex"%>
<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String uid = ParserUtil.getParameter(request, "uid");
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

boolean synAction = false;
boolean synPwAction = false;
if ("syn".equals(command)) {
	synAction = true;
} else if ("synPw".equals(command)) {
	synPwAction = true;
}

try {
	if ("1".equals(step)) {
		if (synAction) {
			boolean success = HelpDeskDB.synchronizePortalUser();
			if (success) {
				message = "Staff account synchronization finish.";
			} else {
				message = "Staff account synchronization failed.";
			}
		} else if (synPwAction) {
			boolean success = HelpDeskDB.synchronizePortalPassword(uid);
			if (success) {
				message = (uid == null || uid.isEmpty() ? "" : "Staff ID: " + uid + " ") + "Password synchronization finish.";
			} else {
				message = (uid == null || uid.isEmpty() ? "" : "Staff ID: " + uid + " ") + "Password synchronization failed.";
			}
		}
	}
} catch (Exception e) {
	e.printStackTrace();
	errorMessage = "Synchronization fail.";
}


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
	<jsp:param name="pageTitle" value="function.helpDesk.user.list" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="mustLogin" value="Y" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="post" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">User ID</td>
		<td class="infoData" width="70%"><input type="text" name="userId" value="" maxlength="10" size="50" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Department</td>
		<td class="infoData" width="70%">
			<select name="deptCode">
				<option value=""></option>
				<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
					<jsp:param name="includeAllDept" value="Y" />
					<jsp:param name="allowAll" value="Y" />
				</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Name</td>
		<td class="infoData" width="70%"><input type="text" name="name" value="" maxlength="30" size="50" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">User Type</td>
		<td class="infoData" width="70%">
			<select name="userType">
				<jsp:include page="../ui/helpDeskUserTypeCMB.jsp" flush="false">
				<jsp:param name="allowEmpty" value="Y" />
				</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Login Status</td>
		<td class="infoData" width="70%">
			<select name="loginStatus">
				<jsp:include page="../ui/helpDeskLoginStatusCMB.jsp" flush="false">
				<jsp:param name="allowEmpty" value="Y" />
				</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Enabled</td>
		<td class="infoData" width="70%">
			<select name="enabled">
				<option value="1" selected>Yes</option>
				<option value="0">No (Password cleared)</option>
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
<form name="form1" action="<html:rewrite page="/helpDesk/user.jsp" />" method="post">
<span id="user_list_result"></span>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '', '');"><bean:message key="function.helpDesk.user.create" /></button></td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0" style="background-color: #BCA9F5;">
	<tr>
		<td>
<button onclick="return submitAction('syn', '');">Insert new Portal users to Help Desk</button>
		</td>
		<td>
Add user ID same as Portal staff ID (all lowercase)
		</td>
	</tr>
	<tr>
		<td>		
<button onclick="return submitAction('synPw', '');">Synchronize All Password</button>
		</td>
		<td>
Reset password same as Portal for all Help Desk users if it links to portal staff ID
		</td>
</tr>
</table>
<input type="hidden" name="command" /> 
<input type="hidden" name="step" />
<input type="hidden" name="uid" />
</form>
<script language="javascript">
	$(document).ready(function() {

	});

	// ajax
	var http = createRequestObject();

	function submitSearch() {
		var userId = document.search_form.userId.value;
		var deptCode = document.search_form.deptCode.value;
		var name = document.search_form.name.value;
		var userType = document.search_form.userType.value;
		var loginStatus = document.search_form.loginStatus.value;
		var enabled = document.search_form.enabled.value;
		
		//show loading image
		document.getElementById("user_list_result").innerHTML = '<img src="../images/wait30trans.gif">';

		//make a connection to the server ... specifying that you intend to make a GET request
		//to the server. Specifiy the page name and the URL parameters to send
		//http.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
		http.open('get', 'user_list_result.jsp?userId=' + userId + '&deptCode=' + deptCode + '&name=' + name + '&userType=' + userType + '&loginStatus=' + loginStatus + '&enabled=' + enabled + '&timestamp=' + new Date().getTime());

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function submitAction(cmd, uid) {
		if (cmd == 'syn') {
			document.form1.command.value = cmd;
			document.form1.uid.value = uid;
			document.form1.step.value = "1";
			document.form1.action = "";
			
			showLoadingBox('body', 500, $(window).scrollTop());
			
			document.form1.submit();
			return false;
		} else if (cmd == 'synPw') {
			var param = {
					userid:	uid,
					action: cmd
					};
			
			$.getJSON('user_action.jsp', param, function(data) {
				var items = [];
					$.each(data, function(key, val) {
						if (key == 'message') {
							alert(val);
						}
					});
			});
			return false;
		}
		callPopUpWindow(document.form1.action + "?command=" + cmd +"&userid=" + uid);
		return false;
	}

	function clearSearch() {
		document.search_form.userId.value = "";
		document.search_form.deptCode.value = "";
		document.search_form.name.value = "";
		document.search_form.userType.value = "";
		document.search_form.loginStatus.value = "";
		document.search_form.enabled.options.selectedIndex = 0;
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