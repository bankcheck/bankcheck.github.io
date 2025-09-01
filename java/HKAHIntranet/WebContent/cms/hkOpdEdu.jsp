<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%
UserBean userBean = new UserBean(request);
//String userID = userBean.getStaffID();
//String userName = StaffDB.getStaffName(userID);
//String updateUser = staffName;
String userId = request.getParameter("user");
String username = CMSDB.getCISusername(userId);

String dept = request.getParameter("dept");
String readonly = request.getParameter("readonly");

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

Calendar calendar = Calendar.getInstance();
String currentDate = DateTimeUtil.formatDateTime(calendar.getTime());

String formID = "hkOpdEdu";

String command = request.getParameter("command");
String regid = request.getParameter("regid");
//main form
//String txMain = request.getParameter("txMain");
String txMain = TextUtil.parseStrUTF8(request.getParameter("txMain"));
//subform
//String txEduRec = request.getParameter("txEduRec");
String txEduRec = TextUtil.parseStrUTF8(request.getParameter("txEduRec"));

//String patno = null;
String patno = request.getParameter("patno");

String sex = null;
String patname = null;
String dob = null;
String eduLevel = null;
String room = PatientDB.getRoom(regid);
boolean disable = false;
String lang = null;

if ("Y".equals(readonly)) {
	disable = true;
}

JSONObject formData = new JSONObject();

