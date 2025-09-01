<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String as_patNo = request.getParameter("patNo");
String as_patName = request.getParameter("patName");
String as_docNo = request.getParameter("docNo");
int current_yy = DateTimeUtil.getCurrentYear();
int current_mm = DateTimeUtil.getCurrentMonth();
int current_dd = DateTimeUtil.getCurrentDay();
String as_flwDateFrom = request.getParameter("flw_date_from");
String as_flwDateTo = request.getParameter("flw_date_to");
String as_apptDateFrom = request.getParameter("date_from");
if (as_apptDateFrom == null || as_apptDateFrom.length() == 0) {
	as_apptDateFrom = current_dd + "/" + current_mm + "/" + current_yy;
}
String as_apptDateTo = request.getParameter("date_to");
String as_hisStatus = request.getParameter("hisStatus");

request.setAttribute("callList", CallBackClientDB.getList(as_patNo,as_docNo,as_patName,as_apptDateFrom,as_apptDateTo,as_flwDateFrom,as_flwDateTo,as_hisStatus));

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
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.callList.client.list" />
	<jsp:param name="category" value="group.callBack" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="callList.jsp" method="get">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.docNo" /></td>
		<td class="infoData" width="35%"><input type="textfield" name="docNo" value="<%=as_docNo==null?"":as_docNo %>" maxlength="10" size="50"></td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.followUpStatus" /></td>
		<td class="infoData" width="35%">
			<select name="hisStatus">
				<option value="">
				<option value="0"<%="0".equals(as_hisStatus)?" selected":""%>>Completed</option>
				<option value="1"<%="1".equals(as_hisStatus)?" selected":""%>>Follow up by PBO</option>
				<option value="2"<%="2".equals(as_hisStatus)?" selected":""%>>Follow up by nurse</option>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.apptDate" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=as_apptDateFrom==null?"":as_apptDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			-
			<input type="textfield" name="date_to" id="date_to" class="datepickerfield" value="<%=as_apptDateTo==null?"":as_apptDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.followUpDate" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="flw_date_from" id="flw_date_from" class="datepickerfield" value="<%=as_flwDateFrom==null?"":as_flwDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			-
			<input type="textfield" name="flw_date_to" id="flw_date_to" class="datepickerfield" value="<%=as_flwDateTo==null?"":as_flwDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.patNo" /></td>
		<td class="infoData" width="35%"><input type="textfield" name="patNo" value="<%=as_patNo==null?"":as_patNo %>" maxlength="10" size="50"></td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.patName" /></td>
		<td class="infoData" width="35%"><input type="textfield" name="patName" value="<%=as_patName==null?"":as_patName %>" maxlength="10" size="50"></td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
		<td colspan="4" align="center">
			<button onclick="return submitReport();"><bean:message key="button.showcbrpt" /></button>
		</td>
	</tr>

</table>
</form>
<bean:define id="functionLabel"><bean:message key="function.callList.client.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="callBackHist.jsp" method="post">
<display:table id="row" name="requestScope.callList" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Patient NO" style="width:6%" />
	<display:column property="fields5" title="Patient Name" style="width:15%" />
	<display:column property="fields4" title="Appt Status" style="width:6%" />
	<display:column property="fields2" title="Appt Date" style="width:8%" />
	<display:column property="fields8" title="Follow Up Date" style="width:8%" />
	<display:column property="fields17" title="Doc NO" style="width:6%" />
	<display:column property="fields6" title="DR Name" style="width:12%" />
	<display:column property="fields9" titleKey="prompt.rmkPbo" style="width:12%" />
	<display:column property="fields10" titleKey="prompt.rmkNrs" style="width:12%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><bean:message key='button.view' /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function submitReport() {
		callPopUpWindow("../callBack/callBackRpt.jsp");
	}

	function clearSearch() {
		document.search_form.patNo.value="";
		document.search_form.patName.value="";
		document.search_form.docNo.value="";
	}

	function submitAction(ls_patNo, ls_seqNo) {
		callPopUpWindow(document.form1.action + "?patNo=" + ls_patNo + "&seqNo=" + ls_seqNo);
		return false;
	}
</script>

</div>

</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>