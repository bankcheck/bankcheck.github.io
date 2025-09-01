<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
if (!userBean.isAccessible("function.ssoUser.list")) {
	response.sendRedirect("../index.jsp");
	return;
}

String ssoUserId = ParserUtil.getParameter(request, "ssoUserId");
String staffNo = ParserUtil.getParameter(request, "staffNo");
String name = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "name"));
String enabled = ParserUtil.getParameter(request, "enabled");

request.setAttribute("user_list", SsoUserDB.getList(ssoUserId, staffNo, name, enabled));
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
<bean:define id="functionLabel"><bean:message key="function.ssoUser.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.user_list" export="true" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="SSO User ID" style="width:10%" />
	<display:column property="fields1" title="Staff No" style="width:10%" />
	<display:column property="fields5" title="Display Name" style="width:10%" />
	<display:column title="中文姓名" style="width:10%">
<%
		String cnFirstName = ((ReportableListObject)pageContext.getAttribute("row")).getFields6();
		String cnLastName = ((ReportableListObject)pageContext.getAttribute("row")).getFields7();
		String cnName = cnLastName + cnFirstName;
%>
		<%=cnName %>
	</display:column>
	<display:column property="fields13" title="User Type" style="width:10%" />
	<display:column title="Enabled" style="width:10%">
		<logic:equal name="row" property="fields14" value="0">
			<font color="red">No</font>
		</logic:equal>
		<logic:notEqual name="row" property="fields14" value="0">
			<font color="green">Yes</font>
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>