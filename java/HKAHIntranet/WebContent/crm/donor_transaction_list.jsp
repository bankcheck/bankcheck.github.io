<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>

<%!
	private ArrayList fetchRelative(String clientID, String sortBy, String ordering) {
		// fetch relative
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT D.CRM_DONATION_ID, D.CRM_CLIENT_ID, D.CRM_LASTNAME, D.CRM_FIRSTNAME, D.CRM_CHINESENAME,TO_CHAR(D.CRM_DONATION_DATE, 'DD/MM/YYYY') CRM_DONATION_DATE, D.CRM_STATUS, D.CRM_PLEDGED_AMOUNT, ");
		sqlStr.append("D.CRM_DONATION_METHOD, D.CRM_CREDITCARD_TYPE, D.CRM_CREDITCARD_NUMBER,TO_CHAR(CRM_CREDITCARD_EXPIREDATE, 'MM/YYYY') CRM_CREDITCARD_EXPIREDATE, D.CRM_CREDITCARD_HOLDERNAME, ");
		sqlStr.append("D.CRM_CHEQUE_NUMBER, D.CRM_BANKIN_ACCOUNT, D.CRM_RECEIPT_ID, ");
		sqlStr.append("D.CRM_CREATED_USER, D.CRM_MODIFIED_USER, D.CRM_ENABLED , TO_CHAR(R.CRM_PRINT_DATE, 'DD/MM/YYYY') CRM_PRINT_DATE  ");
		sqlStr.append("FROM (SELECT * ");
		sqlStr.append("      FROM CRM_CLIENTS_DONATION T ");
		sqlStr.append("      WHERE T.CRM_CLIENT_ID = '"+clientID+"' ");
		sqlStr.append("      AND    T.CRM_STATUS NOT LIKE ('client_info') ) D ");
		sqlStr.append("LEFT JOIN CRM_CLIENTS_DONATION_RECEIPT R ");
		sqlStr.append("ON D.CRM_RECEIPT_ID = R.CRM_RECEIPT_ID ");
		
		sqlStr.append("ORDER BY  ");
		
		if (ConstantsVariable.ZERO_VALUE.equals(sortBy)) {			
			sqlStr.append("D.CRM_DONATION_DATE ");
		} else if (ConstantsVariable.ONE_VALUE.equals(sortBy)) {			
			sqlStr.append("D.CRM_PLEDGED_AMOUNT ");
		} else {
			sqlStr.append("D.CRM_DONATION_DATE ");
		}

		if (ordering != null) {
			sqlStr.append(ConstantsVariable.SPACE_VALUE);
			sqlStr.append(ordering);
		} else {
			sqlStr.append(ConstantsVariable.SPACE_VALUE);
			sqlStr.append(" DESC");
		}
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getClientInfo(String clientID) {
		StringBuffer sqlStr = new StringBuffer();
	
		sqlStr.append("SELECT CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME,  CRM_CHINESENAME, CRM_STREET1, ");
		sqlStr.append("       CRM_STREET2, CRM_STREET3, CRM_STREET4, ");
		sqlStr.append("       CRM_HOME_NUMBER,CRM_MOBILE_NUMBER, CRM_FAX_NUMBER,  CRM_EMAIL, CRM_PHOTO_NAME, ");
		sqlStr.append("       CRM_ORGANIZATION, CRM_SALUTATION, ");
		sqlStr.append("       CRM_DESCRIPTION,CRM_DONOR,  CRM_CREATED_USER, CRM_CREATED_SITE_CODE, ");
		sqlStr.append("       CRM_CREATED_DEPARTMENT_CODE, CRM_MODIFIED_USER ");	
		sqlStr.append("FROM   CRM_CLIENTS ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = '"+clientID+"' ");	
		sqlStr.append("AND    CRM_DONOR = 'Y' ");
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getDonorDonationReceipt(String receiptID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT R.CRM_RECEIPT_ID, TO_CHAR(R.CRM_RECEIPT_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append("R.CRM_RECEIPT_AMOUNT, D.CRM_DONATION_METHOD, ");
		sqlStr.append("DECODE(D.CRM_ITEM,'medical','Medical Fund','healthLifestyle','Health Lifestyle Fund','development','Development Fund'), ");
		sqlStr.append("CONCAT(C.CRM_LASTNAME, (' '||C.CRM_FIRSTNAME)), ");
		sqlStr.append("C.CRM_STREET1, C.CRM_STREET2, C.CRM_STREET3, C.CRM_STREET4, ");
		sqlStr.append("C.CRM_CHINESENAME, CRM_ORGANIZATION ");
		sqlStr.append("FROM  CRM_CLIENTS_DONATION_RECEIPT R , CRM_CLIENTS C, CRM_CLIENTS_DONATION D ");
		sqlStr.append("WHERE R.CRM_RECEIPT_ID IN ( " + receiptID + " ) ");
		sqlStr.append("AND R.CRM_CLIENT_ID = C.CRM_CLIENT_ID ");
		sqlStr.append("AND D.CRM_RECEIPT_ID = R.CRM_RECEIPT_ID ");
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getDonorDonationHospitalReceipt(String donationID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT R.CRM_RECEIPT_ID, TO_CHAR(R.CRM_RECEIPT_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append("R.CRM_RECEIPT_AMOUNT, C.CRM_LASTNAME || ',' || C.CRM_FIRSTNAME, ");
		sqlStr.append("C.CRM_STREET1, C.CRM_STREET2, C.CRM_STREET3, C.CRM_STREET4, ");
		sqlStr.append("C.CRM_CHINESENAME, CRM_ORGANIZATION, ");
		sqlStr.append("DECODE(D.CRM_ITEM,'medical','Medical Fund','healthLifestyle','Health Lifestyle Fund','development','Development Fund') ");
		sqlStr.append("FROM  CRM_CLIENTS_DONATION_RECEIPT R , CRM_CLIENTS C, CRM_CLIENTS_DONATION D ");
		sqlStr.append("WHERE R.CRM_DONATION_ID = '"+donationID+"' ");
		sqlStr.append("AND R.CRM_CLIENT_ID = C.CRM_CLIENT_ID ");
		sqlStr.append("AND D.CRM_RECEIPT_ID = R.CRM_RECEIPT_ID ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean updatePrintReceiptDate(UserBean userBean, String donationID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE CRM_CLIENTS_DONATION_RECEIPT ");
		sqlStr.append("SET    CRM_PRINT_DATE = SYSDATE, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_DONATION_ID = '"+donationID+"' ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	private static String getReceiptID(String donationID){
		StringBuffer sqlStr = new StringBuffer();
		String receiptID = "";
		
		sqlStr.append("SELECT CRM_RECEIPT_ID ");
		sqlStr.append("FROM CRM_CLIENTS_DONATION ");
		sqlStr.append("WHERE CRM_DONATION_ID = '"+donationID+"' ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		if(record.size() > 0){
			ReportableListObject reportableListObject = (ReportableListObject) record.get(0);
			receiptID = reportableListObject.getValue(0);
		}
		
		return receiptID;
	}
	
	private static String getFundType(String receiptID){
		StringBuffer sqlStr = new StringBuffer();
		String fundType = "";
		
		sqlStr.append("SELECT CRM_RECEIPT_ITEM ");
		sqlStr.append("FROM CRM_CLIENTS_DONATION_RECEIPT ");
		sqlStr.append("WHERE CRM_RECEIPT_ID = '"+receiptID+"' ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		if(record.size() > 0){
			ReportableListObject reportableListObject = (ReportableListObject) record.get(0);
			fundType = reportableListObject.getValue(0);
		}
		
		return fundType;
	}
	
	public static boolean delete(UserBean userBean, String donationID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE CRM_CLIENTS_DONATION  ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_DONATION_ID = '"+donationID+"' ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean deleteReceipt(UserBean userBean, String receiptID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE CRM_CLIENTS_DONATION_RECEIPT ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_RECEIPT_ID = '"+receiptID+"' ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);
String clientID =  ParserUtil.getParameter(request, "clientID");

String command = ParserUtil.getParameter(request, "command");
String sortBy = request.getParameter("sortBy");
String ordering =  ParserUtil.getParameter(request, "ordering");
String donationID = ParserUtil.getParameter(request, "donationID");
String receiptID = ParserUtil.getParameter(request, "receiptID");
String fundType = "";
if (sortBy == null) {
	sortBy = ConstantsVariable.EMPTY_VALUE;
}

if ("cancel".equals(command)) {
	if (delete(userBean, donationID)) {
		receiptID = getReceiptID(donationID);
		deleteReceipt(userBean,receiptID);
	}
}
	request.setAttribute("relative_list", fetchRelative(clientID ,sortBy ,ordering));

String message = "";
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

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper style="width:100%">
<div id=mainFrame style="width:100%">
<div id=contentFrame style="width:100%">
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.donor.transaction.list" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel">Client donation list</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>

<%
	ArrayList clientRecord = getClientInfo(clientID);

	if(clientRecord.size() != 0){	
		ReportableListObject clientRow = (ReportableListObject)clientRecord.get(0);	
%>
<table cellpadding="0" width="100%" cellspacing="5"	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="16%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(1)%></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(2)%></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(3)%></td>
	</tr>	
</table>		
<%
	}
%>

<form name="search_form" action="donor_transaction_list.jsp" method="post">
<table style="width:100%" cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Donation List</td>
	</tr>		
	<tr class="smallText">
		<td class="infoLabel" width="30%">Sort By</td>
		<td class="infoData" width="70%">
			<select name="sortBy">
				<option value="0"<%="0".equals(sortBy)?" selected":"" %>>Donation Date</option>
				<option value="1"<%="1".equals(sortBy)?" selected":"" %>>Amount</option>				
			</select>
			<select name="ordering">
				<option <%="DESC".equals(ordering)?" selected":"" %> value="DESC">Decending</option>
				<option <%="ASC".equals(ordering)?" selected":"" %> value="ASC">Ascending</option>
			</select>
		</td>
	</tr>
	
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="clientID" value="<%=clientID %>"/>

</form>
<form name="form1" action="donor_transaction_list.jsp" method="post" style="width:100%">
<display:table style="width:100%" id="row" name="requestScope.relative_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Donation ID" style="width:10%; text-align:right;" />
	<display:column property="fields15" title="Receipt ID" style="width:10%; text-align:right;" />
	<display:column property="fields6" title="Type" style="width:10%; text-align:right;" />
	<display:column property="fields7" title="Amount ($)" style="width:10%; text-align:right;" />
	<display:column property="fields8" title="Method" style="width:10%; text-align:right;" />
	<display:column property="fields5" title="Donation Date" style="width:15%; text-align:right;" />
	<display:column title="Print Receipt" style="width:10%; text-align:center;" >
		<c:if test="${not empty row.fields19 }"><c:out value="${row.fields19 }"/></c:if>
		<c:if test="${empty row.fields19 && row.fields18 == '1' && not empty row.fields15 }">
			<button onclick="return printReceipt('pdfAction', '<c:out value="${row.fields0}"/>', '<c:out value="${row.fields15}"/>');">Print</button>
		</c:if>
		<c:if test="${row.fields18 == '0'}">(Void)</c:if>
		<c:if test="${empty row.fields15 && row.fields18 == '1'}">No Receipt</c:if>
	</display:column>
	<display:column titleKey="button.view" media="html" style="width:20%; text-align:center;">
			<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields15}"/>');" >Info</button>
			<button onclick="return deleteAction('cancel', '<c:out value="${row.fields0}" />', '');" <c:if test="${row.fields18 == '0'}">disabled</c:if> >Void</button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>

<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button type="button" onclick="return submitAction('create', '');">Create Donation</button>
		</td>
	</tr>
</table>


<input type="hidden" name="command" value="<%=command %>" />
<input type="hidden" name="clientID" value="<%=clientID %>" />
<input type="hidden" name="donationID" value="<%=donationID %>" />
<input type="hidden" name="receiptID" value="<%=receiptID %>" />
</form>

<script language="javascript">
	function deleteAction(cmd, cid, rn){
		  var deleteRecord = confirm("Delete record ?");
		   if( deleteRecord == true ){
			   submitAction(cmd, cid, rn);
		   }
	}

	function submitAction(cmd, cid, rn) {	
		if(cmd == "view" || cmd == "create"){
			document.form1.action = "donor_transaction.jsp";
		}
		document.form1.command.value = cmd;		
		document.form1.donationID.value = cid;
		document.form1.receiptID.value = rn;
		document.form1.submit();
	}
	
	function printReceipt(cmd, donationID, receiptID){
		var w = 1100;
		var h = 900;
		var t = 0;
		var l = 0;
		var props = "channelmode=no,directories=no,fullscreen=no,location=no,menubar=no,resizable=yes,";
		props += "scrollbars=yes,status=no,titlebar=no,toolbar=no,";
		props += "top=" + t + ",left=" + l + ",height=" + h + ",width=" + w;

		win = window.open("", "_blank", props, false);
		win.location.href = "print_donation_receipt.jsp?donationID="+donationID+"&receiptID="+receiptID;
		document.form1.submit();
	}
	
</script>
</div>
</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>