<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%> 
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>

<%
Boolean SaveFormAction = false;
Boolean completeFormAction = false;
Boolean newForm = false;
boolean loginAction = false;
ReportableListObject row = null;
ArrayList result = null;
ArrayList resultpl = null;
String plkey = "";
String pldesc = "";
String baID = null;
//String formType = "";
String q1 = "";

//
String[] ba_q = new String[5000];
String completed = "0";
String remark = "";
int cnt = 0;
String createDate = "";
String createTime = "";
String createmm = "";
String createhh = "";
//
String ccr_phase = "";
String formTypeOther = "";
String modifyDate = "";
String modifyTime = "";
String modifyUser = "";
String ultrasoundOthers = "";
String[] ultraOther1=request.getParameterValues("ultraOther1");
String[] ultraOther2=request.getParameterValues("ultraOther2");
if(ultraOther1 != null){	
    //for(String s : hatsSearchCodeArray1){
    	//ultrasoundOthers = ultrasoundOthers
    //}
    for (int i=0;i<ultraOther1.length;i++){
    	ultrasoundOthers = ultrasoundOthers + ultraOther1[i] + "<inner>" + ultraOther2[i] + "<outer>";  
    }
}
if ("<inner><outer>".equals(ultrasoundOthers)) {
	ultrasoundOthers = "";
}
String xrayOthers = "";
String[] xrayOther1=request.getParameterValues("xrayOther1");
String[] xrayOther2=request.getParameterValues("xrayOther2");
if(xrayOther1 != null){	
    //for(String s : hatsSearchCodeArray1){
    	//ultrasoundOthers = ultrasoundOthers
    //}
    for (int i=0;i<xrayOther1.length;i++){
    	xrayOthers = xrayOthers + xrayOther1[i] + "<inner>" + xrayOther2[i] + "<outer>";  
    }
}
if ("<inner><outer>".equals(xrayOthers)) {
	xrayOthers = "";
}
String otherOthers = "";
String[] otherOther1=request.getParameterValues("otherOther1");
String[] otherOther2=request.getParameterValues("otherOther2");
if(otherOther1 != null){	
    //for(String s : hatsSearchCodeArray1){
    	//ultrasoundOthers = ultrasoundOthers
    //}
    for (int i=0;i<otherOther1.length;i++){
    	otherOthers = otherOthers + otherOther1[i] + "<inner>" + otherOther2[i] + "<outer>";  
    }
}
if ("<inner><outer>".equals(otherOthers)) {
	otherOthers = "";
}

String command = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "command"));
String regID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "regID"));
String patNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patNo"));
String formMode = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mode"));
String seqNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "seqNo"));
String formType = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "formType"));
String regDate = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "regDate"));

String patName = "";
String patCName = "";
String patAge = "";
String patSex = "";
String patDob = "";
String patConNo = "";
String docCode = "";
String docName = "";
Boolean isMRStaff = false;

ReportableListObject reportableListObject = null;
boolean patientMode = false;
boolean nurseMode = false;
boolean finishSaving = false;

//String sessionKey = request.getParameter("session");
String language = request.getParameter("language");
String staffID = request.getParameter("staffID");
String haFormPatient = "patient";
seqNo = "1";

Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else {
	locale = Locale.US;
}

session.setAttribute( Globals.LOCALE_KEY, locale );
UserBean userBean = new UserBean(request);

// for detail entry 
String reqStatus = TextUtil.parseStrUTF8((String) request.getAttribute("reqStatus"));
String amtID = TextUtil.parseStrUTF8((String) request.getAttribute("amtID"));
//

//get Dr PickList
//resultpl = BAFormDB.fetchDRPL();

// get pat info
result = PatientDB.getPatInfo(patNo);
if (result.size() > 0) {
	reportableListObject = (ReportableListObject) result.get(0);
	patName = reportableListObject.getValue(3);
	patCName = reportableListObject.getValue(4);
	patAge = reportableListObject.getValue(5);
	patSex = reportableListObject.getValue(1);
	patDob = reportableListObject.getValue(10);
}

//docName = BAFormDB.getRegDocName(regID);

//if ("add".equals(formMode)) {
	// get the latest saved access form
	//baID = BAFormDB.getHALastestFormID(patNo);
//} if ("edit".equals(formMode)) {
	//baID = BAFormDB.getHAFormID(patNo, regID);
//}
//if ("BAFORM".equals(formType)) {
	//formType = null;
//}
//if (formType == null) {
	formType = "BAFORM";
//}

if (BAFormDB.isNewBAForm(patNo, regID, formType)) {
	newForm = true;
	baID = BAFormDB.getBALastestFormID(patNo, formType);
} else {
	newForm = false;
	baID = BAFormDB.getBAFormID(patNo, regID, formType);	
}

