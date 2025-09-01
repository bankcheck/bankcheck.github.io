<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.crm.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);
String tabId = request.getParameter("tabId");
String href = request.getParameter("href");

String newsCategory = request.getParameter("newsCategory");
boolean isLMCCRM = false;
if(newsCategory != null && newsCategory.equals("lmc.crm")){
	isLMCCRM= true;
}

String tab1_class = "Un";
String tab2_class = "Un";
String tab3_class = "Un";
String tab4_class = "Un";
String tab5_class = "Un";
if ("1".equals(tabId)) {
	tab1_class = "";
} else if ("2".equals(tabId)) {
	tab2_class = "";
} else if ("3".equals(tabId)) {
	tab3_class = "";
} else if ("4".equals(tabId)) {
	tab4_class = "";
} else if ("5".equals(tabId)) {
	tab5_class = "";
}

if (clientID != null) {
	try {
		ArrayList record = CRMClientDB.get(clientID);
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
		<td class="infoLabel" width="16%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData"  width="16%"><%=row.getValue(0) %></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData"  width="16%"><%=row.getValue(1) %></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData"  width="16%"><%=row.getValue(2) %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="16%"><bean:message key="prompt.title" /></td>
		<td class="infoData"  width="16%"><%=ParameterHelper.getTitleValue(session, row.getValue(3)) %></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.religion" /></td>
		<td class="infoData"  width="16%"><%=ParameterHelper.getReligionValue(session, row.getValue(4)) %></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.sex" /></td>
		<td class="infoData"  width="16%"><%if ("M".equals(row.getValue(5))) { %><bean:message key="label.male" /><%} else { %><bean:message key="label.female" /><%} %></td>
	</tr>
	<tr>
		<td colspan="6">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6">
			<ul id="tabList">
			<li><a href="client_info.jsp<%=(isLMCCRM)?"?newsCategory=lmc.crm":"" %><%if (href != null) { %>#<%=href %><%} %>" tabId="tab1" class="link<%=tab1_class %>Selected"><span><bean:message key="prompt.basicInfo"/></span></a></li>
			<!--li><a href="donation_list.jsp" tabId="tab2" class="link<%=tab2_class %>Selected"><span><bean:message key="prompt.donation"/></span></a></li-->
			<li><a href="relative_list.jsp<%=(isLMCCRM)?"?newsCategory=lmc.crm":"" %>" tabId="tab3" class="link<%=tab3_class %>Selected"><span><bean:message key="prompt.relative"/></span></a></li>
			<li><a href="client_enrollment_list.jsp<%=(isLMCCRM)?"?newsCategory=lmc.crm":"" %>" tabId="tab4" class="link<%=tab4_class %>Selected"><span><bean:message key="prompt.enrollment"/></span></a></li>
			<!--li><a href="client_activity_list.jsp" tabId="tab5" class="link<%=tab5_class %>Selected"><span><bean:message key="prompt.activitiesHistory"/></span></a></li-->
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