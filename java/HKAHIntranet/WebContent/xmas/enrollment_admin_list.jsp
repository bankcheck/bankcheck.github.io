<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.convert.Converter"%>
<%
UserBean userBean = new UserBean(request);

String message = null;
String errorMessage = null;
String command = request.getParameter("command");
String staffID = request.getParameter("staffID");
String eventID = XmasGatheringDB.getEventIDByCurrentYear();
String staffName = request.getParameter("staffName");;
String scheduleID = request.getParameter("scheduleID");
String staffStatus = request.getParameter("staffStatus");
String subDate = request.getParameter("subDate");
String confirmStatus = request.getParameter("confirmStatus");


String groupWaitingID = null;
String groupCancelID = null;
Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);
ArrayList groupRecord = XmasGatheringDB.getGroupWaitingCancelID(eventID);
if(groupRecord.size()>0){
	for(int i = 0; i < 2; i++) {
		ReportableListObject groupRow = (ReportableListObject) groupRecord.get(i);	
		if(i == 0){
			groupWaitingID = groupRow.getValue(1);
		}else{
			groupCancelID = groupRow.getValue(1);
		}
	}
}

if("confirm".equals(command)){	
	String eID = request.getParameter("eID");
	String sID = request.getParameter("sID");
	String enID = request.getParameter("enID");	
	boolean success = XmasGatheringDB.updateStaffConfirm(userBean,eID,sID,enID);	
	if(!success){
		errorMessage = "Error occured while confirming staff.";
	}else{
		message = "Staff confirmed.";
	}
}


if ("initAction".equals(command)) {
	String eID = request.getParameter("eID");
	String gID = request.getParameter("gID");
	String enID = request.getParameter("enID");
	String uID = request.getParameter("uID");
	
	if (XmasGatheringDB.withdraw2(userBean, eventID, gID, 
			enID, uID) == 0) {
		int result = XmasGatheringDB.enroll2(userBean, eventID, 
				groupWaitingID, "1", uID);
		System.out.println(result);
		if(result == 0) {
			message = "Staff withdrew successfully.";
		}
		else if(result == 1) {
			errorMessage = "Staff Enrolled.";
		}
		else {
			errorMessage = "Fail to withdraw.";
		}
	}
	else {
		errorMessage = "Fail to withdraw.";
	}
}


ArrayList events = null;
String eventPrice = null;
ArrayList groupInfoRecord = XmasGatheringDB.getGroupInfo(eventID);
if(groupInfoRecord.size()>0){
	ReportableListObject groupInfoRow = 
								(ReportableListObject) groupInfoRecord.get(0);	
	eventPrice = groupInfoRow.getValue(5);
}


request.setAttribute("enrollment_list_admin", 
		EnrollmentDB.getEnrolledClass("christmas", eventID, scheduleID, null, staffID, subDate, confirmStatus, staffStatus, staffName));
