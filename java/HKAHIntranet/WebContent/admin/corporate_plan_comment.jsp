<%@ page import="java.io.*"%>
<%@ page import="java.lang.Integer"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
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
<%
UserBean userBean = new UserBean(request);
String deptCode = ParserUtil.getParameter(request, "deptCode");
String fiscalYear = ParserUtil.getParameter(request, "fiscalYear_yy");
String planID = ParserUtil.getParameter(request, "planID");
String goalID = ParserUtil.getParameter(request, "goalID");
String objectType = ParserUtil.getParameter(request, "objectType");
String objectID = ParserUtil.getParameter(request, "objectID");
String commentStatus = null;
String commentDesc = null;
String commentUserID = null;
String commentUsername = null;
String createDate = null;


ArrayList record = CorporatePlanCommentDB.getList(userBean, fiscalYear, deptCode, planID, goalID, objectType, objectID);
ReportableListObject row = null;
for (int i = 0; i < (record.size()); i++) {
	 	row = (ReportableListObject) record.get(i);
	 	commentStatus = row.getValue(0);
	 	commentDesc = row.getValue(1);
	 	commentUserID = row.getValue(2);
	 	commentUsername = row.getValue(3);
	 	createDate = row.getValue(4);
%>

<tr>
	<td rowspan="2" class="infoLabe2">Comment:</td>
	<td><b><%=commentStatus == null ? "" : commentStatus %></b> <%=commentDesc == null ? "" : commentDesc %></td>
</tr>
<tr>
	<td>BY: <%=commentUsername == null ? "" : commentUsername %>  <br>Date: <%=createDate %></td>
<tr>
	<td colspan = "2">------------------------------------------------</td>
</tr>
<%
}
%>
