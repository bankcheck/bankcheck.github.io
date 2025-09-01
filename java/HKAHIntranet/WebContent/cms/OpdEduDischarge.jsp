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
String username = null;
String mainuser = null;

//String dept = request.getParameter("dept");
String readonly = request.getParameter("readonly");

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

Calendar calendar = Calendar.getInstance();
String currentDate = DateTimeUtil.formatDateTime(calendar.getTime());

String formID = "OpdEduDischarge";

String command = request.getParameter("command");
String regid = request.getParameter("regid");
//main form
String txMain = request.getParameter("txMain");
//subform
String txSubform = request.getParameter("txSubform");
//discharge section
String txDischarge = request.getParameter("txDischarge");

String patno = request.getParameter("patno");
//String patno = null;
String sex = null;
String patname = null;
String dob = null;
String eduLevel = null;
String rbEduLevel =null;

//String room = PatientDB.getRoom(regid);
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
		
	if (patRec.size() > 0) {
		ReportableListObject row = (ReportableListObject) patRec.get(0);
		patno = row.getValue(0);
		sex = row.getValue(1);
		patname = row.getValue(3);
		dob = row.getValue(10);
		lang = row.getValue(20);
		eduLevel = row.getValue(22);
		
		if ("PRIMARY".equals(eduLevel) || "Primary".equals(eduLevel)) {
			rbEduLevel = "Primary";
		} else if ("POSTGRADUATE OR ABOVE".equals(eduLevel) || "SECONDARY".equals(eduLevel) || "TERTIARY".equals(eduLevel) || "UNIVERSITY".equals(eduLevel)
			|| "Secondary".equals(eduLevel) || "Tertiary or above".equals(eduLevel) ) {
			
			rbEduLevel = "Secondary/Post Secondary";
		}
			
	} else {
		message = "Patient reord not found";
		disable = true;
	}
		
	JSONParser jParser = null;
	Object obj = null;
	JSONArray sect = null;
			
	if ("save".equals(command) || "report".equals(command)){
		
		//System.out.println("[DEBUG] save " + formID + " regid=" + regid + " userId=" + userId);		
		//System.out.println("[DEBUG] txMain=" + txMain);
		if ((txMain.length() != 0) && (txMain != null)) {
			jParser = new JSONParser();
			obj =  jParser.parse(txMain);
			sect = (JSONArray)obj;
			formData.put("main", sect);
		}
		
		//System.out.println("[DEBUG] txSubform=" + txSubform);
		if ((txSubform.length() != 0) && (txSubform != null)) {
			jParser = new JSONParser();
			obj =  jParser.parse(txSubform);
			sect = (JSONArray)obj;		
			formData.put("subform", sect);
		}
		
		if ((txDischarge.length() != 0) && (txDischarge != null)) {
			jParser = new JSONParser();
			obj =  jParser.parse(txDischarge);
			sect = (JSONArray)obj;		
			formData.put("discharge", sect);
		}
		
		System.out.println("discharge: " + txDischarge);

		if (CMSDB.setForm(formID, regid, formData, userId, patno)) {
			
			message = formID + " saved.";
			  
		} else {
			
			errorMessage = "Failed to save " + formID;
			System.out.println("[OpdEduDischarge] setForm " + formID +  " error:" + errorMessage);
			
		}
		
	} 
/*	
	if ("report".equals(command)) {
		
		formData = CMSDB.getForm(formID, regid);
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
		sqlStr.append(" max(DECODE(fld, 'seDiscipline', val)) seDiscipline ");
		sqlStr.append(" from gen_form@cis "); 																		
		sqlStr.append(" where form_id = '" + formID + "' ");
		sqlStr.append(" and key1 = ? ");
		sqlStr.append(" and key2 = '0' "); 
		sqlStr.append(" and key3 = '0' ");
		sqlStr.append(" and sect_id = 'subform' ");
		sqlStr.append(" group by key1, key2, key3, sect_id, sect_seq ");
		sqlStr.append(" order by sect_seq ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{ regid });

		File reportFile = new File(application.getRealPath("/report/RPT_EDU_DISCHARGE_TW.jasper"));
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
			
			parameters.put("EDULEVEL", (String)main.get("rbEduLevel"));
			
			String accompany = "";
			if ( "true".equals((String)main.get("cbCaregiver")) ) {
				accompany = "Accompany with Caregiver";
			}
			
			if ( "true".equals((String)main.get("cbFamily")) ) {
				if ("".equals(accompany)) {
					accompany = "Accompany with Family";
				} else {
					accompany = accompany + ", Family";	
				}									
			}
			parameters.put("accompany", accompany);
								
			String language = null;
			if ( "true".equals((String)main.get("cbCantonese")) ) {
				if ( language == null )
					language = "Cantonese";
			}
			
			if ( "true".equals((String)main.get("cbEnglish")) ) {
				if ( language == null )
					language = "English";
				else 
					language = language + ", English";
			}

			if (  "true".equals((String)main.get("cbMandarin")) ) {
				if ( language == null )
					language = "Mandarin";
				else 
					language = language + ", Mandarin";
			}

			if ( language == null )
				language = (String)main.get("txOtherLanguage");
			else {
				String data = (String)main.get("txOtherLanguage");
				if (data.trim().length() > 0)
					language = language + ", " + (String)main.get("txOtherLanguage");
			}		
			parameters.put("language", language);
			
			parameters.put("translator", (String)main.get("rbTranslator"));
			parameters.put("define", (String)main.get("rbDefine"));
			parameters.put("barrier", (String)main.get("rbBarrier"));

			String barrierDesc = null;
			if ( "true".equals((String)main.get("cbVisual")) ) {
				if ( barrierDesc == null )
					barrierDesc = "Visual";
			}
			
			if ( "true".equals((String)main.get("cbHearing")) ) {
				if ( barrierDesc == null )
					barrierDesc = "Hearing";
				else 
					barrierDesc = barrierDesc + ", Hearing";
			}

			if ( "true".equals((String)main.get("cbUnableRead")) ) {
				if ( barrierDesc == null )
					barrierDesc = "Unable to read/write";
				else 
					barrierDesc = barrierDesc + ", Unable to read/write";
			}
			
			if ( barrierDesc == null )
				barrierDesc = (String)main.get("txOtherBarrier");
			else {
				String data = (String)main.get("txOtherBarrier");
				if ( data.trim().length() > 0 )
					barrierDesc = barrierDesc + ", " + (String)main.get("txOtherBarrier");
			}	
			parameters.put("barrierDesc", barrierDesc);
			
			parameters.put("cognitive", (String)main.get("rbCognitive"));					
			parameters.put("cultural", (String)main.get("rbCultural"));	
			parameters.put("religious", (String)main.get("rbReligious"));			
			parameters.put("emotional", (String)main.get("rbEmotional"));			
			parameters.put("emotionalDesc", (String)main.get("txEmotional"));			 
			parameters.put("motive", (String)main.get("rbMotive"));
			parameters.put("motiveDesc", (String)main.get("txMotive"));
			
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
			parameters.put("E", (String)main.get("rbE"));
			parameters.put("G", (String)main.get("rbG"));
			parameters.put("A", (String)main.get("rbA"));
			parameters.put("I", (String)main.get("rbI"));
			parameters.put("R", (String)main.get("rbR"));
			parameters.put("T", (String)main.get("rbT"));			
			parameters.put("factSheet", (String)main.get("cbFactSheet"));
			parameters.put("leaflet", (String)main.get("cbLeaflet"));
			parameters.put("medication", (String)main.get("cbMedication"));
			parameters.put("dressing", (String)main.get("cbDressing"));
			parameters.put("injection", (String)main.get("cbInjection"));					
			parameters.put("returnDate", (String)main.get("dtReturn"));
			parameters.put("transport", (String)main.get("rbAmbulance"));
			parameters.put("drugSheet", (String)main.get("cbDrugSheet"));
			parameters.put("refLetter", (String)main.get("cbRefLetter"));
			parameters.put("sickLeave", (String)main.get("cbSickLeave"));
			parameters.put("dressingSheet", (String)main.get("cbDressingSheet"));
			parameters.put("labForm", (String)main.get("cbLabForm"));
			parameters.put("otherInfo", (String)main.get("txOtherInfo"));			
			parameters.put("dischargeDate", (String)main.get("dtDischarge"));
			
			String time = (String)main.get("seDischargeHh") + ":" + (String)main.get("seDischargeMi");
			parameters.put("dischargeTime", time);
			
			String dischargeUser = (String)main.get("txDischargeUser");		
			String createUser = CMSDB.getCISusername(dischargeUser);	
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
*/
	formData = CMSDB.getForm(formID, regid );
	
	obj = formData.get("main");
	
	if (obj != null) {
		sect =  (JSONArray)obj;
		
		JSONObject main = (JSONObject)sect.get(0);
		mainuser = CMSDB.getCISusername((String)main.get("txMainUser"));
		
		txMain = sect.toJSONString().replace("\\", "\\\\").replace("\"", "\\\"").replace("\'", "\\\'");
	}
	//System.out.println("[DEBUG] txMain=" + txMain);
	
	obj = formData.get("subform");
			
	if (obj != null) {
		sect =  (JSONArray)obj;
		txSubform = sect.toJSONString().replace("\\", "\\\\").replace("\"", "\\\"").replace("\'", "\\\'");
	}
	//System.out.println("[DEBUG] txSubform=" + txSubform);

	obj = formData.get("discharge");
	
	if (obj != null) {
		sect =  (JSONArray)obj;
		
		JSONObject discharge = (JSONObject)sect.get(0);
		username = CMSDB.getCISusername((String)discharge.get("txDischargeUser"));
		
		txDischarge = sect.toJSONString().replace("\\", "\\\\").replace("\"", "\\\"").replace("\'", "\\\'");		
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
	{font-family:"Wingdings 2";
	panose-1:5 2 1 2 1 5 7 7 7 7;}
@font-face
	{font-family:"3 of 9 Barcode";
	panose-1:4 2 114 0 0 0 0 0 0 0;}
@font-face
	{font-family:"\@PMingLiU";
	panose-1:2 2 5 0 0 0 0 0 0 0;}
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
	margin:85.05pt 49.6pt 141.75pt 49.6pt;
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
	
#subTable {
	margin-left:12.5pt;
	border-collapse:collapse;
	border:1px solid black;
	cellspacing:0;
	cellpadding:0;
 }
 
