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
	String emptyStr = "--";

	private String checkNumber(String str) {
		if (str == null || str.length() == 0 || emptyStr.equals(str)) {
			return ConstantsVariable.ZERO_VALUE;
		} else {
			return str;
		}
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

	private String getValueForReportWithCurrency(String minValue, String maxValue){
		String returnValue = null;
		if (minValue != null && minValue.length() > 0 && !"0".equals(minValue)
			&& maxValue != null && maxValue.length() > 0 && !"0".equals(maxValue)
			&& !minValue.equals(maxValue)) {
			returnValue = "$" + currencyFormat(minValue) + " ~ " + currencyFormat(maxValue);
		} else if (minValue != null && minValue.length() > 0 && !"0".equals(minValue)) {
			returnValue = "$" + currencyFormat(minValue);
		} else if (maxValue != null && maxValue.length() > 0 && !"0".equals(maxValue)) {
			returnValue = "$" + currencyFormat(maxValue);
		} else {
			returnValue = "--";
		}
		return returnValue;
	}

	private ArrayList<ReportableListObject> fetchPatient(String patno) {
		return UtilDBWeb.getReportableListHATS("SELECT PATFNAME || ' ' || PATGNAME, PATCNAME, PATIDNO, MOTHCODE FROM PATIENT WHERE PATNO = ?", new String[] { patno });
	}

	private ArrayList<ReportableListObject> fetchDoctor(String doccode) {
		return UtilDBWeb.getReportableListHATS("SELECT DOCFNAME || ' ' || DOCGNAME, DOCCNAME FROM DOCTOR WHERE DOCCODE = ?", new String[] { doccode });
	}

	private String fetchProcedureDesc(String procedure) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListHATS("SELECT PROCDESC FROM FIN_PROC WHERE PROCCODE = ?", new String[] { procedure });
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return "";
		}
	}

	private void saveQuotation(UserBean userBean, String patno, String patname, String patcname, String patidno, String doccode,
			String proccode, String diagnosis, String los, String acmcode, String rangeFrom,
			String rangeTo, String hcopy, String pcopy, String drrnddaysummin1, String drrnddaysummax1,
			String profeemin, String profeemax, String anaesthetistfeemin, String anaesthetistfeemax, String othermin1,
			String othermax1, String othermin2, String othermax2, String drrnddaysummin2, String drrnddaysummax2,
			String otmin, String otmax, String othermin3, String othermax3, String totalmin,
			String totalmax, String profeemint, String profeemaxt, String anaesthetistfeemint, String anaesthetistfeemaxt,
			String otmint, String otmaxt, String othermin3t, String othermax3t, String totalmint,
			String totalmaxt, String profeeminp, String profeemaxp, String anaesthetistfeeminp, String anaesthetistfeemaxp,
			String otminp, String otmaxp, String othermin3p, String othermax3p, String totalminp,
			String totalmaxp) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO FIN_QUOTATION (");
		sqlStr.append("PATNO, PATNAME, PATCNAME, PATIDNO, DOCCODE, ");	// 1
		sqlStr.append("PROCCODE, DIAGNOSIS, LOS, ACMCODE , RANGEFROM, ");	// 2
		sqlStr.append("RANGETO, HCOPY, PCOPY, DRRNDDAYSUMMIN1, DRRNDDAYSUMMAX1, ");	// 3
		sqlStr.append("PROFEEMIN, PROFEEMAX, ANAESTHETISTFEEMIN, ANAESTHETISTFEEMAX, OTHERMIN1, ");	// 4
		sqlStr.append("OTHERMAX1, OTHERMIN2, OTHERMAX2, DRRNDDAYSUMMIN2, DRRNDDAYSUMMAX2, ");	// 5
		sqlStr.append("OTMIN, OTMAX, OTHERMIN3, OTHERMAX3, TOTALMIN, ");	// 6
		sqlStr.append("TOTALMAX, PROFEEMINT, PROFEEMAXT, ANAESTHETISTFEEMINT, ANAESTHETISTFEEMAXT, ");	// 7
		sqlStr.append("OTMINT, OTMAXT, OTHERMIN3T, OTHERMAX3T, TOTALMINT, ");	// 8
		sqlStr.append("TOTALMAXT, PROFEEMINP, PROFEEMAXP, ANAESTHETISTFEEMINP, ANAESTHETISTFEEMAXP, ");	// 9
		sqlStr.append("OTMINP, OTMAXP, OTHERMIN3P, OTHERMAX3P, TOTALMINP, ");	// 10
		sqlStr.append("TOTALMAXP, CREATE_USER");	// 11
		sqlStr.append(") VALUES (");
		sqlStr.append("?, ?, ?, ?, ?,");	// 1
		sqlStr.append("?, ?, ?, ?, ?,");	// 2
		sqlStr.append("?, ?, ?, ?, ?,");	// 3
		sqlStr.append("?, ?, ?, ?, ?,");	// 4
		sqlStr.append("?, ?, ?, ?, ?,");	// 5
		sqlStr.append("?, ?, ?, ?, ?,");	// 6
		sqlStr.append("?, ?, ?, ?, ?,");	// 7
		sqlStr.append("?, ?, ?, ?, ?,");	// 8
		sqlStr.append("?, ?, ?, ?, ?,");	// 9
		sqlStr.append("?, ?, ?, ?, ?,");	// 10
		sqlStr.append("?, ?)");

		UtilDBWeb.updateQueueHATS(
			sqlStr.toString(),
			new String[] {
				patno, patname, patcname, patidno, doccode,	// 1
				proccode, diagnosis, los, acmcode, rangeFrom,	// 2
				rangeTo, hcopy, pcopy, checkNumber(drrnddaysummin1), checkNumber(drrnddaysummax1),	// 3
				checkNumber(profeemin), checkNumber(profeemax), checkNumber(anaesthetistfeemin), checkNumber(anaesthetistfeemax), checkNumber(othermin1),	//4
				checkNumber(othermax1), checkNumber(othermin2), checkNumber(othermax2), checkNumber(drrnddaysummin2), checkNumber(drrnddaysummax2),	// 5
				checkNumber(otmin), checkNumber(otmax), checkNumber(othermin3), checkNumber(othermax3), checkNumber(totalmin),	//6
				checkNumber(totalmax), checkNumber(profeemint), checkNumber(profeemaxt), checkNumber(anaesthetistfeemint), checkNumber(anaesthetistfeemaxt),	// 7
				checkNumber(otmint), checkNumber(otmaxt), checkNumber(othermin3t), checkNumber(othermax3t), checkNumber(totalmint),	//8
				checkNumber(totalmaxt), checkNumber(profeeminp), checkNumber(profeemaxp), checkNumber(anaesthetistfeeminp), checkNumber(anaesthetistfeemaxp), //9
				checkNumber(otminp), checkNumber(otmaxp), checkNumber(othermin3p), checkNumber(othermax3p), checkNumber(totalminp),	//10
				checkNumber(totalmaxp), userBean.getStaffID()
			});
	}
