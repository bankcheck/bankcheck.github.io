<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<% 
	String command = null;

	String acmCode = null;
	String language = "";
	String pboRmk = null;
	String patRmk = null;
	String clRmk = null;
	String ckRmk = null;
	String uptDate = null;
	//String reached = null;
	String flwUpDate = null;
	String payMth = null;
	String lastModify = "";
	String sendMethod = null;
	String insuranceRmk = null;
	String bkStatus = null;
	String pager = null;
	String admDate = null;
	String email = null;
	String flwUpSts = null;
	String patSms = null;
	String arcode = null;
	String copaytype = null;
	String aredate = null;
	String arcamt = null;
	String patNo = null;
	String preBookID = null;
	String surTime = null;
	String otherRmk = null;
	String otPso = null;
	String otRemark = null;
	
	command = request.getParameter("command");
	language = request.getParameter("language");
	pager = request.getParameter("patPager");
	admDate = request.getParameter("admDate");
	email = request.getParameter("patEmail");
	bkStatus = request.getParameter("bkStatus");
	acmCode = request.getParameter("acmCode");
	patSms = request.getParameter("patSms");
	arcode = request.getParameter("arcode");
	copaytype = request.getParameter("copaytype");
	aredate = request.getParameter("aredate");
	arcamt = request.getParameter("arcamt");
	patNo = request.getParameter("patNo");
	preBookID = request.getParameter("preBookID");
	payMth = request.getParameter("payMth");
	uptDate = request.getParameter("uptDate");
	otPso = request.getParameter("otPso");

	boolean createAction = false;
	boolean updateAction = false;
	boolean deleteAction = false;
	
	if ("create".equals(command)) {
 		//reached = request.getParameter("reached");
 		sendMethod = request.getParameter("sendMethod");
 		flwUpDate = request.getParameter("flwUpDate");
 		lastModify = request.getParameter("lastModify");
 		flwUpSts = request.getParameter("flwUpSts");
 		patSms = request.getParameter("patSms");
 		
		createAction = true;
	} else if ("update".equals(command)) {
 		//reached = request.getParameter("reached");
 		sendMethod = request.getParameter("sendMethod");
 		flwUpDate = request.getParameter("flwUpDate");
 		lastModify = request.getParameter("lastModify");
 		flwUpSts = request.getParameter("flwUpSts");
 		patSms = request.getParameter("patSms");
 		
		updateAction = true;
	}else if (("updateEmail").equals(command)) {
		//reached = request.getParameter("reached");
 		sendMethod = request.getParameter("sendMethod");
 		flwUpDate = request.getParameter("flwUpDate");
 		lastModify = request.getParameter("lastModify");
 		flwUpSts = request.getParameter("flwUpSts");
 		patSms = request.getParameter("patSms");
	}
	else if("delete".equals(command)) {
		sendMethod = request.getParameter("sendMethod");
 		flwUpDate = request.getParameter("flwUpDate");
 		lastModify = request.getParameter("lastModify");
 		flwUpSts = request.getParameter("flwUpSts");
 		patSms = request.getParameter("patSms");
 		
		deleteAction = true;
	}
	
	if (preBookID != null && preBookID.length() > 0) {	
		ArrayList record = InPatientPreBookDB.getRmk(patNo, preBookID, uptDate);
		if(record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			
			pboRmk = row.getValue(1);
			patRmk = row.getValue(0);
			clRmk = row.getValue(2);
			if(uptDate != null && uptDate.length() > 0 && !uptDate.equals("null")) {
				insuranceRmk = row.getValue(4);
				otherRmk = row.getValue(5);
			}
			otRemark = row.getValue(3);
		}
		
		record = InPatientPreBookDB.getLastReachedBy(preBookID);
		if(record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			
			flwUpSts = row.getValue(0);
		}
	}
	
	if(bkStatus == null || bkStatus.equals("null")) {
		bkStatus = "N";
	}
	
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
<br/><br/>
<table cellpadding="0" cellspacing="5"
					class="contentFrameMenu" border="0" style = "width:100%;">
	<tr class="smallText">	
		<td class="infoLabel" width="15%">
			Booking Status
		</td>
		<td class="infoData2" width="45%">
			<select name="bkStatus">
				<option value="">			
				<option value="N" <%=("N".equals(bkStatus) || bkStatus == null)?" selected":""%>>Normal</option>
				<option value="C" <%="C".equals(bkStatus)?" selected":""%>>Cancelled</option>					
				<option value="R" <%="R".equals(bkStatus)?" selected":""%>>Re-scheduled</option>
			</select>
		</td>
		<td width="15%">
			
		</td>
		<td width="25%">
			
		</td>
	</tr>
