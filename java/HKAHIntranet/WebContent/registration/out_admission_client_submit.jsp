<%@ page import="java.io.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String sessionKey = request.getParameter("session");
String patno = request.getParameter("patno");

String appointmentDate = request.getParameter("appointmentDate");
String appointmentTime = null;
String appointmentTime_hh = request.getParameter("appointmentTime_hh");
String appointmentTime_mi = request.getParameter("appointmentTime_mi");
String attendDoctor = TextUtil.parseStrUTF8(request.getParameter("attendDoctor"));

String patidno = null;
String patidno1 = TextUtil.parseStr(request.getParameter("patidno1")).toUpperCase();
String patidno2 = TextUtil.parseStr(request.getParameter("patidno2")).toUpperCase();
String patpassport = TextUtil.parseStr(request.getParameter("patpassport")).toUpperCase();
String pattraveldoc = TextUtil.parseStr(request.getParameter("pattraveldoc")).toUpperCase();
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
String patmstsOther = TextUtil.parseStrUTF8(request.getParameter("patmstsOther"));
String mothcode = request.getParameter("mothcode");
String edulevel = request.getParameter("edulevel");
String edulevelOther = TextUtil.parseStrUTF8(request.getParameter("edulevelOther"));
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
String patkrela1 = TextUtil.parseStrUTF8(request.getParameter("patkrela1"));
String patkhtel1 = TextUtil.parseStrUTF8(request.getParameter("patkhtel1"));
String patkotel1 = TextUtil.parseStrUTF8(request.getParameter("patkotel1"));
String patkmtel1 = TextUtil.parseStrUTF8(request.getParameter("patkmtel1"));
String patkemail1 = TextUtil.parseStrUTF8(request.getParameter("patkemail1"));
String patkadd11 = TextUtil.parseStrUTF8(request.getParameter("patkadd11"));
String patkadd21 = TextUtil.parseStrUTF8(request.getParameter("patkadd21"));
String patkadd31 = TextUtil.parseStrUTF8(request.getParameter("patkadd31"));
String patkadd41 = TextUtil.parseStrUTF8(request.getParameter("patkadd41"));
String patkTitleDesc1 = TextUtil.parseStrUTF8(request.getParameter("patkTitleDesc1"));
String patkTitleDescOther1 = TextUtil.parseStrUTF8(request.getParameter("patkTitleDescOther1"));
String patkcoucode1 = request.getParameter("patkcoucode1");

String patkfname2 = TextUtil.parseStrUTF8(request.getParameter("patkfname2"));
String patkgname2 = TextUtil.parseStrUTF8(request.getParameter("patkgname2"));
String patkcname2 = TextUtil.parseStrUTF8(request.getParameter("patkcname2"));
String patkrela2 = TextUtil.parseStrUTF8(request.getParameter("patkrela2"));
String patkhtel2 = request.getParameter("patkhtel2");
String patkotel2 = request.getParameter("patkotel2");
String patkmtel2 = request.getParameter("patkmtel2");
String patkemail2 = request.getParameter("patkemail2");
String patkadd12 = TextUtil.parseStrUTF8(request.getParameter("patkadd12"));
String patkadd22 = TextUtil.parseStrUTF8(request.getParameter("patkadd22"));
String patkadd32 = TextUtil.parseStrUTF8(request.getParameter("patkadd32"));
String patkadd42 = TextUtil.parseStrUTF8(request.getParameter("patkadd42"));
String patkTitleDesc2 = TextUtil.parseStrUTF8(request.getParameter("patkTitleDesc2"));
String patkTitleDescOther2 = TextUtil.parseStrUTF8(request.getParameter("patkTitleDescOther2"));
String patkcoucode2 = request.getParameter("patkcoucode2");

String patHowInfo = request.getParameter("patHowInfo");
String patHowInfoOther = TextUtil.parseStrUTF8(request.getParameter("patHowInfoOther"));

String promotionYN = request.getParameter("promotionYN");
String[] unselectedImtInfo = null;
String[] fileList = null;
String language = request.getParameter("language");

