<%@ page language="java" import="org.json.JSONObject" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.apache.commons.io.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>

<%

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

ArrayList result = null;
ArrayList allSmsCode = new ArrayList();
UserBean userBean = new UserBean(request);
String mode = ParserUtil.getParameter(request,"mode");

String smsCode = ParserUtil.getParameter(request, "smsCode");
String smsMsg = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "smsMsg"));
String msgSearch = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"msgSearch"));

Boolean success = false;

if (mode == null || mode.isEmpty()){
	mode = "Find";	
}

if(smsCode == null || smsCode.isEmpty()){
	smsCode = "";
}

if(msgSearch == null || msgSearch.isEmpty()){
	msgSearch = "";
}

if("Create".equals(mode)){
	message = "";
}

if("Save".equals(mode)){
	//DB add new msg
	success = SMSDB.addMsg(smsCode, smsMsg, userBean);
	if(success){
		message = "'" + smsCode + "' create successful.";
	}else{
		message = "'" + smsCode + "' has created already. Please Check.";
	}
}
if ("Edit".equals(mode)){
	result = SMSDB.getMsg(smsCode, null);
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		smsCode = reportableListObject.getValue(0);
		smsMsg = reportableListObject.getValue(1);
	} 
}
if ("Update".equals(mode)){
	success = SMSDB.updateMsg(smsCode, smsMsg, userBean);
	if(success){
		message = "'" + smsCode + "' update successful.";
	}else{
		message = "Update fail. Please try again later.";
	}
}
if ("Find".equals(mode)){
	result = SMSDB.getMsg("SMS_CODE");
	if (result.size() > 0) {
		for (int i=0; i<result.size();i++){
			ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
			allSmsCode.add(reportableListObject.getValue(0));
		}
	} 
	request.setAttribute("msgList", SMSDB.getMsg("CREATE_DATE"));
}
if ("Search".equals(mode)){
	mode = "Find";
	result = SMSDB.getMsg("SMS_CODE");
	if (result.size() > 0) {
		for (int i=0; i<result.size();i++){
			ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
			allSmsCode.add(reportableListObject.getValue(0));
		}
	} 
	request.setAttribute("msgList", SMSDB.getMsg(smsCode, msgSearch, "CREATE_DATE"));
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

<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
<style>
img {
    cursor: pointer;
}
table{
	width:100%;
}
#smsMsg{
    width: 70%;
}
</style>

<body <%if("Update".equals(mode)||"Save".equals(mode)){ %>onload="alertMsg()"<%} %>>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame style="width: 100%;">
<%
	String title = null;
	// set submit label
	title = mode + " SMS Message";
	
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<%if("Find".equals(mode)){ %>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return createMsg('Create');" class="btn-click">Create New SMS Message</button> 				
		</td>
	</tr>
</table>
</div>
<%} %>

<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="smsCodeForm" id="smsCodeForm" action="smsMsg.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="">
		<td class="infoLabel" width="30%">SMS Code</td>
		<td class="infoData" width="70%">
<%if("Find".equals(mode)){ %>
			<select name="smsCode" id="smsCode" style="width: 400px;">
				<option value=""></option>
			</select>
<%}else{ %>		
			<input type="text" id="smsCode" name="smsCode" style="width: 400px;"  <%if("Edit".equals(mode)){ %> value="<%=smsCode %>" <%} %> /> 

<%} %>
		</td>
	</tr>
<%if("Find".equals(mode)) {%>
	<tr class="">
		<td class="infoLabel" width="30%">SMS Message</td>
		<td class="infoData" width="70%">
			<input type="text" id="msgSearch" name="msgSearch" style="width: 400px;" value="<%=msgSearch %>"/> 
		</td>
	</tr>
<%} %>
<%if("Create".equals(mode)||"Edit".equals(mode)){ %>
	<tr>
		<td class="infoLabel" width="30%">SMS Message</td>
		<td class="infoData" width="70%">
			<textarea rows="10" name="smsMsg" id="smsMsg"><%if("Edit".equals(mode)){ %><%=smsMsg %><%} %></textarea>
		</td>
	</tr>		
	
<%} %>
</table> 
<%if("Find".equals(mode)) {%>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction('Search');" class="btn-click">Search</button>
			<button onclick="return submitAction('Reset');" class="btn-click">Reset</button>
		</td>
	</tr>
</table>
</div>
<%} %>
<input type="hidden" name="mode"/>
</form>

