<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> fetchProc() {
			//return UtilDBWeb.getReportableListHATS("SELECT TYPECODE, TYPEDESC FROM FIN_TYPE ORDER BY TYPECODE");
			return UtilDBWeb.getReportableList("SELECT F.PROCCODE, P.PROCDESC FROM CFM_PROC@IWEB P,CFM_CODE@IWEB F WHERE F.PROCCODE=P.PROCCODE AND P.PROCTYPE = 'P' AND P.ISACTIVE = -1 ORDER BY P.PROCDESC");
	}
	
	private ArrayList<ReportableListObject> fetchSpec() {
		//return UtilDBWeb.getReportableListHATS("SELECT TYPECODE, TYPEDESC FROM FIN_TYPE ORDER BY TYPECODE");
		return UtilDBWeb.getReportableList("SELECT SPCCODE, SPCNAME||NVL(SPCCNAME,'') FROM SPEC@IWEB ORDER BY SPCCODE");
	}
	
	private ArrayList<ReportableListObject> fetchDoctor() {
			return UtilDBWeb.getReportableList("SELECT DOCCODE, DOCFNAME || ' ' || DOCGNAME, DOCCNAME,SPCCODE FROM DOCTOR@IWEB WHERE DOCSTS = -1 AND MSTRDOCCODE IS  NULL ORDER BY DOCFNAME, DOCGNAME");
	}

	private ArrayList<ReportableListObject> fetchRegistrationRecord(String regid) {
		return UtilDBWeb.getReportableList("SELECT PATNO, DOCCODE FROM REG@IWEB WHERE REGID = ?", new String[] { regid });
	}

	private String getMasterDoctor(String doccode) {
		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
				"SELECT MSTRDOCCODE FROM DOCTOR@IWEB WHERE DOCCODE = ? AND DOCSTS = -1 AND MSTRDOCCODE IS NOT NULL",
				new String[] { doccode });
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else{
			return doccode;
		}
	}

%>
<%
	UserBean userBean = new UserBean(request);

	String patno = request.getParameter("patno");
	String doccode = request.getParameter("doccode");
	/* if (userBean.isLogin()) {
		hatsDoccode = userBean.getStaffID();
	} */
	String ProcedureSelect1 = request.getParameter("ProcedureSelect1");
	String regid = request.getParameter("regid");
	String patname = null;
	String patcname = null;
	String patidno = null;


	ArrayList<ReportableListObject> record = null;
	ArrayList<ReportableListObject> recordDocList = fetchDoctor();
	ArrayList<ReportableListObject> recordProcList = fetchProc();
	ArrayList<ReportableListObject> recordSpecList = fetchSpec();
	
	ReportableListObject row = null;

	if (regid != null && !"".equals(regid)) {
		record = fetchRegistrationRecord(regid);
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			patno = row.getValue(0);
			doccode = getMasterDoctor(row.getValue(1));

		}
	} 
	
	
	boolean isFreeTextDoc = true;

response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
response.setHeader("Expires", "0"); // Proxies.
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<!--jsp:include page="../common/header.jsp"/-->
<!-- BEGIN syntax highlighter -->

<script type="text/javascript" src="<html:rewrite page="/js/hkah.js" />" /></script>
<!-- <script type="text/javascript" src="sh/shBrushJScript.js"></script>
<link type="text/css" rel="stylesheet" href="sh/shCore.css"/>
<link type="text/css" rel="stylesheet" href="sh/shThemeDefault.css"/>
<script type="text/javascript">
	SyntaxHighlighter.all();
</script> -->
<!-- END syntax highlighter -->

