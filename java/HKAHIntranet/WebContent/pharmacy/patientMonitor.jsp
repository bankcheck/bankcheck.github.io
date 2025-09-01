<%@ page language="java" contentType="text/html; charset=utf-8" %>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<meta http-equiv="refresh" content="3000" />
<script type="text/javascript" src="../js/jquery-1.5.1.min.js" /></script>
<script type="text/javascript">
<!--//
	var wait = 5 * 1000;
	var table = 0;
	var refreshNow = 0;
	$('#lbUsers3').html("");
	$('#lbUsers5').html("");

	function timer() {
		$.ajax({
			type: "POST",
			url: "patientMonitor_ajax.jsp",
			data: "table=" + table,
			success: function(values) {
				if (values != '') {
					if (table % 2 == 0) {
						$('#lbUsers3').html(values);
						$('#lbUsers5').html("") ;
						table++;

						// refresh table 2 at once
						timer();
					} else {
						$('#lbUsers5').html(values);
						table++;

						// refresh table 1 after timeout
						window.setTimeout("timer()", wait);
					}
				} else {
					refreshNow = 0;
					if (table % 2 == 0) {
						$('#lbUsers3').html("") ;
						$('#lbUsers5').html("") ;
						if (table != 0) {
							refreshNow = 1;
						}
					} else {
						$('#lbUsers5').html("");
					}
					table = 0;

					if (refreshNow == 1) {
						// refresh table 2 at once
						timer();
					} else {
						// back to table 1 after timeout
						window.setTimeout("timer()", wait);
					}
				}//if
			}//success
		});//$.ajax
	}

	function startTimer() {
		timer();
	}


	$(document).ready(function () {
		startTimer();
		defineGetElementsByClassName();
		resetblinkFont();
	});

	function blinkFont() {
		var elements = document.getElementsByClassName("blink");
		for (var i = 0; i < elements.length; i++) {
			document.getElementById(elements[i].id).style.KhtmlOpacity='0.9';
			document.getElementById(elements[i].id).style.opacity='0.9';
//			document.getElementById(elements[i].id).style.background='#6F4084';
		}
		setTimeout("resetblinkFont()", 500);
	}

	function resetblinkFont() {
		var elements = document.getElementsByClassName("blink");
		for (var i = 0; i < elements.length; i++) {
			document.getElementById(elements[i].id).style.KhtmlOpacity='0.0';
			document.getElementById(elements[i].id).style.opacity='0.0';
//			document.getElementById(elements[i].id).style.background='#FFFFFF';
		}
		setTimeout("blinkFont()", 500);
	}

	function defineGetElementsByClassName() {
		// define 'getElementsByClassName' - isn't supported in IE web browser
		if (!document.getElementsByClassName) {
			document.getElementsByClassName = function (className) {
				return this.querySelectorAll("." + className);
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
#wrapper2 {
	position: absolute;
	z-index: 1;
	top: 80px;
	bottom: 0;
	left: 6px;
	right: 0px;
	height:100%;
	width: 100%;
	overflow: auto;
	padding:0px;
}
#scroller2 {
	width:200px;
	height:5000px;

	padding:0;
}
#wrapper3 {
	position:absolute;
	z-index:1;
	top: 80px;
	left: 17%;
	right: 0px;
	width: 100%;
	height:100%;
	overflow:hidden;
}
#scroller3 {
	width:41%;
	height:5000px;
	padding:0;
}
#wrapper5 {
	position: absolute;
	z-index: 1;
	top: 80px;
	bottom: 0;
	left: 58%;
	right: 0px;
	height:100%;
	width: 100%;
	overflow: auto;
	padding:0px;
}
#scroller5 {
	width:41%;
	height:5000px;

	padding:0;
}
#table1 {
	position:absolute;
	width:100%;
	bottom:0; /* stick to bottom */
	background-color:Yellow;
	border-top:3px solid #333;
	height:10%;
	z-index:10;
}
	.box{border:1px solid #CCC;
}
.selected{
	background-color:yellow;
}
</style>
</head>
<body>
<!-- index page -->
<table align="center" cellspacing="0" border="0" width="100%">
	<tr>
		<td colspan="3"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="3" align="center" valign=middle colspan="3"><b><font face="AR PL SungtiL GB" size=5 color="#AA0066">Prescription Processing 配藥流程</font></b></td>
	</tr>
	<tr>
		<td align="center" valign=middle bgcolor="#1E9BA0" width="300" height="25"><b><font face="AR PL SungtiL GB" size=5 color="#FFFFFF">Processes 流程</font></b></td>
		<td align="center" valign=middle bgcolor="#FFFFFF" width="10" height="25"></td>
		<td align="center" valign=middle bgcolor="#AA0066"><b><font face="AR PL SungtiL GB" size=5 color="#FFFFFF">Outpatient 門診</font></b></td>
	</tr>
</table>

<div id="wrapper2">
<div id="scroller2">
<table BORDER=0 id="lbUsers2" width="100%">
	<tr><td><img src="images/IMG_4657 b.jpg" alt="Process 1" style="width:300px;height:210px;"></td></tr>
	<!--tr><td><img src="images/IMG_4660.jpg" alt="Process 2" style="width:300px;height:210px;"></td></tr-->
	<tr><td><img src="images/IMG_4661.jpg" alt="Process 3" style="width:300px;height:210px;"></td></tr>
	<tr><td><img src="images/IMG_4662.jpg" alt="Process 4" style="width:300px;height:210px;"></td></tr>
</table>
</div>
</div>

<div id="wrapper3">
<div id="scroller3">
<table BORDER=0 id="lbUsers3" width="100%">
</table>
</div>
</div>

<div id="wrapper5">
<div id="scroller5">
<table BORDER=0 id="lbUsers5" width="100%" >
</table>
</div>
</div>

<div id="Footer">
<table id="table1" width="100%">
	<tr>
		<td height="20" align="left" valign=middle bgcolor="#595959"><b><font face="AR PL SungtiL GB" size=4 color="#FFFFFF">如屏幕顯示剔號<img src="../images/tick_amber_small.gif">，請到藥劑部排隊取藥。<font face="AR PL SungtiL GB" size=4 color="#FFFFFF">藥單完成後兩小時，票號將不再顯示於屏幕中，請直接到藥劑部與職員聯絡。</font></b></td>
	</tr>
	<tr>
		<td height="20" align="left" valign=middle bgcolor="#595959"><b><font face="微軟正黑體" size=4 color="#FFFFFF">Please proceed to pharmacy to pick up your medications when <img src="../images/tick_amber_small.gif"> shows up.</font><font face="微軟正黑體" size=4 color="#FFFFFF">Your ticket number will be automatically removed from the screen after 2 hours of processing.</font></b></td>
	</tr>
</table>
</div>

</body>
</html>