result = BAFormDB.fetchAccessForm(baID);
if(result.size() > 0) {
	row = (ReportableListObject) result.get(0);
	baID = row.getValue(1); 
	//regID = row.getValue(2);
	// Personal Background Section
	formType = row.getValue(8);
	ba_q[0] = row.getValue(19);
	ba_q[1] = row.getValue(20);
	ba_q[2] = row.getValue(21);
	// Personal Information Section
	ba_q[3] = row.getValue(22);
	ba_q[4] = row.getValue(23);
	ba_q[5] = row.getValue(24);
	ba_q[6] = row.getValue(25);
	ba_q[7] = row.getValue(26);
	ba_q[8] = row.getValue(27);
	ba_q[9] = row.getValue(28);
	ba_q[10] = row.getValue(29);
	ba_q[11] = row.getValue(30);
	ba_q[12] = row.getValue(31);
	ba_q[13] = row.getValue(32);
	ba_q[14] = row.getValue(33);
	ba_q[15] = row.getValue(34);
	// Breast symptoms
	ba_q[16] = row.getValue(35);
	ba_q[17] = row.getValue(36);
	ba_q[18] = row.getValue(37);
	ba_q[19] = row.getValue(38);
	ba_q[20] = row.getValue(39);
	ba_q[21] = row.getValue(40);
	ba_q[22] = row.getValue(41);
	ba_q[23] = row.getValue(42);
	ba_q[24] = row.getValue(43);
	ba_q[25] = row.getValue(44);
	ba_q[26] = row.getValue(45);
	ba_q[27] = row.getValue(46);
	ba_q[28] = row.getValue(47);
	ba_q[29] = row.getValue(48);
	ba_q[30] = row.getValue(49);
	ba_q[31] = row.getValue(50);
	ba_q[32] = row.getValue(51);
	ba_q[33] = row.getValue(52);
	ba_q[34] = row.getValue(53);
	ba_q[35] = row.getValue(54);
	ba_q[36] = row.getValue(55);
	ba_q[37] = row.getValue(56);
	ba_q[38] = row.getValue(57);
	ba_q[39] = row.getValue(58);
	// Past Medical History
	ba_q[40] = row.getValue(59);
	ba_q[41] = row.getValue(60);
	ba_q[42] = row.getValue(61);
	ba_q[43] = row.getValue(62);
	ba_q[44] = row.getValue(63);
	ba_q[45] = row.getValue(64);
	ba_q[46] = row.getValue(65);
	ba_q[47] = row.getValue(66);
	ba_q[48] = row.getValue(67);
	ba_q[49] = row.getValue(68);
	ba_q[50] = row.getValue(69);
	ba_q[51] = row.getValue(70);
	ba_q[52] = row.getValue(71);
	ba_q[53] = row.getValue(72);
	ba_q[54] = row.getValue(73);	
	ba_q[55] = row.getValue(74);	
	ba_q[56] = row.getValue(75);
	ba_q[57] = row.getValue(76);
	ba_q[58] = row.getValue(77);
	
	modifyUser = row.getValue(16);
	modifyDate = row.getValue(17);
	modifyTime = row.getValue(18);
	
	if (!newForm) { // no need to refill medical note 
	//	ba_q[6] = row.getValue(25);

	
		//ent_p[1] = row.getValue(133);
		docCode = BAFormDB.getRegDocCode(regID);
		docName = BAFormDB.getRegDocName(regID);
		
		if (("".equals(docCode)) || docCode == null) {
			docCode = row.getValue(3);
			docName = row.getValue(4);		
		}
		
		createDate = row.getValue(14);
		createTime = row.getValue(15);
		createhh = createTime.substring(0, 2);
		createmm = createTime.substring(3, 5);
		//15:31:03 
		//System.out.println(createTime);
		//System.out.println(createTime.substring(0, 2));
		//System.out.println(createTime.substring(3, 5));		
		patAge = row.getValue(7);
	}
	
	if (newForm) {
		result = BAFormDB.getNurseNote(patNo, regID, seqNo);
		if(result.size() > 0) {
			row = (ReportableListObject) result.get(0);
			//phy_1 = row.getValue(0);
			//phy_2 = row.getValue(1);
			//phy_3 = row.getValue(2);
			//phy_4 = row.getValue(3);
			//phy_6 = row.getValue(4);
			//phy_7 = row.getValue(5); //wt
			//phy_8 = row.getValue(6); //ht
			docCode = BAFormDB.getRegDocCode(regID); 
			docName = BAFormDB.getRegDocName(regID);
		} else {
			//phy_1 = "";
			//phy_2 = "";
		}
		//q1 =  "Routine Checking ??????";
	} else {
		completed = row.getValue(12);
	}
	
} else {
	////////////////////////////////////////
	// brand new patient for first ha form
	////////////////////////////////////////
	// get nurse note info
	result = BAFormDB.getNurseNote(patNo, regID, seqNo);
	if(result.size() > 0) {
		row = (ReportableListObject) result.get(0);
		//ba_q[0] = row.getValue(19);
		//ba_q[1] = row.getValue(20);
		//ba_q[2] = row.getValue(21);

		//phy_1 = row.getValue(0);
		//phy_2 = row.getValue(1);
		//phy_3 = row.getValue(2);
		//phy_4 = row.getValue(3);
		//phy_6 = row.getValue(4);
		//phy_7 = row.getValue(5); //wt
		//phy_8 = row.getValue(6); //ht
		docCode = BAFormDB.getRegDocCode(regID);
		docName = BAFormDB.getRegDocName(regID);
	}
	//q1 =  "Routine Checking ??????";
	//phy_5 = "";
	//phy_9 = "";
	//System.out.println("regDate : " + regDate);
	if ((regDate != "") && (regDate != null)) {
		createDate = regDate;
	} 
	else {
		//regDate = DateTimeUtil.getCurrentDateTime().substring(0, 10);
		createDate = DateTimeUtil.getCurrentDateTime().substring(0, 10);
	}
}

//init null value from database
for (int i=0;i<ba_q.length;i++){	 
	if (ba_q[i]==null ||"null".equals(ba_q[i])){
    	ba_q[i] = "";
	}	
}


if (language==null ||"".equals(language)){
 language="eng";
}

//if ("login".equals(command)) {
if (staffID != null && staffID.length() > 0) {
	loginAction = true;
}

