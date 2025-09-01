<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);

String command = request.getParameter("command");
String step = request.getParameter("step");
String donationID = request.getParameter("donationID");
String donationSeq = request.getParameter("donationSeq");
String fiscalYear = request.getParameter("fiscalYear");
String fundID = request.getParameter("fundID");
String fundDesc = null;
String appealID = request.getParameter("appealID");
String appealDesc = null;
String campaignID = request.getParameter("campaignID");
String campaignDesc = null;
String pledgeDate = request.getParameter("pledgeDate");
String status = request.getParameter("status");
String donorID = request.getParameter("donorID");
String donorName = null;
String pledgedAmount = request.getParameter("pledgedAmount");
String receivedAmount = request.getParameter("receivedAmount");
String remarks = request.getParameter("remarks");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean createNewAction = false;

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
			StringBuffer sqlStr = new StringBuffer();
			if (donationID == null || donationID.length() == 0) {
				sqlStr.append("SELECT COUNT(1) + 1 ");
				sqlStr.append("FROM   CRM_CLIENTS_DONATION ");
	
				ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
				if (record.size() > 0) {
					// assign value from database
					ReportableListObject row = (ReportableListObject) record.get(0);
					donationID = row.getValue(0);
				}
				createNewAction = true;
			}

			sqlStr.setLength(0);
			sqlStr.append("INSERT INTO CRM_CLIENTS_DONATION_DETAIL ");
			sqlStr.append("(CRM_DONATION_ID, CRM_DONATION_SEQ, CRM_CLIENT_ID, CRM_FISCAL_YEAR, ");
			sqlStr.append(" CRM_FUND_ID, CRM_CAMPAIGN_ID, CRM_APPEAL_ID, ");
			sqlStr.append(" CRM_STATUS, CRM_PLEDGED_AMOUNT, CRM_RECEIVED_AMOUNT, ");
			sqlStr.append(" CRM_REMARKS, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
			sqlStr.append("VALUES ");
			sqlStr.append("(?, (SELECT COUNT(1) + 1 FROM CRM_CLIENTS_DONATION_DETAIL WHERE CRM_DONATION_ID = ?), ?, ?, ");
			sqlStr.append(" ?, ?, ?,");
			sqlStr.append(" ?, ?, ?,");
			sqlStr.append(" ?, ?, ?)");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { donationID, donationID, clientID, fiscalYear,
						fundID, campaignID, appealID,
						status, pledgedAmount, receivedAmount,
						remarks, loginID, loginID } )) {
				message = "Pledge created.";
			} else {
				errorMessage = "Pledge create fail.";
			}
		} else if (updateAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_CLIENTS_DONATION_DETAIL ");
			sqlStr.append("SET    CRM_CLIENT_ID = ?, CRM_FISCAL_YEAR = ?, CRM_FUND_ID = ?, ");
			sqlStr.append("       CRM_CAMPAIGN_ID = ?, CRM_APPEAL_ID = ?, CRM_STATUS = ?, ");
			sqlStr.append("       CRM_PLEDGED_AMOUNT = ?, CRM_RECEIVED_AMOUNT = ?, ");
			sqlStr.append("       CRM_REMARKS = ?, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_DONATION_ID = ? ");
			sqlStr.append("AND    CRM_DONATION_SEQ = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { clientID, fiscalYear, fundID,
						campaignID, appealID, status,
						pledgedAmount, receivedAmount,
						remarks, loginID, donationID, donationSeq } )) {
				message = "Pledge updated.";
			} else {
				errorMessage = "Pledge update fail.";
			}
		} else if (deleteAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_CLIENTS_DONATION_DETAIL ");
			sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_DONATION_ID = ? ");
			sqlStr.append("AND    CRM_DONATION_SEQ = ?");

			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { loginID, donationID, donationSeq } )) {
				message = "Pledge removed.";
			} else {
				errorMessage = "Pledge remove fail.";
			}
		}

		// forward to list page
		if (errorMessage == null || errorMessage.length() == 0) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT SUM(CRM_PLEDGED_AMOUNT), SUM(CRM_RECEIVED_AMOUNT) ");
			sqlStr.append("FROM   CRM_CLIENTS_DONATION_DETAIL ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_DONATION_ID = ? ");
			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { donationID });
			if (record.size() > 0) {
				// assign value from database
				ReportableListObject row = (ReportableListObject) record.get(0);
				pledgedAmount = row.getValue(0);
				receivedAmount = row.getValue(1);
			}

			// decide status
			float pledgedAmountFloat = NumericUtil.parseFloat(pledgedAmount);
			float receivedAmountFloat = NumericUtil.parseFloat(receivedAmount);
			float balance = receivedAmountFloat - pledgedAmountFloat;
			if (pledgedAmountFloat > 0 && receivedAmountFloat == 0) {
				// pledge
				status = "p";
			} else if (pledgedAmountFloat > 0 && receivedAmountFloat > 0) {
				// payment
				if (pledgedAmountFloat == receivedAmountFloat) {
					status = "fp";
				} else {
					status = "pp";
				}
			} else {
				// appeal
				status = "a";
			}

			if (createNewAction) {
				sqlStr.setLength(0);
				sqlStr.append("INSERT INTO CRM_CLIENTS_DONATION ");
				sqlStr.append("(CRM_DONATION_ID, CRM_CLIENT_ID, CRM_FISCAL_YEAR, ");
				sqlStr.append(" CRM_FUND_ID, CRM_CAMPAIGN_ID, CRM_APPEAL_ID, ");
				sqlStr.append(" CRM_STATUS, CRM_PLEDGED_AMOUNT, CRM_RECEIVED_AMOUNT, ");
				sqlStr.append(" CRM_BALANCE_AMOUNT, CRM_REMARKS, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
				sqlStr.append("VALUES ");
				sqlStr.append("(?, ?, ?, ");
				sqlStr.append(" ?, ?, ?,");
				sqlStr.append(" ?, ?, ?,");
				sqlStr.append(" ?, ?, ?, ?)");

				UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { donationID, clientID, fiscalYear,
						fundID, campaignID, appealID,
						status, pledgedAmount, receivedAmount,
						String.valueOf(balance), remarks, loginID, loginID } );
			} else if (deleteAction) {
				sqlStr.setLength(0);
				sqlStr.append("UPDATE CRM_CLIENTS_DONATION ");
				sqlStr.append("SET    CRM_STATUS, CRM_PLEDGED_AMOUNT = ?, CRM_RECEIVED_AMOUNT = ?, ");
				sqlStr.append("       CRM_BALANCE_AMOUNT = ?, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
				sqlStr.append("WHERE  CRM_ENABLED = 1 ");
				sqlStr.append("AND    CRM_DONATION_ID = ? ");
	
				UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { pledgedAmount, receivedAmount,
						String.valueOf(balance),
						loginID, donationID } );
			} else {
				sqlStr.setLength(0);
				sqlStr.append("UPDATE CRM_CLIENTS_DONATION ");
				sqlStr.append("SET    CRM_CLIENT_ID = ?, CRM_FISCAL_YEAR = ?, CRM_FUND_ID = ?, ");
				sqlStr.append("       CRM_CAMPAIGN_ID = ?, CRM_APPEAL_ID = ?, CRM_STATUS = ?, ");
				sqlStr.append("       CRM_PLEDGED_AMOUNT = ?, CRM_RECEIVED_AMOUNT = ?, CRM_BALANCE_AMOUNT = ?, ");
				sqlStr.append("       CRM_REMARKS = ?, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
				sqlStr.append("WHERE  CRM_ENABLED = 1 ");
				sqlStr.append("AND    CRM_DONATION_ID = ? ");
	
				UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { clientID, fiscalYear, fundID,
						campaignID, appealID, status,
						pledgedAmount, receivedAmount, String.valueOf(balance),
						remarks, loginID, donationID } );
			}

