<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>

<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String patNo = ParserUtil.getParameter(request, "patNo");
String lastName = ParserUtil.getParameter(request, "lastName");
String firstName = ParserUtil.getParameter(request, "firstName");
String dateOfBirth = ParserUtil.getParameter(request, "dateOfBirth");
String Phone = ParserUtil.getParameter(request, "Phone");
String Sex = ParserUtil.getParameter(request, "Sex");

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

if(patNo != null || dateOfBirth != null || lastName != null || firstName != null || Sex != null){
request.setAttribute("patient_list", AdmissionDB.getHATSPatientList(
		patNo, "", Phone, dateOfBirth, Sex,
		firstName.toUpperCase(), lastName.toUpperCase(),null,null, null));
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Patient List" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="search_form" action="patient_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
		<tr class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Patient Number: </td>
			<td class="infoData" width="70%"><input type="text" name="patNo" id="patNo" value="<%=patNo == null ? "" : patNo%>" maxlength="200" size="20" ></td>
		</tr>
		<tr class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Last Name: </td>
			<td class="infoData" width="70%"><input type="text" name="lastName" id="lastName" value="<%=lastName == null ? "" : lastName%>" maxlength="200" size="40" ></td>
		</tr>
		<tr class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">First Name: </td>
			<td class="infoData" width="70%"><input type="text" name="firstName" id="firstName" value="<%=firstName == null ? "" : firstName%>" maxlength="200" size="40" ></td>
		</tr>
			<tr class="smallText">
				<td class="infoLabel" width="30%">Sex</td>
				<td class="infoData" width="70%">
					<select name="Sex">
					<jsp:include page="../ui/sexCMB.jsp" flush="false">
					<jsp:param name="allowEmpty" value="Y" />
					</jsp:include>
					</select>
				</td>
			</tr>		
		<tr class="smallText">
			<td class="infoLabel" width="30%">Date of Birth: </td>
			<td class="infoData" width="70%"><input type="text" name="dateOfBirth" class="datepickerfield" value="<%=dateOfBirth == null ? "" : dateOfBirth%>" maxlength="10" size="10"></td>
		</tr>
		<tr class="smallText">
			<td colspan="2" align="center">
				<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
				<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
			</td>
	</tr>		
	</table>
</form>
<form name="form1" action="check_list.jsp" method="post">

<display:table id="row" name="requestScope.patient_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column title="Patient No" style="width:25%" media="html"><c:out value="${row.fields0}" /></display:column>
	<display:column titleKey="prompt.patientName" style="width:5%">
		<c:out value="${row.fields1}" /> <c:out value="${row.fields2}" />
	</display:column>
		<display:column titleKey="prompt.sex" style="width:15%">
		<logic:equal name="row" property="fields4" value="M">
			<bean:message key="label.male" />
		</logic:equal>
		<logic:equal name="row" property="fields4" value="F">
			<bean:message key="label.female" />
		</logic:equal>
	</display:column>
	<display:column property="fields5" titleKey="prompt.dateOfBirth" style="width:10%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields2}" />','<c:out value="${row.fields4}" />','<c:out value="${row.fields6}" />','<c:out value="${row.fields7}" />');"><bean:message key="button.view" /></button>
		<button onclick="return submitAction('doctor', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields2}" />','<c:out value="${row.fields4}" />','<c:out value="${row.fields6}" />','<c:out value="${row.fields7}" />');">Doctor View</button>
	</display:column>
</display:table>
</DIV>

</DIV>
</DIV>
<script>
function submitSearch() {
	
	document.search_form.submit();
}

function submitAction(cmd, cid, firstName,lastName,psex,ptel,pidno) {

	callPopUpWindow("bed_booking_7days_test.jsp?command=" + cmd + "&patNo=" + cid+"&patLastName="+lastName+"&patFirstName="+firstName+"&patSex="+psex+"&patTel="+ptel+"&patIDNo="+pidno);
	return false;
}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
