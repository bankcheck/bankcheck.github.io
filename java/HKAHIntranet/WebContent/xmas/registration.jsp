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

String scheduleStartDate = null;
String scheduleEndDate = null;
String groupSize = null;
String eventPrice = null;
String groupWaitingID = null;
String groupCancelID = null;
boolean isAllow = true;
String eventID = XmasGatheringDB.getEventIDByCurrentYear();
String confirmDate = "4 December 2017";
String eventDate = XmasGatheringDB.getCurrentEventDate(true);
String join = null;
String groupID = null;
String groupDesc = null;
String enrollID = null;
String message = null;
String errorMessage = null;
String makeRequest = "N";
String participantPrice = null;
String members = null;
int showTable = 35;
String command = request.getParameter("command");
String enrollNo = null;
String confirm = null;
Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);
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

ArrayList groupInfoRecord = XmasGatheringDB.getGroupInfo(eventID);
if(groupInfoRecord.size()>0){
	ReportableListObject groupInfoRow =
								(ReportableListObject) groupInfoRecord.get(0);
	scheduleStartDate = groupInfoRow.getValue(2);
	scheduleEndDate = groupInfoRow.getValue(3);
	groupSize = groupInfoRow.getValue(4);
	eventPrice = groupInfoRow.getValue(5);
}

