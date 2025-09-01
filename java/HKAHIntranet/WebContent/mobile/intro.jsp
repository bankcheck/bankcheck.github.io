<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="java.util.*"%>
<%
// store session key
String sessionKey = request.getParameter("session");
String pageNo = request.getParameter("pageNo");
int pageNoInt = 0;
try {
	pageNoInt = Integer.parseInt(pageNo);
} catch (Exception e) {
	pageNoInt = 1;
}
String phoneModel = request.getParameter("phoneModel");
if (phoneModel == null) {
	phoneModel = "apple";
}

String label1 = null;
String label2 = null;
String label3 = null;
String label4 = null;
String label5 = null;
if (pageNoInt == 1) {
	label1 = "step1_1";
	label2 = "step1_2";
	label3 = "step1_2";
	label4 = "step1_2";
	label5 = "step1_3";
} else if (pageNoInt == 2) {
	label1 = "step2_1";
	label2 = "step2_2";
	label3 = "step1_2";
	label4 = "step1_2";
	label5 = "step1_3";
} else if (pageNoInt == 3) {
	label1 = "step3_1";
	label2 = "step3_2";
	label3 = "step2_2";
	label4 = "step1_2";
	label5 = "step1_3";
} else {
	label1 = "step3_1";
	label2 = "step3_1";
	label3 = "step3_2";
	label4 = "step2_2";
	label5 = "step1_3";
}

String step1_message = "Installation Mobile Application";
String step2_message = "Create Login ID and Password";
String step3_message = "Linkup your Account with Patient";
String step4_message = "Appointment Booking";
String step5_message = "My Appointment";

// clear session and cookie
if (pageNoInt == 1) {
	UserBean userBean = new UserBean(request);
	userBean.invalidate(request, response);
}

String site = "sr";
if (ConstantsServerSide.isTWAH()) {
	site = "tw";
}
%>
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="title" value="Hong Kong Adventist Hospital" />
</jsp:include>
<link rel="stylesheet" type="text/css" href="css/background.css" />
<body>
<div class="header_top_row">
<div class="normal_area">
<table style="width:100%">
<tr>
<%if (ConstantsServerSide.isTWAH()) { %>
	<td><a href="http://www.twah.org.hk/en/main"><img src="images/tw_logo_en.png" width="283" height="107"></a></td>
<%} else { %>
	<td><a href="http://www.hkah.org.hk/en/main"><img src="images/sr_logo_en.png" width="283" height="107"></a></td>
<%} %>
</tr>
</table>
</div>
</div>
<center style="background-color:white;" class="wrapper">
<div class="normal_area">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<table width="700" border="0" cellpadding="0" cellspacing="0" style="background-color:white;">
<tr>
	<td align="center">
	<b class="b1"></b><b class="b2"></b><b class="b3"></b><b class="b4"></b>
		<div class="contentb">
			<table width="690" border="0" cellpadding="0" cellspacing="0" style="background-color:white;">
				<tr>
					<td colspan="2">
						<span class="admissionLabel mediumText">
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr valign="center">
									<td class="<%=label1 %>" width="25%"><p><%=step1_message %></p></td>
									<td class="<%=label2 %>" width="20%"><p><%=step2_message %></p></td>
									<td class="<%=label3 %>" width="20%"><p><%=step3_message %></td>
									<td class="<%=label4 %>" width="20%"><p><%=step4_message %></p></td>
								</tr>
							</table>
						</span>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td rowspan="2" width="10">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td valign="top" align="left">
<%if (pageNoInt == 1) { %>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr style="background-color:#aa0066;">
											<td colspan="3" height="25" style="background-color:#aa0066;">
												<table width="80%" border="0" align="center" cellpadding="0"
													cellspacing="0">
													<tr>
														<td class="style1"><font color="white"><strong>Please select your mobile</strong></font></td>
													</tr>
												</table>
											</td>

													<td class="style1" ><%if ("android".equals(phoneModel)) { %><a href="intro.jsp?phoneModel=apple&session=<%=sessionKey%>"><font color="#ffffff">iOS</font></a><%} else {%><font color="#ffffff">iOS</font><%} %></td>
													<td class="style1" ><%if ("apple".equals(phoneModel)) { %><a href="intro.jsp?phoneModel=android&session=<%=sessionKey%>"><font color="#ffffff">Android</font></a><%} else {%><font color="#ffffff">Android</font><%} %></td>
										</tr>
														<tr>
															<td rowspan="2" width="10">&nbsp;</td>
															<td>&nbsp;</td>
														</tr>
									</table>
									<p><span class="headingLabel extraBigText"><%=step1_message %></span></p>
<%	if ("apple".equals(phoneModel)) { %>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">1) Check email that sent from vendor</p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><img src="images/apple_install.png"></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">2) Please download Testflight from appstore</p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">3) Then key in the redeem code from the vendor's email to install mobile app</p>
<%	} else { %>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">There are two ways to install mobile app into your android device</p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
<%		if (ConstantsServerSide.isTWAH()) { %>
									<p><span class="portalStyleLabel bigText">1) Please provide google play account (gmail) to IT Johnny Ho (Tel: 2835-1571 or Email:<a href="mailto:johnny.ho@twah.org.hk">johnny.ho@twah.org.hk</a>) for register in android. Then, browser <a href="https://play.google.com/apps/internaltest/4701133508773691995">here</a> and accept to join the testing.</span></p>
<%		} else { %>
									<p><span class="portalStyleLabel bigText">1) Please provide google play account (gmail) to IT Johnny Ho (Tel: 2835-1571 or Email:<a href="mailto:johnny.ho@hkah.org.hk">johnny.ho@hkah.org.hk</a>) for register in android. Then, browser <a href="https://play.google.com/apps/internaltest/4701133508773691995">here</a> and accept to join the testing.</span></p>
