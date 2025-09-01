<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	
	fileUpload = true;
}

UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "as_command");
String docId = ParserUtil.getParameter(request, "as_docId");

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if (fileUpload) {
	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("CTS");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(docId);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("upload");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("CTS");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(docId);
		String webUrl = tempStrBuffer.toString();

		for (int i = 0; i < fileList.length; i++) {
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);
			DocumentDB.add(userBean, "cts", docId, webUrl, fileList[i]);
		}
	}
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<form name="form1" enctype="multipart/form-data" action="docUpload.jsp" method="post">

<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%">Attach supporting document</td>
		<td class="infoData2" width="85%">	
		<span id="showDocument_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="cts" />
	<jsp:param name="keyID" value="<%=docId %>" />
	<jsp:param name="allowRemove" value="Y" />
</jsp:include>
		</span>
		<input type="file" name="file1" size="50" class="multi" maxlength="10">
		</td>
	</tr>
</table>

<input type="hidden" name="as_command">
<input type="hidden" name="as_docId" value="<%=docId %>">
</form>
<script language="javascript">
<!--
	$().ready(function(){
		$('#contractDateFrom').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#contractDateTo').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#completeDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#initDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
	});
	
	function submitAction(cmd) {
		if (cmd == 'create') {
			if (document.form1.corporationName.value == '') {
				document.form1.corporationName.focus();
				alert("Please input Corporation Name!");
				return false;
			}
		}
		document.form1.command.value = cmd;
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function removeDocument(did) {
		http.open('get', '../common/document_list.jsp?command=delete&moduleCode=cts&keyID=<%=docId %>&documentID=' + did + '&allowRemove="Y" %>&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById('showDocument_indicator').innerHTML = response;
		}
	}
-->
</script>