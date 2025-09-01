<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.commons.io.*"%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	fileUpload = true;
}

UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");

String userid = ParserUtil.getParameter(request, "userid");
String lastname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "lastname"));
String firstname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "firstname"));
String nickname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "nickname"));
String password = ParserUtil.getParameter(request, "password");
String passwordPlain = ParserUtil.getParameter(request, "passwordPlain");
String usertype = ParserUtil.getParameter(request, "usertype");
String phone = ParserUtil.getParameter(request, "phone");
String photo = ParserUtil.getParameter(request, "photo");
String loginstatus = ParserUtil.getParameter(request, "loginstatus");
String deptcode = ParserUtil.getParameter(request, "deptcode");
String portalStaffId = null;
String photoFileName = null;
String photoUrl = null;

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean success = false;

if ("create".equals(command) || !userBean.isLogin()) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

String message = "";
String errorMessage = "";

try {
	if ("1".equals(step)) {
		if (createAction) {
			if (HelpDeskDB.add(userid, firstname, lastname, nickname, passwordPlain, password, usertype, phone, photo, deptcode)) {
				message = "User created.";
				createAction = false;
				step = "0";
			} else {
				errorMessage = "User create fail.";
			}
		} else if (updateAction) {
			if (HelpDeskDB.update(userid, firstname, lastname, nickname, passwordPlain, password, usertype, phone, photo, deptcode)) {
				message = "User updated.";
				updateAction = false;
				step = "0";
			} else {
				errorMessage = "User update fail.";
			}
		} else if (deleteAction) {
			if (HelpDeskDB.delete(userid)) {
				message = "User deleted.";
				closeAction = true;
			} else {
				errorMessage = "User remove fail.";
			}
		}
		
		if (fileUpload) {
			if (userid != null) {
				String[] fileList = (String[]) request.getAttribute("filelist");
				if (fileList != null && fileList.length > 0) {
					String photoId = HelpDeskDB.getDbUUID();
					String photoFName = HelpDeskDB.getDbUUID() + "." + FilenameUtils.getExtension(fileList[0]);

					// only one photo
					FileUtil.moveFile(
						ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[0],
						HelpDeskDB.getPhotoPath(HelpDeskDB.APPCONFIG_KEY_PHOTO_PATH) + photoFName
					);

					if (!HelpDeskDB.updatePhoto(userid, photoId, photoFName)) {
						errorMessage += "Canot upload photo.";
					}
				}
				
			} else {
				errorMessage += "Canot upload photo because there is no User ID.";
			}
		}
	} else if (createAction) {
		// init value
	}

	ReportableListObject row = null; 

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (userid != null && userid.length() > 0) {
			ArrayList record =HelpDeskDB.get(userid);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				userid = row.getValue(0);
				firstname = row.getValue(1);
				lastname = row.getValue(2);
				nickname = row.getValue(3);
				password = row.getValue(4);
				usertype = row.getValue(5);
				phone = row.getValue(6);
				photo = row.getValue(7);
				loginstatus = row.getValue(8);
				deptcode = row.getValue(9);
				portalStaffId = row.getValue(10);
				photoFileName = row.getValue(11);
				photoUrl = row.getValue(12);
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
<style>
img {
    cursor: pointer;
}
</style>
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
	title = "function.helpDesk.user." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" id="form1" enctype="multipart/form-data" action="user.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Login Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">User ID</td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
			<input type="textfield" name="userid" value="<%=userid==null?"":userid %>" maxlength="10" size="50">
<%	} else { %>
			<%=userid==null?"":userid %><input type="hidden" name="userid" value="<%=userid%>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Password</td>
		<td class="infoData" width="70%">
			<div style="margin-bottom: 10px;"><%=password==null?"":password %> (hashed)</div>
<%	if (createAction || updateAction) { %>
			<div><input type="password" name="passwordPlain" value="<%=passwordPlain==null?"":passwordPlain %>" maxlength="100" size="20">(<%=createAction ? "Enter" : "Reset" %> password)</div>
			<div><input type="password" name="passwordPlainConfirm" value="<%=passwordPlain==null?"":passwordPlain %>" maxlength="100" size="20">(Enter again to confirm)</div>
<% } else { %>
<% 	if (portalStaffId != null && !portalStaffId.isEmpty()) { %>
			<button onclick="return submitAction('synPw', '<%=userid %>');">Syn Password from Portal user: <%=portalStaffId %></button>
<%	} %>
<% } %>
			<input type="hidden" name="password" value="<%=password%>" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">User Type</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="usertype">
				<jsp:include page="../ui/helpDeskUserTypeCMB.jsp" flush="false">
					<jsp:param name="userType" value="<%=usertype %>" />
					<jsp:param name="allowEmpty" value="N" />
				</jsp:include>
			</select>
<%	} else { %>
	<% if("0".equals(usertype)) { %>
		Requester
	<% } else if("1".equals(usertype)) { %>
		Supervisor
	<% } else if("2".equals(usertype)) { %>
		Workman
	<% } else if("3".equals(usertype)) { %>
		Administrator
	<% } %>
		(<%=usertype %>)<input type="hidden" name="usertype" value="<%=usertype%>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Login Status</td>
		<td class="infoData" width="70%">
<% if (!createAction) { %>		
			<% if("0".equals(loginstatus)) { %>
				Online
			<% } else if("2".equals(loginstatus)) { %>
				Logged out
			<% } else { %>
				<%=loginstatus %>
			<% } %>
			<input type="hidden" name="loginstatus" value="<%=loginstatus%>" />
			<button onclick="return submitAction('logout', '<%=userid %>');">Force sign off</button>
<% } %>			
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="2">User Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">First Name</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="firstname" value="<%=firstname==null?"":firstname %>" maxlength="50" size="60">
<%	} else { %>
			<%=firstname==null?"":firstname %><input type="hidden" name="firstname" value="<%=firstname%>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Last Name</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="lastname" value="<%=lastname==null?"":lastname %>" maxlength="50" size="60">
<%	} else { %>
			<%=lastname==null?"":lastname %><input type="hidden" name="lastname" value="<%=lastname%>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Nickname<br />(Display Name)</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="nickname" value="<%=nickname==null?"":nickname %>" maxlength="50" size="60">
<%	} else { %>
			<%=nickname==null?"":nickname %><input type="hidden" name="nickname" value="<%=nickname%>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Dept Code</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="deptcode">
				<jsp:include page="../ui/deptCodeCMB.jsp" flush="true">
					<jsp:param name="deptCode" value="<%=deptcode %>" />
					<jsp:param name="includeAllDept" value="Y" />
					<jsp:param name="allowAll" value="Y" />
					<jsp:param name="allowEmpty" value="Y" />
				</jsp:include>
				<option value="SYSTEM" <%="SYSTEM".equals(deptcode)?" selected":"" %>>SYSTEM (for testing)</option>
			</select>
<%	} else { %>
			<%=deptcode==null?"":deptcode %><input type="hidden" name="deptcode" value="<%=deptcode%>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Phone</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="phone" value="<%=phone==null?"":phone %>" maxlength="20" size="30">
<%	} else { %>
			<%=phone==null?"":phone %><input type="hidden" name="phone" value="<%=phone%>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Photo</td>
		<td class="infoData" width="70%">
<% if (photoUrl == null || photoUrl.isEmpty()) { %>
		<div>No photo</div>
<% } else { %>

<div id="user_photo" style="margin: 5px 0; position: relative; left: 0; top: 0;">
  <img src="<%=photoUrl %>" alt="<%=photoFileName %>" onclick="window.open('<%=photoUrl %>');" width="300px" />
<%	if (createAction || updateAction) { %>
  <img src="../images/delete2.png" onclick="removePhoto();" width="30px" style="position: absolute; top: 10px; left: 250px;"/>
<% } %>
</div>
<% } %>
<%	if (createAction || updateAction) { %>
			<input type="file" name="photo" size="50" maxlength="1">
<%	} else { %>
	<input type="hidden" name="photo" value="<%=photo%>">
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
			<% if (userBean.isAccessible("function.helpDesk.user.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.helpDesk.user.update" /></button><% } %>
			<% if (userBean.isAccessible("function.helpDesk.user.delete")) { %><button class="btn-delete"><bean:message key="function.helpDesk.user.delete" /></button><% } %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
</form>
<script language="javascript">
	$().ready(function() {

	});

	$('form').submit(function() {
		//$('#select2 option').each(function(i) {
		//	$(this).attr("selected", "selected");
		//});
	});

	// validate signup form on keyup and submit

	function submitAction(cmd, stp) {
		if (cmd == 'create' || cmd == 'update') {
<%	if (createAction || updateAction) { %>
		if (document.form1.userid.value == '') {
			alert("Please enter User ID.");
			document.form1.userid.focus();
			return false;
		}
		if (document.form1.passwordPlain.value != '') {
			if (document.form1.passwordPlain.value != document.form1.passwordPlainConfirm.value) {
				alert("Confirm password does not match.");
				document.form1.passwordPlainConfirm.focus();
				return false;
			}
		}
		if (document.form1.nickname.value == '') {
			alert("Please enter Nickname.");
			document.form1.nickname.focus();
			return false;
		}
<%	} %>
		} else if (cmd == 'synPw' || cmd == 'logout') {
			var param = {
					userid:	stp,
					action: cmd
					};
			$.getJSON('user_action.jsp', param, function(data) {
				var items = [];
					$.each(data, function(key, val) {
						if (key == 'message') {
							alert(val);
							document.form1.command.value = '';
							document.form1.step.value = '0';
							document.form1.submit();
						}
					});
			});
			return false;
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
	
	function removePhoto() {
		$('#user_photo').hide();
		document.form1.photo.value = '';
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>