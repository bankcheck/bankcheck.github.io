<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> getList(String userID, String userName, String userStatus) {
		return UtilDBWeb.getReportableListHATS(
			"SELECT USRID, USRNAME, USRSTS FROM USR WHERE USRID LIKE '%' || ? || '%' AND USRNAME LIKE '%' || ? || '%' AND USRSTS = ? ORDER BY USRID",
			new String[] { userID, userName, userStatus });
	}
%>
<%
UserBean userBean = new UserBean(request);

String userID = request.getParameter("userID");
if (userID != null) {
	userID = userID.toUpperCase();
}
String userName = request.getParameter("userName");
if (userName != null) {
	userName = userName.toUpperCase();
}
String userStatus = request.getParameter("userStatus");
request.setAttribute("user_list", getList(userID, userName, userStatus));
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
	<display:column property="fields0" titleKey="prompt.loginID" style="width:20%" />
	<display:column property="fields1" titleKey="prompt.Name" style="width:30%" />
	<display:column titleKey="prompt.status" style="width:20%">
		<logic:equal name="row" property="fields2" value="-1">
			<font color="green">Active</font>
		</logic:equal>
		<logic:notEqual name="row" property="fields2" value="-1">
			<font color="red">Inactive</font>
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:20%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>