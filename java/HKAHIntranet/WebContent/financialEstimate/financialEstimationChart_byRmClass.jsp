<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@	page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	DecimalFormat noDigit = new DecimalFormat("#,##0");

	private ArrayList<ReportableListObject> fetchClass(String acmcode) {
		return UtilDBWeb.getReportableListHATS("SELECT ACMCODE, ACMNAME FROM FIN_ACM WHERE ACMCODE = ?", new String[] { acmcode });
	}

	private String currencyFormat(String value) {
		if (value != null && value.length() > 0) {
			try {
				return noDigit.format(Integer.parseInt(value));
			} catch (Exception e) {
			}
		}
		return "0";
	}
%>
<%
UserBean userBean = new UserBean(request);

String from = request.getParameter("from");
String code = request.getParameter("code");

String doccode = request.getParameter("doccode");
String acmcode = request.getParameter("acmcode");
String acmdesc = null;
String procedure1 = request.getParameter("procedure1");
String procedure2 = request.getParameter("procedure2");

String percentile = "50";

String minT = null;
String maxT = null;
String avgT = null;
String median_T = null;

String minP = null;
String maxP = null;
String avgP = null;
String median_P = null;

String interval = "1000";
int count = 0;

ArrayList<ReportableListObject> record = UtilDBWeb.getFunctionResultsHATS("NHS_GET_PROCFEE", new String[] { null, procedure2, null, acmcode, null, null });
ReportableListObject row = null;
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);

	if ("ProFeeInput".equals(code)) {
		count = 0;
	} else if ("AnaesthetistFeeInput".equals(code)) {
		count = 4;
	} else if ("OtherInput2".equals(code)) {
		count = 8;
	} else if ("OTInput".equals(code)) {
		count = 16;
	} else if ("OtherInput3".equals(code)) {
		count = 20;
	}

	minT = row.getValue(count);
	maxT = row.getValue(count + 1);
	avgT = row.getValue(count + 2);
	median_T = row.getValue(count + 3);
}

record = UtilDBWeb.getFunctionResultsHATS("NHS_GET_PROCFEE", new String[] { doccode, procedure2, null, acmcode, null, null });
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);

	minP = row.getValue(count);
	maxP = row.getValue(count + 1);
	avgP = row.getValue(count + 2);
	median_P = row.getValue(count + 3);
}

if (acmcode != null) {
	record = fetchClass(acmcode);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		acmdesc = row.getValue(1);
	}
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<!--<meta http-equiv="Content-Type" content="text/html; charset=big5">-->
		<meta http-equiv="Content-Type" content="text/html charset=UTF-8" /><!-- For ipad chinese -->
		<title>Financial Estimation Chart</title>
		<link rel="stylesheet" href="./css/style.css" type="text/css">
		<script src="../js/amcharts.js" type="text/javascript"></script>
		<script src="../js/serial.js" type="text/javascript"></script>
		<script src="../js/jquery-1.3.2.min.js" type="text/javascript"></script>

<style>
body {
	margin-top: 0;
}

a {
	color: #ff0000;
}
#close {
	position: absolute;
	right: 20px;
	z-index: 1000;
}
path {
 z-index:2000;
}
</style>
<script type="text/javascript">
			var chart;
<%
out.print("var chartData = [");

ArrayList<ReportableListObject> recordT = UtilDBWeb.getFunctionResultsHATS("NHS_LST_PROCSTAT", new String[] { code, null, procedure2, acmcode });
if (recordT.size() > 0) {
	for (int i = 0; i < recordT.size(); i++) {
		row = (ReportableListObject) recordT.get(i);
		if (i > 0) out.print(",");
		out.print("{'price':'");
		out.print(currencyFormat(row.getValue(0)));
		out.print("','casePercent':");
		out.print(row.getValue(2));
		out.print(",'");
		out.print("T");
		out.print("':");
		out.print(row.getValue(1));
		out.println("}");
	}
}
out.print("];");
%>

