<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
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
<jsp:include page="header.jsp"/>
<body>
<jsp:include page="title.jsp" flush="false">
	<jsp:param name="title" value="Change Password" />
</jsp:include>
<font color="red"><html:errors/></font>
<font color="blue"><html:messages id="messages" message="true"><bean:write name="messages"/></html:messages></font>
<html:form action="/ChangePassword.do" focus="oldPassword" onsubmit="return submitAction();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr>
		<td class="crmField2" width="30%"><bean:message key="prompt.old.password" /></td>
		<td class="crmData2" width="70%"><html:password property="oldPassword" value="" size="20"/></td>
	</tr>
	<tr class="smallText">
		<td class="crmField2" width="30%"><bean:message key="prompt.new.password" /></td>
		<td class="crmData2" width="70%"><html:password property="password" value="" size="20"/></td>
	</tr>
	<tr class="smallText">
		<td class="crmField2" width="30%"><bean:message key="prompt.confirm.password" /></td>
		<td class="crmData2" width="70%"><html:password property="confirmPassword" value="" size="20"/></td>
	</tr>
</table>
<input type="hidden" name="module" value="crm.portal"/>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button type="submit" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				<bean:message key="button.save" /> - <bean:message key="prompt.change.password" />
			</button>
		</td>
	</tr>
</table>
</html:form>
<bean:define id="oldPasswordLabel"><bean:message key="prompt.old.password" /></bean:define>
<bean:define id="newPasswordLabel"><bean:message key="prompt.password" /></bean:define>
<bean:define id="confirmPasswordLabel"><bean:message key="prompt.confirm.password" /></bean:define>
<script language="javascript">
	// validate signup form on keyup and submit
	$("#ChangePasswordForm").validate({
		event: "keyup",
		rules: {
			oldPassword: { required: true, minlength: 1 },
			password: { required: true, minlength: 1 ,maxlength:10},
			confirmPassword: { required: true, minlength: 1 ,maxlength:10}
		},
		messages: {
			oldPassword: {
				required: "<bean:message key="errors.required" arg0="<%=oldPasswordLabel %>" />",
				minlength: "<bean:message key="errors.minlength" arg0="<%=oldPasswordLabel %>" arg1="1" />"
			},
			password: {
				required: "<bean:message key="errors.required" arg0="<%=newPasswordLabel %>" />",
				minlength: "<bean:message key="errors.minlength" arg0="<%=newPasswordLabel %>" arg1="1" />",
				maxlength: "<bean:message key="errors.maxlength" arg0="<%=newPasswordLabel %>" arg1="10" />"
			},
			confirmPassword: {
				required: "<bean:message key="errors.required" arg0="<%=confirmPasswordLabel %>" />",
				minlength: "<bean:message key="errors.minlength" arg0="<%=confirmPasswordLabel %>" arg1="1" />",
				maxlength: "<bean:message key="errors.maxlength" arg0="<%=confirmPasswordLabel %>" arg1="10" />"
			}
		}
	});

	function submitAction() {
		if (document.forms["ChangePasswordForm"].elements["oldPassword"].value == "") {
			document.forms["ChangePasswordForm"].elements["oldPassword"].focus();
			return false;
		}
		if (document.forms["ChangePasswordForm"].elements["oldPassword"].value.length < 1) {
			document.forms["ChangePasswordForm"].elements["oldPassword"].focus();
			return false;
		}
		if (document.forms["ChangePasswordForm"].elements["password"].value == "") {
			document.forms["ChangePasswordForm"].elements["password"].focus();
			return false;
		}
		if (document.forms["ChangePasswordForm"].elements["password"].value.length < 1) {
			document.forms["ChangePasswordForm"].elements["password"].focus();
			return false;
		}
		if (document.forms["ChangePasswordForm"].elements["confirmPassword"].value == "") {
			document.forms["ChangePasswordForm"].elements["confirmPassword"].focus();
			return false;
		}
		if (document.forms["ChangePasswordForm"].elements["confirmPassword"].value.length < 1) {
			document.forms["ChangePasswordForm"].elements["confirmPassword"].focus();
			return false;
		}
		if (document.forms["ChangePasswordForm"].elements["password"].value != document.forms["ChangePasswordForm"].elements["confirmPassword"].value) {
			alert("<bean:message key="error.confirmPassword.invalid" />");
			document.forms["ChangePasswordForm"].elements["confirmPassword"].focus();
			return false;
		}
		return true;
	}
</script>

</body>
</html:html>