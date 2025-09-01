<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="javax.servlet.*,java.text.*" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%!
private ArrayList<ReportableListObject> getChemoItem(){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT CHEMO_ITMCODE, CHEMO_PHARCODE, CHEMO_ITMNAME ");
	sqlStr.append("FROM CHEMOITEM@IWEB ");
	sqlStr.append("WHERE ENABLE = 1 ");
	sqlStr.append("ORDER BY CHEMO_ITMNAME ");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList<ReportableListObject> fetchRecord(String searchDate) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT 	C.CHEMO_PKGCODE, T.CHEMO_ID, TO_CHAR(T.START_DATE, 'DD/MM'), C.PATNO, T.CHEMO_ITMCODE, I.CHEMO_ITMNAME, T.DOSE, ");
	sqlStr.append("			TO_CHAR(T.RECEIVE_DATE, 'DD/MM/YYYY HH24:MI'), RECEIVE_REMARK, ");//7
	sqlStr.append("			TO_CHAR(T.PREPARATION_DATE, 'DD/MM/YYYY HH24:MI'), PREPARATION_REMARK, ");//9
	sqlStr.append("			TO_CHAR(T.CHECKING_DATE, 'DD/MM/YYYY HH24:MI'), CHECKING_REMARK, ");//11
	sqlStr.append("			TO_CHAR(T.KARSON_INPUT_DATE, 'DD/MM/YYYY HH24:MI'), KARSON_INPUT_REMARK, ");//13
	sqlStr.append("			TO_CHAR(T.CLEAN_ROOM_DATE, 'DD/MM/YYYY HH24:MI'), CLEAN_ROOM_REMARK, ");//15
	sqlStr.append("			TO_CHAR(T.FINAL_CHECK_DATE, 'DD/MM/YYYY HH24:MI'), FINAL_CHECK_REMARK, ");//17
	sqlStr.append("			TO_CHAR(T.READY_DATE, 'DD/MM/YYYY HH24:MI'), READY_REMARK, ");//19
	sqlStr.append("			TO_CHAR(T.DELIVERY_DATE, 'DD/MM/YYYY HH24:MI'), DELIVERY_REMARK, ");//21
	sqlStr.append("			TO_CHAR(C.COUNSELING_DATE, 'DD/MM/YYYY'), C.HASCOUNSELING, ");//23
	sqlStr.append("			TO_CHAR(C.NEXT_DATE, 'DD/MM/YYYY'), T.CHEMO_STATUS, T.FINAL_CHECK_USER ");//25,26,27
	sqlStr.append("FROM CHEMOTRACK@IWEB C, CHEMOTX@IWEB T, CHEMOITEM@IWEB I ");
	sqlStr.append("WHERE C.CHEMO_PKGCODE = T.CHEMO_PKGCODE ");
	sqlStr.append("AND T.CHEMO_ITMCODE = I.CHEMO_ITMCODE ");
	sqlStr.append("AND T.KARSON_INPUT_DATE IS NOT NULL AND T.DELIVERY_DATE IS NOT NULL ");
	sqlStr.append("AND C.ENABLED = 1 ");
	sqlStr.append("AND TO_CHAR(T.START_DATE, 'DD/MM/YYYY') = '" + searchDate + "' ");
	sqlStr.append("ORDER BY T.START_DATE, C.CHEMO_PKGCODE, T.CHEMO_ID ");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
private ArrayList<ReportableListObject> getPharmacist(){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT CO_STAFF_ID, CO_STAFFNAME ");
	sqlStr.append("FROM CO_STAFFS ");
	sqlStr.append("WHERE CO_DEPARTMENT_CODE = '380' ");
	sqlStr.append("AND CO_POSITION_CODE IN ('P-305','P-137','P-138','P-139','P-195') ");
	sqlStr.append("AND CO_ENABLED = 1 ");
	sqlStr.append("ORDER BY CO_STAFFNAME ");

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
String status_Start = "1";
String status_Receive = "2";
String status_Preparation = "3";
String status_Checking = "4";
String status_KasonInput = "5";
String status_CleanRoom = "6";
String status_FinCheck = "7";
String status_Ready = "8";
String status_Delivery = "9";
String status_Counseling = "10";
UserBean userBean = new UserBean(request);
boolean isPharManager = false;
if (userBean.isLogin() && userBean.isGroupID("pharManager") && !userBean.isAdmin()){
	isPharManager = true;
}

SimpleDateFormat display = new SimpleDateFormat ("dd/MM/yyyy");
SimpleDateFormat updateDate = new SimpleDateFormat ("dd/MM/yyyy HH:mm");
Date today = new Date();
String todayDate = display.format(today);
int ms = 60000; // *ms = *mins eg.5*ms = 5mins

ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
String chemoOption = "";

record = getChemoItem();
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		chemoOption+="<option value='" + row.getValue(0) + "'>["+row.getValue(1)+"] "+row.getValue(2)+"</option> ";
	}
}

