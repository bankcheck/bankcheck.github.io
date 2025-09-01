<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
String team20 = request.getParameter("team20");
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
<jsp:include page="../../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Send Email/SMS" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>

<form name="form1">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">	
	<tr class="smallText" id="team20Row">
		<td class="infoLabel" width="30%">
			Team 20
		</td>
		<td class="infoData" width="70%">
		<select id="team20" name="team20">
			<option <%="all".equals(team20)?" selected":"" %> value="all">--- All Team 20 ---</option>
			<jsp:include page="../../ui/clientGroupCMB.jsp" flush="false">
				<jsp:param name="groupID" value="<%=team20 %>" />
				<jsp:param name="allowEmpty" value="F" />
			</jsp:include>
		</select>
		</td>
	</tr>
	<tr class="smallText" id="cusGroupRow" style="display:none;">
		<td class="infoLabel" width="30%">
			Customize Groups
		</td>
		<td class="infoData" width="70%">
		<select id="cusGroup" name="cusGroup">			
			<jsp:include page="../../ui/smsEmailCusGroup.jsp" flush="false">
				<jsp:param name="groupID" value="<%=team20 %>" />
				<jsp:param name="allowEmpty" value="Y" />
			</jsp:include>
		</select>
		<div>
			<button id="createCusGroupBtn" type="button" onclick="return customizeGroupAction('create');">Create Customize Group</button>
			<button id="viewCusGroupBtn" style="display:none;" type="button" onclick="return customizeGroupAction('view');">View Customize Group</button>
		</div>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Send By</td>
		<td class="infoData" width="70%">
				<input onclick="changeSendBy()" type="radio" name="sendBy" value="team20" checked>Team 20</input>
				<input onclick="changeSendBy()" type="radio" name="sendBy" value="cusGroup" >Customize Groups</input>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Type</td>
		<td class="infoData" width="70%">
				<input onclick="changeType()" type="radio" name="sendType" value="email" checked>Email</input>
				<input onclick="changeType()" type="radio" name="sendType" value="sms" >SMS</input>
		</td>
	</tr>
	<tr class="smallText" id="emailActionRow" style="display:none;">
		<td class="infoLabel" width="30%">Email Title</td>
		<td class="infoData" width="70%">
			<input  type='text' name='emailAction' style='width:100%' value=''/>
		</td>
	</tr>
	<tr class="smallText"  id="smsLangRow" style="display:none;">
		<td class="infoLabel" width="30%">SMS Length</td>
		<td class="infoData" width="70%">
		- For 1 SMS: (up to 160 Eng. chars.), & (70 Chinese / UTF chars., 60 chars. for China)<br/>
		- For 2 SMS: (up to 306 Eng. chars.), & (134 Chinese / UTF chars., 120 chars. for China)<br/>
		- For 3 SMS: (up to 459 Eng. chars.), & (201 Chinese / UTF chars., 180 chars. for China)<br/>
		- For 4 SMS: (up to 612 Eng. chars.), & (268 Chinese / UTF chars., 240 chars. for China)<br/>
		- For 5 SMS: (up to 765 Eng. chars.), & (335 Chinese / UTF chars., 300 chars. for China)<br/>
		- To send to multiple numbers, separate each number with a comma, (Max receivers: 5) 
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Message</td>
		<td class="infoData" width="70%">
			<textarea name='message'rows="5" cols="100%"
			 onkeydown="numOfCharacter()" onkeyup="numOfCharacter()"></textarea>
		</td>
	</tr>
	<tr id="limitDisplayRow">
	<td></td>
	<td style="text-align:right;"><font size="1">(No. of characters: <span id=textAreaLimit>0</span>)</font></td>
	</tr>	

	<tr class="smallText">
		<td colspan="2" align="center">
			<button type="button" onclick="submitAction()">Submit</button>
			<button type="button" onclick="window.location.reload()">Reset</button>
		</td>
	</tr>
</table>
</form>
<table width="100%" border="0">

</table>
<div id='changePage'></div>

<script language="javascript">
function submitAction(){
	var sendType = $('input[name=sendType]:checked').val();
	var sendBy = $('input[name=sendBy]:checked').val();
	
	var team20 = $('#team20 option:selected').val();
	var cusGroup = $('#cusGroup option:selected').val();
	var message=encodeURIComponent($('textarea[name=message]').val());		
	var sendMsg = confirm("Send Message?");
	   if( sendMsg == true ){	
			if(sendType == 'email'){		
				var action=encodeURIComponent($('input[name=emailAction]').val());		
				
				$.ajax({
					url: "../../crm/portal/sendEmailSMSAction.jsp?type=sendEmail&team20="+team20+"&message="+message+"&action="+action+"&sendBy="+sendBy+"&cusGroup="+cusGroup,
					async:false,
					cache:false,
					success: function(values){	
						if(values){							
							$('#changePage').html(values);
							$('#changePage').html('');
							clearAllValues();
						}else {
							alert("Error occured while sending email to clients.");
						}				
					}//success
				});//$.ajax	   
			}else if(sendType == 'sms'){	
				$.ajax({
					url: "../../crm/portal/sendEmailSMSAction.jsp?type=sendSMS&team20="+team20+"&message="+message+"&sendBy="+sendBy+"&cusGroup="+cusGroup,
					async:false,
					cache:false,
					success: function(values){					
						if(values){	
							$('#changePage').html(values);
							$('#changePage').html('');
							clearAllValues();
						}else {
							alert("Error occured while sending SMS to clients.");
						}				
					}//success
				});//$.ajax	 
			}
	 }
}

function changeType(){
	var sendType = $('input[name=sendType]:checked').val();
	if(sendType == 'email'){
		$('#emailActionRow').show();
		$('#smsLangRow').hide();
		
	}else if(sendType == 'sms'){
		$('#emailActionRow').hide();
		$('#smsLangRow').show();
	}
}

function changeSendBy(){
	var sendBy = $('input[name=sendBy]:checked').val();
	if(sendBy == 'cusGroup'){
		$('#cusGroupRow').show();
		$('#team20Row').hide();
		
	}else if(sendBy == 'team20'){
		$('#cusGroupRow').hide();
		$('#team20Row').show();
	}
}


function numOfCharacter() {	
		$('#textAreaLimit').html($('textarea[name=message]').val().length);	
}

function clearAllValues(){
	$('textarea[name=message]').val('');
	$('input[name=emailAction]').val('');
	$('#textAreaLimit').html($('textarea[name=message]').val().length);	
}

$(document).ready(function() {			
	changeType();
});

function customizeGroupAction(cmd) {
	
	callPopUpWindow("sms_email_group_control.jsp?command="+cmd+"&cusGroupID="+$('select[name=cusGroup] :selected').val());	
	return false;
}

$('select[name=cusGroup]').change(function() {
	  
	  if(this.value){
		  $('#createCusGroupBtn').hide();
		  $('#viewCusGroupBtn').show();
	  }else{
		  $('#createCusGroupBtn').show();
		  $('#viewCusGroupBtn').hide();
	  }
});

</script>
</DIV>

</DIV></DIV>

<jsp:include page="../../common/footer.jsp" flush="false" />
</body>
</html:html>