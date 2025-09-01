<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
%>
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">

<html>
<meta http-equiv="refresh" content=1200>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<head>
<style>
TD { 
	font-family: "Arial", "Verdana", "sans-serif"; 
	font-size:14px; 
	text-align: center;
}
.date {
	font-weight: bold;
}
.empty {
	background-color:#F0F0F0 !important; 
}

.available {
	background-color:#80FE80;
}

.title {
	background-color:#BFCFFE;
}

.booked {
	background-color:#FFCC00;
}

.occupied {
	background-color:#FE8080;
}

.total {
	background-color:#D580FE;
}

.standard {
	background-color:#FEB380;
}

.semi-private {
	background-color:#80C8FE;
}

.private {
	background-color:#8FB200;
}
.vip {
	background-color:#CC9955;
}
#target_Ward {
	font-size:20px;
}
.ot {
	background-color:#00CCFF;
}
.ccic {
	background-color:#FF66FF;
}
.dateHeader {
	font-weight:bold;
	cursor: pointer;
}
.content {
	background-color:#FFFFCE;
}
.vip_odd {
	background-color:#B9B973;
}
.vip_even {
	background-color:#CDCD9A;
}
.private_odd {
	background-color:#C48888;
}
.private_even {
	background-color:#D9B3B3;
}
.semi-private_odd {
	background-color:#81C0C0;
}
.semi-private_even {
	background-color:#A3D1D1;
}
.standard_odd {
	background-color:#FFC78E;
}
.standard_even {
	background-color:#FFDCB9;
}
.totalWard {
	background-color:#ff7575;
}
#targetWardLabel {
	font-size:24px;
	font-weight:bold;
	background:#FFFFDF;
	height:30px;
}

.detail_occupied {
	background-color:#FE8080 !important;
}
.detail_booked {
	background-color:#FFCC00 !important;
}
.detail_discharge {
	background-color:#d3a4ff !important;
}
.detail_male {
	background-color:#84C1FF !important;
}
.detail_female {
	background-color:#FF95CA !important;
}
.detail_unknown {
	background-color:#93FF93 !important;
}

.edit_Btn {
	display:none;
}

.enable {
	background-color:#80FE80 !important;
}

.unable {
	background-color:#F1FF5B !important;
}
#overlay {
	     z-index: 1000;
	     width:100%;
	     height:100%;
	}
.current_patient{
	background-color:#7878E1;
}
.to_be_admit{
	background-color:#CD82CD;
}
.no_patient{
	background-color:#80FE80;
	
}

</style>
</head>

<body>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="One Stop Booking" />
	<jsp:param name="category" value="Report" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="translate" value="N" />
</jsp:include>
<div id="overlay" class="ui-widget-overlay" style="display:none"></div>
<div id="confirmDialog" style="display:none; height:100%; z-index:10;">
	<label>Change the Status:</label><br/><br/>
<%-- 
	<input type="radio" value="X" name="changeBedInfo"/><label>Block the bed for next inpatient (for one day)</label>
--%>
	<input type="radio" value="R" name="changeBedInfo"/><label>Block the bed for renovation (until unblock)</label>
	<input type="radio" value="U" name="changeBedInfo"/><label>Unblock the bed</label>
	<br/>
	<hr/>
	<label>Upgrade the Class to:</label><br/><br/>
	<input type="radio" value="I" name="changeBedInfo"/><label>VIP</label><br/>
	<input type="radio" value="P" name="changeBedInfo"/><label>PRIVATE</label><br/>
	<input type="radio" value="S" name="changeBedInfo"/><label>SEMI-PRIVATE</label><br/>
	<input type="radio" value="T" name="changeBedInfo"/><label>STANDARD</label>
	<br/><br/>
	<label>Select the following beds to block: </label>
	<div id="bedList">
		
	</div>
</div>

