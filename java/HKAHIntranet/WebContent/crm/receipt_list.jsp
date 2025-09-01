<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%!
public static ArrayList getReceiptList(String type, String receiptIdFrom, String receiptIdTo) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT 	R.CRM_RECEIPT_ID, R.CRM_CLIENT_ID, R.CRM_DONATION_ID, ");
	sqlStr.append("CONCAT(C.CRM_LASTNAME, (' '||C.CRM_FIRSTNAME)), ");
	sqlStr.append("		R.CRM_RECEIPT_AMOUNT, TO_CHAR(R.CRM_RECEIPT_DATE, 'DD/MM/YYYY') ");
	sqlStr.append("FROM CRM_CLIENTS_DONATION_RECEIPT R , CRM_CLIENTS C ");
	sqlStr.append("WHERE C.CRM_CLIENT_ID = R.CRM_CLIENT_ID ");
	sqlStr.append("AND R.CRM_RECEIPT_ITEM = '" + type + "' ");
	sqlStr.append("AND R.CRM_RECEIPT_ID BETWEEN '" + receiptIdFrom + "' AND '");
	if(receiptIdTo != null && receiptIdTo.length() > 0){
		sqlStr.append( receiptIdTo + "' ");
	}else{
		sqlStr.append( receiptIdFrom + "' ");
	}
	sqlStr.append("AND R.CRM_ENABLED = 1 ");
	sqlStr.append("AND R.CRM_PRINT_DATE IS NULL ");

	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getDonorDonationReceipt(String type, String receiptIdFrom, String receiptIdTo) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT R.CRM_RECEIPT_ID, TO_CHAR(R.CRM_RECEIPT_DATE, 'DD/MM/YYYY'), ");
	sqlStr.append("R.CRM_RECEIPT_AMOUNT, D.CRM_DONATION_METHOD, ");
	sqlStr.append("F.CRM_FUND_DESC, ");
	sqlStr.append("CONCAT(R.CRM_RECEIPT_LASTNAME, (' '||R.CRM_RECEIPT_FIRSTNAME)), ");
	sqlStr.append("C.CRM_STREET1, C.CRM_STREET2, C.CRM_STREET3, C.CRM_STREET4, ");
	sqlStr.append("C.CRM_CHINESENAME, CRM_ORGANIZATION ");
	sqlStr.append("FROM CRM_CLIENTS_DONATION_RECEIPT R ");
	sqlStr.append("LEFT JOIN CRM_CLIENTS C ON R.CRM_CLIENT_ID = C.CRM_CLIENT_ID ");
	sqlStr.append("LEFT JOIN CRM_CLIENTS_DONATION D ON R.CRM_RECEIPT_ID = D.CRM_RECEIPT_ID ");
	sqlStr.append("LEFT JOIN CRM_FUNDS F ON D.CRM_FUND_ID = F.CRM_FUND_ID ");
	sqlStr.append("WHERE R.CRM_RECEIPT_ITEM = '" + type + "' ");
	sqlStr.append("AND R.CRM_RECEIPT_ID BETWEEN '" + receiptIdFrom + "' AND '");
	if(receiptIdTo != null && receiptIdTo.length() > 0){
		sqlStr.append( receiptIdTo + "' ");
	}else{
		sqlStr.append( receiptIdFrom + "' ");
	}
	sqlStr.append("AND R.CRM_ENABLED = 1 ");	
	sqlStr.append("AND R.CRM_PRINT_DATE IS NULL ");
	sqlStr.append("ORDER BY R.CRM_RECEIPT_ID ");	
	
	System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getDonorDonationHospitalReceipt(String type, String receiptIdFrom, String receiptIdTo) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT R.CRM_RECEIPT_ID, TO_CHAR(R.CRM_RECEIPT_DATE, 'DD/MM/YYYY'), ");
	sqlStr.append("R.CRM_RECEIPT_AMOUNT, C.CRM_LASTNAME || ',' || C.CRM_FIRSTNAME, ");
	sqlStr.append("C.CRM_STREET1, C.CRM_STREET2, C.CRM_STREET3, C.CRM_STREET4, ");
	sqlStr.append("C.CRM_CHINESENAME, CRM_ORGANIZATION, ");
	sqlStr.append("F.CRM_FUND_DESC ");
	sqlStr.append("FROM CRM_CLIENTS_DONATION_RECEIPT R ");
	sqlStr.append("LEFT JOIN CRM_CLIENTS C ON R.CRM_CLIENT_ID = C.CRM_CLIENT_ID ");
	sqlStr.append("LEFT JOIN CRM_CLIENTS_DONATION D ON R.CRM_RECEIPT_ID = D.CRM_RECEIPT_ID ");
	sqlStr.append("LEFT JOIN CRM_FUNDS F ON D.CRM_FUND_ID = F.CRM_FUND_ID ");
	sqlStr.append("WHERE R.CRM_RECEIPT_ITEM = '" + type + "' ");
	sqlStr.append("AND R.CRM_RECEIPT_ID BETWEEN '" + receiptIdFrom + "' AND '");
	if(receiptIdTo != null && receiptIdTo.length() > 0){
		sqlStr.append( receiptIdTo + "' ");
	}else{
		sqlStr.append( receiptIdFrom + "' ");
	}
	sqlStr.append("AND R.CRM_ENABLED = 1 ");	
	sqlStr.append("AND R.CRM_PRINT_DATE IS NULL ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean updatePrintReceiptDate(UserBean userBean, String type, String receiptIdFrom, String receiptIdTo) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CRM_CLIENTS_DONATION_RECEIPT ");
	sqlStr.append("SET    CRM_PRINT_DATE = SYSDATE, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
	sqlStr.append("WHERE  CRM_ENABLED = 1 ");
	sqlStr.append("AND CRM_RECEIPT_ITEM = '" + type + "' ");
	sqlStr.append("AND CRM_RECEIPT_ID BETWEEN '" + receiptIdFrom + "' AND '");
	if(receiptIdTo != null && receiptIdTo.length() > 0){
		sqlStr.append( receiptIdTo + "' ");
	}else{
		sqlStr.append( receiptIdFrom + "' ");
	}
	
	System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}


