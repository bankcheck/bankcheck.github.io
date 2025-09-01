<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
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

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String prID = ParserUtil.getParameter(request, "prID");	// system generated
String prNo = ParserUtil.getParameter(request, "prNo");	// user typed
String prName = ParserUtil.getParameter(request, "prName");	// user typed
String prOwner = ParserUtil.getParameter(request, "prOwner");	// user typed
String prEmail = ParserUtil.getParameter(request, "prEmail");	// user typed
String prToBeReviewedDate = ParserUtil.getParameter(request, "prToBeReviewedDate");	// user typed
String prSuggestedReference = ParserUtil.getParameter(request, "prSuggestedReference");	// user typed

String content = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "content"));
// 

String emailNotifyFromSelf = ParserUtil.getParameter(request, "emailNotifyFromSelf");
String emailNotifyToAll = ParserUtil.getParameter(request, "emailNotifyToAll");
String emailExclude = ParserUtil.getParameter(request, "emailExclude");
String privateDate = DateTimeUtil.getCurrentDateTimeWithoutSecond();

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction || updateAction) {
			// System.out.println("createAction updateAction step prID fileUpload postHomepage : " + createAction + ", " + updateAction + ", " + step + ", " + prID + ", " + fileUpload + ", " + postHomepage);
			// get prID with dummy data
			if (createAction && (prID == null || prID.length() == 0)) {
				prID = PolicyReminderDB.add(userBean);
//System.err.println("1 ID =" + prID);
			}
			
//System.out.println(prID);
			if (PolicyReminderDB.update(userBean, prID, prNo, prName, prOwner, prEmail, prToBeReviewedDate, prSuggestedReference)) {
//System.out.println("IN");
				if (createAction) {
					message = "Policy Reminder created.";
					createAction = false;
				} else {
					message = "Policy Reminder updated.";
					updateAction = false;
				}
				step = null;
			} else {
				if (createAction) {
					errorMessage = "Policy Reminder create fail.";
				} else {
					errorMessage = "Policy Reminder update fail.";
				}
			}
		
		} else if (deleteAction) {
			if (PolicyReminderDB.delete(userBean, prID)) {
				message = "policy reminder removed.";
				closeAction = true;
			} else {
				errorMessage = "policy reminder remove fail.";
			}
		}
	} else if (createAction) {
		prID = "";
		prNo = "";
		prName = "";
		prOwner = "";
		prEmail = "";
		prToBeReviewedDate = "";
		prSuggestedReference = "";
	}
	
	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (prID != null && prID.length() > 0) {
			ArrayList record = PolicyReminderDB.get(userBean, prID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				
				prNo = row.getValue(1);
				prName = row.getValue(2);
				prOwner = row.getValue(3);
				prEmail = row.getValue(4);
				prToBeReviewedDate = row.getValue(5);	// ok
				prSuggestedReference = row.getValue(6);

/*
System.out.println("row.getValue(0)="+row.getValue(0));	// prID
System.out.println("row.getValue(1)="+row.getValue(1)); // prName
System.out.println("row.getValue(2)="+row.getValue(2)); // prOwner
System.out.println("row.getValue(3)="+row.getValue(3)); // prEmail
System.out.println("row.getValue(4)="+row.getValue(4)); // prToBeReviewedDate
System.out.println("row.getValue(5)="+row.getValue(5)); // prSuggestedReference
*/

//				System.out.println("prToBeReviewedDate="+prToBeReviewedDate);
//				if (prToBeReviewedDate.isEmpty()) {
//					postHomepage = "Y";
//				}

				StringBuffer contentSB = new StringBuffer();
				record = PolicyReminderDB.getContent(prID);
				if (record != null) {
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						contentSB.append(row.getValue(0));
					}
				}
				content = contentSB.toString();
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<%if (closeAction) { %>	
	<script type="text/javascript">window.close();</script>
<%} else { %>

<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
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
	title = "function.policy_reminder." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>


<form name="form1" id="form1" enctype="multipart/form-data" action="policy_reminder.jsp" method="post">
<div class="createActionOnly privateRmk" style="display:none; margin: 5px; font-size: 15px;">
</div>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">

 <!-- 'prNo' below: -->
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.prNo" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="prNo" value="<%=prNo==null?"":prNo %>" maxlength="50" size="50">
<%	} else { %>
			<%=prNo==null?"":prNo %>
<%	} %>
		</td>
	</tr>	

 <!-- 'prName' below: -->
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.prName" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="prName" value="<%=prName==null?"":prName %>" maxlength="200" size="100">
<%	} else { %>
			<%=prName==null?"":prName %>
<%	} %>
		</td>
	</tr>	

 <!-- 'prOwner' below: -->
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.prOwner" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="prOwner" value="<%=prOwner==null?"":prOwner %>" maxlength="1000" size="100">
<%	} else { %>
			<%=prOwner==null?"":prOwner %>
<%	} %>
		</td>
	</tr>

