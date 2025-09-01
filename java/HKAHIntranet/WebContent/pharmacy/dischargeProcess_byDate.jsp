<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="javax.servlet.*,java.text.*" %>
<%!
private ArrayList<ReportableListObject> fetchWard(String locid) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT WRDNAME ");
	sqlStr.append("FROM   WARD@IWEB ");
	sqlStr.append("WHERE  WRDCODE = UPPER(?) ");
	sqlStr.append("AND    ACTIVE = '-1' ");
	return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { locid });
}

private ArrayList<ReportableListObject> fetchRecord(String locid, String searchDate) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT 	T.REGID, T.WRDCODE, T.BEDCODE, T.PATNO, P.PATFNAME, ");
	sqlStr.append("		TO_CHAR(T.START_DATE, 'DD/MM/YYYY HH24:MI'), ");
	sqlStr.append("		TO_CHAR(T.TO_RX_DATE, 'DD/MM/YYYY HH24:MI'), T.TO_RX_DATE_REMARK, ");
	sqlStr.append("		TO_CHAR(T.RECEIVE_DATE, 'DD/MM/YYYY HH24:MI'), T.RECEIVE_DATE_REMARK, ");
	sqlStr.append("		TO_CHAR(T.ENTRY_DATE, 'DD/MM/YYYY HH24:MI'), T.ENTRY_DATE_REMARK, ");
	sqlStr.append("		TO_CHAR(T.TO_PBO_DATE, 'DD/MM/YYYY HH24:MI'), T.TO_PBO_DATE_REMARK, ");
	sqlStr.append("		TO_CHAR(T.FINISH_BILLING_DATE, 'DD/MM/YYYY HH24:MI'), T.FINISH_BILLING_DATE_REMARK, ");
	sqlStr.append("		TO_CHAR(T.PAYMENT_SETTLEMENT_DATE, 'DD/MM/YYYY HH24:MI'), T.PAYMENT_SETTLEMENT_DATE_REMARK, ");
	sqlStr.append("		TO_CHAR(T.NO_RX_DISCHARGE_DATE, 'DD/MM/YYYY HH24:MI'), T.NO_RX_DISCHARGE_DATE_REMARK, ");
	sqlStr.append("		TO_CHAR(T.RX_BEDSIDE_DISCHARGE_DATE, 'DD/MM/YYYY HH24:MI'), T.BEDSIDE_DISCHARGE_DATE_REMARK, ");
	sqlStr.append("		TO_CHAR(T.DRUG_PICKING_DATE, 'DD/MM/YYYY HH24:MI'), T.DRUG_PICKING_DATE_REMARK, ");
	sqlStr.append("		TO_CHAR(T.MODIFIED_DATE, 'DD/MM/YYYY HH24:MI'), T.NO_MED ");

	sqlStr.append("FROM TICKET_QUEUE@IWEB T, PATIENT@IWEB P ");
	sqlStr.append("WHERE P.PATNO = T.PATNO ");
	sqlStr.append("AND 	TO_CHAR(T.START_DATE, 'MM/DD/YYYY') = '"+searchDate+"' ");
	sqlStr.append("AND T.STATUS > 0 ");
	sqlStr.append("AND (	(T.STATUS IN (8,9,10) AND T.PAYMENT_SETTLEMENT_DATE IS NOT NULL) OR ");
	sqlStr.append("			(T.STATUS = 7 AND (T.RX_BEDSIDE_DISCHARGE_DATE IS NOT NULL OR T.NO_RX_DISCHARGE_DATE IS NOT NULL OR T.DRUG_PICKING_DATE IS NOT NULL))) ");
	if(!"PBO".equals(locid)&&!"PHAR".equals(locid)&&!"allDept".equals(locid)){
		if("SC".equals(locid) || "MS".equals(locid)){
			sqlStr.append("AND T.WRDCODE IN ('SC','MS') ");
		}else{
			sqlStr.append("AND T.WRDCODE = UPPER('"+locid+"') ");
		}
	}
	sqlStr.append("AND T.ENABLED = '1' ");
	sqlStr.append("ORDER BY T.START_DATE DESC ");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%><%
ArrayList<ReportableListObject> record = null;
ArrayList<ReportableListObject> record2 = null;
ReportableListObject row = null;