events = ScheduleDB.getListByDate("christmas",eventID, null, "other", "party", null, null, false, 99);

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<body>
	<jsp:include page="../common/banner2.jsp"/>
		<div id=indexWrapper>
			<div id=mainFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.xmas.enrollment.list.admin" />
					<jsp:param name="category" value="group.xams" />
				</jsp:include>
				<jsp:include page="../common/message.jsp" flush="false">
					<jsp:param name="message" value="<%=message %>" />
					<jsp:param name="errorMessage" value="<%=errorMessage %>" />
				</jsp:include>				
				
				<form name="searchForm" action="enrollment_admin_list.jsp" method="post">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="25%">
								<bean:message key="prompt.staffID" />
							</td>
							<td class="infoData" width="75%">
								<input type="textfield" name="staffID" value="<%=staffID==null?"":staffID %>" maxlength="50" size="50" />
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="25%">
							<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
								員工姓名
							<%} else { %>
								Staff Name:
							<%} %> 
							</td>
							<td class="infoData" width="75%">
								<input type="textfield" name="staffName" value="<%=staffName==null?"":staffName %>" maxlength="50" size="50" />
							</td>
						</tr>
						<%if(ConstantsServerSide.isHKAH()) { %>												
						<tr class="smallText">
							<td class="infoLabel" width="25%">
							<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
								員工類別
							<%} else { %>
								Staff Status:
							<%} %> 
							</td>
							<td class="infoData" width="35%">
								<select id="staffStatus" name="staffStatus">
									<option value="">ALL</option>
									<option value="FT"<%="FT".equals(staffStatus)?" selected":""%>>FT</option>
									<option value="PT"<%="PT".equals(staffStatus)?" selected":""%>>PT</option>
									<option value="CA"<%="CA".equals(staffStatus)?" selected":""%>>CA</option>
								</select>
							</td>
						</tr>
						<%} %>
						<tr class="smallText">
							<td class="infoLabel" width="25%">
							<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
								組別
							<%} else { %>
								Group: 
							<%} %>
							</td>
							<td class="infoData" width="35%">
								<select id="scheduleID" name="scheduleID">
									<option value="">ALL</option>
									<%
										if(events.size() > 0) { 
											for(int i = 0; i < events.size(); i++) {
												ReportableListObject row = (ReportableListObject) events.get(i);
									%>
												<option value="<%=row.getValue(7)%>" <%=(scheduleID != null)?(scheduleID.equals(row.getValue(7))?" selected":""):"" %>><%=row.getValue(4) %></option>
									<%
											}
									  	}
									%>
								</select>
							</td>
						</tr>
						<tr>
							<td class="infoLabel">
							<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
								遞交日期
							<%} else { %>							
								Submit Date:
							<%} %>
							</td>
							<td class="infoData">
								<input type="textfield" name="subDate" id="subDate" class="datepickerfield" value="<%=subDate==null?"":subDate%>" maxlength="10" size="9" onkeyup="validDate(this)" onblur="validDate(this)">
							</td>
						</tr>
							<tr class="smallText">
							<td class="infoLabel" width="25%">
							<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
								確認
							<%} else { %>
								Confirm: 
							<%} %>
							</td>
							<td class="infoData" width="35%">
								<select id='confirmStatus' name="confirmStatus">
									<option value="">ALL</option>
									<option value="Y"<%="Y".equals(confirmStatus)?" selected":""%>>Yes</option>
									<option value="N"<%="N".equals(confirmStatus)?" selected":""%>>No</option>									
								</select>
							</td>
						</tr>
						
						<tr class="smallText">
							<td colspan="2" align="center">
								<button onclick="return submitSearch();">
									<bean:message key="button.search" />
								</button>
								<button onclick="return clearSearch();">
									<bean:message key="button.clear" />
								</button>
								<input type="hidden" name="command" />
							</td>
						</tr>
					</table>
					<input type="hidden" name="eID" value="">
					<input type="hidden" name="sID" value="">
					<input type="hidden" name="enID" value="">
					<input type="hidden" name="gID" value="">
					<input type="hidden" name="uID" value="">
				</form>
				
				<bean:define id="functionLabel"><bean:message key="function.xmas.enrollment.list.admin" /></bean:define>
				<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
				<display:table id="row" name="requestScope.enrollment_list_admin" export="true" pagesize="100" class="tablesorter">
					<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)
						<input type="hidden" name="enrollIDs" value="<%=((ReportableListObject) pageContext.getAttribute("row")).getFields3() %>" />
					</display:column>
					<display:column titleKey="prompt.staffID" style="width:5%" group="1">
					 <c:out value="${row.fields9}" />
					</display:column>
					<display:column titleKey="prompt.xmas.participant" style="width:12%">
						<logic:equal name="row" property="fields23" value="0">
							<c:out value="${row.fields10}" />
						</logic:equal>
						<logic:notEqual name="row" property="fields23" value="0">
							<c:out value="${row.fields21}" /> (<c:out value="${row.fields22}" />): <c:out value="${row.fields23}" />
						</logic:notEqual>
					</display:column>
					<display:column titleKey="prompt.xmas.hireDate" style="width:4%">
						<logic:equal name="row" property="fields23" value="0">
							<c:out value="${row.fields24}" />
						</logic:equal>
					</display:column>
					<display:column titleKey="prompt.department" style="width:6%">
						<logic:equal name="row" property="fields23" value="0">
							<c:out value="${row.fields12}" />
						</logic:equal>
					</display:column>
					<display:column titleKey="prompt.xmas.status" style="width:4%">
						<logic:equal name="row" property="fields23" value="0">
							<c:out value="${row.fields18}" />
						</logic:equal>
					</display:column>
					<display:column titleKey="prompt.groups" style="width:5%">
					<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
						<c:out value="${row.fields26}" />
					<%} else { %>
						<c:out value="${row.fields16}" />
					<%} %>
					</display:column>
					<display:column titleKey="prompt.xmas.table" style="width:3%">
						<c:out value="${row.fields20}" />
					</display:column>
					<%-- 
					<display:column title="Family Members" style="width:20%">
						<c:set var="tempEnrollID" value="${row.fields3}"/>
						<c:set var="tempScheduleID" value="${row.fields2}"/>
						<c:set var="tempStaffID" value="${row.fields9}"/>
