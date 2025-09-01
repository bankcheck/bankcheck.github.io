<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String staffID = (String) session.getAttribute("staffID");

String command = request.getParameter("command");
String step = request.getParameter("step");
String eventID = request.getParameter("eventID");
String eventDesc = null;
String enrollID = request.getParameter("enrollID");
String attendDate = request.getParameter("attendDate");
String remark = request.getParameter("remark");
if (HttpFileUpload.isMultipartContent(request)){
	Vector uploadMessage = HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);

	command = (String) request.getAttribute("command");
	step = (String) request.getAttribute("step");
	eventID = (String) request.getAttribute("eventID");
	enrollID = (String) request.getAttribute("enrollID");
	attendDate = (String) request.getAttribute("attendDate");
}
if (attendDate == null || attendDate.length() == 0) {
	attendDate = DateTimeUtil.getCurrentDate();
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
			enrollID = EnrollmentDB.add(userBean, "education", eventID, null, "staff", staffID, attendDate, remark);
			if (enrollID != null) {
				message = "staff education created.";
				createAction = false;
				step = "0";
			} else {
				errorMessage = "staff education create fail.";
			}
		} else if (updateAction) {
			if (EnrollmentDB.update(userBean, "education", eventID, null, enrollID, "staff", staffID, attendDate, remark)) {
				message = "staff education updated.";
				updateAction = false;
				step = "0";
			} else {
				errorMessage = "staff education update fail.";
			}
		} else if (deleteAction) {
			if (EnrollmentDB.delete(userBean, "education", eventID, null, enrollID)) {
				message = "staff education removed.";
				closeAction = true;
			} else {
				errorMessage = "staff education remove fail.";
			}
		}
	} else if (createAction) {
		remark = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (eventID != null && eventID.length() > 0
		&& enrollID != null && enrollID.length() > 0) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT E.CO_EVENT_DESC, TO_CHAR(EE.CO_ATTEND_DATE, 'dd/MM/yyyy'), EE.CO_REMARK ");
			sqlStr.append("FROM   CO_ENROLLMENT EE, CO_EVENT E ");
			sqlStr.append("WHERE  EE.CO_SITE_CODE = E.CO_SITE_CODE ");
			sqlStr.append("AND    EE.CO_MODULE_CODE = E.CO_MODULE_CODE ");
			sqlStr.append("AND    EE.CO_EVENT_ID = E.CO_EVENT_ID ");
			sqlStr.append("AND    EE.CO_MODULE_CODE = 'education' ");
			sqlStr.append("AND    EE.CO_EVENT_ID = ? ");
			sqlStr.append("AND    EE.CO_ENROLL_ID = ? ");
			sqlStr.append("AND    EE.CO_USER_TYPE = 'staff' ");
			sqlStr.append("AND    EE.CO_USER_ID = ? ");
			sqlStr.append("AND    EE.CO_ATTEND_STATUS = 1 ");
			sqlStr.append("AND    EE.CO_ENABLED = 1 ");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, enrollID, staffID });
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				eventDesc = row.getValue(0);
				attendDate = row.getValue(1);
				remark = row.getValue(2);
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
	<jsp:forward page="staff_education_list.jsp" />
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
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
	title = "function.staffEducation." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<jsp:include page="staff_brief.jsp" flush="false">
	<jsp:param name="tabId" value="2" />
</jsp:include>
<form name="form1" enctype="multipart/form-data" action="staff_education.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.course" /></td>
		<td class="infoData" width="70%">
<%	if (createAction) {%>
			<select name="eventID">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventID" value="<%=eventID %>" />
	<jsp:param name="eventCategory" value="ce" />
</jsp:include>
			</select>
<%	} else {%>
			<%=eventDesc %>
			<input type="hidden" name="eventID" value="<%=eventID %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.attendDate" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<input type="textfield" name="attendDate" id="attendDate" class="datepickerfield" value="<%=attendDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else {%>
			<%=attendDate %>
			<input type="hidden" name="attendDate" value="<%=attendDate %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.uploadFile" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<input type="file" name="file1" size="50" class="multi" maxlength="5">
<%	} else {%>
<jsp:include page="../helper/viewDocument.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventID" value="<%=eventID %>" />
	<jsp:param name="enrollID" value="<%=enrollID %>" />
</jsp:include>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.remarks" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="remark" value="<%=remark==null?"":remark %>" maxlength="100" size="50">
<%	} else { %>
			<%=remark==null?"":remark %>
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
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.staffEducation.update" /></button>
			<button class="btn-delete"><bean:message key="function.staffEducation.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="enrollID" value="<%=enrollID %>">
<input type="hidden" name="toPDF" value="N">
</form>
<script language="javascript">
<!--
	function submitAction(cmd, stp) {
		document.form1.action= "staff_education.jsp";
		if (document.form1.attendDate.value == "") {
			alert("<bean:message key="error.date.required" />.");
			document.form1.attendDate.focus();
			return false;
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>