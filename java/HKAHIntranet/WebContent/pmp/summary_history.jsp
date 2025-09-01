<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements. See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License. You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
UserBean userBean = new UserBean(request);
String projectID = request.getParameter("projectID");
String commentID = request.getParameter("commentID");
String historyID = null;
String comment = null;
String comment1 = null;
String modifiedDateTime = null;
String modifiedDate = null;
String modifiedTime = null;
String modifiedUser = null;

boolean emailNotify = false;
boolean moreDetail = false;
boolean allowToEdit = ConstantsVariable.YES_VALUE.equals(request.getParameter("allowToEditStr"));

ArrayList record = null;
ArrayList record2 = null;
ReportableListObject row = null;
StringBuffer fromStaffID = new StringBuffer();
StringBuffer toStaffID = new StringBuffer();
StringBuffer ccStaffID = new StringBuffer();

record = ProjectSummaryDB.getComment(projectID, commentID);
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	comment = row.getValue(2);
	modifiedDateTime = row.getValue(9);
	modifiedDate = DateTimeUtil.date4Compare(modifiedDateTime.substring(0, 10), true);
	modifiedTime = modifiedDateTime.substring(11);
	modifiedUser = row.getValue(10);
	if (modifiedUser == null || modifiedUser.length() == 0) {
		modifiedUser = row.getValue(11).toUpperCase();
	}
	emailNotify = ConstantsVariable.YES_VALUE.equals(row.getValue(12));

	// retrieve full comment
	record2 = ProjectSummaryDB.getContent(projectID, commentID, ConstantsVariable.ZERO_VALUE);
	if (record2.size() > 1) {
		StringBuffer sb = new StringBuffer();
		ReportableListObject row2 = null;
		for (int j = 0; j < record2.size(); j++) {
			row2 = (ReportableListObject) record2.get(j);
			sb.append(row2.getValue(0));
		}
		comment = sb.toString();
	}
	if (comment != null && comment.length() > 300) {
		comment1 = comment.substring(0, 300);
		moreDetail = true;
	} else {
		comment1 = comment;
		moreDetail = false;
	}
}
%>
			<tr>
				<td class="topstoryblue">
<%
String tempStaffID = null;
String tempEmail = null;
if (emailNotify) {
	record2 = ProjectSummaryDB.getContactList(projectID, commentID);
	if (record2.size() > 0) {
		fromStaffID.setLength(0);
		toStaffID.setLength(0);
		ccStaffID.setLength(0);
		for (int j = 0; j < record2.size(); j++) {
			row = (ReportableListObject) record2.get(j);
			tempStaffID = row.getValue(2);
			tempEmail = row.getValue(6);
			if (tempEmail == null || tempEmail.length() == 0) {
				tempEmail = row.getValue(7);
			}
			if ("from".equals(row.getValue(0))) {
				fromStaffID.append(row.getValue(3));
				fromStaffID.append(ConstantsVariable.COMMA_VALUE);
			} else if ("to".equals(row.getValue(0))) {
				if (!ConstantsVariable.MINUS_VALUE.equals(tempStaffID)) {
					toStaffID.append(row.getValue(3));
				} else {
					toStaffID.append(tempEmail);
				}
				toStaffID.append(ConstantsVariable.COMMA_VALUE);
			} else if ("cc".equals(row.getValue(0))) {
				if (!ConstantsVariable.MINUS_VALUE.equals(tempStaffID)) {
					ccStaffID.append(row.getValue(3));
				} else {
					ccStaffID.append(tempEmail);
				}
				ccStaffID.append(ConstantsVariable.COMMA_VALUE);
			}
		}
	}
	if (fromStaffID.length() > 0) {
		%>From: (<%=fromStaffID.toString() %>)&nbsp;<%
	}
	if (toStaffID.length() > 0) {
		%>To: (<%=toStaffID.toString() %>)&nbsp;<%
	}
	if (ccStaffID.length() > 0) {
		%>CC: (<%=ccStaffID.toString() %>)&nbsp;<%
	}
}
%>
				</td>
			</tr>
			<tr>
				<td class="h1_margin">
					<span class="pupular_content" style="line-height: 13px">
						<span id="rr_hideobj_0" style="display:none"><%=comment1 %><%if (moreDetail) { %>...<%} %></span>
						<span id="rr_showobj_0" style="display:inline"><%=comment %></span><br/>
						<span id="rr_showhidelink_0" style="CURSOR: pointer" class="visible" onclick="showhide(0, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '[+] More Comment', '[-] Brief Comment');return false;">[-] Brief Comment</span>
					</span>
				</td>
			</tr>
			<tr><td height="7">&nbsp;</td></tr>
			<tr class="topstoryblue">
				<td>
					<i>Posted <span class="time" title="<%=modifiedDate%>T<%=modifiedTime %>:00Z"><%=modifiedDateTime %></span> by <b><%=modifiedUser %></b></i>