if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);

	sessionKey = (String) request.getAttribute("session");
	patno = (String) request.getAttribute("patno");
	
	appointmentDate =(String) request.getAttribute("appointmentDate");	
	appointmentTime_hh = (String)request.getAttribute("appointmentTime_hh");
	appointmentTime_mi = (String)request.getAttribute("appointmentTime_mi");
	attendDoctor = TextUtil.parseStrUTF8((String)request.getAttribute("attendDoctor"));

	patidno1 = TextUtil.parseStr((String) request.getAttribute("patidno1")).toUpperCase();
	patidno2 = TextUtil.parseStr((String) request.getAttribute("patidno2")).toUpperCase();
	patpassport = TextUtil.parseStr((String) request.getAttribute("patpassport")).toUpperCase();
	pattraveldoc = TextUtil.parseStr((String) request.getAttribute("pattraveldoc")).toUpperCase();
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
	patmstsOther = TextUtil.parseStrUTF8((String) request.getAttribute("patmstsOther"));
	mothcode = (String) request.getAttribute("mothcode");	
	edulevel = (String) request.getAttribute("edulevel");
	edulevelOther = TextUtil.parseStrUTF8((String) request.getAttribute("edulevelOther"));
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
	patkrela1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkrela1"));
	patkhtel1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkhtel1"));
	patkotel1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkotel1"));
	patkmtel1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkmtel1"));
	patkemail1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkemail1"));
	patkadd11 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd11"));
	patkadd21 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd21"));
	patkadd31 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd31"));
	patkadd41 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd41"));
	patkTitleDesc1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkTitleDesc1"));
	patkTitleDescOther1 = TextUtil.parseStrUTF8((String) request.getAttribute("patkTitleDescOther1"));
	patkcoucode1 = (String) request.getAttribute("patkcoucode1");
	
	patkfname2 = TextUtil.parseStrUTF8((String) request.getAttribute("patkfname2"));
	patkgname2 = TextUtil.parseStrUTF8((String) request.getAttribute("patkgname2"));
	patkcname2 = TextUtil.parseStrUTF8((String) request.getAttribute("patkcname2"));
	patkrela2 = TextUtil.parseStrUTF8((String) request.getAttribute("patkrela2"));
	patkhtel2 = (String) request.getAttribute("patkhtel2");
	patkotel2 = (String) request.getAttribute("patkotel2");
	patkmtel2 = (String) request.getAttribute("patkmtel2");
	patkemail2 = (String) request.getAttribute("patkemail2");
	patkadd12 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd12"));
	patkadd22 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd22"));
	patkadd32 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd32"));
	patkadd42 = TextUtil.parseStrUTF8((String) request.getAttribute("patkadd42"));
	patkTitleDesc2 = TextUtil.parseStrUTF8((String) request.getAttribute("patkTitleDesc2"));
	patkTitleDescOther2 = TextUtil.parseStrUTF8((String) request.getAttribute("patkTitleDescOther2"));
	patkcoucode2 = (String) request.getAttribute("patkcoucode2");
	
	patHowInfo = (String) request.getAttribute("patHowInfo");
	patHowInfoOther = TextUtil.parseStrUTF8((String) request.getAttribute("patHowInfoOther"));

	promotionYN = (String) request.getAttribute("promotionYN");
	unselectedImtInfo = (String[]) request.getAttribute("unselectedInfo_StringArray");
	language= (String) request.getAttribute("language");
	
	patidno = patpassport;
	if (patidno.length() == 0) {
		patidno = patidno1 + patidno2;
	}
	if (patidno.length() == 0) {
		patidno = pattraveldoc;
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
	if (patidno.length() == 0) {
		patidno = pattraveldoc;
	}
}
String patsexDesc = null;
if (patsex != null && patsex.length() > 0) {
	if ("M".equals(patsex)) {
		patsexDesc = "Male";
	} else if ("F".equals(patsex)) {
		patsexDesc = "Female";
	}
} else {
	patsexDesc = "";
}

String raceDesc = null;
if (racedesc != null && racedesc.length() > 0) {
	raceDesc = racedesc;
} else {
	raceDesc = racedescOther;
}

String regligionDesc = null;
if (religion != null && religion.length() > 0) {
	if ("NO".equals(religion)) {
		regligionDesc = "None";
	} else if ("BU".equals(religion)) {
		regligionDesc = "Buddhism";
	} else if ("CA".equals(religion)) {
		regligionDesc = "Catholic";
	} else if ("CH".equals(religion)) {
		regligionDesc = "Christian";
	} else if ("HI".equals(religion)) {
		regligionDesc = "Hinduism";
	} else if ("SH".equals(religion)) {
		regligionDesc = "Shintoism";
	} else if ("SD".equals(religion)) {
		regligionDesc = "SDA";
	} else {
		regligionDesc = "Others";
	}
} else {
	regligionDesc = religionOther;
}