#subTable th {
	border:1px solid black;
	padding:0in 5.4pt 0in 5.4pt;
	font-weight: bold;
	color: black;
	font-size:9pt;
}

#subTable td {
	border:1px solid black;
	padding:0in 5.4pt 0in 5.4pt;
    font-size: 11px;
    height: 30px;
}


.txContent {
	width:150px;	
 }
 
 #dtEdu {
	width:70px;	
 }
 
.DischargeCell td {
	width: 230px;
	padding:0in 5.4pt 0in 5.4pt;
}

.MsoNormalTable {
	width: 1400px;
}

#txEmotional {
	width: 490px;
}

#txMotive {
	width: 490px;
}

#txOtherMode {
	width: 990px;
}

#txOtherInfo {
	width: 150px;
}

#txOtherLanguage {
	width: 200px;
}

#txOtherBarrier {
	width: 200px;
}

#txOtherInfo {
	width: 150px;
}
-->
</style>

<body lang=EN-US style='text-justify-trim:punctuation'>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="form1" id="form1" action="OpdEduDischarge.jsp" method="post">

<p class=MsoNormal align=center style='text-align:center;line-height:12.0pt'><span
style='font-size:14.0pt'><b>Out-patient Education Summary and Discharge
Arrangement</b></span></p>

<p class=MsoNormal>&nbsp;</p>

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
		<input type="hidden" id="txSubform" name="txSubform" />
		<input type="hidden" id="txDischarge" name="txDischarge" />
		<input type="hidden" id="user" name="user" value="<%=userId==null?"":userId%>" />
		<input type="hidden" id="txMainUser" name="txMainUser" />
		<input type="hidden" id="txDischargeUser" name="txDischargeUser" />		
<!--
		<button id="submit">Save</button>
		<button id="cancel">Cancel</button>				
		<button id="report" formtarget="_blank">Print</button>		
-->					
	</td> 
	</tr>
</table>
</div>


<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
line-height:12.0pt'>&nbsp;</p>

<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
text-indent:6.0pt;line-height:12.0pt'><span style='font-size:12.0pt'><b>Education
Assessment</b></span>
	<button id="editMain" class="smallText">Edit</button>
	<span id="spanMainBtn" class="smallText">
	<button id="submit1" class="save">Save</button>
	<button id="cancelMain" class="cancel">Cancel</button></span>
	<span id="MainUser" ><%=mainuser==null?"":"<b>Created by "+mainuser+"</b>"%></span>
</p>

