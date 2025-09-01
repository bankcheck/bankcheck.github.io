<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getItemList(String itmcode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT H.ITMCODE, A.ACMNAME, H.HPKEY, H.HPSTATUS, H.HPRMK ");
		sqlStr.append("FROM ( ");
		sqlStr.append(" SELECT DECODE(INSTR(HPKEY, '-'), 0, HPKEY, SUBSTR(HPKEY, 0, INSTR(HPKEY, '-') - 1)) ITMCODE, DECODE(INSTR(HPKEY, '-'), 0, '', SUBSTR(HPKEY, INSTR(HPKEY, '-') + 1)) ACMCODE, HPKEY, HPSTATUS, HPRMK ");
		sqlStr.append(" FROM   HPSTATUS@IWEB ");
		sqlStr.append(" WHERE  HPTYPE = 'ROOMCHARGE' ");
		if (itmcode != null && itmcode.length() > 0) {
			sqlStr.append("AND    HPKEY LIKE UPPER('");
			sqlStr.append(itmcode);
			sqlStr.append("%') ");
		}
		sqlStr.append(" AND    HPACTIVE = -1 ");
		sqlStr.append(") H LEFT JOIN ACM@IWEB A ON H.ACMCODE = A.ACMCODE ");
		sqlStr.append("ORDER BY H.ITMCODE, A.ACMNAME, H.HPSTATUS ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
boolean createAction = false;
if ("create".equals(command)) {
	createAction = true;
}

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String itmcode = ParserUtil.getParameter(request, "itmcode");

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

request.setAttribute("room_charge_list", getItemList(itmcode));
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.hats.roomCharge.list" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="search_form" action="room_charge_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
		<tr class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Item Code: </td>
			<td class="infoData" width="70%"><input type="text" name="itmcode" id="itmcode" value="<%=itmcode == null ? "" : itmcode%>" maxlength="200" size="20" ></td>
		</tr>
		<tr class="smallText">
			<td colspan="2" align="center">
				<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
				<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
			</td>
	</tr>
	</table>
</form>

<form name="form1" action="room_charge_list.jsp" method="post">
<display:table id="row" name="requestScope.room_charge_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column title="Charge Code" style="width:25%" media="html"><c:out value="${row.fields0}" /></display:column>
	<display:column title="ACM Code" style="width:25%" media="html"><c:out value="${row.fields1}" /></display:column>
	<display:column title="Bed Code" style="width:25%" media="html"><c:out value="${row.fields3}" /></display:column>
	<display:column title="Room Charge" style="width:25%" media="html">$<c:out value="${row.fields4}" /></display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields3}" />');"><bean:message key="button.view" /></button>
	</display:column>
</display:table>
<%if (userBean.isAccessible("function.hats.roomCharge.update")) { %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '', '');"><bean:message key="function.hats.roomCharge.create" /></button></td>
	</tr>
</table>
<%} %>
</form>
</DIV>

</DIV>
</DIV>
<script>
function submitSearch() {
	document.search_form.submit();
}

function clearSearch() {
	document.search_form.itmcode.value = '';
}

function submitAction(cmd, hpkey, bedcode) {
	if (cmd == 'create' || cmd == 'view') {
		callPopUpWindow("room_charge.jsp?command=" + cmd + "&hpkey=" + hpkey + "&bedcode=" + bedcode);
		return false;
	}
}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
