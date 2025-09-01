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
String dpcid = request.getParameter("dpcid");
String source = request.getParameter("source"); // "fe"= financialEstimationRpt.jsp
String acmcode = request.getParameter("acmcode");

String docCode = "";
String docName = "";
String patType = "";
String version = "";
String totalPrice = "0";
String regType = "";
String regOPCat = "";
String slpNo = "";
boolean isInHATS = false;

Boolean isDoctor = false;
Boolean isRegid = false;

if(userid.startsWith("dr"))
	isDoctor = true;

record = DoctorChargeDB.getDrProcCharge(regid, patno);	
if(record.size()>0){
	row = (ReportableListObject) record.get(0);
	if("NEW".equals(row.getValue(0))){
		mode = "create";
		dpcid = "NEW CHARGE SLIP";
		version = "1";
	}else{
		mode = "view";
		dpcid = row.getValue(0);
		version = row.getValue(4);
		totalPrice = row.getValue(5);
	}
	patno = "".equals(row.getValue(1))?patno:row.getValue(1);
	docCode = row.getValue(2);
	docName = "".equals(row.getValue(3))?"":"Dr. " + row.getValue(3);
	slpNo = row.getValue(6);
	regType = row.getValue(7);
	patType = regType;
	regOPCat = row.getValue(8);
}else{
	mode = "create";
	version = "1";
}

if (regid == null || "".equals(regid)){
	mode = "view";
	regid = "";
	isRegid = false;
} else {
	isRegid = true;
}

