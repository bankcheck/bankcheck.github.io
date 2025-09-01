<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@	page import="java.text.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.db.*" %>
<%@ page import="com.hkah.web.common.*" %>
<%@ page import="com.hkah.web.db.*"%>
<%!
	DecimalFormat noDigit = new DecimalFormat("#,##0");

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
String patno = request.getParameter("patno");
String day = request.getParameter("day");
String acmcode = request.getParameter("acmcode");
String acmdesc = request.getParameter("acmdesc");
String procedure1 = request.getParameter("procedure1");
String procedure2 = request.getParameter("procedure2");
String patfname = null;
String patgname = null;
String titleDesc = null;
String patcname = null;
String patidno = null;
String patsex = null;
String patbdate = null;

String ProFeeInput = request.getParameter("ProFeeInput");
String AnaesthetistFeeInput = request.getParameter("AnaesthetistFeeInput");
String DIInput = request.getParameter("DIInput");
String LabInput = request.getParameter("LabInput");
String OtherInput1 = request.getParameter("OtherInput1");
String totalInput = request.getParameter("totalInput");

String currentDate = DateTimeUtil.getCurrentDate();

ArrayList record = null;
if (patno != null) {
	record = AdmissionDB.getHATSPatient(patno, null, null);

	if (record != null && record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		patno = row.getValue(0);
		patfname = row.getValue(1);
		patgname = row.getValue(2);
		titleDesc = row.getValue(3);
		patcname = row.getValue(4);
		patidno = row.getValue(5);
		patsex = row.getValue(6);
		patbdate = row.getValue(9);
	}
}

String url = null;
String logo = null;
if (ConstantsServerSide.isTWAH()) {
	url = "http://www.twah.org.hk";
	logo = "twah_portal_logo.gif";
} else {
	url = "http://www.hkah.org.hk";
	logo = "hkah_portal_logo.gif";
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
		<title>Financial Estimation Form for Hospital Admission and Procedure / Surgery</title>
		<meta http-equiv="Content-Type" content="text/html; charset=big5">
		<meta http-equiv="Content-Type" content="text/html charset=UTF-8" /><!-- For ipad chinese -->
		<meta name = "format-detection" content = "telephone=no">
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9">
		<script src="./js/jquery-1.3.2.min.js" type="text/javascript"></script>
		<script src="./js/amcharts.js" type="text/javascript"></script>
        <script src="./js/serial.js" type="text/javascript"></script>
	<!--	<script type="text/javascript" src="jquery-1.10.2.js"></script>
		<script type="text/javascript" src="jquery-ui.js"></script>-->
		<link rel="stylesheet" href="./css/jquery-ui.css">


<style>
@media all {
	.page-break	{ display: none; }
}

@media print {
	.page-break	{ display: block; page-break-before: always; }
	#print_btn {display: none;}
}
body {
	/*background-color: #dddddd;*/
	background-color: #ffffff;
	font-size: 19px;
	line-height: 2.7;
	padding: 0;
	margin:0;
}
/*
#paper {
	width: 920px;
	background-color: #ffffff;
	margin: 0 auto;
	padding: 12px 0;
}
#form_wrapper {
	width: 85%;
	border: 1px solid black;
	margin: 0 auto;
}
*/
#form_wrapper {
	width: 920px;
	border: 2px solid black;
	margin: 0 auto;
}
.title {
	background-color: #bbbbbb;
	border-top: 1px solid black;
	border-bottom: 1px solid black;
	margin-top: 10px;
	padding: 0 5px 0 5px;
}
.content {
	padding: 0 5px 2px 5px;
}
#patientDetails_wrap {
	border:none;
	overflow:hidden;
	width: 100%;
	height: 100%
}
#patientDetails, #patientDetails td {
    border: 1px solid black;
    border-collapse: collapse;
}
#totalBox {
	 background-color: #bbbbbb;
	 border: 1px solid black;
	 width: 180px;
	 position:relative;
	 left:717px;
	 margin-top: 20px;
	 padding: 5px;
}

#formNo {
	font-size:0.9em;
	position: relative;
	top:-200px;
	width:150px;
	left: -14px;
	-ms-transform: rotate(-90deg); /* IE 9 */
    -webkit-transform: rotate(-90deg); /* Chrome, Safari, Opera */
    transform: rotate(-90deg);
}
.money {
	float:right;
}

#print_btn {
	position: fixed;
	width: 130px;
	z-index: 200;
	right: 20px;
	bottom: 20px;
	opacity: 0.5;
}
#print_btn:hover {
	opacity: 1;
	cursor: pointer;
}
ol {
	line-height:1.3;
	margin: 25px;
}
li {
	padding-bottom: 20px;
}
</style>

