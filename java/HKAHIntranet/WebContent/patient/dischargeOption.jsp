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
<form name="form1" method="get">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td  style="font-weight:bold;font-size:180%;text-align: center;">Discharge Survey Option</td>
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<tr><td>&nbsp;</td></tr>	
	<tr id = "locIndicator">
		<td align="center">
			<div style="width:450px; height:auto" align="center">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
				 style="width:250px; height:40px; font-size:20px;"
				  onclick="return submitAction('Dispute Bill');">
				Dispute Bill</button>				
			</div>
		</td>		
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr >
		<td align="center">
			<div style="width:450px; height:auto" align="center">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
				 style="width:250px; height:40px; font-size:20px;"
				  onclick="return submitAction('Wrongly Entry Bill');">
				Wrongly Entry Bill</button>				
			</div>
		</td>		
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr >
		<td align="center">
			<div style="width:450px; height:auto" align="center">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
				 style="width:250px; height:40px; font-size:20px;"
				  onclick="return submitAction('Too Expensive');">
				Too Expensive</button>				
			</div>
		</td>		
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr >
		<td align="center">
			<div style="width:450px; height:auto" align="center">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
				 style="width:250px; height:40px; font-size:20px;"
				  onclick="return submitAction('No Money');">
				No Money</button>				
			</div>
		</td>		
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr >
		<td align="center">
			<div style="width:450px; height:auto" align="center">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
				 style="width:250px; height:40px; font-size:20px;"
				  onclick="return submitAction('No Log');">
				No Log</button>				
			</div>
		</td>		
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr >
		<td align="center">
			<div style="width:450px; height:auto" align="center">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
				 style="width:250px; height:40px; font-size:20px;"
				  onclick="return submitAction('');">
				Skip</button>				
			</div>
		</td>		
	</tr>
	
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
<script language="javascript">
	function submitAction(act) {
		showLoadingBox();
		window.location.replace('../patient/survey.jsp?surveyID=8&surveyType=discharge&dischargeType='+act);
		hideLoadingBox();
		return false;
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
<jsp:include page="footer.jsp" flush="false" />
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>