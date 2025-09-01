<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.math.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%!
public class LabReport{
	String labNum;
	String testCat;
	String rptNo;
	String rptVer;	
	String fName;
	String filePath;
	String microDesc;
	
	public LabReport(String labNum, String testCat, String rptNo, String rptVer, String fName, String filePath, String microDesc){
		this.labNum = labNum;
		this.testCat = testCat;
		this.rptNo = rptNo;
		this.rptVer = rptVer;		
		this.fName = fName;
		this.filePath = filePath;
		this.microDesc = microDesc;
	}
}
%>
<%	
String labNum = ParserUtil.getParameter(request, "labNum");
String testCat = ParserUtil.getParameter(request, "testCat");

ArrayList reportList = null;
ArrayList<LabReport> labList = new ArrayList<LabReport>();

if("R".equals(testCat)){
	String deptGrp = CMSDB.getDeptGrp(testCat);
	
	reportList = CMSDB.getLabReport(labNum, deptGrp, null);
	for (int i = 0; i < reportList.size(); i++) {
		ReportableListObject row = (ReportableListObject) reportList.get(i);
		String tempLabNum = row.getValue(0);
		String tempTestCat = row.getValue(1);
		String tempRptNo = row.getValue(2);
		String tempRptVer = row.getValue(3);
		String tempServer = row.getValue(4);
		String tempFolder = row.getValue(5);
		String tempSubFolder = row.getValue(6);
		String tempFName = row.getValue(7);
		String tempFilePath = "//"+tempServer+"/"+tempFolder+"/"+tempSubFolder+"/"+tempFName;	
		labList.add(new LabReport(tempLabNum, tempTestCat, tempRptNo, tempRptVer, tempFName, tempFilePath, null));
	}
	
	if(reportList.size() == 0) {	
		reportList = CMSDB.getReferralReport(labNum);	
		for (int i = 0; i < reportList.size(); i++) {
			ReportableListObject row = (ReportableListObject) reportList.get(i);
			String tempFilePath = row.getValue(0);
			String fName = row.getValue(3) + " (Lab#:" + row.getValue(2) + ")";
			labList.add(new LabReport(null, null, null, null, fName, tempFilePath, null));
		}
	}
} else if ("3".equals(testCat)) {
	ArrayList labDetailList = CMSDB.getLabDetail(labNum);
	for (int i = 0; i < labDetailList.size(); i++) {
		ReportableListObject row = (ReportableListObject) labDetailList.get(i);		
		String tempTestNum = row.getValue(1);	
		String tempMicroDesc = row.getValue(2);
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
			String tempFilePath = "//"+tempServer+"/"+tempFolder+"/"+tempSubFolder+"/"+tempFName;	
			labList.add(new LabReport(tempLabNum, tempTestCat, tempRptNo, tempRptVer, tempFName, tempFilePath, tempMicroDesc));
		}
	}
} else {
	String deptGrp = CMSDB.getDeptGrp(testCat);
	
	reportList = CMSDB.getLabReport(labNum, deptGrp, null);
	for (int i = 0; i < reportList.size(); i++) {
		ReportableListObject row = (ReportableListObject) reportList.get(i);
		String tempLabNum = row.getValue(0);
		String tempTestCat = row.getValue(1);
		String tempRptNo = row.getValue(2);
		String tempRptVer = row.getValue(3);
		String tempServer = row.getValue(4);
		String tempFolder = row.getValue(5);
		String tempSubFolder = row.getValue(6);
		String tempFName = row.getValue(7);
		String tempFilePath = "//"+tempServer+"/"+tempFolder+"/"+tempSubFolder+"/"+tempFName;	
		labList.add(new LabReport(tempLabNum, tempTestCat, tempRptNo, tempRptVer, tempFName, tempFilePath, null));
	}
};



%>
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
<style>
a{color:#036;text-decoration:none;}a:hover{color:#ff3300;text-decoration:none;}
body { margin: 0px; font: 12px Arial, Helvetica, sans-serif; background-color: #ffffff; }

/* For menu with very long title */
.menuSmallText li a:link, .menuSmallText li a:visited { padding-top: 1px !important; font-size: 9px; }
.menuSmallText li a:hover { padding-top: 1px !important; font-size: 9px; }
.menuSmallText li a:active { padding-top: 1px !important; font-size: 9px; }

</style>
<body leftmargin='5' topmargin='5' marginleft='5' marginleft='5' bgcolor='#ffffff'>

<ul style="margin-top: 15px" class="filetree">
<% for(LabReport l : labList){
%> 
	<li >
	<span class="file">
		<a onclick="linkSelected(this)" class="dlfilelink"
		href="../cms/viewPdf.jsp?filePath=<%=l.filePath%>" class="topstoryblue previewdoc" target="content">
		<%if ("R".equals(testCat)) {%>
			<H1 id="TS"><%=l.fName%></H1>
		<% } else if ("3".equals(testCat)) { %> 
			<H1 id="TS"><%=l.microDesc + " " + l.rptNo+" "+l.fName+" (ver."+l.rptVer+")"%></H1>
		<% } else { %>
			<H1 id="TS"><%=l.rptNo+" "+l.fName+" (ver."+l.rptVer+")"%></H1>
		<% } %>
		</a>
	</span>
	</li>
 <% } %>
</ul>

<script language="JavaScript">
function linkSelected(obj){
	$(".link_selected").removeClass("link_selected");
	$(obj).children().addClass('link_selected');		
}
</script>
</body>
</html:html>