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
		sqlStr.append("AND	  CO_GROUP_ID = 'guest' ");
		
		sqlStr.append("ORDER BY CO_GROUP_LEVEL ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	
	private String getNextClientUserID(){
		String clientID = null;
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  (COUNT(U.CO_USERNAME) )+1 ");
		sqlStr.append("FROM   CO_USERS U ");		
		sqlStr.append("WHERE    U.CO_STAFF_YN = 'N' ");		
		sqlStr.append("ORDER BY U.CO_USERNAME ");
		
		//System.out.println(sqlStr.toString());
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			clientID = reportableListObject.getValue(0);

			// set 1 for initial
			if (clientID == null || clientID.length() == 0) {
				clientID = "1";
			}
		}
		
		//String formatString = String.format("%%0%dd", 7);		
		//String formattedString = String.format(formatString,Integer.parseInt(clientID));
		
		String formattedString = "LMC"+clientID;
		return formattedString;
	}
	
	private ArrayList getCRMClientLevel(String clientID) {			
		return  UtilDBWeb.getReportableList("SELECT CRM_NS_LEVEL FROM CRM_CLIENTS_NEWSTART WHERE CRM_CLIENT_ID = "+clientID+" AND CRM_NS_LEVEL IS NOT NULL ");
				
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
String email = request.getParameter("email");
String siteCode = request.getParameter("siteCode");
String staffID = request.getParameter("staffID");
String groupName = request.getParameter("groupName");
String groupDesc = null;
if (groupName == null) groupName = "guest";
if (groupName != null) {
	groupDesc = groupName.substring(0, 1).toUpperCase() + groupName.substring(1);
}
String cID = request.getParameter("clientID");
String level = request.getParameter("level");

boolean loginAction = false;
boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean success = false;

if ("login".equals(command) && userBean.isAdmin()) {
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
		siteCode = ConstantsServerSide.SITE_CODE;		
	}

	// load data from database
	

	if (!createAction) {
		// change login id
		if (loginAction && staffID != null && staffID.length() > 0) {
			userBean = UserDB.getUserBean(request, staffID);
		}

		// load user information
		if (userName != null && userName.length() > 0) {
			ArrayList record = UserDB.get(userName);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
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
					emailSuffix = "";
				}
				staffID = row.getValue(5);
				groupName = row.getValue(6);
				groupDesc = row.getValue(7);

				// load access function
							
				success = true;
			}
			
			ArrayList levelRecord = getCRMClientLevel(CRMClientDB.getClientID(userName));
			
			if (levelRecord.size() > 0) {				
				ReportableListObject row = (ReportableListObject) levelRecord.get(0);
				level = row.getValue(0);				
			}else{
				level = "1";
			}
			
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

boolean clientHaveUserName = false;
ArrayList record = CRMClientDB.getClientInfo(cID);
if (record.size() > 0) {
	ReportableListObject row = (ReportableListObject) record.get(0);
	String userID = row.getValue(47);	
	if(userID != null && userID.length() >0){
		clientHaveUserName = true;
	}
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
<% if(clientHaveUserName){%>
<script language="javascript">window.close()</script>
<%} %>
<jsp:include page="../../common/header.jsp"/>
<body>
<jsp:include page="../../common/banner2.jsp"/>
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
	title = "function.crm.user." + commandType;
%>
<jsp:include page="../../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="mustLogin" value="<%=mustLogin %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="red"><html:errors/></font>
<font color="blue"><html:messages id="messages" message="true"><bean:write name="messages"/></html:messages></font>
<%if (createAction || success) { %>
<html:form action="/CRMUser.do">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.data.login" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.loginID" /></td>
		<td class="infoData" width="70%">		
<%	

if (createAction) {
	String clientID = getNextClientUserID();
	
%>
			<%=clientID%><html:text style="display:none" property="userName" value="<%=clientID%>" maxlength="30" size="50" />
<%	} else { %>
			<%=userName %><input type="hidden" name="userName" value="<%=userName %>">
<%	} %>
		</td>
	</tr>
<%	if ((createAction) || updateAction) { %>
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
<%	if ( updateAction) { %>
			<html:text property="lastName" value="<%=lastName%>" maxlength="30" size="50" />
<%	} else { %>
			<%=lastName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="70%">
<%	if ( updateAction) { %>
			<html:text property="firstName" value="<%=firstName%>" maxlength="60" size="50" />
<%	} else { %>
			<%=firstName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.email" /></td>
		<td class="infoData" width="70%">
<%	if ( updateAction) { %>
		<input type="textfield" name="emailPrefix" value="<%=email==null?"":email %>" maxlength="50" size="25" onblur="javascript:checkFirstLevel(this);"><span id="email_indicator"></span>

<%	} else { %>
		<%=email==null?"":email %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.site" /></td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
<jsp:include page="../../ui/siteCodeRDB.jsp" flush="false">
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
		<td class="infoTitle" colspan="2">Log Book Data</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Level</td>
		<td class="infoData" width="70%">
<%	if ( updateAction) { %>
		<select name="level">
<%for(int i = 1;i<6;i++){ %>
  <option <%=(level.equals(Integer.toString(i))?"SELECTED":"") %> value="<%=i%>"><%=i %></option>
<%} %>
</select>
<%	} else { %>
		<%=level==null?"":level %>
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
<%		if (updateAction || deleteAction) { %>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		} %>
<%	} else { %>
			<%if (userBean.isAccessible("function.crm.user.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.crm.user.update" /></button><%} %>
			<%if (userBean.isAccessible("function.crm.user.delete")) { %><!--<button class="btn-delete"><bean:message key="function.crm.user.delete" /></button>  --><%} %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">

<%
	if(createAction){
%>
	<input type="hidden" name="lastName" value="<%=lastName%>">
	<input type="hidden" name="emailPrefix" value="<%=email%>">
	<input type="hidden" name="firstName" value="<%=firstName%>">
	<input type="hidden" name="cID" value="<%=cID%>">
<%
	}
%>
</html:form>
<bean:define id="loginIDLabel"><bean:message key="prompt.loginID" /></bean:define>
<bean:define id="lastNameLabel"><bean:message key="prompt.lastName" /></bean:define>
<bean:define id="firstNameLabel"><bean:message key="prompt.firstName" /></bean:define>
<script language="javascript">
	
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
		
<%	if (createAction || updateAction) { %>
if (cmd == 'create' || cmd == 'update') {
	if (document.forms["UserForm"].elements["lastName"].value == '' && document.forms["UserForm"].elements["firstName"].value == '') {
		alert("either last name or first name is required.");		
		return false;
	}
	if (document.forms["UserForm"].elements["emailPrefix"].value != '') {
		var str =  document.forms["UserForm"].elements["emailPrefix"].value;
		if (str.indexOf(".") < 2 || str.indexOf("@") < 0) {
			alert("invalid syntax for email address");		
			return false;
		}
	}
}
<%	} %>

		document.forms["UserForm"].elements["command"].value = cmd;
		document.forms["UserForm"].elements["step"].value = stp;
		document.forms["UserForm"].submit();
	}
</script>
<%} %>
</DIV>

</DIV></DIV>

<jsp:include page="../../common/footer.jsp"/>
</body>
</html:html>