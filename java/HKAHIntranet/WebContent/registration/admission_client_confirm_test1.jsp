<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String sessionKey = request.getParameter("session");

String patno = null;
String patfname = null;
String patgname = null;
String titleDesc = null;
String titleDescOther = null;
String patcname = null;

String patidno1 = request.getParameter("patidno1");
String patidno2 = request.getParameter("patidno2");
String patidno = patidno1 + patidno2;
String patpassport = request.getParameter("patpassport");
String patsex = null;
String racedesc = null;
String racedescOther = null;
String religion = null;
String religionOther = null;
String patbdate = request.getParameter("patbdate");
String patmsts = null;
String mothcode = null;
String mothcodeOther = null;
String edulevel = null;
String pathtel = null;
String patotel = null;
String patmtel = null;
String patftel = null;
String occupation = null;
String patemail = null;
String patadd1 = null;
String patadd2 = null;
String patadd3 = null;
String patadd4 = null;
String loccode = null;
String coucode = null;

String patkfname1 = null;
String patkgname1 = null;
String patkcname1 = null;
String patksex1 = null;
String patkrela1 = null;
String patkhtel1 = null;
String patkotel1 = null;
String patkmtel1 = null;
String patkptel1 = null;
String patkemail1 = null;
String patkadd11 = null;
String patkadd21 = null;
String patkadd31 = null;
String patkadd41 = null;

ArrayList record = null;
if (sessionKey != null && sessionKey.length() > 0) {
	record = SessionLoginDB.get(sessionKey);
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		patemail = row.getValue(0);
	}
}

