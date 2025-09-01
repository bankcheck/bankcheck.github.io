<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%
StringBuffer classInfo = new StringBuffer();
String currentDate = DateTimeUtil.getCurrentDate();
String []weekRange = DateTimeUtil.getCurrentWeekRange();
String courseID = null;
String classID = null;
String courseDesc = null;
String scheduleDesc = null;
String classDate = null;
String classStartTime = null;
String classSize = null;
boolean allowEnroll = false;
int labelColor = 0;

ArrayList record = ScheduleDB.getCalendar(null, currentDate, weekRange[1], true);
if (record.size() > 0) {
	ReportableListObject row = null;
	Random random = new Random();
%>			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td rowspan="<%=((record.size() - 1) * 2) + 4 %>" valign="top">
						<img src="../images/A logo.jpg" width="16" height="16"/>
					</td>
					<td rowspan="<%=((record.size() - 1) * 2) + 4 %>" width="10" valign="top">&nbsp;</td>
					<td class="h1_margin">
						<a class="topstoryblue" href="javascript:void(0);"><H1 id="TS">Weekly Online Education Calendar</H1></a>
					</td>
				</tr>
				<tr><td height="2" bgcolor="#F2F2F2"></td></tr>
<%	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		courseID = row.getValue(0);
		classID = row.getValue(1);
		courseDesc = row.getValue(2);
		scheduleDesc = row.getValue(3);
		classDate = row.getValue(5);
		classStartTime = row.getValue(6);
		classSize = row.getValue(13);
		allowEnroll = !ConstantsVariable.ZERO_VALUE.equals(classSize);

		// reset class info storage
		classInfo.setLength(0);
		try {
			labelColor = Integer.parseInt(courseID) % 9 + 1;
		} catch (Exception e) {
			labelColor = random.nextInt(8) + 1;
		}
		if (allowEnroll) {
			classInfo.append("<a href=\"../education/class_enrollment.jsp?courseID=");
			classInfo.append(courseID);
			classInfo.append("&classID=");
			classInfo.append(classID);
			classInfo.append("\" class=\"labelColor");
		} else {
			classInfo.append("<span class=\"labelColor");
		}
		classInfo.append(labelColor);
		classInfo.append("\">");
		classInfo.append(courseDesc.toUpperCase());
		if (scheduleDesc != null && scheduleDesc.length() > 0) {
			classInfo.append("&nbsp;(");
			classInfo.append(scheduleDesc);
			classInfo.append(")");
		}
		if (allowEnroll) {
			classInfo.append("</a><br><BLINK>REGISTER ON-LINE</BLINK>");
		} else {
			classInfo.append("</span>");
		}
		classInfo.append("<br>");
%>
				<tr>
					<td class="h1_margin">
						<span class="reported_quote"><%=classDate %>&nbsp;<%=classStartTime==null?"":classStartTime %></span>
						<span class="pupular_content" style="line-height: 13px"><%=classInfo %></span>
					</td>
				</tr>
				<tr><td height="7">&nbsp;</td></tr>
<%	} %>
			</table>
<%}%>