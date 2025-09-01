<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
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

//GET SAAM PAGE
ArrayList result = null;
String path = "";
result = AllergyDB.getSAAM();
if (result.size() > 0) {
	ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
	path = 	reportableListObject.getValue(0);
}
String url = path;
url += "?";
url += "patno=" + mrnPatientIdentity;
url += "&userRight=" + userRight;
url += "&login=" + login;
url += "&loginName=" + loginName;
url += "&sourceSystem=" + sourceSystem;
url += "&inMethod=eHR";
%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
}
body{
	margin:0px;
	padding:0px;
	overflow-x:hidden;
	overflow-y:scroll;
}
</style>
<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var userRank = "<%=userRank %>";

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
	
	titleUrl = "allergy_menu.jsp";
	document.getElementById("title").src= titleUrl + url;
	
	if(userRank == "DR"){
		contentUrl = "<%=url %>";
	}else{
		contentUrl = "allergy_other.jsp"  + url;
	}
	document.getElementById("content").src= contentUrl;
	
	setContextHeight();
	
	});
	function setContextHeight(){
		var body = document.body;
	    var html = document.documentElement;
	
		var h = Math.max( body.scrollHeight, body.offsetHeight, 
	                       html.clientHeight, html.scrollHeight, html.offsetHeight );
		h= h-60;
		document.getElementById("content").style.height = h+"px";
	
	}
</script>
</head>
<body >
	<iframe name="title" id="title" src="" scrolling="no"></iframe>
	<iframe name="content" id="content" src="" scrolling="yes"></iframe>
</body> 
	
</html>