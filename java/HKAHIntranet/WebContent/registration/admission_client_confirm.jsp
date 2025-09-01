<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String sessionKey = request.getParameter("session");
String language = request.getParameter("language");
Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else {
	locale = Locale.US;
}

session.setAttribute( Globals.LOCALE_KEY, locale );

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
String patmstsOther = null;
String mothcode = null;
String mothcodeOther = null;
String edulevel = null;
String mktSrc = null;
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
String insuranceRemarks = null;

if (language==null ||"".equals(language)){
 language="eng";
}
ArrayList record = null;
if (sessionKey != null && sessionKey.length() > 0) {
	record = SessionLoginDB.get(sessionKey);
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		patemail = row.getValue(0);
	}
}

if (patbdate != null && patbdate.length() > 0) 	{
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
		patemail = row.getValue(18).toString();
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
		mktSrc = row.getValue(41);
		
	}
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
	</style>
</head>
<body>
<DIV id=wrapper class="wrapper" style="background-color:white;">
<DIV >
<DIV  style="background-color:white;">
<jsp:include page="admission_header.jsp" flush="false" />
<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<div class="normal_area">
<div class="career_form" style="padding: 20px 18px;">

<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr valign="center">
		<td class="step2_1" width="33%"><p><%=MessageResources.getMessage(session, "adm.checkInfo1") %></p></td>
		<td class="step2_2" width="33%"><p><%=MessageResources.getMessage(session, "adm.checkInfo2") %></p></td>
		<td class="step2_3" width="33%"><p><%=MessageResources.getMessage(session, "adm.checkInfo3") %></p>
		</td>
	</tr>
