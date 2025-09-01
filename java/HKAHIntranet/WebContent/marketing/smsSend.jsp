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

<%!
public static ArrayList getRevList(String batchID){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT S.PATNO, CONCAT (P.PATFNAME, (' '||P.PATGNAME)) PATNAME,");
	sqlStr.append("P.PATADD1, P.PATADD2, P.PATADD3, ");
	sqlStr.append("P.PATPAGER, P.PATEMAIL, S.METHOD ");
	sqlStr.append("FROM SMS_BATCH_LIST S, PATIENT@IWEB P ");
	sqlStr.append("WHERE S.PATNO = P.PATNO ");
	sqlStr.append("AND S.BATCH_ID = '");
	sqlStr.append(batchID);
	sqlStr.append("' ");
	sqlStr.append("AND S.METHOD = 'S' ");
	sqlStr.append("ORDER BY P.PATPAGER, P.PATADD1, P.PATADD2, P.PATADD3 ");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>

<%

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

ArrayList result = null;
ArrayList allSmsCode = new ArrayList();
UserBean userBean = new UserBean(request);
String mode = ParserUtil.getParameter(request,"mode");

String batchID = ParserUtil.getParameter(request, "batchID");
String smsCode = ParserUtil.getParameter(request, "smsCode");
String smsMsg = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "smsMsg"));

String noOfRev = ParserUtil.getParameter(request, "noOfRev");
String gender = ParserUtil.getParameter(request,"gender");
String type = ParserUtil.getParameter(request,"type");
String ageGp = ParserUtil.getParameter(request,"ageGp");
String regYr = ParserUtil.getParameter(request,"regYr");
String hyperlipidemia = ParserUtil.getParameter(request,"hyperlipidemia");
String hyperglycaemia = ParserUtil.getParameter(request,"hyperglycaemia");
String physicalExam = ParserUtil.getParameter(request,"physicalExam");
String smsRev = ParserUtil.getParameter(request, "smsRev");

boolean success=false;

if (mode == null || mode.isEmpty()){
	mode = "SendEdit";
	smsCode = "";
	smsMsg = "";
}

if ("SendEdit".equals(mode)){
	if("SendEdit".equals(mode)){
		smsMsg = "";
	}
	result = SMSDB.getMsg("SMS_CODE");
	if (result.size() > 0) {
		for (int i=0; i<result.size();i++){
			ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
			allSmsCode.add(reportableListObject.getValue(0));
		}
	} 
	result = SMSDB.getBatch(batchID);
	if (result.size() > 0){
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		noOfRev = reportableListObject.getValue(1);
		gender = reportableListObject.getValue(2);
		type = reportableListObject.getValue(3);
		ageGp = reportableListObject.getValue(4);
		regYr = reportableListObject.getValue(5);
		hyperlipidemia = reportableListObject.getValue(6);
		hyperglycaemia = reportableListObject.getValue(7);
		physicalExam = reportableListObject.getValue(17);
		smsRev = reportableListObject.getValue(10);
		smsMsg = reportableListObject.getValue(16);
	}
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

#smsInfo{
 	width: 80%;
 	vertical-align: top;
}
#batchInfo{
	width: 20%;
	vertical-align: top;
}

