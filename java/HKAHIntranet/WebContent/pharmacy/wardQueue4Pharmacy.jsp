<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%
String queue = request.getParameter("queue");
String queueName = null;
if ("2".equals(queue)) {
	queueName = "Ready for Pick Up";
} else {
	queue = "1";
	queueName = "Fax Received";
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
<script type="text/javascript" src="../js/jquery-1.5.1.min.js" /></script>
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
		if (multSelect1.length == 0) {
			$.ajax({
				type: "POST",
				url: "wardQueue_ajax.jsp",
				data: "table=" + table + "<%=filter?"&filter=Y":"" %><%=resize?"&resize=Y":"" %>",
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
								data: "locid=&queue=<%=queue %>&ticketNo=" + barcode,
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
			displayType = 'Fax Received';
		} else if (updateStatus == '2') {
			displayType = 'Ready for Pick Up';
		} else if (updateStatus == '4') {
			displayType = 'N/A';
		} else {
			displayType = '';
		}
	}

	function performAction(displayno, ticketno) {
		updateDisplayType();

		if (displayType != '') {
			if (confirm(displayType + ' : ' + displayno)){
				$.ajax({
					type: "POST",
					url: "patientUpdateQueue2_ajax.jsp",
					data: "locid=&queue=" + updateStatus + "&ticketNo=" + ticketno,
					success: function(values) {
						if (values != '') {
							timer(true);
						}//if
					}//success
				});//$.ajax
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

			if (confirm(displayType + ' : ' + displayTicketNos)){
				completed = 0;
				arrayLen = multSelect1.length;
				for (i = 0; i < multSelect1.length; i++) {
					$.ajax({
						type: "POST",
						url: "patientUpdateQueue2_ajax.jsp",
						data: "locid=&queue=" + updateStatus + "&ticketNo=" + multSelect1[i],
						success: function(values) {
							completed++;
							if (completed >= multSelect1.length) {
								timer(true);
							}//if
						}//success
					});//$.ajax
				}
			}
			// reset array
			updateStatus = '';
			multSelect1 = [];
			multSelect2 = [];
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
<table align="center" cellspacing="0" border="0" width="100%">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center" valign=middle bgcolor="#AA0066"><b><font face="AR PL SungtiL GB" size=5 color="#FFFFFF">Ward Queue - <%=queueName %></font>&nbsp;<font color="red"><span id="barcode"></span></font></b></td>
	</tr>
</table>
<!-- index page -->

<table BORDER=2 id="lbUsers3" width="100%" border="1"></table>

<div id="Footer">
<table id="table1" width="100%" border="0">
	<tr>
		<td width=25% style='background-color:red;opacity:0.9;' onclick='highlight(this, "-1")'><center><font color='black' SIZE='6'>Cancel Ticket</font></center></td>
		<td width=25% style='background-color:rgb(242,219,219);opacity:0.9;' onclick='highlight(this, "1")'><center><font color='black' SIZE='6'>Fax Received</font></center></td>
		<td width=25% style='background-color:rgb(214,227,188);opacity:0.9;' onclick='highlight(this, "2")'><center><font color='black' SIZE='6'>Ready for Pick Up</font></center></td>
		<td width=25% style='background-color:rgb(227,108,10);opacity:0.9;' onclick='highlight(this, "4")'><center><font color='black' SIZE='6'>N/A</font></center></td>
	</tr>
</table>
</div>

</body>
</html>