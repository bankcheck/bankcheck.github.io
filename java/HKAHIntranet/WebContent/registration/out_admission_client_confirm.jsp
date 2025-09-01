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
} else{
	locale = Locale.US;
}


String appointmentDate = request.getParameter("appointmentDate");
if(appointmentDate == null || "null".equals(appointmentDate)){
	appointmentDate = "";
}
boolean appointTimeIsNull = false;
String appointmentTime_hh = request.getParameter("appointmentTime_hh");
if(appointmentTime_hh == null || "null".equals(appointmentTime_hh)){
	appointmentTime_hh = "";
	appointTimeIsNull = true;
}
String appointmentTime_mi = request.getParameter("appointmentTime_mi");
if(appointmentTime_mi == null || "null".equals(appointmentTime_mi)){
	appointmentTime_mi = "";
	appointTimeIsNull = true; 
}
String appointmentTime = "";
if(appointTimeIsNull == false){
	appointmentTime = appointmentTime_hh + ":" + appointmentTime_mi;
}
String attendDoctor = request.getParameter("attendDoctor");
if(attendDoctor == null || "null".equals(attendDoctor)){
	attendDoctor = "";
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
String pattraveldoc = request.getParameter("pattraveldoc");

String patsex = null;
String racedesc = null;
String racedescOther = null;
String religion = null;
String religionOther = null;
String patbdate = request.getParameter("patbdate");
String patmsts = null;
String patmstsOther = null;
String mothcode = null;
String edulevel = null;
String edulevelOther = null;
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
String coucode = null;

String patkfname1 = null;
String patkgname1 = null;
String patkcname1 = null;
String patkrela1 = null;
String patkhtel1 = null;
String patkotel1 = null;
String patkmtel1 = null;
String patkemail1 = null;
String patkadd11 = null;
String patkadd21 = null;
String patkadd31 = null;
String patkadd41 = null;
String patkTitleDesc1 = null;
String patkTitleDescOther1 = null;
String patkcoucode1 = null;

String patkfname2 = null;
String patkgname2 = null;
String patkcname2 = null;
String patkrela2 = null;
String patkhtel2 = null;
String patkotel2 = null;
String patkmtel2 = null;
String patkemail2 = null;
String patkadd12 = null;
String patkadd22 = null;
String patkadd32 = null;
String patkadd42 = null;
String patkTitleDesc2 = null;
String patkTitleDescOther2 = null;
String patkcoucode2 = null;

String patHowInfo = null;
String patHowInfoOther = null;


if(language==null ||"".equals(language)){
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


if (patbdate != null && patbdate.length() > 0) {
	if (patidno != null && patidno.length() > 0) {		
		record = AdmissionDB.getHATSPatient(null, patidno, patbdate);
	} else if (patpassport != null && patpassport.length() > 0) {
		record = AdmissionDB.getHATSPatient(null, patpassport, patbdate);
	} else if (pattraveldoc != null && pattraveldoc.length() > 0){		
		record = AdmissionDB.getHATSPatient(null, pattraveldoc, patbdate);
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
		coucode = row.getValue(31);
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

<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="admission_header.jsp" flush="false" />
<div class="normal_area">
<div class="career_form">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr valign="center">
		<td class="step2_1" width="33%"><p><%=MessageResources.getMessage(session, "adm.checkInfo1") %></p></td>
		<td class="step2_2" width="33%"><p><%=MessageResources.getMessage(session, "adm.checkInfo2") %></p></td>
		<td class="step2_3" width="33%"><p><%=MessageResources.getMessage(session, "adm.checkInfo3") %></p>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td class="infoText"><%=MessageResources.getMessage(session, "adm.fillInfo") %><%if(!"chi".equals(language)){ %><font color="red">*</font><%} %></td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
	<tr>
		<td class="infoText"><strong><%=MessageResources.getMessage(session, "out.adm.healthCareMessage") %></strong></td>
	</tr>	
</table>
<form name="form1" enctype="multipart/form-data" action="out_admission_client_submit.jsp" method="post">
<table width="800" border="0" cellpadding="0" cellspacing="5">
	<tr>
		<td colspan="3">
			<table style="border-collapse:collapse;border-color:black;" width="100%" border="1">
				<tr>
					<td style="border-style:none;font-size:16px;padding:5px" class="infoText"><strong><%=MessageResources.getMessage(session, "out.adm.per.heading") %></strong></td>
				</tr>
				<tr>
					<td style="border-style:none;padding:2px" class="infoText"><%=MessageResources.getMessage(session, "out.adm.per.intro1") %></td>
				</tr>
				<tr>
					<td style="border-style:none;padding:2px" class="infoText"><%=MessageResources.getMessage(session, "out.adm.per.intro2") %></td>
				</tr>
				<tr>
					<td style="border-style:none;padding:2px" class="infoText"><%=MessageResources.getMessage(session, "out.adm.per.intro3") %></td>
				</tr>			
			</table>
		</td>	
	</tr>
	<tr>
		<td colspan="3" height="25" bgcolor="aa0066">
			<table width="686" border="0" align="center" cellpadding="0"
				cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session, "adm.hosInfo") %></strong></font></td>
				</tr>
			</table>
		</td>
	</tr>	
	<tr>
		<td colspan="2" height="40"  valign="top" bgcolor="#F9F9F9">			
			<table>
			<tr><td id ="appointmentDateCell">
			<div id="appDate"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "out.adm.appDate") %><%=MessageResources.getMessage(session, "adm.ddmmyyyy.hhmm") %></div>			
			
			<input type="text" readonly="readonly" name="appointmentDate" id="appointmentDate" value="<%=appointmentDate %>" maxlength="10" size="10"   onkeyup="validDate(this)" />			
				<jsp:include page="../ui/timeCMB.jsp" flush="false">
					<jsp:param name="label" value="appointmentTime" />
					<jsp:param name="time" value="<%=appointmentTime %>" />
					<jsp:param name="isDisabled" value="Y" />
				</jsp:include>			
			</td></tr>	
			</table>
		</td>
		<td height="40"  valign="top" bgcolor="#F9F9F9">
			<div id="attDoctor"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "out.adm.attDoctor") %></div>
			<select name="attendDoctor" disabled>
				<option value=""></option>
				<jsp:include page="../ui/docCodeCMB.jsp" flush="false">
					<jsp:param name="selectFrom" value="Pre-addmission" />
					<jsp:param name="doccode" value="<%=attendDoctor %>" />
				</jsp:include>
			</select>
		</td>	
	</tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3" height="25" bgcolor="aa0066">
			<table width="650" border="0" align="center" cellpadding="0"
				cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session, "out.adm.personalInfo") %></strong></font></td>
				</tr>
			</table>
		</td>
	</tr>	
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			<div id="patfname"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "out.adm.famName") %></div>
			<input type="text" name="patfname" class="uppercase" value="<%=patfname==null?"":patfname %>" maxlength="60" size="25">					
		</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			<div id="patgname"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "out.adm.givenName") %></div>
			<input type="text" name="patgname" class="uppercase" value="<%=patgname==null?"":patgname %>" maxlength="20" size="25">
		</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			<div id="title"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "adm.title") %></div> 
			<select name="titleDesc">
				<option value=""></option>
				<option value="MR" <%="MR.".equals(titleDesc)?" selected":"" %>><%=MessageResources.getMessage(session, "label.mr") %></option>
				<option value="MRS" <%="MRS.".equals(titleDesc)?" selected":"" %>><%=MessageResources.getMessage(session, "label.mrs") %></option>
				<option value="MISS" <%="MISS".equals(titleDesc)?" selected":"" %>><%=MessageResources.getMessage(session, "label.miss") %></option>
				<option value="MS" <%="MS".equals(titleDesc)?" selected":"" %>><%=MessageResources.getMessage(session, "label.ms") %></option>
				<option value="Others"<%="Others".equals(titleDesc)?" selected":"" %>><%=MessageResources.getMessage(session, "label.others") %></option>				
			</select><br />
			<%=MessageResources.getMessage(session, "label.others") %> : <input type="text" name="titleDescOther" class="uppercase" value="<%=titleDescOther==null?"":titleDescOther %>" maxlength="10" size="20">
		</td>			
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<%=MessageResources.getMessage(session, "prompt.chineseName") %><br />
		 	<input type="text" name="patcname" id="patcname" value="<%=patcname==null?"":patcname %>"  maxlength="20" size="25">
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<div id="patsex"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "prompt.sex") %></div>
			<select name="patsex">
				<option value=""></option>
				<option value="M" <%="M".equals(patsex)?" selected":"" %>><%=MessageResources.getMessage(session, "label.male") %></option>
				<option value="F" <%="F".equals(patsex)?" selected":"" %>><%=MessageResources.getMessage(session, "label.female") %></option>
			</select>
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<div id="dateOfBirth"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "adm.dateOfBirth") %><%=MessageResources.getMessage(session, "adm.ddmmyyyy") %></div>
			<input type="text" name="patbdate" id="patbdate" class="datepickerfield" value="<%=patbdate==null?"":patbdate %>" maxlength="10" size="10" onkeyup="validDate(this)">			
		</td>
	</tr>
	<tr>
		<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">			
			<table width="100%" border="0">
				<tr>
					<td style="width:33%">
						<font color="red">*</font><input type="radio" name="patidType" value="hkid"<%=patpassport==null||patpassport.length()==0?" checked":"" %> onclick="validHKID();"><div id="hkid"><%=MessageResources.getMessage(session, "adm.hkid") %></div>
						<input type="text" name="patidno1" value="<%=patidno1==null?"":patidno1 %>" maxlength="8" size="8" onkeyup="validHKID();" onblur="validHKID()">(<input type="text" name="patidno2" value="<%=patidno2==null?"":patidno2 %>" maxlength="2" size="2" onkeyup="validHKID();" onkeydown="validDOB(event);">)
					</td>				
					<td style="width:33%">
						<input type="radio" name="patidType" value="passport"<%=patpassport!=null&&patpassport.length()>0?" checked":"" %> onclick="validPassport();"><div id="passport"><%=MessageResources.getMessage(session, "adm.passport") %></div>
						<input type="text" name="patpassport" value="<%=patpassport==null?"":patpassport %>" maxlength="20" size="25" onkeyup="validPassport();">
					</td>
					<td style="width:33%">
						<input type="radio" name="patidType" value="traveldoc"<%=pattraveldoc!=null&&pattraveldoc.length()>0?" checked":"" %> onclick="validTravelDoc()"><div id="traveldoc"><%=MessageResources.getMessage(session, "out.adm.traveldocument") %></div>
						<input type="text" name="pattraveldoc" value="<%=pattraveldoc==null?"":pattraveldoc %>" maxlength="20" size="25" onkeyup="validTravelDoc()">
					</td>
				</tr>
				<tr>
					<td height="20">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3">
						<%=MessageResources.getMessage(session, "out.adm.attachID") %>
					</td>
				</tr>
				<tr>
					<td>						
						<input type="file" name="file1" size="20" class="multi" maxlength="5" style="display:inline" />							
					</td>
					<td>
						<%=MessageResources.getMessage(session, "adm.faxNo") %>: 36518802
					</td>
				</tr>
			</table>
		</td>
	</tr> 	
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<div id="patmsts"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "adm.maritalStatus") %></div>
			<select name="patmsts">
				<option value=""></option>
				<option value="S" <%="S".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mStatus1") %></option>
				<option value="M" <%="M".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mStatus2") %></option>	
				<option value="D" <%="D".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mStatus3") %></option>
				<option value="X" <%="X".equals(patmsts)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.mStatus4") %></option>							
			</select><br />
			<%=MessageResources.getMessage(session, "label.others") %>: <input type="text" class="uppercase" name="patmstsOther" value="<%=patmstsOther==null?"":patmstsOther %>" />
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div id="religion"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "prompt.religion") %></div>
			<select name="religion">
				<option value=""></option>
				<option value="NO" <%="NO".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.None") %></option>
				<option value="BU" <%="BU".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion1") %></option>
				<option value="CA" <%="CA".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion2") %></option>
				<option value="CH" <%="CH".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion3") %></option>
				<option value="HI" <%="HI".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion4") %></option>
				<option value="SH" <%="SH".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion5") %></option>
				<option value="SD" <%="SD".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.religion6") %></option>
				<option value="Others"<%="Others".equals(religion)?" selected":"" %>><%=MessageResources.getMessage(session, "label.others") %></option>
			</select><br />
			<%=MessageResources.getMessage(session, "label.others") %>: <input type="text" class="uppercase" name="religionOther" value="<%=religionOther==null?"":religionOther %>" />
		</td>
			<td height="40" valign="top" bgcolor="#F9F9F9"><div id="racedesc"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "adm.ethicGroup") %></div>
			<select name="racedesc">
				<option value=""></option>
				<jsp:include page="../ui/raceDescCMB.jsp" flush="false">
					<jsp:param name="racedesc" value="<%=racedesc %>" />
				</jsp:include>
			</select><br />
			<%=MessageResources.getMessage(session, "label.others") %> : <input type="text" class="uppercase" name="racedescOther" value="<%=racedescOther==null?"":racedescOther %>" maxlength="10" size="20" /> <br />
			(<%=MessageResources.getMessage(session, "adm.hospitalStat") %>)
		</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<div><%=MessageResources.getMessage(session, "prompt.occupation") %></div>
			<input name="occupation" type="text" class="uppercase" value="<%=occupation==null?"":occupation %>" maxlength="20" size="25" />		
			
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div id='mothcode'><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "adm.wLang") %></div>
			<select name="mothcode">
				<option value=""></option>
				<option value="ENG" <%="ENG".equals(mothcode)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.lang1") %></option>
				<option value="TRC" <%="TRC".equals(mothcode)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.lang2") %></option>
				<option value="SMC" <%="SMC".equals(mothcode)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.lang3") %></option>
				<option value="JAP" <%="JAP".equals(mothcode)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.lang4") %></option>
			</select><br />
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<div id='edulevel'><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "prompt.educationLevel") %></div>
			<select name="edulevel">
				<option value=""></option>				
				<option value="Primary"<%="Primary".equals(edulevel)?" selected":"" %>><%=MessageResources.getMessage(session, "label.primarySchool") %></option>
				<option value="Secondary"<%="Secondary".equals(edulevel)?" selected":"" %>><%=MessageResources.getMessage(session, "label.secondarySchool") %></option>
				<option value="Tertiary or above"<%="Tertiary or above".equals(edulevel)?" selected":"" %>><%=MessageResources.getMessage(session, "adm.terOfAbove") %></option>
				<option value="Others"<%="Others".equals(edulevel)?" selected":"" %>><%=MessageResources.getMessage(session, "label.others") %></option>
			</select><br />
			<%=MessageResources.getMessage(session, "label.others") %> : <input type="text" class="uppercase" name="edulevelOther" value="<%=edulevelOther==null?"":edulevelOther %>" maxlength="10" size="20" />
		</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div id='patemail'><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "adm.emailAdd") %></div>
			<input name="patemail" type="text" value="<%=patemail==null?"":patemail %>" maxlength="50" size="25" />
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div id="home"><%=MessageResources.getMessage(session, "out.adm.home") %></div>
			<input name="pathtel" type="text" value="<%=pathtel==null?"":pathtel %>" maxlength="20" size="25" />
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div id='patmtel'><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "out.adm.mobile") %></div>
		<input name="patmtel" type="text" value="<%=patmtel==null?"":patmtel %>" maxlength="20" size="25" />
	</tr>
	<tr>
		<td></td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div><%=MessageResources.getMessage(session, "out.adm.officePhone") %></div>
			<input name="patotel" type="text" value="<%=patotel==null?"":patotel %>" maxlength="20" size="25" />
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div><%=MessageResources.getMessage(session, "adm.faxNo") %></div>
			<input name="patftel" type="text" value="<%=patftel==null?"":patftel %>" maxlength="20" size="25" />
		</td>
	</tr>
	<tr>
		<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9"><div id=patadd1><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "adm.Address") %></div><br />
			<input type="text" name="patadd1" class="uppercase" value="<%=patadd1==null?"":patadd1 %>" maxlength="40" size="50"/><%=MessageResources.getMessage(session, "adm.rmFt") %>/<%=MessageResources.getMessage(session, "adm.floor") %>/<%=MessageResources.getMessage(session, "adm.blkBldg") %><br />
			<input type="text" name="patadd2" class="uppercase" value="<%=patadd2==null?"":patadd2 %>" maxlength="40" size="50"/><%=MessageResources.getMessage(session, "adm.road") %>/<%=MessageResources.getMessage(session, "adm.street") %><br />
			<input type="text" name="patadd3" class="uppercase" value="<%=patadd3==null?"":patadd3 %>" maxlength="40" size="50"/><%=MessageResources.getMessage(session, "adm.district") %><br />
				<select name="coucode">
					<jsp:include page="../ui/countryCodeCMB.jsp" flush="false">
					<jsp:param name="coucode" value="<%=coucode %>" />
					</jsp:include>
				</select><%=MessageResources.getMessage(session, "prompt.country") %>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">	
	<tr>
		<td>
			<a href="javascript:void(0);" onclick="clickOptionalInformation();return false;"><font size="5" color="#F535AA"><b><%=MessageResources.getMessage(session, "out.adm.optionInfo") %></b></font></a>			
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="5" id="optionalInformation1" >	
	<tr >
		<td height="25" colspan="3" bgcolor="#aa0066">
		<table  width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session, "adm.emergencyContact") %> (1)</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>	
	<tr>
		<td width="33%" height="40" valign="top" bgcolor="#F9F9F9"><div id='patkfname1'><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "out.adm.famName") %></div>
			<input type="text" name="patkfname1" class="uppercase" value="<%=patkfname1==null?"":patkfname1 %>" maxlength="60" size="25">
		</td>		
		<td width="33%" height="40" valign="top" bgcolor="#F9F9F9"><div id='patkgname1'><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "out.adm.givenName") %></div>
			<input type="text" name="patkgname1" class="uppercase" value="<%=patkgname1==null?"":patkgname1 %>" maxlength="20" size="25">
		</td>		
		<td height="33" valign="top" bgcolor="#F9F9F9"><%=MessageResources.getMessage(session, "prompt.chineseName") %><br/>
			<input type="text" name="patkcname1" value="<%=patkcname1==null?"":patkcname1 %>" maxlength="20" size="25">
		</td>
	</tr>	
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			<div id="patkTitleDesc1"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "adm.title") %></div> 
			<select name="patkTitleDesc1">
				<option value=""></option>
				<option value="MR" <%="MR.".equals(patkTitleDesc1)?" selected":"" %>><%=MessageResources.getMessage(session, "label.mr") %></option>
				<option value="MRS" <%="MRS.".equals(patkTitleDesc1)?" selected":"" %>><%=MessageResources.getMessage(session, "label.mrs") %></option>
				<option value="MISS" <%="MISS".equals(patkTitleDesc1)?" selected":"" %>><%=MessageResources.getMessage(session, "label.miss") %></option>
				<option value="MS" <%="MS".equals(patkTitleDesc1)?" selected":"" %>><%=MessageResources.getMessage(session, "label.ms") %></option>
				<option value="Others"<%="Others".equals(patkTitleDesc1)?" selected":"" %>><%=MessageResources.getMessage(session, "label.others") %></option>				
			</select><br />
			<%=MessageResources.getMessage(session, "label.others") %> : <input type="text" name="patkTitleDescOther1" class="uppercase" value="<%=patkTitleDescOther1==null?"":patkTitleDescOther1 %>" maxlength="10" size="20">
		</td>
		<td height="33" valign="top" bgcolor="#F9F9F9">
			<div><%=MessageResources.getMessage(session, "prompt.relationship") %></div>
			<input type="text" name="patkrela1" value="<%=patkrela1==null?"":patkrela1 %>" maxlength="20" size="25">
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<div><%=MessageResources.getMessage(session, "adm.emailAdd") %></div>
			<input type="text" name="patkemail1" value="<%=patkemail1==null?"":patkemail1 %>" maxlength="50" size="25" />
		</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div id="home"><%=MessageResources.getMessage(session, "out.adm.home") %></div>
			<input name="patkhtel1" type="text" value="<%=patkhtel1==null?"":patkhtel1 %>" maxlength="20" size="25" />
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div id="patkmtel1"><font color="red">*</font>&nbsp;<%=MessageResources.getMessage(session, "out.adm.mobile") %></div>
			<input name="patkmtel1" type="text" value="<%=patkmtel1==null?"":patkmtel1 %>" maxlength="20" size="25" />	
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div><%=MessageResources.getMessage(session, "out.adm.officePhone") %></div>
			<input name="patkotel1" type="text" value="<%=patkotel1==null?"":patkotel1 %>" maxlength="20" size="25" />
		</td>
	</tr>
	<tr>
		<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9"><%=MessageResources.getMessage(session, "adm.Address") %><br />
			<input type="text" name="patkadd11" class="uppercase" value="<%=patkadd11==null?"":patkadd11 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.rmFt") %>/<%=MessageResources.getMessage(session, "adm.floor") %>/<%=MessageResources.getMessage(session, "adm.blkBldg") %><br />
			<input type="text" name="patkadd21" class="uppercase" value="<%=patkadd21==null?"":patkadd21 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.road") %>/<%=MessageResources.getMessage(session, "adm.street") %><br />
			<input type="text" name="patkadd31" class="uppercase" value="<%=patkadd31==null?"":patkadd31 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.district") %><br />
			<select name="patkcoucode1">
				<jsp:include page="../ui/countryCodeCMB.jsp" flush="false">
				<jsp:param name="coucode" value="<%=patkcoucode1 %>" />
				</jsp:include>
			</select><%=MessageResources.getMessage(session, "prompt.country") %>
		</td>
	</tr>
	
