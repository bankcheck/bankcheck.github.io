<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%!
	private ArrayList fetchRelative(String clientID) {
		// fetch relative
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT CR.CRM_RELATED_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME,C.CRM_CHINESENAME, CR.CRM_RELATIONSHIP, CR.CRM_REMARKS ");
		sqlStr.append("FROM   CRM_CLIENTS_RELATIONSHIP CR, CRM_CLIENTS C ");
		sqlStr.append("WHERE  CR.CRM_RELATED_CLIENT_ID = C.CRM_CLIENT_ID ");
		sqlStr.append("AND    CR.CRM_ENABLED = 1 ");
		sqlStr.append("AND    C.CRM_ENABLED = 1 ");
		sqlStr.append("AND    CR.CRM_CLIENT_ID = '"+clientID+"' ");		
		sqlStr.append("UNION ");
		sqlStr.append("SELECT CR.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME,C.CRM_CHINESENAME, CR.CRM_RELATIONSHIP, CR.CRM_REMARKS ");
		sqlStr.append("FROM   CRM_CLIENTS_RELATIONSHIP CR, CRM_CLIENTS C ");
		sqlStr.append("WHERE  CR.CRM_CLIENT_ID = C.CRM_CLIENT_ID ");
		sqlStr.append("AND    CR.CRM_ENABLED = 1 ");
		sqlStr.append("AND    C.CRM_ENABLED = 1 ");
		sqlStr.append("AND    CR.CRM_RELATED_CLIENT_ID = '"+clientID+"' ");
		sqlStr.append("ORDER BY CRM_LASTNAME, CRM_FIRSTNAME, CRM_RELATED_CLIENT_ID");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getClientInfo(String clientID) {
		StringBuffer sqlStr = new StringBuffer();
	
		sqlStr.append("SELECT CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME,  CRM_CHINESENAME, CRM_STREET1, ");
		sqlStr.append("       CRM_STREET2, CRM_STREET3, CRM_STREET4, ");
		sqlStr.append("       CRM_HOME_NUMBER,CRM_MOBILE_NUMBER, CRM_FAX_NUMBER,  CRM_EMAIL, CRM_PHOTO_NAME, ");
		sqlStr.append("       CRM_ORGANIZATION, CRM_SALUTATION, ");
		sqlStr.append("       CRM_DESCRIPTION,CRM_DONOR,  CRM_CREATED_USER, CRM_CREATED_SITE_CODE, ");
		sqlStr.append("       CRM_CREATED_DEPARTMENT_CODE, CRM_MODIFIED_USER ");	
		sqlStr.append("FROM   CRM_CLIENTS ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = '"+clientID+"' ");	
		sqlStr.append("AND    CRM_DONOR = 'Y' ");
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);
String clientID =  ParserUtil.getParameter(request, "clientID");

request.setAttribute("relative_list", fetchRelative(clientID));

String message = "";
String errorMessage = "";
%>
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper style="width:100%">
<div id=mainFrame style="width:100%">
<div id=contentFrame style="width:100%">
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.donor.relative.list" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.relative.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>

<%
	ArrayList clientRecord = getClientInfo(clientID);

	if(clientRecord.size() != 0){	
		ReportableListObject clientRow = (ReportableListObject)clientRecord.get(0);	
%>
<table cellpadding="0" width="100%" cellspacing="5"	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="16%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(1)%></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(2)%></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(3)%></td>
	</tr>
	<tr></tr>
	<tr class="smallText">
		<td colspan = "6"  class="infoTitle" colspan="4">Relative List</td>
	</tr>
</table>		
<%
	}
%>

<form name="form1" action="donor_relative.jsp" method="post" style="width:100%">

<display:table style="width:100%" id="row" name="requestScope.relative_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.name" style="width:20%">
		<logic:equal name="row" property="fields1" value="">
			<c:out value="${row.fields2}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields1" value="">
			<logic:equal name="row" property="fields2" value="">
				<c:out value="${row.fields1}" />
			</logic:equal>
			<logic:notEqual name="row" property="fields2" value="">
				<c:out value="${row.fields1}" />, <c:out value="${row.fields2}" />
			</logic:notEqual>
		</logic:notEqual>
	</display:column>
	<display:column property="fields5" title="Remark" style="width:30%" />
	<display:column property="fields4" title="Relationship" style="width:25%" />
	<display:column titleKey="button.view" media="html" style="width:20%; text-align:center">
		<button type="button" onclick="return submitBasicInfoAction('view', '<c:out value="${row.fields0}" />');"><bean:message key='prompt.basicInfo' /></button>
		
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');">Relationship</button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>

<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<!--button onclick="return submitAction('create', '');"><bean:message key="function.relative.create" /></button-->
			<button type="button" onclick="return submitRelationshipAction('create', '');"><bean:message key="function.relationship.create" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="command"/>
<input type="hidden" name="clientID" value="<%=clientID %>"/>
<input type="hidden" name="clientRelativeID"/>
</form>
<script language="javascript">
	function submitAction(cmd, cid, rs) {
		document.form1.command.value = cmd;
		document.form1.clientRelativeID.value = cid;
		document.form1.submit();
	}

	function submitRelationshipAction(cmd, cid) {
		document.form1.action = "donor_relative.jsp";
		document.form1.command.value = cmd;
		document.form1.clientRelativeID.value = cid;
		document.form1.submit();
	}
	
	function submitBasicInfoAction(cmd, cid) {		
		callPopUpWindow("donor_info.jsp?command=" + cmd + "&clientID=" + cid);
	
	}
</script>
</div>
</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>