String locid = request.getParameter("locid");
String searchDate = request.getParameter("searchDate");
SimpleDateFormat ft = new SimpleDateFormat ("MM/dd/yyyy");
SimpleDateFormat display = new SimpleDateFormat ("dd/MM/yyyy");
SimpleDateFormat updateDate = new SimpleDateFormat ("dd/MM/yyyy HH:mm");
Date today = new Date();
String displayDate;
if (searchDate == null || "".equals(searchDate)){
	/*searchDate = DateTimeUtil.getCurrentDate(0);*/
	searchDate = ft.format(today);
	displayDate = display.format(today);
}else{
	Date search = new Date(searchDate);
	searchDate = ft.format(search);
	displayDate = display.format(search);
}
Date tmr = new Date(searchDate);
tmr.setDate(tmr.getDate() + 1);
Date ytd = new Date(searchDate);
ytd.setDate(ytd.getDate() - 1);

boolean isPBO = false;
boolean isPhar = false;
boolean isWard = false;
String locDesc = null;
if (locid != null && "PBO".equals(locid)) {
	locDesc = "PBO";
	isPBO = true;
} else if (locid != null && "PHAR".equals(locid)) {
	locDesc = "Pharmacy";
	isPhar = true;
} else if (locid != null && "allDept".equals(locid)) {
	locDesc = "All Department";
	isWard = true;
} else if (locid != null&& locid.length() > 0){
	record = fetchWard(locid);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		locDesc = row.getValue(0);
		if("SC".equals(locid) || "MS".equals(locid)){
			if("SC".equals(locid)){
				record2 = fetchWard("MS");
			}else if("MS".equals(locid)){
				record2 = fetchWard("SC");
			}
			if (record2.size() > 0) {
				row = (ReportableListObject) record2.get(0);
				locDesc = locDesc + " & " + row.getValue(0);
			}
		}
	} else {
		locDesc = locid;
	}
	isWard = true;
} else {
	locid = "PHAR";
	locDesc = "Pharmacy";
	isPhar = true;
}
record = fetchRecord(locid, searchDate);
int count = record.size();
request.setAttribute("record_list", record);

%>
<html>

<head>
<link rel="stylesheet" type="text/css" href="../css/w3.hkah.css" />
<link rel="shortcut icon" href="../images/discharge.ico" type="image/x-icon" />
<title>Discharge Process History</title>
<script type="text/javascript" src="../js/jquery-1.5.1.min.js" /></script>
<script type="text/javascript">
var locid = "<%=locid %>";
var searchDate = "<%=searchDate %>";

$(document).ready(function() {
	$('input').filter('.datepickerfieldOverride').datepicker({
		 showOn: 'focus', buttonImageOnly: true, buttonImage: "../images/calendar.jpg",
	    beforeShow: function(input, inst)
	    {
	        inst.dpDiv.css({marginTop: '7%', marginLeft: '100px'});
	    }
	});
});

function remarkPopup(regid, updateStatus){
	$.ajax({
		type: "POST",
		url: "dischargeProcessUpdate_ajax.jsp",
		data: "queue=" + updateStatus + "&regID=" + regid + "&process=getRemark",
		success: function(values) {
			$("#remark").html(values);
		}
	});//$.ajax
	$.ajax({
		type: "POST",
		url: "dischargeProcessUpdate_ajax.jsp",
		data: "queue=" + updateStatus + "&regID=" + regid + "&process=getPatno",
		success: function(values) {
			$("#remarkPatno").html(values);
		}
	});//$.ajax
	$("#remarkRegid").val(regid);
	$("#remarkStatus").val(updateStatus);

	<% if(isPhar){ %>
	if(updateStatus =='3'){
		document.getElementById("noMedContent").style.display = "inline";
	}else{
		document.getElementById("noMedContent").style.display = "none";
	}
	if(updateStatus == "2" || updateStatus == "5" || updateStatus == "6" || updateStatus == "7"){
		document.getElementById("remark").readOnly = true;
		document.getElementById("saveButton").style.display = "none";
	}else{
		document.getElementById("saveButton").style.display = "inline";
		document.getElementById("remark").readOnly = false;
	}
	<% } else if(isPBO){ %>
	if(updateStatus == "5" || updateStatus == "6" || updateStatus == "7"){
		document.getElementById("saveButton").style.display = "inline";
		document.getElementById("remark").readOnly = false;
	}else{
		document.getElementById("remark").readOnly = true;
		document.getElementById("saveButton").style.display = "none";
	}
	<% } else if(isWard){ %>
	if(updateStatus == "2" || updateStatus == "9"){
		document.getElementById("saveButton").style.display = "inline";
		document.getElementById("remark").readOnly = false;
	}else{
		document.getElementById("remark").readOnly = true;
		document.getElementById("saveButton").style.display = "none";
	}
	<% } else { %>
	document.getElementById("remark").readOnly = true;
	document.getElementById("saveButton").style.display = "none";
	<% } %>
	document.getElementById("RemarkPopup").style.display = "block";
}

