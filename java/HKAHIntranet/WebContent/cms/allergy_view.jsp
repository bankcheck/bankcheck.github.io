<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.db.*"%>
<%
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

String recordID = ParserUtil.getParameter(request, "recordID");
String delReasonID = ParserUtil.getParameter(request, "delReasonID");
String delReasonRemark = ParserUtil.getParameter(request, "delReasonRemark");

boolean success = false;
//update record
if ("1".equals(step)){
	success = AllergyDB.update(login, recordID, delReasonID, delReasonRemark, sourceSystem, mrnPatientIdentity);
	step = "0";
}

ArrayList tempReasonCode = new ArrayList();
ArrayList tempReason = new ArrayList();
ArrayList result = AllergyDB.getCancelReason();
if (result.size() > 0) {
	for (int i=0; i<result.size(); i++){
		ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
		tempReasonCode.add(reportableListObject.getValue(0));
		tempReason.add(reportableListObject.getValue(1));
	}
} 

request.setAttribute("allergyList", AllergyDB.getAllergyRecord(mrnPatientIdentity,null,"ID"));

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
	margin: 0;
	font-size: 15px;
	font-family: arial, verdana, sans-serif;
	background-color: rgb(223,232,246);
}
.button{
    margin: 10px;
	text-align: right;
}
.content{
	margin: 10px;
}
#allergyRecordList{
	width: 100%;
	border-spacing: 0px;
	border-collapse: collapse;
}
tr{
	border-bottom: 2px solid #ddd;
}
tr:hover{
	background-color: #f5f5f5
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
.cancelTitle{
	font-size: 15px;
    font-weight: bold;
	color: white;
	background-color: rgb(79,129,189);
	line-height: 20px;
    padding: 5px 3px 4px 5px;
}
.cancelled{
	text-decoration: line-through;
	color: grey;
}
.active{
	
}
#delReasonRemark{
	width: 100%
}
#showReason{
	position: absolute;
	border: 1px solid black;
	background-color: white;
}
</style>
<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">

var reasonID = [];

$(document).ready(function() {
	$('#addReason').hide();
	$('#showReason').hide();
<%if(success){ %>
	alert("Record deleted.");
	success = false;
	parent.location.reload();
<%} %>
	parent.parent.title.location.reload();
	var userRank = "<%=userRank %>";
	if(userRank == "DR" || userRank == "PHAR"){
		disableField();
		$("#viewMode").text("(View Mode)");
	}
	$('.cancelled').mouseover(handler);
	$('.cancelled').mouseleave(function(){
		$('#showReason').hide();
	});
});

function disableField(){
	$("#delete").prop("disabled",true);
	$(".canDelete").prop("disabled",true);
}

function handler(ev){
	var target = $(ev.target);
	var recordId = target.attr('class');
	recordId = recordId.split(' ');
	if( target.is(".cancelled") ) {
		$.ajax({
	        url: "/intranet/GetAllergyCancelReason",
	        data: {"recordID" : recordId[1]},
	        type: 'POST',
	        dataType: 'html',
			cache: false,
	        success: function(data){
	        	$('#showReason').show();
	        	$('#showReason').css({'top':ev.pageY,'left':ev.pageX});
	        	$('#showReason').html(data);
	        },
	       	error: function(data){
	       		console.log(data);
	       	}
	    });
	}
}

function deleteAction(){
	var delRecord = $('input[name="doDelete"]:checked').val();
	if (delRecord == null){
		alert("Please select a record");
	}else{
		delRecord = delRecord.split(",");
		var recordCode = delRecord[0];
		var recordType = delRecord[1];
		$('#delRecord').val(recordType);
		$('.showDelRecord').text(recordType);
		$('#recordID').val(recordCode);
		$('#record').hide();
		$('#addReason').show();
	}
}

function submitAction(step){
	if(reasonID.length <= 0 || 
			(reasonID.indexOf("000") > -1 && $('#delReasonRemark').val().length <= 0)){
		alert("Please enter a reason for deleting this Record.");
	}else{
		$('#delReasonID').val(reasonID);
		document.getElementById('deleteAllergy').action = 'allergy_view.jsp';
		document.getElementById('step').value = step;
		document.deleteAllergy.submit();
	}
}

function cancelAction(){
	$('#record').show();
	$('#addReason').hide();
}

function refreshAction(){
	parent.location.reload();	
}