<div id="main" >
<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='margin-left:12.5pt;border-collapse:collapse;border:none'>
 <tr>
  <td colspan=4 valign=top style='border:none;
  border-bottom:solid windowtext 1.0pt;background:#F2DBDB;padding:0in 5.4pt 0in 5.4pt'>
  <table width=100%><tr><td width=50%>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Education
  level: 
  <input name="rbEduLevel" class="rbEduLevel" type="radio" value="Illiterate" />Illiterate 
  <input name="rbEduLevel" class="rbEduLevel" type="radio" value="Primary" />Primary 
  <input name="rbEduLevel" class="rbEduLevel" type="radio" value="Secondary/Post Secondary" />Secondary/Post Secondary</b></span></p>
  </td>
  <td width=50%><b>Accompany with:
  <input type="checkbox" name="cbCaregiver" id="cbCaregiver" />Caregiver
  <input type="checkbox" name="cbFamily" id="cbFamily" />Family</b>
  </td>
  </tr></table>
  </td>
 </tr>
 <tr>
  <td width=208 valign=top style='width:155.95pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Language
  spoken: </b></span></p>
  </td>
  <td width=500 colspan=2 style='border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <table border=0 width=100%>
  <tr><td width=100>
  <p class=MsoNormal style='line-height:12.0pt'><input type="checkbox" name="cbCantonese" id="cbCantonese"><span style='font-size:9.0pt'><b> Cantonese </b></span></p>
  </td>
  <td width=400>
  <input type="checkbox" name="cbMandarin" id="cbMandarin">
  <span style='font-size:9.0pt'><b> Mandarin</b></span>
  </td>
  </tr>
  <tr><td>
  <p class=MsoNormal style='line-height:12.0pt'><input type="checkbox" name="cbEnglish" id="cbEnglish"><span
  style='font-size:9.0pt'><b> English </b></span></p>
  </td>
  <td>
    <p class=MsoNormal style='line-height:12.0pt'><input type="checkbox" name="cbOtherLanguage" id="cbOtherLanguage"><span
  style='font-size:9.0pt'><b> Other Language: </b></span><input type="textfield" id="txOtherLanguage" name="txOtherLanguage"/>
  </p>
  </td></tr></table>  
  </td>
  <td style='border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  text-indent:1.45pt;line-height:12.0pt'>
  <span style='font-size:9.0pt'><b>Translator
  needed: </b></span><input name="rbTranslator" class="rbTranslator" type="radio" value="Yes" /><span
  style='font-size:9.0pt'><b> Yes</b></span>
  <input name="rbTranslator" class="rbTranslator" type="radio" value="No" /><span
  style='font-size:9.0pt'><b> No</b></span>
  </p>
  
  </td>
 </tr>
 <tr>
  <td width=208 valign=top style='width:155.95pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Does
  patient has difficulty in defining his/her health problem?</b></span></p>
  </td>
  <td width=132 valign=top style='width:99.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbDefine" class="rbDefine" type="radio" value="No" /><span style='font-size:9.0pt'><b> No</b></span></p>
  </td>
  <td width=113 valign=top style='width:85.05pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbDefine" class="rbDefine" type="radio" value="Yes" /><span
  style='font-size:9.0pt'><b> Yes</b></span></p>
  </td>
  <td valign=top style='width:146.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'></p>
  </td>
 </tr>
 <tr>
  <td width=208 valign=top style='width:155.95pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Communication
  barrier / </b></span></p>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Physical
  limitation</b></span></p>
  </td>
  <td width=132 valign=top style='width:99.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbBarrier" class="rbBarrier" type="radio" value="No" /><span style='font-size:9.0pt'><b> No</b></span></p>
  </td>
  <td width=113 valign=top style='width:85.05pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbBarrier" class="rbBarrier" type="radio" value="Yes" /><span
  style='font-size:9.0pt'><b> Yes</b></span></p>
  </td>
  <td valign=top style='width:210pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'>
  <table border=0 width=100%><tr><td>
  <input type="checkbox" name="cbVisual" id="cbVisual"><span
  style='font-size:9.0pt'><b> Visual </b></span>
  </td><td>
   <input type="checkbox" name="cbUnableRead" id="cbUnableRead"><span
  style='font-size:9.0pt'><b> Unable to read/write</b></span>
  </td></tr><tr><td>
  <input type="checkbox" name="cbHearing" id="cbHearing"><span style='font-size:9.0pt'><b> Hearing </b></span>
  </td><td>
  <input type="checkbox" name="cbOtherBarrier" id="cbOtherBarrier"><span
  style='font-size:9.0pt'><b> Other:</b></span>
  <input type="textfield" id="txOtherBarrier" name="txOtherBarrier">
  </td></tr></table>
  </p>
  
  </td>
 </tr>
 <tr>
  <td width=208 valign=top style='width:155.95pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Cognitive
  limitation</b></span></p>
  </td>
  <td width=132 valign=top style='width:99.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbCognitive" class="rbCognitive" type="radio" value="No" /><span style='font-size:9.0pt'><b> No</b></span></p>
  </td>
  <td width=113 valign=top style='width:85.05pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbCognitive" class="rbCognitive" type="radio" value="Yes" /><span
  style='font-size:9.0pt'><b> Yes</b></span></p>
  </td>
  <td width=195 valign=top style='width:146.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'></p>
  </td>
 </tr>
 <tr>
  <td width=208 valign=top style='width:155.95pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Special
  health cultural practice </b></span></p>
  </td>
  <td width=132 valign=top style='width:99.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbCultural" class="rbCultural" type="radio" value="No" /><span style='font-size:9.0pt'><b> No</b></span></p>
  </td>
  <td width=113 valign=top style='width:85.05pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbCultural" class="rbCultural" type="radio" value="Yes" /><span
  style='font-size:9.0pt'><b> Yes</b></span></p>
  </td>
  <td width=195 valign=top style='width:146.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'></p>
  </td>
 </tr>
 <tr>
  <td width=208 valign=top style='width:155.95pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Religious
  health practice </b></span></p>
  </td>
  <td width=132 valign=top style='width:99.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbReligious" class="rbReligious" type="radio" value="No" /><span style='font-size:9.0pt'><b> No</b></span></p>
  </td>
  <td width=113 valign=top style='width:85.05pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbReligious" class="rbReligious" type="radio" value="Yes" /><span
  style='font-size:9.0pt'><b> Yes</b></span></p>
  </td>
  <td width=195 valign=top style='width:146.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'></p>
  </td>
 </tr>
 <tr>
  <td width=208 valign=top style='width:155.95pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Emotional
  status</b></span></p>
  </td>
  <td width=132 valign=top style='width:99.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbEmotional" class="rbEmotional" type="radio" value="Stable" /><span style='font-size:9.0pt'><b> Stable</b></span></p>
  </td>
  <td width=113 valign=top style='width:85.05pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbEmotional" class="rbEmotional" type="radio" value="Unstable" /><span
  style='font-size:9.0pt'><b> Unstable</b></span></p>
  </td>
  <td width=195 valign=top style='width:146.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Describe:</b></span>
  <input type="textfield" id="txEmotional" name="txEmotional"></p>
  </td>
 </tr>
 <tr>
  <td width=208 valign=top style='width:155.95pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Desire
  / motivation to learn</b></span></p>
  </td>
  <td width=132 valign=top style='width:99.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbMotive" class="rbMotive" type="radio" value="Good" /><span style='font-size:9.0pt'><b> Good</b></span></p>
  </td>
  <td width=113 valign=top style='width:85.05pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  line-height:12.0pt'><input name="rbMotive" class="rbMotive" type="radio" value="Poor" /><span
  style='font-size:9.0pt'><b> Poor</b></span></p>
  </td>
  <td width=195 valign=top style='width:146.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='line-height:12.0pt'><span style='font-size:9.0pt'><b>Describe:</b></span>
  <input type="textfield" id="txMotive" name="txMotive">
  </p>
  </td>
 </tr>
</table>
<br />
<p class=MsoNormal ><span
style='font-size:9.0pt'><b>Preference(s) of learning mode:</b></span> <input type="checkbox" name="cbReading" id="cbReading"><span
style='font-size:9.0pt'><b> Reading </b></span><input type="checkbox" name="cbVerbal" id="cbVerbal"><span style='font-size:
9.0pt'><b> Verbal </b></span><input type="checkbox" name="cbDoing" id="cbDoing"><span
style='font-size:9.0pt'><b> Doing </b></span><input type="checkbox" name="cbOtherMode" id="cbOtherMode"><span style='font-size:9.0pt'><b> Others:
<input type="textfield" id="txOtherMode" name="txOtherMode" /></b></span></p>
<br />

<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;text-indent:5.5pt'><span
style='font-size:9.0pt'><b>Will family / caregiver / other participant in
education process? </b></span><input name="rbFamily" class="rbFamily" type="radio" value="Yes" /><span
style='font-size:9.0pt'><b> Yes</b></span><input name="rbFamily" class="rbFamily" type="radio" value="No" /><span style='font-size:9.0pt'><b> No</b></span>
</p>
</div>
<br />
<div id="subform" >--- subform here ---</div>
<br/>

<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
text-indent:6.0pt'><span style='font-size:12.0pt'><b>Reverse Triage Process</b></span>
<span class="smallText">
	<button id="editDischarge" class="smallText">Edit</button>
	<span id="spanDischargeBtn" class="smallText">
	<button id="submit2" class="save">Save</button>
	<button id="cancelDischarge" class="cancel">Cancel</button>
	</span></p>
<div id="discharge">
<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='margin-left:12.5pt;border-collapse:collapse;border:1px solid black'>
 <tr>
  <td valign=top style='border:none;border-bottom:solid windowtext 1.0pt;
  background:#E5B8B7;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph'><span
  style='font-size:9.0pt'><b>Please "</b></span><span style='font-size:
  8.0pt;font-family:"Wingdings 2"'><b>P</b></span><span style='font-size:9.0pt'><b>" "on appropriate </b></span><span style='font-size:9.0pt;font-family:Wingdings'><b>o</b></span></p>
  </td>
  <td align="center" valign=top style='border:none;border-bottom:solid windowtext 1.0pt;
  background:#E5B8B7;padding:0in 5.4pt 0in 5.4pt'><b>N/A</b></td>
  <td align="center" valign=top style='border:none;border-bottom:solid windowtext 1.0pt;
  background:#E5B8B7;padding:0in 5.4pt 0in 5.4pt'><b>Done</b></td>
  <td align="center" valign=top style='border:none;border-bottom:solid windowtext 1.0pt;
  background:#E5B8B7;padding:0in 5.4pt 0in 5.4pt'><b>Description</b></td>
 </tr>
 <tr >