<script src="../js/jquery-1.3.2.min.js" type="text/javascript"></script>
<script src="../js/ui.datepicker.js" type="text/javascript"></script>
<script src="../js/jquery.searchabledropdown-1.0.8.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/flora.datepicker.css" />" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/w3.hkah.css" />" />
<body style="width: 95%;!important">
	<form name="prtConsentForm" id="prtConsentForm" autocomplete="off" method="post" target="_blank">
	<div id="mask"></div>

	<table width="100%" border="1">
	<th colspan="5" bgcolor='#D8BFD8' class="w3-container ah-pink w3-large">
			Informed Consent Form System
	</th>
	<tr bgcolor='#DDDDD'>
		<td><b>Patient No.: </b><input class="w3-large" type='text' id='patno' name='patno' value="<%=patno==null?"":patno%>" maxlength="10" <% if (patno != null) { %> readonly <%} else {%> onblur="getPatName(this)"<%} %>></td>
		<td><b>Patient Name: </b><input class="w3-large" type='text' id='patname' name='patname' value="<%=patname==null?"":patname%>" maxlength="40"></td>
		<td><b>Chinese Name: </b><input class="w3-large" type='text' id='patcname' name='patcname' value="<%=patcname==null?"":patcname%>" maxlength="10"></td>
		<td><b>ID/Passport No: </b><input class="w3-large" type='text' id='patidno' name='patidno' value="<%=patidno==null?"":patidno%>" maxlength="20"></td>
	</tr>
	</table>

	<table width="980px" border="0"  class="formDetails">
	<tr>
		<td width="32%"><b>醫生 Doctor</b></td>
		<td colspan="4">
		<table><tr><td>
		<% if("".equals(doccode) || doccode == null) {%>
		   <div>Search Dr.<input type="text" id="search" name="search" style="margin: 10px;width: 165px;">
		   <button id="searchDr" onclick="getDoctorList()" class="w3-button w3-grey w3-small w3-border" style="margin-left:5px !important; padding: 2px 2px 2px; !important; "><b>search</b></button>
		   <button id="searchDr" onclick="resetDr()" class="w3-button w3-grey w3-small w3-border" style="margin-left:5px !important; padding: 2px 2px 2px; !important; "><b>clear</b></button>
		   </div>
		<%} else { %>
			<input type="hidden" name="search" value=""/>
		<%} %>
<%-- 			<select name="DocSelect" id="DocSelect" onchange="onChangeDoctor();" style="width:550px;">
				<option value=''>---- Please Select Attending Doctor ----</option>
<%
	if (recordDocList != null && recordDocList.size() > 0) {
		for (int i = 0; i < recordDocList.size(); i++) {
			row = (ReportableListObject) recordDocList.get(i);
%>
				<option value="<%=row.getValue(0) %>" spec="<%=row.getValue(3)%>" <%if (row.getValue(0).equals(doccode)) {%> selected<%}%>><%=row.getValue(1) %>&nbsp;<%=row.getValue(2) %> (<%=row.getValue(0) %>)</option>
<%
		}
	}
