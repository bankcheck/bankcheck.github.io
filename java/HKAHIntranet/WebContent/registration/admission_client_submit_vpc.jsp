<%@ page import="java.io.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="java.util.*"%>
<%
String sessionKey = request.getParameter("session");
String patno = request.getParameter("patno");

//20181003 Arran force logout from intranet
String admissionID = (String)session.getAttribute("admissionID");
session.invalidate();

String expectedAdmissionDate = request.getParameter("expectedAdmissionDate");
String expectedAdmissionTime = null;
String expectedAdmissionTime_hh = request.getParameter("expectedAdmissionTime_hh");
String expectedAdmissionTime_mi = request.getParameter("expectedAdmissionTime_mi");

String admissiondoctor = TextUtil.parseStrUTF8(request.getParameter("admissiondoctor"));
String remarks = TextUtil.parseStrUTF8(request.getParameter("remarks"));

String patidno = null;
String patidno1 = TextUtil.parseStr(request.getParameter("patidno1")).toUpperCase();
String patidno2 = TextUtil.parseStr(request.getParameter("patidno2")).toUpperCase();
String patpassport = TextUtil.parseStr(request.getParameter("patpassport")).toUpperCase();
String patbdate = TextUtil.parseStrUTF8(request.getParameter("patbdate"));
String patfname = TextUtil.parseStrUTF8(request.getParameter("patfname"))==null?"":TextUtil.parseStrUTF8(request.getParameter("patfname")).toUpperCase();
String patgname = TextUtil.parseStrUTF8(request.getParameter("patgname"))==null?"":TextUtil.parseStrUTF8(request.getParameter("patgname")).toUpperCase();
String titleDesc = request.getParameter("titleDesc");
String titleDescOther = TextUtil.parseStrUTF8(request.getParameter("titleDescOther"));
String patcname = TextUtil.parseStrUTF8(request.getParameter("patcname"));
String passdocument = null;
String patsex = request.getParameter("patsex");
String racedesc = request.getParameter("racedesc");
String racedescOther = TextUtil.parseStrUTF8(request.getParameter("racedescOther"));
String religion = request.getParameter("religion");
String religionOther = TextUtil.parseStrUTF8(request.getParameter("religionOther"));
String patmsts = request.getParameter("patmsts");

//20181203 Arran modified to parse utf8 for marital status other
String patmstsOther = TextUtil.parseStrUTF8(request.getParameter("patmstsOther"));

String mothcode = request.getParameter("mothcode");
String mothcodeOther = TextUtil.parseStrUTF8(request.getParameter("mothcodeOther"));

//20181203 Arran modified to display information based on selected language
String edulevelcode = request.getParameter("edulevel");
String edulevel = null;

//20181203 Arran added mktSrc
String mktSrc = request.getParameter("mktSrc");

String pathtel = TextUtil.parseStrUTF8(request.getParameter("pathtel"));
String patotel = TextUtil.parseStrUTF8(request.getParameter("patotel"));
String patmtel = TextUtil.parseStrUTF8(request.getParameter("patmtel"));
String patftel = TextUtil.parseStrUTF8(request.getParameter("patftel"));
String occupation = TextUtil.parseStrUTF8(request.getParameter("occupation"));
String patemail = TextUtil.parseStrUTF8(request.getParameter("patemail"));
String patadd1 = TextUtil.parseStrUTF8(request.getParameter("patadd1"));
String patadd2 = TextUtil.parseStrUTF8(request.getParameter("patadd2"));
String patadd3 = TextUtil.parseStrUTF8(request.getParameter("patadd3"));
String patadd4 = TextUtil.parseStrUTF8(request.getParameter("patadd4"));
String coucode = request.getParameter("coucode");
String coudesc = null;

String patkfname1 = TextUtil.parseStrUTF8(request.getParameter("patkfname1"));
String patkgname1 = TextUtil.parseStrUTF8(request.getParameter("patkgname1"));
String patkcname1 = TextUtil.parseStrUTF8(request.getParameter("patkcname1"));
String patksex1 = request.getParameter("patksex1");
String patkrela1 = TextUtil.parseStrUTF8(request.getParameter("patkrela1"));
String patkhtel1 = TextUtil.parseStrUTF8(request.getParameter("patkhtel1"));
String patkotel1 = TextUtil.parseStrUTF8(request.getParameter("patkotel1"));
String patkmtel1 = TextUtil.parseStrUTF8(request.getParameter("patkmtel1"));
String patkptel1 = TextUtil.parseStrUTF8(request.getParameter("patkptel1"));
String patkemail1 = TextUtil.parseStrUTF8(request.getParameter("patkemail1"));
String patkadd11 = TextUtil.parseStrUTF8(request.getParameter("patkadd11"));
String patkadd21 = TextUtil.parseStrUTF8(request.getParameter("patkadd21"));
String patkadd31 = TextUtil.parseStrUTF8(request.getParameter("patkadd31"));
String patkadd41 = TextUtil.parseStrUTF8(request.getParameter("patkadd41"));

