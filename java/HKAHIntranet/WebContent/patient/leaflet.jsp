<%@ page import="com.hkah.config.*"%>
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
<%@ page language="java" contentType="text/html; charset=big5"%>
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

</style>
<body>
<%-- <jsp:include page="../patient/checkSession.jsp" /> --%>

<div id="popUpDialog" align="center" style="position:absolute; z-index:10; width:auto; height:auto; display:none;"
	class="ui-dialog ui-widget ui-widget-content ui-corner-all">
	<div align="center" class = "ui-widget-header"><label>Preview</label></div>
	<div id = "popUpContent">
	</div>
</div>

<form name="form1">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><td align="center"><img src="../images/pdf.gif"><br/><span class="enquiryLabel extraBigText">Hospital Leaflet</span></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<table style="width:100%;" border="0">
					<tr><th colspan="2" style="width:50%;font-size:20px;">Leaflet</th><th style="width:50%;font-size:20px;">Link</th></tr>
					<tr >
						<td width="10%">
							<img width="40px" src="../images/pdficon.gif"/>
						</td>
						<td>
							<label><%=MessageResources.getMessageEnglish("label.patient.admission") %> <%=MessageResources.getMessageTraditionalChinese("label.patient.admission") %></label>			
						</td>
						<td><a style="color:#0066CC;font-size: 15px;" index="0" noDialog="Y" class="preview" href="javascript:void(0)">Link 連結</a></td>
					</tr>
					<tr >
						<td width="10%" class="infoData">
							<img width="40px" src="../images/pdficon.gif"/>
						</td>
						<td class="infoData">
							<label><%=MessageResources.getMessageEnglish("label.patients.charter") %> <%=MessageResources.getMessageTraditionalChinese("label.patients.charter") %></label>			
						</td>
						<td class="infoData"><a style="color:#0066CC;font-size: 15px;" index="1" noDialog="Y" class="preview" href="javascript:void(0)">Link 連結</a></td>
					</tr>
					<tr >
						<td width="10%">
							<img width="40px" src="../images/pdficon.gif"/>
						</td>
						<td>
							<label><%=MessageResources.getMessageEnglish("label.why.vegetarian.diet") %> <%=MessageResources.getMessageTraditionalChinese("label.why.vegetarian.diet") %></label>			
						</td>
						<td><a style="color:#0066CC;font-size: 15px;" index="2" noDialog="Y" class="preview" href="javascript:void(0)">Link 連結</a></td>
					</tr>
					<tr >
						<td width="10%" class="infoData">
							<img width="40px" src="../images/pdficon.gif"/>
						</td>
						<td class="infoData">
							<label><%=MessageResources.getMessageEnglish("label.health.care.advisory") %> <%=MessageResources.getMessageTraditionalChinese("label.health.care.advisory") %> </label>			
						</td>
						<td class="infoData"><a style="color:#0066CC;font-size: 15px;" index="3" noDialog="Y" class="preview" href="javascript:void(0)">Link 連結</a></td>
					</tr>
					<tr >
						<td width="10%">
							<img width="40px" src="../images/pdficon.gif"/>
						</td>
						<td>
							<label><%=MessageResources.getMessageEnglish("label.daily.room.rate") %> <%=MessageResources.getMessageTraditionalChinese("label.daily.room.rate") %></label>			
						</td>
						<td ><a style="color:#0066CC;font-size: 15px;" index="5" noDialog="Y" class="preview" href="javascript:void(0)">Chinese 中文</a> / <a style="color:#0066CC;font-size: 15px;" index="4" noDialog="Y" class="preview" href="javascript:void(0)">English 英文</a></td>
					</tr>
					<tr >
						<td width="10%" class="infoData">
							<img width="40px" src="../images/pdficon.gif"/>
						</td>
						<td class="infoData">
							<label><%=MessageResources.getMessageEnglish("label.renovation.letter") %> <%=MessageResources.getMessageTraditionalChinese("label.renovation.letter") %></label>			
						</td>
						<td class="infoData"><a style="color:#0066CC;font-size: 15px;" index="7" noDialog="Y" class="preview" href="javascript:void(0)">Chinese 中文</a> / <a style="color:#0066CC;font-size: 15px;" index="6" noDialog="Y" class="preview" href="javascript:void(0)">English 英文</a></td>
					</tr>
				</table>		
			</td>
		</tr>
	</table>
