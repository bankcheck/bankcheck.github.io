<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%
String testType = request.getParameter("testType");
String cntlNum = request.getParameter("cntlNum");
String machno = request.getParameter("machno");
String intTcode = request.getParameter("intTcode");
String frDate = request.getParameter("frDate");
String toDate = request.getParameter("toDate");
String user = request.getParameter("user");

String cntlName = null;
String lotNum = null;
String testCode = null;
String testName = null;
String testTypeDesc = null;
String instrument = LabDB.getInstrumentName(testType, machno);
String rangeHigh = null;
String rangeLow = null;
String givenMean = null;
String givenSD = null;
String LjMax = null;
String LjMin = null;

ReportableListObject cntl = LabDB.getControlDetail(testType, cntlNum, machno, intTcode);

if (cntl != null) {
	cntlName = cntl.getValue(0);
	lotNum = cntl.getValue(1);
	testCode = cntl.getValue(2);
	testName = cntl.getValue(3);
	rangeHigh = LabDB.addLeadingZero(cntl.getValue(4));
	rangeLow = LabDB.addLeadingZero(cntl.getValue(5));
	testTypeDesc = cntl.getValue(7);
	givenMean = LabDB.addLeadingZero(cntl.getValue(8));
	givenSD = LabDB.addLeadingZero(cntl.getValue(9));
	LjMax = cntl.getValue(10);
	LjMin = cntl.getValue(11);
}

ArrayList<ReportableListObject> data = LabDB.getSingleQcData(testType, cntlNum, machno, intTcode, frDate, toDate);

JSONArray labels = new JSONArray();
JSONArray fullData = new JSONArray();
JSONArray rawData = new JSONArray();
JSONArray status = new JSONArray();
JSONArray reason = new JSONArray();
JSONArray rejAccBy = new JSONArray();
JSONArray testDate = new JSONArray();
JSONArray testTime = new JSONArray();
JSONArray key = new JSONArray();

for (int i = 0; i < data.size(); i++) {
	ReportableListObject row = (ReportableListObject)data.get(i);
	labels.add(row.getValue(0));
	
	String txtResult = row.getValue(1);
	rawData.add(txtResult);
	
	double result = LabDB.convertQcResult(txtResult);	
	fullData.add(result);	
	
	status.add(row.getValue(2));
	reason.add(row.getValue(3));
	rejAccBy.add(row.getValue(4));
	testDate.add(row.getValue(5));
	testTime.add(row.getValue(6));
	key.add(row.getValue(7));
}

Date now = new java.util.Date();
java.text.SimpleDateFormat sdfd = new java.text.SimpleDateFormat("dd/MM/yyyy");
String currentDate = sdfd.format(now);
java.text.SimpleDateFormat sdft = new java.text.SimpleDateFormat("HH:mm");
String currentTime = sdft.format(now);
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<jsp:include page="../common/header.jsp"/> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../js/chart.js"></script>
<script src="../js/jquery-3.6.0.min.js"></script>
<style>
.btn {
  width: 120px;
}
.tbl-template {
  width: 1200px;
  border: 0;
}
.summ-data {
  font-weight: bold;
  font-size: 14px;
}
.pt-data {
  font-weight: bold;
  font-size: 14px;
}
.overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
    z-index: 1;
}
.popup {
    display: none;
    position: fixed;
    transform: translate(-50%, -50%);
    background-color: white;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 0 10px rgba(0,0,0,0.3);
    z-index: 2;
}
.close-btn {
    position: absolute;
    top: 5px;
    left: 5px;
    cursor: pointer;
}
</style>
<title>QC Chart</title>
</head>
<body style="background: lightyellow">
<form name="form1" id="form1" method="post" >
<input type="hidden" name="testType" id="testType" value="<%=testType==null?"":testType %>"/>
<input type="hidden" name="cntlNum" id="cntlNum" value="<%=cntlNum==null?"":cntlNum %>"/>
<input type="hidden" name="machno" id="machno" value="<%=machno==null?"":machno %>"/>
<input type="hidden" name="intTcode" id="intTcode" value="<%=intTcode==null?"":intTcode %>"/>
<input type="hidden" name="frDate" id="frDate" value="<%=frDate==null?"":frDate %>"/>
<input type="hidden" name="toDate" id="toDate" value="<%=toDate==null?"":toDate %>"/>
<input type="hidden" name="user" id="user" value="<%=user==null?"":user %>"/>