String patkfname2 = TextUtil.parseStrUTF8(request.getParameter("patkfname2"));
String patkgname2 = TextUtil.parseStrUTF8(request.getParameter("patkgname2"));
String patkcname2 = TextUtil.parseStrUTF8(request.getParameter("patkcname2"));
String patksex2 = request.getParameter("patksex2");
String patkrela2 = TextUtil.parseStrUTF8(request.getParameter("patkrela2"));
String patkhtel2 = request.getParameter("patkhtel2");
String patkotel2 = request.getParameter("patkotel2");
String patkmtel2 = request.getParameter("patkmtel2");
String patkptel2 = request.getParameter("patkptel2");
String patkemail2 = request.getParameter("patkemail2");
String patkadd12 = TextUtil.parseStrUTF8(request.getParameter("patkadd12"));
String patkadd22 = TextUtil.parseStrUTF8(request.getParameter("patkadd22"));
String patkadd32 = TextUtil.parseStrUTF8(request.getParameter("patkadd32"));
String patkadd42 = TextUtil.parseStrUTF8(request.getParameter("patkadd42"));

//20181129 Arran modified to display information based on selected language
String roomType = null;
String roomTypeCode = request.getParameter("roomType");

String bedNo = request.getParameter("bedNo");
String paymentType = request.getParameter("paymentType");
String paymentTypeOther = request.getParameter("paymentTypeOther");
String creditCardType = request.getParameter("creditCardType");
String insuranceRemarks = request.getParameter("insuranceRemarks");
String insurancePolicyNo = request.getParameter("insurancePolicyNo");
String promotionYN = request.getParameter("promotionYN");
String infoForPromotion =  request.getParameter("infoForPromotion");

String confirmDate = null;
String[] unselectedImtInfo = null;
String[] fileList = null;
String language = request.getParameter("language");

Locale locale = Locale.US;

//20181009 Arran add new categories for informed consent Chinese and English
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else {
	locale = Locale.US;
}

if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);

	sessionKey = (String) request.getAttribute("session");
	patno = (String) request.getAttribute("patno");

	expectedAdmissionDate = (String) request.getAttribute("expectedAdmissionDate");
	expectedAdmissionTime_hh = (String) request.getAttribute("expectedAdmissionTime_hh");
	expectedAdmissionTime_mi = (String) request.getAttribute("expectedAdmissionTime_mi");

	admissiondoctor = TextUtil.parseStrUTF8((String) request.getAttribute("admissiondoctor"));
	remarks = TextUtil.parseStrUTF8((String) request.getAttribute("remarks"));

	patidno1 = TextUtil.parseStr((String) request.getAttribute("patidno1")).toUpperCase();
	patidno2 = TextUtil.parseStr((String) request.getAttribute("patidno2")).toUpperCase();
	patpassport = TextUtil.parseStr((String) request.getAttribute("patpassport")).toUpperCase();
	patbdate = TextUtil.parseStrUTF8((String) request.getAttribute("patbdate"));
	patfname = TextUtil.parseStrUTF8((String) request.getAttribute("patfname"));
	patgname = TextUtil.parseStrUTF8((String) request.getAttribute("patgname"));
	titleDesc = (String) request.getAttribute("titleDesc");
	titleDescOther = TextUtil.parseStrUTF8((String) request.getAttribute("titleDescOther"));
	patcname = TextUtil.parseStrUTF8((String) request.getAttribute("patcname"));
	patsex = (String) request.getAttribute("patsex");
	racedesc = (String) request.getAttribute("racedesc");
	racedescOther = TextUtil.parseStrUTF8((String) request.getAttribute("racedescOther"));
	religion = (String) request.getAttribute("religion");
	religionOther = TextUtil.parseStrUTF8((String) request.getAttribute("religionOther"));
	patmsts = (String) request.getAttribute("patmsts");

//20181203 Arran modified to parse utf8 for marital status other
	patmstsOther = TextUtil.parseStrUTF8((String) request.getAttribute("patmstsOther"));

	mothcode = (String) request.getAttribute("mothcode");
	mothcodeOther = TextUtil.parseStrUTF8((String) request.getAttribute("mothcodeOther"));

//20181203 Arran modified to display information based on selected language
	edulevelcode = (String) request.getAttribute("edulevel");

	if ("Primary".equals(edulevelcode)) {
		edulevel = MessageResources.getMessage(locale, "label.primarySchool");
	} else if ("Secondary".equals(edulevelcode)) {
		edulevel = MessageResources.getMessage(locale, "label.highSchool");
	} else if ("Tertiary or above".equals(edulevelcode)) {
		edulevel = MessageResources.getMessage(locale, "adm.terOfAbove");
	} else {
		edulevel = MessageResources.getMessage(locale, "label.others");
	}

