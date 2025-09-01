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
public class archive{
	String fileId;
	String filePath;
	String fileDesc;
	
	public archive(String fileId, String filePath, String keyword ){
		this.fileId = fileId;
		this.filePath = filePath;
		this.fileDesc = fileId + " " + keyword;
	}
}
%>
<%
String fileId = ParserUtil.getParameter(request, "fileId");

ArrayList reportList = null;
ArrayList<archive> archiveList = new ArrayList<archive>();

reportList = CMSDB.getFileArchive( fileId );
for (int i = 0; i < reportList.size(); i++) {
	ReportableListObject row = (ReportableListObject) reportList.get(i);
	String tempFileId = row.getValue(0);
	String tempServer = row.getValue(1);
	String tempFolder = row.getValue(2);
	String tempSubFolder = row.getValue(3);
	String tempFName = row.getValue(4);
	String tempKeyword = row.getValue(5);
	String tempFilePath = "//" + tempServer + "/" + tempFolder.replace("\\", "/") + "/"+tempSubFolder + "/" + tempFName;
	
	archiveList.add(new archive(tempFileId, tempFilePath, tempKeyword ));
}
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
<% for(archive l : archiveList){
%> 
	<li >
	<span class="file">
		<a onclick="linkSelected(this)" class="dlfilelink"
		href="../cms/viewPdf.jsp?filePath=<%=l.filePath%>" class="topstoryblue previewdoc" target="content">
		<H1 id="TS"><%=l.fileDesc%></H1>
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