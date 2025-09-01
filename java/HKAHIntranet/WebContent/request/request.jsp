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

String reqNo = request.getParameter("reqNo");
String reqDate = request.getParameter("reqDate");
String site = request.getParameter("site");
String reqDept = request.getParameter("reqDept");
String reqBy = request.getParameter("reqBy");
String sysName = request.getParameter("sysName");
String taskType = request.getParameter("taskType");
String taskName = request.getParameter("taskName");
String estDay = request.getParameter("estDay");
String status = request.getParameter("status");
String startDate = request.getParameter("startDate");
String HKDate = request.getParameter("HKDate");
String TWDate = request.getParameter("TWDate");
String AMCDate = request.getParameter("AMCDate");
String remark = request.getParameter("remark");

String title = null;
String subTitle = null;

// set submit label
title = "Request Maintenance";
subTitle = "";

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
String nextCommand = null;

try {
	if ("new".equals(command)) {
		nextCommand = "create";
		reqNo = RequestDB.getDefaultReqNo();
	} else if ("edit".equals(command)){
		ArrayList record = RequestDB.get(reqNo);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			reqDate = row.getValue(1);
			site = row.getValue(2);
			reqDept = row.getValue(3);
			reqBy = row.getValue(4);
			sysName = row.getValue(5);
			taskType = row.getValue(6);
			taskName = row.getValue(7);
			estDay = row.getValue(8);
			status = row.getValue(9);
			startDate = row.getValue(10);
			HKDate = row.getValue(11);
			TWDate = row.getValue(12);
			AMCDate = row.getValue(13);
			remark = row.getValue(14);
		}
		nextCommand = "update";
	} else if ("update".equals(command)) {

		if (RequestDB.update(reqNo, reqDate, site, reqDept, reqBy, sysName,
				taskType, taskName, estDay, status, startDate,
				HKDate, TWDate, AMCDate, remark)) {
			message = "Request updated.";
		} else {
			errorMessage = "Request update fail.";
			nextCommand = "update";
		}

	} else if ("create".equals(command)){
		ArrayList record = RequestDB.get(reqNo);
		if (record.size() == 0) {

			if (RequestDB.create(userBean, reqNo, reqDate, site, reqDept, reqBy, sysName,
				taskType, taskName, estDay, status, startDate,
				HKDate, TWDate, AMCDate, remark)) {
				
				message = "Request created.";
				nextCommand = "update";

			} else {
				errorMessage = "Request create fail.";
				nextCommand = "create";
			}
		} else {
			message = "Duplicate reqno";
			nextCommand = "create";
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
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="pageSubTitle" value="<%=subTitle %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" action="request.jsp" method="post">

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqNo" /></td>
		<td class="infoData" width="80%">
			<input type="textfield" name="reqNo" id="reqNo" value="<%=reqNo==null?"":reqNo %>" maxlength="10" size="10" required <%="edit".equals(command)?"readonly":""%>>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDate" /></td>
		<td class="infoData" width="80%"><input type="textfield" name="reqDate" id="reqDate" class="datepickerfield" value="<%=reqDate==null?"":reqDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.siteCode" /></td>
		<td class="infoData" width="80%"><select name="site">
			<option value="BH" <%="BH".equals(site)?" selected":"" %>>BH</option>
			<option value="HK" <%="HK".equals(site)?" selected":"" %>>HK</option>
			<option value="TW" <%="TW".equals(site)?" selected":"" %>>TW</option>
		</select></td>
	</tr>	


	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqBy" /></td>
		<td class="infoData" width="80%" colspan=3">
			<select name="reqDept">
				<option value="">-- Department --</option>
<jsp:include page="../ui/jointDeptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=reqDept %>" />
</jsp:include>
			</select>&nbsp;/&nbsp;
			<span id="showUserID_indicator">
				<input type="textfield" name="reqBy" id="reqBy" value="<%=reqBy==null?"":reqBy %>" maxlength="50" size="50">
			</span>
		</td>
	</tr>


	<tr class="smallText">
		<td class="infoLabel" width="20%">System Name</td>
		<td class="infoData" width="80%"><input type="textfield" name="sysName" value="<%=sysName==null?"":sysName %>" maxlength="50" size="50"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Request Type</td>
		<td class="infoData" width="80%"><input type="textfield" name="taskType" value="<%=taskType==null?"":taskType %>" maxlength="20" size="20"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Request Name</td>
		<td class="infoData" width="80%"><textarea name="taskName" maxlength="500" rows="2" cols="100"><%=taskName==null?"":taskName %></textarea></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Est Days</td>
		<td class="infoData" width="80%"><input type="textfield" name="estDay" id="estDay" value="<%=estDay==null?"":estDay %>" max=9999999.99 min=0></td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="20%">Status</td>
		<td class="infoData" width="80%"><select name="status">
			<option value=""></option>
			<option value="Live Run" <%="Live Run".equals(status)?" selected":"" %>>Live Run</option>
			<option value="Cancelled" <%="Cancelled".equals(status)?" selected":"" %>>Cancelled</option>
			<option value="In Progress" <%="In Progress".equals(status)?" selected":"" %>>In Progress</option>
			<option value="Hold" <%="Hold".equals(status)?" selected":"" %>>Hold</option>
			<option value="Reject" <%="Reject".equals(status)?" selected":"" %>>Reject</option>
		</select></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Start Date</td>
		<td class="infoData" width="80%"><input type="textfield" name="startDate" id="startDate" class="datepickerfield" value="<%=startDate==null?"":startDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Act HK Run Date</td>
		<td class="infoData" width="80%"><input type="textfield" name="HKDate" id="HKDate" class="datepickerfield" value="<%=HKDate==null?"":HKDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Act TW Run Date</td>
		<td class="infoData" width="80%"><input type="textfield" name="TWDate" id="TWDate" class="datepickerfield" value="<%=TWDate==null?"":TWDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Act AMC Run Date</td>
		<td class="infoData" width="80%"><input type="textfield" name="AMCDate" id="AMCDate" class="datepickerfield" value="<%=AMCDate==null?"":AMCDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Remarks</td>
		<td class="infoData" width="80%"><textarea name="remark" id="remark" maxlength="50" maxlength="500" rows="2" cols="100"><%=remark==null?"":remark %></textarea></td>
	</tr>		
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText"><td>
		<input type="hidden" name="command" id="command"/>
		
		<button class="btn-click" onClick="return submitAction('<%=nextCommand==null?"":nextCommand %>')"><bean:message key="button.save" /></button>
		<button type="reset"><bean:message key="button.reset" /></button>
		<button class="btn-click" onclick="return close_window()"><bean:message key="button.close" /></button>
<%if ("edit".equals(command) || "update".equals(command) || "create".equals(command)) {%> 
		<button class="btn-click" onClick="return assign()"><bean:message key="button.assign" /></button>
<%} %>	
	</td>
	</tr>
</table>
</div>

</form>
<script language="javascript">
<!--
	function validate() {
		var valid = true;
		if (!document.getElementById("reqNo").value.trim()) {
			alert("Please enter request number");
			valid = false;
		}
		
		if (isNaN(document.getElementById("estDay").value)) {
			alert("Invalid estimated day");
			valid = false;
		}
		return valid;
	}

	function assign() {
		//callPopUpWindow("assign.jsp?reqNo=" + document.form1.reqNo.value );
		callPopUpWindow("assign.jsp?reqNo=" + document.getElementById("reqNo").value );
		return false;
	}
	
	function close_window() {
		opener.location.reload();
		window.close();
		return false;
	}
	
	function submitAction(cmd) {

		document.getElementById("command").value = cmd;
		if (validate()) {
			document.form1.submit();
		}
		return false;
	}
	
	// ajax
	var http = createRequestObject();

	function changeUserID() {
		var did = document.form1.reqDept.value;
		http.open('get', '../ui/staffIDCMB.jsp?deptCode=' + did + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponseUserID;

		//actually send the request to the server
		http.send(null);

		return false;
	}
	
	function processResponseUserID() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("showUserID_indicator").innerHTML = '<select name="reqBy"><option value="">-- Staff --</option>' + response + '</select>';

			// reset staff id
			document.form1.reqBy.value = "";
		}
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>