<!-- 'prEmail' below: -->
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.prEmail" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="prEmail" value="<%=prEmail==null?"":prEmail %>" maxlength="1000" size="100">
<%	} else { %>
			<%=prEmail==null?"":prEmail %>
<%	} %>
		</td>
	</tr>

 <!-- 'prToBeReviewedDate' below: -->
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.prToBeReviewedDate" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="prToBeReviewedDate" id="prToBeReviewedDate" class="datepickerfield" value="<%=prToBeReviewedDate==null?"":prToBeReviewedDate %>" maxlength="16" size="16">
<%	} else { %>
			<%=prToBeReviewedDate==null?"":prToBeReviewedDate %>
<%	} %>
		</td>
	</tr>
  
<!-- 'prSuggestedReference' below: -->
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.prSuggestedReference" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<div class="box"><textarea id="prSuggestedReference" name="prSuggestedReference" rows="12" cols="100"><%=prSuggestedReference %></textarea></div>
<%	} else { %>
			<%=prSuggestedReference==null?"":prSuggestedReference %>
<%	} %>
		</td>
	</tr>
  
</table>

<div class="pane">

<%-- 'Bottom buttons' below: --%>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.policy_reminder.update" /></button>
 		  	<button class="btn-delete"><bean:message key="function.policy_reminder.delete" /></button>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="prID" value="<%=prID==null?"":prID %>">
<input type="hidden" name="toPDF" value="N">
</form>


<script language="javascript">
 
	$(document).ready(function(){
		$("input[name=private]").click(function(){
			privateMode(this.checked);
		});
<%	if (createAction) { %>
		$('.createActionOnly').show();
<%} %>
	});
	
<%--	function privateMode(enable) {
		if (enable) {
			$('input[name=private]')[0].checked = true;
			$('.privateRmk').css("font-weight","bold");
<%	if (createAction) { %>				
			$('input[name=newsPostDate]').val('<%=privateDate %>');
			$('input[name=prToBeReviewedDate]').val('<%=privateDate %>');
			$('input[name=emailNotifyToAll][value=N]')[0].checked = true;
<%} %>		
			$('.publicNewsOnly').hide();
		} else {
			$("input[name=private]")[0].checked = false;
			$('.privateRmk').css("font-weight","normal");
<%	if (createAction) { %>			
			$('input[name=newsPostDate]').val('<%=privateDate %>');
			$('input[name=prToBeReviewedDate]').val('');
<%} %>			
			$('.publicNewsOnly').show();
		}
	}
--%>
	
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
//			alert(document.form1.prName.value == '')
			if (document.form1.prNo.value == '') {
				alert("Empty Policy No.");
				document.form1.prNo.focus();
				return false;
			}
			if (document.form1.prName.value == '') {
				alert("Empty Policy Name.");
				document.form1.prName.focus();
				return false;
			}
			if (document.form1.prOwner.value == '') {
				alert("Empty Owner.");
				document.form1.prOwner.focus();
				return false;
			}
			if (document.form1.prEmail.value == '') {
				alert("Empty Email.");
				document.form1.prEmail.focus();
				return false;
			}
			if (document.form1.prToBeReviewedDate.value == '') {
				alert("Empty To be Reviewed Date.");
				document.form1.prToBeReviewedDate.focus();
				return false;
			}
		}
<%	 } %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function callback(msg) {
		document.getElementById("file").outerHTML = document.getElementById("file").outerHTML;
		document.getElementById("msg").innerHTML = "<font color=red>"+msg+"</font>";
	}

	// ajax
	var http = createRequestObject();
	var http2 = createRequestObject();

<%--	function processResponseNewsType() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("matchNewsType_indicator").innerHTML = '<select name="newsType">' + http.responseText + '</select>';
		}
	}
--%>
	
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<% } %> 
</html:html>