<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String category = "title.education";
String command = request.getParameter("command");
String step = request.getParameter("step");
String elearningID = request.getParameter("elearningID");
String elearningQID = request.getParameter("elearningQID");
String elearningAID = request.getParameter("elearningAID");
String topic = request.getParameter("topic");
String questionNumPerTest = request.getParameter("questionNumPerTest");
String passGrade = request.getParameter("passGrade");
String duration = request.getParameter("duration");
String question = request.getParameter("question");
if (question != null) {
	question = new String(question.getBytes("ISO-8859-1"), "UTF-8");
}
String answer = request.getParameter("answer");
if (answer != null) {
	answer = new String(answer.getBytes("ISO-8859-1"), "UTF-8");
}
String correct_answer = request.getParameter("correct_answer");
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
			request,
			ConstantsServerSide.DOCUMENT_FOLDER,
			ConstantsServerSide.TEMP_FOLDER,
			ConstantsServerSide.UPLOAD_FOLDER
		);
	command = (String) request.getAttribute("command");
	step = (String) request.getAttribute("step");
	elearningID = (String) request.getAttribute("elearningID");
	elearningQID = (String) request.getAttribute("elearningQID");
	elearningAID = (String) request.getAttribute("elearningAID");
	topic = (String) request.getAttribute("topic");
	questionNumPerTest = (String) request.getAttribute("questionNumPerTest");
	passGrade = (String) request.getAttribute("passGrade");
	duration = (String) request.getAttribute("duration");
	question = (String) request.getAttribute("question");
	if (question != null) {
		question = new String(question.getBytes("ISO-8859-1"), "UTF-8");
	}
	answer = (String) request.getAttribute("answer");
	if (answer != null) {
		answer = new String(answer.getBytes("ISO-8859-1"), "UTF-8");
	}
	correct_answer = (String) request.getAttribute("correct_answer");
}

String modifieddate = "";
boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
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
		if ((createAction || updateAction) && (question == null || question.length() == 0)) {
			errorMessage = "Invalid question.";
		} else if (createAction) {
			elearningQID = ELearning.addQuestion(userBean, elearningID, question);
			if (elearningQID != null) {
				message = "Question created.";
				createAction = false;
			} else {
				errorMessage = "Question create fail.";
			}
		} else if (updateAction) {
			if (ELearning.updateQuestion(userBean, elearningID, elearningQID, question)) {
				message = "Question updated.";
				updateAction = false;
			} else {
				errorMessage = "Question update fail.";
			}
		} else if (deleteAction) {
			if (ELearning.deleteQuestion(userBean, elearningID, elearningQID)) {
				message = "Question deleted.";
			} else {
				errorMessage = "Question delete fail.";
			}
		}
		step = "0";

		if (deleteAction && message != null && message.length() > 0) {
%>
<jsp:forward page="elearning.jsp">
	<jsp:param name="command" value="view"/>
	<jsp:param name="elearningID" value="<%=elearningID %>"/>
	<jsp:param name="step" value="0"/>
</jsp:forward>
<%
		}
	} else if ("2".equals(step)) {
		if ((createAction || updateAction) && (answer == null || answer.length() == 0)) {
			errorMessage = MessageResources.getMessage(session, "error.answer.required");
		} else if (createAction) {
			elearningAID = ELearning.addAnswer(userBean, elearningID, elearningQID, answer, correct_answer);
			if (elearningAID != null) {
				message = "Answer created.";
				createAction = false;
			} else {
				errorMessage = "Answer create fail.";
			}
		} else if (updateAction) {
			if (ELearning.updateAnswer(userBean, elearningID, elearningQID, elearningAID, answer, correct_answer)) {
				message = "Answer updated.";
				updateAction = false;
				elearningAID = "";
			} else {
				errorMessage = "Answer update fail.";
			}
		} else if (deleteAction) {
			if (ELearning.deleteAnswer(userBean, elearningID, elearningQID, elearningAID)) {
				message = "Answer deleted.";
				deleteAction = false;
				elearningAID = null;
			} else {
				errorMessage = "Answer delete fail.";
			}
		}
		step = "0";
	} else if (createAction) {
		elearningQID = "";
		elearningAID = "";
		question = "";
		answer = "";
		correct_answer = "";
	}

	// load data from database
	if (elearningQID != null && elearningQID.length() > 0) {
		ArrayList record = ELearning.getQuestion(elearningID, elearningQID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			topic = row.getValue(0);
			questionNumPerTest = row.getValue(1);
			passGrade = row.getValue(2);
			duration = row.getValue(3);
			if (question == null) {
				question = row.getValue(4);
			}
			modifieddate = row.getValue(5);
		}
	} else if (createAction && elearningID != null && elearningID.length() > 0) {
		ArrayList record = ELearning.get(elearningID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			topic = row.getValue(1);
			questionNumPerTest = row.getValue(2);
			passGrade = row.getValue(3);
			duration = row.getValue(5);
			question = "";
			modifieddate = row.getValue(8);
		}
	} else {
%>
<jsp:forward page="elearning.jsp">
	<jsp:param name="command" value="view"/>
	<jsp:param name="elearningID" value="<%=elearningID %>"/>
	<jsp:param name="step" value="0"/>
</jsp:forward>
<%
	}
} catch (Exception e) {
	e.printStackTrace();
}