try {
	if (patno == null) {
		patno = CMSDB.getRefKey1(formID, regid );
	}
	
	ArrayList patRec = null;
	
	if ( (patno != null) && (patno.length() > 0) ) {
		patRec = PatientDB.getPatInfo(patno);
	} else {
		patRec = PatientDB.getPatInfoByRegid(regid);
	}
	
	//ArrayList patRec = PatientDB.getPatInfoByRegid(regid);
	if (patRec.size() > 0) {
		ReportableListObject row = (ReportableListObject) patRec.get(0);
		patno = row.getValue(0);
		sex = row.getValue(1);
		patname = row.getValue(3);
		dob = row.getValue(10);
		lang = row.getValue(20);
		eduLevel = row.getValue(22);
	} else {
		message = "Patient reord not found";
		disable = true;
	} 
			
	JSONParser jParser = null;
	Object obj = null;
	JSONArray sect = null;
		
	//System.out.println("[DEBUG] " + formID + " regid=" + regid + " dept=" + dept + " command=" + command);		
	
	if ("save".equals(command) || "report".equals(command)){
		
		if ((txMain.length() != 0) && (txMain != null)) {
			//System.out.println(txMain);
			jParser = new JSONParser();
			obj =  jParser.parse(txMain);
			sect = (JSONArray)obj;
			formData.put("main", sect);
		}
		
		if ((txEduRec.length() != 0) && (txEduRec != null)) {
			//System.out.println(txEduRec);
			jParser = new JSONParser();
			obj =  jParser.parse(txEduRec);
			sect = (JSONArray)obj;		
			formData.put("eduRec", sect);
		}

		if (CMSDB.setForm(formID, regid, dept, formData, userId, patno)) {
			
			message = formID + " saved.";
			
		} else {
			
			errorMessage = "Failed to save " + formID;
			System.out.println("[hkOpdEdu] setForm " + formID +  " error:" + errorMessage);
			
		}
		
	} 
	
	if ("report".equals(command) || "Y".equals(readonly)) {
		
		formData = CMSDB.getForm(formID, regid, dept);
		obj = formData.get("main");
		JSONObject main = null;
		
		if (obj == null) {
			message = "Reord has not been saved";
			return;
		} else {
			sect =  (JSONArray)obj;
			main = (JSONObject)sect.get(0);
		}
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select ");
		sqlStr.append("	max(DECODE(fld, 'dtEdu', val)) dtEdu, ");
		sqlStr.append("	max(DECODE(fld, 'txContent', val)) txContent, ");
		sqlStr.append("	max(DECODE(fld, 'seLearner', val)) seLearner, ");
		sqlStr.append("	max(DECODE(fld, 'seMethod', val)) seMethod, ");
		sqlStr.append("	max(DECODE(fld, 'seResponse', val)) seResponse, ");
		sqlStr.append("	max(DECODE(fld, 'seNeed', val)) seNeed, ");
		sqlStr.append(" max(DECODE(fld, 'seDiscipline', val)) seDiscipline, ");
		sqlStr.append(" max(DECODE(fld, 'txComment', val)) txComment ");
		sqlStr.append(" from gen_form@cis "); 																		
		sqlStr.append(" where form_id = '" + formID + "' ");
		sqlStr.append(" and key1 = ? ");
		sqlStr.append(" and key2 = ? "); 
		sqlStr.append(" and key3 = '0' ");
		sqlStr.append(" and sect_id = 'eduRec' ");
		sqlStr.append(" group by key1, key2, key3, sect_id, sect_seq ");
		sqlStr.append(" order by sect_seq ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{ regid, dept });

		File reportFile = new File(application.getRealPath("/report/RPT_EDU_DISCHARGE_HK.jasper"));
		if (reportFile.exists()) {
			
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
			
			Map parameters = new HashMap();
			File reportDir = new File(application.getRealPath("/report/"));
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("PATNO", patno);
			parameters.put("NAME", patname);
			parameters.put("DOB", dob);
			parameters.put("SEX", sex);
			parameters.put("ROOM", room);		
			
			String preference = null;
			if ( "true".equals((String)main.get("cbReading")) ) {
				if ( preference == null )
					preference = "Reading";
			}
			
			if ( "true".equals((String)main.get("cbVerbal")) ) {
				if ( preference == null )
					preference = "Verbal";
				else 
					preference = preference + ", Verbal";
			}

			if ( "true".equals((String)main.get("cbDoing")) ) {
				if ( preference == null )
					preference = "Doing";
				else 
					preference = preference + ", Doing";
			}

			if ( preference == null ) 
				preference = (String)main.get("txOtherMode");
			else {
				String data = (String)main.get("txOtherMode");
				if (data.trim().length() > 0)
					preference = preference + ", " + (String)main.get("txOtherMode");
			}									
			parameters.put("preference", preference);
			
			parameters.put("family", (String)main.get("rbFamily"));			
			parameters.put("fall", (String)main.get("cbFall"));
			parameters.put("wound", (String)main.get("cbWound"));
			parameters.put("fever", (String)main.get("cbFever"));
			parameters.put("sedation", (String)main.get("cbSedation"));
			parameters.put("laryngoscope", (String)main.get("cbLaryngoscope "));
			parameters.put("POP", (String)main.get("cbPOP"));
			parameters.put("sprain", (String)main.get("cbSprain"));
			parameters.put("head", (String)main.get("cbHead"));
			parameters.put("asthma", (String)main.get("cbAsthma"));
			parameters.put("cbOtherInfo", (String)main.get("cbOtherInfo"));
			parameters.put("otherInfo", (String)main.get("txOtherInfo"));
			parameters.put("evaluation", (String)main.get("rbEvaluation"));
			parameters.put("dischargeDate", (String)main.get("dtDischarge"));
			parameters.put("comment", (String)main.get("txComment"));
			
			String time = (String)main.get("seDischargeHh") + ":" + (String)main.get("seDischargeMi");
			parameters.put("dischargeTime", time);
			
			String createUser = (String)main.get("txCreateUser");			
			parameters.put("createUser", createUser);
				
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportListDataSource(record));
		
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/pdf");
			JRPdfExporter exporter = new JRPdfExporter();
	    	exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	       	exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	       	exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

	       	exporter.exportReport();
	       	ouputStream.flush();
	       	ouputStream.close();
			//return;			
		}
		 
	}

	formData = CMSDB.getForm(formID, regid, dept);
	
	obj = formData.get("main");
	
	if (obj != null) {
		sect =  (JSONArray)obj;
		txMain = sect.toJSONString().replace("\\", "\\\\").replace("\"", "\\\"").replace("\'", "\\\'");
	}

	obj = formData.get("eduRec");
			
	if (obj != null) {
		sect =  (JSONArray)obj;
		txEduRec = sect.toJSONString().replace("\\", "\\\\").replace("\"", "\\\"").replace("\'", "\\\'");
	}
	
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<jsp:include page="../common/header.jsp"/>

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=Generator content="Microsoft Word 12 (filtered)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:PMingLiU;
	panose-1:2 2 5 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:"Arial Unicode MS";
	panose-1:2 11 6 4 2 2 2 2 2 4;}
