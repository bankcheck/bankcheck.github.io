<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> getList(String rolID) {
		return UtilDBWeb.getReportableListHATS("SELECT ROLNAM, ROLDESC FROM ROLE WHERE ROLID = ?", new String[] { rolID });
	}

	private String getGroupSeq() {
		// fetch group
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT SEQ_ROLE.NEXTVAL FROM DUAL");

		ArrayList record = UtilDBWeb.getReportableListHATS(sqlStr.toString());
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		}
		return null;
	}

	private boolean add(UserBean userBean, String rolID, String rolNam, String rolDesc) {
		return UtilDBWeb.updateQueueHATS(
				"INSERT INTO ROLE(ROLID, ROLNAM, ROLDESC, STECODE) VALUES (?, ?, ?, GET_CURRENT_STECODE)",
				new String[] { rolID, rolNam, rolDesc });
	}

	private boolean update(UserBean userBean, String rolID, String rolNam, String rolDesc) {
		return UtilDBWeb.updateQueueHATS(
				"UPDATE ROLE SET ROLNAM = ?, ROLDESC = ? WHERE ROLID = ? AND STECODE = GET_CURRENT_STECODE",
				new String[] { rolNam, rolDesc, rolID });
	}

	private boolean delete(UserBean userBean, String rolID) {
		return UtilDBWeb.updateQueueHATS(
				"DELETE ROLE WHERE ROLID = ? AND STECODE = GET_CURRENT_STECODE",
				new String[] { rolID });
	}

	private ArrayList<ReportableListObject> fetchFunctionAvailable(UserBean userBean, String rolID) {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT FSCID, FSCDESC ");
		sqlStr.append("FROM   FUNCSEC ");
		sqlStr.append("WHERE  FSCID NOT IN ( SELECT FSCID FROM ROLEFUNCSEC WHERE ROLID = ?) ");
		sqlStr.append("ORDER BY FSCDESC");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { rolID });
	}

	private ArrayList<ReportableListObject> fetchFunctionSelected(UserBean userBean, String rolID) {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT FSCID, FscDesc ");
		sqlStr.append("FROM   FUNCSEC ");
		sqlStr.append("WHERE  FSCID IN ( SELECT FSCID FROM ROLEFUNCSEC WHERE ROLID = ?) ");
		sqlStr.append("ORDER BY FSCDESC");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { rolID });
	}

	private boolean updateFunctionID(UserBean userBean, String rolID, String[] functionID) {
		boolean success = true;

		HashMap<String, String> roleFuncSecHashMap = new HashMap<String, String>();
		ArrayList record = UtilDBWeb.getReportableListHATS("SELECT RFSID, FSCID FROM ROLEFUNCSEC WHERE ROLID = ?", new String[] { rolID });
		if (record.size() > 0) {
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				roleFuncSecHashMap.put(row.getValue(1), row.getValue(0));
			}
		}

		// clear old function id
		success = UtilDBWeb.updateQueueHATS("DELETE ROLEFUNCSEC WHERE ROLID = ?", new String[] { rolID });

		// add function id
		if (functionID != null && functionID.length > 0) {
			for (int i = 0; i < functionID.length; i++) {
				if (roleFuncSecHashMap.containsKey(functionID[i])) {
					UtilDBWeb.updateQueueHATS("INSERT INTO ROLEFUNCSEC (RFSID, ROLID, FSCID) VALUES (?, ?, ?)", new String[] { roleFuncSecHashMap.get(functionID[i]), rolID, functionID[i] });
				} else {
					UtilDBWeb.updateQueueHATS("INSERT INTO ROLEFUNCSEC (RFSID, ROLID, FSCID) VALUES (SEQ_ROLEFUNCSEC.NEXTVAL, ?, ?)", new String[] { rolID, functionID[i] });
				}
			}
		}

		return success;
	}
%>
<%
UserBean userBean = new UserBean(request);

String command = (String) request.getAttribute("command");
if (command == null) {
	command = request.getParameter("command");
}
String step = (String) request.getParameter("step");
if (step == null) {
	step = request.getParameter("step");
}
String rolID = request.getParameter("rolID");
String rolNam = request.getParameter("rolNam");
String rolDesc = request.getParameter("rolDesc");

String functionID[] = request.getParameterValues("functionID");
String functionIDDesc[] = null;
String functionIDAvailable[] = null;
String functionIDDescAvailable[] = null;

