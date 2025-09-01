<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%@ page import="java.security.MessageDigest,java.net.URLEncoder"%>
<%@ page import="java.text.DecimalFormat"%>

<%
//20181009 Arran changed CASH_EPS to UPON_ARRIVAL
UserBean userBean = new UserBean(request);

String sessionKey = ParserUtil.getParameter(request, "session");

String command = ParserUtil.getParameter(request, "command");
String admissionID = ParserUtil.getParameter(request, "admissionID");
String step = ParserUtil.getParameter(request, "step");
String language = ParserUtil.getParameter(request, "language");
Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else {
	locale = Locale.US;
}

String patno = ParserUtil.getParameter(request, "patno");
String newPatno = ParserUtil.getParameter(request, "newPatno");
String expectedAdmissionDate = ParserUtil.getParameter(request, "expectedAdmissionDate");
String expectedAdmissionTime = ParserUtil.getTime(request, "expectedAdmissionTime");
String actualAdmissionDate = ParserUtil.getParameter(request, "actualAdmissionDate");
String actualAdmissionTime = ParserUtil.getTime(request, "actualAdmissionTime");
String admissiondoctor = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "admissiondoctor"));
String remarks = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remarks"));

String patidno = null;
String patidno1 = TextUtil.parseStr(ParserUtil.getParameter(request, "patidno1")).toUpperCase();
String patidno2 = TextUtil.parseStr(ParserUtil.getParameter(request, "patidno2")).toUpperCase();
String patpassport = TextUtil.parseStr(ParserUtil.getParameter(request, "patpassport")).toUpperCase();
String patbdate = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patbdate"));
String patfname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patfname"));
String patgname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patgname"));
String titleDesc = ParserUtil.getParameter(request, "titleDesc");
String titleDescOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "titleDescOther"));
String patcname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patcname"));
String passdocument = null;
String patsex = ParserUtil.getParameter(request, "patsex");
String racedesc = ParserUtil.getParameter(request, "racedesc");
String racedescOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "racedescOther"));
String religion = ParserUtil.getParameter(request, "religion");
String religionOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "religionOther"));
String patmsts = ParserUtil.getParameter(request, "patmsts");
String patmstsOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patmstsOther"));
String mothcode = ParserUtil.getParameter(request, "mothcode");
String mothcodeOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mothcodeOther"));
String edulevel = ParserUtil.getParameter(request, "edulevel");
String pathtel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pathtel"));
String patotel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patotel"));
String patmtel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patmtel"));
String patftel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patftel"));
String occupation = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "occupation"));
String patemail = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patemail"));
if (patemail == null || "".equals(patemail)) {
	if (sessionKey != null && !"".equals(sessionKey)) {
		patemail = SessionLoginDB.getSessionEmail(sessionKey);
	}
}
String patadd1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patadd1"));
String patadd2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patadd2"));
String patadd3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patadd3"));
String patadd4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patadd4"));
String coucode = ParserUtil.getParameter(request, "coucode");
String coudesc = null;

String patkfname1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkfname1"));
String patkgname1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkgname1"));
String patkcname1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkcname1"));
String patksex1 = ParserUtil.getParameter(request, "patksex1");
String patkrela1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkrela1"));
String patkhtel1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkhtel1"));
String patkotel1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkotel1"));
String patkmtel1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkmtel1"));
String patkptel1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkptel1"));
String patkemail1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkemail1"));
String patkadd11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd11"));
String patkadd21 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd21"));
String patkadd31 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd31"));
String patkadd41 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd41"));

String patkfname2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkfname2"));
String patkgname2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkgname2"));
String patkcname2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkcname2"));
String patksex2 = ParserUtil.getParameter(request, "patksex2");
String patkrela2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkrela2"));
String patkhtel2 = ParserUtil.getParameter(request, "patkhtel2");
String patkotel2 = ParserUtil.getParameter(request, "patkotel2");
String patkmtel2 = ParserUtil.getParameter(request, "patkmtel2");
String patkptel2 = ParserUtil.getParameter(request, "patkptel2");
String patkemail2 = ParserUtil.getParameter(request, "patkemail2");
String patkadd12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd12"));
String patkadd22 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd22"));
String patkadd32 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd32"));
String patkadd42 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd42"));

