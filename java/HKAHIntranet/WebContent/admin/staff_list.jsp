<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.StaffDB"%>
<%@ page import="com.hkah.web.db.SsoUserDB"%>
<%
UserBean userBean = new UserBean(request);
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String staffIds = ParserUtil.getParameter(request, "staffIds");

boolean synAction = false;
boolean batchDelete = false;
if ("syn".equals(command)) {
	synAction = true;
} else if ("batchDelete".equals(command)) {
	batchDelete = true;
}

try {
	if ("1".equals(step)) {
		if (synAction && userBean.isAdmin()) {
			StaffDB.update();
			message = "Staff account synchronization finish.";
		} else if (batchDelete) {
			if (userBean.isAccessible("function.staff.delete")) {
				boolean successCIS = StaffDB.batchDeleteCIS(userBean, staffIds);
				boolean successHATS = StaffDB.batchDeleteHATS(userBean, staffIds);
				boolean successNIS = StaffDB.batchDeleteNIS(userBean, staffIds);
				boolean successHelpdesk = false;
				if (ConstantsServerSide.isTWAH()) {
					successHelpdesk = StaffDB.batchDeleteHelpdesk(userBean, staffIds);
				}
				boolean successRIS = StaffDB.batchDeleteRIS(userBean, staffIds);
				
				// final
				boolean success = StaffDB.batchDelete(userBean, staffIds);
				boolean successSso = SsoUserDB.batchDelete(userBean, staffIds);

				message = "";
				errorMessage = "";
				if (success) {
					message = message.isEmpty() ? message : message + "<br />";
					message += "Batch disable Intranet Portal staff success: " + staffIds;
				} else {
					errorMessage = errorMessage.isEmpty() ? errorMessage : errorMessage + "<br />";
					errorMessage += "No Portal staff is disabled.";
				}
				if (successSso) {
					message = message.isEmpty() ? message : message + "<br />";
					message += "Batch disable SSO user success: " + staffIds;
				} else {
					errorMessage = errorMessage.isEmpty() ? errorMessage : errorMessage + "<br />";
					errorMessage += "No SSO user is disabled.";
				}
				if (successHATS) {
					message = message.isEmpty() ? message : message + "<br />";
					message += "Batch disable HATS user success: " + staffIds;
				} else {
					errorMessage = errorMessage.isEmpty() ? errorMessage : errorMessage + "<br />";
					errorMessage += "No HATS user is disabled.";
				}
				if (successCIS) {
					message = message.isEmpty() ? message : message + "<br />";
					message += "Batch disable CIS user success: " + staffIds;
				} else {
					errorMessage = errorMessage.isEmpty() ? errorMessage : errorMessage + "<br />";
					errorMessage += "No CIS user is disabled.";
				}
				if (successNIS) {
					message = message.isEmpty() ? message : message + "<br />";
					message += "Batch disable NIS user success: " + staffIds;
				} else {
					errorMessage = errorMessage.isEmpty() ? errorMessage : errorMessage + "<br />";
					errorMessage += "No NIS user is disabled.";
				}
				if (ConstantsServerSide.isTWAH()) {
					if (successHelpdesk) {
						message = message.isEmpty() ? message : message + "<br />";
						message += "Batch disable Help Desk user success: " + staffIds;
					} else {
						errorMessage = errorMessage.isEmpty() ? errorMessage : errorMessage + "<br />";
						errorMessage += "No Help Desk user is disabled.";
					}
				}
				if (successRIS) {
					message = message.isEmpty() ? message : message + "<br />";
					message += "Batch disable RIS user success: " + staffIds;
				} else {
					errorMessage = errorMessage.isEmpty() ? errorMessage : errorMessage + "<br />";
					errorMessage += "No RIS user is disabled.";
				}
			} else {
				errorMessage = "You do not have permission to do batch delete.";
			}
		}
	}
} catch (Exception e) {
	e.printStackTrace();
	errorMessage = "Staff account synchronization fail.";
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
	<jsp:param name="pageTitle" value="function.staff.list" />
	<jsp:param name="category" value="prompt.admin" />
</jsp:include>
<div><font color="blue"><%=message %></font></div>
<div><font color="red"><%=errorMessage %></font></div>
<form name="search_form" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.site" /></td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/siteCodeRDB.jsp" flush="false">
	<jsp:param name="allowAll" value="Y" />
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
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
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffName" /></td>
		<td class="infoData" width="70%"><input type="textfield" name="staffName" value="" maxlength="60" size="50"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.category" /></td>
		<td class="infoData" width="70%">
			<select name="category">
<jsp:include page="../ui/categoryCMB.jsp" flush="false">
	<jsp:param name="category" value="All Category" />
	<jsp:param name="emptyLabel" value="All Category" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Override HR</td>
		<td class="infoData" width="70%">
			<select name="markdeleted">
				<option value="" selected>Ignore</option>
				<option value="N">No</option>
				<option value="Y">Yes (Keep 6 months only)</option>
				<option value="B">Yes (Board Member only)</option>
			</select>
		</td>
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
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<form name="form1" action="<html:rewrite page="/admin/staff.jsp" />" method="post">
<span id="staff_list_result"></span>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction('create', '');"><bean:message key="function.staff.create" /></button>
<% if ((!ConstantsServerSide.isAMC() && userBean.isAdmin()) || userBean.isGroupID("managerPortal.user")) { %>
			<div>
				<button class="btn-syn">Synchronize Staff (from HR System)</button>
				<button onclick="callPopUpWindow('staff_list_hr.jsp?run=1'); return false;">View HR staff list</button>
				<button onclick="callPopUpWindow('print_<%=ConstantsServerSide.SITE_CODE %>_staff<%=ConstantsServerSide.isHKAH() ? "_2018" : "" %>.jsp?run=1'); return false;">View HR staff list (Old)</button>
			</div>
<% } %>
		</td>
	</tr>
</table>


<%	if (userBean.isAccessible("function.staff.delete")) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Batch Disable Staff</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="220px">Staff ID(s)</td>
		<td class="infoData">
			Disable:<br />
			- Intranet Portal staff, user (Fix staff info, It CANNOT enable again by using "Synchronize Staff")<br />
			- SSO user<br />
			- HATS<br />
			- CMS-OP/CMS-IP user (account expire immediately)<br />
			- NIS<br />
<% if (ConstantsServerSide.isTWAH()) { %>
			- Help Desk<br />
<% } %>
			- RIS<br />
			<textarea name="staffIds" rows="2" cols="100"></textarea>
			<br />separate each by a comma(,)
		</td>
	</tr>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction('batchDelete');" class="btn-click">Batch Disable</button>
			<%if (ConstantsServerSide.isHKAH()) { %><button onclick="return goToAMC2StaffList();" class="btn-click">Go to AMC2</button><% } %>
		</td>
	</tr>
</table>
<%} %>

