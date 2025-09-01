<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>

<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";

String reqNo = request.getParameter("reqNo");
String manTime = request.getParameter("manTime");
String task = request.getParameter("task");
String taskDate = request.getParameter("taskDate");
if (taskDate == null) {
	Calendar calendar = Calendar.getInstance();
	taskDate = DateTimeUtil.formatDate(calendar.getTime());
}
String taskID = request.getParameter("taskID");
String taskDept = request.getParameter("taskDept");
String command = request.getParameter("command");

String staffID = request.getParameter("staffID");
if (staffID == null) {
	staffID = userBean.getStaffID();
}
String subTitle = StaffDB.getStaffName(staffID);

try {
	if ("new".equals(command)) {
		if (RequestDB.createTask(userBean, reqNo, task, taskDate, manTime, taskDept, staffID)) {
			message = "Task created.";
		} else {
			errorMessage = "Task create fail.";
		}
	} else if ("edit".equals(command)) {
		if (RequestDB.updateTask(userBean, taskID, reqNo, task, manTime, taskDept)) {
			message = "Task updated.";
		} else {
			errorMessage = "Task update fail.";
		}
	}  else if ("delete".equals(command)) {
		if (RequestDB.deleteTask(taskID)) {
			message = "Task deleted.";
		} else {
			errorMessage = "Task delete fail.";
		}
	}
	
} catch (Exception e) {
	e.printStackTrace();
}
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body onload="changeReqNo('form_new')">
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.worksheet.entry" />	
	<jsp:param name="pageSubTitle" value="<%=subTitle %>" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" id="form1">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.startDate" /></td>
		<td class="infoData" width="80%"><input type="textfield" name="taskDate" id="taskDate" class="datepickerfield" value="<%=taskDate==null?"":taskDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" onChange="changeDate()" > (DD/MM/YYYY)</td>
	</tr>
</table>
</form>
<span id="task_subform">
<jsp:include page="task_subform.jsp" flush="true">
	<jsp:param name="taskDate" value="<%=taskDate %>" />
	<jsp:param name="staffID" value="<%=staffID %>" />
</jsp:include>
</span>
<center>
	<button class="btn-click" onclick="return close_window()"><bean:message key="button.close" /></button>
</center>	

<script language="javascript">
<!--
	function updateAction(form_id) {
		document.getElementById(form_id).command.value = "edit" ;

		if (validate(form_id)) {
			document.getElementById(form_id).submit();
		}
		
		return false;
	}
	
	function deleteAction(form_id) {
		document.getElementById(form_id).command.value = "delete" ;
		document.getElementById(form_id).submit();
		return false;
	}
	
	function newAction() {
		if (validate("form_new")) {
			document.form_new.submit();
		}
		return false;
	}
	
	function close_window() {
		opener.location.reload();
		window.close();
		return false;
	}
	
	function validate(form_id) {
		if (isNaN(document.getElementById(form_id).manTime.value)) {
			alert("Man Time invalid");
			return false;
		}
		return true;
	}
	
	var http = createRequestObject();

	function changeDate() {
		var taskDate = document.form1.taskDate.value;
		var d = new Date();
	    var n = d.getTime();
		http.open('get', 'task_subform.jsp?taskDate=' + taskDate + '&staffID=' + <%=staffID %> + '&time=' + n);

		//assign a handler for the response
		http.onreadystatechange = processResponseDate;

		//actually send the request to the server
		http.send(null);

		return false;
	}
	
	function processResponseDate() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;
			
			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("task_subform").innerHTML = response ;
		}
	}
	
	var gform_id;
	
	function changeReqNo(form_id) {
		
		var reqNo = document.getElementById(form_id).reqNo.value;
		
		gform_id = form_id;
		
		http.open('get', 'getRequest.jsp?reqNo=' + reqNo);

		//assign a handler for the response
		http.onreadystatechange = processResponseReqNo;

		//actually send the request to the server
		http.send(null);

		return false;
	}
	
	function processResponseReqNo() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;
			var myObj = JSON.parse(response);
			document.getElementById(gform_id).taskDept.value = myObj.reqDept ;
		}
	}
-->
</script>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>