if (loginAction) {
	if (haFormPatient.equals(staffID)) {
		patientMode = true;
		nurseMode = false;
	} else {
		patientMode = false;
		nurseMode = true;
		userBean = UserDB.getUserBean(request, staffID);		
	}	
}


isMRStaff = BAFormDB.isMRStaff(staffID);

//System.out.println("nurseMode : " + nurseMode);
//System.out.println("isMRStaff : " + isMRStaff);
System.out.println("staffID : " + staffID);
System.out.println("patNo : " + patNo);
System.out.println("regID : " + regID);
//System.out.println("seqNo : " + seqNo);
System.out.println("formType : " + formType);
//System.out.println("newForm : " + newForm);
System.out.println("baID : " + baID);

//System.out.println("command : " + command);
//System.out.println("loginAction : " + loginAction);
//System.out.println("eat_7 : " + eat_7);
//System.out.println("eat_8 : " + eat_8);
//System.out.println("eat_8 : " + eat_9);

if(command != null && command.equals("save_form")) {
	formType = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "formType"));
	q1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q1"));
	// Personal Background Section
	ba_q[0] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q0"));
	ba_q[1] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q1"));
	ba_q[2] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q2"));
	// Personal Information Section
	ba_q[3] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q3"));
	ba_q[4] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q4"));
	ba_q[5] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q5"));
	ba_q[6] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q6"));
	ba_q[7] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q7"));
	ba_q[8] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q8"));
	ba_q[9] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q9"));
	ba_q[10] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q10"));
	ba_q[11] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q11"));
	ba_q[12] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q12"));
	ba_q[13] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q13"));
	ba_q[14] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q14"));
	ba_q[15] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q15"));
	 // Breast symptoms
	ba_q[16] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q16"));
	ba_q[17] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q17"));
	ba_q[18] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q18"));
	ba_q[19] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q19"));
	ba_q[20] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q20"));
	ba_q[21] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q21"));
	ba_q[22] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q22"));
	ba_q[23] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q23"));
	ba_q[24] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q24"));
	ba_q[25] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q25"));
	ba_q[26] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q26"));
	ba_q[27] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q27"));
	ba_q[28] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q28"));
	ba_q[29] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q29"));
	ba_q[30] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q30"));
	ba_q[31] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q31"));
	ba_q[32] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q32"));
	ba_q[33] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q33"));
	ba_q[34] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q34"));
	ba_q[35] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q35"));
	ba_q[36] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q36"));
	ba_q[37] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q37"));
	ba_q[38] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q38"));
	ba_q[39] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q39"));
	// Past Medical History
	ba_q[40] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q40"));
	ba_q[41] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q41"));
	ba_q[42] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q42"));
	ba_q[43] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q43"));
	ba_q[44] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q44"));
	ba_q[45] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q45"));
	ba_q[46] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q46"));
	ba_q[47] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q47"));
	ba_q[48] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q48"));
	ba_q[49] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q49"));
	ba_q[50] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q50"));
	ba_q[51] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q51"));
	ba_q[52] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q52"));
	ba_q[53] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q53"));
	ba_q[54] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q54"));
	ba_q[55] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q55"));
	ba_q[56] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q56"));
	ba_q[57] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q57"));
	ba_q[58] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ba_q58"));
	
	remark = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark"));
	completed = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "completed"));
	
	createDate = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "date_from"));
	createhh = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_hh"));
	createmm = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_mi"));

	ccr_phase = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ccr_phase"));
	formTypeOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "inputSelectName"));
	
	SaveFormAction = true;

}
else if(command != null && command.equals("complete_form")) {	
	 
	completeFormAction = true;

} else {
	command = "view"; 
	SaveFormAction = false;
}

