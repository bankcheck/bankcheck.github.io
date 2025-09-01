<%@ page import="java.math.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.DiIncomeReportHelper"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.ArrayList.*"%>
<%@ page import="java.util.zip.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="org.apache.commons.io.FilenameUtils"%>
<%@ page import="org.apache.poi.ss.usermodel.*"%>
<%@ page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page import="org.apache.poi.ss.util.*"%>
<%!
private List<String> outputAllReports(ServletContext application, HttpServletRequest request, 
		Date reportCreateDate, String actualRun, String endPeriod, String dept, String servcde) {
	List<String> outputFilePaths = new ArrayList<String>();
	
	System.out.println("[incomeReport] outputAllReports");
	
	List<String> rptTypes = new ArrayList<String>();
	if ("Y".equals(actualRun) || actualRun == null) {
		rptTypes.add("BFSummary");
		rptTypes.add("ACTUALSummary");
		rptTypes.add("CFSummary");
		rptTypes.add("BF");
		rptTypes.add("ACTUAL");
		rptTypes.add("CF");
	}
	
	if ("N".equals(actualRun) || actualRun == null) {
		rptTypes.add("TRIAL_BF");
		rptTypes.add("TRIAL");
		rptTypes.add("TRIAL_CF");
		rptTypes.add("TRIAL_BFSummary");
		rptTypes.add("TRIALSummary");
		rptTypes.add("TRIAL_CFSummary");
	}
	try {
		for (String rpttype : rptTypes) {
			String reportFileName = "DiBf" + (rpttype.contains("Summary") ? "Summary" : "") + ".jasper";
			
			System.out.println(" reportFileName="+reportFileName);
			
			File reportFile = new File(application.getRealPath("/report/" + reportFileName));
			if (reportFile.exists()) {
				
				System.out.println(" reportFile="+reportFile.getAbsolutePath());
				
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
				
				String expFileExt = "";
				String reportType = rpttype.contains("BF") ? "BF" :
					(rpttype.contains("CF") ? "CF" : "IC");
				
				String dateStr = (new SimpleDateFormat("yyyyMMdd_kkmmss")).format(new Date());
				String encodedFileName = getListingFileName(rpttype, reportCreateDate, dept) + ".pdf";
				String outputFilePath = ConstantsServerSide.TEMP_FOLDER + "/" + encodedFileName;
				
				System.out.println("outputFilePath: " + outputFilePath);
				
				Map parameters = new HashMap();
				parameters.put("SUBREPORT_DIR", reportFile.getParentFile().getPath() + "\\");
				parameters.put("in_rpttype", reportType);
				parameters.put("in_actualrun", actualRun);
				parameters.put("in_enddt", DateTimeUtil.parseDate(endPeriod));
				parameters.put("in_dept", (dept != null && dept.trim().isEmpty()) ? null : dept);
				parameters.put("in_servcde", (servcde != null && servcde.trim().isEmpty()) ? null : servcde);
				parameters.put("in_stecode", ConstantsServerSide.SITE_CODE.toLowerCase());
				
				System.out.println("Generating: "+reportFileName + ", outputFilePath=" + outputFilePath);
				System.out.println("  reportType="+reportType);
				System.out.println("  actualRun="+actualRun);
				System.out.println("  endPeriod="+endPeriod);
				System.out.println("  dept="+dept);
				System.out.println("  servcde="+servcde);
				
				System.out.println(" Creating jasperPrint object");
				
				JasperPrint jasperPrint = null;
				try {
					jasperPrint =
							JasperFillManager.fillReport(
								jasperReport, parameters, HKAHInitServlet.getDataSourceHATS().getConnection());
				} catch (Exception e) {
					System.out.println("  Error fillReport");
					e.printStackTrace();
				}
	
				System.out.println(" Exporting to pdf");
				
				/*
				request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
				
				//response.setContentType("application/pdf");
				//response.setHeader("Content-disposition", "attachment; filename=\"" + encodedFileName + "\"");
				
				
				OutputStream ouputStream = new FileOutputStream(outputFilePath);
				JRPdfExporter exporter = new JRPdfExporter();
		        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

		        exporter.exportReport();
		        ouputStream.flush();
		        ouputStream.close();
		        */
		        
		     	// Export pdf file
		        JasperExportManager.exportReportToPdfFile(jasperPrint, outputFilePath);
		        
		        jasperPrint = null;
		        jasperReport = null;
		        //System.gc();
		        
		        
		        System.out.println("Export done");
		        
		        outputFilePaths.add(outputFilePath);
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	return outputFilePaths;
}

private void archiveFilesZip(HttpServletResponse response, List<String> fileFullPaths) {
	byte[] buffer = new byte[1024];
	ZipOutputStream zos = null;
	try{
		zos = new ZipOutputStream(response.getOutputStream());
		
		if (fileFullPaths != null && fileFullPaths.size() > 0) {
			System.out.println(new Date() + " [DI Doctor payroll] Zipping reports, size: " + fileFullPaths.size());
			long totalLen = 0l;
			Map<String, Integer> fullPaths = new HashMap<String, Integer>();
			String zipTempPath = ConstantsServerSide.TEMP_FOLDER + "/" + "DI_Payroll_Reports";
			
			for (int i = 0; i < fileFullPaths.size(); i++) {
				String fullPath = fileFullPaths.get(i);
				String fileName = FilenameUtils.getName(fullPath);
				
				System.out.println("Adding file to zip - " + (i+1) + ": " + fullPath + ", file name: "+fileName);
				
				ZipEntry ze= new ZipEntry(fileName);
				try {
					File file = new File(fullPath);
					ze.setTime(file.lastModified());
				} catch (Exception e) {
					System.out.println(new Date() + " [DI Doctor payroll] cannot access filePath:" + fullPath + ", err:" + e.getMessage());
				}
				
				zos.putNextEntry(ze);
				
				try {
					FileInputStream in = new FileInputStream(fullPath);

					int len;
			    	while ((len = in.read(buffer)) > 0) {
			    		zos.write(buffer, 0, len);
			    		totalLen += len;
			    	}
			    	in.close();
				} catch (Exception fex) {
					System.out.println("[intranet] file_list Cannot access file: " + fullPath + ", ex: " + fex.getMessage());
				}
			}
			System.out.println("File len: " + totalLen);
		}
   	} catch (Exception ex) {
    	   ex.printStackTrace();
    } finally {
    	if (zos != null) {
    		try {
	        	zos.closeEntry();
	        	zos.close();
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
    }
}

private String getArchiveFileName(Date reportCreateDate) {
	String ret = null;
	SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
	String tsStr = tsFormat.format(reportCreateDate);
	ret = "HKAH-" + (ConstantsServerSide.isHKAH() ? "SR" : ConstantsServerSide.isTWAH() ? "TW" : "Other") + "_DI_Docincome_Listing_" + tsStr;
	return ret;
}

private String getListingFileName(String rpttype, Date reportCreateDate, String dept) {
	String ret = null;
	SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
	String tsStr = tsFormat.format(reportCreateDate);
	ret = tsStr + "_DocIncomeListing_" + (dept == null ? "" : dept + "_") + rpttype;
	return ret;
}
%>
<%
UserBean userBean = new UserBean(request);

String pageTitle = "DI Doctor Income Report";
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");

String report = request.getParameter("report");
String reportDoc = request.getParameter("reportDoc");
String reportType = request.getParameter("reportType");
String startPeriod = request.getParameter("startPeriod");
String endPeriod = request.getParameter("endPeriod");
Date endPeriodDate = DateTimeUtil.parseDate(endPeriod);
String actualRun = request.getParameter("actualRun");
String payTo = request.getParameter("payTo");
String dept = request.getParameter("dept");
String servcde = request.getParameter("servcde");

String startPeriod3 = request.getParameter("startPeriod3");
String endPeriod3 = request.getParameter("endPeriod3");
String reportDoc2 = request.getParameter("reportDoc2");
String startPeriod2 = request.getParameter("startPeriod2");
String endPeriod2 = request.getParameter("endPeriod2");
String actualRun2 = request.getParameter("actualRun2");
boolean isMthEndTRun = "Y".equals(request.getParameter("isMthEndTRun"));
String reportMonth = ParserUtil.getParameter(request, "reportPeriod_mm");
String reportYear = ParserUtil.getParameter(request, "reportPeriod_yy");

boolean isNoReport = false;
List payToList = new ArrayList();

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

try {
	if ("1".equals(step)) {
		if ("preparetempdata".equals(command)) {
			if (DiIncomeReportDB.insertTempSliptx()) {
				message = "Temp data is prepared.";
			} else {
				errorMessage = "Cannot insert temp data";
			}
		} else if ("preparedata".equals(command)) {
			/*
			System.out.println("DEBUG incomeReport.jsp preparedata reportDoc2=" + reportDoc2 +
					"endPeriod2=" + endPeriod2 + "actualRun2=" + actualRun2);
			*/
			if (reportDoc2 != null && endPeriod2 != null && actualRun2 != null) {
				if ("Y".equals(actualRun2)) {
					startPeriod2 = null;
					if (isMthEndTRun) {
						DiIncomeReportDB.deleteTrialDocincome();
						isMthEndTRun = false;
					}
				}
				
				Integer ret = DiIncomeReportDB.execDiPayroll(startPeriod2, endPeriod2, reportDoc2, actualRun2);
				if (ret != null && ret <= 0) {
					errorMessage = "Error: " + ret + " - ";
					if (ret == 0) {
						errorMessage += "No docincome record is generated.";
					} else if (ret == -1001) {
						errorMessage += "Start date is applied, actual run is not allowed.";
					} else if (ret == -1002) {
						errorMessage += "No end date input.";
					} else if (ret == -1003) {
						errorMessage += "Actual run is not input.";
					} else if (ret == -1010) {
						errorMessage += "Insert record to docincome failed.";
					} else if (ret == -1011) {
						errorMessage += "Reversed record is not found.";
					} else if (ret == -1013) {
						errorMessage += "No record found.";
					} else if (ret == -1014) {
						errorMessage += "Update stndidoc failed.";
					}
				} else {
					actualRun2 = "N";
				}
			}
		} else if ("prepareExam2payData".equals(command)) {
			/*
			System.out.println("DEBUG prepareExam2payData reportYear=" + reportYear +
					"reportMonth=" + reportMonth);
			*/
			if (reportYear != null && reportMonth != null) {
				if (DiIncomeReportDB.addExam2Pay(reportYear, reportMonth)) {
					message = "Data prepare success";
				} else {
					errorMessage = "Fail to add data";
				}
			} else {
				errorMessage = "Empty year or month";
			}
		} else if ("generatereport3".equals(command)) {
			System.out.println("[incomeReport] generatereport3");
			Date reportCreateDate = new Date();
			List<String> outputFilePaths = null;
			
			System.out.println("Site: " + ConstantsServerSide.SITE_CODE +", dept="+dept);
			
			outputFilePaths = outputAllReports(application, request, reportCreateDate, actualRun, endPeriod, dept, servcde);
			
			response.setHeader("Content-disposition", "attachment; filename=\"" + getArchiveFileName(reportCreateDate) + ".zip\"");
			archiveFilesZip(response, outputFilePaths);
			return;
		} else if ("generatePayroll".equals(command) || "generatePayroll2".equals(command)) {
			System.out.println("[incomeReport] generatePayroll payTo=<"+payTo+">");
			Date reportCreateDate = new Date();
			
			List<String> outputFilePaths = 
					DiIncomeReportHelper.outputAllPayrollReports(actualRun, endPeriod, payTo);
			
			response.setHeader("Content-disposition", "attachment; filename=\"" + 
					DiIncomeReportHelper.getPayrollReportArchiveFileName(reportCreateDate) + ".zip\"");
			archiveFilesZip(response, outputFilePaths);
			
			return;
		}
	}

	payToList = DiIncomeReportDB.getPayToList();
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
<style>
.highlightBox { background: #FFFF88; font-weight: bold; }
#prepareExam2payData-remark { font-weight: bold; color: red; }
</style>
<body>
<% if (isNoReport) { %>
<div id=indexWrapper>
Sorry, cannot generate report.
</div>
<button onclick="window.close();">Close Window</button>
<% } else { %>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>

<jsp:include page="../common/page_title.jsp" flush="true">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="isAccessControl" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<div class="pane">
<form name="form2" action="incomeReport.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Generate Report</td>
	</tr>
<!-- 
	<tr class="smallText">
		<td class="infoLabel" width="30%">Category</td>
		<td class="infoData" width="70%">
			<select id="report" name="report">
				<option value="DILS">Doctor Income Listing (Summary)</option>
				<option value="DILD">Doctor Income Listing (Detail)</option>
				<option value="TRS">Payroll Reports</option>
				<option value="TRD">Total Revenue (Detail)</option>
			</select>
		</td>
	</tr>
 -->		
</table>
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText option-both">
		<td class="infoLabel" width="30%">Report Type</td>
		<td class="infoData" width="70%">
			<input type="radio" name="reportType" value=""
			<%if("".equals(reportType) || reportType == null) {%> checked <%} %>/>ALL</input>		
			<input type="radio" name="reportType" value="BF"
			<%if("BF".equals(reportType)) {%> checked <%} %>/>Brought Forward</input>
			<input type="radio" name="reportType" value="IC"
			<%if("IC".equals(reportType)) {%> checked <%} %>/>Doctor Income</input>
			<input type="radio" name="reportType" value="CF"
			<%if("CF".equals(reportType)) {%> checked <%} %>/>Carried Forward</input>
		</td>
	</tr>
	<tr class="smallText option-both">
		<td class="infoLabel" width="30%">End Period</td>
		<td class="infoData" width="70%">
			<input type="text" name="startPeriod" id="startPeriod" value="<%=startPeriod==null?"":startPeriod %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" style="display:none;" />
			<input type="text" name="endPeriod" id="endPeriod" class="datepickerfield" value="<%=endPeriod==null?"":endPeriod %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
		</td>
	</tr>
	
	<tr class="smallText option-TR">
		<td class="infoLabel" width="30%">Department</td>
		<td class="infoData" width="70%">
			<select id="dept" name="dept">
				<option value="">ALL (for HK/AMC2)</option>
				<option value="DI">DI (for TW)</option>	
				<option value="OPD">OPD (for TW)</option>
			</select>
		</td>
	</tr>
	
	<tr class="smallText option-TR">
		<td class="infoLabel" width="30%">Pay To</td>
		<td class="infoData" width="70%">
			<select id="payTo" name="payTo">
			<option value="">ALL</option>
<%
	if (payToList != null && !payToList.isEmpty()) {
		for (int i = 0; i < payToList.size(); i++) {
			ReportableListObject rlo = (ReportableListObject) payToList.get(i);
			String iPayTo = rlo.getValue(0);
	%><option value="<%=iPayTo %>"><%=iPayTo %></option><%
		}
	} else {
		%><option value="HK RADIOLOGISTS LIMITED">HK RADIOLOGISTS LIMITED</option><%		
		%><option value="OOI GAIK CHENG, CLARA">DR OOI GAIK CHENG, CLARA (1235)</option><%
		%><option value="THREE DIMENSION MEDICAL IMAGING LIMITED">THREE DIMENSION MEDICAL IMAGING LIMITED</option><%	
		%><option value="Radiology Associates Limited">Radiology Associates Limited</option><%			
	
	}
%>
			</select>
		</td>
	</tr>
	<tr class="smallText option-both">
		<td class="infoLabel" width="30%">Run Mode</td>
		<td class="infoData" width="70%">
			<input type="radio" name="actualRun" value="N"
			<%if("N".equals(reportType) || reportType == null) {%> checked <%} %>/>Trial</input>
			<input type="radio" name="actualRun" value="Y"
			<%if("Y".equals(reportType)) {%> checked <%} %>/>Actual</input>
		</td>
	</tr>
	<tr class="smallText option-both">
		<td class="infoLabel" width="30%">Service Code</td>
		<td class="infoData" width="70%">
			<input type="text" name="servcde" value="<%=servcde==null?"":servcde %>" maxlength="5" size="5" />
			(Optional)
		</td>
	</tr>	
</table>
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td colspan="2" align="center">
			<!-- <button class="btn-generatereport">Generate</button> -->
			<button onclick="return submitAction2('generatereport3', 1);">Generate all listing reports (PDF)</button>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitAction2('generatePayroll', 1);">Generate payroll report (Excel)</button>
		</td>
	</tr>	
</table>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
</form>

<form name="form3" action="incomeReport.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0" style="display:none;">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Prepare Exam2Pay Data</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Approve Date<br />(Year / Month)</td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="reportPeriod" />
	<jsp:param name="YearAndMonth" value="Y" />
	<jsp:param name="day_mm" value="<%=reportMonth %>" />
	<jsp:param name="day_yy" value="<%=reportYear %>" />
	<jsp:param name="yearRange" value="5" />
	<jsp:param name="hideFutureYear" value="Y" />
	<jsp:param name="isYearOrderDesc" value="Y" />
</jsp:include>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2">
			<div id="prepareExam2payData-remark"></div>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button class="btn-prepareExam2payData">Execute</button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
</form>

<form name="form1" action="incomeReport.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Prepare DOCINCOME Data</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Report Doctor Code</td>
		<td class="infoData" width="70%">
			<input type="text" name="reportDoc2" value="<%=reportDoc2==null?"":reportDoc2 %>" maxlength="10" size="20" />
			(Optional)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Period</td>
		<td class="infoData" width="70%">
			<span id="startPeriod2-div">
				<input type="text" name="startPeriod2" class="datepickerfield" value="<%=startPeriod2==null?"":startPeriod2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
				-
			</span>
			<input type="text" name="endPeriod2" class="datepickerfield" value="<%=endPeriod2==null?"":endPeriod2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Run Mode</td>
		<td class="infoData" width="70%">
			<input type="radio" name="actualRun2" value="N"
			<%if("N".equals(actualRun2) || actualRun2 == null) {%> checked <%} %>/>Trial</input>
			<input type="radio" name="actualRun2" value="Y"
			<%if("Y".equals(actualRun2)) {%> checked <%} %>/>ACTUAL</input>
			<div id="isMthEndTRunBox" style="<%=!"Y".equals(actualRun2) ? "display:none;" : "" %>">
				<input type="checkbox" id="isMthEndTRun" name="isMthEndTRun" value="Y"<%=isMthEndTRun ? " checked=\"checked\"" : "" %> /> Delete trial run data
			</div>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitAction('preparedata', '2');">Execute</button>
		</td>
	</tr>
</table>
<input type="hidden" name="isMthEndTRun" />
<input type="hidden" name="command" />
<input type="hidden" name="step" />
</form>

<form name="form4" action="incomeReport.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Generate TEMP Data</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="left">
		The operation removes (using truncate) all records in database table "TEMP_CARDTX" and generate new records for the coming report data. You MUST run this operation BEFORE generating reports(Type: BF, IC or CF). <br /><br /> 
		(Be aware that there will be huge number of records removed and inserted in the table. Please wait a while for the operation to finish.)
		</td>
	</tr>	
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitAction('preparetempdata', '1');">Execute</button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
</form>

</div>
<script language="javascript">
	$(document).ready(function(){
		$('#report').change(function(){
		});

		$("input[name=actualRun2]").change(function(){
			var value = $('input[name=actualRun2]:checked').val();
			if (value == 'Y') {
				$('#isMthEndTRunBox').show();
				$('#isMthEndTRun').attr('checked', true);
				$('#isMthEndTRunBox').addClass('highlightBox');
			} else if (value == 'N') {
				$('#isMthEndTRunBox').hide();
			}
		});

		$("input[name=actualRun2]").change(function(){
			var value = $('input[name=actualRun2]:checked').val();
			if (value == 'N') {
				$('#startPeriod2-div').attr("style", "visibility: visible");
			} else if (value == 'Y') {
				$('#startPeriod2-div').attr("style", "visibility: hidden");
			}
		});

		$("#isMthEndTRun").change(function(){
			if (this.checked) {
				$('#isMthEndTRunBox').addClass('highlightBox');
			} else {
				$('#isMthEndTRunBox').removeClass('highlightBox');
			}
		});

		$('#input[name=actualRun]').trigger('change');

		$(".pane .btn-prepareExam2payData").click(function(){
			$(this).parents(".pane").animate({ backgroundColor: "#fbc7c7" }, "fast")
			.animate({ backgroundColor: "#F9F3F7" }, "slow")
			$.prompt('All actual run record(s) in the table EXAM2PAY will be cleared!',{
				buttons: { Ok: true, Cancel: false },
				callback: function(v,m,f){
					if (v){
						submit: return submitAction3('prepareExam2payData', 1);
					} else {
						return false;
					}
				},
				prefix:'cleanblue'
			});
		});

		$("#reportPeriod_mm").change(function(){
			prepareExam2payDataRemark();
		});
		$("#reportPeriod_yy").change(function(){
			prepareExam2payDataRemark();
		});

		function prepareExam2payDataRemark(){
			$("#prepareExam2payData-remark").load(
					"getPrepareExam2PayDataRemark.jsp?reportPeriod_yy="+$('#reportPeriod_yy').val() + "&reportPeriod_mm="+$('#reportPeriod_mm').val());

		}
	});

	function submitAction2(cmd, stp) {
		if (document.form2.endPeriod.value == '') {
			document.form2.endPeriod.focus();
			alert("Please input End Date.");
			return false;
		}
		document.form2.command.value = cmd;
		document.form2.step.value = stp;
		document.form2.submit();
		
		showLoadingBox('body', 500, $(window).scrollTop());
		return false;
	}

	function submitAction3(cmd, stp) {
		document.form3.command.value = cmd;
		document.form3.step.value = stp;
		document.form3.submit();
	}

	function submitAction(cmd, stp) {
		if (cmd == 'preparedata' && stp == 2) {
			if (document.form1.endPeriod2.value == '') {
				document.form1.endPeriod2.focus();
				alert("Please input Period. (end date is required)");
				return false;
			}

			if (getRadioCheckedValue(document.form1.actualRun2) == 'Y') {
				$(this).parents(".pane").animate({ backgroundColor: "#fbc7c7" }, "fast")
				.animate({ backgroundColor: "#F9F3F7" }, "slow");
				
				$.prompt('Transaction will be updated. Operation cannot rollback. <br />Confirm to do ACTUAL RUN?',{
					buttons: { Ok: true, Cancel: false },
					callback: function(v,m,f){
						if (v){
							submit: return submitAction('preparedata', 1);
						}
					},
					prefix:'cleanblue'
				});
			} else {
				submitAction('preparedata', 1);
			}
		} else if (stp == 1) {
			if (cmd == 'preparedata') {
				if (document.form1.endPeriod2.value == '') {
					document.form1.endPeriod2.focus();
					alert("Please input Period. (end date is required)");
					return false;
				}
			}
			document.form1.command.value = cmd;
			document.form1.step.value = stp;
			document.form1.submit();
		}
	}

	function clearSearch() {
		//document.search_form.report.value = '';
		checkRadioByObj(document.search_form.reportType, 'IC');
		document.search_form.startPeriod.value = '';
		document.search_form.endPeriod.value = '';
		checkRadioByObj(document.search_form.actualRun, 'N');
	}
</script>

</div>
</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
<% } %>
</body>
</html:html>