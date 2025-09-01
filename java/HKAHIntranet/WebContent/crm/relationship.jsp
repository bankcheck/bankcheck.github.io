<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);

String command = request.getParameter("command");
String step = request.getParameter("step");
String clientRelativeID = request.getParameter("clientRelativeID");
String lastName = TextUtil.parseStr(request.getParameter("lastName")).toUpperCase();
String firstName = TextUtil.parseStr(request.getParameter("firstName")).toUpperCase();
String clientRelativeName = null;
String relationship = request.getParameter("relationship");
String remarks = request.getParameter("remarks");

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
		if ((createAction || updateAction) && (relationship == null || relationship.length() == 0)) {
			errorMessage = MessageResources.getMessage(session, "error.relationship.required");
			step = "0";
		} else if ((createAction || updateAction) && (clientID == clientRelativeID)) {
			errorMessage = "Client cannot be his relative.";
			step = "0";
		} else if (createAction) {
			if (clientRelativeID == null) {
				clientRelativeID = CRMClientDB.add(userBean, lastName, firstName);
			}

			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT CRM_ENABLED ");
			sqlStr.append("FROM   CRM_CLIENTS_RELATIONSHIP ");
			sqlStr.append("WHERE  CRM_CLIENT_ID = ? ");
			sqlStr.append("AND    CRM_RELATED_CLIENT_ID = ?");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, clientRelativeID });
			ReportableListObject row = null;
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				if ("1".equals(row.getValue(0))) {
					errorMessage = "Relationship already created.";
				} else {
					sqlStr.setLength(0);
					sqlStr.append("UPDATE CRM_CLIENTS_RELATIONSHIP ");
					sqlStr.append("SET    CRM_RELATIONSHIP = ?, CRM_REMARKS = ? ");
					sqlStr.append("       CRM_ENABLED = 1, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
					sqlStr.append("WHERE  CRM_CLIENT_ID = ? ");
					sqlStr.append("AND    CRM_RELATED_CLIENT_ID = ?");

					if (UtilDBWeb.updateQueue(
							sqlStr.toString(),
							new String[] { relationship, remarks, loginID, clientID, clientRelativeID } )) {
						message = "Relationship created.";
					} else {
						errorMessage = "Relationship create fail.";
					}
				}
			} else {
				sqlStr.setLength(0);
				sqlStr.append("INSERT INTO CRM_CLIENTS_RELATIONSHIP ");
				sqlStr.append("(CRM_CLIENT_ID, CRM_RELATED_CLIENT_ID, CRM_RELATIONSHIP, ");
				sqlStr.append(" CRM_REMARKS, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
				sqlStr.append("VALUES ");
				sqlStr.append("(?, ?, ?, ?, ?, ?)");

				if (UtilDBWeb.updateQueue(
						sqlStr.toString(),
						new String[] { clientID, clientRelativeID, relationship,
						remarks, loginID, loginID} )) {
					message = "Relationship created.";
				} else {
					errorMessage = "Relationship create fail.";
				}
			}
		} else if (updateAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_CLIENTS_RELATIONSHIP ");
			sqlStr.append("SET    CRM_RELATIONSHIP = ?, CRM_REMARKS = ?, ");
			sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_CLIENT_ID = ? ");
			sqlStr.append("AND    CRM_RELATED_CLIENT_ID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { relationship, remarks,
					loginID, clientID, clientRelativeID } )) {
				message = "Relationship updated.";
			} else {
				errorMessage = "Relationship update fail.";
			}
		} else if (deleteAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_CLIENTS_RELATIONSHIP ");
			sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_CLIENT_ID = ? ");
			sqlStr.append("AND    CRM_RELATED_CLIENT_ID = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { loginID, clientID, clientRelativeID } )) {
				message = "Relationship removed.";
			} else {
				errorMessage = "Relationship remove fail.";
			}
		}

		// forward to list page
		if (errorMessage == null || errorMessage.length() == 0) {
%>
<jsp:forward page="relative_list.jsp">
	<jsp:param name="message" value="<%=message %>"/>
</jsp:forward>
<%
		}
	} else if (createAction) {
		relationship = "";
		remarks = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (clientRelativeID != null && clientRelativeID.length() > 0) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT C.CRM_LASTNAME, C.CRM_FIRSTNAME, ");
			sqlStr.append("       R.CRM_RELATIONSHIP, R.CRM_REMARKS ");
			sqlStr.append("FROM   CRM_CLIENTS_RELATIONSHIP R, CRM_CLIENTS C ");
			sqlStr.append("WHERE  R.CRM_RELATED_CLIENT_ID = C.CRM_CLIENT_ID ");
			sqlStr.append("AND    R.CRM_ENABLED = 1 ");
			sqlStr.append("AND    R.CRM_CLIENT_ID = ? ");
			sqlStr.append("AND    R.CRM_RELATED_CLIENT_ID = ?");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, clientRelativeID });
			if (record.size() > 0) {
				// assign value from database
				ReportableListObject row = (ReportableListObject) record.get(0);
				clientRelativeName = row.getValue(0) + ", " + row.getValue(1);
				relationship = row.getValue(2);
				remarks = row.getValue(3);
			}
		} else {
%>
<jsp:forward page="client_info.jsp"/>
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
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/thickbox.css" />" media="screen" />
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
	title = "function.relationship." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="3" />
</jsp:include>
<form name="form1" action="relationship.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Relative</td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
			<span id="matchClient_indicator">
			<a href="client_info_list.jsp?command=select&keepThis=true&TB_iframe=true&height=700&width=900" title="<bean:message key="function.client.list" />" class="thickbox button">
				<span>Select Relative from Client List</span>
			</a> or
			<br><br><bean:message key="prompt.lastName" />: <input type="textfield" name="lastName" value="<%=lastName==null?"":lastName %>" maxlength="30" size="25">
			<br><bean:message key="prompt.firstName" />: <input type="textfield" name="firstName" value="<%=firstName==null?"":firstName %>" maxlength="60" size="25">
<%	} else { %>
			<%=clientRelativeName==null?clientRelativeID:clientRelativeName %><input type="hidden" name="clientRelativeID" value="<%=clientRelativeID %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Relationship</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="relationship" value="<%=relationship==null?"":relationship %>" maxlength="30" size="25">
<%	} else { %>
			<%=relationship==null?"":relationship %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.remarks" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="remarks" value="<%=remarks==null?"":remarks %>" maxlength="30" size="25">
<%	} else { %>
			<%=remarks==null||remarks.length()==0?"N/A":remarks %>
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
<%		if (createAction) { %>
			<button onclick="return submitAction('list', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		} else { %>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		} %>
<%	} else {%>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.relationship.update" /></button>
			<button class="btn-delete"><bean:message key="function.relationship.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="" />
<input type="hidden" name="step" value="" />
</form>
<script language="javascript">
<!--
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.relationship.value == '') {
				alert("<bean:message key="error.relationship.required" />.");
				document.form1.relationship.focus();
				return false;
			}
		}
<%	} %>
		if (cmd == 'list') {
			document.form1.action = "relative_list.jsp";
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function tb_remove_4_search(cid, name1, name2) {
		document.getElementById("matchClient_indicator").innerHTML = name1 + ', ' + name2 + '<input type="hidden" name="clientRelativeID" value="' + cid + '">';
	 	tb_remove();
	}
-->
</script>
<a class="button" href="<html:rewrite page="/crm/relative_list.jsp" />" onclick="this.blur();"><span><bean:message key="prompt.backTo" /> <bean:message key="function.relative.list" /></span></a>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>