<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.util.regex.Matcher"%>

<%
UserBean userBean = new UserBean(request);
String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");

String labelColorBlue = "#39A9DE"; 
String labelColorRed = "#C00000";
String labelColorPurple = "#F000F0";
String labelColorBlack = "#000000";
String labelColorGreen = "#00C000";
String labelColorOrange = "#DCA010";
String labelColorYellow = "#BEBE0C";
String labelColorBrown = "#9B6802";

ArrayList records = ScheduleDB.getCalendar(userBean.getDeptCode(), startDate, endDate);

File reportFile = new File(application.getRealPath("/report/RPT_EDU_CALENDAR.jasper"));
if (reportFile.exists()) {
	JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	//System.out.println(reportFile.getParentFile());
	Map parameters = new HashMap();
	parameters.put("BaseDir", reportFile.getParentFile());
	
//	Calendar c = Calendar.getInstance();
//	c.setTime(startDate);
//	int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);

Calendar cal = Calendar.getInstance();
Calendar currentDate = Calendar.getInstance();;

cal.setTime(new SimpleDateFormat("dd/MM/yyyy").parse(startDate));

cal.set(Calendar.DAY_OF_MONTH, 1); 
int myMonth=cal.get(Calendar.MONTH);
int i = cal.get(Calendar.DAY_OF_WEEK);
parameters.put("cMonth", new SimpleDateFormat("MMMM yyyy", Locale.US).format(cal.getTime()));

while (myMonth==cal.get(Calendar.MONTH)) {
	StringBuffer courseStr = new StringBuffer();
	for(int k = 0; k < records.size(); k++){
		ReportableListObject row = (ReportableListObject) records.get(k);
		String courseID = row.getValue(0);
		String classID = row.getValue(1);
		String courseDesc = row.getValue(2);
		String scheduleDesc = row.getValue(3);
		String courseRemark = row.getValue(4);
		String classDate = row.getValue(5);
		String classStartTime = row.getValue(6);
		String classEndTime = row.getValue(7);
		String location = row.getValue(8);
		if (location == null || location.length() == 0) {
			location = row.getValue(9);
		}
		String lecturer = row.getValue(10);
		String courseCategory = row.getValue(11);
		String courseType = row.getValue(12);
		String classSize = row.getValue(13);
		String enrolled = row.getValue(14);
		String available = row.getValue(15);
		String classNewsID = row.getValue(16);
		String showRegOnline = row.getValue(17);
		boolean allowEnroll = !ConstantsVariable.ZERO_VALUE.equals(classSize);
		boolean fullEnroll = enrolled.equals(classSize);
		boolean courseDetail = false;
		
		StringBuffer classInfo = new StringBuffer();
		classInfo.setLength(0);
		int labelColor = 0;
		Random random = new Random();
		try {
			labelColor = Integer.parseInt(courseID) % 9 + 1;
		} catch (Exception e) {
			labelColor = random.nextInt(8) + 1;
		}
		if(ConstantsServerSide.isHKAH()){
			classInfo.append("<span style=\"color:");
			if("compulsory".equals(courseCategory)){
				classInfo.append(labelColorRed);
			}else if("mockCode".equals(courseCategory)){
				classInfo.append(labelColorBlue);
			}else if("tND".equals(courseCategory)){
				classInfo.append(labelColorPurple);
			}else if("inservice".equals(courseCategory)){
				classInfo.append(labelColorBlack);
			}else if("mockDrill".equals(courseCategory)){
				classInfo.append(labelColorGreen);
			}else if("CNE".equals(courseCategory)){
				classInfo.append(labelColorOrange);
			}else if("intClass".equals(courseCategory)){
				classInfo.append(labelColorYellow);
			}else {
				classInfo.append(labelColorBrown);
			}
			classInfo.append("\">");
		}
		classInfo.append(courseDesc.toUpperCase());
		if (scheduleDesc != null && scheduleDesc.length() > 0) {
			classInfo.append("<br>(");
			classInfo.append(scheduleDesc);
			classInfo.append(")");
		}
		classInfo.append("<br>");
		if (lecturer != null && lecturer.length() > 0) {
			classInfo.append(lecturer);
			courseDetail = true;
		}
		if (location != null && location.length() > 0) {
			if (courseDetail) {
				classInfo.append(ConstantsVariable.COMMA_VALUE);
				classInfo.append(ConstantsVariable.SPACE_VALUE);
			}
			classInfo.append(location);
			courseDetail = true;
		}
		if (classStartTime != null && classStartTime.length() > 0 && !"00:00".equals(classStartTime)) {
			if (courseDetail) {
				classInfo.append(ConstantsVariable.COMMA_VALUE);
				classInfo.append(ConstantsVariable.SPACE_VALUE);
			}
			classInfo.append(classStartTime);
			if (classEndTime != null && classEndTime.length() > 0) {
				classInfo.append("-");
				classInfo.append(classEndTime);
			}
		}
		if (courseRemark != null && courseRemark.length() > 0) {
			classInfo.append("<br>");
			classInfo.append(courseRemark);
		}
		
		if (allowEnroll) {
			classInfo.append("<br>");
			if (fullEnroll) {
				classInfo.append("FULLY REGISTED");
			} else {
				if (!"N".equals(showRegOnline)) {
				classInfo.append("<BLINK>REGISTER ON-LINE</BLINK><br>(");
				}else{
					classInfo.append("(");
				}
				classInfo.append("<b>" + available + "</b>");
				classInfo.append(" AVAILABLE)");
			}
		}
		if(ConstantsServerSide.isHKAH()){
			classInfo.append("</span>");
		}
		
		Calendar courseCal = Calendar.getInstance();
		courseCal.setTime( new SimpleDateFormat("dd/MM/yyyy").parse(classDate));
		if(cal.equals(courseCal)){
			if(currentDate.equals(courseCal)){
				courseStr.append("<br>");
			}else{
				currentDate = courseCal;	
			}
			courseStr.append("<br>" + classInfo.toString() );
		}
	}
 
  parameters.put(Integer.toString(i), "<b>" + Integer.toString(cal.get(Calendar.DAY_OF_MONTH)) + "</b>" + courseStr.toString());
  
  i++;
  cal.add(Calendar.DAY_OF_MONTH, 1);
}


	ArrayList tempRecord = new ArrayList();
	tempRecord.add("tempRecord");
	
	JasperPrint jasperPrint =
		JasperFillManager.fillReport(
			jasperReport,
			parameters,
			new ReportListDataSource(tempRecord));
	
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
%>
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
<div id=indexWrapper style="width:100%">
<div id=mainFrame style="width:100%">
<div id=contentFrame style="width:100%">

</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>