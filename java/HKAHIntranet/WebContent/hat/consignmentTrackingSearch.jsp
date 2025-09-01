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
<%!
private ArrayList<ReportableListObject> implantHistory(String regid){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT EQITMCODE ");
	sqlStr.append("FROM EQREG@IWEB ");
	sqlStr.append("WHERE REGID = '" + regid + "' ");
	sqlStr.append("AND ENABLED = 1 ");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList<ReportableListObject> getDept(){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT DPTCODE, DPTNAME ");
	sqlStr.append("FROM DEPT@IWEB ");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList<ReportableListObject> getCategory(){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT EQCATCODE, EQCATEGORY ");
	sqlStr.append("FROM EQCATEGORY@IWEB ");
	//sqlStr.append("GROUP BY EQCATEGORY ");
	return UtilDBWeb.getReportableList(sqlStr.toString());
	
}

private ArrayList<ReportableListObject> getCompany(){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT EQCOMCODE, EQCOMDESC ");
	sqlStr.append("FROM EQCOMPANY@IWEB ");
	sqlStr.append("ORDER BY EQCOMDESC ");
	return UtilDBWeb.getReportableList(sqlStr.toString());
	
}
private ArrayList<ReportableListObject> getItem(String searchText){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT EQITMCODE, EQCOMCODE, MODEL, EQREF ");
	sqlStr.append("FROM EQITEM@IWEB ");
	sqlStr.append("WHERE MODEL LIKE ('%"+searchText+"%') ");
	sqlStr.append("OR EQREF LIKE ('%"+searchText+"%') ");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

%>
<%
ArrayList record = new ArrayList();
ReportableListObject row = null;
String patno = request.getParameter("patno");
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
	min-width: 160px;
	box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
	z-index: 1;
	 
	max-height:300px;
	overflow-y:auto;
	overflow-x:hidden;
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
		<span class="w3-xxlarge bold  ">Implant Tracking</span>
		<span >(Search List)</span>
	</div>

	<div class="w3-container w3-tiny ah-pink w3-right w3-display-topright">
		<br/>
	</div>
	<div class="w3-container w3-tiny ah-pink w3-left w3-display-topleft">
		<br/>
	</div>
	
	<div class="w3-right-align w3-white" style="padding-right: 10px;">
		<button class="w3-small" id="addItem" onclick="searchAction();">Search</button>
		<button class="w3-small" id="resetItem" onclick="resetAction()">Reset</button>
	</div>
	<div class="w3-container w3-row w3-white" id="content">
		<div class="w3-col w3-container w3-white" style="width:20%" id="deptSection" >
			<div class="w3-container">
				<span class="w3-medium">Department</span>
				<input id="deptCodeInput" type="hidden" />
	  			<input id="deptInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small"
	  				onkeyup="filterFunction(this.value,'deptSection')"
	  				onfocusin="	$('.dropdown-content').css('display', 'none');
	  							$('#deptList').css('display', 'block');">
	  		</div>
	  		<ul id="deptList" class="w3-ul w3-hoverable w3-border dropdown-content">
			<% 
			record = getDept();
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
			%>
				<li class="w3-small" value="<%=row.getValue(0) %>" onclick="searchDept(this)">
				<%=row.getValue(1) %></li>
			<%
				}
			}
			%>
			</ul>
			<div class="w3-container">
				<span class="w3-medium">Patient No.</span>
	  			<input id="patnoInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small" value="<%=patno==null?"":patno %>"/>
	  		</div>
		</div>
		<div class="w3-col w3-container w3-white" style="height:100%; width:20%" id="categorySection" >
			<div class="w3-container">
				<span class="w3-medium">Category</span>
				<input id="categoryCodeInput" type="hidden" />
	  			<input id="categoryInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small" 
	  				onkeyup="filterFunction(this.value, 'categorySection')"
	  				onfocusin="	$('.dropdown-content').css('display', 'none');
	  							$('#categoryList').css('display', 'block');" />
	  				
	  		</div>
	  		<ul id="categoryList" class="w3-ul w3-hoverable w3-border dropdown-content">
			<% 
			record = getCategory();
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
			%>
				<li class="w3-small" value="<%=row.getValue(0) %>" onclick="searchCategory(this)">
				<%=row.getValue(1) %></li>
			<%
				}
			}
			%>
			</ul>
			<div class="w3-container">
				<!-- <span class="w3-medium">Registration No.</span>
	  			<input id="regidInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small"> -->
	  		</div>
		</div>
		<div class="w3-col w3-container w3-white" style="height:100%; width:20%" id="companySection" >
			<div class="w3-container">
				<span class="w3-medium">Company</span>
				<input id="companyCodeInput" type="hidden" />
	  			<input id="companyInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small" 
	  				onkeyup="filterFunction(this.value, 'companySection')"
	  				onfocusin="	$('.dropdown-content').css('display', 'none');
	  							$('#companyList').css('display', 'block');" >
	  		</div>
	  		<ul id="companyList" class="w3-ul w3-hoverable w3-border dropdown-content">
	  		<% 
			record = getCompany();
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
			%>
				<li class="w3-small" value="<%=row.getValue(0) %>" onclick="searchCompany(this)">
				<%=row.getValue(1) %></li>
			<%
				}
			}
			%>
			</ul>
		</div>
		<div class="w3-col w3-container w3-white" style="height:100%; width:20%" id="modelSection" >
			<div class="w3-container">
				<span class="w3-medium">Model [Ref#]</span>
				<input id="itemCodeInput" type="hidden" />
	  			<input id="itemInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small" 
	  				onkeyup="filterFunction(this.value, 'modelSection')"
	  				onfocusin="	$('.dropdown-content').css('display', 'none');
	  							$('#itemList').css('display', 'block');">
	  		</div>
	  		<ul id="itemList" class="w3-ul w3-hoverable w3-border dropdown-content">
	  		<% 
			record = getItem("%");
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
			%>
				<li class="w3-small" value="<%=row.getValue(0) %>" onclick="searchItem(this)">
				<%=row.getValue(2) %> [REF:<%=row.getValue(3) %>]</li>
			<%
				}
			}
			%>
			</ul>
		</div>
		<div class="w3-col w3-container w3-white" style="height:100%; width:20%" id="LotSection" >
			<div class="w3-container">
				<span class="w3-medium">Lot#</span>
	  			<input id="lotInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small" onkeyup=""><br/>
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
var eqDeptCode, eqCategoryCode, eqCompanyCode, eqItmCode;
var eqDept, eqCategory, eqCompany, eqItem;
var eqLot, eqQty;
var regid;
var patno = <%=patno%>;

