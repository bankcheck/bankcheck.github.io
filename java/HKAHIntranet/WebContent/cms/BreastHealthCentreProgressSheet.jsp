<%@ page import="java.io.*"%>
<%@ page language="java" import="org.json.JSONObject" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="com.hkah.servlet.*" %>

<%
//get information for CISformContent
String mode = ParserUtil.getParameter(request, "mode"); //new, edit, view, viewFromID
String action = ParserUtil.getParameter(request, "action"); //update, check
String userid = ParserUtil.getParameter(request, "userid");
String patno = ParserUtil.getParameter(request, "patno");
String regid = ParserUtil.getParameter(request, "regid");//if no reg, default = 0
String formuid = ParserUtil.getParameter(request, "formuid");
String[] ba_q = new String[5000];
String baID = null;

//define parameter
String formDate = "";
String consulationDate = "";
String sourceOfReferral = "";
String educationLv = "";
String occupation = "";
String smoking = "";
String quantityOfSmoke = "";
String drinking = "";
String quantityOfDrink = "";
String goh = "";
String poh = "";
String moh = "";
String toh = "";
String ageOfDelivery = "";
String breastFeeding = "";
String hrt = "";
String hrtMonth = "";
String hrtYear = "";
String menarcheAge = "";
String menopause = "";
String menopauseAge = "";
String lmpDate = "";
String pastMedicalHistory = "";
String familyHistory = "";
String finding = "";
String imaging = "";
String referToBioBoolean = "";
String mammogramFollowUpBoolean = "";
String usgFollowUpBoolean = "";
String mFollowUpPlace = "";
String mFollowUpDate = "";
String uFollowUpPlace = "";
String uFollowUpDate = "";

// Personal Information Section
String presentMedYN = null; //ba_q[8]
String presentMed = null; //ba_q[9]
String histHormContrYN = null; //ba_q[10]
String histHormContr = null; //ba_q[11]
// Breast symptoms
String breastLumpL = null; //ba_q[16]
String breastLumpLMth = null; //ba_q[17]
String breastLumpRMth = null; //ba_q[18]
String breastLumpR = null; //ba_q[19]
String dischrgFrmNipL = null; //ba_q[20]
String dischrgFrmNipLMth = null; //ba_q[21]
String dischrgFrmNipR = null; //ba_q[22]
String dischrgFrmNipRMth = null; //ba_q[23]
String nippleRetractL = null; //ba_q[24]
String nippleRetractLMth = null; //ba_q[25]
String nippleRetractR = null; //ba_q[26]
String nippleRetractRMth = null; //ba_q[27]
String breastSizeChgL = null; //ba_q[28]
String breastSizeChgLMth = null; //ba_q[29]
String breastSizeChgR = null; //ba_q[30]
String breastSizeChgRMth = null; //ba_q[31]
String breastPainfulL = null; //ba_q[32]
String breastPainfulLMth = null; //ba_q[33]
String breastPainfulR = null; //ba_q[34]
String breastPainfulRMth = null; //ba_q[35]
String skinProblemL = null; //ba_q[36]
String skinProblemLMth = null; //ba_q[37]
String skinProblemR = null; //ba_q[38]
String skinProblemRMth = null; //ba_q[39]
// Past Medical History
String noOfPregnancy = null; //ba_q[43]
String firstDeliveryAge = null; //ba_q[44]
String histBreastFeedYN = null; //ba_q[45]
String breastSurgeryDoneYN = null; //ba_q[46]
String breastSurgeryDoneL = null; //ba_q[47]
String breastSurgeryDoneR = null; //ba_q[48]
String breastUltrasound = null; //ba_q[49]
String mammogram = null; //ba_q[50]
String mammotome = null; //ba_q[51]
String fnac = null; //ba_q[52]
String biopsy = null; //ba_q[53]
String boCancerYN = null; //ba_q[54]
String breastCancer = null; //ba_q[55]
String ovarianCancer = null; //ba_q[56]
String boCanRelationship = null; //ba_q[57]
String noOfDelivery = null; //ba_q[58]

String patName = "";
String patAge = "";
String patSex = "";
String patDob = "";
String docName = "";

String formType = "";
ArrayList result = null;
ReportableListObject row = null;

String host = request.getRemoteAddr();

//get information after enter
if ((action == null || action.isEmpty()) && "view".equals(mode)){
	action = "check";
}

String formContent = ParserUtil.getParameter(request, "formContent");
String imgPath = ParserUtil.getParameter(request, "imgPath");
String updateDate = ParserUtil.getParameter(request, "updateDate");

if 	(mode == null || mode.isEmpty()){
	if (formuid == null || formuid.isEmpty()){
		mode = "new";
	}else{
		mode = "viewFromID";
	}
}

String url = null;
String logo = null;
if (ConstantsServerSide.isTWAH()) {
	url = "http://www.twah.org.hk";
	logo = "Horizontal_billingual_HKAH_TW.jpg";
} else {
	url = "http://www.hkah.org.hk";
	logo = "Horizontal_billingual_HKAH_HK.jpg";
}

if (regid == null || regid.isEmpty() || "0".equals(regid)){
	regid = "0";
	formType = "P";
}else {
	formType = "O";
}

//get form info
if (!(formuid == null || formuid.isEmpty() || "null".equals(formuid))){
	result = BreastHealthDB.getFormInfo(formuid);
	System.err.println("[result.size()]:"+result.size());
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		formDate = 	reportableListObject.getValue(1);
		formType = reportableListObject.getValue(2);
		regid = reportableListObject.getValue(3);
		patno = reportableListObject.getValue(4);
		userid = reportableListObject.getValue(5);
		if ("viewFromID".equals(mode) ||
			("edit".equals(mode) && !("update".equals(action))) ||
			"check".equals(action)){
			formContent = reportableListObject.getValue(6);
		}
	}
	// get imgPath from jasper
	String img = "";
	img = BreastHealthDB.getImage(formuid);
	imgPath = "data:image/png;base64,"+ img;
}

//get patno using regid
if (patno == null || patno.isEmpty()){
	result = BreastHealthDB.getPatID(regid);
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		patno = reportableListObject.getValue(1);
	}
}

//get pat info
result = PatientDB.getPatInfo(patno);
if (result.size() > 0) {
	ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
	patName = reportableListObject.getValue(3);
	patSex = reportableListObject.getValue(1);
	patDob = reportableListObject.getValue(10);
}

//get doc info
result = BreastHealthDB.getDocInfo(userid);
if (result.size() > 0) {
	ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
	docName = reportableListObject.getValue(1);
}

