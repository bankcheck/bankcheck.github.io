<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.config.MessageResources"%>
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

boolean isAllow = true;
if(ConstantsServerSide.isHKAH()) {
	isAllow = XmasGatheringDB.isAllow(userBean.getStaffID()) || XmasGatheringDB.isAllowSpecial(userBean.getStaffID());
}else if(ConstantsServerSide.isTWAH()) {
	isAllow = true;
}

String command = request.getParameter("command");
String eventID = request.getParameter("eventID");
String scheduleID = request.getParameter("scheduleID");
ArrayList fmType = XmasGatheringDB.getFamilyType();
Map enrollMap = null;
Map enrollNameMap = null;
String price = XmasGatheringDB.getPrice(eventID);
Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);
boolean isCA = false;
Calendar curCal = Calendar.getInstance();
Calendar regDeadlineCal = Calendar.getInstance();

if (ConstantsServerSide.isHKAH()) {
	regDeadlineCal.set(Calendar.MONTH, 10);	// keep 10 (Nov)
	regDeadlineCal.set(Calendar.DATE, 26);	// change day from 28 to 26
	regDeadlineCal.set(Calendar.HOUR_OF_DAY, 17);	// keep 17:29:59
	regDeadlineCal.set(Calendar.MINUTE, 29);		// keep 29
	regDeadlineCal.set(Calendar.SECOND, 59);		// keep 59, regDeadlineCal control showing confirmation.jsp or registration.jsp; control hideXmasLink or not  
} else {
	regDeadlineCal.set(Calendar.MONTH, 10);	// 10 (Nov)
	regDeadlineCal.set(Calendar.DATE, 29);	// keep 29
	regDeadlineCal.set(Calendar.HOUR_OF_DAY, 23);	// keep 23:59:59
	regDeadlineCal.set(Calendar.MINUTE, 59);		// keep 59
	regDeadlineCal.set(Calendar.SECOND, 59);		// keep 59
}
regDeadlineCal.set(Calendar.YEAR, 2019);

if (isAllow) {
	request.setAttribute("party_group", 
			ScheduleDB.getListByTime("christmas",eventID, null, scheduleID, null, 
										null, null, null, true));
	enrollMap = XmasGatheringDB.getEnrolledFamily(userBean, eventID, 
									scheduleID,"count");
	enrollNameMap = XmasGatheringDB.getEnrolledFamily(userBean, eventID, 
			scheduleID,"name");
}
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
	<jsp:include page="../common/header.jsp"/>
	<style>
		.header {
			font-weight:bold;
		}
	</style>
	<body>
		<div id=indexWrapper>
			<div id=mainFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.xmas.register" />
					<jsp:param name="category" value="group.xams" />
					<jsp:param name="accessControl" value="N"/>
				</jsp:include>
<%if (isAllow) { %>
				<bean:define id="functionLabel"><bean:message key="function.xmas.enrollment" /></bean:define>
				<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
				
				<display:table id="row" name="requestScope.party_group" export="true" pagesize="30" class="tablesorter">
					<display:column title="&nbsp;" media="html" style="width:5%">
						<%=pageContext.getAttribute("row_rowNum")%>)
					</display:column>
					<display:column titleKey="prompt.xmas.group" style="width:15%">
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
 								<c:out value="${row.fields22}" />
							<%} else { %>
								<c:out value="${row.fields4}" />
							<%} %>						
					</display:column>
					<display:column title="Table No." style="width:10%" media="pdf">
						<c:out value="${row.fields18}" />
					</display:column>
					<display:column titleKey="prompt.available" style="width:10%">
						<logic:equal name="row" property="fields13" value="0">
							<c:out value="${row.fields14}" /> <bean:message key="label.enrolled" />
						</logic:equal>
						<logic:notEqual name="row" property="fields13" value="0">
							<c:out value="${row.fields15}" />/<c:out value="${row.fields13}" />
						</logic:notEqual>
						&nbsp;
						<logic:equal name="row" property="fields15" value="0">
							&nbsp;&nbsp;<img src="../images/full.gif"/>
						</logic:equal>
					</display:column>
					<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
				</display:table>
				
				<table cellpadding="0" cellspacing="5" class="contentFrameSearch" 
						border="0" style="width:98%;font-size:15px;">
					<tr>
						<td style='border-style:outset; border-width:1px;background-color:#E0E0E0;width:15%'>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<label class="header">參加者</label>
						<%} else { %>
							<label class="header">Participant</label>
						<%} %>
						</td>
						<td style='border-style:outset; border-width:1px;background-color:#E0E0E0;width:25%'>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<label class="header">員工姓名</label>
						<%} else { %>						
							<label class="header">Name</label>
						<%} %>
						</td>
						<td style='border-style:outset; border-width:1px;background-color:#E0E0E0;width:7%'>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<label class="header">折扣</label>
						<%} else { %>
							<label class="header">Discount</label>
						<%} %>
						</td>
						<td style='border-style:outset; border-width:1px;background-color:#E0E0E0;width:7%'>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<label class="header">價錢</label>
						<%} else { %>													
							<label class="header">Price</label>
						<%} %>
						</td>
						<td style='border-style:outset; border-width:1px;background-color:#E0E0E0;width:5%'>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<label class="header">人數</label>
						<%} else { %>
							<label class="header">Number</label>
						<%} %>
						</td>