//20181203 Arran added mktSrc
	mktSrc = (String) request.getAttribute("mktSrc");
	pathtel = TextUtil.parseStrUTF8((String) request.getAttribute("pathtel"));
	patotel = TextUtil.parseStrUTF8((String) request.getAttribute("patotel"));
	patmtel = TextUtil.parseStrUTF8((String) request.getAttribute("patmtel"));
	patftel = TextUtil.parseStrUTF8((String) request.getAttribute("patftel"));
	occupation = TextUtil.parseStrUTF8((String) request.getAttribute("occupation"));
	patemail = TextUtil.parseStrUTF8((String) request.getAttribute("patemail"));
	patadd1 = TextUtil.parseStrUTF8((String) request.getAttribute("patadd1"));
	patadd2 = TextUtil.parseStrUTF8((String) request.getAttribute("patadd2"));
	patadd3 = TextUtil.parseStrUTF8((String) request.getAttribute("patadd3"));
	patadd4 = TextUtil.parseStrUTF8((String) request.getAttribute("patadd4"));
	coucode = (String) request.getAttribute("coucode");

	patkfname1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkfname1"));
	patkgname1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkgname1"));
	patkcname1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkcname1"));
	patksex1 = (String) request.getAttribute("patksex1");
	patkrela1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkrela1"));
	patkhtel1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkhtel1"));
	patkotel1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkotel1"));
	patkmtel1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkmtel1"));
	patkptel1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkptel1"));
	patkemail1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkemail1"));
	patkadd11 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd11"));
	patkadd21 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd21"));
	patkadd31 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd31"));
	patkadd41 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd41"));

	patkfname2 = TextUtil.parseStrUTF8((String) request.getAttribute("patkfname2"));
	patkgname2 = TextUtil.parseStrUTF8((String) request.getAttribute("patkgname2"));
	patkcname2 = TextUtil.parseStrUTF8((String) request.getAttribute("patkcname2"));
	patksex2 = (String) request.getAttribute("patksex2");
	patkrela2 = TextUtil.parseStrUTF8((String) request.getAttribute("patkrela2"));
	patkhtel2 = (String) request.getAttribute("patkhtel2");
	patkotel2 = (String) request.getAttribute("patkotel2");
	patkmtel2 = (String) request.getAttribute("patkmtel2");
	patkptel2 = (String) request.getAttribute("patkptel2");
	patkemail2 = (String) request.getAttribute("patkemail2");
	patkadd12 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd12"));
	patkadd22 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd22"));
	patkadd32 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd32"));
	patkadd42 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd42"));

//20181129 Arran modified to display information based on selected language
	roomTypeCode = (String) request.getAttribute("roomType");

	if ("VIP".equals(roomTypeCode)) {
		roomType = MessageResources.getMessage(locale, "adm.acm1");
	} else if ("Private".equals(roomTypeCode)) {
		roomType = MessageResources.getMessage(locale, "adm.acm2");
	} else if ("Semi-Private".equals(roomTypeCode)) {
		roomType = MessageResources.getMessage(locale, "adm.acm3");
	} else if ("Standard".equals(roomTypeCode)) {
		roomType = MessageResources.getMessage(locale, "adm.acm4");
	}

	bedNo = (String) request.getAttribute("bedNo");
	paymentType = (String) request.getAttribute("paymentType");
	paymentTypeOther = (String) request.getAttribute("paymentTypeOther");
	creditCardType = (String) request.getAttribute("creditCardType");
	insuranceRemarks = (String) request.getAttribute("insuranceRemarks");
	insurancePolicyNo = (String) request.getAttribute("insurancePolicyNo");
	promotionYN = (String) request.getAttribute("promotionYN");
	infoForPromotion = (String) request.getAttribute("infoForPromotion");
	unselectedImtInfo = (String[]) request.getAttribute("unselectedInfo_StringArray");
	language= (String) request.getAttribute("language");

	if (patidno1.length() > 0 && patidno2.length() > 0) {
		patidno = patidno1 + "(" + patidno2 + ")";
	} else {
		patidno = patpassport;
	}

	fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null && fileList.length > 0) {
		for (int i = 0; i < fileList.length; i++) {
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + patidno + ConstantsVariable.UNDERSCORE_VALUE + fileList[i]
			);
		}
	}
}

if (patidno == null) {
	patidno = patpassport;
	if (patidno.length() == 0) {
		patidno = patidno1 + patidno2;
	}
}

//20181129 Arran modified to display information based on selected language
String patsexDesc = null;
if (patsex != null && patsex.length() > 0) {
	if ("M".equals(patsex)) {
		patsexDesc = MessageResources.getMessage(locale, "label.male");
	} else if ("F".equals(patsex)) {
		patsexDesc = MessageResources.getMessage(locale, "label.female");
	}
} else {
	patsexDesc = "";
}

//20181211 Arran added chinese
String raceDesc = null;
if (racedesc != null && racedesc.length() > 0) {
	if ("chi".equals(language))
		raceDesc = AdmissionDB.getRaceChiDesc(racedesc);
	else
		raceDesc = racedesc;
} else {
	raceDesc = racedescOther;
}

//20181129 Arran modified to display information based on selected language
String religionDesc = null;
if (religion != null && religion.length() > 0) {
	if ("NO".equals(religion)) {
		religionDesc = MessageResources.getMessage(locale, "adm.None");
	} else if ("BU".equals(religion)) {
		religionDesc = MessageResources.getMessage(locale, "adm.religion1");
	} else if ("CA".equals(religion)) {
		religionDesc = MessageResources.getMessage(locale, "adm.religion2");
	} else if ("CH".equals(religion)) {
		religionDesc = MessageResources.getMessage(locale, "adm.religion3");
	} else if ("HI".equals(religion)) {
		religionDesc = MessageResources.getMessage(locale, "adm.religion4");
	} else if ("SH".equals(religion)) {
		religionDesc = MessageResources.getMessage(locale, "adm.religion5");
	} else if ("SD".equals(religion)) {
		religionDesc = MessageResources.getMessage(locale, "adm.religion6");
	} else {
		religionDesc = religionOther;
	}
} else {
	religionDesc = religionOther;
}

