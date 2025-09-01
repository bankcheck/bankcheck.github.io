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
<%@ page language="java" contentType="text/html; charset=big5"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	public String getCurDate() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(SYSDATE, 'DDMMYYYY') ");
		sqlStr.append("FROM DUAL ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject row = (ReportableListObject) record.get(0);
		return row.getValue(0);
	}
%>
<%
UserBean userBean = new UserBean(request);
String curDate = getCurDate();

boolean isDeptHead = request.getParameter("isDeptHead").equals("true");
String deptCode = "";
String staffID = "";
String deptHead = "";
String deptHeadCode = "";

if (userBean != null) {
	deptCode = userBean.getDeptCode();
	staffID = userBean.getStaffID();
	
	ArrayList result = DepartmentDB.getDeptHead(deptCode);
	if (result.size() > 0) {
		deptHeadCode = ((ReportableListObject)result.get(0)).getValue(0);
		deptHead = ((ReportableListObject)result.get(0)).getValue(1);
	}
}
%>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<style>
.ui-jqgrid tr.jqgrow td {
	height: 20px!Important;
	/*font-size:0.8em!Important;*/
}
.ui-jqgrid {	
	/*font-size:0.8em!Important;*/
}
.wrapper {
	position:absolute; 
	z-index:12;
}
.ui-jqgrid .ui-jqgrid-htable th {
	height: 15px!important;
}
element.style {
	height: 15px!important;
}
.ui-jqgrid .ui-jqgrid-htable th div {
	font-size:0.7em!Important;
}
.transparency {
	filter:alpha(opacity=90);
	-moz-opacity:0.90;
	opacity: 0.90;
}
#ui-datepicker-div {
	z-index:90;
}
#overlay {
	z-index:100;
}
</style>
<body>
	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="function.roster.edit" />
		<jsp:param name="accessControl" value="N"/>
		<jsp:param name="isHideTitle" value="Y"/>
	</jsp:include>
	
	<div id="overlay" class="ui-widget-overlay" style="display:none"></div>
	<div id="alertDialog" style="width:300px; height:auto; position:absolute; z-index:1005; display:none;"
		class="ui-dialog ui-widget ui-widget-content ui-corner-all">
		<div align="left" class = "ui-widget-header"><label class="text">Information</label></div>
		<div align="left"><label id="alertMsg" class="text"></label></div>
		<div>&nbsp;</div>
		<div align="right">
			<button id="closeAlert" class = "ui-button ui-widget ui-state-default ui-corner-all">
				<label class="text">Close</label>
			</button>
		</div>
	</div>
	<div id="confirmDialog" style="width:300px; height:auto; position:absolute; z-index:1002; display:none;"
		class="ui-dialog ui-widget ui-widget-content ui-corner-all">
		<div align="left" class = "ui-widget-header"><label class="text">Confirm</label></div>
		<div align="left"><label id="confirmMsg" class="text"></label></div>
		<div>&nbsp;</div>
		<div align="right">
			<button id="yesBtn" class = "ui-button ui-widget ui-state-default ui-corner-all">
				<label class="text">Yes</label>
			</button>
			<button id="noBtn" class = "ui-button ui-widget ui-state-default ui-corner-all">
				<label class="text">No</label>
			</button>
		</div>
	</div>
	
	<div style="position:absolute; z-index:20; cursor:pointer;"  
		id="menuBtn">
		<div style="width:700px; color:black" class="ui-widget-header transparency">
			<table style="width:100%">
				<tr>
					<td class="setConfig">
						<img src="../images/upbutton.png" style="width:13px"/> 
					</td>
					<td class="setConfig" style="width:340px">
						Dept: <span><b id="deptLabel"></b></span><span style="display:none" id="deptCodeLabel"></span>
					</td>
					<td class="setConfig">
						&nbsp;&nbsp;&nbsp;|&nbsp;
					</td>
					<td class="setConfig" style="width:130px">
						Date: <span><b id="dateLabel"></b></span>
					</td>
					<td class="setConfig">
						&nbsp;&nbsp;&nbsp;
					</td>
					<td style="width:230px"> 
						<button class="ui-button ui-widget ui-state-default ui-corner-all" 
								style="z-index:25; font-size:10px; font-weight:normal; padding-top:0px; height:15px;" 
								onclick="toggleLnDnOSummary()">
							Show/Hide Off-Duty, Leave and On-Duty
						</button>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div style="display:none; position:absolute; z-index:21; width:470px; height:130px;" id="menuDlg"
		class="ui-dialog ui-widget ui-widget-content ui-corner-all">
		<div align="left" class="ui-widget-header" style="width:468px">
			<b>Setting</b>
			<img src="../images/cross.jpg" 
				style="position:absolute; height:18px; cursor:pointer; left:453px" class="closeBtn"/>
		</div>
		<div>
			<table style="width:100%">
				<tr>
					<td>Date From: </td>
					<td>
						<input type="textfield" name="date_from" id="date_from" readonly="readonly" 
							class="datepickerfield" value="" maxlength="10" size="10" 
							onkeyup="validDate(this)" onblur="validDate(this)"/>
					</td>
				</tr>
				<tr>
					<td>Dept: </td>
					<td>
					<%
						if (isDeptHead) {
					%>
						<select id="deptList">
							<jsp:include page="../ui/deptCodeCMB.jsp">
								<jsp:param name="allowAll" value="Y"/>
								<jsp:param name="deptCode" 
									value="<%=deptCode %>"/>
							</jsp:include>
						</select>
					<%
						}
						else {
					%>
						<span id="deptDesc"><%=userBean.getDeptDesc() %></span>
					<%
						}
					%>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>
						<button class="ui-button ui-widget ui-state-default ui-corner-all" 
								onclick="changeDatenDept()">
							Submit
						</button>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="ptSumGridWrapper" class="wrapper">
		<table id="ptSumGrid">
		</table>
	</div>
	<div id="lndGridWrapper" class="wrapper">
		<table id="lndGrid">
		</table>
	</div>
	<div id="staffGridWrapper" class="wrapper">
		<table id="staffGrid">
		</table>
	</div>
	<div id="dutyGridWrapper" class="wrapper">
		<table id="dutyGrid">
		</table>
		<div id="dutyPager"></div>
	</div>
	<div id="offGridWrapper" class="wrapper">
		<table id="offGrid">
		</table>
	</div>
</body>
</html:html>

<script language="javascript">
var minusBottomGridHeight = 295;
var dutyGridHeight = $(window).height()-minusBottomGridHeight;
var staffGridHeight = $(window).height()-minusBottomGridHeight;
var lndGridHeight = $(window).height()-minusBottomGridHeight;
var offGridHeight = $(window).height()-minusBottomGridHeight;
var ptSumGridHeight = 205;

