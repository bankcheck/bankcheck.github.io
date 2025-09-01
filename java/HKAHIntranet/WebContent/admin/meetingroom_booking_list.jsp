<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!

public static ArrayList get(String moduleCode, String eventID, String enrollID) {
	// fetch enrollment
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT C.CO_DEPARTMENT_CODE, D1.CO_DEPARTMENT_DESC, ");
	sqlStr.append("       C.CO_EVENT_ID, C.CO_EVENT_DESC, ");
	sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE, ");
	sqlStr.append("       CE.CO_ENROLL_ID, CE.CO_ENROLL_NO, ");
	sqlStr.append("       CE.CO_USER_TYPE, CE.CO_USER_ID, S.CO_STAFFNAME, D2.CO_DEPARTMENT_DESC, ");
	sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE, 'dd/MM/YYYY'), ");
	sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE, 'HH24:MI'), ");
	sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE2, 'HH24:MI'), ");
	sqlStr.append("       CO_ATTEND_STATUS, ");
	sqlStr.append("       CE.CO_CREATED_USER ");
	sqlStr.append("FROM   CO_ENROLLMENT CE, CO_EVENT C, CO_DEPARTMENTS D1, CO_DEPARTMENTS D2, CO_STAFFS S ");
	sqlStr.append("WHERE  CE.CO_ENABLED = 1 ");
	sqlStr.append("AND    CE.CO_SITE_CODE = C.CO_SITE_CODE ");
	sqlStr.append("AND    CE.CO_MODULE_CODE = C.CO_MODULE_CODE ");
	sqlStr.append("AND    CE.CO_EVENT_ID = C.CO_EVENT_ID ");
	sqlStr.append("AND    CE.CO_USER_ID = S.CO_STAFF_ID (+) ");
	sqlStr.append("AND    C.CO_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE (+) ");
	sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE (+) ");
	if (moduleCode != null && moduleCode.length() > 0) {
		sqlStr.append("AND    CE.CO_MODULE_CODE = '");
		sqlStr.append(moduleCode);
		sqlStr.append("' ");
	}
	if (eventID != null && eventID.length() > 0) {
		sqlStr.append("AND    CE.CO_EVENT_ID = '");
		sqlStr.append(eventID);
		sqlStr.append("' ");
	}
	if (enrollID != null && enrollID.length() > 0) {
		sqlStr.append("AND    CE.CO_ENROLL_ID = '");
		sqlStr.append(enrollID);
		sqlStr.append("' ");
	}

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String step = request.getParameter("step");
String eventID = request.getParameter("eventID");
if (eventID == null) {
	eventID = "1001";
}
String eventID2 = request.getParameter("eventID2");
String eventID3 = request.getParameter("eventID3");
String selectedEnrollID = request.getParameter("enrollID");
String attendDate = null;
String []attendDate_Range = request.getParameterValues("attendDate");
String attendDate_yy = request.getParameter("attendDate_yy");
String attendDate_mm = request.getParameter("attendDate_mm");
String attendDate_dd = request.getParameter("attendDate_dd");
String attendStartTime = null;
String attendEndTime = null;
String attendStartDateTime = null;
String attendStartTime_hh = request.getParameter("attendStartTime_hh");
String attendStartTime_mi = request.getParameter("attendStartTime_mi");
String attendEndDateTime = null;
String attendEndTime_hh = request.getParameter("attendEndTime_hh");
String attendEndTime_mi = request.getParameter("attendEndTime_mi");
String selectedStaffID = request.getParameter("staffID");
if (selectedStaffID == null) {
	selectedStaffID = userBean.getStaffID();
}
String selectedStaffName = null;
String deptDesc = null;
String bookingType = request.getParameter("bookingType");
String createdUserID = null;
String createdUserName = null;

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean copyAction = false;
boolean viewAction = false;

String message = null;

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