//20181129 Arran modified to display information based on selected language
String patmstsDesc = null;
if(patmsts != null && patmsts.length() > 0){
	if ("S".equals(patmsts)) {
		patmstsDesc = MessageResources.getMessage(locale, "adm.mStatus1");
	} else if ("M".equals(patmsts)) {
		patmstsDesc = MessageResources.getMessage(locale, "adm.mStatus2");
	} else if ("D".equals(patmsts)) {
		patmstsDesc = MessageResources.getMessage(locale, "adm.mStatus3");
	} else if ("X".equals(patmsts)) {
		patmstsDesc = MessageResources.getMessage(locale, "adm.mStatus4");
	} else {
		patmstsDesc = patmstsOther;
	}
} else {
	patmstsDesc = patmstsOther;
}

//20181129 Arran modified to display information based on selected language
String mothcodeDesc = null;
if ("ENG".equals(mothcode)) {
	mothcodeDesc = MessageResources.getMessage(locale, "adm.lang1");
} else if ("TRC".equals(mothcode)) {
	mothcodeDesc = MessageResources.getMessage(locale, "adm.lang2");
} else if ("SMC".equals(mothcode)) {
	mothcodeDesc = MessageResources.getMessage(locale, "adm.lang3");
} else if ("JAP".equals(mothcode)) {
	mothcodeDesc = MessageResources.getMessage(locale, "adm.lang4");
} else {
	mothcodeDesc = "";
}
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="title" value="Hong Kong Adventist Hospital" />
</jsp:include>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/registration/background.css" />" />
<style>
	.person-info-tab td { padding: 2px; }
</style>
<body>
<DIV class="wrapper" style="background-color:white;">
<DIV  >
<DIV style="background-color:white;" style="width:100%" >
<jsp:include page="admission_header.jsp" flush="false">
	<jsp:param name="language" value="all" />
</jsp:include>
<div class="normal_area">
<div class="career_form" style="padding: 20px 18px;">

<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr valign="center">
		<td class="step3_1" width="20%"><p>Check Personal Information<br>檢查個人資料</p></td>
		<td class="step3_2" width="20%"><p>Input Personal Information<br>輸入個人資料</p></td>
		<td class="step3_3" width="20%"><p>Submit Personal Information<br>傳送個人資料</p></td>
	</tr>