var dutyGridWidth = $(window).width()-731;
var ptSumGridWidth = $(window).width()-500;
var lndGridWidth = 265;
var staffGridWidth = 230;
var offGridWidth = 155;

var pTop = 224;
var ptSumGridLeft = 265;
var staffGridLeft = 265;
var lndGridLeft = 0;
var dutyGridLeft = 496;
var offGridLeft = 0;

var curDate = '<%=curDate.toString()%>';
var startDate = new Date();
var editLastValue = "";
var lastClickInput = "";
var startMonth, startDay, startYear;
var holiday = new Array();
var saturday = new Array();
var startDateStr, endDateStr;

var isDeptHead = '<%=isDeptHead%>';
var deptCode = '<%=deptCode%>';
var successList = new Array();
var deptHead = '<%=deptHead%>';

$(document).ready(function() {
	if (isDeptHead == "false") {
		minusBottomGridHeight = minusBottomGridHeight - ptSumGridHeight;
		pTop = 0;
		dutyGridLeft = dutyGridLeft - staffGridLeft;
		staffGridLeft = 0;
		dutyGridWidth = dutyGridWidth + offGridWidth;
	}
	
	getPublicHoliday();
	
	$('.setConfig').click(function() {
		$('#menuDlg').css('display', '');
	});
	
	$('.closeBtn').click(function() {
		var dlg = $(this).parent();
		while (dlg.parent()[0].tagName == 'DIV') {
			dlg = dlg.parent();
		}
		dlg.hide();
		$('input#date_from').val($('#dateLabel').html());
		$('#deptList option[value='+$('#deptCodeLabel').html()+']').attr('selected', true);
	});
	
	$('input#date_from').change(function() {
		$(this).val("21"+$(this).val().substring(2));
	});
	
	if (isDeptHead == "false") {
		$('#deptLabel').html($('#deptDesc').html());
		$('#deptCodeLabel').html(deptCode);
	}
	else {
		$('#deptLabel').html($('#deptList option:selected').text());
		$('#deptCodeLabel').html($('#deptList option:selected').val());
	}
	
	$(window).resize(function() {
		waitForFinalEvent(function(){
			gridResize();
		   }, 100, "resizeGrid");
	});
	
	$('button#closeAlert').click(function() {
		$('div#alertDialog').hide();
		$('div#overlay').hide();
		
		if (isDeptHead == "true") {
			if (successList.length > 0) {
				toggleConfirmDialog();
			}
		}
		else {
			if (deptHead.length > 0 && successList.length > 0) {
				toggleConfirmDialog();
			}
		}
	});
	
	$('button#yesBtn').click(function() {
		showLoadingBox('body', 100);
		$('div#confirmDialog').hide("normal", function() {
			//send email
			notification();
		});
	});
	
	$('button#noBtn').click(function() {
		$('div#confirmDialog').hide();
		$('div#overlay').hide();
		successList = new Array();
	});
});

function changeDatenDept() {
	if ($('#dutyGrid').find('.editable').length > 0) {
		var change = confirm("The data do not save. continue?");
		
		if (!change) {
			return;
		}
	}
	
	curDate = $('input#date_from').val().replace('/', '').replace('/', '');
	initStartDate();
	
	$('#dateLabel').html(startDate.getDate()+"/"+(startDate.getMonth()>8?(startDate.getMonth()+1):"0"+(startDate.getMonth()+1))+"/"+startDate.getFullYear());
	
	if (isDeptHead !== "false") {
		$('#deptLabel').html($('#deptList option:selected').text());
		$('#deptCodeLabel').html($('#deptList option:selected').val());
		deptCode = $('#deptList option:selected').val();
	}
	
	$('.closeBtn').trigger('click');
	
	$('#staffGrid').jqGrid('GridUnload');
	$('#dutyGrid').jqGrid('GridUnload');
  	$('#ptSumGrid').jqGrid('GridUnload');
  	$('#offGrid').jqGrid('GridUnload');
  	$('#lndGrid').jqGrid('GridUnload');
  	getPublicHoliday();
}

//get public holiday
function getPublicHoliday() {
	initStartDate();
	$('input#date_from').val(startDate.getDate()+"/"+(startDate.getMonth()>8?(startDate.getMonth()+1):"0"+(startDate.getMonth()+1))+"/"+startDate.getFullYear());
	$('#dateLabel').html(startDate.getDate()+"/"+(startDate.getMonth()>8?(startDate.getMonth()+1):"0"+(startDate.getMonth()+1))+"/"+startDate.getFullYear());
	
	startDateStr = startDate.getDate().toString()+
					(startDate.getMonth()<9?"0"+(startDate.getMonth()+1).toString():
											(startDate.getMonth()+1).toString())+
												startDate.getFullYear().toString();
	endDateStr = '20'+(startDate.getMonth()>10?"01":
					(startDate.getMonth()<8?"0"+(startDate.getMonth()+2).toString():
							(startDate.getMonth()+2).toString()))
							+(startDate.getMonth()>10?(startDate.getFullYear()+1).toString():
										startDate.getFullYear());
	//alert("startDateStr: "+startDateStr);
	//alert("endDateStr: "+endDateStr);
	$.ajax({
		async: false,
		cache: false,
		url: '../json/getPublicHoliday.jsp?callback=?',
		data: 'startDate='+startDateStr+
			  '&endDate='+endDateStr,
		dataType: "jsonp",
		success: function (data, textStatus, jqXHR) {
					holiday = new Array();
					saturday = new Array();
					$.each(data, function(i, v) {
						holiday[i] = v;
					});
					//$.dump(holiday)
					generateGrid();
				 },
		error: function(x, s, e) {
				alert("error in getPublicHoliday");
			   }
	});
}

function checkHolidayInGrid() {
	$.each(holiday, function(i, v) {
		$('#jqgh_dutyGrid_'+v).css('background-color', '#FF8585');
		$('#jqgh_ptSumGrid_'+v).css('background-color', '#FF8585');
	});
}

function checkSaturdayInGrid() {
	$.each(saturday, function(i, v) {
		$('td[aria-describedby=ptSumGrid_'+v+']').css('border-right-width', '3px');
		$('td[aria-describedby=dutyGrid_'+v+']').css('border-right-width', '3px');
	});
}

function highlightLeaveCell() {
	var $this = $('#dutyGrid'), ids = $this.jqGrid('getDataIDs'), i, l = ids.length;
	for (i = l-1; i >= 0; i--) {
	    var data = $this.jqGrid('getRowData', ids[i]);
	    
	    for (var j in data) {
	    	if (data[j] == 'CO' || data[j] == 'BL' || data[j] == 'EL' ||
	    		data[j] == 'AL' || data[j] == 'ML' || data[j] == 'NSL' ||
	    		data[j].substring(0, 1) == 'H') {
	    		$this.jqGrid('setCell', ids[i], j, '', {'background': 'yellow'});
	    	}	
	    }
	}
}

