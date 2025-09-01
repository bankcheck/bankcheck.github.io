<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%
String fileId = ParserUtil.getParameter(request, "fileId");
String message = ParserUtil.getParameter(request, "message");

if ( message == null ){
	message = "File not found"; 
}

ArrayList reportList = null;
String tempFilePath = "";

//System.out.println("[displayArchivePDF] fileId=" + fileId);

reportList = CMSDB.getFileArchive( fileId );

if( reportList.size() > 0 ){
	ReportableListObject row = (ReportableListObject) reportList.get(0);
	String tempServer = row.getValue(1);
	String tempFolder = row.getValue(2);
	String tempSubFolder = row.getValue(3);
	String tempFName = row.getValue(4);
	if (tempServer != null && tempServer.length() > 0){
		tempFilePath = "//"+tempServer+"/"+tempFolder.replace("\\", "/")+"/"+tempSubFolder+"/"+tempFName;	
	}	  
}

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

<html>
	<head>
		<title>View Document</title>
	</head>
	
<%  
	String useSamba = "Y";
	if (CMSDB.sysparams.get("smb_username") == null) {
		useSamba = "N";
	}

	if ((reportList != null && reportList.size() == 1) && tempFilePath != null) { 
		String redirectPath = "../documentManage/download.jsp?locationPath="+tempFilePath+"&src=inapp&dispositionType=inline&intranetPathYN=Y&useSambaYN=" + useSamba + "&#view=FitH";	
		response.sendRedirect(redirectPath);
%>
<!--
		<frameset name="displayLab_frameset" id="displayLab_frameset" border="1" frameborder="1" framespacing="0" cols="*">		
			<frame name="content" src="viewPdf.jsp?filePath=<%//tempFilePath%>"/>
			<noframes>
					<P>Please use Internet Explorer or Mozilla!
			</noframes>
		</frameset>
 -->
<% } else if (reportList != null && reportList.size() > 1) { %>
	<frameset name="display_frameset" id="display_frameset" border="1" frameborder="1" framespacing="0" cols="200, *">	
  		<frame name="menu" src="viewArchiveList.jsp?<%="fileId="+fileId%>"/>
		<frame name="content" src="viewPdf.jsp?<%="filePath="+tempFilePath%>"/>
		<noframes>
				<P>Please use Internet Explorer or Mozilla!
		</noframes>
	</frameset>
<% } else { %>
	<body>
		<%=message %>
	</body>
	 <script>
// self executing function here
(function() {
	alert("<%=message %>");
	window.close();
})();
</script>
<% } %>		
</html>