<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Map.Entry"%>
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

String tempType = null;

int ehrSum = AllergyDB.getEHRrecord(mrnPatientIdentity).size();
int localSum = AllergyDB.getAllergyRecord(mrnPatientIdentity,"A", null).size();
request.setAttribute("ehrList", AllergyDB.getEHRrecord(mrnPatientIdentity));
request.setAttribute("localList", AllergyDB.getAllergyRecord(mrnPatientIdentity, "A", "TYPE"));

String action = "ACK";
String lastAckUser = null;
String lastAckDateTime = null;
ArrayList result = null;
result = AllergyDB.getLog(action, mrnPatientIdentity);
if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		lastAckUser = reportableListObject.getValue(5);
		lastAckDateTime = reportableListObject.getValue(4);
} 
%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge">
<meta http-equiv="Pragma" content="no-cache"> 
<meta http-equiv="Cache-Control" content="no-cache"> 
<meta http-equiv="Expires" content="0">
<title>Allergy</title>
<style>
#title{
	position: inherit;
	top:0px;
	left:0px;
	bottom:0px;
	right:0px; 
	width:100%; 
	height: 60px; 
	border:none; 
	margin:0; 
	padding:0; 
}
#content{
	position: inherit; 
	width:100%; 
	border:none; 
	margin:0; 
	padding:0; 
	overflow: scroll;
	 text-align:center;
}
body{
	font-family: arial, verdana, sans-serif;
	margin:0px;
	padding:0px;
	overflow-x:hidden;
	overflow-y:scroll;
}
table{
	width: 100%;
}
#patInfo{
	font-size: 18px;
	padding-top: 17px;
	padding-left: 15px;
	padding-bottom: 17px;
	text-align: left;
	border-bottom:2px solid black;
	border-color: rgb(156,24,90);
	background-color: rgb(249,243,247);
}
td{
	padding-left: 10px;
}
.showSex{
	padding-left: 0px;
	vertical-align: middle;
	font-weight: bold;
	text-align: center;
    color: white;
    font-size: 30px;
}
#allergyInfo{
 	text-align:center;
	margin:20px;
}
#allergyInfo span{
	text-align:center;
	font-size: 18px;
}
#lastAck span{
	margin-left: 25px;
	margin-right:25px;
	text-decoration: underline;
}
.button{
	margin:100px;
	margin-top:0px;
	text-align:center;
}
input[type=button]{
	align: center;
	margin-left:100px;
	margin-right:50px;
	padding:10px;
}
.recordList{
	text-align:left;
	margin: 20px;
	border:2px solid black;
	padding:10px;
	border-color: rgb(156,24,90);
	background-color: rgb(249,243,247);
}
</style>
<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		setPatInfo();
		setButton("default");
	});

	
	function setPatInfo(){
		var sex = "${sex}";
		if (sex == "F"){
        	$('#patSex').css('background-color', '#EB3546');
        }else if (sex == "M"){
        	$('#patSex').css('background-color', '#25ACE5');
        }else{
        	$('#patSex').css('background-color', '#652D90');
        }
	}
	
	function setButton(action){
		var userRank = "<%=userRank %>";
		if(userRank == "DR" || userRank == "PHAR"){
			$('#printButton').prop('disabled', false);
			$('#updateButton').prop('disabled', false);
		}else if(action == "acknowledged"){
			$('#printButton').prop('disabled', false);
			$('#updateButton').prop('disabled', false);
			var anchors = document.getElementsByTagName("a");
		    for (var i = 0; i < anchors.length; i++) {
		        anchors[i].onclick = function() {return true;};
		    }
		}else if(action == "printing"){
			$('#printButton').prop('disabled', false);
			$('#updateButton').prop('disabled', false);
			$('#acknowledgeButton').prop('disabled', false);
		}else{
			$('#printButton').prop('disabled', true);
			$('#updateButton').prop('disabled', true);
			var anchors = document.getElementsByTagName("a");
		    for (var i = 0; i < anchors.length; i++) {
		        anchors[i].onclick = function() {
		        	alert("Please acknowledge before update or print.");
		        	return false;
		        	};
		    }
		}
	}
	
	function acknowledge(){
		var action = "ACK";
		var mrnPatientIdentity = "<%=mrnPatientIdentity %>";
		var login = "<%=login %>";
		var sourceSystem = "<%=sourceSystem %>";
		
		$.ajax({
	        url: "allergy_log.jsp",
	        data: {	"mrnPatientIdentity" : mrnPatientIdentity,
	        		"action" : action,
	        		"sourceSystem" : sourceSystem,
	        		"login" : login},
	        type: 'POST',
	        dataType: 'html',
			cache: false,
	        success: function(data){
	        	if ($.trim(data)=='false') {
	        		alert("Error occur. ");
				}
				else {
	        		setButton("acknowledged");
	        		$('#lastAck').html(data);
				}
	        },
	       	error: function(data){
	       		alert("Error occur." + data);
	       	}
	    });
	}