</table>
<br>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td style="color: #aa0066; "><%=MessageResources.getMessage(session, "adm.fillInfo") %><%if (!"chi".equals(language)){ %><font color="red">*</font><%} %></td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
	<tr>
		<td style="color: #aa0066; "><strong><%=MessageResources.getMessage(session, "adm.healthCareMessage1") %>
		<%	if ("chi".equals(language)) { %>
			<a href="<%=DocumentDB.getURL("115") %>" target="_blank"><%=MessageResources.getMessage(session,"label.health.care.advisory") %></a>
		<%	} else { %>
					<a href="<%=DocumentDB.getURL("114") %>" target="_blank"><%=MessageResources.getMessage(session,"label.health.care.advisory") %></a>
		<%	} %>
		<%=MessageResources.getMessage(session	, "adm.healthCareMessage2") %></strong></td>
	</tr>
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
</table>
<form name="form1" enctype="multipart/form-data" action="admission_client_submit.jsp" method="post">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="5">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class = "editor_area" valign="top" colspan="3" style="color: #aa0066; ">
						<ul >
							<li>
						<%if ("chi".equals(language)){ %>
							<a href="<%=DocumentDB.getURL("115") %>" target="_blank"><%=MessageResources.getMessage(session, "label.health.care.advisory") %></a>
						<%} else { %>
							<a href="<%=DocumentDB.getURL("114") %>" target="_blank"><%=MessageResources.getMessage(session, "label.health.care.advisory") %></a>
						<%} %>
						</li>
						</ul>
					</td>
				</tr>
				<tr>
					<td height="20" colspan="3">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="5" height="25" style="background-color:#aa0066;">
			<table width="686" border="0" align="center" cellpadding="0"
				cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session, "adm.hosInfo") %></strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" width="50%" valign="top" >
			<table>
			<tr><td id ="expectedAdmissionDateCell">
			<font color="red">*</font><div id="admDate" style="width:150px;"><%=MessageResources.getMessage(session, "adm.expAdmDate") %><%=MessageResources.getMessage(session, "adm.ddmmyyyy") %></div>

			<input type="text" name="expectedAdmissionDate" id="expectedAdmissionDate" class="datepickerfield" value="" maxlength="10" size="10"   onkeyup="validDate(this)" />

				<jsp:include page="../ui/timeCMB.jsp" flush="false">
					<jsp:param name="label" value="expectedAdmissionTime" />
					<jsp:param name="time" value="" />
				</jsp:include>

			</td></tr>
			</table>
		</td>
		<td height="40" width="40%" valign="top" >
			<font color="red">*</font><div id="admDoctor" style="width:150px;"><%=MessageResources.getMessage(session, "adm.admDoctor") %></div>
			<select name="admissiondoctor">
				<option value=""></option>
				<jsp:include page="../ui/docCodeCMB.jsp" flush="false">
					<jsp:param name="selectFrom" value="Pre-addmission" />
				</jsp:include>
			</select>
		</td>
		<td valign="top" width="10%"><font color="red">*</font><div id="roomChoice"><%=MessageResources.getMessage(session, "adm.roomChoice") %></div>
			<select name="roomType">
				<option value=""></option>
				<option value="VIP"><%=MessageResources.getMessage(session, "adm.acm1") %></option>
				<option value="Private"><%=MessageResources.getMessage(session, "adm.acm2") %></option>
				<option value="Semi-Private"><%=MessageResources.getMessage(session, "adm.acm3") %></option>
				<option value="Standard"><%=MessageResources.getMessage(session, "adm.acm4") %></option>
			</select>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="5" height="25" style="background-color:#aa0066;">
			<table width="650" border="0" align="center" cellpadding="0"
				cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session, "adm.personalInfo") %></strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" colspan="2" >
			<table width="100%">
				<tr>
					<td>
						<input type="radio" name="patidType" value="hkid"<%=patpassport==null||patpassport.length()==0?" checked":"" %> onclick="validHKID();"><font color="red">*</font><div id="hkid" style="width:200px;"><%=MessageResources.getMessage(session, "adm.hkid") %></div>
						<input type="text" name="patidno1" value="<%=patidno1==null?"":patidno1 %>" maxlength="8" size="8" onkeyup="validHKID();" onblur="validHKID()">(<input type="text" name="patidno2" value="<%=patidno2==null?"":patidno2 %>" maxlength="2" size="2" onkeyup="validHKID();" onkeydown="validDOB(event);">)
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" name="patidType" value="passport"<%=patpassport!=null&&patpassport.length()>0?" checked":"" %> onclick="validPassport();"><div id="passport" style="width:200px;"><%=MessageResources.getMessage(session, "adm.passport") %></div>
						<input type="text" name="patpassport" value="<%=patpassport==null?"":patpassport %>" maxlength="20" size="25" onkeyup="validPassport();">
					</td>
				</tr>
				<tr>
					<td height="20">&nbsp;</td>
				</tr>
				<tr>
					<td>
						<font color="red">**</font><%=MessageResources.getMessage(session, "adm.attachID") %>
					</td>
				</tr>
				<tr>
					<td>
						<table>
							<tr>
								<td>
									<input type="file" name="file1" size="20" class="multi" maxlength="5" style="display:inline" />
								</td>
								<td>
									<%=MessageResources.getMessage(session, "adm.faxNo") %>: 36518801
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td height="40" valign="top" >
			<font color="red">*</font><div id="dateOfBirth" style="width:200px;"><%=MessageResources.getMessage(session, "adm.dateOfBirth") %></div><%=MessageResources.getMessage(session, "adm.ddmmyyyy") %>
			<input type="text" name="patbdate" id="patbdate" class="datepickerfield" value="<%=patbdate==null?"":patbdate %>" maxlength="10" size="10" onkeyup="validDate(this)">
			<br/><p/><br/><p/><br/>
			<font color="red">*</font><div id="home"><%=MessageResources.getMessage(session, "adm.contactTel") %></div>
			<table width=100%">
				<tr>
					<td height="40" valign="top" ><%=MessageResources.getMessage(session, "adm.home") %><br/>
					<input name="pathtel" type="text" value="<%=pathtel==null?"":pathtel %>" maxlength="20" size="25" />
					</td>
				</tr>
				<tr>
					<td height="40" valign="top" ><%=MessageResources.getMessage(session, "adm.mobile") %><br/>
					<input name="patmtel" type="text" value="<%=patmtel==null?"":patmtel %>" maxlength="20" size="25" />
				</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="64%" height="40" valign="top" >
			<table width="64%">
			<tr>
			<td>
			<font color="red">*</font><div id="patfname"><%=MessageResources.getMessage(session, "adm.famName") %></div>
				<input type="text" name="patfname" class="uppercase" value="<%=patfname==null?"":patfname %>" maxlength="40" size="40"/>
			</td>
			<td style="padding-left:5;" width="32%" height="40" valign="top" >
				<font color="red">*</font><div id="patgname"><%=MessageResources.getMessage(session, "adm.givenName") %></div>
				<input type="text" name="patgname" class="uppercase" value="<%=patgname==null?"":patgname %>" maxlength="40" size="40"/>
			</td>
			</tr>
			<tr>
			<td colspan="2" style="vertical-align:top"><font color="red">*<%=MessageResources.getMessage(session, "adm.nameWarning") %></font></td>
			</tr>
			</table>
		</td>
		<td width="32%" height="40" valign="top" >
			<font color="red">*</font><div id="title"><%=MessageResources.getMessage(session, "adm.title") %></div>
			<select name="titleDesc">
				<option value=""></option>
				<option value="MR." <%="MR.".equals(titleDesc)?" selected":"" %>><%=MessageResources.getMessage(session, "label.mr") %></option>
				<option value="MRS" <%="MRS.".equals(titleDesc)?" selected":"" %>><%=MessageResources.getMessage(session, "label.mrs") %></option>
				<option value="MISS" <%="MISS".equals(titleDesc)?" selected":"" %>><%=MessageResources.getMessage(session, "label.miss") %></option>
				<option value="MS" <%="MS".equals(titleDesc)?" selected":"" %>><%=MessageResources.getMessage(session, "label.ms") %></option>
				<option value=""><%=MessageResources.getMessage(session, "label.others") %></option>
			</select><br />
			<%=MessageResources.getMessage(session, "label.others") %> : <input type="text" name="titleDescOther" class="uppercase" value="<%=titleDescOther==null?"":titleDescOther %>" maxlength="10" size="20">
		</td>
		<td height="40" valign="top" ><%=MessageResources.getMessage(session, "adm.office") %>
			<br/>
			<input name="patotel" type="text" value="<%=patotel==null?"":patotel %>" maxlength="20" size="25" />
			</br>
			<%=MessageResources.getMessage(session, "adm.faxNo") %></br>
			<input name="patftel" type="text" value="<%=patftel==null?"":patftel %>" maxlength="20" size="25" />
		</td>
	</tr>
	<tr>
		<td >
			<font color="red">*</font><div id="patsex"><%=MessageResources.getMessage(session, "prompt.sex") %></div>
			<select name="patsex">
				<option value=""></option>
				<option value="M" <%="M".equals(patsex)?" selected":"" %>><%=MessageResources.getMessage(session, "label.male") %></option>
				<option value="F" <%="F".equals(patsex)?" selected":"" %>><%=MessageResources.getMessage(session, "label.female") %></option>
			</select>
		</td>
		<td ><font color="red">*</font>
			<div id="patemail">
			<%=MessageResources.getMessage(session, "adm.emailAdd") %></div>
			<input name="patemail" type="text" value="<%=patemail==null?"":patemail %>" maxlength="50" size="50" />
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
</table>
<table id="optionalPersonalInformation"cellpadding="1" border="0">
	<tr>
		<td height="40" valign="top" >
			<%=MessageResources.getMessage(session, "prompt.chineseName") %><br />
		 	<input type="text" name="patcname" id="patcname" value="<%=patcname==null?"":patcname %>"  maxlength="20" size="25">
		</td>
		<%if ("chi".equals(language)){ %>
		<td width="80">&nbsp;</td>
		<%} else { %>
		<td width="2">&nbsp;</td>
		<%} %>
		<td height="40" valign="top" ><font color="red">*</font>
			<div id='patmsts'>
				<%=MessageResources.getMessage(session, "adm.maritalStatus") %>
			</div>
			<select name="patmsts">
				<option value=""></option>
				<option value="D" <%="D".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mStatus3") %></option>				
				<option value="E" <%="E".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mStatus5") %></option>			
				<option value="M" <%="M".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mStatus2") %></option>
				<option value="O" <%="O".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "label.others") %></option>
				<option value="X" <%="X".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mStatus4") %></option>
				<option value="S" <%="S".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mStatus1") %></option>
				<option value="W" <%="W".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mStatus6") %></option>
				<option value="Z" <%="Z".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mStatus7") %></option>
				
			</select><br/>
			<%=MessageResources.getMessage(session, "label.others") %>: <input type="text" class="uppercase" name="patmstsOther" value="<%=patmstsOther==null?"":patmstsOther %>" />
		</td>
		<%if ("chi".equals(language)){ %>
		<td width="80">&nbsp;</td>
		<%} else { %>
		<td width="2">&nbsp;</td>
		<%} %>
		<td height="40" valign="top" ><font color="red">*</font>
			<div id='mothcode'>
				<%=MessageResources.getMessage(session, "adm.wLang") %>
			</div>
			<select name="mothcode">
				<option value=""></option>
				<option value="ENG" <%="ENG".equals(mothcode)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.lang1") %></option>
				<option value="TRC" <%="TRC".equals(mothcode)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.lang2") %></option>
				<option value="SMC" <%="SMC".equals(mothcode)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.lang3") %></option>
				<option value="JAP" <%="JAP".equals(mothcode)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.lang4") %></option>
			</select><br />
		</td>
	</tr>
	<tr>
		<td height="40" valign="top" ><font color="red">*</font>
			<div id='racedesc'>
				<%=MessageResources.getMessage(session, "adm.ethicGroup") %>
			</div>
			<select name="racedesc">
				<option value=""></option>
