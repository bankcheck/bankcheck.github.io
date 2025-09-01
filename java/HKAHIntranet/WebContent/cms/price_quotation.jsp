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
String mode = request.getParameter("mode"); //create, view, update
String regid = request.getParameter("regid"); 
String userid = request.getParameter("user"); 
String patno = request.getParameter("patno"); 
String pqId = request.getParameter("pqID");
String source = request.getParameter("source"); // "fe"= financialEstimationRpt.jsp
String acmcode = request.getParameter("acmcode");
String group = request.getParameter("group"); // filter OT menu

String docCode = "";
String docName = "";
String patType = "";
String version = "";
String totalPrice = "0";

Boolean isDoctor = false;
Boolean isRegid = false;

if(userid.startsWith("dr"))
	isDoctor = true;

record = PriceQuotationDB.getQuotation(regid, patno);	
if(record.size()>0){
	row = (ReportableListObject) record.get(0);
	if("NEW".equals(row.getValue(0))){
		mode = "create";
		pqId = "NEW QUOTATION";
		version = "1";
	}else{
		mode = "view";
		pqId = row.getValue(0);
		version = row.getValue(4);
		totalPrice = row.getValue(5);
	}
	patno = "".equals(row.getValue(1))?patno:row.getValue(1);
	docCode = row.getValue(2);
	docName = "".equals(row.getValue(3))?"":"Dr. " + row.getValue(3);
}else{
	mode = "create";
	version = "1";
}

if(regid!= null){
	isRegid = true;
}else{
	regid = "";
}
if(source == null){
	source = "pq";
}
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
<script type="text/javascript" src="<html:rewrite page="/js/jquery.cookie.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.dcdrilldown.1.2.min.js" />" /></script>
<head>
<style>
	.itm{font-size: smaller;}
	.itemTabName{font-size: smaller;}
	.bold{font-weight: bold;}
	#updateButton{margin:0 7px 0 0;border:1px solid #dedede;border-top:1px solid #eee;border-left:1px solid #eee;font: 12px Arial, Helvetica, sans-serif;font-size:100%;line-height:100%;text-decoration:none;color:#565656;cursor:pointer;padding:5px 10px 6px 7px;}