@font-face
	{font-family:"3 of 9 Barcode";
	panose-1:4 2 114 0 0 0 0 0 0 0;}
@font-face
	{font-family:"\@PMingLiU";
	panose-1:2 2 5 0 0 0 0 0 0 0;}
@font-face
	{font-family:"\@Arial Unicode MS";
	panose-1:2 11 6 4 2 2 2 2 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Arial","sans-serif";}
h1
	{margin:0in;
	margin-bottom:.0001pt;
	text-align:center;
	page-break-after:avoid;
	font-size:12.0pt;
	font-family:"Arial","sans-serif";}
h3
	{margin:0in;
	margin-bottom:.0001pt;
	text-align:center;
	page-break-after:avoid;
	font-size:18.0pt;
	font-family:"Arial","sans-serif";}
h4
	{margin:0in;
	margin-bottom:.0001pt;
	page-break-after:avoid;
	font-size:28.0pt;
	font-family:"3 of 9 Barcode";
	font-weight:normal;}
p.MsoNormalIndent, li.MsoNormalIndent, div.MsoNormalIndent
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:24.0pt;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Arial","sans-serif";}
p.MsoHeader, li.MsoHeader, div.MsoHeader
	{margin:0in;
	margin-bottom:.0001pt;
	layout-grid-mode:char;
	font-size:10.0pt;
	font-family:"Arial","sans-serif";}
p.MsoFooter, li.MsoFooter, div.MsoFooter
	{margin:0in;
	margin-bottom:.0001pt;
	layout-grid-mode:char;
	font-size:10.0pt;
	font-family:"Arial","sans-serif";}
 /* Page Definitions */
 @page WordSection1
	{size:595.3pt 841.9pt;
	margin:78.0pt 49.6pt 141.75pt 49.6pt;
	border:solid windowtext 1.0pt;
	padding:1.0pt 4.0pt 1.0pt 4.0pt;
	layout-grid:18.0pt;}
div.WordSection1
	{page:WordSection1;}
 /* List Definitions */
 ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}

.txContent {
	width:190px;	
 }
-->
</style>

</head>

<body lang=EN-US style='text-justify-trim:punctuation'>

<div class=WordSection1 style='layout-grid:18.0pt'>

<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="form1" id="form1" action="hkOpdEdu.jsp" method="post">

<p class=MsoNormal align=center style='text-align:center;line-height:12.0pt'><b><span
style='font-size:14.0pt'>&nbsp;</span></b></p>

<p class=MsoNormal align=center style='text-align:center;line-height:12.0pt'><b><span
style='font-size:14.0pt'>Out-patient Education Record </span></b></p>

<div id="patinfo">
<table>
<tr><td style='font-weight:bold;'>
Patient number:</td><td style='font-size:13.0pt;'><%=patno==null?"":patno %>
</td></tr><tr><td style='font-weight:bold;'>
Patient Name:</td><td style='font-size:13.0pt;'><%=patname==null?"":patname %>
</td></tr><tr><td style='font-weight:bold;'>
Sex:</td><td style='font-size:13.0pt;'><%=sex==null?"":sex %>
</td></tr><tr><td style='font-weight:bold;'>
DOB:</td><td style='font-size:13.0pt;'><%=dob==null?"": dob %>
</td></tr>
</table>
</div>

<div class="pane">
<table width="100%" border="0"> 
	<tr class="smallText" align="left"><td>
		<input type="hidden" name="command" id="command"/>
		<input type="hidden" name="regid" id="regid" value="<%=regid %>"/>		
		<input type="hidden" name="patno" id="patno" value="<%=patno %>"/>
		<input type="hidden" id="txMain" name="txMain" />
		<input type="hidden" id="txEduRec" name="txEduRec" />
		<input type="hidden" id="txCreateUser" name="txCreateUser" value="<%=username==null?"":username%>" />
		<input type="hidden" id="user" name="user" value="<%=userId==null?"":userId%>" />
		<input type="hidden" id="dept" name="dept" value="<%=dept==null?"":dept%>" />	
		<button id="submit">Save</button>
		<button id="report" formtarget="_blank">Print</button>		
	</td> 
	</tr>
</table>
</div>

