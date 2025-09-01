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

%>
<%
UserBean userBean = new UserBean(request);

boolean isPharManager = false;
if (userBean.isLogin() && userBean.isGroupID("pharManager") && !userBean.isAdmin()){
	isPharManager = true;
}

SimpleDateFormat ft = new SimpleDateFormat ("MM/dd/yyyy");
SimpleDateFormat display = new SimpleDateFormat ("dd/MM/yyyy");
Date today = new Date();
Date tmr = new Date();
Date ytd = new Date();
String todayDate = display.format(today);



String searchDate = request.getParameter("searchDate");
if(searchDate == null || "".equals(searchDate)){
	searchDate = todayDate;
}

ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
String chemoOption = "";

record = getChemoItem();
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		chemoOption+="<option value='" + row.getValue(0) + "'> "+row.getValue(2)+"</option> ";
	}
}
/*
Calendar calendar = Calendar.getInstance();
String currentDate = DateTimeUtil.formatDate(calendar.getTime());
String selectYear = request.getParameter("select_year");
String selectMonth = request.getParameter("select_month");
if (selectYear != null){
	calendar.set(Calendar.YEAR, Integer.parseInt(selectYear));
}
if (selectMonth != null) {
	calendar.set(Calendar.MONTH, Integer.parseInt(selectMonth));
}
String calendarDate = DateTimeUtil.formatDate(calendar.getTime());
System.out.println("currentDate:" + currentDate);

calendar.add(Calendar.DAY_OF_YEAR, 1);
Date tomorrow = calendar.getTime();
String tmrDate = DateTimeUtil.formatDate(calendar.getTime());
System.out.println("tmrDate:" + tmrDate);
*/
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="shortcut icon" href="../images/chemo-icon.ico" type="image/x-icon" />
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
	top: 0; 
	border-bottom: 3px solid #333;
	z-index: 1;
	left: 0;
	right: 0;
	height: 70px;
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

.w3-select{
    padding: 8px 0;
    width: 100%;
}

.righttop{
	position: absolute;
	right: 0;
	top: 0;
	margin: 8px;
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
	border: 2px solid red;
	padding: 8px;
	text-align: center; 
	margin: 2px auto;
	animation: flash 2s;
	animation-iteration-count: infinite;
	background-color: white;
}

