<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.displaytag.tags.*"%>
<%@ page import="org.displaytag.util.*"%>
<%
UserBean userBean = new UserBean(request);
if (!userBean.isAdmin()) {
	return;
}

String command = ParserUtil.getParameter(request, "command");
// Validate the request parameters specified by the user
String staffId = ParserUtil.getParameter(request, "staffId");
String oldPassword = ParserUtil.getParameter(request, "oldPassword");
String newPassword = ParserUtil.getParameter(request, "newPassword");
String confirmPassword = ParserUtil.getParameter(request, "confirmPassword");

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

if ("reset".equals(command)){
	try {
		if (!newPassword.equals(confirmPassword)) {
			message = "confirm password invalid.";
		} else if (!UtilDBWeb.isExist(
				"SELECT 1 FROM CO_USERS WHERE (CO_USERNAME = ? OR CO_STAFF_ID = ?) AND CO_PASSWORD = ?",
				new String[] { staffId, staffId, PasswordUtil.cisEncryption(oldPassword) })) {
			message = "original password invalid.";
		} else if (!UtilDBWeb.isExist(
				"SELECT 1 FROM CO_USERS WHERE (CO_USERNAME = ? OR CO_STAFF_ID = ?) AND CO_SITE_CODE = ?",
				new String[] { staffId, staffId, ConstantsServerSide.SITE_CODE })) {
			message = "site invalid.";
		} else if (UtilDBWeb.updateQueue(
				"UPDATE CO_USERS " +
				"SET    CO_PASSWORD = ?, " +
				"       CO_MODIFIED_DATE = SYSDATE, " +
				"       CO_MODIFIED_USER = ? " +
				"WHERE  (CO_USERNAME = ? OR CO_STAFF_ID = ?) ",
				new String[] { PasswordUtil.cisEncryption(newPassword), userBean.getLoginID(), staffId, staffId } )) {
			// update password
			message = "Password is updated.";
		} else {
			message = "Password update fail.";
		}
	} catch (Exception e) {
		message = "Server error.";
		e.printStackTrace();
	}
}
%>
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>

<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="prompt.change.password" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<font color="red"><html:errors/></font>
<font color="blue"><html:messages id="messages" message="true"><bean:write name="messages"/></html:messages></font>
<form name="form1" action="adminResetPassword.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="70%"><input type="text" name="staffId" id="staffId" value="<%=staffId == null ? "" : staffId %>" maxlength="200" size="100" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.old.password" /></td>
		<td class="infoData" width="70%"><input type="password" name="oldPassword" id="oldPassword" value="" maxlength="200" size="100" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.new.password" /></td>
		<td class="infoData" width="70%"><input type="password" name="newPassword" id="newPassword" value="" maxlength="200" size="100" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.confirm.password" /></td>
		<td class="infoData" width="70%"><input type="password" name="confirmPassword" id="confirmPassword" value="" maxlength="200" size="100" /></td>
	</tr>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button type="submit">
				<bean:message key="button.save" /> - <bean:message key="prompt.change.password" />
			</button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" value="reset" />
</form>
<script language="javascript">
	// validate signup form on keyup and submit

	function submitAction() {
		if (document.forms["ChangePasswordForm"].elements["oldPassword"].value == "") {
			document.forms["ChangePasswordForm"].elements["oldPassword"].focus();
			return false;
		}
		if (document.forms["ChangePasswordForm"].elements["newPassword"].value == "") {
			document.forms["ChangePasswordForm"].elements["newPassword"].focus();
			return false;
		}
		if (document.forms["ChangePasswordForm"].elements["confirmPassword"].value == "") {
			document.forms["ChangePasswordForm"].elements["confirmPassword"].focus();
			return false;
		}
		return true;
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>