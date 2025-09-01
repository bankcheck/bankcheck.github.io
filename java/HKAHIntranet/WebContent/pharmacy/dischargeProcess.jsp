<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList<ReportableListObject> fetchWard(String locid) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT WRDNAME ");
		sqlStr.append("FROM   WARD@IWEB ");
		sqlStr.append("WHERE  WRDCODE = UPPER(?) ");
		sqlStr.append("AND    ACTIVE = '-1' ");
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { locid });
	}
%>
<%
/*
locid
1 - Pharmacy (PHAR)
2 - PBO (PBO)
3 - WARD (@HATS-WARD)
*/

/*
STATUS (TABLE:TICKET_QUEUE)
1 - Start Discharge	(START_DATE)
2 - Send to Pharmacy (TO_RX_DATE)
3 - Receive order (RECEIVE_DATE)
4 - Entry Completed (ENTRY_DATE)
------------------------------------
5 - Rx Drop off at PBO (TO_PBO_DATE)
6 - Finish Billing (FINISH_BILLING_DATE)
7 - Payment Settlement (PAYMENT_SETTLEMENT_DATE)
------------------------------------
8 - Pharmacy Bedside Discharge (RX_BEDSIDE_DISCHARGE_DATE)
9 - Drug picking by patient  (DRUG_PICKING_DATE)
10 - No Discharge Med (NO_RX_DISCHARGE_DATE)
*/

UserBean userBean = new UserBean(request);

ArrayList<ReportableListObject> record = null;
ArrayList<ReportableListObject> record2 = null;
ReportableListObject row = null;
String locid = request.getParameter("locid");
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
String queue = request.getParameter("queue");
String queueName = null;
%>
<html>

<head>
<link rel="stylesheet" type="text/css" href="../css/w3.hkah.css" />
<link rel="shortcut icon" href="../images/discharge.ico" type="image/x-icon" />
<title>Discharge Process</title>
<script type="text/javascript" src="../js/jquery-1.5.1.min.js" /></script>
<script type="text/javascript">
var locid = "<%=locid %>";
<!--//
	var wait = 2 * 1000;
	var table = 0;
	var updateStatus = '';
	var multSelect = [];
	var reportUrl = '';

	$('#listInfo').html('');

	// this bit of code just ensures that if you have focus on the input which may be in a form
	// that the carriage return does not cause your form to be submitted. Some scanners submit
	// a carriage return after all the numbers have been passed.