function isIE () {
	var myNav = navigator.userAgent.toLowerCase();
	return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
}
function popitup(link) {
  var w = window.open(link.href,
		link.target||"_blank",
		'menubar=no,toolbar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=no,dependent,width=970,height=620,left=0,top=0');
  return w?false:true; // allow the link to work if popup is blocked
}
			AmCharts.ready(function () {
				// SERIAL CHART
				chart = new AmCharts.AmSerialChart();
				chart.pathToImages = "../images/";
				chart.dataProvider = chartData;
				chart.marginTop = 5;
				chart.categoryField = "price";
<%
				if ("ProFeeInput".equals(code)) {
					out.println("chart.addTitle('醫療程序/手術費 Procedural / Surgical Fee ', 15);");
				} else if ("AnaesthetistFeeInput".equals(code)) {
					out.println("chart.addTitle('麻醉科醫生費 Anaesthetist Fee', 15);");
				} else if ("OtherInput2".equals(code)) {
					out.println("chart.addTitle('其他項目及收費 Other Items and Charges', 15);");
				} else if ("OTInput".equals(code)) {
					out.println("chart.addTitle('手術室及相關物料費用 Operating Theatre and Associated Materials Charges', 15);");
				} else if ("DIInput".equals(code)) {
					out.println("chart.addTitle('診斷程序 Diagnostic Procedures', 15);");
				} else if ("OtherInput3".equals(code)) {
					out.println("chart.addTitle('其他醫院收費 Other Hospital Charges', 15);");
				}
%>
				chart.addListener("dataUpdated", zoomChart);
				chart.addListener("clickGraphItem", handleClick);

				// AXES
				// Category
				var categoryAxis = chart.categoryAxis;
				categoryAxis.gridPosition = "start";
				categoryAxis.axisColor = "#DADADA";
				categoryAxis.dashLength = 3;
				categoryAxis.labelRotation = 45;

				// Value
				var valueAxis = new AmCharts.ValueAxis();
				valueAxis.gridAlpha = 0.07;
				valueAxis.title = "Number of Case";
				valueAxis.dashLength = 3;
				valueAxis.axisAlpha = 0.2;
				valueAxis.minorGridEnabled = true;
				valueAxis.gridAlpha = 0.15;
				valueAxis.stackType = "regular";  // new for column
				chart.addValueAxis(valueAxis);


			/* ------------------------ Percentile - start ----------------------- */
<%
if (recordT.size() > 0) {
	for (int i = 0; i < recordT.size(); i++) {
		row = (ReportableListObject) recordT.get(i);
%>
				var guide<%=row.getValue(2) %>T = new AmCharts.Guide();
				guide<%=row.getValue(2) %>T.category = "<%=row.getValue(0) %>";
				guide<%=row.getValue(2) %>T.lineColor = "#008800";
				guide<%=row.getValue(2) %>T.lineAlpha = 1;
				guide<%=row.getValue(2) %>T.dashLength = 1;
				guide<%=row.getValue(2) %>T.fillAlpha= 0.3,
				guide<%=row.getValue(2) %>T.fillColor= "#888888",
				guide<%=row.getValue(2) %>T.color= "#555555",
				guide<%=row.getValue(2) %>T.inside = true;
				guide<%=row.getValue(2) %>T.labelRotation = 90;
				guide<%=row.getValue(2) %>T.label = "<%=row.getValue(2) %>%";
				categoryAxis.addGuide(guide<%=row.getValue(2) %>T);
<%
		if ("50".equals(row.getValue(2))) {
%>
				var guideUser = new AmCharts.Guide();	// input by user (red line)
                guideUser.category = "<%=row.getValue(0) %>";
                guideUser.lineColor = "#ff0000";
                guideUser.lineAlpha = 1;
                guideUser.dashLength = 3;
                guideUser.inside = true;
				guideUser.color= "#ee4488",
                guideUser.labelRotation = 90;
                guideUser.label = "percentile of 50%";
                categoryAxis.addGuide(guideUser);
<%
		}

	}
}
%>
			/* ------------------------ Percentile - end ----------------------- */


			/* ------------------------ Graph - start ----------------------- */
				// Graph (Hospital)
				var graph2 = new AmCharts.AmGraph();
				graph2.type = "column";
				graph2.lineColor = "#ff8899";
				graph2.lineAlpha = 0;
				graph2.fillAlphas = 1;
				graph2.title = "<%=acmdesc %> (All Doctors) ";
				graph2.valueField = "T";
				graph2.balloonText = "<span style='font-size:13px;'><b>$[[category]]</b> ([[value]] <%=acmdesc %> Cases)<br/>[[casePercent]]th percentile</span>";
				graph2.pattern = {"url":"../images/ui-bg_diagonals-thick_18_b81900_40x40.png", "width":50, "height":50};
				chart.addGraph(graph2);
			/* ------------------------ Graph - end ----------------------- */

				// LEGEND
				var legend = new AmCharts.AmLegend();
				legend.position = "bottom";
				legend.valueText = "[[value]] Cases";
				legend.valueWidth = 200;
				legend.valueAlign = "left";
				legend.equalWidths = false;
				legend.borderAlpha = 0.3;
				legend.horizontalGap = 10;
				legend.switchType = "v";
				legend.periodValueText = "        total: [[value.sum]] Cases"; // this is displayed when mouse is not over the chart.
				chart.addLegend(legend);

				// CURSOR
				var chartCursor = new AmCharts.ChartCursor();
				chartCursor.zoomable = false;
				chartCursor.cursorAlpha = 0;
				chartCursor.valueBalloonsEnabled = false;
				chart.addChartCursor(chartCursor);

				// SCROLLBAR
				var chartScrollbar = new AmCharts.ChartScrollbar();
				chartScrollbar.color = "#FFFFFF";
				chart.addChartScrollbar(chartScrollbar);

				//// 3D
				//chart.depth3D = 10;
				//chart.angle = 30;
				chart.depth3D = 0;
				chart.angle = 0;

				// WRITE
				chart.write("chartdiv");

				<% if ("0".equals(minP) && "0".equals(maxP) && "0".equals(avgP) && "0".equals(median_P)) { %>
					//alert("No result found.");
					//closeWin();
				<% } %>

				// ZOOM
				function zoomChart() {
					// different zoom methods can be used - zoomToIndexes, zoomToDates, zoomToCategoryValues
				}

				function handleClick(event)	{
					parent.document.getElementById('<%=code %>').value = event.item.category;
					closeWin();
				}
			});

		</script>
	</head>

	<body onload="window.parent.document.getElementById('loading').style.display='none';">
	<% if (!"report".equals(from)) {%>
	<!--#include file=".\iFrameHeader.asp"-->
		<div>
			<div id="close"><img src="../images/delete1.png" width="30" onclick="closeWin()"></div>
		</div>
	<% } %>
		<div id="chartdiv" style="width:100%; height:400px;"></div>

		<span style="color:red;">** Results of <b>all doctors</b> are shown.</span>

		<br/>
		<br/>
		<br/>

		<center>
		<table id="percentileTable" width="80%">
			<tr bgcolor='#DDDDD'>
				<tr>
					<th bgcolor='#D8BFD8'>Percentile by Cases</th>
					<th bgcolor='#D8BFD8'>Price (All Doctors)</th>
					<th bgcolor='#D8BFD8'>Price (Active Doctor)</th>
				</tr>
				<tr>
					<td bgcolor='#ffDDDD'><center>MIN</center></td>
					<td bgcolor='#ffDDDD' onclick="handleClick_table('<%=minT %>')"><center>$ <%=currencyFormat(minT) %></center></td>
					<td bgcolor='#ffDDDD' onclick="handleClick_table('<%=minP %>')"><center>$ <%=currencyFormat(minP) %></center></td>
				</tr>
				<tr>
					<td bgcolor='#ffDDDD'><center>MAX</center></td>
					<td bgcolor='#ffDDDD' onclick="handleClick_table('<%=maxT %>')"><center>$ <%=currencyFormat(maxT) %></center></td>
					<td bgcolor='#ffDDDD' onclick="handleClick_table('<%=maxP %>')"><center>$ <%=currencyFormat(maxP) %></center></td>
				</tr>
				<tr>
					<td bgcolor='#ffDDDD'><center>MEAN</center></td>
					<td bgcolor='#ffDDDD' onclick="handleClick_table('<%=avgT %>')"><center>$ <%=currencyFormat(avgT) %></center></td>
					<td bgcolor='#ffDDDD' onclick="handleClick_table('<%=avgP %>')"><center>$ <%=currencyFormat(avgP) %></center></td>
				</tr>
				<tr>
					<td bgcolor='#ffDDDD'><center>MEDIAN</center></td>
					<td bgcolor='#ffDDDD' onclick="handleClick_table('<%=median_T %>')"><center>$ <%=currencyFormat(median_T) %></center></td>
					<td bgcolor='#ffDDDD' onclick="handleClick_table('<%=median_P %>')"><center>$ <%=currencyFormat(median_P) %></center></td>
				</tr>
			</tr>
		</table>
		</center>

		<br/>
	</body>