button:disabled{
	color: white;
}
#searchButton{
    margin: 0 7px 0 0;
    border: 1px solid #dedede;
    border-top: 1px solid #eee;
    border-left: 1px solid #eee;
    font: 12px Arial, Helvetica, sans-serif;
    font-size: 100%;
    line-height: 100%;
    text-decoration: none;
    color: #565656;
    cursor: pointer;
    padding: 5px 10px 6px 7px;
}
.batchInfo{
	border: 0;
	color: black;
}
#smsMsg{
    width: 70%;
    background-color:inherit;
	border: 0;
	margin-left: 100px;
	margin-top: 20px;
	color: black;
}
</style>
<body <%if("Sending".equals(mode)){ %>onload="alertMsg();"<%} %>>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame style="width: 100%;">

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Send SMS" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="smsSendForm" id="smsSendForm" action="smsSend.jsp" method="post">
<table id="layout">
	<tr>
		<td id="smsInfo" >
			<table cellpadding="0" cellspacing="5" class="" border="0">
				<tr class="">
					<td class="infoLabel" width="30%">Enter SMS Code</td>
					<td class="infoData" width="70%">
						<select name="smsCode" id="smsCode" style="width: 400px;">
							<option value=""></option>
						</select>
						<input type="hidden" id="batchID" name="batchID" value="<%=batchID %>"/>
						<input type="button" onclick="searchMsg()" id="searchButton" value="Search"/>
					</td>
				</tr>
				<tr>
					<td class="infoData" width="100%" colspan="2" style="height: 500px; vertical-align: top;">
						<p style="text-align:center;font-weight:bold;font-size:14px;text-decoration: underline;" >SMS Message Display </p>
						<div id="smsMsg"></div>
					</td>
				</tr>		
			</table> 
		</td>
		<td id="batchInfo">
			<table cellpadding="0" cellspacing="5" class="" border="0">
				<tr class="">
					<td class="infoLabel" width="40%">Batch ID</td>
					<td class="infoData" width="60%">
						<p><%=batchID %></p>
					</td>
				</tr>
				<tr>
					<td class="infoLabel" width="40%">No. of Receiver</td>
					<td class="infoData" width="60%">
						<p><%=smsRev %></p>
						<input type="hidden" id="smsRev" name="smsRev" value="<%=smsRev %>"/>
					</td>
				</tr>
				<tr class="">
					<td class="infoLabel" width="40%">Gender</td>
					<td class="infoData" width="60%">
						<p><%="M".equals(gender)?"Male":"F".equals(gender)?"Female":"ALL" %></p>
					</td>
				</tr>
				<tr class="">
					<td class="infoLabel" width="40%">Registration Type</td>
					<td class="infoData" width="60%">
						<p><%="I".equals(type)?"In-patient":"O".equals(type)?"Out-patient":"D".equals(type)?"Daycase":"ALL" %></p>
					</td>
				</tr>
				<tr class="">
					<td class="infoLabel" width="40%">Age Group</td>
					<td class="infoData" width="60%">
						<p><%="0".equals(ageGp)? "0-10" : "1".equals(ageGp)?"11-20" : "2".equals(ageGp)?"21-30" : "3".equals(ageGp)?"31-40": "4".equals(ageGp)?"41-50": "5".equals(ageGp)?"51+": ""  %></p>
					</td>
				</tr>
				<tr class="">
					<td class="infoLabel" width="40%">Registration Year</td>
					<td class="infoData" width="60%">
					<p><%=regYr %></p>
					</td>
				</tr>
				<tr class="">
					<td class="infoLabel" width="40%">Lipidemia</td>
					<td class="infoData" width="60%">
					<p><%="Y".equals(hyperlipidemia)?"High":"N".equals(hyperlipidemia)?"Low / Not Test":"ALL" %></p>
					</td>
				</tr>
				<tr class="">
					<td class="infoLabel" width="40%">Glycaemia</td>
					<td class="infoData" width="60%">
					<p><%="Y".equals(hyperglycaemia)?"High":"N".equals(hyperglycaemia)?"Low / Not Test":"ALL" %></p>
					</td>
				</tr>
				<tr class="">
					<td class="infoLabel" width="40%">Physical Exam</td>
					<td class="infoData" width="60%">
					<p><%="Y".equals(physicalExam)?"Include":"N".equals(physicalExam)?"Not Include":"ALL" %></p>
					</td>
				</tr>		
			</table> 
		</td>
	</tr>
</table>

<input type="hidden" name="mode"/>
</form>

<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
		<%if("Sending".equals(mode)){%>
		<button onclick="return window.close();" class="btn-click" id="">Close</button>
		<%}else{ %>
		<button onclick="return sendSMS();" class="btn-click" id="send">Send</button>
		<%} %>
		</td>
	</tr>
</table>
</div>