if(command != null) {
	if (SaveFormAction) { // save the form
		// check form input date (createdate) is null
		if ((createDate == "") || (createDate == null)) {
			createDate = DateTimeUtil.getCurrentDateTime().substring(0, 10);
		}
		//
		baID = BAFormDB.saveHAForm(userBean, regID, docCode, patNo, patAge, formType, staffID, createDate, createhh, createmm, ba_q);
		//
		SaveFormAction = false;
		finishSaving = true;
		//command = "view";
																			   
		//response.sendRedirect("breast_assess_form.jsp?command=view&staffID=" + staffID + "&patNo=" + patNo + "&regID=" + regID + "&seqNo=" + seqNo + "&formType=" + formType);
	} else if (completeFormAction) { // Complete the form
		BAFormDB.completeHAForm(baID, completed);
	
		completeFormAction = false;
		//command = "view";
		response.sendRedirect("breast_assess_form.jsp?command=view&staffID=" + staffID + "&patNo=" + patNo + "&regID=" + regID + "&seqNo=" + seqNo + "&formType=" + formType);
	}

	if (!"view".equals(command)) {
		command = "view";
		//response.sendRedirect("breast_assess_form.jsp?command=view&staffID=" + staffID + "&patNo=" + patNo + "&regID=" + regID);
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
		.career_form table.table1 {			
			border: 1px solid #ddd;
		}
		.career_form table.table2 {			
			border: 1px solid #ddd;
		}
		td {
	    		padding: 5px; 
		}			
		
		
	</style>
</head>
<body>
<div id=wrapper class="wrapper" style="background-color:white;">
<div style="background-color:white;">
<div class="normal_area">
<div class="career_form" style="padding: 20px 18px;">
<form name="form1" action="breast_assess_form.jsp" method="post">
<table class="table1" style="width: 100%">
	<tr>	
		<td style="background: #B404AE; color: white"><font size="3"><b>乳房健康中心 : 個人健康問卷 </br> Breast Health Center Personal Health Questionnaire</b></font></td>		
		<td>
		<table border=0>
			<tr>
			<td>檢查日期 Date of Screening : 
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=createDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"></input></td>			
			<td  width="30%">檢查時間 Time: 
				<jsp:include page="../ui/timeCMB.jsp" flush="false">
				<jsp:param name="label" value="timeOfOccurrence" />
				<jsp:param name="time" value='<%=((createhh==null||createmm==null)?"":(createhh+":"+createmm)) %>' />																		
				<jsp:param name="allowEmpty" value="Y" />
				<jsp:param name="defaultValue" value='<%=((createhh==null||createmm==null))?"N":"Y"%>' />
				</jsp:include>
			</td>
			</tr>
			<tr>
			<td>更改日期  Modify Date: <%if (newForm) {%><%=DateTimeUtil.getCurrentDate()%><% } else {%><%=modifyDate%><%} %></td>
			<td>更改時間 ModifyTime: <%if (newForm) {%><%=DateTimeUtil.getCurrentTime()%><% } else {%><%=modifyTime%><%} %></td>
			<td>更改員工 Modify Staff: <%if (newForm) {%><%=""%><% } else {%><%=modifyUser%><%} %></td>
			</tr>
		</table>
		</td>
	</tr>	
</table>	
<table class="table2" width="100%" border=0>
			<tr>
			<td>
			<table class="table2" border=0 width=1000> 
			<tr>
				<td>
					<table>
					<tr>
						<td>姓名 Name&nbsp;<input type="text" name="patName" value="<%=patName%>" readonly size=40></input></td>
						<td>中文姓名 Chinese Name&nbsp;<input type="text" name="patCName" value="<%=patCName%>" readonly size=10></input></td>
						<td>年齡  Age&nbsp;<input type="text" name="patAge" value="<%=patAge%>" readonly size=8></input></td>
						<td>性別 Sex&nbsp;<input type="text" name="patSex" value="<%=patSex%>" readonly size=1></input></td>
						<td>出生日期 DOB&nbsp;<input type="text" name="patDob" value="<%=patDob%>" readonly size=7></input></td>	
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table>
					<tr>
						<td>登記號碼 Hospital No&nbsp;<input type="text" name="patno" value="<%=patNo%>" readonly size=5></input></td>
						<td>房號  Consultation No&nbsp;<input type="text" name="patConNo" value="<%=patConNo%>" readonly size=5></input></td>
						<%-- TEMP --%>					
					</tr>
					</table>
				</td>
			</tr>
			</table>
			</td>
			</tr>
	<tr>
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td style="background: #F5A9F2;">			
				個人資料 Personal Background
				</td>
			</tr>
			<tr>
			<td>
			<table class="table2" border=0 width=1000>
				<tr>
				<td>
					<table border=0>
						<tr>
							<td>教育程度 Education Level&nbsp;</td>
							<td><input type="radio" name="ba_q0" value="P" <%if ("P".equals(ba_q[0])) {%>checked<%} %>></input>小學 Primary</td>
							<td><input type="radio" name="ba_q0" value="S" <%if ("S".equals(ba_q[0])) {%>checked<%} %>></input>中學 Secondary</td>
							<td><input type="radio" name="ba_q0" value="T" <%if ("T".equals(ba_q[0])) {%>checked<%} %>></input>大學 Tertiary</td>
						</tr>
					</table>		
				</td>
				</tr>
				<tr>
					<td>
					<table>
					<tr><td>
						職業 Occupation&nbsp;<input type="text" name="ba_q1" value="<%=ba_q[1]%>" size=60></input>
					</td></tr>
					</table>
					</td>
				</tr>
			</table>
			</td>
			</tr>
	</table>
	</td>
	</tr>
	<tr>
	<td>
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			個人病歷 Personal Information
			</td>
		</tr>
		<tr>
		<td>
			<%--
			<table border=0>
			 --%>
			<table class="table2" border=0 width=1100>
				<tr>
					<td>現有身體疾病 Present illness / disease&nbsp;</td>
					<td><input type="checkbox" name="ba_q2" value="1" <%if ("1".equals(ba_q[2])) {%>checked<%} %>></input>糖尿病</br>Diabetes</td>
					<td><input type="checkbox" name="ba_q3" value="1" <%if ("1".equals(ba_q[3])) {%>checked<%} %>></input>高血壓</br>Hypertension</td>
					<td><input type="checkbox" name="ba_q4" value="1" <%if ("1".equals(ba_q[4])) {%>checked<%} %>></input>心臟病</br>Heart Disease</td>
					<td><input type="checkbox" name="ba_q5" value="1" <%if ("1".equals(ba_q[5])) {%>checked<%} %>></input>癌病</br>Cancer</td>
					<td><input type="checkbox" name="ba_q6" value="1" <%if ("1".equals(ba_q[6])) {%>checked<%} %>></input>其他</br>Others</td>
					<td><textarea name="ba_q7" rows="3" cols="45"><%=ba_q[7]%></textarea></td>
				</tr>
			</table>		
		</td>
		</tr>
		<tr>
		<td>
			<%--
			<table border=0>
			 --%>
			<table class="table2" border=0 width=1100>
				<tr>
					<td>正在使用的藥物 Present medication</td>
					<td><input type="radio" name="ba_q8" value="0" <%if ("0".equals(ba_q[8]) || "".equals(ba_q[8])) {%>checked<%} %>></input>無 No</td>
					<td><input type="radio" name="ba_q8" value="1" <%if ("1".equals(ba_q[8])) {%>checked<%} %>>有 Yes</td>
					<td><textarea name="ba_q9" rows="3" cols="50"><%=ba_q[9]%></textarea></td>
				</tr>
				<tr>
					<td>(使用荷爾蒙或避孕藥 On hormonal treatment or contraceptive)</td>
					<td><input type="radio" name="ba_q10" value="0" <%if ("0".equals(ba_q[10]) || "".equals(ba_q[10])) {%>checked<%} %>></input>無 No</td>
					<td><input type="radio" name="ba_q10" value="1" <%if ("1".equals(ba_q[10])) {%>checked<%} %>>有 Yes</td>
					<td><textarea name="ba_q11" rows="3" cols="50"><%=ba_q[11]%></textarea></td>				
				</tr>
				<tr>				
					<td>正服用抗凝血藥物  Taking anticoagulant drug (如: 阿士匹靈 e.g. Aspirin, Warfarin)</td>
					<td><input type="radio" name="ba_q12" value="0" <%if ("0".equals(ba_q[12]) || "".equals(ba_q[12])) {%>checked<%} %>></input>無 No</td>				
					<td><input type="radio" name="ba_q12" value="1" <%if ("1".equals(ba_q[12])) {%>checked<%} %>></input>有 Yes</td>
					<td><textarea name="ba_q13" rows="3" cols="50"><%=ba_q[13]%></textarea></td>				
				</tr>
				<tr>
					<td><div align="left">生活習慣 Social Habits</div><div align="right">吸煙 Smoking</div></td>													
					<td><div align="left">&nbsp;</div><input type="radio" name="ba_q14" value="0" <%if ("0".equals(ba_q[14]) || "".equals(ba_q[14])) {%>checked<%} %>>無 No</input></td>									
					<td><div align="left">&nbsp;</div><input type="radio" name="ba_q14" value="1" <%if ("1".equals(ba_q[14])) {%>checked<%} %>>有 Yes</input></td>
					<td><div align="left">&nbsp;</div><input type="radio" name="ba_q14" value="2" <%if ("2".equals(ba_q[14])) {%>checked<%} %>>曾有 Ex</input></td>
				</tr>
				<tr>
				<td><div></div><div align="right">飲酒 Drinking</div></td>
				<td><input type="radio" name="ba_q15" value="0" <%if ("0".equals(ba_q[15]) || "".equals(ba_q[15])) {%>checked<%} %>>無 No</input></td>								
				<td><input type="radio" name="ba_q15" value="1" <%if ("1".equals(ba_q[15])) {%>checked<%} %>>有 Yes</input></td>
				<td><input type="radio" name="ba_q15" value="2" <%if ("2".equals(ba_q[15])) {%>checked<%} %>>曾有 Ex</input></td>
				</tr>							
			</table>		
		</td>
		</tr>
		</table>
	</td>
	</tr>
	<tr>
		<td> 
			<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="background: #F5A9F2;">			
				乳房病徵 Breast Symptoms:
				</td>
			</tr>
			<tr>
			<td>
			<table class="table2" border=0 width=1100>
				<tr>
					<td width="50%">乳房問題 Breast Problems</td>					
					<td width="10%">左 Left</td>
					<td width="10%">發現多久 How Long</td>
					<td width="10%">右 Right</td>
					<td width="10%">發現多久 How Long</td>
				</tr>
				<tr>
				<td>乳房腫塊 Breast lump</td>
				<td><input type="checkbox" name="ba_q16" value="1" <%if ("1".equals(ba_q[16])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q17" value="<%=ba_q[17]%>" size=1></input>&nbsp;Month 月</td>
				<td><input type="checkbox" name="ba_q18" value="1" <%if ("1".equals(ba_q[18])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q19" value="<%=ba_q[19]%>" size=1></input>&nbsp;Month 月</td>
				</tr>
				<tr>
				<td>乳頭有分泌物 Discharge from nipple</td>
				<td><input type="checkbox" name="ba_q20" value="1" <%if ("1".equals(ba_q[20])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q21" value="<%=ba_q[21]%>" size=1></input>&nbsp;Month 月</td>
				<td><input type="checkbox" name="ba_q22" value="1" <%if ("1".equals(ba_q[22])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q23" value="<%=ba_q[23]%>" size=1></input>&nbsp;Month 月</td>
				</tr>
				<tr>
				<td>乳房凹凸 Nipple is retracted</td>
				<td><input type="checkbox" name="ba_q24" value="1" <%if ("1".equals(ba_q[24])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q25" value="<%=ba_q[25]%>" size=1></input>&nbsp;Month 月</td>
				<td><input type="checkbox" name="ba_q26" value="1" <%if ("1".equals(ba_q[26])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q27" value="<%=ba_q[27]%>" size=1></input>&nbsp;Month 月</td>
				</tr>
				<tr>
				<td>乳房大小不同 Breast size change</td>
				<td><input type="checkbox" name="ba_q28" value="1" <%if ("1".equals(ba_q[28])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q29" value="<%=ba_q[29]%>" size=1></input>&nbsp;Month 月</td>
				<td><input type="checkbox" name="ba_q30" value="1" <%if ("1".equals(ba_q[30])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q31" value="<%=ba_q[31]%>" size=1></input>&nbsp;Month 月</td>
				</tr>				
				<tr>
				<td>乳房痛 Breast painful</td>
				<td><input type="checkbox" name="ba_q32" value="1" <%if ("1".equals(ba_q[32])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q33" value="<%=ba_q[33]%>" size=1></input>&nbsp;Month 月</td>
				<td><input type="checkbox" name="ba_q34" value="1" <%if ("1".equals(ba_q[34])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q35" value="<%=ba_q[35]%>" size=1></input>&nbsp;Month 月</td>
				</tr>
				<tr>
				<td>乳房/乳頭皮膚問題 Skin problem of breast/nipple<br/>e.g. Eczematous, ulcerated 如:濕疹, 皮膚脫落, 皮膚潰爛</td>
				<td><input type="checkbox" name="ba_q36" value="1" <%if ("1".equals(ba_q[36])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q37" value="<%=ba_q[37]%>" size=1></input>&nbsp;Month 月</td>
				<td><input type="checkbox" name="ba_q38" value="1" <%if ("1".equals(ba_q[38])) {%>checked<%} %>></input></td>
				<td><input type="text" name="ba_q39" value="<%=ba_q[39]%>" size=1></input>&nbsp;Month 月</td>
				</tr>				
			</table>		
		</td></tr>
		</table>
		</td>
	</tr>
	<tr>
		<td> 
			<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="background: #F5A9F2;">			
				過去身體狀況 Past Medical History: 
				</td>
			</tr>
			<tr>
			<td>
			<table class="table2" border=0 width=1100>
				<tr>
					<td width="50%">第一次月經年齡 Menarche age</td>
					<td><input type="text" name="ba_q40" value="<%=ba_q[40]%>" size=2></input>歲 Age</td>
				</tr>
				<tr>
					<td width="50%">停經年齡 Menopause age</td>
					<td><input type="text" name="ba_q41" value="<%=ba_q[41]%>" size=2></input>歲 Age</td>
				</tr>
				<tr>
					<td width="50%">上次第一天的經期日子 Last menstruation period</td>
					<td><input type="textfield" name="ba_q42" id="ba_q42" class="datepickerfield" value="<%=ba_q[42]%>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"></input></td>
				</tr>
				<tr>
					<td width="50%">總懷孕次數 Number of pregnancy</td>
					<td><input type="text" name="ba_q43" value="<%=ba_q[43]%>" size=2></input>次 Time</td>
				</tr>
				<tr>
					<td width="50%">總生產次數 Number of Delivery&nbsp;</td>
					<td><input type="text" name="ba_q58" value="<%=ba_q[58]%>" size=2></input>&nbsp;次 Time</td>
				</tr>
				<tr>
					<td width="50%">第一次生產年齡 First No. of Delivery at age of </td>
					<td><input type="text" name="ba_q44" value="<%=ba_q[44]%>" size=2></input> 歲 Age</td>
				</tr>					
				<tr>
					<td width="50%">曾否餵哺母乳 Breast-feed experience </td>
					<td><input type="radio" name="ba_q45" value="0" <%if ("0".equals(ba_q[45]) || "".equals(ba_q[45])) {%>checked<%} %>>無 No</input>								
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="ba_q45" value="1" <%if ("1".equals(ba_q[45])) {%>checked<%} %>>有 Yes</input></td>
				</tr>
				<tr>
					<td width="50%">曾否做過乳房手術 Breast surgery done </td>
					<td><input type="radio" name="ba_q46" value="0" <%if ("0".equals(ba_q[46]) || "".equals(ba_q[46])) {%>checked<%} %>>無 No</input>								
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="ba_q46" value="1" <%if ("1".equals(ba_q[46])) {%>checked<%} %>>有 Yes</input>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" name="ba_q47" value="1" <%if ("1".equals(ba_q[47])) {%>checked<%} %>>左 Left </input>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" name="ba_q48" value="1" <%if ("1".equals(ba_q[48])) {%>checked<%} %>>右 Right</input></td>
				</tr>
				<tr>
				<td width="50%">曾否接受乳房檢查 Breast screening test&nbsp;</td>
				<td>
					<input type="checkbox" name="ba_q49" value="1" <%if ("1".equals(ba_q[49])) {%>checked<%} %>>乳房超聲波 Breast Ultrasound</input>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="ba_q50" value="1" <%if ("1".equals(ba_q[50])) {%>checked<%} %>> 乳房造影 Mammogram</input>
				</td>
				</tr>
				<tr>
					<td></td>
					<td>
					<input type="checkbox" name="ba_q51" value="1" <%if ("1".equals(ba_q[51])) {%>checked<%} %>> Mammotome</input>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="ba_q52" value="1" <%if ("1".equals(ba_q[52])) {%>checked<%} %>> 幼針管抽吸術 FNAC </input>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="ba_q53" value="1" <%if ("1".equals(ba_q[53])) {%>checked<%} %>> 組織切片檢查 Biopsy </input>
					</td>
				</tr>
				<tr>
					<td width="50%">家族人士患有乳癌/卵巢癌 Family history of breast cancer/ovarian cancer </td>
					<td><input type="radio" name="ba_q54" value="0" <%if ("0".equals(ba_q[54]) || "".equals(ba_q[54])) {%>checked<%} %>>無 No</input></td>
				</tr>
				<tr>
				<td></td>
				<td><input type="radio" name="ba_q54" value="1" <%if ("1".equals(ba_q[54])) {%>checked<%} %>>有 Yes</input>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" name="ba_q55" value="1" <%if ("1".equals(ba_q[55])) {%>checked<%} %>> 乳癌 Breast Cancer</input>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" name="ba_q56" value="1" <%if ("1".equals(ba_q[56])) {%>checked<%} %>>卵巢癌 Ovarian Cancer</input>
				</tr>
				<tr>
				<td></td>
				<td>關係 Relationship <textarea name="ba_q57" rows="3" cols="50"><%=ba_q[57]%></textarea></td>				
				</tr>				
			</table>
			</td>
			</tr>
			</table>
		</td>
	</tr>	
</table>
<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
	<td>
	</td>
	</tr>
	<tr>
	<td>
		<table width="100%" border=0>
			<tr><td align="center">	
		<% 
			if ("0".equals(completed)) {
		%>
		
		
			<%
				if (patientMode) {
			%>		
	
			<button type="submit" onclick="return showconfirm('save_form');">
				儲存 Save
			</button>
			</td></tr>
			<%
				}
			%>
			<%
				if (nurseMode) {
			%>		
			<tr><td align="center">
			<button onclick="return showconfirm('save_form');">
				Save Form
			</button>
			
			<%
				}
			%>
		
		<% 
			}
		%>
		
		<%
			if (!patientMode) {
		%>
			<%
				if (!formType.substring(0, 3).equals("CCR")) {	
			%>
				<button onclick="return printReport('pdfAction', '<%=baID %>');">
					Print
				</button>
			<%
				} else { 
			%>
				<button onclick="return printReport('pdfAction', '<%=baID %>', '<%=formType%>');">
					Print
				</button>
			
			<%
				}
			%>
		<%
			}
		%>
		
		
		<%
		//	if (isMRStaff) {
			if (1==2) {
		%>
		<button onclick="return showconfirm('complete_form');">
			<%if ("0".equals(completed)) { %>Set Form Completed<% } else {%>Set Form Incompleted<%}%>
		</button>
		<%
			}
		%>
			</td>
			</tr>
		</table>
	</td>
	</tr>
	
</table>
<input type="hidden" name="command" value="<%=command%>"/>
<input type="hidden" name="staffID" value="<%=staffID%>"/>
<input type="hidden" name="regID" value="<%=regID%>"/>
<input type="hidden" name="seqNo" value="<%=seqNo%>"/>
<input type="hidden" name="patNo" value="<%=patNo%>"/>
<input type="hidden" name="completed" value="<%=completed%>"/>
<input type="hidden" name="formType" value="<%=formType%>"/>
<input type="hidden" name="docCode" value="<%=docCode%>"/>

</form>
</div>
<table><tr><td></td></tr></table>
</div>
</div>
</div>

<script language="javascript">
var selectName = 'formType';
$('select[name='+selectName+']').change(function() {
	var formTypeValue = $(this).find(":selected").html();
	if(formTypeValue == 'Other'){
		$('#freetextSpan').show();
		//$('input[name=inputSelectName]').attr('visibility', 'visible');
	}else{
		//$('#freetextSpan').html('');
		$('#freetextSpan').hide();
		//$('input[name=inputSelectName]').attr('visibility', 'hidden');
	}
});

$(document).ready(function() {
	$('select[name="formType"]').change();
});

var i = 1;
function createItem(divname){
	//alert(divname);
	if (divname == 'ultraOther') {
	     $("<p id='"+i+"test'><input type='text' name='ultraOther1' size='20' /> <input type='text' name='ultraOther2' size='100' /> <a href='javascript:void(0);' onclick='javascript:return remove("+i+");'><img src='../images/minus.gif' width='10' height='10'></a></p>").appendTo('div#ultraOther');		
	} else if (divname == 'xrayOther') {
		$("<p id='"+i+"test'><input type='text' name='xrayOther1' size='20' /> <input type='text' name='xrayOther2' size='100' /> <a href='javascript:void(0);' onclick='javascript:return remove("+i+");'><img src='../images/minus.gif' width='10' height='10'></a></p>").appendTo('div#xrayOther');		
	} else if (divname == 'otherOther') {
		$("<p id='"+i+"test'><input type='text' name='otherOther1' size='20' /> <input type='text' name='otherOther2' size='100' /> <a href='javascript:void(0);' onclick='javascript:return remove("+i+");'><img src='../images/minus.gif' width='10' height='10'></a></p>").appendTo('div#otherOther');		
	}
     i++;
     return false;
}

function remove(removeID){ 
     var id = removeID + 'test';
     $( "#" + id ).remove();
     return false;
}

function printReport(action, baID) {
	if(action == 'pdfAction') {					
			callPopUpWindow("print_report_ba.jsp?command="+action+"&baID="+baID+"&formType=BAFORM");

		
	}	
	return false;
}

function updateText(pickname, editname){
    var input = $('#' + editname);
    input.val(input.val() + $('#' + pickname).find(":selected").attr('value') + '\n');
    
}

function submitAction(cmd) {
	var msg = '';
	//if (document.form1.q1.value == '') {
		//msg = msg + '???????\nPlease input Present Chief Complaints\n';
		//alert(msg);
		//$("input[name=patNo]").focus();
		//$("textarea[name=q1]").focus();
		//// alert($(focusField).css());
		//return false;
	//} else {
		//alert('Saving.....' + cmd);
		document.form1.command.value = cmd;		
		document.form1.submit();
	//}
}

$(document).ready(function() {
	$("textarea[name=q1]").focus();
	
	ReadonlyForm(<%if ("1".equals(completed)) {%>true<%} else {%>false<%} %>);
	<%
	System.out.println("finishSaving : " + finishSaving);
	if (finishSaving){
	%>
		alert('Form Saved')
		location.replace('breast_assess_form.jsp?command=view&staffID=<%=staffID%>&patNo=<%=patNo%>&regID=<%=regID%>&seqNo=<%=seqNo%>&formType=<%=formType%>');
	<%
	}
	%>
	});


function ReadonlyForm(Formcomplete){
	
	if (Formcomplete) {
		$('div.career_form input[type=text]').attr("readonly","readonly");
		$("div.career_form input:radio").attr('disabled',true);
		$("div.career_form input[type=checkbox]").attr('disabled',true);
		$('div.career_form textarea').attr("readonly","readonly");
	}

	return true;
}


function changeLang(lang){
	alert(document.form1.action);
	return false;
}

function closeAction() {
	//var yes = confirm("Are you sure to close this page?\nThe admission form will be removed.");
	var yes = true;
	if (yes) {
		window.open('', '_self', '');
		window.close();
	}
}

function checkSelect_tmp() {
    if ($("input[id='1']:checked").val()) {
         if ($("input[id='7']:checked").val() ||
        	 $("input[id='8']:checked").val() ||
        	 $("input[id='9']:checked").val() ||
        	 $("input[id='10']:checked").val()) {
                jQuery("#2").attr('checked', $("input[id='7']:checked").val());
                jQuery("#3").attr('checked', $("input[id='8']:checked").val());
                jQuery("#4").attr('checked', $("input[id='9']:checked").val());
                jQuery("#5").attr('checked', $("input[id='10']:checked").val());
             	jQuery("#7").attr('checked', false);
             	jQuery("#8").attr('checked', false);
             	jQuery("#9").attr('checked', false);
             	jQuery("#10").attr('checked', false);                
         }
    } else if ($("input[id='6']:checked").val()) {
         if ($("input[id='2']:checked").val() ||
        	 $("input[id='3']:checked").val() ||
        	 $("input[id='4']:checked").val() ||
        	 $("input[id='5']:checked").val()) {
                jQuery("#7").attr('checked', $("input[id='2']:checked").val());
                jQuery("#8").attr('checked', $("input[id='3']:checked").val());
                jQuery("#9").attr('checked', $("input[id='4']:checked").val());
                jQuery("#10").attr('checked', $("input[id='5']:checked").val());
             	jQuery("#2").attr('checked', false);
             	jQuery("#3").attr('checked', false);
             	jQuery("#4").attr('checked', false);
             	jQuery("#5").attr('checked', false);
         }
    }           
}

function checkSelect2_tmp() {
	if ($("input[id='2']:checked").val() ||
			$("input[id='3']:checked").val() ||
			$("input[id='4']:checked").val()||
			$("input[id='5']:checked").val()) {
           jQuery("#1").attr('checked', true);
           jQuery("#6").attr('checked', false);
   } else if ($("input[id='7']:checked").val() ||
		   $("input[id='8']:checked").val() ||
		   $("input[id='9']:checked").val() ||
		   $("input[id='10']:checked").val()) {
	   jQuery("#1").attr('checked', false);
       jQuery("#6").attr('checked', true);
   }           

}

function showconfirm(cmd) {
	var msg = '';

	if (cmd == 'save_form') {
		msg = 'Are you sure to save this record ?\n 確定儲存 ?\n';
	} else if (cmd == 'complete_form') {
		msg = 'Are you sure ?';
	}
	$.prompt(msg, {
		buttons: { Ok: true, Cancel: false },
		callback: function(v,m,f){
			if (v ){
				var x=document.forms["form1"]["ba_q17"].value;
				var y=document.forms["form1"]["ba_q19"].value;
				  if (isNaN(x) || isNaN(y)) 
				  {
				    alert("<Breast lump> month should be a number");
				    return false;
				  } else {
					x=document.forms["form1"]["ba_q21"].value;
					y=document.forms["form1"]["ba_q23"].value;
				    if (isNaN(x) || isNaN(y)) {
				      alert("<Discharge from nipple> month should be a number");
					  return false;
				  	} else {
						x=document.forms["form1"]["ba_q25"].value;
						y=document.forms["form1"]["ba_q27"].value;
						if (isNaN(x) || isNaN(y)) {
						  alert("<Nipple is retracted> month should be a number");
						  return false;
						} else {
							x=document.forms["form1"]["ba_q29"].value;
							y=document.forms["form1"]["ba_q31"].value;
							if (isNaN(x) || isNaN(y)) {
							  alert("<Breast size changed> month should be a number");
							  return false;							
							} else {
								x=document.forms["form1"]["ba_q33"].value;
								y=document.forms["form1"]["ba_q35"].value;
								if (isNaN(x) || isNaN(y)) {
								  alert("<Breast painful> month should be a number");
								  return false;								
								} else {
									x=document.forms["form1"]["ba_q37"].value;
									y=document.forms["form1"]["ba_q39"].value;
									if (isNaN(x) || isNaN(y)) {
								  	  alert("<Skin problem of breast/nipple> month should be a number");
								  	return false;
									} else {
										x=document.forms["form1"]["ba_q40"].value;
										if (isNaN(x)) {
									  	  alert("<Menarche age> should be a number");
									  	return false;
										} else {
											x=document.forms["form1"]["ba_q41"].value;
											if (isNaN(x)) {
										  	  alert("<Menopause age> should be a number");
										  	return false;
											} else {
												x=document.forms["form1"]["ba_q43"].value;
												if (isNaN(x)) {
											     alert("<Number of pregnancy> should be a number");
											  	return false;
												} else {
													x=document.forms["form1"]["ba_q44"].value;
													if (isNaN(x)) {
												  	  alert("<First No. of Delivery at age of> should be a number");
												  	return false;
													}
												}
											}
										}
									}
								}
							}
				  		}
				  	}
				  }
				  submitAction(cmd);									
			}
		},
		prefix:'cleanblue'
	});
	return false;
}

function isInt(x) {
	Alert(x % 1 == 0);
	return x % 1 === 0;
}

</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>