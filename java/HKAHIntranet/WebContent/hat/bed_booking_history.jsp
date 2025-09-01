<%@ page import="com.hkah.servlet.*"%>

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
	font-size:13.5px; 
	text-align: center;
}
.title {
	background-color:#BFCFFE;
}
.booking {
	background-color:#FFFF37;
}
.cancel {
	background-color:#FF8F59;
}
.noshow {
	background-color:#46A3FF;
}
.IC {
	background-color:#79FF79;
}
.IN {
	background-color:#C48888;
}
.ME {
	background-color:#84C1FF;
}
.OB {
	background-color:#FFE66F;
}
.PD {
	background-color:#CA8EFF;
}
.SU {
	background-color:#ff7575;
}
.total {
	background-color:#FF60AF;
}
.history {
	cursor:pointer;
}
.content {
	background-color:#FFFFCE;
}
</style>
</head>

<body>
<div id="bedHistoryInfo" style="display:none; z-index:10; height:100%">
	<div id="bedHistoryContent"></div>
</div>

<div style="background-color:#FFC1E0; width:100%;">
	<label style="font-weight:bold;">Date Range: </label> 
	<input style="background-color:yellow; color:blue;" type="text" id="date_from" value="" disabled/>
	<label> - </label>
	<input style="background-color:yellow; color:blue;" type="text" id="date_to" value="" disabled/>
	<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' id="requestBtn">Submit</button>
</div>

<div id="bkHistoryTab" style="width:100%; height:auto">
	<ul style="width:99.5%">
		<li style="width:11%"><a href="#bkHistory">Bed Booking Statistics</a></li>
	</ul>
	
	<div style="width:95%; height:auto;" id="bkHistory">
	</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
</body>

<script>
var currentIndex = 0;
var selectedDate = "";

function changeView() {
	showLoadingBox('#bkHistoryTab', 200);
	if(currentIndex == 0) {
		$('#bkHistory').html('');
		
		if($('#date_to').val() && selectedDate == "") {
			selectedDate = $('#date_to').val().replace('/', '-').replace('/', '-');
		}
		else if(selectedDate == ""){
			var temp = new Date();
			selectedDate = temp.getDate()+'-'+(temp.getMonth()+1)+'-'+temp.getFullYear();
			$('#date_to').datepicker('setDate', temp);
			
			var tempForm = new Date();
			tempForm.setFullYear(temp.getFullYear(), temp.getMonth(), temp.getDate()-6);
			$('#date_from').val(tempForm.getDate()+'/'+(tempForm.getMonth()+1)+'/'+tempForm.getFullYear());
		}

		$.ajax({
			url: "../ui/bedBookingStat.jsp",
			async: true,
			data: "date="+selectedDate,
			success: function(values){
				$('#bkHistory').html(
						'<table style="width:100%">'+
							values +
						'</table>'
						);
				hideLoadingBox('#bkHistoryTab', 500);
				clickCellEvent();
			}
		});
	}
}

function getDetail(date, ward, type, db) {
	$('#bedHistoryContent').html('');
	showLoadingBox('#bkHistoryTab', 500);
	if(db) {
		$.ajax({
			url: "../ui/bedBookingHistoryDetail.jsp",
			async: true,
			data: "date="+date+"&ward="+ward+"&type="+type,
			success: function(values){
				$('#bedHistoryContent').html(values);
				hideLoadingBox('#bkHistoryTab', 500);
			}
		});
	}
	else {
		$('#bedHistoryContent').html('No record.');
		hideLoadingBox('#bkHistoryTab', 500);
	}
	$('#bedHistoryInfo').dialog('open');
}

function clickCellEvent() {
	$('.history').each(function() {
		$(this).click(function() {
			if($(this).html() == "0") {
				 getDetail(null, null, null, false);
			}else {
				var tmp = $(this).attr('id').split('_');
				getDetail(tmp[1], tmp[0], tmp[2], true);
			}
		});
	});
}

function createTab() {
	$('#bkHistoryTab').tabs({
		show: function(event, ui) {
			currentIndex = ui.index;
			
			changeView();
		}
	});
}

function createHistoryDetailDialog() {
	$('#bedHistoryInfo').dialog({
		autoOpen: false,
		resizable: false,
		draggable: false,
		modal: false,
		width: 500,
		height: 400,
		title: "Detail",
		//position: [($(window).width()/2)-($('div#bedInfo').width()/2), ($(window).height()/10)], 
		open: function(event, ui) {
			$('div[aria-labelledby=ui-dialog-title-bedInfo]').css('top', -500).css('height', 400);
			$('#bedHistoryInfo').css('height', 400);
			$( 'html, body' ).animate( { scrollTop: 0 }, 0 );
			hideLoadingBox('#bkHistoryTab', 500);
		}
	});
}

$(document).ready(function() {
	$('#date_to').datepicker({
		dateFormat: 'dd/mm/yy',
		showOn: "button",
		buttonImage: "../images/calendar.jpg",
		buttonImageOnly: true,
		onSelect: function(dateText, inst) {
			$("#ui-datepicker-div").hide();
			var selectDate = new Date();
			selectDate.setFullYear(inst.selectedYear, inst.selectedMonth, inst.selectedDay-6);
			
			$('#date_from').val(selectDate.getDate()+'/'+(selectDate.getMonth()+1)+'/'+selectDate.getFullYear());
		}
	});
	
	$('#requestBtn').click(function(){
		selectedDate = $('#date_to').val().replace('/', '-').replace('/', '-');
		changeView();
	});
	
	createTab();
	createHistoryDetailDialog();
});
</script>