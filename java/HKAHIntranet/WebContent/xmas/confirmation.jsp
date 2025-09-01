<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
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
ArrayList enrollRecord = null;
boolean isAllow = true;
String tableNo = "";
String status = "";
String mealType = "";
String busToRestType = "";
String busToHospType = "";
String eventID = XmasGatheringDB.getEventIDByCurrentYear();
String groupWaitingID = null;
String groupCancelID = null;
String participantPrice = "";
String eventPrice = null;
String staffName = null;
String staffDeptDesc = null;
boolean staffParam = false;
Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);

String staffID = request.getParameter("staffID");
if (staffID == null || (staffID != null && staffID.length() == 0)) {
	staffID = userBean.getStaffID();
}
else {
	staffParam = true;
}

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
	eventPrice = groupInfoRow.getValue(5);
}

if(isAllow) {
	enrollRecord = EnrollmentDB.getEnrolledClass("christmas", eventID, null, null, staffID, null, null, null, null);
	if(enrollRecord.size() > 0) {
		ReportableListObject row = (ReportableListObject) enrollRecord.get(0);
		if(!row.getValue(2).equals(groupCancelID) && !row.getValue(2).equals(groupWaitingID)) {
			tableNo = row.getValue(20);
			status = row.getValue(18);
			participantPrice = XmasGatheringDB.getParticipantPrice(userBean, eventID, row.getValue(2), row.getValue(3), eventPrice, staffID);
			mealType = row.getValue(25);
			busToRestType = row.getValue(27);
			busToHospType = row.getValue(28);
		}
		else {
			isAllow = false;
		}
	}
	else {
		isAllow = false;
	}
}

