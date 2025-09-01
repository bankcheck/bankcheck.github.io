<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchVIPMembership(String patName, String siteCode, String patNo, String expiredDate, String discountCode) {
		// fetch client
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME, ");
		sqlStr.append("       M.CRM_CLUB_ID, M.CRM_CARD_TYPE, M.CRM_MEMBER_ID, ");
		sqlStr.append("       TO_CHAR(M.CRM_EXPIRY_DATE, 'dd/MM/YYYY'), TO_CHAR(M.CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_CLIENTS C, CRM_CLIENTS_MEMBERSHIP M ");
		sqlStr.append("WHERE  M.CRM_ENABLED = 1 ");
		sqlStr.append("AND    C.CRM_CLIENT_ID = M.CRM_CLIENT_ID ");
		sqlStr.append("AND    M.CRM_CLUB_ID = '5' ");
		if (patName != null && patName.length() > 0) {
			sqlStr.append("AND    (UPPER(C.CRM_LASTNAME) LIKE '%");
			sqlStr.append(patName.toUpperCase());
			sqlStr.append("%' OR UPPER(C.CRM_FIRSTNAME) LIKE '%");
			sqlStr.append(patName.toUpperCase());
			sqlStr.append("%') ");
		}
		if (siteCode != null && siteCode.length() > 0) {
			if ("hkah".equals(siteCode)) {
				sqlStr.append("AND    M.CRM_CLUB_ID = '10' ");
			} else if ("twah".equals(siteCode)) {
				sqlStr.append("AND    M.CRM_CLUB_ID = '11' ");
			}
		}
		if (patNo != null && patNo.length() > 0) {
			sqlStr.append("AND    M.CRM_MEMBER_ID LIKE '%");
			sqlStr.append(patNo);
			sqlStr.append("%' ");
		}
		if (expiredDate != null && expiredDate.length() > 0) {
			sqlStr.append("AND    M.CRM_EXPIRY_DATE = TO_DATE('");
			sqlStr.append(expiredDate);
			sqlStr.append("', 'dd/MM/YYYY') ");
		}
		sqlStr.append("ORDER BY C.CRM_LASTNAME, C.CRM_FIRSTNAME");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();

String patName = request.getParameter("patName");
String siteCode = request.getParameter("siteCode");
String patNo = request.getParameter("patNo");
String expiredDate = request.getParameter("expiredDate");
String discountCode = request.getParameter("discountCode");

request.setAttribute("vip_membership_list", fetchVIPMembership(patName, siteCode, patNo, expiredDate, discountCode));

boolean searchAction = true;

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.vip.membership.list" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
	<jsp:param name="isTranslate" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="vip_membership_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Name</td>
		<td class="infoData" width="70%"><input type="textfield" name="patName" value="<%=patName==null?"":patName %>" maxlength="100" size="50"> (<bean:message key="prompt.optional" />)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Hospital No.</td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/siteCodeRDB.jsp" flush="false">
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			<input type="textfield" name="patNo" value="<%=patNo==null?"":patNo %>" maxlength="100" size="50"> (<bean:message key="prompt.optional" />)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Expired Date</td>
		<td class="infoData" width="70%"><input type="text" name="expiredDate" id="expiredDate" class="datepickerfield" value="<%=expiredDate==null?"":expiredDate %>" /> (<bean:message key="prompt.optional" />)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Discount Code</td>
		<td class="infoData" width="70%">
			<input type="radio" name="discountCode" value="" checked>All
			<input type="radio" name="discountCode" value="1"<% if ("1".equals(discountCode)) { %> checked<%} %>>A: 20%
			<input type="radio" name="discountCode" value="2"<% if ("2".equals(discountCode)) { %> checked<%} %>>B: 15%
			<input type="radio" name="discountCode" value="3"<% if ("3".equals(discountCode)) { %> checked<%} %>>C: 10%
			<input type="radio" name="discountCode" value="4"<% if ("4".equals(discountCode)) { %> checked<%} %>>D: 5%
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
<%if (searchAction) { %>
<bean:define id="functionLabel"><bean:message key="function.vip.membership.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="vip_membership.jsp" method="post">
<display:table id="row" name="requestScope.vip_membership_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.name" class="smallText" style="width:25%">
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
	<display:column property="fields6" titleKey="prompt.expiryDate" class="smallText" style="width:30%" />
	<display:column title="Discount Type" class="smallText" style="width:30%">
		<logic:equal name="row" property="fields4" value="1">
			A: 20%
		</logic:equal>
		<logic:equal name="row" property="fields4" value="2">
			B: 15%
		</logic:equal>
		<logic:equal name="row" property="fields4" value="3">
			C: 10%
		</logic:equal>
		<logic:equal name="row" property="fields4" value="4">
			D: 5%
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.action" media="html" class="smallText" style="width:10%">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.vip.membership.create" /></button></td>
	</tr>
</table>
</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.patName.value = '';
		document.search_form.patNo.value = '';
		document.search_form.expiredDate.value = '';
		document.search_form.discountCode[0].selected = true;
	}

	function submitAction(cmd, mid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&clientID=" + mid);
		return false;
	}
</script>
<%} %>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>