<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="java.util.*" %>
<%
UserBean userBean = new UserBean(request);
if (!userBean.isAccessible("function.di.docEmail.list")) {
	response.sendRedirect("../index.jsp");
	return;
}

String docCode = ParserUtil.getParameter(request, "docCode");
String docName = ParserUtil.getParameter(request, "docName");
String sendRisEmail = ParserUtil.getParameter(request, "sendRisEmail");

request.setAttribute("docEmail_list", 
		RISDB.getDocRISEmailList(docCode, docName, sendRisEmail));
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
<bean:define id="functionLabel"><bean:message key="function.di.docEmail.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.docEmail_list" export="true" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Doctor Code" style="width:5%" />
	<display:column property="fields1" title="Doctor Name" style="width:10%" />
	<display:column property="fields2" title="Email in HATS" style="width:20%" />
		<display:column title="Allow send email" style="width:5%">
		<c:choose>
		      <c:when test="${row.fields3=='-1'}">
		    	Yes
		      </c:when>
		      <c:when test="${row.fields3=='0'}">
		      	No
		      </c:when>
		      <c:otherwise>
		      <c:out value="${row.fields3}" />
		      </c:otherwise>
		</c:choose>
	</display:column>
	<!--display:column property="fields4" title="Last Modified Date" style="width:10%" />-->
	<display:column title="Action" style="width:10%">
		<c:choose>
		      <c:when test="${row.fields3=='-1'}">
		    	<button onclick="return submitAction('updateSendRisEmail', 1, '<c:out value="${row.fields0}" />', '0');">Disable send</button>
		      </c:when>
		      <c:when test="${row.fields3=='0'}">
		    	<button onclick="return submitAction('updateSendRisEmail', 1, '<c:out value="${row.fields0}" />', '-1');">Enable send</button>
		      </c:when>		
		      <c:when test="${row.fields3==''}">
		    	<button onclick="return submitAction('updateSendRisEmail', 1, '<c:out value="${row.fields0}" />', '-1');">Enable send</button>
		      </c:when>      
		</c:choose>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>