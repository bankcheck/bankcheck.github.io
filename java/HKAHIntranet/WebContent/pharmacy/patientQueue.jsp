<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%
String locid = request.getParameter("locid");
String locDesc = null;
boolean isNWStyle = false;
int collen = 17;
if (locid != null && "NW".equals(locid)) {
	locDesc = "New Wing";
//	isNWStyle = true;
//	collen = 14;
} else {
	locDesc = "Old Wing";
	locid = "OW";
//	isNWStyle = false;
//	collen = 17;
}
String queue = request.getParameter("queue");
String queueName = null;
if ("2".equals(queue) || "3".equals(queue)) {
	queue = "3";
	queueName = "Charge Slip Collection";
} else if ("4".equals(queue)) {
	queueName = "Medication Collection after Payment";
} else if ("0".equals(queue)) {
	queueName = "Done";
} else if ("-1".equals(queue)) {
	queueName = "Cancel";
} else {
	queue = "1";
	queueName = "Prescription Verification";
}
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
				url: "patientQueue_ajax.jsp",
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
<%	if ("1".equals(queue)) { %>
				$.ajax({
					type: "POST",
					url: "patientUpdateQueue_ajax.jsp",
					data: "locid=<%=locid %>&queue=",
					success: function(values) {
						if (values != '') {
							timer(true);
							printPharmacyTicket(values);
						}//if
					}//success
				});//$.ajax
<%	} %>
			} else {
				// check the keys pressed are numbers or 'A'
				if ((e.which >= 48 && e.which <= 57) || (e.which >= 65 && e.which <= 90) || (e.which >= 97 && e.which <= 122)) {
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
								url: "patientUpdateQueue_ajax.jsp",
								data: "locid=<%=locid %>&queue=<%=queue %>&ticketNo=" + barcode,
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

	function updateDisplayType() {
		if (updateStatus == '-1') {
			displayType = 'Cancel';
		} else if (updateStatus == '0') {
			displayType = 'Done';
		} else if (updateStatus == '1') {
			displayType = 'Prescription Verification';
		} else if (updateStatus == '2') {
			displayType = 'Dispensing';
		} else if (updateStatus == '3') {
			displayType = 'Charge Slip Collection';
		} else if (updateStatus == '4') {
			displayType = 'Medication Collection after Payment';
		} else if (updateStatus == 'r') {
			displayType = 'Reprint';
		} else {
			displayType = '';
		}
	}

	function performAction(ticketno) {
		updateDisplayType();

		if (displayType != '') {
			if (updateStatus == 'r') {
				if (confirm('Reprint : ' + ticketno)){
					printPharmacyTicket(ticketno);
				}
			} else {
				if (confirm(displayType + ' : ' + ticketno)){
					$.ajax({
						type: "POST",
						url: "patientUpdateQueue_ajax.jsp",
						data: "locid=<%=locid %>&queue=" + updateStatus + "&ticketNo=" + ticketno,
						success: function(values) {
							if (values != '') {
								timer(true);
							}//if
						}//success
					});//$.ajax
				} else {
					timer(true);
				}
			}
		} else {
			searchArray = -1;
			for (i = 0; searchArray == -1 && i < multSelect.length; i++) {
				if (ticketno == multSelect[i]) {
					searchArray = i;
				}
			}
			if (searchArray == -1) {
				document.getElementById(ticketno + '-all').style.background = '#FEFFCF';
				multSelect[multSelect.length] = ticketno;
			} else {
				document.getElementById(ticketno + '-all').style.background = '#FFFFFF';
				multSelect.splice(searchArray, 1);
			}
		}
	}
/*
	function im1() {
		if (messagei.length<6) {
			messagei=messagei+"1";
		} else {
			messagei='';
		}
		$('#lbUsers7').html('')
		$('#lbUsers7').append("<font color='Black' SIZE='5'>"+messagei+"</font>");
	}

	function im2() {
		if (messagei.length<6) {
			messagei=messagei+"2";
		} else {
			messagei='';
		}
		$('#lbUsers7').html('')
		$('#lbUsers7').append("<font color='Black' SIZE='5'>"+messagei+"</font>");
	}

	function im3() {
		if (messagei.length<6) {
			messagei=messagei+"3";
		} else {
			messagei='';
		}
		$('#lbUsers7').html('')
		$('#lbUsers7').append("<font color='Black' SIZE='5'>"+messagei+"</font>");
	}

	function im4() {
		if (messagei.length<6) {
			messagei=messagei+"4";
		} else {
			messagei='';
		}
		$('#lbUsers7').html('')
		$('#lbUsers7').append("<font color='Black' SIZE='5'>"+messagei+"</font>");
	}

	function im5() {
		if (messagei.length<6) {
			messagei=messagei+"5";
		} else {
			messagei='';
		}
		$('#lbUsers7').html('')
		$('#lbUsers7').append("<font color='Black' SIZE='5'>"+messagei+"</font>");
	}

	function im6() {
		if (messagei.length<6) {
			messagei=messagei+"6";
		} else {
			messagei='';
		}
		$('#lbUsers7').html('')
		$('#lbUsers7').append("<font color='Black' SIZE='5'>"+messagei+"</font>");
	}

	function im7() {
		if (messagei.length<6) {
			messagei=messagei+"7";
		} else {
			messagei='';
		}
		$('#lbUsers7').html('')
		$('#lbUsers7').append("<font color='Black' SIZE='5'>"+messagei+"</font>");
	}

	function im8() {
		if (messagei.length<6) {
			messagei=messagei+"8";
		} else {
			messagei='';
		}
		$('#lbUsers7').html('')
		$('#lbUsers7').append("<font color='Black' SIZE='5'>"+messagei+"</font>");
	}

	function im9() {
		if (messagei.length<6) {
			messagei=messagei+"9";
		} else {
			messagei='';
		}
		$('#lbUsers7').html('')
		$('#lbUsers7').append("<font color='Black' SIZE='5'>"+messagei+"</font>");
	}

	function im0() {
		if (messagei.length<6) {
			messagei=messagei+"0";
		} else {
			messagei='';
		}
		$('#lbUsers7').html('')
		$('#lbUsers7').append("<font color='Black' SIZE='5'>"+messagei+"</font>");
	}
*/
	function highlight(cell, newStatus) {
		if (multSelect.length == 0) {
			unhighlight();

			if (updateStatus != newStatus) {
				updateStatus = newStatus;
				cell.style.fontWeight = 'bold';
					if (updateStatus == 'r') {
						cell.style.background = '#F4F2F2';
					} else if (updateStatus == '-1') {
						cell.style.background = '#F41010';
					} else if (updateStatus == '1') {
						cell.style.background = '#F7C59D';
					} else if (updateStatus == '2') {
						cell.style.background = '#E6A9B8';
					} else if (updateStatus == '3') {
						cell.style.background = '#A793C3';
					} else if (updateStatus == '4') {
						cell.style.background = '#8649A3';
					} else if (updateStatus == '0') {
						cell.style.background = '#EEF028';
					}
			} else {
				updateStatus = '';
			}
		} else {
			updateStatus = newStatus;
			updateDisplayType();

			displayTicketNos = '';
			for (i = 0; i < multSelect.length; i++) {
				if (i > 0) displayTicketNos += ','
				displayTicketNos += multSelect[i];
			}

			if (updateStatus == 'r') {
				if (confirm('Reprint : ' + displayTicketNos)){
					for (i = 0; i < multSelect.length; i++) {
						printPharmacyTicket(multSelect[i]);
					}
				}
			} else {
				if (confirm(displayType + ' : ' + displayTicketNos)){
					completed = 0;
					arrayLen = multSelect.length;
					for (i = 0; i < multSelect.length; i++) {
						$.ajax({
							type: "POST",
							url: "patientUpdateQueue_ajax.jsp",
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
				if (j == 0) {
					col.style.background = 'white';
				} else if (j == 1) {
					col.style.background = 'red';
				} else if (j == 2) {
					col.style.background = '#FCD5B5';
				} else if (j == 3) {
<%	if (isNWStyle) { %>
					col.style.background = '#E6B9B8';
				} else if (j == 4) {
					col.style.background = '#B3A2C7';
				} else if (j == 5) {
					col.style.background = '#6F4084';
				} else if (j == 6) {
					col.style.background = 'yellow';
<%	} else { %>
					col.style.background = '#B3A2C7';
				} else if (j == 4) {
					col.style.background = '#6F4084';
				} else if (j == 5) {
					col.style.background = 'yellow';
<%	} %>
				}
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
<table align="center" cellspacing="0" border="0" width="100%">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center" valign=middle bgcolor="#AA0066"><b><font face="AR PL SungtiL GB" size=5 color="#FFFFFF"><%=queueName %> -- <%=locDesc %></font>&nbsp;<font color="red"><span id="barcode"></span></font></b></td>
	</tr>
</table>
<!-- index page -->

<table BORDER=2 id="lbUsers3" width="100%" border="1"></table>

<object id="HKAHIntranetApplet-object" name="HKAHIntranetApplet"
	width="0" height="0"
	classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93"
	codebase="http://java.sun.com/update/1.7.0/jinstall-7u65-windows-i586.cab#Version=1,7,0,0"
	type="application/x-java-applet;version=1.6"
	style="width: 0px; height: 0px; float: left;">
	<param name="archive" value="
		../applet/HKAHIntranetApplet.jar,
		../applet/jasperreports-4.0.1.jar,
		../applet/commons-collections-3.2.1.jar,
		../applet/commons-digester-1.7.jar,
		../applet/commons-logging-1.1.1.jar" />
	<param name="code" value="com.hkah.applet.HKAHIntranetApplet.class" />
	<embed id="HKAHIntranetApplet-embed"
		type="application/x-java-applet;version=1.6"
		width="0" height="0"
		archive="
			../applet/HKAHIntranetApplet.jar,
			../applet/jasperreports-4.0.1.jar,
			../applet/commons-collections-3.2.1.jar,
			../applet/commons-digester-1.7.jar,
			../applet/commons-logging-1.1.1.jar"
		code="com.hkah.applet.HKAHIntranetApplet.class"
		pluginspage="http://java.com/download/" />
</object>

<div id="Footer">
<table id="table1" width="100%" border="0">
	<tr>
		<td width=15% style='background-color:white' onclick='highlight(this, "r")'><center><font color='black' SIZE='6'>Reprint</font></center></td>
		<td width=<%=collen %>% style='background-color:red' onclick='highlight(this, "-1")'><center><font color='white' SIZE='6'>Cancel</font></center></td>
		<td width=<%=collen %>% style='background-color:#FCD5B5;opacity:0.9;' onclick='highlight(this, "1")'><center><font color='black' SIZE='6'>Prescription Verification</font></center></td>
<%	if (isNWStyle) { %>
		<td width=<%=collen %>% style='background-color:#E6B9B8;opacity:0.9;' onclick='highlight(this, "2")' ><center><font color='black' SIZE='6'>Dispensing</font></center></td>
<%	} %>
		<td width=<%=collen %>% style='background-color:#B3A2C7;opacity:0.9;' onclick='highlight(this, "3")'><center><font color='black' SIZE='6'>Charge Slip Collection</font></center></td>
		<td width=<%=collen %>% style='background-color:#6F4084;opacity:0.9;' onclick='highlight(this, "4")'><center><font color='black' SIZE='6'>Medication Collection after Payment</font></center></td>
		<td width=15% style='background-color:yellow;opacity:0.9;' onclick='highlight(this, "0")'><center><font color='brown' SIZE='6'>Done</font></center></td>
	</tr>
<!--
	<tr>
		<td id="lbUsers7"></td>
		<td COLSPAN=5>
			<table id="keypad" width="100%" >
				<td onclick='im1()'>1</td>
				<td onclick='im2()'>2</td>
				<td onclick='im3()'>3</td>
				<td onclick='im4()'>4</td>
				<td onclick='im5()'>5</td>
				<td onclick='im6()'>6</td>
				<td onclick='im7()'>7</td>
				<td onclick='im8()'>8</td>
				<td onclick='im9()'>9</td>
				<td onclick='im0()'>0</td>
				<td onclick='ime()'>OUT</td>
			</table>
		</td>
		<td id="lbUsers8"></td>
	</tr>
-->
</table>
</div>

</body>
</html>