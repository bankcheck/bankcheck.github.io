<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList fetchFunction() {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT AC_FUNCTION_ID, 'group.' || AC_GROUP_ID ");
		sqlStr.append("FROM   AC_FUNCTION ");
		sqlStr.append("WHERE  AC_ENABLED = 1 ");
		sqlStr.append("ORDER BY AC_GROUP_ID, AC_FUNCTION_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private boolean isLevel0Group(String groupID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CO_GROUPS ");
		sqlStr.append("WHERE  CO_GROUP_ID = ? ");
		sqlStr.append("AND    CO_GROUP_LEVEL = 0 ");
		sqlStr.append("AND    CO_ENABLED = 1 ");

		return UtilDBWeb.isExist(sqlStr.toString(), new String[]{groupID});
	}
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = request.getParameter("command");
String step = request.getParameter("step");
String userRoleID = request.getParameter("userRoleID");
String functionID[] = request.getParameterValues("functionID");
String functionIDGroup[] = null;
String functionIDAvailable[] = null;
String functionIDAvailableGroup[] = null;
boolean select2IsEmpty = "Y".equals(request.getParameter("select2IsEmpty"));
String userID[] = request.getParameterValues("userID");
String userIDDesc[] = null;
boolean isLevel0Group = false;
boolean userIDSelect2IsEmpty = "Y".equals(request.getParameter("userIDSelect2IsEmpty"));

boolean updateAction = false;

String message = "";
String errorMessage = "";

if ("update".equals(command)) {
	updateAction = true;
}

