<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.Integer.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.*"%>
<%
UserBean userBean = new UserBean(request);

String[] current_year = DateTimeUtil.getCurrentYearRange();
String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");
String site = request.getParameter("site");

String[] current_month = DateTimeUtil.getCurrentMonthRange();
String curent_date = DateTimeUtil.getCurrentDate();

if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital- Stubbs Road";
}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}
System.out.println("[siteFrom]"+userBean.getSiteCode());
ArrayList record = null; 
ArrayList<String> emptyRecord = new ArrayList<String>();

emptyRecord.add("No Record");

if (date_from != null && date_to != null) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT OL.otldate, OL.patno, ");
	sqlStr.append("       PT.PATFNAME,PT.PATGNAME, ");
	sqlStr.append("       DR.DOCFNAME,DR.DOCGNAME, ");
	sqlStr.append("       OC.OTCDESC, OL.OTLCMT ");
	sqlStr.append("FROM OT_LOG@IWEB OL ");
	sqlStr.append("LEFT JOIN ");
	sqlStr.append("PATIENT@IWEB PT ON OL.PATNO = PT.PATNO ");
	sqlStr.append("JOIN ");
	sqlStr.append("DOCTOR@IWEB DR ON DR.DOCCODE = OL.DOCCODE_S ");
	sqlStr.append("OR ");
	sqlStr.append("DR.DOCCODE = OL.DOCCODE_E ");
	sqlStr.append("LEFT JOIN ");
	sqlStr.append("OT_CODE@IWEB OC ON OL.OTLRESN = OC.OTCID ");
	sqlStr.append("WHERE OL.OTLSTS <> 'x' ");
	if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
		sqlStr.append("AND OL.OTLOTCM = 50059 ");
	} else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
		sqlStr.append("AND OL.OTLOTCM = 549 ");	
	}
	if (date_from != null && date_from.length() > 0) {
		sqlStr.append("AND OL.OTLDATE >= TO_DATE('");
		sqlStr.append(date_from);
		sqlStr.append(" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') ");
	} else {
		date_from = "";
	}
	if (date_to != null && date_to.length() > 0) {
		sqlStr.append("AND OL.OTLDATE <= TO_DATE('");
		sqlStr.append(date_to);
		sqlStr.append(" 23:59:59', 'dd/MM/YYYY HH24:MI:SS') ");
	} else {
		date_to = "";
	}
	sqlStr.append("ORDER BY OL.OTLDATE, OL.PATNO");
	record = UtilDBWeb.getReportableList(sqlStr.toString());

	if (record.size() > 0) {
		// jasper report
		File reportFile = new File(application.getRealPath("/report/colono_report.jasper"));
		if (reportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

			Map parameters = new HashMap();
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("DateFrom", date_from);
			parameters.put("DateTo", date_to);
			parameters.put("Site", site);
			parameters.put("recordCount",Integer.toString(record.size()));
			parameters.put("siteFrom",userBean.getSiteCode());

			System.out.println("[siteFrom] = "+ parameters.get("siteFrom"));
			
			JasperPrint jasperPrint = 
				JasperFillManager.fillReport(
					jasperReport, 
					parameters, 
					new ReportListDataSource(record) {
						public Object getFieldValue(int index) throws JRException {
							String value = (String) super.getFieldValue(index);
	
							if (index == 7) {
								try {
									String[] temp = value.split("fs17");
									String[] temp1 = temp[1].split("\\\\par");
									StringBuffer buffer = new StringBuffer();
									for(String temp2:temp1){
										 temp2 = temp2.replaceAll("\\}","");
										 buffer.append(temp2.toLowerCase());
									}
									return buffer.toString();
								} catch (Exception e) {
									return "error"+e;
								}
							}
							if(index == 0){
								try{
								SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S");
								Date myDate = formatter.parse(value);		
								SimpleDateFormat formatter2 = new SimpleDateFormat("dd/MM/yyyy");
								String temp = formatter2.format(myDate);		

								return temp;
								} catch(Exception e){
									System.out.println("error:"+e);
								}
							
							}
							return value;
						}
					}
				);

			
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);	
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/pdf");
			JRPdfExporter exporter = new JRPdfExporter();
	        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
	        
	        exporter.exportReport();
			return;
		}
	}

	else {
		// jasper report
		File reportFile = new File(application.getRealPath("/report/colono_report.jasper"));
		if (reportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

			Map parameters = new HashMap();
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("DateFrom", date_from);
			parameters.put("DateTo", date_to);
			parameters.put("Site", site);
			parameters.put("recordCount","no");
			parameters.put("siteFrom",userBean.getSiteCode());

			JasperPrint jasperPrint = 
				JasperFillManager.fillReport(
					jasperReport, 
					parameters, 
					new ReportListDataSource(emptyRecord) {
						public Object getFieldValue(int index) throws JRException {
								return "";
						}	
					}
				);

			
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);	
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/pdf");
			JRPdfExporter exporter = new JRPdfExporter();
	        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
	        
	        exporter.exportReport();
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>

<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%String PageTitle = "Report"; %>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.colonoscopy.report" />
</jsp:include>
 
<form name="search_form" action="colono_report.jsp" target="_blank" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="bigText">
		<td colspan="2" align="center"><%=site %></td>
	</tr>
	<tr class="bigText">
		<td colspan="2" align="center">Colonoscopy - Caecum not reached reason report</td>
	</tr>
	<tr class="bigText">
		<td colspan="2" align="center">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=date_from==null?"":date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			-
			<input type="textfield" name="date_to" id="date_to" class="datepickerfield" value="<%=date_to==null?"":date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)<br>

		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<script language="javascript">
<!--//
	function submitSearch(eid, sid) {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.date_to.value = "";
		document.search_form.date_from.value = "";
	}
//-->
</script>


</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>