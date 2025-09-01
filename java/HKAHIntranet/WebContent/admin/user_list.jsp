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
	<jsp:param name="pageTitle" value="function.user.list" />
	<jsp:param name="category" value="prompt.admin" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="post" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.site" /></td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/siteCodeRDB.jsp" flush="false">
	<jsp:param name="allowAll" value="Y" />
	<jsp:param name="siteCode" value="<%=userBean.getSiteCode() %>" />
</jsp:include>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
			<select name="deptCode">
				<option value="">--- All Departments ---</option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="70%"><input type="textfield" name="staffID" value="" maxlength="10" size="50"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="70%"><input type="textfield" name="lastName" value="" maxlength="30" size="50"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="70%"><input type="textfield" name="firstName" value="" maxlength="60" size="50"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Enabled</td>
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
<form name="form1" action="<html:rewrite page="/admin/user.jsp" />" method="post">
<span id="user_list_result"></span>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '', '', '');"><bean:message key="function.user.create" /></button></td>
	</tr>
</table>
</form>
<script language="javascript">
	function submitSearch() {
		var siteCode, staffID, deptCode, lastName, firstName, enabled;
		var e = document.search_form.elements["siteCode"];
		for (var i = 0; i < e.length; i++) {
			if (e[i].checked) {
				siteCode = e[i].value;
			}
		}
		staffID = document.search_form.staffID.value;
		deptCode = document.search_form.deptCode.options[document.search_form.deptCode.selectedIndex].value;
		lastName = document.search_form.lastName.value;
		firstName = document.search_form.firstName.value;
		enabled = document.search_form.enabled.value;

		//show loading image
		document.getElementById("user_list_result").innerHTML = "<img src='../images/wait30trans.gif'>";

		$.ajax({
			type: "POST",
			url: "user_list_result.jsp",
			data: "siteCode=" + siteCode + "&deptCode=" + deptCode + "&staffID=" + staffID + "&lastName=" + lastName + "&firstName=" + firstName + "&enabled=" + enabled,
			success: function(values) {
				document.getElementById("user_list_result").innerHTML = values;
			}//success
		});//$.ajax

		return false;
	}

	function submitAction(cmd, uid, sid, eid) {
		if (cmd == 'login') {
			$.ajax({
				type: "POST",
				url: "user_login.jsp",
				data: "command=" + cmd + "&staffID=" + sid,
				success: function(values) {
					if (values == '') {
						top.frames['bigcontent'].location.reload();
					} else {
						alert("Fail to switch " + sid + "!");
					}
				}//success
			});//$.ajax
		} else {
			callPopUpWindow(document.form1.action + "?command=" + cmd + "&userName=" + uid + "&staffID=" + sid + "&enabled=" + eid);
		}
		return false;

	}

	function clearSearch() {
		document.search_form.staffID.value = "";
		document.search_form.lastName.value = "";
		document.search_form.firstName.value = "";
		return false;
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>