<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchCourseID(String classID) {
		// fetch course
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_EVENT_ID ");
		sqlStr.append("FROM   CO_SCHEDULE ");
		sqlStr.append("WHERE  CO_MODULE_ID = 'education' ");
		sqlStr.append("AND    CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_SCHEDULE_ID = ? ");
		return UtilDBWeb.getReportableList(sqlStr.toString(),
			new String[] { classID }
		);
	}
%>
<%
String category = "title.education";
String type = request.getParameter("type");
String classDate = request.getParameter("classDate");
String courseID = request.getParameter("courseID");
String classID = request.getParameter("classID");

boolean isHospitalOridentation = false;
String classDateDisplay = null;

if ("HO".equals(type)) {
	isHospitalOridentation = true;
	// hardcode for hospital class
	courseID = ConstantsCourseVariable.HOSPITAL_ORIENTATION_NE_CLASS_ID;
} else if ("NO".equals(type)) {
	// hardcode for nurse class
	courseID = ConstantsCourseVariable.NURSE_ORIENTATION_NE_CLASS_ID;
} else if (courseID != null) {
	if (ConstantsCourseVariable.HOSPITAL_ORIENTATION_NE_CLASS_ID.equals(courseID)) {
		isHospitalOridentation = true;
	}
} else if (classID != null) {
	ArrayList record = fetchCourseID(classID);
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		courseID = row.getValue(0);
		if (ConstantsCourseVariable.HOSPITAL_ORIENTATION_NE_CLASS_ID.equals(courseID)) {
			isHospitalOridentation = true;
		}
	}
}

