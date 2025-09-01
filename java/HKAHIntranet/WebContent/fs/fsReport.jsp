<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="java.io.*"%>
<%
UserBean userBean = new UserBean(request);

String reportMth1 = request.getParameter("month_from");
String command = request.getParameter("command");
String rtnFlag = request.getParameter("rtnFlag");
String admDateTo = request.getParameter("date_to");
String chargeTo = ParserUtil.getParameter(request, "chargeTo");
String message = ParserUtil.getParameter(request, "message");
String allDept = ParserUtil.getParameter(request, "all_dept");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

Calendar cal = Calendar.getInstance();
SimpleDateFormat dateFmt = new SimpleDateFormat("ddMMyyyyHHmmss");
String sysDate = dateFmt.format(cal.getTime());
String deptCode = userBean.getDeptCode();
File reportFile = null;
File reportFile2 = null;

boolean submitAction = false;
boolean printAction = false;
boolean printAction2 = false;
boolean successUpt = false;
if ("submit".equals(command)) {
	submitAction = true;
}else if ("print".equals(command)){
	printAction = true;
}else if ("print2".equals(command)){
	printAction2 = true;	
}
System.err.println("[printAction]:"+printAction+"[reportMth1]:"+reportMth1+";[chargeTo]"+chargeTo);
try {
//jasper report
	if (printAction){
		submitAction = false;
				
		//ja1sper report
		reportFile = new File(application.getRealPath("/report/foodServiceReportByDept.jasper"));
		
		if (reportFile.exists()) {
			System.err.println("[printAction]:"+printAction+";[reportMth1]:"+reportMth1+";[allDept]:"+allDept+";[chargeTo]:"+chargeTo);			
			Connection conn = null;
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	
			Map parameters = new HashMap();
			parameters.put("POSTDATE", reportMth1);
			parameters.put("CHARGETO", chargeTo);
			parameters.put("ALLDEPT", allDept);
			parameters.put("SITE", ConstantsServerSide.SITE_CODE);
			
			conn = HKAHInitServlet.getDataSourceIntranet().getConnection();
	
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(jasperReport, 
						parameters, 
						HKAHInitServlet.getDataSourceIntranet().getConnection());
	
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			String contentType = null;
			String dispositionType = "inline";
			JRExporter exporter = null;
	
			contentType = "application/pdf";
			exporter = new JRPdfExporter();
	
			response.setContentType(contentType);
			response.setHeader("Content-disposition", dispositionType);
			
	        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
	        exporter.exportReport();
	        System.gc();
		}else{
			System.err.println("4[printAction]:"+printAction);			
		}
	}else if(printAction2){
		submitAction = false;
		
		//ja1sper report
		reportFile2 = new File(application.getRealPath("/report/foodServiceReportByDept2.jasper"));
		
		if (reportFile2.exists()) {
			System.err.println("[printAction2]:"+printAction2+";[reportMth1]:"+reportMth1+";[allDept]:"+allDept+";[chargeTo]:"+chargeTo);			
			Connection conn = null;
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile2.getPath());
	
			Map parameters = new HashMap();
			parameters.put("POSTDATE", reportMth1);
			parameters.put("CHARGETO", chargeTo);
			parameters.put("ALLDEPT", allDept);
			parameters.put("SITE", ConstantsServerSide.SITE_CODE);
			
			conn = HKAHInitServlet.getDataSourceIntranet().getConnection();
	
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(jasperReport, 
						parameters, 
						HKAHInitServlet.getDataSourceIntranet().getConnection());
	
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			String contentType = null;
			String dispositionType = "inline";
			JRExporter exporter = null;
	
			contentType = "application/pdf";
			exporter = new JRPdfExporter();
	
			response.setContentType(contentType);
			response.setHeader("Content-disposition", dispositionType);
			
	        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
	        exporter.exportReport();
	        System.gc();
		}else{
			System.err.println("4[printAction2]:"+printAction2);			
		}		
	}else{
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMM");
		reportMth1 = dateFormat.format(calendar.getTime());
		System.err.println("2[reportMth1]:"+reportMth1);
	}		
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<body>
<div id=indexWrapper>
<div id=mainFrame>
<div id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.dfsr.deptReport" />
	<jsp:param name="category" value="group.cts" />
	<jsp:param name="mustLogin" value="N" />	
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.dfsr.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="fsReport.jsp" method="post" >
<table cellpadding="0" cellspacing="5" align="center"
		class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%">Service Date</td>
		<td class="infoData" width="25%">
			<input type="textfield" name="month_from" id="month_from"  value="<%=reportMth1==null?"":reportMth1 %>" maxlength="6" size="10" />&nbsp;(YYYYMM)
		</td>
	</tr>		
	<tr class="smallText">			
		<td class="infoLabel" width="20%"><bean:message key="prompt.chargeTo" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<select name="chargeTo" >
			<%chargeTo = chargeTo == null ? deptCode : chargeTo; %>	
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=chargeTo %>" />
				<jsp:param name="allowAll" value="Y" />
				<jsp:param name="category" value="cash" />
			</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">
			<bean:message key="prompt.allDept" />
		</td>
		<td class="infoData" width="25%">
			<input type="checkbox" name="all_dept" id="all_dept" value="N" unchecked/>
		</td>
	</tr>		
	<tr class="smallText">					
		<td align="center" colspan=2>	
			<button onclick="return submitAction('print');">Print</button>					
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>	
		</td>													
	</tr>
<input type="hidden" name="command"/>
</form>
<script language="javascript">
	function submitAction(cmd) {
		if (document.form1.month_from.value == '') {
			alert('Please enter month.');
			document.form1.month_from.focus();
			return false;
		}else{
			if (document.form1.all_dept.checked) {
				document.form1.all_dept.value = 'Y';
				document.form1.all_dept.checked = true;			
			}
			document.form1.command.value = cmd;
			document.form1.submit();
			return false;				
		}
	}
		
	function closeAction() {
		window.close();
	}
</script>
</div>
</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>