.completedLateStep{
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

#ChemoHistList{
	border: 5px solid #A86868;
	border-collapse: collapse;
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

var select_chemopkg, select_chemoid, select_byItem, select_status, action;
var wait = 30 * 1000; //30s

$(document).ready(function () {
	$("#ChemoProcess").addClass("selectPage");
	$("#searchDate").datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		//minDate: -10,
	    onSelect: function(dateText, inst) {
	    	timer(true);

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
	timer(true);
});

$(document).keypress(function(e) {
	if (e.which == 13) { // 13 = "ENTER"
		//alert("click enter");
	} else {
		if(e.shiftKey){
			/*update date time to whole package*/
			if((e.key == "t" || e.key == "T")){
				/*alert(
					    "Key Pressed: " + e.key + "\n"
					    + "key pressed: " + e.which + "\n"
					    + "SHIFT key pressed: " + e.shiftKey + "\n"
					  );*/
				if(select_byItem){
					performActionByItem(select_chemopkg, select_chemoid, select_status);
				}else{
					performAction(select_chemopkg, select_chemoid, select_status);
				}
				
			}
			
			/*reverse action*/
			if((e.key == "u" || e.key == "U")){
				reverseAction(select_chemopkg, select_chemoid, select_status);
			}
			
			/*display remark*/
			/*if((e.key == "p" || e.key == "P")){
				remarkPopup(select_chemopkg, select_chemoid, select_status, false);
			}*/
		}
	}
});

function timer(refreshOnly) {
	var searchDate = $("#searchDate").val();

	$.ajax({
		type: "POST",
		url: "chemoTracking_ajax.jsp",
		data: "searchDate=" + $("#searchDate").val(),
		success: function(values) {
			if (values != "") {
				$("#listInfo").html(values);
				window.setTimeout("timer(true)", wait);
				if(!refreshOnly){
					window.setTimeout("timer(false)", wait);
				}
			} else {
				if(table != 0){
					timer(refreshOnly);
				}else{
					$("#listInfo").html("");
					
					if(!refreshOnly){
						window.setTimeout("timer(false)", wait);	
					}
						
				}
			}//if
		}//success
	});//$.ajax
}

function updateCompleted(){
	$("#listInfo .cps").each(function() {
		if($(this).context.innerText == "10"){
			$(this).closest("tr").addClass("completedRow");
		}
	});
}

function showNewTrigger(){
	action = "new";
	closeRemark();
	closeNewChemo();
	addNewChemo();
	$("#newCasePopup").show();
	$("#updateCaseTitle").hide();
	$("#updateButton").hide();
	$("#startCaseTitle").show();
	$("#saveButton").show();
	$("#cancelButton").hide();
	$("#pastHistButton").hide();
	$("#allowCounseling").prop("disabled", false);
	$("#counselingDate").datepicker( "option", "disabled", true );
	$("#patno").attr("readonly", false);
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

function addNewChemo(){
	var chemoCount = $("table#addChemoTable >tbody >tr").length+1;
	if(chemoCount == 11){
		alert("Error occur. New chemotherapy tracking cannot add more than 10 items.");
	}else {
		$("#addChemoTable")
			.find("tbody")
				.append($("<tr class='eachitem' id='"+ chemoCount +"'>")
				.append($("<td class='w3-center'>").append("<button class='removeitem' onclick='removeItem(this)'>X</button>"))
				.append($("<td>").append("<input type='text' name='startdate"+chemoCount+"' id='startdate"+chemoCount+"' class='w3-input w3-border startChemoDate submitDate' value='' maxlength='10' size='10' onkeyup='validDate(this)' onblur='validDate(this)'>"))
				.append($("<td>").append("<select name='chemo"+chemoCount+"' id='chemo"+chemoCount+"' class='w3-select w3-border submitChemoItem'><option value=''></option><%=chemoOption %></select>"))
				.append($("<td>").append("<input type='number' name='dur"+chemoCount+"' id='dur"+chemoCount+"' class='w3-input w3-border submitDur' min=1 max=9 value='1'/>"))
				.append($("<td>").append("<input type='text' name='dose"+chemoCount+"' id='dose"+chemoCount+"' class='w3-input w3-border submitDose'/>")));
	}
	$(".startChemoDate").datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		minDate: 0,
		defaultDate: new Date(),
		beforeShow: function(input, inst) {
	      	$("#ui-datepicker-div").removeClass(function() {
	           	return $("input").get(0).id; 
	       	});
	       	$("#ui-datepicker-div").addClass(this.id);
	   }
	});
	$(".startChemoDate").datepicker( "option", "dateFormat", "dd/mm/yy" );
	$("#startdate"+chemoCount).val("<%=todayDate %>");
	
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
	var patname = $.trim($("#patName").html());
	if (patno == "" || patno.length == 0){
		alert("Patient Number cannot be empty.");
		$("#patno").focus();
		return;
	}
	if (patname == "" || patname.length == 0){
		alert("Patient cannot be found.");
		$("#patno").focus();
		return;
	}
	
	var nextSchedule = $.trim($("#nextSchedule").val());
	var allowCounseling = $("#allowCounseling").is(":checked");
	var counselingDate = $.trim($("#counselingDate").val());
	var pkgRemark = $.trim($("#pkgRemark").val());
	var selectItem = "";
	var error = false;
	$("#addChemoTable .eachitem")
				.each(
					function() {
						var submitDate = $.trim($(this).find(".submitDate").val());
						if (submitDate=="" ||submitDate==0){
							//alert("Submit Date Error");
							error = true;
						}
						var checkDate = $.trim($(this).find(".submitDate").val()).split("/");
						if (new Date(checkDate[2],checkDate[1]-1,checkDate[0]) < d){
							//alert("Submit Date Error");
							error = true;
						}
						var submitChemoItem = $.trim($(this).find(".submitChemoItem").val());
						if (submitChemoItem=="" ||submitChemoItem.length==0){
							//alert("Chemo Agent Error");
							error = true;
						}
						var submitDur = $.trim($(this).find(".submitDur").val());
						if(submitDur <= 0 || submitDur > 9){
							//alert("Duration Error");
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
				data: "process=submitNewCase&patno=" + patno 
						+ "&selectItem=" + selectItem 
						+ "&nextSchedule=" + nextSchedule 
						+ "&allowCounseling=" + allowCounseling 
						+ "&counselingDate=" + counselingDate 
						+ "&pkgRemark=" + pkgRemark ,
				success: function(values) {
					closeNewChemo();
					timer(true);
				}
			});//$.ajax
			
		}else{
			alert("Submit Error");
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

function removeItem(row) {
	var chemoCount = $("table#addChemoTable >tbody >tr").length;
	if(chemoCount == 1){
		alert("Error occur. New chemotherapy tracking must include at least one item.");
	}else {
		var chemoclass = row.parentNode.parentNode.className;
		if(chemoclass.indexOf("exitstingitem") > -1){
			var chemoid = row.parentNode.parentNode.id;
			if($("#removeItem").val().length > 0){
				$("#removeItem").val($("#removeItem").val() + "," + chemoid);
			}else{
				$("#removeItem").val(chemoid);
			}
		}
		var i = row.parentNode.parentNode.rowIndex;
		document.getElementById("addChemoTable").deleteRow(i);
	}
}

function selectStatus(span, chemopkg, chemoid, updateStatus, byItem){
	select_chemopkg = chemopkg;
	select_chemoid = chemoid;
	select_byItem = byItem;
	select_status = updateStatus;
	$(".chemoProcess").removeClass("selectStatus");
	$("#"+updateStatus+"-"+chemoid).addClass("selectStatus");
	window.setTimeout("timer(true)", wait);
}

function unselectStatus(){
	select_chemopkg = "";
	select_chemoid = "";
	select_byItem = false;
	select_status = "";
	$(".chemoProcess").removeClass("selectStatus");
}

function performAction(chemopkg, chemoid, updateStatus){
	$.ajax({
		type: "POST",
		url: "chemoUpdateQueue_ajax.jsp",
		data: "process=updateStatus&queue=" + updateStatus + "&chemoPkgcode=" + chemopkg,
		success: function(values) {
			unselectStatus();
			timer(true);
		}
	});//$.ajax
}

function performActionByItem(chemopkg, chemoid, updateStatus){
	$.ajax({
		type: "POST",
		url: "chemoUpdateQueue_ajax.jsp",
		data: "process=updateStatusByItem&queue=" + updateStatus + "&chemoid=" + chemoid,
		success: function(values) {
			unselectStatus();
			timer(true);
		}
	});//$.ajax
}

function reverseAction(chemopkg, chemoid, updateStatus){
	var d = new Date();
	var selectDate = $.trim($("#"+updateStatus+"-"+chemoid).html()).split(" ");
	var checkDate = selectDate[0].split("/");
	if (new Date(checkDate[2],checkDate[1]-1,checkDate[0], "23", "59", "59") < d){
		unselectStatus();
		alert("Cannot update the past history.");
	}else{
		$.ajax({
			type: "POST",
			url: "chemoUpdateQueue_ajax.jsp",
			data: "process=reverseStatus&queue=" + updateStatus + "&chemoid=" + chemoid,
			success: function(values) {
				unselectStatus();
				timer(true);
				closeRemark();
			}
		});//$.ajax
	}
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
		$("closeRemarkButton").show();
		$("closeRemarkPopup").show();
	}else{
		$("#remarkNote").show();
		$("#disableAll").show();
		$("closeRemarkButton").hide();
		$("closeRemarkPopup").hide();
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
			timer(true);
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
	action = "update";
	$.ajax({
		type: "POST",
		url: "chemoUpdateQueue_ajax.jsp",
		data: "process=getPkgInfo&chemoPkgcode=" + chemopkg,
		success: function(values) {
			$("#addChemoTable >tbody").html(values.trim());
			<%	if (!isPharManager){%>
					$(".completedRow").find(".submitDose").prop("disabled", true);
					$("#addChemoTable .completedRow")
						.each(
							function() {
								var startDate = $.trim($(this).find(".startDate").html());
								if(startDate == "<%=todayDate %>"){
									$(this).find(".submitDose").prop("disabled", false);
								}
							});
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
					$("#cancelButton").hide();
			<% 	}else{%>
					$(".completedRow").find(".removeitem").prop("disabled", true);
					$("#cancelButton").show();
			<%	}%>
		}
	});//$.ajax.
	$("#newCasePopup").show();
	$("#updateCaseTitle").show();
	$("#updateButton").show();
	$("#startCaseTitle").hide();
	$("#saveButton").hide();
	$("#pastHistButton").show();
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
					timer(true);
				}
			});//$.ajax
		}else{
			alert("Update item error. Please check.");
			return;
		}
}