<%	if (allowToEdit && userBean.getUserName().equals(modifiedUser)) { %>
					<button onclick="submitAction('editComment', 0);return false;" class="btn-click"><bean:message key="button.edit" /></button>
				</td>
<%	} %>
			</tr>
			<tr><td height="7"><HR/></td></tr>
<%
record = ProjectSummaryDB.getCommentHistoryList(userBean, projectID, commentID);
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		historyID = row.getValue(0);
		comment = row.getValue(3);
		modifiedDateTime = row.getValue(10);
		modifiedDate = DateTimeUtil.date4Compare(modifiedDateTime.substring(0, 10), true);
		modifiedTime = modifiedDateTime.substring(11);
		modifiedUser = row.getValue(11);
		if (modifiedUser == null || modifiedUser.length() == 0) {
			modifiedUser = row.getValue(12).toUpperCase();
		}
		emailNotify = ConstantsVariable.YES_VALUE.equals(row.getValue(13));

		// retrieve full comment
		record2 = ProjectSummaryDB.getContent(projectID, commentID, ConstantsVariable.ZERO_VALUE);
		if (record2.size() > 1) {
			StringBuffer sb = new StringBuffer();
			ReportableListObject row2 = null;
			for (int j = 0; j < record2.size(); j++) {
				row2 = (ReportableListObject) record2.get(j);
				sb.append(row2.getValue(0));
			}
			comment = sb.toString();
		}
		if (comment != null && comment.length() > 300) {
			comment1 = comment.substring(0, 300);
			moreDetail = true;
		} else {
			comment1 = comment;
			moreDetail = false;
		}
%>
			<tr>
				<td class="topstoryblue">
<%
		if (emailNotify) {
			record2 = ProjectSummaryDB.getContactHistoryList(projectID, commentID, historyID);
			if (record2.size() > 0) {
				fromStaffID.setLength(0);
				toStaffID.setLength(0);
				ccStaffID.setLength(0);
				for (int j = 0; j < record2.size(); j++) {
					row = (ReportableListObject) record2.get(j);
					tempStaffID = row.getValue(2);
					tempEmail = row.getValue(6);
					if (tempEmail == null || tempEmail.length() == 0) {
						tempEmail = row.getValue(7);
					}
					if ("from".equals(row.getValue(0))) {
						fromStaffID.append(row.getValue(3));
						fromStaffID.append(ConstantsVariable.COMMA_VALUE);
					} else if ("to".equals(row.getValue(0))) {
						if (!ConstantsVariable.MINUS_VALUE.equals(tempStaffID)) {
							toStaffID.append(row.getValue(3));
						} else {
							toStaffID.append(tempEmail);
						}
						toStaffID.append(ConstantsVariable.COMMA_VALUE);
					} else if ("cc".equals(row.getValue(0))) {
						if (!ConstantsVariable.MINUS_VALUE.equals(tempStaffID)) {
							ccStaffID.append(row.getValue(3));
						} else {
							ccStaffID.append(tempEmail);
						}
						ccStaffID.append(ConstantsVariable.COMMA_VALUE);
					}
				}
			}
			if (fromStaffID.length() > 0) {
				%>From: (<%=fromStaffID.toString() %>)&nbsp;<%
			}
			if (toStaffID.length() > 0) {
				%>To: (<%=toStaffID.toString() %>)&nbsp;<%
			}
			if (ccStaffID.length() > 0) {
				%>CC: (<%=ccStaffID.toString() %>)&nbsp;<%
			}
		}
%>
				</td>
			</tr>
			
<%
	System.out.println("DEBUG: comment1 = " + comment1);
	System.out.println("DEBUG: comment = " + comment);
%>

			<tr>
				<td class="h1_margin">
					<span class="pupular_content" style="line-height: 13px">
						<span id="rr_hideobj_<%=i + 1 %>" style="display:<%if (i == 0) { %>none<%} else {%>inline<%} %>"><%=comment1 %><%if (moreDetail) { %>...<%} %></span>
						<span id="rr_showobj_<%=i + 1 %>" style="display:<%if (i == 0) { %>inline<%} else {%>none<%} %>"><%=comment %></span><br/>
						<span id="rr_showhidelink_<%=i + 1 %>" style="CURSOR: pointer" class="visible" onclick="return showhide(<%=i + 1 %>, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '[+] More Comment', '[-] Brief Comment');"><%if (i == 0) { %>[-] Brief Comment<%} else {%>[+] More Comment<%} %></span>
					</span>
				</td>
			</tr>
			<tr><td height="7">&nbsp;</td></tr>
			<tr class="topstoryblue">
				<td>
					<i>Posted <span class="time" title="<%=modifiedDate%>T<%=modifiedTime %>:00Z"><%=modifiedDateTime %></span> by <b><%=modifiedUser %></b></i>
				</td>
			</tr>
			<tr><td height="7"><HR/></td></tr>
<%
	}
}
%>