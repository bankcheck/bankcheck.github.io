<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	fileUpload = true;
}

HashMap<String, String> statusHashSet = OBBookingDB.getStatusSet(session);
String[] months = new String [] {
		MessageResources.getMessage(session, "label.january"),
		MessageResources.getMessage(session, "label.february"),
		MessageResources.getMessage(session, "label.march"),
		MessageResources.getMessage(session, "label.april"),
		MessageResources.getMessage(session, "label.may"),
		MessageResources.getMessage(session, "label.june"),
		MessageResources.getMessage(session, "label.july"),
		MessageResources.getMessage(session, "label.august"),
		MessageResources.getMessage(session, "label.september"),
		MessageResources.getMessage(session, "label.october"),
		MessageResources.getMessage(session, "label.november"),
		MessageResources.getMessage(session, "label.december") };

UserBean userBean = new UserBean(request);

// flag to show agree screen
String agree = ParserUtil.getParameter(request, "agree");
if ("Y".equals(agree)) {
	session.setAttribute("obbooking", "Y");
}

// check source
String source = ParserUtil.getParameter(request, "source");
String displayTitle = null;
boolean obbookingflag = "Y".equals(session.getAttribute("obbooking"));
boolean isDoctor = ("doctor".equals(source) || userBean.isDoctor()) && userBean.isAccessible("function.obbooking.doctor");
boolean isAdmin = "admin".equals(source) && userBean.isAccessible("function.obbooking.administration");
//boolean isOverride = userBean.isAccessible("function.obbooking.override");
boolean isOverride = isAdmin;

if (isDoctor) {
	displayTitle = "OB Booking List for Doctor";
} else if (isAdmin) {
	displayTitle = "OB Booking List for Administration";
} else {
	displayTitle = "OB Booking List for PBO";
}
String loginID = userBean.getLoginID();

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String obbookingID = ParserUtil.getParameter(request, "obbookingID");
String pbpID = ParserUtil.getParameter(request, "pbpID");
String doctorCode = ParserUtil.getParameter(request, "doctorCode");
String searchDoctorCode = ParserUtil.getParameter(request, "searchDoctorCode");
String doctorName = null;
String status = ParserUtil.getParameter(request, "status");
String edc = ParserUtil.getParameter(request, "edc");
int edcYearCurrent = DateTimeUtil.getCurrentYear();
int edcYear = 0;
try { edcYear = Integer.parseInt(ParserUtil.getParameter(request, "edcYear")); } catch (Exception e) {}
if (edcYear == 0) {
	edcYear = edcYearCurrent;
}
int edcMonth = 0;
try { edcMonth = Integer.parseInt(ParserUtil.getParameter(request, "edcMonth")); } catch (Exception e) {}
if (edcMonth == 0) {
	edcMonth = DateTimeUtil.getCurrentMonth();
}
String edcFrom = "01/" + ((edcMonth < 10 ? "0" : "") + edcMonth) + "/" + edcYear;
String edcTo = null;
if (edcMonth == 12) {
	edcTo = "31/12/" + edcYear;
} else {
	edcTo = DateTimeUtil.getRollDate("01/" + (((edcMonth + 1) < 10 ? "0" : "") + (edcMonth + 1)) + "/" + edcYear, -1, 0, 0);
}
String reason = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "reason"));

boolean quotaAction = false;
boolean cancelAction = false;
boolean cancelBookingAction = false;

if ("quota".equals(command)) {
	quotaAction = true;
} else if ("cancel".equals(command)) {
	cancelAction = true;
} else if ("cancelBooking".equals(command)) {
	cancelBookingAction = true;
}

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

int monthMLRemindQuota = 0;
int monthHKRemindQuota = 0;
int monthMLQuota = 0;
int monthHKQuota = 0;
boolean switchQuota = false;

// deafult doctor name
if (isDoctor) {
	if (userBean.isDoctor()) {
		if (userBean.getStaffID() != null && userBean.getStaffID().indexOf("DR") == 0) {
			doctorCode = userBean.getStaffID().substring(2);
		} else {
			doctorCode = userBean.getStaffID();
		}
		doctorName = userBean.getUserName();
	} else {
		// default user
		doctorCode = "";
		doctorName = "";
	}
}

ArrayList<ReportableListObject> record = null;
ReportableListObject row2 = null;

