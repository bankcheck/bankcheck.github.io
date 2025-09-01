<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%
UserBean userBean = new UserBean(request);

String category = "title.education";
String[] months = new String [] {
	MessageResources.getMessage(session, "label.january"),
	MessageResources.getMessage(session, "label.february"),
	MessageResources.getMessage(session, "label.march"),
	MessageResources.getMessage(session, "label.april"),
	MessageResources.getMessage(session, "label.may"),
	MessageResources.getMessage(session, "label.june"),
	MessageResources.getMessage(session, "label.july"),
	MessageResources.getMessage(session, "label.august"),
	MessageResources.getMessage(session, "label.september"),
	MessageResources.getMessage(session, "label.october"),
	MessageResources.getMessage(session, "label.november"),
	MessageResources.getMessage(session, "label.december") };
String[] days = new String[] {
	MessageResources.getMessage(session, "label.sunday"),
	MessageResources.getMessage(session, "label.monday"),
	MessageResources.getMessage(session, "label.tuesday"),
	MessageResources.getMessage(session, "label.wednesday"),
	MessageResources.getMessage(session, "label.thursday"),
	MessageResources.getMessage(session, "label.friday"),
	MessageResources.getMessage(session, "label.saturday") };

/** The days in each month. */
int dom[] = {
	31, 28, 31, 30,	/* jan feb mar apr */
	31, 30, 31, 31,	/* may jun jul aug */
	30, 31, 30, 31	/* sep oct nov dec */
};

// get first day of select month
Calendar calendar = Calendar.getInstance();
String currentDate = DateTimeUtil.formatDate(calendar.getTime());
String selectYear = request.getParameter("select_year");
String selectMonth = request.getParameter("select_month");
if (selectYear != null) {
	calendar.set(Calendar.YEAR, Integer.parseInt(selectYear));
}
if (selectMonth != null) {
	calendar.set(Calendar.MONTH, Integer.parseInt(selectMonth));
}
calendar.set(Calendar.DATE, 1);

// Compute how much to leave before the first.
// getDay(  ) returns 0 for Sunday, which is just right.
int leadGap = calendar.get(Calendar.DAY_OF_WEEK) - 1;

int selectYearInt = calendar.get(Calendar.YEAR);
int selectMonthInt = calendar.get(Calendar.MONTH);
int daysInMonth = dom[selectMonthInt];
if (selectMonthInt == 1 && ((GregorianCalendar) calendar).isLeapYear(calendar.get(Calendar.YEAR))) {
	++daysInMonth;
}

HashMap classMap = new HashMap();
StringBuffer classInfo = new StringBuffer();
Vector classForSameDay = null;

int labelColor = 0;
String labelColorBlue = "#39A9DE"; 
String labelColorRed = "#C00000";
String labelColorPurple = "#F000F0";
String labelColorBlack = "#000000";
String labelColorGreen = "#00C000";
String labelColorOrange = "#DCA010";
String labelColorYellow = "#BEBE0C";
String labelColorBrown = "#9B6802";

boolean allowEnroll = false;
boolean fullEnroll = false;

String calendarDate = DateTimeUtil.formatDate(calendar.getTime());
String startDate = calendarDate;
boolean allowEdit = userBean.isGroupID("managerEducation");

String command = request.getParameter("command");
String step = request.getParameter("step");

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

// retrieve from datebase
String courseID = request.getParameter("courseID");
String classID = request.getParameter("classID");
String courseDesc = null;
String scheduleID = null;
String scheduleDesc = null;
String courseRemark = null;
String classDate = null;
String classStartTime = null;
String classEndTime = null;
String location = null;
String lecturer = null;
String courseCategory = null;
String courseType = null;
String classSize = null;
String enrolled = null;
String available = null;
String scheduleStatus = null;
String scheduleShowRegOnline = null;
String deleteScheduleID = request.getParameter("deleteScheduleID");
String compulsoryCourseID = request.getParameter("compulsoryCourseID");
String inserviceCourseID = request.getParameter("inserviceCourseID");
String cneCourseID = request.getParameter("cneCourseID");
String fireDrillCourseID = request.getParameter("fireDrillCourseID");
String tNDCourseID = request.getParameter("tNDCourseID");
String intClassCourseID = request.getParameter("intClassCourseID");
String mockCodeCourseID = request.getParameter("mockCodeCourseID");
String mockDrillCourseID = request.getParameter("mockDrillCourseID");

String currentDuration = request.getParameter("currentDuration");
if (currentDuration!= null && currentDuration.equals("0.0")) {
	currentDuration = null;
}
String classNewsID;
String showRegOnline = request.getParameter("showRegOnline");
String lunchAva = request.getParameter("lunchAva");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean copyAction = false;
boolean viewAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("copy".equals(command)) {
	copyAction = true;
} else if ("view".equals(command)) {
	viewAction = true;
}

String currentCourseID = request.getParameter("currentCourseID");
if (currentCourseID == null || currentCourseID.length() == 0) {
	currentCourseID = courseID;
}
String currentCourseDesc = null;
String currentClassID = request.getParameter("currentClassID");
if (currentClassID == null || currentClassID.length() == 0) {
	currentClassID = classID;
}
String currentScheduleDesc = TextUtil.parseStrUTF8(request.getParameter("currentScheduleDesc"));
String currentStartDate = null;
String currentStartDate_yy = request.getParameter("currentStartDate_yy");
String currentStartDate_mm = request.getParameter("currentStartDate_mm");
String currentStartDate_dd = request.getParameter("currentStartDate_dd");
String currentStartTime = null;
String currentStartTime_hh = request.getParameter("currentStartTime_hh");
String currentStartTime_mi = request.getParameter("currentStartTime_mi");
String currentEndTime = null;
String currentEndTime_hh = request.getParameter("currentEndTime_hh");
String currentEndTime_mi = request.getParameter("currentEndTime_mi");
String currentLocationID = request.getParameter("currentLocationID");
String currentLocationDesc = TextUtil.parseStrUTF8(request.getParameter("currentLocationDesc"));
String currentLecturer = TextUtil.parseStrUTF8(request.getParameter("currentLecturer"));
String currentClassSize = request.getParameter("currentClassSize");
String currentStatus = request.getParameter("currentStatus");
String educationCourseType = request.getParameter("educationCourseType");
String relatedNewsID = request.getParameter("relatedNewsID");

ReportableListObject row = null;