String patmstsDesc = null;
if ("S".equals(patmsts)) {
	patmstsDesc = "Single";
} else if ("M".equals(patmsts)) {
	patmstsDesc = "Married";
} else {	
	patmstsDesc = patmstsOther;
}

String mothcodeDesc = null;
if ("ENG".equals(mothcode)) {
	mothcodeDesc = "English";
} else if ("TRC".equals(mothcode)) {
	mothcodeDesc = "Traditional Chinese";
} else if ("SMC".equals(mothcode)) {
	mothcodeDesc = "Simplified Chinese";
} else if ("JAP".equals(mothcode)) {
	mothcodeDesc = "Japanese";
} else {
	mothcodeDesc = "";
}

String titleDescription = null;
if (titleDesc != null && titleDesc.length() > 0) {
	titleDescription = titleDesc;
} else {
	titleDescription = titleDescOther;
}

String edulevelDesc = null;
if (edulevel != null && edulevel.length() > 0) {
	edulevelDesc = edulevel;
} else {
	edulevelDesc = edulevelOther;
}

String patkTitle1 = null;
if (patkTitleDesc1 != null && patkTitleDesc1.length() > 0) {
	patkTitle1 = patkTitleDesc1;
} else {
	patkTitle1 = patkTitleDescOther1;
}

