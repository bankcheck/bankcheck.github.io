<%@ page import="java.math.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.displaytag.tags.*"%>
<%@ page import="org.displaytag.util.*"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileFilter"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.nio.file.DirectoryStream"%>
<%@ page import="java.nio.file.FileSystems"%>
<%@ page import="java.nio.file.Files"%>
<%@ page import="java.nio.file.Path"%>
<%@ page import="java.nio.file.DirectoryStream.Filter"%>
<%@ page import="java.nio.file.attribute.FileTime" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page import="org.apache.commons.io.IOCase" %>
<%@ page import="org.apache.commons.io.filefilter.PrefixFileFilter" %>
<%!
private void getRelatedImportedBatches(FsImportBatch batch) {
	if (batch == null) 
		return;
	
	String fileName = batch.getFsIndexFileName();
	List<FsImportBatch> batches = null;
	if (fileName != null) {
		int seqIdx = fileName.lastIndexOf("_");
		String prefix = fileName.substring(0, seqIdx);
		
		batch.setDiffSeqBatches(ForwardScanningDB.getRelatedImportedBatches(prefix));
	}
}
%>

<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");

String stationID = ParserUtil.getParameter(request, "stationID");
String station = ParserUtil.getParameter(request, "station");

String listTablePageParaName = (new ParamEncoder("row").encodeParameterName(TableTagParameters.PARAMETER_PAGE));
String listTableCurPage = request.getParameter(listTablePageParaName);
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

String listLabel = "function.fs.batch.list";

Map<String, String> tooltips = new HashMap<String, String>();
tooltips.put("show_remark","Shows latest 35-days batches (after 03-Dec-2019)");

FsModelHelper helper = FsModelHelper.getInstance();
Map<String, String> stationIDs = helper.stationIDs;
List<FsImportBatch> notImportBatches = new ArrayList<FsImportBatch>(); 
Map<String, String> notImportBatchesAttr = new HashMap<String, String>();
long elapsedSec = 0L;
int fileSearched = 0;
String fileBasePath = "\\\\" + stationIDs.get(station) + "\\BatchesPro";

if ("search".equals(command)) {
	File directory = new File(fileBasePath);
	List<String> batchesFileName = ForwardScanningDB.getBatchFileNames(null);
	String searchTime = DateTimeUtil.getCurrentDateTime();
	try {
		  final Calendar today = Calendar.getInstance();
		  
		  System.out.println(new Date() + " [fs.batch_list] NIO run... filePath=" + fileBasePath );
		  long start = System.currentTimeMillis();
		  Path dir = FileSystems.getDefault().getPath( fileBasePath );
		  //DirectoryStream<Path> stream = Files.newDirectoryStream( dir );
		  final Calendar beginDateCal = Calendar.getInstance();
		  beginDateCal.set(2019, Calendar.DECEMBER, 3, 0, 0, 0);	// 2019-12-03
		  //Date beginDate = beginDateCal.getTime();

		  DirectoryStream<Path> stream = Files.newDirectoryStream(dir, new DirectoryStream.Filter<Path>() {
		    //@Override
		    public boolean accept(Path entry) throws IOException {
		        FileTime fileTime = Files.getLastModifiedTime(entry);
		        long millis = fileTime.to(TimeUnit.MILLISECONDS);
				Date fileLastModified = new Date(millis);
				Calendar fileLastModifiedCal = Calendar.getInstance();
				fileLastModifiedCal.setTime(fileLastModified);

		        // L is necessary for the result to correctly be calculated as a long 
		        return beginDateCal.before(fileLastModifiedCal)	// only check batches >= 2019-12-03
		        		&& today.getTimeInMillis() < millis + (35L * 24 * 60 * 60 * 1000);	// within latest 35 days
		    }
			});

		  String fileName = null;
		  for (Path path : stream) {
		    //System.out.println( "" + i + ": " + path.getFileName() );
		    if (!path.toFile().isDirectory()) {
		    	fileName = path.getFileName().toString();
		    	
		    	//System.out.println( "" + i++ + ": " + fileName );
		    	if (!batchesFileName.contains(fileName)) {
		    		FsImportBatch batch = new FsImportBatch(fileName);
		    		
		    		// search db
		    		getRelatedImportedBatches(batch);
		    		
		    		// search folder
		    		/*
		    		System.out.println(fileSearched + ") not import file:" + fileName);
		    		int seqIdx = fileName.lastIndexOf("_");
		    		String prefix = fileName.substring(0, seqIdx);
		    		//System.out.println("  check prefix=<"+prefix+">");
		    		
		    		File[] files = directory.listFiles();
		    		files = directory.listFiles((FileFilter) new PrefixFileFilter(prefix, IOCase.SENSITIVE));
		    		//System.out.println("  prefix file size=" + files.length);
		    		for (int i = 0; i < files.length; i++) {
		    			String thisFileName = files[i].getName();
		    			if (!thisFileName.equals(fileName)) {
		    				//System.out.println("    " + files[i].getName());
		    				
		    				batch.getDiffSeqBatches().add(new FsImportBatch(thisFileName));
		    			}
		    		}
		    		*/
		    		
		    		notImportBatches.add(batch);
		    	}
		    	++fileSearched;
		    }
		    //if (++i > maxFiles) break;
		  }
		  stream.close();
		  long stop = System.currentTimeMillis();
		  elapsedSec = (stop - start)/1000;
		  System.out.println(new Date() + " [fs.batch_list] Elapsed: " + (stop - start) + " ms, search file total: " + fileSearched );
		  
		  notImportBatchesAttr.put("batch_list_time", searchTime);
		  notImportBatchesAttr.put("batch_list_station", station);
		  notImportBatchesAttr.put("batch_list_fileSearched", String.valueOf(fileSearched));
		  notImportBatchesAttr.put("batch_list_elapsedSec", String.valueOf(elapsedSec));
		  
		  request.getSession().setAttribute("batch_list_attr", notImportBatchesAttr);
		  request.getSession().setAttribute("batch_list", notImportBatches);
	} catch (Exception e) {
		e.printStackTrace();
	}
} else if ("cache".equals(command)) {
	notImportBatches = (ArrayList<FsImportBatch>) request.getSession().getAttribute("batch_list");
	notImportBatchesAttr = (Map<String, String>) request.getSession().getAttribute("batch_list_attr");
	fileBasePath = "\\\\" + stationIDs.get(notImportBatchesAttr.get("batch_list_station")) + "\\BatchesPro";
} else {
	notImportBatchesAttr = (Map<String, String>) request.getSession().getAttribute("batch_list_attr");
}