function initStartDate() {
	var year = curDate.substring(4);
	var month = curDate.substring(2, 4);
	var date = curDate.substring(0, 2);
	
	var setMonth = (parseInt(date, 10)<21?(parseInt(month, 10)-2):(parseInt(month, 10)-1));
	startDate.setFullYear(setMonth<0?(parseInt(year, 10)-1):parseInt(year, 10));
	//startDate.setFullYear(2012);
	//startDate.setMonth(10);
	startDate.setMonth(setMonth<0?11:setMonth);
	startDate.setDate(21);
	//alert("startDate: "+startDate.getDate()+startDate.getMonth()+startDate.getFullYear());
}

function gridResize() {
	//height
	$("#dutyGrid").setGridHeight($(window).height()-minusBottomGridHeight);
	$("#staffGrid").setGridHeight($(window).height()-minusBottomGridHeight);
	$("#lndGrid").setGridHeight($(window).height()-minusBottomGridHeight);
	$("#offGrid").setGridHeight($(window).height()-minusBottomGridHeight);
	//width
	if (isDeptHead == "false") {
		$("#dutyGrid").setGridWidth($(window).width() - staffGridWidth - 4);
	}
	else {
		if ($("#offGridWrapper").css('display') == 'none') {
			if ($("#lndGridWrapper").css('display') == 'none') {
				$("#dutyGrid").setGridWidth($(window).width() - staffGridWidth - 4);
				$("#ptSumGrid").setGridWidth($(window).width() - 3);
			}
			else {
				$("#dutyGrid").setGridWidth($(window).width() - dutyGridLeft - 3);
				$("#ptSumGrid").setGridWidth($(window).width() - ptSumGridLeft - 3);
			}
		}
		else {
			if ($("#lndGridWrapper").css('display') == 'none') {
				$("#dutyGrid").setGridWidth($(window).width() - lndGridWidth - 3);
				$("#ptSumGrid").setGridWidth($(window).width() - lndGridWidth - 3);
			}
			else {
				$("#dutyGrid").setGridWidth($(window).width() - offGridWidth - dutyGridLeft - 3);
				$("#ptSumGrid").setGridWidth($(window).width() - offGridWidth - ptSumGridLeft- 3);
			}
		}
	}
	
	//reset position
	setPosition();
}

function setPosition() {
	$('#ptSumGridWrapper').css('left', ptSumGridLeft);
	$('#lndGridWrapper').css('top', pTop)
						   .css('left', lndGridLeft);
	$('#staffGridWrapper').css('left', staffGridLeft)
						  .css('top', pTop);
	$('#dutyGridWrapper').css('top', pTop)
						 .css('left', dutyGridLeft);
	$('#offGridWrapper').css('top', pTop)
						.css('left', dutyGridLeft+$('#dutyGridWrapper').width()-1);
	
	$('#menuBtn').css('top', $(window).height()-$('#menuBtn').height()-2);
	$('#menuDlg').css('top', $(window).height()-$('#menuBtn').height()-10-$('#menuDlg').height());
}

function toggleOffSummary() {
	toggleGrid("#offGridWrapper");
	$('#menuDlg').hide();
}

function toggleLnDSummary() {
	if ($("#lndGridWrapper").css('display') == 'none') {
		ptSumGridLeft = 265;
		staffGridLeft = 265;
		dutyGridLeft = 496;
	}
	else {
		ptSumGridLeft = 0;
		staffGridLeft = 0;
		dutyGridLeft = 496-265;
	}
	
	toggleGrid("#lndGridWrapper");
	$('#menuDlg').hide();
}

function toggleLnDnOSummary() {
	$('.closeBtn').trigger('click');
	
	toggleOffSummary();
	toggleLnDSummary();
}

function toggleGrid(toggleTarget) {
	$(toggleTarget).toggle('fast', function() {
		gridResize();
	});
}

function syncRowSelection(rowid) {
	var selRow1 = $('#lndGrid').jqGrid('getGridParam','selrow');
	var selRow2 = $('#dutyGrid').jqGrid('getGridParam','selrow');
	var selRow3 = $('#staffGrid').jqGrid('getGridParam','selrow');
	var selRow4 = $('#offGrid').jqGrid('getGridParam','selrow');
	
	if (selRow1 != rowid) {
		$("#lndGrid").jqGrid('setSelection', rowid);
	}
	
	if (selRow2 != rowid) {
		$("#dutyGrid").jqGrid('setSelection', rowid);
	}
	
	if (selRow3 != rowid) {
		$("#staffGrid").jqGrid('setSelection', rowid);
	}
	
	if (selRow4 != rowid) {
		$("#offGrid").jqGrid('setSelection', rowid);
	}
}

function getDayOfWeek(day) {
	switch(day) {
		case 0:
			return 'S';
		case 1:
			return 'M';
		case 2:
			return 'T';
		case 3:
			return 'W';
		case 4:
			return 'T';
		case 5:
			return 'F';
		case 6:
			return 'S';
	}
}

function generateStaffGrid() {
	$("#staffGrid").jqGrid({
		url: "roster_staffCMB.jsp?deptCode="+deptCode+'&isDeptHead='+isDeptHead,
		datatype: "json",
		jsonReader: {
		    repeatitems: false
		},
		colNames: ['FTE', 'Post', 'Emp#', 'Names'], 
		colModel: [ 
		            {name: 'fte', index: 'fte', width: 25, frozen: true },
		            {name: 'post', index: 'post', width: 25, frozen: true },
		            {name: 'empNo', index: 'empNo', width: 30, frozen: true },
		            {name: 'names', index: 'names', width: 120, frozen: true }
		          ],
		rowNum:100, 
		width:staffGridWidth, 
		rowList:[100,200,300], 
		viewrecords: true, 
		shrinkToFit: false, 
		caption: "", 
		height: staffGridHeight,
		onSelectRow: function(rowid, status, e) {
			syncRowSelection(rowid);
		},
		loadComplete: function(data) {
			generateDutyGrid();
			if (isDeptHead == "true") {
				generateOffGrid();
				generateLnDGrid();
				generatePtSumGrid();
			}
			scrollEvent();
			gridResize();
			
			checkHolidayInGrid();
		},
		loadError: function(xhr, status, error) {
			alert('[generateStaffGrid]\nHTTP status code: ' + xhr.status + '\n' +
		              'textStatus: ' + status + '\n' +
		              'errorThrown: ' + error);
		},
		beforeProcessing: function(data, status, xhr) {
		},
		gridComplete: function() {
		}
	});
}