</table>

<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%">
			<bean:message key="prompt.pbList.preferredClass" />
		</td>
		<td class="infoData2" width="40%">
			<select name="preferClass">
				<option value=""></option>		
				<option value="I" <%="I".equals(acmCode)?" selected":""%>>VIP</option>
				<option value="P" <%="P".equals(acmCode)?" selected":""%>>PRIVATE</option>					
				<option value="S" <%="S".equals(acmCode)?" selected":""%>>SEMI-PRIVATE</option>
				<option value="T" <%="T".equals(acmCode)?" selected":""%>>STANDARD</option>
			</select>		
		</td>
		<td class="infoLabel" width="15%">
			<bean:message key="prompt.language" />
		</td>
		<td class="infoData2" width="25%">
			<%=language %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">
			<bean:message key="prompt.patient.remark"/>
		</td>
		<td class="infoData2" width="40%">
			<textarea name="patRmk" onkeypress="return imposeMaxLength(this, 1000);" value="<%=patRmk==null?"":patRmk %>" cols="100" rows="5"><%=patRmk==null?"":patRmk %></textarea>
			<%--
			<input type="textfield" name="patRmk" value="<%=patRmk==null?"":patRmk %>" maxlength="1000" size="100"/>
			--%>
		</td>
		<td class="infoLabel" width="15%">
			AR Code
		</td>
		<td class="infoData2" width="25%">
			<%=arcode==null?"":arcode %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">
			<bean:message key="prompt.rmkPbo"/>
		</td>
		<td class="infoData2" width="40%">
			<textarea name="pboRmk" onkeypress="return imposeMaxLength(this, 200);" value="<%=pboRmk==null?"":pboRmk %>" cols="100" rows="3"><%=pboRmk==null?"":pboRmk %></textarea>
			<%--
			<input type="textfield" name="pboRmk" value="<%=pboRmk==null?"":pboRmk %>" maxlength="145" size="100"/>
			--%>
		</td>
		<td class="infoLabel" width="15%">
			Co-Payment Type
		</td>
		<td class="infoData2" width="25%">
			<%=copaytype==null?"":copaytype %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">
			<bean:message key="prompt.cathLabRmk"/>
		</td>
		<td class="infoData2" width="40%">
			<textarea name="clRmk" onkeypress="return imposeMaxLength(this, 75);" value="<%=clRmk==null?"":clRmk %>" cols="100" rows="3"><%=clRmk==null?"":clRmk %></textarea>
			<%--
			<input type="textfield" name="clRmk" value="<%=clRmk==null?"":clRmk %>" maxlength="75" size="100"/>
			--%>
		</td>
		<td class="infoLabel" width="15%">
			Insurance Coverage End-Date
		</td>
		<td class="infoData2" width="25%">
			<%=aredate==null?"":aredate %>
		</td>
	</tr>
	 <tr class="smallText">
		<td class="infoLabel" width="15%">
			<bean:message key="prompt.cyberknifeRmk"/>
		</td>
		<td class="infoData2" width="40%">
			<%--
			<input type="textfield" name="ckRmk" value="<%=ckRmk==null?"":ckRmk %>" maxlength="145" size="100"/>
			--%>
		</td>
		<td class="infoLabel" width="15%">
			Insurance Limit Amount
		</td>
		<td class="infoData2" width="25%">
			<%=arcamt==null?"":arcamt %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">
			OT Remark
		</td>
		<td class="infoData2" width="40%">
			<%=otRemark==null?"":otRemark %>
		</td>
	</tr>
	<%--<tr class="smallText">
		<td class="infoLabel" width="15%">
			<bean:message key="prompt.reachedBy"/>
		</td>
		<td class="infoData2" width="40%">
			<select name="reached">
				<option value=""></option>			
				<option value="L" <%="L".equals(reached)?" selected":""%>>Link</option>
				<option value="E" <%="E".equals(reached)?" selected":""%>>Email</option>					
				<option value="S" <%="S".equals(reached)?" selected":""%>>SMS</option>
				<option value="F" <%="F".equals(reached)?" selected":""%>>Fax</option>
				<option value="P" <%="P".equals(reached)?" selected":""%>>Phone</option>
				<option value="U" <%="U".equals(reached)?" selected":""%>>Preferred Upfront</option>
				<option value="C" <%="C".equals(reached)?" selected":""%>>Cannot be reached</option>
			</select>
			<div id="sendMsgDiv" style="display:none;">
				<select name="sendMethod">
					<option value=""></option>
					<option value="SE" <%="SE".equals(sendMethod)?" selected":""%>>SMS(Eng)</option>
					<option value="SC" <%="SC".equals(sendMethod)?" selected":""%>>SMS(Chi)</option>
					<option value="EL" <%="EL".equals(sendMethod)?" selected":""%>>Email</option>
				</select>
				<button onclick="sendMsg('select[name=sendMethod]', '#sendResult'); return false;">send</button>
				<span id="sendResult" style="color:red"></span>
			</div>
		</td>
	</tr>--%>
	<tr class="smallText" style="height:50px">
		<td class="infoLabel" width="15%">
			<bean:message key="prompt.preferPayMtd"/>
		</td>
		<td class="infoData2" width="40%">
			<select name="payMth">
				<option value=""></option>		
				<option value="D" <%="D".equals(payMth)?" selected":""%>>Credit Card</option>
				<option value="I" <%="I".equals(payMth)?" selected":""%>>Insurance</option>					
				<option value="C" <%="C".equals(payMth)?" selected":""%>>Cash</option>
				<option value="E" <%="E".equals(payMth)?" selected":""%>>EPS</option>
				<option value="O" <%="O".equals(payMth)?" selected":""%>>Others</option>
			</select>
			OT / Endo PSO (No recall is needed) <input <%="1".equals(otPso)?" CHECKED":""%> name="otPso" type="checkbox"></input>
			<textarea name="insuranceRmk" onkeypress="return imposeMaxLength(this, 500);" style="display:none; width:90%"><%=(insuranceRmk==null||insuranceRmk.equals("null"))?"":insuranceRmk %></textarea>
		</td>
		<td class="infoLabel" width="15%">
			<bean:message key="prompt.followUpDate"/>
		</td>
		<td class="infoData2" width="25%">
			<input type="textfield" name="flwUpDate" id="flwUpDate" 
				class="datepickerfield" value="<%=flwUpDate==null?"":flwUpDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">
			Result (Patient reached by)
		</td>
		<td class="infoData2" width="40%">
			<select name="flwUpSts">
				<option value="0"></option>
				<option value="4" <%="4".equals(flwUpSts)?" selected":""%>>Link</option>
				<option value="12" <%="12".equals(flwUpSts)?" selected":""%>>Web</option>
				<option value="5" <%="5".equals(flwUpSts)?" selected":""%>>Email</option>					
				<option value="6" <%="6".equals(flwUpSts)?" selected":""%>>SMS</option>
				<option value="7" <%="7".equals(flwUpSts)?" selected":""%>>Fax</option>
				<option value="8" <%="8".equals(flwUpSts)?" selected":""%>>Phone</option>
				<option value="9" <%="9".equals(flwUpSts)?" selected":""%>>Can't be reached</option>
				<option value="10" <%="10".equals(flwUpSts)?" selected":""%>>Preferred upfront registration</option>
				<option value="11" <%="11".equals(flwUpSts)?" selected":""%>>Booking cancelled/rescheduled</option>
				<option value="13" <%="13".equals(flwUpSts)?" selected":""%>>Same day booking</option>
				<option value="14" <%="14".equals(flwUpSts)?" selected":""%>>Booking made after printing call list (1 day ahead)</option>
				<option value="15" <%="15".equals(flwUpSts)?" selected":""%>>Without contact information</option>
				<option value="16" <%="16".equals(flwUpSts)?" selected":""%>>Duplicate booking</option>
				<option value="17" <%="17".equals(flwUpSts)?" selected":""%>>Virtual booking for LOG</option>
				<option value="18" <%="18".equals(flwUpSts)?" selected":""%>>Others</option>			
			</select>
			<textarea name="otherRmk" onkeypress="return imposeMaxLength(this, 500);" style="display:none; width:90%"><%=(otherRmk==null||otherRmk.equals("null"))?"":otherRmk %></textarea>
			
		</td>
		<td class="infoLabel" width="15%">
			<bean:message key="prompt.lastModifiedBy"/>
		</td>
		<td class="infoData2" width="25%">
			<%=lastModify %>
		</td>
	</tr>
