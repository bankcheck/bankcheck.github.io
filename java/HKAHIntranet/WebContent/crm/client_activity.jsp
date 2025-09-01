<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchQuestionaire(String questionnaireID) {
		// fetch questionnaire
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_QUESTIONAIRE_QID, CRM_QUESTION ");
		sqlStr.append("FROM   CRM_QUESTIONAIRE_QUESTION ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_QUESTIONAIRE_ID = ? ");
		sqlStr.append("ORDER BY CRM_QUESTIONAIRE_QID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { questionnaireID });
	}
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = request.getParameter("command");
String step = request.getParameter("step");
String activityID = request.getParameter("activityID");
String siteCode = request.getParameter("siteCode");
String activityDesc = request.getParameter("activityDesc");
String activityDate = null;
String activityDate_dd = request.getParameter("activityDate_dd");
String activityDate_mm = request.getParameter("activityDate_mm");
String activityDate_yy = request.getParameter("activityDate_yy");
if (activityDate_dd != null && activityDate_mm != null && activityDate_yy != null) {
	activityDate = activityDate_dd + "/" + activityDate_mm + "/" + activityDate_yy;
}
String eventID = request.getParameter("eventID");
String eventDesc = null;
String activityNote = request.getParameter("activityNote");
String attachment = request.getParameter("attachment");
String questionnaireID = request.getParameter("questionnaireID");
String questionnaireDesc = null;

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
		if (createAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("INSERT INTO CRM_CLIENTS_ACTIVITIES ");
			sqlStr.append("(CRM_ACTIVITY_ID, CRM_SITE_CODE, CRM_ACTIVITY_DESC, CRM_EVENT_ID, CRM_NOTE, CRM_ATTACHMENT, CRM_QUESTIONAIRE_ID, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
			sqlStr.append("VALUES ");
			sqlStr.append("((SELECT COUNT(1) + 1 FROM CRM_CLIENTS_ACTIVITIES), ?, ?, ?, ?, ?, ?, ?, ?)");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { siteCode, activityDesc, eventID, activityNote, attachment, questionnaireID, loginID, loginID} )) {
				message = "Activity created.";
			} else {
				errorMessage = "Activity create fail.";
			}
		} else if (updateAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_CLIENTS_ACTIVITIES ");
			sqlStr.append("SET    CRM_SITE_CODE = ?, CRM_ACTIVITY_DESC = ?, ");
			sqlStr.append("       CRM_EVENT_ID = ?, CRM_NOTE = ?, CRM_ATTACHMENT = ?, CRM_QUESTIONAIRE_ID = ?, ");
			sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_ACTIVITY_ID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { siteCode, activityDesc, eventID, activityNote, attachment, questionnaireID, loginID, activityID } )) {
				message = "Activity updated.";
			} else {
				errorMessage = "Activity update fail.";
			}
		} else if (deleteAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_CLIENTS_ACTIVITIES ");
			sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_ACTIVITY_ID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { loginID, activityID } )) {
				message = "Activity removed.";
			} else {
				errorMessage = "Activity remove fail.";
			}
		}

		// forward to list page
		if (errorMessage == null || errorMessage.length() == 0) {
%>
<jsp:forward page="activity_list.jsp">
	<jsp:param name="message" value="<%=message %>"/>
</jsp:forward>
<%
		}
	} else if (createAction) {
		siteCode = ConstantsServerSide.SITE_CODE;
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (activityID != null && activityID.length() > 0) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT A.CRM_SITE_CODE, A.CRM_ACTIVITY_DESC, TO_CHAR(A.CRM_ACTIVITY_DATE, 'dd/MM/YYYY'), ");
			sqlStr.append("       A.CRM_EVENT_ID, E.CRM_EVENT_DESC, ");
			sqlStr.append("       A.CRM_NOTE, A.CRM_ATTACHMENT, ");
			sqlStr.append("       A.CRM_QUESTIONAIRE_ID, Q.CRM_QUESTIONAIRE_DESC ");
			sqlStr.append("FROM   CRM_CLIENTS_ACTIVITIES A, CRM_EVENTS E, CRM_QUESTIONAIRE Q ");
			sqlStr.append("WHERE  A.CRM_EVENT_ID = E.CRM_EVENT_ID (+) ");
			sqlStr.append("AND    A.CRM_QUESTIONAIRE_ID = Q.CRM_QUESTIONAIRE_ID (+) ");
			sqlStr.append("AND    A.CRM_ENABLED = 1 ");
			sqlStr.append("AND    A.CRM_ACTIVITY_ID = ?");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { activityID });
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				siteCode = row.getValue(0);
				activityDesc = row.getValue(1);
				activityDate = row.getValue(2);
				eventID = row.getValue(3);
				eventDesc = row.getValue(4);
				activityNote = row.getValue(5);
				attachment = row.getValue(6);
				questionnaireID = row.getValue(7);
				questionnaireDesc = row.getValue(8);
			}
		} else {
%>
<jsp:forward page="activity_list.jsp"/>
<%
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
	title = "function.activityHistory." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="5" />
</jsp:include>
<form name="form1" action="activity.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.site" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
<jsp:include page="../ui/siteCodeRDB.jsp" flush="false">
	<jsp:param name="allowAll" value="N" />
</jsp:include>
<%	} else { %>
			<%=siteCode==null?"N/A":siteCode.toUpperCase() %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.description" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="activityDesc" value="<%=activityDesc==null?"":activityDesc %>" maxlength="100" size="50">
<%	} else { %>
			<%=activityDesc==null?"":activityDesc %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="activityDate" />
	<jsp:param name="date" value="<%=activityDate %>" />
	<jsp:param name="showTime" value="N" />
</jsp:include>
<%	} else { %>
			<%=activityDate==null?"":activityDate %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.event" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="eventID">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="eventID" value="<%=eventID %>" />
	<jsp:param name="emptyLabel" value="Empty" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select>
<%	} else { %>
			<%=eventDesc==null?"":eventDesc %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Note</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="activityNote" value="<%=activityNote==null?"":activityNote %>" maxlength="100" size="50">
<%	} else { %>
			<%=activityNote==null?"":activityNote %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Attachment</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="attachment" value="<%="attachment"==null?"":attachment %>" maxlength="100" size="50">
<%	} else { %>
			<%="attachment"==null?"":attachment %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.questionnaire" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="questionnaireID" onchange="showQuestionaire();">
<jsp:include page="../ui/questionnaireIDCMB.jsp" flush="false">
	<jsp:param name="questionnaireID" value="<%=questionnaireID %>" />
	<jsp:param name="emptyLabel" value="Empty" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select>
<%	} else { %>
			<%=questionnaireDesc==null?"":questionnaireDesc %>
<%	} %>
		</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0"
	class="tablesorter" border="0">
	<thead>
	<tr class="smallText">
		<th class="{sorter: false}">&nbsp;</th>
		<th width="75%"><bean:message key="prompt.questionnaire" /></th>
		<th class="{sorter: false}"><bean:message key="prompt.action" /></th>
		<th class="{sorter: false}">&nbsp;</th>
	</tr>
	</thead>
	<tbody>
<%
	boolean success = false;
	try {
		ArrayList record = fetchQuestionaire(questionnaireID);
		ReportableListObject row = null;
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
%>
	<tr>
		<td align="center"><%=i + 1 %>)</td>
		<td align="center"><%=row.getValue(1) %></td>
		<td align="center"><input type="checkbox"></td>
		<td>&nbsp;</td>
	</tr>
<%
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
			<bean:define id="functionLabel"><bean:message key="function.questionnaire.list" /></bean:define>
			<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
		</td>
	</tr>
<%
	}
%>
	</tbody>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.activityHistory.update" /></button>
			<button class="btn-delete"><bean:message key="function.activityHistory.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="" />
<input type="hidden" name="step" value="" />
<input type="hidden" name="activityID" value="<%=activityID %>">
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.activityDesc.value == '') {
				alert("<bean:message key="error.date.required" />.");
				document.form1.activityDesc.focus();
				return false;
			}
		}
<%	} %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function showQuestionaire() {
		document.form1.step.value = 0;
		document.form1.submit();
	}
</script>
<a class="button" href="<html:rewrite page="/crm/activity_list.jsp" />" onclick="this.blur();"><span><bean:message key="prompt.backTo" /> <bean:message key="function.activityHistory.list" /></span></a>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>