//	$("#barcode").keypress(function(e) {
//		if ( e.which === 13 ) {
//			console.log("Prevent form submit.");
//			e.preventDefault();
//		}
//	});

	function timer(refreshOnly) {
			$.ajax({
				type: "POST",
				url: "dischargeProcess_ajax.jsp",
				data: "locid=<%=locid %>",
				success: function(values) {
					if (values != '') {
						$('#listInfo').html(values);
						window.setTimeout("timer(true)", wait);
						if(!refreshOnly){
							window.setTimeout("timer(false)", wait);
						}
					} else {
						if(table != 0){
							timer(refreshOnly);
						}else{
							$('#listInfo').html('');

							if(!refreshOnly){
								window.setTimeout("timer(false)", wait);
							}

						}
					}//if
				}//success
			});//$.ajax
	}

	function startTimer() {
		timer(true);
	}

	function isIE() {
		  var myNav = navigator.userAgent.toLowerCase();
		  var ret = (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
		  return ret;
	}

	$(document).ready(function () {
		startTimer();
<% if(isWard || isPBO){ %>
		$("#listInfo").css("height","75%");
		$("#Footer").css("height","12%");
<% } %>

		// variable to ensure we wait to check the input we are receiving
		// you will see how this works further down
		var pressed = false;
		// Variable to keep the barcode when scanned. When we scan each
		// character is a keypress and hence we push it onto the array. Later we check
		// the length and final char to ensure it is a carriage return - ascii code 13
		// this will tell us if it is a scan or just someone writing on the keyboard
		var chars = [];
		// trigger an event on any keypress on this webpage
//		$(window).keypress(function(e) {
		$(document).keypress(function(e) {
			if (e.which == 13) { // 13 = "ENTER"

			} else {
				// check the keys pressed are numbers or 'A'
				// 48-57 = "0-9"
				// 65-90 = "A-Z"
				// 97-122 = "Function Key / Number Pad"
				if ((e.which >= 48 && e.which <= 57) || (e.which >= 65 && e.which <= 90) || (e.which >= 97 && e.which <= 122)) {
					// if a number is pressed we add it to the chars array
					chars.push(String.fromCharCode(e.which));
				}
				// debug to help you understand how scanner works
//				console.log(e.which + ":" + pressed + ":" + chars.join("|"));

				// Pressed is initially set to false so we enter - this variable is here to stop us setting a
				// timeout everytime a key is pressed. It is easy to see here that this timeout is set to give
				// us 1 second before it resets everything back to normal. If the keypresses have not matched
				// the checks in the readBarcodeScanner function below then this is not a barcode
				if (!pressed) {
					// we set a timeout function that expires after 1 sec, once it does it clears out a list
					// of characters

					setTimeout(function() {
						// check we have a long length e.g. it is a barcode
						if (chars.length >= 4) {
							// join the chars array to make a string of the barcode scanned
							var barcode = chars.join('');
							// debug barcode to console (e.g. for use in Firebug)
//							console.log("Barcode Scanned: " + barcode);
							// assign value to some input (or do whatever you want)
//							$("#barcode").html("<" + barcode + ">");
							performAction(barcode,updateStatus);
						}
						chars = [];
						pressed = false;
					},500);
				}
				// set press to true so we do not reenter the timeout function above
				pressed = true;
			}
		});
	});

	function performAction(regid, updateStatus){
		if (updateStatus == '4' || updateStatus == '6' || updateStatus == '9'){
			$.ajax({
				type: "POST",
				url: "dischargeProcessUpdate_ajax.jsp",
				data: "locid=<%=locid %>&process=getTime&queue=" + updateStatus + "&regID=" + regid,
				success: function(values) {
					if ((updateStatus == '4') && $.trim(values) > 33){
						remarkPopup(regid, updateStatus, true);
					}else if (updateStatus == '6' && $.trim(values) > 20){
						remarkPopup(regid, updateStatus, true);
					}else if (updateStatus == '9' && $.trim(values) > 60){
						remarkPopup(regid, updateStatus, true);
					}

				}
			});//$.ajax
		}else{
			$.ajax({
				type: "POST",
				url: "dischargeProcessUpdate_ajax.jsp",
				data: "locid=<%=locid %>&queue=" + updateStatus + "&regID=" + regid,
				success: function(values) {
					timer(true);
					<%if (isWard) {%>
						if(updateStatus == '9'){
							unhighlight();
						}
					<%}%>
				}
			});//$.ajax
		}
	}

	function highlight(cell, newStatus) {
		if (multSelect.length == 0) {
			unhighlight();
			if (updateStatus != newStatus) {
				updateStatus = newStatus;
				cell.style.fontWeight = 'bold';
				cell.style.background = '#FFBFBF';
			}
		} else {
			//ln 321 (multSelect.length != 0)
			updateStatus = newStatus;
		}
	}

	function unhighlight(){
		document.getElementById("tmrDischargePopup").style.display = "none";
		$(".button").css("background-color","#CCCCCC");
		$(".button").css("fontWeight","normal");
		updateStatus=null;
	}

	function timePopup(element,logDate, logTime){
		//
		var x = 0;
		var y = 0;
		while ( element ) {
		    x += element.offsetLeft - element.scrollLeft + element.clientLeft;
		    y += element.offsetTop - element.scrollLeft + element.clientTop;
		    element = element.offsetParent;
		}
		$("#TimePopup").css("left",x+40);
		$("#TimePopup").css("top",y);

		$("#logDate").text(logDate);
		$("#logTime").text(logTime);

		document.getElementById("TimePopup").style.display = "block";
	}

	function remarkPopup(regid, updateStatus, required){
		unhighlight();
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
		$("#remarkRequired").val(required);

<% if(isPhar){ %>
		if(updateStatus =='3'){
			document.getElementById("noMedContent").style.display = "inline";
		}else{
			document.getElementById("noMedContent").style.display = "none";
		}
		if(updateStatus == "2" || updateStatus == "5" || updateStatus == "6" || updateStatus == "7"){
			document.getElementById("remark").readOnly = true;
			document.getElementById("saveButton").style.display = "none";
			document.getElementById("reverseButton").style.display = "none";
		}else{
			document.getElementById("saveButton").style.display = "inline";
			document.getElementById("reverseButton").style.display = "inline";
			document.getElementById("remark").readOnly = false;
		}
<% } else if(isPBO){ %>
		if(updateStatus == "5" || updateStatus == "6" || updateStatus == "7"){
			document.getElementById("saveButton").style.display = "inline";
			document.getElementById("reverseButton").style.display = "inline";
			document.getElementById("remark").readOnly = false;
		}else{
			document.getElementById("remark").readOnly = true;
			document.getElementById("saveButton").style.display = "none";
			document.getElementById("reverseButton").style.display = "none";
		}
<% } else if(isWard){ %>
		if(updateStatus == "2" || updateStatus == "9"){
			document.getElementById("saveButton").style.display = "inline";
			if(updateStatus == "2"){
				document.getElementById("reverseButton").style.display = "inline";
			}else{
				document.getElementById("reverseButton").style.display = "none";
			}
			document.getElementById("remark").readOnly = false;
		}else{
			document.getElementById("remark").readOnly = true;
			document.getElementById("saveButton").style.display = "none";
			document.getElementById("reverseButton").style.display = "none";
		}
<% } else { %>
		document.getElementById("remark").readOnly = true;
		document.getElementById("saveButton").style.display = "none";
		document.getElementById("reverseButton").style.display = "none";
<% } %>
		if(required == null){
			required = false;
			document.getElementById("remarkNote").style.display = "none";
			document.getElementById("closeButton").style.display = "inline";
			document.getElementById("closePopup").style.display = "inline";
		}else{
			document.getElementById("remarkNote").style.display = "inline";
			document.getElementById("disableAll").style.display = "inline";
			document.getElementById("closeButton").style.display = "none";
			document.getElementById("closePopup").style.display = "none";
		}

		document.getElementById("RemarkPopup").style.display = "block";
	}

	function closePopup(){
		$("#remark").val("");
		$("#noMed").val("");
		document.getElementById("disableAll").style.display = "none";
		document.getElementById("RemarkPopup").style.display = "none";
	}

	function saveRemark(){
		var regid = $("#remarkRegid").val();
		var updateStatus = $("#remarkStatus").val();
		var remark = $("#remark").val();
		var nomed = $("#noMed").val();
		var required = $("#remarkRequired").val();
		if (required == "true"){
			if(remark.length==0){
				alert("The process exceed the pledge time, please fill in the remark.");
				return;
			}
		}
		if (nomed != null)
			nomed = nomed.split("+").join("%2B");
		if (remark != null)
			remark= remark.split("'").join("\\'");
		$.ajax({
			type: "POST",
			url: "dischargeProcessUpdate_ajax.jsp",
			data: "locid=<%=locid %>&queue=" + updateStatus + "&regID=" + regid + "&nomed=" + nomed + "&process=addRemark&remark=" + remark,
			success: function(values) {
				$("#remark").val("");
				closePopup();
			}
		});//$.ajax
	}

	function closeRemark(){
		var remark = $("#remark").val();
		var required = $("#remarkRequired").val();
		if (required == "true"){
			if(remark.length==0){
				alert("The process exceed the pledge time, please fill in the remark.");
				return;
			}
		}
		closePopup();
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

	function reverseAction(){
		var regid = $("#remarkRegid").val();
		var updateStatus = $("#remarkStatus").val();
		//console.log(updateStatus);
		$.ajax({
			type: "POST",
			url: "dischargeProcessUpdate_ajax.jsp",
			data: "locid=<%=locid %>&queue=" + updateStatus + "&regID=" + regid + "&process=reverse",
			success: function(values) {
				closePopup();
			}
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

	function tmrDischargeListPopup(){
		unhighlight();
		closePopup();
		$.ajax({
			type: "POST",
			url: "dischargeProcess_tmrList.jsp",
			data: "locid=<%=locid %>",
			success: function(values) {
				$('#tmrDischargeList').html(values);
			}
		});//$.ajax
		document.getElementById("tmrDischargePopup").style.display = "block";
	}

	function dischargeHistory(){
		window.open(
				"/intranet/pharmacy/dischargeProcess_byDate.jsp?locid=" + locid,
				 "_blank" // <- This is what makes it open in a new window.
				);
	}

	function updateCompleted(){
		$('#row1 .cps').each(function() {
			//console.log($(this).context);
			if($(this).context.innerText == 1){
				$(this).closest('tr').addClass("completedRow");
			}
		});
	}
	
	function alertInCompleted(regid){
		$('#row1 .regid').each(function() {		
			if($(this).context.innerText == regid){
				$(this).closest('tr').addClass("alertIncompleteRow");
			}
		});
	}
	
	function viewAllDept(){
		if(locid != 'allDept'){
		window.open(
				"/intranet/pharmacy/dischargeProcess.jsp?locid=allDept",
				 "_blank" // <- This is what makes it open in a new window.
				);
		}
	}

//-->
</script>
<style type="text/css">
#Header {
	height: 10%;
	border-bottom: 3px solid #333;
}
#listInfo {
	padding: 8px;
	overflow-y: scroll;
	height: 73%;
}
#Footer {
	height: 17%;
	position: absolute;
	width: 100%;
	bottom: 0; /* stick to bottom */
	background-color: white;
	border-top: 3px solid #333;
	z-index: 1;
	left: 0;
	right: 0;
}
.box {
	border: 1px solid #CCC;
}

th{
	font-size:14px;
}

#title {
	position: absolute;
	bottom: 0;
	width: 100%;
	text-align: center;
}

.completeImg{
	cursor: pointer;
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
#RemarkPopup {
	display: none; /* Hidden by default */
	position: absolute;
	z-index: 10; /* Sit on top */
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

#noMedContent{
	display: none;
}

#TimePopup {
	display: none; /* Hidden by default */
	position: absolute;
	z-index: 1; /* Sit on top */
	left: 760px;
    top: 295px;
    width: 200px;
    height: 70px;
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
#reverseButton{
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
    opacity: 0.9;
    font-size: 150%;
    border:2px solid #ffffff;
    text-align: center;
}
.pharbutton{
	height: 80px;
	white-space: normal;
	vertical-align: middle;

}
.pbobutton{
	height: 50px;
	white-space: normal;
	vertical-align: middle;
}

