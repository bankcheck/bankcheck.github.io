<%@ page import="com.hkah.config.*"%>
<%
String menuType = request.getParameter("menuType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.uuid.js" />" />
<style>
	.selected {
		background: url("../images/ui-bg_highlight-soft_75_ffe45c_1x100.png") repeat-x scroll 50% 50% #F6F6F6 !important;
		 
	}
	.newOrder {
		background: #FF0000;
		color: #FFFFFF;
	}
	.quantityBtn {
		width:50px;
		height:40px;
	}
	.quantityBtn label {
		font-size: 25px;
	}
	.oh_detail {
		height:30px;
		cursor: pointer;
	}
	.odd {
		background-color:#BEBEBE;
	}
	.even {
		background-color:#E0E0E0;
	}
	.text {
		font-size: 21px;
	}
	#overlay {
	     z-index: 1000;
	     width:100%;
	     height:100%;
	}
	.ui-widget-header2 {
	    -moz-background-clip: border;
	    -moz-background-origin: padding;
	    -moz-background-size: auto auto;
	    background-attachment: scroll;
	    background-color: #2457AE;
	    background-image: url("../images/?new=2457ae&w=1&h=100&f=png&q=100&fltr[]=over|textures/03_highlight_soft.png|0|0|75");
	    background-position: 50% 50%;
	    background-repeat: repeat-x;
	    border-bottom-color: #AAAAAA;
	    border-bottom-style: solid;
	    border-bottom-width: 1px;
	    border-left-color-ltr-source: physical;
	    border-left-color-rtl-source: physical;
	    border-left-color-value: #AAAAAA;
	    border-left-style-ltr-source: physical;
	    border-left-style-rtl-source: physical;
	    border-left-style-value: solid;
	    border-left-width-ltr-source: physical;
	    border-left-width-rtl-source: physical;
	    border-left-width-value: 1px;
	    border-right-color-ltr-source: physical;
	    border-right-color-rtl-source: physical;
	    border-right-color-value: #AAAAAA;
	    border-right-style-ltr-source: physical;
	    border-right-style-rtl-source: physical;
	    border-right-style-value: solid;
	    border-right-width-ltr-source: physical;
	    border-right-width-rtl-source: physical;
	    border-right-width-value: 1px;
	    border-top-color: #AAAAAA;
	    border-top-style: solid;
	    border-top-width: 1px;
	    color: #FFFFFF;
	    font-weight: bold;
	}
	.ui-widget-content2 {
	    -moz-background-clip: border;
	    -moz-background-origin: padding;
	    -moz-background-size: auto auto;
	    background-attachment: scroll;
	    background-color: #E1E2DF;
	    background-image: url("../images/?new=e1e2df&w=40&h=100&f=png&q=100&fltr[]=over|textures/01_flat.png|0|0|75");
	    background-position: 50% 50%;
	    background-repeat: repeat-x;
	    border-bottom-color: #2A2A22 !important;
	    border-bottom-style: solid !important;
	    border-bottom-width: 1px !important;
	    border-top-color: #2A2A22 !important;
	    border-top-style: solid !important;
	    border-top-width: 1px !important;
	    color: #222222;
	}
</style>
<body>
<jsp:include page="../patient/checkSession.jsp" />
  
<!-- the box for displaying item's comp and opt -->
<div id="setDetails" style="width:auto; height:auto; position:absolute; z-index:10; display:none"
	class="ui-dialog ui-widget ui-widget-content ui-corner-all"></div>

<!-- the box for displaying item's comp and opt -->
<div id="orderDetails" style="width:auto; height:auto; position:absolute; z-index:12; display:none"
	class="ui-dialog ui-widget ui-widget-content ui-widget-content2 ui-corner-all"></div>

<!-- the summary btn at top right corner -->
<div id="orders" style="display:none; cursor:pointer; width:220px; height:80px; position:absolute; z-index:12;"
	class="ui-dialog ui-widget ui-widget-content ui-corner-all">
	<div id="totalOrder" align="center" style="padding-top:20px;"><label style="font-size:25px">Order List</label><label id="newMsg"></label></div>
</div>

<!-- the summary btn at top right corner -->
<div id="fontSize" style="display:none; cursor:pointer; width:100px; height:50px; position:absolute; z-index:12;"
	class="ui-dialog ui-widget ui-widget-content ui-corner-all">
	<div id="fontSizeBtn" align="center" style="padding-top:12px;"><label class="text">Increase</label></div>
</div>

<!-- Msg - complete the adding order process -->
<div id="addedMsg" align="center" style="color:#FFFFFF; background:#CC0000; padding-top:12px; position:absolute; display:none;" 
	class="ui-dialog ui-widget ui-widget-content ui-corner-all">
	<label class="text">Added an order.</label>
</div>

<!-- the box for displaying order list -->
<div id="previewSummary" style="width:900px; height:auto; display:none; position:absolute; z-index:12;"
	class="ui-dialog ui-widget ui-widget-content ui-corner-all"></div>
	
<!-- the box for displaying order list -->
<div id="orderHistoryDetail" style="width:650px; height:auto; display:none; position:absolute; z-index:12; "
	class="ui-dialog ui-widget ui-widget-content ui-corner-all">
		<table id="historyDetail"></table>
</div>

<!-- the box for displaying order list -->
<div id="overlay" class="ui-widget-overlay" style="display:none"></div>
<div id="alertDialog" style="width:300px; height:auto; position:absolute; z-index:1005; display:none;"
	class="ui-dialog ui-widget ui-widget-content ui-corner-all">
	<div align="center" class = "ui-widget-header"><label class="text">Pay Attention</label></div>
	<div align="center"><label id="alertMsg" class="text"></label></div>
	<div>&nbsp;</div>
	<div>&nbsp;</div>
	<div align="center">
		<button id="skipAlert" class = "ui-button ui-widget ui-state-default ui-corner-all" style="display:none;" onclick="return submitAction('exit');">
						<label class="text">Yes</label></button>
		<button id="closeAlert" class = "ui-button ui-widget ui-state-default ui-corner-all">
						<label class="text">Close</label></button>
	</div>
</div>


<form name="form1">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
	<jsp:include page="../patient/patientInfo.jsp" />
		<tr><td>&nbsp;</td></tr>
		<!-- 20110413 andrew lau -->
		<tr id = "contentRow" align="center">
			<td>
				<table id="menuChoices" style="width:100%">
					<jsp:include page="../ui/fsdMenuCategoryCMB.jsp" flush="false" />
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<div style="padding-top:12px; font-size:24px; width:290px; height:42px;" 
					class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' 
					id="backBtn"><img src="../images/undo2.gif"/>
						&nbsp;Back to Home
				</div>
			</td>
		</tr>
	</table>
  <input type="hidden" name="menuType" value="<%=menuType==null?"":menuType %>"> 
