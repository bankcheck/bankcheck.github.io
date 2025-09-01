<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
UserBean userBean = new UserBean(request);
ArrayList enrollRecord = null;
boolean isAllow = true;
String tableNo = "";
String status = "";
String eventID = XmasGatheringDB.getEventIDByCurrentYear();
String participantPrice = "";
String eventPrice = null;

Calendar cal = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
String date = sdf.format(cal.getTime());
Map enrollNameMap = null;
Map enrollMap = null;
String price = XmasGatheringDB.getPrice(eventID);
ArrayList fmType = XmasGatheringDB.getFamilyType();

String groupWaitingID = null;
String groupCancelID = null;
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

if(ConstantsServerSide.isHKAH()) {
	isAllow = XmasGatheringDB.isAllow(userBean.getStaffID());
}else if(ConstantsServerSide.isTWAH()) {
	isAllow = true;
}

if(isAllow) {
	enrollRecord = EnrollmentDB.getEnrolledClass("christmas", eventID, null, null, userBean.getStaffID(), null, null, null, null);
	
	if(enrollRecord.size() > 0) {
		ReportableListObject row = (ReportableListObject) enrollRecord.get(0);
		enrollNameMap = XmasGatheringDB.getEnrolledFamily(userBean, eventID, 
				row.getValue(2),"name");
		enrollMap = XmasGatheringDB.getEnrolledFamily(userBean, eventID, 
				row.getValue(2),"count");
		if(!row.getValue(2).equals(groupCancelID) && !row.getValue(2).equals(groupWaitingID)) {
			tableNo = row.getValue(20);
			status = row.getValue(18);
			participantPrice = XmasGatheringDB.getParticipantPrice(userBean, eventID, row.getValue(2), row.getValue(3), eventPrice, userBean.getStaffID());
		}
		else {
			isAllow = false;
		}
	}
	else {
		isAllow = false;
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
						<td>
							荃灣港安醫院
						</td>
						<td>
							荃灣荃景圍199號  
						</td>
					</tr>
					<tr>
						<td></td>
						<td>電話 : 2276-7363  傳真 : 2276-7713</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="center" colspan="2">
							<b>發票</b>
						</td>
					</tr>
					<%} else { %>
					<tr>
						<td align="center">
						</td>
					</tr>
					<%} %>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
							至：<%=userBean.getUserName() %> (<%=userBean.getDeptDesc() %>_<%=userBean.getStaffID() %>)
						</td>
						<td>
							日期：<%=date %>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>請為你及你的家人繳付以下的款項(2016員工週年聯歡會)：</td>
						<td>銀碼</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<%
					int show = 0;
					int total = participantPrice!=null?Integer.parseInt(participantPrice):0;
					boolean isCA = false;
					if (ConstantsServerSide.isTWAH()) {
						show++;
						ArrayList result = StaffDB.get(userBean.getStaffID());
						if (result.size() > 0) {
							ReportableListObject rlo = (ReportableListObject) result.get(0);	
							if (rlo.getValue(4).equals("CAS")) {
								isCA = true;
								total += Integer.parseInt(price);
							}
						}
						
						%>	<tr>
								<td>
									<%=show%>. <%=userBean.getUserName() %>
								</td>
								<td>HK$<%=isCA?price:"0" %></td>
							</tr>
						<%
					}
					
					for (int i = 0; i < fmType.size(); i++) {	
						ReportableListObject row = (ReportableListObject) fmType.get(i);
						boolean noPrice = false;
						try {
							Integer.parseInt(price);
						}
						catch (Exception e) {
							noPrice = true;
						}
						String name = (String)enrollNameMap.get(row.getValue(0));
						if (name != null && name.length() > 0) {
							show++;
						%>	<tr>
								<td>
									<%=show%>. <%=enrollNameMap.get(row.getValue(0)) %>
								</td>
								<%
									if (isCA) {
										%>
										<td>HK$<%=Integer.parseInt(price)*Integer.parseInt((String)enrollMap.get(row.getValue(0)))%>
										<%
									}
									else {
										%>
										<td>HK$<%=noPrice?"":((Integer.parseInt(row.getValue(2))*Integer.parseInt(price))/100)*Integer.parseInt((String)enrollMap.get(row.getValue(0))) %></td>
										<%
									}
								%>
							</tr>
					<%}
					} %>	
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right">總數：</td>
						<td>HK$<%=String.valueOf(total) %></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>請於2016年12月5日或之前於病人事務部繳交有關款項。</td>
					</tr>
					<tr>
						<td>所有員工週年聯歡會的報名預定會在收到閣下的繳款單收據後才作實。</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<%if(ConstantsServerSide.isTWAH()) { %>
					<%} else { %>
					<tr>
						<td>
							<label style="color:red"><b><i>Venue: </i></b></label><label><b><%=MessageResources.getMessageEnglish("prompt.xmas.location") %> <%=MessageResources.getMessageTraditionalChinese("prompt.xmas.location") %></b></label>
							<br/>
							<label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=MessageResources.getMessageEnglish("prompt.xmas.address") %></label>
							<br/>
							<label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=MessageResources.getMessageTraditionalChinese("prompt.xmas.address") %></label>
							<br/>
						</td>
					</tr>
					<%} %>
					<tr><td>&nbsp;</td></tr>
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