try {
	if ("1".equals(step)) {
		attendDate = attendDate_dd + "/" + attendDate_mm + "/" + attendDate_yy;
		attendStartTime = attendStartTime_hh + ":" + attendStartTime_mi + ":00";
		attendStartDateTime = attendDate + " " + attendStartTime;
		attendEndTime = attendEndTime_hh + ":" + attendEndTime_mi + ":00";
		attendEndDateTime = attendDate + " " + 	attendEndTime;
		int attendStartTime_hh_int = -1;
		try {
			attendStartTime_hh_int = Integer.parseInt(attendStartTime_hh);
		} catch (Exception e) {}
		int attendStartTime_mi_int = -1;
		try {
			attendStartTime_mi_int = Integer.parseInt(attendStartTime_mi);
		} catch (Exception e) {}
		int attendEndTime_hh_int = -1;
		try {
			attendEndTime_hh_int = Integer.parseInt(attendEndTime_hh);
		} catch (Exception e) {}
		int attendEndTime_mi_int = -1;
		try {
			attendEndTime_mi_int = Integer.parseInt(attendEndTime_mi);
		} catch (Exception e) {}

		if ((createAction || updateAction) && attendStartTime_hh_int > attendEndTime_hh_int) {
			message = "meeting room start time must be before end time.";
		} else if ((createAction || updateAction) && attendStartTime_hh_int == attendEndTime_hh_int && attendStartTime_mi_int > attendEndTime_mi_int) {
			message = "meeting room start time must be before end time.";
		} else if ((createAction || updateAction) && attendStartDateTime.equals(attendEndDateTime)) {
			message = "meeting room start time cannot not equal to end time.";
		} else {
			if (createAction) {
				if ("multiple".equals(bookingType)) {
					if (attendDate_Range != null && attendDate_Range.length > 0) {
						int attendDateCount = 0;
						// check whether one of the rooms are booked
						for (int i = 0; attendDateCount == 0 && i < attendDate_Range.length; i++) {
							attendDate = attendDate_Range[i];
							attendStartDateTime = attendDate + " " + attendStartTime;
							attendEndDateTime = attendDate + " " + 	attendEndTime;
							if (EnrollmentDB.isExist("booking", eventID, false, null, attendStartDateTime, attendEndDateTime)) {
								attendDateCount = 1;
							}
						}
						if (attendDateCount > 0) {
							message = "meeting room is failed to book since some of the rooms are booked.";
						} else {
							attendDateCount = 0;
							for (int i = 0; i < attendDate_Range.length; i++) {
								attendDate = attendDate_Range[i];
								attendStartDateTime = attendDate + " " + attendStartTime;
								attendEndDateTime = attendDate + " " + 	attendEndTime;
								selectedEnrollID = EnrollmentDB.add(userBean, "booking", eventID, selectedStaffID, attendStartDateTime, attendEndDateTime);
								if (selectedEnrollID != null) {
									attendDateCount++;
								}
							}
							if (attendDate_Range.length == attendDateCount) {
								message = "meeting room is booked.";
							} else if (attendDate_Range.length > attendDateCount && attendDateCount > 0) {
								message = "some of meeting room is failed to book.";
							} else {
								message = "meeting room is failed to book.";
							}
							createAction = false;
						}
					} else {
						message = "meeting room is failed to book.";
					}
				} else {
					if (EnrollmentDB.isExist("booking", eventID, false, null, attendStartDateTime, attendEndDateTime)) {
						message = "meeting room is failed to book due to the room is already booked by the others.";
					} else if (eventID2 != null && eventID2.length() > 0 && EnrollmentDB.isExist("booking", eventID2, false, null, attendStartDateTime, attendEndDateTime)) {
						message = "meeting room (connected with) is failed to book due to the room is already booked by the others.";
					} else if (eventID3 != null && eventID3.length() > 0 && EnrollmentDB.isExist("booking", eventID3, false, null, attendStartDateTime, attendEndDateTime)) {
						message = "meeting room (connected with) is failed to book due to the room is already booked by the others.";
					} else {
						boolean isSuccess = true;
						if (eventID3 != null && eventID3.length() > 0) {
							selectedEnrollID = EnrollmentDB.add(userBean, "booking", eventID3, selectedStaffID, attendStartDateTime, attendEndDateTime);
							if (selectedEnrollID == null) {
								message = "meeting room (connected with) is failed to book.";
								isSuccess = false;
							}
						}
						if (eventID2 != null && eventID2.length() > 0) {
							selectedEnrollID = EnrollmentDB.add(userBean, "booking", eventID2, selectedStaffID, attendStartDateTime, attendEndDateTime);
							if (selectedEnrollID == null) {
								message = "meeting room (connected with) is failed to book.";
								isSuccess = false;
							}
						}
						if (isSuccess) {
							selectedEnrollID = EnrollmentDB.add(userBean, "booking", eventID, selectedStaffID, attendStartDateTime, attendEndDateTime);
							if (selectedEnrollID != null) {
								message = "meeting room is booked.";
								createAction = false;
							} else {
								message = "meeting room is failed to book.";
							}
						}
					}
				}
			} else if (updateAction) {
				if (EnrollmentDB.isExist("booking", eventID, false, selectedEnrollID, attendStartDateTime, attendEndDateTime)) {
					message = "meeting room is reserved in selected time during update booking.";
				} else {
					if (EnrollmentDB.update(userBean, "booking", eventID, selectedEnrollID, selectedStaffID, attendStartDateTime, attendEndDateTime)) {
						message = "meeting room's booking is update.";
						updateAction = false;
					} else {
						message = "meeting room's booking is failed to update.";
					}
				}
			} else if (deleteAction) {
				if (EnrollmentDB.delete(userBean, "booking", eventID, selectedEnrollID)) {
					message = "meeting room's booking is cancelled.";
					deleteAction = false;
				} else {
					message = "meeting room's booking is failed to cancel.";
				}
			}
		}
		step = null;
	}

	if (!createAction && !"1".equals(step)) {
		if (selectedEnrollID != null && selectedEnrollID.length() > 0) {
			//ArrayList result = EnrollmentDB.get("booking", eventID, selectedEnrollID);
			ArrayList result = get("booking", eventID, selectedEnrollID);
			if (result.size() > 0) {
				ReportableListObject row = (ReportableListObject) result.get(0);
				selectedStaffID = row.getValue(9);
				selectedStaffName = row.getValue(10);
				attendDate = row.getValue(12);
				attendStartTime = row.getValue(13);
				attendEndTime = row.getValue(14);
				createdUserID = row.getValue(16);
				if (userBean.isAdmin() && createdUserID != null) {
					result = StaffDB.get(createdUserID);
					if (result.size() > 0) {
						row = (ReportableListObject) result.get(0);
						createdUserName = row.getValue(3);
					}
				}
			}
		}
	}

	if (copyAction) {
		createAction = true;
		command = "create";
	}
} catch (Exception e) {
	e.printStackTrace();
}

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