<div class="overlay" id="overlay"></div>
<div class="popup" id="wComment" style="top:50%; left:400px">
	<table>
	<tr>
    <td><textarea id="taComment" rows="20" cols="100" maxlength="1000"></textarea></td><td valign="top"><button type="button" onClick="toggleCommentList()">...</button></td>
    </tr>
    <tr><td align="right">
    <button id="popup-save" type="button" class="btn">save</button>
    <button id="popup-close" type="button" class="btn" onclick="hidePopup()">close</button>
    </td></tr>
    </table>
    <input type="hidden" id="popup-action"/>
</div>
<div class="popup" id="wCommentList" style="top:50%; left:50%">
	<select id="selComment" size="14" style="width:500px;" onChange="selectComment()">
<%
ArrayList<ReportableListObject> commentList = LabDB.getCommentTemplate("QC");
for (int i = 0; i < commentList.size(); i++) {
	ReportableListObject row = (ReportableListObject)commentList.get(i);
%>	
 	<option value="<%=row.getValue(0) %>" style="font-size:12px"><%=row.getValue(0) %></option>
<%
} 
%>
	</select>
</div>

<table class="tbl-template" >
<tr>
	<td>Run Date:</td><td><%=currentDate %></td>
	<td colspan=4 align="center"><h1 style="font-weight: bold; font-size: 16px">HONG KONG ADVENTIST HOSPITAL</h1></td>
</tr><tr>
	<td>Run Time:</td><td><%=currentTime %></td>
	<td colspan=4 align="center"><h1 style="font-weight: bold; font-size: 16px"><%=testTypeDesc %> QC - <%=instrument %></h1></td>
</tr><tr>
	<td>From:</td><td class="summ-data"><%=frDate.substring(6)+"/"+frDate.substring(4,6)+"/"+frDate.substring(0,4) %></td>
	<td>To:</td><td class="summ-data"><%=toDate.substring(6)+"/"+toDate.substring(4,6)+"/"+toDate.substring(0,4) %></td>
	<td>Control:</td><td class="summ-data"><%=cntlName %></td>
	<td>Lot Number:</td><td class="summ-data"><%=lotNum %></td>
</tr><tr>
	<td>Test Code:</td><td class="summ-data"><%=testCode %></td>
	<td>Test Name:</td><td class="summ-data"><%=testName %></td>
</tr>
</table>

<table class="tbl-template" >
<tr>
	<td rowspan=10><canvas id="qc-chart" style="background: lightgray" /></td>
</tr>
<%
ArrayList<ReportableListObject> rules = LabDB.getQcRules(testType, machno);
for (int i = 0; i < rules.size(); i++) {
	ReportableListObject row = (ReportableListObject)rules.get(i);
%>
<tr style="height:40px">
	<td class="summ-data">&nbsp 
<div id="divRule<%=row.getValue(0)%>">
<input class="cbRule" type="checkbox" id="cbRule<%=row.getValue(0) %>" value="<%=row.getValue(1) %>" Disabled /> <%=row.getValue(1) %>
</div>
	</td>
</tr>
<%
}
%>
<tr style="height:100px">
	<td><div class="pt-data" id="status"/></td>
</tr>
</table>

<table class="tbl-template" >
<tr>
	<td>Result: </td><td><div class="pt-data" id="result"/></td><td> Date: </td><td><div class="pt-data" id="date"/></td><td> Time: </td><td><div class="pt-data" id="time"/></td><td> Cumulative Sum: </td><td><div class="pt-data" id="cumulativeSum"/></td>
</tr><tr>
	<td valign="top">Comment: </td><td colspan="6"><textarea class="pt-data" id="comment" rows="3" cols="115" style="resize:none" disabled style="resize:none"></textarea></td><td valign="top"> By: </td><td valign="top"><div class="pt-data" id="rejAccBy" style="width:100px"/></td>
</tr><tr>
	<td>Points: </td><td> Accepted = </td><td><div id="accept" class="summ-data"></div></td><td> Excluded = </td><td><div id="reject" class="summ-data"></div></td><td> Total = </td><td><div id="total" class="summ-data"></div></td>
</tr><tr>
	<td>Given: </td><td> mean = </td><td><div id="givenMean" class="summ-data"><%=givenMean %></div></td><td> &sigma; = </td><td><div id="givenSD" class="summ-data"><%=givenSD %></div></td><td> Low = </td><td><div id="rangeLow" class="summ-data"><%=rangeLow %></div></td><td> High = </td><td><div id="rangeHigh" class="summ-data"><%=rangeHigh %></div></td>
