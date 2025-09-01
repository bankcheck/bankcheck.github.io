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
<%
String formID = "FTOCC";

String command = request.getParameter("command");
String system = request.getParameter("system");
String user = request.getParameter("user");

String regid = request.getParameter("regid");
String seq = request.getParameter("seq");
String readonly = request.getParameter("readonly");

String rbFever1 = request.getParameter("rbFever1");
String rbFever2 = request.getParameter("rbFever2");
String rbTravel1 = request.getParameter("rbTravel1");
String rbTravel2 = request.getParameter("rbTravel2");
String rbOcc1 = request.getParameter("rbOcc1");
String rbOcc2 = request.getParameter("rbOcc2");
String rbContact = request.getParameter("rbContact");
String rbCluster = request.getParameter("rbCluster");
String rbHosp = request.getParameter("rbHosp");
String txTemp = request.getParameter("txTemp");
String txMed = TextUtil.parseStrUTF8(request.getParameter("txMed"));
String txTravel = TextUtil.parseStrUTF8(request.getParameter("txTravel"));
String txHosp = TextUtil.parseStrUTF8(request.getParameter("txHosp"));
String dtAdm = request.getParameter("dtAdm");
String txDuration = request.getParameter("txDuration");
String txDiag = TextUtil.parseStrUTF8(request.getParameter("txDiag"));
//20240702 new fields
String rbContact1 = request.getParameter("rbContact1");
String rbContact2 = request.getParameter("rbContact2");
String rbContact3 = request.getParameter("rbContact3");

String patno = null;
String sex = null;
String patname = null;
String dob = null;
String room = null;

boolean disable = false;

ReportableListObject version = CMSDB.getCurrentForm(formID);
String currentForm = version.getValue(0);

if ("Y".equals(readonly)) {
	disable = true;
}

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

System.out.println("[FTOCC] regid=" + regid + " system=" + system + " user=" + user + " command=" + command);

Calendar calendar = Calendar.getInstance();
String currentDate = DateTimeUtil.formatDateTime(calendar.getTime());

try {
	
	ArrayList patRec = null;
	
	if(regid.contains("-")){
		String[] output = regid.split("-");	
		patno = output[1];
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
	} else {
		message = "Patient reord not found";
		disable = true;
	}
	
	try {
        int i = Integer.parseInt(regid);
        room = PatientDB.getRoom(regid);  
    } catch (Exception e) {
        room = "";
    }
	
	if ("create".equals(command)){
		
//		System.out.println("[DEBUG] add FTOCC regid=" + regid + " system=" + system + " user=" + user + " command=" + command);
//		System.out.println("[DEBUG] add FTOCC rbFever1=" + rbFever1 + " rbFever2=" + rbFever2 + " rbTravel1=" + rbTravel1 + " rbTravel2=" + rbTravel2 + " rbOcc1=" + rbOcc1+ " rbOcc2=" + rbOcc2+ " rbContact=" + rbContact+ " rbCluster=" + rbCluster+ " rbHosp=" + rbHosp);
//		System.out.println("[DEBUG] add FTOCC txTemp=" + txTemp + " txMed=" + txMed + " txTravel=" + txTravel + " txHosp=" + txHosp + " dtAdm=" + dtAdm+ " txDuration=" + txDuration+ " txDiag=" + txDiag);

		if (PatientDB.addFTOCCData(regid, system, user, rbFever1, rbFever2, rbTravel1,
				rbTravel2, rbOcc1, rbOcc2, rbContact, rbCluster, rbHosp, txTemp, 
				txMed, txTravel, txHosp, dtAdm, txDuration, txDiag,
//20240702 add new fields				
				rbContact1, rbContact2, rbContact3 )) {
			
			message = "FTOCC data saved.";
			
		} else {
			
			errorMessage = "Failed to save FTOCC data.";
//			System.out.println("[DEBUG] FTOCC error:" + errorMessage);

		}
		
	} else if("report".equals(command)){
		
		ArrayList record = PatientDB.getFTOCCRec(regid, seq);

//get report version
		String reportPath = null;
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			String createDt = row.getValue(3);
			
			version = CMSDB.getFormVersion(formID, createDt,  "dd/mm/yyyy hh24:mi:ss" );
			reportPath = version.getValue(1);
		}
		
		File reportFile = new File(application.getRealPath(reportPath));
//		File reportFile = new File(application.getRealPath("/report/RPT_FTOCC.jasper"));
		
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
			return;
		}
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
	{font-family:"MS Mincho";
	panose-1:2 2 6 9 4 2 5 8 3 4;}