%>
<%
UserBean userBean = new UserBean(request);

String packagecode = request.getParameter("package");
String patno = request.getParameter("patno");
String patname = request.getParameter("patname");
String patcname = TextUtil.parseStrUTF8(request.getParameter("patcname"));
String patidno = request.getParameter("patidno");
String doccode = request.getParameter("doccode");
String procedure1 = request.getParameter("procedure1");
String procedure2 = request.getParameter("procedure2");
String DiagnosisText = TextUtil.parseStrUTF8(request.getParameter("DiagnosisText"));
String day = request.getParameter("day");
String acmcode = request.getParameter("acmcode");
String acmdesc = request.getParameter("acmdesc");
String rangeFrom = request.getParameter("rangeFrom");
String rangeTo = request.getParameter("rangeTo");
int hcopy = 1;
try {
	hcopy = Integer.parseInt(request.getParameter("hcopy"));
} catch (Exception e) {}
int pcopy = 1;
try {
	pcopy = Integer.parseInt(request.getParameter("pcopy"));
} catch (Exception e) {}
String DrRndDaySumMin1 = request.getParameter("DrRndDaySumMin1");
String DrRndDaySumMax1 = request.getParameter("DrRndDaySumMax1");
String ProFeeMinInput = request.getParameter("ProFeeMinInput");
String ProFeeMaxInput = request.getParameter("ProFeeMaxInput");
String AnaesthetistFeeMinInput = request.getParameter("AnaesthetistFeeMinInput");
String AnaesthetistFeeMaxInput = request.getParameter("AnaesthetistFeeMaxInput");
String DrRndDaySumMin2 = request.getParameter("DrRndDaySumMin2");
String DrRndDaySumMax2 = request.getParameter("DrRndDaySumMax2");
String OTMinInput = request.getParameter("OTMinInput");
String OTMaxInput = request.getParameter("OTMaxInput");
String OtherMin1Input = request.getParameter("OtherMin1Input");
String OtherMax1Input = request.getParameter("OtherMax1Input");
String OtherMin2Input = request.getParameter("OtherMin2Input");
String OtherMax2Input = request.getParameter("OtherMax2Input");
String OtherMin3Input = request.getParameter("OtherMin3Input");
String OtherMax3Input = request.getParameter("OtherMax3Input");
String totalMinInput = request.getParameter("totalMinInput");
String totalMaxInput = request.getParameter("totalMaxInput");