</script>
</head>
<body >

<div id="patInfo">
	<table>
		<tr>
			<td id="patSex"class="showSex" rowspan='2' height="45px" width="45px" align="left" ><%=sex%></td>
			<td id="patName" colspan="4" style="text-transform: uppercase;"><%=engSurName%>, <%=engGivenName%></td>
		</tr>
		<tr>
			<td id="patHkid">HKID: <%=hkid%></td>
			<td id="patDob">DOB: <%=dob%></td>
			<td id="patAge">Age: <%=age%></td>
			<td id="patno">Patient No.: <%=mrnPatientIdentity%></td>
		</tr>
	</table>
</div>

<div id="allergyInfo">
	<span>eHR Allergy Data (<%=ehrSum %> records)</span>
	<div id="eHRrecord" class="recordList">
<%
	if(ehrSum > 0){ 
%>
		<display:table id="ehrList" name="requestScope.ehrList" export="false" excludedParams="step">
<% 
	if(((ReportableListObject)pageContext.getAttribute("ehrList")).getValue(1).equals(tempType)){
%>
	<display:column title="Allergy Type" class="active" style="width:13%" >
	</display:column>
<%
	}else{
		tempType = ((ReportableListObject)pageContext.getAttribute("ehrList")).getValue(1);
%>
	<display:column property="fields1" title="Allergy Type" class="active" style="width:13%" />
<%
	}
%>
			<display:column title="#" media="html" style="width:2%">
				<c:out value="${ehrList.fields0}"/>) 
			</display:column>
			<display:column property="fields2" title="Allergy" class="active" style="width:30%" />	
			<display:column title="Reaction" class="active" style="width:15%">
			<c:out value="${ehrList.fields3}"/>: <c:out value="${ehrList.fields4}"/>
			</display:column>	
			<display:column property="fields5" title="Remarks" class="active" style="width:15%"/>
			<display:column property="fields6" title="Update User" class="active" style="width:15%"/>	
			<display:column property="fields7" title="Update Date" class="active" style="width:10%"/>
		</display:table>
<%
	} 
%>
	</div>

	<span>Local Allergy Data (<%=localSum %> records)</span>
	<div id="localrecord"  class="recordList">