ArrayList record = null;
ReportableListObject row = null;

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command) || !userBean.isLogin()) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
		boolean found = false;
		if (rolID != null && rolID.length() > 0) {
			record = getList(rolID);
			found = record.size() > 0;
		}

		if (createAction) {
			if (found) {
				errorMessage = "HATS Group create fail due to already exists.";
			} else {
				rolID = getGroupSeq();
				if (add(userBean, rolID, rolNam, rolDesc)) {
					message = "HATS Group is created.";
					createAction = false;
					step = "0";
				} else {
					errorMessage = "HATS Group fail to create.";
				}
			}
		} else if (updateAction) {
			if (!found) {
				errorMessage = "HATS Group update fail due to not exists.";
			} else if (update(userBean, rolID, rolNam, rolDesc)) {
				HashMap<String, String> roleFuncSecHashMap = new HashMap<String, String>();
				record = UtilDBWeb.getReportableListHATS("SELECT RFSID, FSCID FROM ROLEFUNCSEC WHERE ROLID = ?", new String[] { rolID });
				if (record.size() > 0) {
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						roleFuncSecHashMap.put(row.getValue(0), row.getValue(1));
					}
				}

				updateFunctionID(userBean, rolID, functionID);
				message = "HATS Group is updated.";
				updateAction = false;
				step = "0";
			} else {
				errorMessage = "HATS Group fail to update.";
			}
		} else if (deleteAction) {
			if (!found) {
				errorMessage = "HATS Group fail to update due to not exists.";
			} else if (delete(userBean, rolID)) {
				message = "HATS Group removed.";
				closeAction = true;
			} else {
				errorMessage = "HATS Group fail to remove.";
			}
		}
	} else if (createAction) {
		rolID = "";
		rolNam = "";
		rolDesc = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		// change login id
		if (rolID != null && rolID.length() > 0) {
			record = getList(rolID);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				rolNam = row.getValue(0);
				rolDesc = row.getValue(1);

				record = fetchFunctionSelected(userBean, rolID);
				if (record.size() > 0) {
					functionID = new String[record.size()];
					functionIDDesc = new String[record.size()];
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						functionID[i] = row.getValue(0);
						functionIDDesc[i] = row.getValue(1);
					}
				} else {
					functionID = null;
					functionIDDesc = null;
				}
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}

	if (updateAction) {
		record = fetchFunctionAvailable(userBean, rolID);
		if (record.size() > 0) {
			functionIDAvailable = new String[record.size()];
			functionIDDescAvailable = new String[record.size()];
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				functionIDAvailable[i] = row.getValue(0);
				functionIDDescAvailable[i] = row.getValue(1);
			}
		} else {
			functionIDAvailable = null;
			functionIDDescAvailable = null;
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
	String displayTitle = null;
	String commandType = null;
	if (createAction) {
		displayTitle = "Create HATS Group";
		commandType = "create";
	} else if (updateAction) {
		displayTitle = "Update HATS Group";
		commandType = "update";
	} else if (deleteAction) {
		displayTitle = "Delete HATS Group";
		commandType = "delete";
	} else {
		displayTitle = "View HATS Group";
		commandType = "view";
	}
	// set submit label
	title = "function.group." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="displayTitle" value="<%=displayTitle %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" id="form1" action="hats_group.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.name" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<html:text property="rolNam" value="<%=rolNam %>" maxlength="20" size="50" />
<%	} else { %>
			<%=rolNam==null?"":rolNam %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.description" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<html:text property="rolDesc" value="<%=rolDesc %>" maxlength="100" size="50" />
<%	} else { %>
			<%=rolDesc==null?"":rolDesc %>
<%	} %>
		</td>
	</tr>
<%	if (!createAction) { %>
	<input type="hidden" name="hasFunctionID" value="Y">
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.access" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.function" /></td>
		<td class="infoData" width="70%">
<%			if (createAction || updateAction) { %>
			<table border="0">
				<tr>
					<td><bean:message key="prompt.functionAvailable" /></td>
					<td>&nbsp;</td>
					<td><bean:message key="prompt.functionSelected" /></td>
				</tr>
				<tr>
					<td>
						<select name="functionIDAvailable" size="10" multiple id="select1">
<%				if (functionIDAvailable != null) {
					for (int i = 0; i < functionIDAvailable.length; i++) {
%><option value="<%=functionIDAvailable[i] %>"><%=functionIDDescAvailable[i] %></option><%
					}
				} %>
						</select>
					</td>
					<td>
						<button id="add"><bean:message key="button.add" /> >></button><br>
						<button id="remove"><< <bean:message key="button.delete" /></button>
					</td>
					<td>
						<select name="functionID" size="10" multiple id="select2">
<%				if (functionID != null) {
					for (int i = 0; i < functionID.length; i++) {
%><option value="<%=functionID[i] %>"><%=functionIDDesc[i] %></option><%
					}
				} %>
						</select>
					</td>
				</tr>
			</table>
<%			} else {
				if (functionID != null) {
					for (int i = 0; i < functionID.length; i++) {
%><%=functionIDDesc[i] %><br/><%
					}
				}
			} %>
		</td>
	</tr>
<%	} %>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
<%		if (userBean.isAccessible("function.user.create")) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
<%		} %>
<%		if (updateAction || deleteAction) { %>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		} %>
<%	} else { %>
<%		if (userBean.isAccessible("function.user.update")) { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.group.update" /></button>
<%		} %>
<%		if (userBean.isAccessible("function.user.delete")) { %>
			<button class="btn-delete"><bean:message key="function.group.delete" /></button>
<%		} %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="rolID" value="<%=rolID %>">
</form>
<script language="javascript">
	$().ready(function() {
		$('#add').click(function() {
			return !$('#select1 option:selected').appendTo('#select2');
		});
		$('#remove').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});
	});

	$('.input_capital').on('input', function(evt) {
		$(this).val(function(_, val) {
			return val.toUpperCase();
		});
	});

	function submitAction(cmd, stp) {
		if (cmd == 'create' || cmd == 'update') {
<%	if (createAction || updateAction) { %>
			if (document.form1.rolNam.value == '') {
				alert("Empty HATS Group Name.");
				document.form1.rolNam.focus();
				return false;
			}
			if (document.form1.rolDesc.value == '') {
				alert("Empty HATS Group Description.");
				document.form1.rolDesc.focus();
				return false;
			}
			selectItem('form1', 'functionID');
<%	} %>
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

<%	if (updateAction) { %>
	removeDuplicateItem('form1', 'functionIDAvailable', 'functionID');
<%	} %>
</script>
<%if (!userBean.isAdmin()) { %>
<br/>
<a class="button" href="<html:rewrite page="/index.jsp" />" onclick="this.blur();"><span><bean:message key="prompt.backTo" /> <bean:message key="prompt.loginPage" /></span></a>
<%} %>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp"/>
</body>
<%} %>
</html:html>