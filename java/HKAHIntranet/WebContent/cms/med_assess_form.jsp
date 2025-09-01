<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="javax.servlet.*,java.text.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%!
private ArrayList getIpMedicalNote(String regid) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT I.REGID, I.PATNO, ");
	sqlStr.append("P.PATFNAME||', '||P.PATGNAME AS PATNAME, P.PATCNAME, P.PATBDATE, P.PATSEX,");
	sqlStr.append("TO_CHAR(I.NOTE_DATE, 'DD/MM/YYYY HH24:MI'), I.CURR_CMPLT, I.PHY_EXAM, ");
	sqlStr.append("I.PHY_CVS_FLAG, I.PHY_RES_FLAG, I.PHY_CNS_FLAG, I.PHY_ABD_FLAG, ");
	sqlStr.append("I.PHY_TARGET_EXAM, I.PAST_HEALTH_FLAG, I.PAST_HEALTH, I.PSY_FLAG, I.PSY, "); 
	sqlStr.append("I.IMP, I.PLAN, I.DOCCODE, I.UPDATE_USER, I.UPDATE_DATE ");
	sqlStr.append("FROM IPD_DOCASSESS@CIS I, PATIENT@IWEB P ");
	sqlStr.append("WHERE I.PATNO = P.PATNO ");
	sqlStr.append("AND I.REGID = ? ");

	return UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{regid});		 
}
%>
<%
UserBean userBean = new UserBean(request);

String mode = request.getParameter("mode");
String regid = request.getParameter("regid");
String login = request.getParameter("login"); // doccode in CIS
if(login == null)
	login = request.getParameter("loginId"); // doccode in CMS
String loginName = request.getParameter("loginName");
String userRight = request.getParameter("userRight");
String sourceSystem = request.getParameter("sourceSystem");
String userRank = request.getParameter("userRank");
String userRankDesc = request.getParameter("userRankDesc");

Boolean isNurse = false;
if (ConstantsServerSide.isHKAH() && !"DR".equals(userRank)) {
	isNurse = true;
}

//get record
ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;

String noteDate = request.getParameter("noteDate");
String ipCC = request.getParameter("ipCC");
String ipPhyExam = request.getParameter("ipPhyExam");
String ipCvs = request.getParameter("ipCvs");
String ipRes = request.getParameter("ipRes");
String ipCns = request.getParameter("ipCns");
String ipAbd = request.getParameter("ipAbd");
String ipTargetExam = request.getParameter("ipTargetExam");
String ipPastHealthFlag = request.getParameter("ipPastHealthFlag");
String ipPastHealth = request.getParameter("ipPastHealth");
String ipPsyFlag = request.getParameter("ipPsyFlag");
String ipPsy = request.getParameter("ipPsy");
String ipImp = request.getParameter("ipImp");
String ipPlan = request.getParameter("ipPlan");
String doccode = request.getParameter("doccode");
String docname = request.getParameter("docname");

String alertLink = "";
record = AllergyDB.getSAAM();
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	alertLink = row.getValue(0);
}

record = getIpMedicalNote(regid);
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	
	regid = row.getValue(0);
	
	noteDate = row.getValue(6);
	ipCC = row.getValue(7);
	ipPhyExam = row.getValue(8);
	ipCvs = row.getValue(9);
	ipRes = row.getValue(10);
	ipCns = row.getValue(11);
	ipAbd = row.getValue(12);
	ipTargetExam = row.getValue(13);
	ipPastHealthFlag = row.getValue(14);
	ipPastHealth = row.getValue(15);
	ipPsyFlag = row.getValue(16);
	ipPsy = row.getValue(17);
	ipImp = row.getValue(18);
	ipPlan = row.getValue(19);
	doccode = row.getValue(20);
	docname = DoctorDB.getDoctorFullName(doccode);
	
}

if(noteDate != null && noteDate.length() > 0){
	if(mode != null && mode.length() > 0){
		
	}else{
		mode = "edit";
	}
}else{
	mode = "new";
}

if (noteDate == null) {
	noteDate = DateTimeUtil.getCurrentDateTimeWithoutSecond();
}

String patno = "";
String patfname = "";
String patgname = "";
String patcname = "";
String patsex = "";
String patbdate = "";
String patid = "";
String patreligion = "";

record = PatientDB.getPatInfoByRegid(regid);
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	patno = row.getValue(0);
}

record = PatientDB.getPatInfo(patno);
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	patno = row.getValue(0);
	patfname = row.getValue(11);
	patgname = row.getValue(12);
	patcname = row.getValue(4);
	patsex = row.getValue(1);
	patbdate = row.getValue(10);
	patid = row.getValue(2);
	patreligion = row.getValue(9);
}

request.setAttribute("reg_hist", PatientDB.getPatRegHist(patno, 5));

String temperature = "";
String weight = "";
String bp = "";
String bps = "";
String bpd = "";
String height = "";
String pulse = "";
String hc = "";
String rr = "";
String spo2 = "";
String psy = "";
JSONArray currentmed = new JSONArray();
String lmp = "";
String lmp1 = "";
String lmp2 = "";
String lmp3 = "";
String lmpType = "";
Double maxPain = 0.0;

