<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList fetchUserGroup() {
		// fetch group
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_GROUP_ID, CO_GROUP_DESC ");
		sqlStr.append("FROM   CO_GROUPS ");
		sqlStr.append("WHERE  CO_GROUP_LEVEL > 0 ");
		sqlStr.append("ORDER BY CO_GROUP_LEVEL ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList fetchFunction() {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT AC_FUNCTION_ID, AC_FUNCTION_DESC ");
		sqlStr.append("FROM   AC_FUNCTION ");
		sqlStr.append("WHERE  AC_ENABLED = 1 ");
		sqlStr.append("ORDER BY AC_FUNCTION_ID, AC_GROUP_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList fetchNoLevelGroup() {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_GROUP_ID, CO_GROUP_DESC ");
		sqlStr.append("FROM   CO_GROUPS ");
		sqlStr.append("WHERE  CO_GROUP_LEVEL = 0 ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY CO_GROUP_DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
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
String userName = request.getParameter("userName");
String password = request.getParameter("password");
String lastName = request.getParameter("lastName");
String firstName = request.getParameter("firstName");
String emailPrefix = request.getParameter("emailPrefix");
String emailSuffix = request.getParameter("emailSuffix");
int index = 0;
String email = null;
String siteCode = request.getParameter("siteCode");
String staffID = request.getParameter("staffID");
String enabled = request.getParameter("enabled");

String groupName = request.getParameter("groupName");
String groupDesc = null;
if (groupName == null) groupName = "guest";
if (groupName != null) {
	groupDesc = groupName.substring(0, 1).toUpperCase() + groupName.substring(1);
}
String functionID[] = request.getParameterValues("functionID");
String functionDesc[] = null;
String functionIDAvailable[] = null;
String functionDescAvailable[] = null;

String noLevelGroupID[] = request.getParameterValues("noLevelGroupID");
String noLevelGroupDesc[] = null;
String noLevelGroupIDAvailable[] = null;
String noLevelGroupDescAvailable[] = null;

boolean loginAction = false;
boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean success = false;

if ("login".equals(command) && (userBean.isAdmin() || userBean.isGroupID("managerPortal.user"))) {
	loginAction = true;
} else if ("create".equals(command) || !userBean.isLogin()) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if (!"1".equals(step) && createAction) {
		userName = "";
		password = "";
		lastName = "";
		firstName = "";
		emailPrefix = "";
		emailSuffix = ConstantsServerSide.SITE_CODE + ".org.hk";
		siteCode = ConstantsServerSide.SITE_CODE;
		staffID = "";
		enabled = "1";
	}

	// load data from database
	if (createAction || updateAction) {
		ArrayList record = fetchFunction();
		if (record.size() > 0) {
			functionIDAvailable = new String[record.size()];
			functionDescAvailable = new String[record.size()];
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				functionIDAvailable[i] = row.getValue(0);
				functionDescAvailable[i] = row.getValue(1);
			}
		} else {
			functionIDAvailable = null;
		}

		record = fetchNoLevelGroup();
		if (record.size() > 0) {
			noLevelGroupIDAvailable = new String[record.size()];
			noLevelGroupDescAvailable = new String[record.size()];
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				noLevelGroupIDAvailable[i] = row.getValue(0);
				noLevelGroupDescAvailable[i] = row.getValue(1);
			}
		} else {
			noLevelGroupIDAvailable = null;
		}
	}

	if (!createAction) {
		// change login id
		if (loginAction && staffID != null && staffID.length() > 0) {
			UserBean userBean2 = UserDB.getUserBeanSkipPasswordByStaffID(request, staffID);
			if (userBean2 == null) {
				%><script>alert('Fail to switch <%=staffID %>!');</script><%
			}
		}

		// load user information
		if (userName != null && userName.length() > 0) {
			ArrayList record = UserDB.get(userName, enabled);
			String thisUserName = null;
			if (record.size() > 0) {
				int j = 0;
				ReportableListObject row = (ReportableListObject) record.get(j);
				thisUserName = row.getValue(1);
				// get same username if more than 1 records share same staff ID
				while (j < record.size()) {
					row = (ReportableListObject) record.get(j);
					thisUserName = row.getValue(1);
					if (thisUserName.equals(userName)) {
						j = record.size();
					} else {
						j++;
					}
				}
				siteCode = row.getValue(0);
				userName = row.getValue(1);
				password = "";
				lastName = row.getValue(2);
				firstName = row.getValue(3);
				email = row.getValue(4);
				if ((index = email.indexOf("@")) > 0) {
					emailPrefix = email.substring(0, index);
					emailSuffix = email.substring(index + 1);
				} else {
					emailPrefix = "";
					emailSuffix = ConstantsServerSide.SITE_CODE + ".org.hk";
				}
				staffID = row.getValue(5);
				enabled = row.getValue(8);
				groupName = row.getValue(6);
				groupDesc = row.getValue(7);

				// load access function
				StringBuffer sqlStr = new StringBuffer();
				sqlStr.append("SELECT AF.AC_FUNCTION_ID, AF.AC_FUNCTION_DESC ");
				sqlStr.append("FROM   AC_FUNCTION_ACCESS AC, AC_FUNCTION AF ");
				sqlStr.append("WHERE  AC.AC_FUNCTION_ID = AF.AC_FUNCTION_ID ");
				sqlStr.append("AND    AC.AC_SITE_CODE = ? ");
				sqlStr.append("AND    AC.AC_STAFF_ID = ? ");
				sqlStr.append("AND    AF.AC_ENABLED = 1 ");
				sqlStr.append("ORDER BY AF.AC_FUNCTION_ID, AF.AC_GROUP_ID");

				record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { siteCode, staffID });
				if (record.size() > 0) {
					functionID = new String[record.size()];
					functionDesc = new String[record.size()];
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						functionID[i] = row.getValue(0);
						functionDesc[i] = row.getValue(1);
					}
				} else {
					functionID = null;
				}

				sqlStr.setLength(0);
				sqlStr.append("SELECT G.CO_GROUP_ID, G.CO_GROUP_DESC ");
				sqlStr.append("FROM   AC_USER_GROUPS AUG, CO_GROUPS G ");
				sqlStr.append("WHERE  AUG.AC_GROUP_ID = G.CO_GROUP_ID ");
				sqlStr.append("AND    AUG.AC_SITE_CODE = ? ");
				sqlStr.append("AND    AUG.AC_STAFF_ID = ? ");
				sqlStr.append("AND    AUG.AC_ENABLED = 1 ");
				sqlStr.append("ORDER BY G.CO_GROUP_ID");

				record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { siteCode, staffID });
				if (record.size() > 0) {
					noLevelGroupID = new String[record.size()];
					noLevelGroupDesc = new String[record.size()];
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						noLevelGroupID[i] = row.getValue(0);
						noLevelGroupDesc[i] = row.getValue(1);
					}
				} else {
					noLevelGroupID = null;
				}

				success = true;
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
	String mustLogin = "Y";
	if (createAction) {
		commandType = "create";
		// can create by guest
		mustLogin = "N";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.user." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="mustLogin" value="<%=mustLogin %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="red"><html:errors/></font>
<font color="blue"><html:messages id="messages" message="true"><bean:write name="messages"/></html:messages></font>
<%if (createAction || success) { %>
<html:form action="/User.do">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.data.login" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.loginID" /></td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
			<html:text style="text-transform: uppercase" property="userName" value="<%=userName%>" maxlength="30" size="50" />
<%	} else { %>
			<%=userName %><input type="hidden" name="userName" value="<%=userName %>">
<%	} %>
		</td>
	</tr>
<%	if ((userBean.isAdmin() && createAction) || updateAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.password" /></td>
		<td class="infoData" width="70%">
			<html:password property="password" value="" maxlength="10" size="30" /><%if (updateAction) {%>(<bean:message key="label.emptyRemindUnchange"/>)<%} %>
		</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.data.user" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<html:text property="lastName" value="<%=lastName%>" maxlength="30" size="50" />
<%	} else { %>
			<%=lastName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<html:text property="firstName" value="<%=firstName%>" maxlength="60" size="50" />
<%	} else { %>
			<%=firstName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.email" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
		<html:text property="emailPrefix" value="<%=emailPrefix %>" maxlength="30" size="30" />@
		<select name="emailSuffix">
			<option value="hkah.org.hk"<%=("hkah.org.hk".equals(emailSuffix))?" selected":"" %>>hkah.org.hk</option>
			<option value="twah.org.hk"<%=("twah.org.hk".equals(emailSuffix))?" selected":"" %>>twah.org.hk</option>
		</select>
<%	} else { %>
		<%=email %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.site" /></td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
<jsp:include page="../ui/siteCodeRDB.jsp" flush="false">
	<jsp:param name="allowAll" value="N" />
	<jsp:param name="siteCode" value="<%=siteCode %>" />
</jsp:include>
<%	} else { %>
		<%if (ConstantsServerSide.SITE_CODE_HKAH.equals(siteCode)) { %><bean:message key="label.hkah" /><%} else if (ConstantsServerSide.SITE_CODE_TWAH.equals(siteCode)) {%><bean:message key="label.twah" /><%} else {%><%=siteCode%><%} %>
		<input type="hidden" name="siteCode" value="<%=siteCode%>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<html:text style="text-transform: uppercase" property="staffID" value="<%=staffID %>" maxlength="10" size="50" />
<%	} else { %>
			<a href="staff.jsp?staffID=<%=staffID %>&enabled=<%=enabled %>"><%=staffID %></a><html:hidden property="staffID" value="<%=staffID%>" />
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Enabled</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<input type="radio" name="enabled" value="1"<%="1".equals(enabled)?" checked":"" %> />&nbsp;<font color="green">Yes</font>&nbsp;&nbsp;
			<input type="radio" name="enabled" value="0"<%="0".equals(enabled)?" checked":"" %> />&nbsp;<font color="red">No</font>
<%	} else {%>
<%		if ("1".equals(enabled)) { %>
			<font color="green">Yes</font>
<%		} else { %>
			<font color="red">No</font>
<%		} %>
			<input type="hidden" name="enabled" value="<%=enabled %>">
<%	} %>
		</td>
	</tr>
<%	if (userBean.isAuthor()) { %>
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.data.userGroup" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.userGroup" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) { %>
			<select name="groupName">
<%
			ArrayList record = fetchUserGroup();
			ReportableListObject row = null;
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(groupName)?" selected":"" %>><%=row.getValue(1) %></option><%
				}
			}
