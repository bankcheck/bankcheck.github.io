<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%
UserBean userBean = new UserBean(request);
String selectedStaffID = request.getParameter("staffID");

if (selectedStaffID == null) {
	selectedStaffID = userBean.getStaffID();
}
String selectedStaffName = StaffDB.getStaffName(selectedStaffID);

String totManTime;
String taskDate;

String holidayDate;
String holidayDesc;

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
StringBuffer taskInfo = new StringBuffer();
Vector classForSameDay = null;

String calendarDate = DateTimeUtil.formatDate(calendar.getTime());
//holiday
try {
	ArrayList record = RequestDB.getHolidayList(calendarDate, daysInMonth + calendarDate.substring(2));
	ReportableListObject row = null;
	if (record.size() > 0) {

		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);

			holidayDesc = row.getValue(0);
			holidayDate = row.getValue(1);
			
			// reset class info storage
			taskInfo.setLength(0);
			taskInfo.append("<span class='calendarDaySunText'>");
			taskInfo.append(holidayDesc);
			taskInfo.append("</span>");
			
			// store in hash map
			if (classMap.containsKey(holidayDate)) {
				classForSameDay = (Vector) classMap.get(holidayDate);
			} else {
				classForSameDay = new Vector();
			}
			classForSameDay.add(taskInfo.toString());
			classMap.put(holidayDate, classForSameDay);
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}
//task entry
try {
	ArrayList record = RequestDB.getManTimeByDate(selectedStaffID, calendarDate, daysInMonth + calendarDate.substring(2));
	ReportableListObject row = null;
	if (record.size() > 0) {

		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			
			totManTime = row.getValue(0);
			taskDate = row.getValue(1);
			
			// reset class info storage
			taskInfo.setLength(0);

			taskInfo.append("<center><a href=\"javascript:taskEntry('");
			taskInfo.append(selectedStaffID);
			taskInfo.append("','");
			taskInfo.append(taskDate);
			taskInfo.append("');\" >(");
			taskInfo.append(totManTime);
			taskInfo.append(")</a></center>");
			// store in hash map
			if (classMap.containsKey(taskDate)) {
				classForSameDay = (Vector) classMap.get(taskDate);
			} else {
				classForSameDay = new Vector();
			}
			classForSameDay.add(taskInfo.toString());
			classMap.put(taskDate, classForSameDay);
		}
	}
} catch (Exception e) {
	e.printStackTrace();
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
	<tr class="smallText">
		<td colspan="2">&nbsp;</td>
		<td align="center">Staff: <font color='green'><b><%=selectedStaffName %></b></font></td>
		<td colspan="2">&nbsp;</td>
	</tr>
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
	} else {
		if (((leadGap + i) % 7 != 1) && ((leadGap + i) % 7 != 0)) {
	%>
			<center><a href="javascript:taskEntry('<%=selectedStaffID %>','<%=calendarDate %>');">
			No Entry
			</a></center>
	<%
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