if(ConstantsServerSide.isHKAH()) {
	isAllow = XmasGatheringDB.isAllow(userBean.getStaffID()) || XmasGatheringDB.isAllowSpecial(userBean.getStaffID());
}else if(ConstantsServerSide.isTWAH()) {
	isAllow = true;
}
if (isAllow) {
	ArrayList enrollRecord = EnrollmentDB.getEnrolledClass("christmas", eventID, null,
										null, userBean.getStaffID(), null, null,
										null, null);
	if(enrollRecord.size() > 0) {
		ReportableListObject row = (ReportableListObject) enrollRecord.get(0);
		if(row.getValue(2).equals(groupCancelID)) {
			join = "N";
		}
		else if(row.getValue(2).length() > 0){
			join = "Y";
		}
		enrollID = row.getValue(3);
		eventID = row.getValue(0);
		groupID = row.getValue(2);
		groupDesc = row.getValue(16);
		enrollNo = row.getValue(19);
		confirm = row.getValue(15);

		participantPrice = XmasGatheringDB.getParticipantPrice(userBean, eventID, groupID, enrollID, eventPrice, userBean.getStaffID());
		members = XmasGatheringDB.getEnrolledFamilyMembers(userBean, eventID, groupID, enrollID, userBean.getStaffID(), true, true);
	}

	if (command != null) {
		if (command.equals("initAction")) {
			String reqGrpID = request.getParameter("reqGrpID");
			makeRequest = "Y";
			if (groupID != null && !reqGrpID.equals(groupID)) {
				if (XmasGatheringDB.withdraw(userBean, eventID, groupID,
						enrollID, userBean.getStaffID()) == 0) {
					int result = XmasGatheringDB.enroll(userBean, eventID,
											reqGrpID, "1", userBean.getStaffID());

					if(result == 0) {
						message = "Participated.";
					}
					else if(result == 1) {
						errorMessage = "Enrolled.";
					}
					else {
						errorMessage = "Fail to participate.";
					}
				}
				else {
					errorMessage = "Fail to participate.";
				}
			}
			else if (groupID == null || groupID.length() > 0) {
				int result = XmasGatheringDB.enroll(userBean, eventID,
											reqGrpID, "1", userBean.getStaffID());

				if(result == 0) {
					message = "Participated.";
				}
				else if(result == 1) {
					errorMessage = "Enrolled.";
				}
				else {
					errorMessage = "Fail to participate.";
				}
			}
		}
		else if (command.equals("completeAction")) {
			makeRequest = "Y";
		}

		enrollRecord = EnrollmentDB.getEnrolledClass("christmas", eventID, null,
									null, userBean.getStaffID(), null, null,
									null, null);
		if(enrollRecord.size() > 0) {
			ReportableListObject row = (ReportableListObject) enrollRecord.get(0);
			if(row.getValue(2).equals(groupCancelID)) {
				join = "N";
			}
			else if(row.getValue(2).length() > 0){
				join = "Y";
			}
			enrollID = row.getValue(3);
			eventID = row.getValue(0);
			groupID = row.getValue(2);
			groupDesc = row.getValue(16);
			enrollNo = row.getValue(19);
			confirm = row.getValue(15);

			participantPrice = XmasGatheringDB.getParticipantPrice(userBean, eventID, groupID, enrollID, eventPrice, userBean.getStaffID());
			members = XmasGatheringDB.getEnrolledFamilyMembers(userBean, eventID, groupID, enrollID, userBean.getStaffID(), true, true);
		}
	}
	else {

	}

	ArrayList totalEventToShow = ScheduleDB.getListByDate("christmas",eventID, null, "other", "party", null, null, true, 99);
	while(showTable < totalEventToShow.size() && ConstantsServerSide.isHKAH()) {
		totalEventToShow.remove(showTable);
	}
	request.setAttribute("party_group_list", totalEventToShow);
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
		li {
			line-height:30px;
		}
	</style>
	<body>
		<![if !IE]>
		<table id="warning-box" width="100%" height="20" border="0">
			<tr class="warning">
				<td>
		This intranet portal is best viewed with Internet Explorer. Document links may NOT work properly in other browsers.
				</td>
				<td><a href="javascript:void(0);" onclick="closeWarning()"><img src="<html:rewrite page="/images/remove-button.gif" />" /></a></td>
			</tr>
		</table>
		<script language="javascript">
			function closeWarning() {
				$('#warning-box').hide('slow');
			}
		</script>
		<![endif]>
		<div id=indexWrapper>
			<div id=mainFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.xmas.register" />
					<jsp:param name="category" value="group.xams" />
					<jsp:param name="accessControl" value="N"/>
				</jsp:include>
				<form name="xmasRegForm" action="registration.jsp" method="post">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" style="width:98%">
						<%if(ConstantsServerSide.isHKAH()) { %>
							<%
							if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {
							%>							
							<tr class="smallText">
								<td class="infoLabel" width="25%">
									員工編號 :
								</td>
								<td class="infoData" width="75%">
									<%=userBean.getStaffID() %>
								</td>
							</tr>
							<tr class="smallText">
								<td class="infoLabel" width="25%">
									員工姓名:
								</td>
								<td class="infoData" width="75%">
									<%=userBean.getUserName() %>
								</td>
							</tr>
							<tr>
								<td class="infoLabel" width="25%">
									部門:
								</td>
								<td class="infoData" width="75%">
									<%=userBean.getDeptDesc() %>
								</td>
							</tr>
							<%} else { %>
								<tr class="smallText">
								<td class="infoLabel" width="25%">
									Staff No:
								</td>
								<td class="infoData" width="75%">
									<%=userBean.getStaffID() %>
								</td>
							</tr>
							<tr class="smallText">
								<td class="infoLabel" width="25%">
									Staff Name:
								</td>
								<td class="infoData" width="75%">
									<%=userBean.getUserName() %>
								</td>
							</tr>
							<tr>
								<td class="infoLabel" width="25%">
									Department:
								</td>
								<td class="infoData" width="75%">
									<%=userBean.getDeptDesc() %>
								</td>
							</tr>							
							<%} %>
						<%} else { %>				
							<tr class="smallText">
								<td class="infoLabel" width="25%">
									Staff No:
								</td>
								<td class="infoData" width="75%">
									<%=userBean.getStaffID() %>
								</td>
							</tr>
							<tr class="smallText">
								<td class="infoLabel" width="25%">
									Staff Name:
								</td>
								<td class="infoData" width="75%">
									<%=userBean.getUserName() %>
								</td>
							</tr>
							<tr>
								<td class="infoLabel" width="25%">
									Department:
								</td>
								<td class="infoData" width="75%">
									<%=userBean.getDeptDesc() %>
								</td>
							</tr>
						<%} %>
						<%if(ConstantsServerSide.isHKAH()) { %>
						<%
						if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {
						%>
						<tr>
							<td colspan="2">
								<table style="font-size:16px">
									<tr>
										<td>
											日期:
										</td>
										<td>
											2019年12月12日（星期四）
										</td>
									</tr>
									<tr>
										<td>
											時間:
										</td>
										<td>
											晚上6時45分
										</td>
									</tr>
									<tr>
										<td>
											地點:
										</td>
										<td>
											會所1號時尚康山
										</td>
									</tr>
									<tr>
										<td>
											地址:
										</td>
										<td>
											香港太古康山道2號康蘭居201號   
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td colspan="2">
											<b><u>條款及細則 :</u></b>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<ul style="list-style-type:none;">		<!--prev is list-style-type:disc;-->
												<li>
													● 如您已報名出席週年晚會，並於截止日期前沒有撤回申請，但缺席活動，須繳付港幣$400（每位成本價）。
												</li>
												<li>● 
													<u>如欲參與，請選擇進入其中一個組別。每組最多人數為十二人。為善用座位，您所選的座位有機會被重新安排。人力資料部將保留對所有座位安排的最終決定權。</u>
												</li>
												<!-- 
												<li>
													● <bean:message key="prompt.xmas.remark3"/>
												</li>
												 -->
												<li>
													● <b>
														報名時段由<u>2019年11月11日至2019年11月26日</u>。2019年11月26日下午5時半以後，將不能作任何更改。 
													  </b>
												</li>
												<li>
													 ● 報名確認通知將於<u>2019年12月4日上午9時</u>公佈。屆時，請登入內聯網查看您的報名情況及您的座位安排。 
												</li>
												<!--
												
												<li>
													● <bean:message key="prompt.xmas.remark7"/>
												</li>
												<li>
													● <bean:message key="prompt.xmas.remark8"/>
												</li>
												<li>
													● <bean:message key="prompt.xmas.remark9"/>
												</li>
												-->
												
												<!-- 
												<li>
													● Cost to attend party:
													<table>
														<tr>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>
																○ Eligible staff -
															</td>
															<td>
																Free
															</td>
														</tr>
														<tr>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>
																○  Children below 3 years old -
															</td>
															<td>
																Free
															</td>
														</tr>
														<tr>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>
																○ Children from 3 to 12 years old  -
															</td>
															<td>
																25% or HK$100 per participant
															</td>
														</tr>
														<tr>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>
																○  Children over 12 years old / Spouse -
															</td>
															<td>
																50% or HK$200 per participant
															</td>
														</tr>
													</table>
												</li>
												 -->
												 <!-- 
												<li>
													●  After you register family members, please proceed to HR office <b>immediately</b> to pay the fee to confirm desired seats.
												</li>
												<li>
													●  There will be no refund under any circumstances
												</li>
												<li>
													●  <b>HR office reserves the right to make the final decision on all seating and table arrangements.</b>
												</li>
												<li>
													●  <b><i>Please proceed to HR office immediately to pay if you wish to confirm your group number. If payment is not made within 48 hours, the family booking will be automatically cancelled.</i></b>
												</li>
												 -->
											</ul>
										</td>
									</tr>
								</table>
							</td>
						</tr>						
						<%
						} else {
						%>
							<tr>
							<td colspan="2">
								<table style="font-size:16px">
									<tr>
										<td>
											Date:
										</td>
										<td>
											<%=eventDate %>
										</td>
									</tr>
									<tr>
										<td>
											Time:
										</td>
										<td>
											<%-- 
											<bean:message key="prompt.xmas.time" />
											--%>
											6:45 p.m
										</td>
									</tr>
									<tr>
										<td>
											Venue:
										</td>
										<td>
											ClubONE Kornhill in Vogue
										</td>
									</tr>
									<tr>
										<td>
											Address:
										</td>
										<td>
											201 Kornhill Apartment, 2 Kornhill Road, Taikoo 香港太古康山道2號康蘭居201號 
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td colspan="2">
											<b><u><bean:message key="prompt.xmas.remark.heading"/></u></b>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<ul style="list-style-type:none;">		<!--prev is list-style-type:disc;-->
												<li>
													● If you have registered and have not withdrawn your registration before the closing date and <u>do not show up</u> at the Party, a fine of HK400 (cost per person) will be made payable. 
												</li>
												<li>● 
													<b><u>To participate, you must join a group. Each group will take up to 12 persons ONLY. However, due to seating maximization, your preferred seating group may be changed. HR office reserves the right to make the final decision on all seating and table arrangements.</u></b> 
												</li>
												<!-- 
												<li>
													● <bean:message key="prompt.xmas.remark3"/>
												</li>
												 -->
												<li>
													<b>
													● Registration period is from <u>11/11/2019 to 26/11/2019</u>. No changes can be made after 5:30pm on 26/11/2019. 
													  </b>
												</li>
												<li>
													● Confirmation of registration will be released <u>at 9:00 a.m. on 4 December 2019</u>. Please login to check your registration and your assigned table. 
												</li>
												<!--
												
												<li>
													● <bean:message key="prompt.xmas.remark7"/>
												</li>
												<li>
													● <bean:message key="prompt.xmas.remark8"/>
												</li>
												<li>
													● <bean:message key="prompt.xmas.remark9"/>
												</li>
												-->
												
												<!-- 
												<li>
													● Cost to attend party:
													<table>
														<tr>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>
																○ Eligible staff -
															</td>
															<td>
																Free
															</td>
														</tr>
														<tr>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>
																○  Children below 3 years old -
															</td>
															<td>
																Free
															</td>
														</tr>
														<tr>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>
																○ Children from 3 to 12 years old  -
															</td>
															<td>
																25% or HK$100 per participant
															</td>
														</tr>
														<tr>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>&nbsp;</td><td>&nbsp;</td>
															<td>
																○  Children over 12 years old / Spouse -
															</td>
															<td>
																50% or HK$200 per participant
															</td>
														</tr>
													</table>
												</li>
												 -->
												 <!-- 
												<li>
													●  After you register family members, please proceed to HR office <b>immediately</b> to pay the fee to confirm desired seats.
												</li>
												<li>
													●  There will be no refund under any circumstances
												</li>
												<li>
													●  <b>HR office reserves the right to make the final decision on all seating and table arrangements.</b>
												</li>
												<li>
													●  <b><i>Please proceed to HR office immediately to pay if you wish to confirm your group number. If payment is not made within 48 hours, the family booking will be automatically cancelled.</i></b>
												</li>
												 -->
											</ul>
										</td>
									</tr>
								</table>
							</td>
						</tr>						
						<%
						}
						%>
						<%}else if(ConstantsServerSide.isTWAH()) { %>
						<tr>
							<td colspan="2">
								<table style="font-size:16px" border=0>
									<tr>
										<td colspan="2">
											<label style="font-size:22px"><b>2019員工週年晚會</b></label>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td>
											日期：
										</td>
										<td>
											2019年12月18日(星期三)
										</td>
									</tr>
									<tr>
										<td>
											時間：
										</td>
										<td>
											晚上6：30 - 9：30
										</td>
									</tr>
									<tr>
										<td valign="top">
											地點：
										</td>
										<td>
											香港悅來酒店 (熊貓酒店)<br/>
											五樓宴會廳	  										
										</td>
									</tr>
									<tr>
										<td>
											參加者：
										</td>
										<td>
											本院員工(全職/半職)
										</td>
									</tr>
									<tr>
										<td>
											節目：
										</td>
										<td>
											豐富晚餐，天才表演大比拼及抽獎
										</td>
									</tr>
									<!--<tr>
										<td>
											費用：
										</td>
										<td>
											全免
										</td>
									</tr>-->
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td  colspan="2">
										合資格抽獎員工：</br>
	 									A. 受僱滿3個月</br>
	 									B. 出席週年晚會或當值員工(P Shift) 									
										</td>									
									</tr>
								</table>									
								<table style="font-size:16px" border=0>	
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td colspan="2">
											<u><b>截止報名日期：2019年11月29日(星期五) </b></u> 
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td colspan="2">
											員工需使用本院內聯網內的電子報名系統報名及自行編排座位。
										</td>
									</tr>	
									<tr>
										<td>
										    (如人數未夠12位的圍數將會安排其他同事同坐一席)
										</td>
									</tr>
									<tr>
										<td>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										</td>
										<td>										
										</td>
									</tr>
									<tr>
										<td>
										報名頁面上所顯示的枱號並不等於週年晚會當晚的枱號， 當晚的枱號會於截止後公佈 。
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<%} %>
						<tr class="smallText">
							<td class="infoLabel" width="25%">
								<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>狀態:<%} else {%>Status:<%} %>								
							</td>
							<td class="infoData" width="35%">
								<%if(isAllow) {
									if(!"1".equals(enrollNo)&&"confirm".equals(confirm)){%>
										Participate
									<%}else{ %>									
									<%--
									<%if ("0".equals(eat_1) || "".equals(eat_1)) {%>checked<%} %>
									 --%>
									<input name="join" type="radio" value="Y" <%=(join != null)?(join.equals("Y")?"checked":""):"" %>/><label><b><%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>參與<%} else {%>Participate<%} %></b></label>
				  					<input name="join" type="radio" value="N" <%=(join != null)?(join.equals("N")?"checked":""):"" %>/><label><b><%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>不參與<%} else {%>Not Participate<%} %></b></label>
									<%}
									}else { %>
									You are not eligible to join. 1
								<%} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="25%">
								<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>組別:<%} else {%>Group:<%} %>
							</td>
							<td class="infoData" width="35%">
								<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
									<%=(groupDesc == null || (groupID != null && groupID.equals(groupWaitingID)) || (groupID != null && groupID.equals(groupCancelID)))?"":"組別" + groupDesc.substring(groupDesc.indexOf(" ")) %>
								<%} else {%>								
									<%=(groupDesc == null || (groupID != null && groupID.equals(groupWaitingID)) || (groupID != null && groupID.equals(groupCancelID)))?"":groupDesc%>
								<%} %>	
							</td>
						</tr>
						<tr class="smallText">
							<!-- 
							<td class="infoLabel" width="25%">
								Family Members:
							</td>
							 -->
							 <!-- 
							<td class="infoData" width="35%">
								<%=members==null?"":members %>
							</td>
							 -->
						</tr>
						<!-- 
						<tr class="smallText">
							<td class="infoLabel" width="25%">
								Cost:
							</td>
							<td class="infoData" width="35%">
								<div id="cost">
									<%
										int total = participantPrice != null?Integer.parseInt(participantPrice):0;
										if (ConstantsServerSide.isHKAH()) {
											%><%=participantPrice == null?"":"HK$"+participantPrice  %>&nbsp;&nbsp;<%
										}
										else {
											ArrayList result = StaffDB.get(userBean.getStaffID());
											if (result.size() > 0) {
												ReportableListObject rlo = (ReportableListObject) result.get(0);	
												if (rlo.getValue(4).equals("CAS") && 
														(groupDesc != null && !groupDesc.equals("Waiting") && !groupDesc.equals("Cancel"))) {
													total += Integer.parseInt(eventPrice);
												}
											}
											%><%=total == 0?"":"HK$"+total  %>&nbsp;&nbsp;<%
										}
									%>
									
									<%if (ConstantsServerSide.isHKAH()) { %>
									<b><i> Please proceed to HR office immediately to pay if you wish to confirm your group number. If payment is not made within 48 hours, the family booking will be automatically cancelled.
									</i></b>
									<%} else { %>
										<%if (total > 0) { %>
											<b>請列印  <a href="payment.jsp" target="_blank">Invoice</a> 並於2014年12月5日或之前於病人事務部繳交有關款項。</b>
										<%} %>
									<%} %>
								</div>
							</td>
						</tr>
						 -->
						<tr class="smallText">
							<td class="infoLabel" width="25%">
								<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>目前狀態:<%} else {%>Current Status:<%} %>								
							</td>
							<td class="infoData" width="35%">
								<%if(!isAllow) { %>
									<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
										你不能參與週年晚會
									<%} else {%>
										You are not eligible to join.
									<%} %>
								<%}else {%>
									<div style="font-size:14px; color:blue;">
										<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
											<%=(join != null)?(join.equals("Y")?"已參與":((join.equals("N")?"不參與":""))):"" %>
											<%=(groupDesc != null && !groupID.equals(groupWaitingID) && !groupID.equals(groupCancelID))?("在組別 "+groupDesc.substring(groupDesc.indexOf(" "))):((join != null && join.equals("Y"))?"<br/><br/>您現已在候補名單，請選擇其中一個組別。":"")%>
										<%} else {%>
											<%=(join != null)?(join.equals("Y")?"Participate":((join.equals("N")?"Not Participate":""))):"" %>
											<%=(groupDesc != null && !groupID.equals(groupWaitingID) && !groupID.equals(groupCancelID))?(" in "+groupDesc):((join != null && join.equals("Y"))?"<br/><br/>You are on the <b><i><u>waiting list</u></i></b> now.<br/><br/>Please join a group!!!":"")%>
										<%} %>											
									</div>
								<%} %>
							</td>
						</tr>
						<%if(isAllow) { %>
							<%if(ConstantsServerSide.isHKAH()) { %>
								<tr class="smallText">
									<td colspan="2" align="left">
										<!-- 
										<label><b>
											Thank you for registering and we look forward to seeing you at the Annual Staff Party.
										</b></label>
										 -->
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
								<%if(!"1".equals(enrollNo)&&"confirm".equals(confirm)){%>
								<%}else{ %>
								<tr class="smallText">
									<td colspan="2" align="left">
										<label><b>
											<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
												透過點擊提交按鈕，本人在此聲明本人已閱讀、明白及同意以上所有條款及細則。
											<%} else { %>
												By clicking on the Submit button, I hereby declare that I have read, understood, and agree to all the above terms and conditions.
											<% } %>
										</b></label>
									</td>
								</tr>
								<%} %>
							<%} %>
							<%if(!"1".equals(enrollNo)&&"confirm".equals(confirm)){%>
								<%}else{ %>
							<tr class="smallText">
								<td colspan="2" align="center">
									<br/>
									<button onclick="return enrolltAction('initAction');">
										<bean:message key="button.submit" />
									</button>
								</td>
							</tr>
							<%} %>
						<%} %>
					</table>
					<input type="hidden" name="command"/>
					<input type="hidden" name="isAllow" value="<%=isAllow%>"/>
					<input type="hidden" name="attend" value="<%=join%>"/>
					<input type="hidden" name="waitingID" value="<%=groupWaitingID%>"/>
					<input type="hidden" name="cancelID" value="<%=groupCancelID%>"/>
					<input type="hidden" name="reqGrpID" value="<%=groupID%>"/>
					<input type="hidden" name="groupID" value="<%=groupID%>"/>
					<input type="hidden" name="group" value="<%=groupDesc%>"/>
					<input type="hidden" name="makeRequest" value="<%=makeRequest%>"/>
					<input type="hidden" name="participantPrice" value="<%=participantPrice == null?"0":participantPrice%>"/>
					<%-- <input type="hidden" name="submitCount" value="<%=(submitCount==null)?"0":submitCount%>"/> --%>
				</form>
				<br/>
				<br/>
			<%if(join != null && join.equals("Y")) { %>
				<bean:define id="functionLabel"><bean:message key="function.xmas.enrollment" /></bean:define>
				<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
				<form name="xmasEnrollForm" action="" method="post">

					<display:table id="row" name="requestScope.party_group_list" export="true" pagesize="100" class="tablesorter">
							<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
 							<display:column titleKey="prompt.xmas.group" style="width:15%">
 							<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
 								<c:out value="${row.fields22}" />
							<%} else { %>
								<c:out value="${row.fields4}" />
							<%} %>
								<logic:equal name="row" property="fields4" value="Group 4">
									<%=(ConstantsServerSide.isHKAH())?"":" (Vegetarian)" %>
								</logic:equal>
							</display:column>							
							<display:column title="Table No." style="width:1%" media="pdf">
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
								<%=(ConstantsServerSide.isHKAH()?"":" (每枱12人)") %>
							</display:column>
							<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
								<button onclick="return enrolltAction('view', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />');"><bean:message key='button.view' /></button>
								<logic:notEqual name="row" property="fields13" value="0">
									<logic:notEqual name="row" property="fields15" value="0">
										<%if(groupID != null && groupID.equals(groupWaitingID)) { %>
											<button onclick="return enrolltAction('add', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />');"><bean:message key='button.join' /></button>
										<%} %>
									</logic:notEqual>
									<%--
									<logic:equal name="row" property="fields7" value="<%=groupID %>">
										<button onclick="return enrolltAction('edit', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />');"><bean:message key='button.edit' /></button>
									</logic:equal>
									--%>
									<logic:equal name="row" property="fields7" value="<%=groupID %>">
										<%
											if(!"1".equals(enrollNo)&&"confirm".equals(confirm)){
										%>
											CONFIRMED
										<%
											}else{
										%>
											<button onclick="return enrolltAction('withdraw', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />');"><bean:message key='button.withdraw' /></button>
										<%
											}
										%>
									</logic:equal>
								</logic:notEqual>
							</display:column>

						<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
					</display:table>
					<input type="hidden" name="ecommand"/>
					<input type="hidden" name="eventID"/>
					<input type="hidden" name="scheduleID"/>
					<%-- <input type="hidden" name="submitCount" value="<%=(submitCount==null)?"0":submitCount%>"/> --%>
				</form>
				<input type="hidden" name="showAlert" value="true"/>
				<%} %>
				<script language="javascript">
					var showAlert = true;
					
					function enrolltAction(command, eventID, scheduleID) {
						var curCal = new Date();
						var isAfterDeadline = false;
						if (curCal.getTime() > <%=regDeadlineCal.getTime().getTime() %>) {
							isAfterDeadline = true;
						}

						$('input[name=showAlert]').val("false");
						//$('input[name=eventID]').val(eventID);
						//$('input[name=scheduleID]').val(scheduleID);
						$('input[name=command]').val(command);
						if(command == 'view' && isAfterDeadline == false) {
							callPopUpWindow("enrolled_list.jsp?eventID=" + eventID + "&scheduleID=" + scheduleID);
							return false;
						}
						else if(command == 'add' && isAfterDeadline == false) {
							document.xmasEnrollForm.action = 'enrollment.jsp?command=add&eventID='+eventID+'&scheduleID='+scheduleID;
							document.xmasEnrollForm.submit();
							return false;
						}
						else if(command == 'edit' && isAfterDeadline == false) {
							document.xmasEnrollForm.action = 'enrollment.jsp?command=edit&eventID='+eventID+'&scheduleID='+scheduleID;
							document.xmasEnrollForm.submit();
							return false;
						}
						else if(command == 'withdraw' && isAfterDeadline == false) {
							var waitingID = $('input[name=waitingID]').val();

							$('input[name=command]').val('initAction');
							$('input[name=reqGrpID]').val(waitingID);
							document.xmasRegForm.submit();
							return false;
						}
						else if(command == 'initAction' && isAfterDeadline == false) {
							var join = $('input[name=join]:checked').val();
							var waitingID = $('input[name=waitingID]').val();
							var cancelID = $('input[name=cancelID]').val();
							var groupID = $('input[name=reqGrpID]').val();
							if(join) {
								if (join == "Y") {
									if (groupID && groupID != "null") {
										if (groupID == cancelID) {
											$('input[name=reqGrpID]').val(waitingID);
										}
										else {
											alert("Already participate");
											return false;
										}
									}
									else {
										$('input[name=reqGrpID]').val(waitingID);
									}
								}
								else if (join == "N") {
									if (groupID && groupID != "null") {
										if (groupID == cancelID) {
											alert("Already not participate");
											return false;
										}
										else {
											$('input[name=reqGrpID]').val(cancelID);
										}
									}
									else {
										$('input[name=reqGrpID]').val(cancelID);
									}
								}
								document.xmasRegForm.submit();
								return false;
							}
							else {
								alert("Please choose 'Participate' or Not 'Participate'");
								return false;
							}
						}
					}

					function alertMsg() {						
						var attend = $('input[name=attend]').val()=="Y";
						var group = $('input[name=group]').val() == "null";
						var waiting = $('input[name=group]').val() == "Waiting";
						var cancel = $('input[name=group]').val() == "Cancel";
						var req = $('input[name=makeRequest]').val();
						//var req = 'N';
						var HRmsg = "\n\nPlease proceed to HR office immediately to pay if you wish to confirm your group number. "+
										"If payment is not made within 48 hours, the family booking will be automatically cancelled.";
						var HRmsg = "";		
						var isHKAH = <%=ConstantsServerSide.isHKAH()%>;
						var price = <%=(participantPrice!=null && participantPrice.length()>0)?participantPrice:0%>;

						//alert("attend : " + attend);
						//alert("group : " + group);
						//alert("waiting : " + waiting);
						//alert("cancel : " + cancel);
						//alert("req : " + req);
						//alert("price : " + price);
						
						if(req == "Y") {
							
							//alert("Current Status:  "+
							//		(attend?"Participate":"Not Participate")
							//		+ "\n\n"
							//		//+ " Christmas Gathering"
							//		+ (group?(attend?"Please join a group!!!":""):
							//			(waiting?"You are on the waiting list now.\n\nPlease join a group!!!":
							//				cancel?"":
							//				("Group:  "+$('input[name=group]').val()+
							//				"\n\nCost:  HK$"+$('input[name="participantPrice"]').val()+
							//				(isHKAH?HRmsg:"")+
							//				" \n\n The process is completed!!!"))));
							
							if (attend) {
								if (cancel) {
									<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
										alert("目前狀態：參與 \r\n您現已在候補名單，請選擇其中一個組別。");
									<% } else { %>									
										alert("Current Status:  " + "Participate \r\nYou are on the waiting list now. Please join a group!!!");
									<% } %>										
								} else {
									<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
										alert("恭喜您！ \r\n\您已入組。請於座位確認當天登入至內聯網，查看您所屬的座位。");
									<% } else { %>
										alert("Congratulations! \r\n\You have now joined a group. Please log-in to intranet portal on seating confirmation date to view your table no.");
									<% } %>
								}
							} else {
								<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
									alert("目前狀態:  " + "不參與");
								<%} else {%>
									alert("Current Status:  " + "Not Participate");
								<%} %>
							}	
							if (!isHKAH) {
								if (attend) {
									if (!group) {
										if (!waiting && !cancel) {
											if (parseInt(price) > 0) {
												window.open('payment.jsp', '_blank');
											}
										}
									}
								}
							}

							if(!attend) {
								window.open('','_self','');
								window.close();
							}
						}

						if(waiting) {
							$(window).scrollTop(700);
						}
					}

					function animation() {
						$('div#cost').animate( { backgroundColor: 'yellow' }, 500)
				    	.animate( { backgroundColor: 'white' }, 500);
					}

					$(document).ready(function() {
						setInterval("animation()",1000);

						if($('input[name=isAllow]').val() == "false") {
							$('body').html('');
							alert('Invitees to the Annual Staff Party are full-time or part-time staff under the hospital\'s employment on the day of the Annual Staff Party and other special invited guests. \r\n\r\nFor any questions regarding registration, please contact the Human Resources office.');
							window.open('','_self','');
							window.close();
						}

						var browserName=navigator.appName;
						if (!(navigator.userAgent.indexOf('MSIE') !== -1 || navigator.appVersion.indexOf('Trident/') > 0)) {
							$('body').html('');
						  	alert("Please use Internet Explorer!");
						  	window.open('','_self','');
							window.close();
						}

						alertMsg();
					});
				</script>
			</div>
		</div>
	</body>
</html:html>