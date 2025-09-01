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

String ruleNum = request.getParameter("ruleNum");
String timeslot = request.getParameter("timeslot");
String desc = request.getParameter("desc");
String capacity =  request.getParameter("capacity");
String startDate =  request.getParameter("startDate");
String endDate =  request.getParameter("endDate");
String type =  request.getParameter("type");
String status =  request.getParameter("status");

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
String nextCommand = null;

try {
	if ("new".equals(command)) {
		nextCommand = "create";
	} else if ("edit".equals(command)){
		ArrayList record = FitnessDB.getConfig(ruleNum);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			startDate = row.getValue(0);
			type = row.getValue(1);
			timeslot = row.getValue(2);
			desc = row.getValue(3);
			capacity = row.getValue(4);
			endDate = row.getValue(5);
			status = row.getValue(6);
		}
		nextCommand = "update";
	} else if ("update".equals(command)) {

		if (FitnessDB.updateConfig(userBean, ruleNum, startDate, type, timeslot, desc, capacity, endDate, status)) {				
			message = "Configuration updated";
		} else {
			errorMessage = "Update failed";
			nextCommand = "update";
		}

	} else if ("create".equals(command)){
		
		if (FitnessDB.addConfig(userBean, startDate, type, timeslot, desc, capacity, endDate)) {
			message = "Configuration rule saved";
		} else {
			message = "Fail to save configuration";
		}
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
	<jsp:param name="pageMap" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" action="config_entry.jsp" method="post">

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.startDate" /></td>
		<td class="infoData" width="80%">
			<input type="text" name="startDate" id="startDate" class="datepickerfield" value="<%=startDate==null?"":startDate %>" maxlength="10" size="10" onkeyup="validDate(this)" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.type" /></td>
		<td class="infoData" width="80%">
			<select  name="type" id="type">
				<option value="ONE_TIME" <%="ONE_TIME".equals(type)?" selected":"" %>>One Time</option>
				<option value="DAILY" <%="DAILY".equals(type)?" selected":"" %>>Daily</option>
				<option value="WEEKLY" <%="WEEKLY".equals(type)?" selected":"" %>>Weekly</option>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.time" /></td>
		<td class="infoData" width="80%">
			<select  name="timeslot" id="timeslot">
				<option value="0" <%="0".equals(timeslot)?" selected":"" %>>All-day</option>
				<jsp:include page="../ui/timeslotCMB.jsp" flush="false">
					<jsp:param name="timeslot" value="<%=timeslot %>" />
				</jsp:include>
			</select>
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.description" /></td>
		<td class="infoData" width="80%">
			<input type="textfield" name="desc" id="desc" value="<%=desc==null?"":desc %>" maxlength="4000" size="100" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.available" /></td>
		<td class="infoData" width="80%">
			<input type="textfield" name="capacity" id="capacity" value="<%=capacity==null?"":capacity %>" maxlength="2" size="2" max=99 min=0/>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.termDate" /></td>
		<td class="infoData" width="80%">
			<input type="text" name="endDate" id="endDate" class="datepickerfield" value="<%=endDate==null?"":endDate %>" maxlength="10" size="10" onkeyup="validDate(this)" />
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="80%">
			<select  name="status" id="status">
				<option value="1" <%="1".equals(status)?" selected":"" %>>Active</option>
				<option value="0" <%="0".equals(status)?" selected":"" %>>Inactive</option>
			</select>
		</td>
	</tr>			
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText"><td>
		<input type="hidden" name="command" id="command" value="<%=nextCommand %>"/>
		<input type="hidden" name="ruleNum" id="ruleNum" value="<%=ruleNum %>"/>
		
		<button type="submit"><bean:message key="button.save" /></button>
		<button type="reset"><bean:message key="button.reset" /></button>
		<button class="btn-click" onclick="return close_window()"><bean:message key="button.close" /></button>

	</td>
	</tr>
</table>
</div>

</form>
<script language="javascript">
<!--
<%
if ("create".equals(command)) {
%>
	$( document ).ready(function() {
		alert("<%=message %>");
		close_window();
	});
<%
}
%>
	function validate() {
		var valid = true;
		
		if (!document.getElementById("startDate").value.trim()) {
			alert("Please enter start date");
			valid = false;
		} else if (!validDate(document.getElementById("startDate").value)) {
			alert ("Invalid start date");
			valid = false;
		}
		
		if (!document.getElementById("capacity").value.trim()) {
			alert("Please enter capacity");
			valid = false;
		} else if (isNaN(document.getElementById("capacity").value)) {
			alert("Invalid capacity");
			valid = false;
		}
		
		if (!validDate(document.getElementById("endDate").value)) {
			alert ("Invalid start date");
			valid = false;
		}
		
		return valid;
	}

	function submitAction() {
		if (validate()) {
			document.form1.submit();
		}
		return false;
	}
	
	function close_window() {
		opener.location.reload();
		window.close();
		return false;
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>