if (quotaAction) {
	// make booking
	record = OBBookingDB.makeBooking(userBean, obbookingID, isOverride);
	if (record.size() > 0) {
		row2 = record.get(0);
		status = row2.getValue(0);
		errorMessage = row2.getValue(1);

		if ("B".equals(status)) {
			message = "Please notify patient to pay deposit with 2 weeks from the confirmation date.";
			errorMessage = null;
		}
	} else {
		errorMessage = "ob booking is fail to switch";
	}
} else if (cancelAction) {
	// cancel booking
	record = OBBookingDB.cancelBooking(userBean, pbpID, reason);
	if (record.size() > 0) {
		row2 = record.get(0);
		obbookingID = row2.getValue(0);
		status = row2.getValue(1);
		errorMessage = row2.getValue(2);

		if ("X".equals(status)) {
			message = "ob booking is cancelled.";
			if ("Others".equals(response)) {
				message += " Please contact HKAH !V Patient Business Department at 3651-8900 for enquiry";
			} else {
				message += " Please issue document as attachment for refund";
			}
			errorMessage = null;
		}
	} else {
		errorMessage = "ob booking is fail to cancel";
	}
} else if (cancelBookingAction) {
	// cancel booking
	if (OBBookingDB.updateStatus(userBean, obbookingID, "X")) {
		message = "ob booking is cancelled";
	} else {
		errorMessage = "ob booking is fail to cancel";
	}
}

if (doctorCode != null && doctorCode.length() > 0) {
	record = OBBookingDB.getQuota(doctorCode, edcFrom);
	if (record.size() > 0) {
		row2 = record.get(0);
		try { monthMLRemindQuota = Integer.parseInt(row2.getValue(3)); } catch (Exception e) {};
		try { monthHKRemindQuota = Integer.parseInt(row2.getValue(6)); } catch (Exception e) {};
		try { monthMLQuota = Integer.parseInt(row2.getValue(11)); } catch (Exception e) {};
		try { monthHKQuota = Integer.parseInt(row2.getValue(12)); } catch (Exception e) {};
	}
}

switchQuota = isAdmin || (isDoctor && (monthMLRemindQuota > 0 || monthHKRemindQuota > 0));
ReportableListObject dummyLine = new ReportableListObject(13);
ReportableListObject tentativeLine = new ReportableListObject(13);
tentativeLine.setValue(8, "[Tentative Hold]");

ArrayList<ReportableListObject> list1a = OBBookingDB.getList(edcFrom, edcTo, doctorCode, "HK", "B");
ArrayList<ReportableListObject> list1b = OBBookingDB.getList(edcFrom, edcTo, doctorCode, "ML", "B");

for (int i = 0; i < monthHKRemindQuota ; i++) {
	list1a.add(dummyLine);
}
for (int i = 0; i < monthMLRemindQuota; i++) {
	list1b.add(dummyLine);
}