@font-face
	{font-family:PMingLiU;
	panose-1:2 2 5 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Cambria;
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"3 of 9 Barcode";
	panose-1:4 2 114 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Monotype Sorts";
	panose-1:0 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"\@PMingLiU";
	panose-1:2 2 5 0 0 0 0 0 0 0;}
@font-face
	{font-family:"\@MS Mincho";
	panose-1:2 2 6 9 4 2 5 8 3 4;}
 /* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Arial","sans-serif";}
h1
	{mso-style-link:"Heading 1 Char";
	margin:0in;
	margin-bottom:.0001pt;
	page-break-after:avoid;
	font-size:10.0pt;
	font-family:"Arial","sans-serif";}
h2
	{mso-style-link:"Heading 2 Char";
	margin:0in;
	margin-bottom:.0001pt;
	text-align:center;
	page-break-after:avoid;
	font-size:10.0pt;
	font-family:"Arial","sans-serif";}
h3
	{mso-style-link:"Heading 3 Char";
	margin:0in;
	margin-bottom:.0001pt;
	text-align:center;
	page-break-after:avoid;
	font-size:18.0pt;
	font-family:"Arial","sans-serif";}
h4
	{mso-style-link:"Heading 4 Char";
	margin:0in;
	margin-bottom:.0001pt;
	page-break-after:avoid;
	font-size:28.0pt;
	font-family:"3 of 9 Barcode";
	font-weight:normal;}
h5
	{mso-style-link:"Heading 5 Char";
	margin:0in;
	margin-bottom:.0001pt;
	page-break-after:avoid;
	layout-grid-mode:char;
	font-size:10.5pt;
	font-family:"Arial","sans-serif";}
h6
	{mso-style-link:"Heading 6 Char";
	margin:0in;
	margin-bottom:.0001pt;
	page-break-after:avoid;
	layout-grid-mode:char;
	font-size:11.0pt;
	font-family:"Arial","sans-serif";}
p.MsoHeading7, li.MsoHeading7, div.MsoHeading7
	{mso-style-link:"Heading 7 Char";
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:13.5pt;
	margin-bottom:.0001pt;
	text-indent:-13.5pt;
	page-break-after:avoid;
	font-size:11.0pt;
	font-family:"Arial","sans-serif";
	font-weight:bold;}
p.MsoNormalIndent, li.MsoNormalIndent, div.MsoNormalIndent
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:24.0pt;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Arial","sans-serif";}
p.MsoHeader, li.MsoHeader, div.MsoHeader
	{mso-style-link:"Header Char";
	margin:0in;
	margin-bottom:.0001pt;
	layout-grid-mode:char;
	font-size:10.0pt;
	font-family:"Arial","sans-serif";}
p.MsoFooter, li.MsoFooter, div.MsoFooter
	{mso-style-link:"Footer Char";
	margin:0in;
	margin-bottom:.0001pt;
	layout-grid-mode:char;
	font-size:10.0pt;
	font-family:"Arial","sans-serif";}
a:link, span.MsoHyperlink
	{font-family:"Times New Roman","serif";
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
strong
	{font-family:"Times New Roman","serif";}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{mso-style-link:"Balloon Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:9.0pt;
	font-family:"PMingLiU","serif";}
p.MsoNoSpacing, li.MsoNoSpacing, div.MsoNoSpacing
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Arial","sans-serif";}
span.Heading1Char
	{mso-style-name:"Heading 1 Char";
	mso-style-link:"Heading 1";
	font-family:"Arial","sans-serif";
	font-weight:bold;}
span.Heading2Char
	{mso-style-name:"Heading 2 Char";
	mso-style-link:"Heading 2";
	font-family:"Cambria","serif";
	font-weight:bold;
	font-style:italic;}
span.Heading3Char
	{mso-style-name:"Heading 3 Char";
	mso-style-link:"Heading 3";
	font-family:"Cambria","serif";
	font-weight:bold;}
span.Heading4Char
	{mso-style-name:"Heading 4 Char";
	mso-style-link:"Heading 4";
	font-family:"Calibri","sans-serif";
	font-weight:bold;}
span.Heading5Char
	{mso-style-name:"Heading 5 Char";
	mso-style-link:"Heading 5";
	font-family:"Calibri","sans-serif";
	font-weight:bold;
	font-style:italic;}
span.Heading6Char
	{mso-style-name:"Heading 6 Char";
	mso-style-link:"Heading 6";
	font-family:"Calibri","sans-serif";
	font-weight:bold;}
span.Heading7Char
	{mso-style-name:"Heading 7 Char";
	mso-style-link:"Heading 7";
	font-family:"Arial","sans-serif";
	font-weight:bold;}
span.HeaderChar
	{mso-style-name:"Header Char";
	mso-style-link:Header;
	font-family:"Arial","sans-serif";}
span.FooterChar
	{mso-style-name:"Footer Char";
	mso-style-link:Footer;
	font-family:"Arial","sans-serif";}
span.BalloonTextChar
	{mso-style-name:"Balloon Text Char";
	mso-style-link:"Balloon Text";
	font-family:"PMingLiU","serif";}
span.shorttext
	{mso-style-name:short_text;
	font-family:"Times New Roman","serif";}
span.alt-edited1
	{mso-style-name:alt-edited1;
	font-family:"Times New Roman","serif";
	color:#4D90F0;}
/* Page Definitions */
 @page WordSection1
	{size:595.3pt 841.9pt;
	margin:85.05pt 49.6pt 141.75pt 42.55pt;
	layout-grid:18.0pt;}