String ward = ParserUtil.getParameter(request, "ward");
String roomType = ParserUtil.getParameter(request, "roomType");
String hospitalACM = ParserUtil.getParameter(request, "hospitalACM");
String bedNo = ParserUtil.getParameter(request, "bedNo");
String paymentType = ParserUtil.getParameter(request, "paymentType");
String paymentTypeOther = ParserUtil.getParameter(request, "paymentTypeOther");
String creditCardType = ParserUtil.getParameter(request, "creditCardType");
String insuranceRemarks = ParserUtil.getParameter(request, "insuranceRemarks");
String insurancePolicyNo = ParserUtil.getParameter(request, "insurancePolicyNo");
String promotionYN = ParserUtil.getParameter(request, "promotionYN");
String infoForPromotion = ParserUtil.getParameter(request, "infoForPromotion");

String reached = ParserUtil.getParameter(request, "reached");
String registered = ParserUtil.getParameter(request, "registered");
String  firstViewUser = null;
String firstViewDate = null;
String confirmDate = null;
String[] unselectedImtInfo = null;

String vpc_Amount = "0" ;
String vpc_Amount_disp = "0" ;
String isResident = "no" ;
String roomType_key = null ;
// end

if (patidno1 != null && !patidno1.isEmpty() ) {
	isResident = "yes" ;
	if ("VIP".equals(roomType)) 				{ vpc_Amount = "30000"; roomType_key = "adm.acm1"; }
	else if ("Private".equals(roomType)) 		{ vpc_Amount = "30000"; roomType_key = "adm.acm2"; }
	else if ("Semi-Private".equals(roomType)) 	{ vpc_Amount = "20000"; roomType_key = "adm.acm3"; }
	else if ("Standard".equals(roomType)) 		{ vpc_Amount = "10000"; roomType_key = "adm.acm4"; }
} else {
	if ("VIP".equals(roomType)) 				{ vpc_Amount = "50000"; roomType_key = "adm.acm1"; }
	else if ("Private".equals(roomType)) 		{ vpc_Amount = "50000"; roomType_key = "adm.acm2"; }
	else if ("Semi-Private".equals(roomType)) 	{ vpc_Amount = "40000"; roomType_key = "adm.acm3"; }
	else if ("Standard".equals(roomType)) 		{ vpc_Amount = "30000"; roomType_key = "adm.acm4"; }
}
double amount = Double.parseDouble(vpc_Amount);
DecimalFormat formatter = new DecimalFormat("#,###,###");
vpc_Amount_disp = formatter.format(amount);

%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->

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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
	<jsp:param name="title" value="Hong Kong Adventist Hospital" />
</jsp:include>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/registration/background.css" />" />
<head>
	<style>
		.hightLight {
				background-color:yellow !important;
		}

		.boldtable, .boldtable TD, .boldtable TH { font-size:11pt; font-weight:bold; }
	</style>
</head>
<body>


<DIV id=wrapper class="wrapper" style="background-color:white;">
<DIV >
<DIV  style="background-color:white;">
<jsp:include page="admission_header.jsp" flush="false">
	<jsp:param name="language" value="<%=language %>" />
</jsp:include>
<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<div class="normal_area">
<div class="career_form" style="padding: 20px 18px;">