</table>
<!--
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
-->
<br>
<form name="form1" enctype="multipart/form-data" action="admission_vpc.jsp" method="post">
<table width="800" border="1" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table class="person-info-tab" width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="5" height="25" style="background-color:#aa0066;">
						<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td class="style1"><font color="white"><strong>Personal Information 個人資料</strong></font></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Hospital No. 病歷號碼:</b> </td>
					<td height="20" valign="top"><%=patno==null?"":patno %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Surname 姓:</b> </td>
					<td height="20" valign="top"><%=patfname==null?"":patfname %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Date of Birth 出生日期:</b> </td>
					<td height="20" valign="top"><%=patbdate==null?"":patbdate %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Given Name 名:</b> </td>
					<td height="20" valign="top"><%=patgname==null?"":patgname %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Sex 性別:</b> </td>
					<td height="20" valign="top"><%=patsexDesc==null?"":patsexDesc %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Identity No 證件號碼:</b> </td>
					<td height="20" valign="top"><%=patidno==null?"":patidno %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Home Phone 住宅電話:</b> </td>
					<td height="20" valign="top"><%=pathtel==null?"":pathtel %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Mobile Phone 流動電話:</b> </td>
					<td height="20" valign="top"><%=patmtel==null?"":patmtel %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Office Phone 辦公室電話:</b> </td>
					<td height="20" valign="top"><%=patotel==null?"":patotel %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Fax 傳真:</b> </td>
					<td height="20" valign="top"><%=patftel==null?"":patftel %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Religion 宗教:</b> </td>
					<td height="20" valign="top"><%=religionDesc==null?"":("Others".equals(religionDesc)?religionOther:religionDesc) %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Corr. Lang. 通訊語言:</b> </td>
					<td height="20" valign="top"><%=mothcodeDesc==null?"":mothcodeDesc %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Marital Status 婚姻狀況:</b> </td>
					<td height="20" valign="top"><%=patmstsDesc==null?"":("Others".equals(patmstsDesc)?patmstsOther:patmstsDesc) %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Nationality 國籍:</b> </td>
					<td height="20" valign="top"><%=raceDesc==null?"":raceDesc %></td>

				</tr>
				<tr>

					<td height="20" valign="top"><b>Education Level 教育程度:</b> </td>
					<td height="20" valign="top"><%=edulevel==null?"":edulevel %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Occupation 職業:</b> </td>
					<td height="20" valign="top"><%=occupation==null?"":occupation %></td>

				</tr>
				<tr>
					<td height="20" valign="top"><b>Email Address 電郵地址:</b> </td>
					<td height="20" valign="top"><%=patemail==null?"":patemail %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Address 地址:</b> </td>
					<td height="20" valign="top" colspan="4"><%=patadd1==null?"":patadd1 %> <%=patadd2==null?"":patadd2 %> <%=patadd3==null?"":patadd3 %> <%=coucode==null||"".equals(coucode) ?"":AdmissionDB.getCountryDesc2(coucode, language) %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>How did you hear about us<br/>認識本院的途徑:</b> </td>
					<td height="20" valign="top" colspan="4"><%=AdmissionDB.getMktSrcDesc2(mktSrc, language) %></td>
				</tr>
				<tr>
					<td colspan="5" height="25" style="background-color:#aa0066;">
						<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td class="style1"><font color="white"><strong>Emergency Contact Person Information 緊急聯絡人資料</strong></font></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Contact Person 聯絡人:</b> </td>
					<td height="20" valign="top"><%=patkfname1==null?"":patkfname1 %> <%=patkgname1==null?"":patkgname1 %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Relationship 關係:</b> </td>
					<td height="20" valign="top"><%=patkrela1==null?"":patkrela1 %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Office Phone 辦公室電話:</b> </td>
					<td height="20" valign="top"><%=patkotel1==null?"":patkotel1 %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Mobile Phone 流動電話:</b> </td>
					<td height="20" valign="top"><%=patkmtel1==null?"":patkmtel1 %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Email Address 電郵地址:</b> </td>
					<td height="20" valign="top"><%=patkemail1==null?"":patkemail1 %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Home Phone 住宅電話:</b> </td>
					<td height="20" valign="top"><%=patkhtel1==null?"":patkhtel1 %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Address 地址:</b> </td>
					<td height="20" valign="top" colspan="4"><%=patkadd11==null?"":patkadd11 %> <%=patkadd21==null?"":patkadd21 %> <%=patkadd31==null?"":patkadd31 %> <%=patkadd41==null?"":patkadd41 %></td>
				</tr>
				<tr>
					<td colspan="5" height="25" style="background-color:#aa0066;">
						<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td class="style1"><font color="white"><strong>Hospital, Doctors and Insurance Company Information 住院、醫生及保險公司資料</strong></font></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Attending Doctor 主診醫生:</b> </td>
					<td height="20" valign="top"><%=admissiondoctor==null?"":(AdmissionDB.getDocFullName(admissiondoctor)==null?admissiondoctor:AdmissionDB.getDocFullName(admissiondoctor)) %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top" style='width:210px'><b>Adm. Date & Time 入院日期及時間:</b> </td>
					<td height="20" valign="top"><%=expectedAdmissionDate==null?"":expectedAdmissionDate %> <%=expectedAdmissionTime_hh==null?"--":expectedAdmissionTime_hh %>:<%=expectedAdmissionTime_mi==null?"--":expectedAdmissionTime_mi %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Room Class 病房等級:</b> </td>
					<td height="20" valign="top"><%=roomType==null?"":roomType %></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Room & Bed 病房及病床:</b> </td>
					<td height="20" valign="top"><%=bedNo==null?"":bedNo %></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Slip No 賬單號碼:</b> </td>
					<td height="20" valign="top">&nbsp;</td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Insurance Policy No 保險號碼:</b> </td>
					<td height="20" valign="top"><%=insurancePolicyNo==null?"":insurancePolicyNo %></td>
				</tr>
				<tr>
					<td height="20" valign="top" style="width:180px"><b>Insurance Company 保險公司:</b> </td>
					<td height="20" valign="top" colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Voucher No單號:</b> </td>
					<td height="20" valign="top">&nbsp;</td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Adm. Clerk 登記職員姓名:</b> </td>
					<td height="20" valign="top">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="5" height="25">
						<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
											<td colspan="2"><u><b>Patient’s Declaration and Agreement</b></u></td>
										</tr>
										<tr>
											<td width="20" valign="top">1.</td><td>All information given by me to the Hong Kong Adventist Hospital - Stubbs Road ('the Hospital') herein is true and correct to the best of my knowledge.</td>
										</tr>
										<tr>
											<td width="20" valign="top">2.</td><td>I acknowledge receipt pamphlets of "Healthcare Advisory", "Daily Room Rate, Deposit", "Patient Admission", and "Patients' Charter" from the Hospital, which I have read, understood, and hereby agree to all terms and conditions therein.</td>
										</tr>
										<tr>
											<td width="20" valign="top">3.</td><td>I consent to diagnostic imaging, laboratory, physiotherapy, and other hospital cares provided by healthcare personnel which may include, but is not limited to, blood drawing, medical or surgical treatment, rendered under the general / special instructions of the attending physicians.</td>
										</tr>
										<tr>
											<td width="20" valign="top">4.</td><td>I hereby authorize the Hospital to release / disclose / share / access my personal data (including but not limited to medical records)
											<br>a.	by SMS, post or email through contact details provided by me.  I understand it is my responsibility to provide the Hospital  with my most updated contact detail(s);
											<br>b.	to my insurer, its agent or broker in connection with my insurance claim;
											<br>c.	to any medical institutions under Adventist Health Hong Kong, accreditation institutions / organizations / companies involved in accreditation of the Hospital, or government units of Hong Kong Special Administrative Region, for descriptive studies, statistic data collections, analyses, regulations compliance, health services planning and healthcare evaluation.</td>
										</tr>
										<tr>
											<td width="20" valign="top">5.</td><td>I agree to pay the Hospital all the fees and charges in accordance with the Hospital and doctors’ rates and charges, (name(s) of attending doctor and referred  doctor(s) shown  as above), in respect of all the goods and services rendered to me by the Hospital and the doctor(s).</td>
										</tr>
										<tr>
											<td width="20" valign="top">6.</td><td>I agree to pay any outstanding fees and charges that have not been paid or covered by my insurer;</td>
										</tr>
										<tr>
											<td width="20" valign="top">7.</td><td>I agree to comply with the Hospital's policies during my hospitalization, e.g. solely using medications and tube feeding formula provided by the Hospital.</td>
										</tr>
										<tr>
											<td width="20" valign="top">8.</td><td>I give my consent herein to the Hospital to send its direct marketing and health promotion materials in relation to its services to me by post, SMS, fax, email, or other means of communication or making telephone calls, via my address, telephone numbers, fax number and email address provided by me to the Hospital.
											<br><br>I understand that I may at any time require and notify the Hospital to cease using my data in direct marketing of health services and promotion and the Hospital must, without charge to me, comply with the requirement. The notification of such requirement may be sent to the Hospital by post, email, telephone call or other means of communication. 
													(Telephone No:3651 8997; Email Address:<a href="mailto:patientservice@hkah.org.hk">patientservice@hkah.org.hk</a>)
											</td>
										</tr>
										<tr>
											<td width="20" valign="top"></td>
											<td>
											<br/><br/><%=infoForPromotion!=null&&infoForPromotion.equals("N")?"☑":"□"%> I do not give my consent to the Hospital to use my data for direct marketing of health services and promotion purpose.
											</td>
										</tr>
										<tr>
											<td height="2" colspan="2">&nbsp;</td>
										</tr>
										<tr>
											<td colspan="2"><u><b>病人聲明及協議</b></u></td>
										</tr>
										<tr>
											<td width="20" valign="top">1.</td><td>本人提供予香港港安醫院–司徒拔道（「醫院」）的所有資料，在本人的個人認知範圍內，皆屬實和正確。</td>
										</tr>
										<tr>
											<td width="20" valign="top">2.</td><td>本人確認已收到及仔細閱讀〈住院須知〉、〈每日房租、預繳按金〉、〈入院須知〉和 〈病人權益與責任〉等小冊子，並且明白及同意上述小冊子的一切條款。</td>
										</tr>
										<tr>
											<td width="20" valign="top">3.</td><td>	本人同意在主診醫生的一般/特殊指令下，接受診斷成像、化驗室檢驗、物理治療等程序，及其他由醫護人員於本院提供的醫療護理服務，當中可能包括但不限於抽血、藥物或手術治療等。 </td>
										</tr>
										<tr>
											<td width="20" valign="top">4.</td><td>本人在此授權醫院可以郵寄或以電子方式，提交 / 透露 / 分享 / 索取本人的個人資料（包括但不限於醫療記錄）
											<br>a.	到本人所提供的短訊接收號碼、地址或電郵地址，亦明白有責任向醫院提供最新的聯絡方法以達此目的； 
											<br>b.	予本人的承保人、代理人或經紀人，就本人的保險索償事宜聯繫； 
											<br>c.	予任何港安醫療轄下的醫療機構、及其參與評審認證的認可機構 / 組織 / 公司，或香港特別行政區政府單位作描述性研究、收集統計數據、分析、法規遵從、健康服務規劃和衞生保健評估的用途。 </td>
										</tr>
										<tr>
											<td width="20" valign="top">5.</td><td>本人同意按照醫院和醫生的收費準則 （上述所提及的主診醫生及轉介醫生的姓名），並支付所有由醫院提供予本人的治療、設施和服務的費用。</td>
										</tr>
										<tr>
											<td width="20" valign="top">6.</td><td>本人同意支付所有尚未繳付或保險公司沒有承保的額外費用。</td>
										</tr>
										<tr>
											<td width="20" valign="top">7.</td><td>本人同意於住院期間遵守醫院政策，例如只會服用由醫院供應的藥物及管飼飲食配方。</td>
										</tr>
										<tr>
											<td width="20" valign="top">8.</td><td>本人同意醫院可以藉郵件、短訊、圖文傳真、電郵或其他形式的傳訊，或致電，向本人提供與醫院服務或健康有關的資料。
											<br><br>本人明白，本人可以隨時藉郵件、電郵、電話通話或其他形式的傳訊，通知醫院停止使用本人的個人資料來提供與醫院服務或健康有關的資料。同時，醫院不會因此向本人收取費用。（電話號碼：3651 8997 ; 電郵地址：<a href="patientservice@hkah.org.hk">patientservice@hkah.org.hk</a>） </td>
										</tr>
										<tr>
											<td width="20" valign="top"></td>
											<td>
											<br/><br/><%=infoForPromotion!=null&&infoForPromotion.equals("N")?"☑":"□"%> 本人不同意醫院使用本人的個人資料來提供與醫院服務或健康訊息有關的資料。
										
											</td>
										</tr>
										<tr>
											<td height="2" colspan="2">&nbsp;</td>
										</tr>
										<tr>
											<td colspan="2"><font color="red">If there is any inconsistency or ambiguity between the English version and the Chinese version, the English version shall prevail.<br />中英文版本如有歧異，概以英文版本為準。</font></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br /><br /><br />