%>
			</select> --%>
			<span id="docSelect_indicator">
					<select name="DocSelect"  id="DocSelect" onchange="onChangeDoctor();" style="width:550px;"/>
			</span>
			</td>
			<td style="padding-top: 30px;"><button id="editFav" class="w3-button w3-teal">Edit Favour List</button><br></td>
			</tr></table>
		</td>
	</tr>
	<tr>
		<td style="line-height:1.2;"><b>專科<br/>Specialty</b></td>
		<td colspan="5">
		<table><tr><td>
			<select name="spec" id="spec" onchange="onChangeSpec();">
				<option value=''>---- Please Select Specialty ----</option>
				<%
				if (recordSpecList != null && recordSpecList.size() > 0) {
					for (int i = 0; i < recordSpecList.size(); i++) {
						row = (ReportableListObject) recordSpecList.get(i);
				%>
						<option value="<%=row.getValue(0) %>"><%=row.getValue(1) %></option>
				<%
					}
				}
				%>
					</select>
			</td>
			<td>
			<table>
			<tr><td><input type="radio" name="procYN" id="procYN" value="F" onclick="onClickProcYN()" checked/>Show Favour List</td></tr>
			<tr><td><input type="radio" name="procYN" id="procYN" value="S" onclick="onClickProcYN()"/>Show Specialty Procedure List</td></tr>
			<tr><td><input type="radio" name="procYN" id="procYN" value="A" onclick="onClickProcYN()"/>Show All Procedure</td></tr>
			</table>
			</td>
			
		</tr></table>
		</td>
	</tr>
		<tr>
			<td><b>醫療程序/手術類型 <br/>Procedure/Surgical Operation</b></td>
			<td colspan="3">
			<table>
				<tr>
					<td><b>Free Text Procedure</b></td>
					<td colspan="4">
						<button id="addFreeToFav">add Free Text To Favour List</button>
						<input type='text' id='freeTextProc' name='freeTextProc' value="" style="width: 350px;"/>
						<button class="w3-button" style="font-size:14px!important" id="addSelect">add to Selected</button>
					</td>
				</tr>
					<td><button id="addToFav" class="w3-button" style="padding: 2px 2px 2px 2px; !important;">add to<br> Favour List</button><br/>
						<p style="color:red;">Complication will add to<br/>favour list if complication<br/>is not empty</p>
					</td>
					<td>
					<span id="availProcedure_indicator">
					<select name="ProcedureSelectAvailable"  multiple id="select1" class="ProcedureSelect" size="20" />
					</span>
					</td>
					<td>
						<select name="surgSite" size="10" class="surgSite" id="surgSite">
							<option value="">-- Please Select Surgical Site --</option>
							<option value="Left">Left 左</option>
							<option value="Right">Right 右</option>
							<option value="Bilateral">Bilateral 雙側</option>
							<option value="Unilateral">Unilateral 單側</option>
							<option value="Upper">Upper 上</option>
							<option value="Lower">Lower 下</option>
							<option value="Anterior">Anterior 前</option>
							<option value="Posterior">Posterior 後</option>
						</select>
					</td>
					<td>
						<table>
							<tr><td><button class="w3-button" style="font-size:16px!important" id="add">add</button></td></tr>
							<tr><td><button class="w3-button" style="font-size:16px!important" id="remove">delete</button></td></tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td><b>Selected Procedure(s)/Surgical Operation(s)</b></td>
		<td colspan="5">
		<table>
			<tr>
				<td colspan="6">
					<select name="ProcedureSelect1" class="ProcedureSelect" size="5" multiple id="select2"/>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<%if (ConstantsServerSide.isTWAH()) {%>
			<tr>
				<td><b>Complication</b></td>
				<td colspan="1">
					<table>
						<tr>
							<td  colspan="5">
								<span id="complicationSection">
								<textarea rows="5" cols="90" max_length="2000" id='complication' name='complication' value=""  style="font-size: 16px;"></textarea>
								</span>
							</td>
						</tr>
					</table>
				</td>
			</tr>
	<%} else {%>
		<input type="hidden" name="complication" value=""/>
	<%} %>
	<tr>
		<td style="line-height:1.2;"><b>麻醉類別 Type of anaethesia</b></td>
		<td colspan="1">
		<table>
		<tr>
			<td><input type="checkbox" name="anaeMeth" id="anaeMeth" value="gen">General Anaesthesia</input></td>
			<td><input type="checkbox" name="anaeMeth" id="anaeMeth" value="mon">Monitored Anaesthetic Care</input></td>
			<td><input type="checkbox" name="anaeMeth" id="anaeMeth" value="ins">Intravenous Sedation</input></td>
		</tr>
		<tr>
		<td><input type="checkbox" name="anaeMeth" id="anaeMeth" value="local">Local Anaesthesia / Topical Anaesthesia</input></td>
		<td><input type="checkbox" name="anaeMeth" id="anaeMeth" value="region">Regional Anaesthesia</input>
		<select name="regionAnaeSelect" id="regionAnaeSelect">
					<option value=''></option>
					<option value='spinal'>Spinal</option>
					<option value='epidural'>Epidural</option>
					<option value='other'>Other</option>
				</select>
		</td>
		</tr>
		<tr>
		<td><input type="checkbox" name="anaeMeth" id="anaeMeth" value="combine">Possible combination of the above</input></td>
		<td><input type="checkbox" name="anaeMeth" id="anaeMeth" value="others">Others</input>				
			<span id="regionOtherSection">
			<input type='text' id='regionOther' name='regionOther' value="" style="width: 300px;"/>
			</span>
		</td>
		</tr>
		</table>
		</td>
	</tr>
		<tr>
			<td width="32%"><b>Signature</b></td>
			<td colspan="5">
				<input type="radio" name="patientYN" value="Y" checked>Patient
				<input type="radio" name="patientYN" value="N">Parent/Relative/Guardian
			</td>
		</tr>
	<tr>
		<td width="32%"><b>Sign Date</b></td>
		<td colspan="5">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=DateTimeUtil.getCurrentDate() %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
		</td>
	</tr>
	<tr>
		<td width="32%"><b>Consent Form Language 語言</b></td>
		<td colspan="5">
			<input type="radio" name="lang" value="eng" <%=ConstantsServerSide.isHKAH()?" checked":""%>>English 
			<input type="radio" name="lang" value="chi" <%=ConstantsServerSide.isTWAH()?" checked":""%>>中文	
			<%if (ConstantsServerSide.isHKAH()) {%>
			<input type="radio" name="lang" value="jap" >Japanese
			<%} %>
		</td>
	</tr>
	<%if (ConstantsServerSide.isTWAH()) {%>
		<tr>
			<td><b>Print Time-out form (for OP Only)</td>
			<td colspan="3">
				<input type="radio" name="timeOutForm" value="Y" >Yes 
				<input type="radio" name="timeOutForm" value="N" checked>No	
			</td>
		</tr>
	<%} else { %>
			<tr>
			<td colspan="4">
				<table><tr>
				<td><b>With Anesthesiologist?</b></td>
				<td>
					<input type="radio" name="withAn" value="Y" checked>Yes 
					<input type="radio" name="withAn" value="N" >No	
				</td>
			</tr></table>
			</td>
		</tr>
	<%} %>
	<tr>
		<td colspan="5">
			 <table><tr>
				<td><b>Consent Form Copy</td>
				<td>
					<select name="copy" id="copy" >
						<option value='1'  selected>1</option>
						<option value='2'>2</option>			
					</select>
				</td>
				<td><b>Fact Sheet Copy</b></td>
				<td>
					<select name="fsCopy" id="fsCopy" >
						<option value='1'>1</option>
						<option value='2' selected>2</option>			
					</select>
				</td>
			<td>
			<div style="margin:5px 0 5px 70px; float:right;">
				<button type="button" class="w3-button " id="confirm" name="confirm" style="font-size:15px;" onclick="printRPT();"/><b>Generate Form</b></button>
				<button type="button" class="w3-button  " id="finEst" name="finEst" style="font-size:15px; margin:0 0 0 10px;" onclick="openFIN();"/><b>Financial Estimation</b></button>
			</div>
			</td>
			</tr></table>
		</td>
	</tr>	
	</table>

	<table width="980px" border="0">

	</table>

	<span id="showAdmission_indicator"></span>
	<span id="showProcedurePackage_indicator"></span>
	<span id="showProcedureCode_indicator"></span>
	<span id="showLeaflet_indicator"></span>

	<input type="hidden" name="doccode" value="<%=doccode==null?"":doccode %>"/>
	<input type="hidden" name="regid" value="<%=regid==null?"":regid %>"/>
	<input type="hidden" name="patDOB"/>
	<input type="hidden" name="patSex"/>
	
	<div id="loading"><img src="../images/loadingAnimation.gif"/></div>
	</form>

