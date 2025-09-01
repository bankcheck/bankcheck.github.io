<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String fromDate = request.getParameter("fromDate");
String toDate = request.getParameter("toDate");
String staffID = request.getParameter("staffID");

if(staffID ==null){
	staffID = userBean.getStaffID();
}

if(userBean.isManager()){
	request.setAttribute("leave_list",ELeaveDB.getHistory(staffID,fromDate,toDate));
}else{
	request.setAttribute("leave_list",ELeaveDB.getHistory(userBean.getStaffID(),fromDate,toDate));
}
if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

if(staffID ==null){
	staffID = userBean.getStaffID();
}
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
<%String title = "Leave History"; %>
<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="isHideHeader" value="Y"/>
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="search_form" action="leaveHistory.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
			<tr class="smallText">
				<td class="infoLabel" width="30%">Date From</td>
				<td class="infoData" width="70%"><input type="text" name="fromDate" class="datepickerfield" value="<%=fromDate == null ? "" : fromDate%>" maxlength="10" size="10"></td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="30%">Date To</td>
				<td class="infoData" width="70%"><input type="text" name="toDate" class="datepickerfield" value="<%=toDate == null ? "" : toDate%>" maxlength="10" size="10"></td>
			</tr>
			<%if("manager".equals(userBean.getUserGroupID())){ %>
			<tr class="smallText">
				<td class="infoLabel" width="30%">Staff</td>
				<td class="infoData" width="70%">
									<select name="staffID">
								<option value=""></option>
								<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
								<jsp:param name="deptCode" value="<%=userBean.getDeptCode() %>" />
								<jsp:param name="value" value="<%=staffID %>" />
								<jsp:param name="ignoreCurrentStaffID" value="N" />
								<jsp:param name="showDeptDesc" value="N" />
								<jsp:param name="showFT" value="Y"/>
								</jsp:include>
							</select>
						<%} %>
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
<bean:define id="functionLabel">Leave History</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>

<form name="form1" action="leaveHistory.jsp" method="post">

	<display:table id="row" name="requestScope.leave_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
		<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
		<display:column property="fields5" title="Leave Type" style="width:20%"/>	
		<display:column title="Leave Date" style="width:20%">
			<c:out value="${row.fields3}" /> - <c:out value="${row.fields4}" />
		</display:column>
		<display:column property="fields6" title="Day(s) of Leave" style="width:5%"/>	
		<display:column property="fields7" title="Hour(s) of Leave" style="width:5%"/>
		<display:column property="fields8" title="Remarks" style="width:30%"/>
	</display:table>

</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}
</script>
</DIV></DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body></html:html>