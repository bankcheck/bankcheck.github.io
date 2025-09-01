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
									<td class="<%=label1 %>" width="20%"><p>Online check-in<br />���W�n�O�J�|</p></td>
									<td class="<%=label2 %>" width="20%"><p>Identification<br />�����ҩ�</p></td>
									<td class="<%=label3 %>" width="20%"><p>Insurance<br />�O�I</p></td>
									<td class="<%=label4 %>" width="20%"><p>Others<br />��L</p></td>
									<td class="<%=label5 %>" width="20%"><p>Registration<br />�n�O</p></td>
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
									<p><span class="enquiryLabel extraBigText">Online check-in ���W�n�O�J�|</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">Thank you for using Hong Kong Adventist Hospital and our online check-in system. The online check-in system aims to smoothen your hospital registration procedure. We will contact you to confirm your admission once the information is verified.</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">�h�¨ϥέ����w��|�M���|�����W�n�O�J�|�A�ȡC�����W�n�O�J�|�t�Φ��b�O�դU�n�O�J�|���y�{�󶶺Z�C�@���꦳ֹ����ơA���|�|�P�դU�p���A�H�T�{�դU���J�|�n�O�C</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText"><font color="red">As a security measure, if you leave the registration idle for 10 minutes your registration will ��time out�� and you will lose the details already entered.</font></span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText"><font color="red">����ƫO�w�z�ѡM�p�G�z�b��g�n�O������s�򶢸m10�����M�n�O�N�|���W�ɡ��M�ӱz���e��g����ƱN�|�Q�R���C</font></span></p>
<%} else if (pageNoInt == 2) { %>
									<p><span class="enquiryLabel extraBigText">Identification �����ҩ�</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">Hong Kong Department of Health regulations require either <B>HKID</B> or <B>passport</B> for admission into hospital for treatment.</span></p>
									<p><span class="admissionLabel bigText">If your child does not have a valid HKID or passport, a copy of his/her birth certificate is required.</span></p>
									<p><span class="admissionLabel bigText">This hospital cannot admit or treat any person without a valid HKID or passport.  Please ensure that you have identification ready to avoid any delays.</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">�ھڭ���å͸p�W�w�A�Z�J�|�����v���̶����ѭ��䨭���ҩ��@�ӥH�@�n�O���ΡC</span></p>
									<p><span class="admissionLabel bigText">�p�G�դU���p�ĨS�����Ī����䨭���ҩ��@�ӡA�Y�����Ѩ�X���ҩ��Ѫ��ƥ��C</span></p>
									<p><span class="admissionLabel bigText">���|���ର�S�����ĭ��䨭���ҩ��@�Ӫ��H�h�n�O�J�|�A�δ��Ѫv���C�нлդU�b�n�O�e�T�w�Ʀ����������ҩ��A�H�K�ޭP���󩵻~�C</span></p>
<%} else if (pageNoInt == 3) { %>
									<p><span class="enquiryLabel extraBigText">Insurance �O�I</span></p>
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
									<p><span class="admissionLabel bigText">���|�P��������ΰ�ګO�I���c���p�t�A�i�H��������o���Ӿ��c�C</span></p>
									<p><span class="admissionLabel bigText">�դU�b�p���J�|�H�e�A�i��ݭn�w������ݪ��O�I���q�n�O�αo���P�N�C�դU�i�H�P���|���J�|�n�O�B�p���A�d�ߥ��|�O�_�w���즳�����O�ҫH�C</span></p>
									<p><span class="admissionLabel bigText">�դU���b�n�O�J�|�e����ݪ��O�I���q�p���A�T�w�ۤv�����O�ٽd��C����ƥi��v�T�դU�ҿ�ܪ��ж����O�C</span></p>
									<p><span class="admissionLabel bigText">�f�H���Ӿ����@�P�Ӿ������O�Ρ]�ۭt�B�Ϊ��[���ڡ^�΢��Φ@�P�O�I�ڶ��Υ���D�O�ٽd����B�C</span></p>
									<p><span class="admissionLabel bigText">�p�S�k�X�ܦ����O�I���ҩ��A�f�H����I���B�����O�ΡC�f�H����I�����A�p�b���|�ɤ����ണ�Ѧ������O�I��ơA�K����I��|���������B�����O�ΡC�ЫO�d��榬�ڡA���p�����ݪ��O�I���q�������v�C</span></p>
									<p><span class="admissionLabel bigText">���|�O�d�v�Q�A�ڵ������H����O�I�������Τ���I�㶵���覡�C</span></p>
									<p><span class="admissionLabel bigText">�Ҧ��㶵�����o��O�I���q�Ӿ᪺�O�ҡA�Ω�X�|�e�M�I�C</span></p>
									<p><span class="admissionLabel bigText">���ԲӤ��C���إi�V���|�J�|�n�O�B�d�\�C</span></p>
<%} else { %>
									<p><span class="enquiryLabel extraBigText">Others ��L</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">There is a 48 hours requirement notice for room category change following non-packaged surgery.</span></p>
									<p><span class="admissionLabel bigText">"Private room" is any type of single occupancy room regardless of the number of beds.</span></p>
									<p><span class="admissionLabel bigText">A visitor may stay overnight in "private rooms" or with paediatric patients in our care only.</span></p>
									<p><span class="admissionLabel bigText">Please bring along personal items such as dressing gown, slippers, shaving gear and toiletries.</span></p>
									<p><span class="admissionLabel bigText">We will endeavor to meet all room category requests but availability is on a first-come-first-serve basis.  You are welcome to choose another room category in which case published rates apply.</span></p>
									<p><span class="admissionLabel bigText">Once a package has commenced, it cannot be down graded but can be upgraded.  If an upgrade applies, the entire package will be charged at the higher rate.</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">�S���ѥ[��N�M�\�p�����H�h�p�ݭn���ж����O�A������48�p�ɫe�q�����|�C</span></p>
									<p><span class="admissionLabel bigText">�u�p�a�Сv�D��W�ϥΪ��f�СA�D���G�f�Ф����f�ɼƥئөw�C</span></p>
									<p><span class="admissionLabel bigText">���h��@�W�X�ȥi��u�p�a�Сv�γ�����f�H�L�]�C</span></p>
									<p><span class="admissionLabel bigText">�Ц۳ƭӤH���~�A�Ҧp�D��B��c�B��M�νåͥΫ~�C</span></p>
									<p><span class="admissionLabel bigText">�դU�i�H�ѦҼзǯf�Я����A�ë��ݭn��ܤ��P���ж����O�C�ڭ̷|�ɤO�����դU���n�D�A�åH������o�Φ��ε��G��ڱ��p�Ӥ��t�C</span></p>
									<p><span class="admissionLabel bigText">�M�\�p���@���T�{�A�ж����O�u��W�զӤ���U�աA�B�Ҧ��������A�Ȧ��O��N�H�ж����O�վ�C</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
									<p><span class="admissionLabel bigText">Admission Office �J�|�n�O�B</span></p>
									<p><span class="admissionLabel bigText">Tel �q��:   36518805</span></p>
									<p><span class="admissionLabel bigText">Email �q�l: <a href="mailto:admission@hkah.org.hk">admission@hkah.org.hk</a></span></p>
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
										<button onclick="pageAction('<%=pageNoInt - 1 %>');return false;" class="btn-click">Previous Page �W�@��</button>
<%	} %>
<%	if (pageNoInt < 4) { %>
										<button onclick="pageAction('<%=pageNoInt + 1 %>');return false;" class="btn-click">&nbsp;&nbsp;Next Page �U�@��&nbsp;&nbsp;</button>
<%	} %>
										<input type="hidden" name="pageNo" />
										<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
										</form>
									</td>
									<td>
										<form name="form2" action="<%=action %>" method="post">
<%	if (pageNoInt > 3) { %>
										<button onclick="submitAction();return false;" class="btn-click">Read and Agree �w�\Ū�ΦP�N</button>
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