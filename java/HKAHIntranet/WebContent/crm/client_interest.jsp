<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.crm.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String clientID = request.getParameter("clientID");
if (clientID == null) {
	clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);
}
String command = request.getParameter("command");
String step = request.getParameter("step");
String interestID = request.getParameter("interestID");
String interestSeq = request.getParameter("interestSeq");
String interestType = request.getParameter("interestType");
String remarks = request.getParameter("remarks");
boolean interestTypeB = "B".equals(interestType);

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction) {
			interestSeq = CRMClientInterest.add(userBean, clientID, interestID, interestType, remarks);
			if (interestSeq != null) {
				message = "Interest created.";
				createAction = false;
				step = "0";
			} else {
				errorMessage = "Interest create fail.";
			}
		} else if (updateAction) {
			if (CRMClientInterest.update(userBean, remarks, clientID, interestID, interestSeq, interestType)) {
				message = "Interest updated.";
				updateAction = false;
				step = "0";
			} else {
				errorMessage = "Interest update fail.";
			}
		} else if (deleteAction) {
			if (CRMClientInterest.delete(userBean, clientID, interestID, interestSeq, interestType)) {
				message = "Interest removed.";
				deleteAction = false;
				step = "0";
			} else {
				errorMessage = "Interest remove fail.";
			}
		}
	} else if (createAction) {
		remarks = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (interestID != null && interestID.length() > 0) {
			ArrayList record = CRMClientInterest.get(clientID, interestID, interestSeq, interestType);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				remarks = row.getValue(0);
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>
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
<html:html xhtml="true" lang="true">
<%if (closeAction) {%>
<META HTTP-EQUIV="Refresh" CONTENT="0; URL=client_info.jsp#interest">
<%} else { %>
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	String parameterType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	if (interestTypeB) {
		title = "function.interestHobby." + commandType;
		parameterType = "hobby";
	} else {
		title = "function.interestHospital." + commandType;
		parameterType = "hospitalFacility";
	}
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="1" />
	<jsp:param name="href" value="interest" />
</jsp:include>
<table width="100%" border="0">
	<tr class="smallText">
		<td class="infoTitle">
<%	if (!interestTypeB) { %><bean:message key="prompt.interestHobby" /><%} else { %><bean:message key="prompt.interestHospital" /><%} %>
		</td>
	</tr>
</table>
<form name="form1" action="client_interest.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">
<%	if (!interestTypeB) { %><bean:message key="prompt.interestHobby" /><%} else { %><bean:message key="prompt.interestHospital" /><%} %>
		</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="interestID">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="<%=parameterType %>" />
	<jsp:param name="parameterValue" value="<%=interestID %>" />
</jsp:include>
			</select>
<%	} else { %>
<%		if (interestTypeB) { %>
			<%=ParameterHelper.getHobbyValue(session, interestID) %>
<%		} else { %>
			<%=ParameterHelper.getHospitalFacilityValue(session, interestID) %>
<%		} %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.remarks" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="remarks" value="<%=remarks==null?"":remarks %>" maxlength="100" size="50">
<%	} else { %>
			<%=remarks==null?"":remarks %>
<%	} %>
		</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
<%		if (interestTypeB) { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.interestHobby.update" /></button>
			<button class="btn-delete"><bean:message key="function.interestHobby.delete" /></button>
<% 		} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.interestHospital.update" /></button>
			<button class="btn-delete"><bean:message key="function.interestHospital.delete" /></button>
<% 		} %>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="<%=commandType %>">
<input type="hidden" name="step" value="1">
<input type="hidden" name="interestID" value="<%=interestID %>">
<input type="hidden" name="interestSeq" value="<%=interestSeq %>">
<input type="hidden" name="interestType" value="<%=interestType %>">
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>