try {
	if ("1".equals(step)) {
		Date dateTimeFrom = null;
		Date dateTimeTo = null;
		currentStartDate = currentStartDate_dd + "/" + currentStartDate_mm + "/" + currentStartDate_yy;

		String currentStartDateTime = ConstantsVariable.EMPTY_VALUE;
		if (currentStartTime_hh != null && currentStartTime_hh.length() > 0) {
			currentStartDateTime = currentStartDate + " " + currentStartTime_hh + ":" + currentStartTime_mi + ":00";
		} else {
			currentStartDateTime = currentStartDate + " 00:00:00";
		}
		String currentEndDateTime = ConstantsVariable.EMPTY_VALUE;
		if (currentEndTime_hh != null && currentEndTime_hh.length() > 0) {
			currentEndDateTime = currentStartDate + " " + currentEndTime_hh + ":" + currentEndTime_mi + ":00";
		}

		if ((createAction || updateAction) && (currentClassSize == null || currentClassSize.length() == 0 || !TextUtil.isNumber(currentClassSize))) {
			errorMessage = "Invalid size.";
		} else if (createAction || updateAction) {
			dateTimeFrom = DateTimeUtil.parseDateTime(currentStartDateTime);
			currentStartDateTime = DateTimeUtil.formatDateTime(dateTimeFrom);
			if (currentEndDateTime != null && currentEndDateTime.length() > 0) {
				dateTimeTo = DateTimeUtil.parseDateTime(currentEndDateTime);
				currentEndDateTime = DateTimeUtil.formatDateTime(dateTimeTo);
			}
		}

		if (errorMessage == null) {
			scheduleID = ScheduleDB.getScheduleIDByDateTime("education", currentCourseID, currentStartDateTime, currentEndDateTime);

			if (createAction) {
				if (scheduleID == null || scheduleID.length() == 0) {
					if ("compulsory".equals(educationCourseType)) {
						scheduleID = ScheduleDB.add(userBean, "education", compulsoryCourseID, currentScheduleDesc,
								currentStartDateTime, currentEndDateTime,
								currentDuration, currentLocationID, currentLocationDesc, currentLecturer,
								currentClassSize, currentStatus, showRegOnline, lunchAva);
					} else if ("inservice".equals(educationCourseType)) {
						scheduleID = ScheduleDB.add(userBean, "education", inserviceCourseID, currentScheduleDesc,
								currentStartDateTime, currentEndDateTime,
								currentDuration, currentLocationID, currentLocationDesc, currentLecturer,
								currentClassSize, currentStatus, showRegOnline, lunchAva);
					} else if ("CNE".equals(educationCourseType)) {
						scheduleID = ScheduleDB.add(userBean, "education", cneCourseID, currentScheduleDesc,
								currentStartDateTime, currentEndDateTime,
								currentDuration, currentLocationID, currentLocationDesc, currentLecturer,
								currentClassSize, currentStatus, showRegOnline, lunchAva);
					} else if ("firedrill".equals(educationCourseType)) {
						scheduleID = ScheduleDB.add(userBean, "education", fireDrillCourseID, currentScheduleDesc,
								currentStartDateTime, currentEndDateTime,
								currentDuration, currentLocationID, currentLocationDesc, currentLecturer,
								currentClassSize, currentStatus, showRegOnline, lunchAva);
					} else if ("tND".equals(educationCourseType)) {
						scheduleID = ScheduleDB.add(userBean, "education", tNDCourseID, currentScheduleDesc,
								currentStartDateTime, currentEndDateTime,
								currentDuration, currentLocationID, currentLocationDesc, currentLecturer,
								currentClassSize, currentStatus, showRegOnline, lunchAva);
					} else if ("intClass".equals(educationCourseType)) {
						scheduleID = ScheduleDB.add(userBean, "education", intClassCourseID, currentScheduleDesc,
								currentStartDateTime, currentEndDateTime,
								currentDuration, currentLocationID, currentLocationDesc, currentLecturer,
								currentClassSize, currentStatus, showRegOnline, lunchAva);
					} else if ("mockCode".equals(educationCourseType)) {
						scheduleID = ScheduleDB.add(userBean, "education", mockCodeCourseID, currentScheduleDesc,
								currentStartDateTime, currentEndDateTime,
								currentDuration, currentLocationID, currentLocationDesc, currentLecturer,
								currentClassSize, currentStatus, showRegOnline, lunchAva);
					} else if ("mockDrill".equals(educationCourseType)) {
						scheduleID = ScheduleDB.add(userBean, "education", mockDrillCourseID, currentScheduleDesc,
								currentStartDateTime, currentEndDateTime,
								currentDuration, currentLocationID, currentLocationDesc, currentLecturer,
								currentClassSize, currentStatus, showRegOnline, lunchAva);
					} else {
						scheduleID = ScheduleDB.add(userBean, "education", currentCourseID, currentScheduleDesc,
								currentStartDateTime, currentEndDateTime,
								currentDuration, currentLocationID, currentLocationDesc, currentLecturer,
								currentClassSize, currentStatus, showRegOnline, lunchAva);
					}
					if (scheduleID == null || scheduleID.length() == 0) {
						errorMessage = "schedule is fail to create.";
					} else {
						message = "schedule is created.";
					}
				} else {
					errorMessage = "schedule is already existed.";
				}
			} else if (updateAction) {
				if (ScheduleDB.update(userBean, "education", currentCourseID, currentClassID, currentScheduleDesc,
						currentStartDateTime, currentEndDateTime, currentDuration,
						currentLocationID, currentLocationDesc, currentLecturer,
						currentClassSize, currentStatus,relatedNewsID,showRegOnline, lunchAva)) {
					message = "schedule is updated.";
					updateAction = false;
				} else {
					errorMessage = "schedule update fail.";
				}
			} else if (deleteAction) {
				if (ScheduleDB.delete(userBean, "education", courseID, deleteScheduleID)) {
					message = MessageResources.getMessage(session, "message.schedule.deleteSuccess");
					deleteAction = false;
					command = "";
					step = null;
				} else {
					errorMessage = MessageResources.getMessage(session, "message.schedule.deleteFail");
				}
			}
			step = null;
		}
	} else {
		if (!createAction && currentCourseID != null && currentCourseID.length() > 0) {
			ArrayList result = ScheduleDB.get("education", currentCourseID, currentClassID);
			if (result.size() > 0) {
				row = (ReportableListObject) result.get(0);
				currentCourseDesc = row.getValue(2);
				currentScheduleDesc = row.getValue(3);
				currentStartDate = row.getValue(4);
				currentStartTime = row.getValue(5);
				currentEndTime = row.getValue(6);
				currentLocationID = row.getValue(8);
				currentLocationDesc = row.getValue(9);
				if (currentLocationID == null || currentLocationID.length() == 0) {
					currentLocationDesc = row.getValue(10);
				}
				currentDuration = row.getValue(7);
				currentLecturer = row.getValue(11);
				currentClassSize = row.getValue(12);
				currentStatus = row.getValue(14);
				relatedNewsID = row.getValue(16);
				showRegOnline = row.getValue(17);
				lunchAva = row.getValue(19);
			}
		}
	}

	if (copyAction) {
		createAction = true;
		command = "create";
	}

	boolean courseDetail = false;
	Random random = new Random();

	ArrayList record = ScheduleDB.getCalendar(userBean.getDeptCode(), calendarDate, daysInMonth + calendarDate.substring(2));
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			courseID = row.getValue(0);
			classID = row.getValue(1);
			courseDesc = row.getValue(2);
			scheduleDesc = row.getValue(3);
			courseRemark = row.getValue(4);
			classDate = row.getValue(5);
			classStartTime = row.getValue(6);
			classEndTime = row.getValue(7);
			location = row.getValue(8);
			if (location == null || location.length() == 0) {
				location = row.getValue(9);
			}
			lecturer = row.getValue(10);
			courseCategory = row.getValue(11);
			courseType = row.getValue(12);
			classSize = row.getValue(13);
			enrolled = row.getValue(14);
			available = row.getValue(15);
			classNewsID = row.getValue(16);
			scheduleShowRegOnline = row.getValue(17);
			scheduleStatus = row.getValue(18);
			allowEnroll = !ConstantsVariable.ZERO_VALUE.equals(classSize);
			fullEnroll = enrolled.equals(classSize);
			courseDetail = false;

			Calendar today = Calendar.getInstance();
			Calendar enrollCutOffDate = null;
			boolean tempClose = false;
			String tempClassDate = classDate;
			DateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			if(tempClassDate != null && tempClassDate.length() > 0){
				tempClassDate = tempClassDate + " " + classStartTime;
				Date date = df.parse(tempClassDate);
				enrollCutOffDate = Calendar.getInstance();
				enrollCutOffDate.setTime(date);
			}
			if(ConstantsServerSide.isTWAH()){
				if(today.after(enrollCutOffDate)){
					tempClose = true;
				}
			}

			// reset class info storage
			classInfo.setLength(0);
			try {
				labelColor = Integer.parseInt(courseID) % 9 + 1;
			} catch (Exception e) {
				labelColor = random.nextInt(8) + 1;
			}
			classInfo.append("<div style=\"padding: 4px;\">");
			if (allowEnroll) {
				classInfo.append("<a href=\"javascript:void(0);\" onclick=\"submitCalendarAction('");
				if ("compulsory".equals(courseCategory)
						&& ConstantsServerSide.isHKAH()	// special handling for hkah only
						&& !"1060".equals(courseID)
						&& !"7427".equals(courseID)	&& !"7426".equals(courseID) // special handling for Hospital Orientation
						) {
					if (ConstantsCourseVariable.CPR_CLASS_ID.equals(courseID)) {
						classInfo.append("run_down_compulsory.jsp");
						courseDesc = "CPR COMPULSORY CLASS";
					} else if (courseDesc.indexOf("ACHS") >= 0) {
						// special for ACHS
						classInfo.append("class_enrollment.jsp");
					} else if (courseDesc.indexOf("Mock") >= 0) {
						classInfo.append("class_enrollment.jsp");
					} else {
						classInfo.append("run_down_orientation.jsp");
					}
				} else {
					classInfo.append("class_enrollment.jsp");
				}
				classInfo.append("', '");
				classInfo.append(classDate);
				classInfo.append("', '");
				classInfo.append(courseID);
				classInfo.append("', '");
				classInfo.append(classID);
				classInfo.append("');return false;\" ");
			} else {
				classInfo.append("<span ");
			}
			if(ConstantsServerSide.isHKAH()){
				classInfo.append("style=\"color:");
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
			}else if(ConstantsServerSide.isTWAH()){
				classInfo.append("class=\"labelColor");
				classInfo.append(labelColor);
			}
			classInfo.append("\">");
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
			if (classNewsID != null && classNewsID.length() > 0) {
				classInfo.append("<br/><a href=\"javascript:void(0);\" style='text-decoration:none;font-weight:bold;font-size:16px;background-color:#FFDA71;' onclick=\"readNews('"+classNewsID+"');return false;\">Details</a>");
				ArrayList newsRecord = NewsDB.getContent(classNewsID, "education");
				if (newsRecord.size() > 0) {
					ReportableListObject newsRow = (ReportableListObject) newsRecord.get(0);
					Pattern pattern = Pattern.compile("(?i)(<a href.*?>)(.+?)(</a>)");
					Matcher matcher =  pattern.matcher(newsRow.getValue(0));
					while (matcher.find()) {
						String startTag = matcher.group().replaceAll("(?i)(<a href.*?>)(.+?)(</a>)", "$1");

						classInfo.append(startTag.substring(0, startTag.length()-1) + " target='_blank'>");
						classInfo.append("<img width='24' height='24' src='../images/pdf.gif'>");
						classInfo.append(matcher.group().replaceAll("(?i)(<a href.*?>)(.+?)(</a>)", "$3"));
					}
				}
			}

			if (allowEnroll) {
				classInfo.append("</a><div style=\"margin: 5px 0; text-transform: uppercase;\"\">");
				if (fullEnroll) {
					classInfo.append("FULLY REGISTERED");
				} else {
					if(tempClose){
						classInfo.append(MessageResources.getMessage(session, "label.close"));
					}else{
						if ("open".equals(scheduleStatus)){
							if (!"N".equals(scheduleShowRegOnline)) {
								classInfo.append("<BLINK>REGISTER ON-LINE</BLINK><br>");
							} else {
							}
							classInfo.append("(");
							classInfo.append("<b>" + available + "</b>");
							classInfo.append(" AVAILABLE)");
						}else if ("suspend".equals(scheduleStatus)){
							classInfo.append(MessageResources.getMessage(session, "label.suspend"));
						}else if ("close".equals(scheduleStatus)){
							classInfo.append(MessageResources.getMessage(session, "label.close"));
						}
					}
			}
				classInfo.append("</div>");
			} else {
				classInfo.append("</span>");
			}
			
			if (allowEdit) {
				classInfo.append(" [ <a href=\"javascript:void(0);\" onclick=\"submitViewAction('view', '0', '");
				classInfo.append(courseID);
				classInfo.append("', '");
				classInfo.append(classID);
				classInfo.append("');return false;\">Edit</a> ]");
			}
			//classInfo.append("<p>");
			classInfo.append("</div>");

			// store in hash map
			if (classMap.containsKey(classDate)) {
				classForSameDay = (Vector) classMap.get(classDate);
			} else {
				classForSameDay = new Vector();
			}
			classForSameDay.add(classInfo.toString());
			classMap.put(classDate, classForSameDay);
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
	String commandType = null;
	if (createAction || updateAction || deleteAction) {
		commandType = command;
		// set submit label
		title = "function.classSchedule." + commandType;
	} else {
		commandType = "view";
		// set submit label
		title = "title.education.monthlyCalendar";
	}
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form_calendar" action="education_calendar.jsp" method="post">
<%if (allowEdit) { %>
<%	if (createAction || updateAction || deleteAction || viewAction) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.course" /></td>
		<td class="infoData" width="70%">
<%		if (createAction) {%>
			<div>
			<input type="radio" name="SelectCourseType" id ="SelectCourseType" value="Y"  onclick="onChangeCourseStyle();" checked>Mandatory</input>
			<input type="radio" name="SelectCourseType" id ="SelectCourseType" value="I"  onclick="onChangeCourseStyle();">In-services and Special Training</input>
			<input type="radio" name="SelectCourseType" id ="SelectCourseType" value="N"  onclick="onChangeCourseStyle();">Other</input>
			<input type="radio" name="SelectCourseType" id ="SelectCourseType" value="C"  onclick="onChangeCourseStyle();">CNE</input>
<%			if(ConstantsServerSide.isTWAH()){ %>		
				<input type="radio" name="SelectCourseType" id ="SelectCourseType" value="F"  onclick="onChangeCourseStyle();">Fire and Disaster Drills</input>
<%			} %>				
				<input type="radio" name="SelectCourseType" id ="SelectCourseType" value="T"  onclick="onChangeCourseStyle();">T&D</input>
			<%if(ConstantsServerSide.isHKAH()){ %>
				<input type="radio" name="SelectCourseType" id ="SelectCourseType" value="A"  onclick="onChangeCourseStyle();">Interest Class / Other Activities</input>
				<input type="radio" name="SelectCourseType" id ="SelectCourseType" value="M"  onclick="onChangeCourseStyle();">Mock Code</input>
				<input type="radio" name="SelectCourseType" id ="SelectCourseType" value="D"  onclick="onChangeCourseStyle();">Drill</input>
				<!-- <input type="radio" name="SelectCourseType" id ="SelectCourseType" value="N"  onclick="onChangeCourseStyle();">Other</input>-->
<%			} %>
			</div>
			<input type="textfield" name="newEventDesc" value="" maxlength="500" size="50" onkeypress="filterCourse(this.value, event)" style="display:none"/>
			<button id="addCourseButton" onclick="return addNewCourse();"style="display:none"><bean:message key="button.search" />/<bean:message key="button.add" /></button>


			<div id="courseIDDropDown">
				<select name="currentCourseID" style="display:none">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventID" value="<%=currentCourseID %>" />
	<jsp:param name="eventType" value="class" />
</jsp:include>
				</select>
				<select name="inserviceCourseID" style="display:none">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventCategory" value="inservice" />
	<jsp:param name="eventID" value="<%=inserviceCourseID %>" />
	<jsp:param name="eventType" value="class" />
</jsp:include>
				</select>
				<select name="cneCourseID" style="display:none">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventCategory" value="CNE" />
	<jsp:param name="eventID" value="<%=cneCourseID %>" />
	<jsp:param name="eventType" value="class" />
</jsp:include>
				</select>
				<select name="fireDrillCourseID" style="display:none">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventCategory" value="firedrill" />
	<jsp:param name="eventID" value="<%=fireDrillCourseID %>" />
	<jsp:param name="eventType" value="class" />
</jsp:include>
				</select>
				<select name="tNDCourseID" style="display:none">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventCategory" value="tND" />
	<jsp:param name="eventID" value="<%=tNDCourseID %>" />
	<jsp:param name="eventType" value="class" />
</jsp:include>
				</select>
				<select name="intClassCourseID" style="display:none">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventCategory" value="intClass" />
	<jsp:param name="eventID" value="<%=intClassCourseID %>" />
	<jsp:param name="eventType" value="class" />
</jsp:include>
				</select>
				<select name="compulsoryCourseID">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventCategory" value="compulsory" />
	<jsp:param name="eventID" value="<%=compulsoryCourseID %>" />
	<jsp:param name="eventType" value="class" />
</jsp:include>
				</select>
				<select name="mockCodeCourseID">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventCategory" value="mockCode" />
	<jsp:param name="eventID" value="<%=compulsoryCourseID %>" />
	<jsp:param name="eventType" value="class" />
</jsp:include>
				</select>
				<select name="mockDrillCourseID">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventCategory" value="mockDrill" />
	<jsp:param name="eventID" value="<%=compulsoryCourseID %>" />
	<jsp:param name="eventType" value="class" />
</jsp:include>
				</select>
				<select name="otherCourseID">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventCategory" value="other" />
	<jsp:param name="eventID" value="<%=compulsoryCourseID %>" />
	<jsp:param name="eventType" value="class" />
</jsp:include>
				</select>
			</div>
<%		} else {%>
			<%=currentCourseDesc==null?"":currentCourseDesc %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.description" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="currentScheduleDesc" value="<%=currentScheduleDesc==null?"":currentScheduleDesc %>" maxlength="500" size="50">
<%		} else {%>
			<%=currentScheduleDesc==null?"":currentScheduleDesc %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.classDate" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="currentStartDate" />
	<jsp:param name="date" value="<%=currentStartDate %>" />
	<jsp:param name="isShowNextYear" value="Y" />
</jsp:include> -
<%		} else {%>
			<%=currentStartDate %>
<%		} %>
		(DD/MM/YYYY)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.classTime" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="currentStartTime" />
	<jsp:param name="time" value="<%=currentStartTime %>" />
	<jsp:param name="interval" value="5" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			<button onclick="return resetCurrentStartTime();">Empty</button>
			-
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="currentEndTime" />
	<jsp:param name="time" value="<%=currentEndTime %>" />
	<jsp:param name="interval" value="5" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			<button onclick="return resetCurrentEndTime();">Empty</button>
<%		} else {%>
			<%=currentStartTime %>
			-
			<%=currentEndTime %>
<%		} %>
		(HH:MM)</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.duration" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {
			boolean checkDuration = false;
			if (currentDuration != null && currentDuration.trim().length()> 0) {
				checkDuration = true;
			}
%>
			<select name="currentDuration">
				<option value="0.0" <%=checkDuration && Float.parseFloat(currentDuration) == 0 ? "selected" : ""%>>0.0</option>
<%        if(ConstantsServerSide.isTWAH()){%>
				<option value="0.15" <%=checkDuration && Float.parseFloat(currentDuration) == 0.15 ? "selected" : ""%>>0.15</option>
<%		  } %>					
				<option value="0.5" <%=checkDuration && Float.parseFloat(currentDuration) == 0.5 ? "selected" : ""%>>0.5</option>
<%        if(ConstantsServerSide.isTWAH()){%>
				<option value="0.75" <%=checkDuration && Float.parseFloat(currentDuration) == 0.75 ? "selected" : ""%>>0.75</option>
<%		  } %>				
				<option value="1.0" <%=checkDuration && Float.parseFloat(currentDuration) == 1.0 ? "selected" : ""%>>1.0</option>
<%        if(ConstantsServerSide.isTWAH()){%>
				<option value="1.15" <%=checkDuration && Float.parseFloat(currentDuration) == 1.15 ? "selected" : ""%>>1.15</option>
<%		  } %>											
				<option value="1.5" <%=checkDuration && Float.parseFloat(currentDuration) == 1.5 ? "selected" : ""%>>1.5</option>
<%        if(ConstantsServerSide.isTWAH()){%>
				<option value="1.75" <%=checkDuration && Float.parseFloat(currentDuration) == 1.75 ? "selected" : ""%>>1.75</option>
<%		  } %>			
				<option value="2.0" <%=checkDuration && Float.parseFloat(currentDuration) == 2.0 ? "selected" : ""%>>2.0</option>
<%        if(ConstantsServerSide.isTWAH()){%>
				<option value="2.15" <%=checkDuration && Float.parseFloat(currentDuration) == 2.15 ? "selected" : ""%>>2.15</option>
<%		  } %>		
				<option value="2.5" <%=checkDuration && Float.parseFloat(currentDuration) == 2.5 ? "selected" : ""%>>2.5</option>
				<option value="3.0" <%=checkDuration && Float.parseFloat(currentDuration) == 3.0 ? "selected" : ""%>>3.0</option>
				<option value="3.5" <%=checkDuration && Float.parseFloat(currentDuration) == 3.5 ? "selected" : ""%>>3.5</option>
				<option value="4.0" <%=checkDuration && Float.parseFloat(currentDuration) == 4.0 ? "selected" : ""%>>4.0</option>
				<option value="4.5" <%=checkDuration && Float.parseFloat(currentDuration) == 4.5 ? "selected" : ""%>>4.5</option>
				<option value="5.0" <%=checkDuration && Float.parseFloat(currentDuration) == 5.0 ? "selected" : ""%>>5.0</option>
				<option value="5.5" <%=checkDuration && Float.parseFloat(currentDuration) == 5.5 ? "selected" : ""%>>5.5</option>
				<option value="6.0" <%=checkDuration && Float.parseFloat(currentDuration) == 6.0 ? "selected" : ""%>>6.0</option>
				<option value="6.5" <%=checkDuration && Float.parseFloat(currentDuration) == 6.5 ? "selected" : ""%>>6.5</option>
				<option value="7.0" <%=checkDuration && Float.parseFloat(currentDuration) == 7.0 ? "selected" : ""%>>7.0</option>
				<option value="7.5" <%=checkDuration && Float.parseFloat(currentDuration) == 7.5 ? "selected" : ""%>>7.5</option>
				<option value="8.0" <%=checkDuration && Float.parseFloat(currentDuration) == 8.0 ? "selected" : ""%>>8.0</option>
				<option value="8.5" <%=checkDuration && Float.parseFloat(currentDuration) == 8.5 ? "selected" : ""%>>8.5</option>
				<option value="9.0" <%=checkDuration && Float.parseFloat(currentDuration) == 9.0 ? "selected" : ""%>>9.0</option>
				<option value="9.5" <%=checkDuration && Float.parseFloat(currentDuration) == 9.5 ? "selected" : ""%>>9.5</option>
				<option value="10.0" <%=checkDuration && Float.parseFloat(currentDuration) == 10.0 ? "selected" : ""%>>10.0</option>
				<option value="10.5" <%=checkDuration && Float.parseFloat(currentDuration) == 10.5 ? "selected" : ""%>>10.5</option>
				<option value="11.0" <%=checkDuration && Float.parseFloat(currentDuration) == 11.0 ? "selected" : ""%>>11.0</option>
				<option value="11.5" <%=checkDuration && Float.parseFloat(currentDuration) == 11.5 ? "selected" : ""%>>11.5</option>
				<option value="12.0" <%=checkDuration && Float.parseFloat(currentDuration) == 12.0 ? "selected" : ""%>>12.0</option>
				<option value="12.5" <%=checkDuration && Float.parseFloat(currentDuration) == 12.5 ? "selected" : ""%>>12.5</option>
				<option value="13.0" <%=checkDuration && Float.parseFloat(currentDuration) == 13.0 ? "selected" : ""%>>13.0</option>
				<option value="13.5" <%=checkDuration && Float.parseFloat(currentDuration) == 13.5 ? "selected" : ""%>>13.5</option>
				<option value="14.0" <%=checkDuration && Float.parseFloat(currentDuration) == 14.0 ? "selected" : ""%>>14.0</option>
				<option value="14.5" <%=checkDuration && Float.parseFloat(currentDuration) == 14.5 ? "selected" : ""%>>14.5</option>
				<option value="15.0" <%=checkDuration && Float.parseFloat(currentDuration) == 15.0 ? "selected" : ""%>>15.0</option>
				<option value="15.5" <%=checkDuration && Float.parseFloat(currentDuration) == 15.5 ? "selected" : ""%>>15.5</option>
				<option value="16.0" <%=checkDuration && Float.parseFloat(currentDuration) == 16.0 ? "selected" : ""%>>16.0</option>
				<option value="16.5" <%=checkDuration && Float.parseFloat(currentDuration) == 16.5 ? "selected" : ""%>>16.5</option>
				<option value="17.0" <%=checkDuration && Float.parseFloat(currentDuration) == 17.0 ? "selected" : ""%>>17.0</option>
				<option value="17.5" <%=checkDuration && Float.parseFloat(currentDuration) == 17.5 ? "selected" : ""%>>17.5</option>
				<option value="18.0" <%=checkDuration && Float.parseFloat(currentDuration) == 18.0 ? "selected" : ""%>>18.0</option>
				<option value="18.5" <%=checkDuration && Float.parseFloat(currentDuration) == 18.5 ? "selected" : ""%>>18.5</option>
				<option value="19.0" <%=checkDuration && Float.parseFloat(currentDuration) == 19.0 ? "selected" : ""%>>19.0</option>
				<option value="19.5" <%=checkDuration && Float.parseFloat(currentDuration) == 19.5 ? "selected" : ""%>>19.5</option>
				<option value="20.0" <%=checkDuration && Float.parseFloat(currentDuration) == 20.0 ? "selected" : ""%>>20.0</option>
				<option value="20.5" <%=checkDuration && Float.parseFloat(currentDuration) == 20.5 ? "selected" : ""%>>20.5</option>
				<option value="21.0" <%=checkDuration && Float.parseFloat(currentDuration) == 21.0 ? "selected" : ""%>>21.0</option>
				<option value="21.5" <%=checkDuration && Float.parseFloat(currentDuration) == 21.5 ? "selected" : ""%>>21.5</option>
				<option value="22.0" <%=checkDuration && Float.parseFloat(currentDuration) == 22.0 ? "selected" : ""%>>22.0</option>
				<option value="22.5" <%=checkDuration && Float.parseFloat(currentDuration) == 22.5 ? "selected" : ""%>>22.5</option>
				<option value="23.0" <%=checkDuration && Float.parseFloat(currentDuration) == 23.0 ? "selected" : ""%>>23.0</option>
				<option value="23.5" <%=checkDuration && Float.parseFloat(currentDuration) == 23.5 ? "selected" : ""%>>23.5</option>
				<option value="24.0" <%=checkDuration && Float.parseFloat(currentDuration) == 24.0 ? "selected" : ""%>>24.0</option>
				<option value="24.5" <%=checkDuration && Float.parseFloat(currentDuration) == 24.5 ? "selected" : ""%>>24.5</option>
				<option value="25.0" <%=checkDuration && Float.parseFloat(currentDuration) == 25.0 ? "selected" : ""%>>25.0</option>
				<option value="25.5" <%=checkDuration && Float.parseFloat(currentDuration) == 25.5 ? "selected" : ""%>>25.5</option>
				<option value="26.0" <%=checkDuration && Float.parseFloat(currentDuration) == 26.0 ? "selected" : ""%>>26.0</option>
				<option value="26.5" <%=checkDuration && Float.parseFloat(currentDuration) == 26.5 ? "selected" : ""%>>26.5</option>
				<option value="27.0" <%=checkDuration && Float.parseFloat(currentDuration) == 27.0 ? "selected" : ""%>>27.0</option>
				<option value="27.5" <%=checkDuration && Float.parseFloat(currentDuration) == 27.5 ? "selected" : ""%>>27.5</option>
				<option value="28.0" <%=checkDuration && Float.parseFloat(currentDuration) == 28.0 ? "selected" : ""%>>28.0</option>
				<option value="28.5" <%=checkDuration && Float.parseFloat(currentDuration) == 28.5 ? "selected" : ""%>>28.5</option>
				<option value="29.0" <%=checkDuration && Float.parseFloat(currentDuration) == 29.0 ? "selected" : ""%>>29.0</option>
				<option value="29.5" <%=checkDuration && Float.parseFloat(currentDuration) == 29.5 ? "selected" : ""%>>29.5</option>
				<option value="30.0" <%=checkDuration && Float.parseFloat(currentDuration) == 30.0 ? "selected" : ""%>>30.0</option>
			</select>
<%		} else {%>
			<%=currentDuration %>
<%		} %></td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.location" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
			<select name="currentLocationID">
