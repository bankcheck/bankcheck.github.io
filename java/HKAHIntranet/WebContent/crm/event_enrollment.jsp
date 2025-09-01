<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String eventID = request.getParameter("eventID");
String scheduleID = request.getParameter("scheduleID");
String eventDescription = null;
String scheduleDescription = null;
String eventDate = null;
String classSize = null;
String classEnrolled = null;
String followup = request.getParameter("followup");

try {
	if (eventID != null && eventID.length() > 0) {
		ArrayList result = ScheduleDB.get("crm", eventID, scheduleID);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			eventDescription = reportableListObject.getValue(2);
			scheduleDescription = reportableListObject.getValue(3);
			eventDate = reportableListObject.getValue(4);
			classSize = reportableListObject.getValue(12);
			classEnrolled = reportableListObject.getValue(13);

			request.setAttribute("event_enrollment", EnrollmentDB.getEnrolledClass("crm", eventID, scheduleID, null, null, null,followup, null, null));
		}
	}
} catch (Exception e) {
	e.printStackTrace();
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
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.event.enrollment" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>




<bean:define id="functionLabel"><bean:message key="function.event.enrollment" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.eventDescription" /></td>
		<td class="infoData" width="70%"><%=eventDescription %><%=scheduleDescription==null||scheduleDescription.length()==0?"":" (" + scheduleDescription + ")" %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.eventDate" /></td>
		<td class="infoData" width="70%"><%=eventDate %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.enrolledNumber" /></td>
		<td class="infoData" width="70%"><%=classEnrolled %><%if (!"0".equals(classSize)) { %>/<%=classSize %><%} %></td>
	</tr>
</table>

<form name="search_form" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">follow up status</td>
		<td class="infoData" width="70%">
	<select name="followup">
	<option value="Y"<%="Y".equals(followup)?" selected":"" %>>Finish Followed Up</option>
	<option value="N"<%="N".equals(followup)?" selected":"" %>>Not Follow Up</option>
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



<form name="form1" action="event_enrollment.jsp" method="post">
<display:table id="row" name="requestScope.event_enrollment" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.name" style="width:15%">
		<logic:equal name="row" property="fields9" value="">
			<c:out value="${row.fields10}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields9" value="">
			<logic:equal name="row" property="fields10" value="">
				<c:out value="${row.fields9}" />
			</logic:equal>
			<logic:notEqual name="row" property="fields10" value="">
				<c:out value="${row.fields9}" />, <c:out value="${row.fields10}" />
			</logic:notEqual>
		</logic:notEqual>
	</display:column>
	<display:column property="fields11" titleKey="prompt.chineseName" style="width:15%" />
	<display:column property="fields12" titleKey="prompt.hkid" style="width:10%" />
	<display:column property="fields7" titleKey="prompt.enrolledNumber" style="width:15%; text-align:center"/>
	<display:column property="fields14" title="Remark" style="width:8%; text-align:center"/>
	<display:column titleKey="prompt.status" style="width:15%">
		<logic:equal name="row" property="fields6" value="1">
			<bean:message key="label.attend" /> at <c:out value="${row.fields5}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields6" value="1">
			<bean:message key="label.enrolled" />
		</logic:notEqual>
		<logic:equal name="row" property="fields13" value="N">
		 <br>(Not Follow Up)</br>
		</logic:equal>
		<logic:equal name="row" property="fields13" value="Y">
		 <br>(Finish Followed Up)</br>
		</logic:equal>

	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="submitAction('view', '<c:out value="${row.fields8}" />', '');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="command">
<input type="hidden" name="eventID" value="<%=eventID %>">
<input type="hidden" name="scheduleID" value="<%=scheduleID %>">
<input type="hidden" name="clientID">
<input type="hidden" name="enrollID">
</form>
<script language="javascript">
<!--
	function submitAction(cmd, cid, eid) {
		callPopUpWindow2("client_info.jsp?command=" + cmd + "&clientID=" + cid);
		return false;
	}
		function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.followup.value = "";
	}
	
-->
</script>


</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>