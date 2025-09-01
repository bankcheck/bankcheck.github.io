<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%
UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request,"command");
String ls_actionNo1 = request.getParameter("actionNo1");
String ls_actionNo2 = request.getParameter("actionNo2");
String ls_actionNo3 = request.getParameter("actionNo3");

String ls_approveDate1 = request.getParameter("approveDate1");
String ls_approveDate2 = request.getParameter("approveDate2");
String ls_approveDate3 = request.getParameter("approveDate3");
String ls_approveDate4 = request.getParameter("approveDate4");
String ls_approveDate5 = request.getParameter("approveDate5");

String ctsNo[] = null;
String docName[] = null;
String docEmail = null;
String ctsStatus = null;
String selectCtsNo[] = request.getParameterValues("selectCtsNo");

boolean updateAction = false;

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";

if ("save".equals(command) || !userBean.isLogin()) {
	updateAction = true;
}
try {
	if (userBean != null || userBean.isLogin()) {
		System.err.println("[command]1"+command);
		if (updateAction) {
			System.err.println("[command]2"+command);
			for (int i = 0; i < selectCtsNo.length; i++) {
				ArrayList record = CTS.getRecord(selectCtsNo[i]);
				ReportableListObject row = (ReportableListObject) record.get(0);
				docEmail = row.getValue(6);

				if (docEmail!=null && docEmail.length()> 0){
					// Update - HATS&Email
					ctsStatus = "U";
				} else {
					// Update - HATS&Post
					ctsStatus = "P";
				}
				System.err.println("[ctsStatus]:"+ctsStatus);
				if (!CTS.updateCtsRecordListF(userBean, selectCtsNo[i], ctsStatus, ls_approveDate4, ls_approveDate5)) {
					errorMessage = "Record update fail due to update CTS error.";
				} else if (!CTS.addApproval(selectCtsNo[i], ls_actionNo1, "AHHK Board", ls_approveDate1)) {
					errorMessage = "Record update fail due to update Board error.";
				} else if (!CTS.addApproval(selectCtsNo[i], ls_actionNo2, "MDEC", ls_approveDate2)) {
					errorMessage = "Record update fail due to update MDEC error.";
				} else if (!CTS.addApproval(selectCtsNo[i], ls_actionNo3, "Credentials Committee", ls_approveDate3)) {
					errorMessage = "Record update fail due to update Credentials Committee error.";
				} else if (!CTS.updateHatDoc(selectCtsNo[i], ls_approveDate4, ls_approveDate5)) {
					errorMessage = "Record update fail due to update HATS error.";
				} else {
					System.err.println("[ls_approveDate1]:"+ls_approveDate1+";[ls_approveDate2]:"+ls_approveDate2+";[ls_approveDate3]:"+ls_approveDate3+";[ls_approveDate4]:"+ls_approveDate4+";[ls_approveDate5]:"+ls_approveDate5);
					message = "Record Updated.";
				}
			}
		}
		System.err.println("[command]3"+command);
		// load data from database
		ArrayList record = CTS.getApproveList();
		if (record.size() > 0) {
			ctsNo = new String[record.size()];
			docName = new String[record.size()];
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				ctsNo[i] = row.getValue(0);
				docName[i] = row.getValue(1);
			}
		} else {
			ctsNo = null;
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
<%if (userBean.isLogin()) { %>
<jsp:include page="../common/banner2.jsp"/>
<%} %>
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
	System.err.println("000[command]0"+command);
	// set submit label
	title = "function.cts.acceptVerify";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
	<jsp:param name="accessControl" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.cts.acceptVerify" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="accept_verify" action="accept_verify.jsp" method="post" >
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
			<table border="0">
				<tr>
					<td class="infoCenterLabel2" width="40%"><bean:message key="prompt.waitingApprove" /></td>
					<td width="20%">&nbsp;</td>
					<td class="infoCenterLabel2" width="40%"><bean:message key="prompt.approve" /></td>
				</tr>
				<tr>
					<td width="40%">
						<select name="waitApprove" size="15" multiple id="select1">
<%				if (ctsNo != null) {
					for (int i = 0; i < ctsNo.length; i++) {
%><option value="<%=ctsNo[i] %>"><%=docName[i] %></option><%
					}
				}%>
						</select>
					</td>
					<td width="20%" align="center">
						<button id="add"><bean:message key="button.add" /> >></button><br>
						<button id="remove"><bean:message key="button.delete" /></button>
					</td>
					<td width="40%">
						<select name="selectCtsNo" size="15" multiple id="select2">
						</select>
					</td>
				</tr>
			</table>
	</tr>
	<hr size="5" />
	<tr class="smallText">
		<td>
			<table border="0">
				<tr class="smallText">
					<td class="infoLabel" width="30%"><bean:message key="prompt.actionNo1" /></td>
					<td class="infoData" width="30%">
						<input type="textfield" name="actionNo1" value="<%=ls_actionNo1==null?"":ls_actionNo1 %>" maxlength="22" size="22">
					</td>
					<td class="infoData" width="40%">
						<input type="textfield" name="approveDate1" id="approveDate1" class="datepickerfield" value="<%=ls_approveDate1==null?"":ls_approveDate1 %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
					</td>
				</tr>
				<tr class="smallText">
					<td class="infoLabel" width="30%"><bean:message key="prompt.actionNo2" /></td>
					<td class="infoData" width="30%">
						<input type="textfield" name="actionNo2" value="<%=ls_actionNo2==null?"":ls_actionNo2 %>" maxlength="22" size="22">
					</td>
					<td class="infoData" width="40%">
						<input type="textfield" name="approveDate2" id="approveDate2" class="datepickerfield" value="<%=ls_approveDate2==null?"":ls_approveDate2 %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
					</td>
				</tr>
				<tr class="smallText">
					<td class="infoLabel" width="30%"><bean:message key="prompt.actionNo3" /></td>
					<td class="infoData" width="30%">
						<input type="textfield" name="actionNo3" value="<%=ls_actionNo3==null?"":ls_actionNo3 %>" maxlength="22" size="22">
					</td>
					<td class="infoData" width="40%">
						<input type="textfield" name="approveDate3" id="approveDate3" class="datepickerfield" value="<%=ls_approveDate3==null?"":ls_approveDate3 %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
					</td>
				</tr>
				<tr class="smallText">
					<td class="infoLabel" width="30%"><bean:message key="prompt.actionNo4" /></td>
					<td class="infoData" width="30%">
						<input type="textfield" name="approveDate4" id="approveDate4" class="datepickerfield" value="<%=ls_approveDate4==null?"":ls_approveDate4 %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY) For 1year
					</td>
					<td class="infoData" width="40%">
						<input type="textfield" name="approveDate5" id="approveDate5" class="datepickerfield" value="<%=ls_approveDate5==null?"":ls_approveDate5 %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY) For 3year
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<hr size="5" />
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction('save')"><bean:message key="button.saveUpdate" /></button>
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="command"/>
</form>
<script language="javascript">
	function closeAction() {
		window.close();
	}

	$().ready(function() {
		$('#add').click(function() {
			return !$('#select1 option:selected').appendTo('#select2');
		});
		$('#remove').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});
	});

	$('accept_verify').submit(function() {
		$('#select2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
	});

	function submitAction(cmd) {
		if (document.accept_verify.selectCtsNo.value == "") {
			alert("Please enter approval doctor.");
			document.accept_verify.waitApprove.focus();
			return false;
		}

		if (document.accept_verify.approveDate1.value == "") {
			alert("Please enter <bean:message key="prompt.actionNo1" /> approval date.");
			document.accept_verify.approveDate1.focus();
			return false;
		}

		if (document.accept_verify.approveDate2.value == "") {
			alert("Please enter <bean:message key="prompt.actionNo2" /> approval date.");
			document.accept_verify.approveDate2.focus();
			return false;
		}

		if (document.accept_verify.approveDate3.value == "") {
			alert("Please enter <bean:message key="prompt.actionNo3" /> approval date.");
			document.accept_verify.approveDate3.focus();
			return false;
		}

		if (document.accept_verify.approveDate4.value == "" && document.accept_verify.approveDate5.value == "") {
			alert("Please enter <bean:message key="prompt.actionNo4" /> approval date.");
			document.accept_verify.approveDate4.focus();
			return false;
		}
/*
		var answer = confirm ("Confirm to approve?");
		if (answer) {
			alert('[cmd]'+cmd);
			document.accept_verify.command.value = cmd;
//			document.accept_verify.submit();
			return true;
		} else {
			return false;
		}
*/
		$.prompt('Confirm to approve?',{
			buttons: { Ok: true, Cancel: false },
			callback: function(v,m,f){
				if(v){
					document.accept_verify.command.value = cmd;
					document.accept_verify.submit();
					return true;
				} else {
					return false;
				}
			},
			prefix:'cleanblue'
		});
		return false;
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp"/>
</body>
</html:html>