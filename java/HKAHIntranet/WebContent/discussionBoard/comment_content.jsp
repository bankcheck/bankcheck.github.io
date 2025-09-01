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
%>
<tr>
	<td class="topstoryblue">
	</td>
</tr>
<tr>
	<td class="h1_margin">
		<span class="pupular_content" style="line-height: 13px">
			<span id="rr_hideobj_0" style="display:none"><c:out value="${discussionBoard.comment.dbCommentDesc}" /></span>
			<span id="rr_showobj_0" style="display:inline"><c:out value="${discussionBoard.comment.dbTopicDesc}" /></span><br/>
			<span id="rr_showhidelink_0" style="CURSOR: pointer" class="visible" onclick="showhide(0, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '[+] More Comment', '[-] Brief Comment');return false;">[-] Brief Comment</span>
		</span>
	</td>
</tr>
<tr><td height="7">&nbsp;</td></tr>
