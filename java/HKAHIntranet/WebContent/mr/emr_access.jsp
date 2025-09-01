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
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String listTablePageParaName = ParserUtil.getParameter(request, "listTablePageParaName");
String listTableCurPage = ParserUtil.getParameter(request, "listTableCurPage");

String seqno = ParserUtil.getParameter(request, "seqno");
String patno = ParserUtil.getParameter(request, "patno");

String lockDate = ParserUtil.getParameter(request, "lockDate");
String lockBy = ParserUtil.getParameter(request, "lockBy");
String lockByName = null;
String unlockDate = ParserUtil.getParameter(request, "unlockDate");
String unlockBy = ParserUtil.getParameter(request, "unlockBy");
String unlockByName = null; 
String reason = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "reason"));
String remarks = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remarks"));
String updateUser = ParserUtil.getParameter(request, "updateUser");
String updateUserName = null;
String updateDate = ParserUtil.getParameter(request, "updateDate");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean unlockAction = false;
boolean success = false;
boolean refreshOpenerList = false;

if ("create".equals(command) || !userBean.isLogin()) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("unlock".equals(command)) {
	unlockAction = true;
}

if (createAction) {
	lockBy = userBean.getStaffID();
}

//System.out.println("[emr_access] command="+command+", seqno="+seqno+", patno="+patno);

String message = "";
String errorMessage = "";