// retrieve from datebase
HashMap classMap = new HashMap();
StringBuffer roomInfo = new StringBuffer();
Vector classForSameDay = null;
String enrollID = null;
String eventCategory = null;
String staffID = null;
String staffName = null;
String attendDate_display = null;
String attendStartTime_display = null;
String attendEndTime_display = null;

String calendarDate = DateTimeUtil.formatDate(calendar.getTime());

String eventDesc = null;
String eventRemark = null;
if (eventID != null) {
	ArrayList result = EventDB.get("booking", eventID);
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		eventDesc = reportableListObject.getValue(1);
		eventRemark = reportableListObject.getValue(5);
	}
}

try {
	ArrayList record = EnrollmentDB.getListByDate("booking", eventID, calendarDate, daysInMonth + calendarDate.substring(2));
	ReportableListObject row = null;
	if (record.size() > 0) {
		boolean viewable = userBean.isAccessible("function.meetingRoom.booking.view");

		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			eventCategory = row.getValue(4);
			enrollID = row.getValue(6);
			staffID = row.getValue(9);
			staffName = row.getValue(10);
			deptDesc = row.getValue(11);
			attendDate_display = row.getValue(12);
			attendStartTime_display = row.getValue(13);
			attendEndTime_display = row.getValue(14);

			// reset class info storage
			roomInfo.setLength(0);
			if (viewable) {
				roomInfo.append("<a href=\"javascript:viewAction('");
				roomInfo.append(enrollID);
				roomInfo.append("');\"");
			} else {
				roomInfo.append("<a href=\"#\"");
			}
			roomInfo.append("\">");
			roomInfo.append(attendStartTime_display);
			roomInfo.append("-");
			roomInfo.append(attendEndTime_display);
			roomInfo.append("<br>");
			if (staffName != null && staffName.length() > 0) {
				roomInfo.append(staffName.toUpperCase());
			} else {
				roomInfo.append(staffID.toUpperCase());
			}
			roomInfo.append("<br>");
			if (deptDesc != null && deptDesc.length() > 0) {
				roomInfo.append(deptDesc);
			}
			roomInfo.append("<p><br>");

			// store in hash map
			if (classMap.containsKey(attendDate_display)) {
				classForSameDay = (Vector) classMap.get(attendDate_display);
			} else {
				classForSameDay = new Vector();
			}
			classForSameDay.add(roomInfo.toString());
			classMap.put(attendDate_display, classForSameDay);
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

// permission
String bookingRoomPermissionPrefix = "function.meetingRoom.booking.";
String bookingRoomTypePrefix = "function.meetingRoom.type.";

boolean isOwnerOrCreator = (createdUserID != null && createdUserID.equals(userBean.getLoginID())) || (selectedStaffID != null && selectedStaffID.equals(userBean.getLoginID()));

boolean applyToAllType = userBean.isAccessible(bookingRoomTypePrefix + "all");
boolean applyToThisType = userBean.isAccessible(bookingRoomTypePrefix + eventID);

boolean canUpdateAdmin = userBean.isAccessible(bookingRoomPermissionPrefix + "update");
boolean canDeleteAdmin = userBean.isAccessible(bookingRoomPermissionPrefix + "delete");
boolean canUpdateOwner = userBean.isAccessible(bookingRoomPermissionPrefix + "update.owner");
boolean canDeleteOwner = userBean.isAccessible(bookingRoomPermissionPrefix + "delete.owner");

boolean canCreateThis = userBean.isAccessible(bookingRoomPermissionPrefix + "create") && (applyToAllType || applyToThisType);
boolean canUpdateThis =
	(canUpdateAdmin || (canUpdateOwner && isOwnerOrCreator)) &&
	(applyToAllType || applyToThisType);
boolean canDeleteThis =
	(canDeleteAdmin || (canDeleteOwner && isOwnerOrCreator)) &&
	(applyToAllType || applyToThisType);
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
		title = "function.meetingRoom.booking." + commandType;

		// check owner only permission
		if ((updateAction && !canUpdateAdmin && canUpdateOwner) || (deleteAction && !canDeleteAdmin && canDeleteOwner)) {
			title += ".owner";
		}
	} else {
		commandType = "view";
		// set submit label
		title = "function.meetingRoom.booking.list";
	}
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.admin" />
</jsp:include>
<form name="form1" id="form1" action="meetingroom_booking_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Meeting Room</td>
		<td class="infoData" width="70%">
			<select name="eventID" onchange="return changeEventID()">
				<option>----- Please select the meeting room -----</option>
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="booking" />
	<jsp:param name="eventID" value="<%=eventID %>" />
	<jsp:param name="accessControl" value="<%=(createAction || updateAction || deleteAction) ? \"Y\" : \"N\" %>" />
</jsp:include>
			</select>
		</td>
	</tr>
<%	if (createAction || updateAction || deleteAction || viewAction) { %>
<%		if (createAction && ConstantsServerSide.isTWAH() && ("1012".equals(eventID) || "1030".equals(eventID) || "1031".equals(eventID))) { %>
<%
			String connectType = null;
			if ("1012".equals(eventID)) {
				connectType = "connect1";
			} else if ("1030".equals(eventID)) {
				connectType = "connect2";
			} else if ("1031".equals(eventID)) {
				connectType = "connect3";
			}
%>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Meeting Room (Connected With)</td>
		<td class="infoData" width="70%">
			<select name="eventID2">
				<option value="">---</option>
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="booking" />
	<jsp:param name="eventID" value="" />
	<jsp:param name="eventType" value="<%=connectType %>" />
</jsp:include>
			</select>&nbsp;&nbsp;&nbsp;<i><font color="red">Please handle individual if modify or cancel booking</font></i>
		</td>
	</tr>
<%			if ("1030".equals(eventID)) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Meeting Room (Connected With)</td>
		<td class="infoData" width="70%">
			<select name="eventID2">
				<option value="">---</option>
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="booking" />
	<jsp:param name="eventID" value="" />
	<jsp:param name="eventType" value="connect3" />
</jsp:include>
			</select>&nbsp;&nbsp;&nbsp;<i><font color="red">Please handle individual if modify or cancel booking</font></i>
		</td>
	</tr>
<%			} %>
<%		} else { %>
	<input type="hidden" name="eventID2" value="" />
<%		} %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Apply Staff</td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
			<select name="staffID">
<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
	<jsp:param name="value" value="<%=selectedStaffID %>" />
	<jsp:param name="allowAll" value="Y" />
	<jsp:param name="hideVolunteer" value="Y" />
	<jsp:param name="onlyCurrentStaffID" value="<%=userBean.isAccessible(\"function.meetingRoom.type.all\") ? \"N\" : \"Y\" %>" />
</jsp:include>
			</select>
<%		} else {%>
			<%=selectedStaffName %>
<%		} %>
		</td>
	</tr>
