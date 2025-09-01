<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="javax.servlet.*,java.text.*" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%!
private ArrayList<ReportableListObject> fetchRecord(String date_from, String date_to) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT DISTINCT CHEMO_PKGCODE, PATNO, NEXT_DATE, LISTAGG(CHEMO_PHARCODE,';<BR/>') WITHIN GROUP (ORDER BY CHEMO_PHARCODE) OVER (PARTITION BY CHEMO_PKGCODE) ITEM FROM ");
	sqlStr.append("(SELECT DISTINCT C.CHEMO_PKGCODE, C.PATNO, TO_CHAR(C.NEXT_DATE, 'dd/MM/YYYY') NEXT_DATE, I.CHEMO_PHARCODE ");
	sqlStr.append("FROM CHEMOTRACK@IWEB C, CHEMOTX@IWEB T, CHEMOITEM@IWEB I ");
	sqlStr.append("WHERE C.CHEMO_PKGCODE = T.CHEMO_PKGCODE ");
	sqlStr.append("AND T.CHEMO_ITMCODE = I.CHEMO_ITMCODE ");
	sqlStr.append("AND T.CHEMO_STATUS != 0 ");
	sqlStr.append("AND C.NEXT_DATE >= TO_DATE('" + date_from + " 00:00:00', 'dd/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND C.NEXT_DATE <= TO_DATE('" + date_to + " 23:59:59', 'dd/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND C.ENABLED = 1 ");
	sqlStr.append("ORDER BY I.CHEMO_PHARCODE) ");
	sqlStr.append("ORDER BY PATNO ");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

SimpleDateFormat updateDate = new SimpleDateFormat ("dd/MM/yyyy HH:mm");
Date today = new Date();

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
String showDay = request.getParameter("showDay");
if (selectYear != null) {
	calendar.set(Calendar.YEAR, Integer.parseInt(selectYear));
}
if (selectMonth != null) {
	calendar.set(Calendar.MONTH, Integer.parseInt(selectMonth));
}
calendar.set(Calendar.DATE, 1);
String calendarDate = DateTimeUtil.formatDate(calendar.getTime());


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
//for daily view
HashMap classMapByDaily = new HashMap();
StringBuffer taskInfoByDaily = new StringBuffer();
Vector classForSameDayByDaily = null;

ArrayList record = fetchRecord(calendarDate, daysInMonth + calendarDate.substring(2));
ReportableListObject row = null;

if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		String vChemoPkgcode = row.getValue(0);
		String vPatno = row.getValue(1);
		String vNextDate = row.getValue(2);
		String vChemoPharcode = row.getValue(3);		

		// reset class info storage
		taskInfo.setLength(0);
		taskInfo.append("<td class=\"w3-small ticket\" ondblclick=\"showTicket("+vChemoPkgcode+")\" VALIGN=\"top\">");
		taskInfo.append("<span class=\"w3-medium \">#" + vPatno + ConstantsVariable.COLON_VALUE + "</span><br/>");
		taskInfo.append(vChemoPharcode);
		taskInfo.append(ConstantsVariable.SEMICOLON_VALUE + "<br/>");
		taskInfo.append("</td>");
		
		// reset class info storage (ByDaily)
		taskInfoByDaily.setLength(0);
		taskInfoByDaily.append("<td class=\"w3-small ticket\" ondblclick=\"showTicket("+vChemoPkgcode+")\" VALIGN=\"top\">");
		taskInfoByDaily.append("<span class=\"w3-medium \">#" + vPatno + ConstantsVariable.COLON_VALUE + "</span><br/>");
		taskInfoByDaily.append(vChemoPharcode);
		taskInfoByDaily.append(ConstantsVariable.SEMICOLON_VALUE + "<br/>");
		taskInfoByDaily.append("</td>");

		// store in hash map
		if (classMap.containsKey(vNextDate)) {
			classForSameDay = (Vector) classMap.get(vNextDate);
		} else {
			classForSameDay = new Vector();
		}
		
		// store in hash map (ByDaily)
		if (classMapByDaily.containsKey(vNextDate)) {
			classForSameDayByDaily = (Vector) classMapByDaily.get(vNextDate);
		} else {
			classForSameDayByDaily = new Vector();
		}
		
		if(classForSameDay.size()>=8){
			classForSameDay.add("<td class=\"w3-small ticket\" colspan=\"2\" ALIGN=\"center\" onclick=\"showDailyTicket('"+vNextDate+"')\">...</td>");
			
			// add (ByDaily)
			classForSameDayByDaily.add(taskInfo.toString());
			if(classForSameDayByDaily.size()%2 == 0){
				classForSameDayByDaily.add("</tr>");
				classForSameDayByDaily.add("<tr>");
			}
			classMapByDaily.put(vNextDate, classForSameDayByDaily);
		}else{
			classForSameDay.add(taskInfo.toString());
			if(classForSameDay.size()%2 == 0){
				classForSameDay.add("</tr>");
				classForSameDay.add("<tr>");
			}
			classMap.put(vNextDate, classForSameDay);
			
			// add (ByDaily)
			classForSameDayByDaily.add(taskInfo.toString());
			if(classForSameDayByDaily.size()%2 == 0){
				classForSameDayByDaily.add("</tr>");
				classForSameDayByDaily.add("<tr>");
			}
			classMapByDaily.put(vNextDate, classForSameDayByDaily);
		}
	}
}