<%						
	String tempEnrollID = (String)pageContext.getAttribute("tempEnrollID");
	String tempScheduleID = (String)pageContext.getAttribute("tempScheduleID") ;	
	String tempStaffID = (String)pageContext.getAttribute("tempStaffID") ;	
	
	String members = XmasGatheringDB.getEnrolledFamilyMembers(userBean, eventID, tempScheduleID, tempEnrollID, tempStaffID, true, true);
%>
						<%=members==null?"":members %>
					</display:column>
					--%>
					<display:column titleKey="prompt.xmas.price" style="width:5%">
						<logic:equal name="row" property="fields23" value="0">
							<c:set var="tempEnrollID" value="${row.fields3}"/>
							<c:set var="tempScheduleID" value="${row.fields2}"/>
							<c:set var="tempStaffID" value="${row.fields9}"/>
							<c:set var="tempGrpDesc" value="${row.fields16}"/>
<%						
	String tempEnrollID = (String)pageContext.getAttribute("tempEnrollID");
	String tempScheduleID = (String)pageContext.getAttribute("tempScheduleID") ;
	String tempStaffID = (String)pageContext.getAttribute("tempStaffID") ;
	String tempGrpDesc = (String)pageContext.getAttribute("tempGrpDesc") ;
	
	String participantPrice = XmasGatheringDB.getParticipantPrice(userBean, eventID, tempScheduleID, tempEnrollID, eventPrice, tempStaffID);
	int total = participantPrice!=null?Integer.parseInt(participantPrice):0;
	if (ConstantsServerSide.isTWAH()) {
		ArrayList result = StaffDB.get(tempStaffID);
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);	
			if (rlo.getValue(4).equals("CAS") && 
					(!tempGrpDesc.equals("Waiting") && !tempGrpDesc.equals("Cancel"))) {
				total += Integer.parseInt(eventPrice);
			}
		}
	}
	else {
		
	}
	%><%="HK$"+String.valueOf(total) %><%
%>						
						</logic:equal>
					</display:column>
					
					<display:column titleKey="prompt.submitdate" style="width:7%">
						<logic:equal name="row" property="fields23" value="0">
							<c:out value="${row.fields17}" />
						</logic:equal>
					</display:column>
<% if (ConstantsServerSide.isHKAH()) { %>	
					<display:column titleKey="prompt.xmas.mealtype" style="width:7%">
						<logic:equal name="row" property="fields25" value="vege">
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							素食者
						<%} else { %>
							Vegetarian
						<%} %>
						</logic:equal>
						<logic:equal name="row" property="fields25" value="non-vege">
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							非素食者
						<%} else { %>						
							Non-Vegetarian
						<%} %>							
						</logic:equal>
						<logic:equal name="row" property="fields25" value="N">
						</logic:equal>
					</display:column>
					
					<display:column title="Shuttle bus to Kornhill 穿梭巴士前往康山" style="width:7%">
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<logic:equal name="row" property="fields27" value="not-req">
								不乘坐
							</logic:equal>
							<logic:equal name="row" property="fields27" value="1815">
								18:15
							</logic:equal>
							<logic:equal name="row" property="fields27" value="1845">
								18:45
							</logic:equal>
						<%} else {%>		
							<logic:equal name="row" property="fields27" value="not-req">
								Not Required
							</logic:equal>
							<logic:equal name="row" property="fields27" value="1815">
								18:15
							</logic:equal>
							<logic:equal name="row" property="fields27" value="1845">
								18:45
							</logic:equal>
						<%} %>
					</display:column>

					<display:column title="Shuttle bus to Hospital 穿梭巴士前往醫院" style="width:7%">
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<logic:equal name="row" property="fields28" value="not-req">
								不乘坐
							</logic:equal>
							<logic:equal name="row" property="fields28" value="2145">
								21:45
							</logic:equal>
						<%} else {%>		
							<logic:equal name="row" property="fields28" value="not-req">
								Not Required
							</logic:equal>
							<logic:equal name="row" property="fields28" value="2145">
								21:45
							</logic:equal>
						<%} %>
					</display:column>