<td >
  	<p class=MsoNormal style='margin-left:207.35pt;text-indent:-196.45pt'><b>E</b><span
  	style='font-size:10.0pt'><b> ducation materials given</b></span></p>
  	</td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbE" name="rbE" value="N/A"/></p></td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbE" name="rbE" value="Done"/></p></td>
  	<td>
  	<table class="DischargeCell"><tr><td>
  	<span style='font-size:10.0pt'><b><input type="checkbox" id="cbFactSheet" name="cbFactSheet"/> Fact
  	Sheet</b></span></td>
  	<td>
  	<span style='font-size:10.0pt'><b><input type="checkbox" id="cbLeaflet" name="cbLeaflet"/> Education Leaflets</b></span>
  	</td></tr></table>
  	</td>
  	</tr>
  <tr><td>	
  	<p class=MsoNormal style='text-indent:11.0pt'><b>G</b><span
  	style='font-size:10.0pt'><b> uarantee treatment</b></span></p>
  	</td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbG" name="rbG" value="N/A"/></p></td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbG" name="rbG" value="Done"/></p></td>
  	<td>
  	<table class="DischargeCell"><tr><td>
  	<span style='font-size:10.0pt'><b><input type="checkbox" id="cbMedication" name="cbMedication"/> Medication</b></span>
  	</td><td>
  	<span style='font-size:10.0pt'><b><input type="checkbox" id="cbDressing" name="cbDressing"/> Dressing</b></span>
  	</td><td>
  	<span style='font-size:10.0pt'><b><input type="checkbox" id="cbInjection" name="cbInjection"/> Injection</b></span>
  	</td></tr></table>	
   	</td></tr>
  <tr><td>	
  	<p class=MsoNormal style='text-indent:11.0pt'><b>A
  	</b><span style='font-size:10.0pt'><b> dmission required</b></span></p>
  	</td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbA" name="rbA" value="N/A"/></p></td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbA" name="rbA" value="Done"/></p></td>
	<td></td></tr>
  <tr><td>	
  	<p class=MsoNormal style='margin-left:178.9pt;text-indent:-165.7pt'><b>I
  	</b><span style='font-size:10.0pt'><b> nformation given</b></span></p>	  	
  	</td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbI" name="rbI" value="N/A"/></p></td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbI" name="rbI" value="Done"/></p></td>
  	<td>
  	
  	<table class="DeschargeCell">
  	<tr><td>
  	<span style='font-size:10.0pt'><b><input type="checkbox" name="cbDrugSheet" id="cbDrugSheet" /> Drug Sheet</b></span>
  	</td><td>
  	<span style='font-size:10.0pt'><b><input type="checkbox" name="cbRefLetter" id="cbRefLetter" /> Referral letter</b></span>
  	</td><td>
  	<span style='font-size:10.0pt'><b><input type="checkbox" id="cbLabForm" name="cbLabForm"/> DI/Lab. form</b></span>
  	</td></tr>
  	<tr><td>
  	<span style='font-size:10.0pt'><b><input type="checkbox" name="cbSickLeave" id="cbSickLeave" /> Sick leave cert</b></span>
  	</td><td>
  	<span style='font-size:10.0pt'><b><input type="checkbox" name="cbDressingSheet" id="cbDressingSheet" /> Dressing Sheet</b></span>
  	</td><td>
  	<span style='font-size:10.0pt'><b><input type="checkbox" id="cbOtherInfo" name="cbOtherInfo"/> Others:</b>
  	<input type="textfield" id="txOtherInfo" name="txOtherInfo" /></span>
  	</td></tr>
  	</table>
  	  	
  </td></tr>
  <tr><td>	
  	<p class=MsoNormal style='margin-left:207.45pt;text-align:justify;text-justify:
  	inter-ideograph;text-indent:-196.45pt'><b>R</b><span
  	style='font-size:10.0pt'><b> eturn appointment making</b></span></p>
  	</td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbR" name="rbR" value="N/A"/></p></td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbR" name="rbR" value="Done"/></p></td>
  	<td>
  	<p class=MsoNormal style='margin-left:207.45pt;text-align:justify;text-justify:
  	inter-ideograph;text-indent:-196.45pt'><span
  	style='font-size:10.0pt'><b>Date : <input name="dtReturn" id="dtReturn" type="textfield" class="datepickerfield" maxlength="10" size="10"  onkeyup="validDate(this)" onblur="validDate(this)" /></b></span></p>
  	</td></tr>
  <tr><td>	
  	<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  	text-indent:11.0pt'><b>T</b><span style='font-size:10.0pt'><b> ransfer/Transport</b></span></p>
  	</td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbT" name="rbT" value="N/A"/></p></td>
  	<td><p class=MsoNormal style='text-indent:11.0pt'><input type="radio" class="rbT" name="rbT" value="Done"/></p></td>
  	<td>  	
  	<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
  	text-indent:11.0pt'>
  	<span style='font-size:10.0pt'><b><input name="rbAmbulance" class="rbAmbulance" type="radio" value="Self arrangement" /> Self arrangement</b></span>
  	<span style='font-size:10.0pt'><b><input name="rbAmbulance" class="rbAmbulance" type="radio" value="Ambulance" /> Ambulance </b></span></p>  	
  </td>
 </tr>
</table>

<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
text-indent:8.0pt'><span
style='font-size:9.0pt'><b>Please ensure to complete the form before discharge
the client.</b></span></p>

<br/>

<p class=MsoNormal style='text-align:justify;text-justify:inter-ideograph;
text-indent:5.5pt'><b>Discharge Date : <input name="dtDischarge" id="dtDischarge" type="textfield" class="datepickerfield" maxlength="10" size="10"  onkeyup="validDate(this)" onblur="validDate(this)" />
 Time: <select name='seDischargeHh' id='seDischargeHh'>
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
 </select></b>
 <span id="CreateUser" ><%=username==null?"":"<b>Completed by: <u>"+username+"</u></b>"%></span>
</p>
</div>
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
	$("#txSubform").val('<%=txSubform==null?"":txSubform%>');
	$("#txDischarge").val('<%=txDischarge==null?"":txDischarge%>');
	
	setDefault();
	setSection($("#txMain").val());
	setSection($("#txDischarge").val());
//-1 parameter for enable new line
	setSub(-1);
	
//patient not found	
	if (<%=disable %>) {
		$("input").attr({
			'disabled': 'disabled'
        });
		$("button").attr({
			'disabled': 'disabled'
        });
	} 
	
	setDisableDiv("main", true);
	setDisableDiv("discharge", true);

	$("#main input").click(function(){
		enableFld("main");
	});
	
	$("#discharge input").click(function(){
		enableFld("discharge");
	});

	$("#spanMainBtn").hide();
	$("#spanDischargeBtn").hide();
	
	$("#editMain").click(function(){
				
		if ($("#txMainUser").val() == "") {
			$("#txMainUser").val($("#user").val());
		}
		
		if ($("#txMainUser").val() == $("#user").val()) {
			setDisableDiv("main", false);
			enableFld("main");
			$("#spanMainBtn").show();
			$("#editMain").hide();
		} else {
			alert("This section was completed by " + $("#txMainUser").val());	
		}
		
		return false;
	});

	$("#editDischarge").click(function(){
		
		if ($("#txDischargeUser").val() == "") {
			$("#txDischargeUser").val($("#user").val());
		}
		  
		if ($("#txDischargeUser").val() == $("#user").val()) {
			setDisableDiv("discharge", false);
			enableFld("discharge");  
			$("#spanDischargeBtn").show();
			$("#editDischarge").hide();
		} else {
			alert("This section was completed by " + $("#txDischargeUser").val());	
		}
		
		return false;
	});