<script type="text/javascript">
<%if (ConstantsServerSide.SECURE_SERVER) { %>
if (this.window.name == 'title' || this.window.name == 'content' || this.window.name == 'bigcontent') {
	parent.location.href = "<%=request.getContextPath() %>/printConsentForm.jsp";
}
<%} %>
$(document).ready(function() {
 	
	if ($('#DocSelect').data("originalHTML") == undefined) {
		$('#DocSelect').data("originalHTML", $('#DocSelect').html());
    }
	
	getDoctorList();
 	
	$('input').filter('.datepickerfield').datepicker({
		beforeShow: function (textbox, instance) {
	        var txtBoxOffset = $(this).offset();
	        var top = txtBoxOffset.top;
	        var left = txtBoxOffset.left;
	        var textBoxHeight = $(this).outerHeight();
	        setTimeout(function () {
	            instance.dpDiv.css({
	               top: top-$("#ui-datepicker-div").outerHeight()-50,
	               left: left+$("#date_from").width()+25
	            });
	        }, 0);
	    },
		showOn: 'button', 
		buttonImageOnly: true, 
		buttonImage: "../images/calendar.jpg"
	});
	
	$('#add').click(function() {
		addToSelected();		
	});
	
	$('#surgSite').dblclick(function(){
		if (document.getElementById("surgSite").value != "") {
			if ($('#select1 option').filter(':selected').text() != "") {
				addToSelected();
			}
		}
	});
	
	$('#addSelect').click(function() {
		if ($('#freeTextProc').val() != "") {
				var pArray = $('#freeTextProc').val().toUpperCase().split(";");
		 		for (var i in pArray) {
		 					var option = document.createElement("option");
							option.value     = pArray[i];
							option.innerHTML = pArray[i];
							var select = document.getElementById("select2");
							select.appendChild(option); 
		 			}
		}					
				return false;
	});
	
	$('#editFav').click(function() {
		callPopUpWindow("viewFavorList.jsp?docCode="+document.getElementById("DocSelect").value+"&patno="+document.getElementById("patno").value, screen.width*0.8, screen.height*0.5);			
		return false;
	});
	
	
	$('#remove').click(function() {
		return !$('#select2 option:selected').remove();
	});
	
	$('#select2').dblclick(function(){
		return !$('#select2 option:selected').remove();
	});
	
	$('#addToFav').click(function() {
		$.ajax({
			type: "POST",
			url: "addFavourList.jsp",
			data: 	"docCode="+document.getElementById("DocSelect").value
					+"&procedure=" + document.getElementById("select1").value
					+"&comp="+document.getElementById("complication").value,
			success: function(values) {
				$.ajax({
					type: "POST",
					url: "procedureCMB.jsp",
					data: "spec=" + document.getElementById("spec").value+"&docCode="+document.getElementById("DocSelect").value
							+"&favourListYN=true&procYN=F",
					success: function(values) {
					if (values != '') {		
						$("#availProcedure_indicator").html(values);
						$("input[id=procYN][value='F']").attr('checked', 'checked');
						onChangeSpec();
					} //if
					}//success
				});//$.ajax
			},//success
			error: function() {
				alert('error');
			}
		});//$.ajax	
		return false;
	});
	
	$('#addFreeToFav').click(function() {
		$.ajax({
			type: "POST",
			url: "addFavourList.jsp",
			data: 	"docCode="+document.getElementById("DocSelect").value
					+"&procDesc=" + document.getElementById("freeTextProc").value.toUpperCase()
					+"&comp="+document.getElementById("complication").value,
			success: function(values) {
				$.ajax({
					type: "POST",
					url: "procedureCMB.jsp",
					data: "spec=" + document.getElementById("spec").value+"&docCode="+document.getElementById("DocSelect").value
							+"&favourListYN=true",
					success: function(values) {
					if (values != '') {		
						$("#availProcedure_indicator").html(values);
						$("input[id=procYN][value='F']").attr('checked', 'checked');
						onChangeSpec();
					} //if
					}//success
				});//$.ajax
			},//success
			error: function() {
				alert('error');
			}
		});//$.ajax	
		return false;
	});
	
	$('textarea').keyup(function(){
		  var maxlength = parseInt($(this).attr('max_length')),
		      text = $(this).val(),
		      eol = text.match(/(\r\n|\n|\r)/g),
		      count_eol = $.isArray(eol) ? eol.length : 0,//error if eol is null
		      count_chars = text.length - count_eol;
		  if (maxlength && count_chars > maxlength){
			    $(this).val(text.substring(0, maxlength + count_eol));
			  	alert($(this).attr('id')+" can not be longer than "+$(this).attr('max_length')+" words");
		  	}
		});
	
	
});


