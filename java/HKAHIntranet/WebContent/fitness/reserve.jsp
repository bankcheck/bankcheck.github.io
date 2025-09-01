<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%
UserBean userBean = new UserBean(request);
String staffID = userBean.getStaffID();
String bookDate = request.getParameter("bookDate");
String timeslot = request.getParameter("timeslot");

String message = FitnessDB.reserve(userBean, staffID, bookDate, timeslot, null, null, null, null); 

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
<body onload="changeReqNo('form_new')">
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Fitness Center Booking" />	
</jsp:include>
<br />
<center>
<%
if ("exist".equals(message)) {
%>
	<font color="blue" class="bigText">
		<%= MessageResources.getMessage(session, "message.booking.exist")%>
	</font>
	<br />
	<form name="form1" action="cancel.jsp" method="post">
		<input type="hidden" name="bookDate" value="<%=bookDate %>" />
		<input type="hidden" name="timeslot" value="<%=timeslot %>" />
		<button class="btn-click">Yes</button>
		<button class="btn-click" onclick="return close_window()">No</button>	
	</form>
<%} else { 
		if ("success".equals(message)) {
			message = MessageResources.getMessage(session, "message.booking.success");
		}
%>
	<font color="blue" class="bigText"><%=MessageResources.getMessage(session, message) %></font>
	<br />
	<button class="btn-click" onclick="return close_window()"><bean:message key="button.close" /></button>	
<%} %>
</center>	
<script language="javascript">
<!--
	function close_window() {
		opener.location.reload();
		window.close();
		return false;
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>