<%	
	if(localSum > 0){
%>
		<display:table id="localList" name="requestScope.localList" export="false" excludedParams="step">
<% 
	if(((ReportableListObject)pageContext.getAttribute("localList")).getValue(4).equals(tempType)){
%>
	<display:column title="Allergy Type" class="active" style="width:13%" >
	</display:column>
<%
	}else{
		tempType = ((ReportableListObject)pageContext.getAttribute("localList")).getValue(4);
%>
	<display:column property="fields4" title="Allergy Type" class="active" style="width:18%"/>
<%
	}
%>
			<display:column title="#" media="html" style="width:2%">
				<c:out value="${localList.fields0}"/>) 
			</display:column>
			<display:column title="Allergy" class="active" style="width:25%">
				<c:out value="${localList.fields5}"/>
				<%=((ReportableListObject)pageContext.getAttribute("localList")).getValue(6)!=null && 
				!"".equals(((ReportableListObject)pageContext.getAttribute("localList")).getValue(6))?
						"("+((ReportableListObject)pageContext.getAttribute("localList")).getValue(6)+")":
						"" %>
			</display:column>	
			<display:column property="fields7" title="Reaction" class="active" style="width:15%"/>	
			<display:column property="fields8" title="Remarks" class="active" style="width:15%"/>
			<display:column property="fields9" title="Update User" class="active" style="width:15%"/>	
			<display:column property="fields10" title="Update Date" class="active" style="width:10%"/>	
		</display:table>
<%
	} 
%>		
	</div>

	<div id="lastAck" align="right">
		Last acknowledged by:<span><%=lastAckUser %></span> 
		(Date:<span><%=lastAckDateTime %></span>)
	</div>
</div>

<div class="button"> 
<%  
    java.util.HashMap params = new java.util.HashMap();
	params.put("systemLogin", systemLogin);
	params.put("sourceSystem", sourceSystem);
	
	// User Information
	params.put("login", login);
	params.put("loginName", loginName);
	//params.put("userRank", "DR");
	params.put("userRank", userRank);
	params.put("userRankDesc", userRankDesc);
	params.put("userRight", userRight);
	params.put("hospitalCode", hospitalCode);
	params.put("hospitalName", hospitalName);
	params.put("actionCode", actionCode);
	
	// Patient Information
	params.put("mrnDisplayLabelP", mrnDisplayLabelP);
	params.put("mrnDisplayLabelE", mrnDisplayLabelE);
	params.put("mrnDisplayType", mrnDisplayType);
	params.put("hkid", hkid);
	params.put("mrnPatientIdentity", mrnPatientIdentity);
	params.put("mrnPatientEncounterNo", mrnPatientEncounterNo);
	params.put("patientEhrNo", patientEhrNo);
	params.put("doctype", doctype);
	params.put("docnum", docnum);
	params.put("nation", nation);
	params.put("engSurName", engSurName);
	params.put("engGivenName", engGivenName);
	params.put("chiName", chiName);
	params.put("oname", oname);
	params.put("sex", sex);
	params.put("dob", dob);
	params.put("age", age);
	params.put("deathDate", deathDate);
	params.put("marital", marital);
	params.put("religion", religion);
	params.put("phoneH", phoneH);
	params.put("phoneM", phoneM);
	params.put("phoneOf", phoneOf);
	params.put("phoneOt", phoneOt);
	params.put("residentialAddress", residentialAddress);
	params.put("photoContent", photoContent);
	params.put("photoContentType", photoContentType);
	
	// Patient Admission Information
	params.put("admD", admD);
	params.put("disD", disD);
	params.put("attdoc", attdoc);
	params.put("condoc", condoc);
	params.put("spec", spec);
	params.put("classNum", classNum);
	params.put("ward", ward);
	params.put("bed", bed);
	params.put("details", details);
	
	pageContext.setAttribute("paramsName", params);
	
	params.put("action", "PRINT");
	pageContext.setAttribute("printParamesName", params);
%>
	<html:link page="/cms/allergy_log.jsp" name="printParamesName" target="_blank" >
		<input type="button" value="Print" id="printButton" onclick="setButton('printing')" />
	</html:link>
	<input type="button" value="Acknowledge" id="acknowledgeButton" onclick="acknowledge()" />
	<html:link page="/cms/allergy_index.jsp" name="paramsName" target="_top">
		<input type="button" value="Update" id="updateButton" onclick="" />
	</html:link>
</div>

</body> 
	
</html>