%>

<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String message = "";
String errorMessage = "";

String fundType = request.getParameter("fundType");
String receiptIdFrom = request.getParameter("receiptIdFrom");
String receiptIdTo = request.getParameter("receiptIdTo");
int noOfReceipt = 0;

if(command == null ){
	command = "create";
	receiptIdFrom = "";
	receiptIdTo = "";
}

boolean loginAction = false;
boolean createAction = false;
boolean searchAction = false;
boolean printAction = false;
boolean closeAction = false;

if ("login".equals(command) && userBean.isAdmin()) {
	loginAction = true;
} else if ("create".equals(command) || !userBean.isLogin()) {
	createAction = true;
} else if ("search".equals(command)) {
	searchAction = true;
} else if ("print".equals(command)) {
	printAction = true;
} else if ("close".equals(command)) {
	closeAction = true;
}
if(searchAction){
	ArrayList record = getReceiptList(fundType, receiptIdFrom, receiptIdTo);
	noOfReceipt = record.size();	
	
	request.setAttribute("receipt_list", getReceiptList(fundType, receiptIdFrom, receiptIdTo));
}
if(printAction){	
	/*//boolean success = updatePrintReceiptDate(userBean, fundType, receiptIdFrom, receiptIdTo);
	ArrayList record = getDonorDonationReceipt(fundType, receiptIdFrom, receiptIdTo);
	boolean success = updatePrintReceiptDate(userBean, fundType, receiptIdFrom, receiptIdTo);
	request.setAttribute("donationList", record);
*/
	if("foundation".equals(fundType)){
		ArrayList record = getDonorDonationReceipt(fundType, receiptIdFrom, receiptIdTo);
		request.setAttribute("donationList", record);
		boolean success = updatePrintReceiptDate(userBean, fundType, receiptIdFrom, receiptIdTo);

		if (record.size() > 0) {
			File reportFile = new File(application.getRealPath("/report/RPT_DONOR_RECEIPT_FOUNDATION.jasper"));
			File reportDir = new File(application.getRealPath("/report/"));

			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

				Map parameters = new HashMap();
				parameters.put("BaseDir", reportFile.getParentFile());		
						
				JasperPrint jasperPrint =
					JasperFillManager.fillReport(
						jasperReport,
						parameters,
						new ReportListDataSource(record) {
							public Object getFieldValue(int index) throws JRException {
								String value = (String) super.getFieldValue(index);								
								return value;
							}
						});
				
				
				String encodedFileName = "Foundation_Receipt(" + receiptIdFrom + "-" + receiptIdTo + ").pdf";
				request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
				OutputStream ouputStream = response.getOutputStream();
				response.setContentType("application/pdf");
				response.setHeader("Content-disposition","attachment; filename=\"" + encodedFileName + "\"");
				JRPdfExporter exporter = new JRPdfExporter();
		        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
		
		        exporter.exportReport();
		       
				return;
			}
		}
	}else if("hospital".equals(fundType)){
		ArrayList record = getDonorDonationHospitalReceipt(fundType, receiptIdFrom, receiptIdTo);
		request.setAttribute("donationList", record);
		boolean success = updatePrintReceiptDate(userBean, fundType, receiptIdFrom, receiptIdTo);
					
		if (record.size() > 0) {
			File reportFile = new File(application.getRealPath("/report/RPT_DONOR_RECEIPT.jasper"));
			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
				//System.out.println(reportFile.getParentFile());
				Map parameters = new HashMap();
				parameters.put("BaseDir", reportFile.getParentFile());		
				
				ReportableListObject row = (ReportableListObject)record.get(0);
				String displayName = "";
				String engName = row.getValue(3);
				String chiName = row.getValue(8);
				String organization = row.getValue(9);
				
				if(engName.equals(",")){					
					if(chiName != null && chiName.length() > 0){
						displayName = chiName;
					}else{
						displayName = organization;
					}					
				}else{
					if(chiName != null && chiName.length() > 0){
						displayName = engName + " / " + chiName;
					}else{
						displayName = engName;
					}
				}
				
				parameters.put("Name", displayName);
		
				JasperPrint jasperPrint =
					JasperFillManager.fillReport(
						jasperReport,
						parameters,
						new ReportListDataSource(record) {
							public Object getFieldValue(int index) throws JRException {
								String value = (String) super.getFieldValue(index);								
								return value;
							}
						});
				String encodedFileName = "Hospital_Receipt(" + receiptIdFrom + "-" + receiptIdTo + ").pdf";
				request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
				OutputStream ouputStream = response.getOutputStream();
				response.setContentType("application/pdf");
				response.setHeader("Content-disposition","attachment; filename=\"" + encodedFileName + "\"");
				JRPdfExporter exporter = new JRPdfExporter();
		        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
		
		        exporter.exportReport();
				return;
			}
		}
	}
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
<jsp:include page="../common/header.jsp" />
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.receipt.list" />
	<jsp:param name="category" value="group.crm" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="receipt_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Type:</td>
		<td class="infoData" width="70%">
			<select name="fundType">
				<option <%=((fundType!=null&&fundType.equals("hospital")) || createAction ?"selected":"") %> value="hospital">Hospital Donation Receipt</option>
				<option <%=((fundType!=null&&fundType.equals("foundation"))?"selected":"") %> value="foundation">Foundation Donation Receipt</option>		
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Receipt Number: </td>
		<td class="infoData" width="70%">
			<input type="text" id="receiptIdFrom" name="receiptIdFrom" value="<%=receiptIdFrom %>"/> to 
			<input type="text" id="receiptIdTo" name="receiptIdTo" value="<%=receiptIdTo %>"/>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