function modifySelect() {
	$("select").get(0).selectedIndex = 5;
}

function appendSelectOption(str) {
	$("select").append("<option value=\"" + str + "\">" + str + "</option>");
}

function addToSelected(){
	if (document.getElementById("surgSite").value != "") {
		var site = " ("+document.getElementById("surgSite").value+")";
		var upVal = $('#select1 option:selected').val()+"<s>"+document.getElementById("surgSite").value;
		var removeComp = $('#select1 option:selected').text().split(";")[0];
		if (document.getElementById("complication").value != "") {
			document.getElementById("complication").value = 
				document.getElementById("complication").value+ ' '+$('#select1 option:selected').attr('comp');
		}else {
			document.getElementById("complication").value = $('#select1 option:selected').attr('comp');
		}
		return !$('#select1 option:selected').clone().text(removeComp).append(site.toUpperCase()).attr("value",upVal).appendTo('#select2');
	} else {
		var upVal = $('#select1 option:selected').text().split(";")[0];
		document.getElementById("complication").value = 
			document.getElementById("complication").value+ ' '+$('#select1 option:selected').attr('comp');
		return !$('#select1 option:selected').clone().text(upVal).appendTo('#select2');
	}
}

<%if (ProcedureSelect1 != null) { %>
changeCode(document.getElementById("ProcedureSelect1"));
<%} %>