<jsp:include page="../ui/raceDescCMB.jsp" flush="false">
	<jsp:param name="racedesc" value="<%=racedesc %>" />
</jsp:include>
			</select><br />
			<%=MessageResources.getMessage(session, "label.others") %> : <input type="text" class="uppercase" name="racedescOther" value="<%=racedescOther==null?"":racedescOther %>" maxlength="10" size="20" /> <br />
			(<%=MessageResources.getMessage(session, "adm.hospitalStat") %>)
		</td>
		<%if ("chi".equals(language)){ %>
		<td width="80">&nbsp;</td>
		<%} else { %>
		<td width="2">&nbsp;</td>
		<%} %>
		<td height="40" valign="top" ><font color="red">*</font>
			<div id="religion"><%=MessageResources.getMessage(session, "adm.religion") %></div>
			<select name="religion">
				<option value=""></option>
				<option value="BU" <%="BU".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion1") %></option>
				<option value="CA" <%="CA".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion2") %></option>
				<option value="CH" <%="CH".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion3") %></option>						
				<option value="HI" <%="HI".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion4") %></option>				
				<option value="MU" <%="MU".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion7") %></option>	
				<option value="NO" <%="NO".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.None") %></option>
				<option value="OT" <%="OT".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "label.others") %></option>
				<option value="PR" <%="PR".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion8") %></option>
				<option value="SD" <%="SD".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion6") %></option>				
				<option value="SH" <%="SH".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion5") %></option>
				
			</select><br />
			<%=MessageResources.getMessage(session, "label.others") %>: <input type="text" class="uppercase" name="religionOther" value="<%=religionOther==null?"":religionOther %>" />
		</td>
		<%if ("chi".equals(language)){ %>
		<td width="80">&nbsp;</td>
		<%} else { %>
		<td width="2">&nbsp;</td>
		<%} %>
		<td height="40" valign="top" ><font color="red">*</font>
			<div id="edulevel"><%=MessageResources.getMessage(session, "prompt.educationLevel") %></div>
			<select name="edulevel">
				<option value=""></option>
				<option value="Others"><%=MessageResources.getMessage(session, "label.others") %></option>
				<option value="Primary"<%="Primary".equals(edulevel)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.primary") %></option>
				<option value="Secondary"<%="Secondary".equals(edulevel)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.secondary") %></option>
				<option value="Tertiary or above"<%="Tertiary or above".equals(edulevel)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.terOfAbove") %></option>
			</select>
			</br>
			<font color="red">*</font>
			<div id="occupation">
				<%=MessageResources.getMessage(session, "prompt.occupation") %>
			</div>
			<input name="occupation" type="text" class="uppercase" value="<%=occupation==null?"":occupation %>" maxlength="20" size="25" />

		</td>
	</tr>
	<tr>
		<td height="40" valign="top" colspan="2" >
		<font color="red">*</font>
			<div id="patadd1">
			<%=MessageResources.getMessage(session, "adm.Address") %><br />
		</div>
				<input type="text" name="patadd1" class="uppercase" value="<%=patadd1==null?"":patadd1 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.rmFt") %>/<%=MessageResources.getMessage(session, "adm.floor") %>/<%=MessageResources.getMessage(session, "adm.blkBldg") %><br />
				<input type="text" name="patadd2" class="uppercase" value="<%=patadd2==null?"":patadd2 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.road") %>/<%=MessageResources.getMessage(session, "adm.street") %><br />
				<input type="text" name="patadd3" class="uppercase" value="<%=patadd3==null?"":patadd3 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.district") %><br />
						<select name="coucode">
							<jsp:include page="../ui/countryCodeCMB.jsp" flush="false">
							<jsp:param name="coucode" value="<%=coucode %>" />
							</jsp:include>
						</select><%=MessageResources.getMessage(session, "prompt.country") %>
		</td>
	</tr>
		<tr>
		<td height="40" valign="top" colspan="2" >
		<font color="red">*</font>
			<div id="mktSrc">
			<%=MessageResources.getMessage(session, "adm.mktSrc") %><br />
		</div>
			<select name="mktSrc">
				<option value=""></option>
				<option value="D"<%="D".equals(mktSrc)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mktSrc1") %></option>
				<option value="E"<%="E".equals(mktSrc)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mktSrc2") %></option>
				<option value="M"<%="M".equals(mktSrc)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mktSrc3") %></option>
				<option value="F"<%="F".equals(mktSrc)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mktSrc4") %></option>
				<option value="H"<%="H".equals(mktSrc)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mktSrc5") %></option>
				<option value="I"<%="I".equals(mktSrc)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mktSrc6") %></option>
				<option value="N"<%="N".equals(mktSrc)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mktSrc7") %></option>
				<option value="L"<%="L".equals(mktSrc)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mktSrc8") %></option>
				<option value="O"<%="O".equals(mktSrc)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mktSrc9") %></option>
				<option value="A"<%="A".equals(mktSrc)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mktSrc10") %></option>
				<option value="C"<%="C".equals(mktSrc)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mktSrc11") %></option>				
			</select>
		</td>
	</tr>
</table>

