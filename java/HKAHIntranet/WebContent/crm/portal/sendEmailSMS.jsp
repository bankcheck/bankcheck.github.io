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
<DIV id=contentFrame style="width:100%;height:100%">
<jsp:include page="../../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Send Email/SMS" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>

<form name="form1">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">	
	<tr id='defaultTableRow'><td colspan="2"><table style="width:100%">
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
			<td colspan="2">
				<table id='cusGroupEmailTable' border="0" cellpadding="0" cellspacing="0" style="width:100%">
					<tr>
						<td class="infoLabel" width="30%">
							Team 20
						</td>
						<td class="infoData" width="70%">
							<select id="team20" name="team20" onchange="selectTeamEvent(this)">
								<option value=""></option>
								<jsp:include page="../../ui/clientGroupCMB.jsp" flush="false">
									<jsp:param name="groupID" value="<%=team20 %>" />
									<jsp:param name="allowEmpty" value="F" />
								</jsp:include>
							</select>
						</td>
					</tr>
					<tr style="width:100%">
						<td class="infoLabel" >Name</td>
						<td class="infoData" >
							<select  style="width:100%" name="team20_member">
							</select>
						</td>
					</tr>
					<tr>
						<td class="infoLabel">Email</td>
						<td class="infoData" >
							<input type="textbox" style="width:50%" disabled="disabled" name="team20_memberEmail" />
							
						</td>
					</tr>
					<tr>
					<td></td>
					<td>					
						<button type="button" style="height:100%;" onclick="insertEmailEvent('insertTo')" class="insertTO ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
							Add
						</button>
					</td>
					</tr>
					<tr>
						<td class="infoLabel">Client Email</td>
						<td class="infoData" colspan="5">
							<div class="toClientEmail"></div>
						</td>
					</tr>
				</table>
				<table id='cusGroupSMSTable' border="0" cellpadding="0" cellspacing="0" style="width:100%;display:none;">
					<tr>
						<td class="infoLabel" width="30%">
							Team 20
						</td>
						<td class="infoData" width="70%">
							<select id="team20_sms" name="team20_sms" onchange="selectTeamEvent(this)">
								<option value=""></option>
								<jsp:include page="../../ui/clientGroupCMB.jsp" flush="false">
									<jsp:param name="groupID" value="<%=team20 %>" />
									<jsp:param name="allowEmpty" value="F" />
								</jsp:include>
							</select>
						</td>
					</tr>
					<tr style="width:100%">
						<td class="infoLabel" >Name</td>
						<td class="infoData" >
							<select  style="width:100%" name="team20_member_sms">
							</select>
						</td>
					</tr>
					<tr>
						<td class="infoLabel">SMS</td>
						<td class="infoData" >
							<input type="textbox" style="width:50%" disabled="disabled" name="team20_memberSms" />
							
						</td>
					</tr>
					<tr>
					<td></td>
					<td>					
						<button type="button" style="height:100%;" onclick="insertSMSEvent('insertTo')" class="insertSMS ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
							Add
						</button>
					</td>
					</tr>
					<tr>
						<td class="infoLabel">Client SMS</td>
						<td class="infoData" colspan="5">
							<div class="toClientSms"></div>
						</td>
					</tr>
				</table>
			</td>
		</tr>	
		<tr id='sendByRow' class="smallText">
			<td class="infoLabel" width="30%">Send By</td>
			<td class="infoData" width="70%">
					<input onclick="changeSendBy()" type="radio" name="sendBy" value="team20" checked>Team 20</input>
					<input onclick="changeSendBy()" type="radio" name="sendBy" value="cusGroup" >Customize Send</input>
			</td>
		</tr>
	</table></td></tr>
	<tr id='eventRow' class="smallText">
		<td class="infoLabel" width="30%">Event Name</td>
		<td class="infoData" width="70%">					
			<jsp:include page="../../ui/crmEventIDCMB.jsp" flush="false">
				<jsp:param name="allowEmpty" value="Y" />
				<jsp:param name="selectID" value="eventSelect" />
				<jsp:param name="selectName" value="eventSelect" />
				<jsp:param name="onChangeName" value="selectTeamEvent" />
			</jsp:include>		
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Type</td>
		<td class="infoData" width="70%">
				<input onclick="changeType()" type="radio" name="sendType" value="email" checked>Email</input>
				<input onclick="changeType()" type="radio" name="sendType" value="sms" >SMS</input>
				<input onclick="changeType()" type="radio" name="sendType" value="event" >Event Email</input>
		</td>
	</tr>
	<tr id='defaultTableDetailRow'><td colspan="2"><table style="width:100%">
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
	</table></td></tr>
	<tr id='eventDetailRow'><td colspan='2'><table style='width:100%'>
		<tr class="smallText">
			<td class="infoLabel" width="30%">Email Title</td>
			<td class="infoData" width="70%">
				<input  type='text' name='eventEmailTitle' style='width:100%' value=''/>
			</td>
		</tr>
		<tr>
			<td class="infoLabel" width="30%">Message</td>
			<td class="infoData" width="70%">				
				<textarea name='eventEmailMessage'rows="5" cols="100%"></textarea>
			</td>
		</tr>
		</tr>
	</table></td></tr>
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
	
	var message=encodeURIComponent($('textarea[name=message]').val());		
	var sendMsg = confirm("Send Message?");
	   if( sendMsg == true ){	
			if(sendType == 'email'){		
				var action=encodeURIComponent($('input[name=emailAction]').val());
				
				var allToClient = '' ;
				$("input[class=toEmail]").each(function() {
					allToClient=allToClient+'&allToClient='+$(this).attr('clientID');
				});
				if(sendBy == 'cusGroup'){
					if(allToClient){
						
					}else{
						alert('Clients Email are empty.');
						return;
					}					
				}
				
				
				$.ajax({
					url: "../../crm/portal/sendEmailSMSAction.jsp?type=sendEmail&team20="+team20+"&message="+message+"&action="+action+"&sendBy="+sendBy+allToClient,
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
				var allToClient = '' ;
				$("input[class=toSms]").each(function() {
					allToClient=allToClient+'&allToClient='+$(this).attr('clientID');
				});
				if(sendBy == 'cusGroup'){
					if(allToClient){
						
					}else{
						alert('Clients SMS are empty.');
						return;
					}					
				}
				
				
				$.ajax({
					url: "../../crm/portal/sendEmailSMSAction.jsp?type=sendSMS&team20="+team20+"&message="+message+"&sendBy="+sendBy+allToClient,
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
			}else if(sendType == 'event'){
				$('input[name=eventEmailTitle]').val();
				
				var eEmailTitle = encodeURIComponent($('input[name=eventEmailTitle]').val());
				var eEmailMessage = encodeURIComponent(nl2br($('textarea[name=eventEmailMessage]').val()));
				
				var eid = $('select[name=eventSelect]').find('option:selected').val();		
				
				var eventID = $('input[name=event_eventID_'+eid+']').val();
				var scheduleID = $('input[name=event_scheduleID_'+eid+']').val();
				
				$.ajax({					
					url: "../../crm/portal/sendEmailSMSAction.jsp?type=sendEventEmail&message="+
						 "&eventEmailTitle="+eEmailTitle+"&eventEmailMessage="+eEmailMessage+
						 "&eventID="+eventID+"&scheduleID="+scheduleID,
					async:false,
					cache:false,
					success: function(values){	
						if(values){							
							$('#changePage').html(values);
							$('#changePage').html('');
							
						}else {
							alert("Error occured while sending email to clients.");
						}				
					}//success
				});//$.ajax	   
			}
	 }
}

	function nl2br (str, is_xhtml) {   
	var breakTag = (is_xhtml || typeof is_xhtml === 'undefined') ? '<br />' : '<br>';    
	return (str + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1'+ breakTag +'$2');
	}

function changeType(){
	var sendType = $('input[name=sendType]:checked').val();
	if(sendType == 'email'){
		$('#emailActionRow').show();
		$('#smsLangRow').hide();
		$('#cusGroupEmailTable').show();
		$('#cusGroupSMSTable').hide();
		$('#defaultTableRow').show();
		$('#eventRow').hide();
		$('#defaultTableDetailRow').show();
		$('#eventDetailRow').hide();
	}else if(sendType == 'sms'){
		$('#emailActionRow').hide();
		$('#smsLangRow').show();
		$('#cusGroupEmailTable').hide();
		$('#cusGroupSMSTable').show();
		$('#defaultTableRow').show();
		$('#eventRow').hide();
		$('#defaultTableDetailRow').show();
		$('#eventDetailRow').hide();
	}else if(sendType == 'event'){
		$('#defaultTableRow').hide();
		$('#eventRow').show();
		$('#defaultTableDetailRow').hide();
		$('#eventDetailRow').show();
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


function selectTeamEvent(obj) {	
	
	var sendType = $('input[name=sendType]:checked').val();
	
	if(sendType=='email'){
		var selectDom = $('select[name=team20_member]');	
		if($(obj).find('option:selected').val()){			
			$.ajax({
				url: "../../ui/clientGroupMemCMB.jsp?groupID="+$(obj).find('option:selected').val(),
				async:false,
				cache:false,
				success: function(values){	
					selectDom.html('');
					selectDom.html(values);
					selectStaffEvent();			
					$('input[name=team20_memberEmail]').val($('select[name=team20_member]').find('option:selected').attr('email'));
				}//success
			});//$.ajax	
		}else{
			selectDom.html('');
			selectStaffEvent();
			$('input[name=team20_memberEmail]').val('');		
		}
	}else if(sendType=='sms'){
		var selectDom = $('select[name=team20_member_sms]');	
		if($(obj).find('option:selected').val()){			
			$.ajax({
				url: "../../ui/clientGroupMemCMB.jsp?groupID="+$(obj).find('option:selected').val(),
				async:false,
				cache:false,
				success: function(values){						
					selectDom.html('');
					selectDom.html(values);
					selectStaffEvent();			
					$('input[name=team20_memberSms]').val($('select[name=team20_member_sms]').find('option:selected').attr('sms'));
				}//success
			});//$.ajax	
		}else{
			selectDom.html('');
			selectStaffEvent();
			$('input[name=team20_memberSms]').val('');		
		}
	}else if(sendType=='event'){
		var eid = $(obj).find('option:selected').val();
		
		var etitle = $('input[name=event_eventTitle_'+eid+']').val();
		var edate = $('input[name=event_eventDate_'+eid+']').val();
		var etime = $('input[name=event_eventTime_'+eid+']').val();
		var elocation = $('input[name=event_eventLocation_'+eid+']').val();
		
		$('input[name=eventEmailTitle]').val('Lifestyle Management Center - You have a new event!');
		$('textarea[name=eventEmailMessage]').val('Dear Sir/Madam,\r\n\r\n'+
		  				                          'You (Client Name) are enrolled in '+etitle+' successfully.\r\n\r\n'+
										          'The information of the event is following:\r\n'+
												  'Event: '+etitle+'\r\n'+
												  'Date: '+edate+'\r\n'+
												  'Time: '+etime+'\r\n'+
												  'Location: '+elocation+'\r\n'+
												  'Best Regards,\r\n'+
												  'Lifestyle Management Center');		
		
	}
}

function selectStaffEvent() {
	var sendType = $('input[name=sendType]:checked').val();	
	if(sendType=='email'){
		$('select[name=team20_member]').change(function() {
			var email = '';	
			email = $(this).find('option:selected').attr('email');	
			$('input[name=team20_memberEmail]').val(email);	
		});
	}else if(sendType=='sms'){
		$('select[name=team20_member_sms]').change(function() {
			var sms = '';	
			sms = $(this).find('option:selected').attr('sms');	
			$('input[name=team20_memberSms]').val(sms);	
		});
	}
}

function insertEmailEvent(type) {	
	if(type=='insertTo'){
		
		if($('input[name=team20_memberEmail]').val().length > 0) {
			
			var content = "<div class='removeEmail'>"+
							"["+$('select[name=team20_member]').find('option:selected').html()+
							": <b>"+$('input[name=team20_memberEmail]').val()+"]</b> "+
							"<img style='cursor:pointer' onClick='removeEmailEvent(this)' class='removeEmailImg' src='../../images/delete1.png'/><br/>"+
							"<input type='hidden' class='toEmail' clientID='"+$('select[name=team20_member]').find('option:selected').val()+"' value='"+$('input[name=team20_memberEmail]').val()+"'/>"+
						  "</div>";			
			$('div.toClientEmail').append(content);
			
		}
		else {
			alert("It does not have email address.");
		}
		return false;
	}
}

function insertSMSEvent(type) {	
	if(type=='insertTo'){
		
		if($('input[name=team20_memberSms]').val().length > 0) {
			
			var content = "<div class='removeSms'>"+
							"["+$('select[name=team20_member_sms]').find('option:selected').html()+
							": <b>"+$('input[name=team20_memberSms]').val()+"]</b> "+
							"<img style='cursor:pointer' onClick='removeSMSEvent(this)' class='removeSmsImg' src='../../images/delete1.png'/><br/>"+
							"<input type='hidden' class='toSms' clientID='"+$('select[name=team20_member_sms]').find('option:selected').val()+"' value='"+$('input[name=team20_memberSms]').val()+"'/>"+
						  "</div>";			
			$('div.toClientSms').append(content);
			
		}
		else {
			alert("It does not have mobile number.");
		}
		return false;
	}
}

function removeEmailEvent(obj) {
	$('img.removeEmailImg').unbind('click');	
	$(obj).parent().remove();
	
}

function removeSMSEvent(obj) {
	$('img.removeSmsImg').unbind('click');	
	$(obj).parent().remove();
	
}
</script>
</DIV>
<jsp:include page="../../common/footer.jsp" flush="false" />
</body>
</html:html>