<div class="pane">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="leftText">
		<td align="left" colspan="2">
			<p><span>&nbsp;</span></p>
			<p><span><font color="red" size="4px">Please verify the details of your registration.  You may press <b>MODIFY</b> button to change any details or press <b>SUBMIT</b> button to confirm and proceed to payment.</font></span></p>
			<p><span">&nbsp;</span></p>
			<p><span><font color="red" size="4px">請核對您的登記表內容，如有更改，請按［更改］鍵；或按［同意及傳送］鍵以確認上述資料及進行付款。</font></span></p>
			<p><span>&nbsp;</span></p>
		</td>
	</tr>
	<tr class="middleText">
	<td valign="top"><font color="red">*</font> <input type="checkbox" name="patientAgreement" value="Y" /></td>
	<td valign="top" align="left" width="95%"> By checking this box, I confirm that I have read, understood and agreed to the Patient's Agreement and the <a class="topstoryblue" onclick=" downloadFile('632', ''); return false;" href="javascript:void(0);" target="_blank">Policy Statement relating to the Personal Data (Privacy) Ordinance</a>.</br>
											          本人已閱讀並同意病人協議及關於<a class="topstoryblue" onclick=" downloadFile('767', ''); return false;" href="javascript:void(0);" target="_blank">《個人資料 (私隱) 條例》("私隱條例") 的政策指引</a>。
	<p><span">&nbsp;</span></p>
	</td>
	</tr>

	<tr class="middleText">
		<td align="center" colspan="2">
			<button class="btn-submit" onclick="backAction();return false;">Modify 更改</button>
			<button class="btn-submit" onclick="submitAction();return false;">I Agree and <b>SUBMIT</b> for payment 同意及傳送</button>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="create" />
