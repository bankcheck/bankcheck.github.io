<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.crm.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = request.getParameter("command");
String step = request.getParameter("step");
String clientID = request.getParameter("clientID");
if (clientID == null) {
	clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);
}
String clubID = request.getParameter("clubID");
String clubSeq = request.getParameter("clubSeq");
String clubDesc = request.getParameter("clubDesc");
String cardType = request.getParameter("cardType");
String memberID = request.getParameter("memberID");
String joinDate = null;
String joinDate_yy = request.getParameter("joinDate_yy");
String joinDate_mm = request.getParameter("joinDate_mm");
String joinDate_dd = request.getParameter("joinDate_dd");
if (joinDate_yy != null && joinDate_mm != null && joinDate_dd != null) {
	joinDate = joinDate_dd + "/" + joinDate_mm + "/" + joinDate_yy;
}
String issueDate = null;
String issueDate_yy = request.getParameter("issueDate_yy");
String issueDate_mm = request.getParameter("issueDate_mm");
String issueDate_dd = request.getParameter("issueDate_dd");
if (issueDate_yy != null && issueDate_mm != null && issueDate_dd != null) {
	issueDate = issueDate_dd + "/" + issueDate_mm + "/" + issueDate_yy;
}
String expiryDate = null;
String expiryDate_yy = request.getParameter("expiryDate_yy");
String expiryDate_mm = request.getParameter("expiryDate_mm");
String expiryDate_dd = request.getParameter("expiryDate_dd");
if (expiryDate_yy != null && expiryDate_mm != null && expiryDate_dd != null) {
	expiryDate = expiryDate_dd + "/" + expiryDate_mm + "/" + expiryDate_yy;
}
String paidYN = request.getParameter("paidYN");
String locationPath = null;

