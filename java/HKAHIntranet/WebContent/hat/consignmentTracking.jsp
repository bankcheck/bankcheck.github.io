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

private ArrayList<ReportableListObject> getPatInfo(String source, String regid, String otlid, String patno){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT P.PATNO, P.PATFNAME, P.PATGNAME ");
	if(!"".equals(otlid) && otlid != null){
		sqlStr.append("FROM OT_LOG@IWEB O, PATIENT@IWEB P ");
		sqlStr.append("WHERE O.PATNO = P.PATNO ");
		sqlStr.append("AND O.OTLID = '" + otlid + "' ");
	}else if(!"".equals(regid) && regid != null){
		sqlStr.append("FROM REG@IWEB R, PATIENT@IWEB P  ");
		sqlStr.append("WHERE R.PATNO = P.PATNO ");
		sqlStr.append("AND R.REGID = '" + regid + "' ");
	}else {
		sqlStr.append("FROM PATIENT@IWEB P ");
		sqlStr.append("WHERE P.PATNO = '" + patno + "' ");
	}
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

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
	sqlStr.append("SELECT DISTINCT D.DPTCODE, D.DPTNAME ");
	sqlStr.append("FROM DEPT@IWEB D, EQITEM@IWEB I ");
	sqlStr.append("WHERE D.DPTCODE = I.EQDPTCODE ");
	sqlStr.append("ORDER BY D.DPTNAME ");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%

ArrayList record = new ArrayList();
ReportableListObject row = null;
String source = request.getParameter("source"); //cis / hat / patno
String system = request.getParameter("system");
String mode = request.getParameter("mode"); //create, view, update
String regid = request.getParameter("regid"); 
String otlid = "null".equals(request.getParameter("otlid"))?null:request.getParameter("otlid");
String patno = request.getParameter("patno");
String userid = request.getParameter("userid"); 
String patFname = "";
if("CIS".equals(system)){
	source = system;
}
/*
record = implantHistory(regid);	
if(record.size()>0){
	row = (ReportableListObject) record.get(0);
	if("NEW".equals(row.getValue(0))){
		mode = "create";
	}else{
		mode = "view";
	}
}else{
	mode = "create";
}*/

if ("".equals(mode)|| mode == null){
	mode = "create";
}

record = getPatInfo(source, regid, otlid, patno);	
if(record.size()>0){
	row = (ReportableListObject) record.get(0);
	patno = row.getValue(0);
	patFname = row.getValue(1);
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
	 "http://www.w3.org/TR/html4/frameset.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" type="text/css"
	href="<html:rewrite page="/css/w3.hkah.css" />" />

<head>
<style>
/* The search field */
.searchField {
	box-sizing: border-box;
	border: none;
	border-bottom: 1px solid #ddd;
}

.dropdown-content {
	display: none;
	position: absolute;
	background-color: #f9f9f9;
	min-width: 160px;
	box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
	z-index: 1;
	max-height: 300px;
	overflow-y: auto;
	overflow-x: hidden;
}

#content {
	height: 300px;
}

#summary { /*height:350px;*/
	
}

.hiddenField {
	display: none;
}

#loader {
  position: absolute;
  top: 30%;
  left: 50%;
  display: none;
  z-index: 3;
  border: 16px solid #f3f3f3;
  border-radius: 50%;
  border-top: 16px solid #3498db;
  width: 120px;
  height: 120px;
  animation: spin 2s linear infinite;
  -webkit-animation: spin 2s linear infinite; /* Safari */
  
}

/* Safari */
@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
</head>
<body style="background: aliceblue;">
	<div id="loader"></div>
	<div class="w3-container w3-center ah-pink w3-display-top">
		<span class="w3-xxlarge bold  ">Implant Tracking</span> 
		<span id="viewOnly"><%="view".equals(mode)?" (View ONLY) <button id='updateButton' onclick='updateQuotation()' />Update</button>":"" %></span>
	</div>

	<div class="w3-container w3-tiny ah-pink w3-right w3-display-topleft">
		Patient Number: <%=patno== null?"":patno %><br/>
		Patient First Name: <%=patFname%>
	</div>
	<div class="w3-container w3-tiny ah-pink w3-left w3-display-topright">
		Updating User: <%=userid %><br />
	</div>

	<div class="w3-container w3-row w3-white" id="content">
		<div class="w3-col w3-container w3-white" style="width: 20%" id="deptSection">
			<div class="w3-container w3-margin-bottom">
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
				<li class="w3-small" value="<%=row.getValue(0) %>" onclick="changeCategoryCompanyList(this)"><%=row.getValue(1) %></li>
