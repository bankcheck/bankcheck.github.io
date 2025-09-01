<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%
ArrayList result = null;
String systemLogin = ParserUtil.getParameter(request, "systemLogin");
String sourceSystem = ParserUtil.getParameter(request, "sourceSystem");

// User Information
String login = ParserUtil.getParameter(request, "login");
String loginName = ParserUtil.getParameter(request, "loginName");
String userRank = ParserUtil.getParameter(request, "userRank");
String userRankDesc = ParserUtil.getParameter(request, "userRankDesc");
String userRight = ParserUtil.getParameter(request, "userRight");
String hospitalCode = ParserUtil.getParameter(request, "hospitalCode");
String hospitalName = ParserUtil.getParameter(request, "hospitalName");
String actionCode = ParserUtil.getParameter(request, "actionCode");

// Patient Information
String mrnDisplayLabelP = ParserUtil.getParameter(request, "mrnDisplayLabelP");
String mrnDisplayLabelE = ParserUtil.getParameter(request, "mrnDisplayLabelE");
String mrnDisplayType = ParserUtil.getParameter(request, "mrnDisplayType");
String hkid = ParserUtil.getParameter(request, "hkid");
String mrnPatientIdentity = ParserUtil.getParameter(request, "mrnPatientIdentity");
String mrnPatientEncounterNo = ParserUtil.getParameter(request, "mrnPatientEncounterNo");
String patientEhrNo = ParserUtil.getParameter(request, "patientEhrNo");
String doctype = ParserUtil.getParameter(request, "doctype");
String docnum = ParserUtil.getParameter(request, "docnum");
String nation = ParserUtil.getParameter(request, "nation");
String engSurName = ParserUtil.getParameter(request, "engSurName");
String engGivenName = ParserUtil.getParameter(request, "engGivenName");
String chiName = ParserUtil.getParameter(request, "chiName");
String oname = ParserUtil.getParameter(request, "oname");
String sex = ParserUtil.getParameter(request, "sex");
String dob = ParserUtil.getParameter(request, "dob");
String age = ParserUtil.getParameter(request, "age");
String deathDate = ParserUtil.getParameter(request, "deathDate");
String marital = ParserUtil.getParameter(request, "marital");
String religion = ParserUtil.getParameter(request, "religion");
String phoneH = ParserUtil.getParameter(request, "phoneH");
String phoneM = ParserUtil.getParameter(request, "phoneM");
String phoneOf = ParserUtil.getParameter(request, "phoneOf");
String phoneOt = ParserUtil.getParameter(request, "phoneOt");
String residentialAddress = ParserUtil.getParameter(request, "residentialAddress");
String photoContent = ParserUtil.getParameter(request, "photoContent");
String photoContentType = ParserUtil.getParameter(request, "photoContentType");

// Patient Admission Information
String admD = ParserUtil.getParameter(request, "admD");
String disD = ParserUtil.getParameter(request, "disD");
String attdoc = ParserUtil.getParameter(request, "attdoc");
String condoc = ParserUtil.getParameter(request, "condoc");
String spec = ParserUtil.getParameter(request, "spec");
String classNum = ParserUtil.getParameter(request, "classNum");
String ward = ParserUtil.getParameter(request, "ward");
String bed = ParserUtil.getParameter(request, "bed");
String details = ParserUtil.getParameter(request, "details");

String step = ParserUtil.getParameter(request, "step");

String type = ParserUtil.getParameter(request, "type");
String code = ParserUtil.getParameter(request, "code");
String desc = ParserUtil.getParameter(request, "desc");
String reaction = ParserUtil.getParameter(request, "reaction");
String remarks = ParserUtil.getParameter(request, "remarks");

ArrayList allergyTypeCode = new ArrayList();
ArrayList allergyTypeName = new ArrayList();
ArrayList severityCode = new ArrayList();
ArrayList severityName = new ArrayList();

if (step == null || step.isEmpty()){
	step= "0";
}
Boolean success = false;

if("0".equals(step)){
	// check allgery
	
	
}else if("1".equals(step)){
	success = AllergyDB.add(mrnPatientIdentity, type, code, desc, reaction, remarks, login, sourceSystem); 
	step = "0";
}

// GET ALLERGY TYPE 
result = AllergyDB.getAllergyType();
if (result.size() > 0) {
	for (int i=0; i<result.size(); i++){
		ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
		allergyTypeCode.add(reportableListObject.getValue(0));
		allergyTypeName.add(reportableListObject.getValue(1));
	}
} 