<%if (patno != null && patno.length() > 0) { %>
getPatName(document.getElementById("patno"));
<%} %>

function pageReload() {
	refresh = "true";
	location.reload();
}


function getPatName(patno) {
	document.getElementById("patname").readOnly = false;
	document.getElementById("patcname").readOnly = false;
	document.getElementById("patidno").readOnly = false;
	document.getElementById("patname").value = "";
	document.getElementById("patcname").value = "";
	document.getElementById("patidno").value = "";

	if (patno.value.length > 0) {
		$.ajax({
			type: "POST",
			url: "../registration/admission_hats.jsp",
			data: "patno=" + patno.value,
			success: function(values) {
			if (values != '') {
				$("#showAdmission_indicator").html(values);
				if (values.substring(0, 1) == 1) {
					document.getElementById("patname").value = document.prtConsentForm.hats_patfname.value + ' ' + document.prtConsentForm.hats_patgname.value;
					document.getElementById("patcname").value = document.prtConsentForm.hats_patcname.value;
					if (document.prtConsentForm.hats_patidno.value.length > 4) {
						document.getElementById("patidno").value = document.prtConsentForm.hats_patidno.value;
					}
					document.getElementById("patDOB").value = document.prtConsentForm.hats_patbdate.value;
					document.getElementById("patSex").value = document.prtConsentForm.hats_patsex.value;
					document.getElementById("patname").readOnly = true;
					document.getElementById("patcname").readOnly = true;
					document.getElementById("patidno").readOnly = true;
				} else {
					alert('Patient not found.');
					patno.value = '';
				}
			}//if
			$("#showAdmission_indicator").html("");
			}//success
		});//$.ajax
	}
}

