<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.convert.Converter"%>
<%
ArrayList record = new ArrayList();
ReportableListObject row = null;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
	 "http://www.w3.org/TR/html4/frameset.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/w3.hkah.css" />" />

<head>
<style>
/* The search field */
/*.searchField {
  box-sizing: border-box;
  border: none;
  border-bottom: 1px solid #ddd;
}*/
.dropdown-content {
	display: none;
	position: absolute;
	background-color: #f9f9f9;
	box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
	z-index: 1;
	max-height:300px;
	overflow-y:auto;
	overflow-x:hidden;
	width: 29%;
}
#content{
	height:150px;	
}
.hiddenField{
	display:none;
}

</style>
</head>
<body style="background:aliceblue;" >
	<div class="w3-container w3-center ah-pink ">
		<span class="w3-xxlarge bold  ">Panel Doctor</span>
		<span>(Search List)</span>
	</div>

	<div class="w3-container w3-tiny ah-pink w3-right w3-display-topright">
		<br/>
	</div>
	<div class="w3-container w3-tiny ah-pink w3-left w3-display-topleft">
		<br/>
	</div>
	
	<div class="w3-right-align w3-white" style="padding-right: 10px;">
		<button class="w3-small" id="searchButton" onclick="searchAction();">Search</button>
		<button class="w3-small" id="resetButton" onclick="resetAction()">Reset</button>
	</div>
	
	<div class="w3-container w3-row w3-white" id="content">
		<div class="w3-col w3-container w3-white w3-third" style="height: 100%;" id="arSection" >
			<div class="w3-container">
				<span class="w3-medium">Insurance Company</span> 
				<input id="arCodeInput" type="hidden" class="codeField"/> 
				<input id="arInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small"
					onkeyup="filterFunction(this.value,'arSection')"
					onfocusin="	$('.dropdown-content').css('display', 'none');
	  							$('#arList').css('display', 'block');">
	  		</div>
	  		<div class="w3-container">
	  		<ul id="arList" class="w3-ul w3-hoverable w3-border dropdown-content">
<% 
			record = PanelDoctorDB.getPanelAR(null, null, null);
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%>
				<li class="w3-small" value="<%=row.getValue(0) %>" onclick="updateList('ar', '<%=row.getValue(0) %>', this)"><%=row.getValue(1) %></li>
<%
				}
			}
%>
			</ul>
			</div>
		</div>
		
		<div class="w3-col w3-container w3-white w3-third" style="height: 100%;" id="specialtySection">
			<div class="w3-container">
				<span class="w3-medium">Specialty</span> 
				<input id="specialtyCodeInput" type="hidden" class="codeField"/> 
				<input id="specialtyInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small"
					onkeyup="filterFunction(this.value, 'specialtySection')"
					onfocusin="	$('.dropdown-content').css('display', 'none');
	  							$('#spList').css('display', 'block');">
			</div>
			<div class="w3-container">
				<ul id="spList" class="w3-ul w3-hoverable w3-border dropdown-content">
<% 
			record = PanelDoctorDB.getPanelSP(null, null, null);
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%>
				<li class="w3-small" value="<%=row.getValue(0) %>" onclick="updateList('sp', '<%=row.getValue(0) %>', this)"><%=row.getValue(1) %></li>
<%
				}
			}
%>
				</ul>
			</div>
		</div>
		
		<div class="w3-col w3-container w3-white w3-third" style="height: 100%;" id="doctorSection">
			<div class="w3-container">
				<span class="w3-medium">Doctor Name</span> 
				<input id="drCodeInput" type="hidden" class="codeField"/> 
				<input id="doctorInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small"
					onkeyup="filterFunction(this.value, 'doctorSection')"
					onfocusin="	$('.dropdown-content').css('display', 'none');
	  							$('#drList').css('display', 'block');">

			</div>
			<div class="w3-container">
				<ul id="drList" class="w3-ul w3-hoverable w3-border dropdown-content">
<% 
			record = PanelDoctorDB.getPanelDoctor(null, null, null);
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%>
				<li class="w3-small" value="<%=row.getValue(0) %>" onclick="updateList('dr', '<%=row.getValue(0) %>', this)"><%=row.getValue(1) %> <%=row.getValue(2) %></li>
<%
				}
			}
%>				
				</ul>
			</div>
		</div>
	</div>
	
	<div class="w3-row w3-container" style="width:100%; padding-left: 0px; padding-right: 0px;" id="result">
	</div>
</body>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.cookie.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.dcdrilldown.1.2.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/filterlist.js" />"></script> 
<script language="JavaScript">
var inArcode, inSpcode, inDrcode;