request.setAttribute("obbooking_list1a", list1a);
request.setAttribute("obbooking_list1b", list1b);
request.setAttribute("obbooking_list2", OBBookingDB.getList(edcFrom, edcTo, doctorCode, "ALL", "T"));
request.setAttribute("obbooking_list3", OBBookingDB.getList(edcFrom, edcTo, doctorCode, "ALL", "W"));
request.setAttribute("obbooking_list4", OBBookingDB.getList(edcFrom, edcTo, doctorCode, "ALL", "X"));

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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<%if (!obbookingflag && isDoctor) { %>
<script type="text/javascript">location.href = "ob_booking_intro.jsp?source=<%=source %>";</script>
<%} else { %>
<body>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.obbooking.list" />
	<jsp:param name="displayTitle" value="<%=displayTitle %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="search_form" action="ob_booking_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Doctor</td>
		<td class="infoData" width="70%">
			<select name="doctorCode"<%if (!isDoctor) { %> onChange="return refreshDoctorCodeList(this);"<%} %>>
<%	if (isDoctor) { %>
				<option value="<%=doctorCode %>"><%=doctorName %> (<%=doctorCode %>)</option>
<%	} else { %>
				<option value="">All Doctors</option>
<jsp:include page="../ui/docCodeCMB.jsp" flush="false">
	<jsp:param name="selectFrom" value="obbooking" />
	<jsp:param name="doccode" value="<%=doctorCode %>" />
</jsp:include>
<%	} %>
			</select>
<%	if (!isDoctor) { %>
			<br/><input type="textfield" name="searchDoctorCode" value="<%=searchDoctorCode==null?"":searchDoctorCode %>" maxlength="10" size="10" onblur="return refreshDoctorCodeType(this);"/>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">EDC</td>
		<td class="infoData" width="70%">
			<select name="edcYear">
				<option value="<%=edcYearCurrent - 1 %>"<%=edcYearCurrent - 1 == edcYear?" selected":"" %>><%=edcYearCurrent - 1 %></option>
				<option value="<%=edcYearCurrent %>"<%=edcYearCurrent == edcYear?" selected":"" %>><%=edcYearCurrent %></option>
				<option value="<%=edcYearCurrent + 1 %>"<%=edcYearCurrent + 1 == edcYear?" selected":"" %>><%=edcYearCurrent + 1%></option>
			</select>
			<select name="edcMonth">
<%	for (int i = 0; i < 12; i++) { %>
				<option value="<%=i + 1 %>"<%=i + 1 == edcMonth?" selected":"" %>><%=months[i] %></option>
<%	} %>
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
<bean:define id="functionLabel"><bean:message key="function.obbooking.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" width="100%">
<%	if (!isDoctor && doctorCode != null && doctorCode.length() > 0) { %>
	<tr class="smallText">
		<td class="infoSubTitle8">Remain Quota (Local : <%=monthHKRemindQuota %>), (Mainland: <%=monthMLRemindQuota %>)</td>
	</tr>
<%	} %>
<%	if (isDoctor || isAdmin) { %>
	<tr class="smallText">
		<td class="infoSubTitle3">Confirmed Booking (Local, Expatriate)</td>
	</tr>
	<tr class="smallText">
		<td>
<display:table id="row" name="requestScope.obbooking_list1a" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields2" title="EDC" style="width:10%"/>
<%		if (doctorCode == null) { %>
	<display:column titleKey="prompt.doctor.ob" style="width:15%">
		<c:out value="${row.fields3}" />
		<logic:notEqual name="row" property="fields4" value="">(<c:out value="${row.fields4}" />)</logic:notEqual>
	</display:column>
<%		} %>
	<display:column titleKey="prompt.patientName" style="width:15%">
		<logic:notEqual name="row" property="fields2" value="">
			<c:out value="${row.fields5}" />
		</logic:notEqual>
<%		if (obbookingID != null && obbookingID.length() > 0) { %>
		<logic:equal name="row" property="fields1" value="<%=obbookingID %>"><img src="../images/title_arrow.gif"></logic:equal>
<%		} %>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<logic:notEqual name="row" property="fields0" value="">
			<span id="change_action<c:out value="${row.fields0}" />">
				<button onclick="return submitAction('viewHATS', '0', '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.view" /></button>
<%		if (isAdmin) { %>
				<button onclick="return submitAction('cancel', '0', '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} else { %>
			<logic:equal name="row" property="fields7" value="">
				<button onclick="return submitAction('cancel', '0', '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.cancel" /></button>
			</logic:equal>
<%		} %>
			</span>
		</logic:notEqual>
	</display:column>
	<display:column title="Paid" style="width:5%">
		<logic:notEqual name="row" property="fields0" value="">
			<logic:equal name="row" property="fields7" value="">No</logic:equal>
			<logic:notEqual name="row" property="fields7" value="">Yes</logic:notEqual>
		</logic:notEqual>
	</display:column>
<%		if (!isDoctor) { %>
	<display:column property="fields8" title="Remarks" style="width:15%" />
<%		} %>
	<display:column property="fields10" titleKey="prompt.modifiedBy" style="width:10%" />
	<display:column property="fields11" titleKey="prompt.modifiedDate" style="width:10%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle3">Confirmed Booking (Mainland)</td>
	</tr>
	<tr class="smallText">
		<td>
<display:table id="row" name="requestScope.obbooking_list1b" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields2" title="EDC" style="width:10%"/>
<%		if (doctorCode == null) { %>
	<display:column titleKey="prompt.doctor.ob" style="width:15%">
		<c:out value="${row.fields3}" />
		<logic:notEqual name="row" property="fields4" value="">(<c:out value="${row.fields4}" />)</logic:notEqual>
	</display:column>
<%		} %>
	<display:column titleKey="prompt.patientName" style="width:15%">
		<logic:notEqual name="row" property="fields2" value="">
			<c:out value="${row.fields5}" />
		</logic:notEqual>
<%		if (obbookingID != null && obbookingID.length() > 0) { %>
		<logic:equal name="row" property="fields1" value="<%=obbookingID %>"><img src="../images/title_arrow.gif"></logic:equal>
<%		} %>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<logic:notEqual name="row" property="fields0" value="">
			<span id="change_action<c:out value="${row.fields0}" />">
				<button onclick="return submitAction('viewHATS', '0', '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.view" /></button>
<%		if (isAdmin) { %>
				<button onclick="return submitAction('cancel', '0', '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} else { %>
			<logic:equal name="row" property="fields7" value="">
				<button onclick="return submitAction('cancel', '0', '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.cancel" /></button>
			</logic:equal>
<%		} %>
			</span>
		</logic:notEqual>
	</display:column>
	<display:column title="Paid" style="width:5%">
		<logic:notEqual name="row" property="fields0" value="">
			<logic:equal name="row" property="fields7" value="">No</logic:equal>
			<logic:notEqual name="row" property="fields7" value="">Yes</logic:notEqual>
		</logic:notEqual>
	</display:column>
<%		if (!isDoctor) { %>
	<display:column property="fields8" title="Remarks" style="width:15%" />
<%		} %>
	<display:column property="fields10" titleKey="prompt.modifiedBy" style="width:10%" />
	<display:column property="fields11" titleKey="prompt.modifiedDate" style="width:10%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
		</td>
	</tr>
<%	} %>


<% 
//Comment out Tentative Booking
if(false == true) { %>
	<tr class="smallText">
		<td class="infoSubTitle9">Tentative Booking (with OPD Appointment)</td>
	</tr>
	<tr class="smallText">
		<td>
<display:table id="row" name="requestScope.obbooking_list2" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields2" title="EDC" style="width:10%"/>
<%	if (doctorCode == null) { %>
	<display:column titleKey="prompt.doctor.ob" style="width:20%">
		<c:out value="${row.fields3}" />
		<logic:notEqual name="row" property="fields4" value="">(<c:out value="${row.fields4}" />)</logic:notEqual>
	</display:column>
<%	} %>
	<display:column titleKey="prompt.patientName" style="width:20%">
		<c:out value="${row.fields5}" />
		<logic:equal name="row" property="fields6" value="1"><font color="green">(Mainland)</font></logic:equal>
<%	if (obbookingID != null && obbookingID.length() > 0) { %>
		<logic:equal name="row" property="fields1" value="<%=obbookingID %>"><img src="../images/title_arrow.gif"></logic:equal>
<%	} %>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<!--button onclick="return submitAction('view', '1', '<c:out value="${row.fields1}" />');" class="btn-click"><bean:message key="button.view" /></button-->
		<button onclick="return submitAction('cancelBooking', '1', '<c:out value="${row.fields1}" />');" class="btn-click">Cancel Hold</button>
<%		if (switchQuota) { %>
		<button onclick="return submitAction('quota', '1', '<c:out value="${row.fields1}" />');" class="btn-click">Switch to Confirm</button>
<%		} %>
	</display:column>
	<display:column property="fields12" titleKey="prompt.expiryDate" style="width:10%" />
	<display:column property="fields10" titleKey="prompt.modifiedBy" style="width:10%" />
	<display:column property="fields11" titleKey="prompt.modifiedDate" style="width:10%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
		</td>
	</tr>
<% } %>

<%	
//Comment out Waiting List
if (/*isDoctor || isAdmin*/ true == false) { %>

	<tr class="smallText">
		<td class="infoSubTitle2">Waiting List</td>
	</tr>
	<tr class="smallText">
		<td>
<display:table id="row" name="requestScope.obbooking_list3" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields2" title="EDC" style="width:10%"/>
<%	if (doctorCode == null) { %>
	<display:column titleKey="prompt.doctor.ob" style="width:20%">
		<c:out value="${row.fields3}" />
		<logic:notEqual name="row" property="fields4" value="">(<c:out value="${row.fields4}" />)</logic:notEqual>
	</display:column>
<%	} %>
	<display:column titleKey="prompt.patientName" style="width:20%">
		<c:out value="${row.fields5}" />
		<logic:equal name="row" property="fields6" value="1"><font color="green">(Mainland)</font></logic:equal>
<%	if (obbookingID != null && obbookingID.length() > 0) { %>
		<logic:equal name="row" property="fields1" value="<%=obbookingID %>"><img src="../images/title_arrow.gif"></logic:equal>
<%	} %>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<button onclick="return submitAction('view', '1', '<c:out value="${row.fields1}" />');" class="btn-click"><bean:message key="button.view" /></button>
<%		if (isAdmin) { %>
		<button onclick="return submitAction('cancelBooking', '1', '<c:out value="${row.fields1}" />');" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} %>
<%		if (switchQuota) { %>
		<button onclick="return submitAction('quota', '1', '<c:out value="${row.fields1}" />');" class="btn-click">Switch to Confirm</button>
<%		} %>
	</display:column>
	<display:column property="fields10" titleKey="prompt.modifiedBy" style="width:15%" />
	<display:column property="fields11" titleKey="prompt.modifiedDate" style="width:15%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
		</td>
	</tr>
	<%} %>
	
	
	<%if (isDoctor || isAdmin) { %>
	<tr class="smallText">
		<td class="infoSubTitle1">Cancellation</td>
	</tr>
	<tr class="smallText">
		<td>
<display:table id="row" name="requestScope.obbooking_list4" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields2" title="EDC" style="width:10%"/>
<%	if (doctorCode == null) { %>
	<display:column titleKey="prompt.doctor.ob" style="width:20%">
		<c:out value="${row.fields3}" />
		<logic:notEqual name="row" property="fields4" value="">(<c:out value="${row.fields4}" />)</logic:notEqual>
	</display:column>
<%	} %>
	<display:column titleKey="prompt.patientName" style="width:20%">
		<c:out value="${row.fields5}" />
		<logic:equal name="row" property="fields6" value="1"><font color="green">(Mainland)</font></logic:equal>
<%	if (obbookingID != null && obbookingID.length() > 0) { %>
		<logic:equal name="row" property="fields1" value="<%=obbookingID %>"><img src="../images/title_arrow.gif"></logic:equal>
<%	} %>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<button onclick="return submitAction('view', '1', '<c:out value="${row.fields1}" />');" class="btn-click"><bean:message key="button.view" /></button>
<%		if (switchQuota) { %>
		<button onclick="return submitAction('quota', '1', '<c:out value="${row.fields1}" />');" class="btn-click">Switch to Confirm</button>
<%		} %>
	</display:column>
	<display:column property="fields10" titleKey="prompt.modifiedBy" style="width:15%" />
	<display:column property="fields11" titleKey="prompt.modifiedDate" style="width:15%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
		</td>
	</tr>
<%	} %>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (isDoctor || isAdmin) { %>
			<button onclick="return submitAction('create', '', '');"><bean:message key="function.obbooking.create" /></button>
<%	} else { %>
			<button onclick="return submitAction('appointment', '', '');">Create Tentative Appointment</button>
<%	} %>
		</td>
	</tr>
</table>
<input type="hidden" name="command">
<input type="hidden" name="obbookingID">
<input type="hidden" name="pbpID">
<input type="hidden" name="source" value="<%=source %>">
</form>
<script language="javascript">
	var preActionHtml;
	var preebid;

	function submitSearch() {
		document.search_form.submit();
		return true;
	}

	function clearSearch() {
		return false;
	}

	function refreshDoctorCodeList(obj) {
		document.search_form.searchDoctorCode.value = obj.value;
		return false;
	}

	function refreshDoctorCodeType(obj) {
		document.search_form.doctorCode.value = obj.value;
		return false;
	}

	function submitAction(cmd, stp, ebid) {
		if (cmd == 'quota' || cmd == 'cancelBooking') {
			document.search_form.command.value = cmd;
			document.search_form.obbookingID.value = ebid;
			document.search_form.submit();
		} else if (cmd == 'cancel') {
			if (stp == 1) {
				document.search_form.command.value = cmd;
				document.search_form.pbpID.value = ebid;
				document.search_form.submit();
			} else {
				if (preebid != '') {
					$('#change_action'+preebid).html(preActionHtml);
				}
				if (ebid != '') {
					preActionHtml = document.getElementById('change_action'+ebid).innerHTML;
					preebid = ebid;
					$('#change_action'+ebid).load("ob_booking_cancel.jsp?obbookingID=" + ebid, new Date());
					$('#editDialog').dialog('open');
				}
			}
		} else if (cmd == 'appointment') {
			callPopUpWindow("../common/gwt2hats.jsp?moduleCode=doctor.appointment");
		} else if (cmd == 'viewHATS') {
			callPopUpWindow("../hat/ob_booking.jsp?source=<%=source %>&command=" + cmd + "&pbpID=" + ebid + "&doctorCode=" + document.search_form.doctorCode.value);
		} else {
			callPopUpWindow("../hat/ob_booking.jsp?source=<%=source %>&command=" + cmd + "&obbookingID=" + ebid + "&doctorCode=" + document.search_form.doctorCode.value);
		}
		return false;
	}
</script>
</div>
</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>