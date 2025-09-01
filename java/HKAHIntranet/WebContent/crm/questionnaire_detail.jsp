<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchAnswers(String questionnaireID, String questionnaireQID) {
		// fetch each question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_QUESTIONAIRE_AID, CRM_ANSWER, TO_CHAR(CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_QUESTIONAIRE_ANSWER ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 AND CRM_QUESTIONAIRE_ID = ? AND CRM_QUESTIONAIRE_QID = ? ");
		sqlStr.append("ORDER BY CRM_QUESTIONAIRE_AID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {questionnaireID, questionnaireQID});
	}
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = request.getParameter("command");
String step = request.getParameter("step");
String questionnaireID = request.getParameter("questionnaireID");
String questionnaireQID = request.getParameter("questionnaireQID");
String questionnaireAID = request.getParameter("questionnaireAID");
String description = request.getParameter("description");
String document = request.getParameter("document");
String question = request.getParameter("question");
String answer = request.getParameter("answer");
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
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT COUNT(1) + 1 ");
			sqlStr.append("FROM   CRM_QUESTIONAIRE_QUESTION ");
			sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CRM_QUESTIONAIRE_ID = ?");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { questionnaireID });
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				questionnaireQID = row.getValue(0);

				// create question
				sqlStr.setLength(0);
				sqlStr.append("INSERT INTO CRM_QUESTIONAIRE_QUESTION (");
				sqlStr.append(" CRM_SITE_CODE, CRM_QUESTIONAIRE_ID, ");
				sqlStr.append(" CRM_QUESTIONAIRE_QID, CRM_QUESTION, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
				sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?)");

				if (UtilDBWeb.updateQueue(
						sqlStr.toString(),
						new String[] {questionnaireID, questionnaireQID, question, loginID, loginID} )) {
					message = "Question created.";
					createAction = false;
				} else {
					errorMessage = "Question create fail.";
				}
			}
		} else if (updateAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_QUESTIONAIRE_QUESTION ");
			sqlStr.append("SET    CRM_QUESTION = ?, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CRM_QUESTIONAIRE_ID = ? AND CRM_QUESTIONAIRE_QID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] {question, loginID, questionnaireID, questionnaireQID} )) {
				message = "Question updated.";
				updateAction = false;
			} else {
				errorMessage = "Question update fail.";
			}
		} else if (deleteAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_QUESTIONAIRE_QUESTION ");
			sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CRM_QUESTIONAIRE_ID = ? AND CRM_QUESTIONAIRE_QID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] {loginID, questionnaireID, questionnaireQID} )) {
				message = "Question deleted.";

				sqlStr.setLength(0);
				sqlStr.append("UPDATE CRM_QUESTIONAIRE_ANSWER ");
				sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
				sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CRM_QUESTIONAIRE_ID = ? AND CRM_QUESTIONAIRE_QID = ?");

				// delete the answer too
				UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {loginID, questionnaireQID, questionnaireQID} );
			} else {
				errorMessage = "Question delete fail.";
			}
		}
		step = "0";

		if (deleteAction && message != null && message.length() > 0) {
%>
<jsp:forward page="questionnaire.jsp">
	<jsp:param name="command" value="view"/>
	<jsp:param name="questionnaireID" value="<%=questionnaireID %>"/>
	<jsp:param name="step" value="0"/>
</jsp:forward>
<%
		}
	} else if ("2".equals(step)) {
		if ((createAction || updateAction) && (answer == null || answer.length() == 0)) {
			errorMessage = MessageResources.getMessage(session, "error.answer.required");
		} else if (createAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("INSERT INTO CRM_QUESTIONAIRE_ANSWER (CRM_SITE_CODE, CRM_QUESTIONAIRE_ID, CRM_QUESTIONAIRE_QID, CRM_QUESTIONAIRE_AID, CRM_ANSWER, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
			sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, (SELECT COUNT(1) + 1 FROM CRM_QUESTIONAIRE_ANSWER WHERE CRM_QUESTIONAIRE_ID = ? AND CRM_QUESTIONAIRE_QID = ?), ?, ?, ?)");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] {questionnaireID, questionnaireQID, questionnaireID, questionnaireQID, answer, loginID, loginID} )) {
				message = "Answer created.";
				createAction = false;
			} else {
				errorMessage = "Answer create fail.";
			}
		} else if (updateAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_QUESTIONAIRE_ANSWER ");
			sqlStr.append("SET    CRM_ANSWER = ?, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CRM_QUESTIONAIRE_ID = ? AND CRM_QUESTIONAIRE_QID = ? AND CRM_QUESTIONAIRE_AID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] {answer, loginID, questionnaireID, questionnaireQID, questionnaireAID} )) {
				message = "Answer updated.";
				updateAction = false;
				questionnaireAID = "";
			} else {
				errorMessage = "Answer update fail.";
			}
		} else if (deleteAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_QUESTIONAIRE_ANSWER ");
			sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CRM_QUESTIONAIRE_ID = ? AND CRM_QUESTIONAIRE_QID = ? AND CRM_QUESTIONAIRE_AID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] {loginID, questionnaireID, questionnaireQID, questionnaireAID} )) {
				message = "Answer deleted.";
				deleteAction = false;
			} else {
				errorMessage = "Answer delete fail.";
			}
		}
		step = "0";
	} else if (createAction) {
		questionnaireQID = "";
		questionnaireAID = "";
		question = "";
		answer = "";
	}

	// load data from database
	if (questionnaireQID != null && questionnaireQID.length() > 0) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT E.CRM_QUESTIONAIRE_DESC, M.CO_DESCRIPTION, Q.CRM_QUESTION, TO_CHAR(E.CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_QUESTIONAIRE_QUESTION Q, CRM_QUESTIONAIRE E, CO_DOCUMENT M ");
		sqlStr.append("WHERE  Q.CRM_QUESTIONAIRE_ID = E.CRM_QUESTIONAIRE_ID ");
		sqlStr.append("AND    E.CRM_DOCUMENT_ID = M.CO_DOCUMENT_ID (+) ");
		sqlStr.append("AND    Q.CRM_QUESTIONAIRE_ID = ? ");
		sqlStr.append("AND    Q.CRM_QUESTIONAIRE_QID = ?");
		sqlStr.append("AND    Q.CRM_ENABLED = 1");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { questionnaireID, questionnaireQID });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			description = row.getValue(0);
			document = row.getValue(1);
			if (question == null) {
				question = row.getValue(2);
			}
			modifieddate = row.getValue(3);
		}
	} else if (questionnaireID != null && questionnaireID.length() > 0) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT E.CRM_QUESTIONAIRE_DESC, M.CO_DESCRIPTION, TO_CHAR(E.CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_QUESTIONAIRE E, CO_DOCUMENT M ");
		sqlStr.append("WHERE  E.CRM_DOCUMENT_ID = M.CO_DOCUMENT_ID (+) ");
		sqlStr.append("AND    E.CRM_QUESTIONAIRE_ID = ? ");
		sqlStr.append("AND    E.CRM_QUESTIONAIRE_QID = ?");
		sqlStr.append("AND    E.CRM_ENABLED = 1");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { questionnaireID, questionnaireQID });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			description = row.getValue(0);
			document = row.getValue(1);
			modifieddate = row.getValue(2);
		}
	} else {
%>
<jsp:forward page="questionnaire.jsp">
	<jsp:param name="command" value="view"/>
	<jsp:param name="questionnaireID" value="<%=questionnaireID %>"/>
	<jsp:param name="step" value="0"/>
</jsp:forward>
<%
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
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="questionnaire_detail.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.description" /></td>
		<td class="infoData" width="70%"><%=description %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.document" /></td>
		<td class="infoData" width="70%"><%=document %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.modifiedDate" /></td>
		<td class="infoData" width="70%"><%=modifieddate %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Question</td>
		<td class="infoData" width="70%">
<%	if ("0".equals(step) && (createAction || updateAction) && questionnaireAID.length() == 0) {%>
			<input type="textfield" name="question" value="<%=question %>" maxlength="200" size="100">
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
<%	if ("0".equals(step) && (createAction || updateAction || deleteAction) && questionnaireAID.length() == 0) { %>
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
	if (questionnaireQID != null && !"".equals(questionnaireQID)) {
%>
<table cellpadding="0" cellspacing="0"
	class="tablesorter" border="0">
	<thead>
	<tr class="smallText">
		<th class="{sorter: false}">&nbsp;</th>
		<th width="50%" align="center">Answer</th>
		<th width="25%" align="center"><bean:message key="prompt.modifiedDate" /></th>
		<th class="{sorter: false}"><bean:message key="prompt.action" /></th>
		<th class="{sorter: false}">&nbsp;</th>
	</tr>
	</thead>
	<tbody>
<%
		try {
			boolean success = false;
			boolean editing = false;
			int rowNumber = 0;

			ArrayList record = fetchAnswers(questionnaireID, questionnaireQID);
			ReportableListObject row = null;
			if (record.size() > 0) {
				rowNumber = record.size();
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%>
	<tr>
		<td align="center"><%=i + 1 %>)</td>
<%					if (questionnaireAID != null && row.getValue(0).equals(questionnaireAID)) {
							editing = true;
%>
		<td align="left"><input type="textfield" name="answer" value="<%=row.getValue(1) %>" maxlength="200" size="50"></td>
		<td align="center"><%=row.getValue(2) %></td>
		<td align="center">&nbsp;</td>
<%					} else {%>
		<td align="left"><%=row.getValue(1) %></td>
		<td align="center"><%=row.getValue(2) %></td>
		<td align="center">
			<button onclick="return submitAction('update',0,'<%=row.getValue(0) %>');"><bean:message key="button.update" /></button>
			<button onclick="return submitAction('delete',2,'<%=row.getValue(0) %>');"><bean:message key="button.delete" /></button>
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
		<td align="center" colspan=7>
			<bean:define id="functionLabel"><bean:message key="function.answer.list" /></bean:define>
			<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
		</td>
	</tr>
<%
			}
			if (!editing) {
				title = "button.save";
				commandType = "create";
				questionnaireAID = "";
%>
	<tr class="sessionCol<%=rowNumber % 2 == 0?"Even":"Odd" %>">
		<td align="center"><%=rowNumber + 1 %>)</td>
		<td align="left"><input type="textfield" name="answer" maxlength="200" size="50"></td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
	</tr>
<%
			}
%>
	</tbody>
</table>
<%
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
%>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="" />
<input type="hidden" name="step" value="" />
<input type="hidden" name="questionnaireID" value="<%=questionnaireID %>">
<input type="hidden" name="questionnaireQID" value="<%=questionnaireQID %>">
<input type="hidden" name="questionnaireAID">
</form>
<script language="javascript">
	function submitAction(cmd, stp, aid) {
		if ((cmd == 'create' || cmd == 'update') && stp == 2 && document.form1.answer.value == '') {
			alert("<bean:message key="error.answer.required" />.");
			document.form1.answer.focus();
			return false;
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.questionnaireAID.value = aid;
		document.form1.submit();
	}
</script>
<a class="button" href="<html:rewrite page="/crm/questionnaire.jsp?command=view&questionnaireID=<%=questionnaireID %>" />" onclick="this.blur();"><span><bean:message key="prompt.backTo" /> <bean:message key="function.questionnaire.view" /></span></a>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>