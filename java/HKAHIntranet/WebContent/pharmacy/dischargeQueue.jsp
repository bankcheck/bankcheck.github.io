<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%
String locid = "DIS";
String queue = request.getParameter("queue");
boolean isPBO = "Y".equals(request.getParameter("isPBO"));
String queueName = null;
if ("3".equals(queue)) {
	queueName = "Patient picked up";
} else if ("2".equals(queue) || isPBO) {
	queue = "2";
	queueName = "To PBO";
} else {
	queue = "1";
	queueName = "Start Processing";
}
boolean filter = "Y".equals(request.getParameter("filter"));
if (filter) {
	queueName += " (Skip Ack)";
}
boolean resize = "Y".equals(request.getParameter("resize"));
if (resize) {
	queueName += " (Resized)";
}
%>
<html>
<head>
<script type="text/javascript" src="../js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="../js/jquery-ui.1.10.4.js"></script>
<link rel="stylesheet" type="text/css" href="../css/jquery-ui.1.10.3.css"/>
<audio class="my_audio">
	<source src="../audio/bell.mp3" type="audio/mp3">
</audio>
<script type="text/javascript">
<!--//
	var wait = 6 * 1000;
	var table = 0;
	var messagei = '';
	var displayType;
	var displayTicketNos;
	var updateStatus = '';
	var multSelect1 = [];
	var multSelect2 = [];
	var searchArray = 0;
	var i = 0;
	var arrayLen = 0;
	var completed = 0;
	var reportUrl = '';

	$('#lbUsers3').html('');
	$(".my_audio").trigger('load');

	// this bit of code just ensures that if you have focus on the input which may be in a form
	// that the carriage return does not cause your form to be submitted. Some scanners submit
	// a carriage return after all the numbers have been passed.