<jsp:include page="../ui/locationIDCMB.jsp" flush="false">
	<jsp:param name="locationID" value="<%=currentLocationID %>" />
	<jsp:param name="allowEmpty" value="Y" />
	<jsp:param name="emptyLabel" value="N/A" />
</jsp:include>
			</select>
			<input type="textfield" name="currentLocationDesc" value="<%=currentLocationDesc==null?"":currentLocationDesc %>" maxlength="800" size="50">
<%		} else {%>
			<%=currentLocationDesc %>
<%		} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Lecturer</td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="currentLecturer" value="<%=currentLecturer==null?"":currentLecturer %>" maxlength="500" size="100">
<%		} else {%>
			<%=currentLecturer %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.classSize" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="currentClassSize" value="<%=currentClassSize==null?"":currentClassSize %>" maxlength="3" size="50">
<%		} else {%>
			<%=currentClassSize %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.status" /></td>
<%
		boolean isOpen = "open".equals(currentStatus);
		boolean isSuspend = "suspend".equals(currentStatus);
		boolean isClosed = "close".equals(currentStatus);
		// set default value
		if (!isOpen && !isSuspend && !isClosed) {
			isOpen = true;
		}
		if (createAction || updateAction) {
%>
		<td class="infoData" width="70%">
			<input type="radio" name="currentStatus" value="open"<%=isOpen?" checked":"" %>><bean:message key="label.open" />
			<input type="radio" name="currentStatus" value="suspend"<%=isSuspend?" checked":"" %>><bean:message key="label.suspend" />
			<input type="radio" name="currentStatus" value="close"<%=isClosed?" checked":"" %>><bean:message key="label.close" /></td>
<%		} else {%>
<% 			
			String tempClassDate = currentStartDate;
			String tempClassTime = currentStartTime;
			Calendar today = Calendar.getInstance();
			Calendar enrollCutOffDate = null;
			boolean tempClose = false;
			DateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			if(tempClassDate != null && tempClassDate.length() > 0){
				tempClassDate = tempClassDate + " " + tempClassTime;
				Date date = df.parse(tempClassDate);
				enrollCutOffDate = Calendar.getInstance();
				enrollCutOffDate.setTime(date);
			}
			if(ConstantsServerSide.isTWAH()){
				if(today.after(enrollCutOffDate)){
					tempClose = true;
				}
			}
			if(tempClose){ %>
		<td class="infoData" width="70%"><bean:message key="label.close" /></td>
<%			}else{ %>
		<td class="infoData" width="70%"><%if (isOpen) { %><bean:message key="label.open" /><%} else if (isSuspend) { %><bean:message key="label.suspend" /><%} else { %><bean:message key="label.close" /><%} %></td>
<%			} %>
<%		} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Show Register Online Text?</td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {
				if(showRegOnline == null || (showRegOnline != null && showRegOnline.length() == 0)){
					showRegOnline = "N";
				}
%>
			<input type="radio" name="showRegOnline" value="Y"<%="Y".equals(showRegOnline)?" checked":"" %>>Yes
			<input type="radio" name="showRegOnline" value="N"<%="N".equals(showRegOnline)?" checked":"" %>>No
<%		} else {%>
			<%="Y".equals(showRegOnline)?"Yes":"No" %>
<%		} %>
		</td>
	</tr>
<%	if(ConstantsServerSide.isTWAH()) {%>	
	<tr class="smallText">
		<td class="infoLabel" width="30%">Provide Lunch</td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {
			if(lunchAva == null || (lunchAva != null && lunchAva.length() == 0)){
				lunchAva = "N";
			}
%>
			<input type="radio" name="lunchAva" value="Y"<%="Y".equals(lunchAva)?" checked":"" %>>Yes
			<input type="radio" name="lunchAva" value="N"<%="N".equals(lunchAva)?" checked":"" %>>No
<%		} else {%>
			<%="Y".equals(lunchAva)?"Yes":"No" %>
<%		} %>
		</td>
	</tr>
<%	} %>	
<%		if (!createAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Related News</td>
		<td class="infoData" width="50%">
		<%if (updateAction) { %>
			<select name="relatedNewsID">
				<jsp:include page="../ui/newsListCMB.jsp" flush="false">
					<jsp:param name="newsID" value="<%=relatedNewsID %>" />
					<jsp:param name="newsCategory" value="education" />
					<jsp:param name="newsType" value="classRelatedNews" />
				</jsp:include>
			</select>
		<%} else {
			ArrayList relatedNewsRecord;
			if (relatedNewsID!=null && relatedNewsID.length() > 0) {
				relatedNewsRecord = NewsDB.get(userBean, relatedNewsID, "education","1");
				System.out.println(relatedNewsRecord.size());
				if (relatedNewsRecord.size() > 0) {
					ReportableListObject relatedNewsRow = (ReportableListObject) relatedNewsRecord.get(0);
					String tempNewsTitle = relatedNewsRow.getValue(3);
					String tempNewsID = relatedNewsRow.getValue(0);
					String displayNews = "ID: "+tempNewsID+" | Headline: " + tempNewsTitle;
					%>
					<%=displayNews%>
					<%
				}
			}

		}

		if (viewAction) {
		%>
			<div>
				<button onclick="return createRelatedNews();">Create Related News</button>
			</div>
		<%
		}
		%>
		</td>
	</tr>
<%		} %>
</table>
<%	} %>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%		if (createAction || updateAction || deleteAction) { %>
			<button onclick="submitAction('<%=commandType %>', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="submitAction('cancel', 0);return false;" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		} else if (viewAction) { %>
			<button onclick="submitAction('update', 0);return false;" class="btn-click"><bean:message key="function.classSchedule.update" /></button>
			<button class="btn-delete"><bean:message key="function.classSchedule.delete" /></button>
			<button onclick="submitAction('cancel', 0);return false;" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} else { %>
			<button onclick="submitAction('create', 0);return false;" class="btn-click"><bean:message key="function.classSchedule.create" /></button>
<%		}  %>
		</td>
	</tr>
