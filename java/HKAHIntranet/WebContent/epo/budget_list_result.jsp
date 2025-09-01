<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%
UserBean userBean = new UserBean(request);

String deptCode = request.getParameter("deptCode");
String budgetCode = request.getParameter("budgetCode");
String budgetDesc = request.getParameter("budgetDesc");
String budgetAmt = request.getParameter("budgetAmt");
String budgetEnabled = request.getParameter("budgetEnabled");

ArrayList record1 = EPORequestDB.getBudgetList( deptCode, budgetCode, budgetDesc, budgetAmt, budgetEnabled);

request.setAttribute("budget_list", EPORequestDB.getBudgetList( deptCode, budgetCode, budgetDesc, budgetAmt, budgetEnabled));

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
<display:table id="row" name="requestScope.budget_list" export="true" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Dept Code" style="width:5%" />
	<display:column property="fields1" title="Department Name" style="width:20%" />
	<display:column property="fields2" title="Budget Code" style="width:10%" />
	<display:column property="fields3" title="Description" style="width:25%" />
	<display:column property="fields4" title="Amount" style="width:10%" />
	<display:column property="fields9" title="Enabled" style="width:5%" />	
	<display:column property="fields7" title="Remarks" style="width:15%" />	
	<display:column property="fields8" title="" style="width:0%" media="none"/>	
	<display:column titleKey="prompt.action" media="html" style="width:5%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields4}" />', '<c:out value="${row.fields8}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="sort.budgetCode" value="list"/>
</display:table>