<br>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="6" height="25" style="background-color:#aa0066;">
		<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(locale, "adm.deposit") %></strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><table width = "300" border="0" class="boldtable">
		<tr><td><%=MessageResources.getMessage(locale, "adm.roomType") %></td><td><%=MessageResources.getMessage(locale, roomType_key) %></td></tr>
		<tr><td><%=MessageResources.getMessage(locale, "adm.isResident") %></td><td><%=MessageResources.getMessage(locale, "label."+isResident) %></td></tr>
		<tr><td><%=MessageResources.getMessage(locale, "adm.deposit") %></td><td><%=MessageResources.getMessage(locale, "adm.hkd") %> $ <%=vpc_Amount_disp %></td></tr>
	</table></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<form name="form1" enctype="multipart/form-data" action="" method="post">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="6" height="25" style="background-color:#aa0066;">
		<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(locale,"adm.methodofPayment") %></strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;<font color="red"><br><b><%=MessageResources.getMessage(locale,"adm.merchantLocation") %></b></font></td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5">
			<%=MessageResources.getMessage(locale,"adm.paymentMsg") %>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="5" height="20">
		<table width="700" border="0" cellspacing="0" cellpadding="0">
			<td valign="top" width="5%">
				<font color="red">*</font>
				<input type="checkbox" onclick="return checkRoomRate();return false;" name="agreement2" value="Y" />
			</td>
			<td valign="top" width="95%">
				<div id="paymentMsg">
				<%=MessageResources.getMessage(locale,"adm.agreeCondition1") %>
				<%if ("chi".equals(language)){ %>
					"<a href="<%=DocumentDB.getURL("115") %>" target="_blank"><%=MessageResources.getMessage(locale, "label.health.care.advisory") %></a>",
					"<a href="<%=DocumentDB.getURL("620") %>" target="_blank"><%=MessageResources.getMessage(locale,"adm.agreeCondition2") %></a>"
				<%} else { %>
					"<a href="<%=DocumentDB.getURL("114") %>" target="_blank"><%=MessageResources.getMessage(locale, "label.health.care.advisory") %></a>",
					"<a href="<%=DocumentDB.getURL("116") %>" target="_blank"><%=MessageResources.getMessage(locale,"adm.agreeCondition2") %></a>"
				<%} %>
				 <%=MessageResources.getMessage(locale,"adm.agreeCondition3") %><br />
				</div>
				</td>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="20" >
		<table width="100%" border="0" cellspacing="1" cellpadding="0">
			<tr>
			<font color="red">*</font><div id="payType" style="width:200px;"><%=MessageResources.getMessage(locale,"adm.methodofPayment") %></div>
<!-- 				<td height="30" > -->
<!-- 				<input name="paymentType" -->
<%-- 					type="radio" value="CREDIT CARD" /><%=MessageResources.getMessage(locale,"adm.payMethod1") %> --%>
<!-- 					<select name="creditCardType" onchange="return changePaymentType();"> -->
<!-- 					<option value=""></option> -->
<!-- 					<option value="Visa/Master">Visa/Master</option> -->
<%-- 					<option value="JCB"><%=MessageResources.getMessage(locale,"adm.payMethod1.opt3") %></option> --%>
<%-- 					<option value="Diners"><%=MessageResources.getMessage(locale,"adm.payMethod1.opt4") %></option> --%>
<%-- 					<option value="AE"><%=MessageResources.getMessage(locale,"adm.payMethod1.opt5") %></option> --%>
<!-- 					</select> -->
<!-- 				</td> -->
				<td height="30" ><input name="paymentType"
					type="radio" value="VISA_MASTER" onclick="changePaymentType()"/><%=MessageResources.getMessage(locale,"adm.payMethod10") %></td>
				<td height="30" ><input name="paymentType"
					type="radio" value="UNION_PAY" onclick="changePaymentType()"/><%=MessageResources.getMessage(locale,"adm.payMethod11") %></td>
				<td height="30" ><input name="paymentType"
					type="radio" value="UPON_ARRIVAL" onclick="changePaymentType();"/><%=MessageResources.getMessage(locale,"adm.payMethod13") %></td>
<!-- 				<td height="30" ><input name="paymentType" -->
<%-- 					type="radio" value="CASH" onclick="changePaymentType();"/><%=MessageResources.getMessage(locale,"adm.payMethod3") %></td> --%>
<!-- 				<td height="30" ><input name="paymentType" -->
<%-- 					type="radio" value="EPS" onclick="changePaymentType();"/><%=MessageResources.getMessage(locale,"adm.payMethod4") %></td> --%>

			</tr>
			<tr>
				<td height="5" colspan="4">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>

			<tr>