String searchDate = request.getParameter("searchDate");
if(searchDate == null || "".equals(searchDate)){
	searchDate = todayDate;
}
ArrayList<ReportableListObject> record2 = fetchRecord(searchDate);
ReportableListObject row2 = null;
int count = record2.size();
request.setAttribute("record_list", record2);

String tempChemoPkgcode = "";
String tempChemoDate = "";
boolean showInfo = true;

Date tmr = new Date();
Date ytd = new Date();
Date sDate = display.parse(searchDate);
tmr = sDate;
tmr.setDate(tmr.getDate() + 1);
String tmrDate = display.format(tmr);
ytd = sDate;
ytd.setDate(ytd.getDate() - 2);
String ytdDate = display.format(ytd);

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
#popupHeader {
	border-bottom: 3px solid #333;
	padding: 8px;
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
.box {
	border: 1px solid #CCC;
}

#title{
	position: absolute;
	bottom: 0;
	width: 100%;
	text-align: center;
}

.completeImg{
	cursor: pointer;
}

table{
	border-spacing: 0px;
}

button{
	margin: 5px;
	border: 1px solid #888;
}

.w3-button{
	border: 2px solid #888;
}

.w3-select{
    padding: 8px 0;
    width: 100%;
}

.rightbuttom{
	position: absolute;
	right: 0;
	bottom: 0;
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

#listTable{
	width: 100%;
	border-collapse: collapse;
	border: 1px black;
	border-bottom-style: dotted;
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
	background-color: #FFFE84;
}

.graybox{
	width:90%;
	height:100%; 
	display:block;
	border: 2px solid #lightgray;
	padding: 8px;
	text-align: center; 
	margin: 2px auto;
	background-color: lightgray;
}

.completedRow{
	background-color: #E6E6E6;
}

.hiddenC{
	position: absolute;
  	left: -999px;
}

.finalColumn{
	background-color: #C4C9FF;
}

#mainList th{
	position: sticky;
    top: 70px;
}

th{
	background-color: white;
}

@keyframes flash
{
0% { 	border-color: #FF0000;}
50% {	border-color: #FFE4E4;}
100% {	border-color: #FF0000;}
}

@keyframes selectFlash
{
0% { 	border-color: #000000;}
50% {	border-color: #DCDCDC;}
100% {	border-color: #000000;}
}

.selectStatus{
	border-color: #000000;
	animation: selectFlash 2s;
	animation-iteration-count: infinite;
}

#disableAll{
	display: none; /* Hidden by default */
	position: absolute; 
	z-index: 5; 
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;	
	background-color: #E1E1E1;
	opacity: 0.9;
}

.selectPage{
	border: 1px solid #771C3C;
	background-color: #FFD2E2;
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

.completedUser{
	width:90%;
	height:100%; 
	display:block;
	background-color: #c0fccc;
	border: 2px solid #64FF53;
	cursor: pointer;
	text-align: center; 
	margin: 2px auto;
	padding:17px 0px 17px 0px;
}

.emptyUser{
	width:90%;
	height:100%; 
	display:block;
	border: 2px solid #64FF53;
	cursor: pointer;
	text-align: center; 
	margin: 2px auto;
	padding:17px 0px 17px 0px;
}
</style>
<script type="text/javascript">

var select_chemopkg, select_chemoid, select_byItem, select_status;
var wait = 30 * 1000; //30s

$(document).ready(function () {
	$("#ChemoHistory").addClass("selectPage");
	$("#searchDate").datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
	    onSelect: function(dateText, inst) {
	    	refreshDateTime();

	    }
    });	
	$("#searchDate").datepicker( "option", "dateFormat", "dd/mm/yy" );
	$("#searchDate").val("<%=searchDate%>");
	
	$("#nextSchedule").datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		minDate: 0
    });
	$("#nextSchedule").datepicker( "option", "dateFormat", "dd/mm/yy" );
	
	$("#counselingDate").datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		minDate: 0
    });
	$("#counselingDate").datepicker( "option", "dateFormat", "dd/mm/yy" );
});

$(document).keypress(function(e) {
	if (e.which == 13) { // 13 = "ENTER"
		//alert("click enter");
	} else {
		if(e.shiftKey){
			/*update date time to whole package*//*
			if((e.key == "t" || e.key == "T")){
				if(select_byItem){
					performActionByItem(select_chemopkg, select_chemoid, select_status);
				}else{
					performAction(select_chemopkg, select_chemoid, select_status);
				}
				
			}
			/*display remark*/
			if((e.key == "p" || e.key == "P")){
				remarkPopup(select_chemopkg, select_chemoid, select_status, false);
			}
		}
	}
});

function refreshDateTime() {
	var searchDate = $("#searchDate").val();
	window.location.href = "/intranet/pharmacy/chemoTrackingHistory.jsp?searchDate=" + searchDate;
}