</form>
<script language="javascript">
	var previewClickItem = [
	                    	{link: 'http://www.hkah.org.hk/upload/File/Brochures/Patient%20Admission.pdf'},
	                    	{link: 'http://www.hkah.org.hk/upload/File/Brochures/Patient%20Charter.pdf'},
	                    	{link: 'http://www.hkah.org.hk/upload/File/Brochures/Why_Vegetarian_Diet(1).pdf'},
	                    	{link: 'http://www.hkah.org.hk/upload/File/Health_Care_Advisory.pdf'},
	                    	{eng: 'http://www.hkah.org.hk/new/eng/hospitalization_fi.htm'},
	                    	{chi: 'http://www.hkah.org.hk/new/chi/hospitalization_fi.htm'},
	                    	{file: '395'}, 
		                    {file: '396'}
	                   ];
	
	function submitAction(act) {
		showLoadingBox();
		if (act == 'order') {
			if (!document.form1.registrationForm.checked &&
					!document.form1.patientAdmission.checked &&
					!document.form1.patientsCharter.checked &&
					!document.form1.whyVegetarianDiet.checked &&
					!document.form1.healthCareAdvisory.checked &&
					!document.form1.dailyRoomRateEng.checked &&
					!document.form1.dailyRoomRateChi.checked &&
					!document.form1.preAnaesthesiaQuestionnaire.checked &&
					!document.form1.renovationOTEng.checked &&
					!document.form1.renovationOTChi.checked) {
				alert("Please send any leaflet for hardcopy.");
				return false;
			}
			document.form1.action = "../patient/leafletProcess.jsp";
		} else {
			document.form1.action = "../patient/";
		}
		hideLoadingBox();
		document.form1.submit();
	}
	
	function addBtn(type, id) {
		if(type == "preview") {
			var content = "<button id='"+id+"' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>"+
							'<%=MessageResources.getMessageEnglish("label.click.here") %> <%=MessageResources.getMessageTraditionalChinese("label.click.here") %>'+
						  "</button>";
			return content;
 		}
		else if(type == "close") {
			var content = "<button id='"+id+"' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>"+
		  				  "Close</button>";
			return content;
		}
	}
	
	function previewEvent() {		
		$('.preview').each(function() {
			$(this).click(function() {
				var item = previewClickItem[$(this).attr('index')];
				var showDialog = $(this).attr('noDialog');
				
				$('#popUpContent').html('');
				
				$.each(item, function(index, value) {
					if(index == 'file') {	
						if(showDialog=='Y'){						
							downloadFile(value);
							return false;
						}
						
						var content = 
							'<br/>' +
							'<label>Preview: </label>' +
							addBtn("preview", "fileClick") +
							'<br/>' +
							'<br/>';
						
						$('#popUpContent').append(content);
						
						$('#fileClick').click(function() {
							downloadFile(value);
						});
					}
					else if(index == 'link') {
						if(showDialog=='Y'){						
							window.open(value);
							return false;
						}
						
						var content = 
							'<br/>' +
							'<label>Preview: </label>' +
							addBtn("preview", "linkClick") +
							'<br/>' +
							'<br/>';
						
						$('#popUpContent').append(content);
						
						$('#linkClick').click(function() {
							window.open(value);
						});
					}
					else if(index == 'chi') {
						if(showDialog=='Y'){						
							window.open(value);
							return false;
						}
						
						var content = 
							'<br/>' +
							'<label>'+
								'<%=MessageResources.getMessageEnglish("label.chinese.version") %> <%=MessageResources.getMessageTraditionalChinese("label.chinese.version") %>: '+
							'</label>' +
							addBtn("preview", "chiClick") +
							'<br/>' +
							'<br/>';
						
						$('#popUpContent').append(content);
						
						$('#chiClick').click(function() {
							window.open(value);
						});
					}
					else if(index == 'eng') {
						if(showDialog=='Y'){						
							window.open(value);
							return false;
						}
						
						var content = 
							'<br/>' +
							'<label>'+
								'<%=MessageResources.getMessageEnglish("label.english.version") %> <%=MessageResources.getMessageTraditionalChinese("label.english.version") %>: '+
							'</label>' +
							addBtn("preview", "engClick") +
							'<br/>' +
							'<br/>';
						
						$('#popUpContent').append(content);
						
						$('#engClick').click(function() {
							window.open(value);
						});
					}
				});
				if(showDialog=='Y'){
					return false;
				}
				
				$('#popUpContent').append(addBtn("close", "closePreview"));
				
				$('#closePreview').click(function() {
					$('#popUpDialog').css('display', 'none');
				});
				
				var leftPos = ($(this).position().left - $('#popUpDialog').width() + $(this).width());
				
				$('#popUpDialog').css('top', $(this).position().top + $(this).height())
									.css('left', (leftPos < 0)?0:leftPos);
				
				$('#popUpDialog').css('display', '');
			});
		});
	}
	
	$(document).ready(function(){
		previewEvent();
		hideLoadingBox();
	});
</script>
<jsp:include page="footer.jsp" flush="false" />
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>