<% if(ConstantsServerSide.isHKAH()){ %>						
						<td style='border-style:outset; border-width:1px;background-color:#E0E0E0;width:12%'>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<label class="header">膳食類型</label>
						<%} else { %>
							<label class="header">Meal</label>
						<%} %>
						</td>
						<td style='border-style:outset; border-width:1px;background-color:#E0E0E0;'>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<label class="header">穿梭巴士前往康山</label>
						<%} else { %>
							<label class="header">Shuttle bus to Kornhill</label>
						<%} %>
						</td>
						</td>
						<td style='border-style:outset; border-width:1px;background-color:#E0E0E0;'>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<label class="header">穿梭巴士前往醫院</label>
						<%} else { %>
							<label class="header">Shuttle bus to Hospital</label>
						<%} %>
						</td>
<% } %>						
					</tr>
					<tr>
						<td>Staff</td>
						<td><%=StaffDB.getStaffFullName2(userBean.getStaffID()) %></td>
					<%if (ConstantsServerSide.isTWAH()) {  
						ArrayList result = StaffDB.get(userBean.getStaffID());
						if (result.size() > 0) {
							ReportableListObject rlo = (ReportableListObject) result.get(0);	
							if (rlo.getValue(4).equals("CAS")) {
								isCA = true;
								%>
									<td>Full fee</td>
									<td>HK$<%=price %></td>
								<%
							}
							else {
							%>
								<td>Free</td>
								<td>HK$0</td>
							<%
							}
						}
						else {
						%>
							<td>Free</td>
							<td>HK$0</td>
						<%
						}
					%>
					<%} else { 
					%>
						<td>Free</td>
						<td>HK$0</td>
					<%} %>
						<td>1</td>
<% if(ConstantsServerSide.isHKAH()){ %>						
						<td>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<input class="input_participant_meal" type="radio" name="staffMealType" value="non-vege" checked> 非素食者<br>
  							<input type="radio" name="staffMealType" value="vege"> 素食者<br>
						<%} else { %>
							<input class="input_participant_meal" type="radio" name="staffMealType" value="non-vege" checked> Non-vegetarian<br>
  							<input type="radio" name="staffMealType" value="vege"> Vegetarian<br>
  						<%} %>
						</td>
						<td>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<input class="input_bus_to_restaurant" type="radio" name="busToRestType" value="not-req" checked> 不乘坐<br>
  							<input type="radio" name="busToRestType" value="1815"> 18:15<br>
  							<input type="radio" name="busToRestType" value="1845"> 18:45<br>
						<%} else { %>
							<input class="input_bus_to_restaurant" type="radio" name="busToRestType" value="not-req" checked> Not Required<br>
  							<input type="radio" name="busToRestType" value="1815"> 18:15<br>
  							<input type="radio" name="busToRestType" value="1845"> 18:45<br>
  						<%} %>
						</td>
						<td>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
							<input class="input_bus_to_hospital" type="radio" name="busToHospType" value="not-req" checked> 不乘坐<br>
  							<input type="radio" name="busToHospType" value="2145"> 21:45<br>
						<%} else { %>
							<input class="input_bus_to_hospital" type="radio" name="busToHospType" value="not-req" checked> Not Required<br>
  							<input type="radio" name="busToHospType" value="2145"> 21:45<br>
  						<%} %>
						</td>
