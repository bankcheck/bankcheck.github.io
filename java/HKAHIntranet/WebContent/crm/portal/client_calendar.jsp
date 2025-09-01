<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

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
if (selectYear != null && !selectYear.equals("undefined")) {
	calendar.set(Calendar.YEAR, Integer.parseInt(selectYear));
}
if (selectMonth != null && !selectMonth.equals("undefined")) {
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
String calendarDate = DateTimeUtil.formatDate(calendar.getTime());


ArrayList record = ScheduleDB.getListByDateWithUserID("lmc.crm",	null, null,calendarDate	,  daysInMonth + calendarDate.substring(2),CRMClientDB.getClientID(userBean.getLoginID()),"guest");
ArrayList<ClientEvent> listOfEvent = new ArrayList<ClientEvent>();

if(record.size() >0){
	for (int i = 0; i < record.size(); i++) {
				
		ReportableListObject row = (ReportableListObject) record.get(i);
		String courseID = row.getValue(2);		
		String courseDesc = row.getValue(3);
		String scheduleID = row.getValue(7);
		String classDate = row.getValue(8);
		String classSize = row.getValue(13);
		String enrolled = row.getValue(14);	
		String available = row.getValue(15);
		String isEnrolled = row.getValue(16);
		String status = row.getValue(17);
		String startTime = row.getValue(9);
		String description = row.getValue(19);
		boolean allowEnroll = !ConstantsVariable.ZERO_VALUE.equals(classSize);
		
		boolean fullEnroll = enrolled.equals(classSize);
		boolean courseDetail = false;

		// reset class info storage
		StringBuffer classInfo = new StringBuffer();
		classInfo.setLength(0);
		
		int labelColor = 0;
		Random random = new Random();
		try {
			labelColor = Integer.parseInt(courseID) % 9 + 1;
		} catch (Exception e) {
			labelColor = random.nextInt(8) + 1;
		}
		
		classInfo.append("<span class=\"labelColor");		
		classInfo.append(labelColor);
		classInfo.append("\">");
		classInfo.append(courseDesc.toUpperCase());
		classInfo.append("</span>");
			
		if (allowEnroll) {			
			if(status.equals("open")){
				if(isEnrolled.length()>0){
					classInfo.append(" [ <a style='color:#5F497A;' href=\"javascript:void(0);\" onclick=\"enrollEvent('withdraw','"+courseID+"','"+scheduleID+"','"+(userBean.getStaffID() != null && userBean.getStaffID().length()>0?userBean.getStaffID():userBean.getUserName())+"','"+isEnrolled+"');\">");
					classInfo.append("Unjoin</a> ]");
				}else{
					if(!fullEnroll){
						classInfo.append(" [ <a style='color:#0070C0;' href=\"javascript:void(0);\" onclick=\"enrollEvent('enroll','"+courseID+"','"+scheduleID+"','"+(userBean.getStaffID() != null && userBean.getStaffID().length()>0?userBean.getStaffID():userBean.getUserName())+"');\">");
						classInfo.append("Join</a> ]");
					}
				}
				
			}else if (status.equals("suspend")){
				classInfo.append(" [ <span style='color:red;'>Suspend</span> ] ");
				if(isEnrolled.length()>0){
					classInfo.append("<br>");
					classInfo.append("<BLINK>Joined Event</BLINK>");
				}
			}else if (status.equals("close")){
				classInfo.append(" [ <span style='color:red;'>Close</span> ] ");
				if(isEnrolled.length()>0){
					classInfo.append("<br>");
					classInfo.append("<BLINK>Joined Event</BLINK>");
				}
			}
			classInfo.append("<br>");			
			classInfo.append("<span style='color:#7D28A8;'>Time: </span><span style='color:#035800'>"+startTime+"</span>");
			if(description != null && description.length()>0){
				classInfo.append("<br>");			
				classInfo.append("<span style='color:#7D28A8;'>Description: </span><span style='color:#035800'>"+description+"</span>");
			}
			classInfo.append("<br>");
			if (fullEnroll) {
				classInfo.append("Fully Registered ");
				classInfo.append("<br>");				
				classInfo.append("("+enrolled+" Joined)");
			} else {
				if(isEnrolled.length()>0){
					classInfo.append("("+enrolled+" Joined)");
				}else{
					if(status.equals("open")){
						if (!ConstantsServerSide.isTWAH()) { 
						classInfo.append("<BLINK>Register On-Line</BLINK><br>(");
						}
						classInfo.append(available);
						classInfo.append(" Avaliable)");
					}else if(status.equals("suspend") || status.equals("close")){
						classInfo.append("("+enrolled+" Joined)");
					}
				}
			}
		}else{
			classInfo.append("<br>");			
			classInfo.append("<span style='color:#7D28A8;'>Time: </span><span style='color:#035800'>"+startTime+"</span>");
			if(description != null && description.length()>0){
				classInfo.append("<br>");			
				classInfo.append("<span style='color:#7D28A8;'>Description: </span><span style='color:#035800'>"+description+"</span>");
			}
			classInfo.append("<br>");
			classInfo.append("(Event size is 0)");
		}
		classInfo.append("<p><br>");
		
		ClientEvent tempEvent = new ClientEvent(classInfo.toString(),classDate);
		listOfEvent.add(tempEvent);		
	}
}

%>

<%!
public class ClientEvent{
	String details;	
	String date;
	public ClientEvent(String details,String date){
		this.details = details;
		this.date = date;
	}
}

%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="header.jsp"/>
<body>
<div id="clientCalendar">
<form name="form_calendar" action="client_calendar.jsp" method="post">	
<table cellpadding="0" border ="0" cellspacing="0"
	class="calendar_selector" border="0">
	<tr class="bigText">
		<td align="left">
			<button type="button" onclick="return switchDate(<%=selectYearInt - 1 %>, <%=selectMonthInt %>);" 
					class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				<< <%=selectYearInt - 1 %>
			</button>
			<button type="button" onclick="return switchDate(<%=selectYearInt - (selectMonthInt==0?1:0)  %>, <%=(selectMonthInt + 11) % 12 %>);" 
					class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				<< <%=months[(selectMonthInt + 11) % 12] %>
			</button>
		</td>
		<td align="center">
			<label><%=months[selectMonthInt] %> <%=selectYearInt %></label>
		</td>
		<td align="right">
			<button type="button" onclick="return switchDate(<%=selectYearInt + (selectMonthInt==11?1:0) %>, <%=(selectMonthInt + 1) % 12 %>);" 
					class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				<%=months[(selectMonthInt + 1) % 12] %> >>
			</button>
			<button type="button" onclick="return switchDate(<%=selectYearInt + 1 %>, <%=selectMonthInt %>);" 
				class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				<%=selectYearInt + 1 %> >>
			</button>
		</td>
		<td align="center"></td>
	</tr>
	<tr>
		<td colspan="1">&nbsp;</td>
		<td align="center"><label style="font-size:15px"><bean:message key="label.today" />: <%=currentDate %></label></td>
		<td colspan="1">&nbsp;</td>
	</tr>
	<tr ></tr>
</table>
<table cellpadding="0" cellspacing="0" class="calendar" border="1">
	<tr class="calendarHeader">
		<th class="calendarDaySunText"><%=days[0] %></th>
		<th class="calendarDayText"><%=days[1] %></th>
		<th class="calendarDayText"><%=days[2] %></th>
		<th class="calendarDayText"><%=days[3] %></th>
		<th class="calendarDayText"><%=days[4] %></th>
		<th class="calendarDayText"><%=days[5] %></th>
		<th class="calendarDayText"><%=days[6] %></th>
	</tr>
	<tr class="calendarText">
<%
// print previous month
if (leadGap > 0) {
	for(int i = 0; i < leadGap; i++) {
		%><td align="center">&nbsp;</td><%
	}
}

boolean isCurrentDate = false;

// Fill in numbers for the day of month.
for (int i = 1; i <= daysInMonth; i++) {
	// append zero if date is 1 - 9
	calendarDate = (i<10?"0":"") + String.valueOf(i) + calendarDate.substring(2);
	isCurrentDate = currentDate.equals(calendarDate);
%>
	<td class="calendar-cell">
		<div>
			<span class="calendarDay<%=((leadGap + i) % 7 == 1)?"Sun":"" %>Text">
				<%=i %>&nbsp;&nbsp;&nbsp;&nbsp;<%=isCurrentDate?"<u>Today</u>":"" %>
			</span><br><br>
<%

for(ClientEvent c : listOfEvent){
	 if(c.date.equals(calendarDate)){
%>
	<%=c.details %>
<%	 
	 }
	
}
%>
		</div>
	</td>
<%
	if ((leadGap + i) % 7 == 0) {    // wrap if end of line.
		out.println("</tr>");
		out.print("<tr>");
	} else if (i == daysInMonth) {
		for(int j = 0; j < 7 - ((leadGap + daysInMonth) % 7); j++) {
			%><td align="center">&nbsp;</td><%
		}
	}
}
%>
	</tr>
</table>
<input type="hidden" name="select_year" value="<%=selectYearInt%>">
<input type="hidden" name="select_month" value="<%=selectMonthInt%>">

</form>
</div>
</body>
</html:html>


<script language="javascript">
	
	function switchDate(year, month) {		
		document.form_calendar.select_year.value = year;
		document.form_calendar.select_month.value = month;
		document.form_calendar.submit();
	}
	
	function enrollEvent(action,courseID,scheduleID,loginStaffID,enrollID) {
		var enrollEvent = false;
			if(action =='enroll'){
				enrollEvent = confirm("Enroll event?");
			}else if(action == 'withdraw'){
				enrollEvent = confirm("Withdraw from event?");
			}
			
			if(enrollEvent == true){				
			  var baseUrl ='../../crm/portal/calendar_event_enrollment.jsp?action='+action;		
				var url = baseUrl + '&courseID=' + courseID + '&scheduleID=' + scheduleID + '&loginStaffID=' + loginStaffID + '&enrollID=' + enrollID;	
				$.ajax({
					url: url,
					async: false,
					cache:false,
					success: function(values){
						if(values) {							
							alert($.trim(values));
							switchDate($("input[name=select_year]").val(),$("input[name=select_month]").val());							
						}else {
							alert('Error occured while enrolling event.');
						}
					},
					error: function() {
						alert('Error occured while enrolling event.');
					}
				});
				
			
		   }else{		      			
		   }
	}
	
</script>