<div id="editDialog" style="display:none; height:100%; z-index:10;">
	<div style="float:left; width:100%;">
		<div>
			<label>Class: </label>
		</div>
		<div>
			<select id="edit_Class">
			</select>
		</div>
	</div>
	<br/>
	<div style="float:left; width:100%">
		<div>
			<label>Specialty: </label>
		</div>
		<div>
			<select id="edit_Specialty"></select>
		</div>
	</div>
	<br/><br/>
	<div style="float:left; width:100%">
		<div>
			<label>Date: </label>
		</div>
		<div>
			<input id="selectDate" disabled/>
			<div id="datepicker"></div>
		</div>
	</div>
	<br/><br/>
	<div style="float:left; width:100%">
		<div>
			<label>Total: </label>
		</div>
		<div>
			<input id="totalBeds" disabled/>
		</div>
	</div>
	<div style="float:left; width:100%">
		<div>
			<label>Adjust: </label>
		</div>
		<div>
			<input id="adjustment" value="0"/>
			<button id="spinner_add" class = "ui-button ui-widget ui-state-default ui-corner-all">+</button>
			<button id="spinner_sub" class = "ui-button ui-widget ui-state-default ui-corner-all">-</button>
		</div>
	</div>
</div>

<div id="bedInfo" style="display:none; z-index:10; height:100%">
	<div id="bedInfoContent"></div>
</div>

<div style="background-color:#76EEC6;">
	<button id="updateBtn" class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
			style="font-size:14px; height:25px;">
		<img src="../images/refresh.png" style="width:15px; height:15px;"/>
		Refresh
	</button>
	<label style="font-size:14px;">Last Update: </label><label id="updateTime" style="font-size:14px;"></label>
</div>
<br/>
<div id="overviewTab" style="width:95%; height:auto">
	<ul style="width:99.5%">
		<li style="width:8%"><a href="#bedOverviewByDate">By Date</a></li>
		<li style="width:11%"><a href="#bedOverviewBySpec">By Specialty</a></li>
		<li style="width:12%"><a href="#abedOverview">Available Bed</a></li>
		<li style="width:20%"><a href="#availSexBedOverview">Available Bed - By Gender</a></li>
		<li style="width:13%"><a href="#bedOverviewDetail">Bed Adjustment</a></li>
		<li style="width:13%"><a href="#bedTest">Bed - Patient Info</a></li>
	</ul>
	
	<div style="width:95%; height:auto;" id="bedOverviewByDate">
	</div>
	
	<div style="width:95%; height:auto;" id="bedOverviewBySpec">
	</div>
	
	<div style="width:95%; height:auto;" id="abedOverview">
	</div>
	
	<div style="width:95%; height:auto;" id="availSexBedOverview">
	</div>
	
	<div style="width:95%; height:auto;" id="bedOverviewDetail">
	</div>
	
	<div style="width:95%; height:auto;" id="bedTest">
	</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>

<script>
var today;
var available;
var sex;
var add = 0;
var currentIndex = 0;
var classes = ["VIP", "Private", "Semi-Private", "Standard"];
var wards = ["All", "ICU", "IU", "Medical", "OB", "Pediatric", "Surgical"];
var ward = "All";
var wardOpt = "";
var showAll = false;
var redirect = false;
var showTotal = false;
var info_ward = "";
var info_acm = "";
var info_type = "";
var ward_index = "";
var updateWard="";
var enable = "";


function createOverviewTab() {
	$('#overviewTab').tabs({
		select: function(event, ui) {
			
		},
		show: function(event, ui) {
			currentIndex = ui.index;
			
			if(!redirect) {
				add = 0;
			} else {
				redirect = false;
			}
			ward = "All";
			
			$('#editDialog').dialog('close');
			if(ui.index == 0) {
				today = true;
				available = false;
				sex = false;
			}
			
			if(ui.index == 1) {
				today = false;
				available = false;
				sex = false;
			}			
			if(ui.index == 2) {
				today = false;
				available = true;
				sex = false;
			}
			if(ui.index == 3) {
				ward = "ICU";
				today = false;
				available = true;
				sex = true;
			}
			if(ui.index == 4) {
				ward = "ICU";
				ward_index = 0;
			}
			if(ui.index==5){
				ward = "ICU";
				ward_index = 0;
			}
			changeView();
		}
	});
}