String admissionData = PatientDB.getNisData("ADMISSION",regid);
if(admissionData.length()>0){
	JSONObject content = new JSONObject(admissionData);
	temperature = "null".equals(content.get("temperature").toString())?"":content.get("temperature").toString();
	weight = "null".equals(content.get("weight").toString())?"":content.get("weight").toString();
	bps = "null".equals(content.get("bps").toString())?"":content.get("bps").toString();
	bpd = "null".equals(content.get("bpd").toString())?"":content.get("bpd").toString();
	bp = bps + (bpd.length()>0?" / "+bpd:"");
	height = "null".equals(content.get("height").toString())?"":content.get("height").toString();
	pulse = "null".equals(content.get("pulse").toString())?"":content.get("pulse").toString();
	if(!content.isNull("hc"))
		hc = "null".equals(content.get("hc").toString())?"":content.get("hc").toString();
	rr = "null".equals(content.get("rr").toString())?"":content.get("rr").toString();
	spo2 = "null".equals(content.get("spo2").toString())?"":content.get("spo2").toString();
	psy = content.getJSONArray("psychosicalassmnt").join(",").replaceAll("\"","");
	currentmed = content.getJSONArray("currentmed");
	JSONObject lmpContent = content.getJSONObject("lmp");
	lmp1 = "null".equals(lmpContent.get("lmp1").toString())?"":lmpContent.get("lmp1").toString().replace(".0","");
	if(!lmpContent.isNull("lmp2"))
		lmp2 = "null".equals(lmpContent.get("lmp2").toString())?"":lmpContent.get("lmp2").toString().replace(".0","");
	if(!lmpContent.isNull("lmp3"))
		lmp3 = "null".equals(lmpContent.get("lmp3").toString())?"":lmpContent.get("lmp3").toString().replace(".0","");
	lmp = lmp1 + (lmp2.length()>0?"/"+lmp2:"") + (lmp3.length()>0?"/"+lmp3:"");
	lmp = "0/0/0".equals(lmp)|| "0/0".equals(lmp)|| "0".equals(lmp)?"":lmp;
	lmpType = lmpContent.getJSONArray("lType").join(",").replaceAll("\"","");
}
String fallRisk = PatientDB.getNisData("FallRisk",regid);
fallRisk = "NA".equals(fallRisk)?"":fallRisk;
String allPainData = PatientDB.getNisData("Pain",regid); //get max. score
if(allPainData.length()>0){
	JSONArray painData= new JSONArray(allPainData);
	for(int i=0; i<painData.length(); i++){ 
		JSONObject tmppain = painData.getJSONObject(i); 
		Double painScore = tmppain.getDouble("score");
		if(painScore>maxPain){
			maxPain = painScore;
		}
	}
}else{
	maxPain = -99.0;
}

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html>
<head>
<title>Medical Assessment Form</title>
<meta http-equiv="X-UA-Compatible" content="IE=9">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../css/w3.hkah.css" />
<link rel="stylesheet" type="text/css" href="../css/datepicker-ui.css" />

<script type="text/javascript" src="../js/jquery-1.5.1.min.js" /></script>
<script type="text/javascript" src="../js/datepicker.js" /></script>
<script type="text/javascript" src="../js/datepicker-ui.js" /></script>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<style type="text/css">
body{
	background-color: #F5F5F5;
}
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
#Content {
	padding: 0px 0px 50px 0px;
}


#Footer {
	position: fixed;
	width: 100%;
	bottom: 0; /* stick to bottom */
	background-color: #E6E6E6;
	border-top: 3px solid #D0D0D0;
	z-index: 2;
	left: 0;
	right: 0;
	height: 40px;
	text-align: right;
} 

.footerButton{
	background: silver;
	box-shadow:	inset -1px -1px #0a0a0a,
				inset 1px 1px #fff,
				inset -2px -2px grey,
				inset 2px 2px #dfdfdf;
}

.footerButton :disabled{
	color:grey;
	text-shadow:1px 1px 0 #fff;
}

table {
	width:100%;
	border-collapse: collapse;
}

#row1 {
	background-color:white;
	border-spacing: 0px;
}

#opHistory{
	border-right: 3px solid grey;
}

#opHistoryTable{
	background-color: #CBC;
}

#opHistoryList { 
	overflow-y: scroll; 
	height: 100px; 
	padding: 0px;
	background-color:white;
}

#opHistoryList thead th {
	position: sticky; 
	top: 0; 
	background:#eee; 
	text-align: left;
}

#opHistoryList tbody td { 
	padding: 2px;
}

#opContent{
	border-top: 3px solid grey;
}

#opDocNoteNo{
	opacity: 0.5;
}

#ipHistory{
	background-color: white;
}
#opContent textarea {
	background-color: #F5F5F5;
}

textarea {
	width:100%;
}

.noDisplay{
	display:none;
}

