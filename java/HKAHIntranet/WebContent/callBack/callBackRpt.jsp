<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String ls_fromDate = request.getParameter("fromDate");
String ls_toDate = request.getParameter("toDate");
request.setAttribute("statList", CallBackClientDB.statList(ls_fromDate,ls_toDate));

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
<bean:define id="functionLabel"><bean:message key="function.cts.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="search_form" action="callBackRpt.jsp" method="post" onsubmit="return submitSearch();">
<table cellpadding="0" cellspacing="5"
		class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.dateRange" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="fromDate" id="fromDate" class="datepickerfield" value="<%=ls_fromDate==null?"":ls_fromDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			-
			<input type="textfield" name="toDate" id="toDate" class="datepickerfield" value="<%=ls_toDate==null?"":ls_toDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
		</td>
		<td align="left">
			<button onclick="return submitSearch();">Search</button>
		</td>
	</tr>
</table>
<display:table id="row" name="requestScope.statList" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Dr Name" style="width:5%" />
	<display:column property="fields1" title="Success" style="width:5%" />
	<display:column property="fields2" title="Not Success" style="width:5%" />
	<display:column property="fields3" title="Previous booked" style="width:5%" />
	<display:column property="fields4" title="In Progress" style="width:5%" format="{0,number,0}"/>
	<display:column property="fields5" title="Total Cases" style="width:5%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}
</script>
</div>
</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>