</div>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
</form>
<script language="javascript">
	$(document).ready(function() {
		$(".pane .btn-syn").click(function(){
			/*
			$(this).parents(".pane").animate({ backgroundColor: "#fbc7c7" }, "fast")
			.animate({ backgroundColor: "#F9F3F7" }, "slow")
			$.prompt('Are you sure to synchronize all local staff account from HR System?',{
				buttons: { Ok: true, Cancel: false },
				callback: function(v,m,f){
					if (v){
						submit: submitAction('syn', '')
						return true;
					} else {
						return false;
					}
				},
				prefix:'cleanblue'
			});
			*/
			submit: submitAction('syn', '');
			return false;
		});
	});

	// ajax
	var http = createRequestObject();

	function submitSearch() {
		var siteCode = '', deptCode, staffID, staffName, category, markdeleted, enabled;
		var e = document.search_form.elements["siteCode"];
		for (var i = 0; i < e.length; i++) {
			if (e[i].checked) {
				siteCode = e[i].value;
			}
		}
		deptCode = document.search_form.deptCode.options[document.search_form.deptCode.selectedIndex].value;
		staffID = document.search_form.staffID.value;
		staffName = document.search_form.staffName.value;
		category = document.search_form.category.value;
		markdeleted = document.search_form.markdeleted.value;
		enabled = document.search_form.enabled.value;

		//show loading image
		document.getElementById("staff_list_result").innerHTML = '<img src="../images/wait30trans.gif">';

		//make a connection to the server ... specifying that you intend to make a GET request
		//to the server. Specifiy the page name and the URL parameters to send
		http.open('get', 'staff_list_result.jsp?siteCode=' + siteCode + '&deptCode=' + deptCode + '&staffID=' + staffID + '&staffName=' + staffName + '&category=' + category + '&markdeleted=' + markdeleted + '&enabled=' + enabled + '&timestamp='+new Date().getTime());

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function clearSearch() {
		document.search_form.staffName.value = "";
	}

	function submitAction(cmd, sid, eid) {
		if (cmd == "syn" || cmd == 'batchDelete') {
			document.form1.command.value = cmd;
			document.form1.step.value = "1";
			document.form1.action = "";
			document.form1.submit();
			return true;
		} else if (cmd == "sso") {
			callPopUpWindow("../sso/user.jsp?command=viewByStaffID&staffNo=" + sid);
			return false;
		}
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&staffID=" + sid + "&enabled=" + eid);
		return false;
	}
	
	function goToAMC2StaffList() {
		var host = "<%=ConstantsServerSide.DEBUG ? "205.0.1.81" : "205.0.1.41" %>";
		callPopUpWindow("http://" + host + "/intranet/admin/staff_list.jsp");
		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){

			//read and assign the response from the server
			var response = http.responseText;

			//do additional parsing of the response, if needed

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("staff_list_result").innerHTML = response;

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