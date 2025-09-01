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
<%@ page import="javax.swing.JFileChooser"%>
<%@ page import="javax.swing.JOptionPane"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="java.io.*"%>
<%
UserBean userBean = new UserBean(request);

Calendar cal = Calendar.getInstance();
SimpleDateFormat dateFmt = new SimpleDateFormat("ddMMyyyyHHmmss");
String sysDate = dateFmt.format(cal.getTime());
File reportFile = null;

String command = null;
String rtnFlag = null;
String chargeDetail = null;
String expMth = null;
String chargeSummary = null;
String siteCode = ConstantsServerSide.SITE_CODE;
String message = null;
String errorMessage = null;

expMth = request.getParameter("expMth");
command = request.getParameter("command");
rtnFlag = request.getParameter("rtnFlag");;
chargeDetail = request.getParameter("chargeDetail");; 
chargeSummary = request.getParameter("chargeSummary");;
System.err.println("1[expMth]:"+expMth);

boolean submitAction = false;
boolean printAction = false;
boolean successUpt = false;
String listReturn = null;

if ("export".equals(command)) {
	submitAction = true;	
}else if ("print".equals(command)){
	printAction = true;
}
System.err.println("[command]:"+command);
try {
	if (submitAction) {
		listReturn =FsDB.execFuncGetList("F_FS_EXPORT2FLEX",userBean,expMth,siteCode);

	    if (listReturn != null && "JV".equals(listReturn.substring(0,2))){
	    	System.err.println(listReturn);
			//File creation
//			String fileName = "foodToFlex_"+expMth+".txt";
			String fileName = "foodToFlex.txt";
//			String strPath = "C:\\temp\\";
			String strPath = ConstantsServerSide.DOCUMENT_FOLDER+"/Intranet/fs/";
			System.err.println("[path]:"+strPath);
			File strFile = new File(strPath+fileName);
			boolean fileCreated = strFile.createNewFile();
			//File appending
			Writer objWriter = new BufferedWriter(new FileWriter(strFile));
			objWriter.write(listReturn);
			objWriter.flush();
			objWriter.close();
			//String redirectPath = "../documentManage/download.jsp?locationPath=" + strPath+fileName;
			String redirectPath = "../documentManage/download.jsp?documentID=699";
			response.sendRedirect(redirectPath);			
			message = "Save Success"; 
	    }else{
	    	if(listReturn==null){
	    		errorMessage = "No record found.";	    		
	    	}else{
	    		errorMessage = "Export fail.";	    		
	    	}
	    	submitAction = false;
	    }
	}else if(printAction){
		submitAction = false;
		
		//ja1sper report
		reportFile = new File(application.getRealPath("/report/foodServiceReportByDept2.jasper"));
		
		if (reportFile.exists()) {
			System.err.println("[printAction]:"+printAction+";[expMth]:"+expMth);			
			Connection conn = null;
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	
			Map parameters = new HashMap();
			parameters.put("POSTDATE", expMth);
			parameters.put("CHARGETO", null);
			parameters.put("ALLDEPT", "Y");
			parameters.put("SITE", siteCode);
			
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
	}else{
		if(expMth==null){
			Calendar calendar = Calendar.getInstance();
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMM");
			expMth = dateFormat.format(calendar.getTime());			
		}
		System.err.println("2[expMth]:"+expMth);		
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
	<jsp:param name="pageTitle" value="function.dfsr.2Flex" />	
	<jsp:param name="category" value="group.cts" />
	<jsp:param name="mustLogin" value="N" />	
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.dfsr.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="generateFile2Flex.jsp" method="post" >
<table cellpadding="0" cellspacing="5" align="center"
		class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.exportMth" /></td>
		<td class="infoData" width="25%">
			<input type="textfield" name="expMth" id="expMth"  value="<%=expMth==null?"":expMth %>" maxlength="6" size="10" />&nbsp;(YYYYMM)
		</td>		

	</tr>			
	<tr class="smallText">					
		<td align="center" colspan=2>	
			<button onclick="return submitAction('export');">Export File</button>
			<button onclick="return submitAction('print');">Print</button>			
			<span id="show_indicator">
			</span>	
		</td>													
	</tr>
<input type="hidden" name="command"/>
</form>
<script language="javascript">
	function submitAction(cmd) {
		if (cmd=='export'){
			if (document.form1.expMth.value == '') {
				alert('Please enter export month');
				document.form1.expMth.focus();
				return false;
			}else{
				var expMth = document.form1.expMth.value;
				document.form1.command.value = cmd;
				checkRecord();
				return false;					
			}
		}else if(cmd=='print'){
			document.form1.command.value = cmd;
			document.form1.submit();
			return false;
		}
	}
	
	function checkRecord() {
		var expMth = document.form1.expMth.value;

		$.ajax({
			type: "POST",
			url: "fs_hidden.jsp",
			data: 'p1=2&p2=' + expMth,
			async: false,						
			success: function(values){
				if(values != '') {			
					if(values.substring(0, 1) == 1){
						alert('No record found');						
					}else{						
						document.form1.submit();					
					};
				}else{
					alert('No record found');
				}//if
			}//success
		});//$.ajax	
	}
		
	function WriteFile(passValue) 
	{		
	   var fso  = new ActiveXObject("Scripting.FileSystemObject");
		alert('2[passValue]:'+passValue);	   
	   var fh = fso.CreateTextFile("c:\\Test.txt", true); 
	   fh.WriteLine(passValue); 
	   fh.Close(); 
	   alert('Save success');
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