function closePopup(){
	$("#remark").val("");
	$("#noMed").val("");
	document.getElementById("RemarkPopup").style.display = "none";
}

function changeDate(s){
	var nextDay;
	if(s == "+"){
		nextDay = "<%=ft.format(tmr) %>";
	}else if (s == "-"){
		nextDay = "<%=ft.format(ytd) %>";
	}else {
		s = s.split("/");
		nextDay = s[1] + "/" + s[0] + "/" + s[2];
	}
	window.location.href = "/intranet/pharmacy/dischargeProcess_byDate.jsp?locid=" + locid + "&searchDate=" + nextDay;
}

function saveRemark(){
	var regid = $("#remarkRegid").val();
	var updateStatus = $("#remarkStatus").val();
	var remark = $("#remark").val();
	var nomed = $("#noMed").val();
	if (nomed != null)
		nomed = nomed.split("+").join("%2B");
	$.ajax({
		type: "POST",
		url: "dischargeProcessUpdate_ajax.jsp",
		data: "locid=<%=locid %>&queue=" + updateStatus + "&regID=" + regid + "&nomed=" + nomed + "&process=addRemark&remark=" + remark,
		success: function(values) {
			$("#remark").val("");
			closePopup();
			changeDate($('#searchDate').val());
		}
	});//$.ajax
}

function reprint(regid){
	$.ajax({
		type: "POST",
		url: "dischargeProcessUpdate_ajax.jsp",
		data: "locid=<%=locid %>&regID="+regid+"&process=reprint",
		success: function(values) {
			if (values != '') {
				window.location.href = reportUrl + values + '.pdf';
				//console.log(values);
				// done
			}//if
		}//success
	});//$.ajax
}

function getNativeCallUrl() {
	var printer = "";
	var newUrl = '<%=request.getRequestURL() %>';
	var index = newUrl.indexOf('/intranet');
	if (index > 0) {
		index = newUrl.indexOf('/', index + 1);
		if (index > 0) {
			<% if(isPhar){ %>
			printer = "DISCHARGELABEL_MAR";
			<% }%>

			reportUrl = 'NHSClientApp:' + printer + ':' + newUrl.substring(0, index) + '/report/';
		}
	}
}

getNativeCallUrl();

function viewAllDept(){
	if(locid != 'allDept'){
	window.open(
			"/intranet/pharmacy/dischargeProcess_byDate.jsp?locid=allDept&searchDate="+searchDate,
			 "_blank" // <- This is what makes it open in a new window.
			);
	}
}
</script>
<style type="text/css">
body{
	background:#EAEAEA;
}
#Header {
	/*height: 13%;*/
	border-bottom: 3px solid #333;
	width: 100%;
	text-align: center;
	padding:8px;
}

#listInfo {
	padding: 8px;
	/*overflow-y: scroll;
	height: 73%;*/
}
#Footer {
	height: 17%;
	position: absolute;
	width: 100%;
	bottom: 0; /* stick to bottom */
	background-color: white;
	border-top: 3px solid #333;
	z-index: 10;
	left: 0;
	right: 0;
}
.box {
	border: 1px solid #CCC;
}
.completeImg{
	cursor: pointer;
}

#RemarkPopup {
	display: none; /* Hidden by default */
	position: absolute;
	z-index: 1; /* Sit on top */
	left: 35%;
	top: 30%;
	width: 30%;
	height: 40%;
	overflow: auto; /* Enable scroll if needed */
	background-color: #fefefe;
	margin: auto;
	padding: 0px;
	border: 1px solid #888;
}

#searchDatePopup {
	display: none; /* Hidden by default */
	position: absolute;
	z-index: 1; /* Sit on top */
	left: 600px;
    top: 115px;
    width: 30%;
	overflow: auto; /* Enable scroll if needed */
	background-color: #fefefe;
	margin: auto;
	padding: 10px;
	border: 1px solid #888;
}

