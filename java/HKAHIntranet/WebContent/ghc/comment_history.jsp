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
String clientID = request.getParameter("clientID");
String topic = null;
String comment = null;
String comment1 = null;
String requestTo = null;
String modifiedDateTime = null;
String modifiedDate = null;
String modifiedTime = null;
String modifiedUser = null;

boolean moreDetail = false;

ArrayList record = null;
ReportableListObject row = null;

record = GHCClientDB.getCommentList(userBean, clientID);
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		topic = row.getValue(1);
		comment = row.getValue(2);
		if (comment != null && comment.length() > 300) {
			comment1 = comment.substring(0, 300);
			moreDetail = true;
		} else {
			comment1 = comment;
			moreDetail = false;
		}
		requestTo = row.getValue(3);
		modifiedDateTime = row.getValue(4);
		modifiedDate = DateTimeUtil.date4Compare(modifiedDateTime.substring(0, 10), true);
		modifiedTime = modifiedDateTime.substring(11);
		modifiedUser = row.getValue(5);
%>
			<tr>
				<td class="h1_margin"><a href="javascript:void(0);" class="topstoryblue"><H1 id="TS">[<%=requestTo==null?"":requestTo.toUpperCase() %>] <%=topic %></H1></a></td>
			</tr>
			<tr>
				<td class="h1_margin">
					<span class="pupular_content" style="line-height: 13px">
						<span id="rr_hideobj_<%=i + 1 %>" style="display:<%if (i == 0) { %>none<%} else {%>inline<%} %>"><%=comment1 %><%if (moreDetail) { %>...<%} %></span>
						<span id="rr_showobj_<%=i + 1 %>" style="display:<%if (i == 0) { %>inline<%} else {%>none<%} %>"><%=comment %></span><br/>
						<span id="rr_showhidelink_<%=i + 1 %>" style="CURSOR: pointer" class="visible" onclick="return showhide(<%=i + 1 %>, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '[+]More', '[-]Brief');"><%if (i == 0) { %>[-]Brief<%} else {%>[+]More<%} %></span>
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