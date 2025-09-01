<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.schedule.NotifyPatientAppointment"%>

<%
UserBean userBean = new UserBean(request);

String isReceiveSMS = request.getParameter("isReceive");
String smcID = request.getParameter("smcID");
if (isReceiveSMS == null || isReceiveSMS.length() == 0) {
	isReceiveSMS = "receive";
}

Calendar startCal = Calendar.getInstance();
Calendar endCal = Calendar.getInstance();
Calendar currentCal = Calendar.getInstance();
SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

while (!NotifyPatientAppointment.isSmsScheduleDay(startCal)) {
	startCal.add(Calendar.DATE, 1);
	endCal.add(Calendar.DATE, 1);
	currentCal.add(Calendar.DATE, 1);
}

startCal = NotifyPatientAppointment.getAppointmentDay(startCal, false);
endCal = NotifyPatientAppointment.getAppointmentDay(endCal, false);

ArrayList record = NotifyPatientAppointment.getSMSList(smf, startCal, endCal, isReceiveSMS.equals("receive"), smcID);
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Appointment SMS List" />
	<jsp:param name="category" value="Report" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>

<form name="search_form" action="sms_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
		<tr class="smallText">
			<td class="infoLabel" width="30%">Receive SMS</td>
			<td class="infoData" width="70%">
				<select name='isReceive'>
					<option></option>
					<option <%="receive".equals(isReceiveSMS)?" selected":"" %> value='receive'>Receive</option>
					<option <%="notReceive".equals(isReceiveSMS)?" selected":"" %> value='notReceive'>Not Receive</option>
				</select>					
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel" width="30%">SMS Type</td>
			<td class="infoData" width="70%">
				<select name='smcID'>
					<option></option>
					<option <%="rehab".equals(smcID)?" selected":"" %> value='rehab'>Rehab</option>					
					<option <%="9".equals(smcID)?" selected":"" %> value='9'>Food Service</option>
				</select>					
			</td>
		</tr>
		<tr class="smallText">
			<td colspan="2" align="center">
				<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
				<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
			</td>
		</tr>
	</table>
</form>

<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" style="font-size:16px;">
	<tr>
		<td>Next Sending SMS date : </td>
		<td><%=smf.format(currentCal.getTime())%></td>
	</tr>
	<tr>
		<td>Appointment date : </td>
		<td><%=smf.format(startCal.getTime())%></td>
	</tr>
</table>

<bean:define id="functionLabel">SMS List</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.sms_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable">	
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.patientNo" style="width:7%">
		<c:out value="${row.fields14}" /> 
	</display:column>
	<display:column titleKey="prompt.language" style="width:5%">
		<c:out value="${row.fields0}" /> 
	</display:column>
	<display:column titleKey="prompt.patName" style="width:7%">
		<c:out value="${row.fields1}" /> 
	</display:column>
	<display:column title="SMS Template" style="width:7%">
		<c:out value="${row.fields3}" /> 
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
	<display:column title="DR Display Name" style="width:7%">
		<c:out value="${row.fields17}" /> 
	</display:column>
	<display:column title="DR Eng Name" style="width:7%">
		<c:out value="${row.fields5}" /> 
	</display:column>
	<display:column title="DR Chi Name" style="width:7%">
		<c:out value="${row.fields6}" /> 
	</display:column>
	<display:column title="Booking Date" style="width:7%">
		<c:out value="${row.fields21}" /> 
	</display:column>
	<display:column title="Booking Status" style="width:5%">
		<c:out value="${row.fields23}" /> 
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}
</script>
</DIV>
</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>