%>
<jsp:forward page="donation.jsp">
	<jsp:param name="message" value="<%=message %>"/>
	<jsp:param name="donationID" value="<%=donationID %>"/>
</jsp:forward>
<%
		}
	} else if (createAction) {
		fiscalYear = String.valueOf(DateTimeUtil.getCurrentYear());
		donorID = clientID;
		pledgedAmount = "";
		receivedAmount = "";
		remarks = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (donationID != null && donationID.length() > 0) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT CL.CRM_LASTNAME, CL.CRM_FIRSTNAME, ");
			sqlStr.append("       D.CRM_CLIENT_ID, D.CRM_FISCAL_YEAR, ");
			sqlStr.append("       D.CRM_FUND_ID, F.CRM_FUND_DESC, ");
			sqlStr.append("       D.CRM_APPEAL_ID, A.CRM_APPEAL_DESC, ");
			sqlStr.append("       D.CRM_CAMPAIGN_ID, C.CRM_CAMPAIGN_DESC, ");
			sqlStr.append("       TO_CHAR(D.CRM_DONATION_DATE, 'dd/MM/YYYY'), D.CRM_STATUS, ");
			sqlStr.append("       D.CRM_PLEDGED_AMOUNT, D.CRM_RECEIVED_AMOUNT, D.CRM_REMARKS ");
			sqlStr.append("FROM   CRM_CLIENTS_DONATION_DETAIL D, CRM_CLIENTS CL, ");
			sqlStr.append("       CRM_APPEALS A, CRM_FUNDS F, CRM_CAMPAIGNS C ");
			sqlStr.append("WHERE  D.CRM_CLIENT_ID = CL.CRM_CLIENT_ID ");
			sqlStr.append("AND    D.CRM_FUND_ID = F.CRM_FUND_ID (+) ");
			sqlStr.append("AND    D.CRM_CAMPAIGN_ID = C.CRM_CAMPAIGN_ID (+) ");
			sqlStr.append("AND    D.CRM_APPEAL_ID = A.CRM_APPEAL_ID (+) ");
			sqlStr.append("AND    D.CRM_ENABLED = 1 ");
			sqlStr.append("AND    D.CRM_DONATION_ID = ? ");
			sqlStr.append("AND    D.CRM_DONATION_SEQ = ? ");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { donationID, donationSeq });
			if (record.size() > 0) {
				// assign value from database
				ReportableListObject row = (ReportableListObject) record.get(0);
				donorName = row.getValue(0) + ", " + row.getValue(1);
				donorID = row.getValue(2);
				fiscalYear = row.getValue(3);
				fundID = row.getValue(4);
				fundDesc = row.getValue(5);
				appealID = row.getValue(6);
				appealDesc = row.getValue(7);
				campaignID = row.getValue(8);
				campaignDesc = row.getValue(9);
				pledgeDate = row.getValue(10);
				status = row.getValue(11);
				pledgedAmount = row.getValue(12);
				receivedAmount = row.getValue(13);
				remarks = row.getValue(14);
			}
		} else {
%>
<jsp:forward page="donation_list.jsp"/>
<%
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
	title = "function.pledge." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="2" />
</jsp:include>
<form name="form1" action="donation_detail.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.fiscalYear" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="fiscalYear" value="<%=fiscalYear==null?"":fiscalYear %>" maxlength="4" size="4">
<%	} else { %>
			<%=fiscalYear==null?"":fiscalYear %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.fund" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="fundID">
<jsp:include page="../ui/fundIDCMB.jsp" flush="false">
	<jsp:param name="fundID" value="<%=fundID %>" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select>
<%	} else { %>
			<%=fundDesc==null?"":fundDesc %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.appeal" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="appealID">
<jsp:include page="../ui/appealIDCMB.jsp" flush="false">
	<jsp:param name="appealID" value="<%=appealID %>" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select>
<%	} else { %>
			<%=appealDesc==null?"":appealDesc %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.campaign" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="campaignID">
<jsp:include page="../ui/campaignIDCMB.jsp" flush="false">
	<jsp:param name="campaignID" value="<%=campaignID %>" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select>
<%	} else { %>
			<%=campaignDesc==null?"":campaignDesc %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="date" />
	<jsp:param name="date" value="<%=pledgeDate %>" />
	<jsp:param name="showTime" value="N" />
</jsp:include>
<%	} else { %>
			<%=pledgeDate==null?"":pledgeDate %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="status">
				<option value="a"<%="a".equals(status)?" selected":"" %>><bean:message key="label.appeal" /></option>
				<option value="p"<%="p".equals(status)?" selected":"" %>><bean:message key="label.pledged" /></option>
				<option value="pp"<%="pp".equals(status)?" selected":"" %>><bean:message key="label.partialPayment" /></option>
				<option value="fp"<%="fp".equals(status)?" selected":"" %>><bean:message key="label.fullPayment" /></option>
			</select>
<%	} else {
				if ("a".equals(status)) {
					out.println("Appeal");
				} else if ("p".equals(status)) {
					out.println("Pledged");
				} else if ("pp".equals(status)) {
					out.println("Partial Payment");
				} else if ("fp".equals(status)) {
					out.println("Full Payment");
				}
		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.donor" /></td>
		<td class="infoData" width="85%" colspan="3">
<%	if (createAction || updateAction) { %>
			<select name="donorID">
<jsp:include page="../ui/clientIDCMB.jsp" flush="false">
	<jsp:param name="clientID" value="<%=donorID %>" />
</jsp:include>
			</select>
<%	} else { %>
			<%=donorName==null?"":donorName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.pledged" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="pledgedAmount" value="<%=pledgedAmount==null?"":pledgedAmount %>" maxlength="10" size="25">
<%	} else { %>
			<%=pledgedAmount==null?"":pledgedAmount %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.received" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="receivedAmount" value="<%=receivedAmount==null?"":receivedAmount %>" maxlength="10" size="25">
<%	} else { %>
			<%=receivedAmount==null?"":receivedAmount %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.remarks" /></td>
		<td class="infoData" width="85%" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="remarks" value="<%=remarks==null?"":remarks %>" maxlength="30" size="25">
<%	} else { %>
			<%=remarks==null||remarks.length()==0?"N/A":remarks %>
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
<%	} else {%>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.pledge.update" /></button>
			<button class="btn-delete"><bean:message key="function.pledge.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="donationID" value="<%=donationID %>">
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (isNaN(document.form1.pledgedAmount.value)) {
				alert("<bean:message key="error.pledge.required" />.");
				document.form1.pledgedAmount.focus();
				return false;
			} else if (isNaN(document.form1.receivedAmount.value)) {
				alert("<bean:message key="error.receive.required" />.");
				document.form1.receivedAmount.focus();
				return false;
			}
		}

		if (document.form1.pledgedAmount.value == "") {
			document.form1.pledgedAmount.value = "0";
		} else if (document.form1.receivedAmount.value == "") {
			document.form1.receivedAmount.value = "0";
		}
<%	} %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
</script>
<a class="button" href="<html:rewrite page="/crm/donation.jsp" />?donationID=<%=donationID %>" onclick="this.blur();"><span><bean:message key="prompt.backTo" /> <bean:message key="function.donation.list" /></span></a>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>