<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String sessionKey = request.getParameter("sessionKey");
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
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<table width="800" border="0" cellpadding="0" cellspacing="0">
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
<table width="800" cellpadding="0" cellspacing="0" border="0">
	<tr valign="center">
		<td class="step1_1" width="33%"><p>Check Personal Information<br>�ˬd�ӤH���</p></td>
		<td class="step1_2" width="33%"><p>Input Personal Information<br>�ˬd�ӤH���</p></td>
		<td class="step1_3" width="33%"><p>Submit Personal Information<br>�ǰe�ӤH���</p></td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><font color="red">*</font>Please fill in the form �ж�g�������.</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
	<tr>
		<td><strong>�Щ�J�|�e�̤֤@�Ӥu�@�ѲӾ\"��|����"�ç������W�n�O�{��</strong></td>
	</tr>
	<tr>
		<td>
			<div align="center" class="style2">
				<div align="left" class="style1"><U>In order to allow time for preparation, please read the Health Care Advisory before submitting this admission form one day prior to your admission.</U></div>
			</div>
		</td>
	</tr>
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
</table>
<form name="form1" action="admission_client_confirm.jsp" method="post">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="5" height="25" bgcolor="#AA3D01">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong>Personal Information �ӤH���</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
			<font color="red">*</font>
			<table width="100%">
				<tr>
					<td>
						<input type="radio" name="patidType" value="hkid" onclick="validHKID();" checked>Hong Kong I.D. Card<br />���䨭���Ҹ��X
						<input type="text" name="patidno1" value="" maxlength="8" size="8" onkeyup="validHKID();" onblur="validHKID()">(<input type="text" name="patidno2" value="" maxlength="2" size="2" onkeyup="validHKID();" onkeydown="validDOB();">)
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" name="patidType" value="passport" onclick="validPassport();">Passport No.<br />�@�Ӹ��X
						<input type="text" name="patpassport" value="" maxlength="20" size="25" onkeyup="validPassport();">
					</td>
				</tr>
				<tr>
					<td height="20">&nbsp;</td>
				</tr>
			</table>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Date of Birth (DD ��/MM ��/YYYY �~)<br />�X�ͤ��
			<input type="text" name="patbdate" id="patbdate" class="datepickerfield" value="" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
</table>
<div class="pane">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td align="center">
			<button class="btn-submit" onclick="submitClient();return false;">Check Personal Information �ˬd�ӤH���</button>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
</form>
<script language="javascript">
<!--//
	function validHKID() {
		if (document.form1.patidno1.value != '') {
			document.form1.patidType[0].checked = true;
			document.form1.patpassport.value = '';

			var hkid1 = document.form1.patidno1.value;
			var hkid2 = document.form1.patidno2.value;
			document.form1.patidno1.value = hkid1.toUpperCase();
			document.form1.patidno2.value = hkid2.toUpperCase();
		}
		return false;
	}

	function validPassport() {
		if (document.form1.patpassport.value != '') {
			document.form1.patidType[1].checked = true;
			document.form1.patidno1.value = '';
			document.form1.patidno2.value = '';

			document.form1.patpassport.value = document.form1.patpassport.value.toUpperCase();
			document.form1.patpassport.focus();
		}
		return false;
	}

	function validDOB() {
	}

	function submitClient() {
		if (document.form1.patidType[0].checked) {
			if (document.form1.patidno1.value == '') {
				alert('Empty Hong Kong I.D. Card �S����J���䨭���Ҹ�.');
				document.form1.patidno1.focus();
				return false;
			}
			if (document.form1.patidno2.value == '') {
				alert('Empty Hong Kong I.D. Card �S����J���䨭���Ҹ�.');
				document.form1.patidno2.focus();
				return false;
			}
			if (document.form1.patidno1.value.length < 7) {
				alert('Invalid Hong Kong I.D. Card ��J�����T���䨭���Ҹ�.');
				document.form1.patidno1.focus();
				return false;
			}
		}
		if (document.form1.patidType[1].checked && document.form1.patpassport.value == '') {
			alert('Empty Passport No. �S����J�@�Ӹ��X.');
			document.form1.patpassport.focus();
			return false;
		}
		if (document.form1.patbdate.value == '') {
			alert('Empty Date of Birth �S����J�X�ͤ��.');
			document.form1.patbdate.focus();
			return false;
		}
		if (!validDate(document.form1.patbdate)) {
			alert('Invalid Date of Birth ��J�����T�X�ͤ��.');
			document.form1.patbdate.focus();
			return false;
		}
		document.form1.submit();
	}
//-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>