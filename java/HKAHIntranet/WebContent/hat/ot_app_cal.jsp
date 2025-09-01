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
tr { 
	background-color: #DDDDDD;
}
td {
	text-align: center;
	height: 55px;
	border-style: inset !important;
	border-width: 1px;
}
span {
	font-family: "Arial", "Verdana", "sans-serif"; 
	font-size:14px;
}
label {
	font-size:11px;
}
.cell {
	/*border-width:1px 0 1px 0 !important;*/
}
.title_odd {
	background-color:#BEBEBE;
}
.title_even {
	background-color:#d0d0d0;
}
.time {
	background-color:#FFFF37;
}
.title span{
	font-weight: bold;
	font-size: 18px !important;
}
.event {
	position: absolute; 
	z-index: 12;
}
.dateHeader {
	background-color:#00EC00;
}
</style>
</head>

<body>
	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="function.ot.app.cal" />
	</jsp:include>
	<div style="background-color:#FFC1E0; width:100%; height:5%">
		<span style="font-weight:bold;">Date Range: </span> 
		<input style="background-color:yellow; color:blue;" type="text" id="date_from" value="" disabled/>
		<span> - </span>
		<input style="background-color:yellow; color:blue;" type="text" id="date_to" value="" disabled/>
		<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' id="requestBtn">Submit</button>
	</div>
	
	<table id="otApp" style="width:100%" border="0" cellspacing="0" bgcolor="#CCCCCC" cellpadding="0">
	</table>
</body>
</html:html>

<script>
var selectedDate = "";

function moveEventDIV() {
	$('table#otApp').after($('tr#eventRow td').html());
	
	$('tr#eventRow').remove();
	
	locateEvent();
	$(window).bind('resize', locateEvent);
}

function locateEvent() {
	$('.event').each(function() {
		var id = $(this).attr('id');

		var date = id.split('_')[0];
		var listId = id.split('_')[1];
		var st = id.split('_')[2];
		var et = id.split('_')[3];
		var shr = st.split(':')[0];
		var ehr = et.split(':')[0];
		var smin = st.split(':')[1];
		var emin = et.split(':')[1];
		
		var stop = $('td#'+shr+((parseInt(smin)<30)?'00':'30')).position().top;
		var etop = $('td#'+ehr+((parseInt(emin)<30)?'00':'30')).parent().position().top;
		
		$(this).css('left', $('td.bheader_'+listId+'[date="'+date+'"]').position().left);
		$(this).width($('td.bheader_'+listId+'[date="'+date+'"]').width() + 1);
		$(this).css('top', stop + 55 * parseFloat(((parseInt(smin)>=30)?((parseInt(smin)-30.0)/30.0):(parseInt(smin)/30.0))));
		$(this).height(etop - 55 * parseFloat(((parseInt(emin)>=30)?(((parseInt(emin)-30.0)*-1)/30.0):(parseInt(emin)/-30.0))) - 
				stop + 55 * parseFloat(((parseInt(smin)>=30)?((parseInt(smin)-30.0)/-30.0):(parseInt(smin)/-30.0))));
	});
}

function fetchOtApp() {
	if($('#date_from').val() && selectedDate == "") {
		selectedDate = $('#date_from').val().replace('/', '-').replace('/', '-');
	}
	else if(selectedDate == ""){
		var temp = new Date();
		selectedDate = temp.getDate()+'-'+(temp.getMonth()+1)+'-'+temp.getFullYear();
		$('#date_from').datepicker('setDate', temp);
		selectedDate = (temp.getDate()<10?("0"+temp.getDate()):temp.getDate())+'-'+
						(temp.getMonth()<9?("0"+(temp.getMonth()+1)):(temp.getMonth()+1))+'-'+
						temp.getFullYear();
		
		var tempForm = new Date();
		tempForm.setFullYear(temp.getFullYear(), temp.getMonth(), parseInt(temp.getDate())+2);
		$('#date_to').val((tempForm.getDate()<10?("0"+tempForm.getDate()):tempForm.getDate())+'/'+
				(tempForm.getMonth()<9?("0"+(tempForm.getMonth()+1)):(tempForm.getMonth()+1))+'/'+tempForm.getFullYear());
	}
	
	//$(window).unbind('resize', locateEvent);
	$('div.event').remove();
	
	$.ajax({
		url: "../ui/otAppCMB.jsp",
		async: false,
		data: 'dateFrom='+selectedDate+'&dateTo='+$('#date_to').val().replace('/', '-').replace('/', '-'),
		success: function(values){
			$('table#otApp').html(values);
			moveEventDIV();
		},//success
		error: function(jqXHR, textStatus, errorThrown) {
			alert('Error in ""');
		}
	});
}

$(document).ready(function() {
	$('#date_from').datepicker({
		dateFormat: 'dd/mm/yy',
		showOn: "button",
		buttonImage: "../images/calendar.jpg",
		buttonImageOnly: true,
		onSelect: function(dateText, inst) {
			$("#ui-datepicker-div").hide();
			var selectDate = new Date();

			selectDate.setFullYear(inst.selectedYear, inst.selectedMonth, parseInt(inst.selectedDay)+2);

			$('#date_to').val((selectDate.getDate()<10?("0"+selectDate.getDate()):selectDate.getDate())+'/'+
					(selectDate.getMonth()<9?("0"+(selectDate.getMonth()+1)):(selectDate.getMonth()+1))+'/'+selectDate.getFullYear());
		}
	});
	
	fetchOtApp();
	
	$('#requestBtn').click(function(){
		selectedDate = $('#date_from').val().replace('/', '-').replace('/', '-');
		fetchOtApp();
	});
});
</script>