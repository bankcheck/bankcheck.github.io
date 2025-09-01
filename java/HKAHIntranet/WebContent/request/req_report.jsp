<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.HKAHInitServlet"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");
String curent_date = DateTimeUtil.getCurrentDate();
String command = ParserUtil.getParameter(request, "command");

String dateStr = null;
if (date_from != null && (date_from.equals(date_to) || (date_to == null))) {
	dateStr = date_from;
} else if (date_to != null && date_from == null) {
	dateStr = date_to;
} else if (date_to != null && date_from != null) {	
	dateStr = date_from + " to " + date_to;
}

if ("dept".equals(command)) {
	ArrayList record = RequestDB.getDeptReport(userBean, date_from, date_to);

	File reportFile = new File(application.getRealPath("/report/RPT_TASK_BY_DEPT.jasper"));
	if (reportFile.exists()) {
		
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
		Map parameters = new HashMap();
		File reportDir = new File(application.getRealPath("/report/"));
	
		parameters.put("DATESTR", dateStr);
	
		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
			jasperReport,
			parameters,
			new ReportListDataSource(record));
	
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		JRPdfExporter exporter = new JRPdfExporter();
    	exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
       	exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
       	exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

       	exporter.exportReport();
       	ouputStream.flush();
       	ouputStream.close();
		return;
	}
} else if ("req".equals(command)) {
	ArrayList record = RequestDB.getReqReport(userBean, date_from, date_to);

	File reportFile = new File(application.getRealPath("/report/RPT_TASK_BY_REQ.jasper"));
	if (reportFile.exists()) {
	
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
		Map parameters = new HashMap();
		File reportDir = new File(application.getRealPath("/report/"));
	
		parameters.put("DATESTR", dateStr);
	
		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
			jasperReport,
			parameters,
			new ReportListDataSource(record));
	
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		JRPdfExporter exporter = new JRPdfExporter();
    	exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
       	exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
       	exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

       	exporter.exportReport();
       	ouputStream.flush();
       	ouputStream.close();
		return;
	}
} else if ("staff".equals(command)) {
	ArrayList record = RequestDB.getStaffReport(userBean, date_from, date_to);

	File reportFile = new File(application.getRealPath("/report/RPT_STAFF_SUMM.jasper"));
	if (reportFile.exists()) {
	
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
		Map parameters = new HashMap();
		File reportDir = new File(application.getRealPath("/report/"));
	
		parameters.put("DATESTR", dateStr);
	
		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
			jasperReport,
			parameters,
			new ReportListDataSource(record));
	
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		JRPdfExporter exporter = new JRPdfExporter();
    	exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
       	exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
       	exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

       	exporter.exportReport();
       	ouputStream.flush();
       	ouputStream.close();
		return;
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
<jsp:include page="../common/header.jsp"/>
<style>
.total-row { font-weight: bold; }
</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Time Management Report" />
</jsp:include>
<form name="search_form" action="req_report.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Selection Criteria</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">From :</td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">To :</td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_to" id="date_to" class="datepickerfield" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
		</td>
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="30%">Report:</td>
		<td class="infoData" width="70%">
			<input type="radio" name="command" id="command" value="dept"/>Task Report By Department<br/><br/>
			<input type="radio" name="command" id="command" value="req"/>Task Report By Request<br/><br/>
			<input type="radio" name="command" id="command" value="staff"/>Staff Summary Report			
		</td>
	</tr>
	<tr class="smallText">
		<td align="center" colspan="2">
			<button onclick="return submitSearch();">Generate</button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" />
</form>
<script language="javascript">

	function submitSearch() {
		document.search_form.submit();
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>