.wardbutton{
	height: 50px;
	white-space: normal;
	vertical-align: middle;
}

#listTable{
	width: 100%;
	border-collapse: collapse;
	border: 1px black;
	border-bottom-style: dotted;
}

#listTable th{
	border: 2px black;
    border-bottom-style: solid;
    text-align: left;
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

.pharList2{
	background-color: #FFFFFF;
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

.completedRow{
	background-color: #E6E6E6;
}

.alertIncompleteRow{
	  animation: blinker 2s linear infinite;
}

.hiddenC{
	position: absolute;
  	left: -999px;
}

@keyframes flash
{
0% { 	border-color: #FF0000;}
50% {	border-color: #FFFFFF;}
100% {	border-color: #FF0000;}
}

@keyframes blinker {
0% { 	background-color: #ffb380;}
50% {	background-color: #FFFFFF;}
100% {	background-color: #ffb380;}
}
</style>
</head>

<body>

<div id="Header" class="w3-display-container ah-pink">
	<b><font id="title" face="AR PL SungtiL GB" size=6 >Discharge Process -- <%=locDesc %></font></b>
<%	if (isWard) { %>	
	<button class="leftbuttom w3-button w3-pale-red w3-round-large" onclick="viewAllDept()">View All Dept.</button>
<%	} %>
</div>
<!-- index page -->

<div class="w3-container" id="listInfo" onclick='unhighlight()'></div>

<div class="w3-container" id="Footer">
	<div class="w3-cell-row">
		<div class="w3-container w3-col" style="width:60%; height: 40px;" ><b>Number of Tomorrow Discharge: <span id="tmrCount">0</span></b></div>
		<div class="w3-container w3-col w3-btn button" style="width:20%; height: 40px;" onclick="dischargeHistory()">Discharge History</div>
		<div class="w3-container w3-col w3-btn button" style="width:20%; height: 40px;" onclick="tmrDischargeListPopup()">Tmr Discharge List</div>
  	</div>
  	<div class="w3-cell-row">
  	<%	if (isPBO) { %>
  		<div class="w3-container w3-col button pbobutton" style="width:	33.3%;" onclick='highlight(this, "5")'>Drop off at PBO</div>
		<div class="w3-container w3-col button pbobutton" style="width: 33.3%;" onclick='highlight(this, "6")'>Finish Billing</div>
		<div class="w3-container w3-col button pbobutton" style="width: 33.3%;" onclick='highlight(this, "7")'>Payment Settlement</div>
  	<%	} else if (isPhar) { %>
		<div class="w3-container w3-col w3-btn button pharbutton" style="width:20%" onclick='highlight(this, "3")'>Receive from Ward</div>
		<div class="w3-container w3-col w3-btn button pharbutton" style="width:20%" onclick='highlight(this, "4")'>Entry Completed</div>
		<!-- <div class="w3-container w3-col w3-btn button pharbutton" style="width:20%" onclick='highlight(this, "5")'>Drop off at PBO</div>-->
		<div class="w3-container w3-col w3-btn button pharbutton" style="width:20%" onclick='highlight(this, "8")'>No Discharge Med.</div>
		<div class="w3-container w3-col w3-btn button pharbutton" style="width:20%" onclick='highlight(this, "9")'>Phar. Bedside Discharge</div>
		<div class="w3-container w3-col w3-btn button pharbutton" style="width:20%" onclick='highlight(this, "10")'>Drug picking by patient </div>
	<%	} else if (isWard) { %>
		<div class="w3-container w3-col w3-btn button wardbutton" style="width:80%" onclick='highlight(this, "2")' id='sdToPhar'>Send to Pharmacy</div>
		<div class="w3-container w3-col w3-btn button wardbutton" style="width:20%" onclick='highlight(this, "9")'>Phar. Bedside Discharge</div>
  	<%	} %>
  	</div>
</div>

<!-- Remark -->
<div class="w3-container w3-round-large" id="RemarkPopup">
	<div class="w3-container ah-pink" id="popupHeader">
		<b><font face="AR PL SungtiL GB" size=6 >Process Remark</font></b> - Patient # <span id="remarkPatno"></span><div id="remarkNote"> (REQUIRED)</div>
		<img id="closePopup" src="../images/delete4.png" width="30" height="30" border="0" onclick="closeRemark()"></img>
	</div>
	<div class="w3-container" id="remarkContent">
		<textarea name="remark" id="remark" rows="4" cols="35" maxlength="1000"></textarea>
		<input type="hidden" name="remarkRegid" id="remarkRegid" value="" />
		<input type="hidden" name="remarkStatus" id="remarkStatus" value="" />
		<input type="hidden" name="remarkRequired" id="remarkRequired" value="" />
<%	if (isPhar) { %>
		<br/><br/>
		<div id="noMedContent">
			No. Of Meds:<input type="text" name="noMed" id="noMed" value="" />
		</div>
<%	} %>
	</div>

	<div class = "leftbuttom">
	<button id="saveButton" class="w3-button ah-pink w3-round-large" onclick="saveRemark()">Save</button>
	<button id="closeButton" class="w3-button ah-pink w3-round-large" onclick="closeRemark()">Close</button>
	</div>
	<div class = "rightbuttom">
	<button id="reverseButton" class="w3-button ah-pink w3-round-large" onclick="reverseAction()">Reverse</button>
	</div>
</div>

<div id="disableAll">
</div>

<!-- Time Popup -->
<div class="w3-container w3-round-large" id="TimePopup">
	Date: <span id="logDate"></span><br/>
	Time: <span id="logTime"></span>
</div>


<!-- TmrDischarge -->
<div class="w3-container" id="tmrDischargePopup">
	<div class="w3-container ah-pink" id="popupHeader">
		<b><font face="AR PL SungtiL GB" size=6 >Discharge List - </font>
			<span id="dischargeDate"></span>
		</b>
		<img id="closePopup" src="../images/delete4.png" width="30" height="30" border="0" onclick="document.getElementById('tmrDischargePopup').style.display = 'none';"></img>
	</div>
	<div class="w3-container" id="tmrDischargeList" style="width:100%"></div>
</div>



</body>
</html>