baID = BAFormDB.getBAFormID(patno, regid, "BAFORM");
System.err.println("[patno]"+patno+";[regid]:"+regid+";[baID]:"+baID);
result = BAFormDB.fetchAccessForm(baID);
if(result.size() > 0) {
	row = (ReportableListObject) result.get(0);
	baID = row.getValue(1);
	//regID = row.getValue(2);
	// Personal Background Section
//	formType = row.getValue(8);
	presentMedYN = row.getValue(27); //ba_q[8]
	presentMed = row.getValue(28); //ba_q[9]
	histHormContrYN = row.getValue(29); //ba_q[10]
	histHormContr = row.getValue(30); //ba_q[11]
	smoking = row.getValue(33); //ba_q[14]
	drinking = row.getValue(34); //ba_q[15]
	// Breast symptoms
	breastLumpL = row.getValue(35); //ba_q[16]
	breastLumpLMth = row.getValue(36); //ba_q[17]
	breastLumpR = row.getValue(37); //ba_q[18]
	breastLumpRMth = row.getValue(38); //ba_q[19]
	dischrgFrmNipL = row.getValue(39); //ba_q[20]
	dischrgFrmNipLMth = row.getValue(40); //ba_q[21]
	dischrgFrmNipR = row.getValue(41); //ba_q[22]
	dischrgFrmNipRMth = row.getValue(42); //ba_q[23]
	nippleRetractL = row.getValue(43); //ba_q[24]
	nippleRetractLMth = row.getValue(44); //ba_q[25]
	nippleRetractR = row.getValue(45); //ba_q[26]
	nippleRetractRMth = row.getValue(46); //ba_q[27]
	breastSizeChgL = row.getValue(47); //ba_q[28]
	breastSizeChgLMth = row.getValue(48); //ba_q[29]
	breastSizeChgR = row.getValue(49); //ba_q[30]
	breastSizeChgRMth = row.getValue(50); //ba_q[31]
	breastPainfulL = row.getValue(51); //ba_q[32]
	breastPainfulLMth = row.getValue(52); //ba_q[33]
	breastPainfulR = row.getValue(53); //ba_q[34]
	breastPainfulRMth = row.getValue(54); //ba_q[35]
	skinProblemL = row.getValue(55); //ba_q[36]
	skinProblemLMth = row.getValue(56); //ba_q[37]
	skinProblemR = row.getValue(57); //ba_q[38]
	skinProblemRMth = row.getValue(58); //ba_q[39]
	// Past Medical History
	menarcheAge = row.getValue(59); //ba_q[40]
	menopauseAge = row.getValue(60); //ba_q[41]
	lmpDate = row.getValue(61); //ba_q[42]
	noOfPregnancy = row.getValue(62); //ba_q[43]
	firstDeliveryAge = row.getValue(63); //ba_q[44]
	histBreastFeedYN = row.getValue(64); //ba_q[45]
	breastSurgeryDoneYN = row.getValue(65); //ba_q[46]
	breastSurgeryDoneL = row.getValue(66); //ba_q[47]
	breastSurgeryDoneR = row.getValue(67); //ba_q[48]
	breastUltrasound = row.getValue(68); //ba_q[49]
	mammogram = row.getValue(69); //ba_q[50]
	mammotome = row.getValue(70); //ba_q[51]
	fnac = row.getValue(71); //ba_q[52]
	biopsy = row.getValue(72); //ba_q[53]
	boCancerYN = row.getValue(73); //ba_q[54]
	breastCancer = row.getValue(74); //ba_q[55]
	ovarianCancer = row.getValue(75); //ba_q[56]
	boCanRelationship = row.getValue(76); //ba_q[57]
	noOfDelivery = row.getValue(77); //ba_q[58]
}

if (formContent != null){
	JSONObject content = new JSONObject(formContent);
	consulationDate = content.getString("consulationDate");
	sourceOfReferral = content.getString("sourceOfReferral");
	educationLv = content.getString("educationLv");
	occupation = content.getString("occupation");
	if(smoking==null){
		smoking = content.getString("smoking");
	}
	quantityOfSmoke = content.getString("quantityOfSmoke");
	if(drinking==null){
		drinking = content.getString("drinking");
	}
	quantityOfDrink = content.getString("quantityOfDrink");
	goh = content.getString("goh");
	poh = content.getString("poh");
	moh = content.getString("moh");
	toh = content.getString("toh");
	ageOfDelivery = content.getString("ageOfDelivery");
	if(breastFeeding==null){
		breastFeeding = content.getString("breastFeeding");
	}
	if(hrt==null){
		hrt = content.getString("HRT");
	}
	hrtMonth = content.getString("hrtMonth");
	hrtYear = content.getString("hrtYear");
	if(menarcheAge==null){
		menarcheAge = content.getString("menarcheAge");
	}
	menopause = content.getString("menopause");
	if(menopauseAge==null){
		menopauseAge = content.getString("menopauseAge");
	}
	if(menopauseAge==null){
		lmpDate = content.getString("lmpDate");
	}
	pastMedicalHistory = content.getString("pastMedicalHistory");
	familyHistory = content.getString("familyHistory");
	finding = content.getString("finding");
//	imaging = content.getString("imaging");
	referToBioBoolean = content.getString("referToBioBoolean");
	mammogramFollowUpBoolean = content.getString("mammogramFollowUpBoolean");
	usgFollowUpBoolean = content.getString("usgFollowUpBoolean");
	mFollowUpPlace = content.getString("mFollowUpPlace");
	mFollowUpDate = content.getString("mFollowUpDate");
	uFollowUpPlace = content.getString("uFollowUpPlace");
	uFollowUpDate = content.getString("uFollowUpDate");
}
%>
<!DOCTYPE html>
<html>
<head>
	<title>Breast Health Centre Progress Sheet</title>
	<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">
	<meta http-equiv="Expires" content="0">

	<style>
	body{

	}
	<%if ("view".equals(mode) || "viewFromID".equals(mode)){ %>
	body{
		background: gainsboro;
	}
	#page{
		background: white;
	    width:200mm;
	}
	#inputForm{
	    overflow: auto;
	    border: 1px solid;
	    border-color: #0000ff;
	    margin-bottom:10mm;
		margin-top: 5mm;
		margin-left: 0px;
		margin-right: 0px;
	    padding:5mm;
	}
	<%}%>
	input[type=text] {
		border: none;
		border-bottom: 0.5px solid;
	}
	#canvas {
		background-image: url("../images/form_breast.png");
		width: 341px;
		height: 201px;
	}
	table{
		vertical-align: top;
	}
	td[rowspan] {
		vertical-align: top;
		text-align: left;
	}
	.title {
		vertical-align: top;
		font-weight: bold;
	}
	textarea{
		width:90%;
	}
	.formLabel{
		overflow: hidden;
	    width: 100%;
		border: 1px solid black;
		margin-bottom: 30px;
	}

	.underLineText{
		border: none;
		border-bottom: 0.5px solid;
	}
	#nameLabel{
		float: left;
		width: 50%;
		margin-right: -1px;
		padding-bottom: 500em;
		margin-bottom: -500em;
	}
	#barcodeLabel{
		float: left;
		width: 50%;
		margin-right: -1px;
		border-left: 1px solid black;
		padding-bottom: 500em;
		margin-bottom: -500em;
	}
	#barcodeLabel table{
		width:100%;
		text-align:center;
		border-collapse: collapse;
	}
	span{
		margin-top: 5px;
	}
	input[type=button]{
		margin-left: 20px;
	    margin-right: 20px;
	}
	footer {
		z-index: 1;
	    position: fixed;
	    bottom: 0;
	    left: 0;
	    right: 0;
	    height: 30px;
	    background-color: gainsboro;
	}
	</style>
	<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script type="text/javascript">
	// Adding canvas setting for new entry only
	<%if ("new".equals(mode)){%>
		var value = "";
		var canvas, ctx, flag = false, prevX = 0, currX = 0, prevY = 0, currY = 0, dot_flag = false;
		var x = "red", y = 2;
		var background;

		function init() {
			canvas = document.getElementById('can');
			ctx = canvas.getContext("2d");
			w = canvas.width;
			h = canvas.height;

			background = new Image();
			background.src = "../images/form_breast.png";

			$("#canvasimg").hide();

			canvas.addEventListener("mousemove", function(e) {
				findxy('move', e);
			}, false);
			canvas.addEventListener("mousedown", function(e) {
				findxy('down', e);
			}, false);
			canvas.addEventListener("mouseup", function(e) {
				findxy('up', e);
			}, false);
			canvas.addEventListener("mouseout", function(e) {
				findxy('out', e);
			}, false);
		}

		function color(obj) {
			switch (obj.id) {
			case "red":
				x = "red";
				break;
			case "white":
				x = "white";
				break;
			}
			if (x == "white") {
				y = 14;
				ctx.globalCompositeOperation = 'destination-out';
			} else {
				y = 2;
				ctx.globalCompositeOperation = 'source-over';
			}
		}

		function draw() {
			ctx.beginPath();
			ctx.moveTo(prevX, prevY);
			ctx.lineTo(currX, currY);
			ctx.strokeStyle = x;
			ctx.lineWidth = y;
			ctx.stroke();
			ctx.closePath();
		}

		function erase() {
			var m = confirm("Want to clear");
			if (m) {
				ctx.clearRect(0, 0, w, h);
			}
		}

		function save() {
			var exportCanvas = document.getElementById('exportCan');
			var exportCtx = exportCanvas.getContext("2d");
			exportCtx.drawImage(background, 0, 0);
			exportCtx.drawImage(canvas, 0, 0);
			$("#canvasimg").show();
			var canvasimg = document.getElementById("canvasimg");
			var dataURL = exportCanvas.toDataURL();
			$("#imgPath").val(dataURL);
		}

		function findxy(res, e) {
			var rect = canvas.getBoundingClientRect();
			if (res == 'down') {
				prevX = currX;
				prevY = currY;
				currX = e.clientX - rect.left;
				currY = e.clientY - rect.top;
				flag = true;
				dot_flag = true;
				if (dot_flag) {
					ctx.beginPath();
					ctx.fillStyle = x;
					ctx.fillRect(currX, currY, 2, 2);
					ctx.closePath();
					dot_flag = false;
				}
			}
			if (res == 'up' || res == "out") {
				flag = false;
			}
			if (res == 'move') {
				if (flag) {
					prevX = currX;
					prevY = currY;
					currX = e.clientX - rect.left;
					currY = e.clientY - rect.top;
					draw();
				}
			}
		}
	<%}%>
	//end of canvas

	function lockPatInfo() {
		document.getElementById("formDate").readOnly = true;
		document.getElementById("patNo").readOnly = true;
		document.getElementById("patName").readOnly = true;
		document.getElementById("patDob").readOnly = true;
		document.getElementById("gender").readOnly = true;
	}

	function mFollowUp() {
		if ($('#mammogramFollowUp').is(":checked")) {
			$(".mFollowUp").prop('disabled', false);
		} else {
			$(".mFollowUp").prop('checked', false);
			$(".mFollowUp").prop('disabled', true);
		}
	}
	function uFollowUp() {
		if ($('#usgFollowUp').is(":checked")) {
			$(".uFollowUp").prop('disabled', false);
		} else {
			$(".uFollowUp").prop('checked', false);
			$(".uFollowUp").prop('disabled', true);
		}
	}

	function displayView(){
		// lock the field when view mode
		<% if ("view".equals(mode) || "viewFromID".equals(mode)){%>
			$('input').prop('readonly', true);
			$('textarea').prop('readonly', true);
			$('#inputForm input[type=radio]').prop('disabled', true);
			$('input[type=checkbox]').prop('disabled', true);
			$('input[type=text]').css('border-bottom','none');
		<%} %>
		<% if ("check".equals(action)){ %>
			$("#edit").prop('disabled', true);
			$("#preview").prop('disabled', true);
			$('#update').remove();
			$('#printUpdate').remove();
		<%} %>
			//for canvas
			var img="<%=imgPath%>";
			$(canvas).remove();
			$("#color").remove();
			$("#imgView").attr("src", img);
			$("#imgPath").val(img);

		};

	function getCurrentDate(){
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth()+1; //January is 0!
		var yyyy = today.getFullYear();
		if(dd<10) {
		    dd = '0'+dd;
		}
		if(mm<10) {
		    mm = '0'+mm;
		}
		today = yyyy + '-' + mm + '-' + dd;
		var showFormDate = "<%=formDate%>";
		showFormDate = showFormDate.substr(0,10);
		$("#formDate").val(showFormDate);
		<%if("new".equals(mode)){%>
			$("#consulationDate").val(today);
			$("#formDate").val(today);
		<%} %>
		$("#updateDate").val(today);
	};

	$(document).ready(function() {
		<% if (patName != null){%>
			lockPatInfo();
		<%}%>
		getCurrentDate();
		$(".mFollowUp").prop('disabled', true);
		$(".uFollowUp").prop('disabled', true);
		<% if ("view".equals(mode)||"edit".equals(mode) || "viewFromID".equals(mode)){ %>
			displayView();
		<%}%>
	});