<input type="hidden" name="step" value="1" />
<input type="hidden" name="admissionID" value="<%=admissionID==null?"":admissionID %>" />
<input type="hidden" name="patno" value="<%=patno==null?"":patno %>" />
<input type="hidden" name="expectedAdmissionDate" value="<%=expectedAdmissionDate==null?"":expectedAdmissionDate %>" />
<input type="hidden" name="expectedAdmissionTime_hh" value="<%=expectedAdmissionTime_hh==null?"":expectedAdmissionTime_hh%>" />
<input type="hidden" name="expectedAdmissionTime_mi" value="<%=expectedAdmissionTime_mi==null?"":expectedAdmissionTime_mi%>" />
<input type="hidden" name="admissiondoctor" value="<%=admissiondoctor==null?"":admissiondoctor %>" />
<input type="hidden" name="remarks" value="<%=remarks==null?"":remarks %>" />
<input type="hidden" name="patidno1" value="<%=patidno1==null?"":patidno1 %>" />
<input type="hidden" name="patidno2" value="<%=patidno2==null?"":patidno2 %>" />
<input type="hidden" name="patpassport" value="<%=patpassport==null?"":patpassport %>" />
<input type="hidden" name="patbdate" value="<%=patbdate==null?"":patbdate %>" />
<input type="hidden" name="patfname" value="<%=patfname==null?"":patfname %>" />
<input type="hidden" name="patgname" value="<%=patgname==null?"":patgname %>" />
<input type="hidden" name="titleDesc" value="<%=titleDesc==null?"":titleDesc %>" />
<input type="hidden" name="titleDescOther" value="<%=titleDescOther==null?"":titleDescOther %>" />
<input type="hidden" name="patcname" value="<%=patcname==null?"":patcname %>" />
<input type="hidden" name="patsex" value="<%=patsex==null?"":patsex %>" />
<input type="hidden" name="racedesc" value="<%=racedesc==null?"":racedesc %>" />
<input type="hidden" name="racedescOther" value="<%=racedescOther==null?"":racedescOther %>" />
<input type="hidden" name="religion" value="<%=religion==null?"":religion %>" />
<input type="hidden" name="religionOther" value="<%=religionOther==null?"":religionOther %>" />
<input type="hidden" name="patmsts" value="<%=patmsts==null?"":patmsts %>" />
<input type="hidden" name="patmstsOther" value="<%=patmstsOther==null?"":patmstsOther %>" />
<input type="hidden" name="mothcode" value="<%=mothcode==null?"":mothcode %>" />
<input type="hidden" name="mothcodeOther" value="<%=mothcodeOther==null?"":mothcodeOther %>" />
<input type="hidden" name="edulevel" value="<%=edulevelcode==null?"":edulevelcode %>" />
<input type="hidden" name="pathtel" value="<%=pathtel==null?"":pathtel %>" />
<input type="hidden" name="patotel" value="<%=patotel==null?"":patotel %>" />
<input type="hidden" name="patmtel" value="<%=patmtel==null?"":patmtel %>" />
<input type="hidden" name="patftel" value="<%=patftel==null?"":patftel %>" />
<input type="hidden" name="occupation" value="<%=occupation==null?"":occupation %>" />
<input type="hidden" name="patemail" value="<%=patemail==null?"":patemail %>" />
<input type="hidden" name="patadd1" value="<%=patadd1==null?"":patadd1 %>" />
<input type="hidden" name="patadd2" value="<%=patadd2==null?"":patadd2 %>" />
<input type="hidden" name="patadd3" value="<%=patadd3==null?"":patadd3 %>" />
<input type="hidden" name="patadd4" value="<%=patadd4==null?"":patadd4 %>" />
<input type="hidden" name="coucode" value="<%=coucode==null?"":coucode %>" />
<input type="hidden" name="patkfname1" value="<%=patkfname1==null?"":patkfname1 %>" />
<input type="hidden" name="patkgname1" value="<%=patkgname1==null?"":patkgname1 %>" />
<input type="hidden" name="patkcname1" value="<%=patkcname1==null?"":patkcname1 %>" />
<input type="hidden" name="patksex1" value="<%=patksex1==null?"":patksex1 %>" />
<input type="hidden" name="patkrela1" value="<%=patkrela1==null?"":patkrela1 %>" />
<input type="hidden" name="patkhtel1" value="<%=patkhtel1==null?"":patkhtel1 %>" />
<input type="hidden" name="patkotel1" value="<%=patkotel1==null?"":patkotel1 %>" />
<input type="hidden" name="patkmtel1" value="<%=patkmtel1==null?"":patkmtel1 %>" />
<input type="hidden" name="patkptel1" value="<%=patkptel1==null?"":patkptel1 %>" />
<input type="hidden" name="patkemail1" value="<%=patkemail1==null?"":patkemail1 %>" />
<input type="hidden" name="patkadd11" value="<%=patkadd11==null?"":patkadd11 %>" />
<input type="hidden" name="patkadd21" value="<%=patkadd21==null?"":patkadd21 %>" />
<input type="hidden" name="patkadd31" value="<%=patkadd31==null?"":patkadd31 %>" />
<input type="hidden" name="patkadd41" value="<%=patkadd41==null?"":patkadd41 %>" />
<input type="hidden" name="patkfname2" value="<%=patkfname2==null?"":patkfname2 %>" />
<input type="hidden" name="patkgname2" value="<%=patkgname2==null?"":patkgname2 %>" />
<input type="hidden" name="patkcname2" value="<%=patkcname2==null?"":patkcname2 %>" />
<input type="hidden" name="patksex2" value="<%=patksex2==null?"":patksex2 %>" />
<input type="hidden" name="patkrela2" value="<%=patkrela2==null?"":patkrela2 %>" />
<input type="hidden" name="patkhtel2" value="<%=patkhtel2==null?"":patkhtel2 %>" />
<input type="hidden" name="patkotel2" value="<%=patkotel2==null?"":patkotel2 %>" />
<input type="hidden" name="patkmtel2" value="<%=patkmtel2==null?"":patkmtel2 %>" />
<input type="hidden" name="patkptel2" value="<%=patkptel2==null?"":patkptel2 %>" />
<input type="hidden" name="patkemail2" value="<%=patkemail2==null?"":patkemail2 %>" />
<input type="hidden" name="patkadd12" value="<%=patkadd12==null?"":patkadd12 %>" />
<input type="hidden" name="patkadd22" value="<%=patkadd22==null?"":patkadd22 %>" />
<input type="hidden" name="patkadd32" value="<%=patkadd32==null?"":patkadd32 %>" />
<input type="hidden" name="patkadd42" value="<%=patkadd42==null?"":patkadd42 %>" />
<input type="hidden" name="roomType" value="<%=roomTypeCode==null?"":roomTypeCode %>" />
<input type="hidden" name="bedNo" value="<%=bedNo==null?"":bedNo %>" />
<input type="hidden" name="paymentType" value="<%=paymentType==null?"":paymentType %>" />
<input type="hidden" name="paymentTypeOther" value="<%=paymentTypeOther==null?"":paymentTypeOther %>" />
<input type="hidden" name="creditCardType" value="<%=creditCardType==null?"":creditCardType %>" />
<input type="hidden" name="insuranceRemarks" value="<%=insuranceRemarks==null?"":insuranceRemarks %>" />
<input type="hidden" name="insurancePolicyNo" value="<%=insurancePolicyNo==null?"":insurancePolicyNo %>" />
<input type="hidden" name="promotionYN" value="<%=promotionYN==null?"":promotionYN %>" />
<input type="hidden" name="language" value="<%=language %>"/>
<input type="hidden" name="infoForPromotion" value="<%=infoForPromotion==null?"":infoForPromotion %>" />
<input type="hidden" name="mktSrc" value="<%=mktSrc==null?"":mktSrc %>" />
<%
if (fileList != null && fileList.length > 0) {
		for (int i = 0; i < fileList.length; i++) {
%><input type="hidden" name="client.filelist" value="<%=patidno + ConstantsVariable.UNDERSCORE_VALUE + fileList[i] %>" />
<%
		}
	}
