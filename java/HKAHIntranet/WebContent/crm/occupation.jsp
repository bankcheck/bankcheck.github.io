<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = request.getParameter("command");
String step = request.getParameter("step");
String activityID = request.getParameter("activityID");
String activityDesc = request.getParameter("activityDesc");

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
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("INSERT INTO CRM_ACTIVITIES ");
			sqlStr.append("(CRM_ACTIVITY_ID, CRM_ACTIVITY_DESC, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
			sqlStr.append("VALUES ");
			sqlStr.append("((SELECT COUNT(1) + 1 FROM CRM_ACTIVITIES), ?, ?, ?)");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { activityDesc, loginID, loginID} )) {
				message = "Activity created.";
				createAction = false;
			} else {
				errorMessage = "Activity create fail.";
			}
		} else if (updateAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_ACTIVITIES ");
			sqlStr.append("SET    CRM_ACTIVITY_DESC = ?, ");
			sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_ACTIVITY_ID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { activityDesc, loginID, activityID } )) {
				message = "Activity updated.";
				updateAction = false;
			} else {
				errorMessage = "Activity update fail.";
			}
		} else if (deleteAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_ACTIVITIES ");
			sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_ACTIVITY_ID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { loginID, activityID } )) {
				message = "Activity removed.";
				closeAction = true;
			} else {
				errorMessage = "Activity remove fail.";
			}
		}
	} else if (createAction) {
		activityDesc = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (activityID != null && activityID.length() > 0) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT CRM_ACTIVITY_DESC ");
			sqlStr.append("FROM   CRM_ACTIVITIES ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_ACTIVITY_ID = ?");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { activityID });
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				activityDesc = row.getValue(0);
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
	title = "function.activity." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="activity.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
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
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.activity.update" /></button>
			<button class="btn-delete"><bean:message key="function.activity.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="activityID" value="<%=activityID %>">
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.activityDesc.value == '') {
				alert("<bean:message key="error.activity.required" />.");
				document.form1.activityDesc.focus();
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