request.setAttribute("batch_list", notImportBatches);
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<style>
#patmerge_alert_box {
	padding: 5px;
	background: #ffff99;
	border: 1px solid #f0c36d;
	border-radius: 2px;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

div.scroll {
    background-color: #E6E6E6;
    height: 200px;
    overflow: scroll;
}
</style>
<body>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame style="min-height:0px;">
<jsp:include page="../common/page_title.jsp">
	<jsp:param name="pageTitle" value="<%= listLabel %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<jsp:include page="back.jsp" flush="false" />
<form name="search_form" action="batch_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" >
		<tr>
			<td colspan="2"><div id="patmerge_alert_box"><%=tooltips.get("show_remark") %></div></td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Scanner Station ID</td> 
			<td class="infoData">
				<select name="station">
					<jsp:include page="../ui/fsStationCMB.jsp" flush="true">
						<jsp:param name="stationID" value="<%=station %>" />
					</jsp:include>
				</select>
			</td>
		</tr>

		<tr class="smallText">
			<td colspan="2" align="center">
				<button onclick="return submitSearch();"><bean:message key="button.search" /> not imported batches</button>
				<%
				//List<FsImportBatch> lastNotImportBatches = (ArrayList<FsImportBatch>) request.getSession().getAttribute("batch_list");
				String lastSearchTime = notImportBatchesAttr == null ? null : notImportBatchesAttr.get("batch_list_time");
				if (lastSearchTime != null) {
				%>
					<button onclick="return submitSearch('cache');" <% if (lastSearchTime == null) { %>disabled<% } %>>Show last search<% if (lastSearchTime != null) { %>@<%=lastSearchTime%><% } %></button>
				<%
				}
				%>
			</td>
		</tr>
	</table>
	<input type="hidden" name="<%=listTablePageParaName %>" /> 
	<input type="hidden" name="command" value="search" />
	<input type="hidden" name="step" />
	<input type="hidden" name="fileIndexIds" />
</form>
<bean:define id="functionLabel"><bean:message key="<%=listLabel %>" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<div id="search_result_attr">
<% if (command != null && !command.isEmpty() && notImportBatchesAttr != null) { %>
Station ID: <%=notImportBatchesAttr.get("batch_list_station") == null ? "N/A" : notImportBatchesAttr.get("batch_list_station") %>. <%=notImportBatchesAttr.get("batch_list_fileSearched") %> file(s) searched in <%=notImportBatchesAttr.get("batch_list_elapsedSec") %> second(s). Search time: <%=notImportBatchesAttr.get("batch_list_time") %>
<% } %>
</div>
<form name="form1" action="batch_list.jsp" method="post">
	<display:table id="row" name="requestScope.batch_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<%
		String recordId = null;
		String fileIndexId = null;
		FsImportLog thisFsImportLog = null;
		FsImportBatch batch = (FsImportBatch) pageContext.getAttribute("row");
		String fileName = batch == null ? null : batch.getFsIndexFileName();
		String filePath = null;
	%>
		<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
		<display:column title="Batch File Name" style="width:50%">
			<% 
				filePath = fileBasePath + "\\" + fileName;
				filePath = filePath.replace("\\", "\\\\");
			%>
			<a href="javascript:void(0);" onclick="downloadImportFile('<%=filePath %>')"><%=fileName %></a>
		</display:column>
		<display:column property="diffSeqBatchesHTMLStr" title="Imported batches that may be duplication" style="width:50%" />
		<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>" />
	</display:table>
	<input type="hidden" name="command" />
	<input type="hidden" name="step" />
</form>
<form name="download_form" action="../documentManage/download.jsp">
	<input type="hidden" name="locationPath" />
	<input type="hidden" name="rootFolder" />
</form>
<script language="javascript">

	$(document).ready(function(){
		
	});

	function submitSearch(cmd) {
		if (cmd == 'cache') {
			document.search_form.command.value = 'cache';
		}
		document.search_form.submit();
		showLoadingBox('body', 500, $(window).scrollTop());
		return false;
	}

	function clearSearch() {
		return false;
	}
	
	function downloadImportFile(path) {
		document.download_form.locationPath.value = path;
		document.download_form.rootFolder.value = "\\";
		document.download_form.submit();
	}
</script></DIV>

</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>