<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String bookDate = request.getParameter("bookDate");
String timeslot = request.getParameter("timeslot");
String booknum = request.getParameter("booknum");
String command = request.getParameter("command");
String message = request.getParameter("message");
String editable = request.getParameter("editable");

String subtitle = bookDate + " " + FitnessDB.getTimeRange(timeslot);
String available = FitnessDB.getAvailable(bookDate, timeslot);

if (message == null) {
	message = "";	
}
String errorMessage = "";

if ("delete".equals(command)){
	String debug = FitnessDB.cancelByBooknum(booknum, bookDate, timeslot);
	if ("success".equals(debug)) {
		message = "Booking deleted.";
	} else {
		errorMessage = "Deletion failed - " + debug;
	}
}

request.setAttribute("booking_list", FitnessDB.getBookingList(bookDate, timeslot));

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
	<jsp:param name="pageTitle" value="function.fitness.maintenance" />
	<jsp:param name="pageSubTitle" value="<%=subtitle %>" />
	<jsp:param name="pageMap" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<font color="green" class="bigText">Available: <%=available %></font>
<form name="form1" action="booking_list.jsp" method="post">
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="booking" /></bean:define>
<display:table id="row" name="requestScope.booking_list" export="true" pagesize="20" class="tablesorter">
	<display:column property="fields0" titleKey="prompt.key" style="width:7%" />
	<display:column property="fields1" titleKey="prompt.memberNumber" style="width:11%" />
	<display:column property="fields2" titleKey="prompt.name" style="width:20%" />
	<display:column property="fields3" titleKey="prompt.sex" style="width:7%" />
	<display:column property="fields4" titleKey="prompt.trainer" style="width:20%" />
	<display:column property="fields5" titleKey="prompt.remarks" style="width:18%" />
	<display:column titleKey="prompt.action" media="html" style="width:17%; text-align:center">
<%
	if ("1".equals(editable)) {
%>	
		<button onclick="return editAction('<c:out value="${row.fields0}" />');"><bean:message key='button.edit' /></button>
		<button onclick="return deleteAction('<c:out value="${row.fields0}" />');"><bean:message key='button.delete' /></button>
<%	
	}
%>			
	</display:column>
	
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<center>
	<input type="hidden" name="command" id="command"/>
	<input type="hidden" name="bookDate" id="bookDate" value="<%=bookDate %>"/>
	<input type="hidden" name="timeslot" id="timeslot" value="<%=timeslot %>"/>
	<input type="hidden" name="booknum" id="booknum"/>
<%
	if ("1".equals(editable)) {
%>
	<button class="btn-click" onclick="return createAction()"><bean:message key="button.add" /></button>
<%	
	}
%>			
	<button class="btn-click" onclick="return closeAction()"><bean:message key="button.close" /></button>
</center>	
</form>
<script language="javascript">
<!--	
	function deleteAction(booknum) {
		var confirm_del = confirm("Confirm to delete #" + booknum);
		
		if (confirm_del) {
			document.getElementById("command").value = "delete";
			document.getElementById("booknum").value = booknum;
			document.form1.submit();
		}
		
		return false;		
	}
	
	function editAction(booknum) {
		callPopUpWindow("booking_entry.jsp?command=edit&bookDate=<%=bookDate %>&timeslot=<%=timeslot %>&booknum=" + booknum);
		return false;
	}
	
	function createAction() {
<%		
		if ("0".equals(available)) {
%>			
			alert ("This session is full");
<%			
		} else {
%>
			callPopUpWindow("booking_entry.jsp?command=new&bookDate=<%=bookDate %>&timeslot=<%=timeslot %>");
<%
		}
%>
		return false;
	}
	
	function closeAction() {
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