function saveDutyRecords() {
	var msg = "";
	var errorMsg = "";
	successList = new Array();
	
	$.each($('#dutyGrid').find('.data-changed'), 
		function(i, v) {
		var empNo = $('#staffGrid').jqGrid('getRowData', $(this).attr('id'))['empNo'];
		var staffRole = $('#staffGrid').jqGrid('getRowData', $(this).attr('id'))['post'];
		var staffName = $('#staffGrid').jqGrid('getRowData', $(this).attr('id'))['names'];
		
		$('#dutyGrid')
			.jqGrid('saveRow',
				$(this).attr('id'),
				{
					url: 'roster_saveData.jsp',
					aftersavefunc: function(rowid, response) {
						if ($.trim(response.responseText) == 'success') {
							msg = 'Save Successfully!';
							//$('#dutyGrid').trigger("reloadGrid");
							successList[successList.length] = 
											{
												empNo: empNo, 
												staffName: staffName
											};
						}
						else {
							errorMsg += '<br/>Error Occurred ('+empNo+')!<br/>'+response.responseText;
						}
					},
					errorfunc: function(rowid, response) {
						errorMsg += '<br/>Error Occurred ('+empNo+')!<br/>'+response.responseText;
					},
					restoreAfterError: false,
					extraparam: {
						startMonth: startMonth,
						startDay: startDay,
						startYear: startYear,
						isDeptHead: isDeptHead,
						staffRole: staffRole,
						empNo: empNo
					},
					mtype: "POST"
				});				
	});

	hideLoadingBox('body', 100);
	$('div#overlay').hide();
	
	//after all saving process
	if (errorMsg.length > 0) {
		showAlertMsg(errorMsg);
	}
	else {
		if (msg.length > 0) {
			$('#dutyGrid-save').hide();
			$('#dutyGrid-cancelall').hide();
			$('#dutyGrid-editall').show();
			$('#dutyGrid-confirm').show();
			
			showAlertMsg(msg);
			$('#dutyGrid').trigger("reloadGrid");
		  	$('#ptSumGrid').trigger("reloadGrid");
		  	$('#offGrid').trigger("reloadGrid");
		  	$('#lndGrid').trigger("reloadGrid");
		}
	}
}

function generateDutyGrid() {
	initStartDate();
	var colNames = new Array();
	var colModel = new Array();
	startMonth = startDate.getMonth();
	startDay = startDate.getDate();
	startYear = startDate.getFullYear();
	
	colNames[0] = 'Emp#';
	colModel[0] = {name: 'empNo', index: 'empNo', width: 30, hidden: true };
	var i = 1;
	var hIndex = 0;
	do {
		var dayName = getDayOfWeek(startDate.getDay());

		if (holiday.length > 0 && holiday.length > hIndex) {
			if (holiday[hIndex] == 
				(startDate.getDate()>9?startDate.getDate().toString():"0"+startDate.getDate().toString())+
				(startDate.getMonth()>8?(startDate.getMonth()+1):"0"+(startDate.getMonth()+1))+
				startDate.getFullYear().toString()) {
				holiday[hIndex] = 'day'+i;
				hIndex++;
			}
		}
		
		if (startDate.getDay() == 6) {
			saturday[saturday.length] = 'day'+i;
		}
		
		colNames[i] = startDate.getDate()+'/'+dayName;
		colModel[i] = {name: 'day'+i, index: 'day'+i, width: 25, editable:true };
		startDate.setDate(startDate.getDate()+1);
		i++;
	}while(startDate.getDate() != 21);
		
	colNames[i] = "Hours";
	colModel[i] = {name: 'hours', index: 'hours', width: 20 };
	
	$("#dutyGrid").jqGrid({
		url: "rosterCMB.jsp?row="+
				$("#staffGrid").getGridParam("records")+
				'&startDate='+startDateStr+
				'&endDate='+endDateStr+
				'&deptCode='+deptCode+
				'&isDeptHead='+isDeptHead,
		datatype: "json",
		jsonReader: {
		    repeatitems: false
		},
		colNames: colNames, 
		colModel: colModel,
		rowNum:100, 
		width: dutyGridWidth, 
		rowList:[], 
		pager: '#dutyPager',
		pgbuttons: false,
		pgtext: null,
		viewrecords: true, 
		shrinkToFit: false, 
		caption: "", 
		//cellEdit: true,
		height: dutyGridHeight,
		onSelectRow: function(rowid, status, e) {
			syncRowSelection(rowid);
		},
		loadComplete: function(data) {
		},
		loadError: function(xhr, status, error) {
			alert('[generateDutyGrid]\nHTTP status code: ' + xhr.status + '\n' +
		              'textStatus: ' + status + '\n' +
		              'errorThrown: ' + error);
		},
		beforeProcessing: function(data, status, xhr) {
		},
		gridComplete: function() {
			highlightLeaveCell();
			$('#dutyGrid-save').hide();
			$('#dutyGrid-cancelall').hide();
		}
	});
	
	$("#dutyGrid").jqGrid('navGrid',"#dutyPager",{edit:false,add:false,del:false,search:false,refresh:false});
	$("#dutyGrid").jqGrid('inlineNav',"#dutyPager", {edit:false,add:false,del:false,save:false,cancel:false});
	$("#dutyGrid").jqGrid('navButtonAdd',"#dutyPager",
						{ 
						  	caption:"Save", 
						 	onClickButton: 
						 		function() {
						 			showLoadingBox('body', 100);
									$('div#overlay').show();
									
									setTimeout(
										function() {
											saveDutyRecords();
										}, 3000);
							  	}, 
						  	position: "last", 
						  	title:"", 
						  	cursor: "pointer",
						  	buttonicon:"ui-icon-disk",
						  	id: "dutyGrid-save"
						});
	$("#dutyGrid").jqGrid('navButtonAdd',"#dutyPager",
						{ 
						  	caption:"Edit", 
						 	onClickButton: 
						 		function() {
						 			$('#dutyGrid-save').show();
						 			$('#dutyGrid-cancelall').show();
						 			$('#dutyGrid-editall').hide();
						 			$('#dutyGrid-confirm').hide();
						 			
								  	var $this = $('#dutyGrid'), 
								  		ids = $this.jqGrid('getDataIDs'), 
								  		i, l = ids.length;
									for (i = l-1; i >= 0; i--) {
									    $this.jqGrid('editRow', ids[i], true);
									}
									$this.trigger('scroll');
									$this.jqGrid('resetSelection');
									
									//input change event
									editChangeEvent();
							  	}, 
						  	position: "last", 
						  	title:"", 
						  	cursor: "pointer",
						  	buttonicon:"ui-icon-pencil",
						  	id: "dutyGrid-editall"
						});
	$("#dutyGrid").jqGrid('navButtonAdd',"#dutyPager",
						{
							caption:"Cancel",
							onClickButton: 
						 		function() {
									$('#dutyGrid-save').hide();
						 			$('#dutyGrid-cancelall').hide();
						 			$('#dutyGrid-editall').show();
						 			$('#dutyGrid-confirm').show();
						 			
								  	$('#dutyGrid').trigger("reloadGrid");
								  	$('#ptSumGrid').trigger("reloadGrid");
								  	$('#offGrid').trigger("reloadGrid");
								  	$('#lndGrid').trigger("reloadGrid");
							  	}, 
						  	position: "last", 
						  	title:"", 
						  	cursor: "pointer",
						  	buttonicon:"ui-icon-cancel",
						  	id: "dutyGrid-cancelall"
						});
	
	if (isDeptHead == "true") {
		$("#dutyGrid").jqGrid('navButtonAdd',"#dutyPager",
				{
					caption:"Confirm",
					onClickButton: 
				 		function() {
							showLoadingBox('body', 100);
							$('div#overlay').show();
							
							$.ajax({
								async: true,
								cache: false,
								type: "POST",
								url: 'roster_confirm.jsp',
								data: 'startYear='+startYear+'&startMonth='+startMonth+
										'&startDay='+startDay+'&deptCode='+deptCode,
								success: function (data, textStatus, jqXHR) {
											hideLoadingBox('body', 100);
											$('div#overlay').hide();
											
											if ($.trim(data) == 'fail') {
												showAlertMsg('Fail to confirm!');
											}
											else {
												showAlertMsg('Confirm Successfully!');
											}
										 },
								error: function(x, s, e) {
											alert("error in confirm");
											hideLoadingBox('body', 100);
											$('div#overlay').hide();
									   }
							});
					  	}, 
				  	position: "last", 
				  	title:"", 
				  	cursor: "pointer",
				  	id: "dutyGrid-confirm"
				});
	}
}

