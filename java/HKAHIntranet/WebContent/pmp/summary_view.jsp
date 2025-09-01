<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String step = request.getParameter("step");

String projectID = request.getParameter("projectID");
String commentID = request.getParameter("commentID");

String fromStaffID = null;
String[] toStaffID = null;
String[] ccStaffID = null;
StringBuffer toEmail = new StringBuffer();
StringBuffer ccEmail = new StringBuffer();
String commentTopic = null;
String comment = null;
String involveDeptCode = null;
String involveDeptDesc = null;
String involveUserID = null;
String involveUserDesc = null;
String commentType = null;
String deadline = null;
String modifiedDate = null;
String modifiedUser = null;
boolean emailNotify = false;
int noOfDocument = 0;

HashMap staffInfo = new HashMap();

boolean createCommentAction = false;
boolean updateCommentAction = false;
boolean editCommentAction = false;
boolean viewCommentAction = false;
boolean replyCommentAction = false;
boolean hiddenCommentAction = false;
boolean allowToEdit = false;

if ("createComment".equals(command)) {
	createCommentAction = true;
} else if ("updateComment".equals(command)) {
	updateCommentAction = true;
} else if ("editComment".equals(command)) {
	editCommentAction = true;
} else if ("replyComment".equals(command)) {
	replyCommentAction = true;
} else if ("viewComment".equals(command)) {
	viewCommentAction = true;
} else {
	hiddenCommentAction = true;
}

try {
	// load data from database
	if ((updateCommentAction || editCommentAction || replyCommentAction || viewCommentAction)
			&& commentID != null && commentID.length() > 0) {
		ArrayList record = ProjectSummaryDB.get(projectID);
		ArrayList record2 = null;
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			String requestUserID = row.getValue(2);
			if (userBean.getStaffID().equals(requestUserID)
				|| userBean.getUserName().equals(requestUserID)
				|| userBean.isAccessible("function.projectSummary.supervisor")) {
				allowToEdit = true;
			}

			record = ProjectSummaryDB.getComment(projectID, commentID);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				commentType = row.getValue(0);
				commentTopic = row.getValue(1);
				comment = row.getValue(2);
				involveDeptCode = row.getValue(3);
				involveDeptDesc = row.getValue(4);
				involveUserID = row.getValue(5);
				involveUserDesc = row.getValue(6);
				if (involveUserDesc == null || involveUserDesc.length() == 0) {
					involveUserDesc = row.getValue(7).toUpperCase();
				}
				deadline = row.getValue(8);
				modifiedDate = row.getValue(9);
				modifiedUser = row.getValue(10);
				if (modifiedUser == null || modifiedUser.length() == 0) {
					modifiedUser = row.getValue(11).toUpperCase();
				}
				emailNotify = ConstantsVariable.YES_VALUE.equals(row.getValue(12));
				
				// retrieve full comment
				record2 = ProjectSummaryDB.getContent(projectID, commentID, ConstantsVariable.ZERO_VALUE);
				if (record2.size() > 1) {
					StringBuffer sb = new StringBuffer();
					for (int i = 0; i < record2.size(); i++) {
						ReportableListObject row2 = null;
						row2 = (ReportableListObject) record2.get(i);
						sb.append(row2.getValue(0));
					}
					comment = sb.toString();
				}
			}

			record = ProjectSummaryDB.getContactList(projectID, commentID);
			if (record.size() > 0) {
				Vector toStaffID_Vector = new Vector();
				Vector ccStaffID_Vector = new Vector();
				String tempStaffID = null;
				String tempEmail = null;
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
					tempStaffID = row.getValue(2);
					tempEmail = row.getValue(6);
					if (tempEmail == null || tempEmail.length() == 0) {
						tempEmail = row.getValue(7);
					}
					if (!ConstantsVariable.MINUS_VALUE.equals(tempStaffID)) {
						if ("from".equals(row.getValue(0))) {
							fromStaffID = tempStaffID;
							if (userBean.getStaffID().equals(fromStaffID) || userBean.getUserName().equals(fromStaffID)) {
								allowToEdit = true;
							}
						} else if ("to".equals(row.getValue(0))) {
							toStaffID_Vector.add(tempStaffID);
							if (userBean.getStaffID().equals(tempStaffID) || userBean.getUserName().equals(tempStaffID)) {
								allowToEdit = true;
							}
						} else if ("cc".equals(row.getValue(0))) {
							ccStaffID_Vector.add(tempStaffID);
						}
						if (row.getValue(3) != null && row.getValue(3).length() > 0) {
							staffInfo.put(tempStaffID, row.getValue(3) + " (" + row.getValue(5) + ")");
						} else {
							staffInfo.put(tempStaffID, row.getValue(2).toUpperCase());
						}
					} else {
						if ("to".equals(row.getValue(0))) {
							toEmail.append(tempEmail);
							toEmail.append(ConstantsVariable.COMMA_VALUE);
						} else if ("cc".equals(row.getValue(0))) {
							ccEmail.append(tempEmail);
							ccEmail.append(ConstantsVariable.COMMA_VALUE);
						}
					}
				}
				toStaffID = (String[]) toStaffID_Vector.toArray(new String[toStaffID_Vector.size()]);
				ccStaffID = (String[]) ccStaffID_Vector.toArray(new String[ccStaffID_Vector.size()]);
			}

			record = AttachDocumentDB.getDocument("pmp", projectID, commentID);
			noOfDocument = record.size();
		} else {
			createCommentAction = true;
		}
	} else {
		// reset content
		fromStaffID = userBean.getStaffID();
		toStaffID = null;
		ccStaffID = null;
		commentTopic = null;
		involveDeptCode = userBean.getDeptCode();
		involveUserID = userBean.getStaffID();
		comment = null;
		commentType = "issue";
		deadline = null;
	}
} catch (Exception e) {
	e.printStackTrace();
}

