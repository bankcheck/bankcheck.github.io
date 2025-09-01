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
String labNum = ParserUtil.getParameter(request, "labNum");
String testCat = ParserUtil.getParameter(request, "testCat");
String rptNo = ParserUtil.getParameter(request, "rptNo");
//labNum = "16728862";
//testCat = "C";

//labNum = "16729109";
//testCat = "P";

//labNum = "13709177";
//testCat = "R";

//labNum = "16700197";
//testCat = "R";
//rptNo = "1";

//testCat = "3";
//labNum = "16732665";
int noOfMicroPdf = 0;
ArrayList reportList = null;
String tempFilePath = "";

String useSamba = "Y";
if (CMSDB.sysparams.get("smb_username") == null)
	useSamba = "N";

System.out.println("[displayLabReport] labNum="+labNum+", testCat="+testCat+", rptNo="+rptNo);

if (rptNo != null && rptNo.length() > 0 && !"3".equals(testCat)){	
	String deptGrp = CMSDB.getDeptGrp(testCat);
	
	reportList = CMSDB.getLabReport(labNum, deptGrp, rptNo);		
	if(reportList.size() == 1){
		ReportableListObject row = (ReportableListObject) reportList.get(0);
		String tempLabNum = row.getValue(0);
		String tempTestCat = row.getValue(1);
		String tempRptNo = row.getValue(2);
		String tempRptVer = row.getValue(3);
		String tempServer = row.getValue(4);
		String tempFolder = row.getValue(5);
		String tempSubFolder = row.getValue(6);
		String tempFName = row.getValue(7);
		if (tempServer != null && tempServer.length() > 0){
			tempFilePath = "//"+tempServer+"/"+tempFolder+"/"+tempSubFolder+"/"+tempFName;	
		}	
	}
} else if ("R".equals(testCat)) {
	String deptGrp = CMSDB.getDeptGrp(testCat);
	reportList = CMSDB.getLabReport(labNum, deptGrp, rptNo);
	if(reportList.size() == 1){
		ReportableListObject row = (ReportableListObject) reportList.get(0);
		String tempLabNum = row.getValue(0);
		String tempTestCat = row.getValue(1);
		String tempRptNo = row.getValue(2);
		String tempRptVer = row.getValue(3);
		String tempServer = row.getValue(4);
		String tempFolder = row.getValue(5);
		String tempSubFolder = row.getValue(6);
		String tempFName = row.getValue(7);
		if (tempServer != null && tempServer.length() > 0){
			tempFilePath = "//"+tempServer+"/"+tempFolder+"/"+tempSubFolder+"/"+tempFName;	
		}	
	}
	
	if(reportList.size() == 0){
		reportList = CMSDB.getReferralReport(labNum);	
		if(reportList.size() == 1){
			ReportableListObject row = (ReportableListObject) reportList.get(0);
			tempFilePath = row.getValue(0);		
		}	
	}
} else if ("3".equals(testCat)) {
	ArrayList labDetailList = CMSDB.getLabDetail(labNum);
	for (int i = 0; i < labDetailList.size(); i++) {
		ReportableListObject row = (ReportableListObject) labDetailList.get(i);		
		String tempTestNum = row.getValue(1);	
		ArrayList tempReportList = CMSDB.getLabReport(labNum, tempTestNum, null);
		if(tempReportList.size() > 0){
			ReportableListObject row2 = (ReportableListObject) tempReportList.get(0);
			String tempLabNum = row2.getValue(0);
			String tempTestCat = row2.getValue(1);
			String tempRptNo = row2.getValue(2);
			String tempRptVer = row2.getValue(3);
			String tempServer = row2.getValue(4);
			String tempFolder = row2.getValue(5);
			String tempSubFolder = row2.getValue(6);
			String tempFName = row2.getValue(7);
			if (tempServer != null && tempServer.length() > 0){
				tempFilePath = "//"+tempServer+"/"+tempFolder+"/"+tempSubFolder+"/"+tempFName;	
			}	
			
			noOfMicroPdf++;			
		}
	}
} else {
	String deptGrp = CMSDB.getDeptGrp(testCat);
	
	reportList = CMSDB.getLabReport(labNum, deptGrp, null);		
	if(reportList.size() == 1){
		ReportableListObject row = (ReportableListObject) reportList.get(0);
		String tempLabNum = row.getValue(0);
		String tempTestCat = row.getValue(1);
		String tempRptNo = row.getValue(2);
		String tempRptVer = row.getValue(3);
		String tempServer = row.getValue(4);
		String tempFolder = row.getValue(5);
		String tempSubFolder = row.getValue(6);
		String tempFName = row.getValue(7);
		if (tempServer != null && tempServer.length() > 0){
			tempFilePath = "//"+tempServer+"/"+tempFolder+"/"+tempSubFolder+"/"+tempFName;	
		}
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
		<title>Lab Document</title>
	</head>
	
<% if ((reportList != null && reportList.size() > 1) || noOfMicroPdf > 1){ %>
	<frameset name="displayLab_frameset" id="displayLab_frameset" border="1" frameborder="1" framespacing="0" cols="200, *">	
  		<frame name="menu" src="viewLeftMenu.jsp?<%="labNum="+labNum+"&testCat="+testCat%>"/>
		<frame name="content" src="viewPdf.jsp"/>
		<noframes>
				<P>Please use Internet Explorer or Mozilla!
		</noframes>
	</frameset>
<% } else if (((reportList != null && reportList.size() == 1) || noOfMicroPdf == 1) && tempFilePath != null) { 
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
<% } else { %>
	<body>
		Please call Lab to regenerate report
	</body>
	 <script>
// self executing function here
(function() {
<%
	if ("3".equals(testCat)) {
%>
	alert("Please call Medical Record to scan report");
<%
	} else {
%>
	alert("Please call Lab to regenerate report");
<%
	}
%>
	window.close();
})();
</script>
<% } %>		
</html>