#tmrDischargePopup {
	display: none; /* Hidden by default */
	position: absolute; /* Stay in place */
	z-index: 11; /* Sit on top */
	left: 10%;
	top: 8%;
	width: 80%;
	height: 80%;
	overflow: auto; /* Enable scroll if needed */
	background-color: #fefefe;
	margin: auto;
	padding: 0px;
	border: 1px solid #888;
}

#remarkContent {
	padding: 20px;
}
button{
	margin: 5px;
	border: 1px solid #888;
}
#closePopUp{
	position: absolute;
	right: 0;
	top: 0;
	margin: 8px;
	cursor: pointer;
}
.leftbuttom{
	position: absolute;
	left: 0;
	bottom: 0;
	margin: 8px;
	cursor: pointer;
}
.button{
	cursor: pointer;
    opacity: 0.9;
    font-size: 150%;
    text-align: center;
}

#row1{
	border-spacing: 0px;
}

.wardList{
	background-color: #FFEEC8;
}
.pharList{
	background-color: #F2C8FF;
}
.pboList{
	background-color: #C4C9FF;
}

.completedStep{
	width:90%;
	height:100%;
	display:block;
	background-color: #c0fccc;
	border: 2px solid #64FF53;
	padding: 8px;
	cursor: pointer;
	text-align: center;
	margin: 2px auto;
}
.incompletedStep{
	width:90%;
	height:100%;
	display:block;
	border: 2px solid #64FF53;
	padding: 8px;
	text-align: center;
	margin: 2px auto;
	background-color: white;
}
.alertStep{
	width:90%;
	height:100%;
	display:block;
	border: 2px solid #D8D500;
	padding: 8px;
	text-align: center;
	margin: 2px auto;
	animation: flash 2s;
	animation-iteration-count: infinite;
	background-color: #FFFE84;
}
#searchDate{
	padding: 8px;
    border: none;
    background-color: #AA0066;
    color: white;
    text-align: center;
    font-size: medium;
}
.viewAllbuttom{
	position: absolute;
	left: 0;
	top: 0;
	cursor: pointer;
	margin: 8px;
    padding: 12;
}
</style>
</head>
<jsp:include page="../common/header.jsp"/>
<body style="background:#EAEAEA;">
<div id="Header" class="w3-display-container ah-pink">
	<b><font id="" face="AR PL SungtiL GB" size=6 >Discharge Process History -- <%=locDesc %></font></b><br/>
	<img class="button" src="../images/arrow-left.png" width="35" height="35" border="0" onclick="changeDate('-');"></img>
	<input type="textfield" name="searchDate" id="searchDate" class="datepickerfieldOverride" value="<%=displayDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
	<img class="button" src="../images/arrow-right.png" width="35" height="35" border="0" onclick="changeDate('+');"></img>
	<br/>
	<input type="button" value="Search" onclick="changeDate($('#searchDate').val());"/>
	<div class="w3-container w3-small ah-pink w3-right w3-display-bottomleft">
		Total: <%=count %>
	</div>
	<div class="w3-container w3-small ah-pink w3-right w3-display-bottomright">
		Last Update Date/Time: <%=updateDate.format(today) %>
	</div>
	<div class="w3-container w3-small ah-pink w3-right w3-display-topright">
		<img id="closeWindow" src="../images/delete4.png" width="30" height="30" border="0" onclick="window.close();"></img>
	</div>
<%	if (isWard) { %>	
	<button class="w3-button w3-pale-red w3-round-large w3-display-topleft viewAllbuttom" onclick="viewAllDept()">View All Dept.</button>
<%	} %>
</div>

