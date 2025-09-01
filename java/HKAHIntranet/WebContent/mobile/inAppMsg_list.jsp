<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String user = request.getParameter("user");
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

<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/w3.hkah.css" />" />

 
<style>
html,body,h1,h2,h3,h4,h5 {font-family: "RobotoDraft", "Roboto", sans-serif;}
.w3-bar-block .w3-bar-item{padding:16px}
</style>

<body>
<!-- Side Navigation -->
  <div id="Demo1" class="w3-show">
  <div class="w3-container ah-pink">
  <h4>Mobile App Message</h4>
</div>
<div class="w3-row-padding">
  <div class="w3-third">
    <input type="hidden" id="user" name="user" value="<%=user==null?"":user %>"/>
  <label class="ah-text-pink"><b>Pat No.</b></label>
  <input id="patNo" class="w3-input w3-border w3-light-grey" type="text">
  </div>
  <div class="w3-third">
  <label class="ah-text-pink"><b>Appointment Date</b></label>
  <input class="w3-input w3-border w3-light-grey" type="text" id="datepicker" >
  </div>
   <div class="w3-third">
  <label class="ah-text-pink"><b>Doctor</b></label><br>
		<span id="docSelect_indicator">
				<select name="doctor"  id="doctor" style="width:200px;">
					<option value="">Please select a doctor</option>
				</select>
		</span>
  </div>
</div>
<div class="w3-row-padding">
  <div class=" w3-padding-small">
      <button class="w3-btn searchBtn">Search</button>
  </div>
</div>
  </div>
 <div class="w3-row-padding">
  <div class="w3-half">
  <label class="w3-text-teal"><b>Template</b></label>
  <select id="tempSelect" class="w3-select w3-border w3-light-grey" onchange="getTemplate()"></select>
  </div>
</div>
<div class="w3-row-padding">
  <div class="w3-third">
  <label class="w3-text-teal"><b>Content(Traditonal Chinese)</b></label>
  <textarea rows="5" cols="30" max_length="500" class="w3-input w3-border w3-light-grey" type="text" id="msg_zh-HK"></textarea>
  </div>
  <div class="w3-third">
  <label class="w3-text-teal"><b>Content(Simplified Chinese)</b></label>
  <textarea rows="5" cols="30" max_length="500" class="w3-input w3-border w3-light-grey" type="text" id="msg_zh-CN"></textarea>
  </div>
    <div class="w3-third">
    <label class="w3-text-teal"><b>Content (English)</b></label>
  <textarea rows="5" cols="30" max_length="1000" class="w3-input w3-border w3-light-grey" type="text" id="msg_en"></textarea>
  </div>
</div>
<div class="w3-row-padding">
  <div class=" w3-padding-small">
      <button class="w3-btn sendBtn">Send</button>
      <span id="msgResult"></span>
  </div>
</div>

<div class="w3-container w3-padding" id="rTable" style="zoom: 100%;"></div>

<div id="progressbar" style="position:absolute; z-index:15;display:none;"
	class="ui-dialog ui-widget ui-widget-content ui-corner-all">
	<div class="ui-widget-header">Status</div><br/>
	<div class="progress-label">Loading...</div><br/>
	<div id="btnPanel"></div>
</div>


<script language="javascript">

