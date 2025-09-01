<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.hkah.server.config.ClientConfig"%>
<%@ page import="com.hkah.shared.constants.ConstantsVariable"%>
<%@ page import="com.hkah.shared.model.*"%>
<%@ page import="com.hkah.shared.util.UrlUtil"%>
<%@ page import="java.util.Map"%>
<%
	UserInfo userInfo = (UserInfo) session.getAttribute("userInfo");
	String errCode = request.getParameter("errCode");
	String userID = request.getParameter("userID");
	String contextPath = request.getContextPath();
	String queryString = request.getQueryString();
	Map<String, Object> qParams = UrlUtil.encapUrlQueryParams(queryString);
	qParams.remove("errCode");
	qParams.remove("userID");
	qParams.remove("password");
	
	String targetUrl = "";
	if (qParams != null && qParams.size() > 0) {
		queryString = "?" + UrlUtil.formatQueryParams(qParams);
	} else {
		queryString = "";
	}
	
	String actionPath = contextPath + "/login" + queryString;
	String errMsg = null;
	int errCodeInt = -1;
	if (errCode != null) {
		try {
			ConstantsVariable.LoginCode loginRet = ConstantsVariable.LoginCode.getLoginCodeByCode(errCode);
			errMsg = loginRet.getMsg();
		} catch (Exception e) {
			errMsg = ConstantsVariable.LoginCode.AUTH_ERR.getMsg();
		}
	}

	String site = ClientConfig.getObject().getSiteCode();
	String siteDesc = ClientConfig.getObject().getSiteName();
	String buildStr = ClientConfig.getObject().getVersionNo();
	
	boolean isLoggedIn = userInfo != null;
	if (isLoggedIn) {
		targetUrl = "HKAHNHS" + queryString;
		//response.sendRedirect(targetUrl);
	}
	
	String focus = null;
	if (userID == null) {
		focus = "userID";
	} else {
		focus = "password";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 	<head>
 		<title>New HATS System</title>
 		<link type="text/css" rel="stylesheet" href="css/login.css">
  	</head>
  <body>
	<div id="hkahcms_logo"></div>
    <div id="login_content">
    	<form name="login_form" action="<%=actionPath %>" method="post" target="HKAHNHS" 
    			onsubmit="openHKAHNHS(this)" autocomplete="off">
	    	<table class="login_table" cellspacing="10px" style="border: 1px solid #cccccc; margin: 10px;">
	    		<tr>
	    			<td colspan="2">
	    				<img src="images/main_logo_<%=site %>.jpg" alt="<%=siteDesc %>" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2">
					  	<span class="app-title">Hospital Administration System (New HATS System)<br />
					  	<!-- <span class="app-sub-title">Phase 1</span></span>-->
	    			</td>
	    		</tr>
<% if (errMsg != null) { %>
	    		<tr>
	    			<td colspan="2">
	    				<span class="errmsg"><%=errMsg %></span>
	    			</td>
	    		</tr>
<% } %>
			    <tr>
			    	<td class="flabel">User ID: </td><td><input type="text" name="userID" value="<%=userID == null ? "" : userID %>" /></td>
			    </tr>
			    <tr>
			    	<td class="flabel">Password: </td><td><input type="password" name="password" /></td>
			    </tr>
			    <tr>
			    	<td></td><td><input type="submit" id="submit" value="Sign in"></td>
			    </tr>
			    <tr>
			    	<td colspan="2">
			    		<hr />
			    		<span class="ver-info">build ver: <%=buildStr %></span>
			    	</td>
			    </tr>
	    	</table>
    	</form>
    	
    	<div id="browser-ver-check" class="overlay">
		    <div class="overlay-inner">
		    	<h2>Hospital Administration And Tracking System (HATS)</h2>
		        <p>This web browser is not compatible to Hospital standard. Some HATS features may not work properly. Please contact IT support.</p>
		        <button id="btn-return">Return to login page</button>
		    </div>
		</div>
    	
    	<script type="text/javascript" language="javascript">
 			var screenWidth = screen.width;
 			var screenHeight = screen.height;
 			var url = document.login_form.action;
 			var isLoggedIn = <%=isLoggedIn%>;
 			var targetUrl = '<%=targetUrl%>';
 			var popUpWin;
 			
 			window.onload = function () {
 				hideBrowserCheck();
 				if (!isIE()) {	// IE ver > 9 or non-IE
 			        showBrowserCheck();
 				}
 				
 				document.login_form.<%=focus %>.focus();
 				if (isLoggedIn) {
 					
 					popUpWin = window.open(targetUrl,'_blank',
 		   					'width='+screenWidth+',height='+(screenHeight-20)+
 		   					',resizable=1,left=0,top=0,'+
 		   					'fullscreen=no,resizable=no,toolbar=no,menubar=no,location=no,directories=no,status=no');
 					popUpWin.focus();
 					if (window.name != 'HKAHNHS') {
 		   				window.opener = null;  
 			   			window.open('','_parent','');
 			   			window.close();
 		   			}
 					
 				}
 				
 				var btnret = document.getElementById('btn-return');
 				if (btnret.attachEvent) {
 					btnret.attachEvent('onclick', hideBrowserCheck);
 				} else {
 					btnret.addEventListener('click', hideBrowserCheck, false);
 				}
 			}
 			
 			function showBrowserCheck() {
		        document.getElementById('browser-ver-check').className = document.getElementById('browser-ver-check').className + ' overlay-open';
			    document.body.className = document.body.className + ' overlay-view';
			}
 			
 			function hideBrowserCheck() {
				document.getElementById('browser-ver-check').className = document.getElementById('browser-ver-check').className.replace('overlay-open', '');
 			    document.body.className = document.body.className.replace('overlay-view', '');
 			}
 			
 			function isIE() {
				  var myNav = navigator.userAgent.toLowerCase();
				  var ret = (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
				  //alert('userAgent='+myNav+'\n\nIE ver='+ret);
				  return ret;
 			}
 			
	   		function openHKAHNHS(form) {
	   			//'about:blank'
	   			popUpWin = window.open('about:blank','HKAHNHS',
	   					'width='+screenWidth+',height='+(screenHeight-20)+
	   					',resizable=1,left=0,top=0,'+
	   					'fullscreen=no,resizable=no,toolbar=no,menubar=no,location=no,directories=no,status=no');
				
	   			if (window.name != 'HKAHNHS') {
	   				window.opener = null;  
		   			window.open('','_parent','');
		   			window.close();
	   			}
	   		}
	   	</script>
    </div>
 </body>
</html>