function updateCompleted(){
	$("#listInfo .cps").each(function() {
		if($(this).context.innerText == "10"){
			$(this).closest("tr").addClass("completedRow");
		}
	});
}

function showPatInfo(){
	$.ajax({
		type: "POST",
		url: "chemoUpdateQueue_ajax.jsp",
		data: "process=getPatInfo&patno=" + $("#patno").val(),
		success: function(values) {
			$("#patName").html(values.trim());
		}
	});//$.ajax
}

function enableCounseling(){
	var allowCounseling = $("#allowCounseling").is(":checked");
	if(allowCounseling){
		$("#counselingDate").datepicker( "option", "disabled", false );
	}else{
		$("#counselingDate").datepicker( "option", "disabled", true );
	}
}

function saveNewChemo(){
	var d = new Date();
	d.setDate(d.getDate() - 1);
	
	var patno = $.trim($("#patno").val());
	if (patno == "" || patno.length == 0){
		alert("Patient Number cannot be empty.");
		$("#patno").focus();
		return;
	}
	var nextSchedule = $.trim($("#nextSchedule").val());
	var selectItem = "";
	var error = false;
	$("#addChemoTable .eachitem")
				.each(
					function() {
						var submitDate = $.trim($(this).find(".submitDate").val());
						var checkDate = $.trim($(this).find(".submitDate").val()).split("/");
						if (new Date(checkDate[2],checkDate[1]-1,checkDate[0]) < d){
							alert("Submit Date Error");
							error = true;
						}
						var submitChemoItem = $.trim($(this).find(".submitChemoItem").val());
						if (submitChemoItem=="" ||submitChemoItem.length==0){
							alert("Chemo Agent Error");
							error = true;
						}
						var submitDur = $.trim($(this).find(".submitDur").val());
						if(submitDur <= 0){
							alert("Duration Error");
							error = true;
						}
						var submitDose = $.trim($(this).find(".submitDose").val());
						
						if (selectItem.length != 0)
							selectItem += "|";
						selectItem += submitDate + ":" + submitChemoItem + ":" + submitDur + ":" + submitDose;
					});
		if(!error){
			$.ajax({
				type: "POST",
				url: "chemoUpdateQueue_ajax.jsp",
				data: "process=submitNewCase&patno=" + patno + "&selectItem=" + selectItem + "&nextSchedule=" + nextSchedule,
				success: function(values) {
					//alert("Chemotherapy Save.");
					closeNewChemo();
					refreshDateTime();
				}
			});//$.ajax
		}else{
			return;
		}
}

function closeNewChemo(){
	$("#newCasePopup").hide();
	$("#patientHistory").hide();
	$(".w3-modal-content").css("margin-right","");
	$("#addChemoTable >tbody").html("");
	$("#newCasePopup input").val("");
	$("#allowCounseling").attr("checked",false);
	$("#pkgRemark").val("");
	$("#patName").html("");
}

function closePatHist(){
	$("#patientHistory").hide();
}

function selectStatus(span, chemopkg, chemoid, updateStatus, byItem){
	select_chemopkg = chemopkg;
	select_chemoid = chemoid;
	select_byItem = byItem;
	select_status = updateStatus;
	$(".chemoProcess").removeClass("selectStatus");
	$("#"+updateStatus+"-"+chemoid).addClass("selectStatus");
}

function unselectStatus(){
	select_chemopkg = "";
	select_chemoid = "";
	select_byItem = false;
	select_status = "";
	$(".chemoProcess").removeClass("selectStatus");
}

function remarkPopup(chemopkg, chemoid, updateStatus, required){
	$.ajax({
		type: "POST",
		url: "chemoUpdateQueue_ajax.jsp",
		data: "process=getRemark&queue=" + updateStatus + "&chemoid=" + chemoid,
		success: function(values) {
			$("#remark").html(values);
		}
	});//$.ajax

	$("#remarkChemoId").val(chemoid);
	$("#remarkStatus").val(updateStatus);
	$("#remarkRequired").val(required);

	if(!required){
		required = false;
		$("#remarkNote").hide();
		$("#closeRemarkButton").show();
		$("#closeRemarkPopup").show();
	}else{
		$("#remarkNote").show();
		$("#disableAll").show();
		$("#closeRemarkButton").hide();
		$("#closeRemarkPopup").hide();
	}
	$("#RemarkPopup").show();
}

function saveRemark(){
	var chemoid = $("#remarkChemoId").val();
	var updateStatus = $("#remarkStatus").val();
	var remark = $("#remark").val();
	var required = $("#remarkRequired").val();
	if (required == "true"){
		if(remark.length==0){
			alert("The process exceed the pledge time, please fill in the remark.");
			return;
		}
	}
	if (remark != null)
		remark= remark.split("'").join("\\'");
	$.ajax({
		type: "POST",
		url: "chemoUpdateQueue_ajax.jsp",
		data: "process=addRemark&queue=" + updateStatus + "&chemoid=" + chemoid + "&remark=" + remark,
		success: function(values) {
			$("#remark").val("");
			closeRemark();
			unselectStatus();
			refreshDateTime();
		}
	});//$.ajax
}

