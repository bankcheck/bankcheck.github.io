<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*" %>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String ssoUserId = ParserUtil.getParameter(request, "ssoUserId");
String staffNo = ParserUtil.getParameter(request, "staffNo");
String firstName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "firstName"));
String lastName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "lastName"));
String givenName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "givenName"));
String displayName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "displayName"));
String cnFirstName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cnFirstName"));
String cnLastName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cnLastName"));
String mobilePhoneNo = ParserUtil.getParameter(request, "mobilePhoneNo");
String homePhoneNo = ParserUtil.getParameter(request, "homePhoneNo");
String officePhoneNo = ParserUtil.getParameter(request, "officePhoneNo");
String pagerNo = ParserUtil.getParameter(request, "pagerNo");
String qual = ParserUtil.getParameter(request, "qual");
String userType = ParserUtil.getParameter(request, "userType");
String enabled = ParserUtil.getParameter(request, "enabled");

String moduleCode = ParserUtil.getParameter(request, "moduleCode");
String moduleUserId = ParserUtil.getParameter(request, "moduleUserId");

ArrayList mappings = null;

boolean createAction = false;
boolean updateAction = false;
boolean updateMappingAction = false;
boolean insertMappingAction = false;
boolean deleteMappingAction = false;
boolean deleteAction = false;
boolean enableAction = false;
boolean viewByStaffIDAction = false;
boolean success = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("updateMapping".equals(command)) {
	updateMappingAction = true;
} else if ("insertMapping".equals(command)) {
	insertMappingAction = true;
} else if ("deleteMapping".equals(command)) {
	deleteMappingAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("enable".equals(command)) {
	enableAction = true;	
} else if ("viewByStaffID".equals(command)) {
	viewByStaffIDAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction) {
			if (SsoUserDB.add(userBean, ssoUserId, staffNo, 
					firstName, lastName, givenName, displayName,
					cnFirstName, cnLastName, 
					mobilePhoneNo, homePhoneNo, officePhoneNo, pagerNo,
					qual, userType)) {
				message = "SSO user created.";
				createAction = false;
				step = null;
			} else {
				errorMessage = "SSO user create fail.";
			}
		} else if (updateAction) {
			if (SsoUserDB.update(userBean, ssoUserId, staffNo, 
					firstName, lastName, givenName, displayName,
					cnFirstName, cnLastName, 
					mobilePhoneNo, homePhoneNo, officePhoneNo, pagerNo,
					qual, userType)) {
				message = "SSO user updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "SSO user update fail.";
			}
		} else if (deleteAction) {
			if (SsoUserDB.delete(userBean, ssoUserId)) {
				message = "SSO user and mapping disabled.";
				deleteAction = false;
				step = null;
			} else {
				errorMessage = "SSO user and mapping disable fail.";
			}
		} else if (enableAction) {
			if (SsoUserDB.enableSsoUser(userBean, ssoUserId)) {
				message = "SSO user and disabled mapping enabled.";
				enableAction = false;
				step = null;
			} else {
				errorMessage = "SSO user and disabled mapping enable fail.";
			}
		} else if (updateMappingAction) {
			if (SsoUserDB.updateSsoMappingModuleUserId(userBean, ssoUserId, moduleCode, moduleUserId)) {
				message = "SSO user mapping updated.";
				updateMappingAction = false;
				step = null;
			} else {
				errorMessage = "SSO user mapping update fail.";
			}
		} else if (insertMappingAction) {
			if (SsoUserDB.insertSsoMapping(userBean, ssoUserId, moduleCode, moduleUserId)) {
				message = "SSO user mapping saved.";
				insertMappingAction = false;
				step = null;
			} else {
				errorMessage = "SSO user mapping save fail.";
			}
		} else if (deleteMappingAction) {
			if (SsoUserDB.deleteSsoMapping(userBean, ssoUserId, moduleCode, moduleUserId)) {
				message = "SSO user mapping deleted.";
				deleteMappingAction = false;
				step = null;
			} else {
				errorMessage = "SSO user mapping delete fail.";
			}
		}
	} else {
		if (createAction) {
			ssoUserId = "";
			staffNo = "";
			firstName = "";
			lastName = "";
			givenName = "";
			displayName = "";
			cnFirstName = "";
			cnLastName = "";
			mobilePhoneNo = "";
			homePhoneNo = "";
			officePhoneNo = "";
			pagerNo = "";
			qual = "";
			userType = "";
			enabled = "";
		}
	}

	if (!createAction) {
		// load user information
		if (viewByStaffIDAction) {
			ssoUserId = SsoUserDB.getSsoUserIdByStaffNo(staffNo);
		}
		
		if (ssoUserId != null && ssoUserId.length() > 0) {
			ArrayList record = SsoUserDB.getSsoUserBySsoUserId(ssoUserId);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				ssoUserId = row.getValue(0);
				staffNo = row.getValue(1);
				firstName = row.getValue(2);
				lastName = row.getValue(3);
				givenName = row.getValue(4);
				displayName = row.getValue(5);
				cnFirstName = row.getValue(6);
				cnLastName = row.getValue(7);
				mobilePhoneNo = row.getValue(8);
				homePhoneNo = row.getValue(9);
				officePhoneNo = row.getValue(10);
				pagerNo = row.getValue(11);
				qual = row.getValue(12);
				userType = row.getValue(13);
				enabled = row.getValue(14);
				
				// load sso user mapping
				mappings = SsoUserDB.getMappingList(ssoUserId);
				if (insertMappingAction && "0".equals(step)) {
					if (mappings == null) {
						mappings = new ArrayList();
					}
					int columnSize = 4;
					ReportableListObject rlo = new ReportableListObject(columnSize);
					for (int i = 0; i < columnSize; i++) {
						rlo.setValue(i, "");
					}
					mappings.add(rlo);
					
					moduleCode = "";
					moduleUserId = "";
				}
				request.setAttribute("mappings", mappings);
				
				success = true;
			} else {
				errorMessage = MessageResources.getMessage(session, "error.user.notExist");
			}
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
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
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.ssoUser." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<%if (createAction || success) { %>
<form name="UserForm" method="post" action="user.jsp">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">User SSO Information</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">SSO User Id</td>
		<td class="infoData" width="80%">
<%	if (createAction) { %>
			<html:text property="ssoUserId" value="<%=ssoUserId%>" maxlength="30" size="17" />
<%	} else { %>
			<%=ssoUserId %><input type="hidden" name="ssoUserId" value="<%=ssoUserId %>" />
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Staff No.</td>
		<td class="infoData" width="80%">
<%	if (createAction || updateAction) { %>
			<html:text property="staffNo" value="<%=staffNo%>" maxlength="30" size="17" />
<%	} else { %>
			<%=staffNo %><input type="hidden" name="staffNo" value="<%=staffNo %>" />
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Enabled</td>
		<td class="infoData" width="70%">
<%		if ("1".equals(enabled)) { %>
			<font color="green">Yes</font>
<%		} else { %>
			<font color="red">No</font>
<%		} %>
			<input type="hidden" name="enabled" value="<%=enabled %>">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="2">User Details</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.name" /></td>
		<td width="80%">
			<table cellpadding="0" cellspacing="3"
	class="contentFrameMenu" border="0">
				<tr class="smallText">
					<td class="infoLabel" width="20%"><bean:message key="prompt.displayName" /></td>
					<td class="infoData" width="20%" colspan="5">
			<%	if (createAction || updateAction) { %>
						<html:text property="displayName" value="<%=displayName%>" maxlength="120" size="80" />
			<%	} else { %>
						<%=displayName %>
			<%	} %>
					</td>
				</tr>
				<tr class="smallText">
					<td class="infoLabel" width="20%"><bean:message key="prompt.lastName" /></td>
					<td class="infoData" width="15%">
			<%	if (createAction || updateAction) { %>
						<html:text property="lastName" value="<%=lastName%>" maxlength="30" size="17" />
			<%	} else { %>
						<%=lastName %>
			<%	} %>
					</td>
					
					<td class="infoLabel" width="15%"><bean:message key="prompt.firstName" /></td>
					<td class="infoData" width="20%">
			<%	if (createAction || updateAction) { %>
						<html:text property="firstName" value="<%=firstName%>" maxlength="60" size="17" />
			<%	} else { %>
						<%=firstName %>
			<%	} %>
					</td>
					
					<td class="infoLabel" width="15%"><bean:message key="prompt.givenName" /></td>
					<td class="infoData" width="20%">
			<%	if (createAction || updateAction) { %>
						<html:text property="givenName" value="<%=givenName%>" maxlength="60" size="17" />
			<%	} else { %>
						<%=givenName %>
			<%	} %>
					</td>
				</tr>
				<tr class="smallText">
					<td class="infoLabel"><bean:message key="prompt.cnLastName" /></td>
					<td class="infoData">
			<%	if (createAction || updateAction) { %>
						<html:text property="cnLastName" value="<%=cnLastName%>" maxlength="30" size="17" />
			<%	} else { %>
						<%=cnLastName %>
			<%	} %>
					</td>
					<td class="infoLabel"><bean:message key="prompt.cnFirstName" /></td>
					<td class="infoData">
			<%	if (createAction || updateAction) { %>
						<html:text property="cnFirstName" value="<%=cnFirstName%>" maxlength="30" size="17" />
			<%	} else { %>
						<%=cnFirstName %>
			<%	} %>
					</td>
					<td></td>
					<td></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.phoneNoOrExt" /></td>
		<td width="80%">
			<table cellpadding="0" cellspacing="3"
	class="contentFrameMenu" border="0">
				<tr class="smallText">
					<td class="infoLabel" width="20%"><bean:message key="prompt.mobilePhone" /></td>
					<td class="infoData" width="20%">
			<%	if (createAction || updateAction) { %>
						<html:text property="mobilePhoneNo" value="<%=mobilePhoneNo%>" maxlength="30" size="17" />
			<%	} else { %>
						<%=mobilePhoneNo %>
			<%	} %>
					</td>
					<td class="infoLabel" width="20%"><bean:message key="prompt.homePhone" /></td>
					<td class="infoData" width="20%">
			<%	if (createAction || updateAction) { %>
						<html:text property="homePhoneNo" value="<%=homePhoneNo%>" maxlength="30" size="17" />
			<%	} else { %>
						<%=homePhoneNo %>
			<%	} %>
					</td>
				</tr>
				<tr class="smallText">
					<td class="infoLabel" width="20%"><bean:message key="prompt.officePhone" /></td>
					<td class="infoData" width="20%">
			<%	if (createAction || updateAction) { %>
						<html:text property="officePhoneNo" value="<%=officePhoneNo%>" maxlength="30" size="17" />
			<%	} else { %>
						<%=officePhoneNo %>
			<%	} %>
					</td>
					<td class="infoLabel" width="20%"><bean:message key="prompt.pager" /></td>
					<td class="infoData" width="20%">
			<%	if (createAction || updateAction) { %>
						<html:text property="pagerNo" value="<%=pagerNo%>" maxlength="30" size="17" />
			<%	} else { %>
						<%=pagerNo %>
			<%	} %>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="label.others" /></td>
		<td width="80%">
			<table cellpadding="0" cellspacing="3"
	class="contentFrameMenu" border="0">
				<tr class="smallText">
				
		<td class="infoLabel" width="20%"><bean:message key="prompt.qual" /></td>
		<td class="infoData" width="20%">
<%	if (createAction || updateAction) { %>
			<html:text property="qual" value="<%=qual%>" maxlength="30" size="17" />
<%	} else { %>
			<%=qual %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.userType" /></td>
		<td class="infoData" width="20%">
<%	if (createAction || updateAction) { %>
			<html:text property="userType" value="<%=userType%>" maxlength="100" size="30" />
<%	} else { %>
			<%=userType %>
<%	} %>
		</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td colspan="2">
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
							<%if (userBean.isAccessible("function.ssoUser.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.ssoUser.update" /></button><%} %>
							<%if (userBean.isAccessible("function.ssoUser.delete") && !"0".equals(enabled)) { %><button class="btn-delete">Disable SSO User</button><%} %>
							<%if (userBean.isAccessible("function.ssoUser.create") && "0".equals(enabled)) { %><button onclick="return submitAction('enable', 1);"  class="btn-click">Enable SSO User and mappings</button><%} %>
							<%if (userBean.isAccessible("function.ssoUser.delete") && !"0".equals(enabled) && ConstantsServerSide.DEBUG) { %><button onclick="return submitAction('delete', 1);" class="btn-click">Disable SSO User (no confirm)</button><%} %>
				<%	}  %>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
<%	if (!createAction) { %>	
	<tr class="smallText">
		<td class="infoTitle" colspan="2">User Mapping</td>
	</tr>
	<tr>
		<td colspan="2">
			<div class="pane">
				<table width="100%" border="0">
					<tr class="smallText">
						<td align="left">
							<button onclick="return submitActionMapping('insertMapping', 0);" class="btn-click" <% if (!"1".equals(enabled)) { %>disabled="disabled"<% } %>><bean:message key="button.add" /></button>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2">
<bean:define id="functionLabel"><bean:message key="function.ssoUser.mapping.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<% if (mappings != null && !mappings.isEmpty()) { %>
<display:table id="row" name="requestScope.mappings" export="false" class="tablesorter">
<%
	String thisModuleCode = ((ReportableListObject)pageContext.getAttribute("row")).getFields1();
	String thisModuleUserId = ((ReportableListObject)pageContext.getAttribute("row")).getFields3();
	boolean isUpdate = (thisModuleCode != null && thisModuleCode.equals(moduleCode)) && 
			(thisModuleUserId != null && thisModuleUserId.equals(moduleUserId));
%>
	<display:column title="Module (Code)" style="width:15%">
<%			if ((insertMappingAction) && isUpdate) { %>
			<select name="moduleCode">
<jsp:include page="../ui/ssoModuleCodeCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="<%=moduleCode %>" />
</jsp:include>
			</select>
<%			} else {  %>
		<c:out value="${row.fields2}" /> (<c:out value="${row.fields1}" />) 
<%			}  %>
	</display:column>
	<display:column title="Module User Id" style="width:15%">
<%			if ((insertMappingAction || updateMappingAction) && isUpdate) { %>
		<html:text property="moduleUserId" value="<%=thisModuleUserId %>" maxlength="30" size="17" />
<%			} else {  %>
		<c:out value="${row.fields3}" />
<%			}  %>
	</display:column>
	<display:column title="Action" style="width:10%" media="html">
<%			
		if (insertMappingAction) {
			commandType = "insertMapping";
		} else if (updateMappingAction) {
			commandType = "updateMapping";
		}

		if ((insertMappingAction || updateMappingAction) && isUpdate) { %>
	<%if (userBean.isAccessible("function.ssoUser.update")) { %><button onclick="return submitActionMapping('<%=commandType %>', 1, '<c:out value="${row.fields1}" />', '<c:out value="${row.fields3}" />');" class="btn-click"><bean:message key="button.save" /></button><% } %>
	<button onclick="return submitAction('view', 0, '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} else { %>
	<%if (userBean.isAccessible("function.ssoUser.update")) { %><button onclick="return submitActionMapping('updateMapping', 0, '<c:out value="${row.fields1}" />', '<c:out value="${row.fields3}" />');" class="btn-click"><bean:message key="button.update" /></button><% } %>
	<%if (userBean.isAccessible("function.ssoUser.delete")) { %><button onclick="return submitActionMapping('deleteMapping', 2, '<c:out value="${row.fields1}" />', '<c:out value="${row.fields3}" />');" class="btn-click"><bean:message key="button.delete" /></button><% } %>
<%		}  %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} %>
		</td>
	</tr>
<%	} %>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="moduleCode" />
<input type="hidden" name="moduleUserId" />
</form>
<bean:define id="loginIDLabel"><bean:message key="prompt.loginID" /></bean:define>
<bean:define id="lastNameLabel"><bean:message key="prompt.lastName" /></bean:define>
<bean:define id="firstNameLabel"><bean:message key="prompt.firstName" /></bean:define>
<script language="javascript">
	// validate signup form on keyup and submit

<%	if (createAction || updateAction) { %>
	$("#UserForm").validate({
		rules: {
<%		if (createAction) { %>
			ssoUserId: { required: true },
			staffNo: { required: true }
<%		} %>		
		},
		messages: {
<%		if (createAction) { %>
			ssoUserId: { required: "<bean:message key="error.loginID.required" />" },
			staffNo: { required: true }
<%		} %>
		}
	});
<%	} %>

	function submitAction(cmd, stp) {
		document.forms["UserForm"].elements["command"].value = cmd;
		document.forms["UserForm"].elements["step"].value = stp;
		document.forms["UserForm"].submit();
		return false;
	}
	
	function submitActionMapping(cmd, stp, mcode, muid) {
		if (cmd == 'deleteMapping' && stp == 2) {
			$(".pane").animate({ backgroundColor: "#fbc7c7" }, "fast")
			.animate({ backgroundColor: "#F9F3F7" }, "slow");
			$.prompt('<bean:message key="message.record.delete" />!',{
				buttons: { Ok: true, Cancel: false },
				callback: function(v,m,f){
					if (v){
						submit: submitActionMapping(cmd, '1', mcode, muid);
						return true;
					} else {
						return false;
					}
				},
				prefix:'cleanblue'
			});
			return false;
		}
		
		document.forms["UserForm"].elements["command"].value = cmd;
		document.forms["UserForm"].elements["step"].value = stp;
		document.forms["UserForm"].elements["moduleCode"].value = mcode;
		document.forms["UserForm"].elements["moduleUserId"].value = muid;
		document.forms["UserForm"].submit();
		return false;
	}
</script>
<% } %>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp"/>
</body>
</html:html>