function generatePtSumGrid() {
	initStartDate();
	var colNames = new Array();
	var colModel = new Array();
	
	colNames[0] = 'Type';
	colNames[1] = 'Time';
	colModel[0] = {name: 'type', index: 'type', width: 110, frozen: true };
	colModel[1] = {name: 'time', index: 'time', width: 111, frozen: true };
	var i = 2;
	do {
		var dayName = getDayOfWeek(startDate.getDay());

		colNames[i] = startDate.getDate()+'/'+dayName;
		colModel[i] = {name: 'day'+(i-1), index: 'day'+(i-1), width: 25 };
		startDate.setDate(startDate.getDate()+1);
		i++;
	}while(startDate.getDate() != 21);
	
	$("#ptSumGrid").jqGrid({
		url: "roster_dutySumCMB.jsp?"+
				'startDate='+startDateStr+
				'&endDate='+endDateStr+
				'&deptCode='+deptCode,
		datatype: "json",
		jsonReader: {
		    repeatitems: false
		},
		colNames: colNames, 
		colModel: colModel,
		rowNum:10, 
		width: ptSumGridWidth, 
		rowList:[10,20,30], 
		viewrecords: true, 
		shrinkToFit: false, 
		caption: "",
		sortable: false,
		height: ptSumGridHeight,
		loadComplete: function(data) {
		},
		loadError: function(xhr, status, error) {
			alert('[generatePtSumGrid]\nHTTP status code: ' + xhr.status + '\n' +
		              'textStatus: ' + status + '\n' +
		              'errorThrown: ' + error);
		},
		beforeProcessing: function(data, status, xhr) {
		},
		gridComplete: function() {
			checkSaturdayInGrid();
		}
	});
	
	$("#ptSumGrid").jqGrid('setFrozenColumns');
}

function generateOffGrid() {
	$("#offGrid").jqGrid({
		url: "roster_offSumCMB.jsp?row="+$("#staffGrid").getGridParam("records")+
				'&startDate='+startDateStr+
				'&endDate='+endDateStr+
				'&deptCode='+deptCode,
		datatype: "json",
		jsonReader: {
		    repeatitems: false
		},
		colNames: ['Emp#', 'Sat off', 'Sun off', 'Total off', 'Wk end N'
		          ], 
		colModel: [ 
					{name: 'empNo', index: 'empNo', width: 30, hidden: true },
		            {name: 'satOff', index: 'satOff', width: 30 },
		            {name: 'sunOff', index: 'sunOff', width: 30 },
		            {name: 'totalOff', index: 'totalOff', width: 30 },
		            {name: 'WkEndN', index: 'WkEndN', width: 30 }
		          ],
		rowNum:100, 
		width: offGridWidth, 
		rowList:[100,200,300], 
		viewrecords: true, 
		shrinkToFit: false, 
		caption: "", 
		height: offGridHeight,
		onSelectRow: function(rowid, status, e) {
			syncRowSelection(rowid);
		},
		loadComplete: function(data) {
		},
		loadError: function(xhr, status, error) {
			alert('[generateOffGrid]\nHTTP status code: ' + xhr.status + '\n' +
		              'textStatus: ' + status + '\n' +
		              'errorThrown: ' + error);
		},
		beforeProcessing: function(data, status, xhr) {
		},
		gridComplete: function() {
		}
	});
}

function generateLnDGrid() {
	$("#lndGrid").jqGrid({
		url: "roster_leaveAndDutySumCMB.jsp?row="+$("#staffGrid").getGridParam("records")+
					'&startDate='+startDateStr+
					'&endDate='+endDateStr+
					'&deptCode='+deptCode,
		datatype: "json",
		jsonReader: {
		    repeatitems: false
		},
		colNames: ['Emp#', 'H*', 'AL/ML', 'EL', 'BL', 'CO', 'H*/AL/EL/BL/CO/VL/ML', 
		           'A', 'P', 'N', 'Hours'], 
		colModel: [ 
					{name: 'empNo', index: 'empNo', width: 30, hidden: true },
		            {name: 'h', index: 'h', width: 20 },
		            {name: 'alml', index: 'alml', width: 20 },
		            {name: 'el', index: 'el', width: 20 },
		            {name: 'bl', index: 'bl', width: 20 },
		            {name: 'co', index: 'co', width: 20 },
		            {name: 'all', index: 'all', width: 20 },
		            {name: 'a', index: 'a', width: 20 },
		            {name: 'p', index: 'p', width: 20 },
		            {name: 'n', index: 'n', width: 20 },
		            {name: 'hours', index: 'hours', width: 20 }
		          ],
		rowNum:100, 
		width:lndGridWidth, 
		rowList:[100,200,300], 
		viewrecords: true, 
		shrinkToFit: false, 
		caption: "", 
		height: lndGridHeight,
		onSelectRow: function(rowid, status, e) {
			syncRowSelection(rowid);
		},
		loadComplete: function(data) {
		},
		loadError: function(xhr, status, error) {
			alert('[generateLnDGrid]\nHTTP status code: ' + xhr.status + '\n' +
		              'textStatus: ' + status + '\n' +
		              'errorThrown: ' + error);
		},
		beforeProcessing: function(data, status, xhr) {
		},
		gridComplete: function() {
			syncHours();
		}
	}); 
}

