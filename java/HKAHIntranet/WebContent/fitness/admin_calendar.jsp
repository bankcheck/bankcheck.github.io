<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%
UserBean userBean = new UserBean(request);

String holidayDate;
String holidayDesc;

String[] heading1 = new String[] {
	MessageResources.getMessage(session, "label.sunday"),
	MessageResources.getMessage(session, "label.monday"),
	MessageResources.getMessage(session, "label.tuesday"),
	MessageResources.getMessage(session, "label.wednesday"),
	MessageResources.getMessage(session, "label.thursday"),
	MessageResources.getMessage(session, "label.friday"),
	MessageResources.getMessage(session, "label.saturday") };

String[] heading2 = new String[7];

String displaydate = request.getParameter("displaydate");
Calendar calendar = Calendar.getInstance();
Date currentDate = calendar.getTime();

Date tmpDate = currentDate;
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

if (displaydate != null) {	
	tmpDate = sdf.parse(displaydate);
	calendar.setTime(tmpDate);
}

int dow = calendar.get(Calendar.DAY_OF_WEEK);
calendar.add(Calendar.DATE, -dow);

for (int i = 0; i < 7; i++) {
	calendar.add(Calendar.DATE, 1);
	heading2[i] = DateTimeUtil.formatDate(calendar.getTime());
}

calendar.add(Calendar.DATE, 1);
tmpDate = calendar.getTime();
String next = sdf.format(tmpDate);

calendar.add(Calendar.DATE, -8);
tmpDate = calendar.getTime();
String prev = sdf.format(tmpDate);
String editable = "0";
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

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.fitness.maintenance" />
</jsp:include>
<form name="form1" id="form1" action="admin_calendar.jsp" method="post">


<br/><br/>
<span id="calendar">
<br/><br/>
<table width="100%" border="0">
	<tr class="bigText">
		<td align="left" width="25%">
<% 
	//if (showPrev) { %>		
			<button onclick="return switchDate('<%=prev %>');" <% %>>< Previous Week</button>
<% //} 
%>			
		</td>
		<td align="center" width="50%"></td>
		<td align="right " width="25%">
<% 
	//if (showNext) { %>			
			<button onclick="return switchDate('<%=next %>');">Next Week ></button>
<% //} 
%>			
		</td>
	</tr>
</table>

<table width="100%" border="1">
	<tr class="calendarHeader">
		<th width="16%" class="calendarDayText">Time</th>
		<th width="14%" class="calendarDaySunText"><%=heading1[0] %><br/><%=heading2[0] %></th>
		<th width="14%" class="calendarDayText"><%=heading1[1] %><br/><%=heading2[1] %></th>
		<th width="14%" class="calendarDayText"><%=heading1[2] %><br/><%=heading2[2] %></th>
		<th width="14%" class="calendarDayText"><%=heading1[3] %><br/><%=heading2[3] %></th>
		<th width="14%" class="calendarDayText"><%=heading1[4] %><br/><%=heading2[4] %></th>
		<th width="14%" class="calendarDayText"><%=heading1[5] %><br/><%=heading2[5] %></th>
	</tr>
<%
	try {
		ArrayList record = FitnessDB.getTimeSlot();
		ReportableListObject row = null;
		
		String slotNo;
		String desc;
		SimpleDateFormat sdfTime = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
	
				slotNo = row.getValue(0);
				desc = row.getValue(1) + " - " + row.getValue(2);
%>
	<tr class="calendarText" align="center">
		<td><%=desc %></td>	
<%
				for (int j = 0; j < 6; j++) {
					
					tmpDate = sdfTime.parse(heading2[j] + " " + row.getValue(1));
					
					if (tmpDate.compareTo(currentDate) > 0) {
						editable = "1";
					} else {
						editable = "0";
					}
%>
		<td><a href="javascript:view('<%=heading2[j] %>', '<%=slotNo %>', '<%=editable %>');"><%=FitnessDB.getCount(heading2[j], slotNo) %></a></td>
<%				
				}
%>
	</tr>
<%				
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
</table>
</span>
<input type="hidden" name="displaydate"/>
</form>
<script language="javascript">
<!--
	function view(date, timeslot, editable) {

		callPopUpWindow("booking_list.jsp?bookDate=" + date + "&timeslot=" + timeslot + "&editable=" + editable);
	}
	
	function switchDate(date) {
		document.form1.displaydate.value = date;
		document.form1.submit();
		return true;
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>