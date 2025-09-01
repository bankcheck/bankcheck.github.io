<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String step = request.getParameter("step");

String projectID = request.getParameter("projectID");
String projectDesc = TextUtil.parseStrUTF8(request.getParameter("projectDesc"));
String requestUserID = null;
String requestUserName = null;
String expectedDate = request.getParameter("expectedDate");
String launchDate = request.getParameter("launchDate");
String approval = TextUtil.parseStrUTF8(request.getParameter("approval"));
String budget = TextUtil.parseStrUTF8(request.getParameter("budget"));
String status = request.getParameter("status");
String statusLabel = null;
String modifiedDate = null;

String commentID = request.getParameter("commentID");
String fromStaffID = request.getParameter("fromStaffID");
String[] toStaffID = request.getParameterValues("toStaffID");
String toEmail = request.getParameter("toEmail");
String[] ccStaffID = request.getParameterValues("ccStaffID");
String ccEmail = request.getParameter("ccEmail");
String commentTopic = TextUtil.parseStrUTF8(request.getParameter("commentTopic"));
String comment = TextUtil.parseStrUTF8(request.getParameter("comment"));
String involveDeptCode = request.getParameter("involveDeptCode");
String involveUserID = request.getParameter("involveUserID");
String commentType = request.getParameter("commentType");
String deadline = request.getParameter("deadline");
String emailNotify = request.getParameter("emailNotify");