</table>

<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction) { %>
			<button onclick="return submitAction('create');" class="btn-click"> <bean:message key="button.add" /> </button>
<%	} else if (updateAction) { %>
			<button onclick="return submitAction('update');" class="btn-click"> <bean:message key="button.save" /> </button>
			<button onclick="return submitAction('view');" class="btn-click">Clear</button>			
<%  } else { %>
			<button onclick="return submitAction('create');" class="btn-click"> <bean:message key="button.add" /> </button>			
<%	} %>
			<label style="float:right;color:red">For Phone Registration Use</label>
		</td>
	</tr>
	<tr>
		<td>
			<div style='float:right;'>
				<button class="btn-click" onclick="transToAdmission()" id="transToAdm">Transfer To Pre-Admission</button>
			</div>
		</td>
	</tr>
</table>

<input type="hidden" name="uptDate" value="<%=uptDate %>" />
<input type="hidden" name="pager" value="<%=pager %>" />
<input type="hidden" name="admDate" value="<%=admDate %>" />
<input type="hidden" name="email" value="<%=email %>" />
<input type="hidden" name="patSms" value="<%=patSms %>" />

<script language="javascript">
	function transToAdmission() {
		var confirmSend = confirm("Do you confirm to transfer this patient to Pre-Admission?");
		if(confirmSend) {
			$.ajax({
				type: "POST",
				url: "../inpatient/transToAdmission.jsp",
				data: "patNo=" + $('input[name=patNo]').val() + "&bpbID=" + $('input[name=preBookID]').val(),
				async: false,
				success: function(values){
					if(values.indexOf('true') > -1) {
						alert("Successful");
					}else {
						alert("Fail");
					}
				},//success
				error: function(jqXHR, textStatus, errorThrown) {
							alert(textStatus);
						}
			});//$.ajax*/
		}
		return false;
	}

	function imposeMaxLength(Object, MaxLen)
	{
	  return (Object.value.length < MaxLen);
	}
	
	function sendEmail(resultDom, link, email) {
		var eval;
		if(!email) {
			eval = $('input[name=email]').val();
		}
		else {
			eval = $(email).val();
		}
		//alert(eval);
		if(link) {
			$.ajax({
				type: "POST",
				url: "../registration/admission_email.jsp",
				data: "email=" + eval + "&type=INPAT" +"&BPBID="+$('input[name=preBookID]').val(),
				success: function(values){
					if(values != '') {
						$(resultDom).html(values);
					}//if
				},//success
				error: function(jqXHR, textStatus, errorThrown) {
							alert(textStatus);
						}
			});//$.ajax*/
		}
		else {
			$.ajax({
				type: "POST",
				url: "../inpatient/booking_email.jsp",
				data: "email=" + eval + "&type=INPAT" +"&BPBID="+$('input[name=preBookID]').val()+
						"&admDate="+$('input[name=admDate]').val(),
				success: function(values){
					if(values != '') {
						$(resultDom).html(values);
					}//if
				},//success
				error: function(jqXHR, textStatus, errorThrown) {
							alert(textStatus);
						}
			});//$.ajax*/
		}
	}
	
	function sendSMS(lang, admDate, resultDom,template) {
		var confirmSend = true;
		if($('input[name=patNo]').val() &&($('input[name=patSms]').val() == '0' || !$('input[name=patSms]').val())) {
			confirmSend = confirm("Patient does not agree to receive SMS.\nDo you continue to send this messeage?");
		}
		
		if(confirmSend) {
			var smsPhone;
			if($('select[name=areaCode]').val() != 'N') {
				smsPhone = $('select[name=areaCode]').val()+$('input[name=patTelInput]').val();
			}else {	
				smsPhone = $('input[name=patTelInput]').val();
			}
			//alert(smsPhone);
			
			$.ajax({
				type: "POST",
				url: "../sms/smsNotify.jsp",
				data: "phone=" + smsPhone + 
						"&lang="+lang+"&admDate="+admDate + "&type=INPAT" +"&BPBID="+$('input[name=preBookID]').val() +"&template="+template,
				success: function(values){
					if(values != '') {
						$(resultDom).html(values);
					}//if
				}//success
			});//$.ajax
		}
		else {
		}
		
	}
	
	function sendMsg(from, resultDom,template) {
		var type = $(from).val();
		var admDate = $('input[name=admDate]').val();
		if(type == "EL") {
			if ($('input[name=email]').val().length > 0) {
				sendEmail(resultDom, true);
			} else {
				alert('Empty email.');
			}
		}else if(type == "SE" || type == "SC") {
			var lang = (type=="SE")?"eng":"chi";
			if($('input[name=patTelInput]').val().length > 0 && admDate.length > 0) {
				sendSMS(lang, admDate, resultDom,template);
			} else {
				alert("Telephone(Mobile) or Schd. Admission Date doesn't exist.");
			}
		}else {
			
		}
		return false;
	}

	$(document).ready(function() {
		//select reachBy Event
		/*$('select[name=reached]').change(function() {
			$('option:selected', this).each(function(){
		        if($(this).val() == "C") {
		        	$('div#sendMsgDiv').css('display', '');
		        	$("#sendResult").html('');
		        }
		        else {
		        	$('div#sendMsgDiv').css('display', 'none');
		        	$("#sendResult").html('');
		        }
		    });
		}).trigger('change');*/
		$('.datepickerfield').datepicker({
			showOn: "button",
			buttonImage: "../images/calendar.jpg",
			buttonImageOnly: true
		});

		$('select[name=sendMethod]').change(function() {
			$("#sendResult").html('');
		});
		
		//select insurance Event
		$('select[name=payMth]').change(function() {
			$('option:selected', this).each(function(){
				 if($(this).val() == "I") {
					 $('textarea[name=insuranceRmk]').css('display', '');
				 }
				 else {
					 $('textarea[name=insuranceRmk]').css('display', 'none');
				 }
			});
		}).trigger('change');
		
		$('select[name=flwUpSts]').change(function() {
			$('option:selected', this).each(function(){
				 if($(this).val() == "18") {
					 $('textarea[name=otherRmk]').css('display', '');
				 }
				 else {
					 $('textarea[name=otherRmk]').css('display', 'none');
				 }
			});
		}).trigger('change');
	});
</script>