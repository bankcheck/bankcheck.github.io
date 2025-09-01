<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> fetchWard(String locid) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PH_LOC_DESC ");
		sqlStr.append("FROM   PH_LOCATION ");
		sqlStr.append("WHERE  PH_LOC_ID = UPPER(?) ");
		sqlStr.append("AND    PH_LOC_TYPE = 'I' ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { locid });
	}

	private ArrayList<ReportableListObject> fetchAllWard() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PH_LOC_ID, PH_LOC_DESC ");
		sqlStr.append("FROM   PH_LOCATION ");
		sqlStr.append("WHERE  PH_LOC_TYPE = 'I' ");
		sqlStr.append("ORDER BY PH_LOC_DESC ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String locid = request.getParameter("locid");
String locDesc = null;
int collen = 20;
ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
if (locid != null && locid.length() > 0) {
	record = fetchWard(locid);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		locDesc = row.getValue(0);
	} else {
		locDesc = "Others";
	}
} else {
	record = fetchAllWard();
}

String queue = request.getParameter("queue");
%>
<html>
<head>
<script type="text/javascript" src="../js/jquery-1.5.1.min.js" /></script>
<script type="text/javascript">
<!--//
	var wait = 3 * 1000;
	var table = 0;
	var messagei = '';
	var displayType;
	var displayTicketNos;
	var updateStatus = '';
	var multSelect = [];
	var searchArray = 0;
	var i = 0;
	var arrayLen = 0;
	var completed = 0;

	$('#lbUsers3').html('');

	// this bit of code just ensures that if you have focus on the input which may be in a form
	// that the carriage return does not cause your form to be submitted. Some scanners submit
	// a carriage return after all the numbers have been passed.