if(showDay != null && showDay.length() > 0){
%>
	<table class="caseInDay" width="100%">
<%
		if (classMapByDaily.containsKey(showDay)) {
			classForSameDayByDaily = (Vector) classMapByDaily.get(showDay);
			for (int j = 0; j < classForSameDayByDaily.size(); j++) {
%>
				<%=classForSameDayByDaily.elementAt(j) %>
<%
			}
		} 
%>			</table>
	
<%
}else{

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>Chemotherapy Process</title>
<meta http-equiv="X-UA-Compatible" content="IE=9">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../css/w3.hkah.css" />
<link rel="stylesheet" type="text/css" href="../css/datepicker-ui.css" />
<script type="text/javascript" src="../js/jquery-1.5.1.min.js" /></script>
<script type="text/javascript" src="../js/datepicker.js" /></script>
<script type="text/javascript" src="../js/datepicker-ui.js" /></script>
<style type="text/css">
#Header {
	position: sticky;
	width: 100%;
	top: 0; /* stick to bottom */
	border-bottom: 3px solid #333;
	z-index: 1;
	left: 0;
	right: 0;
}
.calendarBGHighlight{
	background-color: #FFFFB6;
}
.ticket{
	margin: 3px;
	border: 1px dotted #333;
	background-color: #E1E1E1;
	width:45%;
}
#Footer {
	position: fixed;
	width: 100%;
	bottom: 0; /* stick to bottom */
	background-color: white;
	border-top: 3px solid #333;
	z-index: 2;
	left: 0;
	right: 0;
}

button{
	margin: 5px;
	border: 1px solid #888;
}

.button{
	cursor: pointer;
	background-color: #CCCCCC;
    border:2px solid #ffffff;
    text-align: center;
    color: black;
}

.pageButton{
	cursor: pointer;
	background-color: #CCCCCC;
    border:2px solid #ffffff;
    text-align: center;
    padding: 5px;
}

.selectPage{
	border: 1px solid #771C3C;
	background-color: #FFD2E2;
}


#calendar tbody{
	height: 100%;
}
#calendar .calendarHeader{
	height: 5%;
}
#calendar tbody tr{
	height: 19%;
}

#calendar{
	table-layout: fixed;
	width: 100%;  
}

.caseInDay{
	vertical-align: text-top;
}

#ticketPopup{
	z-index: 10;
}

#patientHistory{
	position: fixed;
	top: 50; 
	z-index: 10;
	right: 0;
	width: 40%;

}

