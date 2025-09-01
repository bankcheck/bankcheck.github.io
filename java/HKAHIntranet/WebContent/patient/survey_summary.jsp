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
private ArrayList getStaffSurveyRecord(String dateFrom, String dateTo,String surveyID, String siteCode) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append(" select S.CO_STAFF_ID, DECODE(TRIM(S.CO_FIRSTNAME||' '||S.CO_LASTNAME), '', "); 
	sqlStr.append(" S.CO_STAFFNAME, S.CO_FIRSTNAME||' '||S.CO_LASTNAME) as STAFFNAME ");
	ArrayList surveyQuestionRecord = getSurveyQuestions(surveyID, siteCode);
	if (surveyQuestionRecord.size() > 0) {
		for(int i = 0;i<surveyQuestionRecord.size();i++){
			ReportableListObject surveyQuestionRow = (ReportableListObject) surveyQuestionRecord.get(i);
			
			for(int j = 1; j <= 5; j++){
				sqlStr.append(getQuestionAnswerCount(surveyID, surveyQuestionRow.getValue(0), Integer.toString(j) , dateFrom, dateTo));
			}			
		}
	}		
	sqlStr.append(" from CO_STAFFS S, CO_DEPARTMENTS D where S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE "); 
	sqlStr.append(" and D.CO_DEPARTMENT_CODE = '820' and S.CO_ENABLED = '1' and S.CO_STAFF_ID <> '4347' and S.CO_STAFF_ID <> '4316' "); 
	sqlStr.append(" and S.CO_STAFF_ID <> '3308' and S.CO_STAFF_ID <> '4326' and S.CO_STAFF_ID <> '3960' "); 
	sqlStr.append(" and S.CO_STAFF_ID <> '2075' and S.CO_STAFF_ID <> '3822' ");
	sqlStr.append(" order by STAFFNAME ");
			
	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getSurveyQuestions(String surveyID, String siteCode) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select EE_EVALUATION_QID, EE_QUESTION "); 
	sqlStr.append("from   EE_EVALUATION_QUESTION Q "); 
	sqlStr.append("where  Q.EE_ENABLED = 1 ");
	sqlStr.append("and    Q.EE_EVALUATION_ID = '"+surveyID+"' ");
	sqlStr.append("and    Q.EE_EVALUATION_QID != 1 ");
	sqlStr.append("and    Q.EE_IS_FREE_TEXT  != 'Y' ");
	sqlStr.append("and    Q.EE_SITE_CODE = '"+siteCode+"' ");
	
	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private String getQuestionAnswerCount(String surveyID, String questionID, String answerID, String dateFrom, String dateTo){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append(", ( SELECT COUNT(ESA.EE_EVALUATION_AID) ");
	sqlStr.append(" from EE_EVALUATION_STAFF_ANSWER ESA ");
	sqlStr.append(" where     ESA.EE_ENABLED = '1' "); 
	sqlStr.append(" and       ESA.EE_MODULE_CODE = 'survey' ");           
	sqlStr.append(" and       ESA.EE_EVALUATION_AID != -1 ");	
	sqlStr.append(" and       ESA.EE_EVALUATION_ID = '"+surveyID+"' ");
	sqlStr.append(" and       ESA.EE_EVALUATION_QID = '"+questionID+"' ");
	sqlStr.append(" and       ESA.EE_EVALUATION_AID = '"+answerID+"' ");	
	sqlStr.append(" and       ESA.EE_CREATED_USER = S.CO_STAFF_ID ");
	sqlStr.append(" and       ESA.EE_CREATED_DATE >= TO_DATE('"+dateFrom+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append(" and       ESA.EE_CREATED_DATE <= TO_DATE('"+dateTo+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append(" ) S"+surveyID+"_Q"+questionID+"_A"+answerID+" ");
	
	return sqlStr.toString();
}

private ArrayList getGeneralSurveyRecord(String dateFrom, String dateTo,String surveyID, String siteCode) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select EE_EVALUATION_QID, EE_QUESTION "); 
	
	for(int j = 1; j <= 5; j++){
		sqlStr.append(getQuestionAnswerCount(surveyID, Integer.toString(j) , dateFrom, dateTo));
	}			
	
	sqlStr.append("from      EE_EVALUATION_QUESTION Q "); 
	sqlStr.append("where     Q.EE_ENABLED = 1 ");
	sqlStr.append("and       Q.EE_EVALUATION_ID = '"+surveyID+"' ");
	sqlStr.append("and       Q.EE_EVALUATION_QID != 1 ");
	sqlStr.append("and       Q.EE_IS_FREE_TEXT  != 'Y' ");
	sqlStr.append("and       Q.EE_SITE_CODE = '"+siteCode+"' ");
	sqlStr.append("order by  Q.EE_EVALUATION_QID ");
	
	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private String getQuestionAnswerCount(String surveyID, String answerID, String dateFrom, String dateTo){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append(", ( SELECT COUNT(ESA.EE_EVALUATION_AID) ");
	sqlStr.append(" from EE_EVALUATION_STAFF_ANSWER ESA ");
	sqlStr.append(" where     ESA.EE_ENABLED = '1' "); 
	sqlStr.append(" and       ESA.EE_MODULE_CODE = 'survey' ");           
	sqlStr.append(" and       ESA.EE_EVALUATION_AID != -1 ");	
	sqlStr.append(" and       ESA.EE_EVALUATION_ID = '"+surveyID+"' ");	
	sqlStr.append(" and       ESA.EE_EVALUATION_AID = '"+answerID+"' ");	
	sqlStr.append(" and       ESA.EE_EVALUATION_QID = Q.EE_EVALUATION_QID ");
	sqlStr.append(" and       ESA.EE_CREATED_DATE >= TO_DATE('"+dateFrom+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append(" and       ESA.EE_CREATED_DATE <= TO_DATE('"+dateTo+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append(" ) S"+surveyID+"_A"+answerID+" ");
	
	return sqlStr.toString();
}

private ArrayList getCommentSurveyRecord(String dateFrom, String dateTo,String surveyID, String siteCode) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select    EE_USER_ID , EE_EVALUATION_ANSWER_DESC ");
	sqlStr.append("FROM      EE_EVALUATION_STAFF_ANSWER ESA ");
	sqlStr.append("where     EE_ENABLED = '1' ");  
	sqlStr.append("and       EE_MODULE_CODE = 'survey' ");
	sqlStr.append("and       EE_EVALUATION_ANSWER_DESC is not null ");
	sqlStr.append("and       EE_EVALUATION_QID != '1' ");
	sqlStr.append("and       EE_EVALUATION_ID = '"+surveyID+"' ");
	sqlStr.append("and       EE_SITE_CODE = '"+siteCode+"' ");
	sqlStr.append("and      EE_CREATED_DATE >= TO_DATE('"+dateFrom+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("and      EE_CREATED_DATE <= TO_DATE('"+dateTo+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("order by  EE_USER_ID ");
		
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
String surveyID = request.getParameter("surveyID");
String surveyReport = request.getParameter("surveyReport");

if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital- Stubbs Road";
}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}

if (searchYearFrom != null && searchYearFrom.length() > 0) {
	File reportFile = null;
	ReportListDataSource report = null;
	String type= "";
	if("staff".equals(surveyReport)){
		if("9".equals(surveyID)){
			reportFile = new File(application.getRealPath("/report/RPT_SURVEY_ADMISSION_SUMMARY.jasper"));
			type = "Admission Survey Report (Staff)";
		}else if("8".equals(surveyID)){
			reportFile = new File(application.getRealPath("/report/RPT_SURVEY_DISCHARGE_SUMMARY.jasper"));
			type = "Discharge Survey Report (Staff)";
		}
		report = new ReportListDataSource(getStaffSurveyRecord(searchDayFrom+"/"+searchMonthFrom+"/"+searchYearFrom,
				searchDayTo+"/"+searchMonthTo+"/"+searchYearTo, surveyID ,userBean.getSiteCode()));
	}else if("general".equals(surveyReport)){
		reportFile = new File(application.getRealPath("/report/RPT_SURVEY_GENERAL_SUMMARY.jasper"));
		if("9".equals(surveyID)){
			type = "Admission Survey Report (General)";
		}else if("8".equals(surveyID)){
			type = "Discharge Survey Report (General)";
		}
		report = new ReportListDataSource(getGeneralSurveyRecord(searchDayFrom+"/"+searchMonthFrom+"/"+searchYearFrom,
				searchDayTo+"/"+searchMonthTo+"/"+searchYearTo, surveyID ,userBean.getSiteCode()));
	}else if("comment".equals(surveyReport)){
		reportFile = new File(application.getRealPath("/report/RPT_SURVEY_COMMENT_SUMMARY.jasper"));
		if("9".equals(surveyID)){
			type = "Admission Survey Report (Comment)";
		}else if("8".equals(surveyID)){
			type = "Discharge Survey Report (Comment)";
		}
		report = new ReportListDataSource(getCommentSurveyRecord(searchDayFrom+"/"+searchMonthFrom+"/"+searchYearFrom,
				searchDayTo+"/"+searchMonthTo+"/"+searchYearTo, surveyID ,userBean.getSiteCode()));
	}
	
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("dateFrom", searchDayFrom+"/"+searchMonthFrom+"/"+searchYearFrom);
		parameters.put("dateTo", searchDayTo+"/"+searchMonthTo+"/"+searchYearTo);
		parameters.put("Site", site);
		parameters.put("Type", type );
		
		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				report);
		
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
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="Survey Summary" />					
					<jsp:param name="keepReferer" value="N" />
				</jsp:include>
				<form name="search_form" action="survey_summary.jsp" method="post" target="_blank">
					<table cellpadding="0" cellspacing="5"
						class="contentFrameSearch" border="0">
						<tr class="bigText">
							<td colspan="4" align="center"><%=site %></td>
						</tr>						
						<tr><td>&nbsp;</td></tr>
						<tr class="smallText" >
							<td class="infoLabel" width="15%">Survey Report</td>
							<td class="infoData" width="35%" >
								<select name='surveyReport'>
									<option value='staff'>Staff</option>
									<option value='general'>General</option>
									<option value='comment'>Comment</option>
								</select>
							</td>							
						</tr>
						<tr class="smallText" >
							<td class="infoLabel" width="15%">Survey Type</td>
							<td class="infoData" width="35%" >
								<select name='surveyID'>
									<option value='9'>Admission</option>
									<option value='8'>Discharge</option>
								</select>
							</td>							
						</tr>
						<tr class="smallText" >
							<td class="infoLabel" width="15%">Start Date</td>
							<td class="infoData" width="35%" >
								<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
									<jsp:param name="label" value="searchYearFrom_ByDate" />
									<jsp:param name="day_yy" value="<%=searchYearFrom %>" />
									<jsp:param name="yearRange" value="1" />
									<jsp:param name="isYearOnly" value="N" />
									<jsp:param name="showTime" value="N" />
								</jsp:include>
							</td>
							<td class="infoLabel" width="15%">End Date</td>
							<td class="infoData" width="35%" >
								<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
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

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>  