<%@ page import="com.hkah.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%!
public static ArrayList getDentalSMSList(String isReceiveSMS, String sendDateFrom, String sendDateTo, String nextApptDateFrom, String nextApptDateTo) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select DE.DE_TITLE, DE.DE_FIRSTNAME, DE.DE_LASTNAME, DE.DE_MOBILE, ");
	sqlStr.append(" DE.DE_NEXTAPPTPROVIDER, DE.DE_NEXTAPPTDATE, DE.DE_NEXTAPPTTIME, DECODE(S.SUCCESS, 0, 'False', 1, 'True') Success ");
	sqlStr.append(" from   DE_SMS_INFO DE, SMS_LOG S ");
	sqlStr.append(" where  DE.DE_ENABLED = 1 ");
	sqlStr.append(" and    DE.DE_SMS_ID = S.KEY_ID ");
	sqlStr.append(" AND    S.SMCID = 'dental' ");
	if ("receive".equals(isReceiveSMS)) {
		sqlStr.append(" AND S.SUCCESS = 1 ");
	} else if ("notReceive".equals(isReceiveSMS)){
		sqlStr.append(" AND S.SUCCESS = 0 ");		
	}
	
	if(sendDateFrom != null && sendDateFrom.length() > 0){
		sqlStr.append("AND    DE.DE_CREATED_DATE >= TO_DATE('"+sendDateFrom+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	}
	if(sendDateTo != null && sendDateTo.length() > 0){
		sqlStr.append("AND    DE.DE_CREATED_DATE <= TO_DATE('"+sendDateTo+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	}
	if(nextApptDateFrom != null && nextApptDateFrom.length() > 0){
		sqlStr.append("AND    TO_DATE(DE_NEXTAPPTDATE, 'dd/mm/yyyy') >= TO_DATE('"+nextApptDateFrom+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	}
	if(nextApptDateTo != null && nextApptDateTo.length() > 0){
		sqlStr.append("AND    TO_DATE(DE_NEXTAPPTDATE, 'dd/mm/yyyy') <= TO_DATE('"+nextApptDateTo+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	}
	
	sqlStr.append(" ORDER BY TO_DATE(DE_NEXTAPPTDATE, 'dd/mm/yyyy'), DE.DE_MODIFIED_DATE ");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

String isReceiveSMS = request.getParameter("isReceive");
String sendSMS = request.getParameter("sendSms");
String sendDate = request.getParameter("sendDate");
String sendDateFrom = request.getParameter("sendDateFrom");
String sendDateTo = request.getParameter("sendDateTo");
String nextApptDateFrom = request.getParameter("nextApptDateFrom");
String nextApptDateTo = request.getParameter("nextApptDateTo");
if ("today".equals(sendDate)) {
	String curDateStr = sdf.format(new Date());
	sendDateFrom = curDateStr;
	sendDateTo = curDateStr;
}

ArrayList record = getDentalSMSList(isReceiveSMS, sendDateFrom, sendDateTo, nextApptDateFrom, nextApptDateTo);
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
						<jsp:param name="pageTitle" value="function.dental.sms.list" />
					</jsp:include>
					
					<table>
						<tr>
							<td>
								<form name="search_form" action="sms_list.jsp" method="post">
									<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
										<tr class="smallText">
											<td class="infoLabel" width="30%">
												Receive SMS:
											</td>
											<td class="infoData" width="50%">
											<select name='isReceive'>
												<option></option>
												<option <%="receive".equals(isReceiveSMS)?" selected":"" %> value='receive'>Receive</option>
												<option <%="notReceive".equals(isReceiveSMS)?" selected":"" %> value='notReceive'>Not Receive</option>
											</select>	
											</td>	
											<td width="20%">
												<button onclick="return promptSendSMS();" 
									class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
									<bean:message key="function.dental.sms.send" />
								</button>
											</td>	
										</tr>
										<tr>
											<td class="infoLabel" width="30%">
												Send Date:
											</td>
											<td  class="infoData" width="50%">
												<input type="textfield" name="sendDateFrom" id="sendDateFrom" class="datepickerfield" value="<%=sendDateFrom==null?"":sendDateFrom %>" maxlength="16" size="16">
												-
												<input type="textfield" name="sendDateTo" id="sendDateTo" class="datepickerfield" value="<%=sendDateTo==null?"":sendDateTo %>" maxlength="16" size="16">
											</td>
										</tr>
										<tr>
											<td class="infoLabel" width="30%">
												Next Appt Date:
											</td>
											<td  class="infoData" width="50%">
												<input type="textfield" name="nextApptDateFrom" id="nextApptDateFrom" class="datepickerfield" value="<%=nextApptDateFrom==null?"":nextApptDateFrom %>" maxlength="16" size="16">
												-
												<input type="textfield" name="nextApptDateTo" id="nextApptDateTo" class="datepickerfield" value="<%=nextApptDateTo==null?"":nextApptDateTo %>" maxlength="16" size="16">
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
								</form>
							</td>							
						</tr>
					</table>
					
					<bean:define id="functionLabel">Dental SMS List</bean:define>
					<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
					<display:table id="row" name="requestScope.sms_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable">	
						<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
						<display:column title="Title" style="width:7%">
							<c:out value="${row.fields0}" /> 
						</display:column>
						<display:column title="First Name" style="width:5%">
							<c:out value="${row.fields1}" /> 
						</display:column>
						<display:column title="Last Name" style="width:7%">
							<c:out value="${row.fields2}" /> 
						</display:column>
						<display:column title="Mobile Number" style="width:7%">
							<c:out value="${row.fields3}" /> 
						</display:column>
						<display:column title="Next Appt provider" style="width:5%">
							<c:out value="${row.fields4}" /> 
						</display:column>
						<display:column title="Next Appt Date" style="width:7%">
							<c:out value="${row.fields5}" /> 
						</display:column>
						<display:column title="Next Appt Time" style="width:7%">
							<c:out value="${row.fields6}" /> 
						</display:column>	
						<display:column title="Success" style="width:7%">
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
								$.ajax({
									url: '../sms/smsDental.jsp',
									data: "",
									async: true,
									type: 'POST',
									success: function(data, textStatus, jqXHR) {
										if ($.trim(data)=='true') {
											
										}
										else {
											
										}
									},
									error: function(jqXHR, textStatus, errorThrown) {
										
									},
									complete: function(jqXHR, textStatus) {										
										$('.progress-label').html(
												'Finish sending SMS.');
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
										
						$(document).ready(function() {
							$('#confirmSmsBoxYesBtn').click(function() {
								$('#confirmSmsBox').hide();
								$('input[name=apptDate]').val($('input[name=sendSMSDate]').val());
								$('input[name=sendSms]').val("Y");
								submitSearch();
							});
							
							$('#confirmSmsBoxNoBtn').click(function() {
								$('#confirmSmsBox').hide();
								hideOverLay('body');
							});
							
							if ($('input[name=sendSms]').val() === "Y") {
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