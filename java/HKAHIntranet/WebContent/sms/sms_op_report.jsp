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

<%!
private ArrayList getSmsRecord() {
	StringBuffer sqlStr = new StringBuffer();
/*	
	sqlStr.append("SELECT 	B.BKGID, B.PATNO, B.BKGPNAME || ' ' || B.BKGPCNAME, P.PATSEX , TRUNC(MONTHS_BETWEEN(sysdate, P.PATBDATE)/ 12), ");
	sqlStr.append("			B.BKGMTEL, R.REGOPCAT, TO_CHAR(R.REGDATE, 'HH24:MI'), ");			
	sqlStr.append("			D.DOCFNAME || ' ' || D.DOCGNAME, replace(B.BKGRMK,'''', '&#146;'), ");
	sqlStr.append("			DECODE(SL.SLPSTS, 'C', 'Close', ");
	sqlStr.append("				   'A', 'Active', ");
	sqlStr.append("				   'R', 'Removed', ");
	sqlStr.append("					SL.SLPSTS) ");
	sqlStr.append("FROM 	BOOKING@IWEB B ");
	sqlStr.append("	 LEFT JOIN PATIENT@IWEB P ON B.PATNO = P.PATNO ");
	sqlStr.append("	 inner join SCHEDULE@IWEB S on B.SCHID = S.SCHID ");
	sqlStr.append("	 left join DOCTOR@IWEB D on S.DOCCODE = D.DOCCODE ");
	sqlStr.append("	 LEFT JOIN REG@IWEB R  ON R.BKGID = B.BKGID ");
	sqlStr.append("	 LEFT JOIN SLIP@IWEB SL ON SL.REGID = R.REGID ");
	sqlStr.append("where    UPPER(B.STECODE) = '" + ConstantsServerSide.SITE_CODE.toUpperCase() + "' ");	
	sqlStr.append("and      B.BKGSDATE >= TO_DATE(TO_CHAR(SYSDATE - 1, 'DD/MM/YYYY')||' 20:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("and      B.BKGEDATE <= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
//sqlStr.append("and      B.BKGSDATE >= TO_DATE('25/03/2015 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
//sqlStr.append("and      B.BKGEDATE <= TO_DATE('25/03/2015 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND      (BKGSTS = 'N' OR BKGSTS = 'F') ");
	sqlStr.append("ORDER BY R.REGDATE, B.PATNO ");
*/


sqlStr.append("SELECT BKGID, PATNO, PATNAME, GENDER, PATBDATE, BKGMTEL, APPT_TIME, REGTIME, DOCNAME, APPT_REMARKS, SLPSTS, REGDATE, REGOPCAT, APPT_DATE, NVL(REGDATE, APPT_DATE) AS ORDER_DATE FROM( ");
sqlStr.append("select  BKGID, PATNO,  BKGPNAME || ' ' || BKGPCNAME  as PATNAME, "); 
sqlStr.append("(select PATSEX from HAT_PATIENT@CIS PAT  where PAT.PATNO = BOOKING.PATNO) as GENDER, ");
sqlStr.append("(select TRUNC(MONTHS_BETWEEN(sysdate, PATBDATE)/ 12) from HAT_PATIENT@CIS PAT  where PAT.PATNO = BOOKING.PATNO) as PATBDATE, "); 
sqlStr.append("BKGPTEL as BKGMTEL, ");
sqlStr.append("TO_CHAR(BOOKING.BKGSDATE, 'HH24:MI')  as appt_time,  null as REGTIME, ");
sqlStr.append("(select DOCFNAME || ' ' || DOCGNAME  from HAT_SCHEDULE@CIS, HAT_DOCTOR@CIS "); 
sqlStr.append("where HAT_SCHEDULE.SCHID = BOOKING.SCHID and HAT_SCHEDULE.DOCCODE = HAT_DOCTOR.DOCCODE) as DOCNAME, ");
sqlStr.append("replace(BKGRMK,'''', '&#146;') as APPT_REMARKS , "); 
sqlStr.append("null as SLPSTS, NULL AS REGDATE, 'N' as regopcat , TO_CHAR(BOOKING.BKGSDATE, 'DD/MM/YYYY') AS APPT_DATE ");

sqlStr.append("from hat_booking@CIS booking "); 
sqlStr.append("where bkgsts <> 'F' "); 
sqlStr.append("and booking.bkgsdate >= TO_DATE(TO_CHAR(SYSDATE - 1, 'DD/MM/YYYY')||' 20:00:00', 'DD/MM/YYYY HH24:MI:SS') "); 
sqlStr.append("and BOOKING.BKGSDATE <= TO_DATE(TO_CHAR(SYSDATE , 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
sqlStr.append("and bkgsts NOT IN ('B', 'C') ");


sqlStr.append("UNION ");  


sqlStr.append("select  BKGID,PATNO, (select NVL(PATFNAME, ' ') || ' ' || NVL(PATGNAME, ' ') || ' ' || patcname from HAT_PATIENT@CIS PAT ");
sqlStr.append("where PAT.PATNO = QRY_REG.PATNO) as PATNAME, ");  
sqlStr.append("(select PATSEX from HAT_PATIENT@CIS PAT where PAT.PATNO = QRY_REG.PATNO) as GENDER, ");
sqlStr.append("(select TRUNC(MONTHS_BETWEEN(sysdate, PATBDATE)/ 12) from HAT_PATIENT@CIS PAT where PAT.PATNO = QRY_REG.PATNO) as PATBDATE, ");
sqlStr.append("(select BKGMTEL from BOOKING@IWEB X where X.BKGID=QRY_REG.BKGID) as BKGMTEL, ");
     
sqlStr.append("(select TO_CHAR(bkgsdate, 'HH24:MI') from hat_booking@CIS booking where booking.bkgid = QRY_REG.bkgid) as appt_time , TO_CHAR(REGDATE, 'HH24:MI') AS REGTIME , ");
sqlStr.append("(select DOCFNAME || ' ' || DOCGNAME from HAT_DOCTOR@CIS DOC where DOC.DOCCODE = QRY_REG.DOCCODE) DOCNAME, ");
sqlStr.append("(select replace(BKGRMK,'''', '&#146;') from BOOKING@IWEB X where X.BKGID=QRY_REG.BKGID) as BKG_REMARKS, ");
        
sqlStr.append("(select DECODE(SL.SLPSTS, 'C', 'Close',   'A', 'Active',  'R', 'Removed', SL.SLPSTS) from SLIP@IWEB SL WHERE SL.SLPNO=QRY_REG.SLPNO), ");
sqlStr.append("TO_CHAR(REGDATE, 'DD/MM/YYYY') , regopcat,  ");
sqlStr.append("(select TO_CHAR(BKGSDATE, 'DD/MM/YYYY') from HAT_BOOKING@CIS BOOKING where BOOKING.BKGID = QRY_REG.BKGID) as APPT_DATE ");
sqlStr.append("   FROM QRY_REG@CIS ");
sqlStr.append("where 1 = 1 "); 
sqlStr.append("and qry_reg.regdate >= TO_DATE(TO_CHAR(SYSDATE - 1, 'DD/MM/YYYY')||' 20:00:00', 'DD/MM/YYYY HH24:MI:SS') "); 
sqlStr.append("and QRY_REG.REGDATE <= TO_DATE(TO_CHAR(SYSDATE , 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
sqlStr.append("and QRY_REG.REGTYPE = 'O' ");
sqlStr.append("and  REGSTS not in ('B', 'C') ");
sqlStr.append(") ");
sqlStr.append("ORDER BY ORDER_DATE, REGTIME, APPT_TIME, PATNO ");




System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>

<%
UserBean userBean = new UserBean(request);


ArrayList record = null;
ReportableListObject row = null;

File reportFile = new File(application.getRealPath("/report/RPT_SMS_OP_REPORT.jasper"));
if (reportFile.exists()) {
	JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	
	Map parameters = new HashMap();
	File reportDir = new File(application.getRealPath("/report/"));
	parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
	parameters.put("SubDataSource", new ReportListDataSource(getSmsRecord()));
	//parameters.put("Site", site);
	
	JasperPrint jasperPrint =
		JasperFillManager.fillReport(
			jasperReport,
			parameters,
			new ReportListDataSource(getSmsRecord()));
	
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

				<form name="search_form" action="smsReport.jsp" method="post" target="_blank">
					<table cellpadding="0" cellspacing="5"
						class="contentFrameSearch" border="0">
						
						<tr class="smallText">
							<td colspan="4" align="center">
								<button onclick="return genRptByDate();">Generate Report</button>
							</td>
						</tr>
					</table>
				</form>

				<script language="javascript">
				<!--//
					function genRptByDate() {
						document.search_form.submit();
					}
				//-->
				</script>
			</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>  