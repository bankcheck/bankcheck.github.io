<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%!
public static ArrayList getStatus(String pirID){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT PIRID,PIR_REJECT,PIR_FLWUP,PIR_FLWUP_COMPLETE,PIR_FINAL_FACTOR,PIR_FINAL_REC,PIR_CLOSE_EVAL,PIR_CLOSE_HAPPEN,MODIFIED_USER  ");	
	sqlStr.append("FROM PI_REPORT_STATUS ");
	sqlStr.append("WHERE PIRID ='"+pirID+"' ");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String pirID = request.getParameter("pirID");
String statusType = request.getParameter("statusType");

Calendar cal = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm", Locale.ENGLISH);

String reject=request.getParameter("reject");
String follow=request.getParameter("follow");
String complete=request.getParameter("complete");
String contributingFactors=request.getParameter("contributingFactors");
String recommendation=request.getParameter("recommendation");
String evaluation=request.getParameter("evaluation");
String closeLoop=request.getParameter("closeLoop");

boolean viewAction = false;
boolean editAction = false;
if("view".equals(statusType)){
	viewAction = true;
}else if("edit".equals(statusType)){
	editAction = true;
}

ArrayList statusRecord = getStatus(pirID);
if(statusRecord.size() > 0)	{
	ReportableListObject statusRow = (ReportableListObject)statusRecord.get(0);
	
	reject=statusRow.getValue(1);
	follow=statusRow.getValue(2);
	complete=statusRow.getValue(3);
	contributingFactors=statusRow.getValue(4);
	recommendation=statusRow.getValue(5);
	evaluation=statusRow.getValue(6);
	closeLoop=statusRow.getValue(7);
		
}


String status = request.getParameter("status");
%>
<iframe name='hidden_frame' id="hidden_frame" style="visibility:hidden;width:0px;height:0px;border:0px;"></iframe>
<form name="furtherActionForm" enctype="multipart/form-data" action="furtherActionCommit.jsp"
		method="post" target="hidden_frame">
	<div id="processMsg"></div>
	<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0" width="100%" style="<%=(userBean.isAccessible("function.pi.report.admin")?"":"display:none;")%>">
		<tr class="smallText">
			<td colspan="2" class="infoSubTitle5">Report Status</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel" width="30%">Reject Incident?</td>
			<td class="infoData" width="70%">
		<%if(userBean.isAccessible("function.pi.report.admin")&&editAction) {%>
				<input <%=(editAction?"":"disabled") %> <%=("Y".equals(reject)?"checked":"")%> name="reject" type="radio" value="Y" />Yes
				<input <%=(editAction?"":"disabled") %> <%=("N".equals(reject)?"checked":"")%> name="reject" type="radio" value="N" />No
				
		<%}else {
			String tempReject = "";
			if("Y".equals(reject)){
				tempReject = "Yes";
			}else if("N".equals(reject)){
				tempReject = "No";
			}
			%> 			 
			<div style="display:none;"><input <%=("Y".equals(reject)?"checked":"")%> name="reject" style="display:none;" type="radio" value="Y" />Yes</div>
			<div style="display:none;"><input <%=("N".equals(reject)?"checked":"")%> name="reject" style="display:none;" type="radio" value="N" />No</div>
			<%=tempReject %>
		<%} %>                        
			</td>
		</tr>
		<tr id="followUp" class="smallText" style="display:none;">
			<td class="infoLabel" width="30%">Futher follow-up / notification required?</td>
			<td class="infoData" width="70%">
		<%if(userBean.isAccessible("function.pi.report.admin")&&editAction) { %>
				<input <%=(editAction?"":"disabled") %> <%=("Y".equals(follow)?"checked":"")%> name="follow" type="radio" value="Y" />Yes
				<input <%=(editAction?"":"disabled") %> <%=("N".equals(follow)?"checked":"")%> name="follow" type="radio" value="N" />No
		<%}else { 
			String tempFollow = "";
			if("Y".equals(follow)){
				tempFollow = "Yes";
			}else if("N".equals(follow)){
				tempFollow = "No";
			}
		%>
			 <div style="display:none;"><input <%=("Y".equals(follow)?"checked":"")%> name="follow" type="radio" value="Y" />Yes</div>
			<div style="display:none;"><input <%=("N".equals(follow)?"checked":"")%> name="follow" type="radio" value="N" />No</div>
			<%=tempFollow %>
		<%} %> 
			</td>
		</tr>
	</table>
	
	<table class="assignFollow contentFrameMenu" cellpadding="0" cellspacing="5" border="0" width="100%" style="display:none;">
		<tr class="smallText">
			<td colspan="8" class="infoSubTitle5">Follow Up</td>
		</tr>
	</table>
	
	<div align="center" class="flwUp-pane assignFollow" style='display:none;
				width:100%;padding-left:5px;height:600px;'>
		 <div style="float:left; width:13.5%; height:100%">
		 	<div class='flwUpList scroll-pane jspScrollable' style='overflow: hidden; padding: 0px; width:100%; height:100%;'>
			 </div>
		 </div>
		 <div style="float:right; width:85%; padding-right:10px; height:100%;">
			 <div class="flwup-content scroll-pane jspScrollable" style='overflow: hidden; padding: 0px; width:100%; height:100%;'>
			 </div>
		</div>
	</div>
	<br/>
		<table class="assignFollow contentFrameMenu" cellpadding="0" cellspacing="5" border="0" width="100%" style="display:none;">
			<tr class="smallText">
				<td colspan="2" class="infoSubTitle5">Follow Up Status</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="15%">Completed?</td>
				<td class="infoData" >
			<%if(userBean.isAccessible("function.pi.report.admin")&&editAction) { %>	
					<input <%=(editAction?"":"disabled") %> <%=("Y".equals(complete)?"checked":"")%> name="complete" type="radio" value="Y"/>Yes
					<input <%=(editAction?"":"disabled") %> <%=("N".equals(complete)?"checked":"")%> name="complete" type="radio" value="N"/>No				
			<%}else {
				String tempComplete = "";
				if("Y".equals(complete)){
					tempComplete = "Yes";
				}else if("N".equals(complete)){
					tempComplete = "No";
				}
			%>
					<div style="display:none;">
						<input <%=("Y".equals(complete)?"checked":"")%> name="complete" type="radio" value="Y"/>Yes
						<input <%=("N".equals(complete)?"checked":"")%> name="complete" type="radio" value="N"/>No
					</div>
			<%=tempComplete%>
			<%} %> 
				</td>
			</tr>
		</table>
	
	
	<%if(userBean.isAccessible("function.pi.report.admin")) { %>
		<table class="finalReview contentFrameMenu" cellpadding="0" cellspacing="5" border="0" width="100%" style="display:none;">
			<tr class="smallText">
				<td colspan="2"  class="infoSubTitle5">Final Review</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="15%">Key Contributing Factors</td>
				<td  class="infoData" >
				<%if(editAction){ %>
					<textarea  rows="5" style='width:100%' name="contributingFactors"><%=(contributingFactors==null?"":contributingFactors)%></textarea>
				<%}else{ %>
					<%=(contributingFactors==null?"":contributingFactors)%>
				<%} %>
				</td>
			</tr>		
			<tr class="smallText">
				<td class="infoLabel" width="15%">Recommendation</td>
				<td class="infoData" >
				<%if(editAction){ %>
					<textarea rows="5" style='width:100%' name="recommendation"><%=(recommendation==null?"":recommendation)%></textarea>
				<%}else{ %>
					<%=(recommendation==null?"":recommendation)%>
				<%} %>				
				</td>
			</tr>			
		</table>
	<%} %> 
	
	<%if(userBean.isAccessible("function.pi.report.admin")) { %>
		<table class="finalReview contentFrameMenu" cellpadding="0" cellspacing="5" border="0" width="100%" style="display:none;">
			<tr class="smallText">
				<td colspan="2" class="infoSubTitle5">Close The Loop</td>				
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="15%">Evaluation</td>
				<td class="infoData" >
				<%if(editAction){ %>
					<textarea rows="5" style='width:100%' name="evaluation"><%=(evaluation==null?"":evaluation)%></textarea>
				<%}else{ %>
					<%=(evaluation==null?"":evaluation)%>
				<%} %>				
				</td>
			</tr>		
			<tr class="smallText">
				<td class="infoLabel" width="15%">Happen Again within</td>
				<td class="infoData" >
				<%if(editAction){ %>
					<textarea rows="5" style='width:100%' name="closeLoop"><%=(closeLoop==null?"":closeLoop)%></textarea>
				<%}else{ %>
					<%=(closeLoop==null?"":closeLoop)%>
				<%} %>
				</td>
			</tr>
		</table>
	<%} %> 
	<input name="flwStatus" type="hidden" value="<%=status %>"/>	
	<input name="flwContent" type="hidden" value=""/>
	<br/>
	<%if(userBean.isAccessible("function.pi.report.admin")) { %>
	
	<div align="center">
	<%if(editAction){ %>
		<button type="button" onclick="return submitStatus('<%=pirID%>','submit');">Update Status</button>
	<%}else{ %>
		<button type="button" onclick="return submitStatus('<%=pirID%>','edit');">Edit Status</button>	
	<%} %>	
	</div>
	<%} %>
</form>

<script language="javascript">
$(document).ready(function() {
	init();
	
		$('input[name=reject]:checked').trigger('click');
		$('input[name=follow]:checked').trigger('click');		
		$('input[name=complete]:checked').trigger('click');
	
	getFollowUp($('div.flwUpList'), 'list');
});


function init() {
	$('input[name=reject]').click(function() {
		if($(this).val() == "N") {
			$('tr#followUp').css('display', '');
			$('input[name=follow]:checked').trigger('click');
			$('input[name=complete]:checked').trigger('click');
		}
		else {
			$('tr#followUp').css('display', 'none');
			$('.assignFollow').css('display', 'none');
			$('.finalReview').css('display', 'none');
		}
	});
	
	$('input[name=follow]').click(function() {
		if($(this).val() == "Y") {
			$('.assignFollow').css('display', '');			
		}else {
			$('.assignFollow').css('display', 'none');
			$('.finalReview').css('display', 'none');
		}
	});
	
	$('input[name=complete]').click(function() {	
		if($(this).val() == "Y") {
			$('.finalReview').css('display', '');			
		}else {
			$('.finalReview').css('display', 'none');
		}
	});
}

function deleteFile(dom) {
	$(dom).parent().parent().find('input[filename='+$(dom).prev().html().replace(".", "")+']').remove();
	$(dom).prev().remove();
	$(dom).next().remove();
	$(dom).remove();
}

function addFile(dom) {
	var filePath = $(dom).val();
	var fileName = $(dom).val().substr($(dom).val().lastIndexOf('\\')+1);
	
	$(dom).parent()
		.find('.uploadList')
			.append('<span path='+filePath+'>'+fileName+'</span> <img style="cursor:pointer" src="../images/delete4.png" onclick="deleteFile(this)"/><br/>');
	
	$(dom).after('<input type="file" name="reply_attachment" onchange="addFile(this)"/>');
	$(dom).css('display', 'none').attr('filename', fileName.replace(".", ""));
}

function createNewContent(obj){
	$('button.flwUpBtn').unbind('click');	
	if(!$(obj).hasClass('selected')) {
		$('button.flwUpBtn.selected').removeClass('selected');
		$(obj).addClass('selected');
		getFollowUp($('div.flwup-content'), 'action');		
	}
	
}

function selectFlwUpEvent(obj) {
	$('button.flwUpBtn').unbind('click');
	
	if(!$(obj).hasClass('selected')) {
		$('button.flwUpBtn.selected').removeClass('selected');
		$(obj).addClass('selected');		
		getFollowUp($('div.flwup-content'), 'action');
	}
	return false;	
}

function getFollowUp(target, type,flwUpID) {
	$.ajax({
		url: "followUp.jsp",
		data: "type="+type+"&pirID="+<%=pirID%>+"&flwUpID="+flwUpID,
		async:false,
		cache: false,
		success: function(values){
			if(type == 'action' || type == 'reply') {
				var pane = target.data('jsp');				
				var originalContent = pane.getContentPane().html();				
				pane.getContentPane().html(values);			
				pane.reinitialise();
				
				$('input[name=followUp_email]').click(function() {
					if($(this).val() == "Y") {						
						$('#emailDisplaySpan').css('display', '');			
					}else {
						$('#emailDisplaySpan').css('display', 'none');
					}
				});
			}else if(type == 'list') {
				
				target.html(values);				
				initScroll('.flwUp-pane', true);				
				
				if($('button.flwUpBtn').length > 0) {
					selectFlwUpEvent($('button.flwUpBtn:first'));
				}				
			}
		},
		error: function(x, q, r) {
			alert("Error in getting template.");
		}
	});
}

function selectDeptEvent(obj) {
	var selectDom = $('select[name=followUp_staff]');
	
	$.ajax({
		url: "../ui/staffIDCMB.jsp?allowEmpty=Y&deptCode="+
			$(obj).find('option:selected').val()+
			"&siteCode=hkah",
		async:false,
		cache:false,
		success: function(values){				
			selectDom.html(values);
			selectStaffEvent();
			$('input[name=followUp_staffEmail]').val('');
			$('button.saveEmail').hide();
		}//success
	});//$.ajax	
}

function selectStaffEvent() {
	$('select[name=followUp_staff]').change(function() {
		var email = '';
		if($(this).find('option:selected').html().indexOf('All Staff')==-1){
			email = $(this).find('option:selected').attr('email');						
			$('button.saveEmail').show();							
			
		}else{
			$('button.saveEmail').hide();	
		}
		$('input[name=followUp_staffEmail]').val(email);
	});
}

function insertEmailEvent(type) {
	if(type=='insertTo'){
		if($('input[name=followUp_staffEmail]').val().length > 0) {
			var content = "<div class='removeEmail'>"+
							"["+$('select[name=followUp_staff]').find('option:selected').html()+
							": <b>"+$('input[name=followUp_staffEmail]').val()+"]</b> "+
							"<img style='cursor:pointer' onClick='removeEmailEvent(this)' class='removeEmailImg' src='../images/delete1.png'/><br/>"+
							"<input type='hidden' class='toEmail' value='"+$('input[name=followUp_staffEmail]').val()+"'/>"+
						  "</div>";
			
			$('div.flwup-content')
				.find('div.toStaff').append(content);
			
		}
		else {
			alert("It does not have email address.");
		}
		return false;
	}else if(type=='insertCC'){	
		if($('input[name=followUp_staffEmail]').val().length > 0) {
			var content = "<div class='removeEmail'>"+
							"["+$('select[name=followUp_staff]').find('option:selected').html()+
							": <b>"+$('input[name=followUp_staffEmail]').val()+"]</b> "+
							"<img style='cursor:pointer' onClick='removeEmailEvent(this)' class='removeEmailImg' src='../images/delete1.png'/><br/>"+
							"<input type='hidden' class='ccEmail' value='"+$('input[name=followUp_staffEmail]').val()+"'/>"+
						  "</div>";
						  
			$('div.flwup-content')
				.find('div.ccStaff').append(content);			
		}
		else {
			alert("It does not have email address.");
		}
		return false;
	}else if(type=='insertBCC'){
		if($('input[name=followUp_staffEmail]').val().length > 0) {
			var content = "<div class='removeEmail'>"+
							"["+$('select[name=followUp_staff]').find('option:selected').html()+
							": <b>"+$('input[name=followUp_staffEmail]').val()+"]</b> "+
							"<img style='cursor:pointer' onClick='removeEmailEvent(this)' class='removeEmailImg' src='../images/delete1.png'/><br/>"+
							"<input type='hidden' class='bccEmail' value='"+$('input[name=followUp_staffEmail]').val()+"'/>"+
						  "</div>";
						  
			$('div.flwup-content')
				.find('div.bccStaff').append(content);			
		}
		else {
			alert("It does not have email address.");
		}
		return false;
	}
}

function removeEmailEvent(obj) {
	$('img.removeEmailImg').unbind('click');	
	$(obj).parent().remove();
	
}

function addReplyEvent(obj) {	
		getFollowUp($('div.flwup-content').find('table.content-table:last')
						.find('td.replyContent'), 'reply');
		return false;	
}

function saveStaffEmail(){
	   var staffEmail = $('input[name=followUp_staffEmail]').val();
	   var staffID = $('select[name=followUp_staff] option:selected').attr('value');	
	   var staffName = $('select[name=followUp_staff] option:selected').html();
	   var changeEmail = confirm("Change "+staffName+" email address to "+staffEmail+"?");
	   
	   if( changeEmail == true ){			  
			$.ajax({
				url: "../pi/furtherActionCommit.jsp?type=changeStaffEmail&staffEmail="+staffEmail+"&staffID="+staffID,
				async:false,
				cache:false,
				success: function(values){	
					if(values.indexOf('true')!=-1){					
						alert("Staff Email Address updated successfully.");
					}else {
						alert("Error occured while updating Staff Email Address.");
					}				
				}//success
			});//$.ajax
	   }
}

function sendEmail(pirID){
	var allToStaff='';
	$("input[class=toEmail]").each(function() {
		allToStaff=allToStaff+'&allToStaff='+$(this).val();
	});
	
	var allCcStaff='';
	$("input[class=ccEmail]").each(function() {
		allCcStaff=allCcStaff+'&allCcStaff='+$(this).val();
	});
	
	var allBccStaff='';
	$("input[class=bccEmail]").each(function() {
		allBccStaff=allBccStaff+'&allBccStaff='+$(this).val();
	});
	
	var action=encodeURIComponent($('input[name=followUp_action]').val());
	var remark=encodeURIComponent($('textarea[name=followUp_remark]').val());	
	var emailNotice = $("input[name=followUp_email]:checked").val();
	var reminder = $("input[name=followUp_reminder]:checked").val();
	var status = $("input[name=followUp_status]:checked").val();
	$.ajax({
		url: "../pi/furtherActionCommit.jsp?type=sendEmail&pirID="+pirID+allToStaff+allCcStaff+allBccStaff+'&action='+action
				+'&remark='+remark+'&emailNotice='+emailNotice+'&reminder='+reminder+'&status='+status,
		async:false,
		cache:false,
		success: function(values){	
			if(values.indexOf('true')!=-1){		
				alert("Staff Email Address updated successfully.");
				getFollowUp($('div.flwUpList'), 'list');
				
			}else {
				alert("Error occured while updating Staff Email Address.");
			}				
		}//success
	});//$.ajax	   
}

function removeEmail(obj){
	var deleteEmail = confirm("Delete Email ?");
	if( deleteEmail == true ){	
		var pirID = $(obj).attr('pirID');
		var flwUpID = $(obj).attr('flwUpID');	
		$.ajax({
			url: "../pi/furtherActionCommit.jsp?type=deleteEmail&pirID="+pirID+"&flwUpID="+flwUpID,
			async:false,
			cache:false,
			success: function(values){	
				if(values.indexOf('true')!=-1){		
					alert("Email deleted successfully.");
					getFollowUp($('div.flwUpList'), 'list');
					
				}else {
					alert("Error occured while deleteing Email Address.");
				}				
			}//success
		});//$.ajax	   
	}
}

function displaySelectedEmail(obj){
	$('button.flwUpBtn').unbind('click');	
	if(!$(obj).hasClass('selected')) {
		$('button.flwUpBtn.selected').removeClass('selected');
		$(obj).addClass('selected');
		
		target = $('div.flwup-content');
		
		getFollowUp(target, 'reply',$(obj).attr('flwUpID'));	
	}	
}

function submitReply(pirID,flwUpID){
	var reply=encodeURIComponent($('textarea[name=followUp_reply_msg]').val());		
	$.ajax({
		url: "../pi/furtherActionCommit.jsp?type=submitReply&pirID="+pirID+"&flwUpID="+flwUpID+"&reply="+reply,
		async:false,
		cache:false,
		success: function(values){	
			if(values.indexOf('true')!=-1){		
				alert("Staff Reply updated successfully.");
				
				target = $('div.flwup-content');
				getFollowUp(target, 'reply',$('button.flwUpBtn.selected').attr('flwUpID'));
			}else {
				alert("Error occured while updating Staff Reply.");
			}				
		}//success
	});//$.ajax	   
}

function submitStatus(pirID,type){
	//alert($("input[name=flwstatus]").val());
	if(type=='submit'){		
		var reject = $("input[name=reject]:checked").val();
		if(!(typeof(reject) !== 'undefined' && reject != null)) {
		    reject="";
		}		
		var follow = $("input[name=follow]:checked").val();
		if((!(typeof(follow) !== 'undefined' && follow != null))||($('input[name=follow]').is(":visible"))==false) {
		    follow="";
		}
		
		var complete = $("input[name=complete]:checked").val();
		if((!(typeof(complete) !== 'undefined' && complete != null))||($('input[name=complete]').is(":visible"))==false) {
		    complete="";
		}		
		var contributingFactors=encodeURIComponent($('textarea[name=contributingFactors]').val());
		if((!(typeof(contributingFactors) !== 'undefined' && contributingFactors != null))||($('textarea[name=contributingFactors]').is(":visible"))==false) {
		    contributingFactors="";
		}				
		var recommendation=encodeURIComponent($('textarea[name=recommendation]').val());
		if((!(typeof(recommendation) !== 'undefined' && recommendation != null))||($('textarea[name=recommendation]').is(":visible"))==false) {
		    recommendation="";
		}				
		var evaluation=encodeURIComponent($('textarea[name=evaluation]').val());
		if((!(typeof(evaluation) !== 'undefined' && evaluation != null))||($('textarea[name=evaluation]').is(":visible") )==false) {
		    evaluation="";
		}				
		var closeLoop=encodeURIComponent($('textarea[name=closeLoop]').val());
		if((!(typeof(closeLoop) !== 'undefined' && closeLoop != null))||($('textarea[name=closeLoop]').is(":visible") )==false) {
		    closeLoop="";
		}		
		
		$.ajax({
			url: "../pi/furtherActionCommit.jsp?type=submitStatus&pirID="+pirID+"&reject="+reject+"&follow="+follow
			+"&complete="+complete+"&contributingFactors="+contributingFactors+"&recommendation="+recommendation
			+"&evaluation="+evaluation+"&closeLoop="+closeLoop,
			async:false,
			cache:false,
			success: function(values){	
				if(values.indexOf('true')!=-1){		
					alert("Staff Reply updated successfully.");		
					refreshPage(pirID,'view');
				}else {
					alert("Error occured while updating Staff Reply.");
				}				
			}//success
		});//$.ajax
	}else if(type=='edit'){
		refreshPage(pirID,'edit');
	}
}

function refreshPage(pirID,statusType){	
	$.ajax({
		url: "../pi/furtherAction2.jsp?pirID="+pirID+"&statusType="+statusType,
		async:false,
		cache:false,
		success: function(values){	
			if(values.length>0){	
				$('#statusDiv').html('');
				$('#statusDiv').html(values);
			}else {
				alert("Error occured while changing page.");
			}				
		}//success
	});//$.ajax
}

</script>