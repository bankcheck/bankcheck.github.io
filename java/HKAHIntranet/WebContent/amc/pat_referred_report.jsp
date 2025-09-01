<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>

<%!
private ArrayList getSmsRecord() {
	String itmcodeAnes = (ConstantsServerSide.isTWAH() ? "AN1G" : "DFA");
	String deptCodesDI = (ConstantsServerSide.isTWAH() ? "'240-','280-','340-', '350-'" : "'410-','240-','340-', '245-', '280-'");
	String deptCodesRehab = (ConstantsServerSide.isTWAH() ? "'390-'" : "'390-', '440-'");
	String drFeeColumn = (ConstantsServerSide.isTWAH() ? "b.itmtype='D' and b.itmcode <> '" + itmcodeAnes + "'" : 
		"substr(glccode,5,4) in ('5650','5450','5250') and b.itmcode <> '" + itmcodeAnes + "'");
	
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("select slptype, patno, slpno, doccode, docfname, docgname, patfname, patgname ");
	sqlStr.append(", to_char(min(stntdate), 'yyyy-mm-dd') as First_Capture_Date ");     
	sqlStr.append(", sum(case when category='DR.FEE' then stnnamt end) as Dr ");
	sqlStr.append(", sum(case when category='ANES' then stnnamt end) as Anes ");
	sqlStr.append(", sum(case when category='PHAR' then stnnamt end) as Rx ");
	sqlStr.append(", sum(case when category='LAB' then stnnamt end) as Lab ");
	sqlStr.append(", sum(case when category='DI' then stnnamt end) as DI ");
	sqlStr.append(", sum(case when category='REHAB' then stnnamt end) as Rehab ");
	sqlStr.append(", sum(case when category='OT' then stnnamt end) as OT ");
	sqlStr.append(", sum(case when category='CPLab' then stnnamt end) as CPLab ");
	sqlStr.append(", sum(case when category='CCIC' then stnnamt end) as CCIC ");
	sqlStr.append(", sum(case when category='ENDO' then stnnamt end) as ENDO ");
	sqlStr.append(", sum(case when category='OTHER' then stnnamt end) as Other ");
	sqlStr.append(", sum(stnnamt) as Total "); 
	sqlStr.append("from "); 
	sqlStr.append("( SELECT SLPTYPE, A.PATNO, A.SLPNO, PATREFNO, c.DOCCODE, DOCFNAME, DOCGNAME, ");
	sqlStr.append("(SELECT PATFNAME FROM TMP_AMC_SLIP T WHERE T.SLPNO=A.SLPNO) AS PATFNAME, ");
	sqlStr.append("(select patgname from tmp_amc_slip t where t.slpno=a.slpno) as patgname, ");
	sqlStr.append("b.itmcode, b.itmtype, stnnamt, stnsts , stntdate ");
	sqlStr.append(", ( select regdate from reg@iweb r where r.regid=a.regid) as regdate ");
	sqlStr.append(", ( case when " + drFeeColumn + " then 'DR.FEE' ");
	sqlStr.append("when b.itmcode ='" + itmcodeAnes + "' then 'ANES' ");
	sqlStr.append("when substr(glccode,1,4)='380-' then 'PHAR' ");
	sqlStr.append("when substr(glccode,1,4)='230-' then 'LAB' ");
	sqlStr.append("when substr(glccode,1,4) in (" + deptCodesDI + ")  then 'DI' ");
	sqlStr.append("when substr(glccode,1,4) in (" + deptCodesRehab + ") then 'REHAB' ");
	sqlStr.append("when substr(glccode,1,4)='360-' then 'OT' ");
	sqlStr.append("when substr(glccode,1,4)='210-' then 'CPLab' "); 
	sqlStr.append("when substr(glccode,1,4)='200-' then 'CCIC' ");
	sqlStr.append("when substr(glccode,1,4)='365-' then 'ENDO' ");
	sqlStr.append("else 'OTHER' end) as category ");
	sqlStr.append("from slip@iweb a, sliptx@iweb b, doctor@iweb c, item@iweb d ");
	sqlStr.append("where a.slpno=b.slpno  and a.doccode=c.doccode ");
	sqlStr.append("AND B.ITMCODE=D.ITMCODE ");
	sqlStr.append("and a.slpno in (select slpno from TMP_AMC_SLIP) ");
	sqlStr.append("and stnsts in ('N', 'A')  and b.itmcode <> 'PAYME'  and b.itmcode <> 'REF' ");
	sqlStr.append("and itmcat <> 'O' ");
	sqlStr.append(") tempTable "); 
	sqlStr.append("group by slptype, patno, slpno, doccode, docfname, docgname, patfname, patgname ");
	sqlStr.append("order by patno, slpno ");
	
	//System.out.println("[amc pat_referred_report] sql=" + sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
ArrayList record = null;
ReportableListObject row = null;
UtilDBWeb.executeFunction("PROC_AMC_PAT_REF_UPDATE()");
File reportFile = new File(application.getRealPath("/report/PAT_REF_REPORT.jasper"));
if (reportFile.exists()) {
	JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	
	Map parameters = new HashMap();
	File reportDir = new File(application.getRealPath("/report/"));
	parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
	parameters.put("SubDataSource", new ReportListDataSource(getSmsRecord()));
	parameters.put("Site", ConstantsServerSide.SITE_CODE);
	
	
	JasperPrint jasperPrint =
		JasperFillManager.fillReport(
			jasperReport,
			parameters,
			new ReportListDataSource(getSmsRecord()));
	
	request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
	OutputStream ouputStream = response.getOutputStream();
	response.setHeader("Content-disposition","attachment;filename="+ "report.xls" ); 
	response.setContentType("application/vnd.ms-excel");
	JRXlsExporter exporter = new JRXlsExporter();
    exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
    exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
    exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
    exporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, false);
    exporter.setParameter(JRXlsExporterParameter.IS_AUTO_DETECT_CELL_TYPE, false);
    exporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, false);
    exporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, true);
    exporter.exportReport();
    ouputStream.flush();
    ouputStream.close();
	return;		
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
					<jsp:param name="pageTitle" value="OP List" />
					<jsp:param name="category" value="Report" />
				</jsp:include>

				<form name="search_form" action="pat_referred_report.jsp" method="get">
					<table cellpadding="0" cellspacing="5"
						class="contentFrameSearch" border="0">
						
						<tr class="smallText">
							<td colspan="4" align="center">
								<button onclick="return submitReport('view');"><bean:message key="button.doc.view" /></button>
								<input type="hidden" name="command" />
							</td>
						</tr>
					</table>
				</form>

				<script language="javascript">
				function submitReport(cmd) {	
					document.search_form.command.value = cmd;		
					document.search_form.submit();					
				}
			
				</script>
			</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>   