<!-- index page -->
<div class="w3-container" id="listInfo" onclick='' style="background:#EAEAEA;">
<%	if (count > 0) { %>
<display:table id="row1" name="requestScope.record_list"  export="false" style="background:#EAEAEA;" class=" ">

		<c:set var="ms" value="60000" /><!-- __*ms = __mins eg.5*ms = 5mins-->
		<jsp:useBean id="now" class="java.util.Date" />

		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="startTime" 			value="${row1.fields5}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="toRxTime" 			value="${row1.fields6}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="receiveTime" 		value="${row1.fields8}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="entryTime" 			value="${row1.fields10}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="toPBOTime" 			value="${row1.fields12}" />

		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="finishBillingTime" 	value="${row1.fields14}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="paymentSettleTime" 	value="${row1.fields16}" />

		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="noDischargeTime" 	value="${row1.fields18}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="rxBedsideTime" 		value="${row1.fields20}" />
		<fmt:parseDate pattern="dd/MM/yyyy HH:mm"  var="drugPickTime" 		value="${row1.fields22}" />

<%	if("PHAR".equals(locid)){ %>
	<display:column title="" style="width:1%; " >
		<img class="button" src="../images/print.jpg" width="25" height="25" border="0" onclick=reprint(<c:out value="${row1.fields0}" />) ></img>
	</display:column>
<%	} %>

	<display:column title="Start Time" style="width:5%; " >
		<c:set var="showDate" value="${fn:substring(row1.fields5, 0, 5)}"/>
		<c:set var="showTime" value="${fn:substring(row1.fields5, 11, 16)}"/>
		<c:out value='${showTime}'/>
	</display:column>
	<display:column property="fields1" title="Ward" style="width:4%; "/>
	<display:column property="fields2" title="Bed#" style="width:5%; "/>
	<display:column property="fields3" title="Patient#" style="width:6.5%; "/>
	<display:column property="fields4" title="Last Name" style="width:16%; "/>
	<display:column property="fields25" title="No.Of Meds" style="width:4%; "/>
	<display:column title="Ward<br>Send to Pharmacy" class="w3-center wardList" headerClass="wardList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields6}">
				<c:set var="logDate" value="${fn:substring(row1.fields6, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields6, 11, 16)}"/>
				<c:choose>
					<c:when test="${toRxTime.time - startTime.time > 15*ms}">
						<c:set var="stepClass" value="alertStep"/>
					</c:when>
					<c:otherwise>
						<c:set var="stepClass" value="completedStep"/>
					</c:otherwise>
				</c:choose>
				<span class="<c:out value="${stepClass}" />" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"2") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields7}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<span class="incompletedStep">&nbsp;</span>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Pharmacy<br>Received Order" class="w3-center" style="width:6.5%;" >
		<c:choose>
			<c:when test="${not empty row1.fields8}">
				<c:set var="logDate" value="${fn:substring(row1.fields8, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields8, 11, 16)}"/>
				<c:choose>
					<c:when test = "${receiveTime.time - toRxTime.time > 10*ms}">
						<c:set var="stepClass" value="alertStep"/>
					</c:when>
					<c:otherwise>
						<c:set var="stepClass" value="completedStep"/>
					</c:otherwise>
				</c:choose>
				<span class="<c:out value="${stepClass}" />" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"3") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields9}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<span class="incompletedStep">&nbsp;</span>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Pharmacy<br>Completed Order" class="w3-center" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields10}">
				<c:set var="logDate" value="${fn:substring(row1.fields10, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields10, 11, 16)}"/>
				<c:choose>
					<c:when test = "${entryTime.time - receiveTime.time > 33*ms}">
						<c:set var="stepClass" value="alertStep"/>
					</c:when>
					<c:otherwise>
						<c:set var="stepClass" value="completedStep"/>
					</c:otherwise>
				</c:choose>
				<span class="<c:out value="${stepClass}" />" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"4") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields11}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<span class="incompletedStep">&nbsp;</span>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Pharmacy<br>Drop Off at PBO" class="w3-center pboList" headerClass="pboList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields12}" >
				<c:set var="logDate" value="${fn:substring(row1.fields12, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields12, 11, 16)}"/>
				<c:choose>
					<c:when test = "${toPBOTime.time - receiveTime.time > 35*ms}">
						<c:set var="stepClass" value="alertStep"/>
					</c:when>
					<c:otherwise>
						<c:set var="stepClass" value="completedStep"/>
					</c:otherwise>
				</c:choose>
				<span class="<c:out value="${stepClass}" />" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"5") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields13}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<span class="incompletedStep">&nbsp;</span>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="PBO<br>Finish Billing" class="w3-center pboList" headerClass="pboList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields14}" >
				<c:set var="logDate" value="${fn:substring(row1.fields14, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields14, 11, 16)}"/>
				<c:choose>
					<c:when test = "${finishBillingTime.time - toPBOTime.time > 20*ms}">
						<c:set var="stepClass" value="alertStep"/>
					</c:when>
					<c:otherwise>
						<c:set var="stepClass" value="completedStep"/>
					</c:otherwise>
				</c:choose>
				<span class="<c:out value="${stepClass}" />" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"6") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields15}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<span class="incompletedStep">&nbsp;</span>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="PBO<br>Payment Settled" class="w3-center pboList" headerClass="pboList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields16}" >
				<c:set var="logDate" value="${fn:substring(row1.fields16, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields16, 11, 16)}"/>
				<c:choose>
					<c:when test = "${paymentSettleTime.time - finishBillingTime.time > 180*ms}">
						<c:set var="stepClass" value="alertStep"/>
					</c:when>
					<c:otherwise>
						<c:set var="stepClass" value="completedStep"/>
					</c:otherwise>
				</c:choose>
				<span class="<c:out value="${stepClass}" />" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"7")>
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields17}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<span class="incompletedStep">&nbsp;</span>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="No Discharge Med" class="w3-center pharList" headerClass="pharList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields18}" >
				<c:set var="logDate" value="${fn:substring(row1.fields18, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields18, 11, 16)}"/>
				<c:choose>
					<c:when test = "${noDischargeTime.time - receiveTime.time > 60*ms}">
						<c:set var="stepClass" value="completedStep"/>
					</c:when>
					<c:otherwise>
						<c:set var="stepClass" value="completedStep"/>
					</c:otherwise>
				</c:choose>
				<span class="<c:out value="${stepClass}" />" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"8") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields19}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<span class="incompletedStep">&nbsp;</span>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Pharmacy<br>Bedside Discharge" class="w3-center pharList" headerClass="pharList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields20}" >
				<c:set var="logDate" value="${fn:substring(row1.fields20, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields20, 11, 16)}"/>
				<c:choose>
					<c:when test = "${rxBedsideTime.time - receiveTime.time > 60*ms}">
						<c:set var="stepClass" value="alertStep"/>
					</c:when>
					<c:otherwise>
						<c:set var="stepClass" value="completedStep"/>
					</c:otherwise>
				</c:choose>
				<span class="<c:out value="${stepClass}" />" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"9") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields21}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<span class="incompletedStep">&nbsp;</span>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Drug picking by patient" class="w3-center pharList" headerClass="pharList" style="width:6.5%;">
		<c:choose>
			<c:when test="${not empty row1.fields22}" >
				<c:set var="logDate" value="${fn:substring(row1.fields22, 0, 10)}"/>
				<c:set var="logTime" value="${fn:substring(row1.fields22, 11, 16)}"/>
				<c:choose>
					<c:when test = "${drugPickTime.time - receiveTime.time > 60*ms}">
						<c:set var="stepClass" value="completedStep"/>
					</c:when>
					<c:otherwise>
						<c:set var="stepClass" value="completedStep"/>
					</c:otherwise>
				</c:choose>
				<span class="<c:out value="${stepClass}" />" onclick=remarkPopup(<c:out value="${row1.fields0}" />,"10") >
					<c:out value='${logTime}'/><c:if test="${not empty row1.fields23}">*</c:if>
				</span>
			</c:when>
			<c:otherwise>
				<span class="incompletedStep">&nbsp;</span>
			</c:otherwise>
		</c:choose>
	</display:column>