$(document).ready(function(){
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

function searchDept(dept){
	eqDept = dept.getAttribute('value');
	$("#deptCodeInput").val(eqDept);
	$("#deptInput").val(dept.innerHTML.trim());
	$('#deptList').css('display', 'none');
}

function searchCategory(category) {
	eqCategory = category.getAttribute('value');
	$("#categoryInput").val(category.innerHTML.trim());
	$('#categoryList').css('display', 'none');
}


function searchCompany(company){
	eqCompany = company.getAttribute('value');
	$("#companyInput").val(company.innerHTML.trim());
	$('#companyList').css('display', 'none');
}

function searchItem(item){
	eqItem = item.getAttribute('value');
	$("#itemInput").val(item.innerHTML.trim());
	$('#itemList').css('display', 'none');
}

function resetAction(){
	$('.dropdown-content').css('display', 'none');
	$("#deptInput").val("");
	$("#deptCodeInput").val("");
	$("#categoryInput").val("");
	$("#categoryCodeInput").val("");
	$("#companyInput").val("");
	$("#companyCodeInput").val("");
	$("#itemInput").val("");
	$("#itemCodeInput").val("");
	$("#lotInput").val("");
	$("#patnoInput").val("");
	$("#regidInput").val("");
	$("#result").html("");
}

function searchAction(){
	$('.dropdown-content').css('display', 'none');
	eqDept = $("#deptCodeInput").val();
	eqCategory = $("#categoryInput").val();
	eqCompany = $("#companyInput").val();
	eqItem = $("#itemInput").val();
	eqLot = $("#lotInput").val();
	patno = $("#patnoInput").val();
	regid = $("#regidInput").val();
	$.ajax({
        url: "consignmentTracking_ajax.jsp",
        data: {	"action" : "retrieve",
        		"eqDept" : eqDept,
        		"eqCategory" : eqCategory, 
        		"eqCompany" : eqCompany,
        		"eqItem" : eqItem,
        		"eqLot" : eqLot,
        		"patno" : patno,
        		"regid" : regid
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
function searchByItem(eqitmcode){
	$.ajax({
        url: "consignmentTracking_ajax.jsp",
        data: {	"action" : "retrieve",
        		"eqItmcode" : eqitmcode
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