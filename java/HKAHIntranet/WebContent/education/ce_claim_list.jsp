<%@	page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@	page import="com.hkah.config.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String staffID=request.getParameter("staffID");
String siteCode = request.getParameter("siteCode");
String deptCode=request.getParameter("deptCode");
String year=request.getParameter("year");
String isClaimMoney=request.getParameter("isClaimMoney");
String isClaimHours=request.getParameter("isClaimHours");


request.setAttribute("ce_claim_list", CE.getClaimList(staffID, deptCode, year, isClaimMoney,isClaimHours));

boolean searchAction =true;

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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.ceClaim.list" />
	<jsp:param name="category" value="crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="ce_claim_list.jsp" method="post">

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
			<select name="deptCode">
				<option value="">--- All Departments ---</option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="70%"><input type="textfield" name="staffID" value="" maxlength="10" size="30"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.year" /></td>
		<td class="infoData" width="70%"><input type="textfield" name="year" value="<%=year==null?"":year %>" maxlength="4" size="4"> (YYYY) </td>
	</tr>
	
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.claimMoney" /></td>
		<td class="infoData" width="70%">
			<select name="isClaimMoney">
<jsp:include page="../ui/claimMoney.jsp" flush="false">
	<jsp:param name="isClaimMoney" value="<%=isClaimMoney %>" />
	<jsp:param name="emptyLabel" value="" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.claimHours" /></td>
		<td class="infoData" width="70%">
			<select name="isClaimHours">
<jsp:include page="../ui/claimHours.jsp" flush="false">
	<jsp:param name="isClaimHours" value="<%=isClaimHours %>" />
	<jsp:param name="emptyLabel" value="" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select>
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
<bean:define id="functionLabel"><bean:message key="function.ceClaim.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel%>" /></bean:define>
<form name="form1" action="ce_claim.jsp" method="post">
<display:table id="row" name="requestScope.ce_claim_list" export="true"  class="tablesorter">

	<display:column title="" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" titleKey="prompt.site" class="smallText" style="width:9%" />
	<display:column property="fields2" titleKey="prompt.month" class="smallText" style="width:9%" />
	<display:column property="fields3" titleKey="prompt.approvedDate" class="smallText" style="width:9%" />
	<display:column property="fields4" titleKey="prompt.category" class="smallText" style="width:9%" />
	<display:column property="fields5" titleKey="prompt.department" class="smallText" style="width:9%" />
	<display:column property="fields6" titleKey="prompt.name" class="smallText" style="width:9%" />
	<display:column property="fields7" titleKey="prompt.staffID" class="smallText" style="width:9%" />
	<display:column property="fields8" titleKey="prompt.amount" class="smallText" style="width:9%" />
	<display:column property="fields9" titleKey="prompt.hours" class="smallText" style="width:9%" />
	<display:column property="fields10" titleKey="prompt.actionNo" class="smallText" style="width:9%" />
	<display:column property="fields11" titleKey="prompt.attendingDate" class="smallText" style="width:9%" />
	<display:column property="fields12" titleKey="prompt.courseName" class="smallText" style="width:9%" />
	<display:column property="fields13" titleKey="prompt.claimMoney" class="smallText" style="width:9%" />
	<display:column property="fields14" titleKey="prompt.claimHours" class="smallText" style="width:9%" />
	<display:column property="fields15" titleKey="prompt.hrRemark" class="smallText" style="width:9%" />
	<display:column property="fields16" titleKey="prompt.usedMoney" class="smallText" style="width:9%" />
	<display:column property="fields17" titleKey="prompt.usedHours" class="smallText" style="width:9%" />

	<display:column titleKey="prompt.action" media="html" class="smallText" style="width:10%">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</form>
<%} %>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.staffID.value = '';
		document.search_form.year.value = '';
	}

	function submitAction(cmd, aid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&approvedTransID=" + aid);
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>