</html>

<script type="text/javascript">

function numCheck(evt) {
  var theEvent = evt || window.event;
  var key = theEvent.keyCode || theEvent.which;
  key = String.fromCharCode( key );
  var regex = /[0-9]/;
  if( !regex.test(key) ) {
	theEvent.returnValue = false;
	if(theEvent.preventDefault) theEvent.preventDefault();
  }
}

function numCheck2(self) {
	if (isNaN(self.value)) {
		alert("It is not a number!");
		self.value = "";
		self.focus();
	}
}

function changeAxis() {
	var procedure1 = ReplaceURL('<%=procedure1%>')
	var procedure2 = ReplaceURL('<%=procedure2%>')

	parent.document.getElementById('chart').src = "./FinancialEstimationChart_byRmClass.asp?doccode=<%=doccode%>&procedure1="+procedure1+"&procedure2="+procedure2+"&code=<%=code%>&acmcode=<%=acmcode%>&interval="+document.getElementById('IntervalInput').value+"&percentile="+document.getElementById('PercentileInput').value+"&rnd="+Math.random();
}

function handleClick_table(value)	{
	parent.document.getElementById('<%=code %>').value = value;
	closeWin();
}

function closeWin() {
	window.parent.document.getElementById('mask').style.display='none';
	window.parent.document.getElementById('chart').style.display='none';
	window.parent.InputCal();
}

</script>