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
	<jsp:param name="pageTitle" value="prompt.reset.password" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="red"><html:errors/></font>
<font color="blue"><html:messages id="messages" message="true"><bean:write name="messages"/></html:messages></font>
<html:form action="/ResetPassword.do" focus="email" onsubmit="return submitAction();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="70%"><html:text property="staffID" size="30"/></td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.email" /></td>
		<td class="infoData" width="70%"><html:text property="email" size="30"/></td>
	</tr>
	<tr class="smallText">
		<td align="center" colspan="2"><button type="submit"><bean:message key="prompt.reset.password" /></button></td>
	</tr>
	

	
</table>
</html:form>
<script language="javascript">
	// validate signup form on keyup and submit
	$("#ResetPasswordForm").validate({
		rules: {
		  	staffID: { required: true, staffID:true },
			email: { required: true, email:true }	
	
		},
		messages: {
			email: { required: "<bean:message key="error.email.required" />", email: "<bean:message key="error.email.invalid" />" },
			staffID: { required: "<bean:message key="error.staffID.required" />", email: "<bean:message key="error.staffID.invalid" />" }

		}				
	});
	

	function submitAction() {
		if (document.forms["ResetPasswordForm"].elements["staffID"].value == "") {
			alert('Empty Emp No.');
			document.forms["ResetPasswordForm"].elements["staffID"].focus();
			return false;
		}
		if (document.forms["ResetPasswordForm"].elements["email"].value == "") {
			alert("<bean:message key="error.email.required" />");
			document.forms["ResetPasswordForm"].elements["email"].focus();
			return false;
		}
	}
</script>
<br>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>