function changeView() {
	showLoadingBox('#overviewTab', 200);
	$('input:radio[name=ward]').remove();
	$('div#targetWardLabel').remove();
	if(currentIndex == 0) {
		$('#bedOverviewByDate').html('');
		$.ajax({
			url: "../ui/bedOverviewStatus.jsp",
			async: true,
			cache: false,
			data: "today=true&available=false&add="+add+
					"&showAll="+showAll+"&showTotal="+showTotal+"&sex="+sex,
			success: function(values){
				$('#bedOverviewByDate').html(
						'<table style="width:100%">'+
							values +
						'</table>'
						);
				theClickEvent();
				hideLoadingBox('#overviewTab', 500);
				
				showAll = $('#showAllCol').attr("checked");
				showTotal = $('#showTotal').attr("checked");
				
				$('#showAllCol').click(function() {
					if(showAll) {
						showAll = false;
					}
					else {
						showAll = true;
					}
					changeView();
				});

				toggeleTotal();
				
				$('#showTotal').click(function() {
					if(showTotal) {
						showTotal = false;
					}
					else {
						showTotal = true;
					}
					changeView();
				});
				
				$('.total').css('display', 'none');
				
				popUpBedInfo();
				$('.specialty').css('cursor', 'default');
			}//success
		});//$.ajax
	}
	else if(currentIndex == 1) {
		$('#bedOverviewBySpec').html('');
		showAll = false;
		showTotal = false;
		$.ajax({
			url: "../ui/bedOverviewStatus.jsp",
			async: true,
			cache: false,
			data: "today=false&available=false&add="+add+
					"&ward="+ward+"&showAll="+showAll+"&showTotal="+showTotal+"&sex="+sex,
			success: function(values){
				$('#bedOverviewBySpec').html(
						'<table style="width:100%">'+
							values +
						'</table>'
						);
				theClickEvent();
				clickDateHeaderEvent();
				
				//toggeleTotal();
				
				wardSelectEvent();
				
				$('.total').css('display', 'none');
				
				hideLoadingBox('#overviewTab', 500);
				if(ward == "All") {
					$('.edit_Btn').remove();
				}
			}//success
		});//$.ajax
	}
	else if(currentIndex == 2) {
		$('#abedOverview').html('');
		showAll = false;
		showTotal = false;
		$.ajax({
			url: "../ui/bedOverviewStatus.jsp",
			async: true,
			cache: false,
			data: "today=false&available=true&add="+add+
					"&showAll="+showAll+"&showTotal="+showTotal+"&sex="+sex,
			success: function(values){
				$('#abedOverview').html(
						'<table style="width:100%">'+
							values +
						'</table>'
					);
				theClickEvent();
				hideLoadingBox('#overviewTab', 500);
			}//success
		});//$.ajax
	}
	else if(currentIndex == 3) {
		$('#availSexBedOverview').html('');
		showAll = false;
		showTotal = false;
		$.ajax({
			url: "../ui/bedOverviewStatus.jsp",
			async: true,
			cache: false,
			data: "today=false&available=true&add="+add+
					"&showAll="+showAll+"&showTotal="+showTotal+"&sex="+sex+"&ward="+ward,
			success: function(values){
				$('#availSexBedOverview').html(
						'<table style="width:100%">'+
							values +
						'</table>'
					);
				theClickEvent();
				wardSelectEvent();
				
				hideLoadingBox('#overviewTab', 500);
			}//success
		});//$.ajax
	}
	else if(currentIndex == 4) {
		$('#bedOverviewDetail').html('');
		$.ajax({
			url: "../ui/bedDetailStatus.jsp",
			async: true,
			cache: false,
			data: "add="+add+"&ward="+ward_index,
			success: function(values){
				$('#bedOverviewDetail').html(
						'<table style="width:100%">'+
							values +
						'</table>'
					);
				theClickEvent();
				wardSelectEvent();
				clickBedIconEvent();
				hideLoadingBox('#overviewTab', 500);
			}//success
		});//$.ajax
	}
	else if(currentIndex == 5) {
		$('#bedTest').html('');
		$.ajax({
			url: "../ui/bedStatus.jsp",
			async: true,
			cache: false,
			data: "add="+add+"&ward="+ward_index,
			success: function(values){
				$('#bedTest').html(
						'<table border="0" style="width:100%">'+
							values +
						'</table>'
					);
			
				wardSelectEvent();		
				hideLoadingBox('#overviewTab', 500);
			}//success
		});//$.ajax
	}
	setUpdateTime();
}