//	$("#barcode").keypress(function(e) {
//		if ( e.which === 13 ) {
//			console.log("Prevent form submit.");
//			e.preventDefault();
//		}
//	});

	function timer(refreshOnly) {
		if (multSelect.length == 0) {
			$.ajax({
				type: "POST",
				url: "patientQueueByWard_ajax.jsp",
				data: "locid=<%=locid %>&table=" + table,
				success: function(values) {
					if (values != '') {
						$('#lbUsers3').html(values);
						if (!refreshOnly) {
							table++;

							// refresh table 1 after timeout
							window.setTimeout("timer(false)", wait);
						}
					} else {
						if (table != 0) {
							table = 0;

							// back to table 1 at once
							timer(refreshOnly);
						} else {
							$('#lbUsers3').html('');

							if (!refreshOnly) {
								// refresh table 1 after timeout
								window.setTimeout("timer(false)", wait);
							}
						}
					}//if
				}//success
			});//$.ajax
		} else {
			// refresh table 1 after timeout
			window.setTimeout("timer(false)", wait);
		}
	}

	function startTimer() {
		timer(false);
	}

	function isIE() {
		  var myNav = navigator.userAgent.toLowerCase();
		  var ret = (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
		  return ret;
	}

	function callPharmacyTicketPrint(ticketNo, pickupTime) {
		if (isIE()) {
			document.getElementById("HKAHIntranetApplet-object").getPharmacyTicketPrint('<%=locid %>', ticketNo, pickupTime);
		} else {
			$.ajax({
				type: "POST",
				url: "pharmacyTicketPrint_ajax.jsp",
				data: "locid=<%=locid %>&ticketNo=" + ticketNo + "&pickupTime=" + pickupTime,
				success: function(values) {
					if (values != '') {
						// done
					}//if
				}//success
			});//$.ajax
		}
	}

	function printPharmacyTicket(ticketNo) {
		$.ajax({
			type: "POST",
			url: "patientWaitingTime_ajax.jsp",
			data: "locid=<%=locid %>&ticketNo=" + ticketNo,
			success: function(values) {
				if (values != '') {
					callPharmacyTicketPrint(ticketNo, values);
				} else {
					callPharmacyTicketPrint(ticketNo, "10");
				}//if
			}//success
		});//$.ajax
	}

<%if (locid != null && locid.length() > 0) { %>
	$(document).ready(function () {
		startTimer();

		// variable to ensure we wait to check the input we are receiving
		// you will see how this works further down
		var pressed = false;
		// Variable to keep the barcode when scanned. When we scan each
		// character is a keypress and hence we push it onto the array. Later we check
		// the length and final char to ensure it is a carriage return - ascii code 13
		// this will tell us if it is a scan or just someone writing on the keyboard
		var chars = [];
		// trigger an event on any keypress on this webpage
//		$(window).keypress(function(e) {
		$(document).keypress(function(e) {
			if (e.which == 13) {
				printNewPharmacyTicket();
			} else {
				// check the keys pressed are numbers or 'A'
				if (e.which == 45 || (e.which >= 48 && e.which <= 57) || (e.which >= 65 && e.which <= 90) || (e.which >= 97 && e.which <= 122)) {
					// if a number is pressed we add it to the chars array
					chars.push(String.fromCharCode(e.which));
				}
				// debug to help you understand how scanner works
//				console.log(e.which + ":" + pressed + ":" + chars.join("|"));

				// Pressed is initially set to false so we enter - this variable is here to stop us setting a
				// timeout everytime a key is pressed. It is easy to see here that this timeout is set to give
				// us 1 second before it resets everything back to normal. If the keypresses have not matched
				// the checks in the readBarcodeScanner function below then this is not a barcode
				if (!pressed) {
					// we set a timeout function that expires after 1 sec, once it does it clears out a list
					// of characters
					setTimeout(function() {
						// check we have a long length e.g. it is a barcode
						if (chars.length >= 4) {
							// join the chars array to make a string of the barcode scanned
							var barcode = chars.join('');
							// debug barcode to console (e.g. for use in Firebug)
//							console.log("Barcode Scanned: " + barcode);
							// assign value to some input (or do whatever you want)
//							$("#barcode").html("<" + barcode + ">");
							$.ajax({
								type: "POST",
								url: "patientUpdateQueue2_ajax.jsp",
								data: "locid=<%=locid %>&queue=3&ticketNo=" + barcode,
								success: function(values) {
									timer(true);
//									if (values != '') {
//										$("#barcode").html(values);
//									}//if
								}//success
							});//$.ajax
						}
						chars = [];
						pressed = false;
					},500);
				}
				// set press to true so we do not reenter the timeout function above
				pressed = true;
			}
		});
	});
<%} %>
	function printNewPharmacyTicket() {
		$.ajax({
			type: "POST",
			url: "patientUpdateQueue2_ajax.jsp",
			data: "locid=<%=locid %>&queue=",
			success: function(values) {
				if (values != '') {
					timer(true);
					printPharmacyTicket(values);
				}//if
			}//success
		});//$.ajax
	}

	function updateDisplayType() {
		if (updateStatus == '3') {
			displayType = 'Nurse Acknowledged';
		} else {
			displayType = '';
		}
	}


	function performAction(ticketDt, ticketno) {
		updateDisplayType();

		if (displayType != '') {
			if (confirm(displayType + ' : ' + ticketno)) {
				$.ajax({
					type: "POST",
					url: "patientUpdateQueue2_ajax.jsp",
					data: "locid=<%=locid %>&queue=" + updateStatus + "&ticketDt=" + ticketDt + "&ticketNo=" + ticketno,
					success: function(values) {
						if (values != '') {
							timer(true);
						}//if
					}//success
				});//$.ajax
			}
			unhighlight();
			updateStatus = '';
			timer(true);
		} else {
			searchArray = -1;
			for (i = 0; searchArray == -1 && i < multSelect.length; i++) {
				if (ticketno == multSelect[i]) {
					searchArray = i;
				}
			}
			if (searchArray == -1) {
				document.getElementById(ticketno + '-all').style.background = '#FEFFCF';
				document.getElementById(ticketno + '-all').style.border = '2px solid rgb(130,0,0)';
				multSelect[multSelect.length] = ticketno;
			} else {
				document.getElementById(ticketno + '-all').style.background = '';
				document.getElementById(ticketno + '-all').style.border = '';
				multSelect.splice(searchArray, 1);
			}
		}
	}

	function highlight(cell, newStatus) {
		if (multSelect.length == 0) {
			unhighlight();

			if (updateStatus != newStatus) {
				updateStatus = newStatus;
				cell.style.fontWeight = 'bold';
				cell.style.border = '2px solid rgb(130,0,0)';
			} else {
				updateStatus = '';
			}
		} else {
			updateStatus = newStatus;
			updateDisplayType();

			displayTicketNos = '';
			for (i = 0; i < multSelect.length; i++) {
				if (i > 0) displayTicketNos += ','
				displayTicketNos += '<%=locid%>-' + multSelect[i].substring(4);
			}

			if (updateStatus == 'r') {
				if (confirm('Reprint : ' + displayTicketNos)) {
					for (i = 0; i < multSelect.length; i++) {
						printPharmacyTicket(multSelect[i]);
					}
				}
			} else {
				if (confirm(displayType + ' : ' + displayTicketNos)) {
					completed = 0;
					arrayLen = multSelect.length;
					for (i = 0; i < multSelect.length; i++) {
						$.ajax({
							type: "POST",
							url: "patientUpdateQueue2_ajax.jsp",
							data: "locid=<%=locid %>&queue=" + updateStatus + "&ticketNo=" + multSelect[i],
							success: function(values) {
								completed++;
								if (completed >= multSelect.length) {
									timer(true);
								}//if
							}//success
						});//$.ajax
					}
				}
			}
			// reset array
			updateStatus = '';
			multSelect = [];
			timer(true);

		}
	}

	function unhighlight() {
		var table = document.getElementById('table1');
		var i, j, row, col;
		for (i=0; row = table.rows[i]; i++) {
			for (j=0; col = row.cells[j]; j++) {
				col.style.fontWeight = 'normal';
				col.style.border = '';
			}
		}
	}
//-->
</script>

<style type="text/css">

#table {
	position: fixed !important;
	left: 0px !important;
	right: 0px !important;
	bottom: 0px !important;

	width:100%;

	background-color:white;
	border-top:3px solid #333;

	z-index:10;
}
#wrapper3 {
	position:absolute;
	z-index:1;
	top: 0px;
	left: 0px;
	right: 0px;

	height:100%;
	overflow:hidden;
}
#scroller3 {
	width:100%;
	height:5000px;
	padding:0;
}
#wrapper1 {
	position: absolute;
	z-index: 1;
	top: 100px;
	bottom: 0;
	left: 0px;
	right: 0px;
	height:20%;
	width: 100%;
	overflow: auto;
	padding:0px;
}
#scroller1 {
	width:100%;
	height:300px;

	padding:0;
}
#wrapper2 {
	position: absolute;
	z-index: 1;
	top: 100px;
	bottom: 0;
	left: 200px;
	right: 0px;
	height:100%;
	width: 100%;
	overflow: auto;
	padding:0px;
}
#scroller2 {
	width:400px;
	height:5000px;

	padding:0;
}
#wrapper5 {
	position: absolute;
	z-index: 1;
	top: 100px;
	bottom: 0;
	left: 600px;
	right: 0px;
	height:100%;
	width: 100%;
	overflow: auto;
	padding:0px;
}
#scroller5 {
	width:400px;
	height:5000px;

	padding:0;
}
#table1 {
	position:absolute;
	width:100%;
	bottom:0; /* stick to bottom */
	background-color:white;
	border-top:3px solid #333;
	height:10%;
	z-index:10;
}
.box{
	border:1px solid #CCC;
}
.skipline{
	border:0px solid;
}
.selected{
	background-color:yellow;
}
#keypad tr td {
	vertical-align:middle;
	text-align:center;
	border:1px solid #000000;
	font-size:18px;
	font-weight:bold;
	width:40px;
	height:30px;
	cursor:pointer;
	background-color:#666666;
	color:#CCCCCC;
}
#keypad tr td:hover {
	background-color:#999999; color:#FFFF00;
}
</style>
</head>
<body>
<%if (locid != null && locid.length() > 0) { %>
<table align="center" cellspacing="0" border="0" width="100%">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center" valign=middle bgcolor="#AA0066"><b><font face="AR PL SungtiL GB" size=5 color="#FFFFFF"><%=locDesc %></font>&nbsp;<font color="red"><span id="barcode"></span></font></b></td>
	</tr>
</table>
<!-- index page -->

<table BORDER=2 id="lbUsers3" width="100%" border="1"></table>

<div id="Footer">
<table id="table1" width="100%" border="0">
	<tr>
		<td width=33% style='background-color:rgb(253,233,217);opacity:0.9;' onclick='printNewPharmacyTicket()'><center><font color='black' SIZE='6'>Ticket Generation</font></center></td>
		<td width=34% style='background-color:yellow;opacity:0.9;' onclick='highlight(this, "r")'><center><font color='black' SIZE='6'>Reprint</font></center></td>
		<td width=33% style='background-color:rgb(198,217,241);opacity:0.9;' onclick='highlight(this, "3")'><center><font color='black' SIZE='6'>Nurse Acknowledged</font></center></td>
	</tr>
</table>
</div>
<%} else {%>
<table align="center" cellspacing="0" border="0" width="100%">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center" valign=middle bgcolor="#AA0066"><b><font face="AR PL SungtiL GB" size=5 color="#FFFFFF">Please select location:</font>&nbsp;<font color="red"><span id="barcode"></span></font></b></td>
	</tr>
</table>

<table align="center" cellspacing="0" border="0">
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<%	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i); %>
	<tr>
		<td>(<%=(i + 1) %>)</td>
		<td align="left" valign=middle><b><font face="AR PL SungtiL GB" size=5 color="#AA0066"><a href="wardQueue.jsp?locid=<%=row.getValue(0) %>"><%=row.getValue(1) %></a></font>&nbsp;<font color="red"><span id="barcode"></span></font></b></td>
	</tr>
<%	} %>
</table>
<%} %>
</body>
</html>
