<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String month_shortform[] = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" };

UserBean userBean = new UserBean(request);

String eventID_elearningID = request.getParameter("eventID-elearningID");
String reportCategory = request.getParameter("reportCategory");
//set default course category to [C]ompulsory
if (reportCategory == null) {
	reportCategory = "report1";
}
String searchType = request.getParameter("searchType");
String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");
String financialYear = request.getParameter("financialYear");

boolean isFinancialYear = false;
boolean showStaffDetail = userBean.isAccessible("function.staff.view");

// split eventID_elearningID
String eventID = null;
String elearningID = null;
try {
	String[] idArray = eventID_elearningID.split("-");
	eventID = idArray[0];
	elearningID = idArray[1];
} catch (Exception e) {
}

// set date range from financial year
String financialYearFrom = financialYear;
String financialYearTo = financialYear;
if ("financialYear".equals(searchType)) {
	try {
		financialYearFrom = String.valueOf(Integer.parseInt(financialYear) - 1);
	} catch (Exception e) {
	}
	date_from = "01/01/" + financialYearFrom;
	date_to = "01/01/" + financialYearTo;
	isFinancialYear = true;
}

// get data
try {
	// get report data
	ArrayList columnList = ELearning.getElearningTestReport(eventID, elearningID, reportCategory, date_from, date_to);
	ArrayList record_real = new ArrayList();
	ReportableListObject row = null;
	if (columnList.size() > 0) {
		for (int i = 0; i < columnList.size(); i++) {
			row = (ReportableListObject) columnList.get(i);
			
			record_real.add(row);
		}
	}
	request.setAttribute("record_list", record_real);
	
	// get test info
	columnList = ELearning.get(elearningID);
	ArrayList record_real2 = new ArrayList();
	if (columnList.size() > 0) {
		for (int i = 0; i < columnList.size(); i++) {
			row = (ReportableListObject) columnList.get(i);
			
			record_real2.add(row);
		}
	}
	request.setAttribute("record_list2", record_real2);
	
	// get participant info
	columnList = ELearning.getElearningTestEnrolledUser(eventID, elearningID, date_from, date_to);
	Set enrolledUser = new HashSet();
	if (columnList.size() > 0) {
		for (int i = 0; i < columnList.size(); i++) {
			row = (ReportableListObject) columnList.get(i);
			
			enrolledUser.add(row);
		}
	}	
	columnList = ELearning.getElearningTestEnrolledUniqueUser(eventID, elearningID, date_from, date_to);
	request.setAttribute("totalEnrollment", enrolledUser.size());
	request.setAttribute("numOfEnrolledUser", columnList == null ? 0 :columnList.size());
	
	int totalHitCount = 0;
	if ("report4".equals(reportCategory)) {
		totalHitCount = ELearning.getTotalHitCount(date_from, date_to);
		request.setAttribute("totalHitCount", totalHitCount);
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<bean:define id="functionLabel"><bean:message key="function.staffEducation.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>

<%
	if ("report4".equals(reportCategory)) {
%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
		<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.totalHitCount" /></td>
		<td class="infoData" width="70%">
			<c:out value="${totalHitCount}" />
		</td>
	</tr>
</table>
<%
	} else {
%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.totalNumberOfQuestions" /></td>
		<td class="infoData" width="70%">
			<c:out value="${record_list2[0].fields2}" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.passingScore" /></td>
		<td class="infoData" width="70%">
			<c:out value="${record_list2[0].fields3}" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.totalNumOfEnroll" /></td>
		<td class="infoData" width="70%">
			<c:out value="${totalEnrollment}" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.numOfUserEnroll" /></td>
		<td class="infoData" width="70%">
			<c:out value="${numOfEnrolledUser}" />
		</td>
	</tr>
</table>
<%
	}
%>

<display:table id="row" name="requestScope.record_list" export="true" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<% if ("report1".equals(reportCategory)) { %>
	<display:column property="fields0" title="Total Score" />
	<display:column property="fields1" title="No of User" />
	<% } else if ("report2".equals(reportCategory)) { %>
	<display:column property="fields0" title="Question ID" />
	<display:column property="fields1" title="Question" />
	<display:column property="fields2" title="No of Incorrect Answer" />
	<% } else if ("report3".equals(reportCategory)) { %>
	<display:column property="fields0" title="No of Attempt" />
	<display:column property="fields1" title="No of User" />
	<% } else if ("report4".equals(reportCategory)) { %>
	<display:column property="fields0" title="Hit Count" />
	<display:column property="fields1" title="No of User" />
	<% } %>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
