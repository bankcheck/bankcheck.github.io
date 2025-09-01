<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.CMSDB"%>
<%
String fileName = ParserUtil.getParameter(request, "fileName");
String filePath = ParserUtil.getParameter(request, "filePath");
String showCloseBtn = request.getParameter("showCloseBtn");
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<html:html xhtml="true" lang="true">
	<style type="text/css">
		#login_content {
			margin: 20px auto;
			text-align: middle;
			width: 600px;
			border: 5px solid #DDDDDD;
			border-radius: 5px;
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px;
		}
		
		#login_intro {
			margin: 0 auto;
			font-family: verdana,arial,helvetica,sans-serif;
			font-size: 25px;
			text-align: center;
		}
	</style>
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/style.css" />" />
	<head>
		<title>CMS Mobile Login Code</title>
	</head>
	<body>
<% if("Y".equals(showCloseBtn)){ %>
	<div align="right"><img src="../images/cross.jpg" onclick="windowClose();"></img></div>
<% } %>
		<div id="login_intro">Open <span class="bold">CMS Photo</span> and scan me</div>
		<div id="login_content">
<% if(filePath != null && filePath.length() > 0){ %>
			<img src="<%= filePath + fileName %>"/>
<% } else { %>	
			<img src="<%=CMSDB.sysparams.get("QR_PATH_URL_T") %><%=fileName %>"/>
<% } %>
		</div>		
	</body>
	 <script>
	 function windowClose() { 
		 window.open('','_parent',''); 
		 window.close();
	 } 
	 </script>
</html:html>