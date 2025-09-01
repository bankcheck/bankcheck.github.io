<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%
String category = "title.education";

HashMap statusDesc = new HashMap();
statusDesc.put("open", MessageResources.getMessage(session, "label.open"));
statusDesc.put("suspend", MessageResources.getMessage(session, "label.suspend"));
statusDesc.put("close", MessageResources.getMessage(session, "label.close"));
statusDesc.put("enrolled", MessageResources.getMessage(session, "label.enrolled"));

UserBean userBean = new UserBean(request);

String courseDesc = request.getParameter("courseDesc");
String courseCategory = request.getParameter("courseCategory");
// set default value
if (courseCategory == null) {
	courseCategory = "compulsory";
}
boolean isCompulsory = "compulsory".equals(courseCategory);
boolean isInservice = "inservice".equals(courseCategory);
boolean isOptional = "other".equals(courseCategory);
boolean isCNE = "CNE".equals(courseCategory);
boolean isFireDrill = "firedrill".equals(courseCategory);
boolean isTND = "tND".equals(courseCategory);
boolean isIntClass = "intClass".equals(courseCategory);
boolean isMockCode = "mockCode".equals(courseCategory);
boolean isMockDrill = "mockDrill".equals(courseCategory);
boolean isAll = "".equals(courseCategory);

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
String sortBy = request.getParameter("sortBy");
String ordering = request.getParameter("ordering");


String sortStr = "";
if(sortBy != null && sortBy.length() > 0 && ordering != null && ordering.length() > 0){
	sortStr = "Order By " + sortBy + " " + ordering + " ";	
}

request.setAttribute("class_schedule_list", ScheduleDB.getListByDateWithSorting("education", courseDesc, courseCategory, date_from, date_to, sortStr));

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
	<jsp:param name="pageTitle" value="function.classSchedule.list" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="class_schedule_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.courseDescription" /></td>
		<td class="infoData" width="70%"><input type="textfield" name="courseDesc" value="<%=courseDesc==null?"":courseDesc %>" maxlength="100" size="50"> (<bean:message key="prompt.optional" />)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.courseCategory" /></td>
		<td class="infoData" width="70%">
			<input type="radio" name="courseCategory" value="compulsory"<%=isCompulsory?" checked":"" %>><bean:message key="label.compulsory" />
			<input type="radio" name="courseCategory" value="inservice"<%=isInservice?" checked":"" %>><bean:message key="label.inservice" />
			<input type="radio" name="courseCategory" value="other"<%=isOptional?" checked":"" %>><bean:message key="label.optional" />
			<input type="radio" name="courseCategory" value="CNE"<%=isCNE?" checked":"" %>>CNE
			<input type="radio" name="courseCategory" value="tND"<%=isTND?" checked":"" %>>T&D
<%			if(ConstantsServerSide.isTWAH()){ %>		
				<input type="radio" name="courseCategory" value="firedrill"<%=isFireDrill?" checked":"" %>>Fire and Disaster Drills
				<input type="radio" name="courseCategory" value="" <%=isAll?" checked":"" %>>All
<%			} %>					
				
<%			if(ConstantsServerSide.isHKAH()){ %>
				<input type="radio" name="courseCategory" value="intClass"<%=isIntClass?" checked":"" %>>Interest Class / Other Activities
				<input type="radio" name="courseCategory" value="mockCode"<%=isMockCode?" checked":"" %>>Mock Code
				<input type="radio" name="courseCategory" value="mockDrill"<%=isMockDrill?" checked":"" %>>Drill
<%			} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" value="<%=date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			-
			<input type="textfield" name="date_to" id="date_to" value="<%=date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)<br>
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(1);"><bean:message key="label.today" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(2);"><bean:message key="label.thisMonth" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(3);" checked><bean:message key="label.thisYear" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel">Sort By</td>
		<td colspan="2" class="infoData" >
			<select name="sortBy">
				<option <%="CS.CO_SCHEDULE_START".equals(sortBy)?" selected":"" %> value="CS.CO_SCHEDULE_START">Date</option>
			</select>
			<select name="ordering">				
				<option <%="DESC".equals(ordering)?" selected":"" %> value="DESC">Decending</option>
				<option <%="ASC".equals(ordering)?" selected":"" %> value="ASC">Ascending</option>
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
<bean:define id="functionLabel"><bean:message key="function.classSchedule.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="class_schedule.jsp" method="post">
<display:table id="row" name="requestScope.class_schedule_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields3" titleKey="prompt.course" style="width:30%" />
	<display:column property="fields8" titleKey="prompt.classDate" style="width:15%" />
	<display:column titleKey="prompt.classTime" style="width:15%">
		<c:out value="${row.fields9}" /> - <c:out value="${row.fields10}" />
	</display:column>
	<c:set var="tempClassDate" value="${row.fields8}"/>
	<c:set var="tempClassTime" value="${row.fields9}"/>
<%

	String tempClassDate = (String)pageContext.getAttribute("tempClassDate");
	String tempClassTime = (String)pageContext.getAttribute("tempClassTime");
	Calendar today = Calendar.getInstance();
	Calendar enrollCutOffDate = null;
	boolean tempClose = false;
	DateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
	if(tempClassDate != null && tempClassDate.length() > 0){
		tempClassDate = tempClassDate + " " + tempClassTime;
		Date date = df.parse(tempClassDate);
		enrollCutOffDate = Calendar.getInstance();
		enrollCutOffDate.setTime(date);
	}
	if(ConstantsServerSide.isTWAH()){
		if(today.after(enrollCutOffDate)){
			tempClose = true;
		}
	}
%>	
	<display:column titleKey="prompt.status" style="width:10%">
<% 	if(tempClose){ %>
	<bean:message key="label.close" />
<%	}else{ %>
		<%=statusDesc.get(((ReportableListObject)pageContext.getAttribute("row")).getFields17()) %>
<%	} %>
	</display:column>
<%if(ConstantsServerSide.isTWAH()){ %>
	<display:column property="fields21" title="Lecturer" style="width:15%"/>
<%} %>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<% if (userBean.isAccessible("function.classSchedule.admin")) { %>
			<button onclick="return submitAction('view', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />');"><bean:message key="button.view" /></button>
		<% } else { %>
			N/A
		<% } %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '', '');"><bean:message key="function.classSchedule.create" /></button></td>
	</tr>
</table>
</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.courseDesc.value = '';
	}

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

	function submitAction(cmd, cid, sid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&courseID=" + cid + "&classID=" + sid);
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>