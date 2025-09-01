<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.struts.Globals"%>
<%! 
private String showFile(String documentID, String labelTitle,boolean withFolder, boolean latestFile,
		boolean showSubFolder, boolean onlyShowCurrentYear, boolean showPointForm) {
	
		StringBuffer outputUrl = new StringBuffer();
		if (showPointForm) {
			outputUrl.append("<li>");
		} else {
			outputUrl.append("<tr>");
			outputUrl.append("<td class=\"h1_margin\">");
		}
		if (latestFile) {
			outputUrl.append("<a href=\"javascript:downloadFile('");
			outputUrl.append(documentID);
			outputUrl.append("', '');\"");
		} else if (withFolder) {
			outputUrl.append("<a href=\"javascript:slickToggle('");
			outputUrl.append(documentID);
			outputUrl.append("');\"");
		} else {
			outputUrl.append("<a href=\"#\"");
		}
		outputUrl.append(" class=\"topstoryblue\"><H1 id=\"TS\">");
		outputUrl.append(labelTitle);
		outputUrl.append("</H1></a>");
		if (withFolder) {
			outputUrl.append("<div id=\"content-");
			outputUrl.append(documentID);
			outputUrl.append("\">");
			outputUrl.append("<ul id=\"\" style=\"padding:12px\">");
			ReportableListObject row = DocumentDB.getReportableListObject(documentID);
			if (row != null) {
				String rootFolder = ConstantsServerSide.DOCUMENT_FOLDER;
				String locationPath = row.getValue(2);
				String filePrefix = row.getValue(5);
				String fileSuffix = row.getValue(6);

				// is the file located in web folder
				if ("N".equals(row.getValue(3))) {
					rootFolder = "";
				}

				getFileNameList(rootFolder, locationPath,
						documentID, filePrefix, fileSuffix, "/", showSubFolder, onlyShowCurrentYear, outputUrl);
			}
			outputUrl.append("</ul>");
			outputUrl.append("</div>");
		}
		if (showPointForm) {
			outputUrl.append("</li>");
		} else {
			outputUrl.append("</td>");
			outputUrl.append("</tr>");
		}
		return outputUrl.toString();

}

private void getFileNameList(String rootFolder, String locationPath,
		String documentID, String filePrefix, String fileSuffix, String fileDirectory,
		boolean showSubFolder, boolean onlyShowCurrentYear, StringBuffer outputUrl) {
	File directory = new File(rootFolder + locationPath + fileDirectory);

	String[] children = directory.list();
	if (children != null && children.length > 0) {
		File newDirectory = null;
		String newFileName = null;
		int fileNameIndex = -1;
		boolean foundMatchFile = false;
		String currentYear = String.valueOf(DateTimeUtil.getCurrentYear());
		try {
			for (int i = 0; i < children.length; i++) {
				newDirectory = new File(directory.toString() + "/" + children[i]);
				if (newDirectory.exists()) {
					if (newDirectory.isFile()
							&& (filePrefix == null || filePrefix.length() == 0 || children[i].indexOf(filePrefix) >= 0)
							&& (fileSuffix == null || fileSuffix.length() == 0 || children[i].indexOf(fileSuffix) > 0)
							&& !"Thumbs.db".equals(children[i])){
						outputUrl.append("<li style=\"list-style-image: url(../images/ic/starAnimated.gif)\">");
						outputUrl.append("<a href=\"javascript:downloadFile('");
						outputUrl.append(documentID);
						outputUrl.append("','");
						outputUrl.append(fileDirectory);
						outputUrl.append(children[i]);
						outputUrl.append("');\" class=\"topstoryblue\"><H1 id=\"TS\">");
						newFileName = children[i];
						if (filePrefix != null && filePrefix.length() > 0) {
							if ((fileNameIndex = newFileName.indexOf(filePrefix)) >= 0) {
								newFileName = newFileName.substring(fileNameIndex + filePrefix.length());
							}
						}
						if (fileSuffix != null && fileSuffix.length() > 0) {
							if ((fileNameIndex = newFileName.indexOf(fileSuffix)) >= 0) {
								newFileName = newFileName.substring(0, fileNameIndex);
							}
						}
						outputUrl.append(newFileName);
						outputUrl.append("</H1></a>");
						outputUrl.append("</li>");
						foundMatchFile = true;
					} else if (newDirectory.isDirectory()) {
						if (showSubFolder) {
							outputUrl.append("<li style=\"list-style-image: url(../images/ic/title.gif)\"><B>");
							outputUrl.append(children[i]);
							outputUrl.append("</B></li>");
							outputUrl.append("<ul style=\" padding-left:20px;\">");
							getFileNameList(rootFolder, locationPath,
									documentID, filePrefix, fileSuffix, fileDirectory + children[i] + "/", false, false, outputUrl);
							outputUrl.append("</ul>");
						}
					}
				}
			}
		} catch (Exception e) {
		}
	}
}
%>
<%
UserBean userBean = new UserBean(request);
String category = request.getParameter("category");
String siteCode = userBean.getSiteCode()==null?"twah":userBean.getSiteCode();

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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<table border=0 cellspacing=0 cellpadding=0 width="100%">
<tr>
	<td>
	<a href="../common/leftright_portal.jsp?category=ic" target="_content"><img src="../images/ic/icTitle_<%=siteCode %>.jpg"  width="800" height="120" border="0"/></a>
	</td>
