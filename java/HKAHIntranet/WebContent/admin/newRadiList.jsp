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
<nav class="w3-sidebar w3-bar-block w3-collapse w3-white w3-animate-left w3-card" style="z-index:3;width:42%;" id="mySidebar">
  <div id="Demo1" class="w3-show">
  <div class="w3-container w3-teal">
  <h4>Radisharing</h4>
</div>
<div class="w3-row-padding">
  <div class="w3-half">
  <label class="w3-text-teal"><b>Pat No.</b></label>
  <input id="patNo" class="w3-input w3-border w3-light-grey" type="text">
  </div>
  <div class="w3-half">
  <label class="w3-text-teal"><b>Date</b></label>
  <input class="w3-input w3-border w3-light-grey" type="text" id="datepicker">
  </div>
</div>
<div  class="w3-row-padding-large">
	<input class="w3-radio" type="radio" name="ckRdyUnSent" id="ckRdyUnSent" value="Y" checked>is Ready but not Sent
	<input class="w3-radio" type="radio" name="ckRdyUnSent" id="ckRdyUnSent" value="P">Check Patient		
</div>
<div class="w3-row-padding">
  <div class=" w3-padding-small">
      <button class="w3-btn searchBtn">Search</button>
  </div>
</div>
  </div>
<div class="w3-container w3-padding" id="rTable" style="zoom: 100%;"/>
</nav>

<!-- Page content -->
<div class="w3-container" style="margin-left:52%;">
	<iframe id="iradi" width="1000px" height="1000px" style="zoom: 95%;"></iframe>
</div>


<script language="javascript">

$(document).ready(function() {
    $( "#datepicker" ).datepicker();
    
	$("#iradi").attr("src","http://160.100.2.80/RadiSharing/RadiSharing.html?siteCode=hkah");
	
	$(".searchBtn").click(function() {
		showLoadingBox('body', 500, $(window).scrollTop());
		$.ajax({
			type: "POST",
			url: "radi_ajax.jsp",
			data: 	"patNo="+$( "#patNo" ).val()
			+"&date_from="+$("#datepicker").val()
			+"&ckRdyUnSent="+$('input[name=ckRdyUnSent]:checked').val(),
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

});


function updateR(accessionNo) {
	showLoadingBox('body', 500, $(window).scrollTop());
 		$.ajax({
			type: "POST",
			url: "radi_ajax.jsp",
			data: 	"accessionNo="+accessionNo.trim()
			+"&date_from="+$("#datepicker").val()
			+"&command=updateToReady"
			+"&ckRdyUnSent="+$('input[name=ckRdyUnSent]:checked').val(),
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
};

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