</style>
</head>
<body style="background:aliceblue;">
	<div class="w3-container w3-center ah-pink ">
		<span class="w3-xxlarge bold  ">Price Estimation - <span class="bold" id="currentCategory"></span></span>
		<span id="viewOnly"><%="view".equals(mode)?" (View ONLY) <button id='updateButton' onclick='updateQuotation()' />Update</button>":"" %></span>
	</div>

	<div class="w3-container w3-tiny ah-pink w3-right w3-display-topright">
		<%if(isRegid){ %>
			Registration Number: <%=regid== null?"":regid %><br/>
			Doctor: <%=docName %> <%="".equals(docCode)?"":"("+docCode+")" %><br/>
		<%} %>
		Patient No.: <%=patno== null?"":patno %>
	</div>
	<div class="w3-container w3-tiny ah-pink w3-left w3-display-topleft">
		<%if(isRegid){ %>
			<span id="pqId" >Quotation Number.: <%=pqId==null?"":pqId %></span><br/>
			<span id="version" >Version: <%=version %></span><br/>
		<%} %>
		Updating User: <%=userid %><br/>
	</div>
	<%if(!isRegid){ %>
		<div class="w3-container w3-center" style="background:#DFDFDF;">
			Quotation without registration number will not be save.
		</div>
	<%} %>
	<div class="w3-row">
		<div class="w3-col w3-container" style="width:13%" id="menu" >
 			<ul class="w3-ul w3-hoverable">
			<% 
			record = PriceQuotationDB.getMenu(null, group);
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
			%>
				<li onclick="changeCategory('<%=row.getValue(0) %>');return false;" style="padding: 8px 0px;">
					<a class="w3-medium" href="javascript:void(0);" id="<%=row.getValue(0) %>"><%=row.getValue(1) %></a>
				</li>
			<%
				}
			}
			%>
			</ul>
		</div>
	
		<div class="w3-col w3-container w3-white" style="height:100%; width:55%" id="content" >
			<br/>
			<div>
				<span class="" id="patTypeContent" >Patient Type:</span>
				<select class="w3-border" id="patType" onchange="changePatType()">
					<option value="O">Outpatient</option>
					<option value="D">Daycase</option>
					<%
						record = PriceQuotationDB.fetchClass();
						if (record.size() > 0) {
							for (int i = 0; i < record.size(); i++) {
								row = (ReportableListObject) record.get(i);
					%>
									<option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(acmcode)?" selected":"" %>>Inpatient - <%=row.getValue(1) %></option>
					<%
							}
						}
					%>
				</select>
			</div>
			<div id="optionContent">
			</div>
			<div id="contrast" class="form-popup w3-container w3-pale-red w3-display-middle" style="display:none;height: 120px;width: 400px;">
				<div class="w3-center" style="width:100%">
					<input type="hidden" id="tempBox_contrast" name="tempBox_contrast" value=""/>
					<input type="hidden" id="tempItmCode" name="tempBox_contrast" value=""/>
					<button class="w3-display-topright" onclick="$('#contrast').css('display','none'); ">x</button>
					<br/>Contrast:<br/>
					<button id="contrast_plain" class="w3-button w3-white w3-border w3-border-red" onclick="selectContrast('1','Plain');">Plain</button>
					<button id="contrast_plainAndContrast" class="w3-button w3-white w3-border w3-border-red" onclick="selectContrast('3','Plain and Contrast');">Plain and Contrast</button>
					<button id="contrast_optional" class="w3-button w3-white w3-border w3-border-red" onclick="selectContrast('3','Optional');">Optional</button>
				</div>
			</div>
			<div class="w3-row" id="itemContent">
			</div>
			<br/>
		</div>
	
		<div class="w3-col w3-container" style="width:32%" id="summary">
			<div class="w3-medium w3-center">Ordered Items</div> 
			<table class="w3-small" id="OrderedItemTable"  width="100%">
				<tr>
					<th class="w3-small"></th>
					<th class="w3-small">Type</th>
					<th class="w3-small">Itm. Code</th>
					<th class="w3-small">Description</th>
					<th class="w3-small">Options</th>
					<th class="w3-small">Price</th>
				</tr>
				<%
				//get quotation item
				if(pqId != null && "view".equals(mode)){
					record = PriceQuotationDB.getPreviousQuotation(pqId);
					if(record.size()>0){
						for(int i=0; i<record.size(); i++){
							row = (ReportableListObject) record.get(i);
							patType = row.getValue(1);
							if("I".equals(row.getValue(1)))
								patType = row.getValue(2);
				%>
				<tr class="eachitem" id="<%=row.getValue(0) %>">
					<td>
						<%	if("XUC10".equals(row.getValue(0))||"XUC11".equals(row.getValue(0))||"XUC20".equals(row.getValue(0))||"XUC21".equals(row.getValue(0))){%>
							 Mammogram Package
						<% }else if("XZ005".equals(row.getValue(0))||"XZ007".equals(row.getValue(0))){%>
						<% }else{%>
						<button class="removeitem" onclick="removeItem('<%=row.getValue(0) %>')">X</button>
						<%} %>
					</td>
					<td class="patType" style="display:none">
						<%=patType %>
					</td>
					<td class="patTypeDesc">
						<%=row.getValue(3) %>
					</td>
					<td class="pqItmPrefix"  style="display:none">
						<%=row.getValue(4) %>
					</td>
					<td class="itmCodeDesc">
						<%=row.getValue(6).length()>0?row.getValue(6):row.getValue(5) %>
					</td>
					<td class="itmCode" style="display:none">
						<%=row.getValue(5) %>
					</td>
					<td class="pkgCode" style="display:none">
						<%=row.getValue(6) %>
					</td>
					<td class="itmDesc">
						<%=row.getValue(7) %><%=row.getValue(8).length()>0? " - " + row.getValue(8) :"" %>
					</td>
					<td class="contrastDesc" style="display:none">
						<%=row.getValue(8) %>
					</td>
					<td class="timeslot" style="display:none">
						<%=row.getValue(9) %>
					</td>
					<td class="optiondesc">
						<%=row.getValue(10) %>
					</td>
					<td class="price" >
						$<%=row.getValue(11) %>
					</td>
				</tr>
				<%
						}
					}
				}
				%>
			</table>
			<span class="w3-small bold">Total: $<span class="bold" id="itmSum" name="itmSum" ><%=totalPrice %></span> </span>
			<div>
				<%if(isDoctor){ %><button class="w3-small" id="addFavor" onclick="return addFavorList();">Add to My Favor</button><%} %>
				<button class="w3-small" id="newForm" onclick="refresh();">New Request Form</button>
				<button class="w3-small" id="print" onclick="printAction()">Save and Print Estimation</button>
				<button class="w3-small" id="save" onclick="submitAction();">Save</button>
				<br/>
				<%if("fe".equals(source)){ %><button class="w3-small" id="toFE" onclick="toFE();">Save and Back to Financial Estimation</button><%} %>
			</div>
		</div>
	</div>
