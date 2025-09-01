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

String site = request.getParameter("site");
String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
File reportFile = null;

String wrdCode = request.getParameter("wrdCode");
SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMddHHmmss");
String dateRange = admDateFrom+" to "+admDateTo;
String ward =  request.getParameter("ward");
String wardName = request.getParameter("wardName");

if("view".equals(command)){
	ArrayList Top20Record = PatientDB.getTop20AdmissRateReport(admDateFrom, admDateTo, ward);

	if(Top20Record.size()>0){
		reportFile = new File(application.getRealPath("/report/RptTop20DoctorInp.jasper"));
		ReportListDataSource report = null;

		if (reportFile != null && reportFile.exists()) {
			System.err.println("[wardName]:"+wardName);
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
			
			Map parameters = new HashMap();
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("Site", site);
			parameters.put("DATERANGE", dateRange);
			parameters.put("WRDCODE",ward);
			parameters.put("WRDNAME",wardName);
			
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport,
					parameters,
					new ReportMapDataSource(Top20Record, new String[]{"RANK","DOCNAME","NOOFCASE"},
					null));	
					
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/vnd.ms-excel");
			JRXlsExporter exporterXLS = new JRXlsExporter();
			response.setHeader("Content-Disposition", "attachment;filename=Top20DocAdmissRateReport_" + tsFormat.format(new Date()) + ".xls");
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
					<jsp:param name="pageTitle" value="function.doctorTop20.report" />
					<jsp:param name="category" value="group.report" />
				</jsp:include>
				
				<font color="blue"><%=message %></font>
				<font color="red"><%=errorMessage %></font>
				
				<form name="searchPbForm" action="rptTop20DoctorInp.jsp" method="get">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.admissionDate" />
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="date_from" id="date_from" 
									class="datepickerfield" value="<%=admDateFrom==null?"":admDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								-
								<input type="textfield" name="date_to" id="date_to" 
									class="datepickerfield" value="<%=admDateTo==null?"":admDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>							
							<td width="20%">
								<button onclick="return submitReport('view');"><bean:message key="button.doc.view" /></button>
								<input type="hidden" name="command" />
								<input type="hidden" name="reportNo" value=""/>
								<input type="hidden" name="wardName" value=""/>
							</td>							
						</tr>
						<tr class="smallText">
							<td class="infoLabel" style="width:30%">Ward :</td>
							<td class="infoData" style="width:70%">
								<select name="ward">
								<jsp:include page="../ui/wardCMB.jsp" flush="false">
									<jsp:param name="wrdCode" value="<%=ward %>" />
									<jsp:param name="allowAll" value="Y" />
									<jsp:param name="allowEmpty" value="N" />
								</jsp:include>
								</select>
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
						document.searchPbForm.command.value = cmd;
						document.searchPbForm.submit();	
						var txt = $("select[name=ward] option:selected").text();
						document.searchPbForm.wardName.value=txt;
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