function closeRemark(){
	$("#remarkChemoId").val("");
	$("#remarkStatus").val("");
	$("#remarkRequired").val("");
	$("#remark").val("");
	$("#disableAll").hide();
	$("#RemarkPopup").hide();
}

function showChemoPkgInfo(chemopkg){ 
	$.ajax({
		type: "POST",
		url: "chemoUpdateQueue_ajax.jsp",
		data: "process=getPkgInfo&chemoPkgcode=" + chemopkg + "&canRemove=N&<%=!isPharManager?"canUpdateDose=N":""%>",
		success: function(values) {
			$("#addChemoTable >tbody").html(values.trim());
	<%	if (!isPharManager){%>
			$(".removeitem").attr("disabled","disabled");
			var allowCounseling = $("#allowCounseling").is(":checked");
			var counselingDate = $("#counselingDate").val();
			if(allowCounseling){
				if(counselingDate.length > 0){
					$("#allowCounseling").prop("disabled", true);
					$("#counselingDate").datepicker( "option", "disabled", true);
				}else{
					$("#allowCounseling").prop("disabled", false);
					$("#counselingDate").datepicker( "option", "disabled", false);
				}
			}else{
				$("#allowCounseling").prop("disabled", false);
				$("#counselingDate").datepicker( "option", "disabled", true);
			}
	<%	}else{%>
			enableCounseling();
	<%	}%>
		}
	});//$.ajax
	$("#newCasePopup").show();
	
}

function updateChemo(){
	var d = new Date();
	d.setDate(d.getDate() - 1);
	
	var patno = $.trim($("#patno").val());
	var chemoPkgcode = $.trim($("#chemoPkgcode").val());
	var nextSchedule = $.trim($("#nextSchedule").val());
	var removeItem =  $.trim($("#removeItem").val());
	var allowCounseling = $("#allowCounseling").is(":checked");
	var counselingDate = $.trim($("#counselingDate").val());
	var pkgRemark = $.trim($("#pkgRemark").val());
	var selectItem = "";
	var error = false;
	<%	if (isPharManager){%>
	$("#addChemoTable .exitstingitem")
		.each(
			function() {
				var chemoid = $(this).context.id;
				var submitDose = $.trim($(this).find(".submitDose").val());
				$.ajax({
					type: "POST",
					url: "chemoUpdateQueue_ajax.jsp",
					data: "process=updateChemoDose&chemoid=" + chemoid + "&chemoDose=" + submitDose,
					success: function(values) {
					}
				});//$.ajax
			});
	<%}%>
	$("#addChemoTable .eachitem")
				.each(
					function() {
						var submitDate = $.trim($(this).find(".submitDate").val());
						var checkDate = $.trim($(this).find(".submitDate").val()).split("/");
						if (new Date(checkDate[2],checkDate[1]-1,checkDate[0]) < d){
							error = true;
						}
						var submitChemoItem = $.trim($(this).find(".submitChemoItem").val());
						if (submitChemoItem=="" ||submitChemoItem.length==0){
							error = true;
						}
						var submitDur = $.trim($(this).find(".submitDur").val());
						if(submitDur <= 0){
							error = true;
						}
						var submitDose = $.trim($(this).find(".submitDose").val());
						
						if (selectItem.length != 0)
							selectItem += "|";
						selectItem += submitDate + ":" + submitChemoItem + ":" + submitDur + ":" + submitDose;
					});
		if(!error){
			$.ajax({
				type: "POST",
				url: "chemoUpdateQueue_ajax.jsp",
				data: "process=updateChemoCase"
				+ "&patno=" + patno 
				+ "&chemoPkgcode=" + chemoPkgcode 
				+ "&selectItem=" + selectItem 
				+ "&nextSchedule=" + nextSchedule 
				+ "&removeItem=" + removeItem
				+ "&allowCounseling=" + allowCounseling 
				+ "&counselingDate=" + counselingDate 
				+ "&pkgRemark=" + pkgRemark ,
				success: function(values) {
					//alert("Chemotherapy Updated.");
					closeNewChemo();
					refreshDateTime();
				}
			});//$.ajax
			
		}else{
			alert("New item error. Please check.");
			return;
		}
}

function ChemoProcess(){
	window.open("chemoTracking.jsp", "_blank");
}

function ChemoHistory(){
	window.location.href = "/intranet/pharmacy/chemoTrackingHistory.jsp";
}

function PredictCalendar(){
	window.open("chemoTrackingPredict.jsp", "_blank");
}

function getPastHistoryByPatient(patno,chemoPkgcode){
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
			$("#appendButton").hide();
			
		}
	});//$.ajax
}

