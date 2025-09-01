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
private ArrayList getSmsRecord(String dateFrom, String dateTo, String type, String dept) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT B.PATNO, ");
	if(type.equals("inpatient")||type.equals("oncology")) {
		sqlStr.append("B.BPBPNAME, ");
	} else if(type.equals("inpatdisch")) {
		sqlStr.append("B.PATFNAME||' '||B.PATGNAME as BPBPNAME, ");
	} else if(type.equals("cplab")) {
		sqlStr.append("B.DEPTAFNAME||' '||B.DEPTAGNAME as BPBPNAME, ");
	}else {
		sqlStr.append("BKGPNAME, ");
	}
	sqlStr.append("S.REV_AREA_CODE, S.REV_MOBILE, ");
	if(type.equals("inpatient")||type.equals("oncology")||type.equals("inpatdisch")||type.equals("cplab")) {
		sqlStr.append("upper(S.SMCID), DECODE(S.MSG_LANG, 'UTF8', 'CHI', 'ENG'), ");
	}else {
		sqlStr.append("SC.SMCDESC, S.TEMPLATE_LANG, ");
	}
	sqlStr.append("'', DECODE(S.NO_OF_MSG, null, 0, S.NO_OF_MSG), DECODE(S.SUCCESS, 1, S.NO_OF_SUCCESS, 0), DECODE(CS.CO_STAFFNAME, null, S.SENDER, CS.CO_STAFFNAME), ");
	sqlStr.append("TO_CHAR(S.SEND_TIME, 'DD/MM/YYYY HH24:MI'), DECODE(S.SUCCESS, '1', 'Yes', 'No'), ");
	sqlStr.append("S.RES_MSG, TO_CHAR(S.CREATE_DATE, 'DD/MM/YYYY'), S.NO_OF_SUCCESS ");
	
	if(type.equals("inpatient")||type.equals("oncology")) {
		sqlStr.append("FROM SMS_LOG S, (SELECT  PATNO, TO_CHAR(PBPID) AS PBPID, BPBPNAME FROM BEDPREBOK@IWEB) B, CO_USERS U, CO_STAFFS CS ");
	} else if(type.equals("inpatdisch")) {
		sqlStr.append("FROM SMS_LOG S, PATIENT@IWEB B, CO_USERS U, CO_STAFFS CS ");
	} else if(type.equals("cplab")) {
		sqlStr.append("FROM SMS_LOG S, DEPT_APP@IWEB B, CO_USERS U, CO_STAFFS CS ");		
	}else {
		sqlStr.append("FROM SMS_LOG S, BOOKING@IWEB B, CO_USERS U, CO_STAFFS CS, SMSCONTENT@IWEB SC ");
	}
	System.err.println("[type]:"+type);
	if(type.equals("inpatient")||type.equals("oncology")||type.equals("inpatdisch")||type.equals("cplab")) {
		if(type.equals("inpatient")){
			sqlStr.append("WHERE S.ACT_TYPE = 'INPAT' ");
			sqlStr.append("AND   S.KEY_ID = B.PBPID(+) ");
			sqlStr.append("AND   S.KEY_ID IS NOT NULL ");
		} else if (type.equals("oncology")){ 
			sqlStr.append("WHERE S.ACT_TYPE = 'ONCOLOGY' ");
			sqlStr.append("AND   S.SMCID = '4' ");
			sqlStr.append("AND   S.KEY_ID = B.PBPID(+) ");
			sqlStr.append("AND   S.KEY_ID IS NOT NULL ");
		} else if (type.equals("inpatdisch")){ 
			sqlStr.append("WHERE S.ACT_TYPE = 'INPATDISCH' ");
			sqlStr.append("AND   SUBSTR(KEY_ID,1,6) = B.PATNO(+) ");
			sqlStr.append("AND   S.KEY_ID IS NOT NULL ");
		} else if (type.equals("cplab")){			
			sqlStr.append("WHERE S.ACT_TYPE = 'CPLAB' ");
			sqlStr.append("AND   KEY_ID = B.DEPTAID(+) ");
			sqlStr.append("AND   S.KEY_ID IS NOT NULL ");			
		}
	}
	else {
		System.err.println("2[type]:"+type);		
		if (type.equals("rehab")){
			sqlStr.append("WHERE S.ACT_TYPE = 'REHAB' ");
			sqlStr.append("AND   S.KEY_ID = B.BKGID(+) ");
			sqlStr.append("AND   S.KEY_ID IS NOT NULL ");
		} else if (type.equals("foodservice")){ 
			sqlStr.append("WHERE S.ACT_TYPE = 'FOODSERVICE' ");
			sqlStr.append("AND   S.KEY_ID = B.BKGID(+) ");
			sqlStr.append("AND   S.KEY_ID IS NOT NULL ");
		} else {
			sqlStr.append("WHERE S.ACT_TYPE = 'OUTPAT' ");
			sqlStr.append("AND   S.KEY_ID = B.BKGID(+) ");
			sqlStr.append("AND   S.KEY_ID IS NOT NULL ");
		}
	}
	sqlStr.append("AND   S.SENDER = U.CO_USERNAME(+) ");
	sqlStr.append("AND   U.CO_STAFF_ID = CS.CO_STAFF_ID(+) ");
	sqlStr.append("AND   S.CREATE_DATE >= TO_DATE('"+dateFrom+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND   S.CREATE_DATE <= TO_DATE('"+dateTo+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	if(type.equals("inpatient")||type.equals("oncology")||type.equals("inpatdisch")||type.equals("cplab")) {
	}
	else {
		sqlStr.append("AND   S.SMCID = SC.SMCID(+) ");
		if (type.equals("rehab")){
			sqlStr.append("AND	S.SMCID IN ('5', '6', '7','8') ");
		} else if (type.equals("foodservice")){
			sqlStr.append("AND	S.SMCID IN ('9') ");
		} else {
			if(!dept.equals("0")) {
				sqlStr.append("AND	S.SMCID = '"+dept+"' ");
			}
			else {
				if (type.equals("outpatient")) {
					sqlStr.append("AND	S.SMCID IN ('1', '2', '3') ");
				} 
			}
		}
	}
		
	sqlStr.append("ORDER BY S.CREATE_DATE, S.SUCCESS DESC ");
	
	System.out.println(sqlStr.toString());
	
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
String type = request.getParameter("type");
String dept = request.getParameter("dept");
String funID = "";
if(type.equals("inpatient")){
	funID = "function.sms.report2";
}else if(type.equals("oncology")){
	funID = "function.sms.report3";
}else if(type.equals("rehab")){
	funID = "function.sms.report4";
}else if(type.equals("foodservice")){
	funID = "function.sms.report5";
}else if(type.equals("inpatdisch")){
	funID = "function.sms.report6";	
}else if(type.equals("cplab")){
	funID = "function.cpLabSMSSend.report";	
}else{
	funID = "function.sms.report1";
}

if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital - Stubbs Road";
}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}

