<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
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

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String enlID = ParserUtil.getParameter(request, "enlID");
String patientType = ParserUtil.getParameter(request, "patientType");
String contentID = ParserUtil.getParameter(request, "contentID");
String Dept = ParserUtil.getParameter(request, "Dept");
String contentTitle = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "contentTitle"));
String contentTitleURL = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "contentTitleURL"));
String contentDesc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "contentDesc"));
String content = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "content"));


boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

if (fileUpload) {
	if (createAction && "1".equals(step)) {
		// get news id with dummy data
		contentID = ENewsletterDB.addContent(userBean, enlID, Dept, patientType);
	}

	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("E-Newsletter");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(patientType);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(enlID);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(Dept);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(content);

		for (int i = 0; i < fileList.length; i++) {

			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);

			// skip newsTitleImage
				tempStrBuffer.append("<a href=\"");
				tempStrBuffer.append("/upload/");
				tempStrBuffer.append("E-Newsletter");
				tempStrBuffer.append("/");
				tempStrBuffer.append(patientType);
				tempStrBuffer.append("/");
				tempStrBuffer.append(enlID);
				tempStrBuffer.append("/");
				tempStrBuffer.append(Dept);
				tempStrBuffer.append("/");
				tempStrBuffer.append(contentID);
				tempStrBuffer.append(fileList[i]);
				tempStrBuffer.append("\">");
				tempStrBuffer.append(fileList[i]);
				tempStrBuffer.append("</a><BR>");
		}
		contentDesc = tempStrBuffer.toString();
	}
}

try {
	if ("1".equals(step)) {
		if (createAction || updateAction) {
			// get news id with dummy data
			if (createAction && contentID == null) {
				contentID = ENewsletterDB.addContent(userBean,enlID, patientType, Dept);
			}
			System.out.println("[contentTitleURL]"+contentTitleURL);
			if (ENewsletterDB.updateContent(userBean, enlID, patientType, contentID, Dept, contentTitle, contentTitleURL, 
					contentDesc)) {
				if (createAction) {
					message = "Content created.";
					createAction = false;
				} else {
					message = "Content updated.";
					updateAction = false;
				}
				step = null;
			} else {
				if (createAction) {
					errorMessage = "Content create fail.";
				} else {
					errorMessage = "Content update fail.";
				}
			}
		} else if (deleteAction) {
			if (ENewsletterDB.deleteContent(userBean, contentID, Dept, enlID, patientType )) {
				message = "Content removed.";
				closeAction = true;
			} else {
				errorMessage = "Content remove fail.";
			}
		}
	} else if (createAction) {
		contentID = "";
		Dept = "";
		contentTitle = "";
		contentTitleURL = "";
		contentDesc = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (contentID != null && contentID.length() > 0) {
			System.out.println("[enlID]"+enlID+"[patientType]"+patientType+"[Dept]"+Dept+"[contentID]"+contentID);
			ArrayList record = ENewsletterDB.getContent(enlID, patientType, Dept,contentID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
			
				contentTitle = row.getValue(0);
				contentTitleURL = row.getValue(1);
				contentDesc = row.getValue(2);

			} else {
				closeAction = false;
			}
		} else {
			closeAction = false;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.news." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" enctype="multipart/form-data" action="newsletter.jsp"  method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Department</td>
		<td class="infoData" width="70%">
<%		if (createAction) { %>
			<select name="Dept">
			<jsp:include page="../ui/enewsletterDeptCMB.jsp" flush="false">
			<jsp:param name="Dept" value="<%=Dept %>" />
			<jsp:param name="enlID" value="<%=enlID %>" />
			<jsp:param name="patientType" value="<%=patientType %>" /> 			
			</jsp:include>
			</select>
<%		} else { %>
			<%= Dept==null?"":Dept.toUpperCase() %>
<%		} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.headline" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="contentTitle" value="<%=contentTitle==null?"":contentTitle %>" maxlength="200" size="80">
<%	} else { %>
			<%=contentTitle==null?"":contentTitle %>
<%	} %>
		</td>
	</tr>
	
		<tr class="smallText">
		<td class="infoLabel" width="30%">Headline URL</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="contentTitleURL" value="<%=contentTitleURL==null?"":contentTitleURL %>" maxlength="200" size="80">
<%	} else { %>
			<%=contentTitleURL==null?"":contentTitleURL %>
<%	} %>
		</td>
	</tr>

<%	if (createAction || updateAction) { %>
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.attachment" /></td>
		<td class="infoData">
			<input type="file" name="file1" size="50" class="multi" maxlength="5">
		</td>
	</tr>
<%	} %>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.content" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<div class="box"><textarea id="wysiwyg" name="content" rows="12" cols="100"><%=contentDesc %></textarea></div>
<%	} else { %>
			<%=contentDesc==null?"":contentDesc %>
<%	} %>
		</td>
	</tr>

</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click">Save</button>
			<button onclick="return submitAction('view', 0);" class="btn-click">Cancel</button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click">Update</button>
			<button class="btn-delete">Delete</button>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="contentID" value="<%=contentID %>">
<input type="hidden" name="enlID" value="<%=enlID %>"/>
<input type="hidden" name="patientType" value="<%=patientType %>"/>
<input type="hidden" name="contentTitleURL" value="<%=contentTitleURL %>"/>


<%	if (!createAction) { %><input type="hidden" name="Dept" value="<%=Dept %>"><%} %>
</form>
<script language="javascript">
<!--
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
		}
<%	 } %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function callback(msg) {
		document.getElementById("file").outerHTML = document.getElementById("file").outerHTML;
		document.getElementById("msg").innerHTML = "<font color=red>"+msg+"</font>";
	}

	// ajax
	var http = createRequestObject();



-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>