result = AllergyDB.getAllergySeverity();
if (result.size() > 0) {
	for (int i=0; i<result.size(); i++){
		ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
		severityCode.add(reportableListObject.getValue(0));
		severityName.add(reportableListObject.getValue(1));
	}
} 


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge">
<meta http-equiv="Pragma" content="no-cache"> 
<meta http-equiv="Cache-Control" content="no-cache"> 
<meta http-equiv="Expires" content="0">
<style>
body{
	margin:0;
	font-size: 15px;
	font-family: arial, verdana, sans-serif;
	background-color: ;
}
.button{
    margin: 10px;
	text-align: right;
}
allergyType{
	height: 100px;
}
.title{
	width: 100%;
	font-size: 19px;
    font-weight: bold;
	color: white;
	background-color: rgb(79,129,189);
	line-height: 28px;
    padding: 5px 3px 4px 5px;
	
}
.subtitle{
	width: 100%;
	font-size: 16px;
    font-weight: bold;
    text-decoration: underline;
	color: rgb(21,66,139);
	background-color: rgb(225,225,225);
	line-height: 20px;
    padding: 5px 3px 4px 5px;
}

</style>
<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
<%	if (success){%>
		alert("New record saved.");
		viewReload();
		parent.parent.title.location.reload();
<%	}%>
<%	if ("0".equals(step)){%>
		var userRank = "<%=userRank %>";
		if(userRank == "DR"){
			disableField();
		}
<%		if (AllergyDB.getNKDA(mrnPatientIdentity)) { %>
			disableField();
<%		} else {
			int localSize= AllergyDB.getAllergyRecord(mrnPatientIdentity,"A", null).size();
			int ehrSize = AllergyDB.getEHRrecord(mrnPatientIdentity).size();
			if(localSize > 0 || ehrSize > 0){ %>
				$("#N").prop("disabled",true);
<%			}%>
			showAllergy("O");//set default;
			$("#O").prop("checked", true);
			$("#desc").attr("disabled", "disabled");
			$("#reaction").hide();
<%		}
	}else{ %>
		showAllergy("O");//set default;
		$("#O").prop("checked", true);
		$("#desc").attr("disabled", "disabled");
		$("#reaction").hide();
<%	}%>
});

function viewReload(){
	url = "allergy_view.jsp?";

	url += "systemLogin=<%=systemLogin%>&";
	url += "sourceSystem=<%=sourceSystem%>&";

	// User Information
	url += "login=<%=login%>&";
	url += "loginName=<%=loginName%>&";
	url += "userRank=<%=userRank%>&";
	url += "userRankDesc=<%=userRankDesc%>&";
	url += "userRight=<%=userRight%>&";
	url += "hospitalCode=<%=hospitalCode%>&";
	url += "hospitalName=<%=hospitalName%>&";
	url += "actionCode=<%=actionCode%>&";

	// Patient Information
	url += "mrnDisplayLabelP=<%=mrnDisplayLabelP%>&";
	url += "mrnDisplayLabelE=<%=mrnDisplayLabelE%>&";
	url += "mrnDisplayType=<%=mrnDisplayType%>&";
	url += "hkid=<%=hkid%>&";
	url += "mrnPatientIdentity=<%=mrnPatientIdentity%>&";
	url += "mrnPatientEncounterNo=<%=mrnPatientEncounterNo%>&";
	url += "patientEhrNo=<%=patientEhrNo%>&";
	url += "doctype=<%=doctype%>&";
	url += "docnum=<%=docnum%>&";
	url += "nation=<%=nation%>&";
	url += "engSurName=<%=engSurName%>&";
	url += "engGivenName=<%=engGivenName%>&";
	url += "chiName=<%=chiName%>&";
	url += "oname=<%=oname%>&";
	url += "sex=<%=sex%>&";
	url += "dob=<%=dob%>&";
	url += "age=<%=age%>&";
	url += "deathDate=<%=deathDate%>&";
	url += "marital=<%=marital%>&";
	url += "religion=<%=religion%>&";
	url += "phoneH=<%=phoneH%>&";
	url += "phoneM=<%=phoneM%>&";
	url += "phoneOf=<%=phoneOf%>&";
	url += "phoneOt=<%=phoneOt%>&";
	url += "residentialAddress=<%=residentialAddress%>&";
	url += "photoContent=<%=photoContent%>&";
	url += "photoContentType=<%=photoContentType%>&";

	// Patient Admission Information
	url += "admD=<%=admD%>&";
	url += "disD=<%=disD%>&";
	url += "attdoc=<%=attdoc%>&";
	url += "condoc=<%=condoc%>&";
	url += "spec=<%=spec%>&";
	url += "classNum=<%=classNum%>&";
	url += "ward=<%=ward%>&";
	url += "bed=<%=bed%>&";
	url += "details=<%=details%>&";
	
	window.parent.content_delete.location.href = url;
}

