<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%
String sLoginID = request.getParameter("sLoginID");
String sLoginMessage = request.getParameter("sLoginMessage");
%>
	<b>
<%if (ConstantsServerSide.isHKAH()) { %>
	Hong Kong Adventist Hospital - Stubbs Road
<%} else if (ConstantsServerSide.isTWAH()) { %>
	Hong Kong Adventist Hospital - Tsuen Wan
<%} else { %>
	Adventist Medical Center
<%} %>
	</b><br/>
<div id="login_form">
	<div id="login_status" align="center">
		<center><h1 id="login">&nbsp;</h1>
			<br />
		<div id="login_response"><div id="login_error"><%=sLoginMessage==null?"Please Login":sLoginMessage %></div></div></center>
		<form name="LogonForm" id="login" action="javascript:alert('success!');">
			<br />
			<br />
			<table>
				<tr><td>&nbsp;<bean:message key="prompt.loginID" /></td><td><input type="text" value="<%=sLoginID==null?"":sLoginID %>" name="loginID" id="loginID" size="20" /></td></tr>
				<tr><td>&nbsp;<bean:message key="prompt.password" /></td><td><input type="password" name="loginPwd" id="loginPwd" size="20"/></td></tr>
				<tr><td>&nbsp;<bean:message key="prompt.language" /></td><td>
					<select name="language" id="language">
						<option value="en">English</option><option value="zh_TW">Traditional Chinese</option><option value="zh_CN">Simplied Chinese</option><option value="ja_JP">Japanese</option>
					</select></td></tr>
				<!--tr><td>&nbsp;<bean:message key="prompt.save.password" /></td><td align="left"><input type="checkbox" name="savePwd" id="savePwd" value="Y"/></td></tr-->
				<tr><td colspan="2" align="center"><br><button type="submit" id="submit"><b>Login</b></button></td></tr>
			</table>
			<input type="hidden" name="action" value="user_login">
			<input type="hidden" name="module" value="login">
		</form>
		<div id="login_ajax_loading"><img align="absmiddle" src="../images/spinner.gif">&nbsp;Processing...</div>
	</div>
	<div id="logged_in"><img align="absmiddle" src="../images/spinner.gif">&nbsp;You are successfully logged in!</div>
</div>
<script type="text/javascript">
<!--
	// Preload Images
	img1 = new Image(16, 16);
	img1.src="../images/spinner.gif";

	img2 = new Image(220, 19);
	img2.src="../images/wait30trans.gif";

	$(document).ready(function() {
		// When the form is submitted
		$("#login_status > form").submit(function(){
			// Hide 'Submit' Button
			$('#submit').hide();

			// Show Gif Spinning Rotator
			$('#login_ajax_loading').show();

			// 'this' refers to the current submitted form
			var str = $(this).serialize();
			var today = new Date();

			// -- Start AJAX Call --
			$.ajax({
	    		type: "POST",
	    		url: "../portal/loginProcess.jsp?cd="+today,  // Send the login info to this page
	    		data: str,
	    		cache: false,
	    		success: function(msg){
					$("#login_status").ajaxComplete(function(event, request, settings){
						if (msg == 'OK') {
							// Hide login form
							$('#login_ajax_loading').hide();
							$('#login_status').hide();

							// Show logged in message
							$('#logged_in').show();

							// After 2 seconds redirect the
							setTimeout('gotoLandingPage()', 100);
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
		}); // end submit event
	});

	function gotoLandingPage() {
		var url = window.location.href;
		var index1 = url.indexOf('//');
		var index2 = url.indexOf('/', index1 + 2);
		var index3 = url.indexOf('/', index2 + 1);
		var protocol;
		var landingUrl;

		window.parent.location = url.substring(0, index3) + '/';
	}
-->
</script>