<% } %>					
					<%
					for (int i = 0; i < fmType.size(); i++) {	
						ReportableListObject row = (ReportableListObject) fmType.get(i);
						boolean noPrice = false;
						try {
							Integer.parseInt(price);
						}
						catch (Exception e) {
							noPrice = true;
						}
						%>	<tr <%=(ConstantsServerSide.isTWAH())?"style='visibility: hidden;'":"" %>>
								<td><%=row.getValue(1) %> <%=row.getValue(4).equals("0")?"(No Seat)":"" %></td>
								<td>
									<input fmtypeid="<%=row.getValue(0) %>" 
										 class="input_participant_name" 									 
										value="<%=enrollNameMap.get(row.getValue(0))%>" style="width:100%;"/>
								</td>
								<%if (isCA) {
									%>
									<td><%=row.getValue(4).equals("0")?row.getValue(3):"Full Free" %></td>
									<td>HK$<%=row.getValue(4).equals("0")?"0":price %></td>
									<td>
										<input price="<%=price %>" fmtypeid="<%=row.getValue(0) %>" 
											fmdiscount="<%=row.getValue(4).equals("0")?"0":"100" %>" class="input_participant" 
											seat="<%=row.getValue(4) %>" 
											value="<%=enrollMap.get(row.getValue(0))%>"/>
									</td>
								<%
								}
								else {
								%>
									<td><%=row.getValue(3) %></td>
									<td>HK$<%=noPrice?"":((Integer.parseInt(row.getValue(2))*Integer.parseInt(price))/100) %></td>
									<td>
										<input price="<%=price %>" fmtypeid="<%=row.getValue(0) %>" 
											fmdiscount="<%=row.getValue(2) %>" class="input_participant" 
											seat="<%=row.getValue(4) %>" 
											value="<%=enrollMap.get(row.getValue(0))%>"/>
									</td>
								<%} %>
<% if(ConstantsServerSide.isHKAH()){ %>								
								<td>
									<input fmtypeid="<%=row.getValue(0) %>" type="radio" name="mealType<%=row.getValue(0) %>" value="non-vege" checked> Non-vegetarian<br>
		  							<input type="radio" name="mealType<%=row.getValue(0) %>" value="vege"> Vegetarian<br>
								</td>							
<% } %>
							</tr>
					<%} %>	
					<tr><td>&nbsp;</td></tr>
					<!-- 
					<tr>
						<td></td>
						<td></td>
						<td align="left">
							<label class="header">Total participants:</label>
						</td>
						<td>
							<label id="total_participant">
							</label>
						</td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td align="left">
							<label class="header">Total price:</label>
						</td>
						<td>
							<label id="total_price">
							</label>
						</td>
					</tr>
					 -->	
					<tr>
						<td align="center" colspan="4">
							<button onclick="submit()">
								<bean:message key="button.submit" />
							</button>
						</td>
					</tr>
				</table>
				<input type="hidden" name="command" value="<%=command %>"/>
				<input type="hidden" name="isAllow" value="<%=isAllow%>"/>
				<input type="hidden" name="eventID" value="<%=eventID%>"/>
				<input type="hidden" name="scheduleID" value="<%=scheduleID%>"/>
				<input type="hidden" name="isCA" value="<%=isCA%>"/>
				<input type="hidden" name="price" value="<%=price%>"/>