</tr><tr>
	<td>Calculated: </td><td> mean = </td><td><div id="calMean" class="summ-data"></div></td><td> &sigma; = </td><td><div id="calSD" class="summ-data"></div></td><td> CV(%) = </td><td><div id="calCV" class="summ-data"></div></td><td> Range = </td><td><div id="calRange" class="summ-data"></div></td>
</tr>
</table>
<table class="tbl-template" >
<tr>
<td>
	<button id="btnConnect" type="button" class="btn">disconnect</button>
	<button id="btnMode" type="button" class="btn">cumulative sum</button>
	<button id="btnReject" type="button" class="btn">reject</button>
	<button id="btnComment" type="button" class="btn">view/edit comment</button>
</td><td>
	<button id="bgBack" type="button"><<</button>
	<button id="smBack" type="button"><</button>
	<button id="smFore" type="button">></button>
	<button id="bgFore" type="button">>></button>
</td><td>
	<button type="button" class="btn" onclick="window.print()">print</button>
	<button type="button" class="btn" onclick="window.close()">exit</button>
</td>
</tr>
</table>
        
<script>
const ctx = document.getElementById('qc-chart');

const labels = <%=labels.toJSONString() %>;
const data = <%=fullData.toJSONString() %>;
const rawData = <%=rawData.toJSONString() %>;

var ptStatus = <%=status.toJSONString() %>;
var reason = <%=reason.toJSONString() %>;
var rejAccBy = <%=rejAccBy.toJSONString() %>;
var testDate = <%=testDate.toJSONString() %>;
var testTime = <%=testTime.toJSONString() %>;
var key = <%=key.toJSONString() %>;

var rangeHigh = <%=rangeHigh %>;
var rangeLow = <%=rangeLow %>;
var mean = <%=givenMean %>; 
var sd = <%=givenSD %>; 

var cursor = labels.length - 1;
var x_max = labels.length;
var x_min = 0;
if (labels.length >= 30) {
	x_min = labels.length - 30;
}

var cumulative = [];

var wgrules = [];
<%
for (int i = 0; i < rules.size(); i++) {
	ReportableListObject row = (ReportableListObject)rules.get(i);

	if ("1".equals(row.getValue(2))) {
%>
		wgrules.push(wgrule<%=row.getValue(0) %>);
<%
	} else {
%>
		$("#divRule<%=row.getValue(0) %>").hide();
<%
	}
}
%>
var cont = true;

var mode = "levey-jenings";

var chart = new Chart(ctx, getChartParm());