<p class=MsoNormal align=center style='text-align:center;line-height:12.0pt'>&nbsp;</p>

<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph'>&nbsp;</p>

<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph'><b><span
style='font-size:10.0pt'>Preference(s) of learning mode:</span></b>
<input type="checkbox" name="cbReading" id="cbReading"><b><span style='font-size:10.0pt'> Reading</span></b>
<input type="checkbox" name="cbVerbal" id="cbVerbal"><b><span style='font-size:10.0pt'> Verbal</span></b>
<input type="checkbox" name="cbDoing" id="cbDoing"><b><span style='font-size:10.0pt'> Doing</span></b>
<input type="checkbox" name="cbOtherMode" id="cbOtherMode"><b><span style='font-size:10.0pt'> Others:
<input type="textfield" id="txOtherMode" name="txOtherMode"></span></b></p>
<br/>
<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph'><b><span style='font-size:10.0pt'>Family
/ carer / other participant</span></b>
<input name="rbFamily" class="rbFamily" type="radio" value="Yes" /><b><span style='font-size:10.0pt'> Yes</span></b>
<input name="rbFamily" class="rbFamily" type="radio" value="No" /><b><span style='font-size:10.0pt'> No</span></b></p>

<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph'><b><span
style='font-size:10.0pt'>&nbsp;</span></b></p>

<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph'><b><span
style='font-size:8.0pt'>&nbsp;</span></b></p>

<div id="subform" >--- subform here ---</div>

<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph'><b><span
style='font-size:8.0pt'>Comment: <textarea id="txComment" rows="4" cols="225"></textarea></span></b></p>

<p class=MsoNormal style='text-indent:9.0pt'><b><u><span style='font-size:9.0pt'>Information
advice sheet</span></u></b></p>

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0
 style='border-collapse:collapse'>
 <tr>
  <td width=351 valign=top style='width:263.05pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><input type="checkbox" name="cbFall" id="cbFall" />
  <span style='font-size:9.0pt'>Fall
  prevention</span></p>
  <p class=MsoNormal><input type="checkbox" name="cbWound" id="cbWound" />
  <span style='font-size:9.0pt'>Wound
  care</span></p>
  <p class=MsoNormal><input type="checkbox" name="cbFever" id="cbFever" />
  <span style='font-size:9.0pt'>Fever
  home care </span></p>
  <p class=MsoNormal><input type="checkbox" name="cbSedation" id="cbSedation" />
  <span style='font-size:9.0pt'>Post
  Procedural sedation</span></p>
  <p class=MsoNormal><input type="checkbox" name="cbLaryngoscope" id="cbLaryngoscope" />
  <span style='font-size:9.0pt'>Post
  direct laryngoscope care</span></p>
  </td>
  <td width=351 valign=top style='width:263.05pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><input type="checkbox" name="cbPOP" id="cbPOP" />
  <span style='font-size:9.0pt'>POP care</span></p>
  <p class=MsoNormal><input type="checkbox" name="cbSprain" id="cbSprain" />
  <span style='font-size:9.0pt'>Sprain
  injury care</span></p>
  <p class=MsoNormal><input type="checkbox" name="cbHead" id="cbHead" />
  <span style='font-size:9.0pt'>Head
  injury care</span></p>
  <p class=MsoNormal><input type="checkbox" name="cbAsthma" id="cbAsthma" />
  <span style='font-size:9.0pt'>Asthma
  home care</span></p>
  <p class=MsoNormal><input type="checkbox" name="cbOtherInfo" id="cbOtherInfo" />
  <span style='font-size:9.0pt'>Other: <input type="textfield" id="txOtherInfo" name="txOtherInfo"></span></p>
  </td>
 </tr>
</table>

<br/>
<p class=MsoNormal style='text-indent:9.0pt'><b><u><span style='font-size:9.0pt'>Evaluation</span></u></b></p>
<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0
 style='border-collapse:collapse'>
 <tr>
  <td width=117 valign=top style='padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><input type="radio" name="rbEvaluation" value="Excellent" />
  <span style='font-size:9.0pt'>Excellent</span></p>
  </td>
  <td width=117 valign=top style='padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><input type="radio" name="rbEvaluation" value="Good" />
  <span style='font-size:9.0pt'>Good</span></p>
  </td>
  <td width=117 valign=top style='padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><input type="radio" name="rbEvaluation" value="Fair" />
  <span style='font-size:9.0pt'>Fair</span></p>
  </td>
 </tr>