function generateGrid() {
	generateStaffGrid();
}

function syncHours() {
	var $this = $('#lndGrid'), ids = $this.jqGrid('getDataIDs'), i, l = ids.length;
	for (i = l-1; i >= 0; i--) {
	    var data = $this.jqGrid('getRowData', ids[i]);
	    
	    $('#dutyGrid').jqGrid('setCell', ids[i], 'hours', data['hours']); 
	}
}

function inputClickEvent() {
	$("#dutyGrid").find('input.editable').unbind('click');
	$("#dutyGrid").find('input.editable').focus(function() {
		if (lastClickInput != $(this).attr('id')) {
			lastClickInput = $(this).attr('id');
			editLastValue = $(this).val();
		}
	});
}

function editChangeEvent() {
	inputClickEvent();
	
	$("#dutyGrid").find('input.editable').unbind('change');
	$("#dutyGrid").find('input.editable').change(function() {
		var newVal = $(this).val();
		var editStaff = $(this).parent().parent().find('td:first').html();
		var rowid = $(this).attr('id').split('_')[0];
		var day = $(this).attr('id').split('_')[1];
		
		var staffData = $("#staffGrid").jqGrid('getRowData', rowid);
		var fte = staffData['fte'];
		var post = staffData['post'];
		
		$(this).parent().parent().addClass('data-changed');
		
		if (fte != 'CA') {
			updateOffGrid(rowid, editStaff, newVal, day.substring(3));
		}
		updateLnDGrid(rowid, editStaff, newVal, fte);
		updatePtSumGrid(post, day, newVal);
	});
}

function updatePtSumGrid(post, day, value) {
	var ptSumData;
	
	if (editLastValue != 'AL' && editLastValue.indexOf('A/V') < 0 && 
			editLastValue != 'NPL' && editLastValue.indexOf('NuOR') < 0) {
		if (post == 'HCA') {
			if (editLastValue.substring(0, 1) == 'A') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 1);
				ptSumData[day] = parseInt(ptSumData[day], 10)-1;
				 $("#ptSumGrid").jqGrid('setRowData', 1, ptSumData, null);
			}
			if (editLastValue == 'P') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 2);
				ptSumData[day] = parseInt(ptSumData[day], 10)-1;
				$("#ptSumGrid").jqGrid('setRowData', 2, ptSumData, null);
			}
			if (editLastValue.substring(editLastValue.length-1, editLastValue.length) == 'N') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 3);
				ptSumData[day] = parseInt(ptSumData[day], 10)-1;
				$("#ptSumGrid").jqGrid('setRowData', 3, ptSumData, null);
			}
		}
		else if (post == 'SRN') {
			if (editLastValue.substring(0, 1) == 'A') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 4);
				ptSumData[day] = parseInt(ptSumData[day], 10)-1;
				$("#ptSumGrid").jqGrid('setRowData', 4, ptSumData, null);
				
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 7);
				ptSumData[day] = parseInt(ptSumData[day], 10)-1;
				$("#ptSumGrid").jqGrid('setRowData', 7, ptSumData, null);
			}
			if (editLastValue.substring(0, 1) == 'P') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 5);
				ptSumData[day] = parseInt(ptSumData[day], 10)-1;
				$("#ptSumGrid").jqGrid('setRowData', 5, ptSumData, null);
				
				if (editLastValue.indexOf('PDM') < 0) {
					ptSumData = $("#ptSumGrid").jqGrid('getRowData', 8);
					ptSumData[day] = parseInt(ptSumData[day], 10)-1;
					$("#ptSumGrid").jqGrid('setRowData', 8, ptSumData, null);
				}
			}
			if (editLastValue.indexOf('N') > -1) {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 6);
				ptSumData[day] = parseInt(ptSumData[day], 10)-1;
				$("#ptSumGrid").jqGrid('setRowData', 6, ptSumData, null);
				
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 9);
				ptSumData[day] = parseInt(ptSumData[day], 10)-1;
				$("#ptSumGrid").jqGrid('setRowData', 9, ptSumData, null);
			}
		}
		else if (post == 'RN') {
			if (editLastValue.substring(0, 1) == 'A') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 7);
				ptSumData[day] = parseInt(ptSumData[day], 10)-1;
				$("#ptSumGrid").jqGrid('setRowData', 7, ptSumData, null);
			}
			if (editLastValue.substring(0, 1) == 'P' && 
					editLastValue.indexOf('PDM') < 0) {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 8);
				ptSumData[day] = parseInt(ptSumData[day], 10)-1;
				$("#ptSumGrid").jqGrid('setRowData', 8, ptSumData, null);
			}
			if (editLastValue.indexOf('N') > -1) {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 9);
				ptSumData[day] = parseInt(ptSumData[day], 10)-1;
				$("#ptSumGrid").jqGrid('setRowData', 9, ptSumData, null);
			}
		}
	}
	
	if (value != 'AL' && value.indexOf('A/V') < 0 && value != 'NPL' && 
			value.indexOf('NuOR') < 0) {
		if (post == 'HCA') {
			if (value.substring(0, 1) == 'A') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 1);
				ptSumData[day] = parseInt(ptSumData[day], 10)+1;
				$("#ptSumGrid").jqGrid('setRowData', 1, ptSumData, null);
			}
			if (value == 'P') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 2);
				ptSumData[day] = parseInt(ptSumData[day], 10)+1;
				$("#ptSumGrid").jqGrid('setRowData', 2, ptSumData, null);
			}
			if (value.substring(value.length-1, value.length) == 'N') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 3);
				ptSumData[day] = parseInt(ptSumData[day], 10)+1;
				$("#ptSumGrid").jqGrid('setRowData', 3, ptSumData, null);
			}
		}
		else if (post == 'SRN') {
			if (value.substring(0, 1) == 'A') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 4);
				ptSumData[day] = parseInt(ptSumData[day], 10)+1;
				$("#ptSumGrid").jqGrid('setRowData', 4, ptSumData, null);
				
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 7);
				ptSumData[day] = parseInt(ptSumData[day], 10)+1;
				$("#ptSumGrid").jqGrid('setRowData', 7, ptSumData, null);
			}
			if (value.substring(0, 1) == 'P') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 5);
				ptSumData[day] = parseInt(ptSumData[day], 10)+1;
				$("#ptSumGrid").jqGrid('setRowData', 5, ptSumData, null);
				
				if (value.indexOf('PDM') < 0) {
					ptSumData = $("#ptSumGrid").jqGrid('getRowData', 8);
					ptSumData[day] = parseInt(ptSumData[day], 10)+1;
					$("#ptSumGrid").jqGrid('setRowData', 8, ptSumData, null);
				}
			}
			if (value.indexOf('N') > -1) {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 6);
				ptSumData[day] = parseInt(ptSumData[day], 10)+1;
				$("#ptSumGrid").jqGrid('setRowData', 6, ptSumData, null);
				
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 9);
				ptSumData[day] = parseInt(ptSumData[day], 10)+1;
				$("#ptSumGrid").jqGrid('setRowData', 9, ptSumData, null);
			}
		}
		else if (post == 'RN') {
			if (value.substring(0, 1) == 'A') {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 7);
				ptSumData[day] = parseInt(ptSumData[day], 10)+1;
				$("#ptSumGrid").jqGrid('setRowData', 7, ptSumData, null);
			}
			if (value.substring(0, 1) == 'P' && value.indexOf('PDM') < 0) {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 8);
				ptSumData[day] = parseInt(ptSumData[day], 10)+1;
				$("#ptSumGrid").jqGrid('setRowData', 8, ptSumData, null);
			}
			if (value.indexOf('N') > -1) {
				ptSumData = $("#ptSumGrid").jqGrid('getRowData', 9);
				ptSumData[day] = parseInt(ptSumData[day], 10)+1;
				$("#ptSumGrid").jqGrid('setRowData', 9, ptSumData, null);
			}
		}
	}
}