<%		if (userBean.isAdmin()) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Apply Staff (Real)</td>
		<td class="infoData" width="70%"><%=createdUserName == null ? createdUserID : createdUserName%>
		</td>
	</tr>
<%		} %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Date</td>
<%		if (createAction || updateAction) {%>
		<td class="infoData">
			<span id="dateRange_indicator">
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="attendDate" />
	<jsp:param name="isShowNextYear" value="Y" />
	<jsp:param name="date" value="<%=attendDate %>" />
	<jsp:param name="isFromCurrYear" value="Y" />
</jsp:include>(DD/MON/YYYY)
			&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="showDateRange" value="N" onclick="return showDateRangePanel();">Show Date Range
			</span>
		</td>
<%		} else {%>
		<td class="infoData" width="70%">
			<%=attendDate %>
		(DD/MON/YYYY)</td>
<%		} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Start Time</td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="attendStartTime" />
	<jsp:param name="time" value="<%=attendStartTime %>" />
	<jsp:param name="interval" value="15" />
</jsp:include>
<%		} else {%>
			<%=attendStartTime %>
<%		} %>
		(HH:MM)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">End Time</td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="attendEndTime" />
	<jsp:param name="time" value="<%=attendEndTime %>" />
	<jsp:param name="interval" value="15" />
	<jsp:param name="startfrom" value="1" />
