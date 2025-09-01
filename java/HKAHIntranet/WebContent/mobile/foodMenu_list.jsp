<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%!
	private ArrayList<ReportableListObject> getlist(String inParam) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CODE_NO, C.CODE_VALUE1, C.CODE_VALUE2, DECODE(C.CODE_NO, 'set', '1', '2') CODE_ORDER ");
		sqlStr.append("FROM AH_SYS_CODE C ");
		sqlStr.append("WHERE C.SYS_ID = 'DIT' ");
		sqlStr.append("AND   C.CODE_TYPE = 'MENU_TYPE' ");
		sqlStr.append("AND  (C.STATUS <> 'X' OR CODE_NO = 'set') ");
		if (inParam != null && inParam.length() > 0) {
			sqlStr.append("AND   UPPER(C.CODE_VALUE1) LIKE UPPER('%" + inParam + "%') ");
		}
		sqlStr.append("ORDER BY CODE_ORDER, C.CODE_NO ");

		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

String inParam = request.getParameter("inParam");

ArrayList list = getlist(inParam);
request.setAttribute("list", list);

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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Menu List" />
	<jsp:param name="category" value="prompt.admin" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" id="search_form" action="foodMenu_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Menu Name</td>
		<td class="infoData" width="70%">
			<input type="text" name="inParam"/>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<display:table id="row" name="requestScope.list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="Menu Code" style="width:20%">
		<c:out value="${row.fields0}" /><br>
		<img src="/upload/Food%20Service/foodPhoto/menu/<c:out value="${row.fields0}" />.png" onerror="this.src='../images/alert_general.gif'" width="192" height="101">
	</display:column>
	<display:column property="fields1" title="Display Name (English)" style="width:20%"/>
	<display:column property="fields2" title="Display Name (Chinese)" style="width:20%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('update', '<c:out value="${row.fields0}" />');"><bean:message key="button.update" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="No record"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<script language="javascript">

	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.inParam.value = "";
	}

	function submitAction(cmd, cid) {
		callPopUpWindow("foodMenu_detail.jsp?command=" + cmd + "&menuCode=" + cid);
		return false;
	}

</script>

</DIV>
</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>