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

String nurobPatient = request.getParameter("nurobPatient");
String nurobAge = request.getParameter("nurobAge");
String nurobTelno = request.getParameter("nurobTelno");
String nurobBookno = request.getParameter("nurobBookno");
String nurobEdc = request.getParameter("nurobEdc");
String nurobDr = request.getParameter("nurobDr");
String nurobClinic = request.getParameter("nurobClinic");

request.setAttribute("admltrList", NurobAdmltrDB.getList(nurobPatient, nurobAge, nurobTelno, nurobBookno, nurobEdc, nurobDr, nurobClinic));

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
	<jsp:param name="pageTitle" value="function.nurob.admltr.list" />
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
		<td class="infoLabel" width="15%">Patient Name</td>
		<td class="infoData" width="35%" colspan="3"><input type="text" name="nurobPatient" value="<%=nurobPatient == null ? "" : nurobPatient %>" maxlength="80" size="50" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">From Doctor</td>
		<td class="infoData" width="35%"><input type="text" name="nurobDr" value="<%=nurobDr == null ? "" : nurobDr %>" maxlength="80" size="25" /></td>
		<td class="infoLabel" width="15%">Clinic</td>
		<td class="infoData" width="35%"><input type="text" name="nurobClinic" value="<%=nurobClinic == null ? "" : nurobClinic %>" maxlength="80" size="25" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">E.D.C.</td>
		<td class="infoData" width="35%" colspan="3">
			<input type="text" name="nurobEdc" id="nurobEdc" class="datepickerfield" value="<%=nurobEdc == null ? "" : nurobEdc %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
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

<form name="form1" action="<html:rewrite page="/nurob/admltrForm.jsp" />" method="post">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');">Create</button></td>
	</tr>
</table>
<bean:define id="functionLabel"><bean:message key="function.nurob.admltr.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.admltrList" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="ID" />
	<display:column property="fields1" title="Patient Name" />
	<display:column property="fields4" title="Booking No."/>
	<display:column property="fields6" title="EDC" />
	<display:column property="fields7" title="Doctor" />
	<display:column property="fields8" title="Clinic" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
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
		document.search_form.nurobPatient.value = "";
		document.search_form.nurobDr.value = "";
		document.search_form.nurobClinic.value = "";
		document.search_form.nurobEdc.value = "";
		return false;
	}


	function submitAction(cmd, aid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&nurobAdmltrId=" + aid);
		return false;
	}

</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>