String ProFeeMinT = request.getParameter("ProFeeMinT");
String ProFeeMaxT = request.getParameter("ProFeeMaxT");
String AnaesthetistFeeMinT = request.getParameter("AnaesthetistFeeMinT");
String AnaesthetistFeeMaxT = request.getParameter("AnaesthetistFeeMaxT");
String OTMinT = request.getParameter("OTMinT");
String OTMaxT = request.getParameter("OTMaxT");
String OtherMin3T = request.getParameter("OtherMin3T");
String OtherMax3T = request.getParameter("OtherMax3T");
String totalMinT = request.getParameter("totalMinT");
String totalMaxT = request.getParameter("totalMaxT");

String ProFeeMinP = request.getParameter("ProFeeMinP");
String ProFeeMaxP = request.getParameter("ProFeeMaxP");
String AnaesthetistFeeMinP = request.getParameter("AnaesthetistFeeMinP");
String AnaesthetistFeeMaxP = request.getParameter("AnaesthetistFeeMaxP");
String OTMinP = request.getParameter("OTMinP");
String OTMaxP = request.getParameter("OTMaxP");
String OtherMin3P = request.getParameter("OtherMin3P");
String OtherMax3P = request.getParameter("OtherMax3P");
String totalMinP = request.getParameter("totalMinP");
String totalMaxP = request.getParameter("totalMaxP");

String currentDate = DateTimeUtil.getCurrentDate();

String mothcode = null;
String docname = null;
String doccname = null;

int docFee1 = 0;
try {
	docFee1 += Integer.parseInt(DrRndDaySumMin1);
} catch (Exception e) {}
try {
	docFee1 += Integer.parseInt(ProFeeMinInput);
} catch (Exception e) {}
try {
	docFee1 += Integer.parseInt(AnaesthetistFeeMinInput);
} catch (Exception e) {}
try {
	docFee1 += Integer.parseInt(OtherMin1Input);
} catch (Exception e) {}
try {
	docFee1 += Integer.parseInt(OtherMin2Input);
} catch (Exception e) {}

int docFee2 = 0;
try {
	docFee2 += Integer.parseInt(DrRndDaySumMax1);
} catch (Exception e) {}
try {
	docFee2 += Integer.parseInt(ProFeeMaxInput);
} catch (Exception e) {}
try {
	docFee2 += Integer.parseInt(AnaesthetistFeeMaxInput);
} catch (Exception e) {}
try {
	docFee2 += Integer.parseInt(OtherMax1Input);
} catch (Exception e) {}
try {
	docFee2 += Integer.parseInt(OtherMax2Input);
} catch (Exception e) {}

int hospitalFee1 = 0;
try {
	hospitalFee1 += Integer.parseInt(DrRndDaySumMin2);
} catch (Exception e) {}
try {
	hospitalFee1 += Integer.parseInt(OTMinInput);
} catch (Exception e) {}
try {
	hospitalFee1 += Integer.parseInt(OtherMin3Input);
} catch (Exception e) {}

int hospitalFee2 = 0;
try {
	hospitalFee2 += Integer.parseInt(DrRndDaySumMax2);
} catch (Exception e) {}
try {
	hospitalFee2 += Integer.parseInt(OTMaxInput);
} catch (Exception e) {}
try {
	hospitalFee2 += Integer.parseInt(OtherMax3Input);
} catch (Exception e) {}

ArrayList record = null;

saveQuotation(userBean, patno, patname, patcname, patidno, doccode,
				procedure2, DiagnosisText, day, acmcode, rangeFrom,
				rangeTo, String.valueOf(hcopy), String.valueOf(pcopy), DrRndDaySumMin1, DrRndDaySumMax1,
				ProFeeMinInput, ProFeeMaxInput, AnaesthetistFeeMinInput, AnaesthetistFeeMaxInput, OtherMin1Input,
				OtherMax1Input, OtherMin2Input, OtherMax2Input, DrRndDaySumMin2, DrRndDaySumMax2,
				OTMinInput, OTMaxInput, OtherMin3Input, OtherMax3Input, totalMinInput,
				totalMaxInput, ProFeeMinT, ProFeeMaxT, AnaesthetistFeeMinT, AnaesthetistFeeMaxT,
				OTMinT, OTMaxT, OtherMin3T, OtherMax3T, totalMinT,
				totalMaxT, ProFeeMinP, ProFeeMaxP, AnaesthetistFeeMinP, AnaesthetistFeeMaxP,
				OTMinP, OTMaxP, OtherMin3P, OtherMax3P, totalMinP,
				totalMaxP);

if (doccode != null) {
	record = fetchDoctor(doccode);

	if (record != null && record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		docname = row.getValue(0);
		doccname = row.getValue(1);
	}
}