#patientHistory .w3-modal-content{
	width: 100%;
}

.w3-modal-content{
	width: 50%;
}

#ChemoHistList{
	border: 5px solid #A86868;
	border-collapse: collapse;
}

</style>
<script type="text/javascript">
$(document).ready(function () {
	$("#calendar").height($(window).height()-180);
	$("#PredictCalendar").addClass("selectPage");
	$("#nextSchedule").datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		minDate: 0
    });
	$("#nextSchedule").datepicker( "option", "dateFormat", "dd/mm/yy" );
});


function switchDate(year, month) {
	document.form1.select_year.value = year;
	document.form1.select_month.value = month;
	/*document.form1.submit();
	return true;*/
	
	window.location.href = "/intranet/pharmacy/chemoTrackingPredict.jsp?select_year=" + year + "&select_month=" + month;
}

function showTicket(chemopkg){
	$.ajax({
		type: "POST",
		url: "chemoUpdateQueue_ajax.jsp",
		data: "process=getTicket&chemoPkgcode=" + chemopkg + "&canRemove=N",
		success: function(values) {
			$("#addChemoTable >tbody").html(values.trim());
		}
	});//$.ajax
	$("#ticketPopup").show();
	$("#updateCaseTitle").show();
	$("#startCaseTitle").hide();
}

function closeTicket(){
	$("#newTicketPopup").hide();
	$("#ticketPopup").hide();
	$("#addChemoTable >tbody").html("");
	$("#ticketPopup input").val("");
	$("#patName").html("");
}

function closeTicketByDailyPopup(){
	$("#ticketByDailyPopup").hide();
	$("#ticketByDailyPopup-content").html("");
}

function updateChemo(){
	var error = false;
	var d = new Date();
	d.setDate(d.getDate() - 1);
	
	var patno = $.trim($("#patno").val());
	var chemoPkgcode = $.trim($("#chemoPkgcode").val());
	var nextSchedule = $.trim($("#nextSchedule").val());
	var checkDate = $.trim($("#nextSchedule").val()).split("/");
	if (new Date(checkDate[2],checkDate[1]-1,checkDate[0]) < d){
		error = true;
	}
		if(!error){
			$.ajax({
				type: "POST",
				url: "chemoUpdateQueue_ajax.jsp",
				data: "process=updateChemoPredict&chemoPkgcode=" + chemoPkgcode + "&nextSchedule=" + nextSchedule,
				success: function(values) {
					closeTicket();
					switchDate("<%=selectYearInt %>","<%=selectMonthInt %>");
				}
			});//$.ajax
		}else{
			alert("Update error. Please check.");
			return;
		}
}

function showDailyTicket(day){
	$.ajax({
		type: "POST",
		url: "chemoTrackingPredict.jsp",
		data: "select_year=<%=selectYearInt %>&select_month=<%=selectMonthInt %>&showDay=" + day,
		success: function(values) {
			$("#ticketByDailyTitle").html(day);
			$("#ticketByDailyPopup-content").html(values.trim());
		}
	});//$.ajax
	$("#ticketByDailyPopup").show();
}

function ChemoProcess(){
	window.open("chemoTracking.jsp", "_blank");
}

function ChemoHistory(){
	window.open("chemoTrackingHistory.jsp", "_blank");
}

function PredictCalendar(){
	window.location.href = "/intranet/pharmacy/chemoTrackingPredict.jsp";
}

function showNewTrigger(){
	action = "new";
	$("#ticketPopup").show();
	$("#newCasePopup").show();
	$("#updateCaseTitle").hide();
	$("#startCaseTitle").show();
	$("#patno").focus();
}

function showPatInfo(){
	$.ajax({
		type: "POST",
		url: "chemoUpdateQueue_ajax.jsp",
		data: "process=getPatInfo&patno=" + $("#patno").val(),
		success: function(values) {
			if(values.trim().length > 0){
				$("#patName").html(values.trim());
				$("#pastHistButton").show();
			}else{
				$("#patName").html("");
				$("#pastHistButton").hide();
			}
		}
	});//$.ajax
}

