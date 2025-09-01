<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
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

String address = null;
int httpPort = 80;
String contextPath = null;
String protocol = null;
String action = null;

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
	address = request.getLocalAddr();
	if (address == null || "0.0.0.0".equals(address)) {
		address = request.getServerName();
	}
	httpPort = request.getServerPort();
	contextPath = request.getContextPath();
	protocol = "http";

	if (ConstantsServerSide.SECURE_SERVER) {
		protocol = "https";
		if (httpPort == 8080) {
			httpPort = 8443;
		} else {
			httpPort = 443;
		}
	}

	action = protocol + "://" + address + ":" + httpPort + contextPath + "/registration/admission_client_landing.jsp?sessionKey=" + sessionKey;
}

// clear session and cookie
if (pageNoInt == 1) {
	UserBean userBean = new UserBean(request);
	userBean.invalidate(request, response);
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
<%@ page language="java" contentType="text/html; charset=big5" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<center>
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td align="left"><img src="../images/logo_hkah.gif" border="0" width="261" height="113" /></td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<table width="700" border="0" cellpadding="0" cellspacing="0">
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
									<td class="<%=label1 %>" width="20%"><p>Online check-in<br />網上登記入院</p></td>
									<td class="<%=label2 %>" width="20%"><p>Identification<br />身份證明</p></td>
									<td class="<%=label3 %>" width="20%"><p>Insurance<br />保險</p></td>
									<td class="<%=label4 %>" width="20%"><p>Others<br />其他</p></td>
									<td class="<%=label5 %>" width="20%"><p>Registration<br />登記</p></td>
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
									<p><span class="enquiryLabel extraBigText">Online check-in 網上登記入院</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">Thank you for using Hong Kong Adventist Hospital and our online check-in system. The online check-in system aims to smoothen your hospital registration procedure. We will contact you to confirm your admission once the information is verified.</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">多謝使用香港港安醫院和本院的網上登記入院服務。此網上登記入院系統旨在令閣下登記入院的流程更順暢。一旦核實有關資料，本院會與閣下聯絡，以確認閣下的入院登記。</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText"><font color="red">As a security measure, if you leave the registration idle for 10 minutes your registration will “time out” and you will lose the details already entered.</font></span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText"><font color="red">基於資料保安理由﹐如果您在填寫登記表期間連續閒置10分鐘﹐登記將會“超時”﹐而您之前填寫的資料將會被刪除。</font></span></p>
<%} else if (pageNoInt == 2) { %>
									<p><span class="enquiryLabel extraBigText">Identification 身份證明</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">Hong Kong Department of Health regulations require either <B>HKID</B> or <B>passport</B> for admission into hospital for treatment.</span></p>
									<p><span class="admissionLabel bigText">If your child does not have a valid HKID or passport, a copy of his/her birth certificate is required.</span></p>
									<p><span class="admissionLabel bigText">This hospital cannot admit or treat any person without a valid HKID or passport.  Please ensure that you have identification ready to avoid any delays.</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">根據香港衛生署規定，凡入院接受治療者須提供香港身份證或護照以作登記之用。</span></p>
									<p><span class="admissionLabel bigText">如果閣下的小孩沒有有效的香港身份證或護照，即須提供其出生證明書的副本。</span></p>
									<p><span class="admissionLabel bigText">本院不能為沒有有效香港身份證或護照的人士登記入院，或提供治療。煩請閣下在登記前確定備有有關身份證明，以免引致任何延誤。</span></p>
<%} else if (pageNoInt == 3) { %>
									<p><span class="enquiryLabel extraBigText">Insurance 保險</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">This hospital contracts with a number of insurance companies in Hong Kong and several international carriers.  Direct billing is available with our contracted insurers.</span></p>
									<p><span class="admissionLabel bigText">You may need precertification or pre-approval from your insurance carrier for planned admissions. You may contact our Admission Office to see if a letter of guarantee has been received.</span></p>
									<p><span class="admissionLabel bigText">You should call your insurance company to verify benefits prior to admission as this may affect your room category choice.</span></p>
									<p><span class="admissionLabel bigText">The patient is responsible for any co-pay (deductibles or policy excess) and/or coinsurance payments or any non-covered amounts.</span></p>
									<p><span class="admissionLabel bigText">If current proof of insurance is not presented, the patient is responsible for full payment of hospital services.  A deposit will be required and then at the end of the stay if insurance information is still not available, the patient will be charged the full amount of the hospital stay.  Retain your billing statements and contact your insurance company for reimbursement.</span></p>
									<p><span class="admissionLabel bigText">This hospital reserves the right to refuse any insurance card or documentation as payment for services.</span></p>
									<p><span class="admissionLabel bigText">All accounts must either be guaranteed by an insurance company or settled before discharge.</span></p>
									<p><span class="admissionLabel bigText">Detailed itemized billing statements are available through our Admission Office.</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">本院與部份香港及國際保險機構有聯系，可以直接把賬單發給該機構。</span></p>
									<p><span class="admissionLabel bigText">閣下在計劃入院以前，可能需要預先跟所屬的保險公司登記或得到其同意。閣下可以與本院的入院登記處聯絡，查詢本院是否已收到有關的保證信。</span></p>
									<p><span class="admissionLabel bigText">閣下應在登記入院前跟所屬的保險公司聯絡，確定自己的的保障範圍。此資料可能影響閣下所選擇的房間類別。</span></p>
									<p><span class="admissionLabel bigText">病人須承擔任何共同承擔醫療費用（自負額或附加條款）及╱或共同保險款項或任何非保障範圍金額。</span></p>
									<p><span class="admissionLabel bigText">如沒法出示有關保險的證明，病人須支付全額醫療費用。病人須支付按金，如在離院時仍未能提供有關的保險資料，便須支付住院期間的全額醫療費用。請保留賬單收據，並聯絡所屬的保險公司索取賠償。</span></p>
									<p><span class="admissionLabel bigText">本院保留權利，拒絕接受以任何保險醫療咭或文件支付賬項的方式。</span></p>
									<p><span class="admissionLabel bigText">所有賬項必須得到保險公司承擔的保證，或於出院前清付。</span></p>
									<p><span class="admissionLabel bigText">賬單詳細分列條目可向本院入院登記處查閱。</span></p>
<%} else { %>
									<p><span class="enquiryLabel extraBigText">Others 其他</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">There is a 48 hours requirement notice for room category change following non-packaged surgery.</span></p>
									<p><span class="admissionLabel bigText">"Private room" is any type of single occupancy room regardless of the number of beds.</span></p>
									<p><span class="admissionLabel bigText">A visitor may stay overnight in "private rooms" or with paediatric patients in our care only.</span></p>
									<p><span class="admissionLabel bigText">Please bring along personal items such as dressing gown, slippers, shaving gear and toiletries.</span></p>
									<p><span class="admissionLabel bigText">We will endeavor to meet all room category requests but availability is on a first-come-first-serve basis.  You are welcome to choose another room category in which case published rates apply.</span></p>
									<p><span class="admissionLabel bigText">Once a package has commenced, it cannot be down graded but can be upgraded.  If an upgrade applies, the entire package will be charged at the higher rate.</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">沒有參加手術套餐計劃的人士如需要更改房間類別，必須於48小時前通知本院。</span></p>
									<p><span class="admissionLabel bigText">「私家房」乃單獨使用的病房，非視乎病房內的病床數目而定。</span></p>
									<p><span class="admissionLabel bigText">不多於一名訪客可於「私家房」或陪伴兒科病人過夜。</span></p>
									<p><span class="admissionLabel bigText">請自備個人物品，例如浴衣、拖鞋、刮刀及衛生用品。</span></p>
									<p><span class="admissionLabel bigText">閣下可以參考標準病房租金，並按需要選擇不同的房間類別。我們會盡力滿足閣下的要求，並以先到先得形式及視乎實際情況而分配。</span></p>
									<p><span class="admissionLabel bigText">套餐計劃一旦確認，房間類別只能上調而不能下調，且所有相關的服務收費亦將隨房間類別調整。</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">Admission Office 入院登記處</span></p>
									<p><span class="admissionLabel bigText">Tel 電話:   36518805</span></p>
									<p><span class="admissionLabel bigText">Email 電郵: <a href="mailto:admission@hkah.org.hk">admission@hkah.org.hk</a></span></p>
<%} %>
								</td>
							</tr>
							<tr>
								<td height="50">&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="pane">
							<table>
								<tr>
									<td>
										<form name="form1" action="intro.jsp" method="post">
<%	if (pageNoInt > 1) { %>
										<button onclick="pageAction('<%=pageNoInt - 1 %>');return false;" class="btn-click">Previous Page 上一頁</button>
<%	} %>
<%	if (pageNoInt < 4) { %>
										<button onclick="pageAction('<%=pageNoInt + 1 %>');return false;" class="btn-click">&nbsp;&nbsp;Next Page 下一頁&nbsp;&nbsp;</button>
<%	} %>
										<input type="hidden" name="pageNo" />
										<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
										</form>
									</td>
									<td>
										<form name="form2" action="<%=action %>" method="post">
<%	if (pageNoInt > 3) { %>
										<button onclick="submitAction();return false;" class="btn-click">Read and Agree 已閱讀及同意</button>
<%	} %>
										<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
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
</center>
<script language="javascript">
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