<script language=Javascript>

$(document).ready(function() { 	// to show border in empty <td>
      $("td:empty").html("&nbsp;");
});
</script>
</head>
<body>
	<div id="paper">
	<div id="form_wrapper">
		<table width="100%" border="0">
			<tr>
				<td>
					<img src="../images/<%=logo %>" width="250" height="70">
				</td>
			</tr>
		</table>

		<div id="header" class="content" style="line-height: 1.6; padding-right:0;">
			<table width="100%" border="0">
				<tr>
					<td><center><b>接受手術/入侵性醫療程序同意書</center></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</div>

		<div class="content">
			<table width="100%" border="0" style="line-height: 1.2;">
				<tr>
					<td width="8%">(1)(A)</td><td>本人， <u><%=patfname==null?"":patfname %> <%=patgname==null?"":patgname %></u> (病人姓名)，在此同意接受由 __________________ 醫生為本人施行</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td><td>_______________________________________________________________________________並使用</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td><td>全身麻醉 / 區域麻醉 / 局部麻醉 / 監察麻醉 / 靜脈注射麻醉藥物 / 無麻醉方式。</td>
				</tr>
				<tr>
					<td colspan="2">或</td>
				</tr>
				<tr>
					<td>(1)(B)</td><td>本人，_______________________為 <u><%=patfname==null?"":patfname %> <%=patgname==null?"":patgname %></u> (病人姓名)之父親 / 母親 / 監護</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td><td>人，在此代表病人同意接受由 _________________________ 醫生替其施行</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td><td>_______________________________________________________________________________並使用</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td><td>全身麻醉 / 區域麻醉 / 局部麻醉 / 監察麻醉 / 靜脈注射麻醉藥物 / 無麻醉方式。</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">(2)(B)</td>
					<td>
						<table>
							<tr>
								<td colspan="2">本人確認在簽署此同意書前，已獲得有關此手術 / 醫療程序之資料，包括：</td>
							</tr>
							<tr>
								<td valign="top">a)</td><td>需要進行是項手術 / 醫療程序之原因</td>
							</tr>
							<tr>
								<td valign="top">b)</td><td>是項手術 / 醫療程序之性質</td>
							</tr>
							<tr>
								<td valign="top">c)</td><td>是項手術 / 醫療程序可能引致的危險及併發症，包括但不限於出血、傷口感染、肺炎、其他感染、心臟病發、中風、 大腿靜脈栓塞、肺血管栓塞、以及死亡</td>
							</tr>
							<tr>
								<td valign="top">d)</td><td>是項手術 / 醫療程序及與病人情況有關之潛在危險及併發症</td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td><td style="border-bottom: 1px solid black; margin:0 5px;"></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td><td style="border-bottom: 1px solid black; margin:0 5px;"></td>
							</tr>
							<tr>
								<td>e)</td><td>其他治療方法及不接受治療所帶來的後果</td>
							</tr>
							<tr>
								<td>f)</td><td>是項手術 / 醫療程序在進行中或完成後可能需要的額外治療 /手術， 包括</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>
									<table width="100%" border="0">
										<tr>
											<td width="10%">□&nbsp;深切治療</td><td width="10%">□&nbsp;輸血</td><td width="20%">□&nbsp;由微創轉為開腔手術</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td><td>(請 √ 適用項目或列明其他適用之治療__________________________________________________)</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">(3)</td>
					<td>
						<table>
							<tr>
								<td colspan="2">本人明白</td>
							</tr>
							<tr>
								<td valign="top">a)</td><td>如有需要，除上述醫生外，可能需要其他醫生參與是項手術 / 醫療程序</td>
							</tr>
							<tr>
								<td valign="top">b)</td><td>若在手術期間有身體器官或組織被切除，這些器官或組織可能被棄置，或先作病理化驗，然後被棄置。</td>
							</tr>
							<tr>
								<td valign="top">c)</td><td>是項手術 / 醫療過程可能會被攝影或錄影以作存檔或教學用途，如屬後者，病人之身份將不會被公開或識別。</td>
							</tr>
							<tr>
								<td valign="top">d)</td><td>進行是項手術 / 醫療程序，並不保證病人情況或以後病况會改善</td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td><td style="border-bottom: 1px solid black; margin:0 5px;"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">(4)</td>
					<td>若是進行絕育手術，本人明白手術後可能仍有生育能力 (如不適用可删除).</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">(5)</td>
					<td>本人確認收到有關是項手術/醫療程序的資料單張(編號:____________________)，並已閱讀及完全明白其內容 (如不適用可刪除)</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">
						<table width="100%">
							<tr>
								<td>_____________________________________________</td><td>_____________________________________________</td>
							</tr>
							<tr>
								<td>病人 / 父母 / 監護人簽署</td><td>見證人簽署(証明病人/父母/監護人簽署之見證人)</td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td>_____________________________________________</td><td>_____________________________________________</td>
							</tr>
							<tr>
								<td>病人 / 父母 / 監護人姓名</td><td>見證人姓名</td>
							</tr>
							<tr>
								<td>身份証/護照號碼：</td><td>日期︰<%=DateTimeUtil.getCurrentDate() %></td>
							</tr>
							<tr>
								<td colspan="2">日期︰<%=DateTimeUtil.getCurrentDate() %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">
						<table width="100%">
							<tr>
								<td valign="top" width="12%">醫生聲明︰</td>
								<td>本人已向上述之病人解釋是項手術/醫療程序的性質、風險及效益，並已解答其提出的有關問題。據本人所理解，病人已獲得充分的資料及已簽妥同意書，而這些資料亦已記錄在病人的病歷內。</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">____________________________________________________</td>
				</tr>
				<tr>
					<td colspan="2">醫生簽署</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">____________________________________________________</td>
				</tr>
				<tr>
					<td colspan="2">醫生姓名</td>
				</tr>
				<tr>
					<td colspan="2">日期︰<%=DateTimeUtil.getCurrentDate() %></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">本人，____________________________ 已向簽署人如實地及清楚地將此同意書的內容翻譯成______________(語言或方言)。</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">____________________________________________________</td>
				</tr>
				<tr>
					<td colspan="2">翻譯員簽署</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">____________________________________________________</td>
				</tr>
				<tr>
					<td colspan="2">翻譯員姓名</td>
				</tr>
				<tr>
					<td colspan="2">日期︰<%=DateTimeUtil.getCurrentDate() %></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</table>
		</div>
	</div> <!-- form wrapper -->

	<table width="920px" border="1" style="margin: 0 auto; padding:1; line-height: 1.2; font-size:0.9em;">
		<tr>
			<td width="50%">
				<table width="100%" border="0">
					<tr>
						<td>Patient No.:</td><td><%=patno==null?"":patno %></td>
					</tr>
					<tr>
						<td>Name:</td><td><%=patfname==null?"":patfname %> <%=patgname==null?"":patgname %></td>
					</tr>
					<tr>
						<td>Date of Birth:</td><td><%=patbdate==null?"":patbdate %></td>
					</tr>
					<tr>
						<td>Gender:</td><td><%=patsex==null?"":patsex %></td>
					</tr>
					<tr>
						<td>Room No.:</td><td>&nbsp;</td>
					</tr>
				</table>
			</td>
			<td width="50%">
				<table width="100%">
					<tr>
						<td><center>接受手術/入侵性醫療程序同意書</center></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td><center><img src="consent1_barcode.png"></center></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

	<table width="920px" style="margin: 0 auto; padding:0; line-height: 1.1; font-size:0.9em;">
		<tr>
			<td width="33%"><!--Effective since 15-08-2015<br/>-->Printed at: <%=DateTimeUtil.getCurrentDateTimeWithoutSecond() %>&nbsp;<!--<br/>CHM-035m-15-2898(R2)--></td>
			<!--<td width="33%" style="text-align:center;">Approved by CHM&MD</td>-->
			<td width="33%" style="text-align:right;"><!--Page 1 of 2<br/>--><div style="display: inline; float: right;" id="bcTarget"><img src="consent2_barcode.png"></div>   </td>
		</tr>
	</table>

	</div> <!-- paper -->
	<img id='print_btn' src="../images/print.jpg" onclick="javascript:print_rpt();"/ >
</body>

<script language=Javascript>
$("#bcTarget").barcode("720-a", "code39",{barWidth:2, barHeight:16});

function ReplaceURL(A) {
	if(A == '') {
		return '';
	} else {
		return A.replace(/\%/gi, '%25').replace(/&/gi, '%26').replace(/\+/gi, '%2B').replace(/\ /gi, '%20').replace(/\//gi, '%2F').replace(/\#/gi, '%23').replace(/\=/gi, '%3D');
	}
}

function print_rpt() {
	window.print();
}

function commaSeparateNumber(val){
	while (/(\d+)(\d{3})/.test(val.toString())){
		val = val.toString().replace(/(\d+)(\d{3})/, '$1'+','+'$2');
	}
	return val;
}

</script>
</html>