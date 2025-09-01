<%!
/*
Put login.jsp into /<project_home>/war

Add the follow script to your project web.xml:

	<servlet>
 		<servlet-name>AuthServlet</servlet-name>
  		<servlet-class>com.hkah.server.servlet.AuthServlet</servlet-class>
	</servlet>
	
	<servlet-mapping>
		<servlet-name>AuthServlet</servlet-name>
		<url-pattern>/login</url-pattern>
	</servlet-mapping>

Add key: gwt.htmlHostPage=<gwt_host_page> in /<project_home>/src/ClientConfig.properties

*/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.server.config.ClientConfig"%>
<%@ page import="com.hkah.shared.model.*"%>
<%
	UserInfo userInfo = (UserInfo) session.getAttribute("userInfo");
	String contextPath = request.getContextPath();
	String queryString = request.getQueryString();
	if (queryString != null && queryString.length() > 0) {
		queryString = "?" + queryString;
	} else {
		queryString = "";
	}
	
	String actionPath = contextPath + "/login" + queryString;
	
	boolean isLoggedIn = false;
	if (userInfo != null)
		isLoggedIn = true;
	
	if (isLoggedIn) {
		String targetUrl = ClientConfig.get("gwt.htmlHostPage") + queryString;
		response.sendRedirect(targetUrl);
	}
%>
<html>
 <head>
 	<title>HKAH CMS Login</title>
 	<link type="text/css" rel="stylesheet" href="css/login.css">
  </head>
  <body>
	<div id="hkahcms_logo"></div>
    <div id="login_content">
    	<form name="login_form" action="<%=actionPath %>" method="post">
	    	<table class="login_table">
	    		<tr>
	    			<td colspan="2">
					  	HKAH CMS (Development)
	    			</td>
	    		</tr>
			    <tr>
			    	<td>User ID: </td><td><input type="text" name="username" /></td>
			    </tr>
			    <tr>
			    	<td>Password: </td><td><input type="password" name="password" /></td>
			    </tr>
			    <tr>
			    	<td></td><td><input type="submit" value="Sign in"></td>
			    </tr>
	    	</table>
    	</form>
    </div>
 </body>
</html>