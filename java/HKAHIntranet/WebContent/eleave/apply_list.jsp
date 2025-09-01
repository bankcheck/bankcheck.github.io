<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
HashMap statusHashSet = new HashMap();
statusHashSet.put("O", MessageResources.getMessage(session, "label.waiting.for.approve"));
statusHashSet.put("P", MessageResources.getMessage(session, "label.pending"));
statusHashSet.put("A", MessageResources.getMessage(session, "label.approved"));
statusHashSet.put("R", MessageResources.getMessage(session, "label.rejected"));
statusHashSet.put("C", MessageResources.getMessage(session, "label.confirmed"));

UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String staffID = userBean.getStaffID();
String command = request.getParameter("command");
String eleaveID = request.getParameter("eleaveID");
String appliedDate = request.getParameter("appliedDate");
String ls_responseRemarks = "";

boolean approveAction = false;
boolean rejectAction = false;
boolean deleteAction = false;

String message = "";
String errorMessage = "";

if ("Approve".equals(command)) {
	approveAction = true;
} else if ("Reject".equals(command)) {
	rejectAction = true;
} else if ("Delete".equals(command)) {
	deleteAction = true;
}

try {
if (approveAction) {
	if (ELeaveDB.update(userBean, eleaveID, appliedDate, null, "A", ls_responseRemarks)) {
		message = "Leave approved.";
		approveAction = false;
	} else {
		errorMessage = "Leave approve fail due to already approved or cancelled.";
	}
} else if (rejectAction) {
	if (ELeaveDB.update(userBean, eleaveID, appliedDate, null, "R", ls_responseRemarks)) {
		message = "Leave rejected.";
		rejectAction = false;
	} else {
		errorMessage = "Leave reject fail.";
	}
} else if (deleteAction) {
	String deleteValue = ELeaveDB.delete(userBean, eleaveID, "");
	if ("1".equals(deleteValue)) {
		message = "Leave Cancelled.";
		deleteAction = false;
	}else {
		errorMessage = "Leave cancel fail.";
	}	
}
} catch (Exception e) {
	e.printStackTrace();
}

message = request.getParameter("message");
if (message == null) {
	message = "";
}
errorMessage = "";

request.setAttribute("apply_list", ELeaveDB.getList(userBean));
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
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.eleave.list" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="apply_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<bean:define id="functionLabel"><bean:message key="function.eleave.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="apply_list.jsp" method="post">
<%	if (request.getParameter("search") == null ) { %>
<display:table id="row" name="requestScope.apply_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields2" titleKey="prompt.name" style="width:15%"/>
	<display:column property="fields3" titleKey="prompt.from" style="width:10%" />
	<display:column property="fields4" titleKey="prompt.to" style="width:10%" />
	<display:column titleKey="prompt.appliedDate" style="width:10%">
<%		if(("O".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7())||
			"P".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7()))&&
			ELeaveDB.checkValidApproveEl(((ReportableListObject)pageContext.getAttribute("row")).getFields0(),staffID)){ %>
			<input type="textfield" name="appliedDate" value=<%=((ReportableListObject)pageContext.getAttribute("row")).getFields5() %> maxlength="4" size="3" />
<%		} else {%>
			<c:out value="${row.fields5}" />
<%		} %>Day(s)
	</display:column>
	<display:column titleKey="prompt.status" style="width:10%">
		<%=statusHashSet.get(((ReportableListObject)pageContext.getAttribute("row")).getFields7()) %>
	</display:column>
	<display:column property="fields9" titleKey="prompt.createdBy" style="width:15%" />
	<display:column property="fields10" titleKey="prompt.createdDate" />
	<display:column property="fields12" titleKey="prompt.modifiedBy" style="width:15%" />
	<display:column property="fields13" titleKey="prompt.modifiedDate" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
<%		if(!"A".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7())&&!"R".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7())){ %>
<%			if (ELeaveDB.checkValidApproveEl(((ReportableListObject)pageContext.getAttribute("row")).getFields0(),staffID)) {%>
			<button onclick="return submitUpdate('Approve', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields5}" />');"><bean:message key='button.approve' /></button>
			<button onclick="return submitUpdate('Reject', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields5}" />');"><bean:message key='button.reject' /></button>
<%			} else {%>
			<button onclick="return submitAction('View', '<c:out value="${row.fields0}" />');"><bean:message key='button.view' /></button>
			<%if("O".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7())){ %>
				<button onclick="return submitUpdate('Delete', '<c:out value="${row.fields0}" />','1');"><bean:message key='button.cancel' /></button>
<%			} %>
<%		} %>
<%	} else {%>
			<button onclick="return submitAction('View', '<c:out value="${row.fields0}" />');"><bean:message key='button.view' /></button>
	<%} %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} %>
<%	if (!userBean.isAdmin()) { %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction('create', '');"><bean:message key="function.eleave.create" /></button>
			<button onclick="return submitView()"><bean:message key="button.viewSummary" /></button>
		</td>
</table>
<%	} %>
<input type="hidden" name="command">
<input type="hidden" name="eleaveID">
<input type="hidden" name=appliedDate>
</form>
<script language="javascript">

	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
	}

	function submitUpdate(command,eleaveID,appliedDate) {
//		alert('command:'+command+';eleaveID:'+eleaveID);
		document.form1.command.value = command;
		document.form1.eleaveID.value = eleaveID;
		document.form1.appliedDate.value = appliedDate;
		document.form1.submit();
	}

	function submitAction(cmd, eid) {
		callPopUpWindow("../eleave/apply.jsp?command=" + cmd + "&eleaveID=" + eid);
		return false;
	}

	function submitView() {
		callPopUpWindow("../eleave/info_list.jsp");
		return false;
	}
</script>
</div>
</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>