<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp"/>
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/crm.login.css" />"/>
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/crm.photo.gallery.css" />"/>
	
	<body>
		<form id="login" name="LogonForm">
			<div id="header">
				<div id="logo" style="cursor:pointer"></div>
			</div>
			<h1><bean:message key="label.crm.login" /></h1>
	  		<fieldset id="inputs">
		    	<bean:message key="label.crm.userID" /><br/>
		    	<input id="username" type="text" name="loginID" id="loginID" size="20" autofocus required>
			    <bean:message key="prompt.password" /><br/>
			    <input id="password" type="password" name="loginPwd" id="loginPwd" size="20" required>
		  	</fieldset>
		  	<table>
		  	<tr>
		  	<td>
		  	<bean:message key="label.crm.keepLogged" />
		    <input type="checkbox" name="savePwd" id="savePwd" value="Y"/>
		    </td>
		  	<td style="text-align:right">
<!--
		  	<a href = "reset_password.jsp"><bean:message key="label.crm.forgetPassword" /></a>
-->		  	
		  	</td>
		  	</tr>
		  	</table>
		  	<fieldset id="actions">
		    	<input type="submit" id="submit" value="<bean:message key="prompt.login" />">
		    	<div id="login_response"></div>
		  	</fieldset>
		  	
		  	<div id="login_ajax_loading">
		  		<img align="absmiddle" src="../../images/spinner.gif">&nbsp;Processing...
		  	</div>
		  	<div id="logged_in">
		  		<img align="absmiddle" src="../../images/spinner.gif">&nbsp;You are successfully logged in!
		  	</div>
		  	<input type="hidden" name="action" value="user_login">
			<input type="hidden" name="module" value="login">
		</form>
	</body>
</html:html>
<script>
var secureProtocol = "https:";

$(document).ready(function(){ 
	checkSecure();
	$("#login").bind("submit", login);
});

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
	landingUrl += 'crm/portal/index.jsp';
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
				if (msg == 'OK') {
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