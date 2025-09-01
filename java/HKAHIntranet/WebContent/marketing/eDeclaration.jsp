<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.convert.Converter"%>
<%
ArrayList record = new ArrayList();
ReportableListObject row = null;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
	 "http://www.w3.org/TR/html4/frameset.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<meta name="viewport" content="width=device-width, initial-scale=1">
<jsp:include page="../common/header.jsp">
<jsp:param name="title" value="Self Declaration" />
</jsp:include>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/w3.hkah.css" />" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<script src="https://www.google.com/recaptcha/api.js?hl=en" async defer></script>
<head>
</head>
<body>


<div class="w3-container ah-pink" >
  <img src="../images/Option5_TWAH_logo_Reversed with JCI logo.png"  style="width:100%;max-width:400px">
	  <p class="w3-xlarge w3-center" style="color:white;">Health Self Declaration Form 健康自我申報表</p>

</div>

<div class="result w3-panel w3-border w3-light-grey w3-round-large" style="display:none;">

<div class="w3-container">
<p class="w3-large w3-center "><i class="w3-xxlarge fa fa-check-circle-o"></i><br>
Thank you for your submission.  An SMS acknowledgement will be sent after our confirmation which HKAH-TW staff shall check upon your arrival at the entrance.
<br><br>已提交所申報的資料，閣下稍後將會收到確認短訊。請於抵達本院時出示該短訊以供職員核實之用。</p>

</div>


</div>

<div class="question w3-container w3-card-4  w3-margin"> 

 <div class="w3-row-padding" style="margin:8px -16px;">
   <div class="w3-half w3-margin-bottom">
     <label><i class="fa fa-user"></i> Name 姓名</label>
     <input class="w3-input w3-border" type="text" value="" id="name">
   </div>
   <div class="w3-half">
     <label><i class="fa fa-phone"></i> Mobile phone no. 手提電話號碼</label>
   <input class="w3-input w3-border" type="text" value="" id="phone">
   </div>
 </div>
<div class="w3-row w3-section">
	<h2 class="w3-center">
	Do you have any one of the following situations or symptoms?<br>
	你有否以下任何一種情況或徵狀?
	</h2>
</div>
<div class="w3-card w3-margin">
<ul class="w3-leftbar w3-rightbar w3-border-grey w3-light-grey w3-center w3-large" style="list-style:none">
 <li>a. travelled out of Hong Kong within the last 21 days</li>
 <li>過去21日曾經離開香港</li>
</ul>
</div>
<div class=" w3-card w3-margin">
<ul class="w3-leftbar w3-rightbar w3-border-grey w3-light-grey w3-center w3-large" style="list-style:none">
 <li>b. in close contact with a suspected/ confirmed case of COVID-19 within the last 14 days</li>
 <li>過去14日有與2019冠狀病毒病懷疑/確診個案病人有密切接觸</li>
</ul>
</div>
<div class=" w3-card w3-margin">
<ul class="w3-leftbar w3-rightbar w3-border-grey w3-light-grey w3-center w3-large" style="list-style:none">
 <li>c. have fever or with any body discomfort (e.g. sore throat, cough, shortness of breath, diarrhoea, vomiting, loss of smell/ taste, etc.)
respiratory symptoms
</li>
 <li>有發燒或任何身體不適 (例如喉嚨痛、咳、氣促、腹瀉、嘔吐、失去味覺/嗅覺等)</li>
</ul>
</div>
<div class="w3-row w3-section w3-center">
<!-- <div style="margin:0 auto; display:inline-block;">
	<div style=""class="g-recaptcha" data-sitekey="6Lc4-r8aAAAAAHC-I7EYrEpziIcqCdj0HMRWASoF" data-size="normal" data-callback="verifyCallback"
    data-expired-callback="errorCallBack"
    data-error-callback="errorCallBack"></div>