<!-- 				<td height="30" > -->
<%-- 					<input name="paymentType" type="radio" value="CREDIT CARD AUTH" /><%=MessageResources.getMessage(locale,"adm.payMethod1.authForm") %> --%>
<%-- 					(<a href="/upload/Admission at ward/Credit Card Mail Order Authorzation Form.pdf" target="_blank"><%=MessageResources.getMessage(locale,"label.click.here") %></a>) (<%=MessageResources.getMessage(locale,"adm.payMethod1.depositOnly") %>)<br /> --%>
<!-- 						<br /> -->
<%-- 						<font color="red">**</font><%=MessageResources.getMessage(locale,"adm.payMethodAttach") %><br /> --%>
<!-- 					<table> -->
<!-- 					<tr> -->
<!-- 						<td> -->
<!-- 							<input type="file" name="file2" size="10" class="multi" maxlength="5"/> -->
<!-- 						</td> -->
<%-- 						<td><%=MessageResources.getMessage(locale, "adm.faxNo") %>: 36518801 --%>
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 					</table> -->
<!-- 				</td> -->
				<td height="30"  valign="top">
		  	<div id="insuranceRemarks">
				<table id="insurance">
				  <tr>
					<td><input name="paymentType" type="radio" value="INSURANCE" onclick="changePaymentType();"/><%=MessageResources.getMessage(locale,"adm.payMethod12") %></td>
				  </tr>
				  <tr>
					<td >&nbsp;&nbsp;&nbsp;&nbsp;<%=MessageResources.getMessage(locale,"adm.insurance.company") %>: <input type="text" name="insuranceRemarks" maxlength="100" size="30" value="<%=insuranceRemarks==null?"":insuranceRemarks %>" style="text-transform: uppercase"/></td>
				  </tr>
				</table>
			</div>
				</td>
<%--  				<td height="30"  valign="top"><input name="paymentType" type="radio" value="CORPORATE" onclick="changePaymentType()"/><%=MessageResources.getMessage(locale,"adm.payMethod6") %></td> --%>
<!-- 				<td height="30"  valign="top"> -->
<%-- 					<input name="paymentType" type="radio" value="OTHER" onclick="changePaymentType();"/><%=MessageResources.getMessage(locale, "label.others") %><br /> --%>
<!-- 					<input type="text" name="paymentTypeOther" maxlength="100" size="20" /> -->
<!-- 				</td> -->
			</tr>


</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="3%"><input type="checkbox" name="paymentDeclare" value="1"/></td>
										<%--
										<td><input type="checkbox" name="q3_a7" value="1" <%if ("1".equals(q3_a7)) {%>checked<%} %>/>Others:&nbsp;
										 --%>
							<td><%=MessageResources.getMessage(locale, "adm.payMethod14")%>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
					</table>
</br>
<table>
	<tr>
		<td>
			<font color="red"></font><%=MessageResources.getMessage(locale,"adm.payMethodAttach") %><br />
			<table>
				<tr>
					<td>
						<input type="file" name="file2" size="10" class="multi" maxlength="5"/>
					</td>
					<td>
						<%=MessageResources.getMessage(locale, "adm.faxNo") %>: 36518801 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=MessageResources.getMessage(locale, "adm.emailAdd") %>: hkahpsr@hkah.org.hk
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<br />
<br />
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<%if ("chi".equals(language)){ %>
				點擊"確認付款方法",即表示您已確認資料無誤以及同意
				<a href="<%=DocumentDB.getURL("122") %>" target="_blank">條款及細則</a>
				和
				<a onclick=" downloadFile('767', ''); return false;" href="javascript:void(0);" target="_blank">關於《個人資料 (私隱) 條例》("私隱條例") 的政策指引</a>
			<%} else { %>
				By clicking Payment Method Confirm, I agree that I have read and understood the
				<a href="<%=DocumentDB.getURL("121") %>" target="_blank">Terms & Conditions</a>
				and
				<a onclick=" downloadFile('632', ''); return false;" href="javascript:void(0);" target="_blank">Policy Statement relating to the Personal Data (Privacy) Ordinance</a>
			<%} %>
		</td>
	</tr>