</jsp:include>
<%		} else {%>
			<%=attendEndTime %>
<%		} %>
		(HH:MM)</td>
	</tr>
<%	} %>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%		if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /></button>
			<button onclick="return submitAction('cancel', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} else if (viewAction) { %>
<% 			if (DateTimeUtil.compareTo(attendDate, currentDate) >= 0) { %>
<% 				if (canCreateThis && canUpdateThis) { %><button onclick="return submitAction('copy', 1);" class="btn-click"><bean:message key="button.copy" /></button><% } %>
<% 				if (canUpdateThis) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="button.update" /></button><% } %>
<% 				if (canDeleteThis) { %><button onclick="return submitAction('delete', 0);" class="btn-click"><bean:message key="button.delete" /></button><% } %>
<%			} %>
<button onclick="return submitAction('cancel', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} else { %>
<% if (canCreateThis /* && (!ConstantsServerSide.isTWAH() || !"1011".equals(eventID)) */) { %><button onclick="return submitAction('create', 0);" class="btn-click"><bean:message key="function.meetingRoom.booking.create" /></button><% } %>
<%		}  %>
		</td>
	</tr>
</table>
</div>
<br/><br/>
<table width="100%" border="0">
	<tr class="bigText">
		<td width="10%" align="center"><button onclick="return switchDate(<%=selectYearInt - 1 %>, <%=selectMonthInt %>);"><< <%=selectYearInt - 1 %></button></td>
		<td width="10%" align="center"><button onclick="return switchDate(<%=selectYearInt - (selectMonthInt==0?1:0)  %>, <%=(selectMonthInt + 11) % 12 %>);"><< <%=months[(selectMonthInt + 11) % 12] %></button></td>
		<td width="60%" align="center"><%=months[selectMonthInt] %> <%=selectYearInt %></td>
		<td width="10%" align="center"><button onclick="return switchDate(<%=selectYearInt + (selectMonthInt==11?1:0) %>, <%=(selectMonthInt + 1) % 12 %>);"><%=months[(selectMonthInt + 1) % 12] %> >></button></td>
		<td width="10%" align="center"><button onclick="return switchDate(<%=selectYearInt + 1 %>, <%=selectMonthInt %>);"><%=selectYearInt + 1 %> >></button></td>
	</tr>
	<tr class="smallText">
		<td colspan="2">&nbsp;</td>
		<td align="center"><bean:message key="label.today" />: <font color='green'><b><%=currentDate %></b></font></td>
		<td colspan="2">&nbsp;</td>
	</tr>