if (classDate != null) {
	Date classDateInDate = DateTimeUtil.parseDate(classDate);
	if (classDateInDate != null) {
		try {
			classDateDisplay = (new SimpleDateFormat("EEEE, MMMM dd, yyyy", Locale.ENGLISH)).format(classDateInDate);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
} else {
	classDate = "";
}
if (courseID == null) {
	courseID = "";
}
if (classID == null) {
	classID = "";
}

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%
	String title = null;
	if (isHospitalOridentation) {
		title = "HOSPITAL ORIENTATION PROGRAM OUTLINE";
	} else {
		title = "GENERAL NURSING ORIENTATION PROGRAM";
	}
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<%if (!ConstantsServerSide.isTWAH()) {%>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="<%=(isHospitalOridentation?"class_enrollment.jsp":"../documentManage/download.jsp") %>" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
<%	if (classDateDisplay != null) { %>
	<tr class="bigText">
		<td align="center" colspan="3"><%=classDateDisplay %></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
<%	} %>
<%	if (isHospitalOridentation) { %>
	<tr class="bigText">
		<td align="right" width="20%"><b>08:30 - 09:00</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor8">SPIRITUAL EMPHASIS 心靈上的使命</span><br>
			<b>Chaplain 院牧</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>09:00 - 09:45</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor1">HANDBOOK HI''''GHLIGHTS 員工手冊簡介 </span><br>
			<b>Human Resource Department 人力資源部 </b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>09:45 - 10:15</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor4">AN AMAZYING STORY 奇妙的故事</span><br>
			<b>Lifestyle Management Center 健康生活促進中心</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>10:15 - 11:00</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor3">STANDARD PRECAUTION 一般醫療防備知識</span><br>
			<b>Infection Control Nurse 感染控制部護士</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>10:15 - 11:00</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor3">INTRANET PORTAL 港安醫院內聯網</span><br>
			<b>Information Management 資訊科技部</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>11:15 - 12:00</b></td>
			<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor2">OCCUPATIONAL SAFETY & HEALTH 職業安全及健康</span><br>
			<b>EH/OSH Coordinator 員工健康及職安健主任 </b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>12:00 - 12:45</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%"><b>L U N C H&nbsp;&nbsp;午 餐</b></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>12:45 - 13:30</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor6">MANUAL HANDING 人力提舉安全知識</span><br>
			<b>Rehabilitation Center 復康治療中心</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>13:30 - 14:00</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor7">FIRE SAFETY/DISASTER 防火安全知識</span><br>
			<b>Dept Head of Maintenance 維修部主管</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>14:00 - 14:30</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor9">THE DIFFERENCE IN US IS YOU/IT'S A DOG'S WORLD 與眾不同/人不如狗</span><br>
			<b>Human Resource Department 人力資源部</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>14:30 - 15:00</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor5">MARKETING INVOLVES EVERYONE 市場推廣</span><br>
			<b>Marketing & Business Development 市場及業務發展部</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>15:00 - 15:30</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor1">CULTURAL AWARENESS 文化的體會</span><br>
			<b>Staff Education Manager 員工培訓經理/護理經理</b>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>15:30 - 16:15</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%"><b>H O S P I T A L&nbsp;&nbsp;&nbsp;T O U R&nbsp;&nbsp;醫 院 各 部 門 指 引</b></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>16:15 - 17:00</b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor2">PERFORMANCE IMPROVEMENT WORKSHOP 品質改善</span><br>
			<b>Performance Improvement Coordinator 品質改善部主任</b>
		</td>
	</tr>
<%	} else { %>	
	<tr class="bigText">
		<td align="center" colspan="2">&nbsp;</td>
	</tr>	
	<tr class="bigText">
		<td align="center" colspan="2"><b><span class="labelColor7">TOPICS</span></b></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2">&nbsp;</td>
	</tr>	
	<tr class="bigText">
		<td style="background-color:#0070C0;color:white;font-weight:bold;font-size:20px" align="left" colspan="2">1 Day Nursing Orientation</td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor1">Nursing Organization & Structure</span></b></td>
		<td align="center"><button onclick="return downloadFile('640');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor3">Enhancing Quality of Nursing - AIDET</span></b></td>
		<td align="center"><button onclick="return downloadFile('642');"><bean:message key="button.view" /></button></td>
	</tr>
	
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor2">Standard of Professional Behavior</span></b></td>
		<td align="center"><button onclick="return downloadFile('641');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor10">Case Management</span></b></td>
		<td align="center"><button onclick="return downloadFile('649');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor6">Enhancing Nursing Quality - Rounding</span></b></td>
		<td align="center"><button onclick="return downloadFile('645');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	
	<tr class="bigText">
		<td align="left"><b><span class="labelColor4">Medication Safety</span></b></td>
		<td align="center"><button onclick="return downloadFile('709');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<!-- 
	<tr class="bigText">
		<td align="left"><b><span class="labelColor4">Introduction of Ewell</span></b></td>
		<td align="center"><button onclick="return downloadFile('708');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	-->	
	<tr class="bigText">
		<td align="left" colspan='2'><b><span class="labelColor8">Introduction of Ewell</span></b></td>
	</tr>
	<tr class="">
		<td align="left"><b><span class="labelColor8">&nbsp;&nbsp;1-Handheld & Buttons Intro</span></b></td>
		<td align="center"><button onclick="return downloadFile('734');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="">
		<td align="left"><b><span class="labelColor8">&nbsp;&nbsp;2-Drug Administration(Oral+IV)</span></b></td>
		<td align="center"><button onclick="return downloadFile('735');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="">
		<td align="left"><b><span class="labelColor8">&nbsp;&nbsp;3-Drug Administration(Handle Drug & Reprint Label)</span></b></td>
		<td align="center"><button onclick="return downloadFile('736');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="">
		<td align="left"><b><span class="labelColor8">&nbsp;&nbsp;4-Blood Transfusion</span></b></td>
		<td align="center"><button onclick="return downloadFile('737');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="">
		<td align="left"><b><span class="labelColor8">&nbsp;&nbsp;5-Specimen Collection</span></b></td>
		<td align="center"><button onclick="return downloadFile('738');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="">
		<td align="left"><b><span class="labelColor8">&nbsp;&nbsp;6-Pathology Station</span></b></td>
		<td align="center"><button onclick="return downloadFile('739');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>	
	
	<tr class="bigText">
		<td align="left"><b><span class="labelColor9">Code Blue Highlights</span></b></td>
		<td align="center"><button onclick="return downloadFile('648');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor1">Infection Control</span></b></td>
		<td align="center"><button onclick="return downloadFile('650');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor8">Pharmacy</span></b></td>
		<td align="center"><button onclick="return downloadFile('647');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor5">Nursing Documentation</span></b></td>
		<td align="center"><button onclick="return downloadFile('644');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<!-- 
	<tr class="bigText">
		<td align="left"><b><span class="labelColor4">Patient Safety Goals (KPI)</span></b></td>
		<td align="center"><button onclick="return downloadFile('643');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	 -->
	<tr class="bigText">
		<td align="left"><b><span class="labelColor4">Patient Safety - Fall</span></b></td>
		<td align="center"><button onclick="return downloadFile('707');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor7">MHO - Mortuary Trolley Operation</span></b></td>
		<td align="center"><button onclick="return downloadFile('710');"><bean:message key="button.view" /></button><br/>
		<button onclick="return downloadFile('756');">Video</button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<!-- 
	<tr class="bigText">
		<td align="left"><b><span class="labelColor7">Nursing Orientation- Customer Services</span></b></td>
		<td align="center"><button onclick="return downloadFile('646');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	 -->	
<%	} %>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3">&nbsp;</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><button type="submit"><bean:message key="button.register" /></button></td>
	</tr>
</table>
<input type="hidden" name="classDate" value="<%=classDate %>">
<input type="hidden" name="classID" value="<%=classID %>">
<input type="hidden" name="courseID" value="<%=courseID %>">
</form>
<% } else { %>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="<%=(isHospitalOridentation?"class_enrollment.jsp":"../documentManage/download.jsp") %>" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="1">
	<%	if (isHospitalOridentation) { %>
	
	<% } else { %>
	<tr class="bigText">
		<td style="padding: 5px;"><b>Time</b></td>	
		<td align="left" style="height:35px; padding: 5px;"><b>Topic</b></td>
		<td style="padding: 5px;"><b>Speaker</b></td>
	</tr>
	<tr class="bigText">
		<td style="padding: 5px;">30 mins</td>
		<td align="left" style="height:35px; padding: 5px;"><b><span class="labelColor1">Roundings</span></b></td>	
		<td style="padding: 5px;">Nursing Officer, HKAH-TW</td>	
	</tr>

	<tr class="bigText">
		<td style="padding: 5px;">30 mins</td>
		<td align="left" style="height:35px;padding: 5px;"><b><span class="labelColor2">Fall Prevention <br/> - Adult patients <br/> - Pediatric patients </span></b></td>	
		<td style="padding: 5px;">Nursing Officers, HKAH-TW</td>		
	</tr>

	<tr class="bigText">
		<td style="padding: 5px;">30 mins</td>
		<td align="left" style="height:35px;padding: 5px;"><b><span class="labelColor3">Pressure Ulcer Prevention for patients in <br/> - General Wards <br/> - Operation Room </span></b></td>		
		<td style="padding: 5px;">Nursing Officers, HKAH-TW</td>	
	</tr>
	<tr class="bigText">
		<td style="padding: 5px;">30 mins</td>
		<td align="left" style="height:35px;padding: 5px;"><b><span class="labelColor4">Medication Safety (1)</span></b></td>		
		<td style="padding: 5px;">Pharmacist, HKAH-TW </td>	
	</tr>
	<tr class="bigText">
		<td style="padding: 5px;">30 mins</td>
		<td align="left" style="height:35px;padding: 5px;"><b><span class="labelColor1">Medication Safety (2)</span></b></td>		
		<td style="padding: 5px;">Nursing Officer, HKAH-TW</td>	
	</tr>
	<% } %>	
</table>
<br/>
<table style="width:100%">
<tr class="bigText">
		<td align="center" colspan="3"><button type="button" onclick="return downloadFile('485');">View Schedule</button></td>
</tr>
</table>
<input type="hidden" name="classDate" value="<%=classDate %>">
<input type="hidden" name="classID" value="<%=classID %>">
<input type="hidden" name="courseID" value="<%=courseID %>">
</form>	
<% }%>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>