/*	
	$("#cancelMain").click(function(){
		$("#txMainUser").val('');
		setSection($("#txMain").val());
		setDisableDiv("main", true);
		$("#spanMainBtn").hide();
		$("#editMain").show();
		return false;
	});
	
	$("#cancelDischarge").click(function(){
		$("#txDischargeUser").val('');
		setSection($("#txDischarge").val());
		setDisableDiv("discharge", true);
		$("#spanDischargeBtn").hide();
		$("#editDischarge").show();	
		return false;
	});
*/
	$(".cancel").click(function(){
		$("#command").val("cancel");
	});

	$(".save").click(function(){
		$("#command").val("save");
		fill();
	});
	
/*	
	$("#report").click(function(){
		$("#command").val("report");
		fill();
	});
*/
							
});

function fill() {
//mainform		
	var data = '[{"cbCantonese":"' + $('#cbCantonese').is(":checked") +					
		'","cbEnglish":"' + $('#cbEnglish').is(":checked") +	
		'","cbMandarin":"' + $('#cbMandarin').is(":checked") +	
		'","cbOtherLanguage":"' +  $('#cbOtherLanguage').is(":checked") +	
		'","txOtherLanguage":"' + $("#txOtherLanguage").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"') + 
		'","rbTranslator":"' + $("input[name='rbTranslator']:checked").val() + 
		'","rbDefine":"' + $("input[name='rbDefine']:checked").val() + 
		'","rbBarrier":"' + $("input[name='rbBarrier']:checked").val() + 
		'","cbVisual":"' + $('#cbVisual').is(":checked") +	
		'","cbHearing":"' + $('#cbHearing').is(":checked") +	
		'","cbUnableRead":"' + $('#cbUnableRead').is(":checked") +	
		'","cbOtherBarrier":"' + $('#cbOtherBarrier').is(":checked") +	
		'","txOtherBarrier":"' + $("#txOtherBarrier").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"') + 
		'","rbCognitive":"' + $("input[name='rbCognitive']:checked").val() + 
		'","rbCultural":"' + $("input[name='rbCultural']:checked").val() + 
		'","rbReligious":"' + $("input[name='rbReligious']:checked").val() + 
		'","rbEmotional":"' + $("input[name='rbEmotional']:checked").val() + 
		'","txEmotional":"' + $("#txEmotional").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"') + 
		'","rbMotive":"' + $("input[name='rbMotive']:checked").val() + 
		'","txMotive":"' + $("#txMotive").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"') + 
		'","cbReading":"' + $('#cbReading').is(":checked") +	
		'","cbVerbal":"' + $('#cbVerbal').is(":checked") +	
		'","cbDoing":"' + $('#cbDoing').is(":checked") +	
		'","rbFamily":"' + $("input[name='rbFamily']:checked").val() + 
		'","cbOtherMode":"' + $('#cbOtherMode').is(":checked") +	
		'","txOtherMode":"' + $("#txOtherMode").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"') + 
		
		'","rbEduLevel":"' + $("input[name='rbEduLevel']:checked").val() +
		'","cbCaregiver":"' + $('#cbCaregiver').is(":checked") +	
		'","cbFamily":"' + $('#cbFamily').is(":checked") +
		'","txMainUser":"' + $("#txMainUser").val() + '"}]'; 
	
	data = data.replace(/undefined/g, "");
	
	if ($("#txMainUser").val() != "")
		$("#txMain").val(data);
	
	data = '[{"rbE":"' + $("input[name='rbE']:checked").val() + 
		'","rbG":"' + $("input[name='rbG']:checked").val() + 
		'","rbA":"' + $("input[name='rbA']:checked").val() + 
		'","rbI":"' + $("input[name='rbI']:checked").val() + 
		'","rbR":"' + $("input[name='rbR']:checked").val() + 
		'","rbT":"' + $("input[name='rbT']:checked").val() + 
		'","cbFactSheet":"' + $('#cbFactSheet').is(":checked") +
		'","cbLeaflet":"' + $('#cbLeaflet').is(":checked") +
		'","cbMedication":"' + $('#cbMedication').is(":checked") +
		'","cbDressing":"' + $('#cbDressing').is(":checked") +
		'","cbInjection":"' + $('#cbInjection').is(":checked") +
		'","cbDrugSheet":"' + $('#cbDrugSheet').is(":checked") +	
		'","cbRefLetter":"' + $('#cbRefLetter').is(":checked") +	
		'","cbSickLeave":"' + $('#cbSickLeave').is(":checked") +	
		'","cbDressingSheet":"' + $('#cbDressingSheet').is(":checked") +			
		'","cbLabForm":"' + $('#cbLabForm').is(":checked") +
		'","cbOtherInfo":"' + $('#cbOtherInfo').is(":checked") +
		'","txOtherInfo":"' + $("#txOtherInfo").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"') +

		'","dtReturn":"' + $("#dtReturn").val() + 
		'","rbAmbulance":"' + $("input[name='rbAmbulance']:checked").val() + 
		'","dtDischarge":"' + $("#dtDischarge").val() + 
		'","seDischargeHh":"' + $("#seDischargeHh").val() +
		'","seDischargeMi":"' + $("#seDischargeMi").val() + 
		
		'","txDischargeUser":"' + $("#txDischargeUser").val() + '"}]'; 
		
	data = data.replace(/undefined/g, "");

	if ($("#txDischargeUser").val() != "")
		$("#txDischarge").val(data);
/*	
//subform - only for fixed entries		
	for (var i = 0; i < 4; i++) {
		
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
	
	$("#txSubform").val("[" + data + "]");	
*/	
}


/*
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
	if (code == "6")
		return "Reinforce specific content";
	else if (code == "7")
		return "Have patient practiced demonstration";
	else if (code == "8")
		return "Re-attempt teaching";
	else if (code == "9")
		return "Referral";
	else if (code == "10")
		return "Teaching completed";
	else
		return code;
}

function getDiscipline(code) {
	if (code == "DR")
		return "Doctor";
	else if (code == "N")
		return "Nurse";
	else if (code == "CH")
		return "Chaplain";
	else if (code == "RD")
		return "Registered Dietitian";
	else if (code == "LT")
		return "Lab Technician";
	else if (code == "PT")
		return "Physiotherapist";
	else if (code == "PH")
		return "Pharmacist";
	else if (code == "RG")
		return "Radiographer";	
	else
		return code;
}
*/

function setDefault() {
	var d = new Date();
	
	//set default value 
	$("#cbCantonese").attr('checked', true);
	$("input[name=rbTranslator][value=No]").attr("checked",true);
	$("input[name=rbDefine][value=No]").attr("checked",true);
	$("input[name=rbBarrier][value=No]").attr("checked",true);
	$("input[name=rbCognitive][value=No]").attr("checked",true);
	$("input[name=rbCultural][value=No]").attr("checked",true);
	$("input[name=rbReligious][value=No]").attr("checked",true);
	$("input[name=rbEmotional][value=Stable]").attr("checked",true);
	$("input[name=rbMotive][value=Good]").attr("checked",true);
	$("#cbReading").attr('checked', true);
	$("#cbVerbal").attr('checked', true);
	
	$("#dtDischarge").val( addZero(d.getDate()) + "/" + addZero(d.getMonth() + 1) + "/" + d.getFullYear());
	
	document.getElementById('seDischargeHh').value = addZero(d.getHours());
	document.getElementById('seDischargeMi').value = addZero(d.getMinutes());
		
	if ("<%=lang%>" == "ENG") {
		$("#cbEnglish").attr('checked', true);
	} else if ("<%=lang%>" == "TRC") {
		$("#cbCantonese").attr('checked', true);
	} else if ("<%=lang%>" == "SMC") {
		$("#cbMandrin").attr('checked', true);
	}
	
	$("input[name=rbEduLevel]").attr('checked',false);
	$("input[name=rbEduLevel][value=" + "<%=rbEduLevel%>" + "]").attr("checked",true);
}