//	$("#barcode").keypress(function(e) {
//		if ( e.which === 13 ) {
//			console.log("Prevent form submit.");
//			e.preventDefault();
//		}
//	});

	$(function() {
		$("#dialog_div").dialog({
			autoOpen: false,
			title: "Remark",
			height: 300,
			width: 450,
			modal: true,
			show: "blind",
			hide: "explode",
			buttons: {
				"Ok": function() { $(this).dialog("close"); setRemark(); },
				"Cancel": function() { $(this).dialog("close"); resetMultSelection(); }
			}
		});


		$("#message_div").dialog({
			autoOpen: false,
			height: 100,
			width: 300,
			show: "drop",
			hide: "slide",
			open: function(event, ui){
				setTimeout("$('#message_div').dialog('close')",2000);
			}
		});

		$(".ui-dialog-titlebar").hide();
	});

	function play_audio(task) {
		if (task == 'play') {
			$(".my_audio").trigger('play');
		}
		if (task == 'stop') {
			$(".my_audio").trigger('pause');
			$(".my_audio").prop("currentTime", 0);
		}
	}

	function timer(refreshOnly) {
		if (multSelect1.length == 0) {
			$.ajax({
				type: "POST",
				url: "dischargeQueue<%=isPBO?"PBO":"" %>_ajax.jsp",
				data: "table=" + table + "<%=filter?"&filter=Y":"" %><%=resize?"&resize=Y":"" %>",
				success: function(values) {
					if (values != '' && values.length > 1) {
<%	if (isPBO) { %>
						$('#lbUsers3').html(values.substring(1));
<%	} else { %>
						$('#lbUsers3').html(values);
<%	} %>
						if (!refreshOnly) {
							table++;

							// refresh table 1 after timeout
							window.setTimeout("timer(false)", wait);

<%	if (isPBO) { %>
							if (values.substring(0, 1) != '0') {
								play_audio('play');
//								console.log("sound");
							} else {
								play_audio('stop');
//								console.log("no sound");
							}
<%	} %>
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
		$.ajax({
			type: "POST",
			url: "pharmacyTicketPrint_jasper.jsp",
			data: "locid=<%=locid %>&ticketNo=" + ticketNo + "&pickupTime=" + pickupTime,
			success: function(values) {
				if (values != '') {
					window.location.href = reportUrl + 'pharmacyTicketIP' + values.substring(14) + '.pdf';
					// done
				}//if
			}//success
		});//$.ajax
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
<%	if (isPBO) { %>
<%	} else { %>
				if ($("#dialog_div").dialog("isOpen")) {
					$("#dialog_div").dialog("close");
					setRemark();
				} else {
					var barcode = chars.join('');
//					printNewPharmacyTicket(barcode.substring(0, barcode.length - 1));
					printNewPharmacyTicket(barcode);
				}
<%	} %>
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
								url: "dischargeQueueUpdate_ajax.jsp",
								data: "locid=<%=locid%>&queue=<%=queue %>&ticketNo=" + barcode + "&isPBO=<%=isPBO?"Y":"N" %>",
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

	function printNewPharmacyTicket(patno) {
		if (patno == null || patno.length == 0) {
			var patno2 = prompt("Please enter patient no:");
			if (patno2 != null && patno2.length > 0) {
				patno = patno2;
			}
		}

		$.ajax({
			type: "POST",
			url: "dischargeQueueUpdate_ajax.jsp",
			data: "locid=<%=locid%>&queue=&patno=" + patno,
			success: function(values) {
				if (values != '') {
					timer(true);
					printPharmacyTicket(values);
				}//if
			}//success
		});//$.ajax
	}

	function updateDisplayType() {
		if (updateStatus == '-1') {
			displayType = 'Cancel';
		} else if (updateStatus == 'r') {
			displayType = 'Reprint';
		} else if (updateStatus == '0') {
			displayType = 'Done';
		} else if (updateStatus == '1') {
			displayType = 'Start Processing';
		} else if (updateStatus == '2') {
			displayType = 'To PBO';
		} else if (updateStatus == '3') {
<%	if (isPBO) { %>
			displayType = 'Completed';
<%	} else { %>
			displayType = 'To Pharmacy';
<%	} %>
		} else if (updateStatus == '4') {
			displayType = 'Patient Pick Up';
		} else if (updateStatus == 'z') {
			displayType = 'Re-Call';
		} else if (updateStatus == 'h') {
<%	if (isPBO) { %>
			displayType = 'Start Processing';
<%	} else { %>
			displayType = 'On-Hold';
<%	} %>
		} else if (updateStatus == 'm') {
			displayType = 'Remark';
		} else {
			displayType = '';
		}
	}

	function performAction(displayno, ticketno) {
		updateDisplayType();

		if (displayType != '') {
			if (updateStatus == 'z') {
				recallStatus(displayno, ticketno);
				timer(true);
			} else if (confirm(displayType + ' : ' + displayno)) {
				if (updateStatus == 'r') {
					printPharmacyTicket(ticketno);
				} else if (updateStatus == 'h') {
					setUpdateStatus(updateStatus, displayno, ticketno, true);
				} else if (updateStatus == 'm') {
					document.getElementById("displayno").value = displayno;
					document.getElementById("ticketno").value = ticketno;
					showRemarkDialog();
				} else {
					$.ajax({
						type: "POST",
						url: "dischargeQueueUpdate_ajax.jsp",
						data: "locid=<%=locid%>&queue=" + updateStatus + "&ticketNo=" + ticketno + "&isPBO=<%=isPBO?"Y":"N" %>",
						success: function(values) {
							if (values != '') {
								timer(true);
							}//if
						}//success
					});//$.ajax
				}
			} else {
				timer(true);
			}
		} else {
			searchArray = -1;
			for (i = 0; searchArray == -1 && i < multSelect1.length; i++) {
				if (ticketno == multSelect1[i]) {
					searchArray = i;
				}
			}
			if (searchArray == -1) {
				document.getElementById(ticketno + '-all').style.background = '#FEFFCF';
				multSelect1[multSelect1.length] = ticketno;
				multSelect2[multSelect2.length] = displayno;
			} else {
				document.getElementById(ticketno + '-all').style.background = '#FFFFFF';
				multSelect1.splice(searchArray, 1);
				multSelect2.splice(searchArray, 1);
			}
		}
	}

	function getCurrentStatus(status) {
		if (status == '0') {
			return "Ticket Generation";
		} else if (status == '1') {
			return "Start Processing";
		} else if (status == '2') {
			return "To PBO";
		} else if (status == '3') {
			return "To Pharmacy";
		} else if (status == '4') {
			return "Patient Picked Up";
		} else {
			return "N/A";
		}
	}

	function recallStatus(displayno, ticketno) {
		$.ajax({
			type: "POST",
			url: "dischargeQueueUpdate_ajax.jsp",
			data: "locid=<%=locid %>&queue=Q&ticketNo=" + ticketno + "&isPBO=<%=isPBO?"Y":"N" %>",
			success: function(values) {
<%	if (isPBO) { %>
				if (values == '2' || values == '3') {
<%	} else { %>
				if (values == '1' || values == '2' || values == '3' || values == '4') {
<%	} %>
					if (confirm('Re-Call from ' + getCurrentStatus(values) + ' to ' + getCurrentStatus(values - 1) + ' : ' + displayno)) {
						$.ajax({
							type: "POST",
							url: "dischargeQueueUpdate_ajax.jsp",
							data: "locid=<%=locid %>&queue=Z" + values + "&ticketNo=" + ticketno + "&isPBO=<%=isPBO?"Y":"N" %>",
							success: function(values) {
							}//success
						});//$.ajax
					}

				} else {
					alert('fail to recall.');
				}
			}//success
		});//$.ajax
	}

	function setInfoMessage(message) {
		document.getElementById("message").innerHTML = message;
		$("#message_div").dialog("open");
	}

	function setUpdateStatus(status, displayno, ticketno, refresh) {
		setUpdateStatusHelper(status, displayno, ticketno, '', refresh);
	}

	function showRemarkDialog() {
		clearComboBox();
		clearText();
//		document.getElementById("remark1").selectedIndex = 1;
		$("#dialog_div").dialog("open");
	}

	function setRemark() {
		var status = 'm';
		var displayno = document.getElementById("displayno").value;
		var ticketno = document.getElementById("ticketno").value;
		var remark = '';

		if (document.getElementById("remark2").value != "") {
			remark = document.getElementById("remark2").value;
		} else {
			remark = document.getElementById("remark1").value;
		}

		if (displayno != '' && ticketno != '') {
			setUpdateStatusHelper(status, displayno, ticketno, remark, true);
		} else {
			for (i = 0; i < multSelect1.length; i++) {
				setUpdateStatusHelper(status, multSelect2[i], multSelect1[i], remark, i < multSelect1.length - 1);
			}
			resetMultSelection();
		}
	}

	function setUpdateStatusHelper(status, displayno, ticketno, remark, refresh) {
		$.ajax({
			type: "POST",
			url: "dischargeQueueUpdate_ajax.jsp",
			data: "locid=<%=locid %>&queue=" + status.toUpperCase() + "&ticketNo=" + ticketno + "&isPBO=<%=isPBO?"Y":"N" %>&remark=" + remark,
			success: function(values) {
				if (values != '') {
					setInfoMessage(values);
					if (refresh) {
						timer(true);
					}
				}
			}//success
		});//$.ajax
	}

	function highlight(cell, newStatus) {
		if (multSelect1.length == 0) {
			unhighlight();

			if (updateStatus != newStatus) {
				updateStatus = newStatus;
				cell.style.fontWeight = 'bold';
				cell.style.fontWeight = 'bold';
				cell.style.border = '2px solid rgb(130,0,0)';
			} else {
				updateStatus = '';
			}
		} else {
			updateStatus = newStatus;
			updateDisplayType();

			displayTicketNos = '';
			for (i = 0; i < multSelect1.length; i++) {
				if (i > 0) displayTicketNos += ','
				displayTicketNos += multSelect2[i];
			}

			if (updateStatus == 'r') {
				if (confirm('Reprint : ' + displayTicketNos)) {
					for (i = 0; i < multSelect1.length; i++) {
						printPharmacyTicket(multSelect1[i]);
					}
				}
			} else if (updateStatus == 'z') {
				for (i = 0; i < multSelect1.length; i++) {
					recallStatus(multSelect2[i], multSelect1[i]);
				}
				timer(true);
			} else if (updateStatus == 'h') {
				for (i = 0; i < multSelect1.length; i++) {
					setUpdateStatus(updateStatus, multSelect2[i], multSelect1[i], i < multSelect1.length - 1);
				}
			} else if (updateStatus == 'm') {
				document.getElementById("displayno").value = '';
				document.getElementById("ticketno").value = '';
				showRemarkDialog();
			} else {
				if (confirm(displayType + ' : ' + displayTicketNos)) {
					completed = 0;
					arrayLen = multSelect1.length;
					for (i = 0; i < multSelect1.length; i++) {
						$.ajax({
							type: "POST",
							url: "dischargeQueueUpdate_ajax.jsp",
							data: "locid=<%=locid %>&queue=" + updateStatus + "&ticketNo=" + multSelect1[i] + "&isPBO=<%=isPBO?"Y":"N" %>",
							success: function(values) {
								completed++;
								if (completed >= multSelect1.length) {
									timer(true);
								}//if
							}//success
						});//$.ajax
					}
				}
			}

			if (updateStatus != 'm') {
				resetMultSelection();
			}
		}
	}

	function resetMultSelection() {
		// reset array
		updateStatus = '';
		multSelect1 = [];
		multSelect2 = [];
		timer(true);
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

	function getNativeCallUrl() {
		var newUrl = '<%=request.getRequestURL() %>';
		var index = newUrl.indexOf('/intranet');
		if (index > 0) {
			index = newUrl.indexOf('/', index + 1);
			if (index > 0) {
				reportUrl = 'NHSClientApp:PHARMACY:' + newUrl.substring(0, index) + '/report/';
			}
		}
	}

	getNativeCallUrl();

	function clearComboBox() {
		document.getElementById("remark1").selectedIndex = 0;
		return false;
	}

	function clearText() {
		document.getElementById('remark2').value = "";
		return false;
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
#button{
	cursor: pointer;
	opacity: 0.9;
	font-size: 32px;
	text-align: center;
}
#footer {
  position: fixed;
  left: 0;
  bottom: 0;
  width: 100%;
  background-color: red;
  color: white;
  text-align: center;
}
</style>
</head>
<body>
<table align="center" cellspacing="0" border="0" width="100%">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center" valign=middle bgcolor="#AA0066"><b><font face="AR PL SungtiL GB" size=5 color="#FFFFFF">Discharge Queue - <%=queueName %></font>&nbsp;<font color="red"><span id="barcode"></span></font></b></td>
	</tr>
</table>
<!-- index page -->

<table BORDER=2 id="lbUsers3" width="100%" border="1"></table>

<div id="footer">
<table id="table1" width="100%" border="0">
<%	if (isPBO) { %>
	<tr>
		<td width="33.3%" style="background-color:rgb(120,217,191); opacity:0.9;" onclick="highlight(this, 'h')"><div id="button">Start Processing</div></td>
		<td width="33.3%" style="background-color:rgb(177,217,088); opacity:0.9;" onclick="highlight(this, '3')"><div id="button">Completed</div></td>
		<td width="33.3%" style="background-color:rgb(210,117,141); opacity:0.9;" onclick="highlight(this, 'z')"><div id="button">Re-Call</div></td>
	</tr>
<%	} else { %>
	<tr>
		<td width="25%" style="background-color:red; opacity:0.9;" onclick="highlight(this, '-1')"><div id="button">Cancel Ticket</div></td>
		<td width="25%" style="background-color:rgb(233,203,217); opacity:0.9;" onclick="printNewPharmacyTicket('')"><div id="button">Ticket Generation</div></td>
		<td width="25%" style="background-color:yellow; opacity:0.9;' onclick="highlight(this, 'r')"><div id="button">Reprint</div></td>
		<td width="25%" style="background-color:rgb(210,117,141); opacity:0.9;" onclick="highlight(this, 'z')"><div id="button">Re-Call</div></td>
	</tr>
	<tr>
		<td width="25%" style="background-color:rgb(242,219,219); opacity:0.9;" onclick="highlight(this, '1')"><div id="button">Start Processing</div></td>
		<td width="25%" style="background-color:rgb(214,227,188); opacity:0.9;" onclick="highlight(this, '2')"><div id="button">To PBO</div></td>
		<td width="25%" style="background-color:rgb(198,217,241); opacity:0.9;" onclick="highlight(this, '4')"><div id="button">Patient Picked Up</div></td>
		<td width="25%" style="background-color:rgb(220,210,280); opacity:0.9;" onclick="highlight(this, 'm')"><div id="button">Remark</div></td>
	</tr>
<%	} %>
</table>
</div>
<div id="dialog_div">
<form name="form1">
Remarks:<br><br>
1) <select id="remark1" name="remark1" onchange="return clearText();">
	<option value=""></option>
	<option value="No medication for discharge">No medication for discharge</option>
	<option value="Pending Dr's reply">Pending Dr's reply</option>
	<option value="OB IV fluid charged">OB IV fluid charged</option>
	<option value="Pending OT record">Pending OT record</option>
	<option value="Pending med from ward">Pending med from ward</option>
	<option value="Pending anes record">Pending anes record</option>
	<option value="Pending allergy record">Pending allergy record</option>
</select><br>
<br>
Or<br>
<br>
2) Free Text: <input type="text" id="remark2" name="remark2" maxlength="60" size="30" onfocus="return clearComboBox();">
<input type="hidden" id="displayno" name="displayno">
<input type="hidden" id="ticketno" name="ticketno">
</form>
</div>
<div id="message_div">
<span id="message"></span>
</div>
</body>
</html>