function getPastHistoryByPatient(patno, chemoPkgcode){
	if (chemoPkgcode == "-1"){
		alert("No more history.");
		return;
	}
	$.ajax({
		type: "POST",
		url: "chemoTrackingHistory_ByPatient.jsp",
		data: "patno=" + patno
			+ "&chemoPkgcode=" + chemoPkgcode ,
		success: function(values) {
			if(values.trim().length > 0){
				$("#patientHistory").html(values.trim());
				$(".w3-modal-content").css("margin-right","5%");
				$("#patientHistory").show();
			}else{
				alert("No Chemotherapy History found.");
			}
			if(action == "update"){
				$("#appendButton").hide();
			}
		}
	});//$.ajax
}

function closePatHist(){
	$("#patientHistory").hide();
}

</script>
</head>
<body>
<div id="Header" class="w3-container w3-display-container ah-pink">
	<div class="w3-container w3-center">
		<table width="100%" border="0">
			<tr>
				<td width="10%" rowspan="2"><button onclick="return switchDate(<%=selectYearInt - 1 %>, <%=selectMonthInt %>);"><< <%=selectYearInt - 1 %></button></td>
				<td width="10%" rowspan="2"><button onclick="return switchDate(<%=selectYearInt - (selectMonthInt==0?1:0)  %>, <%=(selectMonthInt + 11) % 12 %>);"><< <%=months[(selectMonthInt + 11) % 12] %></button></td>
				<td width="60%" class="w3-xlarge"><b>Chemotherapy Predicted Calendar</b></td>
				<td width="10%" rowspan="2"><button onclick="return switchDate(<%=selectYearInt + (selectMonthInt==11?1:0) %>, <%=(selectMonthInt + 1) % 12 %>);"><%=months[(selectMonthInt + 1) % 12] %> >></button></td>
				<td width="10%" rowspan="2"><button onclick="return switchDate(<%=selectYearInt + 1 %>, <%=selectMonthInt %>);"><%=selectYearInt + 1 %> >></button></td>
			</tr>
			<tr class="w3-large">
				<td width="60%"><%=months[selectMonthInt] %> <%=selectYearInt %></td>
			</tr>
			<tr class="w3-large">
				<td colspan="5"><!-- <button id="newButton" class="w3-round-large button " onclick="showNewTrigger()">New</button> --></td>
			</tr>
		</table>
		<div class="w3-container w3-small ah-pink w3-right w3-display-bottomright">
		Last Update Date/Time: <%=updateDate.format(today) %>
	</div>
	</div>
</div>
<br/>
<div class="w3-container">
	<table id="calendar" border="1">
		<thead>
		<tr class="calendarHeader">
			<th class="calendarDaySunText"><%=days[0] %></th>
			<th class="calendarDayText"><%=days[1] %></th>
			<th class="calendarDayText"><%=days[2] %></th>
			<th class="calendarDayText"><%=days[3] %></th>
			<th class="calendarDayText"><%=days[4] %></th>
			<th class="calendarDayText"><%=days[5] %></th>
			<th class="calendarDayText"><%=days[6] %></th>
		</tr>
		</thead>
		<tbody>
		<tr class="calendarText">
