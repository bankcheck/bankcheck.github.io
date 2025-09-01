<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String deptCode = request.getParameter("deptCode");
if (deptCode == null || "".equals(deptCode)) {
	deptCode = userBean.getDeptCode();
}
boolean allowAll = false; //userBean.isSuperManager();
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="displayTitle" value="Access Control List (Per User)" />
	<jsp:param name="pageTitle" value="function.accessControlPerUser.list" />
	<jsp:param name="category" value="prompt.admin" />
</jsp:include>
<form name="search_form" action="access_control_list_per_user.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
			<select name="deptCode">
<% if (allowAll) { %>
				<option value="all"<%="all".equals(deptCode)?" selected":"" %>>--- All Department ---</option>
<% } %>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>

<input type="hidden" name="command" value="">
</form>
<span id="access_control_list_per_user_result" />
<script language="javascript">

	function submitSearch() {
		var deptCode = document.search_form.deptCode.options[document.search_form.deptCode.selectedIndex].value;

		//show loading image
		document.getElementById("access_control_list_per_user_result").innerHTML = '<img src="../images/wait30trans.gif">';

		$.ajax({
			type: "POST",
			url: "access_control_list_per_user_result.jsp",
			data: "deptCode=" + deptCode,
			success: function(values) {
			if (values != '') {
				document.getElementById("access_control_list_per_user_result").innerHTML = values;
			}//if
			},//success
			timeout: 60000
		});//$.ajax

		return false;
	}

	function clearSearch() {
		document.search_form.staffID.value = '';
	}

	$(document).ready(function() {
		$('input').filter('.datepickerfieldOverride').datepicker({
			showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg",
			beforeShow: function(input, inst)
			{
				inst.dpDiv.css({marginTop: '-95px', marginLeft: '105px'});
			}
		});
	});
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>