function setSection(data) {
		
	if  (data != "") {
		
		var obj = JSON.parse(data);

		for (field in obj[0]) {
			
			if (field.substring(0,2) == "rb") {
				$("input[name=" + field + "]").attr('checked',false);
				$("input[name=" + field + "][value='" + obj[0][field] + "']").attr("checked",true);
			
			} else if (field.substring(0,2) == "cb") {

				if (obj[0][field] == 'true')
					$("#" + field).attr('checked', true);
				else
					$("#" + field).attr('checked', false);
				
			} else {
				
				if (document.getElementById(field) != null)
					document.getElementById(field).value = obj[0][field];
				
			}			
		}
	}

}

function setSub(row) {
	
	var subform = $("#txSubform").val();
	
	var html = "<table id='subTable'><tr>" + 
		"<th>Date</th>" +
		"<th>Content (Brief Explanation)</th>" +
		"<th>Learner</th>" +
		"<th>Teaching Method</th>" +
		"<th>Response</th>" +
		"<th>Learner Need</th>" +
		"<th>Discipline</th>" +
		"<th width='120'>Create User</th>" +
		"</tr>";
		
	var user = [];		
	
	if  (subform != "") { 
		var obj = JSON.parse(subform);
		var i;

		for (i in obj) {			
			if (i == row) {
				
				html += "<tr valign=top>" + 
					"<td><input name='dtEdu' id='dtEdu' type='textfield' class='datepickerfield' maxlength='10' onkeyup='validDate(this)' onblur='validDate(this)' /></td>" +
					"<td><input type='textfield' id='txContent' name='txContent' /></td>" +
					"<td><input type='checkbox' id='cbLearnerC' /> Caregiver/other<br />" + 
						"<input type='checkbox' id='cbLearnerFM' /> Family<br />" + 
						"<input type='checkbox' id='cbLearnerP' /> Patient<br />" + 
			  			"</td>" +	  		
			  		"<td><input type='checkbox' id='cbMethodQ' />Question-answer<br />" +
						"<input type='checkbox' id='cbMethodD' />Demonstration<br />" +
						"<input type='checkbox' id='cbMethodE' />Explanation<br />" +
						"<input type='checkbox' id='cbMethodW' />Other written material<br />" +
						"<input type='checkbox' id='cbMethodV' />Visual<br />" +															  	
		  				"</td>" +  			
	  				"<td><input type='checkbox' id='cbResponse1' />Asked questions<br />" +
						"<input type='checkbox' id='cbResponse2' />Indicates understanding/answered questions<br />" +
						"<input type='checkbox' id='cbResponse3' />Return demonstration correct<br />" +
						"<input type='checkbox' id='cbResponse4' />Disinterested/refuses information<br />" +
						"<input type='checkbox' id='cbResponse5' />Unable to understand<br />" +  			
	  					"</td>" +  			
	  				"<td><input type='checkbox' id='cbNeed1' />Reinforce specific content<br />" +
						"<input type='checkbox' id='cbNeed2' />Have patient practiced demonstration<br />" +
						"<input type='checkbox' id='cbNeed3' />Re-attempt teaching<br />" +
						"<input type='checkbox' id='cbNeed4' />Referral<br />" +
						"<input type='checkbox' id='cbNeed5' />Teaching completed<br />" +
						"</td>" +			
	  				"<td><input type='checkbox' id='cbDR' />Doctor<br />" +
						"<input type='checkbox' id='cbN' />Nurse<br />" +
						"<input type='checkbox' id='cbCH' />Chaplain<br />" +
						"<input type='checkbox' id='cbRD' />Registered Dietitian<br />" +
						"<input type='checkbox' id='cbLT' />Lab Technician<br />" +
						"<input type='checkbox' id='cbPT' />Physiotherapist<br />" +
						"<input type='checkbox' id='cbPH' />Pharmacist<br />" +
						"<input type='checkbox' id='cbRG' />Radiographer<br />" +		  				
						"<input type='checkbox' id='cbHE' />Health Educator<br />" +		  				
						"</td>" +
					"<td><button onCLick='saveRow(" + i.toString() + ")'>OK</button>" +
						"<button onCLick='setSub(-1)'>Cancel</button></td>" +			
					"</tr>";			
				
			} else {
								
				html += "<tr valign=top>" + 
					"<td>" + obj[i].dtEdu + "</td>";
					
                if (obj[i].txContent != null)
                	html +=	"<td>" + obj[i].txContent.replace(/</g, "&lt;").replace(/&/g, "&amp;") + "</td>";
                else
                	html +=	"<td></td>";
                	                	
                html +=	"<td>";
					
				if (obj[i].cbLearnerC == 'true')
					html += "Caregiver/other<br />";
					
				if (obj[i].cbLearnerFM == 'true')
					html += "Family<br />";
					
				if (obj[i].cbLearnerP == 'true')
					html += "Patient<br />";
				
				html +=	"</td><td>";
				
				if (obj[i].cbMethodQ == 'true')
					html += "Question-answer<br />";
					
				if (obj[i].cbMethodD == 'true')
					html += "Demonstration<br />";
					
				if (obj[i].cbMethodE == 'true')
					html += "Explanation<br />";
				
				if (obj[i].cbMethodW == 'true')
					html += "Other written material<br />";
						
				if (obj[i].cbMethodV == 'true')
					html += "Visual<br />";
					
				html +=	"</td><td>";
					
				if (obj[i].cbResponse1 == 'true')
					html += "Asked questions<br />";
					
				if (obj[i].cbResponse2 == 'true')
					html += "Indicates understanding/answered questions<br />";
					
				if (obj[i].cbResponse3 == 'true')
					html += "Return demonstration correct<br />";
				
				if (obj[i].cbResponse4 == 'true')
					html += "Disinterested/refuses information<br />";
						
				if (obj[i].cbResponse5 == 'true')
					html += "Unable to understand<br />";
					
				html +=	"</td><td>";
				
				if (obj[i].cbNeed1 == 'true')
					html += "Reinforce specific content<br />";
					
				if (obj[i].cbNeed2 == 'true')
					html += "Have patient practiced demonstration<br />";
					
				if (obj[i].cbNeed3 == 'true')
					html += "Re-attempt teaching<br />";
				
				if (obj[i].cbNeed4 == 'true')
					html += "Referral<br />";
						
				if (obj[i].cbNeed5 == 'true')
					html += "Teaching completed<br />";
					
				html +=	"</td><td>";
				
				if (obj[i].cbDR == 'true')
					html += "Doctor<br />";
					
				if (obj[i].cbN == 'true')
					html += "Nurse<br />";
					
				if (obj[i].cbCH == 'true')
					html += "Chaplain<br />";
				
				if (obj[i].cbRD == 'true')
					html += "Registered Dietitian<br />";
						
				if (obj[i].cbLT == 'true')
					html += "Lab Technician<br />";
				
				if (obj[i].cbPT == 'true')
					html += "Physiotherapist<br />";
					
				if (obj[i].cbPH == 'true')
					html += "Pharmacist<br />";
					
				if (obj[i].cbRG == 'true')
					html += "Radiographer<br />";

				if (obj[i].cbHE == 'true')
					html += "Health Educator<br />";
						
				html +=	"</td><td>";
										
				if ( $("#user").val() == obj[i].txSubUser ) {					
					html += "<button onCLick='setSub(" + i.toString() + ")'>Modify</button>" +
						"<button onCLick='delRow(" + i.toString() + ")'>Delete</button>"
				} else {
					html += "<span id='user" + i + "'>" + obj[i].txSubUser + "</span>"
					user[i] = obj[i].txSubUser;
				}
						
				html += "</td></tr>";
			}					
		}
	}
		
	if (row == -1) {
		html += "<tr valign=top>" + 
			"<td><input name='dtEdu' id='dtEdu' type='textfield' class='datepickerfield' maxlength='10' onkeyup='validDate(this)' onblur='validDate(this)' /></td>" +
			"<td><input type='textfield' id='txContent' name='txContent'/></td>" +
			"<td><input type='checkbox' id='cbLearnerC' /> Caregiver/other<br />" + 
				"<input type='checkbox' id='cbLearnerFM' /> Family<br />" + 
				"<input type='checkbox' id='cbLearnerP' /> Patient<br />" + 
	  			"</td>" +	  		
	  		"<td><input type='checkbox' id='cbMethodQ' />Question-answer<br />" +
				"<input type='checkbox' id='cbMethodD' />Demonstration<br />" +
				"<input type='checkbox' id='cbMethodE' />Explanation<br />" +
				"<input type='checkbox' id='cbMethodW' />Other written material<br />" +
				"<input type='checkbox' id='cbMethodV' />Visual<br />" +															  	
				"</td>" +  			
			"<td><input type='checkbox' id='cbResponse1' />Asked questions<br />" +
				"<input type='checkbox' id='cbResponse2' />Indicates understanding/answered questions<br />" +
				"<input type='checkbox' id='cbResponse3' />Return demonstration correct<br />" +
				"<input type='checkbox' id='cbResponse4' />Disinterested/refuses information<br />" +
				"<input type='checkbox' id='cbResponse5' />Unable to understand<br />" +  			
				"</td>" +  			
			"<td><input type='checkbox' id='cbNeed1' />Reinforce specific content<br />" +
				"<input type='checkbox' id='cbNeed2' />Have patient practiced demonstration<br />" +
				"<input type='checkbox' id='cbNeed3' />Re-attempt teaching<br />" +
				"<input type='checkbox' id='cbNeed4' />Referral<br />" +
				"<input type='checkbox' id='cbNeed5' />Teaching completed<br />" +
			"</td>" +			
				"<td><input type='checkbox' id='cbDR' />Doctor<br />" +
				"<input type='checkbox' id='cbN' />Nurse<br />" +
				"<input type='checkbox' id='cbCH' />Chaplain<br />" +
				"<input type='checkbox' id='cbRD' />Registered Dietitian<br />" +
				"<input type='checkbox' id='cbLT' />Lab Technician<br />" +
				"<input type='checkbox' id='cbPT' />Physiotherapist<br />" +
				"<input type='checkbox' id='cbPH' />Pharmacist<br />" +
				"<input type='checkbox' id='cbRG' />Radiographer<br />" +	
				"<input type='checkbox' id='cbHE' />Health Educator<br />" +					
				"</td>" +
			"<td><button onCLick='addRow()'>Save</button></td>" +			
			"</tr>";			
	}
				
	html += "</table>";
	
	document.getElementById("subform").innerHTML = html;	
	
	for (i = 0; i < user.length; i++) {
		if (user[i] != null)
			getUsername(user[i], "user" + i);
	}
	
	$("#dtEdu").datepicker();
	
	if (row >= 0) {
		
		for (field in obj[row]) {
			
			if (field.substring(0,2) == "rb") {
				$("input[name=" + field + "]").attr('checked',false);
				$("input[name=" + field + "][value='" + obj[row][field] + "']").attr("checked",true);
			
			} else if (field.substring(0,2) == "cb") {

				if (obj[row][field] == 'true')
					$("#" + field).attr('checked', true);
				else
					$("#" + field).attr('checked', false);
				
			} else {
				
				if (document.getElementById(field) != null)
					document.getElementById(field).value = obj[row][field];
				
			}			
		}		
/*		
		$("#dtEdu").val(obj[row].dtEdu);
		$("#txContent").val(obj[row].txContent);
		
		if (document.getElementById('seLearner') != null)
			document.getElementById('seLearner').value = obj[row].seLearner;
				
		if (document.getElementById('seMethod') != null)
			document.getElementById('seMethod').value = obj[row].seMethod;
				
		if (document.getElementById('seResponse') != null)
			document.getElementById('seResponse').value = obj[row].seResponse;
				
		if (document.getElementById('seNeed') != null)
			document.getElementById('seNeed').value = obj[row].seNeed;
				
		if (document.getElementById('seDiscipline') != null)
			document.getElementById('seDiscipline').value = obj[row].seDiscipline;
*/

	}
	
	return false;
}

