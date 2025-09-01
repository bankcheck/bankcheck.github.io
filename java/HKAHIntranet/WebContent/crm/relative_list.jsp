<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchRelative(String clientID) {
		// fetch relative
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CR.CRM_RELATED_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME, CR.CRM_RELATIONSHIP, CR.CRM_REMARKS ");
		sqlStr.append("FROM   CRM_CLIENTS_RELATIONSHIP CR, CRM_CLIENTS C ");
		sqlStr.append("WHERE  CR.CRM_RELATED_CLIENT_ID = C.CRM_CLIENT_ID ");
		sqlStr.append("AND    CR.CRM_ENABLED = 1 ");
		sqlStr.append("AND    CR.CRM_CLIENT_ID = ? ");
		sqlStr.append("UNION ");
		sqlStr.append("SELECT CR.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME, CR.CRM_RELATIONSHIP, CR.CRM_REMARKS ");
		sqlStr.append("FROM   CRM_CLIENTS_RELATIONSHIP CR, CRM_CLIENTS C ");
		sqlStr.append("WHERE  CR.CRM_CLIENT_ID = C.CRM_CLIENT_ID ");
		sqlStr.append("AND    CR.CRM_ENABLED = 1 ");
		sqlStr.append("AND    CR.CRM_RELATED_CLIENT_ID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, clientID });
	}
%>
<%
UserBean userBean = new UserBean(request);
String clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);

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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.relative.list" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="3" />
</jsp:include>
<bean:define id="functionLabel"><bean:message key="function.relative.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="client_info.jsp" method="post">
<display:table id="row" name="requestScope.relative_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.name" style="width:20%">
		<c:out value="${row.fields1}" />, <c:out value="${row.fields2}" />
	</display:column>
	<display:column property="fields3" titleKey="prompt.relationship" style="width:20%" />
	<display:column property="fields4" titleKey="prompt.remarks" style="width:25%" />
	<display:column titleKey="button.view" media="html" style="width:25%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key='prompt.basicInfo' /></button>
		<button onclick="return submitRelationshipAction('view', '<c:out value="${row.fields0}" />');"><bean:message key='prompt.relationship' /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<!--button onclick="return submitAction('create', '');"><bean:message key="function.relative.create" /></button-->
			<button onclick="return submitRelationshipAction('create', '');"><bean:message key="function.relationship.create" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="command">
<input type="hidden" name="clientRelativeID">
<input type="hidden" name="relationship">
</form>
<script language="javascript">
	function submitAction(cmd, cid, rs) {
		document.form1.command.value = cmd;
		document.form1.clientRelativeID.value = cid;
		document.form1.submit();
	}

	function submitRelationshipAction(cmd, cid) {
		document.form1.action = "relationship.jsp";
		document.form1.command.value = cmd;
		document.form1.clientRelativeID.value = cid;
		document.form1.submit();
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>