function theClickEvent() {
	$('.edit_Btn').click(function() {
		$('input#selectDate').val($(this).attr('id').substring(5));
		$('#editDialog').dialog('open');
	});
	
	$('.prev_img').click(function() {
		add--;
		changeView();
	});
	
	$('.next_img').click(function() {
		add++;
		changeView();
	});
}

function toggeleTotal() {
	if(showTotal) {
		$('.specialty').css('display', '');
	}
	else {
		$('.specialty').css('display', 'none');
	}
	
	$('.changeCol').each(function() {
		var change = 0+((showTotal)?0:-1)+((showAll)?0:-2);
		$(this).attr('colspan', $(this).attr('colspan')+change);
	});
}

function wardSelectEvent() {
	var content = "";
	
	//for(var i = 0; i < wards.length; i++) {
	//	content += '<option value="'+wards[i]+' "'+((ward.indexOf(wards[i])>-1)?'selected':'')+'>'+wards[i]+'</option>';
	//}
	
	$('input:radio[name=ward][value='+ward+']').attr('checked', true);
	$('div#targetWardLabel').html(ward);
	
	$('input:radio[name=ward]').click(function() {
		ward = $(this).val();
		ward_index = $(this).attr('index');
		$('div#targetWardLabel').html(ward);
		changeView();
	});
	
}

function updateBedStat() {
	$.ajax({
		url: "../hat/updateBedStat.jsp",
		async: false,
		data: "type=update&total="+$('input#adjustment').val()+"&date="+$("input#selectDate").val()+
				"&acm="+$('#edit_Class').val()+"&ward="+$('#edit_Specialty').val(),
		success: function(values){
			changeView();
		}//success
	});//$.ajax
}

function getAdjustment() {
	var val = "0";
	$.ajax({
		url: "../hat/updateBedStat.jsp",
		async: false,
		data: "type=adjust&total="+$('input#adjustment').val()+"&date="+$("input#selectDate").val()+
				"&acm="+$('#edit_Class').val()+"&ward="+$('#edit_Specialty').val(),
		success: function(values){
			val = values;
		}//success
	});//$.ajax
	
	return val;
}