String patkTitle2 = null;
if (patkTitleDesc2 != null && patkTitleDesc2.length() > 0) {
	patkTitle2 = patkTitleDesc2;
} else {
	patkTitle2 = patkTitleDescOther2;
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
		<td class="step3_1" width="20%"><p>Check Personal Information<br>檢查個人資料</p></td>
		<td class="step3_2" width="20%"><p>Input Personal Information<br>輸入個人資料</p></td>
		<td class="step3_3" width="20%"><p>Submit Personal Information<br>傳送個人資料</p></td>
	</tr>
</table>
<form name="form1" enctype="multipart/form-data" action="out_admission.jsp" method="post">
<table width="800" border="1" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="4" height="25" bgcolor="#aa0066">
						<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td class="style1"><font color="white"><strong>App. & Doctors and Insurance Company 預約、醫生及保險公司資料</strong></font></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>				
					<td height="20" valign="top"><b>App. Date & Time 預約日期及時間:</b> </td>
					<td height="20" valign="top"><%=appointmentDate==null?"":appointmentDate %> <%=appointmentTime_hh==null?"--":appointmentTime_hh %>:<%=appointmentTime_mi==null?"--":appointmentTime_mi %></td>
					<td height="20" valign="top"><b>Attending Doctor 主診醫生:</b> </td>
					<td height="20" valign="top"><%=attendDoctor==null?"":(AdmissionDB.getDocName(attendDoctor)==null?attendDoctor:AdmissionDB.getDocName(attendDoctor)) %></td>
					
				</tr>
				<tr>
					<td colspan="4" height="25" bgcolor="#aa0066">
						<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td class="style1"><font color="white"><strong>Personal Information 個人資料</strong></font></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Surname in English 姓(英文):</b> </td>
					<td height="20" valign="top"><%=patfname==null?"":patfname %></td>					
					<td height="20" valign="top"><b>Given Names in English 名(英文):</b> </td>	
					<td height="20" valign="top"><%=patgname==null?"":patgname %></td>		
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Chinese Name 中文姓名:</b> </td>	
					<td height="20" valign="top"><%=patcname==null?"":patcname %></td>					
					<td height="20" valign="top"><b>Title 稱謂:</b> </td>
					<td height="20" valign="top"><%=titleDescription==null?"":titleDescription %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top">
						<b>*HK Identity Card / Passport / Travel Document No.</br>
						*香港身份證 / 護照 / 旅遊證件號碼:
						</b> </td>	
					<td height="20"><%=patidno==null?"":patidno %></td>					
					<td height="20" valign="top"><b>Sex 性別:</b> </td>
					<td height="20" valign="top"><%=patsexDesc==null?"":patsexDesc %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Date of Birth (DD/MM/YYYY) 出生日期 (日/月/年):</b> </td>	
					<td height="20" valign="top"><%=patbdate==null?"":patbdate %></td>					
					<td height="20" valign="top"><b>Marital Status 婚姻狀況:</b> </td>
					<td height="20" valign="top"><%=patmstsDesc==null?"":patmstsDesc %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top">
						<b>Nationality (For hospital statistic purpose only)</br>國籍 (作為醫院統計用):</b> 
					</td>
					<td height="20" ><%=raceDesc==null?"":raceDesc %></td>	
					<td height="20" valign="top"><b>Religion 宗教:</b> </td>	
					<td height="20" valign="top"><%=regligionDesc==null?"":regligionDesc %></td>
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Correspondence Language通訊語言:</b> </td>	
					<td height="20" valign="top"><%=mothcodeDesc==null?"":mothcodeDesc %></td>					
					<td height="20" valign="top"><b>Education Level 教育程度:</b> </td>
					<td height="20" valign="top"><%=edulevelDesc==null?"":edulevelDesc%></td>	
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Email Address (if any) 電郵地址 (如有):</b> </td>	
					<td height="20" valign="top"><%=patemail==null?"":patemail %></td>	
					<td height="20" valign="top"><b>Occupation 職業:</b> </td>
					<td height="20" valign="top"><%=occupation==null?"":occupation %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Home Phone No. 住宅電話:</b> </td>	
					<td height="20" valign="top"><%=pathtel==null?"":pathtel %></td>					
					<td height="20" valign="top"><b>Mobile Phone 流動電話:</b> </td>
					<td height="20" valign="top"><%=patmtel==null?"":patmtel %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Office Phone No. 辦公室電話:</b> </td>	
					<td height="20" valign="top"><%=patotel==null?"":patotel %></td>					
					<td height="20" valign="top"><b>Fax No. 傳真號碼:</b> </td>
					<td height="20" valign="top"><%=patftel==null?"":patftel %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Address地址:</b> </td>	
					<td height="20" valign="top" colspan="3"><%=patadd1==null?"":patadd1 %> <%=patadd2==null?"":patadd2 %> <%=patadd3==null?"":patadd3 %> <%=coucode==null||"".equals(coucode) ?"":AdmissionDB.getCountryDesc(coucode) %></td>	
				</tr>
				
				<tr>
					<td colspan="4" height="25" bgcolor="#aa0066">
						<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td class="style1"><font color="white"><strong>Emergency Contact Person 緊急聯絡人資料 (1)</strong></font></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Surname in English 姓(英文):</b> </td>
					<td height="20" valign="top"><%=patkfname1==null?"":patkfname1 %></td>					
					<td height="20" valign="top"><b>Given Names in English 名(英文):</b> </td>	
					<td height="20" valign="top"><%=patkgname1==null?"":patkgname1 %></td>		
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Chinese Name 中文姓名:</b> </td>	
					<td height="20" valign="top"><%=patkcname1==null?"":patkcname1 %></td>					
					<td height="20" valign="top"><b>Title 稱謂:</b> </td>
					<td height="20" valign="top"><%=patkTitle1==null?"":patkTitle1 %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Relationship 關係:</b> </td>	
					<td height="20" valign="top"><%=patkrela1==null?"":patkrela1 %></td>					
					<td height="20" valign="top"><b>Home Phone No. 住宅電話:</b> </td>	
					<td height="20" valign="top"><%=patkhtel1==null?"":patkhtel1 %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Mobile Phone 流動電話:</b> </td>
					<td height="20" valign="top"><%=patkmtel1==null?"":patkmtel1 %></td>			
					<td height="20" valign="top"><b>Office Phone No. 辦公室電話:</b> </td>	
					<td height="20" valign="top"><%=patkotel1==null?"":patkotel1 %></td>				
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Email Address 電郵地址:</b> </td>	
					<td height="20" valign="top" colspan="3"><%=patkemail1==null?"":patkemail1 %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Address (If different from patient’s address)</br>地址 (如與病人不同):</b> </td>	
					<td height="20" colspan="3"><%=patkadd11==null?"":patkadd11 %> <%=patkadd21==null?"":patkadd21 %> <%=patkadd31==null?"":patkadd31 %> <%=patkcoucode1==null||"".equals(patkcoucode1) ?"":AdmissionDB.getCountryDesc(patkcoucode1) %></td>	
				</tr>
				<tr>
					<td colspan="4" height="25" bgcolor="#aa0066">
						<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td class="style1"><font color="white"><strong>Emergency Contact Person 緊急聯絡人資料 (2)</strong></font></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Surname in English 姓(英文):</b> </td>
					<td height="20" valign="top"><%=patkfname2==null?"":patkfname2 %></td>					
					<td height="20" valign="top"><b>Given Names in English 名(英文):</b> </td>	
					<td height="20" valign="top"><%=patkgname2==null?"":patkgname2 %></td>		
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Chinese Name 中文姓名:</b> </td>	
					<td height="20" valign="top"><%=patkcname2==null?"":patkcname2 %></td>					
					<td height="20" valign="top"><b>Title 稱謂:</b> </td>
					<td height="20" valign="top"><%=patkTitle2==null?"":patkTitle2 %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Relationship 關係:</b> </td>	
					<td height="20" valign="top"><%=patkrela2==null?"":patkrela2 %></td>					
					<td height="20" valign="top"><b>Home Phone No. 住宅電話:</b> </td>	
					<td height="20" valign="top"><%=patkhtel2==null?"":patkhtel2 %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Mobile Phone 流動電話:</b> </td>
					<td height="20" valign="top"><%=patkmtel2==null?"":patkmtel2 %></td>			
					<td height="20" valign="top"><b>Office Phone No. 辦公室電話:</b> </td>	
					<td height="20" valign="top"><%=patkotel2==null?"":patkotel2 %></td>				
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Email Address 電郵地址:</b> </td>	
					<td height="20" valign="top" colspan="3"><%=patkemail2==null?"":patkemail2 %></td>	
				</tr>
				<tr>								
					<td height="20" valign="top"><b>Address (If different from patient’s address)</br>地址 (如與病人不同):</b> </td>	
					<td height="20" colspan="3"><%=patkadd12==null?"":patkadd12 %> <%=patkadd22==null?"":patkadd22 %> <%=patkadd32==null?"":patkadd32 %> <%=patkcoucode2==null||"".equals(patkcoucode2) ?"":AdmissionDB.getCountryDesc(patkcoucode2) %></td>	
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>								
					<td height="20" valign="top"><b>How did you hear about us 認識本院的途徑:</b> </td>
					<td height="20" valign="top">
					<%			
					String patHowInfoDisplay = "";
				
					if(patHowInfo != null && patHowInfo.length() > 0){
						if("enews".equals(patHowInfo)){
							patHowInfoDisplay = "E-newsletter 電子報 ";
						}else if("friend".equals(patHowInfo)){
							patHowInfoDisplay = "Friends / Relatives 親友介紹 ";
						}else if("web".equals(patHowInfo)){
							patHowInfoDisplay = "Hospital website 醫院網站 ";
						}else if("news".equals(patHowInfo)){
							patHowInfoDisplay = "Newspaper / Magazine 報章 / 雜誌";
						}else if("other".equals(patHowInfo)){
							patHowInfoDisplay = "Other 其他";
						}
					}					
					%>
					<%=patHowInfoDisplay %>
					</td>
					<td height="20" valign="top" colspan="2"><%=patHowInfoOther==null?"":patHowInfoOther%></td>			
				</tr>			
				<tr>
					<td colspan="5" height="25">
						<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
											<td colspan="2"><u><b>Patient's Agreement</b></u></td>
										</tr>
										<tr>
											<td width="20" valign="top">1.</td><td>All information given by me is true and correct to the best of my personal knowledge.</td>
										</tr>
										<tr>
											<td width="20" valign="top">2.</td><td>I acknowledge the fact that patients treated or admitted to Hong Kong Adventist Hospital ("the Hospital") are under the direct care, supervision and responsibility of their attending physician. I am informed and recognize that all physicians, specialists, surgeons and independent contractors providing services to patients are not employees or agents of the Hospital.</td>
										</tr>
										<tr>
											<td width="20" valign="top">3.</td><td>I consent to diagnostic imaging, laboratory and physiotherapy procedures which may include, but not limited to, blood drawing, medical or surgical treatment, and other Hospital’s services rendered under the general/special instructions of the attending physician.</td>
										</tr>
										<tr>
											<td width="20" valign="top">4.</td><td>I agree to pay the Hospital’s current rates and charges at the time the services rendered in respect of the facilities used and treatment received by me and all other incidental charges incurred.</td>
										</tr>
										<tr>
											<td width="20" valign="top">5.</td><td>I hereby authorize the Hospital to contact and release/disclose/share all my personal data (including but not limited to medical record) to/with my insurer, its agent or broker for activities pertaining to my insurance claim, or any accreditation institutions / organizations / company involved in accreditation of the Hospital.</td>
										</tr>
										<tr>
											<td width="20" valign="top">6.</td><td>I agree to pay any outstanding charges that have not been paid or covered by my insurer.</td>
										</tr>	
										<tr>
											<td width="20" valign="top">7.</td><td>I agree Clauses 1 to 6 shall remain valid and effective unless specifically revoked by me in writing.</td>
										</tr>	
										<tr>
											<td width="20" valign="top">8.</td><td>I give my consent herein to the Hospital to send its direct marketing and health promotion materials in relation to its services to me by post, SMS, fax, electronic mail or other means of communication or making telephone calls via my address, telephone numbers, fax number and email address provided by me to the Hospital.</td>
										</tr>				
										<tr>
											<td height="2" colspan="2">&nbsp;</td>
										</tr>
															
										<tr>
											<td colspan="2"><u><b>病人協議</b></u></td>
										</tr>
										<tr>
											<td width="20" valign="top">1.</td><td>所有由本人提供的資料在本人的個人認知範圍內皆屬實和正確。</td>
										</tr>
										<tr>
											<td width="20" valign="top">2.</td><td>本人知悉在香港港安醫院（「醫院」）接受治療或留院之病人，均直接由主診醫生照顧、監護及負責。本人知悉及知道，所有為病人服務的醫生、專家、外科醫生及獨立承包商均不屬醫院僱員及代理。</td>
										</tr>
										<tr>
											<td width="20" valign="top">3.</td><td>本人同意在主診醫生的一般/特殊指令下，接受診斷成像、實驗室檢驗及物理治療等程序，當中可能包括但不限於抽血、藥物或手術治療及來自其他醫院提供之服務等。</td>
										</tr>
										<tr>
											<td width="20" valign="top">4.</td><td>本人同意支付所有由醫院提供予本人的治療、設施和服務的規定費用，及偶發事故所帶來的收費。</td>
										</tr>
										<tr>
											<td width="20" valign="top">5.</td><td>本人在此授權醫院就本人的保險索償事宜與本人的承保人或其附屬之仲介人或經紀人聯繫，及向其提交 / 披露 / 分享或索取所有與本人有關的個人資料 ( 包括但不限於醫療紀錄 )，及授權醫院提交 / 披露 / 分享所有與本人有關的個人資料 ( 包括但不限於醫療紀錄 ) 予參與評審醫院的任何認可機構 / 組織 / 公司。</td>
										</tr>
										<tr>
											<td width="20" valign="top">6.</td><td>本人同意支付所有額外費用或保險公司所未能承保的費用。</td>
										</tr>		
										<tr>
											<td width="20" valign="top">7.</td><td>本人同意此協議第一至六條將持續有效，直至本人以書面方式，明確要求取消此協議。</td>
										</tr>		
										<tr>
											<td width="20" valign="top">8.</td><td>本人同意醫院可以藉郵件、短訊、圖文傳真、電子郵件或其他形式的傳訊，或通過電話通話，向本人提供與醫院服務或健康訊息有關的資料。</td>
										</tr>										
										<tr>
											<td height="2" colspan="2">&nbsp;</td>
										</tr>
										
										<tr>
											<td height="2" colspan="2"><input disabled type="checkbox" name="promotionYN" value="N" />I do not give my consent to the Hospital to use my data for direct marketing of health services and promotion purpose.</br> 本人不同意醫院使用本人的個人資料來提供與醫院服務或健康訊息有關的資料。</td>
										</tr>	
										<tr>
											<td height="2" colspan="2">&nbsp;</td>
										</tr>
										<tr>
											<td></td>
											<td>I understand that I may at any time require and notify the Hospital to cease to use my data in direct marketing of health services and promotion and the Hospital must, without charge to me, comply with the requirement. The notification of such requirement may be sent to the Hospital by post, electronic mail, telephone call or other means of communication. (Tel: 3651 8997 ; Email: patientservice@hkah.org.hk)</td>
										</tr>											
										<tr>
											<td></td>
											<td>本人明白，本人可以隨時藉郵件、電子郵件、電話通話或其他形式的傳訊，通知醫院停止使用本人的個人資料來提供與醫院服務或健康訊息有關的資料。同時，醫院不會因此向本人收取費用。(電話號碼：3651 8997 ; 電郵地址：patientservice@hkah.org.hk)</td>
										</tr>									
													
										<tr>
											<td colspan="2">
												<table width="100%" border="0" cellpadding="0" cellspacing="0">
													<tr>
														<td height="2">&nbsp;</td>
													</tr>
													<tr>
														<td height="2">&nbsp;</td>
													</tr>
													<tr>
														<td>Patient Signature:</td><td>&nbsp;</td>
														<td>Name:</td><td>&nbsp;</td>
														<td >Date:</td><td></td>
													</tr>
													<tr>
														<td>病人簽署</td><td>________________________________</td>
														<td>姓名</td><td>_______________________________</td>
														<td align="right">日期</td><td>________________________</td>
													</tr>
													<tr>
														<td height="2">&nbsp;</td>
													</tr>
													<tr>
														<td>Responsible Party Signature:</td><td>&nbsp;</td>
														<td>Name:</td><td>&nbsp;</td>
														<td colspan="2">Relationship:</td>
													</tr>
													<tr>
														<td>負責人簽署</td><td>________________________________</td>
														<td>姓名</td><td>_______________________________</td>
														<td>關係</td><td>________________________</td>
													</tr>
													<tr>
														<td height="2">&nbsp;</td>
													</tr>
													<tr>
														<td height="2">&nbsp;</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td colspan="2"><font color="red">**</font>If there is any inconsistency or ambiguity between the English version and the Chinese version, the English version shall prevail.<br />中英文版本如有歧異，概以英文版本為準。</td>
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
			<p><span><font color="red" size="4px">Please check the details of your registration.  You may review and change any details by pressing the <b>MODIFY</b> button.</font></span></p>
			<p><span">&nbsp;</span></p>
			<p><span><font color="red" size="4px">請檢查您的登記表內容。您可以按更改鍵來覆核及作出更改。</font></span></p>			
			<p><span>&nbsp;</span></p>
		</td>
	</tr>
	<tr class="middleText">
	<td valign="top"><font color="red">*</font> <input type="checkbox" name="patientAgreement" value="Y" /></td>
	<td valign="top" align="left" width="95%">By ticking this box, I confirm that I have read and agree the Patient’s Agreement.								本人已閱讀及同意病人協議。
	<p><span">&nbsp;</span></p>
	</td>
	</tr>
	<tr>
		<td colspan="2">
			<p><span><font color="red" size="4px">Once you are satisfied with the registration, please press  <b>SUBMIT</b> INFORMATION.</font></span></p>
			<p><span">&nbsp;</span></p>
			<p><span><font color="red" size="4px">如您對以上的登記表內容感到滿意﹐請按確認提交。</font></span></p>	
			<p><span">&nbsp;</span></p>
		</td>
	</tr>

	<tr class="middleText">
		<td align="center" colspan="2">
			<button class="btn-submit" onclick="backAction();return false;">Modify 更改</button>
			<button class="btn-submit" onclick="submitAction();return false;">I Agree and submit the information 同意及傳送</button>
		</td>
	</tr>
</table>
</div>
</div></div>
<input type="hidden" name="command" value="create" />
<input type="hidden" name="step" value="1" />
<input type="hidden" name="admissionID" />
<input type="hidden" name="patno" value="<%=patno==null?"":patno %>" />
<input type="hidden" name="appointmentDate" value="<%=appointmentDate==null?"":appointmentDate %>" />
<input type="hidden" name="appointmentTime_hh" value="<%=appointmentTime_hh==null?"":appointmentTime_hh%>" />
<input type="hidden" name="appointmentTime_mi" value="<%=appointmentTime_mi==null?"":appointmentTime_mi%>" />
<input type="hidden" name="attendDoctor" value="<%=attendDoctor==null?"":attendDoctor%>" />
<input type="hidden" name="patidno1" value="<%=patidno1==null?"":patidno1 %>" />
<input type="hidden" name="patidno2" value="<%=patidno2==null?"":patidno2 %>" />
<input type="hidden" name="patpassport" value="<%=patpassport==null?"":patpassport %>" />
<input type="hidden" name="pattraveldoc" value="<%=pattraveldoc==null?"":pattraveldoc%>" />
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
<input type="hidden" name="edulevelOther" value="<%=patmsts==null?"":patmstsOther %>" />
<input type="hidden" name="mothcode" value="<%=mothcode==null?"":mothcode %>" />
<input type="hidden" name="edulevel" value="<%=edulevel==null?"":edulevel %>" />
<input type="hidden" name="edulevelOther" value="<%=edulevelOther==null?"":edulevelOther %>" />
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
<input type="hidden" name="patkrela1" value="<%=patkrela1==null?"":patkrela1 %>" />
<input type="hidden" name="patkhtel1" value="<%=patkhtel1==null?"":patkhtel1 %>" />
<input type="hidden" name="patkotel1" value="<%=patkotel1==null?"":patkotel1 %>" />
<input type="hidden" name="patkmtel1" value="<%=patkmtel1==null?"":patkmtel1 %>" />
<input type="hidden" name="patkemail1" value="<%=patkemail1==null?"":patkemail1 %>" />
<input type="hidden" name="patkadd11" value="<%=patkadd11==null?"":patkadd11 %>" />
<input type="hidden" name="patkadd21" value="<%=patkadd21==null?"":patkadd21 %>" />
<input type="hidden" name="patkadd31" value="<%=patkadd31==null?"":patkadd31 %>" />
<input type="hidden" name="patkadd41" value="<%=patkadd41==null?"":patkadd41 %>" />
<input type="hidden" name="patkcoucode1" value="<%=patkcoucode1==null?"":patkcoucode1 %>" />
<input type="hidden" name="patkTitleDesc1" value="<%=patkTitleDesc1==null?"":patkTitleDesc1 %>" />
<input type="hidden" name="patkTitleDescOther1" value="<%=patkTitleDescOther1==null?"":patkTitleDescOther1 %>" />

<input type="hidden" name="patkfname2" value="<%=patkfname2==null?"":patkfname2 %>" />
<input type="hidden" name="patkgname2" value="<%=patkgname2==null?"":patkgname2 %>" />
<input type="hidden" name="patkcname2" value="<%=patkcname2==null?"":patkcname2 %>" />
<input type="hidden" name="patkrela2" value="<%=patkrela2==null?"":patkrela2 %>" />
<input type="hidden" name="patkhtel2" value="<%=patkhtel2==null?"":patkhtel2 %>" />
<input type="hidden" name="patkotel2" value="<%=patkotel2==null?"":patkotel2 %>" />
<input type="hidden" name="patkmtel2" value="<%=patkmtel2==null?"":patkmtel2 %>" />
<input type="hidden" name="patkemail2" value="<%=patkemail2==null?"":patkemail2 %>" />
<input type="hidden" name="patkadd12" value="<%=patkadd12==null?"":patkadd12 %>" />
<input type="hidden" name="patkadd22" value="<%=patkadd22==null?"":patkadd22 %>" />
<input type="hidden" name="patkadd32" value="<%=patkadd32==null?"":patkadd32 %>" />
<input type="hidden" name="patkadd42" value="<%=patkadd42==null?"":patkadd42 %>" />
<input type="hidden" name="patkcoucode2" value="<%=patkcoucode2==null?"":patkcoucode2 %>" />
<input type="hidden" name="patkTitleDesc2" value="<%=patkTitleDesc2==null?"":patkTitleDesc2 %>" />
<input type="hidden" name="patkTitleDescOther2" value="<%=patkTitleDescOther2==null?"":patkTitleDescOther2 %>" />

<input type="hidden" name="patHowInfo" value="<%=patHowInfo==null?"":patHowInfo %>" />
<input type="hidden" name="patHowInfoOther" value="<%=patHowInfoOther==null?"":patHowInfoOther %>" />
<input type="hidden" name="language" value="<%=language %>"/>

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
<script language="javascript">
<!--
	function backAction() {
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
	}else{				
			$.prompt('Confirm to submit 確定傳送!',{
				buttons: { Ok: true, Cancel: false },
				callback: function(v,m,f){
					if (v){		
						if($('input[name="promotionYN"]').attr('checked')){
							$('input[name="promotionYN"]').val('N');
						}else{
							$('input[name="promotionYN"]').val('Y');	
							$('input[name="promotionYN"]').attr('checked', true);
						}
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
		document.form1.submit();
	}
-->
</script>
</DIV>

</DIV></DIV>
<jsp:include page="admission_footer.jsp" flush="false" />
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