%>
<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
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
<!--
	function backAction() {
		//document.form1.action = "admission_client_confirm_vpc.jsp";
		//document.form1.submit();
		history.back();
	}

	function submitAction() {
		var msg = '';
		var focusField;
	if (!document.form1.patientAgreement.checked) {
		if (msg.length == 0) focusField = document.form1.patientAgreement;
		msg = msg + 'Please Confirm Patient Agreement 請確定已細閱病人恊議.\n';
		alert(msg);
		focusField.focus();
		return false;
	} else {
		$.prompt('Confirm to submit 確定傳送!',{
			buttons: { Ok: true, Cancel: false },
			callback: function(v,m,f){
				if (v){
<%
		if (unselectedImtInfo != null) {
			String tempValue = null;
			for (int j = 0; j < unselectedImtInfo.length; j++ ) {
				tempValue = unselectedImtInfo[j];
%>
					$('form[name="form1"]').append('<input type="hidden" name="unselectedInfo" value="'+<%=tempValue%>+'" />');
<%
			}
		}
%>
					submit: confirmAction();
					//history.pushState(null, null, "admission_client_payment.jsp");
					return true;
				} else {
					return false;
				}
			},
			prefix:'cleanblue'
		});
	}
	}

	function confirmAction() {
		showLoadingBox('body', 500, $(window).scrollTop());
		document.form1.submit();
	}
-->
</script>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>