<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%

UserBean userBean = new UserBean(request);
String command = request.getParameter("command");

String memberID = null;

if  ("search".equals(command)) {
	memberID = request.getParameter("searchMemberID");
} else {
	memberID = request.getParameter("memberID");
}

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
String activeDate = request.getParameter("activeDate");
String endDate = request.getParameter("endDate");
String staffInfo = null;
String nextCommand = null;

try {
	ArrayList staffList = StaffDB.get(memberID);
	
	if (staffList.size() > 0) {
		ReportableListObject staffData = (ReportableListObject) staffList.get(0);
		String name = staffData.getValue(3);
		String dept = staffData.getValue(2);
		
		staffInfo = name + " (" + dept + ")";
		
		if ("create".equals(command)) {
			
			if (FitnessDB.addMember(userBean, memberID, activeDate, endDate)) {
				message = "Saved";
				nextCommand = "update";
			} else {
				message = "Fail to save member";
				nextCommand = "create";
			}
			
		} else if ("update".equals(command)) {
			
			if (FitnessDB.updateMember(userBean, memberID, activeDate, endDate)) {
				message = "Saved";
				nextCommand = "update";
			} else {
				errorMessage = "Fail to update member";
				nextCommand = "update";
			}
			
		} else {
		
			ArrayList record = FitnessDB.getMember(memberID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				activeDate = row.getValue(0);
				endDate = row.getValue(1);
				nextCommand = "update";
			} else {
				activeDate = null;
				endDate = null;
				nextCommand = "create";
			}
			
		}		
		
	} else {
		if (command != null)
			errorMessage = "Invalid staff";
	}
	
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
	<jsp:param name="pageTitle" value="function.fitness.maintenance" />
	<jsp:param name="displayTitle" value="Membership Maintenance" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" action="member.jsp" method="post">

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="80%">
			<input type="textfield" name="searchMemberID" id="searchMemberID" value="<%=memberID==null?"":memberID %>" maxlength="10" size="10" />
			<button class="btn-click" onclick="return searchAction()"><bean:message key="button.search" /></button>
			<br/>
			<%=staffInfo==null?"":staffInfo %>
		</td>
	</tr>
<DIV id=detail>
<%
	if ("create".equals(nextCommand) || "update".equals(nextCommand)) { 
%>	
	<tr class="smallText">
		<td class="infoLabel" width="20%">Active Date</td>
		<td class="infoData" width="80%">
			<input type="text" name="activeDate" id="activeDate" class="datepickerfield" value="<%=activeDate==null?"":activeDate %>" maxlength="10" size="10" onkeyup="validDate(this)" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.expiryDate" /></td>
		<td class="infoData" width="80%">
			<input type="text" name="endDate" id="endDate" class="datepickerfield" value="<%=endDate==null?"":endDate %>" maxlength="10" size="10" onkeyup="validDate(this)" />
		</td>
	</tr>
	<tr class="smallText"><td colspan=2 align=center>
		<button type="submit" ><bean:message key="button.save" /></button>
	</td></tr>
<%		
	}
%>
</DIV>
</table>

<input type="hidden" name="command" id="command" value="<%=nextCommand %>"/>
<input type="hidden" name="memberID" id="memberID" value="<%=memberID %>"/>

</form>
<script language="javascript">
<!--
	
	function searchAction() {
		document.getElementById("command").value = "search";
		document.form1.submit();
		return false;
	}
	
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>