$(document).ready(function(){
	calSummary();
	calCumulative();
	loadCursor();
	
    $(document).keydown(function(e){
    	if ($("#overlay").css("display") == "none") {
	        switch(e.key) {
	            case "ArrowLeft": 
	                goBack();
	                break;
	            case "ArrowRight": 
	                goFore();
	                break;
	        }
    	}	     
    });
    
//drag pop-up	
	$("#wComment").mousedown(function(e){
		
		let drag = true;
		$("#wComment").css("cursor", "move");
		let initx = parseFloat($("#wComment").css("left")) - e.clientX;
		let inity = parseFloat($("#wComment").css("top")) - e.clientY;				
		
		$("#taComment").mousemove(function() {				
			drag = false;
			$('#wComment').css("cursor", "default");
		});
		
		$(document).mousemove(function(e) {			
			if (drag) {				
		    	$("#wComment").css({
		        	left: initx + e.clientX,
		        	top: inity + e.clientY
		      	});
		    }
		});

	  	$(document).mouseup(function() {
	    	drag = false;
	    	$('#wComment').css('cursor', 'default');
		});		  
	});
	
	$("#wCommentList").mousedown(function(e){
		let drag = true;
		let initx = parseFloat($("#wCommentList").css("left")) - e.clientX;
		let inity = parseFloat($("#wCommentList").css("top")) - e.clientY;				
						
		$(document).mousemove(function(e) {		
			if (drag) {				
		    	$("#wCommentList").css({
		        	left: initx + e.clientX,
		        	top: inity + e.clientY
		      	});
		    }			
		});

	  	$(document).mouseup(function() {
	    	drag = false;
		});		  
	});
		
	$("#btnConnect").click(function() {		
		if ($("#btnConnect").text() == "connect") {
			cont = true;
			redraw();		
			$("#btnConnect").text("disconnect");
		} else {
			cont = false;
			redraw();
			$("#btnConnect").text("connect");			
		}
	});
	
	$("#btnMode").click(function() {		
		mode = $("#btnMode").text();
		if (mode == "levey-jenings") {
			$("#btnMode").text("cumulative sum");			
		} else {
			$("#btnMode").text("levey-jenings");	
		}
		redraw();
	});

/*Remove save calc function
 * 
	$("#btnSaveCalc").click(function() {	
		var now = new Date();			
		
		if (confirm("Do you want to overwrite the control range?")) {
			var newMean = Number($("#calMean").text());
			var newSD = Number($("#calSD").text());
			var newRangeHigh = newMean + 2 * newSD;
			var newRangeLow = newMean - 2 * newSD;
						
			$.ajax({			
				url: "lis_qc_action.jsp",	
	            type: 'GET',
			    dataType: "json",
			    
			    data: {
			        action:	"updateNorm",
			        user: $("#user").val(),
			        cntlNum: $("#cntlNum").val(),
			        testType: $("#testType").val(),
			        intTcode: $("#intTcode").val(),
			        machno: $("#machno").val(),
			        rangeHigh: newRangeHigh,
			        rangeLow: newRangeLow,
	        		timestamp: now},
	        		
			    success: function(response) {		    	
			    	if (response.message == "success") {
			    		$("#givenMean").text(newMean.toFixed(3));
			    		$("#givenSD").text(newSD.toFixed(3));
			    		$("#rangeHigh").text(newRangeHigh.toFixed(3));
			    		$("#rangeLow").text(newRangeLow.toFixed(3));
			    		mean = newMean;
			    		sd = newSD;
			    		rangeHigh = newRangeHigh;
			    		rangeLow = newRangeLow;
			    		redraw();
			    	} else {
			    		alert(response.message);
			    	}		    		
			    },
			    
			    error: function(xhr, status, error) {
			        alert(error);
			        hidePopup();
			    }		  		    
			});	
		} 
	});
*/
	
	$("#btnReject").click(function() {	
		showPopup();		
		var action = $("#btnReject").text();
		$("#popup-action").val(action);
		
		var comment = reason[cursor];
		
		if (action == "reject") {						
			if (comment == "") {
				$('.cbRule:checked').each(function() {
					if (comment == "") {
						comment = $(this).val();
					} else {
						comment = comment + ", " + $(this).val();
					}
				});
				
				comment = "Failed Rules: " + comment;
			}
		}
		
		$("#taComment").val(comment);
	});
	
	$("#btnComment").click(function() {			
		showPopup();
		$("#popup-action").val("comment");
		$("#taComment").val(reason[cursor]);	
	});
	
	$("#bgBack").click(function() {		
		cursor-=10;
		if (cursor < 0) {
			cursor = 0;
		}
		if (cursor < x_min) {
			x_min = cursor;
			x_max = x_min + 30;
		}
		redraw();
		loadCursor();
	});
	
	$("#smBack").click(function() {		
		goBack();
	});
	
	$("#bgFore").click(function() {		
		cursor+=10;
		if (cursor > labels.length - 1) {
			cursor = labels.length - 1;
		}
		if (cursor > x_max - 1) {
			x_max = cursor + 1;
			x_min = x_max - 30;
		}
		redraw();
		loadCursor();
	});
	
	$("#smFore").click(function() {		
		goFore();
	});	
	
	$("#popup-save").click(function() {	
		var now = new Date();
				
		$.ajax({			
			url: "lis_qc_action.jsp",	
            type: 'POST',
		    dataType: "json",
		    
		    data: {
		        action:	$("#popup-action").val(),
		        user: $("#user").val(),
		        comment: $("#taComment").val(),
		        key: key[cursor],
        		timestamp: now},
        		
		    success: function(response) {		    	
		    	if (response.message == "success") {
		    		reason[cursor] = response.comment;
		    		rejAccBy[cursor] = response.user;	
		    		
		    		if ($("#popup-action").val() == "accept") {
		    			ptStatus[cursor] = null;
		    			calSummary();
		    		} else if ($("#popup-action").val() == "reject") {
		    			ptStatus[cursor] = "R";
		    			calSummary();
		    		}	
		    		
		    	} else {
		    		alert(response.message);
		    	}
		    	
		    	hidePopup();
		    	calCumulative();
	    		loadCursor();
	    		redraw();
		    },
		    
		    error: function(xhr, status, error) {
		        alert(error);
		        hidePopup();
		    }		  		    
		});	
	});	
});