</table>
<div class="pane">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td align="center">
		<!-- <button class="btn-submit" onclick="submitAction();return false;"><%=MessageResources.getMessage(locale, "adm.preview") %></button> -->
		<button class="btn-submit" onclick="submitAction();return false;"><%=MessageResources.getMessage(locale, "adm.PaymentMethodConfirm") %></button>
		</td>
	</tr>
</table>
</div>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><font color="red"></font><%=MessageResources.getMessage(locale, "adm.versionMsg") %></td>
	</tr>
</table>
<input type="hidden" name="vpc_Version" value="1" size="20" maxlength="8"/>
<input type="hidden" name="vpc_Command" value="pay" size="20" maxlength="16"/>
<input type="hidden" name="vpc_AccessCode" value="D0E9C019" size="20" maxlength="8"/>
<input type="hidden" name="vpc_MerchTxnRef" value="<%=admissionID==null?"":admissionID %>" size="20" maxlength="40"/>
<input type="hidden" name="vpc_Merchant" value="TESTHASEMIGS" size="20" maxlength="16"/>
<input type="hidden" name="vpc_OrderInfo" value="" size="20" maxlength="34"/>
<input type="hidden" name="vpc_Amount" value="<%=vpc_Amount %>" size="20" maxlength="10"/>
<!-- <input type="hidden" name="vpc_ReturnURL" size="63" value="http://160.100.2.99:8080/intranet/registration/admission_payment_return.jsp" maxlength="250"/> -->
<input type="hidden" name="vpc_Locale" value="en" size="20" maxlength="5"/>

<input type="hidden" name="patpassport" value="<%=patpassport==null?"":patpassport %>" />
<input type="hidden" name="patidno1" value="<%=patidno1==null?"":patidno1 %>" />
<input type="hidden" name="patidno2" value="<%=patidno2==null?"":patidno2 %>" />
<input type="hidden" name="roomType" value="<%=roomType==null?"":roomType %>" />
<input type="hidden" name="admissionID" value="<%=admissionID==null?"":admissionID %>" />
<input type="hidden" name="language" value="<%=language%>"/>
<a class="iframe" id="show_info_tree" href="../registration/information_tree.jsp?language=<%=language %>&style=popup" ></a>
</form>
</div>
</div>
</DIV>
</DIV>
<div  class="push"></div>
 <table  width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
</table>
</DIV>

<jsp:include page="admission_footer.jsp" flush="false" />

<script language="javascript">

$(document).ready(function() {
	var wSize = getWindowsSize();
	var infoW = wSize.width;
	var infoH = wSize.height;
	if (infoW > 1280) infoW = 1280;
	infoW = infoW - 100;
	if (infoH > 1024) infoW = 1024;
	infoH = infoH - 100;
/*
	window.addEventListener('beforeunload', function (e) {
		  // Cancel the event as stated by the standard.
		  e.preventDefault();
		  // Chrome requires returnValue to be set.
		  e.returnValue = '';
		});


	$(window).on('beforeunload', function() {
		return 'Your own message goes here...';
	});
*/
	});

	function submitAction() {
		var msg = '';
		var focusField;
		var count = 1;
		var checkAdmissionDateFail = false;
		var agreeement2CheckFail = false;
		var expectedAdmissionDateInvalid = false;

		$(".hightLight").removeClass();

		var payment=document.getElementsByName("paymentType");
		var checkPayment = 'false';
		for(k=0;k<payment.length;k++){

			if (payment[k].checked){
				checkPayment = 'true';
			}
		}
		if (checkPayment == 'false'){
			focusField = document.form1.paymentType[0];
			$('div#payType').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg=msg + '付款方法\n';
			} else {
				msg=msg + 'Payment Method\n';
			}
		}
