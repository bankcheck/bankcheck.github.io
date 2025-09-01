<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>


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
 <link href='https://fonts.googleapis.com/css?family=RobotoDraft' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

 <script type="text/javascript" src="jquery-1.9.1.min.js"></script>
 <script type="text/javascript" src="http://code.jquery.com/ui/1.10.0/jquery-ui.min.js"></script>
 
<style>
html,body,h1,h2,h3,h4,h5 {font-family: "RobotoDraft", "Roboto", sans-serif;}
.w3-bar-block .w3-bar-item{padding:16px}
</style>

<body>
<!-- Side Navigation -->
<nav class="w3-sidebar w3-bar-block w3-collapse w3-white w3-animate-left w3-card" style="z-index:3;width:320px;" id="mySidebar">
  <a href="javascript:void(0)" class="w3-bar-item w3-button w3-border-bottom w3-large"><img src="https://www.w3schools.com/images/w3schools.png" style="width:60%;"></a>
  <a href="javascript:void(0)" onclick="w3_close()" title="Close Sidemenu" 
  class="w3-bar-item w3-button w3-hide-large w3-large">Close <i class="fa fa-remove"></i></a>
  <a href="javascript:void(0)" class="w3-bar-item w3-button w3-dark-grey w3-button w3-hover-black w3-left-align" onclick="document.getElementById('id01').style.display='block'">New Message <i class="w3-padding fa fa-pencil"></i></a>
  <a id="myBtn" onclick="myFunc('Demo1')" href="javascript:void(0)" class="w3-bar-item w3-button"><i class="fa fa-inbox w3-margin-right"></i>Inbox (3)<i class="w3-margin-left fa fa-caret-down"></i></a>
  <div id="Demo1" class="w3-hide w3-animate-left">
    <a href="javascript:void(0)" class="w3-bar-item w3-button w3-border-bottom test w3-hover-light-grey" onclick="openMail('Borge');w3_close();" id="firstTab">
      <div class="w3-container">
        <img class="w3-round w3-margin-right" src="/w3images/avatar3.png" style="width:15%;"><span class="w3-opacity w3-large">Borge Refsnes</span>
        <h6>Subject: Remember Me</h6>
        <p>Hello, i just wanted to let you know that i'll be home at...</p>
      </div>
    </a>
     <a href="javascript:void(0)" class="w3-bar-item w3-button w3-border-bottom test w3-hover-light-grey" onclick="openMail('Jane');w3_close();">
      <div class="w3-container">
        <img class="w3-round w3-margin-right" src="/w3images/avatar5.png" style="width:15%;"><span class="w3-opacity w3-large">Jane Doe</span>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit...</p>
      </div>
    </a>
    <a href="javascript:void(0)" class="w3-bar-item w3-button w3-border-bottom test w3-hover-light-grey" onclick="openMail('John');w3_close();">
      <div class="w3-container">
        <img class="w3-round w3-margin-right" src="/w3images/avatar2.png" style="width:15%;"><span class="w3-opacity w3-large">John Doe</span>
        <p>Welcome!</p>
      </div>
    </a>
  </div>
  <a href="#" class="w3-bar-item w3-button"><i class="fa fa-paper-plane w3-margin-right"></i>Sent</a>
  <a href="#" class="w3-bar-item w3-button"><i class="fa fa-hourglass-end w3-margin-right"></i>Drafts</a>
  <a href="#" class="w3-bar-item w3-button"><i class="fa fa-trash w3-marghin-right"></i>Trash</a>
</nav>

<!-- Modal that pops up when you click on "New Message" -->
<div id="id01" class="w3-modal" style="z-index:4">
  <div class="w3-modal-content w3-animate-zoom">
    <div class="w3-container w3-padding w3-red">
       <span onclick="document.getElementById('id01').style.display='none'" class="w3-button w3-right w3-xxlarge"><i class="fa fa-remove"></i></span>
      <h2>Send Mail</h2>
    </div>
    <div class="w3-panel">
      <label>To</label>
      <input class="w3-input w3-border w3-margin-bottom" type="text">
      <label>From</label>
      <input class="w3-input w3-border w3-margin-bottom" type="text">
      <label>Subject</label>
      <input class="w3-input w3-border w3-margin-bottom" type="text">
      <input class="w3-input w3-border w3-margin-bottom" style="height:150px" placeholder="What's on your mind?">
      <div class="w3-section">
        <a class="w3-button w3-red" onclick="document.getElementById('id01').style.display='none'">Cancel  <i class="fa fa-remove"></i></a>
        <a class="w3-button w3-right" onclick="document.getElementById('id01').style.display='none'">Send  <i class="fa fa-paper-plane"></i></a> 
      </div>    
    </div>
  </div>
</div>

<!-- Overlay effect when opening the side navigation on small screens -->
<div class="w3-overlay w3-hide-large w3-animate-opacity" onclick="w3_close()" style="cursor:pointer" title="Close Sidemenu" id="myOverlay"></div>

<!-- Page content -->
<div class="w3-main" style="margin-left:320px;">
<i class="fa fa-bars w3-button w3-white w3-hide-large w3-xlarge w3-margin-top" onclick="w3_open()"></i>
<a href="javascript:void(0)" class="w3-hide-large w3-red w3-button w3-right w3-margin-top w3-margin-right" onclick="document.getElementById('id01').style.display='block'"><i class="fa fa-pencil"></i></a>

