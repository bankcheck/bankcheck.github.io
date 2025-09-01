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

String admDateFrom = request.getParameter("date_from");
String admDateTo = request.getParameter("date_to");
String reportMth1 = request.getParameter("month_from");

String site = request.getParameter("site");
String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
File reportFile = null;
SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMddHHmmss");
String reportMth = null;

if("view".equals(command)){
	ArrayList rehabRecord = PatientDB.getPatientRehabReport(reportMth1);

	if(rehabRecord.size()>0){
		reportFile = new File(application.getRealPath("/report/RPT_PAT_REHAB_APPT.jasper"));
		ReportListDataSource report = null;

		if (reportFile != null && reportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
			
			Map parameters = new HashMap();
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("DateFrom", reportMth1);
			parameters.put("Site", site);
			parameters.put("reportMth",reportMth1);
			
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport,
					parameters,
					new ReportMapDataSource(rehabRecord, new String[]{"MON","ENG_MON","COL1","AM_CANCEL","COL2","AM_NOSHOW","COL3","COL4","PM_CANCEL","COL5","PM_NOSHOW","COL6"}
																		,null));		
					
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/vnd.ms-excel");
			JRXlsExporter exporterXLS = new JRXlsExporter();
			response.setHeader("Content-Disposition", "attachment;filename=PatientRehabStatMth_" + tsFormat.format(new Date()) + ".xls");
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
					<jsp:param name="pageTitle" value="function.patRehab.report" />
					<jsp:param name="category" value="group.report" />
				</jsp:include>
				
				<font color="blue"><%=message %></font>
				<font color="red"><%=errorMessage %></font>
				
				<form name="searchPbForm" action="rptPatRehabAppt.jsp" method="get">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.reportYear" />
							</td>
							<td class="infoData" width="25%">
								<input type="textfield" name="month_from" id="month_from"  value="<%=reportMth1==null?"":reportMth1 %>" maxlength="6" size="10" />&nbsp;(YYYY)
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
						var year = document.searchPbForm.month_from.value;
						if(year.length!=4){
							document.searchPbForm.month_from.focus();
							return false;							
						}else{
							if(year<1900&&year>9999){
								alert('Please enter valid year');
								document.searchPbForm.month_from.focus();
								return false;								
							}else{
								document.searchPbForm.command.value = cmd;
								document.searchPbForm.submit();	
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