div.WordSection1
	{page:WordSection1;}
 /* List Definitions */
 ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
.hightLight 
	{background-color:yellow !important;}
}		
 -->
</style>
<script src="src/jquery.serializeToJSON.js"></script>
<body style='text-justify-trim:punctuation'>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="form1" id="form1" action="FTOCC_entry.jsp" method="post">
<table width=100% border=0>

<tr valign="top"><td width=30% >
<span style='font-size:16.0pt'>Modification History<br/></span>
<span style='font-size:13.0pt'>
<%
	
try {
	ArrayList record = PatientDB.getFTOCCData(regid);
	if (record.size() > 0) {
		
		for (int i = 0; i < record.size(); i++) {
			ReportableListObject row = (ReportableListObject) record.get(i);
			seq =  row.getValue(0);
			
			String displayUser = null; 			
			
			if (!"".equals(row.getValue(2)))
				displayUser = row.getValue(2);
			
			if (!"".equals(row.getValue(1)))
				displayUser = displayUser + " (" + row.getValue(1) + ")";
						
			String createDt = row.getValue(3);
			String formData = row.getValue(4);
%>
	<a href="#" id="data<%=i %>" onClick='return loadData("<%=regid %>", "<%=seq %>", "<%=i==0?"current":"readOnly" %>" );' ><%=createDt %> <%=displayUser==null?"":" by " + displayUser %></a><br/>
<%
		}
	}
	
} catch (Exception e) {
	e.printStackTrace();
}

