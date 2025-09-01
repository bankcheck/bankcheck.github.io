<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.db.*"%>
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

%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge">
<meta http-equiv="Pragma" content="no-cache"> 
<meta http-equiv="Cache-Control" content="no-cache"> 
<meta http-equiv="Expires" content="0">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Allergy</title>
<style>
body{
	margin:0px;
	padding:0px;
	overflow:hidden;
	
	font-size: 18px;
    font-family: arial, verdana, sans-serif;
	height: 86px;
	background-color: rgb(249,243,247);
	border-width: 2px;
	border-style: solid;
    border-color: rgb(156,24,90);
}
#content_add{
	position: absolute; 
	top:90px; 
	left:0px; 
	bottom:0px; 
	right:0px; 
	width:30%; 
	border:none; 
	margin:0; 
	padding:0; 
	height: 100%;
}
#content_delete{
	position: absolute;
    top: 90px;
    left: 30%;
    bottom: 0px;
    right: 30%;
    width: 70%;
	height: 100%;
	border:none; 
	margin:0; 
	padding:0; 
}
table{
	width: 100%;
}
#patInfo{
	padding-top: 17px;
	padding-left: 15px;
	text-align: left;
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
</style>
<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	url = "?";

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
	
	titleUrl = "allergy_add.jsp";
	document.getElementById("content_add").src= titleUrl + url;
	
	contentUrl = "allergy_view.jsp";
	document.getElementById("content_delete").src= contentUrl + url;
	
	setPatInfo();
	
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
</script>
</head>
<body>
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
	<iframe name="content_add" id="content_add" src="" scrolling="yes" ></iframe>
	<iframe name="content_delete" id="content_delete" src="" scrolling="yes" align="right"></iframe>

</body>
</html>