/*
 *For fixed size subform     
 *
function getSub() {
	
	var subform = $("#txSubform").val();
	
	var html = "<table id='subTable'><tr>" + 
		"<th>Date</th>" +
		"<th>Content (Brief Explanation)</th>" +
		"<th>Learner</th>" +
		"<th>Teaching Method</th>" +
		"<th>Response</th>" +
		"<th>Learner Need</th>" +
		"<th>Discipline</th>" +
		"</tr>";
		
	for (var i = 0; i < 4; i++) {
			html += "<tr>" + 
				"<td><input name='dtEdu' id='dtEdu" + i + "' type='textfield' class='dtEdu' maxlength='10' onkeyup='validDate(this)' onblur='validDate(this)' /></td>" +
				"<td><input type='textfield' id='txContent" + i + "' name='txContent' class='txContent'/></td>" +
				"<td><select name='seLearner' id='seLearner" + i + "' class='txContent'>" +
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
					"<option value='6'>" + getNeed("6") + "</option>" +
					"<option value='7'>" + getNeed("7") + "</option>" +
					"<option value='8'>" + getNeed("8") + "</option>" +
		  			"<option value='9'>" + getNeed("9") + "</option>" +
		  			"<option value='10'>" + getNeed("10") + "</option>" +		  			
				"</select></td>" +			
  				"<td><select name='seDiscipline' id='seDiscipline" + i + "' class='seDiscipline'>" +
	  				"<option value=''></option>" +
					"<option value='DR'>" + getDiscipline("DR") + "</option>" +
					"<option value='N'>" + getDiscipline("N") + "</option>" +
					"<option value='CH'>" + getDiscipline("CH") + "</option>" +
	  				"<option value='RD'>" + getDiscipline("RD") + "</option>" +
  					"<option value='LT'>" + getDiscipline("LT") + "</option>" +
  					"<option value='PT'>" + getDiscipline("PT") + "</option>" +
	  				"<option value='PH'>" + getDiscipline("PH") + "</option>" +
	  				"<option value='RG'>" + getDiscipline("RG") + "</option>" +  				  				
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
*/

function validateRow() {
	
	if (!$("#dtEdu").val().trim()) {
		alert("Please enter education date");
		return false;
	}
	
	return true;
}