//		the field Credit Card Authorization Form is removed, so now the paymentType[4] is Insurance A/C
// 		if (document.form1.paymentType[4].checked){
// 				if (checkUploadFile()=='1'){
// 					if (document.form1.language.value =='chi'){
// 						alert('請附上或傳真信用卡副本及授權書.\n');
// 					} else {
// 						alert('Please Attach or Fax Credit Card copy and Authorization Form.\n');
// 					}
// 				}
// 			}

		// Insurance A/C
		if (document.form1.paymentType[3].checked){
			//if (checkUploadFile()=='1'){
			//	if (document.form1.language.value =='chi'){
			//		alert('請附上或傳真保險卡詳細資料以供核實.\n');
			//	} else {
			//		alert('Please Attach or Fax Insurance Card Details for verification.\n');
			//	}
			//}
			if (!document.form1.insuranceRemarks.value){
				$('div#insuranceRemarks').addClass("hightLight");
				if (document.form1.language.value =='chi'){
					msg=msg + '保險公司名稱\n';
				} else {
					msg=msg + 'Insurance Company Name\n';
				}
			}
		}

		// This field is removed
		// Payment Type : Others
		////if (document.form1.paymentType[6].checked){

		//if (document.form1.paymentType[5].checked){
		//	if (!document.form1.paymentTypeOther.value){
		//		if (document.form1.language.value =='chi'){
		//			msg=msg + '其他公司\n';
		//		} else {
		//			msg=msg + 'Other Company\n';
		//		}
		//	}
		//}

		if (!document.form1.agreement2.checked) {
			if (msg.length == 0) focusField = document.form1.agreement2;
			$(document.form1.agreement2).parent().parent().find('div#paymentMsg').addClass("hightLight");
			agreeement2CheckFail = true;
		}

		if (msg.length > 0
				|| checkAdmissionDateFail || agreeement2CheckFail) {
			if (document.form1.language.value =='chi'){
				msg = '請選擇或輸入以下尚未載入的資料:\n\n' + msg + '\n';
			} else {
				msg = 'The following fields are missing.  Please enter:\n' + msg + '\n';
			}

			if (agreeement2CheckFail) {
				if (document.form1.language.value =='chi'){
					msg = msg + '請  ✔  以確定已細閱每日房租和預繳按金\n';
				} else {
					msg = msg + 'Please  ✔  to confirm the acknowledgement of "Daily Room Rate and Advance Payment".\n';
				}
			}
			if (document.form1.language.value =='chi'){
				msg = msg + '\n' + '如有任何查詢，請致電熱線電話 3651 8740.';
			} else {
				msg = msg + '\n' + 'Kindly contact our hotline at 36518740 if you need further assistance.';
			}

			alert(msg);
			$(focusField).focus();
			// alert($(focusField).css());
			return false;
		} else {
			var checkBox=document.getElementsByName("imptInfo");

			$(".uppercase").each(
					function(){
						if (this.value != '') {
							this.value = this.value.toUpperCase();
						}
					}
				);

			if (checkBox.length > 0){
				for (j = 0; j < checkBox.length; j++ ) {
					if (checkBox[j].checked == false){
					$('form[name="form1"]').append('<input type="hidden" name="unselectedInfo" value="'+checkBox[j].value+'" />');
					}
				}
			}
			//if ( document.form1.creditCardType.value == "Visa/Master" ) {
			//	document.form1.action = "admission_vpc_serverhost_DO.jsp";
			//} else {
			//	document.form1.action = "online_admission_submit.jsp";
			//}

			document.form1.action = "admission_update_payment.jsp" ;
			document.form1.submit();

		}

	}

	function changePaymentType() {
		if (document.form1.creditCardType.value != '') {
			document.form1.paymentType[0].checked = true;
		}
		return false;
	}

	function checkAdmissionDate() {
		var expectedAdmissionDate = document.form1.expectedAdmissionDate.value;
		var deadline = '<%=DateTimeUtil.getCurrentDate() %>';
		return parseDate(expectedAdmissionDate) - parseDate(deadline) > 0;
	}

	function checkUploadFile() {
		var index = '1';
		var fileBox = $('#MultiFile' + index + '_wrap_list');
		if (fileBox && fileBox.html() == '') {
			return 1;
		}
	}

	function closeAction() {
		//var yes = confirm("Are you sure to close this page?\nThe admission form will be removed.");
		var yes = true;
		if (yes) {
			window.open('', '_self', '');
			window.close();
		}
	}

//Disable go back
//	history.pushState(null, null, location.href);
//	window.onpopstate = function () {
//	alert("Admission in process");
//	history.go(1);
//		return false;
//	};

</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>