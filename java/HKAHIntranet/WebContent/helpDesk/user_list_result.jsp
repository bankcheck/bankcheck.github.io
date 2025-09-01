<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="java.util.*" %>
<%
UserBean userBean = new UserBean(request);
if (!userBean.isAccessible("function.helpDesk.user.list")) {
	response.sendRedirect("../index.jsp");
	return;
}

String userId = ParserUtil.getParameter(request, "userId");
String deptCode = ParserUtil.getParameter(request, "deptCode");
String name = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "name"));
String userType = ParserUtil.getParameter(request, "userType");
String loginStatus = ParserUtil.getParameter(request, "loginStatus");
String enabled = request.getParameter("enabled");

request.setAttribute("user_list", HelpDeskDB.getList(userId, deptCode, name, userType, loginStatus, enabled));
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
<bean:define id="functionLabel"><bean:message key="function.helpDesk.user.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.user_list" export="true" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="User ID" style="width:10%" />
	<display:column property="fields9" title="Dept Code" style="width:10%" />
	<display:column property="fields1" title="First Name" style="width:10%" />
	<display:column property="fields2" title="Last Name" style="width:10%" />
	<display:column property="fields3" title="Nick Name<br />(Display Name)" style="width:10%" />
	<display:column title="User Type" style="width:10%">
		<c:choose>
		      <c:when test="${row.fields5=='0'}">
		     <c:out value="Requester" />
		      </c:when>
		      <c:when test="${row.fields5=='1'}">
		      <c:out value="Supervisor" />
		      </c:when>
		      <c:when test="${row.fields5=='2'}">
		      <c:out value="Workman" />
		      </c:when>
		      <c:otherwise>
		      <c:out value="${row.fields5}" />
		      </c:otherwise>
		</c:choose>
	</display:column>
	<display:column property="fields6" title="Phone" style="width:10%" />
	<display:column title="Login Status" style="width:10%">
		<c:choose>
		      <c:when test="${row.fields8=='0'}">
		      <c:out value="Online" />
		      </c:when>
		      <c:when test="${row.fields8=='2'}">
		      <c:out value="Logged out" />
		      </c:when>
		      <c:otherwise>
		      <c:out value="${row.fields8}" />
		      </c:otherwise>
		</c:choose>
	</display:column>
	<c:set var="password" value="${row.fields4}"/>		
	<% String password = (String)pageContext.getAttribute("password"); %>	
	<display:column title="Enable" style="width:10%">
		
	   	<%
	        if(password==null || password.isEmpty())  {
	    %>            
	        <font color="red">Disabled</font>
	    <%
	        } else {
	    %>
	        <font color="green">Enabled</font>
	    <%
	        }
	    %>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
	<% if(password!=null && !password.isEmpty())  { %>
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '');"><bean:message key="button.view" /></button>
	<% } %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>