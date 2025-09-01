<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.config.MessageResources"%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/crm.main.css" />"/>
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/patient.login.css" />"/>
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/crm.photo.gallery.css" />"/>
	
	<body style="background-color:white!important;">	
		<form id="login" name="LogonForm">
			<table>
				<tr>
					<td>
						<div id="header">
							<div id="logo" style="cursor:pointer"></div>
						</div>
					</td>
					<td align="right">
						<span>
							<html:link page="/patient/setSession.jsp?sessionName=language&sessionValue=en">
								<html:img page="/images/lang_en.gif" align="top" />
							</html:link>
							<html:link page="/patient/setSession.jsp?sessionName=language&sessionValue=zh_TW">
								<html:img page="/images/lang_zh_TW.gif" align="top" />
							</html:link>
							<html:link page="/patient/setSession.jsp?sessionName=language&sessionValue=zh_CN">
								<html:img page="/images/lang_zh_CN.gif" align="top" />
							</html:link>
						</span>
						<br/>
						<h1>
							<bean:message key="button.login"/>
						</h1>
					</td>
				</tr>
			</table>
			
	  		<fieldset id="inputs">
		    	<bean:message key="prompt.patientNo"/><br/>
		    	<input id="username" type="text" name="loginID" id="loginID" size="20" autofocus required>
			    <bean:message key="prompt.password"/><br/>
			    <input id="password" type="password" name="loginPwd" id="loginPwd" size="20" required>
		  	</fieldset>
		  	<table>
		  
		  	</table>
		  	<fieldset id="actions">
		    	<input type="submit" id="submit" value="<bean:message key="button.login"/>">
		    	<div id="login_response"></div>
		  	</fieldset>
		  	
		  	<div id="login_ajax_loading">
		  		<img align="absmiddle" src="../images/spinner.gif">&nbsp;
		  	</div>
		  	<div id="logged_in">
		  		<img align="absmiddle" src="../images/spinner.gif">&nbsp;<bean:message key="prompt.login.success"/>
		  	</div>
		  	<input type="hidden" name="action" value="user_login">
			<input type="hidden" name="module" value="login">
		</form>
		<br/>
		<br/>
		<br/>
		<%-- 
		<form name="form1" id="return_form" >
			<button style="width:250px;font-size:24px;" 
					class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' 
					onclick="return submitAction();">
					<img src="../images/undo2.gif"/>&nbsp;Back to Home
			</button>
		</form>
		--%>
	</body>
</html:html>
<script>
var secureProtocol = "https:";

$(document).ready(function(){ 
	checkSecure();
	$("#login").bind("submit", login);
	
	$('form[name=LogonForm]').css('left', $(document).width()/2-$('form[name=LogonForm]').width()/2-30);
	$('form#return_form').css('left', $(document).width()/2-$('form#return_form').width()/2);
});


function submitAction() {
	showLoadingBox();
	document.form1.action = "../patient/";
	document.form1.submit();
	hideLoadingBox();
}


function gotoLoginPage() {
	var url = window.location.href;
	var index1 = url.indexOf('//');
	var index2 = url.indexOf('/', index1 + 2);
	var index3 = url.indexOf('/', index2 + 1);
	var protocol;
	var landingUrl;
	
	<%
	if (ConstantsServerSide.SECURE_SERVER) {
%>
		protocol = 'https://';
<%
	} else {
%>
		protocol = 'http://';
<%
	}
%>
	landingUrl = protocol + url.substring(index1 + 2, index3) + '/';
	landingUrl += 'patient/billing_list.jsp';
	
	window.parent.location = landingUrl;
}

function login() {
	// Hide 'Submit' Button
	$('#submit').hide();

	// Show Gif Spinning Rotator
	$('#login_ajax_loading').show();

	// 'this' refers to the current submitted form
	var str = $(this).serialize();
	
	// -- Start AJAX Call --
	$.ajax({
		type: "POST",
		url: "loginProcess.jsp",  // Send the login info to this page
		data: str,
		success: function(msg){		
			$("#login").ajaxComplete(function(event, request, settings){				
				if (msg.indexOf('OK') > -1) {				
					// Hide login form
					$('#login_ajax_loading').hide();

					// Show logged in message
					$('#logged_in').show();
					
					// After 2 seconds redirect the
					setTimeout('gotoLoginPage()', 100);
				} else {				
					// Show 'Submit' Button
					$('#submit').show();

					// Hide Gif Spinning Rotator
					$('#login_ajax_loading').hide();

					// ERROR?
					var login_response = '<div id="login_error">' + msg + '</div>';
					$('#login_response').html(login_response);
					document.forms["LogonForm"].elements["loginID"].focus();
				}
			});
		}
	});
	// -- End AJAX Call --

	return false;
}

function checkSecure() {
<%
	if (ConstantsServerSide.SECURE_SERVER) {
%>
		if (!(window.location.protocol == secureProtocol)) {
			var url = window.location.href;
			window.location.href = secureProtocol + url.substring(url.indexOf(":") + 1, url.length);
		}
<%
	}
%>
}
</script>