</table>
</div>
<%} %>
<% 	if(ConstantsServerSide.isTWAH()) {%>	
<table width="75%" align="center" bgcolor="yellow"  style="border:1px solid;  font-size: 17px;">
	<tr>
		<!-- <td align="center"><bean:message key="prompt.calendar.remark" /></td>-->
		<td align="center">
			To facilitate the meal ordering system, Staff Education only provide lunch for those who ordered meal <b style="color:red;">4 days before the class</b>, the meal ordering function will be closed as well. Whereas, the enrollment system will be continue until full.<br/>
			為配合課堂膳食安排, 員工培訓部只可以為<b style="color:red;">開課前四個工作天</b>，已報名及訂餐的同事提供飯餐，該課堂網上訂餐功能亦會停止。但課程報名的功能仍會繼續，直到滿額為止。
		</td>
	</tr>
</table>
<%	} %>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="bigText">
		<td width="10%" align="center"><button onclick="return switchDate(<%=selectYearInt - 1 %>, <%=selectMonthInt %>);"><< <%=selectYearInt - 1 %></button></td>
		<td width="10%" align="center"><button onclick="return switchDate(<%=selectYearInt - (selectMonthInt==0?1:0)  %>, <%=(selectMonthInt + 11) % 12 %>);"><< <%=months[(selectMonthInt + 11) % 12] %></button></td>
		<td width="60%" align="center"><%=months[selectMonthInt] %> <%=selectYearInt %></td>
		<td width="10%" align="center"><button onclick="return switchDate(<%=selectYearInt + (selectMonthInt==11?1:0) %>, <%=(selectMonthInt + 1) % 12 %>);"><%=months[(selectMonthInt + 1) % 12] %> >></button></td>
		<td width="10%" align="center"><button onclick="return switchDate(<%=selectYearInt + 1 %>, <%=selectMonthInt %>);"><%=selectYearInt + 1 %> >></button></td>
	</tr>
	<tr class="smallText">
		<td colspan="2">&nbsp;</td>
		<td align="center"><bean:message key="label.today" />: <%=currentDate %></td>
		<td colspan="2">&nbsp;</td>
	</tr>