</table>
<br/>

<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph'><b><span
style='font-size:8.0pt'>Discharge Date: <input name="dtDischarge" id="dtDischarge" type="textfield" class="datepickerfield" maxlength="10" size="10"  onkeyup="validDate(this)" onblur="validDate(this)" />
Time: <select name='seDischargeHh' id='seDischargeHh'>
	 <option value='01'>01</option>
	 <option value='02'>02</option>
	 <option value='03'>03</option>
	 <option value='04'>04</option>
	 <option value='05'>05</option>
	 <option value='06'>06</option>
	 <option value='07'>07</option>
	 <option value='08'>08</option>
	 <option value='09'>09</option>
	 <option value='10'>10</option>
	 <option value='11'>11</option>
	 <option value='12'>12</option>
	 <option value='13'>13</option>
	 <option value='14'>14</option>
	 <option value='15'>15</option>
	 <option value='16'>16</option>
	 <option value='17'>17</option>
	 <option value='18'>18</option>
	 <option value='19'>19</option>
	 <option value='20'>20</option>
	 <option value='21'>21</option>
	 <option value='22'>22</option>
	 <option value='23'>23</option>
 </select>:<select name='seDischargeMi' id='seDischargeMi'>
	 <option value='00'>00</option>
	 <option value='01'>01</option>
	 <option value='02'>02</option>
	 <option value='03'>03</option>
	 <option value='04'>04</option>
	 <option value='05'>05</option>
	 <option value='06'>06</option>
	 <option value='07'>07</option>
	 <option value='08'>08</option>
	 <option value='09'>09</option>
	 <option value='10'>10</option>
	 <option value='11'>11</option>
	 <option value='12'>12</option>
	 <option value='13'>13</option>
	 <option value='14'>14</option>
	 <option value='15'>15</option>
	 <option value='16'>16</option>
	 <option value='17'>17</option>
	 <option value='18'>18</option>
	 <option value='19'>19</option>
	 <option value='20'>20</option>
	 <option value='21'>21</option>
	 <option value='22'>22</option>
	 <option value='23'>23</option>
	 <option value='24'>24</option>
	 <option value='25'>25</option>
	 <option value='26'>26</option>
	 <option value='27'>27</option>
	 <option value='28'>28</option>
	 <option value='29'>29</option>
	 <option value='30'>30</option>
	 <option value='31'>31</option>
	 <option value='32'>32</option>
	 <option value='33'>33</option>
	 <option value='34'>34</option>
	 <option value='35'>35</option>
	 <option value='36'>36</option>
	 <option value='37'>37</option>
	 <option value='38'>38</option>
	 <option value='39'>39</option>
	 <option value='40'>40</option>
	 <option value='41'>41</option>
	 <option value='42'>42</option>
	 <option value='43'>43</option>
	 <option value='44'>44</option>
	 <option value='45'>45</option>
	 <option value='46'>46</option>
	 <option value='47'>47</option>
	 <option value='48'>48</option>
	 <option value='49'>49</option>
	 <option value='50'>50</option>
	 <option value='51'>51</option>
	 <option value='52'>52</option>
	 <option value='53'>53</option>
	 <option value='54'>54</option>
	 <option value='55'>55</option>
	 <option value='56'>56</option>
	 <option value='57'>57</option>
	 <option value='58'>58</option>
	 <option value='59'>59</option>
 </select>
<span id="CreateUser" ></span>
</span></b></p>
</form>

<script language="javascript">
<!--
//IE compatibility
if (typeof console=="undefined") var console={ log: function(x) {document.getElementById('msg').innerHTML=x} };
 
if(typeof String.prototype.trim !== 'function') {
  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, ''); 
  }
}

