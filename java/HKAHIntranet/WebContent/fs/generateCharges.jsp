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

String postDate = request.getParameter("postDate");
String command = request.getParameter("command");
String rtnFlag = request.getParameter("rtnFlag");;
String chargeDetail = request.getParameter("chargeDetail");; 
String chargeSummary = request.getParameter("chargeSummary");;
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

Calendar cal = Calendar.getInstance();
SimpleDateFormat dateFmt = new SimpleDateFormat("ddMMyyyyHHmmss");
String sysDate = dateFmt.format(cal.getTime());
String siteCode = ConstantsServerSide.SITE_CODE;
String postMth = null;
File reportFile = null;

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
System.err.println("[printAction]:"+printAction+"[chargeDetail]:"+chargeDetail+";[chargeSummary]:"+chargeSummary);
try {
	if (submitAction) {
		System.err.println("submitAction[successUpt]:"+successUpt+";[postDate]:"+postDate);
		successUpt =FsDB.execProcUptComp("F_UPT_POSTDATE",userBean, postDate);
			
System.err.println("2[successUpt]:"+successUpt);
	    if (successUpt){
			message = "Post success";
			submitAction = false;
					
			//jasper report
			System.out.println("[chargeDetail]:"+chargeDetail+";[chargeSummary]:"+chargeSummary);
			reportFile = new File(application.getRealPath("/report/foodServiceBillPost.jasper"));				
			
			if (reportFile.exists()) {
				System.err.println("[printAction]:"+printAction+";[postDate]:"+postDate+";[siteCode]:"+siteCode);			
				Connection conn = null;
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
				Map parameters = new HashMap();
				parameters.put("POSTDATE", postDate);
				parameters.put("STECODE", siteCode);
				
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
	    	message = "Post fail.";
	    	submitAction = false;
	    }
	}else if (printAction){
//jasper report
		System.out.println("[chargeDetail]:"+chargeDetail+";[chargeSummary]:"+chargeSummary);
		if(chargeDetail == null && chargeSummary == ""){
			chargeDetail = "Y";
		
		}
		
		System.out.println("[chargeDetail]:"+chargeDetail+";[chargeSummary]:"+chargeSummary);
		if("Y".equals(chargeDetail)){
			System.err.println("1[printAction]:"+printAction);
			reportFile = new File(application.getRealPath("/report/foodServiceBillPost.jasper"));				
		}else if("Y".equals(chargeSummary)){
			System.err.println("2[printAction]:"+printAction);
			reportFile = new File(application.getRealPath("/report/foodServiceChrgSummary.jasper"));				
		}
		
		if (reportFile.exists()) {
			System.err.println("3[printAction]:"+printAction+";[postDate]:"+postDate+";[siteCode]:"+siteCode);				
			Connection conn = null;
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	
			Map parameters = new HashMap();
			parameters.put("POSTDATE", postDate);
			parameters.put("STECODE", siteCode);			
			
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
		
		if(postDate!=null){
			Date postddate = null;
			
			SimpleDateFormat dmyformatter = new SimpleDateFormat("dd/MM/yyyy");
			SimpleDateFormat myformatter = new SimpleDateFormat("yyyyMM");
			try {
				postddate = dmyformatter.parse(postDate);
				postMth = myformatter.format(postddate);
			} catch (Exception e) {
				postMth = myformatter.format(cal.getTime());
			}
	
		}		
		
		//ja1sper report
		reportFile = new File(application.getRealPath("/report/foodServiceReportByDept2.jasper"));
		
		if (reportFile.exists()) {
			System.err.println("[printAction2]:"+printAction2+";[postMth]:"+postMth);			
			Connection conn = null;
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	
			Map parameters = new HashMap();
			parameters.put("POSTDATE", postMth);
			parameters.put("CHARGETO", null);
			parameters.put("ALLDEPT", "Y");
			
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
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		postDate = dateFormat.format(calendar.getTime());
		System.err.println("2[postDate]:"+postDate);
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
	<jsp:param name="pageTitle" value="function.dfsr.post" />
	<jsp:param name="category" value="group.cts" />
	<jsp:param name="mustLogin" value="N" />	
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.dfsr.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="generateCharges.jsp" method="post" >
<table cellpadding="0" cellspacing="5" align="center"
		class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.postDate" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="postDate" id="postDate" class="datepickerfield" value="<%=postDate==null?"":postDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
		</td>
	</tr>
					<tr class="smallText">
		<td class="infoLabel" width="20%">Report</td>
		<td class="infoData" width="80%">
			<input type="checkbox" name="chargeDetail" id="chargeDetail" value="Y" checked="checked" onclick="return unclickother('chargeDetail')">Charge Detail</input>		
			<input type="checkbox" name="chargeSummary" id="chargeSummary" value="N" onclick="return unclickother('chargeSummary')">Charge Summary</input>
		</td>
	</tr>			
	<tr class="smallText">					
		<td align="center" colspan=2>	
			<button onclick="return submitAction('submit');">Proceed</button>
			<button onclick="return submitAction('print');">Print</button>
			<button onclick="return submitAction('print2');">Print by Post Date</button>			
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>	
		</td>													
	</tr>
<input type="hidden" name="command"/>
</form>
<script language="javascript">
	function unclickother(chkbox){
		var chkboxvalue1 = document.getElementById("chargeDetail").checked;
		var chkboxvalue2 = document.getElementById("chargeSummary").checked;

		if(chkbox=='chargeDetail'){
			if(chkboxvalue1 && chkboxvalue2){
				document.getElementById("chargeSummary").checked = false;
				document.form1.chargeDetail.value = 'Y';				
				document.form1.chargeSummary.value = 'N';				
			}else{
				document.form1.chargeSummary.value = 'N';
				document.form1.chargeDetail.value = 'N';				
			}
		}else if(chkbox=='chargeSummary'){
			if(chkboxvalue1 && chkboxvalue2){				
				document.getElementById("chargeDetail").checked = false;
				document.form1.chargeDetail.value = 'N';
				document.form1.chargeSummary.value = 'Y';
			}else{
				document.form1.chargeSummary.value = 'N';
				document.form1.chargeDetail.value = 'N';				
			}			
		}
	}

	function submitAction(cmd) {
		if (cmd=='submit'){
			if (document.form1.postDate.value == '') {
				alert('Please enter post date.');
				document.form1.postDate.focus();
				return false;
			}else{
				var postDate = document.form1.postDate.value;
			}
			
			$.ajax({
				type: "POST",
				url: "fs_hidden.jsp",
				data: 'p1=1&p2=' + postDate,
				async: false,
				success: function(values){				
				if(values != '') {
					if(values.length>0){
						var cnt = parseInt(values);

						if(cnt>0){
							var r=confirm(cnt+" record(s) ready, do you want to post?");
							if (r==true){			
								rtnVal = true;
								document.form1.command.value = cmd;
								document.form1.submit();
								return false;	
							 }else{
								 document.form1.command.value = '';
								 return false;	
							 }
						}else if(cnt == -1){
							alert('Post date already exists!');
							document.form1.postDate.focus();
							rtnVal = false;
							return false;
						}else if(cnt == -2){
							alert('No bill record for posting!');
							document.form1.postDate.focus();
							rtnVal = false;
							return false;
						
						}else{
						 	document.form1.command.value = '';
						 	return false;							
						}						
					}else{
					 	document.form1.command.value = '';
					 	return false;
					}				
				}else{alert('null value');}//if
				}//success
			});//$.ajax		
		}else{
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