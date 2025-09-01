<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();

String category = "title.education";
String command = request.getParameter("command");
String step = request.getParameter("step");
String courseID = request.getParameter("courseID");
String deptCode = request.getParameter("deptCode");
String deptDescription = null;
String description = TextUtil.parseStrUTF8(request.getParameter("description"));
String detail = TextUtil.parseStrUTF8(request.getParameter("detail"));
String courseCategory = request.getParameter("courseCategory");
String requireAssessmentPass = ConstantsVariable.YES_VALUE.equals(request.getParameter("isRequireAssessmentPass")) ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
String nonHospCourse = ConstantsVariable.YES_VALUE.equals(request.getParameter("nonHospCourse")) ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
// set default value
if (courseCategory == null) {
	courseCategory = "compulsory";
}

String material = request.getParameter("material");

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
			courseID = EventDB.add(userBean, "education", deptCode, courseCategory, "class", null, description, detail, ConstantsVariable.YES_VALUE.equals(requireAssessmentPass), ConstantsVariable.YES_VALUE.equals(nonHospCourse));
			if (courseID != null) {
				message = MessageResources.getMessage(session, "message.course.createSuccess");
				createAction = false;
			} else {
				errorMessage = MessageResources.getMessage(session, "error.course.createFail");
			}
		} else if (updateAction) {
			if (EventDB.update(userBean, "education", courseID, deptCode, courseCategory, "class", description, detail, ConstantsVariable.YES_VALUE.equals(requireAssessmentPass), ConstantsVariable.YES_VALUE.equals(nonHospCourse))) {
				message = MessageResources.getMessage(session, "message.course.updateSuccess");
				updateAction = false;
			} else {
				errorMessage = MessageResources.getMessage(session, "error.course.updateFail");
			}
		} else if (deleteAction) {
			if (EventDB.delete(userBean, "education", courseID,  deptCode)) {
				message = MessageResources.getMessage(session, "message.course.deleteSuccess");
				closeAction = true;
			} else {
				errorMessage = MessageResources.getMessage(session, "error.course.deleteFail");
			}
		}
	} else if (createAction) {
		courseID = "";
		description = "";
		detail = "";
		deptCode = "";
		deptDescription = "";
		courseCategory = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (courseID != null && courseID.length() > 0) {
			ArrayList result = EventDB.get("education", courseID, null, "class");
			if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				courseID = reportableListObject.getValue(0);
				description = reportableListObject.getValue(1);
				courseCategory = reportableListObject.getValue(2);
				detail = reportableListObject.getValue(5);
				deptCode = reportableListObject.getValue(6);
				deptDescription = reportableListObject.getValue(7);
				requireAssessmentPass = reportableListObject.getValue(8);
				nonHospCourse = reportableListObject.getValue(10);
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

boolean isCompulsory = "compulsory".equals(courseCategory);
boolean isInservice = "inservice".equals(courseCategory);
boolean isOptional = "other".equals(courseCategory);
boolean isCNE = "CNE".equals(courseCategory);
boolean isFireDrill = "firedrill".equals(courseCategory);
boolean isTND = "tND".equals(courseCategory);
boolean isIntClass = "intClass".equals(courseCategory);
boolean isMockCode = "mockCode".equals(courseCategory);
boolean isMockDrill = "mockDrill".equals(courseCategory);

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
	title = "function.course." + commandType;
	try {
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" action="course.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.courseDescription"/></td>
<%		if (createAction || updateAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="description" value="<%=description %>" maxlength="500" size="50"></td>
<%		} else {%>
		<td class="infoData" width="70%"><%=description %></td>
<%		} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.remarks"/></td>
<%		if (createAction || updateAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="detail" value="<%=detail %>" maxlength="100" size="50"></td>
<%		} else {%>
		<td class="infoData" width="70%"><%=detail %></td>
<%		} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.courseCategory" /></td>
<%			if (createAction || updateAction) {%>
		<td class="infoData" width="70%">
			<input type="radio" name="courseCategory" value="compulsory"<%=isCompulsory?" checked":"" %>><bean:message key="label.compulsory" />
			<input type="radio" name="courseCategory" value="inservice"<%=isInservice?" checked":"" %>><bean:message key="label.inservice" />
			<!-- <input type="radio" name="courseCategory" value="other"<%=isOptional?" checked":"" %>><bean:message key="label.optional" />-->
			<input type="radio" name="courseCategory" value="CNE"<%=isCNE?" checked":"" %>>CNE
<%				if(ConstantsServerSide.isTWAH()){ %>				
				<input type="radio" name="courseCategory" value="firedrill"<%=isFireDrill?" checked":"" %>>Fire and Disaster Drills
<%			} %>					
				<input type="radio" name="courseCategory" value="tND"<%=isTND?" checked":"" %>>T&D
<%			if(ConstantsServerSide.isHKAH()){ %>
				<input type="radio" name="courseCategory" value="intClass"<%=isIntClass?" checked":"" %>>Interest Class / Other Activities
				<input type="radio" name="courseCategory" value="mockCode"<%=isMockCode?" checked":"" %>>Mock Code
				<input type="radio" name="courseCategory" value="mockDrill"<%=isMockDrill?" checked":"" %>>Drill
<%			} %>
		</td>
<%		} else {%>
		<td class="infoData" width="70%"><%if (isCompulsory) { %><bean:message key="label.compulsory" /><%} else if (isInservice) { %><bean:message key="label.inservice" /><%} else if (isCNE) { %>CNE<%} else if (isFireDrill) { %>Fire and Disaster Drills<%} else if (isTND) { %>T&D<%} else if (isIntClass) { %>Interest Class / Other Activities<%} else if (isMockCode) { %>Mock Code<%} else if (isMockDrill){ %>Drill<%} else { %><bean:message key="label.optional" /><%} %></td>
<%		} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="promot.requireTestPass" /></td>
<%		if (createAction || updateAction) {%>
		<td class="infoData" width="70%"><input type="checkbox" name="isRequireAssessmentPass" value="Y"<%=ConstantsVariable.YES_VALUE.equals(requireAssessmentPass) ? " checked=\"checked\"" : "" %>>
<%		} else {%>
		<td class="infoData" width="70%"><%if (ConstantsVariable.YES_VALUE.equals(requireAssessmentPass)) { %><bean:message key="label.yes" /><% } else { %><bean:message key="label.no" /><% } %>
<%		} %>
			<div class="italic"><bean:message key="promot.requireTestPass.remark" /></div>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Non-hospital course</br>(Enrollment by education administrator)</td>
<%		if (createAction || updateAction) {%>
		<td class="infoData" width="70%"><input type="checkbox" name="nonHospCourse" value="Y"<%=ConstantsVariable.YES_VALUE.equals(nonHospCourse) ? " checked=\"checked\"" : "" %>>
<%		} else {%>
		<td class="infoData" width="70%"><%if (ConstantsVariable.YES_VALUE.equals(nonHospCourse)) { %><bean:message key="label.yes" /><% } else { %><bean:message key="label.no" /><% } %>
<%		} %>
			<div class="italic">(If enabled, classes belonging to this course will not show under Monthly Calendar)</div>
		</td>
	</tr>
</table>
<%
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%		if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.course.update" /></button>
			<button class="btn-delete"><bean:message key="function.course.delete" /></button>
<%		}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="courseID" value="<%=courseID %>">
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.description.value == '') {
				alert("<bean:message key="error.courseDescription.required" />.");
				document.form1.description.focus();
				return false;
			}
		}
<%	} %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>