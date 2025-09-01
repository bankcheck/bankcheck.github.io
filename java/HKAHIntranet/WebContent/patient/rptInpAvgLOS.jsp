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
String reportType = request.getParameter("reportType");

String reportYear = request.getParameter("date_yy");
String reportMth = request.getParameter("date_mm");
String reportMthStr = request.getParameter("monthStr");
String reportDate = request.getParameter("reportDate");
String site = request.getParameter("site");
String message = request.getParameter("message");
String errorMessage = "";
File reportFile = null;
String reportDateTitle = null;
SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMddHHmmss");

if (site == null) {
	if ( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
		site = "Hong Kong Adventist Hospital - Stubbs Road";
	} else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())) {
		site = "Hong Kong Adventist Hospital - Tsuen Wan";
	}
}

if (reportDate == null){
	reportDate = "01" + "/" + reportMth + "/" + reportYear;
	reportDateTitle = reportMthStr + " " + reportYear;
} else {
	reportDateTitle = reportDate.substring(3, 10);
}
if (reportDate.length() == 10){
	reportDate += " 00:00:00";
}

if (message == null) {
	message = "";
}

if("view".equals(command)){
	ArrayList list = null;
	String jasperName = null;
	String[] fieldNames = null;
	String outFileName = null;
	if ("detail".equals(reportType)) {
		list = PatientDB.getInpAvgLOSDetail(reportDate);
		jasperName = "rptInpAvgLOS_SubDetail.jasper";
		fieldNames = new String[]{"WARD","PATNO","REGID","ADM_DATE","DISCH_DATE","LOS","BEDCODE","REGSTS"};
		outFileName = "InpAvgLOSReport_Detail";
	} else {
		list = PatientDB.getInpAvgLOS(reportDate);
		jasperName = "rptInpAvgLOS.jasper";
		fieldNames = new String[]{"WARD","TOT_NUM_DISCH","TOT_LOS","AVG_LOS"};
		outFileName = "InpAvgLOSReport";
	}
	System.out.println(" list size="+list.size());
	
	if(list.size()>0){
		reportFile = new File(application.getRealPath("/report/" + jasperName));
		ReportListDataSource report = null;

		if (reportFile != null && reportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
			
			Map parameters = new HashMap();
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("Site", site);
			parameters.put("DATERANGE", reportDateTitle);
			parameters.put("DateStr",reportDate);
			
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport,
					parameters,
					new ReportMapDataSource(list, fieldNames, null));
			
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/vnd.ms-excel");
			JRXlsExporter exporterXLS = new JRXlsExporter();
			response.setHeader("Content-Disposition", "attachment;filename=" + outFileName + "_" + tsFormat.format(new Date()) + ".xls");
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
	} else {
		message = "No records found.";
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
					<jsp:param name="pageTitle" value="function.inpAvgLOS.report" />
					<jsp:param name="category" value="group.report" />
				</jsp:include>
				
				<font color="blue"><%=message %></font>
				<font color="red"><%=errorMessage %></font>
				
				<form name="searchPbForm" action="rptInpAvgLOS.jsp" method="get">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.reportMth" />
							</td>
							<td class="infoData" width="25%">
								<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
									<jsp:param name="label" value="date" />
									<jsp:param name="day_mm" value="<%=reportMth %>" />
									<jsp:param name="monthOnly" value="Y" />
									<jsp:param name="defaultValue" value="Y" />
								</jsp:include>
							</td>
							<td width="20%">
								<button onclick="return submitReport('view');"><bean:message key="button.doc.view" /></button>
								<button onclick="return submitReport('view', 'detail');">View detail list (DEV only)</button>
								<input type="hidden" name="monthStr" />
								<input type="hidden" name="command" />
								<input type="hidden" name="reportType" />
							</td>							
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.reportYear" />
							</td>
							<td class="infoData" width="25%">
								<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
									<jsp:param name="label" value="date" />
									<jsp:param name="day_yy" value="<%=reportYear %>" />
									<jsp:param name="yearRange" value="10" />
									<jsp:param name="hideFutureYear" value="Y" />
									<jsp:param name="isYearOnly" value="Y" />
									<jsp:param name="defaultValue" value="Y" />
								</jsp:include>
							</td>
						</tr>
						<tr>
							<td colspan="3">
							Note: The figures did not cater ward transfer. It counts the number based on the ward that the patient last stayed.
							</td>
						</tr>
					</table>
				</form>
				
				<bean:define id="functionLabel">
					<bean:message key="function.inpAvgLOS.report" />
				</bean:define>
				<bean:define id="notFoundMsg">
					<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
				</bean:define>
									
				<script language="javascript">				
					function submitReport(cmd, type) {
						var year = document.searchPbForm.date_yy.value;
						var month = document.searchPbForm.date_mm.value;
						var monthObj = document.searchPbForm.date_mm;
						var monthStr = monthObj.options[monthObj.selectedIndex].text;
						
						if(year<1900&&year>9999){
							alert('Please enter valid year');
							document.searchPbForm.date_mm.focus();
							return false;								
						}
						if(!(month=='01'||month=='02'||month=='03'||month=='04'||month=='05'||month=='06'||
								month=='07'||month=='08'||month=='09'||month=='10'||month=='11'||month=='12')){
							alert('Please enter valid month');
							document.searchPbForm.date_mm.focus();
							return false;
						}
						
						document.searchPbForm.monthStr.value = monthStr;
						document.searchPbForm.command.value = cmd;
						document.searchPbForm.reportType.value = type;
						document.searchPbForm.submit();
						return false;
					}
				
					function clearSearch() {
					}				
				</script>
			</div>
		</div>
		
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>