<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
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
String dischargeDateFrom = request.getParameter("dischargeDateFrom");
String dischargeDateTo = request.getParameter("dischargeDateTo");

String site = ConstantsServerSide.SITE_CODE.toLowerCase();
String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
File reportFile = null;

SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMddHHmmss");

if("view".equals(command)){
	ArrayList list = PatientDB.getPatientChargeSummaryReport(site, dischargeDateFrom, dischargeDateTo);
	
	/*
	// debug
	for (int i = 0; i < list.size(); i++) {
		ReportableListObject row = (ReportableListObject) list.get(i);
		System.out.print("row " + i + " - ");
		for (int j = 0; j < 24; j++) {
			String doccode = row.getValue(0);
			String patno = row.getValue(9);
			String total = row.getValue(17);
			
			String val = row.getValue(j);
			
			//System.out.println("row:" + i + ", doccode["+doccode+"] patno[" + patno + "] total[" + total + "]");
			System.out.print(j + ":["+val+"]");
		}
		System.out.println();
	}
	*/

	reportFile = new File(application.getRealPath("/report/RPT_PAT_CHARGE_SUMMARY.jasper"));
	ReportListDataSource report = null;

	if (reportFile != null && reportFile.exists()) {
		String siteDesc = "hkah";
		if(ConstantsServerSide.isHKAH()){
			siteDesc = "hkah-sr";
		} else if(ConstantsServerSide.isTWAH()){
			siteDesc = "hkah-tw";
		}
		String fileName = "patient_charge_summary_" + siteDesc + "_" + 
			(dischargeDateFrom == null ? "" : dischargeDateFrom.replaceAll("/", "")) + "_" + 
			(dischargeDateTo == null ? "" : dischargeDateTo.replaceAll("/", "")) + ".pdf";
		
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("in_stecode", site);
		parameters.put("in_datefrom", dischargeDateFrom);
		parameters.put("in_dateto", dischargeDateTo);
		
		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportMapDataSource(list, new String[]{
					"DOCCODE",
					"DOCCODE_SLIP",
					"DOCFNAME",
					"DOCGNAME",
					"REGTYPE",
					"SDSCODE",
					"SDSDESC",
					"ACMNAME",
					"LOS",
					"DISCH_DATE",
					"PATNO",
					"PATFNAME",
					"PATGNAME",
					"DR_FEE",
					"OTHER_DR",
					"OTHER_DR_FEE",
					"HAS_ANES_ITEM",
					"HOSP_FEE",
					"TOTAL",
					"TITLE",
					"ADD1",
					"ADD2",
					"ADD3",
					"ADD4"
				},
				null));	
				
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		JRPdfExporter exporter = new JRPdfExporter();
		response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
		
		exporter.exportReport();
		//return;	
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
<style>
.remark {
	padding: 5px;
	background: #f9edbe;
	border: 1px solid #f0c36d;
	border-radius: 2px;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}
</style>
	<jsp:include page="../common/header.jsp"/>
	<body>
		<div id=indexWrapper>
			<div id=mainFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.rptPatientChargeSummary.report" />
					<jsp:param name="category" value="group.report" />
				</jsp:include>
				
				<font color="blue"><%=message %></font>
				<font color="red"><%=errorMessage %></font>
				<div class="remark">
					It may take several minutes to generate a report for one-month period. 
				</div>
				<form name="rptPatientChargeSummaryForm" action="rptPatientChargeSummary.jsp" method="get">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								Discharge Date
							</td>
							<td class="infoData" width="35%">
								From 
								<input type="textfield" name="dischargeDateFrom" id="dischargeDateFrom" 
									class="datepickerfield" value="<%=dischargeDateFrom==null?"":dischargeDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								to 
								<input type="textfield" name="dischargeDateTo" id="dischargeDateTo" 
									class="datepickerfield" value="<%=dischargeDateTo==null?"":dischargeDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>							
							<td width="20%">
								<button onclick="return submitReport('view');"><bean:message key="button.doc.view" /></button>
								<input type="hidden" name="command" />
							</td>							
						</tr>
					</table>
				</form>
				
				<bean:define id="functionLabel">
					<bean:message key="function.rptPatientChargeSummary.report" />
				</bean:define>
				<bean:define id="notFoundMsg">
					<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
				</bean:define>
						
				<script language="javascript">
					function submitReport(cmd) {
						if (document.rptPatientChargeSummaryForm.dischargeDateFrom.value == '') {
							alert('Please enter Discharge Date period.');
							document.rptPatientChargeSummaryForm.dischargeDateFrom.focus();
							return false;
						}
						if (document.rptPatientChargeSummaryForm.dischargeDateTo.value == '') {
							alert('Please enter Discharge Date period.');
							document.rptPatientChargeSummaryForm.dischargeDateTo.focus();
							return false;
						}
							
						document.rptPatientChargeSummaryForm.command.value = cmd;
						document.rptPatientChargeSummaryForm.submit();	
						
						showLoadingBox('body', 500, $(window).scrollTop());
						return false;
					}
				
					function clearSearch() {
						document.rptPatientChargeSummaryForm.dischargeDateFrom.value="";
						document.rptPatientChargeSummaryForm.dischargeDateTo.value="";
					}				
				</script>
			</div>
		</div>
		
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>