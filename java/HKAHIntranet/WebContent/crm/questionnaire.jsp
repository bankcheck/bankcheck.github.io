<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchQuestion(String questionnaireID) {
		// fetch each question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_QUESTIONAIRE_QID, CRM_QUESTION, TO_CHAR(CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_QUESTIONAIRE_QUESTION ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 AND CRM_QUESTIONAIRE_ID = ?");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { questionnaireID });
	}

	private ArrayList fetchAnswers(String questionnaireID, String questionnaireQID) {
		// fetch each answer
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_ANSWER ");
		sqlStr.append("FROM   CRM_QUESTIONAIRE_ANSWER ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_QUESTIONAIRE_ID = ? ");
		sqlStr.append("AND    CRM_QUESTIONAIRE_QID = ? ");
		sqlStr.append("ORDER BY CRM_QUESTIONAIRE_AID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { questionnaireID, questionnaireQID });
	}
%>
<%
String alpha[] = new String[] {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j"};

UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = request.getParameter("command");
String step = request.getParameter("step");
String questionnaireID = request.getParameter("questionnaireID");
String topic = request.getParameter("topic");
String documentID = request.getParameter("documentID");

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

if (!userBean.isAdmin() && !userBean.isAuthor()) {
%>
<jsp:forward page="questionnaire_list.jsp"/>
<%
}

try {
	if ("1".equals(step)) {
		if ((createAction || updateAction) && (topic == null || topic.length() == 0)) {
			errorMessage = MessageResources.getMessage(session, "error.topic.required");
			step = "0";
		} else if (createAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("INSERT INTO CRM_QUESTIONAIRE (");
			sqlStr.append(" CRM_SITE_CODE, CRM_QUESTIONAIRE_ID, CRM_QUESTIONAIRE_DESC, CRM_DOCUMENT_ID, ");
			sqlStr.append(" CRM_CREATED_USER, CRM_MODIFIED_USER) ");
			sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', (SELECT COUNT(1) + 1 FROM CRM_QUESTIONAIRE), ?, ?, ?, ?, ?, ?, ?)");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] {topic, documentID, loginID, loginID} )) {
				message = "Question created.";
				createAction = false;
			} else {
				errorMessage = "Question create fail.";
			}
		} else if (updateAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_QUESTIONAIRE ");
			sqlStr.append("SET    CRM_QUESTIONAIRE_DESC = ?, CRM_DOCUMENT_ID = ?, ");
			sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CRM_QUESTIONAIRE_ID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] {topic, documentID, loginID, questionnaireID} )) {
				message = "Question modified.";
				updateAction = false;
			} else {
				errorMessage = "Question modify fail.";
			}
		} else if (deleteAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_QUESTIONAIRE SET CRM_ENABLED = 0, ");
			sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CRM_QUESTIONAIRE_ID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { loginID, questionnaireID } )) {
				message = "Question deleted.";
				closeAction = true;
			} else {
				errorMessage = "Question delete fail.";
			}
		}
	} else if (createAction) {
		questionnaireID = "";
		topic = "";
		documentID = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (questionnaireID != null && questionnaireID.length() > 0) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT CRM_QUESTIONAIRE_DESC, CRM_DOCUMENT_ID ");
			sqlStr.append("FROM   CRM_QUESTIONAIRE ");
			sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CRM_ENABLED = 1 AND CRM_QUESTIONAIRE_ID = ?");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { questionnaireID });
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				topic = row.getValue(0);
				documentID = row.getValue(1);
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
	title = "function.questionnaire." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="questionnaire.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.topic" /></td>
<%	if (createAction || updateAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="topic" value="<%=topic %>" maxlength="100" size="50"></td>
<%	} else {%>
		<td class="infoData" width="70%"><%=topic %></td>
<%	} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.document" /></td>
		<td class="infoData" width="70%"><%
		if (createAction || updateAction) {
			%><select name="documentID">
<jsp:include page="../ui/documentIDCMB.jsp" flush="false">
	<jsp:param name="documentID" value="<%=documentID %>" />
</jsp:include>
			</select><%
		} else {
			%><%=documentID %><%
		} %></td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else {%>
			<button onclick="return submitAction('update', 0, '');" class="btn-click"><bean:message key="function.questionnaire.update" /></button>
			<button onclick="return submitAction('delete', 1, '');" class="btn-click"><bean:message key="function.questionnaire.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<br>
<%
	if (!createAction && !updateAction) {
%>
<table cellpadding="0" cellspacing="0"
	class="generaltable" border="0">
	<tr class="smallText">
		<th class="{sorter: false}">&nbsp;</th>
		<th width="60%" align="center"><bean:message key="prompt.question" /></th>
		<th width="15%" align="center"><bean:message key="prompt.modifiedDate" /></th>
		<th class="{sorter: false}"><bean:message key="prompt.action" /></th>
		<th class="{sorter: false}">&nbsp;</th>
	</tr>
<%
		boolean success = false;
		try {
			ArrayList record = fetchQuestion(questionnaireID);
			ArrayList record2 = null;
			ReportableListObject row = null;
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%>
	<tr class="sessionColEven">
		<td align="center">Q<%=i + 1 %>)</td>
		<td align="left"><%=row.getValue(1) %></td>
		<td align="center"><%=row.getValue(2) %></td>
		<td align="center">
			<button onclick="return submitAction('view.detail',0,'<%=row.getValue(0) %>');"><bean:message key="button.view" /></button>
		</td>
		<td align="right">&nbsp;</td>
	</tr>
<%
					record2 = fetchAnswers(questionnaireID, row.getValue(0));
					if (record2.size() > 0) {
						for (int j = 0; j < record2.size(); j++) {
							row = (ReportableListObject) record2.get(j);
%>
	<tr class="sessionColOdd">
		<td align="center"><%=alpha[j] %>)</td>
		<td align="left" colspan="3"><%=row.getValue(0) %></td>
		<td align="right">&nbsp;</td>
	</tr>
<%
						}
					}
				}
				success = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (!success) {
%>
	<tr class="smallText">
		<td align="center" colspan="5">
			<bean:define id="functionLabel"><bean:message key="function.question.list" /></bean:define>
			<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
		</td>
	</tr>
<%
		}
%>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create.detail',0,'');"><bean:message key="function.question.create" /></button></td>
	</tr>
</table>
<%	}%>
<input type="hidden" name="command" value="" />
<input type="hidden" name="step" value="" />
<input type="hidden" name="questionnaireID" value="<%=questionnaireID%>">
<input type="hidden" name="questionnaireQID">
</form>
<script language="javascript">
	function submitAction(cmd, stp, qid) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.topic.value == '') {
				alert("<bean:message key="error.topic.required" />.");
				document.form1.topic.focus();
				return false;
			}
		}
<%	} %>
		if (cmd == 'create.detail') {
			document.form1.action = "questionnaire_detail.jsp";
			document.form1.command.value = 'create';
		} else if (cmd == 'view.detail') {
			document.form1.action = "questionnaire_detail.jsp";
			document.form1.command.value = 'view';
		} else {
			document.form1.command.value = cmd;
		}
		document.form1.step.value = stp;
		document.form1.questionnaireQID.value = qid;
		document.form1.submit();
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>