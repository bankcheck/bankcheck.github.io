<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private void updateMembership(UserBean userBean, String clientID, String clubID, String patNo, String expiredDate, String discountCode) {
		ArrayList record = CRMClientMembershipDB.getList(clientID, clubID);
		if (record.size() > 0) {
			CRMClientMembershipDB.update(userBean, clientID, clubID, discountCode,
				patNo, null, null, expiredDate, "Y");
		} else {
			CRMClientMembershipDB.add(userBean, clientID, clubID, discountCode,
				patNo, null, null, expiredDate, "Y");
		}
	}
%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)) {
	HttpFileUpload.toUploadFolder(request,
	ConstantsServerSide.DOCUMENT_FOLDER,
	ConstantsServerSide.TEMP_FOLDER,
	ConstantsServerSide.UPLOAD_FOLDER);
	fileUpload = true;
}

UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String loginID = userBean.getLoginID();

String clientID = ParserUtil.getParameter(request, "clientID");
if (clientID == null) {
	clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);
}
String lastName = TextUtil.parseStr(ParserUtil.getParameter(request, "lastName")).toUpperCase();
String firstName = TextUtil.parseStr(ParserUtil.getParameter(request, "firstName")).toUpperCase();
String patNo_HKAH = ParserUtil.getParameter(request, "patNo_HKAH");
String patNo_TWAH = ParserUtil.getParameter(request, "patNo_TWAH");
String expiredDate = ParserUtil.getParameter(request, "expiredDate");
String discountCode = ParserUtil.getParameter(request, "discountCode");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction) {
			clientID = CRMClientDB.add(userBean,
					lastName, firstName);
			if (clientID != null) {
				updateMembership(userBean, clientID, "5", null, expiredDate, discountCode);
				updateMembership(userBean, clientID, "10", patNo_HKAH, null, null);
				updateMembership(userBean, clientID, "11", patNo_TWAH, null, null);
				message = "Client created.";
				createAction = false;
				step = null;
			} else {
				errorMessage = "Adventist VIP create fail.";
			}
		} else if (updateAction) {
			if (CRMClientDB.update(userBean,
					clientID,
					lastName, firstName)) {
				updateMembership(userBean, clientID, "5", null, expiredDate, discountCode);
				updateMembership(userBean, clientID, "10", patNo_HKAH, null, null);
				updateMembership(userBean, clientID, "11", patNo_TWAH, null, null);
				message = "Client updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "Adventist VIP update fail.";
			}
		} else if (deleteAction) {
			if (CRMClientDB.delete(userBean, clientID)) {
				message = "Client removed.";
				closeAction = true;
				step = null;
			} else {
				errorMessage = "Adventist VIP remove fail.";
			}
		}
	} else if (createAction) {
		clientID = "";
	}

	// load data from database
	if (clientID != null && clientID.length() > 0) {
		ArrayList record = CRMClientDB.get(clientID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			lastName = row.getValue(0);
			firstName = row.getValue(1);

			// vip info
			record = CRMClientMembershipDB.getList(clientID, "5");
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				expiredDate = row.getValue(5);
				discountCode = row.getValue(0);
			} else {
				expiredDate = null;
				discountCode = null;
			}

			// hkah patient
			record = CRMClientMembershipDB.getList(clientID, "10");
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				patNo_HKAH = row.getValue(5);
			} else {
				patNo_HKAH = null;
			}

			// twah patient
			record = CRMClientMembershipDB.getList(clientID, "11");
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				patNo_TWAH = row.getValue(5);
			} else {
				patNo_TWAH = null;
			}
		}
	}
} catch (Exception e) {
	e.printStackTrace();
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
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.vip.membership." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="vip_membership.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Client ID</td>
		<td class="infoData" width="70%"><%=clientID==null?"":clientID %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><font color="red"><bean:message key="prompt.lastName" /></font></td>
		<td class="infoData" width="70%" id="lastName_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="lastName" value="<%=lastName==null?"":lastName %>" maxlength="30" size="25">
<%	} else { %>
			<%=lastName==null?"":lastName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><font color="red"><bean:message key="prompt.firstName" /></font></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="firstName" value="<%=firstName==null?"":firstName %>" maxlength="60" size="25">
<%	} else { %>
			<%=firstName==null?"":firstName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Hospital No.</td>
		<td class="infoData" width="70%">
			HKAH Hospital No.
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="patNo_HKAH" value="<%=patNo_HKAH==null?"":patNo_HKAH %>" maxlength="10" size="10"> (<bean:message key="prompt.optional" />)
<%	} else { %>
			<%=patNo_HKAH==null?"N/A":patNo_HKAH %>
<%	} %>
			<br/>
			TWAH Hospital No.
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="patNo_TWAH" value="<%=patNo_TWAH==null?"":patNo_TWAH %>" maxlength="10" size="10"> (<bean:message key="prompt.optional" />)
<%	} else { %>
			<%=patNo_TWAH==null?"N/A":patNo_TWAH %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><font color="red">Expired Date</font></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="text" name="expiredDate" id="expiredDate" class="datepickerfield" value="<%=expiredDate==null?"":expiredDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)</td>
<%	} else { %>
			<%=expiredDate==null?"":expiredDate %>
<%	} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><font color="red">Discount Code</font></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="radio" name="discountCode" value="1"<% if (discountCode == null || "1".equals(discountCode)) { %> checked<%} %>>A: 20%<br/>
			<input type="radio" name="discountCode" value="2"<% if ("2".equals(discountCode)) { %> checked<%} %>>B: 15%<br/>
			<input type="radio" name="discountCode" value="3"<% if ("3".equals(discountCode)) { %> checked<%} %>>C: 10%<br/>
			<input type="radio" name="discountCode" value="4"<% if ("4".equals(discountCode)) { %> checked<%} %>>D: 5%
<%	} else if ("1".equals(discountCode)) { %>
			A: 20%
<%	} else if ("2".equals(discountCode)) { %>
			B: 15%
<%	} else if ("3".equals(discountCode)) { %>
			C: 10%
<%	} else if ("4".equals(discountCode)) { %>
			D: 5%
<%	} else { %>
			N/A
<%	} %>
		</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.vip.membership.update" /></button>
			<button class="btn-delete"><bean:message key="function.vip.membership.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="" />
<input type="hidden" name="step" value="" />
<input type="hidden" name="clientID" value="<%=clientID==null?"":clientID %>">
</form>
<script language="javascript">
<!--
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.lastName.value == '') {
				alert("<bean:message key="error.lastName.required" />.");
				document.form1.lastName.focus();
				return false;
			} else if (document.form1.firstName.value == '') {
				alert("<bean:message key="error.firstName.required" />.");
				document.form1.firstName.focus();
				return false;
			} else if (document.form1.expiredDate.value == '') {
				alert("Empty expired date.");
				document.form1.expiredDate.focus();
				return false;
			}
		}
<%	} %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>