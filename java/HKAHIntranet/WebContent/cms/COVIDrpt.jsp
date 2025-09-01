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
<%!
public static ArrayList getData( String date_from, String date_to ) {
	StringBuffer sqlStr = new StringBuffer();
/*
	sqlStr.append("SELECT to_char(date_in, 'yyyy-mm-dd'), 'Done', count(*), ");
	sqlStr.append(" DECODE(m.type, 'I', 'Inpatient', 'O', 'Outpatient', 'C', 'External Referral'), ");
	sqlStr.append(" m.spec_type, ");
	sqlStr.append(" DECODE(m.type, 'C', M.LOCATION, ");	
	sqlStr.append("		DECODE(HAT_GET_PATIENT_CAT(M.HOSPNUM), ");
	sqlStr.append(" 		'Patient', CASE WHEN TO_CHAR(M.DATE_IN, 'yyyymmdd') > TO_CHAR(P.PATRDATE, 'yyyymmdd') THEN 'Patient: current' ELSE 'Patient: new' END, ");
	sqlStr.append(" 		HAT_GET_PATIENT_CAT(M.HOSPNUM))), ");
	sqlStr.append(" M.PRIORITY ");
	sqlStr.append(" FROM labo_masthead@LIS m ");
	sqlStr.append(" JOIN labo_detail@LIS d on m.lab_num = d.lab_num ");
	sqlStr.append(" JOIN patient@iweb p on p.patno = m.hospnum ");	
	sqlStr.append(" WHERE d.test_num in ('WUCPC', 'SARS', 'XSARS') ");
	sqlStr.append(" AND d.test_type <> '0' ");	
	sqlStr.append(" AND spec_type in ('NPS', 'DTS') ");
	sqlStr.append(" AND m.type in ('I', 'O', 'C') ");
	if (date_from != null && date_from.length() == 10) {
		sqlStr.append(" AND M.DATE_IN >= TO_DATE('");
		sqlStr.append(date_from);
		sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
	}
	if (date_to != null && date_to.length() == 10) {
		sqlStr.append(" AND M.DATE_IN <= TO_DATE('");
		sqlStr.append(date_to);
		sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
	}	
	sqlStr.append(" GROUP BY to_char(date_in, 'yyyy-mm-dd'), ");
	sqlStr.append(" m.type, ");
	sqlStr.append(" m.spec_type, ");
	sqlStr.append(" DECODE(m.type, 'C', M.LOCATION, ");	
	sqlStr.append("		DECODE(HAT_GET_PATIENT_CAT(M.HOSPNUM), ");
	sqlStr.append(" 		'Patient', CASE WHEN TO_CHAR(M.DATE_IN, 'yyyymmdd') > TO_CHAR(P.PATRDATE, 'yyyymmdd') THEN 'Patient: current' ELSE 'Patient: new' END, ");
	sqlStr.append(" 		HAT_GET_PATIENT_CAT(M.HOSPNUM))), ");
	sqlStr.append(" M.PRIORITY ");
	
	sqlStr.append(" UNION ");
	
	sqlStr.append(" SELECT to_char(b.bkgsdate, 'yyyy-mm-dd'), 'Apptmt', count(*), ");
	sqlStr.append(" 'Outpatient', ");
	sqlStr.append(" DECODE(be.natureofvisit, 'COVID19N', 'NPS', 'COVID19S', 'DTS'), ");
	sqlStr.append("	NVL2(P.PATNO, ");	
	sqlStr.append("	DECODE(HAT_GET_PATIENT_CAT(P.PATNO), ");
	sqlStr.append(" 		'Patient', CASE WHEN TO_CHAR(b.bkgsdate, 'yyyymmdd') > TO_CHAR(P.PATRDATE, 'yyyymmdd') THEN 'Patient: current' ELSE 'Patient: new' END, ");
	sqlStr.append(" 		HAT_GET_PATIENT_CAT(P.PATNO)), 'Patient: new'), ");
	sqlStr.append(" 'ROUTINE' ");
	sqlStr.append(" FROM booking@IWEB b ");			
	sqlStr.append(" JOIN booking_extra@IWEB be on b.bkgid = be.bkgid ");
	sqlStr.append(" LEFT JOIN patient@IWEB p on p.patno = b.patno ");
	sqlStr.append(" WHERE be.natureofvisit in ('COVID19N', 'COVID19S') AND b.bkgsts <> 'C' ");
	sqlStr.append(" AND b.bkgsts <> 'C' ");
	if (date_from != null && date_from.length() == 10) {
		sqlStr.append(" AND b.bkgsdate >= TO_DATE('");
		sqlStr.append(date_from);
		sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
	}
	if (date_to != null && date_to.length() == 10) {
		sqlStr.append(" AND b.bkgsdate <= TO_DATE('");
		sqlStr.append(date_to);
		sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
	}
	sqlStr.append(" GROUP BY to_char(b.bkgsdate, 'yyyy-mm-dd'), ");
	sqlStr.append(" be.natureofvisit, ");
	sqlStr.append("	NVL2(P.PATNO, ");	
	sqlStr.append("	DECODE(HAT_GET_PATIENT_CAT(P.PATNO), ");
	sqlStr.append(" 		'Patient', CASE WHEN TO_CHAR(b.bkgsdate, 'yyyymmdd') > TO_CHAR(P.PATRDATE, 'yyyymmdd') THEN 'Patient: current' ELSE 'Patient: new' END, ");
	sqlStr.append(" 		HAT_GET_PATIENT_CAT(P.PATNO)), 'Patient: new') ");
	
	sqlStr.append(" ORDER BY 7, 4 desc, 6 desc, 1 ");
*/
	sqlStr.append("SELECT ");
sqlStr.append(" to_char(date_in, 'yyyy-mm-dd'), ");
sqlStr.append("	DECODE(HAT_GET_PATIENT_CAT(M.HOSPNUM), ");
sqlStr.append("  'Patient', CASE WHEN TO_CHAR(M.DATE_IN, 'yyyymmdd') > TO_CHAR(P.PATRDATE, 'yyyymmdd') THEN 'Current' ELSE 'New' END, ");
sqlStr.append("  HAT_GET_PATIENT_CAT(M.HOSPNUM)), ");
sqlStr.append(" count(*), ");
sqlStr.append(" m.spec_type, ");
sqlStr.append(" M.LOCATION, ");	
sqlStr.append(" DECODE(M.PRIORITY, 'ROUTINE', '1. ROUTINE', '2. ' || M.PRIORITY) || ' (Done)' ");
	sqlStr.append(" FROM labo_masthead@LIS m ");
	sqlStr.append(" JOIN labo_detail@LIS d on m.lab_num = d.lab_num ");
	sqlStr.append(" JOIN patient@iweb p on p.patno = m.hospnum ");	
	sqlStr.append(" WHERE d.test_num in ('WUCPC', 'SARS', 'XSARS', 'HC', 'XHC') ");
	sqlStr.append(" AND d.test_type <> '0' ");	
	sqlStr.append(" AND spec_type in ('NPS', 'DTS') ");
	sqlStr.append(" AND m.type in ('I', 'O', 'C') ");
	if (date_from != null && date_from.length() == 10) {
		sqlStr.append(" AND M.DATE_IN >= TO_DATE('");
		sqlStr.append(date_from);
		sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
	}
	if (date_to != null && date_to.length() == 10) {
		sqlStr.append(" AND M.DATE_IN <= TO_DATE('");
		sqlStr.append(date_to);
		sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
	}	
	sqlStr.append(" GROUP BY ");
	sqlStr.append(" M.PRIORITY, ");
	sqlStr.append(" m.spec_type, ");
	sqlStr.append(" M.LOCATION, ");	
	sqlStr.append(" to_char(date_in, 'yyyy-mm-dd'), ");
	sqlStr.append("	DECODE(HAT_GET_PATIENT_CAT(M.HOSPNUM), ");
	sqlStr.append("  'Patient', CASE WHEN TO_CHAR(M.DATE_IN, 'yyyymmdd') > TO_CHAR(P.PATRDATE, 'yyyymmdd') THEN 'Current' ELSE 'New' END, ");
	sqlStr.append("  HAT_GET_PATIENT_CAT(M.HOSPNUM)) ");

	sqlStr.append(" UNION ");
	
	sqlStr.append(" SELECT ");
sqlStr.append(" to_char(b.bkgsdate, 'yyyy-mm-dd'), ");
sqlStr.append("	NVL2(P.PATNO, ");	
sqlStr.append("	 DECODE(HAT_GET_PATIENT_CAT(P.PATNO), ");
sqlStr.append("  'Patient', CASE WHEN TO_CHAR(b.bkgsdate, 'yyyymmdd') > TO_CHAR(P.PATRDATE, 'yyyymmdd') THEN 'Current' ELSE 'New' END, ");
sqlStr.append("  HAT_GET_PATIENT_CAT(P.PATNO)), 'New'), ");
sqlStr.append(" count(*), ");
sqlStr.append(" DECODE(be.natureofvisit, 'COVID19N', 'NPS', 'COVID19S', 'DTS'), ");
sqlStr.append(" 'Outpatient', ");
sqlStr.append(" '3. ROUTINE (Appointment)' ");
	sqlStr.append(" FROM booking@IWEB b ");			
	sqlStr.append(" JOIN booking_extra@IWEB be on b.bkgid = be.bkgid ");
	sqlStr.append(" LEFT JOIN patient@IWEB p on p.patno = b.patno ");
	sqlStr.append(" WHERE be.natureofvisit in ('COVID19N', 'COVID19S') AND b.bkgsts <> 'C' ");
	sqlStr.append(" AND b.bkgsts <> 'C' ");
	if (date_from != null && date_from.length() == 10) {
		sqlStr.append(" AND b.bkgsdate >= TO_DATE('");
		sqlStr.append(date_from);
		sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
	}
	if (date_to != null && date_to.length() == 10) {
		sqlStr.append(" AND b.bkgsdate <= TO_DATE('");
		sqlStr.append(date_to);
		sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
	}
	sqlStr.append(" GROUP BY ");
	sqlStr.append(" be.natureofvisit, ");
	sqlStr.append(" to_char(b.bkgsdate, 'yyyy-mm-dd'), ");
	
	sqlStr.append("	NVL2(P.PATNO, ");	
	sqlStr.append("	DECODE(HAT_GET_PATIENT_CAT(P.PATNO), ");
	sqlStr.append(" 		'Patient', CASE WHEN TO_CHAR(b.bkgsdate, 'yyyymmdd') > TO_CHAR(P.PATRDATE, 'yyyymmdd') THEN 'Current' ELSE 'New' END, ");
	sqlStr.append(" 		HAT_GET_PATIENT_CAT(P.PATNO)), 'New') ");
	sqlStr.append(" ORDER BY 6 ");

	//System.out.println("[COVIDrpt DEBUG] sql:" + sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

Calendar calendar = Calendar.getInstance();
String currentDate = DateTimeUtil.formatDate(calendar.getTime());

String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");
String priority = request.getParameter("priority");

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

if ("report".equals(command)) {
	ArrayList record = getData(date_from, date_to);

	File reportFile = new File(application.getRealPath("/report/RPT_COVID2.jasper"));
	if (reportFile.exists()) {
		
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
		Map parameters = new HashMap();
		File reportDir = new File(application.getRealPath("/report/"));
		
		String title = "COVID MANAGEMENT REPORT";
	
		parameters.put("REPORT_TITLE", title);
	
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
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.covid.report" />
</jsp:include>
<form name="search_form" action="COVIDrpt.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Selection Criteria</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">From :</td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" value="<%=date_from==null?currentDate:date_from %>" /> (DD/MM/YYYY)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">To :</td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_to" id="date_to" class="datepickerfield" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" value="<%=date_to==null?currentDate:date_to %>" /> (DD/MM/YYYY)
		</td>
	</tr>
	<tr class="smallText">
		<td align="center" colspan="2">
			<button type="submit">Generate</button>	
		</td>
	</tr>
</table>
<input type="hidden" name="command" id="command" value="report" />	
</form>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>