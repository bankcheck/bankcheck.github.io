<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="java.util.*" %>
<%
UserBean userBean = new UserBean(request);
if (!userBean.isAccessible("function.di.rptLog.list")) {
	response.sendRedirect("../index.jsp");
	return;
}

String diAccessNum = ParserUtil.getParameter(request, "diAccessNum");
String diDoccode = ParserUtil.getParameter(request, "diDoccode");
String sendDateFrom = ParserUtil.getParameter(request, "sendDateFrom");
String sendDateTo = ParserUtil.getParameter(request, "sendDateTo");
String sendStatus = ParserUtil.getParameter(request, "sendStatus");
String readStatus = ParserUtil.getParameter(request, "readStatus");

request.setAttribute("rptLog_list", 
		RISDB.getDiRptLogList(null, diAccessNum, diDoccode, sendDateFrom, sendDateTo, sendStatus, readStatus));
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
<bean:define id="functionLabel"><bean:message key="function.di.rptLog.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.rptLog_list" export="true" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields2" title="RIS Accession No" style="width:10%" />
	<display:column property="fields4" title="Doctor Code" style="width:5%" />
	<display:column property="fields14" title="Doctor Name" style="width:10%" />
	<display:column property="fields9" title="Send Date" style="width:10%" />
	<display:column property="fields7" title="Send Status" style="width:5%" />
		<display:column title="Read Status" style="width:5%">
		<c:choose>
		      <c:when test="${row.fields8=='0'}">
		    	Not read
		      </c:when>
		      <c:when test="${row.fields8=='1'}">
		      Read
		      </c:when>
		      <c:otherwise>
		      <c:out value="${row.fields8}" />
		      </c:otherwise>
		</c:choose>
	</display:column>
	<display:column property="fields11" title="Read Date" style="width:10%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>