$(document).ready(function(){

	$("#txMain").val('<%=txMain==null?"":txMain%>');
	$("#txEduRec").val('<%=txEduRec==null?"":txEduRec%>');
	
//set default value
	document.getElementById("CreateUser").innerHTML = ""; 
	getMain();
//-1 obsolite parameter for enable new line	
	getSubform();
	
//patient not found	
	if (<%=disable %>) {
		$("input").attr({
			'disabled': 'disabled'
        });
		$("button").attr({
			'disabled': 'disabled'
        });
		$("select").attr({
			'disabled': 'disabled'
        });
		$("textarea").attr({
			'disabled': 'disabled'
        });
	} 

	$("input[type=checkbox]").click(function(){
		enableFld();
	});
	
	$("#submit").click(function(){
		$("#command").val("save");
		$("#report").attr({'disabled': 'disabled'});
		fill();
	});
	
	$("#report").click(function(){
		$("#command").val("report");
		fill();
	});
							
});

function fill() {
//mainform		
	var data = '[{"cbReading":"' + $('#cbReading').is(":checked") +	
		'","cbVerbal":"' + $('#cbVerbal').is(":checked") +	
		'","cbDoing":"' + $('#cbDoing').is(":checked") +	
		'","rbFamily":"' + $("input[name='rbFamily']:checked").val() + 
		'","cbOtherMode":"' + $('#cbOtherMode').is(":checked") +	
		'","txOtherMode":"' + $("#txOtherMode").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"') + 		
		'","cbFall":"' + $('#cbFall').is(":checked") +	
		'","cbWound":"' + $('#cbWound').is(":checked") +	
		'","cbFever":"' + $('#cbFever').is(":checked") +	
		'","cbSedation":"' + $('#cbSedation').is(":checked") +	
		'","cbLaryngoscope ":"' + $('#cbLaryngoscope').is(":checked") +	
		'","cbPOP":"' + $('#cbPOP').is(":checked") +	
		'","cbSprain":"' + $('#cbSprain').is(":checked") +	
		'","cbHead":"' + $('#cbHead').is(":checked") +	
		'","cbAsthma":"' + $('#cbAsthma').is(":checked") +							
		'","cbOtherInfo":"' + $('#cbOtherInfo').is(":checked") +	
		'","txOtherInfo":"' + $("#txOtherInfo").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"') + 
		'","rbEvaluation":"' + $("input[name='rbEvaluation']:checked").val() + 
		'","dtDischarge":"' + $("#dtDischarge").val() + 
		'","seDischargeHh":"' + $("#seDischargeHh").val() +
		'","seDischargeMi":"' + $("#seDischargeMi").val() +
		'","txComment":"' + $("#txComment").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"').trim();
		
	if ($("#txCreateUser").val().trim())
		data = data + '","txCreateUser":"' + $("#txCreateUser").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"');
				
	data = data + '"}]'; 
	data = data.replace(/undefined/g, "");
	
	$("#txMain").val(data);
	
//subform		
	data = '';
	
	for (var i = 0; i < 8; i++) {
		
		if (i == 0) {
			data = '{"dtEdu":"' + $("#dtEdu" + i).val() +	
				'","txContent":"' + $("#txContent" + i).val().replace(/\"/g, "\\\"") + 
				'","seLearner":"' + $("#seLearner" + i).val() +
				'","seMethod":"' + $("#seMethod" + i).val() + 
				'","seResponse":"' + $("#seResponse" + i).val() +
				'","seNeed":"' + $("#seNeed" + i).val() +
				'","seDiscipline":"' + $("#seDiscipline" + i).val() + '"}';
		} else {
			data = data + ',' + '{"dtEdu":"' + $("#dtEdu" + i).val() +	
				'","txContent":"' + $("#txContent" + i).val().replace(/\"/g, "\\\"") + 
				'","seLearner":"' + $("#seLearner" + i).val() +
				'","seMethod":"' + $("#seMethod" + i).val() + 
				'","seResponse":"' + $("#seResponse" + i).val() +
				'","seNeed":"' + $("#seNeed" + i).val() +
				'","seDiscipline":"' + $("#seDiscipline" + i).val() + '"}';
		}
					
	}
			
	$("#txEduRec").val("[" + data + "]");
}

function getLearner(code) {
	if (code == "C")
		return "Caregiver/other";
	else if (code == "FM")
		return "Family";
	else if (code == "P")
		return "Patient";
	else
		return code;
}

function getMethod(code) {
	if (code == "Q")
		return "Question-answer";
	else if (code == "D")
		return "Demonstration";
	else if (code == "E")
		return "Explanation";
	else if (code == "W")
		return "Other written material";
	else if (code == "V")
		return "Visual";
	else
		return code;
}

