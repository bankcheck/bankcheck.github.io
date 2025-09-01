<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%
UserBean userBean = new UserBean(request);
String selectedStaffID = request.getParameter("staffID");

if (selectedStaffID == null) {
	selectedStaffID = userBean.getStaffID();
}

String selectYear = request.getParameter("select_year");
String selectMonth = request.getParameter("select_month");

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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%
	String title = "function.worksheet.entry";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="select_year" value="<%=selectYear %>" />
	<jsp:param name="select_month" value="<%=selectMonth %>" />	
</jsp:include>
<form name="form1" id="form1" action="task_summary.jsp" method="post">

<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
<%if (userBean.isAccessible("function.worksheet.maintenance")) { %>			
	
		<td class="infoLabel" width="30%">Staff</td>
		<td class="infoData" width="70%">
			<select name="staffID" id="staffID" onchange="changeStaff()">
<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=userBean.getDeptCode() %>" />
	<jsp:param name="value" value="<%=selectedStaffID %>" />
</jsp:include>
			</select>
		</td>
<%} %>		
	</tr>
</table>

<br/><br/>
<span id="calendar">
<jsp:include page="task_calendar.jsp" flush="false">
	<jsp:param name="staffID" value="<%=selectedStaffID %>" />
</jsp:include>
</span>
</form>
<script language="javascript">
<!--
	function taskEntry(staffID, taskDate) {
		callPopUpWindow("task_entry.jsp?staffID=" + staffID + "&taskDate="+taskDate);
	}
	
	function switchDate(year, month) {
		document.form1.select_year.value = year;
		document.form1.select_month.value = month;
		document.form1.submit();
		return true;
	}
	
	function changeStaff() {
		document.form1.submit();
		return false;
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>