function changeDate(s){
	var nextDay;
	if(s == "+"){
		nextDay = $("#tmrDate").val();
	}else if (s == "-"){
		nextDay = $("#ytdDate").val();
	}
	window.location.href = "/intranet/pharmacy/chemoTrackingHistory.jsp?searchDate=" + nextDay;
}
</script>
</head>
<body>
<div id="Header" class="w3-display-container ah-pink">
	<div class="leftbuttom w3-container">
		
	</div>
	<div class="w3-container w3-center">
		<input type="hidden" name="ytdDate" id="ytdDate" value="<%=ytdDate %>" />
		<img class="" src="../images/arrow-left.png" width="25" height="25" border="0" onclick="changeDate('-');"></img>
		<input type="text" name="searchDate" id="searchDate" class="ah-pink w3-center w3-border-0" maxlength="10" size="10">
		<img class="" src="../images/arrow-right.png" width="25" height="25" border="0" onclick="changeDate('+');"></img>
		<input type="hidden" name="tmrDate" id="tmrDate" value="<%=tmrDate %>" />
		<br/>
		<span class="w3-xlarge"><b>Chemotherapy Process History</b></span>
	</div>
	<div class="w3-container w3-small ah-pink w3-right w3-display-bottomright">
		Last Update Date/Time: <%=updateDate.format(today) %>
	</div>
</div>

<div id="disableAll">
</div>

<!-- index page -->
<div class="w3-container" onclick=''>
	<table class="w3-small">
		<thead>
			<tr>
				<th style="width:5%">Date</th>
				<th style="width:5%">Patient#</th>
				<th style="width:12%">Item Code</th>
				<th style="width:12%">Regimen</th>
				<th style="width:6%">Receive Confirmation</th>
				<th style="width:6%">Materials Preparation Finish</th>
				<th style="width:6%">Materials Checking Finish</th>
				<th style="width:6%">KARSON input completed</th>
				<th style="width:6%" class="finalColumn">Entered into Clean Room</th>
				<th style="width:6%">Fin. Vol Checking</th>
				<th style="width:6%">Fin. Vol Checked By</th>
				<th style="width:6%" class="finalColumn">Fin. Product Ready to send out</th>
				<th style="width:6%" class="finalColumn">Fin. Product Delivery Completed</th>
				<th style="width:6%">1st Dose Chemo Counseling</th>
				<th style="width:6%">Next Schedule Date</th>
			</tr>
<%	if (isPharManager){%>			
			<tr>
				<th colspan="5">&nbsp;</th>
				<th>(20mins)</th>
				<th>(20mins)</th>
				<th>(25mins)</th>
				<th class="finalColumn" >(25mins)</th>
				<th>(30mins)</th>
				<th>&nbsp;</th>
				<th class="finalColumn" >(30mins)</th>
				<th class="finalColumn" >(5mins)</th>
				<th colspan="2">&nbsp;</th>
			</tr>
<%	} %>
		</thead>
		<tbody id="listInfo">
