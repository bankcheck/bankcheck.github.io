<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String staffID = (String) session.getAttribute("staffID");
String tabId = request.getParameter("tabId");
String href = request.getParameter("href");

String tab1_class = "linkUnSelected";
String tab2_class = "linkUnSelected";
if ("1".equals(tabId)) {
	tab1_class = "linkSelected";
} else if ("2".equals(tabId)) {
	tab2_class = "linkSelected";
}

if (staffID != null) {
	try {
		// fetch client info
		ArrayList record = StaffDB.get(staffID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
%>
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
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData"  width="10%"><%=staffID %></td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.department" /></td>
		<td class="infoData"  width="35%"><%=row.getValue(2) %></td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.staffName" /></td>
		<td class="infoData"  width="35%"><%=row.getValue(3) %></td>
	</tr>
	<tr>
		<td colspan="6">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6">
			<ul id="tabList">
			<li><a href="staff.jsp<%if (href != null) { %>#<%=href %><%} %>" tabId="tab1" class="<%=tab1_class %>"><span><bean:message key="prompt.basicInfo"/></span></a></li>
			<li><a href="staff_education_list.jsp" tabId="tab2" class="<%=tab2_class %>"><span><bean:message key="prompt.education"/></span></a></li>
			</ul>
		</td>
	</tr>
</table>
<%
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
}
%>