<%
	// print previous month
	if (leadGap > 0) {
%>
			<td align="center" colspan="<%=leadGap %>">&nbsp;</td>
<%
	}
	
	boolean isCurrentDate = false;
	
	// Fill in numbers for the day of month.
	for (int i = 1; i <= daysInMonth; i++) {
		// append zero if date is 1 - 9
		calendarDate = (i<10?"0":"") + String.valueOf(i) + calendarDate.substring(2);
		isCurrentDate = currentDate.equals(calendarDate);
%>
			<td class="calendarBG<%=isCurrentDate?"Highlight":"" %>" VALIGN="top" ALIGN="left">
				<span class="calendarDay<%=((leadGap + i) % 7 == 1)?"Sun":"" %>Text"><%=i %></span>
				<br/><table class="caseInDay" width="100%">
<%
		if (classMap.containsKey(calendarDate)) {
			classForSameDay = (Vector) classMap.get(calendarDate);
			for (int j = 0; j < classForSameDay.size(); j++) {
%>
				<%=classForSameDay.elementAt(j) %>
<%
			}
		} 
%>			</table></td>
<%
		if ((leadGap + i) % 7 == 0) {    // wrap if end of line.
			out.println("</tr>");
			out.print("<tr class=\"calendarText\">");
		} else if (i == daysInMonth) {
%>
			<td align="center" colspan="<%=7 - ((leadGap + daysInMonth) % 7) %>">&nbsp;</td>
<%
		}
	}
%>
		</tr>
		</tbody>
	</table>
	<br/><br/><br/>
</div>
<form name="form1" id="form1" action="chemoTrackingPredict.jsp" method="post">
	<input type="hidden" name="select_year" value="<%=selectYearInt %>" />
	<input type="hidden" name="select_month" value="<%=selectMonthInt %>" />
</form>

<div class="w3-container" id="Footer">
	<div class="w3-cell-row">
		<div class="w3-container w3-col" style="width:55%;" >&nbsp;</div>
		<div class="w3-container w3-col w3-btn pageButton" style="width:15%" onclick="ChemoProcess()" id="ChemoProcess">Chemotherapy Process</div>
		<div class="w3-container w3-col w3-btn pageButton" style="width:15%" onclick="ChemoHistory()" id="ChemoHistory">Past History</div>
		<div class="w3-container w3-col w3-btn pageButton" style="width:15%" onclick="PredictCalendar()" id="PredictCalendar">Predicted Chemotherapy</div>
  	</div>
</div>

<!-- New Case Trigger -->
<div id="ticketPopup" class="w3-modal">
 	<div class="w3-modal-content">
    	<header class="w3-container ah-pink">
			<span id="closePopup" onclick="closeTicket()" class="w3-button w3-display-topright">&times;</span>
			<b><font face="AR PL SungtiL GB" size=6 >
				<span id="startCaseTitle">Create New Case</span>
				<span id="updateCaseTitle">Update Case</span>
			</font></b>
		</header>

		<div class="w3-container w3-display" id="newChemoList" style="width:100%">
			<br/>
			Patient No. <input type="text" name="patno" id="patno" value="" onkeyup="showPatInfo()"/><br/>
			Patient Name: <span id="patName"></span>
			<br/><br/>
			<table id="addChemoTable" style="width:100%">
				<thead>
					<tr>
						<th style="text-align:left; width:75%">Chemo Agent</th>
						<th style="text-align:left; width:25%">Dose</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
			<br/>
			Next Schedule <input type="text" name="nextSchedule" id="nextSchedule" value="" />
			<span class="button w3-button w3-border w3-border-red w3-round-large" style="padding:3px;" onclick="$('#nextSchedule').val('');"/> Cancel Predict</span>
			<input type="hidden" name="removeItem" id="removeItem" value="" />
			<input type="hidden" name="chemoPkgcode" id="chemoPkgcode" value="" />
			<br/><br/><br/>
			<button id="pastHistButton" class="w3-button w3-round-large button w3-display-topright" onclick="getPastHistoryByPatient($('#patno').val(),$('#chemoPkgcode').val())">Past History</button>
		</div>
		<footer class="w3-container ah-pink">
			<button id="closeButton" class="w3-button ah-pink w3-round-large button" onclick="closeTicket()">Close</button>
			<button id="updateButton" class="w3-button ah-pink w3-round-large w3-display-bottomright button" onclick="updateChemo()">Update</button>
		</footer>
  </div>
</div>

<div class="w3-modal" id="patientHistory"></div>


</body>
</html>

<%	}%>