</script>

</head>
<body <%if ("new".equals(mode)){%> onload="init()"<%}%> >
	<form name="breastHealth" id="breastHealth" action="" method="post">
	<div id="page">
		<div id="inputForm">
			<div class="title" style="text-align:right; float: right;">
				Breast Health Centre Progress Sheet<br>
				<% if ("view".equals(mode) || "viewFromID".equals(mode)){%>(View Mode)<%}%>
			</div>
			<div>
				<img width="390px" src="../images/<%=logo%>">
			</div>
			<table style="width: 100%">
				<tr>
					<td class="title" width="50%">Date of First Consulation: <input type="text" name="consulationDate" id="consulationDate" value="<%=consulationDate %>" readonly/></td>
					<td class="title" width="50%">Source of Referral: <input type="text" name="sourceOfReferral" id="sourceOfReferral" value="<%=sourceOfReferral %>" readonly/></td>
				</tr>
			</table>
			<%if(baID!=null && baID.length()>0){ %>
				<table class="table2" border=0 style="width: 100%">
					<tr>
						<td class="title" colspan=5><u>Past Medical History:</u></td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td width="15%" class="title">Breast surgery done&nbsp;</td>
						<td width="30%">
							<input type="radio" name=breastSurgeryDoneY value="0" <%if ("0".equals(breastSurgeryDoneYN) || "".equals(breastSurgeryDoneYN)) {%>checked<%} %> onclick="return false;"/>No
							<input type="radio" name="breastSurgeryDoneN" value="1" <%if ("1".equals(breastSurgeryDoneYN)) {%>checked<%} %> onclick="return false;">Yes</input>
						<td colspan=2>
							<input type="checkbox" name="breastSurgeryDoneL" value="1" <%if ("1".equals(breastSurgeryDoneL)) {%>checked<%} %> onclick="return false;"/>Left
							<input type="checkbox" name="breastSurgeryDoneR" value="1" <%if ("1".equals(breastSurgeryDoneR)) {%>checked<%} %> onclick="return false;"/>Right
						</td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td width="15%" class="title">Breast screening test&nbsp;</td>
						<td colspan=3>
							<input type="checkbox" name="breastUltrasound" value="1" <%if ("1".equals(breastUltrasound)) {%>checked<%} %> onclick="return false;"/>Breast Ultrasound
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="mammogram" value="1" <%if ("1".equals(mammogram)) {%>checked<%} %> onclick="return false;"/>Mammogram
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="mammotome" value="1" <%if ("1".equals(mammotome)) {%>checked<%} %> onclick="return false;"/>Mammotome
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="fnac" value="1" <%if ("1".equals(fnac)) {%>checked<%} %> onclick="return false;"/>FNAC
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="biopsy" value="1" <%if ("1".equals(biopsy)) {%>checked<%} %> onclick="return false;"/>Biopsy
						</td>
					</tr>
					<tr>
						<td class="title" colspan=5><u>Present Medication:</u></td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td colspan=4><input type="radio" name="presentMedN" value="0" <%if ("0".equals(presentMedYN) || "".equals(presentMedYN)) {%>checked<%} %>/>No
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="presentMedY" value="1" <%if ("1".equals(presentMedYN)) {%>checked<%} %>/>Yes
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id="presentMed" value="<%=presentMed==null?"":presentMed%>" readonly/>
						</td>
					</tr>
					<tr>
						<td class="title" colspan=5><u>Social Habits:</u></td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td class="title" colspan=2 disabled>Smoking:
							<select name="smoking" id="smoking" disabled>
								<option value="0"<%=("0".equals(smoking)?" selected":"")%>>No</option>
								<option value="1"<%=("1".equals(smoking)?" selected":"")%>>Yes</option>
								<option value="2"<%=("2".equals(smoking)?" selected":"")%>>Ex-smoker</option>
							</select>
						</td>
						<td class="title" colspan=2>Drinking:
							<select name="drinking" id="drinking" disabled>
								<option value="0"<%=("0".equals(drinking)?" selected":"")%>>No</option>
								<option value="1"<%=("1".equals(drinking)?" selected":"")%>>Yes</option>
								<option value="2"<%=("2".equals(drinking)?" selected":"")%>>Ex-smoker</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="title" colspan=5><u>Menstrual History:</u></td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td width="15%" class="title">Menarche age</td>
						<td width="30%"><input type="text" name="menarcheAge" id="menarcheAge" value="<%=menarcheAge==null?"":menarcheAge %>" size="3" readonly/>Age</td>
						<td width="15%" class="title">Menopause age</td>
						<td width="35%"><input type="text" id="menopauseAge" value="<%=menopauseAge==null?"":menopauseAge%>" size="3" readonly/>Age</td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td width="15%" class="title">Date of LMP</td>
						<td colspan=3><input type="text" id="lmpDate" value="<%=lmpDate==null?"":lmpDate%>" size="11" readonly/>(DD/MM/YYYY)</td>
					</tr>
					<tr>
						<td class="title" colspan=5><u>Obstetric History:</u></td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td colspan=2><b>G -</b><input type="text" id="noOfPregnancy" value="<%=noOfPregnancy==null?"":noOfPregnancy%>" size="3" readonly/>Time
						&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<b>P -</b><input type="text" id=noOfDelivery value="<%=noOfDelivery==null?"":noOfDelivery%>" size="3" readonly/>Time
						</td>
						<td class="title" colspan=2>
							First No. of Delivery at age of&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" id=firstDeliveryAge value="<%=firstDeliveryAge==null?"":firstDeliveryAge%>" size="3" readonly/>
						</td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td class="title" width="15%">History Breast Feeding:</td>
						<td colspan=3><input type="radio" name="breastFeedingNo" value="0" <%if ("0".equals(histBreastFeedYN) || "".equals(histBreastFeedYN)) {%>checked<%} %>/>No
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="breastFeedingYes" value="1" <%if ("1".equals(histBreastFeedYN)) {%>checked<%} %>/>Yes
						</td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td class="title" width="15%">History of Hormonal Contraceptive/HRT</td>
						<td width="30%"><input type="radio" name="hrtNo" value="0" <%if ("0".equals(hrt) || "".equals(hrt)) {%>checked<%} %>/>No
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="hrtYes" value="1" <%if ("1".equals(hrt)) {%>checked<%} %>/>Yes
						</td>
						<td colspan=2><input type="text" id=histHormContr value="<%=histHormContr==null?"":", for "+histHormContr%>" size="50" readonly/></td>
					</tr>
					<tr>
						<td class="title" colspan=4><u>Self Breasts Examination and Symptoms:</u></td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td class="title" width="15%">Breast Problems</td>
						<td class="title" width="30%">Left
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							How Long
						</td>
						<td class="title" colspan=2>Right
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							How Long
						</td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td class="title" width="15%">Breast lump</td>
						<td width="30%">
							<input type="checkbox" name=breastLumpL value="1" <%if ("1".equals(breastLumpL)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=breastLumpLMth value="<%=breastLumpLMth==null?"":breastLumpLMth %>" size="3" align="right" readonly/>Month
						</td>
						<td colspan=2>
							<input type="checkbox" name="breastLumpR" value="1" <%if ("1".equals(breastLumpR)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=breastLumpRMth value="<%=breastLumpRMth==null?"":breastLumpRMth %>" size="3" align="right" readonly/>Month
						</td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td class="title" width="15%">Discharge from nipple</td>
						<td width="30%">
							<input type="checkbox" name="dischrgFrmNipL" value="1" <%if ("1".equals(dischrgFrmNipL)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=dischrgFrmNipLMth value="<%=dischrgFrmNipLMth==null?"":dischrgFrmNipLMth %>" size="3" readonly/>Month
						</td>
						<td colspan=2>
							<input type="checkbox" name="dischrgFrmNipR" value="1" <%if ("1".equals(dischrgFrmNipR)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=dischrgFrmNipRMth value="<%=dischrgFrmNipRMth==null?"":dischrgFrmNipRMth %>" size="3" readonly/>Month
						</td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td class="title" width="15%">Nipple is retracted</td>
						<td width="30%">
							<input type="checkbox" name="nippleRetractL" value="1" <%if ("1".equals(nippleRetractL)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=nippleRetractLMth value="<%=nippleRetractLMth==null?"":nippleRetractLMth %>" size="3" readonly/>Month</td>
						<td colspan=2>
							<input type="checkbox" name="nippleRetractR" value="1" <%if ("1".equals(nippleRetractR)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=nippleRetractRMth value="<%=nippleRetractRMth==null?"":nippleRetractRMth %>" size="3" readonly/>Month
						</td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td class="title" width="15%">Breast size change</td>
						<td width="30%">
							<input type="checkbox" name="breastSizeChgL" value="1" <%if ("1".equals(breastSizeChgL)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=breastSizeChgLMth value="<%=breastSizeChgLMth==null?"":breastSizeChgLMth %>" size="3" readonly/>Month
						</td>
						<td colspan=2>
							<input type="checkbox" name="breastSizeChgR" value="1" <%if ("1".equals(breastSizeChgR)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=breastSizeChgRMth value="<%=breastSizeChgRMth==null?"":breastSizeChgRMth %>" size="3" readonly/>Month
						</td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td class="title" width="15%">Breast painful</td>
						<td width="30%">
							<input type="checkbox" name="breastPainfulL" value="1" <%if ("1".equals(breastPainfulL)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=breastPainfulLMth value="<%=breastPainfulLMth==null?"":breastPainfulLMth %>" size="3" readonly/>Month
						</td>
						<td colspan=2>
							<input type="checkbox" name="breastPainfulR" value="1" <%if ("1".equals(breastPainfulR)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=breastPainfulRMth value="<%=breastPainfulRMth==null?"":breastPainfulRMth %>" size="3" readonly/>Month
						</td>
					</tr>
					<tr>
						<td width="10%"></td>
						<td class="title" width="15%">Skin problem of breast/nipple<br/>e.g. Eczematous, ulcerated</td>
						<td width="30%">
							<input type="checkbox" name="skinProblemL" value="1" <%if ("1".equals(skinProblemL)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=skinProblemLMth value="<%=skinProblemLMth==null?"":skinProblemLMth %>" size="3" readonly/>Month
						</td>
						<td colspan=2>
							<input type="checkbox" name="skinProblemR" value="1" <%if ("1".equals(skinProblemR)) {%>checked<%} %>></input>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="text" id=skinProblemRMth value="<%=skinProblemRMth==null?"":skinProblemRMth %>" size="3" readonly/>Month
						</td>
					</tr>
				</table>
				<table class="table2" border=0 style="width: 100%">
				</table>
				<table class="table2" border=0 style="width: 100%">
					<tr>
						<td class="title" colspan=5><u>Family History:</u></td>
					</tr>
					<tr>
						<td width="5%"></td>
						<td width="25%" class="title">breast cancer/ovarian cancer</td>
						<td colspan=2><input type="radio" name="boCancerY" value="0" <%if ("0".equals(boCancerYN) || "".equals(boCancerYN)) {%>checked<%} %>/>No</td>
					</tr>
					<tr>
						<td colspan=2></td>
						<td width="10%">
							<input type="radio" name="boCancerN" value="1" <%if ("1".equals(boCancerYN)) {%>checked<%} %>/>Yes
							&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						<td>
							<input type="checkbox" name=breastCancer value="1" <%if ("1".equals(breastCancer)) {%>checked<%} %>/>Breast Cancer
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="ovarianCancer" value="1" <%if ("1".equals(ovarianCancer)) {%>checked<%} %>/>Ovarian Cancer
						</td>
					</tr>
					<tr>
						<td colspan=2></td>
						<td colspan=3>
							Relationship: <input type="text" id=boCanRelationship value="<%=boCanRelationship==null?"":boCanRelationship%>" size="50" readonly/>
						</td>
					</tr>
				</table>
				<div><input type="hidden" name="pastMedicalHistory" id="pastMedicalHistory" value="" /></div>
				<div><input type="hidden" name="familyHistory" id="familyHistory" value="" /></div>
				<div><input type="hidden" name="educationLv" id="educationLv" value="" /></div>
				<div><input type="hidden" name="occupation" id="occupation" value="" /></div>
				<div><input type="hidden" name="quantityOfSmoke" id="quantityOfSmoke" value="" /></div>
				<div><input type="hidden" name="quantityOfDrink" id="quantityOfDrink" value="" /></div>
				<div><input type="hidden" name="goh" id="goh" value="" /></div>
				<div><input type="hidden" name="poh" id="poh" value="" /></div>
				<div><input type="hidden" name="moh" id="moh" value="" /></div>
				<div><input type="hidden" name="toh" id="toh" value="" /></div>
				<div><input type="hidden" name="ageOfDelivery" id="ageOfDelivery" value="" /></div>
				<div><input type="hidden" name="hrtMonth" id="hrtMonth" value="" /></div>
				<div><input type="hidden" name="hrtYear" id="hrtYear" value="" /></div>
				<div><input type="hidden" name="referToBioBoolean" id="referToBioBoolean" value="" /></div>
				<div><input type="hidden" name="mammogramFollowUpBoolean" id="mammogramFollowUpBoolean" value="" /></div>
				<div><input type="hidden" name="usgFollowUpBoolean" id="usgFollowUpBoolean" value="" /></div>
				<div><input type="hidden" name="mFollowUpPlace" id="mFollowUpPlace" value="" /></div>
				<div><input type="hidden" name="mFollowUpDate" id="mFollowUpDate" value="" /></div>
				<div><input type="hidden" name="uFollowUpPlace" id="uFollowUpPlace" value="" /></div>
				<div><input type="hidden" name="uFollowUpDate" id="uFollowUpDate" value="" /></div>
			<%}else{ %>
				<table style="width: 100%">
					<tr>
						<td rowspan="3" class="title">Background:</td>
						<td colspan="3">
							<table style="width: 100%">
								<tr>
									<td>Education Level: <input type="text" name="educationLv" id="educationLv" value="<%=educationLv %>" /></td>
									<td>Occupation: <input type="text" name="occupation" id="occupation" value="<%=occupation %>" /></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>Smoking:</td>
						<td><input type="radio" name="smoking" id="smokingNo" value="no" <%if ("no".equals(smoking)){ %>checked<%} %>> No <input
							type="radio" name="smoking" id="smokingYes" value="yes" <%if ("yes".equals(smoking)){ %>checked<%} %>> Yes</td>
						<td>Quantity <input type="text" name="quantityOfSmoke" id="quantityOfSmoke" value="<%=quantityOfSmoke %>" /></td>
					</tr>
					<tr>
						<td>Drinking:</td>
						<td><input type="radio" name="drinking" id="drinkingNo" value="no" <%if ("no".equals(drinking)){ %>checked<%} %>> No
							<input type="radio" name="drinking" id="drinkingYes" value="yes" <%if ("yes".equals(drinking)){ %>checked<%} %>> Yes</td>
						<td>Quantity <input type="text" name="quantityOfDrink" id="quantityOfDrink" value="<%=quantityOfDrink %>"/></td>
					</tr>
				</table>
				<table>
					<tr>
						<td rowspan="4" class="title">Obstetric History:</td>
						<td colspan="3">
							<table style="width: 100%">
								<tr class="title">
									<td>G- <input type="text" name="goh" id="goh" placeholder="0" style="width: 80px;" value="<%=goh %>"/></td>
									<td>P- <input type="text" name="poh" id="poh" placeholder="0" style="width: 80px;" value="<%=poh %>"/></td>
									<td>M- <input type="text" name="moh" id="moh" placeholder="0" style="width: 80px;" value="<%=moh %>"/></td>
									<td>T- <input type="text" name="toh" id="toh" placeholder="0" style="width: 80px;" value="<%=toh %>"/></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>First Full Term Delivery at Age of</td>
						<td><input type="text" name="ageOfDelivery" id="ageOfDelivery" value="<%=ageOfDelivery %>"/></td>
					</tr>
					<tr>
						<td>History of Breast Feeding:</td>
						<td><input type="radio" name="breastFeedingYes" id="breastFeedingYes" value="yes" <%if ("yes".equals(breastFeeding)){ %>checked<%} %>> Yes
							<input type="radio" name="breastFeedingNo" id="breastFeedingNo" value="no" <%if ("no".equals(breastFeeding)){ %>checked<%} %>> No</td>
					</tr>
					<tr>
						<td>History of Hormonal Contraceptive / HRT:</td>
						<td><input type="radio" name="hrtYes" id="hrtYes" value="yes" <%if ("yes".equals(hrt)){ %>checked<%} %>> Yes
							<input type="radio" name="hrtNo" id="hrtNo" value="no" <%if ("no".equals(hrt)){ %>checked<%} %>> No</td>
						<td>For <input type="text" name="hrtMonth" id="hrtMonth" style="width: 20px;" value="<%=hrtMonth %>"/>Months
								<input type="text" name="hrtYear" id="hrtYear" style="width: 20px;" value="<%=hrtYear %>"/>Years</td>
					</tr>
				</table>
				<table>
					<tr>
						<td rowspan="3" class="title">Menstrual History:</td>
						<td>Menarche at age of</td>
						<td><input type="text" name="menarcheAge" id="menarcheAge" value="<%=menarcheAge %>"/></td>
					</tr>
					<tr>
						<td>Menopause</td>
						<td><input type="radio" name="menopauseYes" id="menopauseYes" value="yes" <%if ("yes".equals(menopause)){ %>checked<%} %>> Yes
							<input type="radio" name="menopauseNo" id="menopauseNo" value="no" <%if ("no".equals(menopause)){ %>checked<%} %>> No</td>
						<td>at age of <input type="text" name="menopauseAge" id="menopauseAge" value="<%=menopauseAge %>"/></td>
					</tr>
					<tr>
						<td>Date of LMP</td>
						<td><input type="text" name="lmpDate" id="lmpDate" value="<%=lmpDate %>"/></td>
					</tr>
				</table>
				<div>
					<div class="title">Past Medical History:</div>
					<div><textarea rows="4" name="pastMedicalHistory" id="pastMedicalHistory"><%=pastMedicalHistory %></textarea></div>
				</div>
				<div>
					<div class="title">Family History:</div>
					<div><textarea rows="4"name="familyHistory" id="familyHistory"><%=familyHistory %></textarea></div>
				</div>
			<%} %>
<hr>
			<table style="width: 80%">
				<tr>
					<td class="title" style="text-decoration: underline;">Physical Examination:</td>
					<td>
						<table>
							<tr>
								<td>
									<div id="canvas">
										<%if ("new".equals(mode)){ %>
											<canvas id="can" width="341px" height="201px" style="border: 2px solid;"></canvas>
											<canvas id="exportCan" width="341px" height="201px" style="border: 2px solid; display: none;"></canvas>
										<%}%>
									</div>
									<%if ("edit".equals(mode)||"view".equals(mode) || "viewFromID".equals(mode)) {%>
										<img id="imgView" src="<%=imgPath%>">
									<%} %>
									<input type="hidden" name="imgPath" id="imgPath"/>
								</td>
							</tr>
							<tr>
								<td>
									<table id="color">
										<tr>
											<td>Eraser</td>
											<td>Pen</td>
										</tr>
										<tr>
											<td><div style="width: 10px; height: 10px; background: white; border: 2px solid;" id="white" onclick="color(this)"></div></td>
											<td><div style="width: 10px; height: 10px; background: red; border: 2px solid;" id="red" onclick="color(this)"></div></td>
											<td><input type="button" value="clear" id="clr" size="23" onclick="erase()" style=""></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<table style="width: 80%">
				<tr>
					<td class="title">Findings:</td>
					<td><textarea rows="4" name="finding" id="finding"><%=finding %></textarea></td>
				</tr>
				<tr>
					<td colspan=2></td>
				</tr>
				<tr>
					<td colspan=2></td>
				</tr>
				<tr>
					<td class="title">Imaging:</td>
					<td><b>Please refer to DI Report</b></td>
				</tr>
			</table>
			<table style="width: 100%">
				<tr>
					<td class="title" style="text-decoration: underline;">Recommendation:</td>
				</tr>
				<tr>
					<td colspan=3>
						<input type="checkbox" name="recommendation" id="referToBio" value="referToBio" <%if ("true".equals(referToBioBoolean)){ %>checked<%} %>>Refer to Biopsy or FNAC
						<input type="hidden" name="referToBioBoolean" id="referToBioBoolean">
					</td>
				</tr>
				<tr>
					<td width="20%">
						<input type="checkbox" name="recommendation" id="mammogramFollowUp" value="mammogramFollowUp" onclick="mFollowUp()" <%if ("true".equals(mammogramFollowUpBoolean)){ %>checked<%} %>>Mammogram Follow up
						<input type="hidden" name="mammogramFollowUpBoolean" id="mammogramFollowUpBoolean">
					</td>
					<td width="30%">
						<input type="radio" class="mFollowUp" name="mFollowUpPlace" id="mFollowUpPlaceLeft" value="left" <%if ("left".equals(mFollowUpPlace)){ %>checked<%} %>> Left
						<input type="radio" class="mFollowUp" name="mFollowUpPlace" id="mFollowUpPlaceRight" value="right" <%if ("right".equals(mFollowUpPlace)){ %>checked<%} %>> Right
						<input type="radio" class="mFollowUp" name="mFollowUpPlace" id="mFollowUpPlaceBoth" value="both" <%if ("both".equals(mFollowUpPlace)){ %>checked<%} %>> Both
					</td>

<!--
					<td><input type="radio" class="mFollowUp" name="mFollowUpDate" id="mFollowUpDate6Months" value="6Months" <%if ("6Months".equals(mFollowUpDate)){ %>checked<%} %>> 6 Months
						<input type="radio" class="mFollowUp" name="mFollowUpDate" id="mFollowUpDate1Year" value="1Year" <%if ("1Year".equals(mFollowUpDate)){ %>checked<%} %>> 1 Year
						<input type="radio" class="mFollowUp" name="mFollowUpDate" id="mFollowUpDateRoutine" value="routine" <%if ("routine".equals(mFollowUpDate)){ %>checked<%} %>> Routine</td>
 -->
					<td width="50%">for: <input type="text" id=mFollowUpDate value="<%=mFollowUpDate==null?"":mFollowUpDate%>" size="50"/></td>
				</tr>
				<tr>
					<td width="20%">
						<input type="checkbox" name="recommendation" id="usgFollowUp" value="usgFollowUp" onclick="uFollowUp()" <%if ("true".equals(usgFollowUpBoolean)){ %>checked<%} %>>USG Follow up
						<input type="hidden" name="usgFollowUpBoolean" id="usgFollowUpBoolean">
					</td>
					<td width="30%">
						<input type="radio" class="uFollowUp" name="uFollowUpPlace" id="uFollowUpPlaceLeft" value="left" <%if ("left".equals(uFollowUpPlace)){ %>checked<%} %>> Left
						<input type="radio" class="uFollowUp" name="uFollowUpPlace" id="uFollowUpPlaceRight" value="right" <%if ("right".equals(uFollowUpPlace)){ %>checked<%} %>> Right
						<input type="radio" class="uFollowUp" name="uFollowUpPlace" id="uFollowUpPlaceBoth" value="both" <%if ("both".equals(uFollowUpPlace)){ %>checked<%} %>> Both
					</td>
<!--
					<td><input type="radio" class="uFollowUp" name="uFollowUpDate" id="uFollowUpDate6Months" value="6Months" <%if ("6Months".equals(uFollowUpDate)){ %>checked<%} %>> 6 Months
						<input type="radio" class="uFollowUp" name="uFollowUpDate" id="uFollowUpDate1Year" value="1Year" <%if ("1Year".equals(uFollowUpDate)){ %>checked<%} %>> 1 Year
						<input type="radio" class="uFollowUp" name="uFollowUpDate" id="uFollowUpDateRoutine" value="routine" <%if ("routine".equals(uFollowUpDate)){ %>checked<%} %>> Routine</td>
 -->
					<td width="50%">for: <input type="text" id=uFollowUpDate value="<%=uFollowUpDate==null?"":uFollowUpDate%>" size="50"/></td>
				</tr>
			</table>
			<table style="width: 80%; margin-top:50px;">
				<tr class="title">
					<td style="width:65%; border-bottom:1px solid;" >Doctor's signature: <span style="float:right;">(<input type="text" id="docName" name="docName" value="<%=docName %>" />)</span></td>
					<td style="text-align:right;">Date: <input type="text" name="formDate" id="formDate" /></td>
				<tr>
			</table>
			<div class="formLabel">
				<div id="nameLabel">
					<table>
						<tr class="title">
							<td>Patient No.:</td>
							<td><input type="text" id="patNo" name="patno"value="<%=patno %>"  />
								<input type="hidden" id="regid" name="regid" value="<%=regid %>" /></td>
						</tr>
						<tr class="title">
							<td>Name: </td>
							<td><input type="text" id="patName" name="patName" value="<%=patName %>" /></td>
						</tr>
						<tr class="title">
							<td>Date of Birth: </td>
							<td><input type="text" id="patDob" name="patDob" value="<%=patDob %>" /></td>
						</tr>
						<tr class="title">
							<td>Gender: </td>
							<td><input type="text" id="gender" name="gender" value="<%=patSex %>" /></td>
						</tr>
					</table>
				</div>
				<div id="barcodeLabel">
					<table>
						<tr>
							<td colspan="2" height="30" style="font-size:110%; vertical-align: middle;" class="title"><b>Breast Health Centre Progress Sheet</b></td>
						</tr>
						<tr>
							<td style="border: 1px solid black;">Version: 08 Mar 2017</td>
							<td style="border: 1px solid black;" class="title">BRHC-MBA002</td>
						</tr>
						<tr>
							<td colspan="2"><img src="../images/barcode.png"></td>
						</tr>
					</table>
				</div>
			</div>
			<input type="hidden" id="userid" name="userid" value="<%=userid %>" />
			<input type="hidden" id="formuid" name="formuid" value="<%=formuid %>" />
			<input type="hidden" name="mode" id="mode" />
			<input type="hidden" name="action" id="action" />
			<input type="hidden" name="formContent" id="formContent" />
			<input type="hidden" name="formType" id="formType" value="<%=formType %>" />
			<input type="hidden" name="updateDate" id="updateDate" value="" />
		</div>
	</div>
	</form>

	<footer>
		<span style="float: left;">
			<input type="radio" name="viewMode" value="Edit" id="edit" onclick="return viewAction('edit','update');" <%if ("new".equals(mode)||"edit".equals(mode)){ %>checked<%} %> style="margin-left: 20px;"/>Edit
			<input type="radio" name="viewMode" value="Preview" id="preview" onclick="return viewAction('view','update');" <%if ("view".equals(mode) || "viewFromID".equals(mode)){ %>checked<%} %> style="margin-left: 50px;"/>Preview
		</span>
		<span style="float: right;">
		<%if (formuid == null || formuid.isEmpty()||"null".equals(formuid)){%>
			<input type="button" value="Save" id="save" onclick="return submitAction('save');" />
			<input type="button" value="Save & Print" id="printSave" onclick="return submitAction('viewPage');" />
		<%} else{ %>
			<input type="button" value="Update" id="update" onclick="return submitAction('save');" />
			<input type="button" value="Update & Print" id="printUpdate" onclick="return submitAction('viewPage');" />
		<%} %>
			<input type="button" value="Close" id="close" onclick="closeWindow()" />
		</span>
	</footer>

</body>

<script>
	function saveContent(){
		var content = {};
		var formContent = "";
		var consulationDate = $("#consulationDate").val();
		var sourceOfReferral = $("#sourceOfReferral").val();
		var educationLv = $("#educationLv").val();
		var occupation = $("#occupation").val();

		var quantityOfSmoke = $("#quantityOfSmoke").val();
		<%if(baID!=null && baID.length()>0){%>
//			var smoking = $("#smoking").val();
			var smoking = '';
//			var drinking = $("#drinking").val();
			var drinking = '';
			var breastFeeding = $('input[name=breastFeedingYes]:checked').val();
			if (!($('input[name=breastFeedingYes]:checked').is(':checked'))){
				breastFeeding = "0";
			}
			var HRT = $('input[name=hrtYes]:checked').val();
			if (!($('input[name=hrtYes]:checked').is(':checked'))){
				HRT = "0";
			}
			var menopause = '';
			var menarcheAge = '';
			var menopauseAge = '';
			var lmpDate = '';
			var presentMed = '';
			var noOfPregnancy = '';
			var noOfDelivery = '';
			var firstDeliveryAge = '';
			var histHormContr = '';
		<%}else{%>
			var smoking = $('input[name=smoking]:checked').val();
			if (!($('input[name=smoking]:checked').is(':checked'))){
				smoking = "false";
			}
			var drinking = $('input[name=drinking]:checked').val();
			if (!($('input[name=drinking]:checked').is(':checked'))){
				drinking = "false";
			}
			var breastFeeding = $('input[name=breastFeedingYes]:checked').val();
			if (!($('input[name=breastFeedingYes]:checked').is(':checked'))){
				breastFeeding = "false";
			}
			var HRT = $('input[name=hrtYes]:checked').val();
			if (!($('input[name=hrtYes]:checked').is(':checked'))){
				HRT = "false";
			}
			var menopause = $('input[name=menopauseYes]:checked').val();
			if (!($('input[name=menopauseYes]:checked').is(':checked'))){
				menopause = "false";
			}
			var menarcheAge = $("#menarcheAge").val();
			var menopauseAge = $("#menopauseAge").val();
			var lmpDate = $("#lmpDate").val();
			var presentMed = $("#presentMed").val();
			var noOfPregnancy = $("#noOfPregnancy").val();
			var noOfDelivery = $("#noOfDelivery").val();
			var firstDeliveryAge = $("#firstDeliveryAge").val();
			var histHormContr = $("#histHormContr").val();
		<%}%>

		var quantityOfDrink = $("#quantityOfDrink").val();
		var goh = $("#goh").val();
		var poh = $("#poh").val();
		var moh = $("#moh").val();
		var toh = $("#toh").val();
		var ageOfDelivery = $("#ageOfDelivery").val();
		var hrtMonth = $("#hrtMonth").val();
		var hrtYear = $("#hrtYear").val();


		var pastMedicalHistory = $("#pastMedicalHistory").val();
		var familyHistory = $("#familyHistory").val();
		var finding = $("#finding").val();
//		var imaging = $("#imaging").val();
		var imaging = '';
		var referToBioBoolean = $('#referToBioBoolean').val();
		var mammogramFollowUpBoolean = $('#mammogramFollowUpBoolean').val();
		var usgFollowUpBoolean = $('#usgFollowUpBoolean').val();
		var mFollowUpPlace = $('input[name=mFollowUpPlace]:checked').val();
			if (!($('input[name=mFollowUpPlace]:checked').is(':checked'))){
				mFollowUpPlace = "false";
			}
/*
		var mFollowUpDate = $('input[name=mFollowUpDate]:checked').val();
			if (!($('input[name=mFollowUpDate]:checked').is(':checked'))){
				mFollowUpDate = "false";
			}
*/
		var mFollowUpDate = $("#mFollowUpDate").val();
		var uFollowUpPlace = $('input[name=uFollowUpPlace]:checked').val();
			if (!($('input[name=uFollowUpPlace]:checked').is(':checked'))){
				uFollowUpPlace = "false";
			}
/*
		var uFollowUpDate = $('input[name=uFollowUpDate]:checked').val();
			if (!($('input[name=uFollowUpDate]:checked').is(':checked'))){
				uFollowUpDate = "false";
			}
*/
			var uFollowUpDate = $("#uFollowUpDate").val();

		// Personal Information Section
		var presentMedYN = null;
			if ($('input[name=presentMedY]:checked').is(':checked')){
				presentMedYN = "1";
			}else{
				presentMedYN = "0";
			}

		var histHormContrYN = null;
			if ($('input[name=histHormContrY]:checked').is(':checked')){
				histHormContrYN = "1";
			}else{
				histHormContrYN = "0";
			}

		// Breast symptoms
		var breastLumpL = null;
			if ($('input[name=breastLumpL]:checked').is(':checked')){
				breastLumpL = "1";
			}else{
				breastLumpL = "0";
			}
		var breastLumpLMth = $("#breastLumpLMth").val();
		var breastLumpR = null;
			if ($('input[name=breastLumpR]:checked').is(':checked')){
				breastLumpR = "1";
			}else{
				breastLumpR = "0";
			}
		var breastLumpRMth = $("#breastLumpRMth").val();
		var dischrgFrmNipL = null;
			if ($('input[name=dischrgFrmNipL]:checked').is(':checked')){
				dischrgFrmNipL = "1";
			}else{
				dischrgFrmNipL = "0";
			}
		var dischrgFrmNipLMth = $("#dischrgFrmNipLMth").val();
		var dischrgFrmNipR = null;
			if ($('input[name=dischrgFrmNipR]:checked').is(':checked')){
				dischrgFrmNipR = "1";
			}else{
				dischrgFrmNipR = "0";
			}
		var dischrgFrmNipRMth = $("#dischrgFrmNipRMth").val();
		var nippleRetractL = null;
			if ($('input[name=nippleRetractL]:checked').is(':checked')){
				nippleRetractL = "1";
			}else{
				nippleRetractL = "0";
			}
		var nippleRetractLMth = $("#nippleRetractLMth").val();
		var nippleRetractR = null;
			if ($('input[name=nippleRetractR]:checked').is(':checked')){
				nippleRetractR = "1";
			}else{
				nippleRetractR = "0";
			}
		var nippleRetractRMth = $("#nippleRetractRMth").val();
		var breastSizeChgL = null;
			if ($('input[name=breastSizeChgL]:checked').is(':checked')){
				breastSizeChgL = "1";
			}else{
				breastSizeChgL = "0";
			}
		var breastSizeChgLMth = $("#breastSizeChgLMth").val();
		var breastSizeChgR = null;
			if ($('input[name=breastSizeChgR]:checked').is(':checked')){
				breastSizeChgR = "1";
			}else{
				breastSizeChgR = "0";
			}
		var breastSizeChgRMth = $("#breastSizeChgRMth").val();
		var breastPainfulL = null;
			if ($('input[name=breastPainfulL]:checked').is(':checked')){
				breastPainfulL = "1";
			}else{
				breastPainfulL = "0";
			}
		var breastPainfulLMth = $("#breastPainfulLMth").val();
		var breastPainfulR = null;
			if ($('input[name=breastPainfulR]:checked').is(':checked')){
				breastPainfulR = "1";
			}else{
				breastPainfulR = "0";
			}
		var breastPainfulRMth = $("#breastPainfulRMth").val();
		var skinProblemL = null;
			if ($('input[name=skinProblemL]:checked').is(':checked')){
				skinProblemL = "1";
			}else{
				skinProblemL = "0";
			}
		var skinProblemLMth = $("#skinProblemLMth").val();
		var skinProblemR = null;
			if ($('input[name=skinProblemR]:checked').is(':checked')){
				skinProblemR = "1";
			}else{
				skinProblemR = "0";
			}
		var skinProblemRMth = $("#skinProblemRMth").val();
		// Past Medical History



		var histBreastFeedYN = null;
			if ($('input[name=breastFeedingYes]:checked').is(':checked')){
				histBreastFeedYN = "1";
			}else{
				histBreastFeedYN = "0";
			}
		var breastSurgeryDoneYN = null;
			if ($('input[name=breastSurgeryDoneY]:checked').is(':checked')){
				breastSurgeryDoneYN = "1";
			}else{
				breastSurgeryDoneYN = "0";
			}
		var breastSurgeryDoneL = null;
			if ($('input[name=breastSurgeryDoneL]:checked').is(':checked')){
				breastSurgeryDoneL = "1";
			}else{
				breastSurgeryDoneL = "0";
			}
		var breastSurgeryDoneR = null;
			if ($('input[name=breastSurgeryDoneR]:checked').is(':checked')){
				breastSurgeryDoneR = "1";
			}else{
				breastSurgeryDoneR = "0";
			}
		var breastUltrasound = null;
			if ($('input[name=breastUltrasound]:checked').is(':checked')){
				breastUltrasound = "1";
			}else{
				breastUltrasound = "0";
			}
		var mammogram = null;
			if ($('input[name=mammogram]:checked').is(':checked')){
				mammogram = "1";
			}else{
				mammogram = "0";
			}
		var mammotome = null;
			if ($('input[name=mammotome]:checked').is(':checked')){
				mammotome = "1";
			}else{
				mammotome = "0";
			}
		var fnac = null;
			if ($('input[name=fnac]:checked').is(':checked')){
				fnac = "1";
			}else{
				fnac = "0";
			}
		var biopsy = null;
			if ($('input[name=biopsy]:checked').is(':checked')){
				biopsy = "1";
			}else{
				biopsy = "0";
			}
		var boCancerYN = null;
		if ($('input[name=boCancerY]:checked').is(':checked')){
			boCancerYN = "1";
		}else{
			boCancerYN = "0";
		}
		var breastCancer = null;
		if ($('input[name=breastCancer]:checked').is(':checked')){
			breastCancer = "1";
		}else{
			breastCancer = "0";
		}
		var ovarianCancer = null;
		if ($('input[name=ovarianCancer]:checked').is(':checked')){
			ovarianCancer = "1";
		}else{
			ovarianCancer = "0";
		}
		var boCanRelationship = $("#boCanRelationship").val();
		content = {
			"consulationDate" : consulationDate,
			"sourceOfReferral" : sourceOfReferral,
			"educationLv" : educationLv,
			"occupation" : occupation,
			"smoking" : smoking,
			"quantityOfSmoke" : quantityOfSmoke,
			"drinking" : drinking,
			"quantityOfDrink" : quantityOfDrink,
			"goh" : goh,
			"poh" : poh,
			"moh" : moh,
			"toh" : toh,
			"ageOfDelivery" : ageOfDelivery,
			"breastFeeding" : breastFeeding,
			"HRT" : HRT,
			"hrtMonth" : hrtMonth,
			"hrtYear" : hrtYear,
			"menarcheAge" : menarcheAge,
			"menopause" : menopause,
			"menopauseAge" : menopauseAge,
			"lmpDate" : lmpDate,
			"pastMedicalHistory" : pastMedicalHistory,
			"familyHistory" : familyHistory,
			"finding" : finding,
			"imaging" : imaging,
			"referToBioBoolean" : referToBioBoolean,
			"mammogramFollowUpBoolean" : mammogramFollowUpBoolean,
			"usgFollowUpBoolean" : usgFollowUpBoolean,
			"mFollowUpPlace" : mFollowUpPlace,
			"mFollowUpDate" : mFollowUpDate,
			"uFollowUpPlace" : uFollowUpPlace,
			"uFollowUpDate" : uFollowUpDate,
			"presentMedYN" : presentMedYN,
			"presentMed" : presentMed,
			"histHormContrYN" : histHormContrYN,
			"histHormContr" : histHormContr,
			"breastLumpL" : breastLumpL,
			"breastLumpLMth" : breastLumpLMth,
			"breastLumpR" : breastLumpR,
			"breastLumpRMth" : breastLumpRMth,
			"dischrgFrmNipL" : dischrgFrmNipL,
			"dischrgFrmNipLMth" : dischrgFrmNipLMth,
			"dischrgFrmNipR" : dischrgFrmNipR,
			"dischrgFrmNipRMth" : dischrgFrmNipRMth,
			"nippleRetractL" : nippleRetractL,
			"nippleRetractLMth" : nippleRetractLMth,
			"nippleRetractR" : nippleRetractR,
			"nippleRetractRMth" : nippleRetractRMth,
			"breastSizeChgL" : breastSizeChgL,
			"breastSizeChgLMth" : breastSizeChgLMth,
			"breastSizeChgR" : breastSizeChgR,
			"breastSizeChgRMth" : breastSizeChgRMth,
			"breastPainfulL" : breastPainfulL,
			"breastPainfulLMth" : breastPainfulLMth,
			"breastPainfulR" : breastPainfulR,
			"breastPainfulRMth" : breastPainfulRMth,
			"skinProblemL" : skinProblemL,
			"skinProblemLMth" : skinProblemLMth,
			"skinProblemR" : skinProblemR,
			"skinProblemRMth" : skinProblemRMth,
			"noOfPregnancy" : noOfPregnancy,
			"firstDeliveryAge" : firstDeliveryAge,
			"histBreastFeedYN" : histBreastFeedYN,
			"breastSurgeryDoneYN" : breastSurgeryDoneYN,
			"breastSurgeryDoneL" : breastSurgeryDoneL,
			"breastSurgeryDoneR" : breastSurgeryDoneR,
			"breastUltrasound" : breastUltrasound,
			"mammogram" : mammogram,
			"mammotome" : mammotome,
			"fnac" : fnac,
			"biopsy" : biopsy,
			"boCancerYN" : boCancerYN,
			"breastCancer" : breastCancer,
			"ovarianCancer" : ovarianCancer,
			"boCanRelationship" : boCanRelationship,
			"noOfDelivery" : noOfDelivery
		};

		formContent = JSON.stringify(content);
		$("#formContent").val(formContent);
	}

	//translate new line to <br>
	function translateBR(){
		var newText = $("#pastMedicalHistory").val().replace(/\r?\n/g, '&#13;');
		$("#pastMedicalHistory").val(newText);
		var newText = $("#familyHistory").val().replace(/\r?\n/g, '&#13;');
		$("#familyHistory").val(newText);
		var newText = $("#finding").val().replace(/\r?\n/g, '&#13;');
		$("#finding").val(newText);
//		var newText = $("#imaging").val().replace(/\r?\n/g, '&#13;');
//		$("#imaging").val(newText);
	}

	// get Recommendation choosen
	function getRecommendation(){
		if ($('#referToBio').is(":checked")){
			$('#referToBioBoolean').val(true);}
		if ($('#mammogramFollowUp').is(":checked")){
			$('#mammogramFollowUpBoolean').val(true);}
		if ($('#usgFollowUp').is(":checked")){
			$('#usgFollowUpBoolean').val(true);}
	}

	function viewAction(cmd, action) {
		document.breastHealth.mode.value = cmd;
		document.breastHealth.action.value = action;
		<%if ("new".equals(mode)){%>
			save();
		<%}%>
		translateBR();
		getRecommendation();
		saveContent();
		document.getElementById('breastHealth').action = 'BreastHealthCentreProgressSheet.jsp';
		document.breastHealth.submit();
	}

	function submitAction(cmd) {
		document.breastHealth.mode.value = cmd;
		<%if ("new".equals(mode)){%>
			save();
		<%}%>
		translateBR();
		getRecommendation();
		saveContent();
		document.getElementById('breastHealth').action = 'BreastHealth_jasper.jsp';
		document.breastHealth.submit();
	}

	function closeWindow(){
	    document.title="close";
	}


</script>
</html>