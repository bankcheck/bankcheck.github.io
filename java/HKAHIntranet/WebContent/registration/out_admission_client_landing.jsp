<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.*"%>
<%
String sessionKey = request.getParameter("sessionKey");
String language = request.getParameter("language");

Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else if ("eng".equals(language)) {
	locale = Locale.US;
}

String appointmentDate = request.getParameter("appointmentDate");
String appointmentTime_hh = request.getParameter("appointmentTime_hh");
String appointmentTime_mi = request.getParameter("appointmentTime_mi");
String attendDoctor = request.getParameter("attendDoctor");

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
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/registration/background.css" />" />
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="admission_header.jsp" flush="false" />
<div class="normal_area">
	<div class="career_form">
	<table width="800" border="0" cellpadding="0" cellspacing="0">
		<tr valign="center">
			<td class="step2_1" width="33%"><p><%=MessageResources.getMessage(locale, "adm.checkInfo1") %></p></td>
			<td class="step2_2" width="33%"><p><%=MessageResources.getMessage(locale, "adm.checkInfo2") %></p></td>
			<td class="step2_3" width="33%"><p><%=MessageResources.getMessage(locale, "adm.checkInfo3") %></p></td>
		</tr>
	</table>
	<table width="800" border="0" cellpadding="0" cellspacing="0">	
		<tr>
			<td class="infoText"><%=MessageResources.getMessage(locale, "adm.fillInfo") %><%if(!"chi".equals(language)){ %><font color="red">*</font><%} %></td>
		</tr>	
	</table>
	<table width="800" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="20">&nbsp;</td>
		</tr>
		<tr>
			<td class="infoText"><strong><%=MessageResources.getMessage(locale, "out.adm.healthCareMessage") %></strong></td>
		</tr>
		<tr>
			<td height="20">&nbsp;</td>
		</tr>
	</table>
	
	<form name="form1" action="out_admission_client_confirm.jsp" method="post">
	<table width="800" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="5" height="25" bgcolor="#aa0066">
				<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(locale, "adm.hosInfo") %></strong></font></td>				
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height="20" colspan="5">&nbsp;</td>
		</tr>
		<tr>
			<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
				<table width="100%">
					<tr>
						<td><font color="red">*</font></td>
						<td>
							<input type="radio" name="patidType" value="hkid" onclick="validHKID();" checked><%=MessageResources.getMessage(locale, "adm.hkid") %>
							<input type="text" name="patidno1" value="" maxlength="8" size="8" onkeyup="validHKID();" onblur="validHKID()">(<input type="text" name="patidno2" value="" maxlength="2" size="2" onkeyup="validHKID();" onkeydown="validDOB();">)
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<input type="radio" name="patidType" value="passport" onclick="validPassport();"><%=MessageResources.getMessage(locale, "adm.passport") %>
							<input type="text" name="patpassport" value="" maxlength="20" size="25" onkeyup="validPassport();">
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<input type="radio" name="patidType" value="traveldoc" onclick="validTravelDoc();"><%=MessageResources.getMessage(locale, "out.adm.traveldocument") %>
							<input type="text" name="pattraveldoc" value="" maxlength="20" size="25" onkeyup="validTravelDoc();">
						</td>
					</tr>
					<tr>
						<td height="20">&nbsp;</td>
					</tr>
				</table>
			</td>
			<td width="2">&nbsp;</td>
			<td height="40" valign="top" bgcolor="#F9F9F9">
				<font color="red">*</font><%=MessageResources.getMessage(locale, "adm.dateOfBirth") %><%=MessageResources.getMessage(locale, "adm.ddmmyyyy") %>
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
				<button class="btn-submit" onclick="submitClient();return false;"><%=MessageResources.getMessage(locale, "adm.button.ckPersonalInfo") %></button>
			</td>
		</tr>
	</table>
	</div>
</div>
</div>
<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
<input type="hidden" name="language" value="<%=language%>" />
<input type="hidden" name="appointmentDate" value="<%=appointmentDate==null?"":appointmentDate %>" />
<input type="hidden" name="appointmentTime_hh" value="<%=appointmentTime_hh==null?"":appointmentTime_hh %>" />
<input type="hidden" name="appointmentTime_mi" value="<%=appointmentTime_mi==null?"":appointmentTime_mi %>" />
<input type="hidden" name="attendDoctor" value="<%=attendDoctor==null?"":attendDoctor %>" />
</form>
<script language="javascript">
<!--//
	function validHKID() {
		if (document.form1.patidno1.value != '') {
			document.form1.patidType[0].checked = true;
			document.form1.patpassport.value = '';
			document.form1.pattraveldoc.value = '';
			
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
			document.form1.pattraveldoc.value = '';

			document.form1.patpassport.value = document.form1.patpassport.value.toUpperCase();
			document.form1.patpassport.focus();
		}
		return false;
	}
	
	function validTravelDoc() {
		if (document.form1.pattraveldoc.value != '') {
			document.form1.patidType[2].checked = true;
			document.form1.patidno1.value = '';
			document.form1.patidno2.value = '';
			document.form1.patpassport.value = '';

			document.form1.pattraveldoc.value = document.form1.pattraveldoc.value.toUpperCase();
			document.form1.pattraveldoc.focus();
		}
		return false;
	}

	function validDOB() {
	}

	function submitClient() {
		if (document.form1.patidType[0].checked) {
			if (document.form1.patidno1.value == '') {
				alert('Empty Hong Kong I.D. Card 沒有輸入香港身份證號.');
				document.form1.patidno1.focus();
				return false;
			}
			if (document.form1.patidno2.value == '') {
				alert('Empty Hong Kong I.D. Card 沒有輸入香港身份證號.');
				document.form1.patidno2.focus();
				return false;
			}
			if (document.form1.patidno1.value.length < 7) {
				alert('Invalid Hong Kong I.D. Card 輸入不正確香港身份證號.');
				document.form1.patidno1.focus();
				return false;
			}
		}
		if (document.form1.patidType[1].checked && document.form1.patpassport.value == '') {
			alert('Empty Passport No. 沒有輸入護照號碼.');
			document.form1.patpassport.focus();
			return false;
		}
		if (document.form1.patidType[2].checked && document.form1.pattraveldoc.value == '') {
			alert('Empty Travel Document No. 沒有輸入旅遊證件號碼.');
			document.form1.pattraveldoc.focus();
			return false;
		}
		if (document.form1.patbdate.value == '') {
			alert('Empty Date of Birth 沒有輸入出生日期.');
			document.form1.patbdate.focus();
			return false;
		}
		if (!validDate(document.form1.patbdate)) {
			alert('Invalid Date of Birth 輸入不正確出生日期.');
			document.form1.patbdate.focus();
			return false;
		}
		document.form1.submit();
	}
//-->
</script>
<jsp:include page="admission_footer.jsp" flush="false" />
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>