<table width="800" border="0" cellpadding="0" cellspacing="0" id="optionalInformation1">
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr >
		<td colspan="6" height="25" style="background-color:#aa0066;">
		<table  width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session, "adm.emergencyContact") %> (1)</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" >
			<font color="red">*</font>
			<div id="patkfname1">
			<%=MessageResources.getMessage(session, "adm.famName") %>
			</div>
				<input type="text" name="patkfname1" class="uppercase" value="<%=patkfname1==null?"":patkfname1 %>" maxlength="60" size="25"/>

		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" >
			<font color="red">*</font>
			<div id="patkgname1">
			<%=MessageResources.getMessage(session, "adm.givenName") %>
			</div>
			<input type="text" name="patkgname1" class="uppercase" value="<%=patkgname1==null?"":patkgname1 %>" maxlength="20" size="25">
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" ><%=MessageResources.getMessage(session, "prompt.chineseName") %>
			<input type="text" name="patkcname1" value="<%=patkcname1==null?"":patkcname1 %>" maxlength="20" size="25">
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" >
			<font color="red">*</font>
			<div id="patksex1"><%=MessageResources.getMessage(session, "prompt.sex") %></div>
			<select name="patksex1">
				<option value=""></option>
				<option value="M" <%="M".equals(patksex1)?" selected":"" %>><%=MessageResources.getMessage(session, "label.male") %></option>
				<option value="F" <%="F".equals(patksex1)?" selected":"" %>><%=MessageResources.getMessage(session, "label.female") %></option>
			</select>
			<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td height="40" valign="top">
				<font color="red">*</font>
				<div id="patkrela1">
				<%=MessageResources.getMessage(session, "prompt.relationship") %>
				</div>
				<input type="text" name="patkrela1" class="uppercase" value="<%=patkrela1==null?"":patkrela1 %>" maxlength="20" size="25">
				<br /><br /><br/>
				<%=MessageResources.getMessage(session, "adm.emailAdd") %>
				<input type="text" name="patkemail1" value="<%=patkemail1==null?"":patkemail1 %>" maxlength="50" size="25" /></td>
			</tr>
		</table>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top"  colspan=3">
			<font color="red">*</font>
			<div id="patkhtel1">
			<%=MessageResources.getMessage(session, "adm.contactTel") %>
			</div>
		<br />
			<table width=100%">
				<tr>
					<td height="40" valign="top" ><%=MessageResources.getMessage(session, "adm.khome") %>
						<input type="text" name="patkhtel1" value="<%=patkhtel1==null?"":patkhtel1 %>" maxlength="20" size="25" />
					</td>
					<td width="2">&nbsp;</td>
					<td height="40" valign="top" ><%=MessageResources.getMessage(session, "adm.koffice") %>
						<input type="text" name="patkotel1" value="<%=patkotel1==null?"":patkotel1 %>" maxlength="20" size="25" />
					</td>
				</tr>
				<tr>
					<td height="40" valign="top" ><%=MessageResources.getMessage(session, "adm.kmobile") %>
						<input type="text" name="patkmtel1" value="<%=patkmtel1==null?"":patkmtel1 %>" maxlength="20" size="25" />
					</td>
					<td width="2">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="80%" height="20" valign="top"  colspan="3">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td width="2">&nbsp;</td>
				<td height="40" valign="top" colspan="3" "><%=MessageResources.getMessage(session, "adm.Address") %> <%=MessageResources.getMessage(session, "adm.AddressIfDiff") %><br />
					<input type="text" name="patkadd11" class="uppercase" value="<%=patadd1==null?"":patadd1 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.rmFt") %>/<%=MessageResources.getMessage(session, "adm.floor") %>/<%=MessageResources.getMessage(session, "adm.blkBldg") %><br />
					<input type="text" name="patkadd21" class="uppercase" value="<%=patadd2==null?"":patadd2 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.road") %>/<%=MessageResources.getMessage(session, "adm.street") %><br />
					<input type="text" name="patkadd31" class="uppercase" value="<%=patadd3==null?"":patadd3 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.district") %><br />
				</td>
			</tr>
		</table>
		</td>
		<td width="20%" >
				<input type="radio" name="patkadd41" value="HONG KONG"<%="HONG KONG".equals(patkadd41)?" checked":"" %> /><%=MessageResources.getMessage(session, "label.hongKongIsland") %><br />
				<input type="radio" name="patkadd41" value="KOWLOON"<%="KOWLOON".equals(patkadd41)?" checked":"" %> /><%=MessageResources.getMessage(session,"label.kowloon") %><br />
				<input type="radio" name="patkadd41" value="NEW TERRITORIES"<%="NEW TERRITORIES".equals(patkadd41)?" checked":"" %> /><%=MessageResources.getMessage(session,"label.newTerritories") %>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0" id="optionalInformation2">
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" style="background-color:#aa0066;">
		<table width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session, "adm.emergencyContact") %> (2) (<%=MessageResources.getMessage(session, "adm.optional") %>) </strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" ><div><%=MessageResources.getMessage(session, "adm.famName") %></div>
			<input type="text" class="uppercase" name="patkfname2" value="" maxlength="60" size="25">
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" ><%=MessageResources.getMessage(session, "adm.givenName") %>
			<input type="text" class="uppercase" name="patkgname2" value="" maxlength="30" size="25">
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" ><%=MessageResources.getMessage(session, "prompt.chineseName") %>
			<input type="text" name="patkcname2" value="" maxlength="20" size="25">
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" ><div><%=MessageResources.getMessage(session, "prompt.sex") %></div>
			<select name="patksex2">
				<option value=""></option>
				<option value="M"><%=MessageResources.getMessage(session, "label.male") %></option>
				<option value="F"><%=MessageResources.getMessage(session, "label.female") %></option>
			</select>
			<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td height="40" valign="top"><%=MessageResources.getMessage(session, "prompt.relationship") %>
					<input type="text" class="uppercase" name="patkrela2" value="" maxlength="20" size="25"> <br />
				<br />
				<br />
				<%=MessageResources.getMessage(session, "adm.emailAdd") %>
				<input type="text" name="patkemail2" value="" maxlength="50" size="25" /></td>
			</tr>
		</table>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top"  colspan=3">
			<%=MessageResources.getMessage(session, "adm.contactTel") %><br />
			<table width=100%">
				<tr>
					<td height="40" valign="top" ><%=MessageResources.getMessage(session, "adm.khome") %>
						<input type="text" name="patkhtel2" value="" maxlength="20" size="25" />
					</td>
					<td width="2" valign="top">&nbsp;</td>
					<td height="40" valign="top" ><%=MessageResources.getMessage(session, "adm.koffice") %>
						<input type="text" name="patkotel2" value="" maxlength="20" size="25" />
					</td>
				</tr>
				<tr>
					<td height="40" valign="top" ><%=MessageResources.getMessage(session, "adm.kmobile") %>
						<input type="text" name="patkmtel2" value="" maxlength="20" size="25" />
					</td>
					<td width="2" valign="top">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
		<tr>
		<td width="80%" height="20" valign="top"  colspan="3">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td width="2">&nbsp;</td>
				<td height="40" valign="top" colspan="2" ><%=MessageResources.getMessage(session, "adm.Address") %> <%=MessageResources.getMessage(session, "adm.AddressIfDiff") %><br />
				<input type="text" class="uppercase" name="patkadd12" value="" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.rmFt") %>/<%=MessageResources.getMessage(session, "adm.floor") %>/<%=MessageResources.getMessage(session, "adm.blkBldg") %><br />
				<input type="text" class="uppercase" name="patkadd22" value="" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.road") %>/<%=MessageResources.getMessage(session, "adm.street") %><br />
				<input type="text" class="uppercase" name="patkadd32" value="" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.district") %><br />
				</td>
			</tr>
		</table>
		</td>
		<td width="20%"  >
				<input type="radio" name="patkadd42" value="HONG KONG" /><%=MessageResources.getMessage(session, "label.hongKongIsland") %><br />
				<input type="radio" name="patkadd42" value="KOWLOON" /><%=MessageResources.getMessage(session,"label.kowloon") %><br />
				<input type="radio" name="patkadd42" value="NEW TERRITORIES" /><%=MessageResources.getMessage(session,"label.newTerritories") %>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">

	<!-- methodofPayment moved to admission_client_payment.jsp ( begin ) -->
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" style="background-color:#aa0066;">
		<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session,"adm.methodofPayment") %></strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>

	<tr>
		<td height="20" colspan="5">
			<%=MessageResources.getMessage(session,"adm.paymentMsg") %>
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
				<%=MessageResources.getMessage(session,"adm.agreeCondition1") %>
				"
				<%if ("chi".equals(language)){ %>
					<a href="<%=DocumentDB.getURL("115") %>" target="_blank"><%=MessageResources.getMessage(session, "label.health.care.advisory") %></a>
				<%} else { %>
					<a href="<%=DocumentDB.getURL("114") %>" target="_blank"><%=MessageResources.getMessage(session, "label.health.care.advisory") %></a>
				<%} %>
				",
				"<a href="<%=DocumentDB.getURL("116") %>" target="_blank"><%=MessageResources.getMessage(session,"adm.agreeCondition2") %></a>"
				 <%=MessageResources.getMessage(session,"adm.agreeCondition3") %><br />
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
			<font color="red">*</font><div id="payType" style="width:200px;"><%=MessageResources.getMessage(session,"adm.methodofPayment") %></div>
				<td height="30" >
				<input name="paymentType"
					type="radio" value="CREDIT CARD" /><%=MessageResources.getMessage(session,"adm.payMethod1") %>
					<select name="creditCardType" onchange="return changePaymentType();">
					<option value=""></option>
					<option value="Visa"><%=MessageResources.getMessage(session,"adm.payMethod1.opt1") %></option>
					<option value="Master"><%=MessageResources.getMessage(session,"adm.payMethod1.opt2") %></option>
					<option value="JCB"><%=MessageResources.getMessage(session,"adm.payMethod1.opt3") %></option>
					<option value="Diners"><%=MessageResources.getMessage(session,"adm.payMethod1.opt4") %></option>
					<option value="AE"><%=MessageResources.getMessage(session,"adm.payMethod1.opt5") %></option>
					</select>
				</td>
				<td height="30" ><input name="paymentType"
					type="radio" value="CUP CARD" onclick="changePaymentType()"/><%=MessageResources.getMessage(session,"adm.payMethod2") %></td>
				<td height="30" ><input name="paymentType"
					type="radio" value="CASH" onclick="changePaymentType();"/><%=MessageResources.getMessage(session,"adm.payMethod3") %></td>
				<td height="30" ><input name="paymentType"
					type="radio" value="EPS" onclick="changePaymentType();"/><%=MessageResources.getMessage(session,"adm.payMethod4") %></td>

			</tr>
			<tr>
				<td height="5" colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td height="30" ><input name="paymentType" type="radio" value="CREDIT CARD AUTH" /><%=MessageResources.getMessage(session,"adm.payMethod1.authForm") %>
					(<a href="/upload/Admission at ward/Credit Card Mail Order Authorzation Form.pdf" target="_blank"><%=MessageResources.getMessage(session,"label.click.here") %></a>) (<%=MessageResources.getMessage(session,"adm.payMethod1.depositOnly") %>)<br /><br />
						<font color="red">**</font><%=MessageResources.getMessage(session,"adm.payMethodAttach") %><br />
					<table>
					<tr>
						<td>
							<input type="file" name="file2" size="10" class="multi" maxlength="5"/>
						</td>
						<td><%=MessageResources.getMessage(session, "adm.faxNo") %>: 36518801
						</td>
					</tr>
					</table>
				</td>
				<td height="30"  valign="top">
				<table id="insurance">
				  <tr>
					<td><input name="paymentType" type="radio" value="INSURANCE" onclick="changePaymentType();"/><%=MessageResources.getMessage(session,"adm.payMethod5") %></td>
				  </tr>
				  <tr>
					<td ><%=MessageResources.getMessage(session,"adm.insurance.remark") %>: <input type="text" name="insuranceRemarks" maxlength="100" size="15" value="<%=insuranceRemarks==null?"":insuranceRemarks %>"/></td>
				  </tr>
				</table>
				</td>
				<td height="30"  valign="top"><input name="paymentType" type="radio" value="CORPORATE" onclick="changePaymentType()"/><%=MessageResources.getMessage(session,"adm.payMethod6") %></td>
				<td height="30"  valign="top">
					<input name="paymentType" type="radio" value="OTHER" onclick="changePaymentType();"/><%=MessageResources.getMessage(session, "label.others") %><br />
					<input type="text" name="paymentTypeOther" maxlength="100" size="20" />
				</td>
			</tr>
		</table>
		</td>
	</tr>

	<!-- methodofPayment moved to admission_client_payment.jsp ( end ) -->

	
	
	<tr>
		<td colspan="6">
		<table width="700" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
		<br />
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr >
		<td  id="browserInfo" colspan="6" height="25" style="background-color:#aa0066;">
		<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session, "adm.otherInfo") %></strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr >
		<td valign="top" width="95%" style="font-size:large;color:red;">
			<%=MessageResources.getMessage(session, "adm.agreeFollowingInfo") %>
			<img src="../images/tick_green_small.gif" />
			<input type="checkbox" name="checkAll" onclick="checkAllImpt();"/>
			<%if (!"chi".equals(language)) { %>
				<%=MessageResources.getMessage(session,"adm.agreeFollowingInfo1")%>
			<%} %>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">
		<ul id="browser" class="filetree">
			<jsp:include page="../registration/important_information.jsp" flush="false">
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
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<div id="infoForPromotionMsg">
			<input type="checkbox" name="infoForPromotion" value="N" />
			<%=MessageResources.getMessage(session,"adm.infoForPromotion")%>
			</div>
		</td>
	</tr>