boolean isEditQuestion = "0".equals(step) && (createAction || updateAction || deleteAction) && elearningAID.length() == 0;
boolean isEditAnswer = elearningAID != null && elearningAID.length() > 0;
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
	title = "function.question." + commandType;
	String flowStep = isEditQuestion ? "2": "3";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr valign="center">
		<td class="step<%=flowStep %>_1"><p><bean:message key="prompt.topic" /></p></td>
		<td class="step<%=flowStep %>_2"><p><bean:message key="prompt.question" /></p></td>
		<td class="step<%=flowStep %>_3"><p><bean:message key="prompt.answer" /></p></td>
	</tr>
</table>
<bean:define id="functionLabel"><bean:message key="function.answer.list" /></bean:define>
<form name="form1" action="elearning_detail.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.topic" /></td>
		<td class="infoData" width="70%"><%=topic %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key='<%=ConstantsServerSide.isTWAH() ? "prompt.document.twah" : "prompt.document" %>' /></td>
		<td class="infoData" width="70%">
<jsp:include page="../helper/viewDocument.jsp" flush="false">
	<jsp:param name="elearningID" value="<%=elearningID %>" />
</jsp:include>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key='<%=ConstantsServerSide.isTWAH() ? "prompt.noOfQuestion.twah" : "prompt.noOfQuestion" %>' /></td>
		<td class="infoData" width="70%"><%=questionNumPerTest %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.passGrade" /></td>
		<td class="infoData" width="70%"><%=passGrade %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.readDocumentDuration" /></td>
		<td class="infoData" width="70%"><%=duration %> <bean:message key="label.seconds" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.modifiedDate" /></td>
		<td class="infoData" width="70%"><%=modifieddate %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.question" /></td>
		<td class="infoData" width="70%">