<%
if (count > 0) { 
	for(int i=0; i<count; i++){
		row = (ReportableListObject) record2.get(i);
		String vChemoPkgcode = row.getValue(0);
		String vChemoId = row.getValue(1);
		String vStartDate = row.getValue(2);
		String vPatno = row.getValue(3);
		String vChemoItmcode = row.getValue(4);
		String vChemoItmname = row.getValue(5);
		String vDose = row.getValue(6);
		String vReceiveDate = row.getValue(7);
		String vReceiveRemark = row.getValue(8);
		String vPreparationDate = row.getValue(9);
		String vPreparationRemark = row.getValue(10);
		String vCheckingDate = row.getValue(11);
		String vCheckingRemark = row.getValue(12);
		String vKasonInputDate = row.getValue(13);
		String vKasonInputRemark = row.getValue(14);
		String vCleanRoomDate = row.getValue(15);
		String vCleanRoomRemark = row.getValue(16);
		String vFinCheckDate = row.getValue(17);
		String vFinCheckRemark = row.getValue(18);
		String vReadyDate = row.getValue(19);
		String vReadyRemark = row.getValue(20);
		String vDeliveryDate = row.getValue(21);
		String vDeliveryRemark = row.getValue(22);
		String vCounselingDate = row.getValue(23);
		String vHasCounseling = row.getValue(24);
		String vNextDate = row.getValue(25);
		String vStatus = row.getValue(26);
		String vFinCheckUser = row.getValue(27);
		
		Date dReceiveDate = updateDate.parse(vReceiveDate);
		Date dPreparationDate = updateDate.parse(vPreparationDate);
		Date dCheckingDate = updateDate.parse(vCheckingDate);
		Date dKasonInputDate = updateDate.parse(vKasonInputDate);
		Date dCleanRoomDate = updateDate.parse(vCleanRoomDate);
		Date dFinCheckDate = updateDate.parse(vFinCheckDate);
		Date dReadyDate = updateDate.parse(vReadyDate);
		Date dDeliveryDate = updateDate.parse(vDeliveryDate);
		//Date dCounselingDate = updateDate.parse(vCounselingDate);
		
		if (tempChemoPkgcode != null && tempChemoPkgcode.equals(vChemoPkgcode) && 
				tempChemoDate != null && tempChemoDate.equals(vStartDate)){
			showInfo = false;
		}else{
			showInfo = true;
			tempChemoPkgcode = vChemoPkgcode;
			tempChemoDate = vStartDate;
		}
%>
		<tr>
		
<%
		if(showInfo){
%>
			<td><%=vStartDate %></td>
			<td><span class="listPatno" ondblclick="showChemoPkgInfo('<%=vChemoPkgcode %>')" style="cursor: pointer;"><%=vPatno %></span></td>
<%		}else{ 
%>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
<%		}
%>
			<td><%=vChemoItmname %></td>
			<td><%=vDose %></td>
			<td>
<%		if(vReceiveDate == null || vReceiveDate.length()<=0){ %>
			<span id="<%=status_Receive %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this, '<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Receive %>', false)" >&nbsp;</span>
<%		} else { 
%>		
			<span id="<%=status_Receive %>-<%=vChemoId %>" class="chemoProcess completedStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Receive %>', false)" onclick="selectStatus(this, '<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Receive %>', false)" >
				<%=vReceiveDate %>
				<% if(vReceiveRemark == null || vReceiveRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
			
<%		} %>
			</td>
			<td>
<%		if(vPreparationDate == null || vPreparationDate.length()<=0){
%>
			<span id="<%=status_Preparation %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this, '<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Preparation %>', false)" >&nbsp;</span>
<%		
		} else { 
			if((dPreparationDate.getTime() - dReceiveDate.getTime()) < 20*ms){
%>
			<span id="<%=status_Preparation %>-<%=vChemoId %>" class="chemoProcess completedStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Preparation %>', false)" onclick="selectStatus(this, '<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Preparation %>', true)" >
				<%=vPreparationDate %>
				<% if(vPreparationRemark == null || vPreparationRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%			
			}else{

%>		
			<span id="<%=status_Preparation %>-<%=vChemoId %>" class="chemoProcess alertStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Preparation %>', false)" onclick="selectStatus(this, '<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Preparation %>', true)" >
				<%=vPreparationDate %>
				<% if(vPreparationRemark == null || vPreparationRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%			}
		} %>
			</td>
			<td>
<%		if(vCheckingDate == null || vCheckingDate.length()<=0){ 
%>
			<span id="<%=status_Checking %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Checking %>', false)" >&nbsp;</span>
<%		
		} else { 
			if((dCheckingDate.getTime() - dReceiveDate.getTime()) < 20*ms){
%>		
			<span id="<%=status_Checking %>-<%=vChemoId %>" class="chemoProcess completedStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Checking %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Checking %>', true)" >
				<%=vCheckingDate %>
				<% if(vCheckingRemark == null || vCheckingRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%		
			}else{
%>
			<span id="<%=status_Checking %>-<%=vChemoId %>" class="chemoProcess alertStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Checking %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Checking %>', true)" >
				<%=vCheckingDate %>
				<% if(vCheckingRemark == null || vCheckingRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%
			}
		} %>
			</td>
			<td>
<%		if(vKasonInputDate == null || vKasonInputDate.length()<=0){ 
%>
			<span id="<%=status_KasonInput %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_KasonInput %>', false)" >&nbsp;</span>
<%		
		} else { 
			if((dKasonInputDate.getTime() - dReceiveDate.getTime()) < 25*ms){
%>		
			<span id="<%=status_KasonInput %>-<%=vChemoId %>" class="chemoProcess completedStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_KasonInput %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_KasonInput %>', true)" >
				<%=vKasonInputDate %>
				<% if(vKasonInputRemark == null || vKasonInputRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%			
			}else{
%>
			<span id="<%=status_KasonInput %>-<%=vChemoId %>" class="chemoProcess alertStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_KasonInput %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_KasonInput %>', true)" >
				<%=vKasonInputDate %>
				<% if(vKasonInputRemark == null || vKasonInputRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%
			}
		} %>
			</td>
			<td class="finalColumn">
<%		if(vCleanRoomDate == null || vCleanRoomDate.length()<=0){ 
%>
			<span id="<%=status_CleanRoom %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_CleanRoom %>', false)" >&nbsp;</span>
<%		
		} else {
			if((dCleanRoomDate.getTime() - dReceiveDate.getTime()) < 25*ms){
%>		
			<span id="<%=status_CleanRoom %>-<%=vChemoId %>" class="chemoProcess completedStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_CleanRoom %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_CleanRoom %>', true)" >
				<%=vCleanRoomDate %>
				<% if(vCleanRoomRemark == null || vCleanRoomRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%			}else{
%>
			<span id="<%=status_CleanRoom %>-<%=vChemoId %>" class="chemoProcess alertStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_CleanRoom %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_CleanRoom %>', true)" >
				<%=vCleanRoomDate %>
				<% if(vCleanRoomRemark == null || vCleanRoomRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%
			}
		} %>
			</td>
			<td>
<%		if(vFinCheckDate == null || vFinCheckDate.length()<=0){ 
%>
			<span id="<%=status_FinCheck %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_FinCheck %>', true)" >&nbsp;</span>
<%		
		} else { 
			if(dFinCheckDate.getTime() - dCleanRoomDate.getTime() < 30*ms){
%>		
			<span id="<%=status_FinCheck %>-<%=vChemoId %>" class="chemoProcess completedStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_FinCheck %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_FinCheck %>', true)" >
				<%=vFinCheckDate %>
				<% if(vFinCheckRemark == null || vFinCheckRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%			}else{
%>
			<span id="<%=status_FinCheck %>-<%=vChemoId %>" class="chemoProcess alertStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_FinCheck %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_FinCheck %>', true)" >
				<%=vFinCheckDate %>
				<% if(vFinCheckRemark == null || vFinCheckRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%
			}
		}%>
			</td>
			<td>
				<select class="<%if(vFinCheckUser == null || vFinCheckUser.length()<=0){%>emptyUser<%}else{ %>completedUser<%} %>" 
						id="finCheckUserID" name="finCheckUserID" onchange="updateCheckUser('<%=vChemoId %>')" 
						<%	if (vFinCheckUser.length()>0 && !isPharManager){%>disabled<%} %>>
					<option value=""></option>
					<%
					ArrayList<ReportableListObject> record1 = getPharmacist();
					ReportableListObject row1 = null;
					if (record1.size() > 0) {
						for (int j = 0; j < record1.size(); j++) {
							row1 = (ReportableListObject) record1.get(j);
					%>
							<option value='<%=row1.getValue(0)%>' 
							<%if(vFinCheckUser.equals(row1.getValue(0))){%>selected<%} %>> 
							<%=row1.getValue(1)%></option> 
					<%
						}
					}
					%>
				</select>
			</td>
			<td class="finalColumn">
<%		if(vReadyDate == null || vReadyDate.length()<=0){ 
%>
			<span id="<%=status_Ready %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Ready %>', true)" >&nbsp;</span>
<%		
		} else { 
			if(dFinCheckDate.getTime() - dCleanRoomDate.getTime() < 30*ms){
%>		
			<span id="<%=status_Ready %>-<%=vChemoId %>" class="chemoProcess completedStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Ready %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Ready %>', true)" >
				<%=vReadyDate %>
				<% if(vReadyRemark == null || vReadyRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%			}else{
%>
			<span id="<%=status_Ready %>-<%=vChemoId %>" class="chemoProcess alertStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Ready %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Ready %>', true)" >
				<%=vReadyDate %>
				<% if(vReadyRemark == null || vReadyRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%	
			}
		} %>
			</td>
			<td class="finalColumn">
<%		if(vDeliveryDate == null || vDeliveryDate.length()<=0){ 
%>
			<span id="<%=status_Delivery %>-<%=vChemoId %>" class="chemoProcess incompletedStep" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Delivery %>', true)" >&nbsp;</span>
<%		
		} else { 
			if(dDeliveryDate.getTime() - dReadyDate.getTime() < 5*ms){
%>		
			<span id="<%=status_Delivery %>-<%=vChemoId %>" class="chemoProcess completedStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Delivery %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Delivery %>', true)" >
				<%=vDeliveryDate %>
				<% if(vDeliveryRemark == null || vDeliveryRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%			}else{
%>
			<span id="<%=status_Delivery %>-<%=vChemoId %>" class="chemoProcess alertStep" ondblclick="remarkPopup('<%=vChemoPkgcode %>', '<%=vChemoId %>', '<%=status_Delivery %>', false)" onclick="selectStatus(this,'<%=vChemoPkgcode %>', '<%=vChemoId %>','<%=status_Delivery %>', true)" >
				<%=vDeliveryDate %>
				<% if(vDeliveryRemark == null || vDeliveryRemark.length()<=0){} else { %><span class="w3-text-red">*</span><%} %>
			</span>
<%
			}
		}%>
			</td>
			<td>
<%		if("Y".equals(vHasCounseling)){ 
			if(vCounselingDate == null || vCounselingDate.length()<=0){%>
			<span id="<%=status_Counseling %>-<%=vChemoId %>" class="chemoProcess">
				&nbsp;
			</span>
<%			}else{ %>			
			<span id="<%=status_Counseling %>-<%=vChemoId %>" class="chemoProcess incompletedStep">
				<%=vCounselingDate %>
			</span>
<%			}
		} else { %>		
			<span id="<%=status_Counseling %>-<%=vChemoId %>" class="chemoProcess graybox">
				&nbsp;
			</span>
<%		} %>
			</td>
<%
		if(showInfo){
%>
			<td><%=vNextDate %></td>
<%		}else{ 
%>
			<td>&nbsp;</td>
<%		}
%>
		<td class="hiddenC cps"><%=vStatus %></td>
		</tr>		
<%		
	}
}
%>
		</tbody>
	</table>
	<br/><br/><br/>
</div>

<div class="w3-container" id="Footer">
	<div class="w3-cell-row">
		<div class="w3-container w3-col" style="width:55%;" >&nbsp;</div>
		<div class="w3-container w3-col w3-btn pageButton" style="width:15%" onclick="ChemoProcess()" id="ChemoProcess">Chemotherapy Process</div>
		<div class="w3-container w3-col w3-btn pageButton" style="width:15%" onclick="ChemoHistory()" id="ChemoHistory">Past History</div>
		<div class="w3-container w3-col w3-btn pageButton" style="width:15%" onclick="PredictCalendar()" id="PredictCalendar">Predicted Chemotherapy</div>
  	</div>
</div>

<!-- Remark -->
<div id="RemarkPopup" class="w3-modal">
 	<div class="w3-modal-content">
    	<header class="w3-container ah-pink">
			<span id="closeRemarkPopup" onclick="closeRemark()" class="w3-button w3-display-topright">&times;</span>
			<b><font face="AR PL SungtiL GB" size=6 >Process Remark</font></b><div id="remarkNote"> (REQUIRED)</div>
		</header>

		<div class="w3-container">
			<br/>
			<textarea name="remark" id="remark" rows="4" cols="35" maxlength="1000"></textarea>
			<input type="hidden" name="remarkChemoId" id="remarkChemoId" value="" />
			<input type="hidden" name="remarkStatus" id="remarkStatus" value="" />
			<br/><br/><br/>
		</div>
		<footer class="w3-container ah-pink">
			<button id="closeRemarkButton" class="w3-button ah-pink w3-round-large button" onclick="closeRemark()">Close</button>
			<button id="saveRemarkButton" class="w3-button ah-pink w3-round-large w3-display-bottomright button" onclick="saveRemark()">Save</button>
		</footer>
  </div>
</div>

<!-- New Case Trigger -->
<div id="newCasePopup" class="w3-modal">
 	<div class="w3-modal-content">
    	<header class="w3-container ah-pink">
			<span id="closePopup" onclick="closeNewChemo()" class="w3-button w3-display-topright">&times;</span>
			<b><font face="AR PL SungtiL GB" size=6 >
				<span id="updateCaseTitle">Update Case</span>
			</font></b>
		</header>
		<div class="w3-container w3-display-container" id="newChemoList" style="width:100%">
			<br/>
			Patient No. <input type="text" name="patno" id="patno" value="" onkeyup="showPatInfo()"/><br/>
			Patient Name: <span id="patName"></span>
			<br/><br/>
			<table id="addChemoTable" style="width:100%">
				<thead>
					<tr>
						<th style="width:15%">Date</th>
						<th style="width:45%">Chemo Agent</th>
						<th style="width:10%">Duration (Days)</th>
						<th style="width:25%">Regimen</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
			<br/>
			<table width="100%">
				<tr>
					<td>Next Schedule</td>
					<td><input type="text" name="nextSchedule" id="nextSchedule" value="" /></td>
				</tr>
				<tr>
					<td>1st Dose Chemo Counseling Date</td>
					<td>
						<input type="checkbox" name="allowCounseling" id="allowCounseling" value="" onclick="enableCounseling()"/>
						<input type="text" name="counselingDate" id="counselingDate" value=""/>
					</td>
				</tr>
				<tr><td colspan=2>&nbsp;</td></tr>
				<tr>
					<td colspan=2>
						Remark <br/><textarea name="pkgRemark" id="pkgRemark" rows="4" cols="35" maxlength="1000"></textarea>
					</td>
				</tr>
			</table>
			<input type="hidden" name="removeItem" id="removeItem" value="" />
			<input type="hidden" name="chemoPkgcode" id="chemoPkgcode" value="" />
			<br/><br/><br/>
			<button id="pastHistButton" class="w3-button w3-round-large button w3-display-topright" onclick="getPastHistoryByPatient($('#patno').val(),'')">Past History</button>
		</div>
		
		<footer class="w3-container ah-pink">
			<button id="closeButton" class="w3-button ah-pink w3-round-large button" onclick="closeNewChemo()">Close</button>
			<button id="updateButton" class="w3-button ah-pink w3-round-large w3-display-bottomright button" onclick="updateChemo()">Update</button>
		</footer>
  </div>
</div>

<div class="w3-modal" id="patientHistory">
</div>


</body>
</html>