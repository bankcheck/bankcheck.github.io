<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
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

// GET SAAM PAGE
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

int recordNum = AllergyDB.getAllergyRecord(mrnPatientIdentity,"A",null).size();

%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge">
<meta http-equiv="Pragma" content="no-cache"> 
<meta http-equiv="Cache-Control" content="no-cache"> 
<meta http-equiv="Expires" content="0">
<style>
body {
	font-size: 13px;
	font-family: arial, verdana, sans-serif;
    overflow: hidden;
    background-color: #f1f1f1;
}
div.tab button {
    background-color: #ddd;
    border: 2px solid #ccc;
    float: left;
    outline: none;
    cursor: pointer;
    padding: 14px 16px;
    transition: 0.3s;
    margin-right: 20px;
    border-radius: 3px;
}
div.tab button:hover {
	border: 2px solid #ccc;
    background-color: #ddd;
    box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24), 0 17px 50px 0 rgba(0,0,0,0.19);
    border-radius: 3px;
}

div.tab button.active {
	font-size: 14px;
	font-weight: bold;
    background-color: #ccc;
    border-radius: 3px;
}
#logo{
	position: absolute;
    right: 10px;
}
</style>
<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var url = window.parent.content.location.href;

	if (url.indexOf("allergy_other") >= 0){
		document.getElementById("other").className += " active";
	}else{
		document.getElementById("allergy").className += " active";
	}
});
function showActive(evt, cmd){
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
	evt.currentTarget.className += " active";
	if (cmd=="other"){
		document.getElementById("logo").src="../images/A logo.jpg";
	}else{
		document.getElementById("logo").src="../images/ehealth_system_logo.png";
	}
}
</script>
</head>
<body>
<div class="tab">
<%  
    java.util.HashMap params = new java.util.HashMap();
	params.put("systemLogin", systemLogin);
	params.put("sourceSystem", sourceSystem);
	
	// User Information
	params.put("login", login);
	params.put("loginName", loginName);
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
%>
	<a href="<%=url %>" target="content">
		<button id="allergy" class="tablinks" onclick = "showActive(event, 'allergy')">
			eHR Allergy Page
		</button>
	</a>

	<html:link page="/cms/allergy_other.jsp" name="paramsName" target="content">
		<button id="other" class="tablinks" onclick = "showActive(event, 'other')">
			Local Allergy Data (<%=recordNum %>)
		</button>
	</html:link>

	<img src="../images/A logo.jpg" id="logo" height="42" width="70">
</div>

</body>
	 

</html>