<script language="javascript">
	$().ready(function() {
		setDropDownList();
	<%if("Sending".equals(mode)){ %>
		$("#layout").hide();
	<%} %>
		lockfield();
		$("#smsCode").focus();
		$("#smsCode").on("focus",function(e){
		    $(this).select();
		});
		$(window).keydown(function(event){
		   if(event.keyCode == 13) {
		     event.preventDefault();
		     searchMsg();
		     return false;
		   }
		});
		$('#send').prop('disabled',true);
	});
	
	function alertMsg(){
		<%if(success){ %>
			var msg= "<%=message %>";
		<%}else{ %>
			var msg= "<%=errorMessage %>";
		<%} %>
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
	
	function lockfield(){
		$(".batchInfo").prop('disabled',true);
		<%if(!(smsMsg == null || smsMsg.isEmpty())){ %>
			//document.getElementById("searchButton").disabled = true;
			document.getElementById("smsCode").readOnly = true;
		<%} %>
	}
	
	function searchMsg(){
		var smsCode = $("#smsCode").val();
		if (smsCode == ""){
			$('#smsMsg').empty();
			$('#send').prop('disabled',true);
		}else{
			$.ajax({
		        url: "getSmsMsg.jsp",
		        data: {"smsCode" : smsCode},
		        type: 'POST',
		        dataType: 'html',
				cache: false,
		        success: function(data){
		        	$('#smsMsg').html(data);
		        },
		       	error: function(data){
		       		console.log(data);
		       	}
		    });
		}
		
	}
	
	//translate new line to <br>
	function translateBR(){
		var newText = $("#smsMsg").val().replace(/\r?\n/g, '&#13;');
		$("#smsMsg").val(newText);
	}
	
	function submitAction(cmd){
			document.smsSendForm.mode.value = cmd;
			document.smsSendForm.submit();

	}

	function sendSMS() {
		//showLoadingBox('body', 100, 350);
		$('#progressbar').css('top', 350);
		$('#progressbar').css('left', $(window).width()/2-$('#progressbar').width()/2);
		$('#progressbar').show();
		showOverLay('body');
		
		sentSMS = 0;
		successSent = 0;
		failSent = 0;
		
		var smsCode = $("#smsCode").val();
		var batchID = $("#batchID").val();
		var smsRev = $("#smsRev").val();
		
<%
	ArrayList record = getRevList(batchID);
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			ReportableListObject row = (ReportableListObject)record.get(i);
%>
			$.ajax({
				url: '/intranet/marketing/send.jsp',
				data: {	"batchID" : batchID,
						"smsCode" : smsCode,
						"patno" : <%=row.getValue(0)%>},
				async: true,
				type: 'POST',
				success: function(data, textStatus, jqXHR) {
					if ($.trim(data)=='true') {
						successSent++;
					}
					else {
						failSent++;
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					failSent++;
				},
				complete: function(jqXHR, textStatus) {
					sentSMS++;
					$('.progress-label').html(
							'Sending.......'+sentSMS+'/'+smsRev+'<br/>'+
							'(Success: '+successSent+' Fail: '+failSent+')');
					sendSMSPost(sentSMS==smsRev);
				}
			});
<%
		}
	}
%>
	}
	
	function sendSMSPost(complete) {
		if (complete) {
			$('#progressbar').append(
					'<button id="progressCloseBtn" '+
					'class="ui-button ui-widget ui-state-default'+
					' ui-corner-all ui-button-text-only">Close</button>');
			
			$('#progressCloseBtn').click(function() {
				$('#progressbar').hide();
				showLoadingBox('body', 100, 350);
				window.close();
				/*
				var url = window.location.href;
				url.replace("sendSms=Y", "sendSms=N"); //ensure send sms only one time
				window.location.replace(url);
				*/
			});
			
			$('input[name=sendSms]').val("N");
			
		}
		
	}

</script>
</DIV>
</DIV></DIV>
<div id="progressbar" style="position:absolute; z-index:15;display:none;"
				class="ui-dialog ui-widget ui-widget-content ui-corner-all">
			<div class="ui-widget-header">Status</div><br/>
			<div class="progress-label">Loading...</div><br/>
</div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>