<input type="hidden" id="command" name="command" value="<%=command %>" />


</form>
<form name="form1" action="receipt_list.jsp" method="post">
<display:table id="row" name="requestScope.receipt_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Receipt ID" style="width:10%" />
	<display:column property="fields1" title="Client ID" style="width:10%" />
	<display:column property="fields2" title="Donation ID" style="width:10%" />
	<display:column property="fields3" title="Donor Name" style="width:20%" />
	<display:column property="fields4" title="Amount" style="width:10%" />
	<display:column property="fields5" title="Receipt Date" style="width:15%" />
</display:table>

<input type="hidden" name="fundType" value="<%=fundType %>" /> 
<input type="hidden" name="receiptIdFrom" value="<%=receiptIdFrom %>" />  
<input type="hidden" name="receiptIdTo" value="<%=receiptIdTo %>" />
<input type="hidden" name="noOfReceipt" value="<%=noOfReceipt %>" />
<input type="hidden" name="command" value="<%=command %>" />

<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('print');">Print</button></td>
	</tr>
</table>

</form>
<script language="javascript">
	function submitSearch() {
		if($("#receiptIdFrom").val().length === 0){
			alert("Please at least enter one receipt number.");
		}else{
			document.search_form.command.value = 'search';
			document.search_form.submit();	
		}
	}

	function clearSearch() {
		document.search_form.fundType.value = '';
		document.search_form.receiptIdFrom.value = '';
		document.search_form.receiptIdTo.value = '';
		document.search_form.command.value = null;
		document.search_form.submit();	
	}

	function submitAction(cmd) {
		if(<%=noOfReceipt%> <= 0 ){
			alert("No record found.");
		}else{
			document.form1.command.value = cmd;
			document.form1.submit();
		}
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>