function goBack() {		
	cursor--;
	if (cursor < 0) {
		cursor = 0;
	}
	if (cursor < x_min) {
		x_min = cursor;
		x_max = x_min + 30;
	}
	redraw();
	loadCursor();
};

function goFore() {
	cursor++;
	if (cursor > labels.length - 1) {
		cursor = labels.length - 1;
	}
	if (cursor > x_max - 1) {
		x_max = cursor + 1;
		x_min = x_max - 30;
	}
	redraw();
	loadCursor();
}

function showPopup() {
	$("#wComment").css("display", 'block');
	$("#overlay").css("display", 'block');
	$("#taComment").val("");
}

function hidePopup() {
	$('.popup').css("display", 'none');
	$("#overlay").css("display", 'none');	
}

function toggleCommentList() {
	if ($('#wCommentList').css("display") == "none") { 
		$('#wCommentList').css("display", 'block');
	} else {
		$('#wCommentList').css("display", 'none');
	}
}

function selectComment() {
	let comment = $("#taComment").val();
	comment = comment + $("#selComment").val();
	$("#taComment").val(comment);
	$('#wCommentList').css("display", 'none');
}

function getChartParm() {
	if (mode == "levey-jenings") {
		return getLjParm();
	} else {
		return getCumParm();
	}
}

function getLjParm() {	
	var chtLabels = labels.slice(x_min, x_max);
	var y_min = <%=LjMin %>;
	var y_max = <%=LjMax %>;;
	
	var chtLine = [];
	var chtReject = [];
	var chtNormal = [];
	var chtAbnormal = [];
	var chtCursor = [];
	var chtUpperLimit = [];
	var chtLowerLimit = [];
	var chtMean = [];
	
	for (let i = x_min; i < x_max; i++) {
		let pt = data[i];
		
//change outlier values to top and bottom of the chart for plotting	
		if (pt > y_max) {
			pt = y_max;
		} else if (pt < y_min) {
			pt = y_min;
		}
		
		chtLine.push(pt);
							
		if (ptStatus[i] == 'R') {
			chtReject.push(pt);
			chtNormal.push(null);
			chtAbnormal.push(null);
		} else {
			var abnormal = false;
			
			wgrules.forEach(function(fx){
				abnormal = abnormal || fx(i, false);
			});			
			
			if (abnormal) {
				chtReject.push(null);
				chtNormal.push(null);
				chtAbnormal.push(pt);
			} else {
				chtReject.push(null);
				chtNormal.push(pt);
				chtAbnormal.push(null);
			}
		}
		
		chtUpperLimit.push(rangeHigh);
		chtLowerLimit.push(rangeLow);
		chtMean.push(mean);
		chtCursor.push(null);				
	}
	
	chtCursor[cursor - x_min] = y_min;	
		
	var chartParm =
	{
		"data": {
			"labels":chtLabels,

			"datasets": [{
//line				
				"showLine":cont,
				"borderColor":"rgba(0, 0, 139, 1)",
				"borderWidth":2,
				"spanGaps":true,
				"data":chtLine,
				"pointRadius":0
			},{
//normal				
				"showLine":false,
				"borderColor":"rgba(0, 0, 139, 1)",
				"pointBackgroundColor":"rgba(0, 0, 139, 1)",
				"borderWidth":2,
				"data":chtNormal,
				"pointRadius":5
			},{
//violated Westgard rules				
				"showLine":false,
				"borderColor":"rgba(0, 255, 255, 1)",
				"pointBackgroundColor":"rgba(255, 255, 255, 1)",
				"borderWidth":2,
				"data":chtAbnormal,
				"pointRadius":5
			},{
//reject				
				"showLine":false,
				"borderColor":"rgba(255, 0, 0, 1)",
				"pointBackgroundColor":"rgba(255, 255, 255, 1)",
				"borderWidth":2,
				"data":chtReject,
				"pointRadius":5
			},{
//Upper Limit				
				"showLine":true,
				"borderColor":"rgba(0, 0, 255, 1)",
				"borderWidth":2,
				"spanGaps":true,
				"data":chtUpperLimit,
				"pointRadius":0
			},{
//Lower Limit				
				"showLine":true,
				"borderColor":"rgba(0, 0, 255, 1)",
				"borderWidth":2,
				"spanGaps":true,
				"data":chtLowerLimit,
				"pointRadius":0
			},{		
//mean				
				"showLine":true,
				"borderColor":"rgba(0, 0, 0, 1)",
				"borderWidth":3,
				"spanGaps":true,
				"data":chtMean,
				"pointRadius":0
			},{		
//cursor				
				"showLine":false,
				"pointStyle": 'rect',
				"pointBackgroundColor":"rgba(0, 0, 0, 1)",
				"data":chtCursor,
				"pointRadius":10
			}]			
		},
		"type":"line",
		"options":{
			"scales":{
				"y":{
					"min":y_min,
					"max":y_max,
					"ticks":{
						"stepSize":sd,
						"callback":function(value) {
					    	return fixDec(value);
					    }
					},
					"grid":{
						"color":"rgba(0, 0, 0, 0.5)"
					}
				},
				"x":{
					"grid":{
						"color":"rgba(0, 0, 0, 0.5)"
					}
				}
			},
			"plugins":{
				"legend":{
					"display":false
				},
				"title":{
					"text":"Levey Jennings Chart",
					"display":true
				},
		        "tooltip":{
		            "enabled":false  
		        }
			}
		}
	};
	
	return chartParm;
}