function disableField(){
	$("input").prop('disabled', true);
	 $("#remarks").attr("disabled", "disabled");
	 $("#reaction").hide();
}

function showDesc(){
	var selectValue = $('input:radio.allergy:checked').val();
	selectValue = selectValue.substring(1);
	if (selectValue == "000"){
		$("#desc").removeAttr("disabled");
	}else{
		 $("#desc").val("");
		 $("#desc").attr("disabled", "disabled"); 
	}
}

function showAllergy(allergyType){
	$.ajax({
        url: "/intranet/GetAllergy",
        data: {"allergyType" : allergyType},
        type: 'POST',
        dataType: 'html',
		cache: false,
        success: function(data){
        	$('#allergyName').html(data);
        },
       	error: function(data){
       		console.log(data);
       	}
    });
	if (allergyType == "N"){
	     $("#remarks").val("");
	     $("#desc").val("");
	     $("#remarks").attr("disabled", "disabled");
	     $("#desc").attr("disabled", "disabled"); 
	     $(".allergy").attr("disabled", "disabled"); 
	}else if(allergyType == "D"){
		$("#reaction").show();
	}else{
		$("#reaction").hide();
		$(".allergy").removeAttr("disabled");
        $("#remarks").removeAttr("disabled");
        
	}
}

function submitAction(step){
	if ($('.allergyType').is(':checked') && $('.allergy').is(':checked')){
		if($('input:radio.allergyType:checked').val() == "D" &&
			!$('.reaction').is(':checked')){
				alert("Please select the reaction.");
		}else{
			var selectValue = $('input:radio.allergy:checked').val();
			selectValue = selectValue.substring(1);
			if(selectValue == "000" && $('#desc').val().length <= 0){
					alert("Please enter others description.");
			}else{
			document.getElementById('type').value = $('input:radio.allergyType:checked').val();
			document.getElementById('code').value = $('input:radio.allergy:checked').val();
			document.getElementById('addAllergy').action = 'allergy_add.jsp';
			document.getElementById('step').value = step;
			document.addAllergy.submit();
			}
		}
	}else if($('input:radio.allergyType:checked').val() == "N"){
		document.getElementById('type').value = $('input:radio.allergyType:checked').val();
		document.getElementById('code').value = "";
		document.getElementById('addAllergy').action = 'allergy_add.jsp';
		document.getElementById('step').value = step;
		document.addAllergy.submit();
	}else{
		alert("Please select at least one allergy");
	}
}

function resetAction(){
	$("#desc").attr("disabled", "disabled"); 
	document.getElementById("addAllergy").reset();
}

</script>
</head>
<body>
<div id="new">
	<div class="title">Add New Allergy</div>
	<form name="addAllergy" id="addAllergy" action="" method="post" >
		<div class="button content"> 
			<input type="button" value="Submit" id="submitButton" onclick="return submitAction('1');" />
			<input type="button" value="Reset" id="resetButton" onclick="resetAction()" />
		</div>
		<div class="subtitle">Select Allergy Type:</div>
		<%for(int i=0;i<allergyTypeCode.size();i++){  %>
			<input type="radio" class="allergyType" name="alleryType" id="<%=allergyTypeCode.get(i) %>" value="<%=allergyTypeCode.get(i) %>" onclick="return showAllergy('<%=allergyTypeCode.get(i) %>');" /><%=allergyTypeName.get(i) %><br>
		<%} %>
	
		<div id="selectAllergy" class="subtitle">Select Allergy:</div>
		<div id="allergyName" ></div>
		<div id="reaction">
			<div class="subtitle">Reaction:</div>
			<%for(int i=0;i<severityCode.size();i++){  %>
				<input type="radio" class="reaction" name="reaction" id="<%=severityCode.get(i) %>" value="<%=severityCode.get(i) %>" /><%=severityName.get(i) %><br>
			<%} %>
		</div>
		<div id="moreinfo">
			<div class="subtitle">Remarks:</div>
			<textarea rows="6" cols="40" class="otherinfo" name="remarks" id="remarks" ></textarea>
		</div>
		
		<input type="hidden" id="type" name="type" value="" /><br/>
		<input type="hidden" id="code" name="code" value=""/><br/>
		<input type="hidden" id="login" name="login" value="<%=login %>" /><br/>
		<input type="hidden" id="patno" name="mrnPatientIdentity" value="<%=mrnPatientIdentity %>" /><br/>
		<input type="hidden" id="system" name="sourceSystem" value="<%=sourceSystem %>"/><br/>
		<input type="hidden" id="step" name="step" value="<%=step %>"/><br/>
	
	</form>
</div>
</body>
</html>