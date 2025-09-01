<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();

String clientID = request.getParameter("clientID");
if (clientID == null) {
	clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);
}
String command = request.getParameter("command");
String step = request.getParameter("step");
String affiliationID = request.getParameter("affiliationID");
String companyName = request.getParameter("companyName");
String companyTitle = request.getParameter("companyTitle");
String remarks = request.getParameter("remarks");

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
			// get club seq
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT COUNT(1) + 1 ");
			sqlStr.append("FROM   CRM_CLIENTS_AFFILIATION ");
			sqlStr.append("WHERE  CRM_CLIENT_ID = ? ");
			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID });
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				affiliationID = row.getValue(0);
			}

			sqlStr.setLength(0);
			sqlStr.append("INSERT INTO CRM_CLIENTS_AFFILIATION ");
			sqlStr.append("(CRM_CLIENT_ID, CRM_AFFILIATION_ID, CRM_COMPANY_NAME, CRM_COMPANY_TITLE, CRM_AFFILIATION_REMARKS, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
			sqlStr.append("VALUES ");
			sqlStr.append("(?, ?, ?, ?, ?, ?, ?)");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { clientID, affiliationID, companyName, companyTitle, remarks, loginID, loginID} )) {
				message = "Affiliation created.";

				createAction = false;
				step = "0";
			} else {
				errorMessage = "Affiliation create fail.";
			}
		} else if (updateAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_CLIENTS_AFFILIATION ");
			sqlStr.append("SET    CRM_COMPANY_NAME = ?, CRM_COMPANY_TITLE = ?, CRM_AFFILIATION_REMARKS = ?, ");
			sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_CLIENT_ID = ? ");
			sqlStr.append("AND    CRM_AFFILIATION_ID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { companyName, companyTitle, remarks, loginID, clientID, affiliationID } )) {
				message = "Affiliation updated.";

				updateAction = false;
				step = "0";
			} else {
				errorMessage = "Affiliation update fail.";
			}
		} else if (deleteAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_CLIENTS_AFFILIATION ");
			sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_CLIENT_ID = ? ");
			sqlStr.append("AND    CRM_AFFILIATION_ID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { loginID, clientID, affiliationID } )) {
				message = "Affiliation removed.";

				closeAction = true;
			} else {
				errorMessage = "Affiliation remove fail.";
			}
		}
	} else if (createAction) {
		companyName = "";
		companyTitle = "";
		remarks = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (affiliationID != null && affiliationID.length() > 0) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT CRM_COMPANY_NAME, CRM_COMPANY_TITLE, CRM_AFFILIATION_REMARKS ");
			sqlStr.append("FROM   CRM_CLIENTS_AFFILIATION ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_CLIENT_ID = ? ");
			sqlStr.append("AND    CRM_AFFILIATION_ID = ?");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, affiliationID });
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				companyName = row.getValue(0);
				companyTitle = row.getValue(1);
				remarks = row.getValue(2);
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
<%if (closeAction) {%>
<META HTTP-EQUIV="Refresh" CONTENT="0; URL=client_info.jsp#affiliation">
<%} else { %>
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
	title = "function.affiliation." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="1" />
	<jsp:param name="href" value="affiliation" />
</jsp:include>
<table width="100%" border="0">
	<tr class="smallText">
		<td class="infoTitle"><bean:message key="prompt.affiliation" /></td>
	</tr>
</table>
<form name="form1" action="client_affiliation.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.companyName" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="companyName" value="<%=companyName==null?"":companyName %>" maxlength="50" size="50">
<%	} else { %>
			<%=companyName==null?"":companyName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.companyTitle" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="companyTitle" value="<%=companyTitle==null?"":companyTitle %>" maxlength="50" size="50">
<%	} else { %>
			<%=companyTitle==null?"":companyTitle %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.remarks" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="remarks" value="<%=remarks==null?"":remarks %>" maxlength="100" size="50">
<%	} else { %>
			<%=remarks==null?"":remarks %>
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
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.affiliation.update" /></button>
			<button class="btn-delete"><bean:message key="function.affiliation.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="<%=commandType %>">
<input type="hidden" name="step" value="1">
<input type="hidden" name="affiliationID" value="<%=affiliationID %>">
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.companyName.value == '') {
				alert("<bean:message key="error.affiliation.required" />.");
				document.form1.companyName.focus();
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