<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private HashSet getHoliday(String dateFrom, String dateTo) {
		ArrayList record = RequestDB.getHolidayList(dateFrom, dateTo);
		ReportableListObject row = null;
		HashSet hashSet = new HashSet();
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			hashSet.add(row.getValue(1));
		}
		return hashSet;
	}
%>
<%
String quotaType = request.getParameter("quotaType");
String hpstatus1 = request.getParameter("hpstatus1");
String hpstatus2 = request.getParameter("hpstatus2");
if (hpstatus2 == null) {
	hpstatus2 = hpstatus1;
}
String rangeType_sun = request.getParameter("rangeType_sun");
if (rangeType_sun == null) {
	rangeType_sun = "Y";
}
String rangeType_mon = request.getParameter("rangeType_mon");
if (rangeType_mon == null) {
	rangeType_mon = "Y";
}
String rangeType_tue = request.getParameter("rangeType_tue");
if (rangeType_tue == null) {
	rangeType_tue = "Y";
}
String rangeType_wed = request.getParameter("rangeType_wed");
if (rangeType_wed == null) {
	rangeType_wed = "Y";
}
String rangeType_thu = request.getParameter("rangeType_thu");
if (rangeType_thu == null) {
	rangeType_thu = "Y";
}
String rangeType_fri = request.getParameter("rangeType_fri");
if (rangeType_fri == null) {
	rangeType_fri = "Y";
}
String rangeType_sat = request.getParameter("rangeType_sat");
String rangeType_holiday = request.getParameter("rangeType_holiday");
HashSet holidaySet = null;
if ("Y".equals(rangeType_holiday)) {
	holidaySet = new HashSet();
} else {
	holidaySet = getHoliday(hpstatus1, hpstatus2);
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%if ("multiple".equals(quotaType)) {%>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="hpstatus1" />
	<jsp:param name="date" value="<%=hpstatus1 %>" />
	<jsp:param name="isShowNextYear" value="Y" />
	<jsp:param name="isFromCurrYear" value="Y" />
</jsp:include> -
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="hpstatus2" />
	<jsp:param name="date" value="<%=hpstatus2 %>" />
	<jsp:param name="isShowNextYear" value="Y" />
	<jsp:param name="isFromCurrYear" value="Y" />
</jsp:include>
			&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="showDateRange" value="N" onclick="return hideDateRangePanel();" checked>Show Date Range<br/>
		(DD/MON/YYYY) - (DD/MON/YYYY)<br/>
		<br/>
		<table>
			<tr>
				<td><input type="checkbox" name="rangeType_sun" value="Y"<%="Y".equals(rangeType_sun)?" checked":""%> onclick="return updateDateRangePanel();"><bean:message key="label.sunday" /></td>
				<td><input type="checkbox" name="rangeType_mon" value="Y"<%="Y".equals(rangeType_mon)?" checked":""%> onclick="return updateDateRangePanel();"><bean:message key="label.monday" /></td>
				<td><input type="checkbox" name="rangeType_tue" value="Y"<%="Y".equals(rangeType_tue)?" checked":""%> onclick="return updateDateRangePanel();"><bean:message key="label.tuesday" /></td>
				<td><input type="checkbox" name="rangeType_wed" value="Y"<%="Y".equals(rangeType_wed)?" checked":""%> onclick="return updateDateRangePanel();"><bean:message key="label.wednesday" /></td>
			</tr>
			<tr>
				<td><input type="checkbox" name="rangeType_thu" value="Y"<%="Y".equals(rangeType_thu)?" checked":""%> onclick="return updateDateRangePanel();"><bean:message key="label.thursday" /></td>
				<td><input type="checkbox" name="rangeType_fri" value="Y"<%="Y".equals(rangeType_fri)?" checked":""%> onclick="return updateDateRangePanel();"><bean:message key="label.friday" /></td>
				<td><input type="checkbox" name="rangeType_sat" value="Y"<%="Y".equals(rangeType_sat)?" checked":""%> onclick="return updateDateRangePanel();"><bean:message key="label.saturday" /></td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2"><input type="checkbox" name="rangeType_holiday" value="Y"<%="Y".equals(rangeType_holiday)?" checked":""%> onclick="return updateDateRangePanel();">Include Holiday</td>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
		<a href="javascript:void(0);" onclick="return updateDateRangePanel();">Refresh</a> (max display 300 records)
	<ul>
<%
if (hpstatus1 != null && hpstatus2 != null) {
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(DateTimeUtil.parseDate(hpstatus1));
	String tempDate = DateTimeUtil.formatDate(calendar.getTime());
	int count = 0;
	while (DateTimeUtil.compareTo(tempDate, hpstatus2) <= 0 && count < 300) {
		if ("Y".equals(rangeType_sun) && calendar.get(Calendar.DAY_OF_WEEK) == 1 && ("Y".equals(rangeType_holiday) || !holidaySet.contains(tempDate))) {
			%><li><b><%=tempDate %></b><input type="hidden" name="hpstatus" value="<%=tempDate %>"></li><%
			count++;
		} else if ("Y".equals(rangeType_mon) && calendar.get(Calendar.DAY_OF_WEEK) == 2 && ("Y".equals(rangeType_holiday) || !holidaySet.contains(tempDate))) {
			%><li><b><%=tempDate %></b><input type="hidden" name="hpstatus" value="<%=tempDate %>"></li><%
			count++;
		} else if ("Y".equals(rangeType_tue) && calendar.get(Calendar.DAY_OF_WEEK) == 3 && ("Y".equals(rangeType_holiday) || !holidaySet.contains(tempDate))) {
			%><li><b><%=tempDate %></b><input type="hidden" name="hpstatus" value="<%=tempDate %>"></li><%
			count++;
		} else if ("Y".equals(rangeType_wed) && calendar.get(Calendar.DAY_OF_WEEK) == 4 && ("Y".equals(rangeType_holiday) || !holidaySet.contains(tempDate))) {
			%><li><b><%=tempDate %></b><input type="hidden" name="hpstatus" value="<%=tempDate %>"></li><%
			count++;
		} else if ("Y".equals(rangeType_thu) && calendar.get(Calendar.DAY_OF_WEEK) == 5 && ("Y".equals(rangeType_holiday) || !holidaySet.contains(tempDate))) {
			%><li><b><%=tempDate %></b><input type="hidden" name="hpstatus" value="<%=tempDate %>"></li><%
			count++;
		} else if ("Y".equals(rangeType_fri) && calendar.get(Calendar.DAY_OF_WEEK) == 6 && ("Y".equals(rangeType_holiday) || !holidaySet.contains(tempDate))) {
			%><li><b><%=tempDate %></b><input type="hidden" name="hpstatus" value="<%=tempDate %>"></li><%
			count++;
		} else if ("Y".equals(rangeType_sat) && calendar.get(Calendar.DAY_OF_WEEK) == 7 && ("Y".equals(rangeType_holiday) || !holidaySet.contains(tempDate))) {
			%><li><b><%=tempDate %></b><input type="hidden" name="hpstatus" value="<%=tempDate %>"></li><%
			count++;
		}
		calendar.add(Calendar.DAY_OF_YEAR, 1);
		tempDate = DateTimeUtil.formatDate(calendar.getTime());
	}
}
%>
	</ul>
<%} else { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="hpstatus" />
	<jsp:param name="isShowNextYear" value="Y" />
	<jsp:param name="date" value="<%=hpstatus1 %>" />
	<jsp:param name="isFromCurrYear" value="Y" />
</jsp:include>(DD/MON/YYYY)
			&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="showDateRange" value="N" onclick="return showDateRangePanel();">Show Date Range
<%}%>