.gcTable span{
	text-decoration: underline;
}

.gcTable th, .gcTable td{
	text-align: left;
	padding-left: 4px;
	border: 1px solid grey;
}

.mnTable{
	border-collapse: collapse;
}

.mnTable td{
	padding: 8px 8px;
	border: 1px solid grey;
	vertical-align: top;
}

#ipPhyTable td{
	padding: 1px;
	border: 0px;
	vertical-align: top;
}

#noDocNote{
	margin-top: 10px;
}

</style>
<script type="text/javascript">
var mode = "<%=mode%>";
var opregid, opregdate;
var ipregid = "<%=regid%>";
var reportUrl = '';

window.onload = function() { 
	  var txts = document.getElementsByTagName('TEXTAREA'); 

	  for(var i = 0, l = txts.length; i < l; i++) {
	    if(/^[0-9]+$/.test(txts[i].getAttribute("maxlength"))) { 
	      var func = function() { 
	        var len = parseInt(this.getAttribute("maxlength"), 4000); 

	        if(this.value.length > len) { 
	          alert('Maximum length exceeded: ' + len); 
	          this.value = this.value.substr(0, len); 
	          return false; 
	        } 
	      };

	      txts[i].onkeyup = func;
	    } 
	  };

};
	
$(document).ready(function () {
	$("#row1 tbody tr").click(function(){
		getDocNote(this);
	});
<%	if(isNurse){ %>
	setReadOnly();
<%	} %>
});

$(document).keypress(function(e) {
	if (e.which == 13) { // 13 = "ENTER"
		//alert("click enter");
	} else {
		if(e.shiftKey){
			/* press shift + "t" */
			if((e.key == "t" || e.key == "T")){

			}
		}
	}
});

function alertLink(){
	window.open("<%=alertLink %>?patno=<%=patno %>&userRight=<%=userRight %>&sourceSystem=<%=sourceSystem %>&login=<%=login %>&loginName=<%=loginName %>&userRank=<%=userRank %>&userRankDesc=<%=userRankDesc %>");
}

function getDocNote(data){
	opregid = $.trim($(data).find(".regid").html());
	opregdate = $.trim($(data).find(".regdate").html());
	
	$.ajax({
        url: "med_opd_docnote.jsp",
        data: {	"regid" : opregid, 
        		"regdate" : opregdate },
        type: 'POST',
        dataType: 'html',
		cache: false,
        success: function(data){
        	$('#opContent').html(data);
        },
       	error: function(data){
       		alert ("Error!");
       	}
    });
}

function appendToCurrentNote(){
	if(opregid != null && opregid.length > 0){
		$("#ipCC").val($("#opCC").val()); 
		$("#ipPresentIllness").val($("#opCC").val()); 
		$("#ipPhyExam").val($("#opPhyExam").val()); 
		var opCVSval = $("input[name=opcvs]:checked").val();
		if(opCVSval != null && opCVSval.length > 0){
			if(opCVSval == "N" || opCVSval == "D" || opCVSval == "R" || opCVSval == "-"){
				$("#ipcvs" + opCVSval).prop("checked",true);	
			}else {
				$("input[name=ipcvs]").prop("checked",false);
			}
		}else{
			$("input[name=ipcvs]").prop("checked",false);
		}
		var opRESval = $("input[name=opres]:checked").val();
		if(opRESval != null && opRESval.length > 0){
			if(opRESval == "N" || opRESval == "D" || opRESval == "R" || opRESval == "-"){
				$("#ipres" + opRESval).prop("checked",true);	
			}else {
				$("input[name=ipres]").prop("checked",false);
			}
		}else{
			$("input[name=ipres]").prop("checked",false);
		}
		var opCNSval = $("input[name=opcns]:checked").val();
		if(opCNSval != null && opCNSval.length > 0){
			if(opCNSval == "N" || opCNSval == "D" || opCNSval == "R" || opCNSval == "-"){
				$("#ipcns" + opCNSval).prop("checked",true);	
			}else {
				$("input[name=ipcns]").prop("checked",false);
			}
		}else{
			$("input[name=ipcns]").prop("checked",false);
		}
		var opABDval = $("input[name=opabd]:checked").val();
		if(opABDval != null && opABDval.length > 0){
			if(opABDval == "N" || opABDval == "D" || opABDval == "R" || opABDval == "-"){
				$("#ipabd" + opABDval).prop("checked",true);	
			}else {
				$("input[name=ipabd]").prop("checked",false);
			}
		}else{
			$("input[name=ipabd]").prop("checked",false);
		}
//		var opPHval = $("input[name=opPastHealth]:checked").val();
//		if(opPHval != null && opPHval.length > 0){
//			$("#ipPastHealth"+opPHval).prop("checked",true);	
//		}else{
//			$("input[name=ipPastHealthFlag]").prop("checked",false);
//		}
//		$("#ipPastHealth").val($("#opPastHealth").val());
		$("#ipTargetExam").val($("#opTargetExam").val());
		$("#ipImp").val($("#opImp").val());
		$("#ipPlan").val($("#opPlan").val());
	}
}