function getCumParm() {
	
	var chtLabels = labels.slice(x_min, x_max);
	var y_min = -3 * sd;
	var y_max = 3 * sd;
	
	var chtLine = [];
	var chtReject = [];
	var chtNormal = [];
	var chtAbnormal = [];
	var chtCursor = [];
	var chtUpperLimit = [];
	var chtLowerLimit = [];
	var chtMean = [];
	
	for (let i = x_min; i < x_max; i++) {
		let pt = cumulative[i];
		
		if (pt > y_max) {
			pt = y_max;
		} else if (pt < y_min) {
			pt = y_min;
		}
		
		chtLine.push(pt);
							
		if (ptStatus[i] == 'R') {
			chtReject.push(pt);
			chtNormal.push(null);
			chtAbnormal.push(null);
		} else {
			var abnormal = false;
			
			wgrules.forEach(function(fx){
				abnormal = abnormal || fx(i, false);
			});			
			
			if (abnormal) {
				chtReject.push(null);
				chtNormal.push(null);
				chtAbnormal.push(pt);
			} else {
				chtReject.push(null);
				chtNormal.push(pt);
				chtAbnormal.push(null);
			}
		}
		
		chtUpperLimit.push(2*sd);
		chtLowerLimit.push(-2*sd);
		chtMean.push(0);
		chtCursor.push(null);				
	}
	
	chtCursor[cursor - x_min] = y_min;	
		
	var chartParm =
	{
		"data": {
			"labels":chtLabels,

			"datasets": [{
//line				
				"showLine":cont,
				"borderColor":"rgba(0, 0, 139, 1)",
				"borderWidth":2,
				"spanGaps":true,
				"data":chtLine,
				"pointRadius":0
			},{
//normal				
				"showLine":false,
				"borderColor":"rgba(0, 0, 139, 1)",
				"pointBackgroundColor":"rgba(0, 0, 139, 1)",
				"borderWidth":2,
				"data":chtNormal,
				"pointRadius":5
			},{
//violated Westgard rules				
				"showLine":false,
				"borderColor":"rgba(0, 255, 255, 1)",
				"borderWidth":2,
				"data":chtAbnormal,
				"pointRadius":5
			},{
//reject				
				"showLine":false,
				"borderColor":"rgba(255, 0, 0, 1)",
				"borderWidth":2,
				"data":chtReject,
				"pointRadius":5
			},{
//Upper Limit				
				"showLine":true,
				"borderColor":"rgba(0, 0, 255, 1)",
				"borderWidth":2,
				"spanGaps":true,
				"data":chtUpperLimit,
				"pointRadius":0
			},{
//Lower Limit				
				"showLine":true,
				"borderColor":"rgba(0, 0, 255, 1)",
				"borderWidth":2,
				"spanGaps":true,
				"data":chtLowerLimit,
				"pointRadius":0
			},{		
//mean				
				"showLine":true,
				"borderColor":"rgba(0, 0, 0, 1)",
				"borderWidth":3,
				"spanGaps":true,
				"data":chtMean,
				"pointRadius":0
			},{		
//cursor				
				"showLine":false,
				"pointStyle": 'rect',
				"pointBackgroundColor":"rgba(0, 0, 0, 1)",
				"data":chtCursor,
				"pointRadius":10
			}]			
		},
		"type":"line",
		"options":{
			"scales":{
				"y":{
					"min":y_min,
					"max":y_max,
					"ticks":{
						"stepSize":sd,
						"callback":function(value) {
					    	return fixDec(value);
					    }
					},
					"grid":{
						"color":"rgba(0, 0, 0, 0.5)"
					}
				},
				"x":{
					"grid":{
						"color":"rgba(0, 0, 0, 0.5)"
					}
				}
			},
			"plugins":{
				"legend":{
					"display":false
				},
				"title":{
					"text":"Cumulative Sum Chart",
					"display":true
				},
		        "tooltip":{
		            "enabled":false  
		        }
			}
		}
	};
	
	return chartParm;
}

