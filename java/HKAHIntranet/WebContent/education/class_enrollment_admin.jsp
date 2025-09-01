<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.io.FileReader" %>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="au.com.bytecode.opencsv.CSVReader"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)) {
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	fileUpload = true;
}

UserBean userBean = new UserBean(request);

String category = "title.education";
String currentDay = DateTimeUtil.getCurrentDate();
String courseCategory = ParserUtil.getParameter(request, "courseCategory");
String command = ParserUtil.getParameter(request, "command");
String eventID = ParserUtil.getParameter(request, "eventID");
String scheduleID = ParserUtil.getParameter(request, "scheduleID");
String enrollID = ParserUtil.getParameter(request, "enrollID");
String deptCode = ParserUtil.getParameter(request, "deptCode");
String staffID = ParserUtil.getParameter(request, "staffID");
String module = "education";
String courseDescription = null;
String classDate = null;
String classStartTime = null;
String classEndTime = null;
String classDuration = null;
String location = null;
String locationOther = null;
String lecturer = null;
String classSize = null;
String classEnrolled = null;
String requireAssessmentPass = null;
String lunchAva = null;
String[] passTestDate = (String[])request.getAttribute("passTestDate_StringArray");
String[] isPassTestDate = (String[])request.getAttribute("isPassTestDate_StringArray");
String[] attendDates = (String[])request.getAttribute("attendDate_StringArray");
String[] isAttendDate = (String[])request.getAttribute("isAttendDate_StringArray");
String[] enrollIDs = (String[])request.getAttribute("enrollIDs_StringArray");
String[] remarks2 = (String[])request.getAttribute("remarks2_StringArray");
String orderById = ParserUtil.getParameter(request, "orderById");
String scheduleStatus = null;
String directLink = null;

String staffList = ParserUtil.getParameter(request, "staffList");

Map<String, String> onDutyMaps = null;
if (enrollIDs !=  null) {
	onDutyMaps = new HashMap<String, String>();
	for (int i = 0; i < enrollIDs.length; i++) {
		onDutyMaps.put(enrollIDs[i], ParserUtil.getParameter(request, "onDuty_" + enrollIDs[i]));
	}
}

String[] fileList = (String[]) request.getAttribute("filelist");
String[] nextLine = null;
List class_enrollment = null;

String allowAll = userBean.isSuperManager() || userBean.isEducationManager() ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
String userDeptCode = userBean.getDeptCode() == null ? ConstantsVariable.EMPTY_VALUE : userBean.getDeptCode();

if ("vaccine".equals(courseCategory)) {
	module = "vaccine";
} else {
	module = "education";
}

boolean takeAction = false;
boolean withdrawAction = false;
boolean updateDateAction = false;
boolean closeAction = false;
boolean loadAction = false;
boolean exportPdfAction = false;
boolean eatLunch = false;
boolean removeLunch = false;

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