function undo(){
	$("#ipMedicalNote textarea").val("");
	$("#ipMedicalNote input").val("");
	$("#ipMedicalNote input:radio").prop("checked",false);
}

function saveAction(action, next){	
	var patno = $("#patno").val();
	var ipCC = $("#ipCC").val()==null?"":handleSymbol($("#ipCC").val());
	var ipPhyExam = $("#ipPhyExam").val()==null?"":handleSymbol($("#ipPhyExam").val());
	var ipCvs = $("input[name=ipcvs]:checked").val()==null?"N":$("input[name=ipcvs]:checked").val();
	var ipRes = $("input[name=ipres]:checked").val()==null?"N":$("input[name=ipres]:checked").val();
	var ipCns = $("input[name=ipcns]:checked").val()==null?"N":$("input[name=ipcns]:checked").val();
	var ipAbd = $("input[name=ipabd]:checked").val()==null?"N":$("input[name=ipabd]:checked").val();
	var ipTargetExam = $("#ipTargetExam").val()==null?"":handleSymbol($("#ipTargetExam").val());
	var ipPastHealthFlag = $("input[name=ipPastHealthFlag]:checked").val();
	var ipPastHealth = $("#ipPastHealth").val()==null?"":handleSymbol($("#ipPastHealth").val());
	var ipPsyFlag = $("input[name=ipPsyFlag]:checked").val();
	var ipPsy = $("#ipPsy").val()==null?"":handleSymbol($("#ipPsy").val());
	var ipImp = $("#ipImp").val()==null?"":handleSymbol($("#ipImp").val());
	var ipPlan = $("#ipPlan").val()==null?"":handleSymbol($("#ipPlan").val());
	var doccode = "<%=login %>";
	var login = "<%=login%>";
	if (ipPastHealthFlag == null){
		if(ipPastHealth.length > 0){
			alert("Coloumn Past Health History must be select.");
			return false;	
		}else{
			ipPastHealthFlag = "N";
		}	
	}
	if (ipPsyFlag == null){
		if(ipPsy.length > 0){
			alert("Coloumn Psychosocial History must be select.");
			return false;	
		}else{
			ipPsyFlag = "N";
		}	
	}
	if(	ipCC.length > 4000 || ipPhyExam.length > 4000 ||  
		ipPsy.length > 4000 || ipImp.length > 4000 || ipPlan.length > 4000){
		alert("Max. length of the input field is 4000");
		return false;
	}
	$.ajax({
        url: "med_assess_form_ajax.jsp",
        data: "action=" + action + 
        		"&regid=" + ipregid + 
        		"&patno=" + patno + 
        		"&ipCC=" + ipCC + 
        		"&ipPhyExam=" + ipPhyExam + 
        		"&ipCvs=" + ipCvs + 
        		"&ipRes=" + ipRes + 
        		"&ipCns=" + ipCns + 
        		"&ipAbd=" + ipAbd + 
        		"&ipTargetExam=" + ipTargetExam + 
        		"&ipPastHealthFlag=" + ipPastHealthFlag + 
        		"&ipPastHealth=" + ipPastHealth + 
        		"&ipPsyFlag=" + ipPsyFlag + 
        		"&ipPsy=" + ipPsy + 
        		"&ipImp=" + ipImp + 
        		"&ipPlan=" + ipPlan + 
        		"&doccode=" + doccode + 
        		"&login=" + login,
       	type: 'POST',
        dataType: 'html',
   		cache: false,
        success: function(data){
        	if(data){
        		if(next == "print"){
            		print(ipregid);
            	}else if(next == "close"){
        			window.open('', '_self', ''); 
            		window.close();
            	}else{
            		location.reload();
            	}
        	}else{
        		alert("Medical notes save error.");
        	}
        },
       	error: function(data){
       		alert ("Error!");
       	}
    });
	
}