<%
				}
			}
%>
			</ul>
		</div>
		<div class="w3-col w3-container w3-white" style="height: 100%; width: 20%" id="categorySection">
			<div class="w3-container w3-margin-bottom">
				<span class="w3-medium">Category (Optional)</span> 
				<input id="categoryCodeInput" type="hidden" /> 
				<input id="categoryInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small"
					onkeyup="filterFunction(this.value, 'categorySection')"
					onfocusin="	$('.dropdown-content').css('display', 'none');
	  							$('#categoryList').css('display', 'block');"
	  				onfocusout="clearVar(this.value, 'categorySection')">

			</div>
			<ul id="categoryList" class="w3-ul w3-hoverable w3-border dropdown-content">
			</ul>
		</div>
		<div class="w3-col w3-container w3-white" style="height: 100%; width: 20%" id="companySection">
			<div class="w3-container w3-margin-bottom">
				<span class="w3-medium">Company</span> 
				<input id="companyCodeInput" type="hidden" /> 
				<input id="companyInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small"
					onkeyup="filterFunction(this.value, 'companySection')"
					onfocusin="	$('.dropdown-content').css('display', 'none');
	  							$('#companyList').css('display', 'block');">
			</div>
			<ul id="companyList" class="w3-ul w3-hoverable w3-border dropdown-content">
			</ul>
		</div>
		<div class="w3-col w3-container w3-white" style="height: 100%; width: 20%" id="modelSection">
			<div class="w3-container w3-margin-bottom">
				<span class="w3-medium">Model [Ref#]</span> 
				<input id="itemCodeInput" type="hidden" /> 
					<input id="itemInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small"
					onkeyup="filterFunction(this.value, 'modelSection')"
					onfocusin="	">
			</div>
			<ul id="itemList" class="w3-ul w3-hoverable w3-border dropdown-content">
			</ul>
		</div>
		<div class="w3-col w3-container w3-white" style="height: 100%; width: 20%" id="LotSection">
			<div class="w3-container w3-margin-bottom">
				<span class="w3-medium">Lot#</span> 
				<input id="lotInput" type="text" placeholder="" class="searchField w3-input w3-round w3-small" onkeyup=""><br /> 
				<span class="w3-medium">Quantity</span>
				<input id="qtyInput" type="text" value="1" class="searchField w3-input w3-round w3-small" onkeyup="">
			</div>
			<button class="w3-small" id="addItem" onclick="addItemToList();">Add</button>
			<button class="w3-small" id="resetItem" onclick="resetAction()">Reset</button>
		</div>
	</div>

	<div class="w3-row w3-container" style="width: 100%" id="summary">
		<div class="w3-right-align">
			<button class="w3-small" id="submitItem" onclick="submitAction();">Submit</button>
		</div>
		<div class="w3-medium w3-center">Items List</div>
		<table class="w3-small" id="implantTableList" width="100%">
			<thead>
				<tr>
					<th class="w3-small" width="2%"></th>
					<th class="w3-small hiddenField">deptCode</th>
					<th class="w3-small" width="15%">Department</th>
					<th class="w3-small hiddenField">categoryCode</th>
					<th class="w3-small" width="10%">Category</th>
					<th class="w3-small hiddenField">companyCode</th>
					<th class="w3-small" width="20%">Company</th>
					<th class="w3-small hiddenField">itmCode</th>
					<th class="w3-small" width="40%">Model [Ref#]</th>
					<th class="w3-small" width="10%">Lot#</th>
					<th class="w3-small" width="3%">Qty</th>
				</tr>
			</thead>
			<tbody class="w3-small"></tbody>
		</table>

	</div>

</body>
<script type="text/javascript"
	src="<html:rewrite page="/js/jquery.cookie.js" />" /></script>
<script type="text/javascript"
	src="<html:rewrite page="/js/jquery.dcdrilldown.1.2.min.js" />" /></script>
<script type="text/javascript"
	src="<html:rewrite page="/js/filterlist.js" />"></script>
<script language="JavaScript">
var msg = "Please click 'Update' before edit.";
var mode = "<%=mode %>";
var regid = "<%=regid %>";
var userid = "<%=userid %>";
var source = "<%=source %>";
var patno = "<%=patno %>";
var otlid = "<%=otlid %>";

	var eqDeptCode, eqCategoryCode, eqCompanyCode, eqItmCode;
	var eqDept, eqCategory, eqCompany, eqItem;
	var eqLot, eqQty;

	$(document).ready(function() {
		$(document).keypress(function(e) {
			if (e.which == 13) { // 13 = "ENTER"
				addItemToList();
			}
		});
		$(document).mousedown(function(e) {
			if (e.which == 3) {
				$('.dropdown-content').css('display', 'none');
			}
		});
	});

	function filterFunction(inputField, section) {
		var a, i;
		inputField = inputField.toUpperCase();
		div = document.getElementById(section);
		a = div.getElementsByTagName("li");
		if (section == "modelSection" && inputField.substring(0, 1) == "*") {
			$.ajax({
				url : "consignmentTracking_ajax.jsp",
				data : {
					"action" : "searchItem",
					"searchText" : inputField.substring(1)
				},
				type : 'POST',
				dataType : 'html',
				cache : false,
				success : function(data) {
					$("#itemList").html(data);
						$('#itemList').css('display', 'block');

				},
				error : function(data) {
					alert("Cannot find the item!");
				}
			});
		} else {
			for (i = 0; i < a.length; i++) {
				txtValue = a[i].textContent || a[i].innerText;
				if (txtValue.toUpperCase().indexOf(inputField) > -1) {
					a[i].style.display = "";
				} else {
					a[i].style.display = "none";
				}
			}
		}
	}
	
	function clearVar(inputField, section) {
		if (inputField.trim() == '') {
			if (section == "categorySection") {
				eqCategory = '';
			}
		}
	}
	
	function changeCategoryCompanyList(dept) {
		changeCategoryList(dept);
		changeCompanyList();
	}

	function changeCategoryList(dept) {
		eqDept = dept.value + "-";
		$("#deptInput").val(dept.innerHTML.trim());
		$("#deptCodeInput").val(eqDept);
		$('#deptList').css('display', 'none');
		$("#categoryInput").val("");
		$("#categoryCodeInput").val("");
		$("#companyInput").val("");
		$("#companyCodeInput").val("");
		$("#itemInput").val("");
		$("#itemCodeInput").val("");
		$("#lotInput").val("");
		$.ajax({
			url : "consignmentTracking_ajax.jsp",
			data : {
				"action" : "changeCategory",
				"eqDept" : eqDept
			},
			type : 'POST',
			dataType : 'html',
			cache : false,
			success : function(data) {
				$("#categoryList").html(data);

			},
			error : function(data) {
				alert("Cannot find the item!");
			}
		});
	}

	function changeCompanyList(category) {
		if (category != null) {
			eqCategory = category.getAttribute('value');
			$("#categoryInput").val(category.innerHTML.trim());
			$("#categoryCodeInput").val(eqCategory);
			$('#categoryList').css('display', 'none');
		}
		$("#companyInput").val("");
		$("#companyCodeInput").val("");
		$("#itemInput").val("");
		$("#itemCodeInput").val("");
		$("#lotInput").val("");
		$.ajax({
			url : "consignmentTracking_ajax.jsp",
			data : {
				"action" : "changeCompany",
				"eqCategory" : eqCategory,
				"eqDept" : eqDept
			},
			type : 'POST',
			dataType : 'html',
			cache : false,
			success : function(data) {
				$("#companyList").html(data);

			},
			error : function(data) {
				alert("Cannot find the item!");
			}
		});
	}

	function changeItemList(company) {
		eqCompany = company.getAttribute('value');
		$("#companyInput").val(company.innerHTML.trim());
		$("#companyCodeInput").val(eqCompany);
		$('#companyList').css('display', 'none');
		$("#itemInput").val("");
		$("#itemCodeInput").val("");
		$("#lotInput").val("");
		$("#loader").show();
		$.ajax({
			url : "consignmentTracking_ajax.jsp",
			data : {
				"action" : "changeItem",
				"eqCategory" : eqCategory,
				"eqCompany" : eqCompany,
				"eqDept" : eqDept
			},
			type : 'POST',
			dataType : 'html',
			cache : false,
			success : function(data) {
				//$("#itemList").html(data);
				document.getElementById("itemList").innerHTML = data;
				$('#itemList').css('display', 'block');
				
				$("#loader").hide();
			},
			error : function(data) {
				alert("Cannot find the item!");
				
				$("#loader").hide();
			}
		});
	}

	function updateByItem(item) {
		eqItem = item.getAttribute('value');
		$('#itemList').css('display', 'none');
		$("#lotInput").val("");
		$.ajax({
			url : "consignmentTracking_ajax.jsp",
			data : {
				"action" : "searchItemDetail",
				"searchText" : eqItem
			},
			type : 'POST',
			dataType : 'html',
			cache : false,
			success : function(data) {
				$("#itemList").html(data);
			},
			error : function(data) {
				alert("Cannot find the item!");
			}
		});
		$('#lotInput').focus();
	}

	function resetAction() {
		$("#deptInput").val("");
		$("#deptCodeInput").val("");
		$("#categoryInput").val("");
		$("#categoryCodeInput").val("");
		$("#companyInput").val("");
		$("#companyCodeInput").val("");
		$("#itemInput").val("");
		$("#itemCodeInput").val("");
		$("#lotInput").val("");
		$("#qtyInput").val("1");
		
		eqCategory = '';
	}

	function addItemToList() {
		$('.dropdown-content').css('display', 'none');
		eqDeptCode = $("#deptCodeInput").val();
		eqDetp = $("#deptInput").val();
		eqCategoryCode = $("#categoryCodeInput").val();
		eqCategory = $("#categoryInput").val();
		eqCompanyCode = $("#companyCodeInput").val();
		eqCompany = $("#companyInput").val();
		eqItmCode = $("#itemCodeInput").val();
		eqItem = $("#itemInput").val();
		eqLot = $("#lotInput").val();
		eqQty = $("#qtyInput").val();
		if (eqDeptCode == "" || eqCategoryCode == "" || eqItmCode == "" || eqLot == "") {
			alert("All fields are required.");
			return;
		}
		var tempId = eqItmCode + ":l:" + eqLot;
		$("#implantTableList")
				.find('tbody')
				.append($("<tr class='eachitem' id='"+ tempId +"'>")
				.append($("<td>")
				.append("<button id='" + eqLot + "' class='removeItem' onclick=removeItem(this)>X</button>"))
				.append($("<td class='submitDept hiddenField'>").append(eqDeptCode))
				.append($("<td>").append(eqDetp))
				.append($("<td class='hiddenField'>").append(eqCategoryCode))
				.append($("<td>").append(eqCategory))
				.append($("<td class='hiddenField'>").append(eqCompanyCode))
				.append($("<td>").append(eqCompany))
				.append($("<td class='submitItmcode hiddenField'>").append(eqItmCode))
				.append($("<td>").append(eqItem))
				.append($("<td class='submiteqLot'>").append(eqLot))
				.append($("<td class='submiteqQty'>").append(eqQty)));
		resetAction();
		$("#itemInput").focus();

	}

	function submitAction() {
		var selectItem = "";
		if ($('#implantTableList .eachitem').length <= 0) {
			alert("No item is entered.");
			return false;
		}
		$("#submitItem").attr("disabled", true);
		$('#implantTableList .eachitem')
				.each(
					function() {
						var submitDept = $.trim($(this).find(".submitDept").html());
						var submitItmcode = $.trim($(this).find(".submitItmcode").html());
						var submiteqLot = $.trim($(this).find(".submiteqLot").html());
						var submiteqQty = $.trim($(this).find(".submiteqQty").html());
						if (selectItem.length != 0)
							selectItem += "|";
						selectItem += submitDept + ":" + submitItmcode + ":" + submiteqLot + ":" + submiteqQty;
					});
		//console.log(selectItem);
		$.ajax({
			url : "consignmentTracking_ajax.jsp",
			data : {
				"action" : "saveImplant",
				"source" : source,
				"patno" : patno,
				"regid" : regid,
				"otlid" : otlid,
				"userid" : userid,
				"selectItem" : selectItem
			},
			type : 'POST',
			dataType : 'html',
			cache : false,
			success : function(data) {
				if ($.trim(data) == "-1") {
					alert("Error Occur! Please try again later.");
					$("#submitItem").attr("disabled", false);
				} else {
					alert("Implant list saved.");
					$("button").attr("disabled", true);
				}
			},
			error : function(data) {
				alert($.trim(data));
			}
		});
	}

	function removeItem(row) {
		//document.getElementById(row).remove();
		var i = row.parentNode.parentNode.rowIndex;
		document.getElementById("implantTableList").deleteRow(i);
	}
</script>
</html:html>