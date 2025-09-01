<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%
UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
String sortBy = request.getParameter("sortBy");
if (sortBy == null) {
	sortBy = "DOCNAME";
}
String ordering = request.getParameter("ordering");
if(ordering == null) {
	ordering = "ASC";
}

String reportMth1 = request.getParameter("month_from");
String admDateTo = request.getParameter("date_to");

String site = request.getParameter("site");
String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
File reportFile = null;
SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMddHHmmss");
String reportMth = null;

if(reportMth1!=null){
	SimpleDateFormat myformatter = new SimpleDateFormat("MMMM yyyy", Locale.US);
	SimpleDateFormat dmyformatter = new SimpleDateFormat("yyyyMMdd");
	Date admdate = dmyformatter.parse(reportMth1+"01");
	reportMth = myformatter.format(admdate);	
}

if("view".equals(command)){
	ArrayList preBookRecord = PatientDB.getPatientBookingReport(reportMth1);

	if(preBookRecord.size()>0){
		reportFile = new File(application.getRealPath("/report/RPT_PAT_BOOK_MTH.jasper"));
		ReportListDataSource report = null;

		if (reportFile != null && reportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
			
			Map parameters = new HashMap();
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("DateFrom", reportMth1);
			parameters.put("Site", site);
			parameters.put("reportMth",reportMth);
			
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport,
					parameters,
					new ReportMapDataSource(preBookRecord, new String[]{"WRDCODE","TIME_SLOT","COL1","COL2","COL3",
																		"COL4","COL5","COL6","COL7","COL8","COL9",
																		"COL10","COL11","COL12","COL13","COL14",
																		"COL15","COL16","COL17","COL18","COL19",
																		"COL20","COL21","COL22","COL23","COL24","COL25",
																		"COL26","COL27","COL28","COL29","COL30","COL31"}
																		,null));	
					
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/vnd.ms-excel");
			JRXlsExporter exporterXLS = new JRXlsExporter();
			response.setHeader("Content-Disposition", "attachment;filename=PatientBookingReport_" + tsFormat.format(new Date()) + ".xls");
			exporterXLS.setParameter(JRXlsExporterParameter.JASPER_PRINT, jasperPrint);
			exporterXLS.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, ouputStream);
			exporterXLS.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
			exporterXLS.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, false);
			exporterXLS.setParameter(JRXlsExporterParameter.IS_AUTO_DETECT_CELL_TYPE, true);
			exporterXLS.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, false);
			exporterXLS.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, true);
			
			exporterXLS.exportReport();
			ouputStream.flush();
			ouputStream.close();		
			return;			
			
			
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

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<body>
		<div id=indexWrapper>
			<div id=mainFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.patBook.report" />
					<jsp:param name="category" value="group.report" />
				</jsp:include>
				
				<font color="blue"><%=message %></font>
				<font color="red"><%=errorMessage %></font>
				
				<form name="searchPbForm" action="rptPatBookMth.jsp" method="get">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.reportMth" />
							</td>
							<td class="infoData" width="25%">
								<input type="textfield" name="month_from" id="month_from"  value="<%=reportMth1==null?"":reportMth1 %>" maxlength="6" size="10" />&nbsp;(YYYYMM)
							</td>
							<td width="20%">
								<button onclick="return submitReport('view');"><bean:message key="button.doc.view" /></button>
								<input type="hidden" name="command" />
							</td>							
						</tr>						
					</table>
				</form>
				
				<bean:define id="functionLabel">
					<bean:message key="function.pbList.title" />
				</bean:define>
				<bean:define id="notFoundMsg">
					<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
				</bean:define>
						
				<script language="javascript">				
					function submitReport(cmd) {
						//callPopUpWindow("../callBack/callBackRpt.jsp");
						
						var yearMth = document.searchPbForm.month_from.value;
						if(yearMth.length!=6){
							document.searchPbForm.month_from.focus();
							return false;							
						}else{
							var year = yearMth.substr(0, 4);
							var month = yearMth.substr(4, 2);
							
							if(year<1900&&year>9999){
								alert('Please enter valid year');
								document.searchPbForm.month_from.focus();
								return false;								
							}
							if(month=='01'||month=='02'||month=='03'||month=='04'||month=='05'||month=='06'||
									month=='07'||month=='08'||month=='09'||month=='10'||month=='11'||month=='12'){
								document.searchPbForm.command.value = cmd;
								document.searchPbForm.submit();												
							}else{
								alert('Please enter valid month');
								document.searchPbForm.month_from.focus();
								return false;
							}
						}
					}
				
					function clearSearch() {
						document.searchPbForm.date_from.value="";
						document.searchPbForm.date_to.value="";
					}				
				</script>
			</div>
		</div>
		
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>