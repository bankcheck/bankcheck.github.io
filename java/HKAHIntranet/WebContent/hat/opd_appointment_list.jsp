<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%!
public static ArrayList getAppointmentList(String startDate, String startTime, String endDate, String endTime,String sendSts) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT P.MOTHCODE, B.BKGPNAME, P.PATSMS, M.SMCID, BKGMTEL, ");
	sqlStr.append("D.DOCFNAME || ' ' || D.DOCGNAME, D.DOCCNAME, ");
	sqlStr.append("TO_CHAR(B.BKGSDATE, 'DD'), TO_CHAR(B.BKGSDATE, 'MM'), ");
	sqlStr.append("TO_CHAR(B.BKGSDATE, 'YYYY'), TO_CHAR(B.BKGSDATE, 'HH24'), ");
	sqlStr.append("TO_CHAR(B.BKGSDATE, 'MI'), B.BKGID, M.SEND_TIME, ");
	sqlStr.append("P.PATNO, P.PATPAGER, M.SMCID, CD.CO_DISPLAYNAME, P.COUCODE, ");
	sqlStr.append("D.TITTLE, M.RES_MSG, TO_CHAR(B.BKGSDATE, 'DD/MM/YYYY'), ");
	sqlStr.append("S.DOCCODE, B.BKGSTS, TO_CHAR(B.BKGSDATE, 'DD/MM/YYYY HH24:MI'), ");
	sqlStr.append("DECODE(INSTR (M.SMCID, 'typhoon'),1,TO_CHAR(M.SEND_TIME, 'DD/MM/YYYY HH24:MI'),''), ");
	sqlStr.append("DECODE(INSTR (M.SMCID, 'typhoon'),1,(CASE WHEN M.RES_MSG='BKERR01' THEN 'The country code is 852/853, but the phone no. is not 8 digits' ");
	sqlStr.append(" WHEN M.RES_MSG='BKERR02' THEN 'The country code is 86, but first letter of phone no. is not ''1'' or the phone no. is not 11 digits' ");
	sqlStr.append(" WHEN M.RES_MSG='BKERR03' THEN 'The country code is not 852/853/86' ");
	sqlStr.append(" WHEN M.RES_MSG='BKERR04' THEN 'Country Code is empty value' ");
	sqlStr.append(" WHEN M.RES_MSG='BKERR05' THEN 'Phone No. is empty value' ");
	sqlStr.append("ELSE M.RES_MSG  END),'') ");
	sqlStr.append("FROM BOOKING@IWEB B, SCHEDULE@IWEB S, DOCTOR@IWEB D, PATIENT@IWEB P, CO_DOCTORS CD, SMS_LOG M ");

	if (startTime == null) {
		sqlStr.append("WHERE B.BKGSDATE >= TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	} else {
		sqlStr.append("WHERE B.BKGSDATE >= TO_DATE('"+startDate+" "+startTime+":00', 'DD/MM/YYYY HH24:MI:SS') ");
	}
	if (endTime == null) {
		sqlStr.append("AND   B.BKGSDATE <= TO_DATE('"+endDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	} else {
		sqlStr.append("AND   B.BKGSDATE <= TO_DATE('"+endDate+" "+endTime+":59', 'DD/MM/YYYY HH24:MI:SS') ");
	}
	sqlStr.append("AND   S.SCHID(+) = B.SCHID ");
	sqlStr.append("AND   D.DOCCODE(+) = S.DOCCODE ");
	sqlStr.append("AND   P.PATNO(+) = B.PATNO ");
	sqlStr.append("AND TO_CHAR(B.BKGID)  = M.KEY_ID(+) ");
	sqlStr.append("AND	  CD.CO_DOC_CODE(+) = S.DOCCODE ");
	sqlStr.append("AND   B.BKGSTS = 'N' ");
	if(!"".equals(sendSts)){
		sqlStr.append("AND M.SMCID LIKE 'typhoon%' ");
	}
	//sqlStr.append("AND   B.USRID <> 'HACCESS' "); //Health Assessment
	//sqlStr.append("AND   B.USRID <> 'HEART' "); //Heart Centre
	//4 - Oncology, 9 - fs, 5, 6, 7, 8, 10 - rehab
	//sqlStr.append("AND   (B.SMCID <> '4' OR B.SMCID IS NULL) ");
	sqlStr.append("AND   D.DOCCODE <> 'OPDN' ");
	sqlStr.append("AND   D.DOCCODE <> 'OPDG' ");
	sqlStr.append("AND   D.DOCCODE <> 'OPD1' ");
	sqlStr.append("AND   D.DOCCODE <> 'OPD7' ");
	sqlStr.append("AND   D.DOCCODE <> '1566' ");//DENTIST
	sqlStr.append("AND   D.DOCCODE <> '1860' ");//DENTIST
	//sqlStr.append("AND   D.DOCCODE <> 'N008' ");//FS
	//sqlStr.append("AND   D.DOCCODE <> 'N029' ");//FS
	//sqlStr.append("AND   B.USRID <> 'FS' ");//FS
	//sqlStr.append("AND   D.DOCCODE NOT LIKE 'R%' ");//REHAB
	//sqlStr.append("AND   B.USRID <> 'REHAB' ");//REHAB
		if("0".equals(sendSts)){
			sqlStr.append("AND M.SUCCESS = 0 ");
		} else if ("1".equals(sendSts)){
			sqlStr.append("AND M.SUCCESS = 1 ");
		}

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getDoctorList(String startDate, String startTime, String endDate, String endTime,String sendSts) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT DISTINCT DR.DOCCODE,DR.DOCNAME,DR.DOCMTEL,'12',DR.KEYID, ");
	sqlStr.append("DECODE(INSTR (M.SMCID, 'typhoon'),1,TO_CHAR(M.SEND_TIME, 'DD/MM/YYYY HH24:MI'),''), ");
	sqlStr.append("DECODE(INSTR (M.SMCID, 'typhoon'),1,(CASE WHEN M.RES_MSG='BKERR01' THEN 'The country code is 852/853, but the phone no. is not 8 digits' ");
	sqlStr.append(" WHEN M.RES_MSG='BKERR02' THEN 'The country code is 86, but first letter of phone no. is not ''1'' or the phone no. is not 11 digits' ");
	sqlStr.append(" WHEN M.RES_MSG='BKERR03' THEN 'The country code is not 852/853/86' ");
	sqlStr.append(" WHEN M.RES_MSG='BKERR04' THEN 'Country Code is empty value' ");
	sqlStr.append(" WHEN M.RES_MSG='BKERR05' THEN 'Phone No. is empty value' ");
	sqlStr.append("ELSE M.RES_MSG  END),''), ");
	sqlStr.append("'','','',DATESTAMP,'doctor','-1' ");
	sqlStr.append(" FROM ");
	sqlStr.append("(SELECT DOCCODE,DOCNAME,DOCMTEL,KEYID,DATESTAMP ");
	sqlStr.append(" FROM  ");
	sqlStr.append("((SELECT DISTINCT D.DOCCODE,D.DOCMTEL,DOCFNAME||' '||DOCGNAME AS DOCNAME ");
	sqlStr.append(", 'T'||TO_CHAR(TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),'YYYYMMDD')||D.DOCCODE as KEYID ");
	sqlStr.append(", TO_CHAR(TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),'YYYYMMDD')as DATESTAMP ");
	sqlStr.append("FROM  TEMPLATE@IWEB T, DOCTOR@IWEB D WHERE T.DOCCODE = D.DOCCODE AND D.DOCSTS = -1 ");
	sqlStr.append("AND  ('' IS NULL OR D.SPCCODE = '' OR ('' = 'DENTIST' AND D.SPCCODE IN ('DENTIST', 'DENHYG', 'ORALMAX', 'PROSDON')))) ");
	sqlStr.append("UNION( SELECT DISTINCT D.DOCCODE,D.DOCMTEL,DOCFNAME||' '||DOCGNAME AS DOCNAME ");
	sqlStr.append(", 'T'||TO_CHAR(TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),'YYYYMMDD')||D.DOCCODE as KEYID ");
	sqlStr.append(", TO_CHAR(TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),'YYYYMMDD')as DATESTAMP ");
	sqlStr.append("FROM BOOKING@IWEB B,SCHEDULE@IWEB S,DOCTOR@IWEB D ");
	if (startTime == null) {
		sqlStr.append("WHERE B.BKGSDATE >= TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	} else {
		sqlStr.append("WHERE B.BKGSDATE >= TO_DATE('"+startDate+" "+startTime+":00', 'DD/MM/YYYY HH24:MI:SS') ");
	}
	if (endTime == null) {
		sqlStr.append("AND   B.BKGSDATE <= TO_DATE('"+endDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	} else {
		sqlStr.append("AND   B.BKGSDATE <= TO_DATE('"+endDate+" "+endTime+":59', 'DD/MM/YYYY HH24:MI:SS') ");
	}
	sqlStr.append("AND   S.SCHID(+) = B.SCHID ");
	sqlStr.append("AND   D.DOCCODE(+) = S.DOCCODE ");
	sqlStr.append("AND   B.BKGSTS = 'N' ");
	sqlStr.append("))T,TABLE(CAST(MULTISET(SELECT LEVEL FROM DUAL CONNECT BY  LEVEL <= LENGTH (REGEXP_REPLACE(T.DOCMTEL, '[^/]+'))  + 1) AS SYS.ODCINUMBERLIST)) LEVELS ");
	sqlStr.append("WHERE  DOCCODE <> 'OPDN' ");
	sqlStr.append("AND DOCCODE <> 'OPDG' AND DOCCODE <> 'OPD1' AND DOCCODE <> 'OPD7' AND DOCCODE NOT LIKE 'R%' AND DOCCODE NOT LIKE 'N%'  ORDER BY DOCCODE) DR");
	sqlStr.append(", SMS_LOG M");
	sqlStr.append(" WHERE DR.KEYID  = M.KEY_ID(+)");
	if("0".equals(sendSts)){
		sqlStr.append("AND M.SUCCESS = 0 ");
	} else if ("1".equals(sendSts)){
		sqlStr.append("AND M.SUCCESS = 1 ");
	}
	sqlStr.append(" ORDER BY LENGTH(DOCCODE),DOCCODE ASC ");
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

String apptDate = ParserUtil.getParameter(request, "apptDate");
String apptTimeFrom = ParserUtil.getParameter(request, "apptTimeFrom");
String apptTimeTo = ParserUtil.getParameter(request, "apptTimeTo");
String sendSts = ParserUtil.getParameter(request, "sendSts");
String sendSMS = request.getParameter("sendSms");
String sendType = ParserUtil.getParameter(request, "sendType");

if (apptDate == null || apptDate.length() <= 0) {
	apptDate = DateTimeUtil.getCurrentDate();
}

if (apptTimeFrom == null || apptTimeFrom.length() <= 0) {
	apptTimeFrom = "00:00";
}

if (apptTimeTo == null || apptTimeTo.length() <= 0 ) {
	apptTimeTo = "23:59";
}

ArrayList record = null;
if ("doctor".equals(sendType)) {
	record = getDoctorList(apptDate, apptTimeFrom, apptDate, apptTimeTo,sendSts);
} else {
	 record = getAppointmentList(apptDate, apptTimeFrom, apptDate, apptTimeTo,sendSts);
}
request.setAttribute("appointment_list", record);
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
						<jsp:param name="pageTitle" value="OPD Appointment List" />
					</jsp:include>
					
					<table>
						<tr>
							<td>
								<form name="search_form" action="opd_appointment_list.jsp" method="post">
									<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
										<tr class="smallText">
											<td class="infoLabel" width="30%">
												Appointment Date: 
											</td>
											<td class="infoData" width="50%">
												<!-- <input type="text" name="apptDate" class="datepickerfield" 
														value="<%=apptDate == null ? "" : apptDate%>" 
														maxlength="10" size="10">
												 -->
												<select name="apptDate">
												<%
													SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");												
										        	Date currentDate = new Date();
													Calendar c = Calendar.getInstance();
											        c.setTime(currentDate);
													String today = sdf.format(c.getTime());											        
											        c.add(Calendar.DATE, 1);
													String tmr = sdf.format(c.getTime());												
												%>
												 	<option value="<%=today %>" <%=apptDate.equals(today)?"selected":"" %>>Today (<%=today %>)</option>
												 	<option value="<%=tmr %>" <%=apptDate.equals(tmr)?"selected":"" %>>TMR (<%=tmr %>)</option>
												</select>
											</td>
											<td class="infoLabel" width="30%">
												Appointment Time From : 
											</td>
											<td class="infoData" width="30%">
												<input type="text" name="apptTimeFrom" 
														value="<%=apptTimeFrom == null ? "" : apptTimeFrom%>" 
														maxlength="10" size="10">
											</td>
											<td class="infoLabel" width="5%">
												To 
											</td>
											<td class="infoData" width="50%">
												<input type="text" name="apptTimeTo" 
														value="<%=apptTimeTo == null ? "" : apptTimeTo%>" 
														maxlength="10" size="10">
											</td>
											<td class="infoLabel" width="10%">
												Status 
											</td>
											<td class="infoData" width="30%">
												<select name="sendSts">
													<option value=""></option>
													<option value="1" <%="1".equals(sendSts)?" selected=\"selected\"" : ""%>>Success</option>
													<option value="0" <%="0".equals(sendSts)?" selected=\"selected\"" : ""%>>Fail/Not Send</option>
												</select>
											</td>
										</tr>
										<tr>
											<td class="infoLabel" width="10%">
												Type 
											</td>
											<td class="infoData" width="40%">
												<select name="sendType">
													<option value="patient" <%="patient".equals(sendType)?" selected=\"selected\"" : ""%>>Patient</option>
													<option value="doctor" <%="doctor".equals(sendType)?" selected=\"selected\"" : ""%>>Doctor</option>
												</select>
											</td>
										</tr>
										<tr class="smallText">
											<td colspan="4" align="center">
												<button onclick="return submitSearch();">
													<bean:message key="button.search" />
												</button>
											</td>
										</tr>
									</table>
									<input type="hidden" name="sendSms" value="<%=sendSMS == null ? "":sendSMS %>" />
								</form>
							</td>
							<td>
								<button onclick="return promptSendSMS();" 
									class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
									Send Typhoon SMS
								</button>
							</td>
						</tr>
					</table>
					
					<input type="hidden" name="sendSMSDate" value="<%=apptDate == null ? "" : apptDate%>" />
					
					<bean:define id="functionLabel">OPD Appointment List</bean:define>
					<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
					<display:table id="row" name="requestScope.appointment_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable">	
						<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
					<%if ("doctor".equals(sendType)) { %>
								<display:column title="Doctor Code" style="width:7%">
									<c:out value="${row.fields0}" /> 
								</display:column>
								<display:column title="Doctor Name" style="width:7%">
									<c:out value="${row.fields1}" /> 
								</display:column>
								<display:column title="Doctor Mobile" style="width:7%">
									<c:out value="${row.fields2}" /> 
								</display:column>
								<display:column title="Success Date" style="width:5%">
									<c:out value="${row.fields5}" /> 
								</display:column>
								<display:column title="Return Msg" style="width:5%">
								<c:out value="${row.fields6}" /> 
								</display:column>
					<%} else { %>	
						<display:column titleKey="prompt.patientNo" style="width:7%">
							<c:out value="${row.fields14}" /> 
						</display:column>
						<display:column title="Lang" style="width:5%">
							<c:out value="${row.fields0}" /> 
						</display:column>
						<display:column titleKey="prompt.patName" style="width:7%">
							<c:out value="${row.fields1}" /> 
						</display:column>
						<display:column titleKey="prompt.countryCode" style="width:5%">
							<c:out value="${row.fields18}" /> 
						</display:column>
						<display:column title="Patient Mobile" style="width:7%">
							<c:out value="${row.fields15}" /> 
						</display:column>
						<display:column title="Booking Mobile" style="width:7%">
							<c:out value="${row.fields4}" /> 
						</display:column>
						<display:column title="Doctor Code" style="width:5%">
							<c:out value="${row.fields22}" /> 
						</display:column>
						<display:column title="Dr. Eng Name" style="width:7%">
							<c:out value="${row.fields5}" /> 
						</display:column>
						<display:column title="Dr. Chi Name" style="width:7%">
							<c:out value="${row.fields6}" /> 
						</display:column>
						<display:column title="Booking Date" style="width:7%">
							<c:out value="${row.fields24}" /> 
						</display:column>
						<display:column title="Success Date" style="width:5%">
							<c:out value="${row.fields25}" /> 
						</display:column>
						<display:column title="Return Msg" style="width:5%">
							<c:out value="${row.fields26}" /> 
						</display:column>
					<%} %>	
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
							$('#confirmSmsBoxContent').append('<label>Send Typhoon SMS to the patients booked on '+
																$('input[name=sendSMSDate]').val()+'?</label><br/><br/>');
							
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
							
							sentSMS = 0;
							successSent = 0;
							failSent = 0;
<%
							for (int i = 0; i < record.size(); i++) {
								ReportableListObject row = (ReportableListObject)record.get(i);
%>
								$.ajax({
									url: '../sms/sendTyphoonSms.jsp',
									//if smcid is null or empty, default 1
									data: {bkID: "<%=row.getValue(12)%>", smcid: <%=row.getValue(3).length()==0?"1":row.getValue(3)%>,
											sendType:"<%=row.getValue(11)%>",docCode:"<%=row.getValue(0)%>",docMobile:"<%=row.getValue(2)%>"
											,appDate:"<%=row.getValue(10)%>"},
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
										failSent++;
									},
									complete: function(jqXHR, textStatus) {
										sentSMS++;
										$('.progress-label').html(
												'Sending.......'+sentSMS+'/'+totalSMS+'<br/>'+
												'(Success: '+successSent+' Fail: '+failSent+')');
										sendSMSPost(sentSMS==totalSMS);
									}
								});
<%
							}
%>
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
						
						var sentSMS = 0;
						var successSent = 0;
						var failSent = 0;
						var totalSMS = <%=record.size()%>;
						
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