</table>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="1">
	<tr class="calendarHeader">
		<th width="08%" class="calendarDaySunText"><%=days[0] %></th>
		<th width="17%" class="calendarDayText"><%=days[1] %></th>
		<th width="17%" class="calendarDayText"><%=days[2] %></th>
		<th width="17%" class="calendarDayText"><%=days[3] %></th>
		<th width="17%" class="calendarDayText"><%=days[4] %></th>
		<th width="17%" class="calendarDayText"><%=days[5] %></th>
		<th width="07%" class="calendarDayText"><%=days[6] %></th>
	</tr>
	<tr class="calendarText">
<%
// print previous month
if (leadGap > 0) {
%><td align="center" colspan="<%=leadGap %>">&nbsp;</td><%
}

boolean isCurrentDate = false;

// Fill in numbers for the day of month.
for (int i = 1; i <= daysInMonth; i++) {
	// append zero if date is 1 - 9
	calendarDate = (i<10?"0":"") + String.valueOf(i) + calendarDate.substring(2);
	isCurrentDate = currentDate.equals(calendarDate);
%>
	<td class="calendarBG<%=isCurrentDate?"Highlight":"" %>" VALIGN="top" ALIGN="left">
		<span class="calendarDay<%=((leadGap + i) % 7 == 1)?"Sun":"" %>Text"><%=i %></span><br><br><%
	if (classMap.containsKey(calendarDate)) {
		classForSameDay = (Vector) classMap.get(calendarDate);
		for (int j = 0; j < classForSameDay.size(); j++) {
%><%=classForSameDay.elementAt(j) %><%
		}
	}
%></td>
<%
	if ((leadGap + i) % 7 == 0) {    // wrap if end of line.
		out.println("</tr>");
		out.print("<tr>");
	} else if (i == daysInMonth) {
%><td align="center" colspan="<%=7 - ((leadGap + daysInMonth) % 7) %>">&nbsp;</td><%
	}
}
%>
	</tr>