</div> -->
<p id="btngrp" >
<button id="Y" class="g-recaptcha yesbtn w3-button w3-red w3-round-xxlarge w3-margin" data-sitekey="6Le948MaAAAAAGmUSMQFEfPjCOtJyl8SmKEi1hDr" data-callback="verifyCallback"
    data-expired-callback="errorCallBack"
    data-error-callback="errorCallBack"><h4><span>&#10004;</span> Yes 有</h4></button>
<button id="N" class="g-recaptcha nobtn w3-button w3-green w3-round-xxlarge " data-sitekey="6Le948MaAAAAAGmUSMQFEfPjCOtJyl8SmKEi1hDr" data-callback="verifyCallbackN"
    data-expired-callback="errorCallBack"
    data-error-callback="errorCallBack"><h4><span>&#10006;</span> All none 以上皆沒有</h4></button></p></div>
</div>
</body>

<script language="JavaScript">
var vName, vPhone, inDrcode;

$(document).ready(function(){
	//$("button").attr("disabled", true);
	$(window).scrollTop(0);
	$('input[type=text], input[type=password]').attr('autocomplete', 'off');
/* 	$('.yesbtn').click(function() {
		if ($( "#name" ).val() != '' && $( "#phone" ).val() != '') {
			$.ajax({
				type: "POST",
				url: "eDecAction.jsp",
				data: 	"name="+$( "#name" ).val()
				+"&phone=" + $( "#phone" ).val()
				+"&ans=Y"
				+"&action=ADD",
				success: function(values) {				 
					$('.question').hide();
					$('.result').show();

				},//success
				error: function() {
					alert('error');
				}
			});
		} else {
			alert("Please provide your name and phone number.");
		}
	}); */
	
/* 	$('.nobtn').click(function() {
		if ($( "#name" ).val() != '' && $( "#phone" ).val() != '') {
			$.ajax({
				type: "POST",
				url: "eDecAction.jsp",
				data: 	"name="+$( "#name" ).val()
				+"&phone=" + $( "#phone" ).val()
				+"&ans=N"
				+"&action=ADD",
				success: function(values) {				 
					$('.question').hide();
					$('.result').show();

				},//success
				error: function() {
					alert('error');
				}
			});
		} else {
			alert("Please provide your name and phone number.");
		}
	}); */
});

function verifyCallback(token) {
	$.ajax({
		type: "POST",
		url: "eDecAction.jsp",
		data: 	"type=verify"
		+"&token=" + token
		+"&ans=N"
		+"&action=ADD",
		success: function(values) {				 
		if ($( "#name" ).val() != '' && $( "#phone" ).val() != '') {
			$.ajax({
				type: "POST",
				url: "eDecAction.jsp",
				data: 	"name="+$( "#name" ).val()
				+"&phone=" + $( "#phone" ).val()
				+"&ans=Y"
				+"&action=ADD",
				success: function(values) {				 
					$('.question').hide();
					$('.result').show();

				},//success
				error: function() {
					alert('error');
				}
			});
		} else {
			alert("Please provide your name and phone number.");
		}

		},//success
		error: function() {
			alert('error');
		}
	});
  }
  
  function verifyCallbackN(token) {
	$.ajax({
		type: "POST",
		url: "eDecAction.jsp",
		data: 	"type=verify"
		+"&token=" + token
		+"&ans=N"
		+"&action=ADD",
		success: function(values) {				 
		if ($( "#name" ).val() != '' && $( "#phone" ).val() != '') {
			$.ajax({
				type: "POST",
				url: "eDecAction.jsp",
				data: 	"name="+$( "#name" ).val()
				+"&phone=" + $( "#phone" ).val()
				+"&ans=N"
				+"&action=ADD",
				success: function(values) {				 
					$('.question').hide();
					$('.result').show();

				},//success
				error: function() {
					alert('error');
				}
			});
		} else {
			alert("Please provide your name and phone number.");
		}

		},//success
		error: function() {
			alert('error');
		}
	});
  }
  
  function errorCallBack(token) {
	//$("button").attr("disabled", true);
  }

</script>
</html:html>