</display:table>
<%	} else {%>
	<script>$("#dischargeDate").html("<%=displayDate %>");</script>
	No discharge process planed on <%=displayDate %>.
<% 	} %>
</div>

<!-- Remark -->
<div class="w3-container w3-round-large" id="RemarkPopup">
	<div class="w3-container ah-pink" id="popupHeader">
		<b><font face="AR PL SungtiL GB" size=6 >Process Remark</font></b> - Patient # <span id="remarkPatno"></span>
		<img id="closePopup" src="../images/delete4.png" width="30" height="30" border="0" onclick="document.getElementById('RemarkPopup').style.display = 'none';"></img>
	</div>
	<div class="w3-container" id="remarkContent">
		<textarea name="remark" id="remark" rows="10" cols="50%" maxlength="1000"></textarea>
		<input type="hidden" name="remarkRegid" id="remarkRegid" value="" />
		<input type="hidden" name="remarkStatus" id="remarkStatus" value="" />
<%	if (isPhar) { %>
		<br/><br/>
		<div id="noMedContent">
			No. Of Meds:<input type="text" name="noMed" id="noMed" value="" />
		</div>
<%	} %>
	</div>
	<div class = "leftbuttom">
	<button id="saveButton" class="w3-button ah-pink w3-round-large" onclick="saveRemark()">Save</button>
	<button class="w3-button ah-pink w3-round-large" onclick="document.getElementById('RemarkPopup').style.display = 'none';">Close</button>
	</div>
</div>
</body>
</html>