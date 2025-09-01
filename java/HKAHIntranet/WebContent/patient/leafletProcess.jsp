<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.ArrayList" %>
<%
String registrationForm = request.getParameter("registrationForm");
String patientAdmission = request.getParameter("patientAdmission");
String patientsCharter = request.getParameter("patientsCharter");
String whyVegetarianDiet = request.getParameter("whyVegetarianDiet");
String healthCareAdvisory = request.getParameter("healthCareAdvisory");
String dailyRoomRateEng = request.getParameter("dailyRoomRateEng");
String dailyRoomRateChi = request.getParameter("dailyRoomRateChi");
String preAnaesthesiaQuestionnaire = request.getParameter("preAnaesthesiaQuestionnaire");
String renovationOTEng = request.getParameter("renovationOTEng");
String renovationOTChi = request.getParameter("renovationOTChi");
ArrayList<String> orderItems = new ArrayList<String>();

UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();

StringBuffer message = new StringBuffer();
if ("Y".equals(registrationForm)) {
	message.append("<br/>");
	message.append(MessageResources.getMessageEnglish("label.registration.form"));

	orderItems.add(MessageResources.getMessageEnglish("label.registration.form") + " " +
			MessageResources.getMessageTraditionalChinese("label.registration.form"));
}
if ("Y".equals(patientAdmission)) {
	message.append("<br/>");
	message.append(MessageResources.getMessageEnglish("label.patient.admission"));

	orderItems.add(MessageResources.getMessageEnglish("label.patient.admission")+ " " +
			MessageResources.getMessageTraditionalChinese("label.patient.admission"));
}
if ("Y".equals(patientsCharter)) {
	message.append("<br/>");
	message.append(MessageResources.getMessageEnglish("label.patients.charter"));

	orderItems.add(MessageResources.getMessageEnglish("label.patients.charter")+ " " +
			MessageResources.getMessageTraditionalChinese("label.patients.charter"));
}
if ("Y".equals(whyVegetarianDiet)) {
	message.append("<br/>");
	message.append(MessageResources.getMessageEnglish("label.why.vegetarian.diet"));

	orderItems.add(MessageResources.getMessageEnglish("label.why.vegetarian.diet")+ " " +
			MessageResources.getMessageTraditionalChinese("label.why.vegetarian.diet"));
}
if ("Y".equals(healthCareAdvisory)) {
	message.append("<br/>");
	message.append(MessageResources.getMessageEnglish("label.health.care.advisory"));

	orderItems.add(MessageResources.getMessageEnglish("label.health.care.advisory")+ " " +
			MessageResources.getMessageTraditionalChinese("label.health.care.advisory"));
}
if ("Y".equals(dailyRoomRateEng)) {
	message.append("<br/>");
	message.append(MessageResources.getMessageEnglish("label.daily.room.rate"));
	message.append("(");
	message.append(MessageResources.getMessageEnglish("label.english.version"));
	message.append(")");

	orderItems.add(MessageResources.getMessageEnglish("label.daily.room.rate") + " " +
			MessageResources.getMessageTraditionalChinese("label.daily.room.rate")+
			"("+MessageResources.getMessageEnglish("label.english.version")+ " " +
			MessageResources.getMessageTraditionalChinese("label.english.version") + ")");
}
if ("Y".equals(dailyRoomRateChi)) {
	message.append("<br/>");
	message.append(MessageResources.getMessageEnglish("label.daily.room.rate"));
	message.append("(");
	message.append(MessageResources.getMessageEnglish("label.chinese.version"));
	message.append(")");

	orderItems.add(MessageResources.getMessageEnglish("label.daily.room.rate")+ " " +
			MessageResources.getMessageTraditionalChinese("label.daily.room.rate")+
			"("+MessageResources.getMessageEnglish("label.chinese.version")+ " " +
			MessageResources.getMessageTraditionalChinese("label.chinese.version") +")");
}
if ("Y".equals(preAnaesthesiaQuestionnaire)) {
	message.append("<br/>");
	message.append(MessageResources.getMessageEnglish("label.pre-anaesthesia.questionnaire"));

	orderItems.add(MessageResources.getMessageEnglish("label.pre-anaesthesia.questionnaire")+ " " +
			MessageResources.getMessageTraditionalChinese("label.pre-anaesthesia.questionnaire"));
}
if ("Y".equals(renovationOTEng)) {
	message.append("<br/>");
	message.append(MessageResources.getMessageEnglish("label.renovation.letter"));
	message.append("(");
	message.append(MessageResources.getMessageEnglish("label.english.version"));
	message.append(")");

	orderItems.add(MessageResources.getMessageEnglish("label.renovation.letter")+ " " +
			MessageResources.getMessageTraditionalChinese("label.renovation.letter")+
			"("+MessageResources.getMessageEnglish("label.english.version")+ " " +
			MessageResources.getMessageTraditionalChinese("label.english.version") +")");
}
if ("Y".equals(renovationOTChi)) {
	message.append("<br/>");
	message.append(MessageResources.getMessageEnglish("label.renovation.letter"));
	message.append("(");
	message.append(MessageResources.getMessageEnglish("label.chinese.version"));
	message.append(")");

	orderItems.add(MessageResources.getMessageEnglish("label.renovation.letter")+ " " +
			MessageResources.getMessageTraditionalChinese("label.renovation.letter")+
				"("+MessageResources.getMessageEnglish("label.chinese.version")+ " " +
				MessageResources.getMessageTraditionalChinese("label.chinese.version") +")");
}