function cancelChemo(){
	var patno = $.trim($("#patno").val());
	var chemoPkgcode = $.trim($("#chemoPkgcode").val());
	var pkgRemark = $.trim($("#pkgRemark").val());
	var error = false;
	
	if(pkgRemark.length <= 0){
		alert("Please fill in the remark before cancel the case.");
		error = true;
		return;
	}
	
	if(!error){
		var sure = confirm("All process will be deleted. \nAre you sure to cancel case?");
		if(sure == true){
			$.ajax({
				type: "POST",
				url: "chemoUpdateQueue_ajax.jsp",
				data: "process=cancelChemoCase"
				+ "&patno=" + patno 
				+ "&chemoPkgcode=" + chemoPkgcode 
				+ "&pkgRemark=" + pkgRemark ,
				success: function(values) {
					//alert("Chemotherapy Updated.");
					closeNewChemo();
					timer(true);
				}
			});//$.ajax
		}
	}else{
		alert("Update item error. Please check.");
		return;
	}
}

function ChemoProcess(){
	window.location.href = "/intranet/pharmacy/chemoTracking.jsp";
}

function ChemoHistory(){
	window.open("chemoTrackingHistory.jsp?searchDate=" + $("#searchDate").val(), "_blank");
}

function PredictCalendar(){
	window.open("chemoTrackingPredict.jsp", "_new");
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

function appendToNewCase(chemoPkgcode){
	$.ajax({
		type: "POST",
		url: "chemoUpdateQueue_ajax.jsp",
		data: "process=appendToNewCase&chemoPkgcode=" + chemoPkgcode,
		success: function(values) {
			$("#addChemoTable >tbody").append(values.trim());
			$(".startChemoDate").datepicker({
				showOtherMonths: true,
				selectOtherMonths: true,
				changeMonth: true,
				changeYear: true,
				minDate: 0,
				defaultDate: new Date(),
				beforeShow: function(input, inst) {
			      	$("#ui-datepicker-div").removeClass(function() {
			           	return $("input").get(0).id; 
			       	});
			       	$("#ui-datepicker-div").addClass(this.id);
			   }
			});
			$(".startChemoDate").datepicker( "option", "dateFormat", "dd/mm/yy" );
			
		}
	});//$.ajax
}

function closePatHist(){
	$("#patientHistory").hide();
}

function changeDate(s){
	var nextDay;
	if(s == "+"){
		nextDay = $("#tmrDate").val();
	}else if (s == "-"){
		nextDay = $("#ytdDate").val();
	}
	window.location.href = "/intranet/pharmacy/chemoTracking.jsp?searchDate=" + nextDay;
}

function updateCheckUser(chemoid){
	var finCheckUserID = $("#finCheckUserID").val();

	$.ajax({
		type: "POST",
		url: "chemoUpdateQueue_ajax.jsp",
		data: "process=updateCheckUser&chemoid=" + chemoid + "&finCheckUserID=" + finCheckUserID,
		success: function(values) {
			timer(true);
		}
	});//$.ajax
}
</script>
</head>
<body>
<div id="Header" class="w3-container w3-display-container ah-pink">
	<div class="leftbuttom w3-container">
		<button id="newButton" class="w3-button w3-round-large button" onclick="showNewTrigger()">New</button>
	</div>
	<div class="w3-container w3-center">
		<input type="hidden" name="ytdDate" id="ytdDate" value="" />
		<img class="" src="../images/arrow-left.png" width="25" height="25" border="0" onclick="changeDate('-');"></img>
		<input type="text" name="searchDate" id="searchDate" class="ah-pink w3-center w3-border-0" maxlength="10" size="10">
		<img class="" src="../images/arrow-right.png" width="25" height="25" border="0" onclick="changeDate('+');"></img>
		<input type="hidden" name="tmrDate" id="tmrDate" value="" />
		<br/>
		<span class="w3-xlarge"><b>Chemotherapy Process</b></span>
	</div>
	<div class="righttop w3-container w3-tiny">
		Shift + 'T' : Update Date/Time <br/>
		Shift + 'U' : Undo <br/>
	</div>
</div>

<!-- index page -->
<div class="w3-container" id="chemolistInfo">
	<table class="w3-small" id="mainList">
		<thead>
			<tr>
				<th style="width:5%">Date</th>
				<th style="width:5%">Patient#</th>
				<th style="width:12%">Item Name</th>
				<th style="width:12%">Regimen</th>
				<th style="width:6%">Receive Confirmation</th>
				<th style="width:6%">Materials Preparation Finish</th>
				<th style="width:6%">Materials Checking Finish</th>
				<th style="width:6%">KARSON input completed</th>
				<th class="finalColumn" style="width:6%">Entered into Clean Room</th>
				<th style="width:6%">Fin. Vol Checking</th>
				<th style="width:6%">Fin. Vol Checked By</th>
				<th class="finalColumn" style="width:6%">Fin. Product Ready to send out</th>
				<th class="finalColumn" style="width:6%">Fin. Product Delivery Completed</th>
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
		<tbody id="listInfo"></tbody>
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


<div class="w3-container" id="disableAll">
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
	  		<button id="closeRemarkButton" class="w3-button w3-round-large button" onclick="closeRemark()">Close</button>
			<button id="reverseButton" class="w3-button w3-round-large button" onclick="reverseAction(null,$('#remarkChemoId').val(),$('#remarkStatus').val())">Reverse</button>
			<button id="saveRemarkButton" class="w3-button w3-round-large w3-display-bottomright button" onclick="saveRemark()">Save</button>
		</footer>
  </div>
</div>

<!-- New Case Trigger -->
<div id="newCasePopup" class="w3-modal">
 	<div class="w3-modal-content">
    	<header class="w3-container ah-pink">
			<span id="closePopup" onclick="closeNewChemo()" class="w3-button w3-display-topright">&times;</span>
			<b><font face="AR PL SungtiL GB" size=6 >
				<span id="startCaseTitle">Start New Case</span>
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
						<th style="width:5%">X</th>
						<th style="width:15%">Date</th>
						<th style="width:45%">Chemo Agent</th>
						<th style="width:10%">Duration (Days)</th>
						<th style="width:25%">Regimen</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
			<button id="addButton" class="w3-button ah-pink w3-round-large" onclick="addNewChemo()">+</button>
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
			<button id="pastHistButton" class="w3-button w3-round-large button w3-display-topright" onclick="getPastHistoryByPatient($('#patno').val(),$('#chemoPkgcode').val())">Past History</button>
		</div>
		<footer class="w3-container ah-pink">
	  		<button id="closeButton" class="w3-button w3-round-large button" onclick="closeNewChemo()">Close</button>
			<button id="cancelButton" class="w3-button w3-round-large button" onclick="cancelChemo()" style="display:none;">Cancel Case</button>
			<button id="updateButton" class="w3-button w3-round-large w3-display-bottomright button" onclick="updateChemo()">Update</button>
			<button id="saveButton" class="w3-button w3-round-large w3-display-bottomright button" onclick="saveNewChemo()">Save</button>
		</footer>
  </div>
</div>

<div class="w3-modal" id="patientHistory"></div>


</body>
	 

</html>