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
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/registration/background.css" />" />
<body>
<DIV id="indexWrapper" class="wrapper" style="background-color:white;">
<DIV id="mainFrame">
<DIV style="background-color:white;width:100%">
<jsp:include page="admission_header.jsp" flush="false">
	<jsp:param name="language" value="<%=language %>" />
</jsp:include><table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>

</table>
<div class="normal_area">
<div class="career_form" style="padding: 20px 18px;">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr valign="center">
		<td class="step1_1" width="33%"><p><%=MessageResources.getMessage(locale, "adm.checkInfo1") %></p></td>
		<td class="step1_2" width="33%"><p><%=MessageResources.getMessage(locale, "adm.checkInfo2") %></p></td>
		<td class="step1_3" width="33%"><p><%=MessageResources.getMessage(locale, "adm.checkInfo3") %></p></td>
	</tr>
</table>
<br>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td style="color: #aa0066; "><%=MessageResources.getMessage(locale, "adm.fillInfo") %><%if(!"chi".equals(language)){ %><font color="red">*</font><%} %></td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
	<tr>
		<td style="color: #aa0066; "><strong><%=MessageResources.getMessage(locale, "adm.healthCareMessage1") %>
		<%	if ("chi".equals(language)) { %>
			<a href="<%=DocumentDB.getURL("115") %>" target="_blank"><%=MessageResources.getMessage(locale,"label.health.care.advisory") %></a>
<%	} else { %>
			<a href="<%=DocumentDB.getURL("114") %>" target="_blank"><%=MessageResources.getMessage(locale,"label.health.care.advisory") %></a>
<%	} %>
		<%=MessageResources.getMessage(locale, "adm.healthCareMessage2") %></strong></td>
	</tr>
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
</table>

<form name="form1" action="admission_client_confirm_vpc.jsp" method="post">
<!--form name="form1" action="admission_client_confirm_vpc.jsp" method="post"-->
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="5" height="25" style="background-color:#aa0066;">
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
		<td height="40" valign="top" colspan="3">
			<table width="100%">
				<tr>
					<td>
						<font color="red">*</font>
					</td>
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
					<td height="20">&nbsp;</td>
				</tr>
			</table>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top">
			<font color="red">*</font><%=MessageResources.getMessage(locale, "adm.dateOfBirth") %><%=MessageResources.getMessage(locale, "adm.ddmmyyyy") %>
			<input type="text" name="patbdate" id="patbdate" class="datepickerfield" value="" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top">
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top">
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top">
		</td>
	</tr>
	<tr>
		<td height="15" colspan="5">&nbsp;</td>
	</tr>
</table>
<div class="pane">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td  style="color: #aa0066; ">
			<%=MessageResources.getMessage(locale, "adm.stateForPersonal") %>
		</td>
	</tr>
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
	<tr class="middleText">
		<td align="center">			
			<button class="btn-submit" onclick="submitClient();return false;"><%=MessageResources.getMessage(locale, "adm.button.ckPersonalInfo") %></button>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
<input type="hidden" name="language" value="<%=language%>" />
</form>
</div>
</div>
<jsp:include page="admission_footer.jsp" flush="false" />
</DIV>
</DIV>
<div class="push"></div>
</DIV>

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
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>