function updateLnDGrid(rowid, staffID, value, fte) {
	var lndData = $("#lndGrid").jqGrid('getRowData', rowid);
	
	if (staffID == lndData['empNo']) {
		var oldFirstCh = editLastValue.substring(0, 1);
		var newFirstCh = value.substring(0, 1);
		
		if (editLastValue.indexOf('A/V') < 0 && 
				editLastValue.indexOf('NuOR') < 0) {
			if (fte != 'CA') {
				if (oldFirstCh == "H") {
					lndData['h'] = parseInt(lndData['h'], 10)-1;
					lndData['all'] = parseInt(lndData['all'], 10)-1;
					lndData['hours'] = parseInt(lndData['hours'], 10) - 8;
				}
				if (editLastValue == 'AL' || editLastValue == 'ML' ||
					editLastValue == 'NSL') {
					lndData['alml'] = parseInt(lndData['alml'], 10)-1;
					lndData['all'] = parseInt(lndData['all'], 10)-1;
					lndData['hours'] = parseInt(lndData['hours'], 10) - 8;
				}
				if (editLastValue == 'EL') {
					lndData['el'] = parseInt(lndData['el'], 10)-1;
					lndData['all'] = parseInt(lndData['all'], 10)-1;
					lndData['hours'] = parseInt(lndData['hours'], 10) - 8;
				}
				if (editLastValue == 'BL') {
					lndData['bl'] = parseInt(lndData['bl'], 10)-1;
					lndData['all'] = parseInt(lndData['all'], 10)-1;
					lndData['hours'] = parseInt(lndData['hours'], 10) - 8;
				}
				if (editLastValue == 'CO') {
					lndData['co'] = parseInt(lndData['co'], 10)-1;
					lndData['all'] = parseInt(lndData['all'], 10)-1;
					lndData['hours'] = parseInt(lndData['hours'], 10) - 8;
				}
			}
			if (editLastValue.indexOf('N') > -1) {
				lndData['n'] = parseInt(lndData['n'], 10)-1;
				lndData['hours'] = parseInt(lndData['hours'], 10) - 8;
			}
			if (oldFirstCh == 'P') {
				lndData['p'] = parseInt(lndData['p'], 10)-1;
				lndData['hours'] = parseInt(lndData['hours'], 10) - 8;
			}
			if (oldFirstCh == 'A' && editLastValue != 'AL') {
				lndData['a'] = parseInt(lndData['a'], 10)-1;
				lndData['hours'] = parseInt(lndData['hours'], 10) - 8;
			}
		}
		
		if (value.indexOf('A/V') < 0 && value.indexOf('NuOR') < 0) {
			if (fte != 'CA') {
				if (newFirstCh == "H") {
					lndData['h'] = parseInt(lndData['h'], 10)+1;
					lndData['all'] = parseInt(lndData['all'], 10)+1;
					lndData['hours'] = parseInt(lndData['hours'], 10) + 8;
				}
				if (value == 'AL' || value == 'ML' || value == 'NSL') {
					lndData['alml'] = parseInt(lndData['alml'], 10)+1;
					lndData['all'] = parseInt(lndData['all'], 10)+1;
					lndData['hours'] = parseInt(lndData['hours'], 10) + 8;
				}
				if (value == 'EL') {
					lndData['el'] = parseInt(lndData['el'], 10)+1;
					lndData['all'] = parseInt(lndData['all'], 10)+1;
					lndData['hours'] = parseInt(lndData['hours'], 10) + 8;
				}
				if (value == 'BL') {
					lndData['bl'] = parseInt(lndData['bl'], 10)+1;
					lndData['all'] = parseInt(lndData['all'], 10)+1;
					lndData['hours'] = parseInt(lndData['hours'], 10) + 8;
				}
				if (value == 'CO') {
					lndData['co'] = parseInt(lndData['co'], 10)+1;
					lndData['all'] = parseInt(lndData['all'], 10)+1;
					lndData['hours'] = parseInt(lndData['hours'], 10) + 8;
				}
			}
			if (value.indexOf('N') > -1) {
				lndData['n'] = parseInt(lndData['n'], 10)+1;
				lndData['hours'] = parseInt(lndData['hours'], 10) + 8;
			}
			if (newFirstCh == 'P') {
				lndData['p'] = parseInt(lndData['p'], 10)+1;
				lndData['hours'] = parseInt(lndData['hours'], 10) + 8;
			}
			if (newFirstCh == 'A' && value != 'AL') {
				lndData['a'] = parseInt(lndData['a'], 10)+1;
				lndData['hours'] = parseInt(lndData['hours'], 10) + 8;
			}
		}
		
		$("#lndGrid").jqGrid('setRowData', rowid, lndData, null);
		$('#dutyGrid').jqGrid('setCell', rowid, 'hours', lndData['hours']); 
	}
}