if (!staffParam && (userBean != null && userBean.isAccessible("function.xmas.enrollment.list.admin"))) {
	isAllow = true;
}
else {
	if (staffID != null) {
		staffName = StaffDB.getStaffFullName2(staffID);
		staffDeptDesc = DepartmentDB.getDeptDesc(StaffDB.getDeptCode(staffID));
	}
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<style>
		LABEL {
			font-size: 18px !important;
		}
		DIV {
			font-size: 24px !important;
		}
	</style>
	<body>
		<div id=indexWrapper>
			<div id=mainFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="group.xams" />
					<jsp:param name="category" value="group.xams" />
					<jsp:param name="accessControl" value="N"/>
				</jsp:include>
				<table id="contentTable" style="width:90%">
					<%if(ConstantsServerSide.isTWAH()) { %>
					<tr>
						<td align="center">
							<b>Confirmation of Registration</b><br/>
							<b>Hong Kong Adventist Hospital - Tsuen Wan</b><br/>
							<b>Annual Staff Party</b><br/>
							18 December 2019
						</td>
					</tr>
					<%} else { %>
					<tr>
						<td align="center"><img src="../images/confirmation_page.jpg"/></td>
					</tr>
					<%} %>
					<tr><td>&nbsp;</td></tr>
					<tr><td><div><%if (Locale.TRADITIONAL_CHINESE.equals(locale)) {%>姓名:<%}else {%>Name:<%}%><%=(staffName != null)?staffName:userBean.getUserName() %></div></td></tr>
					<tr><td><div><%if (Locale.TRADITIONAL_CHINESE.equals(locale)) {%>員工編號:<%}else {%>Emp No: <%}%><%=staffID %></div></td></tr>
					<tr><td><div><%if (Locale.TRADITIONAL_CHINESE.equals(locale)) {%>員工類別:<%}else {%>Status: <%}%><%=status %></div></td></tr>
					<tr><td><div><%if (Locale.TRADITIONAL_CHINESE.equals(locale)) {%>部門:<%}else {%>Dept: <%}%><%=(staffDeptDesc != null)?staffDeptDesc:userBean.getDeptDesc() %></div></td></tr>
					<tr><td><div>
						<%if (Locale.TRADITIONAL_CHINESE.equals(locale)) {%>膳食類型:<%
							if (mealType.equals("non-vege")) {%> 非素食者<%}else{%> 素食者<%}%>
						<%}else{%>Meal:<%if (mealType.equals("non-vege")) {%> Non-vegetarian<%}else{%> Vegetarian<%}}%>
					</div></td></tr>

					<tr><td><div><%if (Locale.TRADITIONAL_CHINESE.equals(locale)) {%>
						穿梭巴士前往康山:
						<%if(busToRestType.equals("not-req")){%> 不乘坐
						<%}else{%><%if(busToRestType.equals("1815")){%> 18:15
						<%}else{%><%if(busToRestType.equals("1845")){%> 18:45<%}%><%}%><%}%>
					<%}else{%>
						Shuttle to Kornhill :
						<%if(busToRestType.equals("not-req")){%> Not Required
						<%}else{%><%if(busToRestType.equals("1815")){%> 18:15
						<%}else{%><%if(busToRestType.equals("1845")){%> 18:45<%}%><%}%><%}%>
					<%}%></div></td></tr>
									
					<tr><td><div><%if (Locale.TRADITIONAL_CHINESE.equals(locale)) {%>
						穿梭巴士前往醫院:
						<%if(busToHospType.equals("not-req")){%> 不乘坐
						<%}else{%><%if(busToHospType.equals("2145")){%> 21:45<%}}%>
					<%}else{%>
						Shuttle to Hospital:
						<%if(busToHospType.equals("not-req")){%> Not Required
						<%}else{%><%if(busToHospType.equals("2145")){%> 21:45<%}}%>
					<%}%></div></td></tr>
					
					<!--  
					<tr><td><div>Price: 
					<%
						int total = participantPrice != null&&participantPrice.length()>0?Integer.parseInt(participantPrice):0;
						if (ConstantsServerSide.isHKAH()) {
							%><%=participantPrice == null?"HK$0":"HK$"+participantPrice  %>&nbsp;&nbsp;<%
						}
						else {
							ArrayList result = StaffDB.get(userBean.getStaffID());
							if (result.size() > 0) {
								ReportableListObject rlo = (ReportableListObject) result.get(0);	
								if (rlo.getValue(4).equals("CAS")) {
									total += Integer.parseInt(eventPrice);
								}
							}
							%><%=total == 0?"HK$0":"HK$"+total  %>&nbsp;&nbsp;<%
						}
					%>
					</div></td></tr>
					-->
					<tr><td>&nbsp;</td></tr>
					<tr><td><div style="color:green"><b><i><%if (Locale.TRADITIONAL_CHINESE.equals(locale)) {%>您的檯號:<%}else {%>Your Table No.: <%}%><%=tableNo %></i></b></div></td></tr>
					<tr><td>&nbsp;</td></tr>
					<%if(ConstantsServerSide.isTWAH()) { %>
					<tr>
						<td>

							<label><b>地點：	  香港悅來酒店 (熊貓酒店)五樓宴會廳 新界西荃灣荃華街3號</b></label>
							<br/>

						</td>
					</tr>
					<%} else { %>
					<tr>
						<td>
							<%if (Locale.TRADITIONAL_CHINESE.equals(locale)) {%>
							<label style="color:red"><b><i>會場 : </i></b></label><label><b>會所1號時尚康山</b></label>
							<%--
							<label style="color:red"><b><i>會場: </i></b></label><label><b><%=MessageResources.getMessageTraditionalChinese("prompt.xmas.location")%></b></label>
							--%>
							<%} else {%>
							<label style="color:red"><b><i>Venue: </i></b></label><label><b>ClubONE Kornhill in Vogue<%--<%=MessageResources.getMessageTraditionalChinese("prompt.xmas.location") --%></b></label>
							<%--
							<label style="color:red"><b><i>Venue: </i></b></label><label><b><%=MessageResources.getMessageEnglish("prompt.xmas.location") %>
							--%> 
							<%} %>
							<br/>
							<%if (Locale.TRADITIONAL_CHINESE.equals(locale)) {%>
							<label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;香港太古康山道2號康蘭居201號</label>
							<%--
							<label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=MessageResources.getMessageTraditionalChinese("prompt.xmas.address") %></label>
							--%>
							<%} else {%>
							<label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;201 Kornhill Apartment, 2 Kornhill Road, Taikoo</label>
							<%--
							<label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=MessageResources.getMessageEnglish("prompt.xmas.address") %></label>
							--%>
							<%} %>
							<br/>
							<%--
							<label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=MessageResources.getMessageTraditionalChinese("prompt.xmas.address") %></label>
							<br/>
							 --%>
						</td>
					</tr>
					<tr>
					<td>
					<%if (Locale.TRADITIONAL_CHINESE.equals(locale)) {%>
						<label style="color:red"><b><i>日期 : </i></b></label><label>2019 年 12 月 12 日</label>
					<%} else {%>
						<label style="color:red"><b><i>Date:</i></b></label><label>&nbsp;&nbsp;&nbsp;&nbsp;12 December 2019</label> 
					<%} %>
					</td>
					</tr>
					<%} %>
					<tr><td>&nbsp;</td></tr>					
					<%if(ConstantsServerSide.isTWAH()) { %>
					<!--
					<tr><td><label style="color:green"><b><i>Note: </i></b></label></td></tr>
					<tr>
						<td>
							<label>- The Annual Staff Party will start at 6:30pm</label><br/><br/>
							<label>- Staff MUST bring along their hospital ID badge which will be used to scan for attendance and most importantly for prize drawing. Therefore, please take note, no hospital ID badge, no prize drawing.</label><br/><br/>
							<label>- Prize drawings will be computer-generated. Winners have to present their hospital ID badges to claim their prizes on stage.</label><br/><br/>
							<label>- Attendance will be taken so that participants who have booked a place but do not show up, the cost of HKD$400 per person will be deducted from your next payroll. Please do not ask for any exception.</label><br/><br/>
							<label>- Dinner party seating charts will be displayed at reception desk. Please make sure your table number before seating at the dinner party.</label><br/><br/>
							<label>- Parking Arrangements: Please contact King's Cuisine staff on the night of the Annual Staff Party for the restaurant receipt for 3-hour free parking at the Windsor House Parking Lot if necessary.</label>
						</td>
					</tr>
					-->
					<%} else { %>
					<%
						if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {
					%>
						<tr><td><label style="color:green"><b><i>備註: </i></b></label></td></tr>
						<tr>
						<td>
							<label>- 員工週年晚會將於晚上6時45 分開始（下午6時恭候，屆時設有遊戲攤位及有棉花糖提供）。</label><br/><br/>
							<label>- 出席活動之員工必須帶備員工證，作出席紀錄及抽獎登記之用，否則將不能參與抽獎活動。</label><br/><br/>
							<label>- 抽獎結果會由電腦程式隨機抽出。得獎者須出示員工證，並到台前領取獎品。</label><br/><br/>
							<label>- 如根據週年晚會當晚的出席記錄，未有已報名參與晚會的員工資料，該員工須繳付港幣$400（每位成本價）。</label><br/><br/>
							<label>- 晚宴的座位表會於當晚張貼在接待處，請先查閱座位安排，再自行入座。</label><br/><br/>
							<label>- 當晚沒有泊車優惠提供。</label><br/><br/>
							<!--
							<label>- 泊車安排：駕車員工可於晚宴當晚聯絡景逸軒職員，索取餐廳收據，作申請皇室堡停車場三小時免費泊車之用。</label><br/><br/>
							-->
							<!-- 
							<label>- <%=MessageResources.getMessageEnglish("prompt.xmas.note6") %></label>
							 -->
						</td>
						</tr>					
					<%
						} else {
					%>
						<tr><td><label style="color:green"><b><i>Note: </i></b></label></td></tr>
						<tr>
						<td>
							<label>- The Annual Staff Party will start at 6:45pm. (The venue will be ready with cotton candy and game booth available at 6:00pm.) </label><br/><br/>
							<label>- Staff MUST bring along their hospital ID badge which will be used to scan for attendance and most importantly for prize drawing. Therefore, please take note, no hospital ID badge, no prize drawing. </label><br/><br/>
							<label>- Prize drawings will be computer-generated. Winners have to present their hospital ID badges to claim their prizes on stage. </label><br/><br/>
							<label>- Attendance will be taken at the Annual Staff Party. A fine of HK400 (cost per person) will be made payable for participants who have registered but do not show up at the Annual Staff Party. </label><br/><br/>
							<label>- Dinner party seating charts will be displayed at the reception. Please check your arranged seating at the dinner party.</label><br/><br/>
							<label>- No Parking Arrangement is available.</label><br/><br/>
							<!--
							<label>- Parking Arrangements: Please contact King's Cuisine staff on the night of the Annual Staff Party for the restaurant receipt for 3-hour free parking at the Windsor House Parking Lot if necessary.</label><br/><br/>
							-->
							<!-- 
							<label>- <%=MessageResources.getMessageEnglish("prompt.xmas.note6") %></label>
							 -->
						</td>
						</tr>					
					<%
						}
					%>
					<%} %>
					<tr>
						<td align="center"><img src="../images/xmas/seasongreeting.png"/></td>
					</tr>
				</table>
				<input type="hidden" name="isAllow" value="<%=isAllow%>"></input>
				<script>
				$(document).ready(function() {
					$(window).bind('resize', function() {
						$('#mainFrame table#contentTable div').css('padding-left', $(window).width()/3);
					}).trigger('resize');

					if($('input[name=isAllow]').val() == "false") {
						$('body').html('');
						alert('You are not attending this event.');
						window.open('','_self','');
						window.close();
					}
				});
				</script>
			</div>
		</div>
	</body>
</html:html>
