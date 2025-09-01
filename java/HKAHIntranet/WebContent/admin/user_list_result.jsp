<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String siteCode = request.getParameter("siteCode");
String deptCode = request.getParameter("deptCode");
String staffID = request.getParameter("staffID");
String lastName = request.getParameter("lastName");
String firstName = request.getParameter("firstName");
String enabled = request.getParameter("enabled");
request.setAttribute("user_list", UserDB.getList4UserList(userBean, siteCode, deptCode, staffID, firstName, lastName, enabled));
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
<bean:define id="functionLabel"><bean:message key="function.user.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.user_list" export="true" class="tablesorter">
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
		<logic:equal name="row" property="fields0" value="<%=ConstantsServerSide.SITE_CODE_AMC2 %>">
			AMC2
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
	<display:column titleKey="prompt.loginID" style="width:15%">
		<c:out value="${row.fields2}" />
		(<c:out value="${row.fields3}" />, <c:out value="${row.fields4}" />)
	</display:column>
	<display:column property="fields9" title="Staff Name" style="width:10%" />
	<display:column property="fields5" titleKey="prompt.adventistStaff" style="width:10%" />
	<display:column property="fields7" titleKey="prompt.userGroup" style="width:10%" />
	<display:column title="Enabled" style="width:10%">
		<logic:equal name="row" property="fields8" value="0">
			<font color="red">Disabled</font>
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="0">
			<font color="green">Enabled</font>
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields2}" />', '', '<c:out value="${row.fields8}" />');"><bean:message key="button.view" /></button>
<%	if (userBean.isAdmin() || userBean.isAccessible("function.allowLoginOther") ) { %>
		<button onclick="return submitAction('login', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields5}" />', '<c:out value="${row.fields8}" />');"><bean:message key="button.login" /></button>
<%	} %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>