</table>
<table width="800" border="0" cellpadding="0" cellspacing="5" id="optionalInformation2" >	
	<tr >
		<td height="25" colspan="3" bgcolor="#aa0066">
		<table  width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session, "adm.emergencyContact") %> (2)</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>	
	<tr>
		<td width="33%" height="40" valign="top" bgcolor="#F9F9F9"><%=MessageResources.getMessage(session, "out.adm.famName") %>
			<input type="text" name="patkfname2" class="uppercase" value="<%=patkfname2==null?"":patkfname2 %>" maxlength="60" size="25">
		</td>		
		<td width="33%" height="40" valign="top" bgcolor="#F9F9F9"><%=MessageResources.getMessage(session, "out.adm.givenName") %>
			<input type="text" name="patkgname2" class="uppercase" value="<%=patkgname2==null?"":patkgname2 %>" maxlength="20" size="25">
		</td>		
		<td height="33" valign="top" bgcolor="#F9F9F9"><%=MessageResources.getMessage(session, "prompt.chineseName") %><br/>
			<input type="text" name="patkcname2" value="<%=patkcname2==null?"":patkcname2 %>" maxlength="20" size="25">
		</td>
	</tr>	
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			<span id="title"><%=MessageResources.getMessage(session, "adm.title") %></span> 
			<select name="patkTitleDesc2">
				<option value=""></option>
				<option value="MR" <%="MR.".equals(patkTitleDesc2)?" selected":"" %>><%=MessageResources.getMessage(session, "label.mr") %></option>
				<option value="MRS" <%="MRS.".equals(patkTitleDesc2)?" selected":"" %>><%=MessageResources.getMessage(session, "label.mrs") %></option>
				<option value="MISS" <%="MISS".equals(patkTitleDesc2)?" selected":"" %>><%=MessageResources.getMessage(session, "label.miss") %></option>
				<option value="MS" <%="MS".equals(patkTitleDesc2)?" selected":"" %>><%=MessageResources.getMessage(session, "label.ms") %></option>
				<option value="Others"<%="Others".equals(patkTitleDesc2)?" selected":"" %>><%=MessageResources.getMessage(session, "label.others") %></option>				
			</select><br />
			<%=MessageResources.getMessage(session, "label.others") %> : <input type="text" name="patkTitleDescOther2" class="uppercase" value="<%=patkTitleDescOther2==null?"":patkTitleDescOther2 %>" maxlength="10" size="20">
		</td>
		<td height="33" valign="top" bgcolor="#F9F9F9">
			<div><%=MessageResources.getMessage(session, "prompt.relationship") %></div>
			<input type="text" name="patkrela2" value="<%=patkrela2==null?"":patkrela2 %>" maxlength="20" size="25">
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<div><%=MessageResources.getMessage(session, "adm.emailAdd") %></div>
			<input type="text" name="patkemail2" value="<%=patkemail2==null?"":patkemail2 %>" maxlength="50" size="25" />
		</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div id="home"><%=MessageResources.getMessage(session, "out.adm.home") %></div>
			<input name="patkhtel2" type="text" value="<%=patkhtel2==null?"":patkhtel2 %>" maxlength="20" size="25" />
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div><%=MessageResources.getMessage(session, "out.adm.mobile") %></div>
			<input name="patkmtel2" type="text" value="<%=patkmtel2==null?"":patkmtel2 %>" maxlength="20" size="25" />	
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9"><div><%=MessageResources.getMessage(session, "out.adm.officePhone") %></div>
			<input name="patkotel2" type="text" value="<%=patkotel2==null?"":patkotel2 %>" maxlength="20" size="25" />
		</td>
	</tr>
	<tr>
		<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9"><%=MessageResources.getMessage(session, "adm.Address") %><br />
			<input type="text" name="patkadd12" class="uppercase" value="<%=patkadd12==null?"":patkadd12 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.rmFt") %>/<%=MessageResources.getMessage(session, "adm.floor") %>/<%=MessageResources.getMessage(session, "adm.blkBldg") %><br />
			<input type="text" name="patkadd22" class="uppercase" value="<%=patkadd22==null?"":patkadd22 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.road") %>/<%=MessageResources.getMessage(session, "adm.street") %><br />
			<input type="text" name="patkadd32" class="uppercase" value="<%=patkadd32==null?"":patkadd32 %>" maxlength="40" size="50"><%=MessageResources.getMessage(session, "adm.district") %><br />
			<select name="patkcoucode2">
				<jsp:include page="../ui/countryCodeCMB.jsp" flush="false">
				<jsp:param name="coucode" value="<%=patkcoucode2 %>" />
				</jsp:include>
			</select><%=MessageResources.getMessage(session, "prompt.country") %>
		</td>
	</tr>	