function print(regid){
	$.ajax({
		type: "POST",
		url: "med_assess_form_ajax.jsp",
		data: "action=print&regid="+regid,
		success: function(values) {
			if (values != '') {
				//open in browser
				window.location.href = "med_assess_form_ajax.jsp?action=print&regid="+regid;
				//auto print using NHSClientApp.exe
				/*
				window.location.href = reportUrl + values + '.pdf';
				location.reload();
				*/
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
			reportUrl = 'NHSClientApp:' + printer + ':' + newUrl.substring(0, index) + '/report/';
		}
	}
}

getNativeCallUrl();

function handleSymbol(txt){
	return txt.replace(/%/g,"%25").replace(/&/g,"%26");
}

function printOnly(){
	var patno = $("#patno").val();
	var noteDate = "<%=noteDate %>";
	var ipCC = $("#ipCC").val()==null?"":handleSymbol($("#ipCC").val());
	var ipPhyExam = $("#ipPhyExam").val()==null?"":handleSymbol($("#ipPhyExam").val());
	var ipCvs = $("input[name=ipcvs]:checked").val()==null?"N":$("input[name=ipcvs]:checked").val();
	var ipRes = $("input[name=ipres]:checked").val()==null?"N":$("input[name=ipres]:checked").val();
	var ipCns = $("input[name=ipcns]:checked").val()==null?"N":$("input[name=ipcns]:checked").val();
	var ipAbd = $("input[name=ipabd]:checked").val()==null?"N":$("input[name=ipabd]:checked").val();
	var ipTargetExam = $("#ipTargetExam").val()==null?"":handleSymbol($("#ipTargetExam").val());
	var ipPastHealthFlag = $("input[name=ipPastHealthFlag]:checked").val();
	var ipPastHealth = $("#ipPastHealth").val()==null?"":handleSymbol($("#ipPastHealth").val());
	var ipPsyFlag = $("input[name=ipPsyFlag]:checked").val();
	var ipPsy = $("#ipPsy").val()==null?"":handleSymbol($("#ipPsy").val());
	var ipImp = $("#ipImp").val()==null?"":handleSymbol($("#ipImp").val());
	var ipPlan = $("#ipPlan").val()==null?"":handleSymbol($("#ipPlan").val());
	var doccode = "<%=login %>";
	var login = "<%=login%>";
	
	window.location.href = "med_assess_form_ajax.jsp" + 
    		"?action=printOnly" +  
    		"&regid=" + ipregid + 
    		"&patno=" + patno + 
    		"&noteDate=" + noteDate + 
    		"&ipCC=" + ipCC + 
    		"&ipPhyExam=" + ipPhyExam + 
    		"&ipCvs=" + ipCvs + 
    		"&ipRes=" + ipRes + 
    		"&ipCns=" + ipCns + 
    		"&ipAbd=" + ipAbd + 
    		"&ipTargetExam=" + ipTargetExam + 
    		"&ipPsyFlag=" + ipPsyFlag + 
    		"&ipPsy=" + ipPsy + 
    		"&ipImp=" + ipImp + 
    		"&ipPlan=" + ipPlan + 
    		"&doccode=" + doccode + 
    		"&login=" + login;
}

function setReadOnly(){
	$("input[type=radio]").prop("disabled", true);
	$("textarea").prop("readonly",true);
}
</script>
</head>
<body class="w3-small">
<div id="Header" class="w3-container w3-display-container ah-pink">
	<div class="leftbuttom w3-container">
	</div>
	<div id="patInfo" class="w3-container w3-center">
		<table height="100%">
			<tr>
				<td class="infoLabel" width="8%">Patient No:</td>
				<td class="infoData" width="16%"><input type="text" name="patno" id="patno" value="<%=patno %>" readonly/></td>
				<td class="infoLabel" width="8%">First Name: </td>
				<td class="infoData" width="16%"><input type="text" name="patfname" id="patfname" value="<%=patfname %>" readonly/></td>
				<td class="infoLabel" width="8%">Given Name: </td>
				<td class="infoData" width="16%"><input type="text" name="patgname" id="patgname" value="<%=patgname %>" readonly/></td>
				<td class="infoLabel" width="8%">Chinese Name:</td>
				<td class="infoData" width="16%"><input type="text" name="patcname" id="patcname" value="<%=patcname %>" readonly/></td>
				<!-- <td class="infoLabel" width="4%" rowspan="2"><button id="allergyButton" class="w3-button w3-round-large" style="color: black;" onclick="alertLink()">Allergy</button></td> -->
			</tr>
			<tr>
				<td class="infoLabel" width="8%">Gender: </td>
				<td class="infoData" width="16%"><input type="text" name="patsex" id="patsex" value="<%=patsex %>" readonly/></td>
				<td class="infoLabel" width="8%">Birth Date: </td>
				<td class="infoData" width="16%"><input type="text" name=patbdate id="patbdate" value="<%=patbdate %>" readonly/></td>
				<td class="infoLabel" width="8%">ID No: </td>
				<td class="infoData" width="16%"><input type="text" name="patid" id="patid" value="<%=patid %>" readonly/></td>
				<td class="infoLabel" width="8%">Religion:</td>
				<td class="infoData" width="16%"><input type="text" name="patreligion" id="patreligion" value="<%=patreligion %>" readonly/></td>
			</tr>
		</table>
	</div>
	<div  class="righttop w3-container w3-tiny">
	</div>
</div>

<!-- index page -->
<div id="Content" class="w3-container">
	<div class="w3-cell-row">
		<div id="opHistory" class="w3-cell" style="width:45%">
		  	<div id="opHistoryTable" class="w3-container">
		  	<span class="w3-large">Registration History</span><br/>
			  	<div id="opHistoryList" class="" >
				  	<display:table id="row1" name="reg_hist" export="false" class="w3-hoverable tablesorter">
				  	 	<display:setProperty name="basic.msg.empty_list" value="" />
				  		<display:column media="html" title="Regid" headerClass="noDisplay" style="width:0%" property="fields2" class="regid noDisplay"/>
						<display:column media="html" title="Reg. Date" style="width:25%" property="fields4" class="regdate"/>
						<display:column media="html" title="Type" style="width:20%" property="fields5" />
						<display:column media="html" title="Category" style="width:20%" property="fields6" />
						<display:column media="html" title="Doctor" style="width:28%" property="fields7" />
						<display:column media="html" title="Splty" style="width:7%" property="fields8" />
					</display:table>
				</div>
				<br/>
		  	</div>
		  	<div id="opContent" class="w3-container w3-display-container">
		  		<span class="w3-large">Doctor Note</span><br/>
			  	<div id="opDocNoteTemp" class="">
					Reg. Date: <span id="regdate"></span><br/>
					<br/>
					<label style="font-weight: bold;">Chief Complaint / Present Illness / Past Health / Social and Family History: </label><br/>
						<textarea id="opCC" rows="4" readonly></textarea>
					<label style="font-weight: bold;">Physical Examination: </label><br/>
						<textarea id="opPhyExam" rows="3" readonly></textarea><br/> 
						<table>
							<tr>
								<td style="text-decoration: underline; width:25%;">CVS: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
								<td><input type="radio" id="" name="opcvs" value="-" disabled> Irrelevant </td>
<%	} %>
								<td><input type="radio" id="" name="opcvs" value="N" disabled> No Significant Finding </td>
								<td><input type="radio" id="" name="opcvs" value="R" disabled> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
								<td><input type="radio" id="" name="opcvs" value="D" disabled> Decline </td>
							</tr>
							<tr>
								<td style="text-decoration: underline;">Respiratory: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
								<td><input type="radio" id="" name="opres" value="-" disabled> Irrelevant </td>
<%	} %>
								<td><input type="radio" id="" name="opres" value="N" disabled> No Significant Finding </td>
								<td><input type="radio" id="" name="opres" value="R" disabled> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
								<td><input type="radio" id="" name="opres" value="D" disabled> Decline </td>
							</tr>
							<tr>
								<td style="text-decoration: underline;">CNS: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
								<td><input type="radio" id="" name="opcns" value="-" disabled> Irrelevant </td>