<%} %>
			</div>
		</div>
		<script>
			$(document).ready(function() {
				inputEvent();
				
				if($('input[name=isAllow]').val() == "false") {
					$('body').html('');
					alert('You are not eligible to join.');
					window.open('','_self','');
					window.close();
				}
			});
			
			function submit() {
				showOverLay('body');
				showLoadingBox('body', 500);
				
				var command  = $('input[name=command]').val();
				var eventID = $('input[name=eventID]').val();
				var scheduleID = $('input[name=scheduleID]').val();
<% if(ConstantsServerSide.isHKAH()){ %>					
				var staffMealType = $('input[name=staffMealType]:checked').val();
				var busToRestType = $('input[name=busToRestType]:checked').val();
				var busToHospType = $('input[name=busToHospType]:checked').val();
<% } else { %>
				var staffMealType = "";
				var busToRestType = "";
				var busToHospType = "";
<% } %>
				var param = "";
				var total = 1;
				var paramName = "";
				var success = true;

				// 2019/11/20
				<%if (curCal.after(regDeadlineCal)) {%>
					alert("No Submit after Deadline!");
					success = false;
					//return false;
				<%}%>

				$.each($('.input_participant'), function(i, v) {
						var vNo = parseInt($(v).val());
						if (vNo != "NaN" && vNo > 0) {
							var name = $.trim($(v).parent().parent().find('.input_participant_name').val());
							if (name.length <= 0) {
								alert("Please Input Name(s) of "+$(v).parent().parent().find('td:first').html());
								success = false;
								return false;
							}
							param += "&familyType"+$(v).attr('fmtypeid')+"="+vNo;
							if ($(v).attr('seat') != "0") {
								total += vNo;
							}
						}
					});
				
				if (!success) {
					hideLoadingBox('body', 500);
					hideOverLay('body');
					return;
				}
				
				$.each($('.input_participant_name'), function(i, v) {
					var vNames = $(v).val();
					if (vNames) {
						paramName += "&familyNames"+$(v).attr('fmtypeid')+"="+vNames;
<% if(ConstantsServerSide.isHKAH()){ %>						
						var mealType = $('input[name=mealType' + $(v).attr('fmtypeid') + ']:checked').val();
						paramName += "&mealType"+$(v).attr('fmtypeid')+"="+mealType;
<% } %>						
					}
				});
								
				$.ajax({
					type: "GET",
					url: "enroll_process.jsp?command="+command+"&eventID="+eventID+
							"&scheduleID="+scheduleID+"&totalParticipant="+total+"&staffMealType="+staffMealType+"&busToRestType="+busToRestType+"&busToHospType="+busToHospType+
							param+paramName,
					async: false,
					cache: false,
					success: function(values){
						var result = $.trim(values);
						if (result == "true") {
							window.open("../xmas/registration.jsp?command=completeAction", "_self");
							return;
						}
						else {
							alert("Not Successful!");
							location.reload(true);
							return;
						}
							
						hideLoadingBox('body', 500);
						hideOverLay('body');
					},//success
					error: function(jqXHR, textStatus, errorThrown) {
						hideLoadingBox('body', 500);
						hideOverLay('body');
						alert('Error in "submit"');
					}
				});//$.ajax
				
			}
			
			function inputEvent() {
				$('.input_participant').change(function() {
					var value = $(this).val();
					
					if (parseInt(value) != "NaN") { }
					else {
						$(this).val(0);
						alert("Please input a number.");
						return;
					}
					
					if (value.length == 0) {
						$(this).val(0);
					}

					var totalParticipant = 0;
					var totalPrice = 0;
					$.each($('.input_participant'), function(i, v) {
						var count = $(v).val();
						if (parseInt(count) != "NaN") {
							totalParticipant += parseInt(count);
							count = parseInt(count);
						}
						else {
							totalParticipant += 0;
							count = 0;
						}
						
						totalPrice += count * parseInt((parseInt($(v).attr('fmdiscount')) * 
										parseInt($(v).attr('price'))) / 100);
					});
					
					totalPrice = parseInt(totalPrice);
					if ($('input[name=isCA]').val()=='true') {
						totalPrice+=parseInt($('input[name=price]').val());
					}
					
					$('#total_participant').html(totalParticipant+1);
					$('#total_price').html("HK$"+totalPrice);
				}).trigger('change');
			}
		</script>
	</body>
</html:html>