$(document).ready(function(){
	changeARlist();
	changeSPlist();
	changeDRlist();
	$(document).keypress(function(e) {
		if (e.which == 13) { // 13 = "ENTER"
			searchAction();
		}
	});
	$(document).mousedown(function(e) {
		if (e.which == 3){
			$('.dropdown-content').css('display', 'none');
		}
	});
	//searchAction();
});

function filterFunction(inputField,section) {
  	var a, i;
	inputField = inputField.toUpperCase();
  	div = document.getElementById(section);
	div.getElementsByClassName("codeField")[0].value = "";
  	a = div.getElementsByTagName("li");
	for (i = 0; i < a.length; i++) {
    	txtValue = a[i].textContent || a[i].innerText;
    	if (txtValue.toUpperCase().indexOf(inputField) > -1) {
      		a[i].style.display = "";
	    } else {
    		a[i].style.display = "none";
    	}
  	}	
}

function updateList(inputType, inputValue, inputText){
	inArcode = $("#arCodeInput").val();
	inSpcode = $("#specialtyCodeInput").val();
	inDrcode = $("#drCodeInput").val();
	if (inputType == "ar"){
		inArcode = inputValue;
		$("#arInput").val(inputText.innerHTML.trim());
		$("#arCodeInput").val(inArcode);
		$('#arList').css('display', 'none');
	}else if (inputType == "sp"){
		inSpcode = inputValue;
		$("#specialtyInput").val(inputText.innerHTML.trim());
		$("#specialtyCodeInput").val(inSpcode);
		$('#spList').css('display', 'none');
	}else if (inputType == "doc"){
		inDrcode = inputValue;
		$("#doctorInput").val(inputText.innerHTML.trim());
		$("#drCodeInput").val(inDrcode);
		$('#drList').css('display', 'none');
	}
	changeARlist();
	changeSPlist();
	changeDRlist();
}

function changeARlist() {
	$.ajax({
		url : "panelDoctorSearch_ajax.jsp",
		data : {
			"action" : "changeAR",
			"inArcode" : inArcode, 
			"inSpcode" : inSpcode,
			"inDrcode" : inDrcode
		},
		type : 'POST',
		dataType : 'html',
		cache : false,
		success : function(data) {
			$("#arList").html(data);

		},
		error : function(data) {
			alert("Cannot find the item!");
		}
	});
}

function changeSPlist() {
	$.ajax({
		url : "panelDoctorSearch_ajax.jsp",
		data : {
			"action" : "changeSP",
			"inArcode" : inArcode, 
			"inSpcode" : inSpcode,
			"inDrcode" : inDrcode
		},
		type : 'POST',
		dataType : 'html',
		cache : false,
		success : function(data) {
			$("#spList").html(data);

		},
		error : function(data) {
			alert("Cannot find the item!");
		}
	});
}

function changeDRlist() {
	$.ajax({ 
		url : "panelDoctorSearch_ajax.jsp",
		data : {
			"action" : "changeDR",
			"inArcode" : inArcode, 
			"inSpcode" : inSpcode,
			"inDrcode" : inDrcode
		},
		type : 'POST',
		dataType : 'html',
		cache : false,
		success : function(data) {
			$("#drList").html(data);
		},
		error : function(data) {
			alert("Cannot find the item!");
		}
	});
}

function resetAction(){
	$('.dropdown-content').css('display', 'none');
	$("#arInput").val("");
	$("#arCodeInput").val("");
	$("#specialtyInput").val("");
	$("#specialtyCodeInput").val("");
	$("#doctorInput").val("");
	$("#drCodeInput").val("");
	$("#result").html("");
	inArcode = "";
	inSpcode = "";
	inDrcode = "";
	changeARlist();
	changeSPlist();
	changeDRlist();
	$("#itemList").html("");
}

function searchAction(){
	$('.dropdown-content').css('display', 'none');
	inArcode = $("#arCodeInput").val();
	inSpcode = $("#specialtyCodeInput").val();
	inDrcode = $("#drCodeInput").val();
	$.ajax({
        url: "panelDoctorSearch_ajax.jsp",
        data: {	
			"action" : "retrieve",
			"inArcode" : inArcode, 
			"inSpcode" : inSpcode,
			"inDrcode" : inDrcode
				},
        type: 'POST',
        dataType: 'html',
		cache: false,
        success: function(data){
        	$("#result").html(data);
        },
        error: function(data){
        	alert($.trim(data));
        }
	});
}
</script>
</html:html>