</body>
<script language="JavaScript">
var msg = "Please click 'Update' before edit.";
var category = "";
var docCode = "<%=docCode %>";
var userid = "<%=userid %>";
var patno = "<%=patno %>";
var regid = "<%=regid %>";
var pqId = "<%=pqId %>";
var mode = "<%=mode %>";
var version = "<%=version %>";
var source = "<%=source %>";
var group = "<%=group %>";

if(mode == "view"){
	disabled = "disabled";
	$('select').attr('disabled', true);
}else{
	disabled = "";
	$('select').attr('disabled', false);
	$("button").attr("disabled", false);
	$("#updateButton").css('display','block'); 
	$(".removeitem").attr("disabled", false);
}

$(document).ready(function(){
	changeCategory("LB");
	<%if(!isRegid){%>
		$("#save").attr("disabled", true);
		$("#save").addClass("w3-disabled");
		$("#print").html("Print Only");
	<%} %>
	<%if("fe".equals(source) && acmcode.length() > 0 ){ %>
		$("select").attr("disabled", true);
		<%if(!acmcode.equals(patType) && patType.length() > 0 ){ %>
			$("#patTypeContent").addClass("w3-text-red bold");
			$(".patTypeDesc").addClass("w3-text-red bold");
			if(confirm("The patient type of the previous quotation does not match to the financial estimation.\nWould you like to update the quotation?")){
				updateQuotation();
			}
		<%}%>
	<%}%>
});

function refresh(){
	if(mode == "view"){
		alert(msg);
		return false;
	}else{
		if(confirm("Reset all items for this reservation?")){
			if(mode == "view"){
				$('#OrderedItemTable .eachitem').each(function() {
					clickedBox = $(this).context.id;
					removeItem(clickedBox);
				});
				updateQuotation();
			}else if (mode == "update"){
				$('#OrderedItemTable .eachitem').each(function() {
					clickedBox = $(this).context.id;
					removeItem(clickedBox);
				});
			}else{
				window.location.assign(window.location.href);
			}
		}else{
			return false;
		}
	}
}

function changeCategory(pqCategory) {
	var categoryDesc = $.trim($("#"+pqCategory).html());
	$.ajax({
        url: "priceQuotation_action.jsp",
        data: {	"action" : "getOption",
        		"pqCategory" : pqCategory,
        		"disabled" : disabled
				},
        type: 'POST',
        dataType: 'html',
		cache: false,
        success: function(data){
        	$("#optionContent").html(data);
        	$("#currentCategory").text(categoryDesc);
        	
        },
       	error: function(data){
       		alert ("Cannot find the item!");
       	}
    });
	$.ajax({
        url: "priceQuotation_action.jsp",
        data: {	"action" : "getItem",
        		"pqCategory" : pqCategory,
        		"userid" : userid,
        		"disabled" : disabled
				},
        type: 'POST',
        dataType: 'html',
		cache: false,
        success: function(data){
        	$("#itemContent").html(data);
        	category = pqCategory;
        	$('#OrderedItemTable .eachitem').each(function() {
        		clickedBox = $(this).context.id;  
        		if(clickedBox.indexOf(category)>=0)
        			$('#'+clickedBox).attr("checked", true);
			});
        },
       	error: function(data){
       		alert ("Cannot find the item!");
       	}
    });
}