<%if (eventDesc != null) { %>
	<tr class="smallText">
		<td colspan="2">&nbsp;</td>
		<td align="center">Meeting Room: <font color='green'><b><%=eventDesc %></b></font></td>
		<td colspan="2">&nbsp;</td>
	</tr>
<%} %>
<%if (eventRemark != null && !eventRemark.isEmpty()) { %>
	<tr class="smallText">
		<td colspan="2">&nbsp;</td>
		<td align="center"><span style="color: red; font-weight: bold; font-size: 150%"><%=eventRemark %></span></td>
		<td colspan="2">&nbsp;</td>
	</tr>
<%} %>
</table>
<table width="100%" border="1">
	<tr class="calendarHeader">
		<th width="15%" class="calendarDaySunText"><%=days[0] %></th>
		<th width="15%" class="calendarDayText"><%=days[1] %></th>
		<th width="15%" class="calendarDayText"><%=days[2] %></th>
		<th width="15%" class="calendarDayText"><%=days[3] %></th>
		<th width="15%" class="calendarDayText"><%=days[4] %></th>
		<th width="15%" class="calendarDayText"><%=days[5] %></th>
		<th width="10%" class="calendarDayText"><%=days[6] %></th>
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
<input type="hidden" name="select_year" value="<%=selectYearInt %>" />
<input type="hidden" name="select_month" value="<%=selectMonthInt %>" />
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="eventID" value="<%=eventID %>" />
<input type="hidden" name="enrollID" value="<%=selectedEnrollID==null?"":selectedEnrollID %>" />
<input type="hidden" name="bookingType" value="single" />
</form>
<script language="javascript">
<!--
	function switchDate(year, month) {
		document.form1.select_year.value = year;
		document.form1.select_month.value = month;
		document.form1.submit();
		return true;
	}

	function changeEventID() {
		document.form1.submit();
		return true;
	}

	function submitCalendarAction(eid) {
		document.form1.enrollID.value = eid;
		document.form1.submit();
		return true;
	}

	function viewAction(eid) {
		document.form1.command.value = "view";
		document.form1.step.value = "0";
		document.form1.enrollID.value = eid;
		document.form1.submit();
		return true;
	}

	function submitAction(cmd, stp) {
		if (cmd == 'delete') {
			if (stp == 0) {
				$.prompt('Confirm to delete?',{
					buttons: { Ok: true, Cancel: false },
					callback: function(v,m,f){
						if (v){
							submit: submitAction(cmd, 1);
							return true;
						} else {
							return false;
						}
					},
					prefix:'cleanblue'
				});
				return false;
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
		return true;
	}

	// ajax
	var http = createRequestObject();

	function showDateRangePanel() {
		var attendDate = document.form1.attendDate_dd.value + '/' + document.form1.attendDate_mm.value + '/' + document.form1.attendDate_yy.value;

		http.open('get', 'meetingroom_booking_date_range.jsp?bookingType=multiple&attendDate1=' + attendDate + '&attendDate2=' + attendDate + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		document.form1.bookingType.value = 'multiple';

		return false;
	}

	function updateDateRangePanel() {
		var rangeType = document.form1.rangeType.value;
		var attendDate1 = document.form1.attendDate1_dd.value + '/' + document.form1.attendDate1_mm.value + '/' + document.form1.attendDate1_yy.value;
		var attendDate2 = document.form1.attendDate2_dd.value + '/' + document.form1.attendDate2_mm.value + '/' + document.form1.attendDate2_yy.value;

		http.open('get', 'meetingroom_booking_date_range.jsp?bookingType=multiple&rangeType=' + rangeType + '&attendDate1=' + attendDate1 + '&attendDate2=' + attendDate2 + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function hideDateRangePanel() {
		var attendDate1 = document.form1.attendDate1_dd.value + '/' + document.form1.attendDate1_mm.value + '/' + document.form1.attendDate1_yy.value;

		http.open('get', 'meetingroom_booking_date_range.jsp?bookingType=single&attendDate1=' + attendDate1 + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		document.form1.bookingType.value = 'single';

		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("dateRange_indicator").innerHTML = response;
		}
	}
<%	if (message != null) { %>

	alert("<%=message %>");
<%	} %>
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>