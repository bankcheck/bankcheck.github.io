<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%

UserBean userBean = new UserBean(request);
String command = request.getParameter("command");

String bookDate = request.getParameter("bookDate");
String timeslot = request.getParameter("timeslot");
String booknum = request.getParameter("booknum");

String memberID =  request.getParameter("memberID");
String name =  request.getParameter("name");
String gender =  request.getParameter("gender");
String trainer =  request.getParameter("trainer");
String remark =  request.getParameter("remark");

String subtitle = bookDate + " " + FitnessDB.getTimeRange(timeslot);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
String nextCommand = null;

try {
	if ("new".equals(command)) {
		nextCommand = "create";
	} else if ("edit".equals(command)){
		ArrayList record = FitnessDB.get(bookDate, timeslot, booknum);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			memberID = row.getValue(0);
			name = row.getValue(1);
			gender = row.getValue(2);
			trainer = row.getValue(3);
			remark = row.getValue(4);
		}
		nextCommand = "update";
	} else if ("update".equals(command)) {

		if (FitnessDB.update(userBean, bookDate, timeslot, booknum, memberID, name, gender, trainer, remark)) {
			message = "Booking updated";
		} else {
			errorMessage = "Update failed";
			nextCommand = "update";
		}

	} else if ("create".equals(command)){
		
		String debug = FitnessDB.reserve(userBean, memberID, bookDate, timeslot, name, gender, trainer, remark); 
		
		if ("success".equals(debug)) {
			message = "Booking created";
		} else if("exist".equals(debug)) {
			message = "Duplicate booking";
		} else {
			message = "Booking failed - " + debug;
		}
	} 
	
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/thickbox.css" />" media="screen" />
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.fitness.maintenance" />
	<jsp:param name="pageSubTitle" value="<%=subtitle %>" />
	<jsp:param name="pageMap" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" action="booking_entry.jsp" method="post">

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.memberNumber" /></td>
		<td class="infoData" width="80%">
			<input type="textfield" name="memberID" id="memberID" value="<%=memberID==null?"":memberID %>" maxlength="10" size="10" required />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.name" /></td>
		<td class="infoData" width="80%">
			<input type="textfield" name="name" id="name" value="<%=name==null?"":name %>" maxlength="100" size="100" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.sex" /></td>
		<td class="infoData" width="80%">
			<input type="textfield" name="gender" id="gender" value="<%=gender==null?"":gender %>" maxlength="1" size="1" />
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.trainer" /></td>
		<td class="infoData" width="80%">
			<input type="textfield" name="trainer" id="trainer" value="<%=trainer==null?"":trainer %>" maxlength="100" size="100" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.remarks" /></td>
		<td class="infoData" width="80%"><textarea name="remark" id="remark" maxlength="4000" rows="5" cols="100"><%=remark==null?"":remark %></textarea></td>
	</tr>		
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText"><td>
		<input type="hidden" name="command" id="command" value="<%=nextCommand %>"/>
		<input type="hidden" name="bookDate" id="bookDate" value="<%=bookDate %>"/>
		<input type="hidden" name="timeslot" id="timeslot" value="<%=timeslot %>"/>
		<input type="hidden" name="booknum" id="booknum" value="<%=booknum %>"/>
		
		<button type="submit"><bean:message key="button.save" /></button>
		<button type="reset"><bean:message key="button.reset" /></button>
		<button class="btn-click" onclick="return close_window()"><bean:message key="button.close" /></button>

	</td>
	</tr>
</table>
</div>

</form>
<script language="javascript">
<!--
<%
if ("create".equals(command)) {
%>
	$( document ).ready(function() {
		alert("<%=message %>");
		close_window();
	});
<%
}
%>
	function close_window() {
		opener.location.reload();
		window.close();
		return false;
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>