<%if("Find".equals(mode)){ %>
<div id="tbl-container">
<display:table id="row1" name="requestScope.msgList" pagesize="10" export="true" class="generaltable">
	<display:column title="&nbsp;" media="html" style="width:2%">
		<c:set var="orginal" value="${row1.fields0}"/>
		<c:set var="singlequote" value="'"/>
		<c:set var="newsinglequote" value="\\'\\'"/>
		<c:set var="smsCode" value="${fn:replace(orginal,singlequote,newsinglequote) }"/>
		<button onclick="return showSMS('<c:out value="${smsCode}" />');">View/Edit</button>
	</display:column>
	<display:column property="fields0" title="SMS Code" style="width:8%"/>
	<display:column property="fields1" title="SMS Message" style="width:90%"/>
</display:table>
</div>
<%} %>
 

<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
		<%if("Create".equals(mode)){ %>
			<button onclick="return submitAction('Save');" class="btn-click">Save</button>
		<%} %>
		<%if("Edit".equals(mode)){ %>
			<button onclick="return submitAction('Update');" class="btn-click">Update</button>
		<%} %>
		</td>
	</tr>
</table>
</div>



<script language="javascript">
	$().ready(function() {
<%if("Find".equals(mode)) {%>
		setDropDownList();
<%} %>
<%if("Edit".equals(mode)) {%>
		lockfield();
<%} %>
	});
	
	function alertMsg(){
		var msg= "<%=message %>";
		alert(msg);
		window.close();
	}
	
	function setDropDownList(){
		<%for(int j=0; j<allSmsCode.size(); j++){ %>
			var currentSms = "<%=allSmsCode.get(j).toString() %>";
			var smsCode = "<%=smsCode %>";
			$('#smsCode').append($('<option></option>').val(currentSms).text(currentSms));
			$('#smsCode').val(smsCode);
		<%} %>
	}
	
	function createMsg(mode){
		var w = 1100;
		var h = 900;
		var t = 0;
		var l = 0;
		var props = "channelmode=no,directories=no,fullscreen=no,location=no,menubar=no,resizable=yes,";
		props += "scrollbars=yes,status=no,titlebar=no,toolbar=no,";
		props += "top=" + t + ",left=" + l + ",height=" + h + ",width=" + w;

		win = window.open("", "_blank", props, false);
		win.location.href = "smsMsg.jsp?mode=" + mode;
		var win_timer = setInterval(function() {   
			if(win.closed) {
		    window.location.href = "smsMsg.jsp";
		    clearInterval(win_timer);
		} 
		}, 100); 
	}
	
	function showSMS(smsCode) {
		var w = 1100;
		var h = 900;
		var t = 0;
		var l = 0;
		var props = "channelmode=no,directories=no,fullscreen=no,location=no,menubar=no,resizable=yes,";
		props += "scrollbars=yes,status=no,titlebar=no,toolbar=no,";
		props += "top=" + t + ",left=" + l + ",height=" + h + ",width=" + w;

		win = window.open("", "_blank", props, false);
		win.location.href = "smsMsg.jsp?mode=Edit&smsCode=" + smsCode;
		var win_timer = setInterval(function() {   
			if(win.closed) {
		    window.location.href = "smsMsg.jsp";
		    clearInterval(win_timer);
		} 
		}, 100); 
	}
	
	function lockfield(){
		document.getElementById("smsCode").readOnly = true;
	}

	//translate new line to <br>
	function translateBR(){
		var newText = $("#smsMsg").val().replace(/\r?\n/g, '&#13;');
		$("#smsMsg").val(newText);
	}

	
	function submitAction(cmd){
		if(cmd=="Save"||cmd=="Update"){ 
			translateBR();
		}
		if(cmd=="Reset"){
			document.smsCodeForm.smsCode.value = "";
			document.smsCodeForm.msgSearch.value = "";
			cmd="Find";
		}
		document.smsCodeForm.mode.value = cmd;
		document.smsCodeForm.submit();
	}
	

</script>
</DIV>
</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>