%></span></td>
<td width=70%>
<div class=WordSection1 style='layout-grid:18.0pt'>

<u><span style='font-size:16.0pt'>FTOCC Screening</span></u>
<p class=MsoNormal>&nbsp;</p>
<h1 align=center style='text-align:left'><span style='font-size:12.0pt'>
Patient number: <%=patno==null?"":patno %><br/>
Patient Name: <%=patname==null?"":patname %><br/>
Sex: <%=sex==null?"":sex %><br/>
DOB: <%=dob==null?"":dob %><br/>
Room: <%=room==null?"":room %><br/>

<p class=MsoNormal>&nbsp;</p>
<table width=704 border=0><tr>
<td width=50% align="left">Date and Time: <span id="createDt" /></td>
<td width=50% align="left">Staff Name: <span id="createUser" /></span></h1></td>

</tr></table>

<div class="pane">
<table width="100%" border="0"> 
	<tr class="smallText" align="left"><td>
		<input type="hidden" name="command" id="command"/>
		<input type="hidden" name="system" id="system" value="<%=system==null?"":system %>"/>
		<input type="hidden" name="user" id="user" value="<%=user==null?"":user %>"/>
		<input type="hidden" name="regid" id="regid" value="<%=regid %>"/>
		<input type="hidden" name="patno" id="patno" value="<%=patno %>"/>
		<input type="hidden" name="seq" id="seq" />
		<button id="submit">Save</button>
		<button id="edit" onClick="return false;">Edit</button>
		<button id="cancel" onClick="return false;">Cancel</button>
		<button id="print" formtarget="_blank">Print</button>
		<button id="get" onClick="return false;">Get Last FTOCC</button>
	</td>
	</tr>
</table>
</div>

<p class=MsoNormal>&nbsp;</p>
<div id="mainForm">
<jsp:include page="<%=currentForm %>"/> 
</div>
</td>
</tr>
</table>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-size:6.0pt'>&nbsp;</span></p>

</div>
</form>

<script language="javascript">
fullscreen();

<!--
//IE compatibility
if (typeof console=="undefined") var console={ log: function(x) {document.getElementById('msg').innerHTML=x} };
 
if(typeof String.prototype.trim !== 'function') {
  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, ''); 
  }
}

