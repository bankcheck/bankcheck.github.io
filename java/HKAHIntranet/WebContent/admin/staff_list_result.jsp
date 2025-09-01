<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String[] months = new String [] {
	MessageResources.getMessage(session, "label.january"),
	MessageResources.getMessage(session, "label.february"),
	MessageResources.getMessage(session, "label.march"),
	MessageResources.getMessage(session, "label.april"),
	MessageResources.getMessage(session, "label.may"),
	MessageResources.getMessage(session, "label.june"),
	MessageResources.getMessage(session, "label.july"),
	MessageResources.getMessage(session, "label.august"),
	MessageResources.getMessage(session, "label.september"),
	MessageResources.getMessage(session, "label.october"),
	MessageResources.getMessage(session, "label.november"),
	MessageResources.getMessage(session, "label.december") };

String siteCode = request.getParameter("siteCode");
String deptCode = request.getParameter("deptCode");
String staffID = request.getParameter("staffID");
String staffName = request.getParameter("staffName");
String category = request.getParameter("category");
String markdeleted = request.getParameter("markdeleted");
String enabled = request.getParameter("enabled");
request.setAttribute("staff_list", StaffDB.getList4StaffList(userBean, siteCode, deptCode, staffID, staffName, category, markdeleted, enabled));
%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<bean:define id="functionLabel"><bean:message key="function.staff.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.staff_list" export="true" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.site" style="width:5%">
		<logic:equal name="row" property="fields0" value="<%=ConstantsServerSide.SITE_CODE_HKAH %>">
			<bean:message key="label.hkah" />
		</logic:equal>
		<logic:equal name="row" property="fields0" value="<%=ConstantsServerSide.SITE_CODE_TWAH %>">
			<bean:message key="label.twah" />
		</logic:equal>
		<logic:equal name="row" property="fields0" value="<%=ConstantsServerSide.SITE_CODE_AMC %>">
			AMC
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.department" style="width:10%">
		<logic:equal name="row" property="fields1" value="">
			<bean:message key="label.all" />
		</logic:equal>
		<logic:notEqual name="row" property="fields1" value="">
			<c:out value="${row.fields1}" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields2" titleKey="prompt.staffID" style="width:10%" />
	<display:column titleKey="prompt.staffName" style="width:15%">
		<c:out value="${row.fields3}" />
	</display:column>
	<display:column titleKey="prompt.chineseName" style="width:10%">
		<c:out value="${row.fields12}" />
	</display:column>
	<display:column property="fields4" titleKey="prompt.status" style="width:10%" />

	<display:column titleKey="prompt.hireDate" style="width:5%">
		<c:out value="${row.fields6}" />
	</display:column>
	<display:column titleKey="prompt.termDate" style="width:5%">
		<c:out value="${row.fields11}" />
	</display:column>
	<display:column title="Override HR<br />(Keep active)" style="width:10%">
		<logic:equal name="row" property="fields13" value="Y">
			<font color="red">Yes (Keep 6 months only)</font>
		</logic:equal>
		<logic:equal name="row" property="fields13" value="B">
			<font color="blue">Yes (Board Member only</font>
		</logic:equal>
		<logic:equal name="row" property="fields13" value="N">
			<font color="green">No</font>
		</logic:equal>
	</display:column>
	<display:column title="Enabled" style="width:10%">
		<logic:equal name="row" property="fields10" value="0">
			<font color="red">Disabled</font>
		</logic:equal>
		<logic:notEqual name="row" property="fields10" value="0">
			<font color="green">Enabled</font>
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields10}" />');"><bean:message key="button.view" /></button>
		<button onclick="return submitAction('sso', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields10}" />');">SSO User</button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>