</tr>
</table>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="" />
	<jsp:param name="suffix" value="_4"/>
	<jsp:param name="pageMap" value="N"/>
	<jsp:param name="mustLogin" value="Y" />
</jsp:include>
<%if("Department Policy".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<ul id="" style="padding:12px">
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("412", "", true, true,true,false,false) %>
<%}else{ %>
<%=showFile("360", "", true, true,true,false,false) %>
<%} %>
</ul>
</div>
<%} %>
<%if("Audit".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<ul id="" style="padding:12px">	
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("413", "", true, true,true,false,false) %>
<%}else{ %>
	<li style="list-style-image: url(../images/ic/title.gif)">Hand Hygiene</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('375','Hand Hygiene Audit in 5 Moments (Q3) ppt.ppt');return false;" target="_blank">Hand Hygiene Audit (Q3) 2010</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('375','HH on April - May 2010.ppt');return false;" target="_blank">Hand Hygiene Audit (Q2) 2010</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('375','HH on Jan - Mar 2010.ppt');return false;" target="_blank">Hand Hygiene Audit (Q1) 2010</a></li>

	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI re`rt 2009 for HH (Q1).doc');return false;" target="_blank">Hand Hygiene Audit (Q1) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2009 for HH (Q2).doc');return false;" target="_blank">Hand Hygiene Audit (Q2) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2009 for HH (Q3).doc');return false;" target="_blank">Hand Hygiene Audit (Q3) 2009</a></li>

	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2008 for HH (Q1).doc');return false;" target="_blank">Hand Hygiene Audit (Q1) 2008</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2008 for HH (Q2).doc');return false;" target="_blank">Hand Hygiene Audit (Q2) 2008</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2008 for HH (Q3).doc');return false;" target="_blank">Hand Hygiene Audit (Q3) 2008</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2008 for HH (Q4).doc');return false;" target="_blank">Hand Hygiene Audit (Q3) 2008</a></li>

	<li style="list-style-image: url(../images/ic/title.gif)">Gowning</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2010 for Gowing (Q2).doc');return false;" target="_blank">Gowning (Q2) 2010</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2010 for Gowing (Q1).doc');return false;" target="_blank">Gowning (Q1) 2010</a></li>
	<li style="list-style-image: url(../images/ic/title.gif)">Degowning</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2010 for Degowing (Q2).doc');return false;" target="_blank">Degowning (Q2) 2010</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2010 for Degowing (Q1).doc');return false;" target="_blank">Degowning (Q1) 2010</a></li>
	<li style="list-style-image: url(../images/ic/title.gif)">BPE</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('374','PI Report 2010 for BPE (Q3).doc');return false;" target="_blank">Bloodborne Pathogen Exposure (Q3) 2010</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('374','PI Report 2010 for BPE (Q2).doc');return false;" target="_blank">Bloodborne Pathogen Exposure (Q2) 2010</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('374','PI Report 2010 for BPE (Q1).doc');return false;" target="_blank">Bloodborne Pathogen Exposure (Q1) 2010</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI Report 2009 for BPE (Q1).doc');return false;" target="_blank">Bloodborne Pathogen Exposure (Q1) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI Report 2009 for BPE (Q2).doc');return false;" target="_blank">Bloodborne Pathogen Exposure (Q2) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI Report 2009 for BPE (Q3).doc');return false;" target="_blank">Bloodborne Pathogen Exposure (Q3) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI Report 2009 for BPE (Q4).doc');return false;" target="_blank">Bloodborne Pathogen Exposure (Q4) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI Report 2008 for BPE (Q1).doc');return false;" target="_blank">Bloodborne Pathogen Exposure (Q1) 2008</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI Report 2008 for BPE (Q2).doc');return false;" target="_blank">Bloodborne Pathogen Exposure (Q2) 2008</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI Report 2008 for BPE (Q3).doc');return false;" target="_blank">Bloodborne Pathogen Exposure (Q3) 2008</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI Report 2008 for BPE (Q4).doc');return false;" target="_blank">Bloodborne Pathogen Exposure (Q4) 2008</a></li>
	<li style="list-style-image: url(../images/ic/title.gif)">SSI</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('374','PI report 2010 for SSI (Q2).doc');return false;" target="_blank">Surgical Site Infection (Q2) 2010</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('374','PI report 2010 for SSI (Q1).doc');return false;" target="_blank">Surgical Site Infection (Q1) 2010</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2009 for SSI (Q1).doc');return false;" target="_blank">Surgical Site Infection (Q1) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2009 for SSI (Q2).doc');return false;" target="_blank">Surgical Site Infection (Q2) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2009 for SSI (Q3).doc');return false;" target="_blank">Surgical Site Infection (Q3) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2009 for SSI (Q4).doc');return false;" target="_blank">Surgical Site Infection (Q4) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2008 for SSI (Q1).doc');return false;" target="_blank">Surgical Site Infection (Q1) 2008</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2008 for SSI (Q2).doc');return false;" target="_blank">Surgical Site Infection (Q2) 2008</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2008 for SSI (Q3).doc');return false;" target="_blank">Surgical Site Infection (Q3) 2008</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2008 for SSI (Q4).doc');return false;" target="_blank">Surgical Site Infection (Q4) 2008</a></li>
	<li style="list-style-image: url(../images/ic/title.gif)">Report Notification of Infectious Disease</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('374','PI Report 2010 for RNID (Q3).doc');return false;" target="_blank">Report Notification of Infectious Disease (Q3) 2010</a></li>	
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('374','PI Report 2010 for RNID (Q2).doc');return false;" target="_blank">Report Notification of Infectious Disease (Q2) 2010</a></li>	
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('374','PI Report 2010 for RNID (Q1).doc');return false;" target="_blank">Report Notification of Infectious Disease (Q1) 2010</a></li>	
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2009 for RNID (Q1).doc');return false;" target="_blank">Report Notification of Infectious Disease (Q1) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2009 for RNID (Q2).doc');return false;" target="_blank">Report Notification of Infectious Disease (Q2) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2009 for RNID (Q3).doc');return false;" target="_blank">Report Notification of Infectious Disease (Q3) 2009</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','PI report 2009 for RNID (Q4).doc');return false;" target="_blank">Report Notification of Infectious Disease (Q4) 2009</a></li>
	<li style="list-style-image: url(../images/ic/title.gif)">MDRO</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','281008 Antimicrobial Management Program Report.doc');return false;" target="_blank">Monitoring Antibiotic Usage (Jun – Oct 2008)</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('372','MDRO 2008.ppt');return false;" target="_blank">Multi-Drug Resistance Organism (Jan – Jun 2008)</a></li>
<%} %>	
</ul>
</div>
<%} %>
<%if("WasteManagement".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<ul id="" style="padding:12px">	
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("414", "", true, true,true,false,false) %>
<%}else{ %>
<%=showFile("378", "", true, false,true,false,false) %>
<%} %>
</ul>
</div>
<%} %>
<%if("ICCMinutes".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<ul id="" style="padding:12px">	
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("416", "", true, true,true,false,false) %>
<%}else{ %>
	<li style="list-style-image: url(../images/ic/title.gif)">2010</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('380','ICC Minutes 100209.pdf');return false;" target="_blank">ICC Minutes 100209</a></li>
	<li style="list-style-image: url(../images/ic/title.gif)">2009</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('381','ICC Minutes 090210.pdf');return false;" target="_blank">ICC Minutes 090210</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('381','ICC Minutes 091005.pdf');return false;" target="_blank">ICC Minutes 091005</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('381','ICC Minutes 091218.pdf');return false;" target="_blank">ICC Minutes 091218</a></li>
<%} %>
</ul>
</div>
<%} %>
<%if("ICCCharts".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<ul id="" style="padding:12px">	
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("417", "", true, true,true,false,false) %>
<%}else{ %>
	<li style="list-style-image: url(../images/ic/title.gif)">2010</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('380','ICC Memebers 2010.ppt');return false;" target="_blank">ICC Memebers 2010</a></li>
	<li style="list-style-image: url(../images/ic/title.gif)">2009</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('381','ICC Memebers 2009.ppt');return false;" target="_blank">ICC Memebers 2009</a></li>
<%} %>
</ul>
</div>
<%} %>
<%if("ICLNPCharts".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<ul id="" style="padding:12px">	
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("418", "", true, true,true,false,false) %>
<%}else{ %>
	<li style="list-style-image: url(../images/ic/title.gif)">2010</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('382','ICLNP 2010.ppt');return false;" target="_blank">ICLNP Memebers 2010</a></li>
	<li style="list-style-image: url(../images/ic/title.gif)">2009</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('383','ICLNP 2009.ppt');return false;" target="_blank">ICLNP Memebers 2009</a></li>
<%} %>
</ul>
</div>
<%} %>
<%if("ICLNPMinutes".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<ul id="" style="padding:12px">	
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("419", "", true, true,true,false,false) %>
<%}else{ %>
	<li style="list-style-image: url(../images/ic/title.gif)">2010</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('382','ICLNP Minutes 100223.pdf');return false;" target="_blank">ICLNP Minutes 100223</a></li>
	<li style="list-style-image: url(../images/ic/title.gif)">2009</li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('383','ICLNP Minutes 090224.pdf');return false;" target="_blank">ICLNP Minutes 090224</a></li>
	<li style="list-style-image: url(../images/ic/starAnimated.gif)"><a href="javascript:void(0);" onclick="downloadFile('383','ICLNP Minutes 091020.pdf');return false;" target="_blank">ICLNP Minutes 091020</a></li>
<%} %>
</ul>
</div>
<%} %>

<%if("Video".equals(category)){ %>
<%if (ConstantsServerSide.isTWAH()) {%>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<jsp:include page="../education/NSI_Popup.jsp" flush="false">
<jsp:param name="module" value="IC"/>
</jsp:include>
</div>
<%}%>
<%}else if("gown".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%=showFile("530", "", true, true,false,false,false) %>
</div>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<jsp:include page="../education/NSI_Popup.jsp" flush="false">
<jsp:param name="module" value="GOWN"/>
</jsp:include>
</div>
<%} %>
<%if("Form".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("420", "", true, true,true,false,false) %>
<%}else{ %>
<%=showFile("371", "", true, true,false,false,false) %>
<%} %>
</div>
<%} %>
<%if("eduMaterial".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%=showFile("535", "", true, true,true,false,false) %>
</div>
<%} %>
<%if("aviFlu".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%=showFile("377", "", true, true,false,false,false) %>
</div>
<%} %>
<%if("isolate".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%=showFile("532", "", true, true,false,false,false) %>
</div>
<%} %>
<%if("handHygiene".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%=showFile("370", "", true, true,false,false,false) %>
</div>
<%} %>
<%if("Poster".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("421", "", true, true,true,false,false) %>
<%}else{ %>
<%=showFile("385", "", true, true,false,false,false) %>
<%} %>
</div>
<%} %>
<%if("newsletter".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("425", "", true, true,true,false,false) %>
<%}else{ %>
<%=showFile("385", "", true, true,false,false,false) %>
<%} %>
</div>
<%} %>
<%if("ICPractice".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%	
	String newsID = "1";
	String title = null;
	String titleImage = null;
	String newsCategory = "infection control";
	String content = null;
	if (newsID != null && newsID.length() > 0) {
	ArrayList result = null;
	// get news content

		result = NewsDB.get(userBean,newsID, newsCategory);

	if (result.size() > 0) {
		ReportableListObject row = (ReportableListObject) result.get(0);
		title = row.getValue(3);
		titleImage = row.getValue(5);


		StringBuffer contentSB = new StringBuffer();
		result = NewsDB.getContent(newsID, newsCategory);
		if (result != null) {
			for (int i = 0; i < result.size(); i++) {
				row = (ReportableListObject) result.get(i);
				contentSB.append(row.getValue(0));
			}
		}
		content = contentSB.toString();
	}
} %>
<div class="memo">
<a class=""><img src="../images/ic/starAnimated.gif"/><H1 id="ART"><%=title %></H1><img src="../images/ic/starAnimated.gif"/></a>&nbsp;&nbsp;<p/><br/>
<span class="" style="line-height: 20px">
<%	if (titleImage != null && titleImage.length() > 0) {
		if (titleImage.indexOf("http://") == 0) { %>
			<br/><img src="<%=titleImage %>"><br/>
<%		} else { %>
			<br/><img src="/upload/<%=newsCategory %>/<%=newsID %>/<%=titleImage %>"><br/>
<%		}
	} %>
	<%=content %>
</span>
</div>
</div>
<%} %>
<%if("inService".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("422", "", true, true,true,false,false) %>
<%}else{ %>
<%=showFile("387", "", true, true,false,false,false) %>
<%} %>
</div>
<%} %>
<%if("program".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("423", "", true, true,true,false,false) %>
<%}else{ %>
<%} %>
</div>
<%} %>
<%if("surveillance".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("424", "", true, true,true,false,false) %>
<%}else{ %>
<%} %>
</div>
<%} %>
<%if("scopeOfService".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("427", "", true, true,true,false,false) %>
<%}else{ %>
<%} %>
</div>
<%} %>
<%if("fitTest".equals(category)){ %>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<%if (ConstantsServerSide.isTWAH()) {%>
<%=showFile("426", "", true, true,true,false,false) %>
<%}else{ %>
<%=showFile("534", "", true, true,true,false,false) %>
<%} %>
</div>
<%if (ConstantsServerSide.isHKAH()) {%>
<div style="margin: 5px; border-width:2px; border-style:dashed; border-color:#E8A89B; padding:12px; width:700px;">
<jsp:include page="../education/NSI_Popup.jsp" flush="false">
<jsp:param name="module" value="ICN95"/>
</jsp:include>
</div>
<%}} %>
<DIV>
</DIV></DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<script>
function playMovie(file) {
	var FO = {
		movie:"../swf/flvplayer.swf",
		width:"640px",
		height:"480px",
		majorversion:"7",
		build:"0",
		flashvars:"file="+file+"&autoStart=true&repeat=true"
	};

	UFO.create(FO, 'player');
}
</script>
</html:html>