function getResponse(code) {
	if (code == "1")
		return "Asked questions";
	else if (code == "2")
		return "Indicates understanding/answered questions";
	else if (code == "3")
		return "Return demonstration correct";
	else if (code == "4")
		return "Disinterested/refuses information";
	else if (code == "5")
		return "Unable to understand";
	else
		return code;
}

function getNeed(code) {
	if (code == "1")
		return "Reinforce specific content";
	else if (code == "2")
		return "Have patient practiced demonstration";
	else if (code == "3")
		return "Re-attempt teaching";
	else if (code == "4")
		return "Referral";
	else if (code == "5")
		return "Teaching completed";
	else
		return code;
}

function getDiscipline(code) {
	if (code == "N")
		return "Nurse";
	else if (code == "RD")
		return "Registered Dietitian";
	else if (code == "PT") 
		return "Physiotherapist";
	else if (code == "PH")
		return "Pharmacist";
	else if (code == "PO")
		return "P&O";
	else if (code == "PD")
		return "Podiatrist";
	else if (code == "ST")
		return "Speech Therapist";
	else if (code == "OT")
		return "Occupational Therapist";
	else if (code == "MT")
		return "Music Therapist";
	else if (code == "C")
		return "Counselor";
	
	
	else
		return code;
}

function getMain() {
	
	var data = $("#txMain").val();
	
	var d = new Date();
	
	$("#dtDischarge").val( addZero(d.getDate()) + "/" + addZero(d.getMonth() + 1) + "/" + d.getFullYear());
	
	document.getElementById('seDischargeHh').value = addZero(d.getHours());
	document.getElementById('seDischargeMi').value = addZero(d.getMinutes());
	
	if  (data != "") {
		var obj = JSON.parse(data);
		for (field in obj[0]) {
			
			if (field.substring(0,2) == "rb") {
				$("input[name=" + field + "]").attr('checked',false);
				$("input[name=" + field + "][value=" + obj[0][field] + "]").attr("checked",true);
			} else if (field.substring(0,2) == "cb") {

				if (obj[0][field] == 'true')
					$("#" + field).attr('checked', true);
				else
					$("#" + field).attr('checked', false);
				
			} else {
				$("#" + field).val(obj[0][field]);
			}
			
			if ((field == "txCreateUser") && (obj[0][field] != ""))
			 	document.getElementById("CreateUser").innerHTML = " <b>Completed by: <u>" + obj[0][field] + "</u></b>";				
		}
	}
	
	enableFld();
}