var fever1;
var fever2;
var travel1;
var travel2;
var occ1;
var occ2;
var contact;
var cluster;
var hosp;

	$(document).ready(function(){
		
		$("#edit").hide();
		$("#print").hide();
		$("#cancel").show();
		$("#submit").show();
		$("#get").show();
		
		$("#data0").click();
								
		$("#edit").click(function(){
			loadData($("#regid").val(), $("#seq").val(), "edit");			
		});
		
		$("#cancel").click(function(){
			$("#form1").reset();
			$("#data0").click();
		});
		
		$("#print").click(function(){		
			$("#form1").attr('action', "FTOCC_entry.jsp?command=report&regid=" + $("#regid").val() + "&seq=" + $("#seq").val());
		});
		
		$("#submit").click(function(){
			
			var valid = true;
			
			if (($("input[name='rbFever1']:checked").val() == null) || ($("input[name='rbFever2']:checked").val() == null)) {
				alert("Please enter Fever History");			
				valid = false;
			}
			
			if ($("input[name='rbFever1']:checked").val() == "1") {
				
				if (!$("#txTemp").val().trim()) {
					alert("Please enter Body Temperature");
					valid = false;
				}
				
				if (isNaN($("#txTemp").val().trim())) {
					alert("Please enter a numeric Body Temperature");
					valid = false;
				}
				
			}
			
			if (($("input[name='rbFever1']:checked").val() == "1") || ($("input[name='rbFever2']:checked").val() == "1")) {
				
				if (($("input[name='rbTravel1']:checked").val() == null) 
					|| ($("input[name='rbTravel2']:checked").val() == null) 
					|| ($("input[name='rbOcc1']:checked").val() == null)
					|| ($("input[name='rbOcc2']:checked").val() == null)
					|| ($("input[name='rbContact']:checked").val() == null)
					|| ($("input[name='rbCluster']:checked").val() == null)) { 
	
					alert("Incomplete FTOCC");			
					valid = false;
				}				
			}
			
			if ($("input[name='rbTravel1']:checked").val() == "1") {				
				if (!$("#txTravel").val().trim()) {
					alert("Please enter Travel History");
					valid = false;
				}			
			}
			
			if ($("input[name='hosp']:checked").val() == "1") {				
				if (!$("#txHosp").val().trim()) {
					alert("Please enter Hospital Name");
					valid = false;
				}
				
				if (!$("#dtAdm").val().trim()) {
					alert("Please enter Admission Date");
					valid = false;
				}
				
				if (!$("#txDuration").val().trim()) {
					alert("Please enter Duration of Stay");
					valid = false;
				}
				
			}				
							
			if (valid) {				
				$("#command").val("create");
				$("#form1").submit();
			} else {
				return false;
			}
			
		});
		
		$("#get").click(function(){
			var hour = "5";
			var displayUser;
			var d = new Date();
		    var n = d.getTime();	    
		    
			$.post("FTOCC_data.jsp",
					{
						patno: $("#patno").val(),
						hour: hour,
						time: n
					},
					function(data, status){
						
						if (status == "success") {
														
							if (data.trim()=="null") {
								alert("No FTOCC data within last " + hour + " hours");	
							} else {
								
								$.post("<%=currentForm %>",
								{
		 							time: n
								},
								function(form, status){
									if (status == "success") {
										document.getElementById("mainForm").innerHTML = form;
										initFlds();	
										
										var obj = JSON.parse(data);
										for (field in obj) {
											if (field.substring(0,2) == "rb") {
												$("input[name=" + field + "][value=" + obj[field] + "]").attr("checked",true);
											} else {
												$("#" + field).val(obj[field]);
											}
										}
								
										displayUser = obj["usr"];
										if (obj["sys"] != "")
											displayUser = displayUser + " (" + obj["sys"] + ")";
									
										$("#createUser").html(displayUser);
										$("#createDt").html(obj["createdt"]);

										enableTxt();
										changeColor();
										
										$("#submit").show();
										$("#cancel").hide();
										$("#edit").hide();
										$("#print").hide();
										$("#get").hide();
										
									} else {
										alert(status);
									}
										
								});
															
							}
																					
						} else {
							alert(status);
						}
					});											
		});
		
	});
		
	function loadData(regid, seq, mode) {
		
		var displayUser;
		var d = new Date();
	    var n = d.getTime();
		
		$.post("FTOCC_data.jsp",
			{
				regid: regid,
				seq: seq, 
				time: n
			},
			function(data, status){
				
				if (status == "success") {
										
					var obj = JSON.parse(data);
					var formPath;
					
					if (mode == "edit")
						formPath = "<%=currentForm %>";
					else
						formPath = obj["formPath"];
				
					$.post(formPath,
							{
								time: n
							},
							function(data, status){
								if (status == "success") {
									
									document.getElementById("mainForm").innerHTML = data;
									initFlds();
									
									for (field in obj) {
										if (field.substring(0,2) == "rb") {
											$("input[name=" + field + "]").attr('checked',false);
											$("input[name=" + field + "][value=" + obj[field] + "]").attr("checked",true);
										} else {
											$("#" + field).val(obj[field]);
										}
									}
									
									displayUser = obj["usr"];
									if (obj["sys"] != "")
										displayUser = displayUser + " (" + obj["sys"] + ")";
										
									$("#createUser").html(displayUser);
									$("#createDt").html(obj["createdt"]);
									$("#seq").val(seq);
									
									$("input").attr({
										'disabled': 'disabled'
							        });
									
				 					changeColor();
									
									$("#submit").hide();
									$("#edit").hide();
									$("#print").hide();
									$("#cancel").hide();
									$("#get").hide();
									
									if (mode == "current") {
										$("#edit").show();
										$("#print").show();
									} else if (mode == "edit") {
										$("input").removeAttr('disabled');
										enableTxt();
										$("#submit").show();
										$("#cancel").show();
										$("#edit").hide();
										$("#print").hide();
										$("#get").hide();
									} 
									
									if (<%=disable %>) {
										$("input").attr({
											'disabled': 'disabled'
								        });
										$("#submit").hide();
										$("#edit").hide();
										$("#cancel").hide();
									}
																
								} else {
									alert(status);
								}								
							});
														 	
				} else {
					alert(status);
				}
			});
						
	}				
	
	function enableTxt(){
	
		if ($("input[name='rbTravel1']:checked").val() == "0") {
			$(".travel").val("");
			 
			$(".travel").attr({
            	'disabled': 'disabled'
            });			
		} else {
			$(".travel").removeAttr('disabled');
		}
		
		if ($("input[name='rbHosp']:checked").val() == "0") {
			$(".hosp").val("");
			
			$(".hosp").attr({
            	'disabled': 'disabled'
            });
			
			$("#dtAdm").val("");
			
			$("#dtAdm").attr({
				'disabled': 'disabled'
			});
												
		} else {
			$(".hosp").removeAttr('disabled');	
			$("#dtAdm").removeAttr('disabled');
		}
		
		$(".datepickerfield").datepicker();
	}
	
	function changeColor() {
		
		if ( $("input[name='rbFever1']:checked").val() == "1") {
			$("#fever1").css("color","red");
			$("#fever1").css("font-weight","bold");
		} else {
			$("#fever1").css("color","black");
			$("#fever1").css("font-weight","normal");
		}
		
		if ( $("input[name='rbFever2']:checked").val() == "1") {
			$("#fever2").css("color","red");
			$("#fever2").css("font-weight","bold");
		} else {
			$("#fever2").css("color","black");
			$("#fever2").css("font-weight","normal");
		}		
		
		if ( $("input[name='rbTravel1']:checked").val() == "1") {
			$("#travel1").css("color","red");
			$("#travel1").css("font-weight","bold");
		} else {
			$("#travel1").css("color","black");
			$("#travel1").css("font-weight","normal");
		}	

		if ( $("input[name='rbTravel2']:checked").val() == "1") {
			$("#travel2").css("color","red");
			$("#travel2").css("font-weight","bold");
		} else {
			$("#travel2").css("color","black");
			$("#travel2").css("font-weight","normal");
		}	
		
		if ( $("input[name='rbOcc1']:checked").val() == "1") {
			$("#occ1").css("color","red");
			$("#occ1").css("font-weight","bold");
		} else {
			$("#occ1").css("color","black");	
			$("#occ1").css("font-weight","normal");
		}
		
		if ( $("input[name='rbOcc2']:checked").val() == "1") {
			$("#occ2").css("color","red");
			$("#occ2").css("font-weight","bold");
		} else {
			$("#occ2").css("color","black");
			$("#occ2").css("font-weight","normal");
		}
		
		if ( $("input[name='rbContact']:checked").val() == "1") {
			$("#contact").css("color","red");
			$("#contact").css("font-weight","bold");
		} else {
			$("#contact").css("color","black");
			$("#contact").css("font-weight","normal");
		}
		
		if ( $("input[name='rbCluster']:checked").val() == "1") {
			$("#cluster").css("color","red");
			$("#cluster").css("font-weight","bold");
		} else {
			$("#cluster").css("color","black");
			$("#cluster").css("font-weight","normal");
		}
		
		if ( $("input[name='rbHosp']:checked").val() == "1") {
			$("#hosp").css("color","red");
			$("#hosp").css("font-weight","bold");
		} else {
			$("#hosp").css("color","black");
			$("#hosp").css("font-weight","normal");
		}
		
		if ( $("input[name='rbContact1']:checked").val() == "1") {
			$("#contact1").css("color","red");
			$("#contact1").css("font-weight","bold");
		} else {
			$("#contact1").css("color","black");
			$("#contact1").css("font-weight","normal");
		}
		
		if ( $("input[name='rbContact2']:checked").val() == "1") {
			$("#contact2").css("color","red");
			$("#contact2").css("font-weight","bold");
		} else {
			$("#contact2").css("color","black");
			$("#contact2").css("font-weight","normal");
		}
		
		if ( $("input[name='rbContact3']:checked").val() == "1") {
			$("#contact3").css("color","red");
			$("#contact3").css("font-weight","bold");
		} else {
			$("#contact3").css("color","black");
			$("#contact3").css("font-weight","normal");
		}		
	}
	
	function initFlds() {
		$("input[name='rbFever1']").click(function(){			
			if (fever1 == $("input[name='rbFever1']:checked").val()) {
				$("input[name='rbFever1']").attr('checked',false);
			}
			
			fever1 = $("input[name='rbFever1']:checked").val();
			enableTxt();
			changeColor();
		});
		
		$("input[name='rbFever2']").click(function(){			
			if (fever2 == $("input[name='rbFever2']:checked").val()) {
				$("input[name='rbFever2']").attr('checked',false);
			}
			
			fever2 = $("input[name='rbFever2']:checked").val();
			enableTxt();
			changeColor();
		});
		
		$("input[name='rbTravel1']").click(function(){			
			if (travel1 == $("input[name='rbTravel1']:checked").val()) {
				$("input[name='rbTravel1']").attr('checked',false);
			}
			
			travel1 = $("input[name='rbTravel1']:checked").val();
			enableTxt();
			changeColor();
		});
		
		$("input[name='rbTravel2']").click(function(){			
			if (travel2 == $("input[name='rbTravel2']:checked").val()) {
				$("input[name='rbTravel2']").attr('checked',false);
			}
			
			travel2 = $("input[name='rbTravel2']:checked").val();			
			changeColor();
		});
		
		$("input[name='rbOcc1']").click(function(){			
			if (occ1 == $("input[name='rbOcc1']:checked").val()) {
				$("input[name='rbOcc1']").attr('checked',false);
			}
			
			occ1 = $("input[name='rbOcc1']:checked").val();			
			changeColor();
		});

		$("input[name='rbOcc2']").click(function(){			
			if (occ2 == $("input[name='rbOcc2']:checked").val()) {
				$("input[name='rbOcc2']").attr('checked',false);
			}
			
			occ2 = $("input[name='rbOcc2']:checked").val();			
			changeColor();
		});

		$("input[name='rbContact']").click(function(){			
			if (contact == $("input[name='rbContact']:checked").val()) {
				$("input[name='rbContact']").attr('checked',false);
			}
			
			contact = $("input[name='rbContact']:checked").val();			
			changeColor();
		});

		$("input[name='rbCluster']").click(function(){		
			if (cluster == $("input[name='rbCluster']:checked").val()) {
				$("input[name='rbCluster']").attr('checked',false);
			}
			
			cluster = $("input[name='rbCluster']:checked").val();
			changeColor();
		});

		$("input[name='rbHosp']").click(function(){			
			if (hosp == $("input[name='rbHosp']:checked").val()) {
				$("input[name='rbHosp']").attr('checked',false);
			}
			
			hosp = $("input[name='rbHosp']:checked").val();
			enableTxt();
			changeColor();
		});
/*		
		$(".datepickerfield").datepicker({
			  showOn: "button",
			  buttonImage: "../images/calendar.jpg",
			  buttonImageOnly: true
			});
*/			
	}
-->
</script>
</DIV>

</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>