</table>
<br />
<br />
<br />
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><font color="red">***</font><%=MessageResources.getMessage(session, "adm.versionMsg") %></td>
	</tr>
</table>
<div class="pane">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td align="center">
		<button class="btn-submit" onclick="submitAction();return false;"><%=MessageResources.getMessage(session, "adm.preview") %></button>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="create" />
<input type="hidden" name="step" value="1" />
<input type="hidden" name="admissionID" />
<input type="hidden" name="patno" value="<%=patno==null?"":patno %>" />
<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
<input type="hidden" name="tempOptionalValue" value="1"/>
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
	$("a#show_info_tree").fancybox({
		width: infoW,
		height: infoH,
		centerOnScroll: true
	});

	$("#wrapper").mousedown(function(){
		if (mouseOverAdmissionDateDiv == false){
			 checkExpectedAdmissionDateInserted(document.form1.expectedAdmissionDate);
		}
	});

	$(".uppercase").keyup(
			function(){
				this.value = this.value.toUpperCase();
			}
	 );

	$('select=[name=expectedAdmissionTime_hh] :nth-child(1)').attr('selected', 'selected');
	$('select=[name=expectedAdmissionTime_mi] :nth-child(1)').attr('selected', 'selected');
	dateImgMouseOver();

	if (document.form1.language.value =='chi'){
		alert('煩請閣下在辦理網上登記手續前,輸入預定入院日期。');
	} else {
		alert('Please enter your Expected Admission Date and Time before you proceed to the pre-registration.');
	}
	var focusField = document.form1.expectedAdmissionDate;
	$(document.form1.expectedAdmissionDate).parent().parent().find('div#admDate').addClass("hightLight");
	$(focusField).focus();
	});

	var mouseOverAdmissionDateDiv = false;
	var mouseOverAdmissionDateHeader = false;
	function dateImgMouseOver(){
		$('#expectedAdmissionDateCell').find('.ui-datepicker-trigger').mouseover(function() {
			   mouseOverAdmissionDateDiv = true;
			 });

		   $('#expectedAdmissionDateCell').find('.ui-datepicker-trigger').mouseout(function() {
			   mouseOverAdmissionDateDiv = false;
			 });

		   $('#browser').mouseover(function() {
			   mouseOverAdmissionDateDiv = true;
			 });

		   $('#browser').mouseout(function() {
			   mouseOverAdmissionDateDiv = false;
			 });

		   $('#expectedAdmissionDateCell').mouseover(function() {
			   mouseOverAdmissionDateDiv = true;
			 });

		   $('#expectedAdmissionDateCell').mouseout(function() {
			   mouseOverAdmissionDateDiv = false;
			 });


		   $('.ui-datepicker-trigger').click(function() {
			   	$('div=[class=ui-datepicker-header]').mouseover(function() {
						   mouseOverAdmissionDateHeader = true;
						 });

				   $('div=[class=ui-datepicker-header]').mouseout(function() {
					   mouseOverAdmissionDateHeader = false;
					 });
			 });

		   var datediv = document.getElementById("ui-datepicker-div");
		   datediv.onmouseover = function()   {
		      mouseOverAdmissionDateDiv = true;
		   };
		   datediv.onmouseout = function()   {
		      mouseOverAdmissionDateDiv = false;
		   }

		   datediv.onclick= function(){
			  if (mouseOverAdmissionDateHeader == false){
				  var focusField = document.form1.expectedAdmissionDate;
				  setTimeout(function(){$(focusField).focus();},100)
				}
	  		 }
	}

	function checkExpectedAdmissionDateInserted(dom){
		validDate(dom);

		var msg = '';
		var focusField;
		var focusBrowser = false;
		if (mouseOverAdmissionDateDiv == false){
			if (document.form1.expectedAdmissionDate.value == '') {
				if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
				$(document.form1.expectedAdmissionDate).parent().parent().find('div#admDate').addClass("hightLight");

				if (document.form1.language.value =='chi'){
					msg = msg + '煩請閣下在辦理網上登記手續前,輸入預定入院日期。\n';
				} else {
					msg = msg + 'Please enter your Expected Admission Date and Time before you proceed to the pre-registration.\n';
				}
			} else {
				var checkAdmissionDateFail = false;
				var agreeement2CheckFail = false;
				var expectedAdmissionDateInvalid = false;

				$(".hightLight").removeClass();


				if (!validDate(document.form1.expectedAdmissionDate)) {
					if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
					$(document.form1.expectedAdmissionDate).parent().parent().find('div#admDate').addClass("hightLight");
					expectedAdmissionDateInvalid = true;
				} else if (!checkAdmissionDate()) {
					if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
					$(document.form1.expectedAdmissionDate).parent().parent().find('div#admDate').addClass("hightLight");
					checkAdmissionDateFail = true;
				}


				if (msg.length > 0 	|| checkAdmissionDateFail || expectedAdmissionDateInvalid) {

					if (expectedAdmissionDateInvalid) {
						if (document.form1.language.value =='chi'){
							msg = msg + '輸入不正確預定入院日期\n';
						} else {
							msg = msg + 'Admission Date is not a valid date.\n';
						}

					}

					if (checkAdmissionDateFail) {
						if (document.form1.language.value =='chi'){
							msg = msg + '由於預定入院日期少於一個工作天，\n請在預定入院日期當天到入院登記處辦理入院手續。\n閣下可先閱讀「重要資料」以作參考.\n';
						} else {
							msg = msg + 'The expected admission date is less than one day prior to your admission.\nKindly approach our admission office on the expected admission date for registration.\nYou may refer to the "Important Information" provided for your reference.\n';
						}

						/*
						focusBrowser = true;
						 $(window).scrollTop($("#browserInfo").offset().top);
						$('#browserInfo').focus();
						*/
					}

					if (document.form1.language.value =='chi'){
						msg=msg +'\n如有任何查詢，請致電熱線電話 3651 8740。\n';
					} else {
						msg=msg +'\nIf you have any query, please kindly contact our Hotline at 3651 8740.\n';
					}

				}
			}
			if (msg != '')
			alert(msg);

			if (focusBrowser == false){
				setTimeout(function(){
					$(focusField).focus();
					if (checkAdmissionDateFail) {
						$("#show_info_tree").click();
					}
				},100)
			} else if (checkAdmissionDateFail) {
				$("#show_info_tree").click();
			}
		}
	}




	function checkAllImpt(){
		$('input[name="imptInfo"]').each(function() {
			if ($('input[name="checkAll"]').is(':checked')){
				$(this).attr('checked', true);
			} else {
				$(this).attr('checked', false);
			}
		});
	}


	function clickOptionalInformation(){
		var optionalInformation1 = document.getElementById("optionalInformation1");
		var optionalInformation2 = document.getElementById("optionalInformation2");

		if (document.form1.tempOptionalValue.value == '1'){
			optionalInformation1.style.display = "block";
			optionalInformation2.style.display = "block";
			document.form1.tempOptionalValue.value = '2';
		} else if (document.form1.tempOptionalValue.value == '2'){
			optionalInformation1.style.display = "none";
			optionalInformation2.style.display = "none";
			document.form1.tempOptionalValue.value = '1';
		}
	}

	function clickOptionalField(fieldID){
		var optionalField = document.getElementById(fieldID);

		if (optionalField.style.display == 'none'){
			optionalField.style.display = 'block';
		} else if (optionalField.style.display == 'block'){
			optionalField.style.display = 'none';
		}

	}

	function checkRoomRate(){

		var Roomrate = document.getElementById("Roomrate");

		if (document.form1.agreement2.checked == true) {
			Roomrate.checked = true;
		} else {
			Roomrate.checked = false;
		}

		var Healthcarebox = document.getElementById("Healthcarebox");

		if (document.form1.agreement2.checked == true) {
			Healthcarebox.checked = true;
		} else {
			Healthcarebox.checked = false;
		}
	}

	function changeLang(lang){
		alert(document.form1.action);
		return false;
	}

	function submitAction() {
		var msg = '';
		var focusField;
		var count = 1;
		var checkAdmissionDateFail = false;
		var agreeement2CheckFail = false;
		var expectedAdmissionDateInvalid = false;

		$(".hightLight").removeClass();
		if (document.form1.roomType.value == '') {
			if (msg.length == 0) focusField = document.form1.roomType;
			$(document.form1.roomType).parent().find('div#roomChoice').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '房間類別\n';
			} else {
				msg = msg + 'Room Choice\n';
			}
		}

		if (document.form1.expectedAdmissionDate.value == '') {
			if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
			$(document.form1.expectedAdmissionDate).parent().parent().find('div#admDate').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '預定入院日期\n';
			} else {
				msg = msg + 'Admission Date\n';
			}
		} else if (!validDate(document.form1.expectedAdmissionDate)) {
			if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
			$(document.form1.expectedAdmissionDate).parent().parent().find('div#admDate').addClass("hightLight");
			expectedAdmissionDateInvalid = true;
		} else if (!checkAdmissionDate()) {
			if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
			$(document.form1.expectedAdmissionDate).parent().parent().find('div#admDate').addClass("hightLight");
			checkAdmissionDateFail = true;
		}
		if (document.form1.admissiondoctor.value == '') {
			if (msg.length == 0) focusField = document.form1.admissiondoctor;
			$(document.form1.admissiondoctor).parent().find('div#admDoctor').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '醫生名稱\n';
			} else {
				msg = msg + 'Admission Doctor\n';
			}
		}
		if (document.form1.patidType[0].checked) {
			if (document.form1.patidno1.value == '') {
				if (msg.length == 0) focusField = document.form1.patidno1;
				$(document.form1.patidno1).parent().find('div#hkid').addClass("hightLight");
				msg = msg + (count++) + '. ';
				if (document.form1.language.value =='chi'){
					msg = msg + '香港身份證號碼\n';
				} else {
					msg = msg + 'Hong Kong I.D. Card\n';
				}
			} else if (document.form1.patidno2.value == '') {
				if (msg.length == 0) focusField = document.form1.patidno2;
				$(document.form1.patidno1).parent().find('div#hkid').addClass("hightLight");
				msg = msg + (count++) + '. ';
				if (document.form1.language.value =='chi'){
					msg = msg + '香港身份證號碼\n';
				} else {
					msg = msg + 'Hong Kong I.D. Card\n';
				}
			} else if (document.form1.patidno1.value.length < 7) {
				if (msg.length == 0) focusField = document.form1.patidno1;
				$(document.form1.patidno1).parent().find('div#hkid').addClass("hightLight");
				if (document.form1.language.value =='chi'){
					msg = msg + '輸入不正確香港身份證號碼.\n';
				} else {
					msg = msg + 'Invalid Hong Kong I.D. Card.\n';
				}
			}
		}
		if (document.form1.patidType[1].checked && document.form1.patpassport.value == '') {
			if (msg.length == 0) focusField = document.form1.patpassport;
			$(document.form1.patpassport).parent().find('div#passport').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '護照號碼\n';
			} else {
				msg = msg + 'Passport No\n';
			}
		}
		if (document.form1.patbdate.value == '') {
			if (msg.length == 0) focusField = document.form1.patbdate;
			$(document.form1.patbdate).parent().find('div#dateOfBirth').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '出生日期\n';
			} else {
				msg = msg + 'Date of Birth\n';
			}
		} else if (!validDate(document.form1.patbdate)) {
			if (msg.length == 0) focusField = document.form1.patbdate;
			$(document.form1.patbdate).parent().find('div#dateOfBirth').addClass("hightLight");
			if (document.form1.language.value =='chi'){
				msg = msg + '輸入不正確出生日期.\n';
			} else {
				msg = msg + 'Invalid Date of Birth.\n';
			}
		}
		if (document.form1.patfname.value == '') {
			if (msg.length == 0) focusField = document.form1.patfname;
			$(document.form1.patfname).parent().find('div#patfname').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '姓氏\n';
			} else {
				msg = msg + 'Family Name\n';
			}
		}
		if (document.form1.patgname.value == '') {
			if (msg.length == 0) focusField = document.form1.patgname;
			$(document.form1.patgname).parent().find('div#patgname').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '名稱\n';
			} else {
				msg = msg + 'Given Name\n';
			}
		}
		if (document.form1.patemail.value == '') {
			if (msg.length == 0) focusField = document.form1.patemail;
			$(document.form1.patemail).parent().find('div#patemail').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '電郵\n';
			} else {
				msg = msg + 'Email\n';
			}
		}
		if (document.form1.titleDesc.value == '' && document.form1.titleDescOther.value == '') {
			if (msg.length == 0) focusField = document.form1.titleDesc;
			$(document.form1.titleDesc	).parent().find('div#title').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '稱謂\n';
			} else {
				msg = msg + 'Title\n';
			}
		}
		if (document.form1.patsex.value == '') {
			if (msg.length == 0) focusField = document.form1.patsex;
			$(document.form1.patsex).parent().find('div#patsex').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '性別\n';
			} else {
				msg = msg + 'Sex\n';
			}
		}

		if (document.form1.religion.value == 'OT' && document.form1.religionOther.value == '') {
			if (msg.length == 0) focusField = document.form1.religion;
			$(document.form1.religion).parent().find('div#religion').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '宗教 \n';
			} else {
				msg = msg + 'Religion\n';
			}
		}
		if (document.form1.pathtel.value == ''
				&& document.form1.patotel.value == ''
				&& document.form1.patmtel.value == '') {
			if (msg.length == 0) focusField = document.form1.pathtel;
			$('div#home').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '聯絡電話號碼\n';
			} else {
				msg = msg + 'Contact No.\n';
			}
		}

		if (document.form1.patmsts.value == '') {
			if (msg.length == 0) focusField = document.form1.patmsts;
			$(document.form1.patmsts).parent().find('div#patmsts').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '婚姻狀況 \n';
			} else {
				msg = msg + 'Marital Status\n';
			}
		}

		if (document.form1.patmsts.value == 'O' && document.form1.patmstsOther.value == '') {
			if (msg.length == 0) focusField = document.form1.patmsts;
			$(document.form1.patmsts).parent().find('div#patmsts').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '婚姻狀況 \n';
			} else {
				msg = msg + 'Marital Status\n';
			}
		}
		if (document.form1.mothcode.value == '') {
			if (msg.length == 0) focusField = document.form1.mothcode;
			$(document.form1.mothcode).parent().find('div#mothcode').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '通訊語言\n';
			} else {
				msg = msg + 'Correspondence Language\n';
			}
		}
		if (document.form1.racedesc.value == '' && document.form1.racedescOther.value == '') {
			if (msg.length == 0) focusField = document.form1.racedesc;
			$(document.form1.racedesc	).parent().find('div#racedesc').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '國藉\n';
			} else {
				msg = msg + 'Nationality\n';
			}
		}
		if (document.form1.religion.value == '' && document.form1.religionOther.value == '') {
			if (msg.length == 0) focusField = document.form1.religion;
			$(document.form1.religion	).parent().find('div#religion').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '宗教\n';
			} else {
				msg = msg + 'Religion\n';
			}
		}
		if (document.form1.edulevel.value == '') {
			if (msg.length == 0) focusField = document.form1.edulevel;
			$(document.form1.edulevel).parent().find('div#edulevel').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '教育程度 \n';
			} else {
				msg = msg + 'Education Level\n';
			}
		}
		if (document.form1.mktSrc.value == '') {
			if (msg.length == 0) focusField = document.form1.mktSrc;
			$(document.form1.mktSrc).parent().find('div#mktSrc').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '認識本院的途徑 \n';
			} else {
				msg = msg + 'How did you hear about us?\n';
			}
		}
		if (document.form1.occupation.value == '') {
			if (msg.length == 0) focusField = document.form1.occupation;
			$('div#occupation').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '職業\n';
			} else {
				msg = msg + 'Occupation \n';
			}
		}
		if (document.form1.patadd1.value == ''
			&& document.form1.patadd2.value == ''
			&& document.form1.patadd3.value == ''
			) {
			if (msg.length == 0) focusField = document.form1.patadd1;
			$('div#patadd1').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '地址\n';
			} else {
				msg = msg + 'Address\n';
			}
		}
		if (document.form1.patkfname1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkfname1;
			$('div#patkfname1').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '(緊急聯絡人) 姓氏\n';
			} else {
				msg = msg + '(Emergency Contact Person) Family Name\n';
			}
		}
		if (document.form1.patkgname1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkgname1;
			$('div#patkgname1').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '(緊急聯絡人) 名稱\n';
			} else {
				msg = msg + '(Emergency Contact Person) Given Name\n';
			}
		}
		if (document.form1.patksex1.value == '') {
			if (msg.length == 0) focusField = document.form1.patksex1;
			$('div#patksex1').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '(緊急聯絡人) 性別\n';
			} else {
				msg = msg + '(Emergency Contact Person) Sex\n';
			}
		}
		if (document.form1.patkrela1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkrela1;
			$('div#patkrela1').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '(緊急聯絡人) 關係\n';
			} else {
				msg = msg + '(Emergency Contact Person) Relationship\n';
			}
		}
		if (document.form1.patkhtel1.value == ''
			&& document.form1.patkotel1.value == ''
			&& document.form1.patkmtel1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkhtel1;
			$('div#patkhtel1').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if (document.form1.language.value =='chi'){
				msg = msg + '(緊急聯絡人) 聯絡電話號碼\n';
			} else {
				msg = msg + '(Emergency Contact Person) Contact No.\n';
			}
		}

		// move to admission_client_payment.jsp (begin)
		
		if (!document.form1.agreement2.checked) {
			if (msg.length == 0) focusField = document.form1.agreement2;
			$(document.form1.agreement2).parent().parent().find('div#paymentMsg').addClass("hightLight");
			agreeement2CheckFail = true;
		}

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
		// move to admission_client_payment.jsp (end)
		
		if (document.form1.paymentType[4].checked){
				if (checkUploadFile()=='1'){
					if (document.form1.language.value =='chi'){
						alert('請附上或傳真信用卡副本及授權書.\n');
					} else {
						alert('Please Attach or Fax Credit Card copy and Authorization Form.\n');
					}
				}
			}

		if (msg.length > 0
				|| checkAdmissionDateFail || agreeement2CheckFail) {
			if (document.form1.language.value =='chi'){
				msg = '請選擇或輸入以下尚未載入的資料:\n\n' + msg + '\n';
			} else {
				msg = 'The following fields are missing.  Please choose or enter:\n' + msg + '\n';
			}

			if (expectedAdmissionDateInvalid) {
				if (document.form1.language.value =='chi'){
					msg = msg + '輸入不正確預定入院日期\n';
				} else {
					msg = msg + 'Admission Date is not a valid date.\n';
				}
			}

			if (checkAdmissionDateFail) {
				if (document.form1.language.value =='chi'){
					msg = msg + '預定入院日期少於一個工作天\n';
				} else {
					msg = msg + 'Admission Date is less than one day prior to your admission.\n';
				}
			}
			// move to admission_client_payment.jsp (begin)
			if (agreeement2CheckFail) {
				if (document.form1.language.value =='chi'){
					msg = msg + '請  ✔  以確定已細閱每日房租和預繳按金\n';
				} else {
					msg = msg + 'Please  ✔  to confirm the acknowledgement of "Daily Room Rate and Advance Payment".\n';
				}
			}
			// move to admission_client_payment.jsp (end)

			if (document.form1.language.value =='chi'){
				msg=msg +'\n如有任何查詢，請致電熱線電話 3651 8740\n';
			} else {
				msg=msg +'\nKindly contact our hotline at 3651 8740 if you need further assistance.\n';
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

</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>