$(document).ready(function() {
    $( "#datepicker" ).datepicker();
    
    getDoctorList();
    
 	$(".searchBtn").click(function() {
		showLoadingBox('body', 500, $(window).scrollTop());
		$.ajax({
			type: "POST",
			url: "appMsg_ajax.jsp",
			data: 	"patNo="+$( "#patNo" ).val()
			+"&appDate="+$("#datepicker").val()
			+"&docCode="+$("#doctor").val()
			+"&type=getRecord",
			success: function(values) {
				hideLoadingBox('body', 500);
				$( "#rTable" ).html(values);
			},//success
			error: function() {
				hideLoadingBox('body', 500);
				alert('error');
			}
		});//$.ajax	
		return false;
	});  
 	
 	$(".sendBtn").click(function() {
 		
//		showLoadingBox('body', 500, $(window).scrollTop());
		showOverLay('body');
 
		 $('#progressbar').css('top', 350);
		$('#progressbar').css('left', $(window).width()/2-$('#progressbar').width()/2);
		$('.progress-label').html('');
		$('.progress-label').html('Sending..');
		$('#progressbar').show();  


 		$.ajax({
			url: 'appMsg_ajax.jsp',
			data: {patNo: $( "#patNo" ).val().toUpperCase(), appDate: $("#datepicker").val(),
				msgHK:$("#msg_zh-HK").val(),msgCN:$("#msg_zh-CN").val(),msgEN:$("#msg_en").val()
					,bkgID:"100",type:"sendListMsg",user: $( "#user" ).val().toUpperCase(),docCode:$("#doctor").val()},
			async: true,
			type: 'POST',
			success: function(data, textStatus, jqXHR) {
				$('#btnPanel').html('');
				$('.progress-label').html(data);
		
		$('#btnPanel').append(
				'<button id="progressCloseBtn" '+
				'class="ui-button ui-widget ui-state-default'+
				' ui-corner-all ui-button-text-only">Close</button>');
		
		$('#progressCloseBtn').click(function() {
			$('#progressbar').hide();
			hideOverLay('body');

		});
			},
			error: function(jqXHR, textStatus, errorThrown) {
				hideOverLay('body');
				$('#progressbar').hide();
				alert(error);
				
			},
			complete: function(jqXHR, textStatus) {

			}
		}); 
		return false;
	}); 
	
	$.ajax({
		type: "POST",
		url: "../mobile/appMsg_ajax.jsp?type=msgType",
		async: false,
		success: function(values){
			$('select#tempSelect').html(values);
		},//success
		error: function(jqXHR, textStatus, errorThrown) {
		}
	});//$.ajax

});

function getDoctorList(){
	$.ajax({
		type: "POST",
		url: "docCodeCMB.jsp",
		data: "doccode="+$('#doctor').val(),
		success: function(values) {
			if (values != '') {
				$("#docSelect_indicator").html(values);
			} else {//if
			 	$("#docSelect_indicator").html("");
			}
		}//success
	});//$.ajax
}

function getTemplate() {
	$.ajax({
		async: false,
		cache: false,
		url: '../mobile/appMsg_ajax.jsp?callback=?',
		data: 'msgID='+$( "#tempSelect option:selected" ).val()
				+'&type=msgContent',
		dataType: "jsonp",
		success: function (data, textStatus, jqXHR) {
					/* $('span#patName').html(data['PATNAME']+' '+data['PATCNAME']);	
					$('input[name=patientName]').val(data['PATNAME']+' '+data['PATCNAME']); */
					$('#msg_zh-HK').val(data['zh-HK']);
					$('#msg_zh-CN').val(data['zh-CN']);
					$('#msg_en').val(data['en']);
				 },
		error: function(x, s, e) {
					$('#msg_zh-HK').val();
					$('#msg_zh-CN').val();
					$('#msg_en').val();
			   }
	});
}
function showLoadingBox(target, time, top) {
	if($('div#loadingBox').length  <= 0) {
		var imgPath;
		if(window.location.href.indexOf('crm/portal') > -1) {
			imgPath = "../../images/";
		}
		else {
			imgPath = "../images/";
		}
		$('<div id="loadingBox" class="loading">'+'<strong>Loading...</strong><br/><img src="'+imgPath+'loadingAnimation.gif"/></div>')
			.appendTo(target);
	}

	$(target).find('div#loadingBox').css('left', $(window).width()/2-$('div#loadingBox').width()/2);//$(target).position().left
	if (top) {
		$(target).find('div#loadingBox').css('top', top);//(top?top:$(target).position().top)
	}
	else {
		$(target).find('div#loadingBox').css('top', $(window).height()/2-$('div#loadingBox').height()/2);//(top?top:$(target).position().top)
	}
	$(target).find('div#loadingBox').fadeIn(time);
}

function hideLoadingBox(target, time) {
	$(target).find('div#loadingBox').fadeOut(time);
}


function clear_form_elements(class_name) {
	  $("."+class_name).find(':input').each(function() {
	    switch(this.type) {
	        case 'password':
	        case 'text':
	        case 'textarea':
	        case 'file':
	        case 'select-one':
	        case 'select-multiple':
	        case 'date':
	        case 'number':
	        case 'tel':
	        case 'hidden':
	        case 'email':
	            $(this).val('');
	            break;
	        case 'checkbox':
	        case 'radio':
	            this.checked = false;
	            break;
	    }
	  });
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>