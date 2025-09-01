<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.upload.*" %>
<%@ page import="com.hkah.web.common.*" %>
<%@ page import="com.hkah.web.db.*" %>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String step = request.getParameter("step");

String doctorID = request.getParameter("doctorID");
String lastName = TextUtil.parseStrUTF8(request.getParameter("lastName"));
String firstName = TextUtil.parseStrUTF8(request.getParameter("firstName"));
String chineseName = TextUtil.parseStrUTF8(request.getParameter("chineseName"));
String homePhone = request.getParameter("homePhone");
String mobilePhone = request.getParameter("mobilePhone");
String specialtyCode = request.getParameter("specialtyCode");
String specialtyCodeLabel = null;
String specialtyDesc = request.getParameter("specialtyDesc");
String document = TextUtil.parseStrUTF8(request.getParameter("document"));
String credential = TextUtil.parseStrUTF8(request.getParameter("credential"));
String interest = TextUtil.parseStrUTF8(request.getParameter("interest"));

if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	command = (String) request.getAttribute("command");
	step = (String) request.getAttribute("step");

	doctorID = (String) request.getAttribute("doctorID");
	lastName = TextUtil.parseStrUTF8((String) request.getAttribute("lastName"));
	firstName = TextUtil.parseStrUTF8((String) request.getAttribute("firstName"));
	chineseName = TextUtil.parseStrUTF8((String) request.getAttribute("chineseName"));
	homePhone = (String) request.getAttribute("homePhone");
	mobilePhone = (String) request.getAttribute("mobilePhone");
	specialtyCode = (String) request.getAttribute("specialtyCode");
	specialtyDesc = TextUtil.parseStrUTF8((String) request.getAttribute("specialtyDesc"));
	document = TextUtil.parseStrUTF8((String) request.getAttribute("document"));
	credential = TextUtil.parseStrUTF8((String) request.getAttribute("credential"));
	interest = TextUtil.parseStrUTF8((String) request.getAttribute("interest"));

	// create new record
	if ("create".equals(command) && "1".equals(step)) {
		// get project id with dummy data
		doctorID = DoctorDB.add(userBean);
	}

	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("Doctor");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(doctorID);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append("/upload/Doctor/");
		tempStrBuffer.append(doctorID);
		tempStrBuffer.append("/");
		String webFileBaseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(document);

		String physicalFileUrl = null;
		String webFileUrl = null;
		for (int i = 0; i < fileList.length; i++) {
			physicalFileUrl = baseUrl + fileList[i];
			webFileUrl = webFileBaseUrl + fileList[i];
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				physicalFileUrl
			);
			tempStrBuffer.append("<a href=\"");
			tempStrBuffer.append(webFileUrl);
			tempStrBuffer.append("\">");
			tempStrBuffer.append(fileList[i]);
			tempStrBuffer.append("</a><BR>");
		}
		document = tempStrBuffer.toString();
	}
}

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction) {
			// get project id with dummy data
			doctorID = DoctorDB.add(userBean);

			if (DoctorDB.update(userBean, doctorID,
					lastName, firstName, chineseName,
					homePhone, mobilePhone,
					specialtyCode, specialtyDesc, document, credential, interest)) {
				message = "doctor created.";
				createAction = false;
				step = "0";
			} else {
				errorMessage = "doctor create fail.";
			}
		} else if (updateAction) {
			if (DoctorDB.update(userBean, doctorID,
					lastName, firstName, chineseName,
					homePhone, mobilePhone,
					specialtyCode, specialtyDesc, document, credential, interest)) {
				message = "doctor updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "doctor update fail.";
			}
		} else if (deleteAction) {
			if (DoctorDB.delete(userBean, doctorID)) {
				message = "doctor removed.";
				closeAction = true;
			} else {
				errorMessage = "doctor remove fail.";
			}
		}
	} else if (createAction) {
		doctorID = "";
		specialtyCode = "ob";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (doctorID != null && doctorID.length() > 0) {
			ArrayList record = DoctorDB.get(doctorID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				lastName = row.getValue(0);
				firstName = row.getValue(1);
				chineseName = row.getValue(2);
				homePhone = row.getValue(3);
				mobilePhone = row.getValue(4);
				specialtyCode = row.getValue(5);
				specialtyDesc = row.getValue(6);
				document = row.getValue(7);
				credential = row.getValue(8);
				interest = row.getValue(9);
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

specialtyCodeLabel = "label." + specialtyCode;
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
	title = "function.doctor." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" id="form1" <%if (createAction || updateAction) { %>enctype="multipart/form-data" <%} %>action="apply.jsp" method="post">
<bean:define id="lastNameLabel"><bean:message key="prompt.lastName" /></bean:define>
<bean:define id="firstNameLabel"><bean:message key="prompt.firstName" /></bean:define>
<bean:define id="chineseNameLabel"><bean:message key="prompt.chineseName" /></bean:define>
<bean:define id="dateOfBirthLabel"><bean:message key="prompt.dateOfBirth" /></bean:define>
<bean:define id="homePhoneLabel"><bean:message key="prompt.homePhone" /></bean:define>
<bean:define id="mobilePhoneLabel"><bean:message key="prompt.mobilePhone" /></bean:define>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="30%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="lastName" value="<%=lastName==null?"":lastName %>" maxlength="50" size="25">
<%	} else { %>
			<%=lastName==null?"":lastName %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="30%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="firstName" value="<%=firstName==null?"":firstName %>" maxlength="50" size="25">
<%	} else { %>
			<%=firstName==null?"":firstName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData" width="30%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="chineseName" value="<%=chineseName==null?"":chineseName %>" maxlength="30" size="25">
<%	} else { %>
			<%=chineseName==null?"":chineseName %>
<%	} %>
		</td>
		<td class="infoData" colspan="2">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.homePhone" /></td>
		<td class="infoData" width="30%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="homePhone" value="<%=homePhone==null?"":homePhone %>" maxlength="50" size="25">
<%	} else { %>
			<%=homePhone==null?"":homePhone %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.mobilePhone" /></td>
		<td class="infoData" width="30%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="mobilePhone" value="<%=mobilePhone==null?"":mobilePhone %>" maxlength="50" size="25">
<%	} else { %>
			<%=mobilePhone==null?"":mobilePhone %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.specialty" /></td>
		<td class="infoData" colspan="3">
<%	if (createAction || updateAction) { %>
			<select name="specialtyCode">
<jsp:include page="../ui/specialtyCMB.jsp" flush="false">
	<jsp:param name="specialtyCode" value="<%=specialtyCode %>" />
</jsp:include>
		</select>
<%	} else {
		if (specialtyCode != null && specialtyCode.length() > 0) {
			%><bean:message key="<%=specialtyCodeLabel %>" /><%
		} else {
			%>N/A<%
		}
	}
%>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.document" /></td>
		<td class="infoData" colspan="3">
<%		if (createAction || updateAction) { %>
			<input type="file" name="file1" size="50" class="multi" maxlength="10">
<%		} else { %>
			<%=document==null?"":document %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Credential section</td>
		<td class="infoData" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="credential" value="<%=credential==null?"":credential %>" maxlength="50" size="25">
<%	} else { %>
			<%=credential==null?"":credential %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Areas of Interest / Strength</td>
		<td class="infoData" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="interest" value="<%=interest==null?"":interest %>" maxlength="100" size="100">
<%	} else { %>
			<%=interest==null?"":interest %>
<%	} %>
		</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.doctor.update" /></button>
			<button class="btn-delete"><bean:message key="function.doctor.delete" /></button>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="<%=commandType %>" />
<input type="hidden" name="step" />
<input type="hidden" name="doctorID" value="<%=doctorID %>" />
</form>
<script language="javascript">
<!--//
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.lastName.value == '') {
				alert('<bean:message key="errors.required" arg0="<%=lastNameLabel %>" />.');
				document.form1.lastName.focus();
				return false;
			}
			if (document.form1.firstName.value == '') {
				alert('<bean:message key="errors.required" arg0="<%=firstNameLabel %>" />.');
				document.form1.firstName.focus();
				return false;
			}
			if (document.form1.chineseName.value == '') {
				alert('<bean:message key="errors.required" arg0="<%=chineseNameLabel %>" />.');
				document.form1.chineseName.focus();
				return false;
			}
			if (document.form1.homePhone.value == '') {
				alert('<bean:message key="errors.required" arg0="<%=homePhoneLabel %>" />.');
				document.form1.homePhone.focus();
				return false;
			}
			if (document.form1.mobilePhone.value == '') {
				alert('<bean:message key="errors.required" arg0="<%=mobilePhoneLabel %>" />.');
				document.form1.mobilePhone.focus();
				return false;
			}
		}
<%	 } %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
//-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>