if (patbdate != null && patbdate.length() > 0) {
	if (patidno != null && patidno.length() > 0) {
		record = AdmissionDB.getHATSPatient(null, patidno, patbdate);
	} else if (patpassport != null && patpassport.length() > 0) {
		record = AdmissionDB.getHATSPatient(null, patpassport, patbdate);
	}
	if (record != null && record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		patno = row.getValue(0);
		patfname = row.getValue(1);
		patgname = row.getValue(2);
		titleDesc = row.getValue(3);
		patcname = row.getValue(4);
		patidno = row.getValue(5);
//		if (patidno.length() >= 8 && patidno.length() <= 9) {
//			patidno1 = patidno.substring(0, 7);
//			patidno2 = patidno.substring(7);
//		} else {
//			patpassport = patidno;
//		}
		patsex = row.getValue(6);
		racedesc = row.getValue(7);
		religion = row.getValue(8);
//		patbdate = row.getValue(9);

		patmsts = row.getValue(10);
		mothcode = row.getValue(11);
		edulevel = row.getValue(12);
		pathtel = row.getValue(13);
		patotel = row.getValue(14);
		patmtel = row.getValue(15);
		patftel = row.getValue(16);
		occupation = row.getValue(17);
//		patemail = row.getValue(18);
		patadd1 = row.getValue(19);
		patadd2 = row.getValue(20);
		patadd3 = row.getValue(21);
		String patkname = row.getValue(22);
		int index = patkname.indexOf(" ");
		if (index > 0) {
			patkfname1 = patkname.substring(0, index);
			patkgname1 = patkname.substring(index + 1);
		}
		patkrela1 = row.getValue(23);
		patkhtel1 = row.getValue(24);
		patkptel1 = row.getValue(25);
		patkotel1 = row.getValue(26);
		patkmtel1 = row.getValue(27);
		patkemail1 = row.getValue(28);
		String patkadd = row.getValue(29);
		String[] patkaddArray = TextUtil.split(patkadd, ",");
		if (patkaddArray.length == 4) {
			patkadd11 = patkaddArray[0];
			patkadd21 = patkaddArray[1];
			patkadd31 = patkaddArray[2];
		} else {
			patkaddArray = TextUtil.split(patkadd, 40);
			patkadd11 = patkaddArray.length > 0 ? patkaddArray[0] : null;
			patkadd21 = patkaddArray.length > 1 ? patkaddArray[1] : null;
			patkadd31 = patkaddArray.length > 2 ? patkaddArray[2] : null;
		}
		loccode = row.getValue(30);
		coucode = row.getValue(31);
	}
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
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
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr valign="center">
		<td class="step2_1" width="33%"><p>Check Personal Information<br />檢查個人資料</p></td>
		<td class="step2_2" width="33%"><p>Input Personal Information<br />輸入個人資料</p></td>
		<td class="step2_3" width="33%"><p>Submit Personal Information<br />傳送個人資料</p>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><font color="red">*</font>Please fill in the form 請填寫有關資料.</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
	<tr>
		<td><strong>請於入院前最少一個工作天細閱"住院須知"並完成網上登記程序</strong></td>
	</tr>
	<tr>
		<td>
			<div align="center" class="style2"><div align="left" class="style1"><U>In order to allow time for preparation, please read the Health Care Advisory before submitting this admission form one day prior to your admission.</U></div></div>
		</td>
	</tr>
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
</table>
<form name="form1" enctype="multipart/form-data" action="admission_client_submit.jsp" method="post">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="3">
		<table width="700" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" colspan="3">
					<%=MessageResources.getMessageEnglish("label.health.care.advisory") %>
					<%=MessageResources.getMessageTraditionalChinese("label.health.care.advisory") %>
					(<a href="javascript:void(0);" onclick="downloadFile('75');return false;" target="_blank">Click here 請按此</a>)
				</td>
			</tr>
			<tr>
				<td height="20" colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td valign="top" width="5%"><font color="red">*</font> <input
					type="checkbox" name="agreement1" value="Y" /></td>
				<td valign="top" width="60%">
					I have read this &quot;Health Care Advisory&quot;. I understand and accept that the hospital services will be charged according to my choice of room category. <br />
					本人已清楚閱讀以上&quot;住院須知&quot;。本人明白並接受住院收費將根據本人所選擇的房間類別而計算。
				</td>
				<td valign="top" align="center" width="35%">
					<font color="red">*</font>My room choice is<br />
					本人選擇房間類別為<br />
					<select name="roomType">
						<option value=""></option>
						<option value="VIP">VIP 貴賓</option>
						<option value="Private">Private 頭等</option>
						<option value="Semi-Private">Semi-Private 二等</option>
						<option value="Standard">Standard 三等</option>
					</select>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3" height="25" bgcolor="#AA3D01">
		<table width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong>Hospital
				Information 醫院資料</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Expected
		admission date & time (DD 日/MM 月/YYYY 年 HH 時:MM 分)<br />
		預定入院日期 <input type="text" name="expectedAdmissionDate"
			id="expectedAdmissionDate" class="datepickerfield"
			value="<%=DateTimeUtil.getCurrentDate() %>" maxlength="10" size="10"
			onkeyup="validDate(this)" onblur="validDate(this)" /> <jsp:include
			page="../ui/timeCMB.jsp" flush="false">
			<jsp:param name="label" value="expectedAdmissionTime" />
			<jsp:param name="time" value="" />
		</jsp:include></td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Admitting
		Doctor<br />
		主診醫生 <input type="text" name="admissiondoctor" value="" maxlength="20"
			size="25"></td>
	</tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="5" height="25" bgcolor="#AA3D01">
		<table width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong>Personal
				Information 個人資料</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9"><font
			color="red">*</font>
		<table width="100%">
			<tr>
				<td><input type="radio" name="patidType" value="hkid"
					<%=patpassport==null||patpassport.length()==0?" checked":"" %>
					onclick="validHKID();">Hong Kong I.D. Card<br />
				香港身份證號碼 <input type="text" name="patidno1"
					value="<%=patidno1==null?"":patidno1 %>" maxlength="8" size="8"
					onkeyup="validHKID();" onblur="validHKID()">(<input
					type="text" name="patidno2"
					value="<%=patidno2==null?"":patidno2 %>" maxlength="2" size="2"
					onkeyup="validHKID();" onkeydown="validDOB(event);">)</td>
			</tr>
			<tr>
				<td><input type="radio" name="patidType" value="passport"
					<%=patpassport!=null&&patpassport.length()>0?" checked":"" %>
					onclick="validPassport();">Passport No.<br />
				護照號碼 <input type="text" name="patpassport"
					value="<%=patpassport==null?"":patpassport %>" maxlength="20"
					size="25" onkeyup="validPassport();"></td>
			</tr>
			<tr>
				<td height="20">&nbsp;</td>
			</tr>
			<tr>
				<td>Please Attach or Fax Copy of HKID / Passport for
				Verification Purpose<br />
				<font color="red">**</font>請附上或傳真身份證明或護照文件以作核對<br />
				<input type="file" name="file1" size="30" class="multi"
					maxlength="5"><br />
				<font color="red">**</font>Fax No 傳真號碼: 36518801</td>
			</tr>
		</table>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Date
		of Birth (DD 日/MM 月/YYYY 年)<br />
		出生日期 <input type="text" name="patbdate" id="patbdate"
			class="datepickerfield" value="<%=patbdate==null?"":patbdate %>"
			maxlength="10" size="10" onkeyup="validDate(this)"></td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9"><font
			color="red">*</font>Family Name as on I.D. Card/Passport<br />
		姓 (英文) <input type="text" name="patfname"
			value="<%=patfname==null?"":patfname %>" maxlength="60" size="25">
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9"><font
			color="red">*</font>Given Name as on I.D. Card/Passport<br />
		名 (英文) <input type="text" name="patgname"
			value="<%=patgname==null?"":patgname %>" maxlength="30" size="25">
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9"><font
			color="red">*</font>Title<br />
		稱謂 <select name="titleDesc">
			<option value=""></option>
			<option value="MR." <%="MR.".equals(titleDesc)?" selected":"" %>>Mr.
			先生</option>
			<option value="MRS" <%="MRS.".equals(titleDesc)?" selected":"" %>>Mrs.
			太太</option>
			<option value="MISS" <%="MISS".equals(titleDesc)?" selected":"" %>>Miss
			小姐</option>
			<option value="MS" <%="MS".equals(titleDesc)?" selected":"" %>>Ms.
			女士</option>
			<option value="">Others 其他</option>
		</select><br />
		Others<br />
		其他 : <input type="text" name="titleDescOther"
			value="<%=titleDescOther==null?"":titleDescOther %>" maxlength="10"
			size="20"></td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">Chinese Name<br />
		中文姓名 <input type="text" name="patcname"
			value="<%=patcname==null?"":patcname %>" maxlength="20" size="25">
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Sex<br />
		性別 <select name="patsex">
			<option value=""></option>
			<option value="M" <%="M".equals(patsex)?" selected":"" %>>M
			男</option>
			<option value="F" <%="F".equals(patsex)?" selected":"" %>>F
			女</option>
		</select></td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Marital
		Status<br />
		婚姻狀況 <select name="patmsts">
			<option value="">Other 其他</option>
			<option value="S" <%="S".equals(patmsts)?" selected":"" %>>Single
			未婚</option>
			<option value="M" <%="M".equals(patmsts)?" selected":"" %>>Married
			已婚</option>
			<option value="D" <%="D".equals(patmsts)?" selected":"" %>>Divorce
			離婚</option>
			<option value="X" <%="X".equals(patmsts)?" selected":"" %>>Separate
			分居</option>
		</select></td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Ethnic
		Group<br />
		種族 <select name="racedesc">
			<option value=""></option>
			<jsp:include page="../ui/raceDescCMB.jsp" flush="false">
				<jsp:param name="racedesc" value="<%=racedesc %>" />
			</jsp:include>
		</select><br />
		Others<br />
		其他 : <input type="text" name="racedescOther"
			value="<%=racedescOther==null?"":racedescOther %>" maxlength="10"
			size="20" /> <br />
		(For hospital statistic )</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Religion<br />
		宗教 <select name="religion">
			<option value="OT" <%="OT".equals(religion)?" selected":"" %>>Others
			其他</option>
			<option value="NO" <%="NO".equals(religion)?" selected":"" %>>None
			沒有</option>
			<option value="BU" <%="BU".equals(religion)?" selected":"" %>>Buddhism
			佛教</option>
			<option value="CA" <%="CA".equals(religion)?" selected":"" %>>Catholic
			天主教</option>
			<option value="CH" <%="CH".equals(religion)?" selected":"" %>>Christian
			基督教</option>
			<option value="HI" <%="HI".equals(religion)?" selected":"" %>>Hinduism
			印度教</option>
			<option value="SH" <%="SH".equals(religion)?" selected":"" %>>Shintoism
			日本神道教</option>
			<option value="SD" <%="SD".equals(religion)?" selected":"" %>>SDA
			基督復臨安息日教會</option>
		</select><br />
		Others<br />
		其他 : <input type="text" name="religionOther"
			value="<%=religionOther==null?"":religionOther %>" /></td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Education
		Level<br />
		教育程度 <select name="edulevel">
			<option value="Others">Others 其他</option>
			<option value="Primary"
				<%="Primary".equals(edulevel)?" selected":"" %>>Primary 小學</option>
			<option value="SECONDARY"
				<%="Secondary".equals(edulevel)?" Secondary":"" %>>Secondary
			中學</option>
			<option value="Tertiary or above"
				<%="Tertiary or above".equals(edulevel)?" selected":"" %>>Tertiary
			or above 大專或以上</option>
		</select></td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="2" colspan="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Written
		Language<br />
		語言 <select name="mothcode">
			<option value="ENG" <%="ENG".equals(mothcode)?" selected":"" %>>English
			英語</option>
			<option value="TRC" <%="TRC".equals(mothcode)?" selected":"" %>>Traditional
			Chinese 繁體中文</option>
			<option value="SMC" <%="SMC".equals(mothcode)?" selected":"" %>>Simplified
			Chinese 簡体中文</option>
			<option value="JAP" <%="JAP".equals(mothcode)?" selected":"" %>>Japanese
			日本語</option>
		</select><br />

		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Occupation<br />
		職業 <input name="occupation" type="text"
			value="<%=occupation==null?"":occupation %>" maxlength="20" size="25" />
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5" bgcolor="#F9F9F9"><font color="red">*</font>Contact
		Telephone Number<br />
		聯絡電話<br />
		<table width=100%">
			<tr>
				<td height="40" valign="top" bgcolor="#F9F9F9">Home<br />
				住宅 <input name="pathtel" type="text"
					value="<%=pathtel==null?"":pathtel %>" maxlength="20" size="25" />
				</td>
				<td width="2">&nbsp;</td>
				<td height="40" valign="top" bgcolor="#F9F9F9">Office<br />
				辦公室 <input name="patotel" type="text"
					value="<%=patotel==null?"":patotel %>" maxlength="20" size="25" />
				</td>
			</tr>
			<tr>
				<td height="40" valign="top" bgcolor="#F9F9F9">Mobile/Pager No<br />
				手提號碼/傳呼機號碼 <input name="patmtel" type="text"
					value="<%=patmtel==null?"":patmtel %>" maxlength="20" size="25" />
				</td>
				<td width="2">&nbsp;</td>
				<td height="40" valign="top" bgcolor="#F9F9F9">Fax No<br />
				傳真號碼 <input name="patftel" type="text"
					value="<%=patftel==null?"":patftel %>" maxlength="20" size="25" />
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td height="40" valign="top" bgcolor="#F9F9F9"><font
					color="red">*</font>Email Address<br />
				電郵地址 <input name="patemail" type="text"
					value="<%=patemail==null?"":patemail %>" maxlength="50" size="25" />
				</td>
				<td width="2">&nbsp;</td>
				<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9"><font
					color="red">*</font>Address<br />
				地址<br />
				<input type="text" name="patadd1"
					value="<%=patadd1==null?"":patadd1 %>" maxlength="40" size="50">Rm/Flat
				室/Floor 層/Block/Bldg 大廈<br />
				<input type="text" name="patadd2"
					value="<%=patadd2==null?"":patadd2 %>" maxlength="40" size="50">Road
				道路/Street 街道<br />
				<input type="text" name="patadd3"
					value="<%=patadd3==null?"":patadd3 %>" maxlength="40" size="50">District
				區域<br />
				<select name="coucode">
					<jsp:include page="../ui/countryCodeCMB.jsp" flush="false">
						<jsp:param name="coucode" value="<%=coucode %>" />
					</jsp:include>
				</select>Country 國家</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
		<table width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong>Emergency
				Contact Person Information 緊急聯絡人資料 (1)</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9"><font
			color="red">*</font>Family Name<br />
		姓 (英文) <input type="text" name="patkfname1"
			value="<%=patkfname1==null?"":patkfname1 %>" maxlength="15" size="25">
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9"><font
			color="red">*</font>Given Name<br />
		名 (英文) <input type="text" name="patkgname1"
			value="<%=patkgname1==null?"":patkgname1 %>" maxlength="15" size="25">
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">Chinese Name<br />
		中文姓名 <input type="text" name="patkcname1"
			value="<%=patkcname1==null?"":patkcname1 %>" maxlength="20" size="25">
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Sex<br />
		性別 <select name="patksex1">
			<option value=""></option>
			<option value="M" <%="M".equals(patksex1)?" selected":"" %>>M
			男</option>
			<option value="F" <%="F".equals(patksex1)?" selected":"" %>>F
			女</option>
		</select></td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9" colspan=3"><font
			color="red">*</font>Contact Telephone Number<br />
		聯絡電話<br />
		<table width=100%">
			<tr>
				<td height="40" valign="top" bgcolor="#F9F9F9">Home<br />
				住宅 <input type="text" name="patkhtel1"
					value="<%=patkhtel1==null?"":patkhtel1 %>" maxlength="20" size="25" />
				</td>
				<td width="2">&nbsp;</td>
				<td height="40" valign="top" bgcolor="#F9F9F9">Office.<br />
				辦公室 <input type="text" name="patkotel1"
					value="<%=patkotel1==null?"":patkotel1 %>" maxlength="20" size="25" />
				</td>
			</tr>
			<tr>
				<td height="40" valign="top" bgcolor="#F9F9F9">Mobile<br />
				手提號碼 <input type="text" name="patkmtel1"
					value="<%=patkmtel1==null?"":patkmtel1 %>" maxlength="20" size="25" />
				</td>
				<td width="2">&nbsp;</td>
				<td height="40" valign="top" bgcolor="#F9F9F9">Pager No<br />
				傳呼號碼 <input type="text" name="patkptel1"
					value="<%=patkptel1==null?"":patkptel1 %>" maxlength="20" size="25" />
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" valign="top" bgcolor="#F9F9F9">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td height="40" valign="top"><font color="red">*</font>Relationship<br />
				關係 <input type="text" name="patkrela1"
					value="<%=patkrela1==null?"":patkrela1 %>" maxlength="20" size="25">
				<br />
				<br />
				<br />
				Email Address<br />
				電郵地址 <input type="text" name="patkemail1"
					value="<%=patkemail1==null?"":patkemail1 %>" maxlength="50"
					size="25" /></td>
		</table>
		</td>
		<td width="2">&nbsp;</td>
		<td height="20" valign="top" bgcolor="#F9F9F9" colspan="3">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td width="2">&nbsp;</td>
				<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
				Address<br />
				地址<br />
				<input type="text" name="patkadd11"
					value="<%=patkadd11==null?"":patkadd11 %>" maxlength="25" size="50">Rm/Flat
				室/Floor 層/Block/Bldg 大廈<br />
				<input type="text" name="patkadd21"
					value="<%=patkadd21==null?"":patkadd21 %>" maxlength="25" size="50">Road
				道路/Street 街道<br />
				<input type="text" name="patkadd31"
					value="<%=patkadd31==null?"":patkadd31 %>" maxlength="25" size="50">District
				區域<br />
				<input type="radio" name="patkadd41" value="HONG KONG"
					<%="HONG KONG".equals(patkadd41)?" checked":"" %> />Hong Kong 香港<br />
				<input type="radio" name="patkadd41" value="KOWLOON"
					<%="KOWLOON".equals(patkadd41)?" checked":"" %> />Kowloon 九龍<br />
				<input type="radio" name="patkadd41" value="NEW TERRITORIES"
					<%="NEW TERRITORIES".equals(patkadd41)?" checked":"" %> />New
				Territories 新界</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
		<table width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong>Emergency
				Contact Person Information 緊急聯絡人資料 (2)</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">Family
		Name<br />
		姓 (英文) <input type="text" name="patkfname2" value="" maxlength="15"
			size="25"></td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">Given
		Name<br />
		名 (英文) <input type="text" name="patkgname2" value="" maxlength="15"
			size="25"></td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">Chinese Name<br />
		中文姓名 <input type="text" name="patkcname2" value="" maxlength="20"
			size="25"></td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">Sex<br />
		性別 <select name="patksex2">
			<option value=""></option>
			<option value="M">M 男</option>
			<option value="F">F 女</option>
		</select></td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9" colspan=3">
		Contact Telephone Number<br />
		聯絡電話<br />
		<table width=100%">
			<tr>
				<td height="40" valign="top" bgcolor="#F9F9F9">Home<br />
				住宅 <input type="text" name="patkhtel2" value="" maxlength="20"
					size="25" /></td>
				<td width="2" valign="top">&nbsp;</td>
				<td height="40" valign="top" bgcolor="#F9F9F9">Office.<br />
				辦公室 <input type="text" name="patkotel2" value="" maxlength="20"
					size="25" /></td>
			</tr>
			<tr>
				<td height="40" valign="top" bgcolor="#F9F9F9">Mobile<br />
				手提號碼 <input type="text" name="patkmtel2" value="" maxlength="20"
					size="25" /></td>
				<td width="2" valign="top">&nbsp;</td>
				<td height="40" valign="top" bgcolor="#F9F9F9">Pager No<br />
				傳呼號碼 <input type="text" name="patkptel2" value="" maxlength="20"
					size="25" /></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" valign="top" bgcolor="#F9F9F9">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td height="40" valign="top">Relationship<br />
				關係 <input type="text" name="patkrela2" value="" maxlength="20"
					size="25"> <br />
				<br />
				<br />
				Email Address<br />
				電郵地址 <input type="text" name="patkemail2" value="" maxlength="50"
					size="25" /></td>
			</tr>
		</table>
		</td>
		<td width="2">&nbsp;</td>
		<td height="20" valign="top" bgcolor="#F9F9F9" colspan="3">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
				Address<br />
				地址<br />
				<input type="text" name="patkadd12" value="" maxlength="25"
					size="50">Rm/Flat 室/Floor 層/Block/Bldg 大廈<br />
				<input type="text" name="patkadd22" value="" maxlength="25"
					size="50">Road 道路/Street 街道<br />
				<input type="text" name="patkadd32" value="" maxlength="25"
					size="50">District 區域<br />
				<input type="radio" name="patkadd42" value="HONG KONG" />Hong Kong
				香港<br />
				<input type="radio" name="patkadd42" value="KOWLOON" />Kowloon 九龍<br />
				<input type="radio" name="patkadd42" value="NEW TERRITORIES" />New
				Territories 新界</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
		<table width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong>Method
				of Payment 付款方法</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5">*All accounts must either be
		guaranteed by an insurance company or settled before discharge. Please
		ensure the insurance or corporate company contracts with this hospital
		are valid.<br />
		所有賬戶必須由保險公司保證或出院前清付。請確保該保險或企業公司與本院的合約有效。</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="5" height="20">
		<table width="700" border="0" cellspacing="0" cellpadding="0">
			<td valign="top" width="5%"><font color="red">*</font> <input
				type="checkbox" name="agreement2" value="Y" /></td>
			<td valign="top" width="95%">I have read and agreed to the terms
			and conditions detailed on the "Daily Room Rate and Advance Payment"
			and then advise on the following (<a
				href="http://www.hkah.org.hk/new/eng/hospitalization_fi.htm"
				target="_blank">Click here</a>)<br />
			本人已閱讀及同意"每日房租和預繳按金"並提供以下資料 (<a
				href="http://www.hkah.org.hk/new/chi/hospitalization_fi.htm"
				target="_blank">請按此</a>)</td>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="20" bgcolor="#F9F9F9"><font color="red">*</font>Method
		of Payment 付款方法
		<table width="100%" border="0" cellspacing="1" cellpadding="0">
			<tr>
				<td height="30" bgcolor="#F9F9F9"><input name="paymentType"
					type="radio" value="CASH" checked /> Cash 現金</td>
				<td height="30" bgcolor="#F9F9F9"><input name="paymentType"
					type="radio" value="EPS" /> EPS 易辦事</td>
				<td height="30" bgcolor="#F9F9F9"><input name="paymentType"
					type="radio" value="CREDIT CARD" /> Credit Card 信用卡 <select
					name="creditCardType" onchange="return changePaymentType();">
					<option value=""></option>
					<option value="Visa">Visa</option>
					<option value="Master">Master</option>
					<option value="JCB">JCB</option>
					<option value="Diners">Diners</option>
					<option value="AE">AE</option>
				</select></td>
				<td height="30" bgcolor="#F9F9F9"><input name="paymentType"
					type="radio" value="CUP CARD" /> Cup Card 銀聯卡</td>
			</tr>
			<tr>
				<td height="5" colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td height="30" bgcolor="#F9F9F9" valign="top"><input
					name="paymentType" type="radio" value="INSURANCE" /> Insurance A/C
				醫療保險</td>
				<td height="30" bgcolor="#F9F9F9" valign="top"><input
					name="paymentType" type="radio" value="CORPORATE" /> Corporate A/C
				公司賬戶</td>
				<td height="30" bgcolor="#F9F9F9"><input name="paymentType"
					type="radio" value="CREDIT CARD AUTH" /> Credit Card Authorization
				Form<br />
				信用卡授權書 (<a
					href="/upload/Admission at ward/Credit Card Mail Order Authorzation Form.pdf"
					target="_blank">Click here 請按此</a>) (for Deposit only只適用於按金)<br />
				<br />
				Attach or Fax Credit Card copy and Authorization Form<br />
				<font color="red">**</font>請附上或傳真信用卡副本及授權書<br />
				<input type="file" name="file2" size="30" class="multi"
					maxlength="5"><br />
				<font color="red">**</font>Fax No 傳真號碼: 36518801</td>
				<td height="30" bgcolor="#F9F9F9" valign="top"><input
					name="paymentType" type="radio" value="OTHER" /> Others 其他<br />
				<input type="text" name="paymentTypeOther" maxlength="10" size="20" />
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
		<table width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong>Patient's
				Agreement 病人協議</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td colspan="6">
		<table width="700" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">(1)</td>
				<td>The above information given by me is true and correct to
				the best of my personal knowledge;</td>
			</tr>
			<tr>
				<td valign="top">(2)</td>
				<td>I have read and agreed to the terms and conditions detailed
				on the "Daily Room Rate and Advance Payment";</td>
			</tr>
			<tr>
				<td valign="top">(3)</td>
				<td>I have read and agreed to the terms and conditions detailed
				on the "Health Care Advisory". I understand and accept that the
				hospital services will be charged according to my choice of room
				category;</td>
			</tr>
			<tr>
				<td valign="top">(4)</td>
				<td>I understand that the Hospital is committed to providing
				healthy menu to patients. To implement the said principle,
				vegetarian meal is the only choice available in this hospital;</td>
			</tr>
			<tr>
				<td valign="top">(5)</td>
				<td>I receive and acknowledge the terms and conditions detailed
				on the "Patient Admission" and "Patients' Charter";</td>
			</tr>
			<tr>
				<td valign="top">(6)</td>
				<td>I agree to pay the Hospital’s current rates and charges at
				the time the services rendered in respect of the facilities used and
				treatment received by me and all other incidental charges incurred;</td>
			</tr>
			<tr>
				<td valign="top">(7)</td>
				<td>I agree to use solely the medicines provided by the
				Hospital during the hospitalization;</td>
			</tr>
			<tr>
				<td valign="top">(8)</td>
				<td>I authorize the Hospital to contact my insurer and release
				my information required regarding my case to the insurance company
				for verification of coverage under my insurance policy; and</td>
			</tr>
			<tr>
				<td valign="top">(9)</td>
				<td>I agree to pay any outstanding charges that have not been
				paid or covered by my insurer.</td>
			</tr>
			<tr>
				<td width="31">&nbsp;</td>
				<td width="669">&nbsp;</td>
			</tr>
			<tr>
				<td valign="top">(1)</td>
				<td>本人提供上述的一切資料於本人的個人認知範圍內全屬真實和正確；</td>
			</tr>
			<tr>
				<td valign="top">(2)</td>
				<td>本人已閱讀及同意"每日房租和預繳按金"上的一切條款；</td>
			</tr>
			<tr>
				<td valign="top">(3)</td>
				<td>本人已清楚閱讀及同意"住院須知"上的一切條款。本人明白並接受住院收費將根據本人所選擇的房間類別而計算；</td>
			</tr>
			<tr>
				<td valign="top">(4)</td>
				<td>本人明白醫院致力提供健康膳食給予病人。為履行此目標，醫院膳食部只供應素食餐；</td>
			</tr>
			<tr>
				<td valign="top">(5)</td>
				<td>本人獲悉及接納"入院須知"及"病人權益與責任"上的一切條款；</td>
			</tr>
			<tr>
				<td valign="top">(6)</td>
				<td>本人同意支付一切與本人有關之治療、設施或服務使用，及偶發事故等所需的費用;</td>
			</tr>
			<tr>
				<td valign="top">(7)</td>
				<td>本人同意在留院期間只會使用由醫院供應的藥物;</td>
			</tr>
			<tr>
				<td valign="top">(8)</td>
				<td>本人批准醫院與本人之承保人聯絡並提交與本人有關的病歷資料，以便保險公司作批核保額之覆核程序; 及</td>
			</tr>
			<tr>
				<td valign="top">(9)</td>
				<td>本人同意支付所有額外費用或保險公司所未能承保之費用。</td>
			</tr>
			<tr>
				<td width="31">&nbsp;</td>
				<td width="669">&nbsp;</td>
			</tr>
			<tr>
				<td valign="top" colspan="2">
				<ul>
					<li>Patient Admission 入院須知 (<a href="javascript:void(0);"
						onclick="downloadFile('76');return false;" target="_blank">Click
					here 請按此</a>)</li>
					<li>Patients' Charter 病人權益與責任 (<a
						href="http://www.hkah.org.hk/new/eng/download/Patient_Charter.pdf"
						target="_blank">Click here 請按此</a>)</li>
					<li>Why Vegetarian Diet 為什麼要食素 (<a
						href="http://www.hkah.org.hk/new/eng/download/Why_Vegetarian_Diet.pdf"
						target="_blank">Click here 請按此</a>)</li>
				</ul>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
		<table width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong>Signee's
				Acknowledgement 簽署人同意書</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td colspan="6">
		<table width="700" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">&nbsp;</td>
				<td>I, the undersigned, accept full responsibility for the
				settlement of all expenses incurred by the patient.<br />
				本簽署人全權負責支付以上病人之一切費用。</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td valign="top"><input type="checkbox" name="promotionYN"
					value="Y" /></td>
				<td>We will periodically send you hospital and medical
				information. If you would like to receive such information, please
				tick the box.<br />
				我們會為閣下定期寄上本院及醫療資訊。如閣下同意，請於方格上填上剔號。</td>
			</tr>
		</table>
		<br />
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
		<table width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong>Other
				Information 其他資料</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5">
		<ul id="browser" class="filetree">
			<jsp:include page="../registration/important_information.jsp"
				flush="false">
				<jsp:param name="source" value="registration" />
			</jsp:include>
			<jsp:include page="../common/information_helper.jsp" flush="false">
				<jsp:param name="category" value="informed consent" />
				<jsp:param name="skipColumnTitle" value="Y" />
				<jsp:param name="mustLogin" value="N" />
				<jsp:param name="skipTreeview" value="Y" />
				<jsp:param name="oldTreeStyle" value="Y" />
			</jsp:include>
		</ul>
		</td>
	</tr>