function changePatType(){
	var patType = $("#patType").val();
	var option = "";
	$('#OrderedItemTable .eachitem').each(function() {
		clickedBox = $(this).context.id;  
		itmCode = clickedBox.substring(2);
		pkgCode = $.trim($(this).find(".pkgCode").html());
		category = clickedBox.substring(0,2);
		pqItmPrefix = $.trim($(this).find(".pqItmPrefix").html());
		timeslot = $.trim($(this).find(".timeslot").html());
		contrastDesc = $.trim($(this).find(".contrastDesc").html());
		if(pkgCode.length > 0){
			option = pkgCode.substring(0,2);	
		}else{
			if(timeslot == "5"){
				option = "XZ005";
			}else if(timeslot == "7"){
				option = "XZ007";
			}else{
				option = pqItmPrefix;
			}
		}
		if(contrastDesc.length == 0)
			contrastDesc = null;
		if(itmCode.indexOf("x")>0){
			contrast = $.trim($(this).find(".itmCode").html()).substring($.trim($(this).find(".itmCode").html()).length-1);
		}else{
			contrast = null;
		}
		removeItem(clickedBox);
		if(clickedBox=="XUC11"||clickedBox=="XUC10"||clickedBox=="XUC20"||clickedBox=="XUC21"){
		}else if(clickedBox == "XZ005") {
			addItem("changePatType", "XZ", patType, "005", "XZ", "XZ", "5", 'X', clickedBox);
		}else if(clickedBox == "XZ007") {
			addItem("changePatType", "XZ", patType, "007", "XZ", "XZ", "7", 'X', clickedBox);
		}else{
			addItem("changePatType", category, patType, itmCode, option, pqItmPrefix, contrast, timeslot, clickedBox, contrastDesc);
		}
	 });
	
	if(category=="XZ"){
		changeCategory("XR");
	}else{
		changeCategory(category);
	}
}

function selectOption(val){
	if(mode == "view"){
		alert(msg);
		return false;
	}else{
		$("#"+val).attr('checked',true);	
	}
}

function selectContrast(contrast,contrastDesc) {
	var clickedBox = $('#tempBox_contrast').val();
	var itmCode = $('#tempItmCode').val();
	selectItem(clickedBox,itmCode,contrast,contrastDesc);
};

function selectItem(clickedBox,itmCode,contrast,contrastDesc){
	if(mode == "view"){
		alert(msg);
		return false;
	}
	var pqCategory = category;
	var pqItmPrefix = $.trim($("#pqItmPrefix").html());
	var patType = $('#patType').val();
	var option = $('input[name=select_pqOption]:checked').val()==null?"":$('input[name=select_pqOption]:checked').val();
	var timeslot = "";
	var isClicked = false; 
	if(option.indexOf("-")>=0){
		timeslot = option.split("-")[1];
		option = option.split("-")[0];
	}
	$('#OrderedItemTable .eachitem').each(function() {
		var checkingBox = $(this).context.id; 
	    if(checkingBox==clickedBox){
	    	isClicked = true;
	    	return false;
	    }
	 });
	
	if(!isClicked){
		if(itmCode.indexOf("x")>0){
			if(contrast == null || contrast.length <= 0){
				$("#contrast").css('display','block'); 
				if(pqCategory == "XP"){
					$("#contrast_optional").addClass('w3-disabled');
					$("#contrast_optional").attr('disabled','disabled');
				}else{
					$("#contrast_optional").removeClass('w3-disabled');
					$("#contrast_optional").attr('disabled','');
				}
				$("#tempBox_contrast").val(clickedBox);
				$("#tempItmCode").val(itmCode);
				return false;
			}
		}
		addItem("addItm", pqCategory, patType, itmCode, option, pqItmPrefix, contrast, timeslot, clickedBox, contrastDesc);
	}else{
		removeItem(clickedBox);
	}
}

