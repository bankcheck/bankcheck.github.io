<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);

String category = "title.education";
String courseCategory = request.getParameter("courseCategory");
boolean isCompulsory = "compulsory".equals(courseCategory);
boolean isInservice = "inservice".equals(courseCategory);
boolean isOptional = "other".equals(courseCategory);
boolean isCNE = "CNE".equals(courseCategory);
boolean isFireDrill = "firedrill".equals(courseCategory);
boolean isTND = "tND".equals(courseCategory);
boolean isIntClass = "intClass".equals(courseCategory);
boolean isMockCode = "mockCode".equals(courseCategory);
boolean isMockDrill = "mockDrill".equals(courseCategory);
boolean isVaccine = "vaccine".equals(courseCategory);

String[] current_year = DateTimeUtil.getCurrentYearRange();
String date_from = request.getParameter("date_from");
if (date_from == null || date_from.length() == 0) {
	date_from = DateTimeUtil.getRollDate(current_year[0], 0, 0, 0);
}
String date_to = request.getParameter("date_to");
if (date_to == null || date_to.length() == 0) {
	date_to = current_year[1];
}
String[] current_month = DateTimeUtil.getCurrentMonthRange();
String curent_date = DateTimeUtil.getCurrentDate();

if ("vaccine".equals(courseCategory)) {
	request.setAttribute("class_enrollment_list", ScheduleDB.getListByDate("vaccine", null, courseCategory, null, date_from, date_to, true));
} else {
	request.setAttribute("class_enrollment_list", ScheduleDB.getListByDate("education", null, courseCategory, "class", date_from, date_to, true));
}

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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
	<jsp:param name="pageTitle" value="function.classEnrollment.admin" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="class_enrollment_admin_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.courseCategory" /></td>
		<td class="infoData" width="70%">
			<input type="radio" name="courseCategory" value="" checked><bean:message key="label.all" />
			<input type="radio" name="courseCategory" value="compulsory"<%=isCompulsory?" checked":"" %>><bean:message key="label.compulsory" />
			<input type="radio" name="courseCategory" value="inservice"<%=isInservice?" checked":"" %>><bean:message key="label.inservice" />
			<input type="radio" name="courseCategory" value="other"<%=isOptional?" checked":"" %>><bean:message key="label.optional" />
			<input type="radio" name="courseCategory" value="CNE"<%=isCNE?" checked":"" %>>CNE
<%			if(ConstantsServerSide.isTWAH()){ %>	
				</br>	
				<input type="radio" name="courseCategory" value="firedrill"<%=isFireDrill?" checked":"" %>>Fire and Disaster Drills
<%			} %>					
				<input type="radio" name="courseCategory" value="tND"<%=isTND?" checked":"" %>>T&D
<%			if(ConstantsServerSide.isHKAH()){ %>
				<input type="radio" name="courseCategory" value="intClass"<%=isIntClass?" checked":"" %>>Interest Class / Other Activities
				<input type="radio" name="courseCategory" value="mockCode"<%=isMockCode?" checked":"" %>>Mock Code
				<input type="radio" name="courseCategory" value="mockDrill"<%=isMockDrill?" checked":"" %>>Drill
				<input type="radio" name="courseCategory" value="vaccine"<%=isVaccine?" checked":"" %>>Vaccination
<%			} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			-
			<input type="textfield" name="date_to" id="date_to" class="datepickerfield" value="<%=date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)<br>
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(1);"><bean:message key="label.today" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(2);"><bean:message key="label.thisMonth" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(3);" checked><bean:message key="label.thisYear" />
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="courseCategory" value="<%=courseCategory %>">
</form>
<bean:define id="functionLabel"><bean:message key="function.classEnrollment.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="class_enrollment_admin.jsp" method="post">
<display:table id="row" name="requestScope.class_enrollment_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.courseDescription" style="width:35%">
		<c:out value="${row.fields3}" />
		<logic:notEqual name="row" property="fields4" value="">
			(<c:out value="${row.fields4}" />)
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.classTime" style="width:20%">
		<logic:equal name="row" property="fields8" value="">
			N/A
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="">
			<c:out value="${row.fields8}" /> (<c:out value="${row.fields9}" /> - <c:out value="${row.fields10}" />)
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.available" style="width:10%">
		<logic:equal name="row" property="fields13" value="0">
			<c:out value="${row.fields14}" /> <bean:message key="label.enrolled" />
		</logic:equal>
		<logic:notEqual name="row" property="fields13" value="0">
			<c:out value="${row.fields15}" />/<c:out value="${row.fields13}" />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<logic:equal name="row" property="fields13" value="0">
			N/A
		</logic:equal>
		<logic:notEqual name="row" property="fields13" value="0">
			<% if(userBean.isLogin() && "3717".equals(userBean.getStaffID())){%>
			<button onclick="return submitAction('view', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />');"><bean:message key='button.view' /></button>
			<% }else if(userBean.isLogin() && (userBean.isAccessible("function.classEnrollment.admin.allowEnroll") || userBean.isGroupID("managerEducation") || userBean.isManager() || userBean.isAdmin())){%>
			<button onclick="return submitAction('view', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />');"><bean:message key='button.view' /></button>
			<button onclick="return submitAction('exportpdf', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />');">View Attendance Report</button>
			<%}else if (userBean.isLogin() && userBean.isGroupID("viewAttdPDF")) { %>
			<button onclick="return submitAction('exportpdf', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />');">View Attendance Report</button>
			<%}%>
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="eventID">
<input type="hidden" name="scheduleID">
<input type="hidden" name="courseCategory" value="<%=courseCategory %>">
</form>

<%if(ConstantsServerSide.isHKAH()){ %>
	<% if(userBean.isAdmin() || userBean.isGroupID("managerEducation")){ %>
<p align="center"><button onclick="return printSearch();">Export Registration Analysis Excel</button></p>
	<%} %>
<%} %>

<script language="javascript">
<!--
	function setDateRange(select) {
		if (select == 1) {
			document.search_form.date_from.value = '<%=curent_date %>';
			document.search_form.date_to.value = '<%=curent_date %>';
		} else if (select == 2) {
			document.search_form.date_from.value = '<%=current_month[0] %>';
			document.search_form.date_to.value = '<%=current_month[1] %>';
		} else if (select == 3) {
			document.search_form.date_from.value = '<%=current_year[0] %>';
			document.search_form.date_to.value = '<%=current_year[1] %>';
		}
	}

	function submitSearch(eid, sid) {
		document.search_form.action = "class_enrollment_admin_list.jsp";
		document.search_form.eventID = eid;
		document.search_form.scheduleID = sid;
		document.search_form.submit();
	}

	function clearSearch() {
	}
	
	function printSearch() {
		document.search_form.action = "education_analysis.jsp";
		document.search_form.submit();
	}

	function submitAction(cmd, eid, sid) {
		var courseCategory = document.form1.courseCategory.value;
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&eventID=" + eid + "&scheduleID=" + sid+"&courseCategory="+courseCategory);
		return false;
	}
-->
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>