function selectDelReason(val){
	var index = reasonID.indexOf(val);
	if (index > -1) {
		reasonID.splice(index, 1);
	}else{
		reasonID.push(val);	
	}
}
</script>
</head>
<body>
<div>
	<div id="record">
		<div class="title" >Table of the record <span id="viewMode"></span></div>
		<div class="content">
			<div class="button">
				<input type="button" value="Delete Record" id="delete" onclick="deleteAction();" />
				<input type="button" value="Refresh" id="refresh" onclick="return refreshAction();" />
			</div>
			<display:table id="allergyRecordList" name="requestScope.allergyList" export="false" pagesize="20" excludedParams="step">
				<c:choose>
					<c:when test = "${allergyRecordList.fields3 == 'D' }">
						<display:column title="&nbsp;" media="html" />
						<display:column property="fields4" title="Allergy Type" class="cancelled ${allergyRecordList.fields1}"/>
						<display:column title="Allergy" class="cancelled ${allergyRecordList.fields1}" >
							<c:out value="${allergyRecordList.fields5}"/>
							<%=((ReportableListObject)pageContext.getAttribute("allergyRecordList")).getValue(6)!=null && 
							!"".equals(((ReportableListObject)pageContext.getAttribute("allergyRecordList")).getValue(6))?
									"("+((ReportableListObject)pageContext.getAttribute("allergyRecordList")).getValue(6)+")":
									"" %>
						</display:column>	
						<display:column property="fields7" title="Reaction" class="cancelled ${allergyRecordList.fields1}"/>
						<display:column property="fields8" title="Remarks" class="cancelled ${allergyRecordList.fields1}"/>	
						<display:column property="fields9" title="Update User" class="cancelled ${allergyRecordList.fields1}"/>	
						<display:column property="fields10" title="Update Date" class="cancelled ${allergyRecordList.fields1}"/>	
						
					</c:when>
					<c:otherwise>
						<display:column title="&nbsp;" media="html">
							<input type="radio" class="canDelete" name="doDelete" value="<c:out value="${allergyRecordList.fields1}" />,<c:out value="${allergyRecordList.fields4}" />">
						</display:column>
						<display:column property="fields4" title="Allergy Type" class="active" />
						<display:column title="Allergy" class="active" >
							<c:out value="${allergyRecordList.fields5}"/>
							<%=((ReportableListObject)pageContext.getAttribute("allergyRecordList")).getValue(6)!=null && 
							!"".equals(((ReportableListObject)pageContext.getAttribute("allergyRecordList")).getValue(6))?
									"("+((ReportableListObject)pageContext.getAttribute("allergyRecordList")).getValue(6)+")":
									"" %>
						</display:column>	
						<display:column property="fields7" title="Reaction" class="active" />	
						<display:column property="fields8" title="Remarks" class="active" />
						<display:column property="fields9" title="Update User" class="active" />	
						<display:column property="fields10" title="Update Date" class="active" />	
					</c:otherwise>
				</c:choose>
			</display:table>
			
			<div id="showReason"></div>	
		</div>
	</div>
</div>
<div id="addReason">
	<form name="deleteAllergy" id="deleteAllergy" action="" method="post">
		<div class="title">Confirm deletion - <span class="showDelRecord"></span></div>
		<div class="content">
			<b>Please enter reason(s) of deletion of the <span class="showDelRecord"></span></b><br/>
			<%for(int i=0;i<tempReasonCode.size();i++){  %>
				<input type="checkbox" class="delReason" name="delReason" id="<%=tempReasonCode.get(i) %>" value="<%=tempReasonCode.get(i) %>" onclick="return selectDelReason('<%=tempReasonCode.get(i) %>');" /><%=tempReason.get(i) %><br/>
			<%} %>
			<br/>
			<b>Remarks</b><br/>
			<textarea rows="10" id="delReasonRemark" name="delReasonRemark" ></textarea>
			<input type="hidden" id="delRecord" name="delRecord" />
			<input type="hidden" name="recordID" id="recordID" />
			<input type="hidden" name="delReasonID" id=delReasonID />
			<input type="hidden" id="login" name="login" value="<%=login %>" /><br/>
			<input type="hidden" name="mrnPatientIdentity" id="patno" value="<%=mrnPatientIdentity %>" />
			<input type="hidden" name="sourceSystem" id="system" value="<%=sourceSystem %>" />
			<input type="hidden" id="step" name="step" value="<%=step %>"/><br/>
			<div class="button">
				<input type="button" value="Submit" id="save" onclick="return submitAction('1');" />
				<input type="button" value="Cancel" id="cancel" onclick="cancelAction();" />
			</div>
		</div>
	</form>
</div>
</body>
</html>