if(source == null){
	source = "";
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

	@media screen and (min-width: 1601px) {
	  .unitInput {width:27%; display:inline !important;  text-align: center;}
      .less { padding:7px 11px;}
      .add{ padding:7px 11px;}
     }
     
	@media screen and (max-width: 1600px) {
	  .unitInput {width:30%;display:inline !important; text-align: center;}
      .less { padding:4px 4px;}
      .add{ padding:4px 4px;}
      .itmDesc {max-width: 156px;}
     }
</style>
</head>
<body style="background:aliceblue;">
	<div class="w3-container w3-center ah-pink " <%="view".equals(mode)?" style=\"height:33px;\"":"" %>>
		<span class="w3-large bold  ">Doctor Procedure Charge <span class="bold" id="currentCategory"><br></span></span>
		<span id="viewOnly"><%="view".equals(mode)?"(View ONLY) <button id='updateButton' onclick='updateQuotation()' />Update</button>":"" %></span>
	</div>

	<div class="w3-container w3-tiny ah-pink w3-right w3-display-topright">
		<%if(isRegid){ %>
			Registration Number: <%=regid== null?"":regid %>Doctor: <%=docName %> <%="".equals(docCode)?"":"("+docCode+")" %>
		<%} %>
		Patient No.: <%=patno== null?"":patno %>
		Reg Type: <%=regType==null?"":regType %>
		Slip No.:<%=slpNo==null?"":slpNo %>
	</div>
	<div class="w3-container w3-tiny ah-pink w3-left w3-display-topleft">
		<%if(isRegid){ %>
			<span id="dpcid" >Charge No.: <%=dpcid==null?"":dpcid %></span><span id="version" > Version: <%=version %></span>
		<%} %>
		Updating User: <%=userid %><br/>
	</div>
	<%if(!isRegid){ %>
		<div class="w3-container w3-center" style="background:#DFDFDF;">
			Charge Slip without registration number will not be save.
		</div>
	<%} %>
	<div class="w3-row">
		<div class="w3-col w3-container" style="width:6%" id="menu" >
 			<ul class="w3-ul w3-hoverable">
			<% 
			record = DoctorChargeDB.getMenu();
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
			%>
				<li onclick="changeCategory('<%=row.getValue(0) %>');return false;" style="padding: 3px 0px;">
					<a class="w3-small" href="javascript:void(0);" id="<%=row.getValue(0) %>"><%=row.getValue(1) %></a>
				</li>
			<%
				}
			}
			%>
			</ul>
		</div>
	
		<div class="w3-col w3-container w3-white" style="height:100%; width:66%; padding:0px 2px; " id="content" >
			<div  style="padding:2px 0px; line-height: normal;">
				<span class="" id="patTypeContent">Search:</span>
				<input id="keyWord" class="w3-input w3-border w3-light-grey keyWord" type="text" style="width:50%; display:inline !important; padding:2px;"></input>
				<button id="searchKW" class="w3-btn searchKW" onclick="searchKeyWord()" style=""><img src="../images/search.gif"/></button>
			</div>

			<div class="w3-row" id="itemContent">
			</div>
			<br/>
		</div>
	
		<div class="w3-col w3-container" style="width:28%" id="summary">
			<div class="w3-medium w3-center">Ordered Items</div> 
			<table class="w3-small" id="OrderedItemTable"  width="100%">
				<tr>
					<th class="w3-small"></th>
					<th class="w3-small">Itm. Code</th>
					<th class="w3-small">Description</th>
					<th class="w3-small">Unit</th>
					<th class="w3-small">Price</th>
					<th class="w3-small">Total</th>
				</tr>
				<%
				//get  item
				if(dpcid != null && "view".equals(mode)){
					record = DoctorChargeDB.getPreviousCharge(dpcid);
					if(record.size()>0){
						for(int i=0; i<record.size(); i++){
							row = (ReportableListObject) record.get(i);
							isInHATS = "1".equals(row.getValue(6));
							
				%>
				<tr class="eachitem" id="<%=row.getValue(0) %>">
					<td>
						<span class="INHATS" style="display:none;"><%=isInHATS?"Y":"N" %></span>
						<% if(isInHATS){%>
							IN HATS
						<% }else{%>
						<button class="removeitem" onclick="removeItem('<%=row.getValue(0) %>')">X</button>
						<%} %>
					</td>
					<td class="itmCode">
						<%=row.getValue(1) %>
					</td>
					<td class="pkgCode" style="display:none">
						<%=row.getValue(2) %>
					</td>
					<td class="itmDesc" itmcontent="<%=row.getValue(3) %><%=(!"".equals(row.getValue(8)))?" ("+row.getValue(8)+")":"" %>">
						<%=row.getValue(3) %><%=(!"".equals(row.getValue(8)))?" <br><p class=\"desc\" style=\"color:#3366ff;\">"+row.getValue(8)+"</p>":"" %>
					</td>
					<td class="unit">
						<%=row.getValue(5) %>
					</td>
					<td class="price" >
						$<%=row.getValue(4) %>
					</td>
					<td class="itemTotal">$<%=row.getValue(7) %></td>
				</tr>
				<%
						}
					}
				}
				%>
			</table>
			<a id="test" style="display:none;"></a>
			<span class="w3-small bold">Total: $<span class="bold" id="itmSum" name="itmSum" ><%=totalPrice %></span> </span>
			<div>
				<%if(false){ %><button class="w3-small" id="addFavor" onclick="return addFavorList();" style="display:none;">Add to My Favor</button><%} %>
				<div id="btnPanel">
					<button class="w3-small" id="newForm" onclick="refresh();" style="display:none;">New Charge Slip</button>
					<button class="w3-small" id="save" onclick="submitAction();">Save Draft</button>
					<br><button class="w3-small" id="print" onclick="printAction()">Print Draft</button>
					<button class="w3-small" id="save" onclick="addChgAction();">confirm and Post to Slip <%=slpNo %></button>
				</div>
				<br/>
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
var dpcid = "<%=dpcid %>";
var mode = "<%=mode %>";
var version = "<%=version %>";
var source = "<%=source %>";
var patType = "<%=patType%>";
var slpNo = "<%=slpNo%>";
var regopcat = "<%=regOPCat%>";

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
	if (regopcat == 'U') {
		changeCategory("UC");
		category = "UC";
	} else {
		changeCategory("OP");
		category = "OP";
	}
	<%if(!isRegid){%>
		$("#btnPanel").attr("disabled", true);
		$("#btnPanel").addClass("w3-disabled");
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

	$(".add").click(function() {
		alert("in");
	});
	
	$("#keyWord").keypress(function(e) {
		if ( e.which === 13 ) {
			searchKeyWord();
			e.preventDefault();
		}
	});
});

