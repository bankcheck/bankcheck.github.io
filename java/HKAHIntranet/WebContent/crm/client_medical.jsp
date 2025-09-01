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
String medicalID = request.getParameter("medicalID");
String medicalSeq = request.getParameter("medicalSeq");
String medicalType = request.getParameter("medicalType");
String remarks = request.getParameter("remarks");
boolean medicalTypeI = "I".equals(medicalType);

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
			medicalSeq = CRMClientMedical.add(userBean, clientID, medicalID, medicalType, remarks);
			if (medicalSeq != null) {
				message = "Interest created.";
				createAction = false;
				step = "0";
			} else {
				errorMessage = "Medical record create fail.";
			}
		} else if (updateAction) {
			if (CRMClientMedical.update(userBean, remarks, clientID, medicalID, medicalSeq, medicalType)) {
				message = "Interest updated.";
				updateAction = false;
				step = "0";
			} else {
				errorMessage = "Medical record update fail.";
			}
		} else if (deleteAction) {
			if (CRMClientMedical.delete(userBean, clientID, medicalID, medicalSeq, medicalType)) {
				message = "Interest removed.";
				deleteAction = false;
				step = "0";
			} else {
				errorMessage = "Medical record remove fail.";
			}
		}
	} else if (createAction) {
		remarks = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (medicalID != null && medicalID.length() > 0) {
			ArrayList record = CRMClientMedical.get(clientID, medicalID, medicalSeq, medicalType);
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
<META HTTP-EQUIV="Refresh" CONTENT="0; URL=client_info.jsp#medical">
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
	if (medicalTypeI) {
		title = "function.medicalRecordIndividual." + commandType;
	} else {
		title = "function.medicalRecordFamily." + commandType;
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
	<jsp:param name="href" value="medical" />
</jsp:include>
<table width="100%" border="0">
	<tr class="smallText">
		<td class="infoTitle">
<%	if (medicalTypeI) { %><bean:message key="prompt.medicalRecordIndividual" /><%} else { %><bean:message key="prompt.medicalRecordFamily" /><%} %>
		</td>
	</tr>
</table>
<form name="form1" action="client_medical.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">
<%	if (medicalTypeI) { %><bean:message key="prompt.medicalRecordIndividual" /><%} else { %><bean:message key="prompt.medicalRecordFamily" /><%	} %>
		</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="medicalID">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="medical" />
	<jsp:param name="parameterValue" value="<%=medicalID %>" />
</jsp:include>
			</select>
<%	} else { %>
			<%=ParameterHelper.getMedicalValue(session, medicalID) %>
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
<%	} else {
		if (medicalTypeI) { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.medicalRecordIndividual.update" /></button>
			<button class="btn-delete"><bean:message key="function.medicalRecordIndividual.delete" /></button>
<% 		} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.medicalRecordFamily.update" /></button>
			<button class="btn-delete"><bean:message key="function.medicalRecordFamily.delete" /></button>
<%		}
	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="<%=commandType %>">
<input type="hidden" name="step" value="1">
<input type="hidden" name="medicalID" value="<%=medicalID %>">
<input type="hidden" name="medicalSeq" value="<%=medicalSeq %>">
<input type="hidden" name="medicalType" value="<%=medicalType %>">
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