function getProcedureDetails() {
	if (document.getElementById("ProcedureSelect1").selectedIndex!="0") {
		$.ajax({
			type: "POST",
			url: "procedureDetails.jsp",
			data: "procedure=" + document.getElementById("ProcedureSelect1").value,
			success: function(values) {
				if (values != '') {
					$("#showProcedureCode_indicator").html(values);
				} else {//if
				 	$("#showProcedureCode_indicator").html("");
				}
			}//success
		});//$.ajax

	}
}

function getDoctorList(){
	$.ajax({
		type: "POST",
		url: "docCodeCMB.jsp",
		data: "keyword=" + document.getElementById("search").value+"&doccode="+$('[name="doccode"]').val(),
		success: function(values) {
			if (values != '') {
				$("#docSelect_indicator").html(values);
				onChangeDoctor();
			} else {//if
			 	$("#docSelect_indicator").html("");
			}
		}//success
	});//$.ajax
}

function onClickProcYN() {

	onChangeSpec();
}

function onChangeDoctor(){
 	if ($("#DocSelect").find(':selected').attr('spec') != ""){
		$('#spec option[value='+$("#DocSelect").find(':selected').attr('spec')+']').attr('selected','selected');
	} 
 	$("input[id=procYN][value='F']").attr('checked', 'checked');
	onChangeSpec();
}

function onChangeSpec() {
	$.ajax({
		type: "POST",
		url: "procedureCMB.jsp",
		data: "spec=" + document.getElementById("spec").value+"&docCode="+document.getElementById("DocSelect").value
				+"&procYN="+$("input[name=procYN]:checked").val(),
		success: function(values) {
		if (values != '') {		
			$("#availProcedure_indicator").html(values);
			if(values.indexOf('showAll')> -1 || document.getElementById("DocSelect").value == "" ){
				document.getElementById("spec").value = "";
				$("input[id=procYN][value='A']").attr('checked', 'checked');
			}
		} //if 
			$("#availProcedure_indicator").html(values);
			$('#select1').dblclick(function(){
				addToSelected();
				return false;
			});
		
		}//success
	});//$.ajax
}

function checkAnaeMethod() {
	if (document.getElementById("anaeMeth").selectedIndex=="5") {
		document.getElementById("regionAnaeSelect").disabled = false;
		document.getElementById("regionAnaeSelect").style.display = 'block';
		document.getElementById("regionOtherSection").style.display = 'block';
		
		if (document.getElementById("regionAnaeSelect").selectedIndex!="2") {
			document.getElementById("regionOther").value = '';
			document.getElementById("regionOtherSection").style.display = 'none';
		} else {
			document.getElementById("regionOtherSection").style.display = 'block';
		}
	} else if (document.getElementById("anaeMeth").selectedIndex=="7") {
		document.getElementById("regionAnaeSelect").value = 'other';
		document.getElementById("regionAnaeSelect").disabled = true;
		document.getElementById("regionAnaeSelect").style.display = 'block';
		
		document.getElementById("regionOther").value = '';
	    
		document.getElementById("regionOtherSection").style.display = 'block';	
	} else {
		document.getElementById("regionAnaeSelect").style.display = 'none';
		document.getElementById("regionAnaeSelect").value='';
		document.getElementById("regionOtherSection").style.display = 'none';
		document.getElementById("regionOther").value = '';
	}
}

function openFIN() {
	<% if (ConstantsServerSide.isHKAH()){ %>
		window.open("http://www-server/intranet/financialEstimate/financialEstimationRpt.jsp?doccode="+document.getElementById('DocSelect').value+
				"&patno="+document.getElementById("patno").value
			, "_blank");
	<% } else {%>
		window.open("http://192.168.0.20/intranet/financialEstimate/financialEstimationRpt.jsp?doccode="+document.getElementById('DocSelect').value+
					"&patno="+document.getElementById("patno").value
				, "_blank");
	<% }%>
}