if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	command = (String) request.getAttribute("command");
	step = (String) request.getAttribute("step");
	projectID = (String) request.getAttribute("projectID");
	projectDesc = TextUtil.parseStrUTF8((String) request.getAttribute("projectDesc"));
	expectedDate = (String) request.getAttribute("expectedDate");
	launchDate = (String) request.getAttribute("launchDate");
	approval = TextUtil.parseStrUTF8((String) request.getAttribute("approval"));
	budget = TextUtil.parseStrUTF8((String) request.getAttribute("budget"));
	status = (String) request.getAttribute("status");

	commentID = (String) request.getAttribute("commentID");
	fromStaffID = (String) request.getAttribute("fromStaffID");
	toStaffID = (String []) request.getAttribute("toStaffID_StringArray");
	toEmail = (String) request.getAttribute("toEmail");
	ccStaffID = (String []) request.getAttribute("ccStaffID_StringArray");
	ccEmail = (String) request.getAttribute("ccEmail");
	commentTopic = TextUtil.parseStrUTF8((String) request.getAttribute("commentTopic"));
	comment = TextUtil.parseStrUTF8((String) request.getAttribute("comment"));
	involveDeptCode = (String) request.getAttribute("involveDeptCode");
	involveUserID = (String) request.getAttribute("involveUserID");
	commentType = (String) request.getAttribute("commentType");
	deadline = (String) request.getAttribute("deadline");
	emailNotify = (String) request.getAttribute("emailNotify");

	// create new record
	if ("create".equals(command) && "1".equals(step)) {
		// get project id with dummy data
		projectID = ProjectSummaryDB.add(userBean);
	}

	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("Project Management");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(projectID);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		for (int i = 0; i < fileList.length; i++) {
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);
			AttachDocumentDB.insertDocument(userBean, "pmp", projectID, commentID, fileList[i]);
		}
	}
}

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean createCommentAction = false;
boolean updateCommentAction = false;
boolean editCommentAction = false;
boolean replyCommentAction = false;
boolean viewCommentAction = false;
boolean closeAction = false;
boolean allowToEdit = false;

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("createComment".equals(command)) {
	createCommentAction = true;
} else if ("updateComment".equals(command)) {
	updateCommentAction = true;
} else if ("editComment".equals(command)) {
	editCommentAction = true;
} else if ("replyComment".equals(command)) {
	replyCommentAction = true;
} else if ("viewComment".equals(command)) {
	viewCommentAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction) {
			// create project id if necessary
			if (projectID == null) {
				projectID = ProjectSummaryDB.add(userBean);
			}
			if (ProjectSummaryDB.update(userBean, projectID, projectDesc, expectedDate, launchDate, approval, budget, status)) {
				message = "project created.";
				createAction = false;
			} else {
				errorMessage = "project create fail.";
			}
		} else if (updateAction) {
			if (ProjectSummaryDB.update(userBean, projectID, projectDesc, expectedDate, launchDate, approval, budget, status)) {
				message = "project updated.";
				updateAction = false;
			} else {
				errorMessage = "project update fail.";
			}
		} else if (deleteAction) {
			if (ProjectSummaryDB.delete(userBean, projectID)) {
				message = "project removed.";
				closeAction = true;
			} else {
				errorMessage = "project remove fail.";
			}
		} else if (createCommentAction) {
			if (ProjectSummaryDB.addComment(userBean, projectID,
					commentType, commentTopic, comment, involveDeptCode, involveUserID, deadline,
					fromStaffID, toStaffID, toEmail, ccStaffID, ccEmail, emailNotify)) {
				message = "new comment added.";
				createCommentAction = false;
			} else {
				errorMessage = "new comment add fail.";
			}
		} else if (updateCommentAction) {
			if ("delete".equals(commentType)) {
				if (ProjectSummaryDB.deleteComment(userBean, projectID, commentID)) {
					message = "comment deleted.";
					updateCommentAction = false;
				} else {
					errorMessage = "comment deleted fail.";
				}
			} else {
				if (ProjectSummaryDB.updateComment(userBean, projectID, commentID,
						commentType, commentTopic, comment, involveDeptCode, involveUserID, deadline,
						fromStaffID, toStaffID, toEmail, ccStaffID, ccEmail, emailNotify, true)) {
					message = "comment updated.";
					updateCommentAction = false;
					// change to view comment
					viewCommentAction = true;
					command = "viewComment";
				} else {
					errorMessage = "comment update fail.";
				}
			}
		} else if (editCommentAction) {
			if (ProjectSummaryDB.updateComment(userBean, projectID, commentID,
					commentType, commentTopic, comment, involveDeptCode, involveUserID, deadline,
					fromStaffID, toStaffID, toEmail, ccStaffID, ccEmail, emailNotify, false)) {
				message = "comment edited.";
				editCommentAction = false;
				// change to view comment
				viewCommentAction = true;
				command = "viewComment";
			} else {
				errorMessage = "comment edit fail.";
			}
		} else if (replyCommentAction) {
			if (ProjectSummaryDB.replyComment(userBean, projectID, commentID,
					comment, emailNotify)) {
				message = "comment updated.";
				replyCommentAction = false;
				// change to view comment
				viewCommentAction = true;
				command = "viewComment";
			} else {
				errorMessage = "comment update fail.";
			}
		}
		step = null;
	} else if (createAction) {
		projectID = "";
		requestUserID = userBean.getStaffID();
		requestUserName = userBean.getUserName();
		fromStaffID = userBean.getStaffID();
		involveDeptCode = userBean.getDeptCode();

		// reset content
		fromStaffID = userBean.getStaffID();
		toStaffID = null;
		ccStaffID = null;
		commentTopic = null;
		involveDeptCode = userBean.getDeptCode();
		comment = null;
		commentType = "issue";
		deadline = null;
	} else if (createCommentAction) {
		commentID = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (projectID != null && projectID.length() > 0) {
			ArrayList record = ProjectSummaryDB.get(projectID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				projectDesc = row.getValue(0);
				requestUserID = row.getValue(2);
				requestUserName = row.getValue(3);
				expectedDate = row.getValue(4);
				launchDate = row.getValue(5);
				approval = row.getValue(6);
				budget = row.getValue(7);
				status = row.getValue(8);
				modifiedDate = row.getValue(9);
			}
		} else {
			closeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

// set default value
if (status == null || status.length() == 0) {
	status = "preparation";
}
statusLabel = "label." + status;
if (commentType == null || commentType.length() == 0) {
	commentType = "issue";
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
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/thickbox.css" />" media="screen" />
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<%
	String title = null;
	String subTitle = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
		subTitle = "";
	} else if (updateAction) {
		commandType = "update";
		subTitle = "";
	} else if (deleteAction) {
		commandType = "delete";
		subTitle = "";
	} else {
		commandType = "view";
		if (updateCommentAction || editCommentAction) {
			subTitle = "prompt.comment";
		} else {
			subTitle = "";
		}
	}
	// set submit label
	title = "function.projectSummary." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="pageSubTitle" value="<%=subTitle %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" enctype="multipart/form-data" action="summary.jsp" method="post">
<%	if (createAction || updateAction) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.description" /></td>
		<td class="infoData" width="80%">
			<input type="textfield" name="projectDesc" value="<%=projectDesc==null?"":projectDesc %>" maxlength="50" size="50">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.requestFrom" /></td>
		<td class="infoData" width="80%"><%=requestUserName==null?"":requestUserName %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.expectedFinishDate" /></td>
		<td class="infoData" width="80%"><input type="textfield" name="expectedDate" id="expectedDate" class="datepickerfield" value="<%=expectedDate==null?"":expectedDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.launchDate" /></td>
		<td class="infoData" width="80%"><input type="textfield" name="launchDate" id="launchDate" class="datepickerfield" value="<%=launchDate==null?"":launchDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.approval" /></td>
		<td class="infoData" width="80%"><input type="textfield" name="approval" value="<%=approval==null?"":approval %>" maxlength="50" size="50"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.budget" /></td>
		<td class="infoData" width="80%"><input type="textfield" name="budget" value="<%=budget==null?"":budget %>" maxlength="50" size="50"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.document" /></td>
		<td class="infoData" width="80%">
			<span id="showProjectDocument_indicator">
<jsp:include page="../common/attach_document.jsp" flush="false">
	<jsp:param name="moduleID" value="pmp" />
	<jsp:param name="keyID" value="<%=projectID %>" />
	<jsp:param name="key2ID" value="0" />
	<jsp:param name="allowRemove" value="Y" />
</jsp:include>
			</span>
			<input type="file" name="file1" size="50" class="multi" maxlength="10">
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="80%">
			<input type="radio" name="status" value="preparation"<%="preparation".equals(status)?" checked":"" %>><bean:message key="label.preparation" />
			<input type="radio" name="status" value="launch"<%="launch".equals(status)?" checked":"" %>><bean:message key="label.launch" />
			<input type="radio" name="status" value="pilotRun"<%="pilotRun".equals(status)?" checked":"" %>><bean:message key="label.pilotRun" />
			<input type="radio" name="status" value="monitoring"<%="monitoring".equals(status)?" checked":"" %>><bean:message key="label.monitoring" />
<%		if (updateAction) { %>
			<input type="radio" name="status" value="close"<%="close".equals(status)?" checked":"" %>><bean:message key="label.close" />
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.modifiedDate" /></td>
		<td class="infoData" width="80%"><%=modifiedDate==null?"":modifiedDate %></td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%		if (createAction || updateAction || deleteAction) { %>
			<button onclick="submitAction('<%=commandType %>', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="submitAction('view', 0);return false;" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		}  %>
		</td>
	</tr>
</table>
</div>
<%	} %>
<span id="showComment_indicator">
<%	if (createCommentAction || updateCommentAction || editCommentAction || replyCommentAction || viewCommentAction) { %>
<jsp:include page="summary_view.jsp" flush="false">
	<jsp:param name="command" value="<%=command %>" />
	<jsp:param name="projectID" value="<%=projectID %>" />
	<jsp:param name="commentID" value="<%=commentID %>" />
</jsp:include>
<%	} %>
</span>
<%	if (!createAction && !updateAction && !deleteAction) { %>
<div id="showOverall_indicator">
<jsp:include page="../pmp/summary_overall.jsp" flush="false">
	<jsp:param name="projectID" value="<%=projectID %>" />
</jsp:include>
</div>
<%	} %>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="projectID" value="<%=projectID==null?"":projectID %>" />
<input type="hidden" name="commentID" value="<%=commentID==null||updateAction?"":commentID %>" />
</form>
<script language="javascript">
<!--
	$().ready(function(){
<%	if (createCommentAction || updateCommentAction|| editCommentAction) { %>
		// set javascript for the new add comment
		$('#add1').click(function() {
			var options = $('#select1 option:selected');
			if (options.length == 1 && options[0].value != '') {
				return !$('#select1 option:selected').appendTo('#select2');
			}
		});
		$('#remove1').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});
		$('#add2').click(function() {
			var options = $('#select3 option:selected');
			if (options.length == 1 && options[0].value != '') {
				return !$('#select3 option:selected').appendTo('#select4');
			}
		});
		$('#remove2').click(function() {
			return !$('#select4 option:selected').appendTo('#select3');
		});

		removeDuplicateItem('form1', 'responseByIDAvailable', 'toStaffID');
		removeDuplicateItem('form1', 'responseByIDAvailable', 'ccStaffID');
<%	} %>
<%	if (createCommentAction || updateCommentAction || editCommentAction || replyCommentAction || viewCommentAction) { %>

		// hide overall summary
		$('#showOverall_indicator').hide();
<%	} %>
	});

	function submitAction(cmd, stp) {
		if (stp == 1) {
			if (cmd == 'create' || cmd == 'update') {
				if (document.form1.projectDesc.value == '') {
					alert("Empty descrption.");
					document.form1.projectDesc.focus();
					return false;
				}
			}
			if (cmd == 'createComment' || cmd == 'updateComment') {
				if (document.form1.commentTopic.value == '') {
					alert("Empty topic.");
					document.form1.commentTopic.focus();
					return false;
				}
				$('#select2 option').each(function(i) {
					$(this).attr("selected", "selected");
				});
				$('#select4 option').each(function(i) {
					$(this).attr("selected", "selected");
				});
			}
			if (cmd == 'createComment' || cmd == 'updateComment' || cmd == 'replyComment') {
				if (document.form1.comment.value == '') {
					alert("Empty comment.");
					document.form1.comment.focus();
					return false;
				}
			}
		} else {
			if (cmd == 'delete') {
				$.prompt('<bean:message key="message.record.delete" />!',{
					buttons: { Ok: true, Cancel: false },
					callback: function(v,m,f){
						if (v){
							submit: submitAction('delete', 1);
							return true;
						} else {
							return false;
						}
					},
					prefix:'cleanblue'
				});
				return false;
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function changeInvolveUserID() {
		var did = document.form1.involveDeptCode.value;

		http.open('get', '../ui/staffIDCMB.jsp?deptCode=' + did + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponseInvolveUserID;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function processResponseInvolveUserID() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("showInvolveUserID_indicator").innerHTML = '<select name="involveUserID">' + response + '</select>';

			// reset staff id
			document.form1.nomineeStaffID.value = "";
		}
	}

	function showComment(cmd, cid) {
		//preset hidden value
		document.form1.commentID.value = cid;

		if (cmd == 'viewComment') {
			// hide overall summary
			$('#showOverall_indicator').hide();
		} else if (cmd == 'hiddenComment') {
			// hide overall summary
			$('#showOverall_indicator').show();
		}

		http.open('get', 'summary_view.jsp?command=' + cmd + '&projectID=<%=projectID %>&commentID=' + cid + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponseComment;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function processResponseComment() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("showComment_indicator").innerHTML = response;

			// set a fixed date for the demo to be independent of the current date
			$.prettyDate.now = function() {
				return new Date("<%=DateTimeUtil.getCurrentDateTimeStandard() %>");
			}
			$("span").prettyDate();
		}
	}

	var divShow_indicator;

	function showSearch() {
		var contactType = document.form1.searchContactType.value;
		var dateRange = document.form1.searchDateRange.value;
		var dateFrom = document.form1.searchDateFrom.value;
		var dateTo = document.form1.searchDateTo.value;
		var commentType = document.form1.searchCommentType.value;
		var sortBy = document.form1.searchSortBy.value;
		var ordering = document.form1.ordering.value;
		var topic = document.form1.searchTopic.value;

		// set display indicator
		divShow_indicator = "showSearch_indicator";

		http.open('get', 'summary_outstanding.jsp?projectID=<%=projectID %>&contactType=' + contactType + '&dateRange=' + dateRange + '&dateFrom=' + dateFrom + '&dateTo=' + dateTo + '&commentType=' + commentType + '&sortBy=' + sortBy + '&ordering=' + ordering + '&topic=' + topic + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function addCommentLink(cid) {
		var lpid = document.form1.linkProjectID.value;

		http.open('get', 'summary_link.jsp?command=addCommentLink&projectID=<%=projectID %>&commentID=' + cid + '&linkProjectID=' + lpid + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		// set display indicator
		divShow_indicator = "linkComment_indicator";

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function removeCommentLink(cid) {
		http.open('get', 'summary_link.jsp?command=deleteCommentLink&projectID=<%=projectID %>&commentID=' + cid + '&allowRemove=Y&timestamp=<%=(new java.util.Date()).getTime() %>');

		// set display indicator
		divShow_indicator = "linkComment_indicator";

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function showCommentArchive() {
		http.open('get', 'summary_helper.jsp?projectID=<%=projectID %>&category=archive&timestamp=<%=(new java.util.Date()).getTime() %>');

		// set display indicator
		divShow_indicator = "showArchive_indicator";

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function removeDocument(cid, did) {
		var allowRemove;
		// set display indicator
		if (cid == '0') {
			divShow_indicator = "showProjectDocument_indicator";
			allowRemove = 'Y';
		} else {
			divShow_indicator = "showCommentDocument_indicator";
			allowRemove = '<%=updateCommentAction || editCommentAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE %>';
		}

		http.open('get', '../common/attach_document.jsp?command=deleteDocument&moduleID=pmp&keyID=<%=projectID %>&key2ID=' + cid + '&documentID=' + did + '&allowRemove=' + allowRemove + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById(divShow_indicator).innerHTML = response;
		}
	}

	function showhide(i, hideobj, showobj, showhidelink, hidelink, showlink){
		var showelem = document.getElementById(showobj + i);
		var hideelem = document.getElementById(hideobj + i);
		var linkelem=document.getElementById(showhidelink + i);

		showelem.style.display=showelem.style.display=='none'?'inline':'none';
		hideelem.style.display=hideelem.style.display=='none'?'inline':'none';

		if (hideelem.style.display=='none'){
			linkelem.className="invisible";
			linkelem.innerHTML = showlink;
		} else {
			linkelem.className="visible";
			linkelem.innerHTML = hidelink;
		}
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>