</table>

<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr >
		<td height="25" colspan="4" bgcolor="#aa0066">
		<table  width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>			
				<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session, "out.adm.howInfo") %></strong></font></td>
			</tr>
		</table>
		</td>
	</tr>		
	<tr>
	<td>
	<div id='patHowInfo'><font color="red">*</font>
	<table style="width:100%">
	<tr>
			
		<td height="40" valign="top" bgcolor="#F9F9F9">		
			<input type="radio" name="patHowInfo" value="enews"<%="enews".equals(patHowInfo)?" checked":"" %>/>
			<%=MessageResources.getMessage(session, "out.adm.howInfo.enews") %>			
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<input type="radio" name="patHowInfo" value="friend" <%="friend".equals(patHowInfo)?" checked":"" %>/>
			<%=MessageResources.getMessage(session, "out.adm.howInfo.friend") %>
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<input type="radio" name="patHowInfo" value="web" <%="web".equals(patHowInfo)?" checked":"" %>/>
			<%=MessageResources.getMessage(session, "out.adm.howInfo.web") %>		
		</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<input type="radio" name="patHowInfo" value="news" <%="news".equals(patHowInfo)?" checked":"" %>/>
			<%=MessageResources.getMessage(session, "out.adm.howInfo.news") %>			
		</td>
	</tr>
	<tr>
		<td colspan="4" height="40" valign="top" bgcolor="#F9F9F9">
			<input type="radio" name="patHowInfo" value="other" <%="other".equals(patHowInfo)?" checked":"" %>/>
			<%=MessageResources.getMessage(session, "out.adm.howInfo.other") %>
			<input type="text" value="<%=patHowInfoOther==null?"":patHowInfoOther %>" name="patHowInfoOther" onkeyup="checkHowInfoOther()" class="uppercase" maxlength="10" size="20">
		</td>
	</tr>
	</table>
	</div>
	</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">	
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr >
		<td  id="browserInfo" colspan="6" height="25" bgcolor="#aa0066">
		<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong><%=MessageResources.getMessage(session, "adm.otherInfo") %></strong></font></td>
			</tr>
		</table>
		</td>
	</tr>	
	<tr>
		<td height="20" colspan="5">
		<ul id="browser" class="filetree">
			<jsp:include page="../registration/out_important_information.jsp" flush="false">
				<jsp:param name="source" value="registration" />
			</jsp:include>		
		</ul>
		</td>
	</tr>
	<tr>
		<td><font color="red">***</font><%=MessageResources.getMessage(session, "adm.versionMsg") %></td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
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
</div>
</div>
<input type="hidden" name="command" value="create" />
<input type="hidden" name="step" value="1" />
<input type="hidden" name="admissionID" />
<input type="hidden" name="patno" value="<%=patno==null?"":patno %>" />
<input type="hidden" name="session" value="<%=sessionKey==null?"":sessionKey %>" />
<input type="hidden" name="tempOptionalValue" value="2"/>
<input type="hidden" name="language" value="<%=language%>"/>
<input type="hidden" name="appointmentTime_hh" value="<%=appointmentTime_hh==null?"":appointmentTime_hh %>" />
<input type="hidden" name="appointmentTime_mi" value="<%=appointmentTime_mi==null?"":appointmentTime_mi %>" />
<input type="hidden" name="attendDoctor" value="<%=attendDoctor==null?"":attendDoctor %>" />
<a class="iframe" id="show_info_tree" href="../registration/information_tree.jsp?language=<%=language %>&style=popup" ></a>
</form>
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
	
		$(".uppercase").blur(
				function(){
					this.value = this.value.toUpperCase();
				}
		 );		
	});
		
	function checkAllImpt(){
		$('input[name="imptInfo"]').each(function() {
			if($('input[name="checkAll"]').is(':checked')){
				$(this).attr('checked', true);
			}else{
				$(this).attr('checked', false);
			}
		});
	}

	function clickOptionalInformation(){
		var optionalInformation1 = document.getElementById("optionalInformation1");
		var optionalInformation2 = document.getElementById("optionalInformation2");

		if(document.form1.tempOptionalValue.value == '1'){
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

		if(optionalField.style.display == 'none'){
			optionalField.style.display = 'block';
		} else if (optionalField.style.display == 'block'){
			optionalField.style.display = 'none';
		}

	}
	
	function submitAction() {
		var msg = '';
		var focusField;
		var count = 1;
		var checkAdmissionDateFail = false;
		var agreeement2CheckFail = false;
		var expectedAdmissionDateInvalid = false;
				
		$(".hightLight").removeClass();
		if (document.form1.appointmentDate.value == '') {
			if (msg.length == 0) focusField = document.form1.appointmentDate;
			$(document.form1.appointmentDate).parent().find('div#appDate').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '預約日期\n';
			}else{
				msg = msg + 'Appointment Date\n';
			}			
		} else if (!validDate(document.form1.appointmentDate)) {
			if (msg.length == 0) focusField = document.form1.appointmentDate;
			$(document.form1.appointmentDate).parent().find('div#appDate').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '輸入不正確預約日期.\n';
			}else{
				msg = msg + 'Invalid Appointment Date.\n';
			}			
		}	
		
		if ($('select[name=attendDoctor] :selected').text() == ''){
			if (msg.length == 0) focusField = document.form1.attendDoctor;
			$(document.form1.attendDoctor).parent().find('div#attDoctor').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '主診醫生\n';
			}else{
				msg = msg + 'Attend Doctor\n';
			}
		}
		
		if (document.form1.patfname.value == '') {
			if (msg.length == 0) focusField = document.form1.patfname;
			$(document.form1.patfname).parent().find('div#patfname').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '姓 (英文)\n';
			}else{
				msg = msg + 'Surname in English\n';
			}			
		}		
		if (document.form1.patgname.value == '') {
			if (msg.length == 0) focusField = document.form1.patgname;
			$(document.form1.patgname).parent().find('div#patgname').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '名 (英文)\n';
			}else{
				msg = msg + 'Given Name in English\n';
			}				
		}
		if ($('select[name=titleDesc] :selected').text() == '' && document.form1.titleDescOther.value == ''){
			if (msg.length == 0) focusField = document.form1.titleDesc;
			$(document.form1.titleDesc).parent().find('div#title').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '稱謂\n';
			}else{
				msg = msg + 'Title\n';
			}
		}
		if ($('select[name=patsex] :selected').text() == ''){
			if (msg.length == 0) focusField = document.form1.patsex;
			$(document.form1.patsex).parent().find('div#patsex').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '性別\n';
			}else{
				msg = msg + 'Sex\n';
			}
		}
		if (document.form1.patbdate.value == '') {
			if (msg.length == 0) focusField = document.form1.patbdate;
			$(document.form1.patbdate).parent().find('div#dateOfBirth').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '出生日期\n';
			}else{
				msg = msg + 'Date of Birth\n';
			}			
		} else if (!validDate(document.form1.patbdate)) {
			if (msg.length == 0) focusField = document.form1.patbdate;
			$(document.form1.patbdate).parent().find('div#dateOfBirth').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '輸入不正確出生日期.\n';
			}else{
				msg = msg + 'Invalid Date of Birth.\n';
			}			
		}		
		if (document.form1.patidType[0].checked) {
			if (document.form1.patidno1.value == '') {
				if (msg.length == 0) focusField = document.form1.patidno1;
				$(document.form1.patidno1).parent().find('div#hkid').addClass("hightLight");
				msg = msg + (count++) + '. ';
				if(document.form1.language.value =='chi'){			
					msg = msg + '香港身份證號碼\n';
				}else{
					msg = msg + 'Hong Kong I.D. Card\n';
				}					
			} else if (document.form1.patidno2.value == '') {
				if (msg.length == 0) focusField = document.form1.patidno2;
				$(document.form1.patidno1).parent().find('div#hkid').addClass("hightLight");
				msg = msg + (count++) + '. ';
				if(document.form1.language.value =='chi'){			
					msg = msg + '香港身份證號碼\n';
				}else{
					msg = msg + 'Hong Kong I.D. Card\n';
				}				
			} else if (document.form1.patidno1.value.length < 7) {
				if (msg.length == 0) focusField = document.form1.patidno1;
				$(document.form1.patidno1).parent().find('div#hkid').addClass("hightLight");
				if(document.form1.language.value =='chi'){			
					msg = msg + '輸入不正確香港身份證號碼.\n';
				}else{
					msg = msg + 'Invalid Hong Kong I.D. Card.\n';
				}				
			}
		}
		if (document.form1.patidType[1].checked && document.form1.patpassport.value == '') {
			if (msg.length == 0) focusField = document.form1.patpassport;
			$(document.form1.patpassport).parent().find('div#passport').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '護照號碼\n';
			}else{
				msg = msg + 'Passport No\n';
			}			
		}
		if (document.form1.patidType[2].checked && document.form1.pattraveldoc.value == '') {
			if (msg.length == 0) focusField = document.form1.pattraveldoc;
			$(document.form1.pattraveldoc).parent().find('div#traveldoc').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '旅遊證件號碼\n';
			}else{
				msg = msg + 'Travel Document No\n';
			}			
		}
		if ($('select[name=patmsts] :selected').text() == '' && document.form1.patmstsOther.value == ''){
			if (msg.length == 0) focusField = document.form1.patmsts;
			$(document.form1.patmsts).parent().find('div#patmsts').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '婚姻狀況\n';
			}else{
				msg = msg + 'Marital Status\n';
			}
		}
		if ($('select[name=religion] :selected').text() == '' && document.form1.religionOther.value == ''){
			if (msg.length == 0) focusField = document.form1.religion;
			$(document.form1.religion).parent().find('div#religion').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '信仰\n';
			}else{
				msg = msg + 'Religion\n';
			}
		}
		if ($('select[name=racedesc] :selected').text() == '' && document.form1.racedescOther.value == ''){
			if (msg.length == 0) focusField = document.form1.racedesc;
			$(document.form1.racedesc).parent().find('div#racedesc').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '國藉\n';
			}else{
				msg = msg + 'Nationality\n';
			}
		}
		if ($('select[name=mothcode] :selected').text() == ''){
			if (msg.length == 0) focusField = document.form1.mothcode;
			$(document.form1.mothcode).parent().find('div#mothcode').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '通訊語言\n';
			}else{
				msg = msg + 'Correspondence Language\n';
			}
		}
		if ($('select[name=edulevel] :selected').text() == '' && document.form1.edulevelOther.value == ''){
			if (msg.length == 0) focusField = document.form1.edulevel;
			$(document.form1.edulevel).parent().find('div#edulevel').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '教育程度\n';
			}else{
				msg = msg + 'Education Level\n';
			}
		}
		if (document.form1.patemail.value == ''){
			if (msg.length == 0) focusField = document.form1.patemail;
			$(document.form1.patemail).parent().find('div#patemail').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '電郵地址\n';
			}else{
				msg = msg + 'Email Address\n';
			}
		}
		if (document.form1.patmtel.value == ''){
			if (msg.length == 0) focusField = document.form1.patmtel;
			$(document.form1.patmtel).parent().find('div#patmtel').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '流動電話\n';
			}else{
				msg = msg + 'Mobile Phone\n';
			}
		}
		if ($('select[name=coucode] :selected').text() == '' && document.form1.patadd1.value == ''
			&& document.form1.patadd2.value == '' && document.form1.patadd3.value == ''){
			if (msg.length == 0) focusField = document.form1.padadd1;
			$(document.form1.patadd1).parent().find('div#patadd1').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '地址\n';
			}else{
				msg = msg + 'Address\n';
			}
		}		
		if (document.form1.patkfname1.value == '') {
			if ($('#optionalInformation1').css("display")=='none') clickOptionalInformation();
			if (msg.length == 0) focusField = document.form1.patkfname1;
			$(document.form1.patkfname1).parent().find('div#patkfname1').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '姓 (英文) (緊急聯絡人)\n';
			}else{
				msg = msg + 'Surname in English (Emergency Contact Person)\n';
			}			
		}	
		if (document.form1.patkgname1.value == '') {
			if ($('#optionalInformation1').css("display")=='none') clickOptionalInformation();
			if (msg.length == 0) focusField = document.form1.patkgname1;
			$(document.form1.patkgname1).parent().find('div#patkgname1').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '名 (英文) (緊急聯絡人)\n';
			}else{
				msg = msg + 'Given Names in English (Emergency Contact Person)\n';
			}			
		}	
		if ($('select[name=patkTitleDesc1] :selected').text() == '' && document.form1.patkTitleDescOther1.value == ''){
			if ($('#optionalInformation1').css("display")=='none') clickOptionalInformation();
			if (msg.length == 0) focusField = document.form1.patkTitleDesc1;
			$(document.form1.patkTitleDesc1).parent().find('div#patkTitleDesc1').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '稱謂 (緊急聯絡人)\n';
			}else{
				msg = msg + 'Title (Emergency Contact Person)\n';
			}
		}
		if (document.form1.patkmtel1.value == '') {
			if ($('#optionalInformation1').css("display")=='none') clickOptionalInformation();
			if (msg.length == 0) focusField = document.form1.patkmtel1;
			$(document.form1.patkmtel1).parent().find('div#patkmtel1').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '流動電話 (緊急聯絡人)\n';
			}else{
				msg = msg + 'Mobile Phone (Emergency Contact Person)\n';
			}			
		}	
		
		if ($('input[name=patHowInfo]:checked').length <= 0) {
			if (msg.length == 0) focusField = document.form1.patHowInfo;
			$('div#patHowInfo').addClass("hightLight");
			msg = msg + (count++) + '. ';
			if(document.form1.language.value =='chi'){			
				msg = msg + '認識本院的途徑 \n';
			}else{
				msg = msg + 'How did you hear about us\n';
			}
		}
		
		if (msg.length > 0 ) {
			if(document.form1.language.value =='chi'){			
				msg = '請選擇或輸入以下尚未載入的資料:\n\n' + msg + '\n';
			}else{
				msg = 'The following fields are missing.  Please choose or enter:\n' + msg + '\n';
			}
					
			if(document.form1.language.value =='chi'){			
				msg=msg +'\n如有任何查詢，請致電熱線電話 3651 8808\n';
			}else{
				msg=msg +'\nKindly contact our hotline at 3651 8808 if you need further assistance.\n';
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
			
			if(checkBox.length > 0){
				for (j = 0; j < checkBox.length; j++ ) {
					if(checkBox[j].checked == false){
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

	function validDOB(event) {
		if (document.form1.patno.value != '' && event.keyCode == 13) {
			document.form1.patbdate.focus();
		}
	}
	
	function checkHowInfoOther(){
		document.form1.patHowInfo[4].checked = true;
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

</script></DIV>

</DIV>
</DIV>
<jsp:include page="admission_footer.jsp" flush="false" />
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>