</form>
<script language="javascript">
	var currentMenu = "";
	var currentMenuItem = "";
	var currentItemCategory = "";
	var currentItemComp = "";
	var currentItemCode = "";
	var currentPrice = "";
	var currentOptCode = new Array();
	var currentItemId = "";
	var allOrder = new Array();
	var tempSetOrder;
	var previewTemplate = "";
	var time = null;
	var serveType = null;
	var h = null;
	var m = null;
	var curSetCate;
	var sentOrder = false;
	
	function confirmExit() {
		if(allOrder.length > 0 && !sentOrder) {
			alertMsg("You still not send the order.<br/>Do you really want to exit? ");
			$("button#closeAlert").find('label').html('No');
			$("button#skipAlert").css('display', '');
			hideLoadingBox('body', 500);
			return false;
		}else {
			submitAction('back');
		}
	}
	
	function submitAction(act) {
		showLoadingBox('body', 500);
		if (act == 'order') {
			document.form1.action = "../patient/foodServicesProcess.jsp";
			document.form1.submit();
		} else if (act == 'menu' || act == 'set') {
			document.form1.menuType.value= act;
			document.form1.action = "../patient/foodServices.jsp";
			document.form1.submit();
		} else {
			document.form1.action = "../patient/main.jsp";
			document.form1.submit();
		}
		hideLoadingBox('body', 500);
	}

	function changeMenuCategory(value, title, compCode) {
		var selectedItemCategory = value;
		var setCategoryItem;
		
		if (selectedItemCategory != '') {
			showLoadingBox('body', 500);
			$.ajax({
				type: "GET",
				url: "../ui/fsdMenuItemCMB.jsp",
				data: "menuType=" + selectedItemCategory +'&title=' + title + '&compCode=' + compCode,
				async: false,
				success: function(values){
					//$("#code-container").html("<select name='selectedItemCode' onchange='return changeMenuCode()'>" + values + "</select>");
					//changeMenuCode();
					if(value == "set") {
						setCategoryItem = values;
					}
					else {
						$('table#menuChoices').html('<tbody>'+values+'</tbody>');
						clickCategroyEvent();
						clickItemEvent(value);
						addBtn('foodCategory');
						addBtn('mainPage');
						$(window).scrollTop(0);
						$(window).trigger('scroll');
					}
					hideLoadingBox('body', 500);
					
				},//success
				error: function(jqXHR, textStatus, errorThrown) {
					hideLoadingBox('body', 500);
					alert('Error in "changeMenuCategory"');
				}
			});//$.ajax
		}
		
		if(value == "set") {
			
			return setCategoryItem;
		}
	}
	
	function changeItemComp(value, set) {
		var selectedItemComp = value;
		currentItemComp = value;
		
		if (selectedItemComp != '') {
			showLoadingBox('body', 500);
				$.ajax({
					type: "GET",
					url: "../ui/fsdItemOptCMB.jsp",
					data: "compCode=" + selectedItemComp + "&itemCode=" + currentItemCode,
					async: false,
					success: function(values){
						var content = "<div id = 'options-container'>" 	+
										"<label class='text'>Options:&nbsp;</label><br/>" +
											values 							+
											'<br/>' +
									  "</div>";
									
						$('#options-container').remove();
						if(!set) {
					    	$('#orderDetails').append(content);
					    
						    
						    if(currentMenu == "set") {
						    	$('#setBtns').remove();
						    	$('#orderDetails').append(addBtn('setSubOrderBtnGrp'));
						    	 $('#cancelSub').click(function() {
								    	$('#orderDetails').html('');
										$('#orderDetails').css('display', 'none');
								    });
						    }else {
						    	$('#btns').remove();
						    	$('#orderDetails').append(addBtn('orderBtnGrp'));
						    	 $('#cancel').click(function() {
								    	$('#orderDetails').html('');
										$('#orderDetails').css('display', 'none');
								    });
						    }
						}
						else {
							$('div#setChoices').append(content);
						}
					   	checkFoodOptEvent();
					   	hideLoadingBox('body', 500);
					},//success
					error: function(jqXHR, textStatus, errorThrown) {
						hideLoadingBox('body', 500);
						alert('Error in "changeItemComp"');
					}
				});//$.ajax
			//}
		}
		
	}

	function changeMenuCode(type, value, set) {
		var menuType = type;
		var selectedItemCode = value;
		currentItemCode = value;
		currentPrice = $('#'+value).parent().find('#currency').html() + '&nbsp;' +
						$('#'+value).parent().find('#unitPrice').html();

		if (selectedItemCode != '') {
			showLoadingBox('body', 500);
			if(!set) {
				$('#orderDetails').css('display', 'none');
				$('#orderDetails').html('<div style="width:'+((set)?"auto":"100%")+'; height:auto;" align="center" class = "ui-widget-header2"><label class="text">'+$('#'+value).parent().find('label:first').html()+'</label></div>');
				//$('#setDetails').css('display', 'none');
				
			}
			$.ajax({
				type: "GET",
				url: "../ui/fsdItemCompCMB.jsp",
				data: "menuType=" + menuType + "&itemCode=" + selectedItemCode,
				async: false,
				success: function(values){
					if(type !== "set") {
						$("#selectedItemComp").unbind('change');
						if(values != '') {
							var content = "<div id = 'composition-container'>" 	+
											"<label class='text'>Composition:&nbsp;</label><br/>" +
											"<div>" 							+
												values 							+
											"</div>"							+
										  "</div>";
							if(!set) {
								if(currentMenu !== "set") {
									/*$('#quantity-container').remove();
									$('#orderDetails').append(
											'<label class="text">Quantity:</label><br/>' +
											'<div>' +
												'<input style="font-size:21px" id="quantity-container" value="1"/>' +
												'<button id="spinner_add" class = "quantityBtn ui-button ui-widget ui-state-default ui-corner-all"><label class="text">+</label></button>' +
												'<button id="spinner_sub" class = "quantityBtn ui-button ui-widget ui-state-default ui-corner-all"><label class="text">-</label></button>' +
											'</div>'
											);
							   	 	spinnerEvent();*/
								}
								$('#orderDetails').append(content);
							}
						    else {
						   	 	$('div#setChoices').append(content);
						    }
						    selectCompEvent(set);
						} 
						else {
							if(!set) {
								currentItemComp = "";
								if(currentMenu !== "set") {
									/*$('#quantity-container').remove();
									$('#orderDetails').append(
											'<label class="text">Quantity:</label><br/>' +
											'<div>' +
												'<input style="font-size:21px" id="quantity-container" value="1"/>' +
												'<button id="spinner_add" class = "quantityBtn ui-button ui-widget ui-state-default ui-corner-all"><label class="text">+</label></button>' +
												'<button id="spinner_sub" class = "quantityBtn ui-button ui-widget ui-state-default ui-corner-all"><label class="text">-</label></button>' +
											'</div>'
											);
									spinnerEvent();*/
								}
								
								if(currentMenu == "set") {
									$('#orderDetails').append('<br/>'+addBtn('setSubOrderBtnGrp'));
									//$('button#confirmSetChoiceBtn').css('display', 'none');
									
									$('#cancelSub').click(function() {
								    	$('#orderDetails').html('');
										$('#orderDetails').css('display', 'none');
								    });
								}else {
									$('#orderDetails').append('<br/>'+addBtn('orderBtnGrp'));
									$('#cancel').click(function() {
									    	$('#orderDetails').html('');
											$('#orderDetails').css('display', 'none');
									    });
								}
							}
						}
					}
					else {
						/*$('#quantity-container').remove();*/
						$('#setDetails').html('<div style="width:'+((set)?"auto":"100%")+'; height:auto;" align="center" class = "ui-widget-header"><label class="text">'+$('#'+value).parent().find('label:first').html()+'</label></div>');
						/*$('#setDetails').append(
								'<label class="text">Quantity:</label>' +
								'<div>' +
									'<input style="font-size:15px" id="quantity-container" value="1"/>' +
									'<button id="spinner_add" class = "quantityBtn ui-button ui-widget ui-state-default ui-corner-all"><label class="text">+</label></button>' +
									'<button id="spinner_sub" class = "quantityBtn ui-button ui-widget ui-state-default ui-corner-all"><label class="text">-</label></button>' +
								'</div><div><br/></div>'
								);*/
						$('#setDetails').append('<div style="height:50px"><label class="text" style="color:red;">*If there is any changes, please click <b>cancel</b> and <b>re-order</b> it.</label></div>');
						$('#setDetails').append('<div style="width:100%; height:auto;"><label class="text">Categories: </label>'+values+'</div>');
						
						$('#setDetails').append('<hr/>');
						$('#setDetails').append('<br/>');
						$('#setDetails').append('<div style="background-color:white; float:left;"><label class="text" style="font-size:24px; color:red;">*Please choose <span style="background-color:#F5F587">one item below</span> or <span style="background-color:#F5F587">click "skip" button</span> this category.</label></div>');
						$('#setDetails').append('<div style="float:right"><button id="skipItemBtn" class = "ui-button ui-widget ui-state-default ui-corner-all" onclick="skipItemEvent();"><label class="text">Skip</label></button></div>');
						
						$('#setDetails').append('<div id="setCategoryContent" style="width:100%; height:100%">' +
														'<div style="float:left; width:100%; height:100%" id="setChoices"></div>' +
												  '</div>');
						$('#setDetails').append('<div style="float:left; width:100%" id="setBtn"></div>');
						$('#setDetails').append('<br/><br/><br/><hr width="100%"/>');
						$('#setDetails').append(addBtn('orderBtnGrp'));
						
						$('button#submit').css('display', 'none');
						
						$('#cancel').click(function() {
						    	$('#setDetails').html('');
						    	tempSetOrder = null;
								$('#setDetails').css('display', 'none');
								$('#orderDetails').css('display', 'none');
								$(window).scrollTop(0);
								$(window).trigger('scroll');
						    });
						//spinnerEvent();
					}
					hideLoadingBox('body', 500);
				},//success
				error: function(jqXHR, textStatus, errorThrown) {
					hideLoadingBox('body', 500);
					alert('Error in "changeMenuCode"');
				}
			});//$.ajax
		}
	}

	function addBtn(type) {
		var btn = "";
		if(type == "orderHist") {
			btn = 	'<div id="viewHistory"><button style="font-size:24px;" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" '+
					'onclick="init(); return false;" '+
					'>'+
					'Order History</button><br/><br/></div>';
					
			$('#viewHistory').remove();
			$('#backBtn').before(btn);
		}
		else if(type == "mainPage") {
			btn = '<div id="backSCBtn"><button style="font-size:24px; width:400px; float:right;" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only '+
						((currentMenu == "set")?'selected" ':'" ') +
					'onclick="getSets();" '+
					'>'+
					'Breakfast Set</button><br/><br/></div>';
			$('.setMenuBtnLoc').before(btn);			
		}
		else if(type == "foodCategory") {
			btn = '<div id="backFCBtn"><button style="font-size:24px; width:400px; float:left;" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only '+
						((currentMenu !== "set")?'selected" ':'" ') +
					'onclick="getFoodCategory();" '+
					'>'+
					'Menu</button><br/><br/></div>';
			$('.menuBtnLoc').html(btn);
		}
		else if(type == "confirmBtn"){
			btn = '<button id="confirmBtn" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"'+
					'onclick="return confirmOrder();">'+
					'<label class="text">&nbsp;Confirm and Send</label></button>&nbsp;';
			return btn;
		}
		else if(type == "closeSummary"){
			btn = '<button id="closeSumBtn" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"'+
						'>'+
						'<label class="text">&nbsp;Close</label></button>&nbsp;';
			return btn;
		}
		else if(type == "orderBtnGrp") {
			var btns = "<div style='width:100%' id = 'btns'>"	+
							"<button style='background:#FF9D6F !important;' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' id = 'submit' onclick = 'addOrder()'><label class='text'>Add</label></button>" +
							"<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' id = 'cancel'><label class='text'>Cancel</label></button>" +
						"</div>";
			return btns;
		}
		else if(type == "setSubOrderBtnGrp") {
			var btns = "<div style='width:100%' id = 'setBtns'>"	+
							"<button id='confirmSetChoiceBtn' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' onclick='confirmSetSubItemEvent();'><label class='text'>Add</label></button>" +
							"<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' id = 'cancelSub'><label class='text'>Cancel</label></button>" +
						"</div>";
			return btns;
		}
		else if(type == "confirmSetChoiceBtn"){
			btn = '<button id="confirmSetChoiceBtn" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"'+
					'>'+
					'<label class="text">&nbsp;Confirm</label></button>&nbsp;';
			return btn;	
		}
	}
	
	function assignServeType(hour, min) {
		if((hour >= 7) && (hour <= 11)) {
			if(hour > 7 && hour < 11) {
				serveType = "B";
			}else if(hour == 7) {
				if(min >= 30) {
					serveType = "B";
				}
			}else if(hour == 11) {
				if(min < 30) {
					serveType = "B";
				}
			}
		}
		if ((hour >= 11) && (hour <= 15)){
			if(hour > 11 && hour < 15) {
				serveType = "L";
			}else if(hour == 11) {
				if(min >= 30) {
					serveType = "L";
				}
			}else if(hour == 15) {
				if(min < 30) {
					serveType = "L";
				}
			}
		}
		if ((hour >= 15) && (hour <= 17)){
			if(hour > 15 && hour < 17) {
				serveType = "B";
			}else if(hour == 15) {
				if(min >= 30) {
					serveType = "S";
				}
			}else if(hour == 17) {
				if(nowM < 30) {
					serveType = "S";
				}
			}
		}
		if ((hour >= 17) && (hour <= 19)){
			if(hour > 17 && hour < 19) {
				serveType = "D";
			}else if(hour == 17) {
				if(min >= 30) {
					serveType = "D";
				}
			}else if(hour == 19) {
				if(min <= 30) {
					serveType = "D";
				}
			}
		}
	}
	
	function confirmOrder() {
		if(time == null) {
			alertMsg("Please choose Serve Time");
			return;
		} else if(((h == null || h == "null") || (m == null || m == "null")) && time !== "now") {
			alertMsg("Please choose Serve Time");
			return;
		}
		
		closeAllPopupDiv();
		if((h !== null || h !== "null") && (m !== null || m !== "null") && time !== "now") {
			assignServeType(h, m);
		}
		else if(time == "now") {
			var now = new Date();
			
			var nowH = parseInt(now.getHours());
			var nowM = parseInt(now.getMinutes());
			
			assignServeType(nowH, nowM);
		}

		/*if(serveType == null || serveType == "null") {
			alertMsg("Please choose a Serve Type");
			return;
		}*/
		
		if(allOrder.length > 0) {
			showLoadingBox('body', 500);
			var selectedItemCode = new Array();
			var selectedOptCode = new Array();
			var selectedItemAmount = new Array();
			var selectedMenuType = new Array();
			
			for(var i = 0; i < allOrder.length; i++) {
				selectedMenuType.splice(selectedMenuType.length, 0, allOrder[i].itemMenuType);
				selectedItemCode.splice(selectedItemCode.length, 0, allOrder[i].itemName.split('_')[0]);
				
				var opt = "";
				if(allOrder[i].itemMenuType !== "S") {
					if(allOrder[i].itemOpt.length == 0)
						opt = "null.";
					
					for(var j = 0; j < allOrder[i].itemOpt.length; j++) {
						opt += allOrder[i].itemOpt[j].split('_')[0]+'.';	
					}
					selectedOptCode.splice(selectedOptCode.length, 0, opt.substring(0, opt.length-1));
				}
				else {
					selectedOptCode.splice(selectedOptCode.length, 0, allOrder[i].itemOpt);
				}
				
				selectedItemAmount.splice(selectedItemAmount.length, 0, allOrder[i].amount);
			}
			
			$.ajax({
				type: "GET",
				url: "../patient/foodServicesProcess.jsp",
				data: "selectedMenuType="+selectedMenuType+"&selectedItemCode=" + selectedItemCode +'&selectedOptCode=' + selectedOptCode +
						'&selectedItemAmount=' + selectedItemAmount +'&serveTime=' + 
						((time == "now")?time:
							(((time.getDate()<10)?"0":"")+time.getDate()+'-'+
							((time.getMonth() < 9)?"0":"")+(time.getMonth()+1)+'-'+time.getFullYear())) +
						'&serveType=' + serveType + '&h=' + h + '&m=' + m,
				success: function(values){
					if(values.indexOf('true') > -1) {
						sentOrder = true;
						$('table#preview').find('tr').each(function() {
							$(this).find('td:first-child').remove();
						});
						
						var stype = $('select#fdServeType option:selected').text();
						$('table#menuChoices').html('<tbody>'+
								'<tr><td align="center"><img src="../images/food.jpg"><br/><span class="enquiryLabel extraBigText">Food Services</span></td></tr>' +
								'<tr align="center"><td colspan="2">Order Summary</td></tr><tr><td colspan="2"><HR></td></tr>' +
								'<tr><td>&nbsp;</td></tr>' +
								'<tr><td align="center"><span class="bigText"><table>'+$('table#preview').html()+values+'</table></span></td></tr>' +
								'<tr><td>&nbsp;</td></tr>'+
								'<tr><td align="center"><label class="text"><b>It takes about 15 minutes for delivery.</b></label></td></tr>'+
								'<tr><td align="center"><label class="text"><b>Thank you for your order. Out staff will contact you shortly.</b></label></td></tr>'+
								'<tr><td>&nbsp;</td></tr>'+
								'<tr><td>&nbsp;</td></tr>'+
								'<tr><td>&nbsp;</td></tr>'+'</tbody>'
						);
						
						$('label#selectedType').html(stype);
						$('select#fdServeType').remove();
						$('label#selectedTime').html((time == "now")?time:((((time.getDate()<10)?"0":"")+time.getDate()+'-'+
								((time.getMonth() < 9)?"0":"")+(time.getMonth()+1)+'-'+time.getFullYear()) +' '+h+":"+m));
						$('.serveTime').remove();
						$('label#selectedTime').parent().parent().parent().css('background-color', '');
						$('.orderHidden').css('display', 'none');
						$('.orderDisplay').css('display', '');
						
						$('#backFCBtn').remove();
						$('#backSCBtn').remove();
						$('#viewHistory').remove();
						
						$('#orders').remove();
						$('#previewSummary').remove();
						
						if($('div#orderSuccess').html() == "false") {
							$('table#menuChoices').html('<tbody>'+
									'<tr><td>Order Fail</td></tr>'
									+'</tbody>');
						}
						
						hideLoadingBox('body', 500);
					}else {
						alertMsg('Error in send order.');
					}
				},//success
				error: function(jqXHR, textStatus, errorThrown) {
					hideLoadingBox('body', 500);
					alert('Error in "confirmOrder"');
				}
			});//$.ajax
		}
	}
	
	function addOrder() {
		showLoadingBox('body', 500);
		var temp = {};
		var add = false;
		var totalOrder = 0;
		$('div#addedMsg').fadeIn(100);
		$('div#previewSummary').css('display', 'none');
		$('label#newMsg').html('<label style="font-size:25px">(click)</label>');
		if(currentMenu == "set") {
			if(tempSetOrder['subItem'].length > 0) {
				temp['uuid'] = jQuery.uidGen({prefix: 'S',mode:'sequential'});
				var parentSet = temp['uuid'];
				temp['itemMenuType'] = "S";
				temp['itemName'] = tempSetOrder['setName'];
				temp['itemPrice'] = tempSetOrder['price'];
				
				var setOpt = "";
				$.each(tempSetOrder['subItem'], function(index, value){
					setOpt += '+'+value['itemName'].split('_')[0];
					if(value['itemOpt'].length > 0) {
						$.each(value['itemOpt'], function(i, v) {
							setOpt += '.'+v.split('_')[0].split('@')[1];
						});
					}
				});
				
				temp['itemOpt'] = setOpt.substring(1);
				temp['amount'] = 1;//$('#quantity-container').val();
				
				allOrder.splice(allOrder.length, 0, temp);
				
				$.each(tempSetOrder['subItem'], function(index, value){
					temp = {};
					temp['parentSet'] = parentSet;
					temp['itemMenuType'] = "I";
					temp['itemName'] = value['itemName'];
					temp['itemPrice'] = value['itemPrice'];
					temp['itemOpt'] = value['itemOpt'];
					temp['amount'] = 1;//$('#quantity-container').val();
					
					allOrder.splice(allOrder.length, 0, temp);
				});
				//$.dump(allOrder)
			}
		}else {
			temp['uuid'] = jQuery.uidGen({prefix: 'M',mode:'sequential'});
			temp['itemMenuType'] = "M";
			temp['itemName'] = currentItemCode+'_'+$('#'+currentItemCode).parent().find(':first-child').html();
			temp['itemPrice'] = currentPrice;
			temp['itemOpt'] = currentOptCode;
			
			$.each(allOrder, function(index, el){
				if(el['itemName'] ==  currentItemCode+'_'+$('#'+currentItemCode).parent().find(':first-child').html()) {
					if(el['itemOpt'].length == 0 && currentOptCode.length == 0) {
						el['amount'] = parseInt(el['amount']) + 1; //parseInt($('#quantity-container').val()
						add = true;
					}
				}
				totalOrder +=el['amount'];
			});
			
			if(!add) {
				totalOrder +=1;
				temp['amount'] = 1;//$('#quantity-container').val();
				currentOptCode = new Array();
				allOrder.splice(allOrder.length, 0, temp);
			}
		}
		//$.dump(allOrder);
		$('#orderDetails').css('display', 'none');
		$('#setDetails').css('display', 'none');
		previewSummary();
		$('div#addedMsg').fadeOut(500);
		
		for(var i = 0; i < 15; i++) {
			$("div#orders").animate( { backgroundColor: 'yellow' }, 500)
		    .animate( { backgroundColor: 'red' }, 500);
		}
		
		$('div#orders').addClass('newOrder');
		hideLoadingBox('body', 500);
	}
	
	function modifiyOrderQuantity(uuid, amount) {
		for(var i = 0; i < allOrder.length; i++) {
			if(allOrder[i].itemMenuType == "I") {
				if(allOrder[i].parentSet == uuid) {
					allOrder[i].amount = amount;
				}
			}
			else if(allOrder[i].uuid == uuid) {
				allOrder[i].amount = amount;
			}
		}
	}
	
	function previewSummary() {
		
		$('#orderDetails').css('display', 'none');
		$('#setDetails').css('display', 'none');
		var total = 0.0;	
		var totalOrder = 0;
		$('table#preview').html('<tbody>'+previewTemplate+'</tbody>');
		selectServTimeEvent();
		selectServeTypeEvent();
		
		//$.dump(allOrder);
		if(allOrder.length > 0) {
			$('table#preview tr#summaryContent').before(
					'<tr class="orderHidden"><td></td><td style="width:45%;"><label class="text">Item</label></td>' +
					'<td style="width:25%;"><label class="text">Quantity</label></td>' +
					'<td style="width:20%;"><label class="text">Price</label></td></tr>' +
					'<tr><td colspan="4"><hr/></td></tr>'
				);
		}
		
		for(var i = 0; i < allOrder.length; i++) {
			if(allOrder[i].itemMenuType == "I") {
				continue;
			}
			var len;
			var opt = "";
			var tempOpt = allOrder[i].itemOpt;
			var price;
			var cur;	
			
			if(allOrder[i].itemMenuType == "S") {
				var j = i+1;
				while(j < allOrder.length && allOrder[j].itemMenuType == "I") {
					opt += allOrder[j].itemName.split('_')[1]+'<br/>';
					tempOpt = allOrder[j].itemOpt;
					for(var k = 0; k < tempOpt.length; k++) {
						opt += '- '+tempOpt[k].split('_')[1]+'<br/>';
					} 
					j++;
				}
				len = j-i-1;
			}
			else {
				for(var j = 0; j < tempOpt.length; j++) {
					opt += tempOpt[j].split('_')[1]+'<br/>';
				} 	
				len = 0;
			}
			
			totalOrder += allOrder[i].amount;
			if(allOrder[i].itemMenuType == "S") {
				cur = allOrder[i].itemPrice.split(' ')[0];
				price = parseFloat(allOrder[i].itemPrice.split(' ')[1]) * allOrder[i].amount;
				total += price;
			}else {
				cur = allOrder[i].itemPrice.split('&nbsp;')[0];
				price = parseFloat(allOrder[i].itemPrice.split('&nbsp;')[1]) * allOrder[i].amount;
				total += price;
			}
			
			$('table#preview tr#summaryContent').before(
					'<tr>' +
						'<td><button length = "'+len+'" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only cancel" id = "'+i+'" style = "float:left"><label class="text">Cancel</label></button></td>'+
						'<td>'+
							'<div style = "float:left"><label id = "itemName" class="text"><b>'+allOrder[i].itemName.split('_')[1]+' x '+
							'<label class="orderDisplay quantity text" uuid="'+ allOrder[i].uuid +'" style="display:none;">1</label>' +
							'</b></label></div></td>'+
						//quantity
						'<td>' +  
							'<div class="quantity-container orderHidden" uuid="'+ allOrder[i].uuid +'"><input style="font-size:21px; width:50px;" class="quantity-input" value="'+allOrder[i].amount+'"/>' +
							'<button id="spinner_add" class = "quantityBtn ui-button ui-widget ui-state-default ui-corner-all"><label class="text">+</label></button>' +
							'<button id="spinner_sub" class = "quantityBtn ui-button ui-widget ui-state-default ui-corner-all"><label class="text">-</label></button>' +'</div>' + '</td>' +
						/**********/
						'<td><label class="text">&nbsp;'+cur+'</label> <label uuid="'+ allOrder[i].uuid +'" class="text itemPrice">'+price+'</label></td>'+
					'</tr>' +
					'<tr>' +
						'<td>&nbsp;</td>' +
						'<td><label id = "itemOpt" class="text">'+opt+'</label></td>' +
						'<td>&nbsp;</td>' +
						'<td>&nbsp;</td>' +
					'</tr>' +
					'<tr><td colspan="4">&nbsp;</td></tr>'
			);
		}
		
		if(allOrder.length > 0) {
			var currency;
			if(allOrder[0].itemMenuType == "S")
				currency = allOrder[0].itemPrice.split(' ')[0];
			else
				currency = allOrder[0].itemPrice.split('&nbsp;')[0];
			
			$('table#preview tr#summaryContent').before(
					'<tr>' +
						'<td>&nbsp;</td>' +
						'<td>&nbsp;</td>' +
						'<td>&nbsp;</td>' +
						'<td><label id = "total" class="text"><b>&nbsp;Total:&nbsp;'+currency+'&nbsp;<span class="totalPay">'+total+'</span></b></label></td>' +
					'</tr>' 
					
			);
			$('table#preview tr#summaryContent').before('<tr><td colspan="4"><hr/></td></tr>');
		}
		
		cancelOrder();
		spinnerEvent();
	}
	
	function previewSummaryTemplate() {
		$.ajax({
			type: "GET",
			url: "../ui/fsdOrderSummary.jsp",
			async: false,
			success: function(values){
				$('div#previewSummary').html('<div align="center" class = "ui-widget-header"><label class="text">Order Summary</label></div>'+
						'<div style = "width:100%" class="ui-dialog-content ui-widget-content"><table id="preview" style="width:95%;"></table></div>'+
						addBtn('confirmBtn') +
						addBtn('closeSummary'));
				selectServTimeEvent();
				$('input[value="now"]').trigger('click');
				previewTemplate = values;
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "previewSummaryTemplate"');
			}
		});//$.ajax
	}
	
	function cancelOrder() {
		$('.cancel').click(function() {
			showLoadingBox('body', 500);
			var start = parseInt($(this).attr('id'));
			var len = parseInt($(this).attr('length'));
			
			for(var i  = start; i <= len + start; i++) {
				allOrder.splice(start, 1);
			}
			
			previewSummary();
			var left = $(window).width() - 45 - $('div#previewSummary').width();
			var top = $(window).scrollTop() + $('div#orders').height() + 5;
			$('div#previewSummary')
				.css('left', left)
				.css('top', top);
			hideLoadingBox('body', 500);
		});
	}
	
	function getFoodCategory() {
		closeAllPopupDiv();
		showLoadingBox('body', 500);
		$.ajax({
			type: "GET",
			url: "../ui/fsdMenuCategoryCMB.jsp",
			async: false,
			success: function(values){
				currentMenu = "menu";
				$('table#menuChoices').html('<tbody>'+values+'</tbody>');
				clickCategroyEvent();
				addBtn('mainPage');
				addBtn('foodCategory');
				addBtn('orderHist');
				$(window).scrollTop(0);
				$(window).trigger('scroll');
				$('#orderDetails').css('width', 'auto');
				hideLoadingBox('body', 500);
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "getFoodCategory"');
			}
		});//$.ajax
		
	}
	
	//20110413 andrew lau
	/****************************************EVENT************************************/
	function checkFoodOptEvent() {
		$('.foodOpt').each(function() {
			if(currentOptCode.length > 0) {
				for(var i = 0; i < currentOptCode.length; i++) {
					if(currentOptCode[i].split('_')[0] == $(this).val()) {
						$(this).attr('checked', true);
					}
				}
			}
		});
		
		$('.foodOpt').each(function() {
			$(this).click(function() {
				var added = false;
				for(var i = 0; i < currentOptCode.length; i++) {
					if(currentOptCode[i] == $(this).val()+'_'+$(this).next().html()) {
						currentOptCode.splice(i, 1);
						added = true;
					}
				}
				
				var max = 0;
				$('button.selectItemComp').each(function() {
					max += parseInt($(this).attr('maxchoice'));
				});

				if(parseInt($('button.selectItemComp.selected').attr('maxchoice')) < $(".foodOpt:checked").length) {
					$(this).attr('checked', false);
				}
				else {
					if(!added) {
						currentOptCode[currentOptCode.length] = $(this).val()+'_'+$(this).next().html();
						if(parseInt($('button.selectItemComp.selected').attr('maxchoice')) == $(".foodOpt:checked").length) {
							$('button.selectItemComp.selected').removeClass('empty');
							$('button.selectItemComp.empty:first').trigger('click');
						}
					}
				}
			});
		});
	}
	
	function clickCategroyEvent() {
		$('.foodCategory').each(function() {
			$(this).click(function() {
				
				$('#orderDetails').html('');
				$('#orderDetails').css('display', 'none');
				changeMenuCategory($(this).attr('id'), $(this).prev().prev().html());
				
			});
		});
	}
	
	function clickItemEvent(value) {
		$('.foodItem').each(function() {
			$(this).click(function() {
				
				changeMenuCode(value, $(this).attr('id'), false);
				
				var leftPos = ($(this).position().left - $('#orderDetails').width());
				var topPos = $(this).position().top-$('#orderDetails').height()+20;
				
				currentItemId = $(this).attr('id');
				currentOptCode = new Array();
				
				$('#orderDetails')
					.css('top', (currentMenu=="set")?(topPos+$('#setDetails').position().top):(topPos < 0)?0:topPos)
					.css('left', (leftPos < 0)?0:((currentMenu=="set")?(leftPos+50):leftPos));
				$('#orderDetails').css('display', '');	
				
			});
		});
	}
	
	function selectCompEvent(set) {
		$(".selectItemComp").each(function() {
			$(this).click(function() {
				
				$('.selectItemComp.selected').removeClass('selected');
				$(this).addClass('selected');
          		changeItemComp($(this).attr('id'), set);
          		
			});
		});
		
		$('.selectItemComp:first').trigger('click');
	}
	
	function scrollEvent() {
		$(window).scroll(function () { 
				$('div#orders').css('top', $(window).scrollTop());
				$('div#fontSize').css('top', $(window).scrollTop());
				$('div#loadingBox').css('top', $(window).scrollTop());
				$('div#addedMsg').css('top', $(window).scrollTop() + $('div#orders').height() + 6);
		   }).trigger('scroll');
	}
	
	function resizeEvent() {
		$('div#orders').css('left', $(window).width() - $('div#orders').width());
		$('div#fontSize').css('left', 0);
		
		if(currentItemId != "") {
			var leftPos = ($('#'+currentItemId).position().left - $('#orderDetails').width());
			$('#orderDetails').css('top', $('#'+currentItemId).position().top)
						.css('left', (leftPos < 0)?0:leftPos);
		}
		
		$('div#addedMsg').css('left', $(window).width() - $('div#addedMsg').width())
							.css('top', $('div#orders').height() + 6);
	}
	
	function clickSummaryBtnEvent() {
		$('div#orders').click(function() {
			$('div#orders').removeClass('newOrder');
			$('label#newMsg').html('');
			if($('div#orders').hasClass('show')) {
				$('div#orders').removeClass('show');
				//$("#ui-datepicker-div").hide();
			} else {
				$('div#orders').addClass('show');
				previewSummary();
				$("#closeSumBtn").click(function() {
					$('div#previewSummary').css('display', 'none');
					$('div#orders').removeClass('show');
				});
			}
			var left = $(window).width() - 45 - $('div#previewSummary').width();
			var top = $(window).scrollTop() + $('div#orders').height() + 5;
			$('div#previewSummary')
				.css('left', left)
				.css('top', top)
				.toggle();
		});
	}
	
	//20110509
	function clickSetEvent() {
		$('.foodSet').each(function() {
			$(this).click(function() {
				
				$('#setDetails').html('');
				$('#setDetails').css('display', 'none');
				
				tempSetOrder = {};
				tempSetOrder['setName'] = $(this).attr('id')+'_'+$(this).prev().prev().html();
				tempSetOrder['price'] = $(this).next().next().html();
				tempSetOrder['subItem'] = new Array();
				
				changeMenuCode("set", $(this).attr('id'), false);
				getSetCategory();
				//$('#setDetails').find('button.setCategory').attr("disabled", true);
				
				$('#setDetails').css('width', '85%')
					.css('top', $(window).height()/2.5 + $(window).scrollTop())
					.css('left', $(window).width()/2 - $('#setDetails').width()/2);
					
				
				$('#setDetails').css('display', '');
					
				//$('button#submit').css('display', 'none');
				
			});
		});
	}
	
	function selectSetCategoryEvent(type) {
		$("#selectedSetCategory").change(function () {
	          $('#selectedSetCategory').find("option:selected")
	          	.each(function() {
	          		$('div#setImage').html('<img src="../images/food.jpg"/><br/><br/>');
	          		$('#composition-container').remove();
	          		$('#options-container').remove();
	          		changeMenuCode(type, $(this).val(), true);
	              });
	        })
	        .trigger('change');
	}
	
	function selectNextConfigItem() {
		var flag = false;
		
		$('#setDetails').find('button.setCategory').each(function() {
			$(this).removeClass('selected');
			if(!$(this).hasClass('made')) {
				$(this).trigger('click');
				flag = true;
				return false;
			}
		});
		
		if(!flag) {
			$('#setCategoryContent').prev().remove();
			$('#setCategoryContent').prev().remove();
			$('button#submit').css('display', 'none');
			$('#setCategoryContent').html('<label class="text">Please click "Add" to add in order list.</label>');
			$('#setBtn').html('');
			$('.setCategory.selected').removeClass('selected');
			$('#submit').css('display', '');
		}
		
		$(window).scrollTop(0);
		$(window).trigger('scroll');
	}
	
	function confirmSetSubItemEvent() {
		var temp = {};
		temp['itemName'] = currentItemId+"_"+$('#'+currentItemId).parent().find('label:first').html();
		temp['itemPrice'] = 'HKD 0';
		temp['amount'] = 1;
		temp['itemOpt'] = currentOptCode;

		tempSetOrder['subItem'].splice(tempSetOrder['subItem'].length, 0, temp);
		
		$('#'+$('#setDetails').find('button.setCategory.selected').attr('id')+'_image').css('display', '');
		$('#setDetails').find('button.setCategory.selected').addClass('made').attr("disabled", true);
    	
		$('#orderDetails').css('display', 'none');
		selectNextConfigItem();
		/*currentItemId
		
		$('#confirmSetChoiceBtn').click(function() {
			
			var category = $('#selectedSetCategory').find("option:selected");
			
			temp['itemName'] = category.val() + '_' + category.html();
			temp['itemPrice'] = 'HKD 0';
			temp['amount'] = 1;
			temp['itemOpt'] = currentOptCode;
			
			tempSetOrder['subItem'].splice(tempSetOrder['subItem'].length, 0, temp);
	    	
			$('#'+type+'_image').css('display', '');
	    	$('#'+type).addClass('made');
	    	$('#'+type).attr("disabled", true);
	    	selectNextConfigItem();
	    });*/
	}
	/************************************END EVENT************************************/
	
	//20110509
	function getSetCategory() {
		//alert($('#setDetails').find('button.setCategory').length)
		$('#setDetails').find('button.setCategory').unbind('click');
		$('#setDetails').find('button.setCategory').each(function() {
			$(this).click(function() {
				//if(curSetCate != $(this).attr('index') && (curSetCate == 0 && $(this).attr('index'))) {
					var type = $(this).attr('id');
					currentOptCode = new Array();
					//alert($('.setCategory.selected').html())
					$('.setCategory').removeClass('selected');
					$(this).addClass('selected');
					
					$('#setChoices').html('');
					$('div#setChoices').append(
							"<div id = 'setCategory-container'>" 	+
								"<label class='text'>"+($(this).html()).replace(/<br>/g, ' ')+":&nbsp;</label><br/><br/>" +
								"<table id = 'selectedSetCategory' style='font-size:18px; width:100%'>" 	+
									'<tbody>' 	+
										changeMenuCategory("set", "", type) +
									'</tbody>'	+
								"</table>"							+
				 			 "</div>");

					clickItemEvent(type);
				    $('#orderDetails').css('display', 'none');
					//$('div#setBtn').html(addBtn('confirmSetChoiceBtn')+'<br/><br/>');
					//confirmSetSubItemEvent(type);
					//selectSetCategoryEvent(type);
				//}
			});
		});
		
		$('#setDetails').find('button.setCategory:first').trigger('click');
		curSetCate = $('#setDetails').find('button.setCategory:first').attr('index');
	}
	
	function getSets() {
		closeAllPopupDiv();
		showLoadingBox('body', 500);
		$.ajax({
			type: "GET",
			url: "../ui/fsdMenuSetCMB.jsp",
			async: false,
			success: function(values){
				currentMenu = "set";
				$('table#menuChoices').html('<tbody>'+values+'</tbody>');
				clickSetEvent();
				//$('#backFCBtn').remove();
				addBtn('mainPage');
				addBtn('foodCategory');
				addBtn('orderHist');
				$(window).scrollTop(0);
				$(window).trigger('scroll');
				hideLoadingBox('body', 500);
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				hideLoadingBox('body', 500);
				alert('Error in "getSets"');
			}
		});//$.ajax
		
	}
	
	function init() {
		var content = 
			'<tr>' +
				'<td align="center">' +
					'<img src="../images/food_menu.jpg"/>' +
				'</td>' +
			'</tr>' +
			'<tr><td>&nbsp;</td></tr>' +
			'<tr>' +	
				'<td align="center">' +
					'<div align="center" style="width:450px; height:auto">' +
						//'<button onclick="getSets();" id="set" class = "ui-button ui-widget ui-state-default ui-corner-all" style="color:#0000FF; width:200px; height:auto; float:left; font-size:24px;">' +
						//'Breakfast Set Menu</button>' +
						'<button onclick="getFoodCategory();" id="menu" class = "ui-button ui-widget ui-state-default ui-corner-all" style="color:#0000FF; width:200px; height:auto; font-size:24px;">' +
						'Menu</button>' +
					'</div>' +
				'</td>' +
			'</tr>' +
			'<tr><td>&nbsp;</td></tr>' +
			'<tr>' +
				'<td align="center">' +
					'<table id="orderHistory" class="ui-button ui-widget-content ui-corner-all" style="width:70%">' +
					
					'</table>' +
				'</td>' +
			'</tr>';
		
		$('table#menuChoices').html('<tbody>'+content+'</tbody>');
		getOrderHistory();
		$('#viewHistory').remove();
		$(window).scrollTop(0).trigger('scroll');
	}
	
	function increaseFontSize() {
		$('div#fontSize').click(function() {
			var currentFontSize = $('label').css('font-size');
		    var currentFontSizeNum = parseFloat(currentFontSize, 10);
		    var newFontSize = currentFontSizeNum*1.2;
		    $('label').css('font-size', newFontSize);
		    return false;

		});
	} 
	
	function closeAllPopupDiv() {
		$('#orderDetails').css('display', 'none');
		$('#setDetails').css('display', 'none');
		$('#previewSummary').css('display', 'none');
	}
	
	function spinnerEvent() {
		$('button.quantityBtn').click(function() {
			var quantityInput = $(this).parent().find('.quantity-input');
			var curQuan = quantityInput.val();
			
			if($(this).attr('id') == 'spinner_add') {
				quantityInput.val(parseInt(quantityInput.val()) + 1);
			}else if($(this).attr('id') == 'spinner_sub') {
				quantityInput.val(parseInt(quantityInput.val()) - 1);
			}
			
			if(parseInt(quantityInput.val()) == 0) {
				quantityInput.val(1);
			}
			modifiyOrderQuantity($(this).parent().attr('uuid'), quantityInput.val());
			
			var curPrice = $('.itemPrice[uuid='+$(this).parent().attr('uuid')+']').html();

			$('label[uuid='+$(this).parent().attr('uuid')+']').each(function() {
				if($(this).hasClass('itemPrice')) {
					$(this).html((parseInt(curPrice)/curQuan)*quantityInput.val());
					$('span.totalPay').html(
							parseInt($('span.totalPay').html())-
							parseInt(curPrice)+
							(parseInt(curPrice)/curQuan)*quantityInput.val());
				}
				else if($(this).hasClass('quantity')) {
					$(this).html(quantityInput.val());
				}
			});
		});
		/*$('button#spi	nner_add').click(function() {
			$('#quantity-container').val(parseInt($('#quantity-container').val()) + 1);
		});
		
		$('button#spinner_sub').click(function() {
			if(parseInt($('#quantity-container').val()) > 1)
				$('#quantity-container').val(parseInt($('#quantity-container').val()) - 1);
		});*/
	}
	
	function selectServeTypeEvent() {
		$('#fdServeType').unbind('change');
		
		if(serveType == null)
			serveType = "null";
		
		$('#fdServeType option[value='+serveType+']').attr("selected", true);
		
		$('#fdServeType').change(function() {
			$('option:selected', this).each(function(){
		        	serveType = $(this).val();
		    	});
			});
	}
	
	function selectServTimeEvent() {
		$("input#datepicker").datepicker('destroy');
		$('input:radio[name="time"]').unbind('click');
		
		$("input#datepicker").datepicker({
			onSelect: function(dateText, inst) {
				$("#ui-datepicker-div").hide();
				var selectDate = new Date();
				selectDate.setFullYear(inst.selectedYear, inst.selectedMonth, inst.selectedDay);
				
				time = selectDate;
			  }
		});
		$("#ui-datepicker-div").css('z-index', 13);
		
		if(time == "now") {
			$('input:radio[value="now"]').attr('checked', true);
			$('#serveHour').attr('disabled', true);
			$('#serveMin').attr('disabled', true);
			$('#serveHour option[value=null]').attr("selected", true);
			$('#serveMin option[value=null]').attr("selected", true);
		}else if(time == "custom" || time != null) {
			//$("input#datepicker").datepicker("setDate", time);
			$("input#datepicker").val(time.getDate()+'/'+(time.getMonth()+1)+'/'+time.getFullYear());
			$('#serveHour option[value='+h+']').attr("selected", true);
			$('#serveMin option[value='+m+']').attr("selected", true);
			$('input:radio[value="custom"]').attr('checked', true);
			$('#serveHour').attr('disabled', false);
			$('#serveMin').attr('disabled', false);
			$("#ui-datepicker-div").hide();
		}else {
			$('#serveHour').attr('disabled', true);
			$('#serveMin').attr('disabled', true);
		}
		
		$('input:radio[name="time"]').each(function() {
			$(this).click(function() {
				if($(this).val() == "now") {
					time = $(this).val();
					$('#serveHour').attr('disabled', true);
					$('#serveMin').attr('disabled', true);
				}
				else {
					time = "custom";
					$('#serveHour').attr('disabled', false);
					$('#serveMin').attr('disabled', false);
					$("input#datepicker").focus();
				}
				return;
			});
		});
		
		$('#serveHour').change(function() {
			$('option:selected', this).each(function(){
		        	h = $(this).val();
		        	if(h == 7 || h == 19) {
		        		$('#serveMin')[0].selectedIndex = 3;
		        		$('#serveMin').trigger('change');
		        	}
		    	});
			});
		$('#serveMin').change(function() {
			$('option:selected', this).each(function(){
		        	m = $(this).val();
		        	if((h == 7 && m < 30) || (h == 19 && m > 30)) {
		        		$('#serveMin')[0].selectedIndex = 3;
		        		$('#serveMin').trigger('change');
		        	}
		    	});
			});
	}
	
	function getOrderHistory() {
		$.ajax({
			type: "GET",
			url: "../ui/fsdOrderHistory.jsp",
			async: false,
			success: function(values){
				$('table#orderHistory').html(values);
				historyDetail();
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "getOrderHistory"');
			}
		});
	}
	
	function historyDetail() {
		$('.oh_detail').each(function() {
			$(this).click(function() {
				$('#historyDetail').html('');
				var no = $(this).find('td:first label').html();
				$.ajax({
					type: "GET",
					url: "../ui/fsdOrderHistoryDetail.jsp",
					async: false,
					data: "orderNo="+no, 
					success: function(values){
						$('#historyDetail').html(values);
						$('button#closeDetail').click(function() {
							$('#orderHistoryDetail').css('display', 'none');
						});
						$('#orderHistoryDetail').css('top', $(window).height()/4 + $(window).scrollTop());
						$('#orderHistoryDetail').css('left', $(window).width()/2 - $('#orderHistoryDetail').width()/2);
						$('#historyDetail tr:first label#orderNo').html('('+no+')');
						$('#orderHistoryDetail').css('display', '');
						
					},//success
					error: function(jqXHR, textStatus, errorThrown) {
						alert('Error in "getOrderHistory"');
					}
				});
			});
		});
	}
	
	function skipItemEvent() {
		$('#'+$('#setDetails').find('button.setCategory.selected').attr('id')+'_image').css('display', '');
		$('#setDetails').find('button.setCategory.selected').addClass('made').attr("disabled", true);
		
		selectNextConfigItem();
	}
	
	function alertMsg(msg) {
		$('label#alertMsg').html(msg);
		$('button#closeAlert').click(function() {
			$('div#alertDialog').css('display', 'none');
			$('div#overlay').css('display', 'none');
		});
		$('div#alertDialog').css('top', $(window).height()/2 - $('div#alertDialog').height()/2 + $(window).scrollTop())
								.css('left', $(window).width()/2 - $('div#alertDialog').width()/2);
		$('div#alertDialog').css('display', '');
		$('div#overlay').css('display', '');
		$('div#overlay').css('height', $('body').height());
		$('div#overlay').css('width', $('body').width());
		$("button#skipAlert").css('display', 'none');
		$("button#closeAlert").find('label').html('Close');
	}
	
	$(document).ready(function(){
		getFoodCategory();
		previewSummaryTemplate();
		scrollEvent();
		$(resizeEvent);
		$(window).bind('resize', resizeEvent);
		$(window).trigger('scroll');
		clickSummaryBtnEvent();
		$('div#orders').toggle();
		$('#backBtn').click(function() {
			confirmExit();
		});
	});

	//end
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>