</table>
</br>

<button type="button" onclick="return printCalendar('<%=startDate%>', '<%=daysInMonth + calendarDate.substring(2)%>');">Print PDF</button>

<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="select_year" value="<%=selectYearInt%>">
<input type="hidden" name="select_month" value="<%=selectMonthInt%>">
<input type="hidden" name="classDate">
<input type="hidden" name="courseID" value="<%=currentCourseID==null?"":currentCourseID %>">
<input type="hidden" name="classID" value="<%=currentClassID==null?"":currentClassID %>">
<input type="hidden" name="currentClassID">
<input type="hidden" name="deleteScheduleID">
<input type="hidden" name="educationCourseType" value=""/>
</form>
<script type="text/javascript" src="<html:rewrite page="/js/filterlist.js" />"></script>
<script language="javascript">
var courseFilter = new filterlist(document.forms['form_calendar'].elements['currentCourseID'], document.forms['form_calendar'].elements['newEventDesc']);
var courseInserviceFilter = new filterlist(document.forms['form_calendar'].elements['inserviceCourseID'], document.forms['form_calendar'].elements['newEventDesc']);
var courseCNEFilter = new filterlist(document.forms['form_calendar'].elements['cneCourseID'], document.forms['form_calendar'].elements['newEventDesc']);
var courseFireDrillFilter = new filterlist(document.forms['form_calendar'].elements['fireDrillCourseID'], document.forms['form_calendar'].elements['newEventDesc']);
var coursetNDFilter = new filterlist(document.forms['form_calendar'].elements['tNDCourseID'], document.forms['form_calendar'].elements['newEventDesc']);
var courseintClassFilter = new filterlist(document.forms['form_calendar'].elements['intClassCourseID'], document.forms['form_calendar'].elements['newEventDesc']);
var courseMockCodeFilter = new filterlist(document.forms['form_calendar'].elements['mockCodeCourseID'], document.forms['form_calendar'].elements['newEventDesc']);
var courseMockDrillFilter = new filterlist(document.forms['form_calendar'].elements['mockDrillCourseID'], document.forms['form_calendar'].elements['newEventDesc']);

	$(document).ready(function(){
		$('select[name=currentLocationID]').change(function() {
			var iddesc = $(this).find("option:selected").html();
			var desc = iddesc.split(/-(.+)/)[1];
			if (desc != null) {
				desc = desc.replace(/&amp;/g, '&');
			}
			$('input[name=currentLocationDesc]').val(desc);	
		});
	});

	function readNews(nid) {
		callPopUpWindow("../portal/news_view.jsp?newsCategory=education&newsID="+nid);
		return true;
	}

	function createRelatedNews(cmd, cid, nid) {

		callPopUpWindow("../admin/news.jsp?command=create&newsCategory=education&newsType=classRelatedNews");
		return false;
	}

	function filterCourse(value,event) {
		if ( $('input[id=SelectCourseType]:checked').val() == 'N' ) {
			courseFilter.set(value, event);
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'I' ) {
			courseInserviceFilter.set(value, event);
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'C' ) {
			courseCNEFilter.set(value, event);
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'F' ) {
			courseFireDrillFilter.set(value, event);
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'T' ) {
			coursetNDFilter.set(value, event);
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'A' ) {
			courseintClassFilter.set(value, event);
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'M' ) {
			courseMockCodeFilter.set(value, event);
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'D' ) {
			courseMockDrillFilter.set(value, event);
		}

	}

	function switchDate(year, month) {
		document.form_calendar.select_year.value = year;
		document.form_calendar.select_month.value = month;
		document.form_calendar.submit();
	}

	function submitCalendarAction(urlAction, classDate, courseID, classID) {
		document.form_calendar.action = urlAction;
		document.form_calendar.classDate.value = classDate;
		document.form_calendar.courseID.value = courseID;
		document.form_calendar.classID.value = classID;
		document.form_calendar.submit();
	}
	function onChangeCourseStyle() {
		var CourseID = document.forms["form_calendar"].elements["currentCourseID"].value;
		var compulsoryCourseID = document.forms["form_calendar"].elements["compulsoryCourseID"];
		var SelectCourseType = document.forms["form_calendar"].elements["SelectCourseType"];

		for (i = 0; i < document.form_calendar.SelectCourseType.length; i++) {
			if (SelectCourseType[i].checked) {
				if (SelectCourseType[i].value == "Y") { //compulsory
					document.form_calendar.compulsoryCourseID.style.display = "block";
					document.form_calendar.educationCourseType.value = "compulsory";

					document.form_calendar.newEventDesc.style.display = "none";
					document.form_calendar.addCourseButton.style.display = "none";
					document.form_calendar.currentCourseID.style.display = "none";
					document.form_calendar.inserviceCourseID.style.display = "none";
					document.form_calendar.cneCourseID.style.display = "none";
					document.form_calendar.fireDrillCourseID.style.display = "none";
					document.form_calendar.tNDCourseID.style.display = "none";
					document.form_calendar.intClassCourseID.style.display = "none";
					document.form_calendar.mockCodeCourseID.style.display = "none";
					document.form_calendar.mockDrillCourseID.style.display = "none";
					document.form_calendar.otherCourseID.style.display = "none";
				} else if (SelectCourseType[i].value == "N") {
					document.form_calendar.newEventDesc.style.display = "block";
					document.form_calendar.addCourseButton.style.display = "block";
					document.form_calendar.currentCourseID.style.display = "block";
					document.form_calendar.otherCourseID.style.display = "block";
					document.form_calendar.educationCourseType.value = "other";

					document.form_calendar.currentCourseID.style.display = "none";
					document.form_calendar.compulsoryCourseID.style.display = "none";
					document.form_calendar.inserviceCourseID.style.display = "none";
					document.form_calendar.cneCourseID.style.display = "none";
					document.form_calendar.fireDrillCourseID.style.display = "none";
					document.form_calendar.tNDCourseID.style.display = "none";
					document.form_calendar.intClassCourseID.style.display = "none";
					document.form_calendar.mockCodeCourseID.style.display = "none";
					document.form_calendar.mockDrillCourseID.style.display = "none";
				} else if (SelectCourseType[i].value == "I") {
					document.form_calendar.newEventDesc.style.display = "block";
					document.form_calendar.addCourseButton.style.display = "block";
					document.form_calendar.inserviceCourseID.style.display = "block";
					document.form_calendar.educationCourseType.value = "inservice";

					document.form_calendar.compulsoryCourseID.style.display = "none";
					document.form_calendar.currentCourseID.style.display = "none";
					document.form_calendar.cneCourseID.style.display = "none";
					document.form_calendar.fireDrillCourseID.style.display = "none";
					document.form_calendar.tNDCourseID.style.display = "none";
					document.form_calendar.intClassCourseID.style.display = "none";
					document.form_calendar.mockCodeCourseID.style.display = "none";
					document.form_calendar.mockDrillCourseID.style.display = "none";
					document.form_calendar.otherCourseID.style.display = "none";
				} else if (SelectCourseType[i].value == "C") {
					document.form_calendar.newEventDesc.style.display = "block";
					document.form_calendar.addCourseButton.style.display = "block";
					document.form_calendar.cneCourseID.style.display = "block";
					document.form_calendar.educationCourseType.value = "CNE";

					document.form_calendar.inserviceCourseID.style.display = "none";
					document.form_calendar.compulsoryCourseID.style.display = "none";
					document.form_calendar.currentCourseID.style.display = "none";
					document.form_calendar.fireDrillCourseID.style.display = "none";
					document.form_calendar.tNDCourseID.style.display = "none";
					document.form_calendar.intClassCourseID.style.display = "none";
					document.form_calendar.mockCodeCourseID.style.display = "none";
					document.form_calendar.mockDrillCourseID.style.display = "none";
					document.form_calendar.otherCourseID.style.display = "none";
				} else if (SelectCourseType[i].value == "F") {
					document.form_calendar.newEventDesc.style.display = "block";
					document.form_calendar.addCourseButton.style.display = "block";
					document.form_calendar.fireDrillCourseID.style.display = "block";
					document.form_calendar.educationCourseType.value = "firedrill";

					document.form_calendar.inserviceCourseID.style.display = "none";
					document.form_calendar.compulsoryCourseID.style.display = "none";
					document.form_calendar.currentCourseID.style.display = "none";
					document.form_calendar.cneCourseID.style.display = "none";
					document.form_calendar.tNDCourseID.style.display = "none";
					document.form_calendar.intClassCourseID.style.display = "none";
					document.form_calendar.mockCodeCourseID.style.display = "none";
					document.form_calendar.mockDrillCourseID.style.display = "none";
					document.form_calendar.otherCourseID.style.display = "none";
				} else if (SelectCourseType[i].value == "T") {
					document.form_calendar.newEventDesc.style.display = "block";
					document.form_calendar.addCourseButton.style.display = "block";
					document.form_calendar.tNDCourseID.style.display = "block";
					document.form_calendar.educationCourseType.value = "tND";

					document.form_calendar.inserviceCourseID.style.display = "none";
					document.form_calendar.compulsoryCourseID.style.display = "none";
					document.form_calendar.currentCourseID.style.display = "none";
					document.form_calendar.cneCourseID.style.display = "none";
					document.form_calendar.fireDrillCourseID.style.display = "none";
					document.form_calendar.intClassCourseID.style.display = "none";
					document.form_calendar.mockCodeCourseID.style.display = "none";
					document.form_calendar.mockDrillCourseID.style.display = "none";
					document.form_calendar.otherCourseID.style.display = "none";
				} else if (SelectCourseType[i].value == "A") {
					document.form_calendar.newEventDesc.style.display = "block";
					document.form_calendar.addCourseButton.style.display = "block";
					document.form_calendar.intClassCourseID.style.display = "block";
					document.form_calendar.educationCourseType.value = "intClass";

					document.form_calendar.inserviceCourseID.style.display = "none";
					document.form_calendar.compulsoryCourseID.style.display = "none";
					document.form_calendar.currentCourseID.style.display = "none";
					document.form_calendar.cneCourseID.style.display = "none";
					document.form_calendar.fireDrillCourseID.style.display = "none";
					document.form_calendar.tNDCourseID.style.display = "none";
					document.form_calendar.mockCodeCourseID.style.display = "none";
					document.form_calendar.mockDrillCourseID.style.display = "none";
					document.form_calendar.otherCourseID.style.display = "none";
				} else if (SelectCourseType[i].value == "M") {
					document.form_calendar.newEventDesc.style.display = "block";
					document.form_calendar.addCourseButton.style.display = "block";
					document.form_calendar.mockCodeCourseID.style.display = "block";
					document.form_calendar.educationCourseType.value = "mockCode";

					document.form_calendar.inserviceCourseID.style.display = "none";
					document.form_calendar.compulsoryCourseID.style.display = "none";
					document.form_calendar.currentCourseID.style.display = "none";
					document.form_calendar.cneCourseID.style.display = "none";
					document.form_calendar.fireDrillCourseID.style.display = "none";
					document.form_calendar.tNDCourseID.style.display = "none";
					document.form_calendar.intClassCourseID.style.display = "none";
					document.form_calendar.mockDrillCourseID.style.display = "none";
					document.form_calendar.otherCourseID.style.display = "none";
				} else if (SelectCourseType[i].value == "D") {
					document.form_calendar.newEventDesc.style.display = "block";
					document.form_calendar.addCourseButton.style.display = "block";
					document.form_calendar.mockDrillCourseID.style.display = "block";
					document.form_calendar.educationCourseType.value = "mockDrill";

					document.form_calendar.inserviceCourseID.style.display = "none";
					document.form_calendar.compulsoryCourseID.style.display = "none";
					document.form_calendar.currentCourseID.style.display = "none";
					document.form_calendar.cneCourseID.style.display = "none";
					document.form_calendar.fireDrillCourseID.style.display = "none";
					document.form_calendar.tNDCourseID.style.display = "none";
					document.form_calendar.mockCodeCourseID.style.display = "none";
					document.form_calendar.intClassCourseID.style.display = "none";
					document.form_calendar.otherCourseID.style.display = "none";
				}
			}
		}
	}

	function submitAction(cmd, stp) {
		document.form_calendar.command.value = cmd;
		document.form_calendar.step.value = stp;
		<%
			if (currentClassID != null && !"".equals(currentClassID)) {
		%>
		if (cmd == 'delete') {
			document.form_calendar.deleteScheduleID.value = <%=currentClassID %>;
		}
		<%
			}
		%>
		  document.form_calendar.submit();

	}

	function submitViewAction(cmd, stp, cid, csid) {
		document.form_calendar.command.value = cmd;
		document.form_calendar.step.value = stp;
		document.form_calendar.courseID.value = cid;
		document.form_calendar.classID.value = csid;
		document.form_calendar.submit();
	}

	function resetCurrentStartTime() {
		document.form_calendar.currentStartTime_hh.value = '';
		document.form_calendar.currentStartTime_mi.value = '';

		return false;
	}

	function resetCurrentEndTime() {
		document.form_calendar.currentEndTime_hh.value = '';
		document.form_calendar.currentEndTime_mi.value = '';

		return false;
	}

	// ajax
	var http = createRequestObject();

	function addNewCourse() {
		var classType = 'other';
		var selectName = 'currentCourseID';
		if ( $('input[id=SelectCourseType]:checked').val() == 'N' ) {
			classType = 'other';
			selectName = 'currentCourseID';
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'I' ) {
			classType='inservice';
			selectName = 'inserviceCourseID';
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'C' ) {
			classType='CNE';
			selectName = 'cneCourseID';
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'F' ) {
			classType='firedrill';
			selectName = 'fireDrillCourseID';
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'T' ) {
			classType='tND';
			selectName = 'tNDCourseID';
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'A' ) {
			classType='intClass';
			selectName = 'intClassCourseID';
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'M' ) {
			classType='mockCode';
			selectName = 'mockCodeCourseID';
		} else if ( $('input[id=SelectCourseType]:checked').val() == 'D' ) {
			classType='mockDrill';
			selectName = 'mockDrillCourseID';
		}
		var eventDesc = document.forms['form_calendar'].newEventDesc.value;
		if (eventDesc == "") {
			alert("Please input course");
			return false;
		}
		eventDesc = encodeURIComponent(eventDesc);
		// var eventDesc = document.form_calendar.newEventDesc.value;

		//make a connection to the server ... specifying that you intend to make a GET request
		//to the server. Specifiy the page name and the URL parameters to send
		var queryStr = '?';
		queryStr += 'moduleCode=education&eventCategory='+classType+'&eventType=class&eventDesc=' + eventDesc + '&&timestamp=<%=(new java.util.Date()).getTime() %>';
		queryStr += '&selectName='+selectName;
		http.open('get', 'searchAddEvent.jsp' + queryStr);

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;

	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4) {

			//read and assign the response from the server
			var response = http.responseText;

			//do additional parsing of the response, if needed

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById('courseIDDropDown').innerHTML = response;
			document.forms['form_calendar'].newEventDesc.value = "";

			//If the server returned an error message like a 404 error, that message would be shown within the div tag!!.
			//So it may be worth doing some basic error before setting the contents of the <div>
		}
	}

	function printCalendar(startDate, endDate) {
		callPopUpWindow("education_cal_export.jsp?startDate="+startDate+"&endDate="+endDate);
	}

<%if (createAction) {%>
onChangeCourseStyle();
<%}%>
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>