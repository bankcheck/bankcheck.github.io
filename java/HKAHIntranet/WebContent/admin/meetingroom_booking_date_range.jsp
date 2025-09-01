<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%
String bookingType = request.getParameter("bookingType");
String rangeType = request.getParameter("rangeType");
int dayOfWeek = 0;
try {
	dayOfWeek = Integer.parseInt(rangeType);
} catch (Exception e) {}
String attendDate1 = request.getParameter("attendDate1");
String attendDate2 = request.getParameter("attendDate2");
if (attendDate2 == null) {
	attendDate2 = attendDate1;
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
<%if ("multiple".equals(bookingType)) {%>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="attendDate1" />
	<jsp:param name="date" value="<%=attendDate1 %>" />
	<jsp:param name="isShowNextYear" value="Y" />	
	<jsp:param name="isFromCurrYear" value="Y" />
</jsp:include> - 
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="attendDate2" />
	<jsp:param name="date" value="<%=attendDate2 %>" />
	<jsp:param name="isShowNextYear" value="Y" />	
	<jsp:param name="isFromCurrYear" value="Y" />	
</jsp:include>
			&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="showDateRange" value="N" onclick="return hideDateRangePanel();">Hide Date Range<br/>
		(DD/MON/YYYY) - (DD/MON/YYYY)<br/>
		<br/>
		Select Every <select name="rangeType" onchange="return updateDateRangePanel();">
			<option value=""><bean:message key="label.all" /></option>
			<option value="1"<%="1".equals(rangeType)?" selected":""%>><bean:message key="label.sunday" /></option>
			<option value="2"<%="2".equals(rangeType)?" selected":""%>><bean:message key="label.monday" /></option>
			<option value="3"<%="3".equals(rangeType)?" selected":""%>><bean:message key="label.tuesday" /></option>
			<option value="4"<%="4".equals(rangeType)?" selected":""%>><bean:message key="label.wednesday" /></option>
			<option value="5"<%="5".equals(rangeType)?" selected":""%>><bean:message key="label.thursday" /></option>
			<option value="6"<%="6".equals(rangeType)?" selected":""%>><bean:message key="label.friday" /></option>
			<option value="7"<%="7".equals(rangeType)?" selected":""%>><bean:message key="label.saturday" /></option>
			<option value="8"<%="8".equals(rangeType)?" selected":""%>><bean:message key="prompt.month" /></option>
		</select>
		<a href="javascript:void(0);" onclick="return updateDateRangePanel();">Refresh</a> (max display 100 records)
	<ul>
<%
if (attendDate1 != null && attendDate2 != null) {
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(DateTimeUtil.parseDate(attendDate1));
	String tempDate = DateTimeUtil.formatDate(calendar.getTime());
	int count = 0;
	while (DateTimeUtil.compareTo(tempDate, attendDate2) <= 0 && count < 100) {
		if (dayOfWeek == 0 || dayOfWeek == calendar.get(Calendar.DAY_OF_WEEK)) {
			%><li><b><%=tempDate %></b><input type="hidden" name="attendDate" value="<%=tempDate %>"></li><%
			count++;
		} else if (dayOfWeek == 8 && String.valueOf(calendar.get(Calendar.DAY_OF_MONTH)).equals(attendDate1.substring(0, 2))) {
			%><li><b><%=tempDate %></b><input type="hidden" name="attendDate" value="<%=tempDate %>"></li><%
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
	<jsp:param name="label" value="attendDate" />
	<jsp:param name="isShowNextYear" value="Y" />
	<jsp:param name="date" value="<%=attendDate1 %>" />
	<jsp:param name="isFromCurrYear" value="Y" />
</jsp:include>(DD/MON/YYYY)
			&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="showDateRange" value="N" onclick="return showDateRangePanel();">Show Date Range
<%}%>