try {
	if ("1".equals(step)) {
		if (createAction) {
			seqno = PatientDB.addPatLock(userBean, patno, lockBy, reason, remarks);
			if (seqno != null) {
				message = "eMR Lock created.";
				createAction = false;
				step = "0";
				refreshOpenerList = true;
			} else {
				errorMessage = "eMR Lock create fail.";
			}
		} else if (updateAction) {
			if (PatientDB.updatePatLock(userBean, seqno, reason, remarks)) {
				message = "eMR Lock updated.";
				updateAction = false;
				step = "0";
			} else {
				errorMessage = "eMR Lock update fail.";
			}
		/*
		} else if (deleteAction) {
			if (PatientDB.deletePatLock(patno)) {
				message = "eMR Lock deleted.";
				closeAction = true;
				refreshOpenerList = true;
			} else {
				errorMessage = "eMR Lock remove fail.";
			}
		*/
		} else if (unlockAction) {
			if (PatientDB.unlockPatLock(userBean, seqno, userBean.getStaffID())) {
				message = "eMR Lock unlocked.";
				updateAction = false;
				step = "0";
				refreshOpenerList = true;
			} else {
				errorMessage = "eMR Lock unlock fail.";
			}		
		}

	} else if (createAction) {
		// init value
	}

	ReportableListObject row = null; 

	// load data from database
	if (!createAction && !"1".equals(step)) {
		ArrayList record = PatientDB.getPatLock(seqno);
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			seqno = row.getValue(0);
			patno = row.getValue(1);
			lockBy = row.getValue(2);
			lockByName = row.getValue(10);
			lockDate = row.getValue(3);
			reason = row.getValue(4);
			remarks = row.getValue(5);
			updateUser = row.getValue(6);
			updateUserName = row.getValue(12);
			updateDate = row.getValue(7);
			unlockBy = row.getValue(8);
			unlockByName = row.getValue(11);
			unlockDate = row.getValue(9);
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
#patLockStatusMsg { color: red; font-size: 15px;}
</style>
<% if (refreshOpenerList) { %>
<script type="text/javascript">
if (opener && opener.document.searchform) {
	var form = opener.document.searchform;
	form.elements["<%=listTablePageParaName %>"].value = "<%=listTableCurPage %>";
	form.submit();
}
</script>
<% } %>
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
	title = "function.mr.emracc." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" id="form1" action="emr_access.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Patient Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Patient No.</td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
			<input type="textfield" name="patno" value="<%=patno==null?"":patno %>" maxlength="10" size="20" />
<%	} else { %>
			<%=patno==null?"":patno %><input type="hidden" name="patno" value="<%=patno%>">
<%	} %>
			<span id="patLockStatusMsg" class="alertText"></span>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Patient Name</td>
		<td class="infoData" width="70%">
			<span name="patname"></span>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="2">
			e-MR Lock Details	
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Current Status</td>
		<td class="infoData" width="70%">
			<span name="lockStatus"></span>
			<span name="latestLockSeqno"></span>
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="30%">Seq No.</td>
		<td class="infoData" width="70%">
			<%=seqno==null?"":seqno %><input type="hidden" name="seqno" value="<%=seqno%>">
		</td>
	</tr>		
	<tr class="smallText">
		<td class="infoLabel" width="30%">Lock By</td>
		<td class="infoData" width="70%">
<%	if (!createAction) { %>		
			<%=lockByName==null || lockByName.isEmpty() ? "" : lockByName %><%=lockBy==null || lockBy.isEmpty()?"":" (" + lockBy + ")" %>
<% } %>
		<input type="hidden" name="lockBy" value="<%=lockBy%>">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Lock Date Time</td>
		<td class="infoData" width="70%">
			<%=lockDate==null?"":lockDate %>
			<input type="hidden" name="lockDate" value="<%=lockDate%>">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Unlock By</td>
		<td class="infoData" width="70%">
			<%=unlockByName == null || unlockByName.isEmpty() ? "" : unlockByName %><%=unlockBy==null || unlockBy.isEmpty() ?"":" (" + unlockBy + ")" %><input type="hidden" name="unlockBy" value="<%=unlockBy%>">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Unlock Date Time</td>
		<td class="infoData" width="70%">
			<%=unlockDate==null?"":unlockDate %>
			<input type="hidden" name="unlockDate" value="<%=unlockDate%>">
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="30%">Reason</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<textarea name="reason" id="reason" rows="3" cols="100"><%=reason==null?"":reason%></textarea>
<%	} else { %>
			<%=reason==null?"":reason %><input type="hidden" name="reason" value="<%=reason==null?"":reason%>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Remarks<br />(for internal use)</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<textarea name="remarks" id="remarks" rows="3" cols="100"><%=remarks==null?"":remarks%></textarea>
<%	} else { %>
			<%=remarks==null?"":remarks %><input type="hidden" name="remarks" value="<%=remarks==null?"":remarks%>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Last Updated</td>
		<td class="infoData" width="70%">
			<%=updateDate==null?"":updateDate %> <% if (updateUser != null) { %>by <%=updateUserName %><%=updateUser==null?"":" (" + updateUser + ")" %><% } %>
		</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click" name="saveBtn"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<% if (userBean.isAccessible("function.mr.emracc.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.mr.emracc.update" /></button><% } %>
			<% if (userBean.isAccessible("function.mr.emracc.delete")) { %><button class="btn-delete"><bean:message key="function.mr.emracc.delete" /></button><% } %>
			&nbsp;
			<% if ((unlockDate == null || unlockDate.isEmpty()) && userBean.isAccessible("function.mr.emracc.update")) { %><button onclick="return submitAction('unlock', 0);" class="btn-click" name="unlockBtn">Unlock</button><% } %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="listTablePageParaName" value="<%=listTablePageParaName %>" />
<input type="hidden" name="listTableCurPage" value="<%=listTableCurPage %>" />
</form>
<script language="javascript">
	$().ready(function() {
		<%	if (createAction || updateAction) { %>
			$("textarea[name=reason]").supertextarea({
				maxl: 255,
				tabr: {use: false}
			});
		
			$("textarea[name=remarks]").supertextarea({
				maxl: 255,
				tabr: {use: false}
			});
			
			$("input[name=patno]").blur(function() {
				getPatLockStatus();
			});
		<%	} %>
		
		getPatLockStatus();
	});

	function getPatLockStatus() {
		$('#patLockStatusMsg').html('');
		$('span[name=patname]').html('');
		$('span[name=lockStatus]').html('');
		
		var param = {
			action: 'lockStatus',
			patno: $("input[name=patno]").val()
		};
		$.getJSON('emr_patLockStatus.jsp', param, function(data) {
			var items = [];
			$.each(data, function(key, val) {
				if (key == 'result') {					
					var isDisable = false;
					if (val == false) {
						isDisable = true;
					}
					$('button[name=saveBtn]').attr('disabled', isDisable);
				} else if (key == 'message') {
					$('#patLockStatusMsg').html(val);
				} else if (key == 'object') {
					$('span[name=patname]').html(val.patname);
					var lockStatus;
					if (val.islocked == 'Y') {
						lockStatus = '<span class="alertText bigText">Locked</span>';
						if (val.seqno != '<%=seqno%>') {
							lockStatus = lockStatus + ' by <button onclick="submitAction(\'view\', \'0\', \'' + val.seqno + '\')" class="btn-click">lock (Seq No.: ' + val.seqno + ')</button>';
						}
					} else {
						lockStatus = 'No Lock';
					}
					$('span[name=lockStatus]').html(lockStatus);
				}
			});
		});
	}

	function submitAction(cmd, stp, keyId) {
		if (cmd == 'view' && keyId) {
			callPopUpWindow("emr_access.jsp?command=" + cmd + "&seqno=" + keyId);
			return false;
		} else if (cmd == 'create' || cmd == 'update') {
<%	if (createAction || updateAction) { %>
		if (document.form1.patno.value == '') {
			alert("Please provide Patient No.");
			document.form1.patno.focus();
			return false;
		}
		if (document.form1.reason.value == '') {
			alert("Please provide lock Reason");
			document.form1.reason.focus();
			return false;
		}
<%	} %>
		}
		if (cmd == 'unlock' && stp == '0') {
			var promptMsg= 'Confirm to unlock Patient No.: <%=patno %> ?';
			$.prompt(promptMsg,{
				buttons: { Ok: true, Cancel: false },
				callback: function(v,m,f){
					if (v){
						submit: submitAction(cmd, 1, keyId);
						return true;
					} else {
						return false;
					}
				},
				prefix:'cleanblue'
			});
			return false;
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
		
		return false;
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>