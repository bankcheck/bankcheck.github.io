<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge">
<meta http-equiv="Pragma" content="no-cache"> 
<meta http-equiv="Cache-Control" content="no-cache"> 
<meta http-equiv="Expires" content="0">
<style>
body{
	font-size: 13px;
    font-family: arial, verdana, sans-serif;
	height: 80px;
	background-color: rgb(249,243,247);
	border-style: solid;
    border-color: rgb(156,24,90);
    margin: 0;
}
table{
	width: 100%;
}
#patInfo{
	padding-top: 10px;
	padding-left: 10px;
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
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.5.1.min.js" /></script>
<script type="text/javascript">
	$(document).ready(function(){
		var sex = "${sex}";
		if (sex == "F"){
        	$('#patSex').css('background-color', '#EB3546');
        }else if (sex == "M"){
        	$('#patSex').css('background-color', '#25ACE5');
        }else{
        	$('#patSex').css('background-color', '#652D90');
        }
	});

</script>
</head>
<body>  
<div id="patInfo">
<table>
	<tr>
		<td id="patSex"class="showSex" rowspan='2' height="45px" width="45px" align="left" >${sex}</td>
		<td id="patName" colspan="4" style="text-transform: uppercase;">${engSurName}, ${engGivenName}</td>
	</tr>
	<tr>
		<td id="patHkid">HKID: ${hkid}</td>
		<td id="patDob">DOB: ${dob}</td>
		<td id="patAge">Age: ${age}</td>
		<td id="patno">Patient No.: ${mrnPatientIdentity}</td>
	</tr>
</table>
</div>
</body>		
</html>