%></select>
<%		} else { %>
			<a href="access_control.jsp?command=view&userRoleID=<%=groupName %>"><%=groupDesc %></a>
<%		} %>
		</td>
	</tr>
<%		if (userBean.isAccessible("function.accessControl.view")) { %>
	<input type="hidden" name="hasFunctionID" value="Y">
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.access" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.function" /></td>
		<td class="infoData" width="70%">
<%			if (userBean.isAccessible("function.accessControl.update") && (createAction || updateAction)) { %>
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
%><option value="<%=functionIDAvailable[i] %>"><%=functionDescAvailable[i] %></option><%
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
%><option value="<%=functionID[i] %>"><%=functionDesc[i] %></option><%
					}
				} %>
						</select>
					</td>
				</tr>
			</table>
<%			} else {
				if (functionID != null) {
					for (int i = 0; i < functionID.length; i++) {
%><%=functionDesc[i] %><br/><%
					}
				}
			} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.groups" /></td>
		<td class="infoData" width="70%">
<%			if (userBean.isAccessible("function.accessControl.update") && (createAction || updateAction)) { %>
			<table border="0">
				<tr>
					<td><bean:message key="prompt.groupsAvailable" /></td>
					<td>&nbsp;</td>
					<td><bean:message key="prompt.groupsSelected" /></td>
				</tr>
				<tr>
					<td>
						<select name="noLevelGroupIDAvailable" size="10" multiple id="noLevelGroupIDSelect1">
<%				if (noLevelGroupIDAvailable != null) {
					for (int i = 0; i < noLevelGroupIDAvailable.length; i++) {
%>
							<option value="<%=noLevelGroupIDAvailable[i] %>">
<%
						try {
%><bean:message key="<%=noLevelGroupDescAvailable[i] %>" /><%
						} catch (Exception e) {
%><%=noLevelGroupDescAvailable[i] %><%
						}
%>
							</option>
<%
					}
				} %>
						</select>
					</td>
					<td>
						<button id="add2"><bean:message key="button.add" /> &gt;&gt;</button><br>
						<button id="remove2">&lt;&lt; <bean:message key="button.delete" /></button>
					</td>
					<td>
						<select name="noLevelGroupID" size="10" multiple id="noLevelGroupIDSelect2">
<%				if (noLevelGroupID != null) {
					for (int i = 0; i < noLevelGroupID.length; i++) {
%>
							<option value="<%=noLevelGroupID[i] %>">
<%
						try {
%><bean:message key="<%=noLevelGroupDesc[i] %>" /><%
						} catch (Exception e) {
%><%=noLevelGroupDesc[i] %><%
						}
%>
							</option>
<%
					}
				}
				%>
						</select>
					</td>
				</tr>
			</table>
<%			} else {
				if (noLevelGroupID != null) {
					for (int i = 0; i < noLevelGroupID.length; i++) {
						try {
%><a href="access_control.jsp?command=view&userRoleID=<%=noLevelGroupID[i] %>"><bean:message key="<%=noLevelGroupDesc[i] %>" /></a><br/><%
						} catch (Exception e) {
%><a href="access_control.jsp?command=view&userRoleID=<%=noLevelGroupID[i] %>"><%=noLevelGroupDesc[i] %></a><br/><%
						}
					}
				}
			} %>
			<input type="hidden" name="noLevelGroupIDSelect2IsEmpty" value="N" />
			<input type="hidden" name="select2IsEmpty" value="N" />
		</td>
	</tr>