$(window).resize(function() {
	 
	 if (screen.width < 1600) {
			$(".unit").css('width','50%');
			$(".less").css('padding','4px 4px');
			$(".add").css('padding','4px 4px');
		}
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

function searchKeyWord(){
	var keyWord = $('#keyWord').val();
	$.ajax({
        url: "doctorCharge_action.jsp",
        data: {	"action" : "getItem",
        		"pqCategory" : category,
        		"userid" : userid,
        		"disabled" : disabled,
        		"keyWord" :keyWord
				},
        type: 'POST',
        dataType: 'html',
		cache: false,
        success: function(data){
        	$("#itemContent").html(data);
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

function changeCategory(pqCategory) {
	var categoryDesc = $.trim($("#"+pqCategory).html());
	if(category != '' && pqCategory != category) {
		alert("this registration is "+$("#"+category).html()+", can not select "+$("#"+pqCategory).html()+" item(s)");
		return false;	
	}
	$.ajax({
        url: "doctorCharge_action.jsp",
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
        url: "doctorCharge_action.jsp",
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
	var patType = "O";
	var option = "";
	$('#OrderedItemTable .eachitem').each(function() {
		clickedBox = $(this).context.id;  
		itmCode = clickedBox.substring(2);
		pkgCode = $.trim($(this).find(".pkgCode").html());
		category = clickedBox.substring(0,2);
		pqItmPrefix = $.trim($(this).find(".pqItmPrefix").html());
		timeslot = $.trim($(this).find(".timeslot").html());
		contrastDesc = $.trim($(this).find(".contrastDesc").html());
		price =$.trim($(this).find(".price").html()).substring(1);; 
		unit  =$.trim($(this).find(".unit").html());
		ISINHATS = $.trim($(this).find(".INHATS").html());
		desc  =$.trim($(this).find(".desc").html());
		
		if(pkgCode.length > 0){
			option = pkgCode.substring(0,2);	
		}else{
			option = pqItmPrefix;
		}
		contrast = null;

		removeItem(clickedBox);
		
		addItem("changePatType", category, patType, itmCode, option, pqItmPrefix, contrast, timeslot, clickedBox, contrastDesc, price, unit, ISINHATS,desc);

	 });
	
	changeCategory(category);

}

function selectOption(val){
	if(mode == "view"){
		alert(msg);
		return false;
	}else{
		$("#"+val).attr('checked',true);	
	}
}


function selectItem(clickedBox,itmCode,maxUnit){
	if(mode == "view"){
		alert(msg);
		return false;
	}
	var pqCategory = category;
	var pqItmPrefix = $.trim($("#pqItmPrefix").html());
	var option = $('input[name=select_pqOption]:checked').val()==null?"":$('input[name=select_pqOption]:checked').val();
	var timeslot = "";
	var isClicked = false; 
	var inhats = "N";
	$('#OrderedItemTable .eachitem').each(function() {
		var checkingBox = $(this).context.id; 
		inhats = $.trim($(this).find(".INHATS").html()); 
	    if(checkingBox==clickedBox){
	    	isClicked = true;

	    	return false;
	    }
	 });
	
	if(!isClicked){

		addItem("addItm", pqCategory, patType, itmCode, null,pqItmPrefix, null,null,clickedBox, null,"","",null,"",maxUnit);
	}else if (inhats != "Y"){
		removeItem(clickedBox);
	} else {
		$("#"+clickedBox).attr('checked',true);
	}
}

function addItem(action, pqCategory, patType, itmCode,  pqItmPrefix, clickedBox, maxUnit){

	addItem(action, pqCategory, patType, itmCode, null, pqItmPrefix, null, null, clickedBox, null, null, null, null, null, maxUnit);

}

function addItem(action, pqCategory, patType, itmCode, option, pqItmPrefix, contrast, timeslot, clickedBox, contrastDesc){
	addItem(action, pqCategory, patType, itmCode, option, pqItmPrefix, contrast, timeslot, clickedBox, contrastDesc, null, null, null, null, null);

}

function addItem(action, pqCategory, patType, itmCode, option, pqItmPrefix, contrast, timeslot, clickedBox, contrastDesc, price, unit, inHATS,desc, maxUnit){

	var changePatType = false;
	if(action == "changePatType"){
		changePatType = true;
		action = "addItm";
	}
	
	$.ajax({
        url: "doctorCharge_action.jsp",
        data: {	"action" : action,
        		"pqCategory" : pqCategory,
        		"patType" : patType,
        		"itmCode" : itmCode,
        		"slpNo": slpNo,
        		"docCode": docCode,
        		"price": price,
        		"unit": unit,
        		"inhats":inHATS,
        		"desc":desc,
        		"maxUnit":maxUnit
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
        	if(inHATS=='Y'){
        		$("#"+clickedBox).parent().attr('disabled',true);
        	}
        	$('#OrderedItemTable').append(data);


        },
       	error: function(data){
       		alert ("Cannot find the item!");
       	}
    });
}

function chgUnit(clickedBox,text) {
	var unit = $.trim($('#OrderedItemTable #'+clickedBox).find(".unit").val());
	
	  if (text == "+") {
		  var newVal = parseFloat(unit) + 1;		  
		} else {
	   // Don't allow decrementing below zero
	    if (unit > 1) {
	      var newVal = parseFloat(unit) - 1;
	    } else {
	      var newVal = 1;
	    }
	  }
	  $('#OrderedItemTable #'+clickedBox).find(".unit").val(newVal);

	  chgPrice(clickedBox);

}

function chgPrice(clickedBox){
	var unit = $.trim($('#OrderedItemTable #'+clickedBox).find(".unit").val());
	var hatprice = $.trim($('#OrderedItemTable #'+clickedBox).find(".price").attr( "hatPrice" ));
	var oriPrice = $.trim($('#OrderedItemTable #'+clickedBox).find(".price").attr( "oriPrice" ));
	var maxUnit = $.trim($('#OrderedItemTable #'+clickedBox).find(".unit").attr( "maxUnit" ));
	
    if (Number($('#OrderedItemTable #'+clickedBox).find(".price").val()) > Number(hatprice)) {
    	alert("amount can not be larger than price in HATS");
    	$('#OrderedItemTable #'+clickedBox).find(".price").val(oriPrice);
    }
    
    if (maxUnit!= ""){
    	if (unit > Number(maxUnit)) {
    		alert("item unit can not be more than "+maxUnit);
    		$.trim($('#OrderedItemTable #'+clickedBox).find(".unit").val(maxUnit));
    		unit = maxUnit;
    	}
    }
    var amt = $('#OrderedItemTable #'+clickedBox).find(".price").val() * unit;
    
    $('#OrderedItemTable #'+clickedBox).find(".itemTotal").html(amt);

    chgAmount();
}

function chgAmount() {
	  var sum = 0;
	  $('#OrderedItemTable .eachitem').each(function() {
		  var tmpamt = $.trim($(this).find(".itemTotal").html());
	      sum += parseFloat(tmpamt);
		  $('#test').html(tmpamt);
	  });
	  $('#itmSum').text(sum);
}


function removeItem(clickedBox){

	if(mode == "view"){
		alert(msg);
		return false;
	}else{
		var itmCode = $.trim($('#OrderedItemTable #'+clickedBox).find(".itmCode").html());
		var itmPrice = $.trim($('#OrderedItemTable #'+clickedBox).find(".price").html()).substring(1);

		$('#OrderedItemTable #'+clickedBox).remove();
		$("#"+clickedBox).attr('checked',false);
		chgAmount();

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
	        url: "doctorCharge_action.jsp",
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
	var submitMsg="Charge Slip Saved.";
	var notReload = false;
	if(mode == "view"){
		alert(msg);
		return false;
	}else{
		if(patno == null || patno.length == 0){
			alert("Error occur. Missing Patient No.");
			return false;
		}
		if(mode != "update" && $('#OrderedItemTable .eachitem').length <= 0){
			alert("No item is selected.");
			return false;
		}
		var selectItem = "";
		if(mode == "update"){
			version = parseInt(version) +  1 ;
		}
		$('#OrderedItemTable .eachitem').each(function(){
			var clickedBox = $(this).attr( "id" );  
		    var itmCode = $.trim( $(this).find(".itmCode").html() );
		    var pkgCode = $.trim( $(this).find(".pkgCode").html() );
			var unit = $.trim( $(this).find(".unit").val() );
		    var itemTotal =$.trim( $(this).find(".itemTotal").html() );
		    var price =$.trim( $(this).find(".price").val() );
		    var inhats = $.trim($(this).find(".INHATS").html());
		    var desc = $.trim( $(this).find(".desc").val() );
		    
		    if (itmCode == 'PDXX' && desc == ''){
		    	alert(itmCode+" must input description. ");
		    	notReload = true;
		    	return false;
		 
		    }
		    
			if(selectItem.length!=0) {
				selectItem += ";";
			}
			selectItem += itmCode + "," + pkgCode + ","  + price + "," + clickedBox + "," + unit+ "," + itemTotal +","+ inhats +","+desc;
			
		});
			if(!notReload) {
				$.ajax({
			        url: "doctorCharge_action.jsp",
			        data: {	"action" : "saveCharge",
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
			        	dpcid = $.trim(data);
			        	if($.trim(data) == "-1" || $.trim(data) == 'null'){
			        		alert("Save Draft Fail. Please print the charge Slip for charging");
							window.location.assign(window.location.href);	
			        	}else{
			        		if (action == "addChg") {
			        			$.ajax({
			        		        url: "doctorCharge_action.jsp",
			        		        data: {	"action" : "addHATS",
			        		        		"docCode" : docCode,
			        		        		"patno" : patno, 
			        		        		"regid" : regid,
			        		        		"dpcid" : dpcid, 
			        		        		"userid" : userid, 
			        		        		"slpNo" : slpNo
			        						},
			        		        type: 'POST',
			        		        dataType: 'html',
			        				cache: false,
			        		        success: function(data){
			        		        	if($.trim(data) < 0 || $.trim(data) == 'null' ) {
			        		        		alert("Add Charge Fail. Please print the charge Slip for charging");
			        		        		window.location.href = "/intranet/cms/doctorCharge_action.jsp?action=print&printOpt=ALL&dpcid=" + dpcid
											+"&selectItem="+selectItem+"&patno="+patno+"&docCode="+docCode+"&slpNo="+slpNo;
		
			        		        	} else if($.trim(data) == 999) {
			        		        		alert("Slip is using by other system. Please print out the Docdtor Procedure Charge, Sign and give to PBO for charging! ");
			        		        		showLoadingBox('body', 500, $(window).scrollTop());
			    			    			window.location.href = "/intranet/cms/doctorCharge_action.jsp?action=print&dpcid=" + dpcid+"&printOpt=TELLOG"
											+"&selectItem="+selectItem+"&patno="+patno+"&docCode="+docCode+"&slpNo="+slpNo;
			        		        	} else if($.trim(data) == 777) {
			        		        		alert("Slip is Closed. Please print out the Docdtor Procedure Charge, Sign and give to PBO for charging! ");
			        		        		showLoadingBox('body', 500, $(window).scrollTop());
			    			    			window.location.href = "/intranet/cms/doctorCharge_action.jsp?action=print&dpcid=" + dpcid+"&printOpt=TELLOG"
											+"&selectItem="+selectItem+"&patno="+patno+"&docCode="+docCode+"&slpNo="+slpNo;
			        		        	} else if($.trim(data) == 888) {
			        		        		alert("No item is posted to slip");
			    		    				window.location.assign(window.location.href);
		
			        		        	} else {
			        		        		alert("Charges posted.");
											window.location.assign(window.location.href);
		
			        		        	}
		
		
			        		        },
			        		        error: function(data){
			        		        	alert($.trim(data));
			    		    			window.location.assign(window.location.href);
		
			        		        }
			        			});
		
			        		} else {
					    		if(action == "printAll"){
					    			showLoadingBox('body', 500, $(window).scrollTop());
					    			window.open("/intranet/cms/doctorCharge_action.jsp?action=print&printOpt=ALL&dpcid=" + dpcid
					    									+"&selectItem="+selectItem+"&patno="+patno+"&docCode="+docCode+"&slpNo="+slpNo,"_blank");
					    			hideLoadingBox('body', 500);
					    		}else if(action == "toFE"){
					    			showLoadingBox('body', 500, $(window).scrollTop());
					    			window.location.href = "/intranet/financialEstimate/financialEstimationRpt.jsp?dpcid=" + dpcid;
					    		}else{
					    				window.location.assign(window.location.href);
					    		}
			        		}
			        	}
			        },
			        error: function(data){
			        	
			        }
				});
			}
	}
}

function addChgAction() {
	submitAction("addChg");
}

function printAction(){
	var selectItem = "";
	$('#OrderedItemTable .eachitem').each(function(){
		var clickedBox = $(this).attr( "id" );  
	    var itmCode = $.trim( $(this).find(".itmCode").html() );
	    var pkgCode = $.trim( $(this).find(".pkgCode").html() );
		var unit = $.trim( $(this).find(".unit").html() );
	    var itemTotal =$.trim( $(this).find(".itemTotal").html());
	    var price =$.trim( $(this).find(".price").val() );
	    var inhats = $.trim($(this).find(".INHATS").html());
	    var desc = $.trim( $(this).find(".itmDesc").attr("itmcontent") );
		if(selectItem.length!=0) {
			selectItem += ";";
		}
		selectItem += itmCode + "," + pkgCode + ","  + price + "," + clickedBox + "," + unit+ "," + itemTotal +","+ inhats +","+desc;
		
	});
	
	
	
	if(mode != "view"){
		submitAction("printAll");
	}else{
		showLoadingBox('body', 500, $(window).scrollTop());
		window.location.href = "/intranet/cms/doctorCharge_action.jsp?action=print&printOpt=All&dpcid=" + dpcid
		+"&selectItem="+selectItem+"&patno="+patno+"&docCode="+docCode+"&slpNo="+slpNo;;
	}
}


function updateQuotation(){
	$(window).trigger('resize');

	dpcid = null;
	$("#dpcid").append(" (Updating...)");
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