ArrayList record = null;
ReportableListObject row = null;

if (searchYearFrom != null && searchYearFrom.length() > 0) {
	File reportFile = new File(application.getRealPath("/report/RPT_SMS_REPORT_Portrait.jasper"));	
	if (reportFile.exists()) {		
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("dateFrom", searchDayFrom+"/"+searchMonthFrom+"/"+searchYearFrom);
		parameters.put("dateTo", searchDayTo+"/"+searchMonthTo+"/"+searchYearTo);
		parameters.put("Site", site);
		String tempTitle = "";
		if(type.equals("inpatient")){
			tempTitle = "In-patient";
		}else if (type.equals("oncology")){
			tempTitle = "Oncology";
		}else if (type.equals("rehab")){
			tempTitle = "Rehab";
		}else if (type.equals("foodservice")){
			tempTitle = "Food Service";
		}else if (type.equals("inpatdisch")){
			tempTitle = "Inpatient Discharge";
		}else if (type.equals("cplab")){
			tempTitle = "CPLab Appointment SMS";			
		}else{
			tempTitle = "Out-patient";
		}
		parameters.put("rType", "("+tempTitle+")");
		
		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportListDataSource(getSmsRecord(searchDayFrom+"/"+searchMonthFrom+"/"+searchYearFrom,
														searchDayTo+"/"+searchMonthTo+"/"+searchYearTo,
														type, dept)));
		
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
				<%String PageTitle = "SMS Report"; %>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="<%=funID %>" />
					<jsp:param name="category" value="Report" />
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
								<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
									<jsp:param name="label" value="searchYearFrom_ByDate" />
									<jsp:param name="day_yy" value="<%=searchYearFrom %>" />
									<jsp:param name="yearRange" value="1" />
									<jsp:param name="isYearOnly" value="N" />
									<jsp:param name="showTime" value="N" />
								</jsp:include>
							</td>
							<td class="infoLabel" width="10%">End Date</td>
							<td class="infoData" width="40%" >
								<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
									<jsp:param name="label" value="searchYearTo_ByDate" />
									<jsp:param name="day_yy" value="<%=searchYearTo %>" />
									<jsp:param name="yearRange" value="1" />
									<jsp:param name="isYearOnly" value="N" />
									<jsp:param name="showTime" value="N" />
								</jsp:include>
							</td>
						</tr>
						<%if(type.equals("outpatient")){ %>
						<tr class="smallText" >
							<td class="infoLabel" width="10%">Department</td>
							<td class="infoData" width="40%" >
								<select id="dept" name="dept">
									<option value="0">ALL</option>
									<option value="1">Registration Desk</option>
									<option value="2">Heart Centre</option>
									<option value="3">Health Assessment</option>
								</select>
							</td>
						</tr>
						<%} %>
						<tr><td><input name="type" value="<%=type%>" style="display:none"/></td></tr>
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
						return false;
					}
				//-->
				</script>
			</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>