function selectClassEvent() {
	$('#edit_Class').change(function () {
        $('#edit_Class').find("option:selected")
	      	.each(function() {
	      		var total;
	      		
	      		if(currentIndex == 0)
	      			total = $('td#total_'+$(this).html().toLowerCase()+"_"+$('#edit_Specialty').find("option:selected").val().toLowerCase()).html();
	      		else if(currentIndex == 1) {
	      			total = $('td#total_'+$(this).html().toLowerCase()+"_"+$('input#selectDate').val().replace(/\//g, '-')).html();
	      		}

	      		$('input#totalBeds').val(total);
	      		$('#adjustment').val(getAdjustment().replace(/(^\s*)|(\s*$)/g, ""));
	          });
    })
    .trigger('change');
}

function clickDateHeaderEvent() {
	$('.dateHeader').click(function() {
		add = parseInt($(this).attr('add'));
		redirect = true;
		$('#overviewTab').tabs( "select", 0);
	});
}

function selectSpecialtyEvent() {
	$('#edit_Specialty').change(function () {
        $('#edit_Specialty').find("option:selected")
	      	.each(function() {
	      		var total;
	      		
	      		if(currentIndex == 0)
	      			total = $('td#total_'+$('#edit_Class').find("option:selected").html().toLowerCase()+"_"+$(this).val().toLowerCase()).html();
	      		else if(currentIndex == 1) {
	      			total = $('td#total_'+$('#edit_Class').find("option:selected").html().toLowerCase()+"_"+$('input#selectDate').val().replace(/\//g, '-')).html();
	      		}

	      		$('input#totalBeds').val(total);
	      		$('#adjustment').val(getAdjustment().replace(/(^\s*)|(\s*$)/g, ""));
	          });
    })
    .trigger('change');
}

function popUpBedInfo() {
	$('.detail').each(function () {
		if($(this).html() !== "") {
			$(this).css('cursor', 'pointer');
			$(this).click(function () {
				var info = $(this).attr('id').split('_');
				info_type = info[0];
				info_acm = info[1];
				info_ward = info[2];
				if(info_ward != "specialty") {
					$('#bedInfoContent').html('');
					showLoadingBox('#overviewTab', 200);
					$.ajax({
						url: "../ui/bedInformation.jsp",
						async: false,
						data: "date="+$('.date').html()+"&ward="+info_ward+"&acm="+info_acm+"&type="+info_type,
						success: function(values){
							$('#bedInfoContent').html(values);
							$('#bedInfo').dialog("option", 'title', $('#infoWard').html()+' - '+$('#infoACM').html());
							hideLoadingBox('#overviewTab', 200);
						}
					});
					$('#bedInfo').dialog('open');
				}
			});
		}
	});
}

function updateBedEnable() {
	var blockBed = "";
	$('input[name=blockBed]').each(function() {
		if($(this).attr('checked') == true) {
			blockBed += $(this).val()+":";
		}
	});
	
	$.ajax({
		url: "../hat/updateBedStat.jsp",
		async: false,
		data: "type=enable"+"&date="+$("div#bedOverviewDetail .date").html()+
				"&acm="+updateWard.attr('acm')+"&ward="+updateWard.attr('ward')+"&rm="+
				updateWard.attr('room')+
				"&bed="+updateWard.attr('bed')+"&enable="+(($('input[name=changeBedInfo]:checked').val()=='U')?1:0)+
				"&change="+$('input[name=changeBedInfo]:checked').val()+"&blockBed="+blockBed.substring(0, blockBed.length-1),
		success: function(values){
			changeView();
		}//success
	});//$.ajax
}

function getRelatedBedList() {
	$.ajax({
		url: "../ui/rm_bedCMB.jsp",
		async: false,
		data: "Type=Bed&Value="+updateWard.attr('room')+"&format=table",
		success: function(values){
			$('div#bedList').html(values);
		}
	});
}

function clickBedIconEvent() {
	$('.edit_Bed').click(function() {
<%	if (userBean.isLogin()) { %>
		updateWard = $(this).parent();
		var disable = false;
		$('input[name=changeBedInfo]').each(function() {
			if(updateWard.attr('acm') == $(this).next().html()) {
				disable = true;
			}
			$(this).css('display', (disable)?'none':'')
			.next().css('display', (disable)?'none':'');
		});
		getRelatedBedList();
		$('#confirmDialog').dialog('open');
<%	} else { %>
		alert('Please login intranet portal!');
		parent.location.href = "../portal/index.jsp";
<%	} %>
	});
}

function createConfirmDialog() {
	$('#confirmDialog').dialog({
		autoOpen: false,
		resizable: false,
		draggable: false,
		modal: false,
		width: 400,
		height: 1000,
		title: "Confirm",
		position: [($(window).width()/2)-($('div#confirmDialog').width()), 5],
		buttons: {
			"Cancel": function() { 
				$('div#overlay').css('display', 'none');
				$(this).dialog("close"); 
			},
			"Confirm": function() {
				$('div#overlay').css('display', 'none');
				updateBedEnable();
				$(this).dialog("close"); 
			}
		},
		close: function(event, ui) {
			$('div#overlay').css('display', 'none');
		},
		open: function(event, ui) {
			$('div#overlay').css('display', '');
			$('div#overlay').css('height', $('div#overviewTab').height()+100);
			$('div#overlay').css('width', $('body').width());
			$('input[name=changeBedInfo]').each(function() {
				$(this).attr('checked', false);
			});
		}
	});
}

function createBedInfoDialog() {
	$('#bedInfo').dialog({
		autoOpen: false,
		resizable: false,
		draggable: false,
		modal: true,
		width: 500,
		height: 400,
		title: "Detail",
		//position: [($(window).width()/2)-($('div#bedInfo').width()/2), ($(window).height()/10)], 
		open: function(event, ui) {
			$('div[aria-labelledby=ui-dialog-title-bedInfo]').css('top', -500).css('height', 400);
			$('#bedInfo').css('height', 400);
			$( 'html, body' ).animate( { scrollTop: 0 }, 0 );
			hideLoadingBox('#overviewTab', 500);
		}
	});
}

function createEditDialog() {
	$('#editDialog').dialog({
		autoOpen: false,
		resizable: false,
		draggable: false,
		modal: true,
		minWidth: 280,
		height: 340,
		title: "Edit",
		position: [($(window).width()/2)-($('div#editDialog').width()/2), ($(window).height()/10)], 
		buttons: {
			"Cancel": function() { 
				$(this).dialog("close"); 
			},
			"Submit": function() {
				updateBedStat();
				$(this).dialog("close"); 
			}			
		},
		create: function(event, ui) {
/*			$( "#datepicker" ).datepicker({
				dateFormat: 'dd/mm/yy',
				onSelect: function(dateText, inst) {
						  },
				altField: 'input#selectDate',
				altFormat: 'dd/mm/yy'
			});
			*/
			$.ajax({
				url: "../ui/ward_classCMB.jsp",
				async: false,
				data: "Type=Class",
				success: function(values){
					$('#edit_Class').html(values);
				}//success
			});//$.ajax
			
			$.ajax({
				url: "../ui/ward_classCMB.jsp",
				async: false,
				data: "Type=Ward",
				success: function(values){
					wardOpt = values;
					$('#edit_Specialty').html(values);
				}//success
			});//$.ajax
			
			selectClassEvent();
			selectSpecialtyEvent();
			
			$('#spinner_add').click(function() {
				$('#adjustment').val(parseInt($('#adjustment').val()) + 1);
			});
			
			$('#spinner_sub').click(function() {
				$('#adjustment').val(parseInt($('#adjustment').val()) - 1);
			});
		},
		open: function(event, ui) {
			$('#edit_Specialty').attr('disabled', false);
			$('#edit_Specialty')[0].selectedIndex = 0;
			$('#edit_Class')[0].selectedIndex = 0;
			$('#edit_Class').trigger('change');
			$('#adjustment').val(getAdjustment().replace(/(^\s*)|(\s*$)/g, ""));
			
			if(currentIndex == 1){
				$('#edit_Specialty')[0].selectedIndex = $('#target_Ward')[0].selectedIndex-1;
				$('#edit_Specialty').attr('disabled', true);
			}
		}
	});
}

function setUpdateTime() {
	var currentTime = new Date();
	$('label#updateTime').html(currentTime.getFullYear()+"/"+
								(((currentTime.getMonth()+1)<10)?("0"+(currentTime.getMonth()+1)):(currentTime.getMonth()+1))+"/"+
								((currentTime.getDate()<10)?("0"+currentTime.getDate()):currentTime.getDate())+" "+
								((currentTime.getHours()<10)?("0"+currentTime.getHours()):currentTime.getHours())+":"+
								((currentTime.getMinutes()<10)?("0"+currentTime.getMinutes()):currentTime.getMinutes())+":"+
								((currentTime.getSeconds()<10)?("0"+currentTime.getSeconds()):currentTime.getSeconds()));
}

function updateEvent() {
	$('button#updateBtn').click(function() {
		changeView();
	});
}

$(document).ready(function() {
	$('div#overlay').css('display', 'none');
	// create dialog
	var today = new Date();
	$('input#selectDate').val(today.getDate()+"/"+((today.getMonth() > 8)?"":"0")+(today.getMonth()+1)+"/"+today.getFullYear());
	
	createBedInfoDialog();
	
	createEditDialog();
	
	createConfirmDialog();
	
	//create tab
	createOverviewTab();
	
	updateEvent();
	setUpdateTime();
});
</script>