function addItem(action, pqCategory, patType, itmCode, option, pqItmPrefix, contrast, timeslot, clickedBox, contrastDesc){
	var changePatType = false;
	if(action == "changePatType"){
		changePatType = true;
		action = "addItm";
	}
	$.ajax({
        url: "priceQuotation_action.jsp",
        data: {	"action" : action,
        		"pqCategory" : pqCategory,
        		"patType" : patType,
        		"itmCode" : itmCode,
        		"option" : option,
        		"pqItmPrefix" : pqItmPrefix,
        		"contrast" : contrast,
        		"timeslot" : timeslot,
        		"contrastDesc" : contrastDesc
				},
        type: 'POST',
        dataType: 'html',
		cache: false,
        success: function(data){
        	if(data.indexOf("alert")>0){
        		$("#"+clickedBox).attr('checked',false);
        	}else{
        		$("#"+clickedBox).attr('checked',true);
        	}
        	$('#OrderedItemTable').append(data);
        	$("#contrast").css('display','none'); 
        	$('input[name=select_contrast]').attr('checked',false);
        	//Special Case for MM010 and MM011
        	if(pqCategory == "MM" && itmCode == "010"){ 
    			if(option == "XM"){
    				addItem(action, "XU", patType, "C10", "XU", "XU", null, timeslot, clickedBox);
    			}else {
    				addItem(action, "XU", patType, "C10", "RO"==option?"RU":"UO"==option?"UU":null, "XU", null, timeslot, clickedBox);
    			}
    		}else if(pqCategory == "MM" && itmCode == "011"){
    			if(option == "XM"){
    				addItem(action, "XU", patType, "C11", "XU", "XU", null, timeslot, clickedBox);
    			}else {
    				addItem(action, "XU", patType, "C11", "RO"==option?"RU":"UO"==option?"UU":null, "XU", null, timeslot, clickedBox);
    			}
    		}else if(pqCategory == "MM" && itmCode == "020"){
    			if(option == "XM"){
    				addItem(action, "XU", patType, "C20", "XU", "XU", null, timeslot, clickedBox);
    			}else {
    				addItem(action, "XU", patType, "C20", "RO"==option?"RU":"UO"==option?"UU":null, "XU", null, timeslot, clickedBox);
    			}
    		}else if(pqCategory == "MM" && itmCode == "021"){
    			if(option == "XM"){
    				addItem(action, "XU", patType, "C21", "XU", "XU", null, timeslot, clickedBox);
    			}else {
    				addItem(action, "XU", patType, "C21", "RO"==option?"RU":"UO"==option?"UU":null, "XU", null, timeslot, clickedBox);
    			}
    		}
        	if(!changePatType && timeslot == "5"){//Special Case for XZ005
        		var isClicked = false;
        		$('#OrderedItemTable .eachitem').each(function() {
					var checkingBox = $(this).context.id; 
				    if(checkingBox=="XZ005"){
				    	isClicked = true;
				    }
				 });
        		if(!isClicked)
        			addItem(action, "XZ", patType, "005", "XZ", "XZ", null, 'X', clickedBox);
        	}
        	if(!changePatType && timeslot == "7"){//Special Case for XZ007
        		var isClicked = false;
        		$('#OrderedItemTable .eachitem').each(function() {
					var checkingBox = $(this).context.id; 
				    if(checkingBox=="XZ007"){
				    	isClicked = true;
				    }
				 });
        		if(!isClicked)
        			addItem(action, "XZ", patType, "007", "XZ", "XZ", null, 'X', clickedBox);
        	}
        },
       	error: function(data){
       		alert ("Cannot find the item!");
       	}
    });
}

function removeItem(clickedBox){
	if(mode == "view"){
		alert(msg);
		return false;
	}else{
		var timeslot = $.trim($('#OrderedItemTable #'+clickedBox).find(".timeslot").html());
		var itmCode = $.trim($('#OrderedItemTable #'+clickedBox).find(".itmCode").html());
		var itmPrice = $.trim($('#OrderedItemTable #'+clickedBox).find(".price").html()).substring(1);
		var itmSum = $("#itmSum").text();
		itmSum = itmSum - itmPrice;
		$('#itmSum').text(itmSum);
		$('#OrderedItemTable #'+clickedBox).remove();
		$("#"+clickedBox).attr('checked',false);
		if(timeslot == "5"){
			hvUrgentReport = false;
			$('#OrderedItemTable .eachitem').each(function() {
				var checkingBox = $.trim( $(this).find(".timeslot").html() );
			    if(checkingBox=="5")
			    	hvUrgentReport = true;
			 });
			if(!hvUrgentReport)
				removeItem('XZ005');
		}
		if(timeslot == "7"){
			hvUrgentReport = false;
			$('#OrderedItemTable .eachitem').each(function() {
				var checkingBox = $.trim( $(this).find(".timeslot").html() );
			    if(checkingBox=="7")
			    	hvUrgentReport = true;
			 });
			if(!hvUrgentReport)
				removeItem('XZ007');
		}
		if(clickedBox == 'MM010'){
			removeItem('XUC10');
		}else if(clickedBox == 'MM011'){
			removeItem('XUC11');
		}else if(clickedBox == 'MM020'){
			removeItem('XUC20');
		}else if(clickedBox == 'MM021'){
			removeItem('XUC21');
		}
	}
}

