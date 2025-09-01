<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
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

boolean isIssue = false;
boolean isOutstanding = false;

String columnTitle = request.getParameter("columnTitle");
String projectID = request.getParameter("projectID");
String commentID = request.getParameter("commentID");
String category = request.getParameter("category");
String contactType = request.getParameter("contactType");
String dateRange = request.getParameter("dateRange");
String dateFrom = request.getParameter("dateFrom");
String dateTo = request.getParameter("dateTo");
String commentType = request.getParameter("commentType");
String sortBy = request.getParameter("sortBy");
String ordering = request.getParameter("ordering");
String topic = request.getParameter("topic");
String deptCodeInclude = request.getParameter("deptCodeInclude");
String deptCodeExclude = request.getParameter("deptCodeExclude");

ArrayList result = null;

// default column title
if (columnTitle == null && category != null) {
	columnTitle = category.toUpperCase();
}

if ("issue".equals(category)) {
	isIssue = true;
	result = ProjectSummaryDB.getCommentList(userBean, projectID, category);
} else if ("todo".equals(category)) {
	result = ProjectSummaryDB.getCommentToDoList(userBean, projectID, deptCodeInclude, deptCodeExclude);
} else {
	isOutstanding = true;
	result = ProjectSummaryDB.getCommentList(userBean, projectID, contactType, dateRange, dateFrom, dateTo, commentType, topic, sortBy, ordering, !"archive".equals(category));
}

ReportableListObject row = null;
String commentTypeColor = null;
String topicDesc = null;
String commentDesc = null;
String issuerDeptDesc = null;
String issuerName = null;
String involveDeptDesc = null;
String deadline = null;
String deadlineColor = null;
String modifiedDate = null;
String issuerDeptDesc_prev = null;

int count = 0;
boolean isNewIssuerDept = false;

	if (columnTitle != null && columnTitle.length() > 0) {
%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td class="title"><span><%=columnTitle %> <img src="../images/title_arrow.gif"></span></td></tr>
				<tr><td height="2" bgcolor="#840010"></td></tr>
				<tr><td height="10"></td></tr>
			</table>
<%
	}
	String todayDate = DateTimeUtil.getCurrentDate();
	if (result.size() > 0) {
		for (int i = 0; i < result.size(); i++) {
			row = (ReportableListObject) result.get(i);
			commentID = row.getValue(0);
			commentType = row.getValue(1);
			if ("urgent".equals(commentType) || "to do".equals(commentType) || "in progress".equals(commentType)) {
				commentTypeColor = "_urgent";
			} else {
				commentTypeColor = "";
			}
			topicDesc = row.getValue(2);
			commentDesc = row.getValue(3);
			if (commentDesc != null && commentDesc.length() > 300) {
				commentDesc = commentDesc.substring(0, 300) + " ..";
			}
			issuerDeptDesc = row.getValue(4);
			issuerName = row.getValue(5);
			if (issuerName == null || issuerName.length() == 0) {
				issuerName = row.getValue(6);
			}
			if (issuerDeptDesc == null || issuerDeptDesc.length() == 0) {
				issuerDeptDesc = issuerName==null?"Others":issuerName.toUpperCase();
			}
			involveDeptDesc = row.getValue(7);
			if (involveDeptDesc == null || involveDeptDesc.length() == 0) {
				involveDeptDesc = "N/A";
			}
			deadline = row.getValue(8);
			if (deadline != null && deadline.length() > 0 && DateTimeUtil.compareTo(todayDate, deadline) > 0) {
				deadlineColor = "_urgent";
			} else {
				deadlineColor = "";
			}
			modifiedDate = row.getValue(9);
			isNewIssuerDept = !issuerDeptDesc.equals(issuerDeptDesc_prev);

			if (isOutstanding) {
				count++;
%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="most_popular" bgcolor="#<%=(count%2==1)?"FFFFFF":"e8e8e8"%>" width="15" valign="top">
						<b class="pupular_content"><%=count %>.</b>
					</td>
					<td class="most_popular" bgcolor="#<%=(count%2==1)?"FFFFFF":"e8e8e8"%>">
						<a href="javascript:void(0);" onclick="showComment('viewComment', '<%=commentID %>');return false;" class="topstoryblue"><H2 id="TS"><%=topicDesc %></H2></a>
						<br><span class="reported_quote"><%=modifiedDate %> by <%=issuerName %></span>
						<br><span class="reported_quote"><b><bean:message key="prompt.type" />:</b></span> <span class="reported_quote<%=commentTypeColor %>"><%=commentType.toUpperCase() %></span>
						<br><span class="reported_quote"><b>Handle By:</b> <%=involveDeptDesc %></span>
						<br><span class="reported_quote"><b><bean:message key="prompt.deadline" />:</b></span> <span class="reported_quote<%=deadlineColor %>"><%=deadline==null||deadline.length()==0?"N/A":deadline %></span>
					</td>
					<td bgcolor="#FFFFFF" width="10">&nbsp;</td>
				</tr>
			</table>
<%			} else { %>
<%				if (isNewIssuerDept) { %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td class="title"><span><%=issuerDeptDesc %></span></td></tr>
				<tr><td height="2" bgcolor="#840010"></td></tr>
				<tr><td height="10"></td></tr>
			</table>
<%				} %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="h1_margin">
						<a href="#" onclick="showComment('viewComment', '<%=commentID %>');" class="topstoryblue"><H1 id="TS"><%=topicDesc %></H1></a>
					</td>
				</tr>
				<tr><td height="2" bgcolor="#F2F2F2"></td></tr>
				<tr>
					<td class="h1_margin">
						<span class="pupular_content" style="line-height: 13px"><%=commentDesc %></span>
<%				if (isIssue) { %>
						<br><span class="reported_quote"><%=modifiedDate %> by <%=issuerName %></span>
						<br><span class="reported_quote"><b>Handle By:</b> <%=involveDeptDesc %></span>
<%				} else { %>
						<br><span class="reported_quote"><%=modifiedDate %> to <%=issuerName==null||issuerName.length()==0?issuerDeptDesc:issuerName %></span>
						<br><span class="reported_quote"><b><bean:message key="prompt.type" />:</b></span> <span class="reported_quote<%=commentTypeColor %>"><%=commentType.toUpperCase() %></span>
						<br><span class="reported_quote"><b><bean:message key="prompt.deadline" />:</b></span> <span class="reported_quote<%=deadlineColor %>"><%=deadline==null||deadline.length()==0?"N/A":deadline %></span>
<%				} %>
					</td>
				</tr>
				<tr><td height="7">&nbsp;</td></tr>
			</table>
<%			}
			// keep previous news type
			issuerDeptDesc_prev = issuerDeptDesc;
		}
	}
%>