try {
	if ("1".equals(step)) {
		// clean up the original
		// clean up function access control
		if (functionID != null || select2IsEmpty) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("DELETE AC_FUNCTION_ACCESS ");
			sqlStr.append("WHERE  AC_ENABLED = 1 ");
			sqlStr.append("AND    AC_GROUP_ID = ?");

			UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userRoleID } );
		}

		// clean up user access control
		if (userID != null || userIDSelect2IsEmpty) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr = new StringBuffer();
			sqlStr.append("DELETE AC_USER_GROUPS ");
			sqlStr.append("WHERE  AC_ENABLED = 1 ");
			sqlStr.append("AND    AC_GROUP_ID = ?");

			UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userRoleID } );
		}

		boolean functionSuccess = false;
		boolean userSuccess = false;
		if (updateAction) {
			if (functionID != null) {
				for (int i = 0; i < functionID.length; i++) {
					if (UtilDBWeb.updateQueue(
						"INSERT INTO AC_FUNCTION_ACCESS " +
						"(AC_FUNCTION_ID, AC_GROUP_ID, AC_ACCESS_MODE, AC_CREATED_USER, AC_MODIFIED_USER) " +
						"VALUES " +
						"(?, ?, 'F', ?, ?)",
						new String[] { functionID[i], userRoleID, loginID, loginID } )) {
						functionSuccess = true;
					}
				}
			} else {
				functionSuccess = true;
			}

			if (userID != null) {
				for (int i = 0; i < userID.length; i++) {
					if (UtilDBWeb.updateQueue(
						"INSERT INTO AC_USER_GROUPS " +
						"(AC_STAFF_ID, AC_GROUP_ID, AC_CREATED_USER, AC_MODIFIED_USER) " +
						"VALUES " +
						"(?, ?, ?, ?)",
						new String[] { userID[i], userRoleID, loginID, loginID } )) {
						userSuccess = true;
					}
				}
			} else {
				userSuccess = true;
			}

			if (functionSuccess && userSuccess) {
				message = "Access control updated.";
				updateAction = false;
			} else {
				errorMessage = "Access control update fail.";
			}
		}
	}

	isLevel0Group = isLevel0Group(userRoleID);

	// load data from database
	if (userRoleID != null && userRoleID.length() > 0) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT AF.AC_FUNCTION_ID, 'group.' || AF.AC_GROUP_ID ");
		sqlStr.append("FROM   AC_FUNCTION_ACCESS AC, AC_FUNCTION AF ");
		sqlStr.append("WHERE  AC.AC_FUNCTION_ID = AF.AC_FUNCTION_ID ");
		sqlStr.append("AND    AC.AC_GROUP_ID = ? ");
		sqlStr.append("AND    AF.AC_ENABLED = 1 ");
		sqlStr.append("ORDER BY AF.AC_GROUP_ID, AF.AC_FUNCTION_ID");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userRoleID });
		ReportableListObject row = null;
		if (record.size() > 0) {
			functionID = new String[record.size()];
			functionIDGroup = new String[record.size()];
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				functionID[i] = row.getValue(0);
				functionIDGroup[i] = row.getValue(1);
			}
		} else {
			functionID = null;
		}

		record = fetchFunction();
		if (record.size() > 0) {
			functionIDAvailable = new String[record.size()];
			functionIDAvailableGroup = new String[record.size()];
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				functionIDAvailable[i] = row.getValue(0);
				functionIDAvailableGroup[i] = row.getValue(1);
			}
		} else {
			functionIDAvailable = null;
		}

		// load user list if level of this group is 0
		if (isLevel0Group) {
			sqlStr.setLength(0);
			sqlStr.append("SELECT U.CO_FIRSTNAME, U.CO_LASTNAME, S.CO_STAFFNAME, D.CO_DEPARTMENT_DESC, S.CO_STAFF_ID ");
			sqlStr.append("FROM   AC_USER_GROUPS AUG, CO_USERS U, CO_STAFFS S, CO_DEPARTMENTS D ");
			sqlStr.append("WHERE  AUG.AC_SITE_CODE = U.CO_SITE_CODE ");
			sqlStr.append("AND    AUG.AC_STAFF_ID = U.CO_STAFF_ID ");
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
			sqlStr.append("AND    S.CO_SITE_CODE = U.CO_SITE_CODE ");
			sqlStr.append("AND    S.CO_STAFF_ID = U.CO_STAFF_ID ");
			sqlStr.append("AND    AUG.AC_GROUP_ID = ? ");
			sqlStr.append("AND    AUG.AC_ENABLED = 1 ");
			sqlStr.append("AND    S.CO_ENABLED = 1 ");
			sqlStr.append("ORDER  BY S.CO_STAFFNAME");

			record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userRoleID });
			if (record.size() > 0) {
				userID = new String[record.size()];
				userIDDesc = new String[record.size()];
				ReportableListObject rlo = null;
				String staffID = null;
				String userLastName = null;
				String userFirstName = null;
				String staffName = null;
				String deptDesc = null;
				String displayName = null;
				for (int i = 0; i < record.size(); i++) {
					rlo = (ReportableListObject) record.get(i);
					userFirstName = rlo.getValue(0);
					userLastName = rlo.getValue(1);
					staffName = rlo.getValue(2);
					deptDesc = rlo.getValue(3);
					staffID = rlo.getValue(4);
					// show staff name, if no staff name, show user first name and last name
					if (staffName != null && staffName.trim().length() > 0) {
						displayName = staffName;
					} else {
						displayName = (userFirstName == null ? "" : userFirstName) + (userLastName == null ? "" : userLastName);
					}

					userID[i] = staffID;
					userIDDesc[i] = displayName + " " + (deptDesc == null || deptDesc.length() == 0 ? "" : "(" + deptDesc + ")");
				}
			} else {
				userID = null;
				userIDDesc = null;
			}
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
<script type="text/javascript" src="<html:rewrite page="/js/filterlist.js" />"></script>
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
	if (updateAction) {
		commandType = "update";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.accessControl." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="access_control.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.userGroup" /></td>
		<td class="infoData" width="70%">
			<%=userRoleID==null?"":userRoleID %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.function" /></td>
		<td class="infoData" width="70%">
<%	if (updateAction) { %>
			<table border="0">
				<tr>
					<td><bean:message key="prompt.functionAvailable" /></td>
					<td>&nbsp;</td>
					<td><bean:message key="prompt.functionSelected" /></td>
				</tr>
				<tr>
					<td>
						<select name="functionIDAvailable" size="10" multiple id="select1">
<%		if (functionIDAvailable != null) { %>
<%			for (int i = 0; i < functionIDAvailable.length; i++) { %>
							<option value="<%=functionIDAvailable[i] %>">
<%						try {
%><bean:message key="<%=functionIDAvailableGroup[i] %>" />-<bean:message key="<%=functionIDAvailable[i] %>" /><%
						} catch (Exception e) {
%><%=functionIDAvailableGroup[i] %>-<%=functionIDAvailable[i] %><%
						} %>
							</option>
<%			} %>
<%		} %>
						</select>
					</td>
					<td>
						<button id="add"><bean:message key="button.add" /> >></button><br>
						<button id="remove"><< <bean:message key="button.delete" /></button>
					</td>
					<td>
						<select name="functionID" size="10" multiple id="select2">
<%		if (functionID != null) { %>
<%			for (int i = 0; i < functionID.length; i++) { %>
							<option value="<%=functionID[i] %>">
<%						try {
%><bean:message key="<%=functionIDGroup[i] %>" />-<bean:message key="<%=functionID[i] %>" /><%
						} catch (Exception e) {
%><%=functionIDGroup[i] %>-<%=functionID[i] %><%
						} %>
							</option>
<%			} %>
<%		} %>
						</select>
					</td>
				</tr>
			</table>
<%	} else { %>
<%		if (functionID != null) { %>
<%			for (int i = 0; i < functionID.length; i++) { %>
<%						try {
%><bean:message key="<%=functionIDGroup[i] %>" />-<bean:message key="<%=functionID[i] %>" /><br/><%
						} catch (Exception e) {
%><%=functionIDGroup[i] %>-<%=functionID[i] %><br/><%
						} %>
<%			} %>
<%		} %>
<%	} %>
			<input type="hidden" name="select2IsEmpty" value="N" />
		</td>
	</tr>

<%	if (isLevel0Group) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.users" /></td>
		<td class="infoData" width="70%">
<%			if (updateAction) { %>
			<table border="0">
				<tr>
					<td><bean:message key="prompt.usersAvailable" /></td>
					<td>&nbsp;</td>
					<td><bean:message key="prompt.usersSelected" /></td>
				</tr>
				<tr>
					<td>
						<select name="userIDAvailable" size="10" multiple id="userIDSelect1">
							<jsp:include page="../ui/staffIDCMB.jsp" flush="true" />
						</select>
						<div>
							<bean:message key="button.search" />:&nbsp;
							<input name="searchField1" onkeyup="myfilter1.set(this.value, event)" />
						</div>
					</td>
					<td>
						<button id="add2"><bean:message key="button.add" /> &gt;&gt;</button><br>
						<button id="remove2">&lt;&lt; <bean:message key="button.delete" /></button>
					</td>
					<td>
						<select name="userID" size="10" multiple id="userIDSelect2">
							<% request.setAttribute("staffIDCMB_filterValues", userID); %>
							<jsp:include page="../ui/staffIDCMB.jsp" flush="true">
								<jsp:param name="isFilterValues" value="Y" />
							</jsp:include>
						</select>
						<div>
							<bean:message key="button.search" />:&nbsp;
							<input name="searchField2" onkeyup="myfilter2.set(this.value, event)"/>
						</div>
					</td>
				</tr>
			</table>
<%			} else {
				if (userID != null) {
					for (int i = 0; i < userID.length; i++) {
						try {
%><bean:message key="<%=userIDDesc[i] %>" /><br/><%
						} catch (Exception e) {
%><%=userIDDesc[i] %><br/><%
						}
					}
				}
			} %>
			<input type="hidden" name="userIDSelect2IsEmpty" value="N" />
		</td>
	</tr>
<%	} %>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (updateAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.accessControl.update" /></button>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="userRoleID" value="<%=userRoleID%>">
</form>
<script language="javascript">
<%	if (isLevel0Group) { %>
	// filter staff list
	var myfilter1 = new filterlist(document.form1.userIDAvailable, document.form1.searchField1);
	var myfilter2 = new filterlist(document.form1.userID, document.form1.searchField2);
<%	} %>

	$().ready(function() {
		$('#add').click(function() {
			return !$('#select1 option:selected').appendTo('#select2');
		});
		$('#remove').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});

<%	if (isLevel0Group) { %>
		$('#add2').click(function() {
			return !$('#userIDSelect1 option:selected').appendTo('#userIDSelect2');
		});
		$('#remove2').click(function() {
			return !$('#userIDSelect2 option:selected').appendTo('#userIDSelect1');
		});
<%	} %>
	});

	$('form').submit(function() {
		$('#select2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
<%	if (isLevel0Group) { %>
		$('#userIDSelect2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
<%	} %>
	});

	function submitAction(cmd, stp) {
<%	if (updateAction) { %>
		if (cmd == 'update') {
			selectItem('form1', 'functionID');
<%		if (isLevel0Group) { %>
			selectItem('form1', 'userID');
<%		} %>
		checkSelectEmpty();
		}
<%	} %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

<%	if (updateAction) { %>
		removeDuplicateItem('form1', 'functionIDAvailable', 'functionID');
<%		if (isLevel0Group) { %>
			removeDuplicateItem('form1', 'userIDAvailable', 'userID');
<%		} %>

		function checkSelectEmpty() {
			f2 = document.getElementById("select2");
			var f_count = 0;
			if (f2) {
				for (i = 0; i < f2.length; i++ ) {
					if (f2.options[i] && f2.options[i].selected) {
						f_count++;
					}
				}
			}
			if (f_count == 0) {
				document.forms["form1"].elements["select2IsEmpty"].value = "Y";
			}
<%	if (isLevel0Group) { %>

			u2 = document.getElementById("userIDSelect2");
			var u_count = 0;
			if (u2) {
				for (i = 0; i < u2.length; i++ ) {
					if (u2.options[i] && u2.options[i].selected) {
						u_count++;
					}
				}
			}
			if (u_count == 0) {
				document.forms["form1"].elements["userIDSelect2IsEmpty"].value = "Y";
			}
<%	} %>
		}
<%	} %>


</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>