<%	} %>								
								<td><input type="radio" id="" name="opcns" value="N" disabled> No Significant Finding </td>
								<td><input type="radio" id="" name="opcns" value="R" disabled> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
								<td><input type="radio" id="" name="opcns" value="D" disabled> Decline </td>
							</tr>
<%	if (ConstantsServerSide.isTWAH()) { %>							
							<tr>
								<td style="text-decoration: underline;">Abdomen: </td>
								<td><input type="radio" id="" name="opabd" value="N" disabled> No Significant Finding </td>
								<td><input type="radio" id="" name="opabd" value="R" disabled> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
								<td><input type="radio" id="" name="opabd" value="D" disabled> Decline </td>
							</tr>
<%	} %>
<%	if (ConstantsServerSide.isHKAH()) { %>
							<tr>
								<td style="vertical-align: top;text-decoration: underline;">Targeted Examination: </td>
								<td colspan="3"><textarea id="opTargetExam" rows="2" readonly></textarea></td>
							</tr>
<%	} %>
						</table>
<!-- 
					<label style="font-weight: bold;">Past Health: </label><br/>
		 				<input type="radio" id="gdPastHealth" name="opPastHealth" value="N" disabled> No significant
		 				<input type="radio" id="referTarget" name="opPastHealth" value="R" disabled> Refer to Physical Examination <br/>
						<textarea id="opPastHealth" rows="3" readonly></textarea>