function updateOffGrid(rowid, staffID, value, day) {
	initStartDate();
	var offData = $("#offGrid").jqGrid('getRowData', rowid);
	startDate.setDate(startDate.getDate()+parseInt(day, 10)-1);
	
	//check it is the same row
	if (staffID == offData['empNo']) {
		var lastCh = editLastValue.substring(editLastValue.length-1, editLastValue.length);
		//total
		if (startDate.getDay() == 0 || startDate.getDay() == 6) {
			if (editLastValue == "/") {
				offData['totalOff'] = parseInt(offData['totalOff'], 10)-1;
			}
			if (value == "/") {
				offData['totalOff'] = parseInt(offData['totalOff'], 10)+1;
			}
		}
		//sun
		if (startDate.getDay() == 0) {
			if (editLastValue == "/") {
				offData['sunOff'] = parseInt(offData['sunOff'], 10)-1;
			}
			if (lastCh == 'N') {
				offData['WkEndN'] = parseInt(offData['WkEndN'], 10)-1;
			}
			
			if (value == "/") {
				offData['sunOff'] = parseInt(offData['sunOff'], 10)+1;
			}
			if (value.substring(value.length-1, value.length) == 'N') {
				offData['WkEndN'] = parseInt(offData['WkEndN'], 10)+1;
			}
		}
		//sat
		if (startDate.getDay() == 6) {
			if (editLastValue == "/") {
				offData['satOff'] = parseInt(offData['satOff'], 10)-1;
			}
			if (lastCh == 'N') {
				offData['WkEndN'] = parseInt(offData['WkEndN'], 10)-1;
			}
			
			if (value == "/") {
				offData['satOff'] = parseInt(offData['satOff'], 10)+1;
			}
			if (value.substring(value.length-1, value.length) == 'N') {
				offData['WkEndN'] = parseInt(offData['WkEndN'], 10)+1;
			}
		}
		
		$("#offGrid").jqGrid('setRowData', rowid, offData, null);
	}
}

function scrollEvent() {
	$("#lndGrid").closest(".ui-jqgrid-bdiv").scroll(function(e) {
		$("#dutyGrid").closest(".ui-jqgrid-bdiv").scrollTop($("#lndGrid").closest(".ui-jqgrid-bdiv").scrollTop());
		$("#offGrid").closest(".ui-jqgrid-bdiv").scrollTop($("#lndGrid").closest(".ui-jqgrid-bdiv").scrollTop());
		$("#staffGrid").closest(".ui-jqgrid-bdiv").scrollTop($("#lndGrid").closest(".ui-jqgrid-bdiv").scrollTop());
	});
	
	$("#dutyGrid").closest(".ui-jqgrid-bdiv").scroll(function(e) {
		$("#lndGrid").closest(".ui-jqgrid-bdiv").scrollTop($("#dutyGrid").closest(".ui-jqgrid-bdiv").scrollTop());
		$("#offGrid").closest(".ui-jqgrid-bdiv").scrollTop($("#dutyGrid").closest(".ui-jqgrid-bdiv").scrollTop());
		$("#ptSumGrid").closest(".ui-jqgrid-bdiv").scrollLeft($("#dutyGrid").closest(".ui-jqgrid-bdiv").scrollLeft());
		$("#staffGrid").closest(".ui-jqgrid-bdiv").scrollTop($("#dutyGrid").closest(".ui-jqgrid-bdiv").scrollTop());
	});
	
	$("#offGrid").closest(".ui-jqgrid-bdiv").scroll(function(e) {
		$("#lndGrid").closest(".ui-jqgrid-bdiv").scrollTop($("#offGrid").closest(".ui-jqgrid-bdiv").scrollTop());
		$("#dutyGrid").closest(".ui-jqgrid-bdiv").scrollTop($("#offGrid").closest(".ui-jqgrid-bdiv").scrollTop());
		$("#staffGrid").closest(".ui-jqgrid-bdiv").scrollTop($("#offGrid").closest(".ui-jqgrid-bdiv").scrollTop());
	});
	
	$("#staffGrid").closest(".ui-jqgrid-bdiv").scroll(function(e) {
		$("#lndGrid").closest(".ui-jqgrid-bdiv").scrollTop($("#staffGrid").closest(".ui-jqgrid-bdiv").scrollTop());
		$("#dutyGrid").closest(".ui-jqgrid-bdiv").scrollTop($("#staffGrid").closest(".ui-jqgrid-bdiv").scrollTop());
		$("#offFrid").closest(".ui-jqgrid-bdiv").scrollTop($("#staffGrid").closest(".ui-jqgrid-bdiv").scrollTop());
	});
	
	$("#ptSumGrid").closest(".ui-jqgrid-bdiv").scroll(function(e) {
		$("#dutyGrid").closest(".ui-jqgrid-bdiv").scrollLeft($("#ptSumGrid").closest(".ui-jqgrid-bdiv").scrollLeft());
	});
}

function showAlertMsg(msg) {
	$('label#alertMsg').html(msg);
	$('div#alertDialog').css('top', $(window).height()/2 - $('div#alertDialog').height()/2 + $(document).scrollTop())
						.css('left', $(window).width()/2 - $('div#alertDialog').width()/2);
	$('div#overlay').css('height', $(document).height());
	$('div#overlay').css('width', $(document).width());
	$('div#alertDialog').show();
	$('div#overlay').show();
}


function toggleConfirmDialog() {
	if (isDeptHead == "true") {
		var content = '';
		content += "Do you want to notify the changes to the following staff(s)?<br/>";
		
		if (successList.length > 0) {
			$.each(successList, function(i, v) {
				content += v.empNo+': '+v.staffName+'<br/>';
			});
		}
		
		$('label#confirmMsg').html(content);
	}
	else {
		$('label#confirmMsg').html("Do you want to notify "+'<%=deptHead%>'+" about the changes?");
	}
	
	$('div#confirmDialog').css('top', $(window).height()/2 - $('div#confirmDialog').height()/2 + $(document).scrollTop())
						.css('left', $(window).width()/2 - $('div#confirmDialog').width()/2);
	$('div#overlay').css('height', $(document).height());
	$('div#overlay').css('width', $(document).width());
	$('div#confirmDialog').show();
	$('div#overlay').show();
}

function notification() {
	var recvStaff = "";
	if (isDeptHead == "true") {
		$.each(successList, function(i, v) {
			recvStaff += v.empNo+"_";
		});
	}
	else {
		recvStaff += '<%=deptHeadCode%>';
	}
	
	$.ajax({
		async: true,
		cache: false,
		type: "POST",
		url: 'roster_notify_changes.jsp',
		data: 'recvStaff='+recvStaff+'&isDeptHead='+isDeptHead+
				'&startYear='+startYear+'&startMonth='+startMonth+
				'&startDay='+startDay,
		success: function (data, textStatus, jqXHR) {
					$('div#overlay').hide();
					successList = new Array();
					showAlertMsg(data);
					hideLoadingBox('body', 100);
				 },
		error: function(x, s, e) {
					alert("error in notification");
					$('div#overlay').hide();
			   }
	});
}

var waitForFinalEvent = (function () {
	  var timers = {};
	  return function (callback, ms, uniqueId) {
	    if (!uniqueId) {
	      uniqueId = "Don't call this twice without a uniqueId";
	    }
	    if (timers[uniqueId]) {
	      clearTimeout (timers[uniqueId]);
	    }
	    timers[uniqueId] = setTimeout(callback, ms);
	  };
	})();
</script>