String url = null;
String logo = null;
String VIPRoom = null;
String privateRoom = null;
String semiPrivateRoom = null;
String standardRoom = null;
if (ConstantsServerSide.isTWAH()) {
	url = "http://www.twah.org.hk";
	logo = "twah_portal_logo.gif";
	VIPRoom = "3,000-4,000";
	privateRoom = "2,000";
	semiPrivateRoom = "1,100–1,200";
	standardRoom = "700-750";
} else {
	url = "http://www.hkah.org.hk";
	logo = "hkah_portal_logo.gif";
	VIPRoom = "3,800-8,400";
	privateRoom = "2,300-3,300";
	semiPrivateRoom = "1,680-2,200";
	standardRoom = "680-900";
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
	line-height: 2.7;
	padding: 0;
	margin:0;
}
#form_wrapper {
	font-size: 16px;
	width: 920px;
	border: 2px solid black;
	margin: 0 auto;
}
#form_patient {
	font-size: 14px;
	width: 920px;
	border: 0px;
	margin: 0 auto;
}
#form_table {
	font-size: 14px;
	border: 1px solid black;
}
.form {
	width: 100%;
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
	 width: 480px;
	 position:relative;
	 left:417px;
	 margin-top: 20px;
	 padding: 5px;
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
	opacity: 0.6;
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
<%	for (int i=0; i<hcopy + pcopy; i++) { %>
	<div id="form_patient">
		<div id="header" class="content" style="line-height: 1.6; padding-right:0;">
			<table width="100%" border="0">
				<tr>
					<td width="25%"><img src="../images/<%=logo %>" width="250" height="70"></td>
					<td width="50%">&nbsp;</td>
					<td width="25%" align="right"><b>Form A<br>表格 A<b></td>
				</tr>
			</table>

			<table width="100%" border="0">
				<tr>
					<td width="100%"><center><b>服務費用預算 - 預算醫生費用 (只供參考)<br/>Budget Estimate - Estimated Doctor's Fees (For Illustration Only)</b></center></td>
				</tr>
			</table>

<%		if (i >= hcopy) { %>
			<table width="100%" border="2">
				<tr>
					<td width="100%">
						<font size="-2">
							<center>須知：務請確認已於表格上簽署，並須於入院當日交予病人事務部。<br/>Important: Please ensure that forms A and B are both signed and bring them to the Patient Business Office on the day of admission</center>
						</font>
					</td>
				</tr>
			</table>
<%		} else {%>
			<br>
<%		} %>
		</div>

		<br>

		<div class="content" style="padding:5px 5px;">
			<span style="line-height: 1.3;">
				<font size="-2">
					本表格正本會存放在醫院的病人醫療記錄內，副本供病人和醫生參考。費用預算只供參考，最終收費視乎病人實際接受的治療、程序及服務而定。此「服務費用預算」有效期為六個月，由<u><%=currentDate %></u>起計。<br/><br/>
					The original of this form will be filed as hospital’s medical records, and copies will be given to patient and doctor for reference.  The estimated charges are for reference only.  Final payments are subject to charges incurred from treatment, procedures and services performed.  This "Budget Estimate" is valid for a period of 6 months starting from <u><%=currentDate %></u>.<br/><br/>
				</font>
			</span>
		</div>

		<div class="content">
			<table width="100%" style="line-height: 1.2;">
				<tr>
					<td width="20%">病人姓名 Patient Name</td>
					<td width="12%" align="right">(中文 Chinese):</td>
					<td width="20%" style="border-bottom: 1px solid black;"><%=patcname==null?"":patcname %></td>
					<td width="12%" align="right">(英文 English):</td>
					<td width="36%" style="border-bottom: 1px solid black;"><%=patname==null?"":patname %></td>
				</tr>
				<tr>
					<td colspan="3">身份證 / 護照號碼 Hong Kong Identity Card / Passport Number:</td>
					<td colspan="2"style="border-bottom: 1px solid black;"><%=patidno %></td>
				</tr>
				<tr>
					<td colspan="5">&nbsp;</td>
				</tr>
			</table>

			<table width="100%" style="line-height: 1.2;">
				<tr>
					<td width="35%">初步診斷 Provisional Diagnosis:</td>
					<td colspan="3" style="border-bottom: 1px solid black;"><%=DiagnosisText==null?"":DiagnosisText %></td>
				</tr>
				<tr>
					<td width="35%">預計住院時間 Estimated Length of Stay:</td>
					<td width="15%" style="border-bottom: 1px solid black;"><%=day==null?"":day %> 日 Day(s)</td>
					<td width="20%" align="right">病房級別 Class of Ward:</td>
					<td width="30%" style="border-bottom: 1px solid black;"><%=acmdesc==null?"":acmdesc %></td>
				</tr>
				<tr>
					<td>治療程序 / 手術 Treatment Procedure/Surgical<br>Operation:</td>
					<td colspan="3" style="border-bottom: 1px solid black;"><%=fetchProcedureDesc(procedure2) %></td>
				</tr>
				<tr>
					<td>主診醫生 Attending Doctor:</td>
					<td colspan="3" style="border-bottom: 1px solid black;"><%=docname==null?"":docname %>&nbsp;<%=doccname==null?"":doccname %></td>
				</tr>
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
			</table>
		</div>
	</div>

	<div id="form_wrapper">
		<div class="title" style="line-height: 1.6;">
			<span>
				<b>預算醫生費用 Estimated Doctor’s Fees (由醫生填寫 To be completed by doctor)</b>
			</span>
		</div>

		<div class="content">
			<table width="100%" style="line-height: 1.5;">
				<tr>
					<td width="50%">每日醫生巡房費 Daily Doctor's Round Fee:</td>
					<td width="30%" style="border-bottom: 1px solid black;">
						<span class='money'>
							<%=getValueForReportWithCurrency(DrRndDaySumMin1, DrRndDaySumMax1) %>
							(<%=day==null?"":day %> 日 day(s))
						</span>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>手術費 Surgical Fee:</td>
					<td style="border-bottom: 1px solid black;">
						<span class='money'>
							<%=getValueForReportWithCurrency(ProFeeMinInput, ProFeeMaxInput) %>
						</span>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>麻醉科醫生費 Anaesthetist's Fee:</td>
					<td style="border-bottom: 1px solid black;">
						<span class='money'>
							<%=getValueForReportWithCurrency(AnaesthetistFeeMinInput, AnaesthetistFeeMaxInput) %>
						</span>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>其他專科醫生診療費用 (請註明) Other Specialists' Consultation Fee<br>(Please Specify):</td>
					<td style="border-bottom: 1px solid black;">
						<span class='money'>
							<%=getValueForReportWithCurrency(OtherMin1Input, OtherMax1Input) %>
						</span>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>其他項目及收費 Other Items and Charges:</td>
					<td style="border-bottom: 1px solid black;">
						<span class='money'>
							<%=getValueForReportWithCurrency(OtherMin2Input, OtherMax2Input) %>
						</span>
					</td>
					<td>&nbsp;</td>
				</tr>
			</table>

			<div id="totalBox">
				<b>總計 Total:
					<span class='money'>
						<%=getValueForReportWithCurrency(String.valueOf(docFee1), String.valueOf(docFee2)) %>
					</span>
				</b>
			</div>
			<br>

			<span style="line-height: 1.6;">
				<font size="-2">
					<b>本人已向病人/ 親屬/ 獲授權人士解釋上述預算費用，並徵得其同意。<br/>
					I have explained to the patient the details of the above estimated charges and have sought his / her agreement</b>
				</font>
			</span><br/>
			<table style="width: 100%; height: 50px; line-height: 1.5; text-align: center">
			<tr>
				<td width="33%"><%=docname==null?"":docname %>&nbsp;<%=doccname==null?"":doccname %></td>
				<td width="33%"></td>
				<td width="33%"><%=currentDate %></td>
			</tr>
			<!--[if IE]><tr>
				<td><span style="font-size:0.1em">______________________________________________________________________________________________________________________________________________________________________________________________________________________________</span></td>
				<td><span style="font-size:0.1em">______________________________________________________________________________________________________________________________________________________________________________________________________________________________</span></td>
				<td><span style="font-size:0.1em">______________________________________________________________________________________________________________________________________________________________________________________________________________________________</span></td>
			</tr><![endif]-->
			<!--[if !IE]> --><tr>
				<td><span style="line-height: 0.4;">________________________________</span></td>
				<td><span style="line-height: 0.4;">________________________________</span></td>
				<td><span style="line-height: 0.4;">________________________________</span></td>
			</tr><!-- <![endif]-->
				<td>
					醫生姓名<br/>
					Name of Doctor<br/>
				</td>
				<td>
					醫生簽署<br/>
					Signature of Doctor
				</td>
				<td>
					日期<br/>
					Date
				</td>
			</tr>
			</table>
		</div>

		<div class="title" style="line-height: 1.6;">
			<span>
				<b>病人簽署 Patient’s Signature</b>
			</span>
		</div>
		<br>
		<div class="content">
			<span style="line-height: 1.6;">
				<font size="-2">
					<b>本人知悉服務預算費用並無法律效力，僅為參考，並不包括因倂發症以及入院後發現的疾病所產生的額外費用。本人同意最終收費視乎病人實際接受的治療、程序及服務而定，並以醫院帳單所列為準。 <br/><br/>
					I understand that this budget estimate is not legally binding and is for reference only.  Additional charges incurred from complications and from diseases diagnosed after admission are not covered.  I agree that final payments are subject to charges incurred from treatment, procedures and services performed and should be made in accordance with hospital invoice.</b>
				</font>
			</span>
			<table style="width: 100%; height: 50px; line-height: 1.5; text-align: center">
			<tr>
				<td width="33%"></td>
				<td width="33%"></td>
				<td width="33%"><%=currentDate %></td>
			</tr>
			<!--[if IE]><tr>
				<td><span style="font-size:0.1em">______________________________________________________________________________________________________________________________________________________________________________________________________________________________</span></td>
				<td><span style="font-size:0.1em">______________________________________________________________________________________________________________________________________________________________________________________________________________________________</span></td>
				<td><span style="font-size:0.1em">______________________________________________________________________________________________________________________________________________________________________________________________________________________________</span></td>
			</tr><![endif]-->
			<!--[if !IE]> --><tr>
				<td><span style="line-height: 0.4;">________________________________</span></td>
				<td><span style="line-height: 0.4;">________________________________</span></td>
				<td><span style="line-height: 0.4;">________________________________</span></td>
			</tr><!-- <![endif]-->
				<td>
					病人 / 親屬 / 獲授權人士姓名<br/>
					Name of Patient / Next-of-kin / Authorised Person
				</td>
				<td>
					病人 / 親屬 / 獲授權人士簽署<br/>
					Signature of Patient / Next-of-kin / Authorised Person
				</td>
				<td>
					日期<br/>
					Date
				</td>
			</tr>
			</table>
		</div>
	</div>

	<br><p>

	<div id="form_patient">
		<div id="form_table">
			<table width="100%" style="line-height: 1.2;">
				<tr>
					<td width="55%">
						<table width="100%" border="0">
							<tr><td width="25%">Name:</td><td><%=patname==null?"":patname %></td></tr>
							<tr><td>Date of Birth:</td><td>&nbsp;</td></tr>
							<tr><td>Gender:</td><td>&nbsp;</td></tr>
							<tr><td>Room No.:</td><td>&nbsp;</td></tr>
						</table>
					</td>
					<td width="45%">
						<div id="form_table">
							<table width="100%" style="line-height: 1.2;">
								<tr><td colspan="2"><span style="font-size:14pt"><center><b>ESTIMATED DOCTOR’S FEES</b><br><font color="red"><u>(FORM A)</u></font></center></span></td></tr>
								<tr><td width="50%"><%if (ConstantsServerSide.isTWAH()) {%>&nbsp;<%} else { %>June 2016<%} %></td><td><center><%if (ConstantsServerSide.isTWAH()) {%>VPMA-MZA003<%} else { %>VPMA-MLC35<%} %></center></td></tr>
								<tr><td colspan="2"><center><img src="<%if (ConstantsServerSide.isTWAH()) {%>VPMAMZA003<%} else { %>VPMAMLC35<%} %>.jpg" width="260" height="32"></center></td></tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>

	<div id="form_patient">
		<div id="header" class="content" style="line-height: 1.6; padding-right:0;">
			<table width="100%" border="0">
				<tr>
					<td width="25%"><img src="../images/<%=logo %>" width="250" height="70"></td>
					<td width="50%">&nbsp;</td>
					<td width="25%" align="right"><b>Form B<br>表格 B<b></td>
				</tr>
			</table>

			<table width="100%" border="0">
				<tr>
					<td width="100%"><center><b>服務費用預算 - 預算醫生費用 (只供參考)<br/>Budget Estimate - Estimated Doctor's Fees (For Illustration Only)</b></center></td>
				</tr>
			</table>

<%		if (i >= hcopy) { %>
			<table width="100%" border="2">
				<tr>
					<td width="100%">
						<font size="-2">
							<center>須知：務請確認已於表格上簽署，並須於入院當日交予病人事務部。<br/>Important: Please ensure that forms A and B are both signed and bring them to the Patient Business Office on the day of admission</center>
						</font>
					</td>
				</tr>
			</table>
<%		} else {%>
			<br>
<%		} %>
		</div>

		<br>

		<div class="content" style="padding:5px 5px;">
			<span style="line-height: 1.3;">
				<font size="-2">
					本表格正本會存放在醫院的病人醫療記錄內，副本供病人和醫生參考。費用預算只供參考，最終收費視乎病人實際接受的治療、程序及服務而定。此「服務費用預算」有效期為六個月，由<u><%=currentDate %></u>起計。<br/><br/>
					The original of this form will be filed as hospital’s medical records, and copies will be given to patient and doctor for reference.  The estimated charges are for reference only.  Final payments are subject to charges incurred from treatment, procedures and services performed.  This "Budget Estimate" is valid for a period of 6 months starting from <u><%=currentDate %></u>.<br/><br/>
				</font>
			</span>
		</div>

		<div class="content">
			<table width="100%" style="line-height: 1.2;">
				<tr>
					<td width="20%">病人姓名 Patient Name</td>
					<td width="12%" align="right">(中文 Chinese):</td>
					<td width="20%" style="border-bottom: 1px solid black;"><%=patcname==null?"":patcname %></td>
					<td width="12%" align="right">(英文 English):</td>
					<td width="36%" style="border-bottom: 1px solid black;"><%=patname==null?"":patname %></td>
				</tr>
				<tr>
					<td colspan="3">身份證號碼 / 護照號碼 Hong Kong Identity Card/Passport Number</td>
					<td colspan="2"style="border-bottom: 1px solid black;"><%=patidno %></td>
				</tr>
				<tr>
					<td colspan="5">&nbsp;</td>
				</tr>
			</table>

			<table width="100%" style="line-height: 1.2;">
				<tr>
					<td width="30%">初步診斷 Provisional Diagnosis:</td>
					<td colspan="3" style="border-bottom: 1px solid black;"></td>
				</tr>
				<tr>
					<td width="35%">預計住院時間 Estimated Length of Stay:</td>
					<td width="15%" style="border-bottom: 1px solid black;"><%=day==null?"":day %> 日 Day(s)</td>
					<td width="20%" align="right">病房級別 Class of Ward:</td>
					<td width="30%" style="border-bottom: 1px solid black;"><%=acmdesc==null?"":acmdesc %></td>
				</tr>
				<tr>
					<td>治療程序 / 手術 Treatment Procedure/Surgical Operation:</td>
					<td colspan="3" style="border-bottom: 1px solid black;"><%=fetchProcedureDesc(procedure2) %></td>
				</tr>
				<tr>
					<td>主診醫生 Attending Doctor:</td>
					<td colspan="3" style="border-bottom: 1px solid black;"><%=docname==null?"":docname %>&nbsp;<%=doccname==null?"":doccname %></td>
				</tr>
				<tr>
					<td colspan="4">&nbsp;</td>
				</tr>
			</table>
		</div>
	</div>

	<div id="form_wrapper">
		<div class="title">
			<span style="line-height:1.4;">
				<font size="-2">
					<b>預算醫院費用 Estimated Hospital Charges</br>
					（由醫生根據醫院提供的收費資料填寫 To be completed by doctor based on the charges information provided by hospital）</b>
				</font>
			</span>
		</div>

		<div class="content">
			<table width="100%" style="line-height: 1.5;">
				<tr>
					<td width="50%">住宿Room:</td>
					<td width="30%" style="border-bottom: 1px solid black;">
						<span class='money'>
							<%=getValueForReportWithCurrency(DrRndDaySumMin2, DrRndDaySumMax2) %>
							(<%=day==null?"":day %> 日 day(s))
						</span>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>手術室及相關物料費用<br>Operating Theatre and Associated<br>Materials Charges (備註1 Remark 1)：</td>
					<td style="border-bottom: 1px solid black;">
						<span class='money'>
							<%=getValueForReportWithCurrency(OTMinInput, OTMaxInput) %>
						</span>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>其他醫院收費 Other Hospital Charges<br>(備註2 Remark 2)：</td>
					<td style="border-bottom: 1px solid black;">
						<span class='money'>
							<%=getValueForReportWithCurrency(OtherMin3Input, OtherMax3Input) %>
						</span>
					</td>
					<td>&nbsp;</td>
				</tr>
			</table>

			<div id="totalBox">
				<b>總計 Total:
					<span class='money'>
						<%=getValueForReportWithCurrency(String.valueOf(hospitalFee1), String.valueOf(hospitalFee2)) %>
					</span>
				</b>
			</div>
		</div>

		<div class="title" style="line-height: 1.6;">
			<span>
				<b>病人簽署 Patient’s Signature</b>
			</span>
		</div>
		<div class="content">
			<span style="line-height: 1.6;">
				<font size="-2">
					<b>本人知悉服務預算費用並無法律效力，僅為參考，並不包括因倂發症以及入院後發現的疾病所產生的額外費用。本人同意最終收費視乎病人實際接受的治療、程序及服務而定，並以醫院帳單所列為準。<br/><br/>
					I understand that this budget estimate is not legally binding and is for reference only.  Additional charges incurred from complications and from diseases diagnosed after admission are not covered.  I agree that final payments are subject to charges incurred from treatment, procedures and services performed and should be made in accordance with hospital invoice.</b>
				</font>
			</span>
			<table style="width: 100%; height: 50px; line-height: 1.5; text-align: center">
			<tr>
				<td width="33%"></td>
				<td width="33%"></td>
				<td width="33%"><%=currentDate %></td>
			</tr>
			<!--[if IE]><tr>
				<td><span style="font-size:0.1em">______________________________________________________________________________________________________________________________________________________________________________________________________________________________</span></td>
				<td><span style="font-size:0.1em">______________________________________________________________________________________________________________________________________________________________________________________________________________________________</span></td>
				<td><span style="font-size:0.1em">______________________________________________________________________________________________________________________________________________________________________________________________________________________________</span></td>
			</tr><![endif]-->
			<!--[if !IE]> --><tr>
				<td><span style="line-height: 0.4;">________________________________</span></td>
				<td><span style="line-height: 0.4;">________________________________</span></td>
				<td><span style="line-height: 0.4;">________________________________</span></td>
			</tr><!-- <![endif]-->
				<td>
					病人 / 親屬 / 獲授權人士姓名<br/>
					Name of Patient / Next-of-kin / Authorised Person
				</td>
				<td>
					病人 / 親屬 / 獲授權人士簽署<br/>
					Signature of Patient / Next-of-kin / Authorised Person
				</td>
				<td>
					日期<br/>
					Date
				</td>
			</tr>
			</table>
		</div>
	</div>

	<div id="form_patient">
		<div class="content">
			<span style="line-height: 1.3;">
				<table width="100%" border="0">
					<tr>
						<td width="3%" rowspan="5">&nbsp;</td>
						<td colspan="2"><span style="font-size:12px"><b>備註 Remarks:</b></span></td>
						<td width="3%" rowspan="5">&nbsp;</td>
					</tr>
					<tr>
						<td width="3%" valign="top">1</td>
						<td>
							<font size="-2">
								表格內列出醫院費用預算的參考幅度數字，是根據去年度本院接受同類治療的相關病人出院帳單的實際費用統計及醫生初步選擇的治療項目估算所得。每位醫生處理同樣病症的方法可能會有差異(例如療程選擇、藥物處方、使用物料等)。<br/>
								Figures listed under the Reference Range of Hospital Charges are derived from statistics of actual discharge bills of relevant patients who underwent similar treatment in our hospital last year and the preliminary treatment items chosen by the doctor.　Doctors’ management (e.g. choice of procedures, drugs and consumables) of the same illness may differ.<br/>
							</font>
						</td>
					</tr>
					<tr>
						<td valign="top">2</td>
						<td>
							<font size="-2">
								「其他醫院收費」是護理、消耗品、藥物、化驗、檢查，及其他非手術室相關費用的估算總和。<br/>
								Other Hospital Charges is a rough estimate of the total charges including nursing care, consumables, drugs, laboratory tests, investigations, and other non-Operating Theatre related charges.<br/><br/>
								本院的每天住院房租如下: 三等房 $<%=standardRoom %>，二等房 $<%=semiPrivateRoom %>，私家房 $<%=privateRoom %>，VIP 房 $<%=VIPRoom %>。其他特殊病房收費請參考網頁 <a href="<%=url %>" target="_blank"><%=url %></a><br/>
								Our hospital’s Room Charges are as follows: Standard Room $<%=standardRoom %>, Semi-Private Room $<%=semiPrivateRoom %>, Private Room $<%=privateRoom %>, VIP Room $<%=VIPRoom %>. For other special beds, please refer to our webpage: <a href="<%=url %>" target="_blank"><%=url %></a>
							</font>
						</td>
					</tr>
				</table>
			</span>
		</div>
	</div>

	<br><p><br>

	<div id="form_patient">
		<div id="form_table">
			<table width="100%" style="line-height: 1.2;">
				<tr>
					<td width="55%">
						<table width="100%" border="0">
							<tr><td width="25%">Name:</td><td><%=patname==null?"":patname %></td></tr>
							<tr><td>Date of Birth:</td><td>&nbsp;</td></tr>
							<tr><td>Gender:</td><td>&nbsp;</td></tr>
							<tr><td>Room No.:</td><td>&nbsp;</td></tr>
						</table>
					</td>
					<td width="45%">
						<div id="form_table">
							<table width="100%" style="line-height: 1.2;">
								<tr><td colspan="2"><span style="font-size:14pt"><center><b>ESTIMATED HOSPITAL CHARGES</b><br><font color="red"><u>(FORM B)</u></font></center></span></td></tr>
								<tr><td width="50%"><%if (ConstantsServerSide.isTWAH()) {%>&nbsp;<%} else { %>June 2016<%} %></td><td><center><%if (ConstantsServerSide.isTWAH()) {%>VPMA-MZA004<%} else { %>VPMA-MLC36<%} %></center></td></tr>
								<tr><td colspan="2"><center><img src="<%if (ConstantsServerSide.isTWAH()) {%>VPMAMZA004<%} else { %>VPMAMLC36<%} %>.jpg" width="260" height="32"></center></td></tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
<%
	}
%>

	<div id="paper">
		<!--img class="form" src="./SURU08a1_chi.png"/ -->
		<!--img class="form" src="./SURU08a2_chi.png"/ -->
		<!--img class="form" src="./MCDA25a1_chi.png"/ -->
		<!--img class="form" src="./MCDA25a2_chi.png"/ -->
	</div> <!-- form wrapper -->

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