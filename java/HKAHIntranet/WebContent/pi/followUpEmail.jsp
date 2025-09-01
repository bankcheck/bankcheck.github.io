<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%! 
%>

<%
UserBean userBean = new UserBean(request);
String pirID = request.getParameter("pirID");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
	Licensed to the Apache Software Foundation (ASF) under one or more
	contributor license agreements.  See the NOTICE file distributed with
	this work for additional information regarding copyright ownership.
	The ASF liCensus this file to You under the Apache License, Version 2.0
	(the "License"); you may not use this file except in compliance with
	the License.  You may obtain a copy of the License at

		 http://www.apache.org/liCensus/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<style>
div.confidential { 
	float:right;
	color:red;
}
div#report LABEL {
	color: black !important;
	font-weight: bold!important;
}
#incidentTypeForm TD {
	line-height:14pt !important;
}
#report {
	background-color: #CCCCCC;
}
#report .header {
	cursor: pointer;
	background: #D2449D !important;
	border-bottom-color: #E48FC4 !important;
	border-left-color: #E48FC4 !important;
	border-right-color: #E48FC4 !important;
	border-top-color: #E48FC4 !important;
	height:22px;
}
#report .header label {
}
.addFlw, .stepBtn, .nextBtn, .prevBtn {
	cursor: pointer;
}
.alert {
	color: Red!important;
}
.content-table td {
	border-width:0px!Important;
}
.reply-index td {
	border-width:0px!Important;
}
.selected {
	background: url("../images/ui-bg_highlight-soft_75_ffe45c_1x100.png") repeat-x scroll 50% 50% #F6F6F6 !important;
}
.scroll-pane
{
	width: 100%;
	height: 100%;
	overflow: auto;
}
div#menu, div#content {
	border: 2px solid;
	border-color: black;
}
div.reportItem {
	cursor: pointer!important;
}
</style>
<jsp:include page="../common/header.jsp"/>
	
<body>		
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Email" />
	<jsp:param name="keepReferer" value="Y" />
</jsp:include>
	<table class="assignFollow contentFrameMenu" cellpadding="0" cellspacing="5" border="0" width="100%">
		<tr class="smallText">
			<td colspan="8" class="infoSubTitle5">Follow Up</td>
		</tr>
	</table>
	
	<div align="center" class="flwUp-pane assignFollow" style='width:100%;padding-left:5px;height:600px;'>
		 <div style="float:left; width:13.5%; height:100%">
		 	<div class='flwUpList scroll-pane jspScrollable' style='overflow: hidden; padding: 0px; width:100%; height:100%;'>
			 </div>
		 </div>
		 <div style="float:right; width:85%; padding-right:10px; height:100%;">
			 <div class="flwup-content scroll-pane jspScrollable" style='overflow: hidden; padding: 0px; width:100%; height:100%;'>
			 </div>
		</div>
	</div>

</DIV>
</DIV>
</DIV>	
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
<script language="javascript">
var apis = [];


$(document).ready(function() {
	
	getFollowUp($('div.flwUpList'), 'list');
});

function getFollowUp(target, type,flwUpID) {
	$.ajax({
		url: "followUpEmailAction.jsp",
		data: "type="+type+"&pirID="+<%=pirID%>+"&flwUpID="+flwUpID,
		async:false,
		cache: false,
		success: function(values){
			if(type == 'reply') {				
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

function selectFlwUpEvent(obj) {	
	$('button.flwUpBtn').unbind('click');
	
	if(!$(obj).hasClass('selected')) {
		displaySelectedEmail(obj);		
		$('button.flwUpBtn.selected').removeClass('selected');
		$(obj).addClass('selected');		
	}
	return false;	
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

function initScroll(target, autoReinitialise) {
	//destroyScroll();	
	$(target).find('.scroll-pane').each(function(){
		apis.push($(this).jScrollPane({autoReinitialise:autoReinitialise}).data().jsp);
	});
	return false;
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

</script>