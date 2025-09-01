<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
private ArrayList getCRMUserList(String siteCode,String lastName,String firstName) {
	// fetch group
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT U.CO_SITE_CODE,U.CO_USERNAME,U.CO_LASTNAME,U.CO_FIRSTNAME,U.CO_EMAIL,C.CRM_CLIENT_ID ");
	sqlStr.append("FROM   CO_USERS U ,CRM_CLIENTS C ");
	sqlStr.append("WHERE  U.CO_ENABLED = 1  ");
	sqlStr.append("AND    U.CO_STAFF_YN = 'N' ");

	if (siteCode != null && siteCode.length() > 0) {
		sqlStr.append("AND    U.CO_SITE_CODE = '"+siteCode+"' ");
	}	
	if (firstName != null && firstName.length() > 0) {
		sqlStr.append("AND    UPPER(TRIM(U.CO_FIRSTNAME)) LIKE '%");
		sqlStr.append(firstName.trim().toUpperCase());
		sqlStr.append("%' ");
	}
	if (lastName != null && lastName.length() > 0) {
		sqlStr.append("AND    UPPER(TRIM(U.CO_LASTNAME)) LIKE '%");
		sqlStr.append(lastName.trim().toUpperCase());
		sqlStr.append("%' ");
	}
	sqlStr.append("AND  U.CO_USERNAME = C.CRM_USERNAME ");
	sqlStr.append("ORDER BY U.CO_USERNAME ");

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

%>
<%
UserBean userBean = new UserBean(request);

String siteCode = request.getParameter("siteCode");
String lastName = request.getParameter("lastName");
String firstName = request.getParameter("firstName");

request.setAttribute("user_list", getCRMUserList(siteCode,lastName,firstName));
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
	<display:column titleKey="prompt.site" style="width:10%">
		<logic:equal name="row" property="fields0" value="<%=ConstantsServerSide.SITE_CODE_HKAH %>">
			<bean:message key="label.hkah" />
		</logic:equal>
		<logic:notEqual name="row" property="fields0" value="<%=ConstantsServerSide.SITE_CODE_HKAH %>">
			<bean:message key="label.twah" />
		</logic:notEqual>
	</display:column>	
	<display:column titleKey="prompt.loginID" style="width:30%">
		<c:out value="${row.fields1}" />
		(<c:out value="${row.fields2}" />, <c:out value="${row.fields3}" />)
	</display:column>	
		<display:column titleKey="prompt.email" style="width:30%">
		<c:out value="${row.fields4}" />		
	</display:column>	
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields1}" />', '');"><bean:message key="button.view" /></button>
		<button onclick="return viewNote('view', '<c:out value="${row.fields5}" />', '');">Progress Note</button>		
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>