function getSubform() {
	
	var subform = $("#txEduRec").val();
	var html = "<table id='eduRec'><tr>" + 
		"<th>Date</th>" +
		"<th>Content (Brief Explanation)</th>" +
		"<th>Learner</th>" +
		"<th>Teaching Method</th>" +
		"<th>Response</th>" +
		"<th>Learner Need</th>" +
		"<th>Discipline</th>" +
		"</tr>";
		
	for (var i = 0; i < 8; i++) {
			html += "<tr>" + 
				"<td><input name='dtEdu' id='dtEdu" + i + "' type='textfield' class='dtEdu' maxlength='10' onkeyup='validDate(this)' onblur='validDate(this)' /></td>" +
				"<td><input type='textfield' id='txContent" + i + "' name='txContent' class='txContent'/></td>" +
				"<td><select name='seLearner' id='seLearner" + i + "' class='seLearner'>" +
		  			"<option value=''></option>" +
		  			"<option value='C'>" + getLearner("C") + "</option>" +
	  				"<option value='FM'>" + getLearner("FM") + "</option>" +
	  				"<option value='P'>" + getLearner("P") + "</option>" +		  			
		  		"</select></td>" +	  		
		  		"<td><select name='seMethod' id='seMethod" + i + "' class='seMethod'>" +
	  				"<option value=''></option>" +
  					"<option value='Q'>" + getMethod("Q") + "</option>" +
  					"<option value='D'>" + getMethod("D") + "</option>" +
  					"<option value='E'>" + getMethod("E") + "</option>" +
  	  				"<option value='W'>" + getMethod("W") + "</option>" +
	  	  			"<option value='V'>" + getMethod("V") + "</option>" +		  			
	  			"</select></td>" +  			
  				"<td><select name='seResponse' id='seResponse" + i + "' class='seResponse'>" +
	  				"<option value=''></option>" +
  					"<option value='1'>" + getResponse("1") + "</option>" +
  					"<option value='2'>" + getResponse("2") + "</option>" +
  					"<option value='3'>" + getResponse("3") + "</option>" +
	  	  			"<option value='4'>" + getResponse("4") + "</option>" +
	  	  			"<option value='5'>" + getResponse("5") + "</option>" +		  			
  				"</select></td>" +  			
  				"<td><select name='seNeed' id='seNeed" + i + "' class='seNeed'>" +
	  				"<option value=''></option>" +
					"<option value='1'>" + getNeed("1") + "</option>" +
					"<option value='2'>" + getNeed("2") + "</option>" +
					"<option value='3'>" + getNeed("3") + "</option>" +
		  			"<option value='4'>" + getNeed("4") + "</option>" +
		  			"<option value='5'>" + getNeed("5") + "</option>" +		  			
				"</select></td>" +			
  				"<td><select name='seDiscipline' id='seDiscipline" + i + "' class='seDiscipline'>" +
	  				"<option value=''></option>" +
					"<option value='N'>" + getDiscipline("N") + "</option>" +
	  				"<option value='RD'>" + getDiscipline("RD") + "</option>" +
  					"<option value='PT'>" + getDiscipline("PT") + "</option>" +
	  				"<option value='PH'>" + getDiscipline("PH") + "</option>" +		
					"<option value='PO'>" + getDiscipline("PO") + "</option>" +
	  				"<option value='PD'>" + getDiscipline("PD") + "</option>" +
  					"<option value='ST'>" + getDiscipline("ST") + "</option>" +
	  				"<option value='OT'>" + getDiscipline("OT") + "</option>" +		
  					"<option value='MT'>" + getDiscipline("MT") + "</option>" +
	  				"<option value='C'>" + getDiscipline("C") + "</option>" +		
				"</select></td>" +	
				"</tr>";												
	}
						
	html += "</table>";
	
	document.getElementById("subform").innerHTML = html;	
	
	$(".dtEdu").datepicker();
		
	if  (subform != "") { 
		var obj = JSON.parse(subform);
		
		for (i in obj) {
			$("#dtEdu" + i).val(obj[i].dtEdu);
			$("#txContent" + i).val(obj[i].txContent);
			
			//$("#seLearner" + i).val(obj[i].seLearner);			
			if (document.getElementById('seLearner' + i) != null)
				document.getElementById('seLearner' + i).value = obj[i].seLearner;
			
			//$("#seMethod" + i).val(obj[i].seMethod);			
			if (document.getElementById('seMethod' + i) != null)
				document.getElementById('seMethod' + i).value = obj[i].seMethod;
			
			//$("#seResponse" + i).val(obj[i].seResponse);			
			if (document.getElementById('seResponse' + i) != null)
				document.getElementById('seResponse' + i).value = obj[i].seResponse;
			
			//$("#seNeed" + i).val(obj[i].seNeed);			
			if (document.getElementById('seNeed' + i) != null)
				document.getElementById('seNeed' + i).value = obj[i].seNeed;
			
			//$("#seDiscipline" + i).val(obj[i].seDiscipline);			
			if (document.getElementById('seDiscipline' + i) != null)
				document.getElementById('seDiscipline' + i).value = obj[i].seDiscipline;
		}
	}
	
	return false;
}

function addZero(n){
	  if(n < 10){
	    return "0" + n;
	  }
	  return n
}

function enableFld(){		
	if ($('#cbOtherMode').is(":checked")) { 
		$("#txOtherMode").removeAttr('disabled');
	} else {
		$('#txOtherMode').attr({'disabled': 'disabled'});
		$('#txOtherMode').val("");
	}
	
	if ($('#cbOtherInfo').is(":checked")) { 
		$("#txOtherInfo").removeAttr('disabled');
	} else {
		$('#txOtherInfo').attr({'disabled': 'disabled'});
		$('#txOtherInfo').val("");
	}
}
-->
</script>
</DIV>
</DIV>
</DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</div>

</body>

</html:html>