<div id="Borge" class="w3-container person">
  <br>
  <img class="w3-round  w3-animate-top" src="/w3images/avatar3.png" style="width:20%;">
  <h5 class="w3-opacity">Subject: Remember Me</h5>
  <h4><i class="fa fa-clock-o"></i> From Borge Refsnes, Sep 27, 2015.</h4>
  <a class="w3-button" href="#">Reply<i class="w3-padding fa fa-mail-reply"></i></a>
  <a class="w3-button" href="#">Forward<i class="w3-padding fa fa-arrow-right"></i></a>
  <hr>
  <p>Hello, i just wanted to let you know that i'll be home at lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
  <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
  <p>Best Regards, <br>Borge Refsnes</p>
</div>

<div id="Jane" class="w3-container person">
  <br>
  <img class="w3-round w3-animate-top" src="/w3images/avatar5.png" style="width:20%;">
  <h5 class="w3-opacity">Subject: None</h5>
  <h4><i class="fa fa-clock-o"></i> From Jane Doe, Sep 25, 2015.</h4>
  <a class="w3-button">Reply<i class="w3-padding fa fa-mail-reply"></i></a>
  <a class="w3-button">Forward<i class="w3-padding fa fa-arrow-right"></i></a>
  <hr>
  <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
  <p>Forever yours,<br>Jane</p>
</div>

<div id="John" class="w3-container person">
  <br>
  <img class="w3-round w3-animate-top" src="/w3images/avatar2.png" style="width:20%;">
  <h5 class="w3-opacity">Subject: None</h5>
  <h4><i class="fa fa-clock-o"></i> From John Doe, Sep 23, 2015.</h4>
  <a class="w3-button">Reply<i class="w3-padding fa fa-mail-reply"></i></a>
  <a class="w3-button">Forward<i class="w3-padding fa fa-arrow-right"></i></a>
  <hr>
  <p>Welcome.</p>
  <p>That's it!</p>
</div>
     
</div>

<script language="javascript">

$(document).ready(function() {

});


function getDate(){
	return $( "select[name='eventDate_dd'] option:selected" ).val()+"/"+$( "select[name='eventDate_mm'] option:selected" ).val()+"/"+$( "select[name='eventDate_yy'] option:selected" ).val();
}

function getTimeFrom(){
	return $( "select[name='eventFrom_hh'] option:selected" ).val()+":"+$( "select[name='eventFrom_mi'] option:selected" ).val()+":00";
}

function getTimeTo(){
	return $( "select[name='eventTo_hh'] option:selected" ).val()+":"+$( "select[name='eventTo_mi'] option:selected" ).val()+":00";
}

function setInputDisableSts(sts,class_name){
	$("."+class_name).find(':input').each(function() {
		if(this.type != 'button') {
			$(this).prop("disabled", sts);
		 }
	  });
}

function eventActionCancel(){
var action = $('#actMsg').val();
	if (action == 'CONFATT'){
		$( "#calendar" ).fullCalendar( 'refetchEvents' );
		$('#confirmDialog').hide();
		$('#eventModal').hide();
	} else {
		document.getElementById('confirmDialog').style.display='none';
	}
}
function eventActionConfirm(){
	var action = $('#actMsg').val();
	if (action == 'DEL'){
		$.ajax({
			type: "POST",
			url: "eventAction.jsp",
			data: 	"eventType="+$( "#eventType option:selected" ).val()
			+"&enrollID="+$("#enrollID").val()
			+"&memEventID="+$("memEventID").val()
			+"&action=DEL",
			success: function(values) {
				$( "#calendar" ).fullCalendar( 'refetchEvents' );
				$('#confirmDialog').hide();
				$('#eventModal').hide();
			},//success
			error: function() {
				alert('error');
			}
		});//$.ajax	
		clear_form_elements('eventModal');
	} else if (action == 'MOD') {
		$.ajax({
			type: "POST",
			url: "eventAction.jsp",
			data: 	"eventType="+$( "#eventType option:selected" ).val()
			+"&title=" + $( "#eventTitle" ).val()
			+"&desc="+$( "#eventDesc" ).val()
			+"&date="+getDate()
			+"&sTime="+getTimeFrom()
			+"&eTime="+getTimeTo()
			+"&enrollID="+$("#enrollID").val()
			+"&memEventID="+$("#memEventID").val()
			+"&action=MOD",
			success: function(values) {
				$( "#calendar" ).fullCalendar( 'refetchEvents' );
				$('#confirmDialog').hide();
				$('#eventModal').hide();
			},//success
			error: function() {
				alert('error');
			}
		});//$.ajax	
		clear_form_elements('eventModal');
	} else if (action =='CONFATT') {
		$( "#upFile" ).prop("disabled", false); 
		$( "#upFileSub" ).prop("disabled", false);
		$( "#keyID" ).prop("disabled", false); 
		document.getElementById('uploadFile').style.display='block';
		$('#confirmDialog').hide();
	} else if (action=='DELATT') {
		$.ajax({
			type: "POST",
			url: "fileDelete.jsp",
			data: 	"keyID="+$('#actMsg').attr( "keyid" )
			+"&docID=" + $('#actMsg').attr( "docid" ),
			success: function(values) {
				$( "."+ $('#actMsg').attr( "keyid" )+"_"+$('#actMsg').attr( "docid" )).remove();
				$('#confirmDialog').hide();
			},//success
			error: function() {
				alert('error');
			}
		});//$.ajax	
	}
}

function deleteAttach(keyID,docID) {
	$('#actMsg').val('DELATT');
	$('#actMsg').html('delete this attachment?');
	$('#actMsg').attr("keyid", keyID);
	$('#actMsg').attr("docid", docID);
	$('#confirmDialog').show();

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
<style>
.fc-day-header { 
background-color:#AA0066; 
color:white;
}
.fc-day {
background-color:white;
}
.fc-typeText{
text-decoration: underline;
font-weight: bold;
}
.ui-dialog{
z-index:1000;
</style>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>