<%	if ("0".equals(step) && (createAction || updateAction) && elearningAID.length() == 0) {%>
			<div class="box"><textarea id="wysiwyg" name="question" rows="11" cols="69"><%=question %></textarea></div>
<%	} else {%>
			<%=question %>
<%	} %>
		</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (isEditQuestion) { %>
			<button onclick="return submitAction('<%=commandType %>', 1, '');" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0, '');" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else {%>
			<button onclick="return submitAction('update', 0, '');" class="btn-click"><bean:message key="function.question.update" /></button>
			<button class="btn-delete"><bean:message key="function.question.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<%
	if (elearningQID != null && !"".equals(elearningQID)) {
%>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<th class="{sorter: false}">&nbsp;</th>
		<th width="35%" align="center"><bean:message key="prompt.answer" /></th>
		<th width="15%" align="center"><bean:message key="prompt.correctAnswer" /></th>
		<th width="15%" align="center"><bean:message key="prompt.modifiedDate" /></th>
		<th class="{sorter: false}"><bean:message key="prompt.action" /></th>
		<th class="{sorter: false}">&nbsp;</th>
	</tr>
<%
		try {
			boolean success = false;
			ArrayList record = ELearning.getAnswers(elearningID, elearningQID);
			ReportableListObject row = null;
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%>
	<tr>
<%					if (elearningAID != null && row.getValue(0).equals(elearningAID)) {
						String correct_answer_yes = null;
						String correct_answer_no = null;
						if ("1".equals(row.getValue(2))) {
							correct_answer_yes = " checked";
							correct_answer_no = "";
						} else {
							correct_answer_yes = "";
							correct_answer_no = " checked";
						}
%>
		<td align="center"><%=i + 1 %>)</td>
		<td align="left"><div class="box"><textarea id="wysiwyg" name="answer" rows="11" cols="69"><%=row.getValue(1) %></textarea></div></td>
		<td align="center">
			<img src="../images/tick_green_small.gif"><input type="radio" name="correct_answer" value="1"<%=correct_answer_yes %>>
			<img src="../images/cross_red_small.gif"><input type="radio" name="correct_answer" value="0"<%=correct_answer_no %>></td>
		<td align="center"><%=row.getValue(3) %></td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
<%					} else {%>
		<td align="center"><%=i + 1 %>)</td>
		<td align="left"><%=row.getValue(1) %></td>
		<td align="center"><%=("1".equals(row.getValue(2))?"<img src=\"../images/tick_green_small.gif\">":"<img src=\"../images/cross_red_small.gif\">") %></td>
		<td align="center"><%=row.getValue(3) %></td>
		<td align="center">
<%						if (!isEditQuestion && !isEditAnswer) { %>
			<button onclick="return submitAction('update',0,'<%=row.getValue(0) %>');"><bean:message key="button.update" /></button>
			<button onclick="return submitAction('delete',2,'<%=row.getValue(0) %>');"><bean:message key="button.delete" /></button>
<%						} %>
		</td>
		<td align="center"></td>
<%					}%>
	</tr>
<%
				}
				success = true;
			}

			if (!success) {
%>
	<tr class="smallText">
		<td align="center" colspan="6">
			<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
		</td>
	</tr>
<%
			}
			if (!isEditQuestion && !isEditAnswer) {
				commandType = "create";
				elearningAID = "";
%>
	<tr class="sessionColEven">
		<td align="center">&nbsp;</td>
		<td align="left"><div class="box"><textarea id="wysiwyg" name="answer" rows="11" cols="69"></textarea></div></td>
		<td align="center">
			<img src="../images/tick_green_small.gif"><input type="radio" name="correct_answer" value="1">
			<img src="../images/cross_red_small.gif"><input type="radio" name="correct_answer" value="0" checked></td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
	</tr>
<%
			}
%>
</table>
<%		if (!isEditQuestion) { %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center" colspan="6">
<%			if (!isEditAnswer) { %>
			<button onclick="return submitAction('<%=commandType %>', 2, '<%=elearningAID %>');" class="btn-click"><bean:message key="button.save" /> <bean:message key="function.answer.create" /></button>
			<button onclick="return submitAction('view', 0, '');" class="btn-click"><bean:message key="button.cancel" /> <bean:message key="function.answer.update" /></button>
<%			} else { %>
			<button onclick="return submitAction('<%=commandType %>', 2, '<%=elearningAID %>');" class="btn-click"><bean:message key="button.save" /> <bean:message key="function.answer.update" /></button>
			<button onclick="return submitAction('view', 0, '');" class="btn-click"><bean:message key="button.cancel" /> <bean:message key="function.answer.update" /></button>
<%			} %>
		</td>
	</tr>
</table>
<%
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
%>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="elearningID" value="<%=elearningID %>">
<input type="hidden" name="elearningQID" value="<%=elearningQID %>">
<input type="hidden" name="elearningAID">
</form>
<script language="javascript">
	function submitAction(cmd, stp, aid) {
		if (cmd == 'create' || cmd == 'update') {
			if (stp == 2 && document.form1.answer.value == '') {
				alert("<bean:message key="error.answer.required" />.");
				document.form1.answer.focus();
				return false;
			}
		}
		document.form1.action = "elearning_detail.jsp";
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.elearningAID.value = aid;
		document.form1.submit();
	}
</script>
<br>
<a class="button" href="../education/elearning.jsp?command=view&elearningID=<%=elearningID %>" onclick="this.blur();"><span><bean:message key="prompt.backTo" /> <bean:message key="prompt.eLesson" /></span></a>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>