function printRPT() {
	
	$('#select2 option').each(function(i) {
		$(this).attr("selected", "selected");
	});
	if (document.getElementById("patno").value=="" && document.getElementById("patname").value=="") {
		alert('Patient not found.');
		document.getElementById('patno').focus();
		return;
	}  else if ( $('#DocSelect').find(":selected").text() == "") {
		alert("Please select Doctor.");
		document.getElementById('DocSelect').focus();
		return;
	} else if (document.getElementById('select2').value=="") {
		alert("Please select Procedure.");
		return;
	} 
	
    if( $('#select2').length > 0){
    	
        //build an array of selected values
        var selectednumbers = "";
        $('#select2 :selected').each(function(i, selected) {
            	selectednumbers += $(selected).val().split("<s>")[0]+";";
        });
    }
    
/* 	$.ajax({
		type: "POST",
		url: "procedureDetails.jsp",
		data: "procedure=" + selectednumbers,
		dataType:"jsonp",
		cache:false,
		async:false,
		success: function(values) {
			$.each(values, function(i, v) {
				var url = v.url;
				if(url.length > 0 ){
					window.open(url, "_blank");
				}
			});
				//window.open(values, "_blank");
		}//success
	});//$.ajax */
	
	document.getElementById('prtConsentForm').action = 'consentForm_jasper.jsp';
	document.getElementById("prtConsentForm").submit();
	
}


function clearDocSelect() {
	if (document.getElementById("DocInput").value != "") {
		document.getElementById("DocSelect").selectedIndex = 0;
	}
}

function clearAll() {
	
}

function validDate(obj) {
	date=obj.value
	if (/[^\d/]|(\/\/)/g.test(date)) {
		obj.value=obj.value.replace(/[^\d/]/g,'');
		obj.value=obj.value.replace(/\/{2}/g,'/');
		return;
	}
	if (/^\d{2}$/.test(date)) {
		obj.value=obj.value+'/';
		return;
	}
	if (/^\d{2}\/\d{2}$/.test(date)) {
		obj.value=obj.value+'/';
		return;
	}
	if (!/^\d{2}\/\d{2}\/\d{4}$/.test(date)) {
		return;
	}
	test1=(/^\d{2}\/?\d{2}\/\d{4}$/.test(date))
	date=date.split('/')
	d=new Date(date[2],date[1]-1,date[0])
	test2=(1*date[0]==d.getDate() && 1*date[1]==(d.getMonth()+1) && 1*date[2]==d.getFullYear())
	if (test1 && test2) return true;
	obj.select();
	obj.focus();
	return false;
}

function resetDr(){
	document.getElementById("search").value = "";
	getDoctorList();
}


</script>
<style>
body {
	 font-family:Arial;
	 width:980px;
	 size:9px;
	 line-height:1.7;
	 margin-top:0;
	 padding-top:0;
}

#bgLayer {
	z-index: 0;
	position: absolute;
	maring:0;
	width: 100%;
	height: 100%;
	top: 0;
	left: 0;
}

#mask {
	z-index: 200;
	position: absolute;
	background-color: #ffffff;
	maring:0;
	width: 100%;
	height: 100%;
	top: 0;
	left: 0;
	opacity: 0.4;
	filter: alpha(opacity=40);
	display:none;
}

td {
	font-size: 12px;
}

tr { height: 30px;}	
table.formDetails td { font-size: 15px; padding-top: 3px;}

#loading, #loadingRef {
	display:none;
	z-index: 2000;
	position: absolute;
	top: 360px;
	left: 400px;
}

#procedureGroup {
	position: absolute;
	display:none;
	z-index: 30;
	width: 577px;
}

#patno, #patname, #patcname, #patidno {
	width: 60%;
}


.input {
	width:50px;
	z-index:100;
}
img:hover {
	cursor: hand;
}

#select2{
	font-size: 14px;
	height:60px;
	width:700px;

}
#select1{
	font-size: 13px;
	height:180px;

}

.pointer {
	cursor:pointer;
	color: #0000FF;
}

#version {
	color: #666666;
}

.show {display: block;}
</style>
</body>
</html:html>