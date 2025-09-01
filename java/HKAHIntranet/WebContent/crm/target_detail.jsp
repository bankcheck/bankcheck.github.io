<%@ page import="java.util.*" %>
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
<%
	Map crm = (HashMap) request.getAttribute("crm");
%>
<!-- 
<c:if test="${crm == null}">
	<c:redirect url="promotion_detail.htm" />
</c:if>
-->

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<c:set var="allowRemove" value="${crm.allowRemove}"/>
<jsp:useBean id="allowRemove" type="java.lang.String"/>
<c:set var="title" value="${crm.title}"/>
<jsp:useBean id="title" type="java.lang.String"/>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<c:set var="message" value="${crm.message}" />
<jsp:useBean id="message" class="java.lang.String" />
<c:set var="errorMessage" value="${crm.errorMessage}" />
<jsp:useBean id="errorMessage" class="java.lang.String" />
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<c:choose>
	<c:when test="${!crm.createAction && crm.crmTarget == null}">
		<div class="pane">
			<bean:message key="prompt.notExist" />
			<table width="100%" border="0">
				<tr class="smallText">
					<td align="center">
						<button onclick="window.close();" class="btn-click"><bean:message key="label.close" /></button>
					</td>
				</tr>
			</table>
		</div>
	</c:when>
	<c:otherwise>
<form name="form1" id="form1" action="target_detail.htm" enctype="multipart/form-data" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.targetName" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${crm.createAction || crm.updateAction}" > 
					<input type="text" name="crmTargetName" value="<c:out value="${crm.crmTarget.crmTargetName}"/>" maxlength="200" size="100" />
				</c:when>
				<c:otherwise>
					<c:out value="${crm.crmTarget.crmTargetName}"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.targetDescription" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${crm.createAction || crm.updateAction}" > 
					<input type="text" name="crmTargetDescription" value="<c:out value="${crm.crmTarget.crmTargetDescription}"/>" maxlength="200" size="100" />
				</c:when>
				<c:otherwise>
					<c:out value="${crm.crmTarget.crmTargetDescription}"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	
</table>

<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
				<c:choose>
					<c:when test="${crm.createAction || crm.updateAction || crm.deleteAction}" >
						<button onclick="return submitAction('<c:out value="${crm.commandType}"/>', 1, 0);" class="btn-click">
							<bean:message key="button.save" /> - <bean:message key="<%=title %>" />
						</button>
						<button onclick="return submitAction('view', 0, 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
					</c:when>
					<c:otherwise>
						<button onclick="return submitAction('update', 0, 0);" class="btn-click"><bean:message key="function.promotion.update" /></button>
						<button class="btn-delete"><bean:message key="function.target.delete" /></button>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="targetID" value="<c:out value="${crm.crmTarget.crmTargetId}" />" />
</form>
<script language="javascript">
<!--
	// validate form
<%
	if ((Boolean) crm.get("createAction") || (Boolean) crm.get("updateAction")){
%>
	$("#form1").validate({
		rules: {
			crmTargetName: { required: true }
		},
		messages: {
			crmTargetName: { required: "<bean:message key="error.targetName.required" />" }
		}
	});
<%
	}
%>
	
	function submitAction(cmd, stp, seq) {
		if (stp == 1) {
			if (cmd == 'create' || cmd == 'update') {
				// validation
			} 
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
-->
</script>
	</c:otherwise>
</c:choose>
</div>
</div>
</div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>