function addFavorList(){
	if(mode == "view"){
		alert(msg);
		return false;
	}else{
		var clickedBox = "";
		$('#OrderedItemTable .eachitem').each(function() {
			if(clickedBox.length > 0)
				clickedBox += ",";
			clickedBox += $(this).context.id;  
		 });
		$.ajax({
	        url: "priceQuotation_action.jsp",
	        data: {	"action" : "addFavor",
	        		"userid" : userid,
	        		"clickedBox" : clickedBox
					},
	        type: 'POST',
	        dataType: 'html',
			cache: false,
	        success: function(data){
	        	if($.trim(data) == "-1"){
	        		alert ("Error / Item is in favor list!");
	        	}else{
	        		alert ("Items added into your favor list. ");
		        	changeCategory(category);
	        	}
	        },
	       	error: function(data){
	       		alert ("Error / Item is in favor list!");
	       	}
	    });
	}
}

function submitAction(action) {
	if(mode == "view"){
		alert(msg);
		return false;
	}else{
		if(patno == null || patno.length == 0){
			alert("Error occur. Missing Patient No.");
			return false;
		}
		if($('#OrderedItemTable .eachitem').length <= 0){
			alert("No item is selected.");
			return false;
		}
		var selectItem = "";
		if(mode == "update")
			version = parseInt(version) +  1 ;	
		$('#OrderedItemTable .eachitem').each(function(){
			var clickedBox = $(this).context.id;  
		    var patType = $.trim( $(this).find(".patType").html() );
		    var timeslot = $.trim( $(this).find(".timeslot").html() );
		    var itmCode = $.trim( $(this).find(".itmCode").html() );
		    var pkgCode = $.trim( $(this).find(".pkgCode").html() );
			var price =$.trim( $(this).find(".price").html() ).substring(1);
			if(selectItem.length!=0)
				selectItem += ";";
			selectItem += patType + "," + itmCode + "," + pkgCode + "," + timeslot + "," + price + "," + clickedBox;
		});
		$.ajax({
	        url: "priceQuotation_action.jsp",
	        data: {	"action" : "saveQuotation",
	        		"source" : source,
	        		"docCode" : docCode,
	        		"patno" : patno, 
	        		"regid" : regid,
	        		"version" : version, 
	        		"userid" : userid, 
	        		"selectItem" : selectItem
					},
	        type: 'POST',
	        dataType: 'html',
			cache: false,
	        success: function(data){
	        	pqId = $.trim(data);
	        	if($.trim(data) == "-1"){
	        		alert("Error Occur! Please try again later.");
	        	}else{
		    		if(action == "print"){
		    			showLoadingBox('body', 500, $(window).scrollTop());
		    			window.location.href = "/intranet/cms/priceQuotation_action.jsp?action=print&pqId=" + pqId;
		    		}else if(action == "toFE"){
		    			showLoadingBox('body', 500, $(window).scrollTop());
		    			window.location.href = "/intranet/financialEstimate/financialEstimationRpt.jsp?pqId=" + pqId;
		    		}else{
		    			alert("Price Quotation saved.");
		    			window.location.assign(window.location.href);
		    		}
	        	}
	        },
	        error: function(data){
	        	alert($.trim(data));
	        }
		});
	}
}

function printAction(){
	if(mode != "view"){
		submitAction("print");
	}else{
		showLoadingBox('body', 500, $(window).scrollTop());
		window.location.href = "/intranet/cms/priceQuotation_action.jsp?action=print&pqId=" + pqId;
	}
}

function toFE(){
	if(mode != "view"){
		submitAction("toFE");
	}else{
		showLoadingBox('body', 500, $(window).scrollTop());
		window.location.href = "/intranet/financialEstimate/financialEstimationRpt.jsp?pqId=" + pqId + "&group=" + group;
	}
}

function updateQuotation(){
	pqId = null;
	$("#pqId").append(" (Updating...)");
	$("#version").append(" --> " + (parseInt(version) +  1) );
	mode = "update";
	disabled = "";
	if(source != "fe"){
		$('select').attr('disabled', false);	
	}
	$("button").attr("disabled", false);
	$("#viewOnly").css('display','none');
	$(".removeitem").attr("disabled", false);
	changePatType();
	$("#patTypeContent").removeClass("w3-text-red bold");
}
</script>
</html:html>