<%		}
	} %>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
<%		if (updateAction || deleteAction) { %>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		} %>
<%	} else { %>
			<%if (userBean.isAccessible("function.user.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.user.update" /></button><%} %>
			<%if (userBean.isAccessible("function.user.delete")) { %><button class="btn-delete"><bean:message key="function.user.delete" /></button><%} %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
</html:form>
<bean:define id="loginIDLabel"><bean:message key="prompt.loginID" /></bean:define>
<bean:define id="lastNameLabel"><bean:message key="prompt.lastName" /></bean:define>
<bean:define id="firstNameLabel"><bean:message key="prompt.firstName" /></bean:define>
<script language="javascript">
	$().ready(function() {
		$('#add').click(function() {
			return !$('#select1 option:selected').appendTo('#select2');
		});
		$('#remove').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});

		$('#add2').click(function() {
			return !$('#noLevelGroupIDSelect1 option:selected').appendTo('#noLevelGroupIDSelect2');
		});
		$('#remove2').click(function() {
			return !$('#noLevelGroupIDSelect2 option:selected').appendTo('#noLevelGroupIDSelect1');
		});
	});

	$('UserForm').submit(function() {
		$('#select2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});

		$('#noLevelGroupIDSelect2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
	});

	// validate signup form on keyup and submit
	$("#UserForm").validate({
		rules: {
<%	if (createAction) { %>
			userName: { required: true, minlength: 5 },
<%	} %>
			lastName: { required: true, minlength: 2 },
			firstName: { required: true, minlength: 2 }
		},
		messages: {
<%	if (createAction) { %>
			userName: { required: "<bean:message key="error.loginID.required" />", minlength: "<bean:message key="errors.minlength" arg0="<%=loginIDLabel %>" arg1="5" />" },
<%	} %>
			lastName: { required: "<bean:message key="error.lastName.required" />", minlength: "<bean:message key="errors.minlength" arg0="<%=lastNameLabel %>" arg1="2" />" },
			firstName: { required: "<bean:message key="error.firstName.required" />", minlength: "<bean:message key="errors.minlength" arg0="<%=firstNameLabel %>" arg1="2" />" }
		}
	});

	function submitAction(cmd, stp) {
		if (cmd == 'create' || cmd == 'update') {
<%	if (createAction || updateAction) { %>
<%		if (createAction) { %>
			if (document.forms["UserForm"].elements["userName"].value == "") {
				alert("<bean:message key="error.loginID.required" />");
				document.forms["UserForm"].elements["userName"].focus();
				return false;
			}
			if (document.forms["UserForm"].elements["userName"].value.length < 2) {
				alert("<bean:message key="errors.minlength" arg0="<%=loginIDLabel %>" arg1="5" />");
				document.forms["UserForm"].elements["userName"].focus();
				return false;
			}
<%		} %>
			if (document.forms["UserForm"].elements["lastName"].value == "") {
				alert("<bean:message key="error.lastName.required" />");
				document.forms["UserForm"].elements["lastName"].focus();
				return false;
			}
			if (document.forms["UserForm"].elements["lastName"].value.length < 2) {
				alert("<bean:message key="errors.minlength" arg0="<%=lastNameLabel %>" arg1="2" />");
				document.forms["UserForm"].elements["lastName"].focus();
				return false;
			}
			if (document.forms["UserForm"].elements["firstName"].value == "") {
				alert("<bean:message key="error.firstName.required" />");
				document.forms["UserForm"].elements["firstName"].focus();
				return false;
			}
			if (document.forms["UserForm"].elements["firstName"].value.length < 2) {
				alert("<bean:message key="errors.minlength" arg0="<%=firstNameLabel %>" arg1="2" />");
				document.forms["UserForm"].elements["firstName"].focus();
				return false;
			}
<%		if (userBean.isAuthor()) { %>
			selectItem('UserForm', 'functionID');
			selectItem('UserForm', 'noLevelGroupID');
<%		} %>
<%	} %>
		}

		checkSelectEmpty();

		document.forms["UserForm"].elements["command"].value = cmd;
		document.forms["UserForm"].elements["step"].value = stp;
		document.forms["UserForm"].submit();
	}

<%	if (updateAction) { %>
		removeDuplicateItem('UserForm', 'functionIDAvailable', 'functionID');
		removeDuplicateItem('UserForm', 'noLevelGroupIDAvailable', 'noLevelGroupID');
<%	} %>


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
		document.forms["UserForm"].elements["select2IsEmpty"].value = "Y";
	}

	g2 = document.getElementById("noLevelGroupIDSelect2");
	var g_count = 0;
	if (g2) {
		for (i = 0; i < g2.length; i++ ) {
			if (g2.options[i] && g2.options[i].selected) {
				g_count++;
			}
		}
	}
	if (g_count == 0) {
		document.forms["UserForm"].elements["noLevelGroupIDSelect2IsEmpty"].value = "Y";
	}
}
</script>
<%} %>
<bean:define id="functionLabel"><bean:message key="function.user.list" /></bean:define>
<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
<%if (!userBean.isAdmin()) { %>
<br/>
<a class="button" href="<html:rewrite page="/index.jsp" />" onclick="this.blur();"><span><bean:message key="prompt.backTo" /> <bean:message key="prompt.loginPage" /></span></a>
<%} %>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp"/>
</body>
</html:html>