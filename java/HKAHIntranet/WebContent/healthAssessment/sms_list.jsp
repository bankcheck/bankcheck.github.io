<%@ page import="com.hkah.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%!

public static ArrayList getSMSList(String smsDate) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select PE.PATNO,PE.PATMTEL, ");
	sqlStr.append(" PE.MOTHCODE, PE.REVCODE,TO_CHAR(PE.EXPIRY_DATE,'dd/mm/yyyy'), ");
	sqlStr.append(" DECODE(S.SUCCESS, 0, 'Fail:'||S.RES_MSG, 1, 'Success') Success, PE.PATNAME,TO_CHAR(PE.CREATE_DATE,'dd/mm/yyyy HH24:MI:SS')  ");
	sqlStr.append(" from   PE_SMS PE, SMS_LOG S ");
	sqlStr.append(" where  PE.ENABLED = 1 ");
	sqlStr.append(" and    PE.SMS_ID = S.KEY_ID(+) ");
	sqlStr.append(" AND    S.SMCID = 'HAPGP' ");
	if(smsDate != null && smsDate.length() > 0){
		sqlStr.append("AND PE.CREATE_DATE >=  TO_DATE('"+smsDate+"  00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND PE.CREATE_DATE <=  TO_DATE('"+smsDate+"  23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");

	}
	sqlStr.append(" ORDER BY TO_CHAR(PE.CREATE_DATE, 'dd/mm/yyyy'), PE.PATNO ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

String patNo = request.getParameter("patNo");
String mobile = request.getParameter("mobile");
String couCode = request.getParameter("couCode");
String refCode = request.getParameter("refCode");
String expDate = request.getParameter("expDate");
String sendSMS = request.getParameter("sendSms");
String smsDate = request.getParameter("smsDate");
if (smsDate == null || smsDate.length() == 0) {
	smsDate = DateTimeUtil.getCurrentDate();
}
if (expDate == null || expDate.length() == 0) {
	expDate = DateTimeUtil.getRollDate(365,0,0);
}

String patName = request.getParameter("patName");
String lang = request.getParameter("lang");

ArrayList record = getSMSList(smsDate);
request.setAttribute("sms_list", record);
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp" />
	<body>
		<div id="indexWrapper">
			<div id="mainFrame">
				<div id="contentFrame">
					<jsp:include page="../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="HAPGP SMS List" />
					</jsp:include>
					
					<table>
						<tr>
							<td>
								<form name="search_form" id="search_form" action="sms_list.jsp" method="post">
									<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
										<tr>
											<th class="infoTitle" colspan="6" width="100%">
											Send SMS
											</th>
										</tr>
										<tr class="smallText">
											<td class="infoLabel" width="50%">
												Patient Number:
											</td>
											<td class="infoData" width="50%" colspan="5">
												<input type="textfield" name="patNo" id="patNo" value="<%=patNo==null?"":patNo %>" maxlength="10" size="15" onblur="getPatName(this)" onfocus="resetPatDataField()"/>
											</td>	
										</tr>
										<tr>
											<td class="infoLabel" width="25%">
												SMS Lang:
											</td>
											<td class="infoData" width="15%">
											<select name="lang" id="lang">
												<option <%="ENG".equals(lang)?" selected":"" %> value='ENG'>English</option>
												<option <%="TRC".equals(lang)?" selected":"" %> value='TRC'>Traditional Chinese</option>
												<option <%="SMC".equals(lang)?" selected":"" %> value='SMC'>Simplified Chinese</option>
												<option <%="JAP".equals(lang)?" selected":"" %> value='JAP'>Japanese</option>
											</select>
											</td>
											<td class="infoLabel" width="25%">
												Country Code:
											</td>
											<td  class="infoData"  width="15%">
												<input type="textfield" name="couCode" id="couCode" value="<%=couCode==null?"":couCode %>" maxlength="10" size="10"/>
											</td>
											<td class="infoLabel" width="15%">
												Phone Number:
											</td>
											<td  class="infoData" width="15%">
												<input type="textfield" name="mobile" id="mobile" value="<%=mobile==null?"":mobile %>" maxlength="30" size="30">
											</td>
										</tr>
										<tr>
											<td class="infoLabel" width="30%">
												Reward Code
											</td>
											<td  class="infoData" width="30%">
												<input type="textfield" name="refCode" id="refCode" value="<%=refCode==null?"":refCode %>" maxlength="30" size="30">												
											</td>
											<td class="infoLabel" width="30%">
												Expiry Date
											</td>
											<td  class="infoData" width="30%" colspan="2">
												<input type="text" name="expDate" id="expDate" class="datepickerfield" value="<%=expDate == null ? "" : expDate%>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">											
											</td>
											<td align="center">
												<button onclick="return promptSendSMS();" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
													style="font-size:18px!important;">
													Send SMS
												</button>
											</td>	
										</tr>
									</table>
									<span id="showPatient_indicator"></span>
									<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
										<tr>
												<th class="infoTitle" colspan="2" width="100%">
												SMS Sent Search
												</th>
										</tr>									
										<tr class="smallText">
											<td class="infoLabel" width="30%">
												 Date: 
											</td>
											<td class="infoData" width="70%">
												<input type="text" name="smsDate" class="datepickerfield" value="<%=smsDate %>" maxlength="10" size="10">
											</td>
										</tr>
										<tr class="smallText">
											<td colspan="2" align="center">
												<button onclick="return submitSearch();">
													<bean:message key="button.search" />
												</button>
											</td>
										</tr>
									</table>
									<input type="hidden" name="sendSms" value="<%=sendSMS == null ? "":sendSMS %>" />
									<input type="hidden" name="patName" id="patName" value="<%=patName == null ? "":patName %>" />
								</form>
							</td>							
						</tr>
					</table>
					
	<bean:define id="functionLabel">SMS List</bean:define>
	<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
	<display:table id="row" name="requestScope.sms_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable">	
		<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
		<display:column title="Patient Number" style="width:7%">
			<c:out value="${row.fields0}" /> 
		</display:column>
		<display:column title="Patient Name" style="width:5%">
			<c:out value="${row.fields6}" /> 
		</display:column>
		<display:column title="Mobile" style="width:5%">
			<c:out value="${row.fields1}" /> 
		</display:column>
		<display:column title="SMS Language" style="width:3%">
			<c:out value="${row.fields2}" /> 
		</display:column>
		<display:column title="Reward Code" style="width:5%">
			<c:out value="${row.fields3}" /> 
		</display:column>
		<display:column title="Expiry Date" style="width:5%">
			<c:out value="${row.fields4}" /> 
		</display:column>
		<display:column title="Success" style="width:10%">
			<c:out value="${row.fields5}" /> 
		</display:column>
				<display:column title="Send Date" style="width:10%">
			<c:out value="${row.fields7}" /> 
		</display:column>
				
		<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	</display:table>
	
	
			
<script language="javascript">
			function submitSearch() {
				showOverLay('body');
				showLoadingBox('body', 100, 350);
				document.search_form.submit();
			}
			

			
			function promptSendSMS() {
				$('#confirmSmsBoxContent').html('');
				$('#confirmSmsBoxContent').append('<div class="ui-widget-header">Confirm</div><br/>');
				$('#confirmSmsBoxContent').append('<label>Send SMS to patient?</label><br/><br/>');
				
				$('#confirmSmsBox').css('top', 300);
				$('#confirmSmsBox').css('left', $(window).width()/2-$('#confirmSmsBox').width()/2);
				
				showOverLay('body');
				$('#confirmSmsBox').show();
				return false;
			}
				
				function sendSMS() {
					
					//showLoadingBox('body', 100, 350);
					$('#progressbar').css('top', 350);
					$('#progressbar').css('left', $(window).width()/2-$('#progressbar').width()/2);
					$('#progressbar').show();
					showOverLay('body');
					
					successSent = 0;
					failSent = 0;
		
					$.ajax({
						url: '../sms/sendHAPGPSms.jsp',
						//if smcid is null or empty, default 1
						data: {patNo:document.getElementById("patNo").value,mobile:document.getElementById("mobile").value,
								couCode:document.getElementById("couCode").value,lang:document.getElementById("lang").value,
								refNo:document.getElementById("refCode").value,expDate:document.getElementById("expDate").value,
								patName:document.getElementById("patName").value},
								
						async: true,
						type: 'POST',
						success: function(data, textStatus, jqXHR) {
							if ($.trim(data)=='true') {
								successSent++;
							}
							else {
								failSent++;
							}
						},
						error: function(jqXHR, textStatus, errorThrown) {
							
						},
						complete: function(jqXHR, textStatus) {										
							$('.progress-label').html(
									'Finish sending SMS.<br/>(Success:'+successSent+' Fail: '+failSent+')');
							sendSMSPost(true);
						}
					});
		
				}
				
				function sendSMSPost(complete) {
					if (complete) {
						$('#progressbar').append(
								'<button id="progressCloseBtn" '+
								'class="ui-button ui-widget ui-state-default'+
								' ui-corner-all ui-button-text-only">Close</button>');
						
						$('#progressCloseBtn').click(function() {
							$('#progressbar').hide();
							showLoadingBox('body', 100, 350);
							
							var url = window.location.href;
							url.replace("sendSms=Y", "sendSms=N"); //ensure send sms only one time
							window.location.replace(url);
						});
						
						$('input[name=sendSms]').val("N");
					}
				}
				
				function resetPatDataField(){
					document.getElementById("mobile").value = "";
					document.getElementById("couCode").value = "";
					document.getElementById("patName").value = "";
					document.getElementById("lang").value = "ENG"; 
				}
				
				function getPatName(patno) {
 					document.getElementById("mobile").value = "";
					document.getElementById("couCode").value = "";
					document.getElementById("patName").value = "";
					document.getElementById("lang").value = ""; 
					
					if (patno.value.length > 0) {
						$.ajax({
							type: "POST",
							url: "../registration/admission_hats.jsp",
							data: "patno=" + patno.value,
							success: function(values) {
							if (values != '') {					
								$("#showPatient_indicator").html(values);
								if (values.substring(0, 1) == 1) {
									document.getElementById("lang").value = document.search_form.hats_mothcode.value;
									document.getElementById("couCode").value = document.search_form.hats_coucode.value;
									document.getElementById("mobile").value = document.search_form.hats_patmtel.value;
									document.getElementById("patName").value = document.search_form.hats_patfname.value + ' ' + document.search_form.hats_patgname.value;
								} else {
									alert('Patient not found.');
									patno.value = '';
								}
							}//if
							$("#showPatient_indicator").html("");
							}//success
						});//$.ajax
					}
				}
								
				$(document).ready(function() {
					$('#confirmSmsBoxYesBtn').click(function() {
						$('#confirmSmsBox').hide();
						$('input[name=sendSms]').val("Y");
						submitSearch();
					});
					
					$('#confirmSmsBoxNoBtn').click(function() {
						$('#confirmSmsBox').hide();
						hideOverLay('body');
					});
					
					if ($('input[name=sendSms]').val() == "Y") {
						sendSMS();
					}
				});							
		</script>
				</div>
			</div>
		</div>
		
		<div id="progressbar" style="position:absolute; z-index:15;display:none;"
				class="ui-dialog ui-widget ui-widget-content ui-corner-all">
			<div class="ui-widget-header">Status</div><br/>
			<div class="progress-label">Loading...</div><br/>
		</div>
		
		<div id="confirmSmsBox" class="ui-dialog ui-widget ui-widget-content ui-corner-all" 
				style="position:absolute; z-index:15;display:none;">
			<div id="confirmSmsBoxContent"></div>
			<button id="confirmSmsBoxYesBtn"
					class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				Yes
			</button>
			<button id="confirmSmsBoxNoBtn"
					class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				No
			</button>
		</div>
	</body>
</html:html>