if ("take".equals(command)) {
	takeAction = true;
} else if ("withdraw".equals(command)) {
	withdrawAction = true;
} else if ("updateDate".equals(command)) {
	updateDateAction = true;
} else if ("load".equals(command)) {
	loadAction= true;
} else if ("exportpdf".equals(command)) {
	exportPdfAction= true;
} else if ("eatLunch".equals(command)) {
	eatLunch = true;
} else if ("removeLunch".equals(command)) {
	removeLunch = true;
}
try {
	if (takeAction) {
		if (userBean.isEducationManager() || userBean.isAdmin()) {
			int enrollSuccess = 0;
			int enrollprevous = 0;
			int enrollFull = 0;
			int enrollFail = 0;
			if (staffList !=  null && staffList.length()>0) {
				String newStaffID[] = staffList.split(",");
				for(int i=0;i<newStaffID.length;i++) {
					int returnValue = EnrollmentDB.enroll(userBean, module, eventID, scheduleID, "staff", newStaffID[i]);
					if (returnValue == 0) {
						enrollSuccess++;
					} else if (returnValue == -1) {
						enrollprevous++;
					} else if (returnValue == -2) {
						enrollFull++;
					} else {
						enrollFail++;
					}
				}
					if (enrollSuccess==newStaffID.length) {
						message = "Class enrolled.";
					} else if (enrollprevous>0||enrollFull>0||enrollFail>0) {
						errorMessage = "Class enroll fail. ";
						if (enrollFull > 0) {
							errorMessage = "Class fulled.";
						} else if (enrollprevous > 0) {
							errorMessage = enrollprevous + " staff enrolled prevous.";
						}
					}

			} else {
				errorMessage = "Class enroll fail.";
			}
		} else {
			int returnValue = EnrollmentDB.enroll(userBean, module, eventID, scheduleID, "staff", staffID);
			if (returnValue == 0) {
				message = "Class enrolled.";
			} else if (returnValue == -1) {
				errorMessage = "Class enrolled prevous.";
			} else if (returnValue == -2) {
				errorMessage = "Class fulled.";
			} else {
				errorMessage = "Class enroll fail.";
			}
		}
	} else if (withdrawAction) {
		int returnValue = EnrollmentDB.withdraw(userBean, module, eventID, scheduleID, enrollID, "staff", staffID);
		if (returnValue == 0) {
			message = "Class withdrawn.";
		} else if (returnValue == -1) {
			errorMessage = "Class haven't enrolled yet.";
		} else {
			errorMessage = "Class withdraw fail.";
		}
	} else if (eatLunch) {
		boolean returnValue = EnrollmentDB.updateLunch(userBean, module, eventID, scheduleID, enrollID, "Y");
		if (returnValue) {
			message = "Lunch ordered.";
		} else {
			errorMessage = "Lunch update fail.";
		}

	} else if (removeLunch) {
		boolean returnValue = EnrollmentDB.updateLunch(userBean, module, eventID, scheduleID, enrollID, "N");
		if (returnValue) {
			message = "Lunch not ordered.";
		} else {
			errorMessage = "Lunch update fail.";
		}
	} else if (updateDateAction) {
		if (enrollIDs != null) {
			boolean updateAttend = true;
			boolean updatePassTest = true;
			boolean updateOnDutySuccess = true;
			boolean updateRemarks2 = true;

			int j = 0;
			int k = 0;
			for (int i = 0; i < enrollIDs.length; i++) {
				if (isAttendDate.length > i) {
					if ("Y".equals(isAttendDate[i])) {
						if (!EnrollmentDB.attend(userBean, module, eventID, scheduleID, enrollIDs[i], attendDates[j])) {
							updateAttend = false;
						}
					}
					j++;
				}

				if (isPassTestDate.length > i) {
					if ("Y".equals(isPassTestDate[i])) {
						if (!EnrollmentDB.passTest(userBean, module, eventID, scheduleID, enrollIDs[i], passTestDate[k])) {
							updatePassTest = false;
						}
					}
					k++;
				}

				if (!EnrollmentDB.addRemarks(userBean, module, eventID, scheduleID, enrollIDs[i], remarks2[i])) {
					updateRemarks2 = false;
				}

				if (!EnrollmentDB.updateOnDuty(userBean, module, eventID, scheduleID, enrollIDs[i], onDutyMaps.get(enrollIDs[i]))) {
					updateOnDutySuccess = false;
				}
			}

			if (!updateAttend || !updatePassTest || !updateOnDutySuccess || !updateRemarks2) {
				errorMessage = "Enrollment update fail.";
			} else {
				message = "Enrollment updated.";
			}
		} else {
			errorMessage = "Enrollment update fail.";
		}
	} else if (loadAction) {
		try {
			CSVReader reader = new CSVReader(new FileReader(ConstantsServerSide.UPLOAD_FOLDER +"\\"+fileList[0]));

			while ((nextLine = reader.readNext()) != null) {
				String staffNo = nextLine[0].split("</")[0].toUpperCase();
				if ("0".equals(staffNo.substring(0,1))) {
					staffNo = staffNo.substring(1,staffNo.length());
				}
				if (EnrollmentDB.isEnrollednotAttend(module,eventID,scheduleID,"staff",staffNo)) {
					boolean tempValue = EnrollmentDB.attendIgnoreStatus(userBean,module,eventID,scheduleID,"",staffNo,nextLine[2],nextLine[1],"Y");
				} else {
					int returnValue = EnrollmentDB.enroll(userBean, module, eventID,scheduleID, "staff", staffNo);
					boolean tempValue = EnrollmentDB.attend(userBean,module,eventID,scheduleID,"",staffNo,nextLine[1],nextLine[2],"Y");
				}
			}
			reader.close();
			message = "List of Staff uploaded.";

		} catch (Exception e) {
			errorMessage = "List of Staff uploaded fail.";
			e.printStackTrace();
		}
		try {
			File file = new File(ConstantsServerSide.UPLOAD_FOLDER +"\\"+fileList[0]);
			boolean temp = file.delete();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	if (eventID != null && eventID.length() > 0) {
		ArrayList result = ScheduleDB.get(module, eventID, scheduleID);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			courseDescription = reportableListObject.getValue(2);
			classDate = reportableListObject.getValue(4);
			classStartTime = reportableListObject.getValue(5);
			classEndTime = reportableListObject.getValue(6);
			classDuration = reportableListObject.getValue(7);
			location = reportableListObject.getValue(9);
			locationOther = reportableListObject.getValue(10);
			lecturer = reportableListObject.getValue(11);
			classSize = reportableListObject.getValue(12);
			classEnrolled = reportableListObject.getValue(13);
			requireAssessmentPass = reportableListObject.getValue(15);
			scheduleStatus = reportableListObject.getValue(14);
			lunchAva = reportableListObject.getValue(19);
			class_enrollment = EnrollmentDB.getEnrolledClass(module, eventID, scheduleID, null, null, null, null,null, null);
			request.setAttribute("class_enrollment", class_enrollment);
			directLink = "http://192.168.0.20/intranet/education/class_enrollment.jsp";
			directLink += "?classDate=" ;
			directLink += classDate;
			directLink += "&courseID=";
			directLink += eventID;
			directLink += "&classID=";
			directLink += scheduleID;
		} else {
			closeAction = true;
		}
	}

	if (exportPdfAction) {
			File reportFile = new File(application.getRealPath("/report/eeAttdSheet.jasper"));
			File reportDir = new File(application.getRealPath("/report/"));
			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

				Map parameters = new HashMap();
				parameters.put("BaseDir", reportFile.getParentFile());
				parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
				parameters.put("Site", ConstantsServerSide.SITE_CODE);
				parameters.put("eventID", eventID);
				parameters.put("scheduleID", scheduleID);
				parameters.put("module", module);
				parameters.put("orderById", orderById);

				JasperPrint jasperPrint =
					JasperFillManager.fillReport(
						jasperReport, parameters, HKAHInitServlet.getDataSourceIntranet().getConnection());

				String encodedFileName = "ClassAttdList_" + courseDescription + "_" + classDate + ".pdf";
				request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
				OutputStream ouputStream = response.getOutputStream();
				response.setContentType("application/pdf");
				response.setHeader("Content-disposition", "attachment; filename=\"" + encodedFileName + "\"");
				JRPdfExporter exporter = new JRPdfExporter();
			exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
			exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

			exporter.exportReport();
				return;
			}
		}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<style>
<!--
.input-date-box { width: 220px; margin: 2px 0; border: 1px solid #e0dfe3; }
.exportpdf { background: #fff url('../images/pdf_small.gif') no-repeat top left; }
#report-box { background: #CCFFCC;  }
-->
</style>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.classEnrollment.admin" />
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<bean:define id="functionLabel"><bean:message key="function.classEnrollment.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" enctype="multipart/form-data" action="class_enrollment_admin.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr>
		<td colspan="2">
			<table id="report-box">
				<tr>
					<td>
						<button class="exportpdf" onclick="submitAction('exportpdf', '<%=eventID %>', '<%=scheduleID %>');">PDF version</button>
					</td>
					<td>
						<table>
							<tr>
								<td valign="top">Sort order:</td>
								<td>
									<input type="radio" name="orderById" value="1" checked />Department > Emp No<br/>
									<input type="radio" name="orderById" value="2" />Emp No > Department
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.courseDescription" /></td>
		<td class="infoData" width="70%"><%=courseDescription %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.classDate" /></td>
		<td class="infoData" width="70%"><%=classDate %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.classTime" /></td>
		<td class="infoData" width="70%"><%=classStartTime %> - <%=classEndTime %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.duration" /></td>
		<td class="infoData" width="70%"><%=classDuration %> hour(s)</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.location" /></td>
		<td class="infoData" width="70%">
<%
	String locationDisplay = "";
	if (locationOther != null) {
		if (locationOther.equals(location)) {
			locationDisplay = location;
		} else {
			locationDisplay = location + " " + locationOther;
		}
	} else {
		locationDisplay = location;
	}
%>
			<%=locationDisplay %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Lecturer</td>
		<td class="infoData" width="70%"><%=lecturer %></td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.classSize" /></td>
		<td class="infoData" width="70%"><%=classSize %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.enrolledNumber" /></td>
		<td class="infoData" width="70%"><%=classEnrolled %></td>
	</tr>
</table>

	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
<% if (ConstantsServerSide.SITE_CODE.toUpperCase().equals("TWAH")) {%>
			<tr class="smallText">
				<td class="infoLabel" width="30%">Direct Enrollment Link</td>
				<td class="infoData" width="70%"><a href=<%=directLink %>>Link<a/>
				<textarea rows="2" cols="100" readonly><%=directLink %></textarea>
				</td>
			</tr>
<%} %>
			<tr class="smallText">
				<td class="infoLabel" width="30%">Upload Enrollment Record</td>
				<td class="infoData" width="70%">
				<input type="file" name="file1" size="50" class="multi" maxlength="5">
				<button onclick="return submitAction('load', '','');" class="btn-click">Load Data</button>
				</td>
			</tr>
	</table>
<display:table id="row" name="requestScope.class_enrollment" export="true" pagesize="100" class="tablesorter">
<%
	ReportableListObject rlo = ((ReportableListObject) pageContext.getAttribute("row"));
	String assessmentPassDate = rlo == null ? null : ((ReportableListObject) pageContext.getAttribute("row")).getFields13();
	String attendDate = rlo == null ? null : ((ReportableListObject) pageContext.getAttribute("row")).getFields7();
	boolean isPassTest = assessmentPassDate != null && !StringUtils.isEmpty(assessmentPassDate);
%>
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)
		<input type="hidden" name="enrollIDs" value="<%=((ReportableListObject) pageContext.getAttribute("row")).getFields3() %>" />
	</display:column>
	<display:column title="" media="csv excel xml pdf" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%></display:column>
	<display:column title="Course Category" media="csv excel xml pdf" style="width:0%; text-align:center">
		<logic:equal name="row" property="fields17" value="compulsory">
			<bean:message key="label.compulsory" />
		</logic:equal>
		<logic:equal name="row" property="fields17" value="inservice">
			<bean:message key="label.inservice" />
		</logic:equal>
		<logic:equal name="row" property="fields17" value="other">
			<bean:message key="label.optional" />
		</logic:equal>
		<logic:equal name="row" property="fields17" value="CNE">
			CNE
		</logic:equal>
		<logic:equal name="row" property="fields17" value="firedrill">
			Fire and Disaster Drills
		</logic:equal>
		<logic:equal name="row" property="fields17" value="tND">
			T&D
		</logic:equal>
	</display:column>
	<display:column title="Course Name" style="width:20%">
		<c:out value="${row.fields1}" /><logic:notEqual name="row" property="fields16" value=""> - <c:out value="${row.fields16}" /></logic:notEqual>
	</display:column>
	<display:column title="Class Date" media="csv excel xml pdf" style="width:0%; text-align:center">
		<%=classDate %>
	</display:column>
	<display:column title="Class Time" media="csv excel xml pdf" style="width:0%; text-align:center">
		<%=classStartTime %> - <%=classEndTime %>
	</display:column>
	<display:column title="Class Duration" media="csv excel xml pdf" style="width:0%; text-align:center">
		<%=classDuration %> hour(s)
	</display:column>
	<display:column title="Lecturer" media="csv excel xml pdf" style="width:0%; text-align:center">
		<%=lecturer %>
	</display:column>
	<display:column titleKey="prompt.staffName" media="html" style="width:20%" >
		<c:out value="${row.fields10}" />
<% if (userBean.isEducationManager() || userBean.isAdmin()|| ("8189".equals(eventID))) { %>
		<span id="remark2-box_<c:out value="${row.fields9}" />">
			<br/><%=("8189".equals(eventID))?"Remark:":"Name:" %><input type="textfield" name="remarks2" id="remarks2_<c:out value="${row.fields9}" />" value="<c:out value="${row.fields23 }" />" />
		</span>
<%} %>
	</display:column>
	<display:column titleKey="prompt.staffName"  media="csv excel xml pdf" style="width:20%">
		<c:out value="${row.fields10}" />
		<c:if test="${not empty row.fields23}">
		   (<c:out value="${row.fields23 }" />)
		</c:if>
	</display:column>
<% if (ConstantsServerSide.SITE_CODE.toUpperCase().equals("HKAH")) {%>
	<display:column title="Display Name"  media="csv excel xml pdf" style="width:20%">
		<c:out value="${row.fields24}" />
	</display:column>
<% } %>
	<display:column titleKey="prompt.staffID" style="width:5%">
	 <c:out value="${row.fields9}" />
	</display:column>
	<display:column titleKey="prompt.department" style="width:20%">
		<c:out value="${row.fields12}" />
	</display:column>
		<display:column  titleKey="prompt.category" style="width:10%">
		<% String tempCategory = StaffDB.getEduCategory(((ReportableListObject) pageContext.getAttribute("row")).getFields9()); %>
		<%=(tempCategory != null? tempCategory : "") %>
	</display:column>
	<display:column title="Position" style="width:10%">
		<%=!"".equals(((ReportableListObject) pageContext.getAttribute("row")).getFields9())?("se".equals(((ReportableListObject) pageContext.getAttribute("row")).getFields9().substring(0, 2))?"":StaffDB.getPosition(((ReportableListObject) pageContext.getAttribute("row")).getFields9())):"" %>
	</display:column>
	<display:column titleKey="prompt.status" style="width:10%">
		<logic:equal name="row" property="fields8" value="1">
			<bean:message key="label.attend" /> at <c:out value="${row.fields7}" /> <c:out value="${row.fields14}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="1">
			<bean:message key="label.enrolled" />
		</logic:notEqual>
	</display:column>
	<display:column title="On Duty" style="width:10%" media="csv excel xml pdf">
		<logic:equal name="row" property="fields15" value="1">
			Yes
		</logic:equal>
		<logic:notEqual name="row" property="fields15" value="1">
			No
		</logic:notEqual>
	</display:column>
	<display:column title="On Duty" style="width:15%" media="html">
<%
	String onDuty = rlo == null ? null : ((ReportableListObject) pageContext.getAttribute("row")).getFields15();
%>
		<input type="radio" name="onDuty_<%=((ReportableListObject) pageContext.getAttribute("row")).getFields3() %>" value="1" <%="1".equals(onDuty) ? "checked=\"checked\"" :("".equals(onDuty) ?"checked=\"checked\"" : "") %>/>Yes
		<input type="radio" name="onDuty_<%=((ReportableListObject) pageContext.getAttribute("row")).getFields3() %>" value="0" <%="0".equals(onDuty) ? "checked=\"checked\"" : "" %>/>No
	</display:column>

<%	if (ConstantsVariable.YES_VALUE.equals(requireAssessmentPass)) { %>
	<display:column titleKey="prompt.testPassDate" style="width:15%;">
<%	if (userBean.isEducationManager()) {
			if (isPassTest) { %>
		<c:out value="${row.fields13}" />
<%			} %>
<%	} %>
	</display:column>
<%	} %>

	<display:column titleKey="prompt.action" media="html" style="width:25%; text-align:center">

<%	if (userBean.isEducationManager()) { %>
		<div id="status-dates" style="text-align: left;">
<logic:notEqual name="row" property="fields8" value="1">
			<div class="input-date-box">
<%		if (EventDB.isOutsideCourse(eventID)) { %>
				Attended at
<%		 } else { %>
				Attended at
<%		 } %>
				<input type="checkbox" name="isAttendDate" id="isAttendDate_<c:out value="${row.fields3}" />" value="Y" class="isAttendDate" />
				<span id="attendDate-box" style="display:none;">
					<input type="text" name="attendDate" id="attendDate_<c:out value="${row.fields3}" />" value="<%=!StringUtils.isEmpty(attendDate) ? attendDate : classDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
				</span>
			</div>
</logic:notEqual>
<logic:equal name="row" property="fields8" value="1">
	<input type="checkbox" name="isAttendDate" value="N" class="isAttendDate" style="display:none;" />
	<input type="text" name="attendDate" value="<%=!StringUtils.isEmpty(attendDate) ? attendDate : classDate %>" style="display:none;" />
</logic:equal>
<%		if (ConstantsVariable.YES_VALUE.equals(requireAssessmentPass) && !isPassTest) { %>
			<div class="input-date-box">
<%			if (EventDB.isOutsideCourse(eventID)) { %>
				Expire at
<%			 } else { %>
				Test passed at
<%		 	 } %>
				<input type="checkbox" name="isPassTestDate" id="isPassTestDate_<c:out value="${row.fields3}" />" value="Y" class="isPassTestDate" />
				<span id="passTestDate-box" style="display:none;">
<%			if (EventDB.isOutsideCourse(eventID)) {
				String expireDate;
				if (!StringUtils.isEmpty(attendDate)) {
					String[] date = attendDate.split("/");
					expireDate = date[0]+"/"+date[1]+"/"+Integer.toString(Integer.parseInt(date[2])+2);
				} else {
					String[] date = classDate.split("/");
					expireDate = date[0]+"/"+date[1]+"/"+Integer.toString(Integer.parseInt(date[2])+2);
				}
%>
				<input type="textfield" name="passTestDate" id="passTestDate_<c:out value="${row.fields3}" />" value="<%=expireDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
<%			 } else { %>
				<input type="textfield" name="passTestDate" id="passTestDate_<c:out value="${row.fields3}" />" value="<%=!StringUtils.isEmpty(attendDate) ? attendDate : classDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
<%		 	 } %>
				</span>
			</div>
<%		} else { %>
				<input type="checkbox" name="isPassTestDate" value="N" class="isPassTestDate" style="display:none;" />
				<input type="textfield" name="passTestDate" style="display:none;" />
<%		} %>
		</div>
<%	} %>
<%	if (userBean.isEducationManager() || userBean.isAccessible("function.classEnrollment.admin.allowEnroll")) { %>
				<button onclick="submitAction('withdraw', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields9}" />', '<c:out value="${row.fields2}" />');"><bean:message key="button.withdraw" /></button>
<% 	} else if ("open".equals(scheduleStatus)) {%>
		<logic:equal name="row" property="fields11" value="<%=userDeptCode %>">
			<logic:notEqual name="row" property="fields8" value="1">
				<button onclick="submitAction('withdraw', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields9}" />', '<c:out value="${row.fields2}" />');"><bean:message key="button.withdraw" /></button>
			</logic:notEqual>
		</logic:equal>
<%	} else { %>
<%		if (userBean.isAssociatedDeptCode(((ReportableListObject)pageContext.getAttribute("row")).getFields11())) { %>
				<button onclick="submitAction('withdraw', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields9}" />', '<c:out value="${row.fields2}" />');"><bean:message key="button.withdraw" /></button>
<%		}
	}%>
	</display:column>
<% if (ConstantsServerSide.SITE_CODE.toUpperCase().equals("TWAH")) {%>
	<display:column title="Enroll Date" media="html" style="width:10%; text-align:center">
		<c:out value="${row.fields20}" />
	</display:column>
<% } %>
<%	if (lunchAva != null && "Y".equals(lunchAva)) { %>
	<c:set var="tempEnrollDept" value="${row.fields11}"/>
	<c:set var="tempLunchAva" value="${row.fields21}"/>
	<display:column title="Order Lunch" media="html" style="width:10%; text-align:center">

<%
		String tempEnrollDept = (String)pageContext.getAttribute("tempEnrollDept");
		String tempLunchAva = (String)pageContext.getAttribute("tempLunchAva");
		if ((tempEnrollDept != null && tempEnrollDept.equals(userDeptCode)) || (userBean.isAssociatedDeptCode(((ReportableListObject)pageContext.getAttribute("row")).getFields11()))||true) {
			Calendar today = Calendar.getInstance();
			Calendar cutOffDate = null;
			boolean allowEdit = false;
			DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
			if (classDate != null && classDate.length() > 0) {
				Date date = df.parse(classDate);
				cutOffDate = Calendar.getInstance();
				cutOffDate.setTime(date);
				if (cutOffDate.get(Calendar.DAY_OF_WEEK)==Calendar.FRIDAY) {
					cutOffDate.add(Calendar.DAY_OF_MONTH, -4);
				} else {
					cutOffDate.add(Calendar.DAY_OF_MONTH, -6);
				}
				cutOffDate.set(Calendar.HOUR_OF_DAY, 13);
			}

			if (cutOffDate != null && today.before(cutOffDate)) {
				allowEdit = true;
			}

%>
<%			if ("N".equals(tempLunchAva)) { %>
<%				if (allowEdit) {	%>
				<input <%="N".equals(tempLunchAva)?"":"checked" %> id='lunchChkBox<c:out value="${row.fields9}" />' onclick="return submitAction('lunch', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields9}" />', '<c:out value="${row.fields2}" />');" type="checkbox" >
<%				} else { %>
					No
<%				} %>
<%			} else { %>
<%				if (allowEdit) {	%>
				<input <%="N".equals(tempLunchAva)?"":"checked" %> id='lunchChkBox<c:out value="${row.fields9}" />' onclick="return submitAction('lunch', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields9}" />', '<c:out value="${row.fields2}" />');" type="checkbox" >
<%				} else { %>
					Yes
<%				} %>
<%			} %>
<%
		} else if (userBean.isEducationManager() || userBean.isAdmin()) { %>
<%			if ("N".equals(tempLunchAva)) { %>
				<input <%="N".equals(tempLunchAva)?"":"checked" %> id='lunchChkBox<c:out value="${row.fields9}" />' onclick="return submitAction('lunch', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields9}" />', '<c:out value="${row.fields2}" />');" type="checkbox" >
<%			} else { %>
				<input <%="N".equals(tempLunchAva)?"":"checked" %> id='lunchChkBox<c:out value="${row.fields9}" />' onclick="return submitAction('lunch', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields9}" />', '<c:out value="${row.fields2}" />');" type="checkbox" >
<%			} %>
<%		} else { %>
			<logic:equal name="row" property="fields21" value="Y">
				Yes
			</logic:equal>
			<logic:notEqual name="row" property="fields21" value="Y">
				No
			</logic:notEqual>
<%
		}
%>
	</display:column>
<% } %>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>

<%
	if (class_enrollment != null && !class_enrollment.isEmpty()) {
%>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="submitAction('updateDate', '', '');"><bean:message key="button.update" /></button>
			<input type="checkbox" id="allAttend" />&nbsp;Select all attend
<% if (ConstantsVariable.YES_VALUE.equals(requireAssessmentPass)) { %>
			<input type="checkbox" id="allPassTest" />&nbsp;Select all pass
<% } %>
		</td>
	</tr>
</table>
<%
	}
%>


<%
if (ConstantsServerSide.SITE_CODE.equals("hkah")) {
	if (!classSize.equals(classEnrolled)) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.enrollment" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
			<select name="deptCode" onchange="return changeStaffID()">
				<option value="">--- Select Departments ---</option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="allowAll" value="<%=allowAll %>" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffName" /></td>
		<td class="infoData" width="70%">
			Search By Staff No
			<input type="textfield" name="staffNo" value="" maxlength="10" size="20" class="referKey" keyType='staff'/>
<% if (userBean.isEducationManager() || userBean.isAdmin()) { %>
			<table>
				<tr>
					<td width="40%">
						<span id="showStaffID_indicator">
							<select name="staffAvailable" onchange="return clearStaffNo()"  size="10" multiple id="select1">
			<%if (deptCode != null && deptCode.length() > 0) { %>
			<jsp:include page="../ui/staffIDCMB.jsp" flush="true">
				<jsp:param name="showDeptDesc" value="Y" />
				<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
				<jsp:param name="deptCode" value="<%=deptCode %>" />
				<jsp:param name="showStaffID" value="Y" />
			</jsp:include>
			<%} %>
							</select>
						</span>
					</td>
					<td width="20%">
						<button id="add"><bean:message key="button.add" /> >></button><br/>
						<button id="remove"><< <bean:message key="button.delete" /></button>
					</td>
					<td width="40%">
						<select name="staffName" size="10" multiple id="select2">
						</select>
					</td>
				</tr>
			</table>
<%} else { %>
			<br/>
			<span id="showStaffID_indicator">
				<select name="staffName" onchange="return clearStaffNo()">
				<%if (deptCode != null && deptCode.length() > 0) { %>
					<jsp:include page="../ui/staffIDCMB.jsp" flush="true">
					<jsp:param name="showDeptDesc" value="Y" />
					<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
					<jsp:param name="deptCode" value="<%=deptCode %>" />
					<jsp:param name="showStaffID" value="Y" />
					</jsp:include>
				<%} %>
				</select>
			</span>
<%} %>
		</td>
	</tr>
</table>

<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction('take', '', '');" class="btn-click"><bean:message key="button.enroll" /></button>
		</td>
	</tr>
</table>
<%}
} else {
	if (!classSize.equals(classEnrolled)) {
		if ("open".equals(scheduleStatus) || userBean.isGroupID("managerEducation") || userBean.isAccessible("function.classEnrollment.admin.allowEnroll")) { %>
	<table cellpadding="0" cellspacing="5"
		class="contentFrameMenu" border="0">
		<tr class="smallText">
			<td class="infoTitle" colspan="2"><bean:message key="prompt.enrollment" /></td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
			<td class="infoData" width="70%">
				<select name="deptCode" onchange="return changeStaffID()">
					<option value="">--- Select Departments ---</option>
	<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
		<jsp:param name="deptCode" value="<%=deptCode %>" />
		<jsp:param name="allowAll" value="<%=allowAll %>" />
	</jsp:include>
				</select>
			</td>
		</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffName" /></td>
		<td class="infoData" width="70%">
<% 			if (userBean.isEducationManager() || userBean.isAdmin()) { %>
			Search By Staff No
			<input type="textfield" name="staffNo" value="" maxlength="10" size="20" class="referKey" keyType='staff'/>
			<table>
				<tr>
					<td width="40%">
						<span id="showStaffID_indicator">
							<select name="staffAvailable" onchange="return clearStaffNo()"  size="10" multiple id="select1">
<%				if (deptCode != null && deptCode.length() > 0) { %>
			<jsp:include page="../ui/staffIDCMB.jsp" flush="true">
				<jsp:param name="showDeptDesc" value="Y" />
				<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
				<jsp:param name="deptCode" value="<%=deptCode %>" />
				<jsp:param name="showStaffID" value="Y" />
			</jsp:include>
<%				} %>
							</select>
						</span>
					</td>
					<td width="20%">
						<button id="add"><bean:message key="button.add" /> >></button><br/>
						<button id="remove"><< <bean:message key="button.delete" /></button>
					</td>
					<td width="40%">
						<select name="staffName" size="10" multiple id="select2">
						</select>
					</td>
				</tr>
			</table>
<%			} else { %>
			<span id="showStaffID_indicator">
				<select name="staffName" onchange="return clearStaffNo()">
				<%if (deptCode != null && deptCode.length() > 0) { %>
					<jsp:include page="../ui/staffIDCMB.jsp" flush="true">
					<jsp:param name="showDeptDesc" value="Y" />
					<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
					<jsp:param name="deptCode" value="<%=deptCode %>" />
					<jsp:param name="showStaffID" value="Y" />
					</jsp:include>
				<%} %>
				</select>
			</span>
<%			} %>
		</td>
	</tr>

	</table>
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
				<button onclick="return submitAction('take', '', '');" class="btn-click"><bean:message key="button.enroll" /></button>
			</td>
		</tr>
	</table>
<% 		}
	}
}
%>
<input type="hidden" name="command">
<input type="hidden" name="eventID" value="<%=eventID %>">
<input type="hidden" name="scheduleID" value="<%=scheduleID %>">
<input type="hidden" name="courseCategory" value="<%=courseCategory %>">
<input type="hidden" name="enrollID">
<input type="hidden" name="staffID">
<input type="hidden" name="tempStaffID">
<input type="hidden" name="staffList"/>
</form>
<script language="javascript">
<!--
	$(document).ready(function() {
		$('#add').click(function() {
			return !$('#select1 option:selected').appendTo('#select2');
		});

		$('#remove').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});
<%
	if (class_enrollment != null) {
		for (int i = 0; i < class_enrollment.size(); i++) {
			ReportableListObject rlo = (ReportableListObject) class_enrollment.get(i);
%>
		$('#passTestDate_<%=rlo.getFields3() %>').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#isPassTestDate_<%=rlo.getFields3() %>').click(function() {
			var passTestDate = $(this).parent().find('#passTestDate_<%=rlo.getFields3() %>');
			var span = $(this).parent().find('span');
			if ($(this).attr('checked')) {
				span.css('display', 'inline');
			} else {
				span.css('display', 'none');
			}
		});

		$('#attendDate_<%=rlo.getFields3() %>').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#isAttendDate_<%=rlo.getFields3() %>').click(function() {
			var passTestDate = $(this).parent().find('#attendDate_<%=rlo.getFields3() %>');
			var span = $(this).parent().find('span');
			if ($(this).attr('checked')) {
				span.css('display', 'inline');
			} else {
				span.css('display', 'none');
			}
		});

		var isSe = '<%=rlo.getFields9() %>';
		var isLMCScreening = "<%=rlo.getFields1() %>";
		if (isSe.substr(0,2) == 'se') {
			$('#remark2-box_<%=rlo.getFields9() %>').css('display','inline');
		} else if (isLMCSCreening = '8189') {
			$('#remark2-box_<%=rlo.getFields9() %>').css('display','inline');
		} else {
			$('#remark2-box_<%=rlo.getFields9() %>').css('display','none');
		}

