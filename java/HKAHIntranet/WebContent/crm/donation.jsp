<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchDonation(String donationID) {
		// fetch donation
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.CRM_DONATION_SEQ, D.CRM_FISCAL_YEAR, F.CRM_FUND_DESC, C.CRM_CAMPAIGN_DESC, ");
		sqlStr.append("       A.CRM_APPEAL_DESC, CL.CRM_LASTNAME, CL.CRM_FIRSTNAME, D.CRM_STATUS, ");
		sqlStr.append("       D.CRM_PLEDGED_AMOUNT, D.CRM_RECEIVED_AMOUNT ");
		sqlStr.append("FROM   CRM_CLIENTS_DONATION_DETAIL D, CRM_CLIENTS CL, ");
		sqlStr.append("       CRM_APPEALS A, CRM_FUNDS F, CRM_CAMPAIGNS C ");
		sqlStr.append("WHERE  D.CRM_CLIENT_ID = CL.CRM_CLIENT_ID ");
		sqlStr.append("AND    D.CRM_FUND_ID = F.CRM_FUND_ID (+) ");
		sqlStr.append("AND    D.CRM_CAMPAIGN_ID = C.CRM_CAMPAIGN_ID (+) ");
		sqlStr.append("AND    D.CRM_APPEAL_ID = A.CRM_APPEAL_ID (+) ");
		sqlStr.append("AND    D.CRM_ENABLED = 1 ");
		sqlStr.append("AND    D.CRM_DONATION_ID = '");
		sqlStr.append(donationID);
		sqlStr.append("' ");
		sqlStr.append("ORDER BY D.CRM_DONATION_SEQ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);

String donationID = request.getParameter("donationID");

ArrayList record = fetchDonation(donationID);
float pledged = 0;
float received = 0;
float balance = 0;
int count = record.size();
try {
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			pledged += NumericUtil.parseFloat(row.getValue(8));
			received += NumericUtil.parseFloat(row.getValue(9));
		}
	}
	balance = received - pledged;
} catch (Exception e) {}
request.setAttribute("donation_list", record);

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.donation.list" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="2" />
</jsp:include>
<bean:define id="functionLabel"><bean:message key="function.donation.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="donation_detail.jsp" method="post">
<display:table id="row" name="requestScope.donation_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" titleKey="prompt.fiscalYear" class="smallText" style="width:10%" />
	<display:column property="fields2" titleKey="prompt.fund" class="smallText" style="width:10%" />
	<display:column property="fields3" titleKey="prompt.campaign" class="smallText" style="width:10%" />
	<display:column property="fields4" titleKey="prompt.appeal" class="smallText" style="width:10%" />
	<display:column titleKey="prompt.donor" class="smallText" style="width:10%">
		<c:out value="${row.fields5}" />, <c:out value="${row.fields6}" />
	</display:column>
	<display:column titleKey="prompt.status" class="smallText" style="width:10%">
		<logic:equal name="row" property="fields7" value="a">
			<bean:message key="label.appeal" />
		</logic:equal>
		<logic:equal name="row" property="fields7" value="p">
			<bean:message key="label.pledged" />
		</logic:equal>
		<logic:equal name="row" property="fields7" value="pp">
			<bean:message key="label.partialPayment" />
		</logic:equal>
		<logic:equal name="row" property="fields7" value="fp">
			<bean:message key="label.fullPayment" />
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.pledged" class="smallText" style="width:10%;text-align:right">
		$<c:out value="${row.fields8}" />
	</display:column>
	<display:column titleKey="prompt.received" class="smallText" style="width:10%;text-align:right">
		$<c:out value="${row.fields9}" />
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr>
		<td width="10%" align="right">Count</td>
		<td width="10%" align="center"><%=count %></td>
		<td width="40%">&nbsp;</td>
		<td width="10%" align="right">Total</td>
		<td width="10%" align="right">$<%=pledged %></td>
		<td width="10%" align="right">$<%=received %></td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td align="right" colspan="4"><bean:message key="prompt.balance" /></td>
		<td>&nbsp;</td>
		<td align="right">$<%=balance %></td>
		<td>&nbsp;</td>
	</tr>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.pledge.create" /></button></td>
	</tr>
</table>
<input type="hidden" name="command">
<input type="hidden" name="donationID" value="<%=donationID %>">
<input type="hidden" name="donationSeq">
</form>
<script language="javascript">
	function submitAction(cmd, sid) {
		document.form1.command.value = cmd;
		document.form1.donationSeq.value = sid;
		document.form1.submit();
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>