function wgrule1(i, disp) {
//1 2s - One control observation exceeds the control limits of the Mean plus or minus two Standard Deviations.	
	if (Math.abs(data[i] - mean) > 2 * sd) {
		if (disp)
			$('#cbRule1').attr('checked', true);
		return true;
	} else {
		if (disp)
			$('#cbRule1').attr('checked', false);
		return false;
	}
}

function wgrule2(i, disp) {
//1 3s - One control observation exceeds the control limits of the Mean plus or minus three Standard Deviations.
	if (Math.abs(data[i] - mean) > 3 * sd){
		if (disp)
			$('#cbRule2').attr('checked', true);
		return true;
	} else {
		if (disp)
			$('#cbRule2').attr('checked', false);
		return false;
	}
}

function wgrule3(i, disp) {
//2 2s - Two consecutive control observations exceed either two Standard Deviations above or two Standard Deviati...
	if (Math.abs(data[i] - mean) <= 2 * sd) {
		if (disp)
			$('#cbRule3').attr('checked', false);
		return false;
	} else {
		var h = i - 1;
		while (h >= 0) {
			if (ptStatus[h] != 'R') {
				if (Math.abs(data[h] - mean) > 2 * sd) {
					if (disp)
						$('#cbRule3').attr('checked', true);
					return true;
				} else {
					if (disp)
						$('#cbRule3').attr('checked', false);
					return false;
				}
			} 
			h--;
		}
		
		if (disp)
			$('#cbRule3').attr('checked', false);
		return false;
	}
}

function wgrule4(i, disp) {
//R 4s - Two consecutive control observations exceed a total range of four Standard Deviations. The rule is invok...
	var h = i - 1;
	while (h >= 0) {
		if (ptStatus[h] != 'R') {
			if (Math.abs(data[i] - data[h]) > 4 * sd) {
				if (disp)
					$('#cbRule4').attr('checked', true);
				return true;
			} else {
				if (disp)
					$('#cbRule4').attr('checked', false);
				return false;
			}
		} 
		h--;
	}
	
	if (disp)
		$('#cbRule4').attr('checked', false);
	return false;		
}

function wgrule5(i, disp) {
//2of3 - Two of three consecutive control observations (including the trigger result) exceed two Standard Deviati...
	if (ptStatus[i] == 'R') {
		if (disp)
			$('#cbRule5').attr('checked', false);
		return false;
	}
	
	var sample_count = 0;
	var result_count = 0;
	var h = i;
	
	while (sample_count < 3) {
		if (h < 0) {
			if (disp)
				$('#cbRule5').attr('checked', false);
			return false;
		}
		
		if (ptStatus[h] != 'R') {
			if (Math.abs(data[h] - mean) > 2 * sd) { 
				result_count++;
			}
			sample_count ++;
		}
	
		h--;		
	}
	
	if (result_count >= 2) {
		if (disp)
			$('#cbRule5').attr('checked', true);
		return true;
	} else {
		if (disp)
			$('#cbRule5').attr('checked', false);
		return false;
	}	
}

function wgrule6(i, disp) {
//4 1s - Four consecutive control observations (including the trigger result) exceed one Standard Deviation above...
	if (Math.abs(data[i] - mean) <= sd) {
		if (disp)
			$('#cbRule6').attr('checked', false);
		return false;
	} else {
		var h = i - 1;
		var sample = 1;
	
		while (h >= 0) {
			if (ptStatus[h] != 'R') {
				sample++;
				if (Math.abs(data[h] - mean) <= sd) {
					if (disp)
						$('#cbRule6').attr('checked', false);
					return false;
				}
			}
			
			if (sample >= 4) {
				if (disp)
					$('#cbRule6').attr('checked', true);
				return true;
			}
				
			h--;
		}
	}
	
	if (disp)
		$('#cbRule6').attr('checked', false);
	return false;
}