-->
					<label style="font-weight: bold;">Impression / Diagnosis: </label><br/>
						<textarea id="opImp" rows="3" readonly></textarea>
					<label style="font-weight: bold;">Medical Care Plan: </label><br/>
						<textarea id="opPlan" rows="3" readonly></textarea>
				</div>
		  	</div>
		</div>
		
		<div id="ipHistory" class="w3-cell" style="width:55%">
		 	<div id="generalCondition" class="w3-container">
		 		<span class="w3-large">Patient's General Condition</span>
			 	<table id="gcTable" class="gcTable">
			 		<tr>
			 			<td class="infoData" width="33%">Temperature (<sup>o</sup>C): <span><%=temperature %></span></td>
			 			<td class="infoData" width="33%">Weight (kg): <span><%=weight%></span></td>
			 			<td class="infoData" width="33%">Pain score: <span><%=maxPain == -99.0?"":maxPain+"/10" %></span></td>
			 		</tr>	
			 		<tr>
			 			<td class="infoData" width="33%">BP (mmHg): <span><%=bp %></span></td>
			 			<td class="infoData" width="33%">Height (cm): <span><%=height %></span></td>
			 			<td class="infoData" width="33%">Fall risk: <span><%=fallRisk %></span></td>
			 		</tr>
			 		<tr>
			 			<td class="infoData" width="33%">P (/min): <span><%=pulse %></span></td>
			 			<td class="infoData" width="33%">HC (cm): <span><%=hc %></span></td>
			 			<td class="infoData" width="33%">Phychosocial Assessment: <span><%=psy %></span></td>
			 		</tr>
			 		<tr>
			 			<td class="infoData" width="33%">RR (/min): <span><%=rr %></span></td>
			 			<td class="infoData" width="33%">LMP: <span><%=lmp %></span>
			 				<%=lmpType.length()>0?"<br>Type: <span>"+lmpType+"</span>":"" %>
			 			</td>
			 			<td class="infoData" width="33%">&nbsp;</td>
			 		</tr>
			 		<tr>
			 			<td class="infoData" width="33%">SaO<sub>2</sub> (%): <span><%=spo2 %></span></td>
			 			<td class="infoData" width="33%">&nbsp;</td>
			 			<td class="infoData" width="33%">&nbsp;</td>
			 		</tr>
			 		<tr>
			 			<td colspan=3>Current Medication: 
			 	<%if (currentmed.length()>0){ %>
			 				<table>
			 				<tr>
			 					<th>Medicine Name</th>
			 					<th>Dose</th>
			 					<th>Freq.</th>
			 					<th>Route</th>
			 					<th>Last Dose</th>
			 				<tr>
					<%for(int i=0; i<currentmed.length(); i++){ 
						JSONObject tmpMed = currentmed.getJSONObject(i); %>
		 					<tr>
		 						<td><%="null".equals(tmpMed.get("name").toString())?"":tmpMed.get("name").toString() %></td>
		 						<td><%="null".equals(tmpMed.get("dose").toString())?"":tmpMed.get("dose").toString() %></td>
		 						<td><%="null".equals(tmpMed.get("freq").toString())?"":tmpMed.get("freq").toString() %></td>
		 						<td><%="null".equals(tmpMed.get("route").toString())?"":tmpMed.get("route").toString() %></td>
		 						<td><%="null".equals(tmpMed.get("lastDose").toString())?"":tmpMed.get("lastDose").toString() %></td>
		 					</tr>
			 		<%} %>
			 				</table>
			 	<%} %>
			 			</td>
			 		</tr>
			 	</table>
		 	</div>
		 	
		 	<div id="ipMedicalNote" class="w3-container">
		 	<br/>
		 	<span class="w3-large">Medical Notes</span><br/>
		 	<span>Assessment Date: <%=noteDate==null?"":noteDate %></span>
		 	<br/><br/>
		 	<table class="mnTable">
		 		<tr>
		 			<td colspan=2>
		 				<label style="font-weight: bold;">Chief Complaint / Present Illness / Past Health / Social and Family History: </label><br/> 
		 				<textarea id="ipCC" rows="4" maxlength="4000"><%=ipCC==null?"":ipCC %></textarea>
		 			</td>
		 		</tr>
		 		<tr>
		 			<td colspan=2>
		 				<label style="font-weight: bold;">Physical Examination: </label><br/> 
		 				<textarea id="ipPhyExam" rows="3" maxlength="4000"><%=ipPhyExam==null?"":ipPhyExam%></textarea><br/>
		 				<table id="ipPhyTable">
							<tr>
								<td style="text-decoration: underline; width:25%;">CVS: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
								<td><input type="radio" id="ipcvs-" name="ipcvs" value="-" <%if ("-".equals(ipCvs)){ %>checked<%} %>> Irrelevant </td>
<%	} %>
								<td><input type="radio" id="ipcvsN" name="ipcvs" value="N" <%if ("N".equals(ipCvs)){ %>checked<%} %>> No Significant Finding </td>
								<td><input type="radio" id="ipcvsR" name="ipcvs" value="R" <%if ("R".equals(ipCvs)){ %>checked<%} %>> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
								<td><input type="radio" id="ipcvsD" name="ipcvs" value="D" <%if ("D".equals(ipCvs)){ %>checked<%} %>> Decline </td>
							</tr>
							<tr>
								<td style="text-decoration: underline;">Respiratory: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
								<td><input type="radio" id="ipres-" name="ipres" value="-" <%if ("-".equals(ipRes)){ %>checked<%} %>> Irrelevant </td>
<%	} %>	
								<td><input type="radio" id="ipresN" name="ipres" value="N" <%if ("N".equals(ipRes)){ %>checked<%} %>> No Significant Finding </td>
								<td><input type="radio" id="ipresR" name="ipres" value="R" <%if ("R".equals(ipRes)){ %>checked<%} %>> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
								<td><input type="radio" id="ipresD" name="ipres" value="D" <%if ("D".equals(ipRes)){ %>checked<%} %>> Decline </td>
							</tr>
							<tr>
								<td style="text-decoration: underline;">CNS: </td>
<%	if (ConstantsServerSide.isHKAH()) { %>
								<td><input type="radio" id="ipcns-" name="ipcns" value="-" <%if ("-".equals(ipCns)){ %>checked<%} %>> Irrelevant </td>
<%	} %>	
								<td><input type="radio" id="ipcnsN" name="ipcns" value="N" <%if ("N".equals(ipCns)){ %>checked<%} %>> No Significant Finding </td>
								<td><input type="radio" id="ipcnsR" name="ipcns" value="R" <%if ("R".equals(ipCns)){ %>checked<%} %>> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
								<td><input type="radio" id="ipcnsD" name="ipcns" value="D" <%if ("D".equals(ipCns)){ %>checked<%} %>> Decline </td>
							</tr>