</table>
<br />
<br />
<br />
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><font color="red">***</font>If there is any inconsistency or
		ambiguity between the English version and the Chinese version, the
		English version shall prevail.<br />
		中英文版本如有歧異，概以英文版本為準。</td>
	</tr>
</table>
<div class="pane">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td align="center">
		<button class="btn-submit" onclick="submitAction();return false;">Preview
		預覽</button>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="create" />
<input type="hidden" name="step" value="1" />
<input type="hidden" name="admissionID" />
<input type="hidden" name="patno" value="<%=patno==null?"":patno %>" />
<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
</form>
<script language="javascript">
<!--
	function submitAction() {
		var msg = '';
		var focusField;

		if (!document.form1.agreement1.checked) {
			if (msg.length == 0) focusField = document.form1.agreement1;
			msg = msg + 'Please Confirm Health Care Advisory 請確定已細閱住院須知.\n';
		}
		if (document.form1.roomType.value == '') {
			if (msg.length == 0) focusField = document.form1.roomType;
			msg = msg + 'Empty Room Choice 沒有選擇房間類別.\n';
		}
		if (document.form1.expectedAdmissionDate.value == '') {
			if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
			msg = msg + 'Empty Admission Date 沒有輸入預定入院日期.\n';
		} else if (!validDate(document.form1.expectedAdmissionDate)) {
			if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
			msg = msg + 'Invalid Admission Date 輸入不正確預定入院日期.\n';
		} else if (!checkAdmissionDate()) {
			if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
			msg = msg + 'Admission Date is less than one day prior to your admission. 預定入院日期少於一個工作天.\n';
		}
		if (document.form1.admissiondoctor.value == '') {
			if (msg.length == 0) focusField = document.form1.admissiondoctor;
			msg = msg + 'Empty Admission Doctor 沒有輸入醫生.\n';
		}
		if (document.form1.patidType[0].checked) {
			if (document.form1.patidno1.value == '') {
				if (msg.length == 0) focusField = document.form1.patidno1;
				msg = msg + 'Empty Hong Kong I.D. Card 沒有輸入香港身份證號.\n';
			} else if (document.form1.patidno2.value == '') {
				if (msg.length == 0) focusField = document.form1.patidno2;
				msg = msg + 'Empty Hong Kong I.D. Card 沒有輸入香港身份證號.\n';
			} else if (document.form1.patidno1.value.length < 7) {
				if (msg.length == 0) focusField = document.form1.patidno1;
				msg = msg + 'Invalid Hong Kong I.D. Card 輸入不正確香港身份證號.\n';
			}
		}
		if (document.form1.patidType[1].checked && document.form1.patpassport.value == '') {
			if (msg.length == 0) focusField = document.form1.patpassport;
			msg = msg + 'Empty Passport No. 沒有輸入護照號碼.\n';
		}
		if (document.form1.patbdate.value == '') {
			if (msg.length == 0) focusField = document.form1.patbdate;
			msg = msg + 'Empty Date of Birth 沒有輸入出生日期.\n';
		} else if (!validDate(document.form1.patbdate)) {
			if (msg.length == 0) focusField = document.form1.patbdate;
			msg = msg + 'Invalid Date of Birth 輸入不正確出生日期.\n';
		}
		if (document.form1.patfname.value == '') {
			if (msg.length == 0) focusField = document.form1.patfname;
			msg = msg + 'Empty Family Name 沒有輸入姓氏.\n';
		}
		if (document.form1.patgname.value == '') {
			if (msg.length == 0) focusField = document.form1.patgname;
			msg = msg + 'Empty Given Name 沒有輸入名稱.\n';
		}
		if (document.form1.titleDesc.value == '' && document.form1.titleDescOther.value == '') {
			if (msg.length == 0) focusField = document.form1.titleDesc;
			msg = msg + 'Empty Title 沒有輸入稱謂.\n';
		}
		if (document.form1.patsex.value == '') {
			if (msg.length == 0) focusField = document.form1.patsex;
			msg = msg + 'Empty Sex 沒有輸入性別.\n';
		}
		if (document.form1.racedesc.value == '' && document.form1.racedescOther.value == '') {
			if (msg.length == 0) focusField = document.form1.racedesc;
			msg = msg + 'Empty Ethnic Group 沒有輸入種族.\n';
		}
		if (document.form1.religion.value == 'OT' && document.form1.religionOther.value == '') {
			if (msg.length == 0) focusField = document.form1.religion;
			msg = msg + 'Empty Religion 沒有輸入宗教.\n';
		}
		if (document.form1.mothcode.value == 'OTH' && document.form1.mothcodeOther.value == '') {
			if (msg.length == 0) focusField = document.form1.mothcode;
			msg = msg + 'Empty Written Language 沒有輸入語言.\n';
		}
		if (document.form1.occupation.value == '') {
			if (msg.length == 0) focusField = document.form1.occupation;
			msg = msg + 'Empty Occupation 沒有輸入職業.\n';
		}
		if (document.form1.pathtel.value == ''
				&& document.form1.patotel.value == ''
				&& document.form1.patmtel.value == '') {
			if (msg.length == 0) focusField = document.form1.pathtel;
			msg = msg + 'Empty Contact Telephone Number 沒有輸入電話.\n';
		}
		if (document.form1.patemail.value == '') {
			if (msg.length == 0) focusField = document.form1.patemail;
			msg = msg + 'Empty Email 沒有輸入電郵地址.\n';
		}
		if (document.form1.patadd1.value == '') {
			if (msg.length == 0) focusField = document.form1.patadd1;
			msg = msg + 'Empty Address 沒有輸入地址.\n';
		}
		if (document.form1.patkfname1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkfname1;
			msg = msg + 'Empty Family Name for Emergency Contact Person 沒有輸入緊急聯絡人姓氏.\n';
		}
		if (document.form1.patkgname1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkgname1;
			msg = msg + 'Empty Given Name for Emergency Contact Person 沒有輸入緊急聯絡人名稱.\n';
		}
		if (document.form1.patkhtel1.value == ''
				&& document.form1.patkotel1.value == ''
				&& document.form1.patkmtel1.value == ''
				&& document.form1.patkptel1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkhtel1;
			msg = msg + 'Empty Contact Telephone Number 沒有輸入緊急聯絡人電話.\n';
		}
		if (document.form1.patkrela1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkrela1;
			msg = msg + 'Empty Relationship for Emergency Contact Person 沒有輸入緊急聯絡人關係.\n';
		}
		if (!document.form1.agreement2.checked) {
			if (msg.length == 0) focusField = document.form1.agreement2;
			msg = msg + 'Please Confirm Daily Room Rate and Advance Payment 請確定已細閱每日房租和預繳按金.\n';
		}

		if (msg.length > 0) {
			alert(msg);
			focusField.focus();
			return false;
		} else {
			document.form1.submit();
		}
	}

	// ajax
	var http = createRequestObject();

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

	function validDOB(event) {
		if (document.form1.patno.value != '' && event.keyCode == 13) {
			document.form1.patbdate.focus();
		}
	}

	function changePaymentType() {
		if (document.form1.creditCardType.value != '') {
			document.form1.paymentType[2].checked = true;
		}
		return false;
	}

	function checkAdmissionDate() {
		var expectedAdmissionDate = document.form1.expectedAdmissionDate.value;
		var deadline = '<%=DateTimeUtil.getCurrentDate() %>';
		return parseDate(expectedAdmissionDate) - parseDate(deadline) > 0;
	}
-->
</script></DIV>

</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>