function wgrule7(i, disp) {
//10 X - Ten consecutive control observations (including the trigger result) must be present either above the Mea...
	var pos = true;
	
	if (data[i] - mean == 0) {
		if (disp)
			$('#cbRule7').attr('checked', false);
		return false;
	} else if (data[i] - mean < 0) {
		pos = false;
	}
	
	var h = i - 1;
	var sample = 1;

	while (h >= 0) {		
		if (ptStatus[h] != 'R') {
			sample++;
			
			if (pos && data[h] - mean <= 0) {
				if (disp)
					$('#cbRule7').attr('checked', false);
				return false;
			}
			
			if (!pos && data[h] - mean >= 0) {
				if (disp)
					$('#cbRule7').attr('checked', false);
				return false;
			}
		}
		
		if (sample >= 10) {
			if (disp)
				$('#cbRule7').attr('checked', true);
			return true;
		}
			
		h--;
	}	
	
	if (disp)
		$('#cbRule7').attr('checked', false);
	return false;
}

function wgrule8(i, disp) {
//7 tr - Seven consecutive control observations (including the trigger result) must be present on the same side o...
	var upTrend = true;
	var downTrend = true;
	
	var result = data[i];
	var prev = i - 1;
	
	var sample_count = 0;
		
	while ((sample_count < 7) && (prev >= 0)){
		if (ptStatus[prev] != 'R') {
			if (result >= data[prev]) {
				downTrend = false;
			}
			if (result <= data[prev]) {
				upTrend = false;
			}
			sample_count++;
		}
		prev--;		
	}

	if (upTrend || downTrend) {
		if (disp)
			$('#cbRule8').attr('checked', false);
		return false;	
	} else {
		if (disp)
			$('#cbRule8').attr('checked', false);			
		return false;
	}
}

function loadCursor() {
	$("#result").text(rawData[cursor]);
	
	$("#date").text(testDate[cursor]);
	$("#time").text(testTime[cursor]);	
		
	$("#cumulativeSum").text(cumulative[cursor]);
	$("#comment").val(reason[cursor]);
	$("#rejAccBy").text(rejAccBy[cursor]);	
		
	if (ptStatus[cursor] == 'R') {
		$("#status").text("Rejected");
		$(".pt-data").css("color", "rgb(255, 0, 0)"); 
		$("#btnReject").text("accept");
	} else {
		$("#status").text("Accepted");
		$(".pt-data").css("color", "rgb(0, 128, 0)"); 
		$("#btnReject").text("reject");
	}
	
	wgrules.forEach(function(fx){
		fx(cursor, true);
	});	
}

function calSummary() {
	var now = new Date();
		
	$.ajax({			
		url: "lis_qc_action.jsp",	
        type: 'GET',
	    dataType: "json",
	    
	    data: {
	        action:	"cal",
	        cntlNum: $("#cntlNum").val(),
	        testType: $("#testType").val(),
	        machno: $("#machno").val(),
	        intTcode: $("#intTcode").val(),
	        frDate: $("#frDate").val(),
	        toDate: $("#toDate").val(),
    		timestamp: now},	        
    		
	    success: function(response) {		    	
	    	if (response.message == "success") {
	    		$("#accept").text(response.accept);
	    		$("#reject").text(response.reject);
	    		$("#total").text(response.total);
	    		$("#calMean").text(response.mean);
	    		$("#calSD").text(response.sd);
	    		$("#calCV").text(response.cv);
	    		$("#calRange").text(response.range);
	    		
	    	} else {
	    		alert(response.message);
	    	}	    		    	
	    },
	    
	    error: function(xhr, status, error) {
	        alert(error);
	    }		  		    
	});		
}

function calCumulative() {
	var cum = 0;
	for(let i = 0; i<labels.length; i++) {
		if (ptStatus[i] != "R")
			cum = cum + data[i] - mean;
		
		cumulative.push(fixDec(cum));
	}
}

function redraw() {
	chart.destroy();
	chart = new Chart(ctx, getChartParm());
}

function fixDec(val) {
	return Number(val.toFixed(<%=LabDB.QcDecimal %>)).toString();
}
</script>
</body>
</html>