UtilMail.sendMail(
		ConstantsServerSide.MAIL_ALERT,
		"cherry.wong@hkah.org.hk",
		"Need Hardcopy Leaflet from Patient " + userBean.getUserName() + " (" + loginID + ")",
		message.toString());
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
<%@ page language="java" contentType="text/html; charset=big5"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<body>
<%-- <jsp:include page="../patient/checkSession.jsp" /> --%>
<form name="form1">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td></tr>
<jsp:include page="../patient/patientInfo.jsp" />
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><img src="../images/pdf.gif"><br/><span class="enquiryLabel extraBigText">Hospital Leaflet</span></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
<%for(int i = 0; i < orderItems.size(); i+=3) {
%>
	<tr>
		<td align="center">
			<div style="width:99%; height:200px;" align="center">
			<%if(orderItems.size() > i) {%>
				<div class = "leafletItem ui-button ui-corner-all ui-button-text-only">
					<div>
						<img index = "0" class="preview" src="../images/pdficon.gif" /><br/>
						<label><%=orderItems.get(i).toString() %></label>
					</div>
				</div>
			<%}%>
			<%if(orderItems.size() > i+1) {%>
				<div class = "leafletItem ui-button ui-corner-all ui-button-text-only">
					<div>
						<img index = "1" class="preview" src="../images/pdficon.gif"/><br/>
						<label><%=orderItems.get(i+1).toString() %></label>
					</div>
				</div>
			<%}%>
			<%if(orderItems.size() > i+2) {%>
				<div class = "leafletItem ui-button ui-corner-all ui-button-text-only">
					<div>
						<img index = "2" class="preview" src="../images/pdficon.gif"/><br/>
						<label><%=orderItems.get(i+2).toString() %></label>
					</div>
				</div>
			<%}%>
			</div>
		</td>
	</tr>
	<tr>
		<td align="center">
			<div style="width:99%;" align="left">
			<%if(orderItems.size() > i) {%>
				<div style="height:20%; color:#00248E;" class = 'leafletItem ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>
						<label>Hard Copy: </label>
						<img src="../images/thumb_up.gif"/>
				</div>
			<%}%>
			<%if(orderItems.size() > i+1) {%>
				<div style="height:20%; color:#00248E;" class = 'leafletItem ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>
						<label>Hard Copy: </label>
						<img src="../images/thumb_up.gif"/>
				</div>
			<%}%>
			<%if(orderItems.size() > i+2) {%>
				<div style="height:20%; color:#00248E;" class = 'leafletItem ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>
						<label>Hard Copy: </label>
						<img src="../images/thumb_up.gif"/>
				</div>
			<%}%>
			</div>
		</td>
	</tr>
<%
}
%>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><b>Thank you for your order. Out staff will contact you shortly.</b></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><button style="font-size:24px;" class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' onclick="return submitAction();"><img src="../images/undo2.gif">&nbsp;Back to Home</button></td></tr>
</table>
</form>
<script language="javascript">
	function submitAction() {
		showLoadingBox();
		document.form1.action = "../patient/main.jsp";
		document.form1.submit();
		hideLoadingBox();
	}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>