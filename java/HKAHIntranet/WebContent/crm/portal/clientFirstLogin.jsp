<%@ page import="com.hkah.web.common.*"%>
<%@ page import="org.apache.struts.action.*"%>
<%@ page import="org.apache.struts.util.*"%>
<%
UserBean userBean = new UserBean(request);

String loginIDChanged = (String)request.getAttribute("loginIDChanged");

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
<%if("true".equals(loginIDChanged)){%>
<script language="javascript">
	parent.parent.location.reload();
</script>	
<%}%>

<html:html xhtml="true" lang="true">
<jsp:include page="header.jsp"/>
<body>
<jsp:include page="title.jsp" flush="false">
	<jsp:param name="title" value="Change Login ID and Password for first time logging in" />
</jsp:include>
<font color="red"><html:errors/></font>
<font color="blue"><html:messages id="messages" message="true"><bean:write name="messages"/></html:messages></font>
<html:form action="/CRMChangeLoginID.do" focus="loginID" onsubmit="return submitAction();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr>
		<td class="crmField2" width="30%">Original Login ID</td>
		<td style="background-color:#E3E3EE;" width="70%"><%=userBean.getLoginID() %></td>
	</tr>
	<tr class="smallText">
		<td class="crmField2" width="30%">New Login ID</td>
		<td class="crmData2" width="70%">
			<html:text property="newLoginID" value="" size="30" maxlength="30"/>
			<span style="margin-left:20px;color:red">Max. 30 characters</span>
		</td>
	</tr>		
	<tr class="smallText">
		<td class="crmField2" width="30%"><bean:message key="prompt.new.password" /></td>
		<td class="crmData2" width="70%">
			<html:password property="password" value="" size="30" maxlength="10"/>
			<span style="margin-left:20px;color:red">Max. 10 characters</span>
		</td>
	</tr>
	<tr class="smallText">
		<td class="crmField2" width="30%"><bean:message key="prompt.confirm.password" /></td>
		<td class="crmData2" width="70%"><html:password property="confirmPassword" value="" size="30" maxlength="10"/></td>
	</tr>
</table>
<input type="hidden" name="module" value="crm.portal"/>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button  type="submit"  class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				<bean:message key="button.save" /> - Change Login ID and Password
			</button>		
		</td>
	</tr>
</table>
</html:form>
<bean:define id="newLoginIDLabel">New Login ID</bean:define>
<bean:define id="newPasswordLabel"><bean:message key="prompt.password" /></bean:define>
<bean:define id="confirmPasswordLabel"><bean:message key="prompt.confirm.password" /></bean:define>
<script language="javascript">
	$.validator.addMethod("cannotBeLMC", function(value, element, param) {		
	    if(value.substring(0, 3) == "LMC"){
	     return false;
	      }else{
	          return true;
	     }   
	});
	
	// validate signup form on keyup and submit
	$("#CRMChangeLoginIDForm").validate({
		 onkeyup: false,
		rules: {			
			newLoginID: {
				required: {
			        depends:function(){
			            $(this).val($.trim($(this).val()));
			            return true;
			        }
		    	}, minlength: 1 ,maxlength:30,cannotBeLMC: true},
			password: { required: true, minlength: 1 ,maxlength:10},
			confirmPassword: { required: true, minlength: 1 ,maxlength:10}
			
		},
		messages: {
			newLoginID: {				
				required: "<bean:message key="errors.required" arg0="<%=newLoginIDLabel %>" />",
				minlength: "<bean:message key="errors.minlength" arg0="<%=newLoginIDLabel %>" arg1="1" />",
				maxlength: "<bean:message key="errors.maxlength" arg0="<%=newLoginIDLabel %>" arg1="30" />",
				cannotBeLMC: "Login ID Cannot Start with 'LMC'"
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
		if (document.forms["CRMChangeLoginIDForm"].elements["newLoginID"].value == "") {
			document.forms["CRMChangeLoginIDForm"].elements["newLoginID"].focus();
			return false;
		}
		if (document.forms["CRMChangeLoginIDForm"].elements["newLoginID"].value.length < 1) {
			document.forms["CRMChangeLoginIDForm"].elements["newLoginID"].focus();
			return false;
		}
		if (document.forms["CRMChangeLoginIDForm"].elements["newLoginID"].value.length > 30) {
			document.forms["CRMChangeLoginIDForm"].elements["newLoginID"].focus();
			return false;
		}
		if (document.forms["CRMChangeLoginIDForm"].elements["password"].value == "") {
			document.forms["CRMChangeLoginIDForm"].elements["password"].focus();
			return false;
		}
		if (document.forms["CRMChangeLoginIDForm"].elements["password"].value.length < 1) {
			document.forms["CRMChangeLoginIDForm"].elements["password"].focus();
			return false;
		}
		if (document.forms["CRMChangeLoginIDForm"].elements["password"].value.length > 10) {
			document.forms["CRMChangeLoginIDForm"].elements["password"].focus();
			return false;
		}
		if (document.forms["CRMChangeLoginIDForm"].elements["confirmPassword"].value == "") {
			document.forms["CRMChangeLoginIDForm"].elements["confirmPassword"].focus();
			return false;
		}
		if (document.forms["CRMChangeLoginIDForm"].elements["confirmPassword"].value.length < 1) {
			document.forms["CRMChangeLoginIDForm"].elements["confirmPassword"].focus();
			return false;
		}
		if (document.forms["CRMChangeLoginIDForm"].elements["confirmPassword"].value.length > 10) {
			document.forms["CRMChangeLoginIDForm"].elements["confirmPassword"].focus();
			return false;
		}
		if (document.forms["CRMChangeLoginIDForm"].elements["password"].value != document.forms["CRMChangeLoginIDForm"].elements["confirmPassword"].value) {
			alert("<bean:message key="error.confirmPassword.invalid" />");
			document.forms["CRMChangeLoginIDForm"].elements["confirmPassword"].focus();
			return false;
		}		
		return true;
	}
</script>

</body>
</html:html>