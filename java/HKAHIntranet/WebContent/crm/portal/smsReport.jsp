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
private ArrayList getSmsRecord(String dateFrom, String dateTo) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT C.CRM_CLIENT_ID, C.CRM_LASTNAME || ',' || C.CRM_FIRSTNAME, S.REV_AREA_CODE, S.REV_MOBILE, upper(S.SMCID), DECODE(S.MSG_LANG, 'UTF8', 'CHI', 'ENG'), '', "); 
	sqlStr.append("DECODE(S.NO_OF_MSG, null, 0, S.NO_OF_MSG), DECODE(S.SUCCESS, 1, S.NO_OF_SUCCESS, 0), DECODE(CS.CO_STAFFNAME, null, S.SENDER, "); 
	sqlStr.append("CS.CO_STAFFNAME), TO_CHAR(S.SEND_TIME, 'DD/MM/YYYY HH24:MI'), DECODE(S.SUCCESS, '1', 'Yes', 'No'), ");
	sqlStr.append("S.RES_MSG, TO_CHAR(S.CREATE_DATE, 'DD/MM/YYYY'), S.NO_OF_SUCCESS ");
	sqlStr.append("from SMS_LOG S, CRM_CLIENTS C, CO_USERS U, CO_STAFFS CS ");
	sqlStr.append("where S.ACT_TYPE = 'LMC' "); 
	sqlStr.append("and   S.KEY_ID = C.CRM_CLIENT_ID(+) "); 
	sqlStr.append("AND   S.KEY_ID IS NOT NULL ");
	sqlStr.append("AND   S.SENDER = U.CO_USERNAME(+) ");
	sqlStr.append("AND   U.CO_STAFF_ID = CS.CO_STAFF_ID(+) ");
	sqlStr.append("AND   S.CREATE_DATE >= TO_DATE('"+dateFrom+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND   S.CREATE_DATE <= TO_DATE('"+dateTo+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("ORDER BY S.CREATE_DATE, S.SUCCESS DESC "); 
			
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>

<%
UserBean userBean = new UserBean(request);
String site = request.getParameter("site");
String searchYearFrom = request.getParameter("searchYearFrom_ByDate_yy");
String searchYearTo = request.getParameter("searchYearTo_ByDate_yy");
String searchMonthFrom = request.getParameter("searchYearFrom_ByDate_mm");
String searchMonthTo = request.getParameter("searchYearTo_ByDate_mm");
String searchDayFrom = request.getParameter("searchYearFrom_ByDate_dd");
String searchDayTo = request.getParameter("searchYearTo_ByDate_dd");

if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital- Stubbs Road";
}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}

ArrayList record = null;
ReportableListObject row = null;

if (searchYearFrom != null && searchYearFrom.length() > 0) {
	File reportFile = new File(application.getRealPath("/report/RPT_CRM_SMS_REPORT_Portrait.jasper"));
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("dateFrom", searchDayFrom+"/"+searchMonthFrom+"/"+searchYearFrom);
		parameters.put("dateTo", searchDayTo+"/"+searchMonthTo+"/"+searchYearTo);
		parameters.put("Site", site);
		
		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportListDataSource(getSmsRecord(searchDayFrom+"/"+searchMonthFrom+"/"+searchYearFrom,
														searchDayTo+"/"+searchMonthTo+"/"+searchYearTo)));
		
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		JRPdfExporter exporter = new JRPdfExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../../servlets/image?image=");

        exporter.exportReport();
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

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../../common/header.jsp"/>
	<body>
		<DIV id=contentFrame style="width:100%;height:100%">
				<%String PageTitle = "SMS Report"; %>
				<jsp:include page="../../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="SMS Report" />
					<jsp:param name="category" value="group.crm" />
					<jsp:param name="keepReferer" value="N" />
				</jsp:include>
				<form name="search_form" action="smsReport.jsp" method="post" target="_blank">
					<table cellpadding="0" cellspacing="5"
						class="contentFrameSearch" border="0">
						<tr class="bigText">
							<td colspan="4" align="center"><%=site %></td>
						</tr>
						<tr class="bigText">
							<td colspan="4" align="center">SMS Report</td>
						</tr>	
						<tr><td>&nbsp;</td></tr>
						<tr class="smallText" >
							<td class="infoLabel" width="10%">Start Date</td>
							<td class="infoData" width="40%" >
								<jsp:include page="../../ui/dateCMB.jsp" flush="false"> 
									<jsp:param name="label" value="searchYearFrom_ByDate" />
									<jsp:param name="day_yy" value="<%=searchYearFrom %>" />
									<jsp:param name="yearRange" value="1" />
									<jsp:param name="isYearOnly" value="N" />
									<jsp:param name="showTime" value="N" />
								</jsp:include>
							</td>
							<td class="infoLabel" width="10%">End Date</td>
							<td class="infoData" width="40%" >
								<jsp:include page="../../ui/dateCMB.jsp" flush="false"> 
									<jsp:param name="label" value="searchYearTo_ByDate" />
									<jsp:param name="day_yy" value="<%=searchYearTo %>" />
									<jsp:param name="yearRange" value="1" />
									<jsp:param name="isYearOnly" value="N" />
									<jsp:param name="showTime" value="N" />
								</jsp:include>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr class="smallText">
							<td colspan="4" align="center">
								<button onclick="return genRptByDate();">Generate Report (By Date)</button>
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
<jsp:include page="../../common/footer.jsp" flush="false" />
</body>
</html:html>