String exportType = request.getParameter("exportType");
String exportColumn = request.getParameter("exportColumn");
String exportRow = request.getParameter("exportRow");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean printAction = false;
boolean printLabelAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("print".equals(command)) {
	printAction = true;
} else if ("printLabel".equals(command)) {
	printLabelAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction && updateAction && (memberID == null || memberID.length() == 0)) {
			errorMessage = "Empty member #.";
		} else if (createAction) {
			if (CRMClientMembershipDB.isExistMemberID(clientID, clubID, memberID)) {
				errorMessage = "Membership create fail due to member # already exist.";
			} else {
				clubSeq = CRMClientMembershipDB.add(userBean, clientID, clubID, cardType, memberID, joinDate, issueDate, expiryDate, paidYN);
				if (clubSeq != null) {
					message = "Membership created.";
					createAction = false;
				} else {
					errorMessage = "Membership create fail.";
				}
			}
		} else if (updateAction) {
			if (CRMClientMembershipDB.isExistMemberID(clientID, clubID, memberID)) {
				errorMessage = "Membership update fail due to member # already exist.";
			} else if (CRMClientMembershipDB.update(userBean, clientID, clubID, clubSeq, cardType, memberID, joinDate, issueDate, expiryDate, paidYN)) {
				message = "Membership updated.";
				updateAction = false;
			} else {
				errorMessage = "Membership update fail.";
			}
		} else if (deleteAction) {
			if (CRMClientMembershipDB.delete(userBean, clientID, clubID, clubSeq)) {
				message = "Membership removed.";
				closeAction = true;
			} else {
				errorMessage = "Membership remove fail.";
			}
		} else if (printAction) {
			locationPath = CRMClientMembershipDB.createPDF(userBean, clientID, clubID, clubSeq);
		} else if (printLabelAction) {
			locationPath = CRMClientDB.createPDFAddress(session, userBean, clientID, exportType, exportColumn, exportRow);
		}
		step = null;
	} else if (createAction) {
		paidYN = "N";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (clubID != null && clubID.length() > 0
				&& clubSeq != null && clubSeq.length() > 0) {

			ArrayList record = CRMClientMembershipDB.get(clientID, clubID, clubSeq);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				cardType = row.getValue(0);
				memberID = row.getValue(1);
				clubDesc = row.getValue(2);
				joinDate = row.getValue(3);
				issueDate = row.getValue(4);
				expiryDate = row.getValue(5);
				paidYN = row.getValue(6);
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
<META HTTP-EQUIV="Refresh" CONTENT="0; URL=client_info.jsp#member">
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
	title = "function.member." + commandType;
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
	<jsp:param name="href" value="member" />
</jsp:include>
<table width="100%" border="0">
	<tr class="smallText">
		<td class="infoTitle"><bean:message key="prompt.membership" /></td>
	</tr>
</table>
<form name="form1" action="client_membership.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.category" /></td>
		<td class="infoData" width="70%">
<%	if (createAction) { %>
			<select name="clubID">
<jsp:include page="../ui/clubIDCMB.jsp" flush="false">
	<jsp:param name="clubID" value="<%=clubID %>" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
<%	} else { %>
			<%=clubDesc==null?"":clubDesc %><input type="hidden" name="clubID" value="<%=clubID %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.memberNumber" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="memberID" value="<%=memberID==null?"":memberID %>" maxlength="100" size="50">
<%	} else { %>
			<%=memberID==null?"":memberID %><input type="hidden" name="memberID" value="<%=memberID %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.cardType" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select name="cardType">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="cardType" />
	<jsp:param name="parameterValue" value="<%=cardType %>" />
</jsp:include>
			</select>
<%	} else { %>
			<%=ParameterHelper.getCardTypeValue(session, cardType) %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.joinedDate" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="joinDate" />
	<jsp:param name="date" value="<%=joinDate %>" />
	<jsp:param name="yearRange" value="10" />
	<jsp:param name="showTime" value="N" />
</jsp:include>
<%	} else { %>
			<%=joinDate==null?"":joinDate %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.issuedDate" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="issueDate" />
	<jsp:param name="date" value="<%=issueDate %>" />
	<jsp:param name="yearRange" value="10" />
	<jsp:param name="showTime" value="N" />
</jsp:include>
<%	} else { %>
			<%=issueDate==null?"":issueDate %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.expiryDate" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="expiryDate" />
	<jsp:param name="date" value="<%=expiryDate %>" />
	<jsp:param name="yearRange" value="10" />
	<jsp:param name="addYear" value="Y" />
	<jsp:param name="showTime" value="N" />
</jsp:include>
<%	} else { %>
			<%=expiryDate==null?"":expiryDate %>
<%	} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.paid" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="radio" name="paidYN" value="Y"<%="Y".equals(paidYN)?" checked":"" %>><bean:message key="label.yes" />
			<input type="radio" name="paidYN" value="N"<%="N".equals(paidYN)?" checked":"" %>><bean:message key="label.no" />
<%	} else { %>
			<%if ("Y".equals(paidYN)) { %><bean:message key="label.yes" /><%} else { %><bean:message key="label.no" /><%} %>
<%	} %>
		</td>
	</tr>
<%	if (!createAction && !updateAction && !deleteAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Print Membership Card</td>
		<td class="infoData" width="70%">
			<button onclick="return submitAction('print', 1);" class="btn-click">Generate Membership Label</button>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Print Address Label</td>
		<td class="infoData" width="85%" colspan="3">
			<select name="exportType">
				<option value="">---</option>
				<option value="L7160"<%="L7160".equals(exportType)?" selected":"" %>>Avery L7160</option>
				<option value="8220"<%="8220".equals(exportType)?" selected":"" %>>Herma-8220</option>
			</select>
			&nbsp;&nbsp;Location: Column
			<select name="exportColumn">
				<option value="">---</option>
				<option value="1"<%="1".equals(exportColumn)?" selected":"" %>>1</option>
				<option value="2"<%="2".equals(exportColumn)?" selected":"" %>>2</option>
				<option value="3"<%="3".equals(exportColumn)?" selected":"" %>>3</option>
			</select>
			Row
			<select name="exportRow">
				<option value="">---</option>
				<option value="1"<%="1".equals(exportRow)?" selected":"" %>>1</option>
				<option value="2"<%="2".equals(exportRow)?" selected":"" %>>2</option>
				<option value="3"<%="3".equals(exportRow)?" selected":"" %>>3</option>
				<option value="4"<%="4".equals(exportRow)?" selected":"" %>>4</option>
				<option value="5"<%="5".equals(exportRow)?" selected":"" %>>5</option>
				<option value="6"<%="6".equals(exportRow)?" selected":"" %>>6</option>
				<option value="7"<%="7".equals(exportRow)?" selected":"" %>>7</option>
				<option value="8"<%="8".equals(exportRow)?" selected":"" %>>8</option>
			</select>
			<button onclick="return submitAction('printLabel', 1);" class="btn-click">Generate Address Label</button>
		</td>
	</tr>
<%	} %>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.membership.update" /></button>
			<button class="btn-delete"><bean:message key="function.membership.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="<%=commandType %>">
<input type="hidden" name="step" value="1">
<input type="hidden" name="clientID" value="<%=clientID %>">
<input type="hidden" name="clubSeq" value="<%=clubSeq %>">
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
		if (cmd == 'printLabel') {
			if (document.form1.exportType.value == '') {
				alert("Please select export type!");
				document.form1.exportType.focus();
				return false;
			}
			if (document.form1.exportColumn.value == '') {
				alert("Please select export column!");
				document.form1.exportColumn.focus();
				return false;
			}
			if (document.form1.exportRow.value == '') {
				alert("Please select export row!");
				document.form1.exportRow.focus();
				return false;
			}
			if (document.form1.exportType.value == '8220' && document.form1.exportColumn.value == '3') {
				alert("Herma-8220 Label can only have two columns!");
				document.form1.exportColumn.focus();
				return false;
			}
			if (document.form1.exportType.value == 'L7160' && document.form1.exportRow.value == '8') {
				alert("Avery L7160 Label can only have seven rows!");
				document.form1.exportRow.focus();
				return false;
			}
		} else if ((cmd == 'create' || cmd == 'update') && stp == 1) {
			if (document.form1.memberID.value == '') {
				alert("Empty Member #.");
				document.form1.memberID.focus();
				return false;
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

<%	if (locationPath != null) { %>
	callPopUpWindow("/intranet/FopServlet?fo=<%=locationPath %>");
<%	} %>
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>