<% 		} %>
		$('#allPassTest').click(function() {
			if ($(this).attr('checked')) {
				$('.isPassTestDate').filter(function(index) {return !$(this).attr('checked')}).click();
				$('.isPassTestDate').parent().find('#passTestDate-box').css('display', 'inline');
			} else {
				$('.isPassTestDate').filter(function(index) {return $(this).attr('checked')}).click();
				$('.isPassTestDate').parent().find('#passTestDate-box').css('display', 'none');
			}
		});

		$('#allAttend').click(function() {
			if ($(this).attr('checked')) {
				$('.isAttendDate').filter(function(index) {return !$(this).attr('checked')}).click();
				$('.isAttendDate').parent().find('#attendDate-box').css('display', 'inline');
			} else {
				$('.isAttendDate').filter(function(index) {return $(this).attr('checked')}).click();
				$('.isAttendDate').parent().find('#attendDate-box').css('display', 'none');
			}
		});
<% 	} %>
	});

	function submitAction(cmd, eid, sid) {
		if (cmd == 'take') {
<% if (userBean.isEducationManager() || userBean.isAdmin()) { %>
			var temp=[];
			$('#select2 option').each(function(i) {
				$(this).attr("selected", "selected");
				temp.push($(this).val());
			});
			document.form1.staffList.value=temp.join(",");
			if (temp.length <= 0) {
				alert('<bean:message key="error.staffID.required" />!');
				document.form1.staffNo.focus();
				return false;
			}
<%} else {%>
			sid = document.form1.staffName.value;
			if (sid == '') {
				alert('<bean:message key="error.staffID.required" />!');
				document.form1.staffName.focus();
				return false;
			}
<%}%>
		} else if (cmd == 'updateDate') {
			var isPassTestDate = document.getElementsByName('isPassTestDate');
			for (i = 0; i < isPassTestDate.length; i++) {
				if (!isPassTestDate[i].checked) {
					isPassTestDate[i].value = 'N';
					isPassTestDate[i].checked = true;

				}
			}
			var isAttendDate = document.getElementsByName('isAttendDate');
			for (i = 0; i < isAttendDate.length; i++) {
				if (!isAttendDate[i].checked) {
					isAttendDate[i].value = 'N';
					isAttendDate[i].checked = true;
				}
			}

		}
		if (cmd == 'lunch') {
			if (document.getElementById('lunchChkBox' + sid).checked) {
			    cmd='eatLunch';
			} else {
			    cmd='removeLunch';
			}
		}
		document.form1.command.value = cmd;
		document.form1.enrollID.value = eid;
		document.form1.staffID.value = sid;
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function changeStaffID() {
		var did = document.form1.deptCode.value;

		http.open('get', '../ui/staffIDCMB.jsp?showDeptDesc=N&siteCode=<%=ConstantsServerSide.SITE_CODE %>&deptCode=' + did + '&showStaffID=Y&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponseStaffID;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function processResponseStaffID() {
		//check if the response has been received from the server
		if (http.readyState == 4) {
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
<% if (userBean.isEducationManager() || userBean.isAdmin()) { %>
			document.getElementById("showStaffID_indicator").innerHTML = '<select name="staffName" onchange="return clearStaffNo()" size="10" multiple id="select1"><option value=""></option>' + response + '</select>';
			if (document.form1.tempStaffID.value != null && document.form1.tempStaffID.value.length > 0) {
				$('#select1').val(document.form1.tempStaffID.value);
				!$('#select1 option:selected').appendTo('#select2');
			}
			document.form1.staffNo.focus();
<%			} else { %>
			document.getElementById("showStaffID_indicator").innerHTML = '<select name="staffName" onchange="return clearStaffNo()"><option value=""></option>' + response + '</select>';
			document.form1.staffName.value=document.form1.tempStaffID.value;
			document.form1.tempStaffID.value='';
			// reset staff id
			document.form1.nomineeStaffID.value = "";
<%			} %>
		}
	}

	$('.referKey').blur(function() {
		getRelatedInfo($(this).attr('keyType'), $(this).val(), $(this));
	});

	function getRelatedInfo(type, key, dom) {
		while(!$(dom).is('table')) {
			dom = $(dom).parent();
		}

		if (type == 'staff') {
			$.ajax({
				url: "../ui/staffInfoCMB.jsp?callback=?",
				data: "staffid="+key,
				dataType: "jsonp",
				cache: false,
				success: function(values) {
					document.form1.deptCode.value =  values['DEPTCODE'];
					changeStaffID();
					document.form1.tempStaffID.value = values['STAFFID'];
					document.form1.staffNo.value = '';
				},
				error: function(x, s, e) {
					if (key.length > 0) {
						alert("Staff ID could not be found.");
					}
				}
			});
		}
	}

	function clearStaffNo() {
		document.form1.staffNo.value = '';
	}

	$(document).keypress(
	    function(event) {
	     if (event.which == '13') {
		event.preventDefault();
	      }


	});
-->
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>