<%	if (ConstantsServerSide.isTWAH()) { %>	
							<tr>
								<td style="text-decoration: underline;">Abdomen: </td>
								<td><input type="radio" id="ipabdN" name="ipabd" value="N" <%if ("N".equals(ipAbd)){ %>checked<%} %>> No Significant Finding </td>
								<td><input type="radio" id="ipabdR" name="ipabd" value="R" <%if ("R".equals(ipAbd)){ %>checked<%} %>> Refer to <%=ConstantsServerSide.isHKAH()?"Target":"Physical" %> Exam </td>
								<td><input type="radio" id="ipabdD" name="ipabd" value="D" <%if ("D".equals(ipAbd)){ %>checked<%} %>> Decline </td>
							</tr>
<%	} %>
<%	if (ConstantsServerSide.isHKAH()) { %>	
							<tr>
								<td style="vertical-align: top;text-decoration: underline;">Targeted Examination: </td>
								<td colspan="3"><textarea id="ipTargetExam" rows="2"><%=ipTargetExam==null?"":ipTargetExam%></textarea></td>
							</tr>
<%	} %>
						</table>
		 			</td>
		 		</tr>
		 		<tr>
<%	if (ConstantsServerSide.isHKAH()) { %>			 		
		 			<td style="width:50%">
		 				<label style="font-weight: bold;">Past Health History:</label><br/>
		 				<input type="radio" id="ipPastHealthN" name="ipPastHealthFlag" value="N" <%if ("N".equals(ipPastHealthFlag)){ %>checked<%} %>> No significant<br/>
		 				<input type="radio" id="ipPastHealthR" name="ipPastHealthFlag" value="R" <%if ("R".equals(ipPastHealthFlag)){ %>checked<%} %>> Refer to Targeted Exam
		 				<textarea id="ipPastHealth" rows="3" maxlength="4000"><%=ipPastHealth==null?"":ipPastHealth%></textarea>
		 			</td>
<%	} %>	 			
		 			<td <%=ConstantsServerSide.isHKAH()?"style=\"width:50%\"":"colspan=2" %>>
		 				<label style="font-weight: bold;">Psychosocial History: </label><br/> 
		 				<input type="radio" id="ipPsyFlagN" name="ipPsyFlag" value="N" <%if ("N".equals(ipPsyFlag)){ %>checked<%} %>> No significant<br/>
		 				<input type="radio" id="ipPsyFlagR" name="ipPsyFlag" value="R" <%if ("R".equals(ipPsyFlag)){ %>checked<%} %>> 
		 				<%=ConstantsServerSide.isHKAH()?"Refer to Targeted Exam":"Refer to Physical Examination" %>
		 				<textarea id="ipPsy" rows="3" maxlength="4000"><%=ipPsy==null?"":ipPsy%></textarea>
		 			</td>
		 		</tr>
		 		<tr>
		 			<td>
		 				<label style="font-weight: bold;">Impression / Diagnosis: </label><br/> 
		 				<textarea id="ipImp" rows="3" maxlength="4000"><%=ipImp==null?"":ipImp%></textarea>
		 			</td>
		 			<td>
			 			<label style="font-weight: bold;">Medical Care Plan: </label><br/> 
			 			<textarea id="ipPlan" rows="3" maxlength="4000"><%=ipPlan==null?"":ipPlan%></textarea>
		 			</td>
		 		</tr>
		 	</table>
		 	</div>
		</div>
	</div>	
</div>

<div id="Footer" class="w3-container" id="Footer">
	<div class="w3-cell-row" >
		<div class="w3-container w3-col" style="width:45%;" >
			<input type="button" id="appendToCurrentNote" class="w3-button footerButton" value="Append To Current Notes" onclick="appendToCurrentNote()">
			<input type="button" id="undo" class="w3-button footerButton" value="Undo" onclick="undo()">
		</div>
<%if(isNurse){ %>
		<div class="w3-container w3-col" style="width:55%;" >
			<input type="button" class="w3-button footerButton" value="Print Only" onclick="printOnly()">
		</div>
<%} else { %>
<%	if("new".equals(mode)){ %>
		<div class="w3-container w3-col" style="width:55%;" >
			<input type="button" class="w3-button footerButton" value="Save and Finish" onclick="saveAction('saveNote', 'print')">
		</div>
<%	} else if("edit".equals(mode)){%>
		<div class="w3-container w3-col" style="width:55%;" >
			<input type="button" class="w3-button footerButton" value="Save and Finish" onclick="saveAction('updateNote', 'print')">
		</div>
<%	} %>
<%} %>
  	</div>
</div>

<!-- Modal -->
<div id="newPopup" class="w3-modal">
	<div class="w3-modal-content">
	</div>
</div>
</body>
</html>