<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
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

String nurobMoPatno = request.getParameter("nurobMoPatno");
String name = TextUtil.parseStrUTF8(request.getParameter("name"));
String nurobPhysName = TextUtil.parseStrUTF8(request.getParameter("nurobPhysName"));
String nurobDeliDateFrom = request.getParameter("nurobDeliDateFrom");
String nurobDeliDateTo = request.getParameter("nurobDeliDateTo");

// default search current delivery date
if (nurobDeliDateFrom == null && nurobDeliDateTo == null) {
	Calendar cal = Calendar.getInstance();
	String today = DateTimeUtil.formatDate(cal.getTime());
	nurobDeliDateFrom = today;
	nurobDeliDateTo = today;
}

request.setAttribute("deliRoomList", NurobDeliRmDB.getList(nurobMoPatno, name, nurobPhysName, nurobDeliDateFrom, nurobDeliDateTo));

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
<jsp:include page="../common/header.jsp" />
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<% 
	String accessControl = "Y";
	if (ConstantsServerSide.DEBUG) {
		accessControl = "N";
	} 
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.nurob.dr.list" />
	<jsp:param name="accessControl" value="<%=accessControl %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="search_form" method="post" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%">Mother's Hosp. No.</td>
		<td class="infoData" width="35%"><input type="text" name="nurobMoPatno" value="<%=nurobMoPatno == null ? "" : nurobMoPatno %>" maxlength="10" size="15" /></td>
		<td class="infoLabel" width="15%">Mother's Name</td>
		<td class="infoData" width="35%"><input type="text" name="name" value="<%=name == null ? "" : name %>" maxlength="40" size="50" /></td>

	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Physician</td>
		<td class="infoData" width="35%" colspan="3"><input type="text" name="nurobPhysName" value="<%=nurobPhysName == null ? "" : nurobPhysName %>" maxlength="40" size="50" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Delivery Date</td>
		<td class="infoData"" width="35%" colspan="3">
			<input type="text" name="nurobDeliDateFrom" id="nurobDeliDateFrom" class="datepickerfield" value="<%=nurobDeliDateFrom == null ? "" : nurobDeliDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
			-
			<input type="text" name="nurobDeliDateTo" id="nurobDeliDateTo" class="datepickerfield" value="<%=nurobDeliDateTo == null ? "" : nurobDeliDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="4">
			<table width="100%" border="0">
				<tr>
					<td align="center">
						<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
						<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>

<form name="form1" action="<html:rewrite page="/nurob/deliveryRoom.jsp" />" method="post">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');">Create</button></td>
	</tr>
</table>
<bean:define id="functionLabel"><bean:message key="function.nurob.dr.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.deliRoomList" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" title="Ref. No." />
	<display:column property="fields2" title="Mother's Hosp. No." />
	<display:column property="fields3" title="Mother's Name" style="width:15%" />
	<display:column property="fields6" title="Mother's Chinese Name" style="width:15%" />
	<display:column property="fields7" title="Physician" style="width:15%" />
	<display:column property="fields8" title="Age" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields1}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');">Create</button></td>
	</tr>
</table>
</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}
	
	function clearSearch() {
		document.search_form.nurobMoPatno.value = "";
		document.search_form.name.value = "";
		document.search_form.nurobPhysName.value = "";
		document.search_form.nurobDeliDateFrom.value = "";
		document.search_form.nurobDeliDateTo.value = "";
		return false;
	}


	function submitAction(cmd, sitecode, drid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&nurobSiteCode=" + sitecode + "&nurobDeliRmId=" + drid);
		return false;
	}

</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>