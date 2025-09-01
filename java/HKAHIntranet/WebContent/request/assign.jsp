<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%
UserBean userBean = new UserBean(request);

String reqNo = request.getParameter("reqNo");
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
String command = request.getParameter("command");

String reqDesc = null;

if (command != null && command.equals("add")){
	String staffID = request.getParameter("addStaff");
	if (staffID != null) {
		if (!RequestDB.assignStaff(userBean, reqNo, staffID)) {
			errorMessage = "staff assign fail.";
		}
	}
}

if (command != null && command.equals("remove")){
	String staffID = request.getParameter("removeStaff");
	if (staffID != null) {
		if (!RequestDB.removeStaff(reqNo, staffID)) {
			errorMessage = "staff remove fail.";
		}
	}
}

if (command != null && command.equals("addall")){
	if (!RequestDB.assignAllStaff(reqNo, userBean)) {
		errorMessage = "staff assign fail.";
	}
}

if (command != null && command.equals("removeall")){
	if (!RequestDB.removeAllStaff(reqNo)) {
		errorMessage = "staff remove fail.";
	}
}

// load data from database
if (reqNo != null && reqNo.length() > 0) {
	ArrayList record = RequestDB.get(reqNo);
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		reqDesc = row.getValue(7);
	}
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

String title = null;
String subTitle = null;

// set submit label
title = "Assign Staff";
subTitle = "";
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

<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/thickbox.css" />" media="screen" />
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="pageSubTitle" value="<%=subTitle %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle"><%=reqDesc==null?"Blank":reqDesc %></td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="3">&nbsp;</td>
	</tr>

</table>
<form name="assign_form" action="assign.jsp" method="post">
<table width="1000" cellpadding="0" cellspacing="0" border="0" align="left" valign="top">
	<tr>
		<td valign="top" width="45%">
Avaliable Staffs:
<br>		
<select name="addStaff" size="20" style="width: 100%">
<%
ArrayList avaliableUser = RequestDB.getAvailableUser(reqNo, userBean);
ReportableListObject avaliableRow = null;
if (avaliableUser.size() > 0) {
	for (int i = 0; i < avaliableUser.size(); i++) {
		avaliableRow = (ReportableListObject) avaliableUser.get(i);
%>
		<option value="<%=avaliableRow.getValue(0) %>"><%=avaliableRow.getValue(1) %></option>
<%
	}
}
%>
</select>
		<td align="center" valign="middle" width="10%">
			<button onclick="return submitAction('add');" class="btn-click"> > </button>
			<br><br>
			<button onclick="return submitAction('remove');" class="btn-click"> < </button>
			<br><br>			
			<button onclick="return submitAction('addall');" class="btn-click"> >> </button>
			<br><br>
			<button onclick="return submitAction('removeall');" class="btn-click"> << </button>			
						
		</td>
		<td valign="top" width="45%">
Assigned Staffs:
<br>		
<select name="removeStaff" size="20" style="width: 100%">
<%
ArrayList assignedUser = RequestDB.getAssignedUser(reqNo);
ReportableListObject assignedRow = null;
if (assignedUser.size() > 0) {
	for (int i = 0; i < assignedUser.size(); i++) {
		assignedRow = (ReportableListObject) assignedUser.get(i);
%>
		<option value="<%=assignedRow.getValue(0)%>"
		<%
			if (!(assignedRow.getValue(2).equals(userBean.getDeptCode())) && (!userBean.isAdmin())) {
		%>		disabled
		<% } %>
		><%=assignedRow.getValue(1) %></option>
<%
	}
}
%>

		</td></tr>
		<tr><td>
		<input type="hidden" name="command">
		<input type="hidden" name="reqNo" value=<%=reqNo%>>	
		</td></tr>
</table>

<div class="pane">
<table width="100%" border="0">
	<tr class="smallText"><td>
		<button class="btn-click" onclick="return close_window()"><bean:message key="button.close" /></button>
	</td>
	</tr>
</table>
</div>

</form>
		</td>
	</tr>
</table>

<script language="javascript">
	function submitAction(cmd) {
		document.assign_form.command.value=cmd;
	}
	
	function close_window() {
		window.close();
		return false;
	}
</script>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>