<% } %>						
					<display:column titleKey="prompt.xmas.comfirm" style="width:5%">
						<logic:equal name="row" property="fields23" value="0">
							<c:set var="tempConfirm" value="${row.fields15}"/>
							<c:set var="tempEnrollNo" value="${row.fields19}"/>
							<c:set var="tempStaffID" value="${row.fields9}"/>
							<c:set var="tempScheduleID" value="${row.fields2}"/>
<%
	String tempConfirm = (String)pageContext.getAttribute("tempConfirm");
	String tempEnrollNo = (String)pageContext.getAttribute("tempEnrollNo");
	String tempStaffID = (String)pageContext.getAttribute("tempStaffID") ;
	String tempScheduleID = (String)pageContext.getAttribute("tempScheduleID") ;
	String tempStaffStatus = "";
	
	if (ConstantsServerSide.isTWAH()) {
		ArrayList result = StaffDB.get(tempStaffID);
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);	
			tempStaffStatus = rlo.getValue(4);
		}
	}
	
	if ("confirm".equals(tempConfirm) ||
			("1".equals(tempEnrollNo) && tempStaffStatus.equals("CAS") &&(tempScheduleID.equals(groupWaitingID)||tempScheduleID.equals(groupCancelID))) ||
			("1".equals(tempEnrollNo) && !tempStaffStatus.equals("CAS"))){
%>
						<c:out value="Y" />
<%
	}else{
%>
						<button onclick="return confirmStaff('<c:out value="${row.fields0}" />','<c:out value="${row.fields2}" />','<c:out value="${row.fields3}" />','<c:out value="${row.fields9}" />','<c:out value="${row.fields10}" />');">
							Confirm?
						</button>
<%
	}
%>
						</logic:equal>
					</display:column>					
				<display:column titleKey="prompt.xmas.action" style="width:5%">
					<logic:equal name="row" property="fields23" value="0">
						<c:set var="tempScheduleID" value="${row.fields2}"/>
<%
	String tempScheduleID = (String)pageContext.getAttribute("tempScheduleID") ;
	if(!tempScheduleID.equals(groupWaitingID)&&!tempScheduleID.equals(groupCancelID)){
%>
					<button onclick="return enrolltAction('withdraw','<c:out value="${row.fields0}" />','<c:out value="${row.fields2}" />','<c:out value="${row.fields3}" />','<c:out value="${row.fields9}" />','<c:out value="${row.fields10}" />');"><bean:message key='button.withdraw' /></button>
<%
	}
%>	
					</logic:equal>
				</display:column>
					<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
				</display:table>
				
				<script language="javascript">
					function submitSearch() {
						if(document.searchForm.subDate.value){
							 if (!validDate(document.searchForm.subDate)) {
								 alert("Error in Submit Date format");
								 return false;
							 }
						}
						document.searchForm.command.value = 'search';
						document.searchForm.submit();
					}
					
					function confirmStaff(eID,sID,enID,uID,uName){		
					   var confirmStaff = confirm("Confirm Staff - "+$.trim(uName)+" ("+uID+")?");
					   if( confirmStaff == true ){	
							document.searchForm.eID.value=eID;
							document.searchForm.sID.value=sID;
							document.searchForm.enID.value=enID;
							document.searchForm.command.value='confirm';
							document.searchForm.submit();
					   }
					}
					
					function clearSearch() {
						$('input[name=staffID]').val('');						
						$('select#staffStatus :nth-child(1)').attr('selected', 'selected');
						$('select#scheduleID :nth-child(1)').attr('selected', 'selected');
						$('input[name=subDate]').val('');				
						$('select#confirmStatus :nth-child(1)').attr('selected', 'selected');
					}
					
					function enrolltAction(command, eID,gID,enID,uID,uName) {	
						var confirmStaff = confirm("Withdrew Staff - "+$.trim(uName)+" ("+uID+")?");
						   if( confirmStaff == true ){	
						$('input[name=command]').val('initAction');
						document.searchForm.eID.value=eID;
						document.searchForm.gID.value=gID;
						document.searchForm.enID.value=enID;
						document.searchForm.uID.value=uID;
						document.searchForm.submit();
						   }
					}
				</script>
			</div>
		</div>
	</body>
</html:html>