<%		} %>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><img src="images/android_install.png"></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">2) or download <a href="../mobile/mobile.apk">APK</a> to install</p>
<%	} %>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
<%} else if (pageNoInt == 2) { %>
									<p><span class="headingLabel extraBigText"><%=step2_message %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">Create your own account with username and password</p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><img src="images/register.png"></span></p>
<%} else if (pageNoInt == 3) { %>
									<p><span class="headingLabel extraBigText"><%=step3_message %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText"><img src="images/linkup.png"></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">1) Input the patient information based on the email from IT</p>
									<p><span class="portalStyleLabel bigText"><img src="images/linkup_patient_<%=site %>.png"></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">2) Select either mobile or email, input the mobile number of email address based on your selection then click "Get Code"</p>
									<p><span class="portalStyleLabel bigText"><img src="images/linkup_mobile.png"></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">3) Enter the code from SMS or email, then click "Linkup"</p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">4) Linkup successful</p>
									<p><span class="portalStyleLabel bigText"><img src="images/linkup_success.png"></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">5) Menu</p>
									<p><span class="portalStyleLabel bigText"><img src="images/menu_<%=site %>.png"></span></p>
<%} else { %>
									<p><span class="headingLabel extraBigText"><%=step4_message %></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">1) Search doctor from the list</p>
									<p><span class="portalStyleLabel bigText"><img src="images/booking1_<%=site %>.png"></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">2) or use Filter to limit the selection</p>
									<p><span class="portalStyleLabel bigText"><img src="images/booking2_<%=site %>.png"></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">3) Select time slot"</p>
									<p><span class="portalStyleLabel bigText"><img src="images/booking3_<%=site %>.png"></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">4) Confirm the booking</p>
									<p><span class="portalStyleLabel bigText"><img src="images/booking4_<%=site %>.png"></span></p>
									<p><span class="portalStyleLabel bigText">&nbsp;</span></p>
									<p><span class="portalStyleLabel bigText">5) Successful booking</p>
									<p><span class="portalStyleLabel bigText"><img src="images/booking5_<%=site %>.png"></span></p>
<%} %>
								</td>
							</tr>
							<tr>
								<td height="30">&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="pane">
							<table>
								<tr class="middleText">
									<td>
										<form name="form1" action="intro.jsp" method="post">
<%	if (pageNoInt > 1) { %>
											<button onclick="pageAction('<%=pageNoInt - 1 %>');return false;" class="btn-click">Previous</button>
<%	} %>
<%	if (pageNoInt < 4) { %>
											<button onclick="pageAction('<%=pageNoInt + 1 %>');return false;" class="btn-click">&nbsp;&nbsp;Next&nbsp;&nbsp;</button>
<%	} %>
											<input type="hidden" name="pageNo" />
											<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
											<input type="hidden" name="phoneModel" value="<%=phoneModel%>"/>
										</form>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</table>
		</div>
		<b class="b4"></b><b class="b3"></b><b class="b2"></b><b class="b1"></b>
	</td>
</tr>
</table>
<div class="push"></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
</table>
</div>
</center>
</br>
<div id="footer" class="footer" style="width:100%">
<div class="normal_area">
</br>
<table border="0" style="width:100%">
<%	if (ConstantsServerSide.isTWAH()) { %>
<tr><td style="color:white;font-size: 15px;text-align:left" colspan="2">Hong Kong Adventist Hospital - Tsuen Wan</td></tr>
<%	} else { %>
<tr><td style="color:white;font-size: 15px;text-align:left" colspan="2">Hong Kong Adventist Hospital - Stubbs Road</td></tr>
<%	} %>
</table>
<table border="0" style="width:100%">
<tr>
</br>
</br>
</br>
<td style="color:white;text-align:right">
      (C) 2020 Adventist Health. All Rights Reserved.
</td>
</tr>
</table>
</div>
</div>
<script phoneModel="javascript">
<!--//
	function pageAction(pno) {
		document.form1.pageNo.value = pno;
		document.form1.submit();
	}

	function submitAction() {
		document.form2.submit();
	}
//-->
</script>
</body>
</html:html>