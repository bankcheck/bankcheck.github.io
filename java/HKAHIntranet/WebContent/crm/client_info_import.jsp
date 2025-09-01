<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = request.getParameter("command");
String indexFile = request.getParameter("indexFile");

String message = "";
String errorMessage = "";

boolean uploadAction = false;
boolean confirmAction = false;

// Check that we have a file upload request
if (HttpFileUpload.isMultipartContent(request)){
	Vector uploadMessage = HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);

	if (uploadMessage.size() > 0) {
		for (int i=0; i<uploadMessage.size(); i++) {
			errorMessage += (String) uploadMessage.get(i) + "<BR>";
		}
	}
	uploadAction = true;
} else if ("confirm".equals(command)) {
	confirmAction = true;
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.client.import" />
	<jsp:param name="category" value="group.crm" />
</jsp:include>
<font color="blue"><%=message%></font>
<font color="red"><%=errorMessage%></font>
<%if (confirmAction) { %>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr valign="center">
		<td class="step3_1"><p><bean:message key="prompt.documentUpload" /></p></td>
		<td class="step3_2"><p><bean:message key="button.confirm" /></p></td>
		<td class="step3_3"><p><bean:message key="function.client.import" /></p></td>
	</tr>
</table>
<form name="form1" action="upload.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.fileName" /></td>
		<td class="infoData" width="70%"><%=indexFile%></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.description" /></td>
		<td class="infoData" width="70%"><input type="textfield" name="description" value="<%=indexFile.substring(0, indexFile.lastIndexOf(".")) %>" maxlength="100" size="50"></td>
	</tr>
	<tr class="smallText">
		<td align="center" colspan="4"><button onclick="return submitAction();"><bean:message key="button.save" /> <bean:message key="function.client.import" /></button></td>
	</tr>
</table>
<HR>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="3"><bean:message key="function.client.import" /></td>
	</tr>
	<tr class="smallText">
		<th width="60%" align="left"><u><bean:message key="prompt.fileName" /></u></th>
		<th width="10%" align="left"><u><bean:message key="prompt.fileSize" /></u></th>
		<th width="30%" align="left"><u><bean:message key="prompt.modifiedDate" /></u></th>
	</tr>
	<tr class="smallText">
		<td colspan="3">&nbsp;</td>
	</tr>
</table>
<input type="hidden" name="command" value="" />
<input type="hidden" name="indexFile" value="<%=indexFile %>" />
</form>
<script language="javascript">
	function createDirectory() {
		if (document.form1.folderName.value == '') {
			alert("<bean:message key="error.folderName.required" />.");
		} else {
			document.form1.action = "upload.jsp";
			document.form1.command.value = "folder";
			document.form1.submit();
		}
	}

	function moveDirectory(file) {
		document.form1.action = "upload.jsp";
		document.form1.command.value = "assign";
		document.form1.locationPath.value = file;
		document.form1.submit();
	}

	function downloadFile(file) {
		document.form1.action = "download.jsp";
		document.form1.locationPath.value = file;
		document.form1.submit();
	}

	function submitAction() {
		if (document.form1.description.value == '') {
			alert("<bean:message key="error.description.required" />.");
			return false;
		}
		document.form1.action = "upload.jsp";
		document.form1.command.value = "save";
		document.form1.submit();
	}
</script>
<a class="button" href="<html:rewrite page="/documentManage/upload.jsp" />" onclick="this.blur();"><span><bean:message key="prompt.backTo" /> <bean:message key="prompt.documentUpload" /></span></a>
<%
} else if (uploadAction) {
%>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr valign="center">
		<td class="step2_1"><p><bean:message key="prompt.documentUpload" /></p></td>
		<td class="step2_2"><p><bean:message key="button.confirm" /></p></td>
		<td class="step2_3"><p><bean:message key="function.client.import" /></p></td>
	</tr>
</table>
<form name="form1" action="upload.jsp" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<th class="{sorter: false}">&nbsp;</th>
		<th width="75%" align="center"><bean:message key="prompt.fileName" /></th>
		<th class="{sorter: false}"><bean:message key="prompt.action" /></th>
		<th class="{sorter: false}">&nbsp;</th>
	</tr>
<%
	File file = new File(ConstantsServerSide.UPLOAD_FOLDER);
	int i = 0;
	try {
		String[] children = file.list();
		for (int j=0; j<children.length; j++) {
%>
	<tr>
		<td align="center"><%=i + 1 %>)</td>
		<td align="left"><%=children[j] %></td>
		<td align="center">
			<button onclick="return assignIndex('<%=children[j] %>');"><bean:message key="function.client.import" /></button>
		<td align="right">&nbsp;</td>
	</tr>
<%
			i++;
		}
	} catch (Exception e) {
	}
%>
</table>
<input type="hidden" name="command" value="assign">
<input type="hidden" name="indexFile">
</form>
<script language="javascript">
	function assignIndex(file) {
		document.form1.indexFile.value = file;
		document.form1.submit();
	}
</script>
<a class="button" href="<html:rewrite page="/documentManage/upload.jsp" />" onclick="this.blur();"><span><bean:message key="prompt.backTo" /> <bean:message key="prompt.documentUpload" /></span></a>
<%} else {%>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr valign="center">
		<td class="step1_1"><p><bean:message key="prompt.documentUpload" /></p></td>
		<td class="step1_2"><p><bean:message key="button.confirm" /></p></td>
		<td class="step1_3"><p><bean:message key="function.client.import" /></p></td>
	</tr>
</table>
<form name="form1" enctype="multipart/form-data" action="client_info_import.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.uploadFile" /></td>
		<td class="infoData" width="70%"><input type="file" name="file1" class="multi" maxlength="1" accept="csv"></td>
	</tr>
	<tr class="smallText">
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td align="center" colspan="2">*<bean:message key="message.upload.csv" /></td>
	</tr>
	<tr class="smallText">
		<td align="center" colspan="2">
			<button type="submit"><bean:message key="prompt.uploadFile" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" value="upload">
<input type="hidden" name="toPDF" value="N">
</form>
<%}%>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>