String allowRemove = updateCommentAction || editCommentAction?"Y":"N";
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
<%if (!hiddenCommentAction) { %>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle"><bean:message key="prompt.comment" /></td>
		<td class="infoButton" align="right">
<%	if (createCommentAction) { %>
			<button onclick="submitAction('createComment', 1);return false;" class="btn-click"><bean:message key="button.save" /></button>
			<button onclick="showComment('hiddenComment', '');return false;" class="btn-click"><bean:message key="label.cancel" /></button>
<%	} else if (updateCommentAction) { %>
<%		if (allowToEdit) { %>
			<button onclick="submitAction('updateComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.update" /></button>
<%		} %>
			<button onclick="showComment('viewComment', '<%=commentID %>');return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.update" /></button>
<%	} else if (editCommentAction) { %>
<%		if (allowToEdit) { %>
			<button onclick="submitAction('editComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.edit" /></button>
<%		} %>
			<button onclick="showComment('viewComment', '<%=commentID %>');return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.edit" /></button>
<%	} else if (replyCommentAction) { %>
			<button onclick="submitAction('replyComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.update" /></button>
			<button onclick="showComment('viewComment', '<%=commentID %>');return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.update" /></button>
<%	} else if (viewCommentAction) { %>
<%		if (allowToEdit) { %>
			<button onclick="submitAction('updateComment', 0);return false;" class="btn-click"><bean:message key="button.update" /></button>
<%		} else { %>
			<button onclick="submitAction('replyComment', 0);return false;" class="btn-click">Reply</button>
<%		} %>
			<button onclick="showComment('hiddenComment', '');return false;" class="btn-click"><bean:message key="label.cancel" /></button>
<%	} %>
		</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="10%"><bean:message key="prompt.from" /></td>
		<td class="infoData" width="90%" colspan=3">
<%	if (createCommentAction || updateCommentAction || editCommentAction) { %>
			<select name="fromStaffID">
<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
	<jsp:param name="value" value="<%=fromStaffID %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>
<%	} else { %>
		<%=staffInfo.get(fromStaffID) %>
<%	} %>
		</td>
	</tr>
<%	if ((emailNotify && toStaffID != null && toStaffID.length > 0) || createCommentAction || updateCommentAction || editCommentAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="10%"><bean:message key="prompt.to" /></td>
		<td class="infoData" width="90%" colspan=3">
<%		if (createCommentAction || updateCommentAction || editCommentAction) { %>
			<table border="0">
				<tr>
					<td>
						<select name="toStaffID" size="3" multiple id="select2">
<%			if (toStaffID != null) {
				for (int i = 0; i < toStaffID.length; i++) {
					%><option value="<%=toStaffID[i] %>"><%=staffInfo.get(toStaffID[i]) %><%
				}
			} %>
						</select>
					</td>
					<td>
						<button id="remove1"><bean:message key="button.delete" /></button>
					</td>
				</tr>
				<tr>
					<td>
						<select name="responseByIDAvailable" id="select1">
							<option value="">--Select Staff--</option>
<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
	<jsp:param name="value" value="<%=userBean.getStaffID() %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
						</select>
					</td>
					<td>
						<button id="add1"><bean:message key="button.add" /></button>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<textarea name="toEmail" rows="2" cols="160"><%=toEmail.toString() %></textarea><br/>
						Free Text Email (Please use semicolon(;) to separate each email)
					</td>
				</tr>
			</table>
<%		} else {
			if (toStaffID != null) {
				for (int i = 0; i < toStaffID.length; i++) {
					%><%=staffInfo.get(toStaffID[i]) %>; <%
				}
			}
		} %>
		</td>
	</tr>
<%	} %>
<%	if ((emailNotify && ccStaffID != null && ccStaffID.length > 0) || createCommentAction || updateCommentAction || editCommentAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="10%">CC</td>
		<td class="infoData" width="90%" colspan=3">
<%		if (createCommentAction || updateCommentAction || editCommentAction) { %>
			<table border="0">
				<tr>
					<td>
						<select name="ccStaffID" size="3" multiple id="select4">
<%			if (ccStaffID != null) {
				for (int i = 0; i < ccStaffID.length; i++) {
					%><option value="<%=ccStaffID[i] %>"><%=staffInfo.get(ccStaffID[i]) %><%
				}
			} %>
						</select>
					</td>
					<td>
						<button id="remove2"><bean:message key="button.delete" /></button>
					</td>
				</tr>
				<tr>
					<td>
						<select name="responseByIDAvailable2" id="select3">
							<option value="">--Select Staff--</option>
<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
	<jsp:param name="value" value="<%=userBean.getStaffID() %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
						</select>
					</td>
					<td>
						<button id="add2"><bean:message key="button.add" /></button>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<textarea name="ccEmail" rows="2" cols="160"><%=ccEmail.toString() %></textarea><br/>
						Free Text Email (Please use semicolon(;) to separate each email)
					</td>
				</tr>
			</table>
<%		} else {
			if (ccStaffID != null) {
				for (int i = 0; i < ccStaffID.length; i++) {
					%><%=staffInfo.get(ccStaffID[i]) %>;<%
				}
			}
		} %>
		</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoLabel" width="10%"><bean:message key="prompt.topic" /></td>
		<td class="infoData" width="40%">
<%	if (createCommentAction || updateCommentAction || editCommentAction) { %>
			<input type="textfield" name="commentTopic" value="<%=commentTopic==null?"":commentTopic %>" maxlength="50" size="50">
<%	} else { %>
			<%=commentTopic==null?"":commentTopic %>
<%	} %>
		</td>
		<td class="infoLabel" width="10%"><bean:message key="prompt.type" /></td>
		<td class="infoData" width="40%">
<%	if (createCommentAction || updateCommentAction || editCommentAction) { %>
			<input type="radio" name="commentType" value="issue"<%="issue".equals(commentType)?" checked":"" %>><bean:message key="label.issue" />&nbsp;&nbsp;
			<input type="radio" name="commentType" value="memo"<%="memo".equals(commentType)?" checked":"" %>><bean:message key="label.memo" />&nbsp;&nbsp;
			<input type="radio" name="commentType" value="to do"<%="to do".equals(commentType)?" checked":"" %>><bean:message key="label.todo" />&nbsp;&nbsp;
			<input type="radio" name="commentType" value="in progress"<%="in progress".equals(commentType)?" checked":"" %>><bean:message key="label.inprogress" />&nbsp;&nbsp;
			<input type="radio" name="commentType" value="pending"<%="pending".equals(commentType)?" checked":"" %>><bean:message key="label.pending" />&nbsp;&nbsp;
			<input type="radio" name="commentType" value="archive"<%="archive".equals(commentType)?" checked":"" %>><bean:message key="label.archive" />&nbsp;&nbsp;
			<%if (updateCommentAction || editCommentAction) {%><input type="radio" name="commentType" value="delete"<%="delete".equals(commentType)?" checked":"" %>><bean:message key="button.delete" /><%} %>
<%	} else {
		if ("q & a".equals(commentType)) {
			%><bean:message key="label.qna" /><%
		} else if ("issue".equals(commentType)) {
			%><bean:message key="label.issue" /><%
		} else if ("urgent".equals(commentType)) {
			%><bean:message key="label.urgent" /><%
		} else if ("memo".equals(commentType)) {
			%><bean:message key="label.memo" /><%
		} else if ("to do".equals(commentType)) {
			%><bean:message key="label.todo" /><%
		} else if ("in progress".equals(commentType)) {
			%><bean:message key="label.inprogress" /><%
		} else if ("pending".equals(commentType)) {
			%><bean:message key="label.pending" /><%
		} else if ("done".equals(commentType)) {
			%><bean:message key="label.done" /><%
		} else if ("archive".equals(commentType)) {
			%><bean:message key="label.archive" /><%
		} else if ("delete".equals(commentType)) {
			%><bean:message key="button.delete" /><%
		}
	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="10%">Handle By</td>
		<td class="infoData" width="90%" colspan=3">
<%	if (createCommentAction || updateCommentAction || editCommentAction) { %>
			<select name="involveDeptCode" onchange="return changeInvolveUserID()">
				<option value="">-- Department --</option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=involveDeptCode %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>&nbsp;/&nbsp;
			<span id="showInvolveUserID_indicator">
				<select name="involveUserID">
					<option value="">-- Staff --</option>
<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=involveDeptCode %>" />
	<jsp:param name="value" value="<%=involveUserID %>" />
</jsp:include>
				</select>
			</span>
<%	} else { %>
			<%=involveDeptDesc==null?"":involveDeptDesc %>&nbsp;/&nbsp;
			<%=involveUserDesc==null?"":involveUserDesc %>
<%	} %>
		</td>
	</tr>
<%	if (updateCommentAction || editCommentAction || noOfDocument > 0) { %>
	<tr class="smallText">
		<td class="infoLabel" width="10%"><bean:message key="prompt.document" /></td>
		<td class="infoData" width="90%" colspan=3">
			<span id="showCommentDocument_indicator">
<jsp:include page="../common/attach_document.jsp" flush="false">
	<jsp:param name="moduleID" value="pmp" />
	<jsp:param name="keyID" value="<%=projectID %>" />
	<jsp:param name="key2ID" value="<%=commentID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
			</span>
<%		if (createCommentAction) { %>
			Only available after create comment
<%		} else if (updateCommentAction || editCommentAction) { %>
			<input type="file" name="file1" size="50" class="multi" maxlength="10">
<%		} %>
		</td>
	</tr>
<%	} %>
<%	if (createCommentAction || updateCommentAction || editCommentAction || replyCommentAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="10%">Email Notify</td>
		<td class="infoData" width="90%" colspan="3">
			<input type="radio" name="emailNotify" value="YY"><bean:message key="label.yes" /> (login)
<%		if (createCommentAction || updateCommentAction || editCommentAction) { %>
			<input type="radio" name="emailNotify" value="YN"><bean:message key="label.yes" /> (create comment)
<%		} %>
			<input type="radio" name="emailNotify" value="N" checked><bean:message key="label.no" />
		</td>
	</tr>
<%	} %>
<%	if (createCommentAction || updateCommentAction || editCommentAction || replyCommentAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="10%"><bean:message key="prompt.comment" /></td>
		<td class="infoData" width="90%" colspan=3">
			<div class="box"><textarea id="wysiwyg" name="comment" rows="20" cols="160"><%if (editCommentAction) { %><%=comment %><%} %></textarea></div>
		</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoLabel" width="10%"><bean:message key="prompt.deadline" /></td>
		<td class="infoData" width="40%">
<%	if (createCommentAction || updateCommentAction || editCommentAction) { %>
			<input type="textfield" name="deadline" id="deadline" class="datepickerfield" value="<%=deadline==null?"":deadline %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
<%	} else { %>
			<%=deadline==null?"":deadline %>
<%	} %>
			(DD/MM/YYYY)</td>
		<td class="infoLabel" width="10%">Link with project</td>
		<td class="infoData" width="40%">
<%	if (createCommentAction) { %>
			Only available after create comment
<%	} else {%>
			<span id="linkComment_indicator">
<jsp:include page="summary_link.jsp" flush="false">
	<jsp:param name="command" value="<%=command %>" />
	<jsp:param name="projectID" value="<%=projectID %>" />
	<jsp:param name="commentID" value="<%=commentID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
			</span>
<%	} %>
		</td>
	</tr>
<%	if (!createCommentAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="10%">History</td>
		<td class="infoData" width="90%" colspan=3">
			<div id="rr_listing">
				<table border="0" width="100%" cellspacing="0" cellpadding="0">
<jsp:include page="summary_history.jsp" flush="false">
	<jsp:param name="projectID" value="<%=projectID %>" />
	<jsp:param name="commentID" value="<%=commentID %>" />
	<jsp:param name="allowToEditStr" value="<%=allowToEdit ? ConstantsVariable.YES_VALUE: ConstantsVariable.NO_VALUE %>" />
</jsp:include>
				</table>
			</div>
		</td>
	</tr>
<%	} %>
</table>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle">&nbsp;</td>
		<td class="infoButton" align="right">
<%	if (createCommentAction) { %>
			<button onclick="submitAction('createComment', 1);return false;" class="btn-click"><bean:message key="button.save" /></button>
			<button onclick="showComment('hiddenComment', '');return false;" class="btn-click"><bean:message key="label.cancel" /></button>
<%	} else if (updateCommentAction) { %>
<%		if (allowToEdit) { %>
			<button onclick="submitAction('updateComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.update" /></button>
<%		} %>
			<button onclick="showComment('viewComment', '<%=commentID %>');return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.update" /></button>
<%	} else if (editCommentAction) { %>
<%		if (allowToEdit) { %>
			<button onclick="submitAction('editComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.edit" /></button>
<%		} %>
			<button onclick="showComment('viewComment', '<%=commentID %>');return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.edit" /></button>
<%	} else if (replyCommentAction) { %>
			<button onclick="submitAction('replyComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.update" /></button>
			<button onclick="showComment('viewComment', '<%=commentID %>');return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.update" /></button>
<%	} else if (viewCommentAction) { %>
<%		if (allowToEdit) { %>
			<button onclick="submitAction('updateComment', 0);return false;" class="btn-click"><bean:message key="button.update" /></button>
<%		} else { %>
			<button onclick="submitAction('replyComment', 0);return false;" class="btn-click">Reply</button>
<%		} %>
			<button onclick="showComment('hiddenComment', '');return false;" class="btn-click"><bean:message key="label.cancel" /></button>
<%	} %>
		</td>
	</tr>
</table>
<%} %>