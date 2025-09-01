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
<jsp:include page="header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<style>
.serContent {
	cursor:pointer;
	font-size:14px;
}
</style>
<body>
<%--  
<jsp:include page="../patient/checkSession.jsp" />
--%>
<form name="form1" method="post">
<div id="serInfo" style="position:absolute; z-index:12;">
	<div id="callServiceInfo" class = "ui-widget-header serContent" align="center" style="padding:3px 12px 3px 12px;">
		<img src="../images/callService.jpg"/><br/>
		<bean:message key="prompt.callService" />
	</div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<%--  
<jsp:include page="../patient/patientInfo.jsp" />
--%>
	<tr><td>&nbsp;</td></tr>
	<!--  <tr><td align="center"><span class="enquiryLabel extraBigText">Patient Service</span></td></tr>-->
	<tr><td>&nbsp;</td></tr>
	<tr id = "locIndicator">
		<td align="center">
			<div style="width:450px; height:auto" align="center">				
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' style="width:200px; height:200px; float:left; font-size:24px;" onclick="return submitAction('leaflet');">
				<img src="../images/pdf.gif"/><br/><br/>Hospital Leaflet</button>
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' style="width:200px; height:200px; float:left; font-size:24px;" onclick="return submitAction('obService');">
				<img width="100" src="../images/obService.jpg"/><br/><br/>Obstetric Admission</button>
			</div>
		</td>
		<!--  
		<td align="center"><button onclick="return submitAction('leaflet');"><img src="../images/pdf.gif"><br/>Hopsital Leaflet</button></td>
		-->
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
			<div style="width:450px; height:auto" align="center">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' style="width:200px; height:200px; float:left; font-size:24px;" onclick="return submitAction('generalAdmission');">
				<img width="75" src="../images/generalAdmission.jpg"/><br/><br/>General Admission</button>
				
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' style="width:200px; height:200px; float:left; font-size:24px;" onclick="return submitAction('hkahWeb');">
				<img src="../images/A logo.jpg"/><br/><br/>Hospital Website</button>
				<%--
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' style="width:200px; height:200px; float:left; font-size:24px;" onclick="return submitAction('billing');">
				<img src="../images/billing.jpg"/><br/><br/>Bill Summary</button>
				--%>
			</div>
		</td>
		<!--
		<td align="center"><button onclick="return submitAction('logout');"><img src="../images/exit.jpg"><br/>Logout</button></td>
		-->
	</tr>
	<tr><td>&nbsp;</td></tr>
	<%-->
	<tr>
		<td align="center">
			<div style="width:450px; height:auto" align="center">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' style="width:200px; height:200px; float:left; font-size:24px;" onclick="return submitAction('surveyAdmission');">
				<img width="75" src="../images/survey.gif"/><br/><br/>Admission Survey</button>
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' style="width:200px; height:200px; float:left; font-size:24px;" onclick="return submitAction('surveyDischarge');">
				<img width="75" src="../images/survey2.jpg"/><br/><br/>Discharge Survey</button>
			</div>
		</td>
	</tr>
	--%>
	<%-- 
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
			<div style="width:450px; height:auto" align="center">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' style="width:200px; height:200px; float:left; font-size:24px;" onclick="return submitAction('foodServices');">
				<img  src="../images/food.jpg"/><br/><br/>Food Service</button>				
			</div>
		</td>
		<!--
		<td align="center"><button onclick="return submitAction('logout');"><img src="../images/exit.jpg"><br/>Logout</button></td>
		-->
	</tr>
	--%>
	
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
<script language="javascript">
	function submitAction(act) {
		showLoadingBox();
		clearParamInForm();
		if (act == 'billing') {
			document.form1.action = "../patient/login.jsp";
			document.form1.submit();
			hideLoadingBox();
			return true;
		} else if (act == 'leaflet') {
			document.form1.action = "../patient/leaflet.jsp";
			document.form1.submit();
			showLoadingBox();
			return true;
		} else if (act == 'foodServices') {
			document.form1.action = "../patient/foodServices.jsp";
			document.form1.submit();
			hideLoadingBox();
			return true;
		} else if (act == 'logout') {
			document.form1.action = "../patient/index.jsp?action=logout";
			document.form1.submit();
			hideLoadingBox();
			return true;
		}else if (act == 'obService') {
			addParamToForm('form1', 'type', 'obService');
			document.form1.action = "../patient/admission_service.jsp";
			document.form1.submit();
			hideLoadingBox();
			return true;
		}else if (act == 'generalAdmission') {
			addParamToForm('form1', 'type', 'generalAdmission');
			document.form1.action = "../patient/admission_service.jsp";
			document.form1.submit();
			hideLoadingBox();
			return true;
		}else if (act == 'hkahWeb') {
			window.open('http://www.hkah.org.hk/new/eng/index.htm');
			hideLoadingBox();
			return false;
		}else if (act == 'surveyAdmission') {
			addParamToForm('form1', 'surveyID', '9');
			addParamToForm('form1', 'surveyType', 'admission');
			document.form1.action = '../patient/survey.jsp';
			hideLoadingBox();
			return true;
		}else if (act == 'surveyDischarge') {
			addParamToForm('form1', 'surveyID', '8');
			addParamToForm('form1', 'surveyType', 'discharge');
			document.form1.action = '../patient/survey.jsp';
			hideLoadingBox();
			return true;
		}
	}
	
	function addParamToForm(formID, name, value) {
		$('<input />').attr('type', 'hidden')
						.attr('name', name)
						.attr('value', value)
						.appendTo('form[name='+formID+']');
	}
	
	function clearParamInForm() {
		$('form[name=form1]').find('input').remove();
	}
	
	$(document).ready(function(){
		if($.browser.safari) {
			if($('tr#locIndicator').position().top < 200)
				$('div#serInfo').css('top', $('tr#locIndicator').position().top);
			else
				$('div#serInfo').css('top', $('tr#locIndicator').position().top);
		}
		else {
			$('div#serInfo').css('top', $('tr#locIndicator').position().top);
		}
		
		$('div#callServiceInfo').click(function() {
			showLoadingBox();
			document.form1.action = '../patient/callService.jsp';
			document.form1.submit();
			hideLoadingBox();
			return true;
		});
	});
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>