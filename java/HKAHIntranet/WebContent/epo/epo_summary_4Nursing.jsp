<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%!
// production

private ArrayList getHkahRecord(String fromDate, String toDate) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT REQ_NO, REQ_DATE, ");
	sqlStr.append("(SELECT CD.CO_DEPARTMENT_DESC FROM CO_DEPARTMENTS CD WHERE CD.CO_DEPARTMENT_CODE = REQ_DEPT_CODE) AS DEPT_DESC,");	
	sqlStr.append("REQ_DESC,");
	sqlStr.append("(SELECT CS.CO_STAFFNAME FROM CO_STAFFS CS WHERE CS.CO_STAFF_ID = APPROVED_BY AND CS.CO_SITE_CODE = 'hkah') AS APPROVED_BY,"); 
	sqlStr.append("REQ_DESC AS SUPPLIER_NAME, AMOUNT, (NVL(BUDGET_CODE,'NIL')||'/'||NVL(AD_COUNCIL_NO,'NIL')||'/'||NVL(BOARD_COUNCIL_NO,'NIL')||'/'||NVL(FINANCE_COMM_NO,'NIL')) AS BUDGET_CODE ");
	sqlStr.append("FROM"); 
	sqlStr.append("(SELECT M.REQ_NO, TO_CHAR(M.REQ_DATE,'DD/MM/YYYY') AS REQ_DATE, M.REQ_DEPT_CODE, M.REQ_DESC, M.APPROVED_BY, D.SUPPLIER_NAME, SUM(D.REQ_AMOUNT) AS AMOUNT, M.BUDGET_CODE, M.AD_COUNCIL_NO, M.BOARD_COUNCIL_NO, M.FINANCE_COMM_NO, ");
	sqlStr.append("(SELECT EB.CODE FROM EPO_BUDGET EB WHERE EB.CODE = M.BUDGET_CODE AND EB.TYPE = 'BC') AS BC_DESC, (SELECT EB.CODE FROM EPO_BUDGET EB WHERE EB.CODE = M.AD_COUNCIL_NO AND EB.TYPE = 'AC') AS AC_DESC ");	
	sqlStr.append(" FROM EPO_REQUEST_M M, EPO_REQUEST_D D ");
	sqlStr.append("WHERE M.REQ_NO = D.REQ_NO(+) ");
	sqlStr.append("AND M.REQ_NO IS NOT NULL ");
	sqlStr.append("AND D.REQ_NO IS NOT NULL ");
	sqlStr.append("AND M.REQ_STATUS NOT IN ('C','R') ");
	sqlStr.append("AND M.REQ_DATE >= TO_DATE('"+fromDate+" 00:00', 'dd/mm/yyyy hh24:mi') ");
	sqlStr.append("AND M.REQ_DATE < TO_DATE('"+toDate+" 00:00', 'dd/mm/yyyy hh24:mi') + 1 ");	
	sqlStr.append("GROUP BY M.REQ_NO, TO_CHAR(M.REQ_DATE,'DD/MM/YYYY'), M.REQ_DEPT_CODE, M.REQ_DESC, M.APPROVED_BY, D.SUPPLIER_NAME, M.BUDGET_CODE, M.AD_COUNCIL_NO, M.BOARD_COUNCIL_NO, M.FINANCE_COMM_NO ");
	sqlStr.append("HAVING SUM(D.REQ_AMOUNT)< =10000 ");
	sqlStr.append("AND M.REQ_DEPT_CODE IN ('330','140','120','110','150','220','370','375','200','210','160','365','100','130','310','362') ");
	sqlStr.append(") ORDER BY 3, 1 ");
	System.err.println("[getHkahRecord]:"+sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

%>
<%
UserBean userBean = new UserBean(request);
SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMddHHmmss");
String command = ParserUtil.getParameter(request, "command");
String fromDate = request.getParameter("date_from");
String toDate = request.getParameter("date_to");
String type = ParserUtil.getParameter(request, "type");
String jasperName = null;
String jasperName_sub1 = null;
String jasperName_sub2 = null;
ArrayList record = null;
ReportableListObject row = null;
System.err.println("[type]:"+type+";");
if(type!=null && type.length()>0){
	if("pdf".equals(type)){
		jasperName = "/report/epo_summary_4Nursing.jasper";
		jasperName_sub1 = "/report/epo_summary_Sub1.jasper";
	}else if("xls".equals(type)){
		jasperName = "/report/epo_summary_4Nursing_xls.jasper";
		jasperName_sub1 = "/report/epo_summary_xls_Sub1.jasper";	
	}else{
		jasperName = "/report/epo_summary_4Nursing.jasper";
		jasperName_sub1 = "/report/epo_summary_Sub1.jasper";	
	}
	File reportFile = new File(application.getRealPath(jasperName));
	File subReportFile1 = new File(application.getRealPath(jasperName_sub1));

	if (reportFile.exists()) {
		if("pdf".equals(type) || "xls".equals(type)){
			System.err.println("2[type]:"+type);		
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

			File reportDir = new File(application.getRealPath("/report/"));

			Map parameters = new HashMap();
			parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
			parameters.put("fromDate",fromDate);
			parameters.put("toDate",toDate);
			parameters.put("SubDataSource", 
					new ReportMapDataSource(getHkahRecord(fromDate,toDate), new String[]{"REQ_NO", "REQ_DATE", "DEPT_DESC", "REQ_DESC", "APPROVED_BY", "SUPPLIER_NAME", "AMOUNT", "BUDGET_CODE"}, new boolean[]{false,false,false,false,false,false,true,false}));			
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport, parameters, new JREmptyDataSource(1));
			
			if("pdf".equals(type)){
				System.err.println("3[type]:"+type);			
				request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
				OutputStream ouputStream = response.getOutputStream();			
				response.setContentType("application/pdf");
				JRPdfExporter exporter = new JRPdfExporter();
				exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
				exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
				exporter.exportReport();			
			}else if("xls".equals(type)){
				System.err.println("4[type]:"+type);			
				request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
				OutputStream ouputStream = response.getOutputStream();			
				response.setContentType("application/vnd.ms-excel");
				JRXlsExporter exporterXLS = new JRXlsExporter();
				response.setHeader("Content-Disposition", "attachment;filename=EPOSummary_" + tsFormat.format(new Date()) + ".xls");
				exporterXLS.setParameter(JRXlsExporterParameter.JASPER_PRINT, jasperPrint);
				exporterXLS.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, ouputStream);
				exporterXLS.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
				exporterXLS.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, false);
				exporterXLS.setParameter(JRXlsExporterParameter.IS_AUTO_DETECT_CELL_TYPE, true);
				exporterXLS.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, false);
				exporterXLS.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, true);
				exporterXLS.exportReport();				
			}
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
	<DIV id=indexWrapper>
		<DIV id=mainFrame>
			<DIV id=contentFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="EPO Summary(For Nursing)" />
					<jsp:param name="category" value="Report" />
				</jsp:include>

				<form name="search_form" action="epo_summary_4Nursing.jsp" method="get">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.reqDate" />
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="date_from" id="date_from" 
									class="datepickerfield" value="<%=fromDate==null?"":fromDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								-
								<input type="textfield" name="date_to" id="date_to" 
									class="datepickerfield" value="<%=toDate==null?"":toDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>							
							<td width="20%">
								<button onclick="return submitReport('pdf');"><bean:message key="button.doc.view" />(pdf)</button>
								<button onclick="return submitReport('xls');"><bean:message key="button.doc.view" />(xls)</button>								
								<input type="hidden" name="command" />
								<input type="hidden" name="type" />								
							</td>							
						</tr>						
					</table>
				</form>

				<script language="javascript">
				function submitReport(cmd) {
					document.search_form.type.value = cmd;		
					document.search_form.submit();					
				}
			
				</script>
			</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>   