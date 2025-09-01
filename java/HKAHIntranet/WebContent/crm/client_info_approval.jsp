<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String clientID = request.getParameter("clientID");
String siteCode = request.getParameter("siteCode");
String deptCode = request.getParameter("deptCode");
String userID = request.getParameter("userID");
String approveID = request.getParameter("approveID");

boolean cancelAction = false;
boolean approveAction = false;
boolean rejectAction = false;

if ("cancel".equals(command)) {
	cancelAction = true;
} else if ("approve".equals(command)) {
	approveAction = true;
} else if ("reject".equals(command)) {
	rejectAction = true;
}

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";

if (cancelAction) {
	if (ApprovalUserDB.processRequest(userBean, "crm", "client", approveID, siteCode, deptCode, userID, clientID, "C")) {
		message = "Request Cancelled.";
	} else {
		errorMessage = "Request fail to cancel.";
	}
} else if (approveAction) {
	if (ApprovalUserDB.processRequest(userBean, "crm", "client", approveID, siteCode, deptCode, userID, clientID, "A")) {
		message = "Request Accepted.";
	} else {
		errorMessage = "Request fail to accept.";
	}
} else if (rejectAction) {
	if (ApprovalUserDB.processRequest(userBean, "crm", "client", approveID, siteCode, deptCode, userID, clientID, "R")) {
		message = "Request Rejected.";
	} else {
		errorMessage = "Request fail to reject.";
	}
}

request.setAttribute("client_list_approval", ApprovalUserDB.getList(userBean, "crm", "client"));
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
	<jsp:param name="pageTitle" value="function.client.approval" />
	<jsp:param name="category" value="group.crm" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="client_info_approval.jsp" method="post">
<bean:define id="functionLabel"><bean:message key="function.client.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.client_list_approval" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.requestFrom" style="width:30%">
		<c:out value="${row.fields4}" />
		(
		<logic:equal name="row" property="fields1" value="<%=ConstantsServerSide.SITE_CODE_HKAH %>">
			<bean:message key="label.hkah" />
		</logic:equal>
		<logic:notEqual name="row" property="fields1" value="<%=ConstantsServerSide.SITE_CODE_HKAH %>">
			<bean:message key="label.twah" />
		</logic:notEqual>
		<logic:equal name="row" property="fields2" value="520">
			<bean:message key="department.520" />
		</logic:equal>
		<logic:equal name="row" property="fields2" value="660">
			<bean:message key="department.660" />
		</logic:equal>
		<logic:equal name="row" property="fields2" value="670">
			<bean:message key="department.670" />
		</logic:equal>
		<logic:equal name="row" property="fields2" value="750">
			<bean:message key="department.750" />
		</logic:equal>
		)
	</display:column>
	<display:column titleKey="prompt.ownerBy" style="width:30%">
		<logic:equal name="row" property="fields5" value="<%=ConstantsServerSide.SITE_CODE_HKAH %>">
			<bean:message key="label.hkah" />
		</logic:equal>
		<logic:notEqual name="row" property="fields5" value="<%=ConstantsServerSide.SITE_CODE_HKAH %>">
			<bean:message key="label.twah" />
		</logic:notEqual>
		<logic:equal name="row" property="fields6" value="520">
			<bean:message key="department.520" />
		</logic:equal>
		<logic:equal name="row" property="fields6" value="660">
			<bean:message key="department.660" />
		</logic:equal>
		<logic:equal name="row" property="fields6" value="670">
			<bean:message key="department.670" />
		</logic:equal>
		<logic:equal name="row" property="fields6" value="750">
			<bean:message key="department.750" />
		</logic:equal>
	</display:column>
	<display:column property="fields10" titleKey="prompt.modifiedDate" style="width:15%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields9}" />', '');"><bean:message key="button.view" /></button>
		<logic:equal name="row" property="fields11" value="O">
			<logic:equal name="row" property="fields3" value="<%=userBean.getStaffID() %>">
				<button onclick="return submitAction('cancel', '<c:out value="${row.fields9}" />', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields0}" />');"><bean:message key="button.cancel" /></button>
			</logic:equal>
			<logic:equal name="row" property="fields7" value="<%=userBean.getStaffID() %>">
				<button onclick="return submitAction('approve', '<c:out value="${row.fields9}" />', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields0}" />');"><bean:message key="button.approve" /></button>
				<button onclick="return submitAction('reject', '<c:out value="${row.fields9}" />', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields0}" />');"><bean:message key="button.reject" /></button>
			</logic:equal>
		</logic:equal>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="command">
<input type="hidden" name="clientID">
<input type="hidden" name="siteCode">
<input type="hidden" name="deptCode">
<input type="hidden" name="userID">
<input type="hidden" name="approveID">
</form>
<script language="javascript">
<!--
	function submitAction(cmd, cid, sid, did, uid, aid) {
		if (cmd == 'view') {
			callPopUpWindow("client_info.jsp?command=" + cmd + "&clientID=" + cid);
			return false;
		} else {
			document.form1.command.value = cmd;
			document.form1.clientID.value = cid;
			document.form1.siteCode.value = sid;
			document.form1.deptCode.value = did;
			document.form1.userID.value = uid;
			document.form1.approveID.value = aid;
			document.form1.submit();
		}
	}
-->
</script>

</DIV>

</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>