function addRow(){
	
	if (!validateRow())
		return false;
	
	var subform = $("#txSubform").val();	
	
	var newData = '{"dtEdu":"' + $("#dtEdu").val() + '",'
		+ '"txContent":"' + $("#txContent").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"') + '",'
		+ '"cbLearnerC":"' + $('#cbLearnerC').is(":checked") + '",'
		+ '"cbLearnerFM":"' + $('#cbLearnerFM').is(":checked") + '",'
		+ '"cbLearnerP":"' + $('#cbLearnerP').is(":checked") + '",'
		+ '"cbMethodQ":"' + $('#cbMethodQ').is(":checked") + '",'
		+ '"cbMethodD":"' + $('#cbMethodD').is(":checked") + '",'
		+ '"cbMethodE":"' + $('#cbMethodE').is(":checked") + '",'
		+ '"cbMethodW":"' + $('#cbMethodW').is(":checked") + '",'
		+ '"cbMethodV":"' + $('#cbMethodV').is(":checked") + '",'
		+ '"cbResponse1":"' + $('#cbResponse1').is(":checked") + '",'
		+ '"cbResponse2":"' + $('#cbResponse2').is(":checked") + '",'
		+ '"cbResponse3":"' + $('#cbResponse3').is(":checked") + '",'
		+ '"cbResponse4":"' + $('#cbResponse4').is(":checked") + '",'
		+ '"cbResponse5":"' + $('#cbResponse5').is(":checked") + '",'
		+ '"cbNeed1":"' + $('#cbNeed1').is(":checked") + '",'
		+ '"cbNeed2":"' + $('#cbNeed2').is(":checked") + '",'
		+ '"cbNeed3":"' + $('#cbNeed3').is(":checked") + '",'
		+ '"cbNeed4":"' + $('#cbNeed4').is(":checked") + '",'
		+ '"cbNeed5":"' + $('#cbNeed5').is(":checked") + '",'
		+ '"cbDR":"' + $('#cbDR').is(":checked") + '",'
		+ '"cbN":"' + $('#cbN').is(":checked") + '",'
		+ '"cbCH":"' + $('#cbCH').is(":checked") + '",'
		+ '"cbRD":"' + $('#cbRD').is(":checked") + '",'
		+ '"cbLT":"' + $('#cbLT').is(":checked") + '",'
		+ '"cbPT":"' + $('#cbPT').is(":checked") + '",'
		+ '"cbPH":"' + $('#cbPH').is(":checked") + '",'
		+ '"cbRG":"' + $('#cbRG').is(":checked") + '",'	
		+ '"cbHE":"' + $('#cbHE').is(":checked") + '",'			
		+ '"txSubUser":"' + $("#user").val() + '"}';
		    
    if (subform == "") {
    	$("#txSubform").val('[' + newData + ']');
    } else {
    	
		var obj = JSON.parse(subform);
    	var newObj = JSON.parse(newData);
    	obj.push(newObj);
    	$("#txSubform").val(JSON.stringify(obj));	    	
    }
    
    //setSub(-1);
	$("#command").val("save");
	
    return true;
									
}

function saveRow(row){
	
	if (!validateRow())
		return false;
	
	var subform = $("#txSubform").val();	
	
	var newData = '{"dtEdu":"' + $("#dtEdu").val() + '",'
		+ '"txContent":"' + $("#txContent").val().replace(/\\/g, '\\\\').replace(/\"/g, '\\\"') + '",'		
		+ '"cbLearnerC":"' + $('#cbLearnerC').is(":checked") + '",'
		+ '"cbLearnerFM":"' + $('#cbLearnerFM').is(":checked") + '",'
		+ '"cbLearnerP":"' + $('#cbLearnerP').is(":checked") + '",'
		+ '"cbMethodQ":"' + $('#cbMethodQ').is(":checked") + '",'
		+ '"cbMethodD":"' + $('#cbMethodD').is(":checked") + '",'
		+ '"cbMethodE":"' + $('#cbMethodE').is(":checked") + '",'
		+ '"cbMethodW":"' + $('#cbMethodW').is(":checked") + '",'
		+ '"cbMethodV":"' + $('#cbMethodV').is(":checked") + '",'
		+ '"cbResponse1":"' + $('#cbResponse1').is(":checked") + '",'
		+ '"cbResponse2":"' + $('#cbResponse2').is(":checked") + '",'
		+ '"cbResponse3":"' + $('#cbResponse3').is(":checked") + '",'
		+ '"cbResponse4":"' + $('#cbResponse4').is(":checked") + '",'
		+ '"cbResponse5":"' + $('#cbResponse5').is(":checked") + '",'
		+ '"cbNeed1":"' + $('#cbNeed1').is(":checked") + '",'
		+ '"cbNeed2":"' + $('#cbNeed2').is(":checked") + '",'
		+ '"cbNeed3":"' + $('#cbNeed3').is(":checked") + '",'
		+ '"cbNeed4":"' + $('#cbNeed4').is(":checked") + '",'
		+ '"cbNeed5":"' + $('#cbNeed5').is(":checked") + '",'
		+ '"cbDR":"' + $('#cbDR').is(":checked") + '",'
		+ '"cbN":"' + $('#cbN').is(":checked") + '",'
		+ '"cbCH":"' + $('#cbCH').is(":checked") + '",'
		+ '"cbRD":"' + $('#cbRD').is(":checked") + '",'
		+ '"cbLT":"' + $('#cbLT').is(":checked") + '",'
		+ '"cbPT":"' + $('#cbPT').is(":checked") + '",'
		+ '"cbPH":"' + $('#cbPH').is(":checked") + '",'
		+ '"cbRG":"' + $('#cbRG').is(":checked") + '",'
		+ '"cbHE":"' + $('#cbHE').is(":checked") + '",'			
		+ '"txSubUser":"' + $("#user").val() + '"}';
      	
	var obj = JSON.parse(subform);
    var newObj = JSON.parse(newData);
    obj.splice(row, 1, newObj);
    
    $("#txSubform").val(JSON.stringify(obj));	    	
    
    //setSub(-1);
	$("#command").val("save");
	
    return true;
									
}

function delRow(row){
	
	var subform = $("#txSubform").val();	
			     	
	var obj = JSON.parse(subform);
	obj.splice(row, 1);
    $("#txSubform").val(JSON.stringify(obj))	    	
    
    //setSub(-1);
	$("#command").val("save");
	
    return true;
									
}

function addZero(n){
	  if(n < 10){
	    return "0" + n;
	  }
	  return n
}

function enableFld(div){
	
	if (div == "main") {
		if ($('#cbOtherLanguage').is(":checked")) { 
			$("#txOtherLanguage").removeAttr('disabled');
		} else {
			$('#txOtherLanguage').attr({'disabled': 'disabled'});
			$('#txOtherLanguage').val("");
		}
		
		if ($("input[name='rbBarrier']:checked").val() == "Yes") {
			$("#cbVisual").removeAttr('disabled');
			$("#cbHearing").removeAttr('disabled');
			$("#cbUnableRead").removeAttr('disabled');
			$("#cbOtherBarrier").removeAttr('disabled');		 
		} else {
			$("#cbVisual").attr('checked', false);
			$("#cbVisual").attr({'disabled': 'disabled'});
			$("#cbHearing").attr('checked', false);
			$("#cbHearing").attr({'disabled': 'disabled'});		
			$("#cbUnableRead").attr('checked', false);
			$("#cbUnableRead").attr({'disabled': 'disabled'});		
			$("#cbOtherBarrier").attr('checked', false);
			$("#cbOtherBarrier").attr({'disabled': 'disabled'});		
		}
		
		if ($('#cbOtherBarrier').is(":checked")) {
			$("#txOtherBarrier").removeAttr('disabled');
		} else {
			$('#txOtherBarrier').attr({'disabled': 'disabled'});
			$('#txOtherBarrier').val("");
		}
		
		if ($('#cbOtherMode').is(":checked")) { 
			$("#txOtherMode").removeAttr('disabled');
		} else {
			$('#txOtherMode').attr({'disabled': 'disabled'});
			$('#txOtherMode').val("");
		}
	}
	
	if (div == "discharge") {		
		if ($('#cbOtherInfo').is(":checked")) { 
			$("#txOtherInfo").removeAttr('disabled');
		} else {
			$('#txOtherInfo').attr({'disabled': 'disabled'});
			$('#txOtherInfo').val("");
		}
	}
	
}

function setDisableDiv(div, disable) {
	var node = document.getElementById(div).getElementsByTagName('input');
		
	for(var i = 0; i < node.length; i++){
    	node[i].disabled = disable;
    }
	
	var node = document.getElementById(div).getElementsByTagName('select');
	
	for(var i = 0; i < node.length; i++){
    	node[i].disabled = disable;
    }

}

function getUsername(userID, spanID ) {

    var d = new Date();
    var n = d.getTime();

	$.post("getCISUser.jsp",
		{
			userID: userID,
			time: n
		},
		function(data, status){
			if (status == "success") {											
				document.getElementById(spanID).innerHTML = data;															
			} else {
				alert(status);
			}
		});					
}				

-->
</script>
</DIV>
</DIV>
</DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>
