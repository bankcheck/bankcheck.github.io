<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);

String command = request.getParameter("command");
String step = request.getParameter("step");
String eventID = request.getParameter("eventID");
String scheduleID = request.getParameter("scheduleID");
String updateReviewno = request.getParameter("updateReviewno");
String updateReviewfield = request.getParameter("updateReviewfield");

String eventDesc = null;
String scheduleDate = null;
String scheduleSize = null;
String scheduleEnrolled = null;
String scheduleStatus = null;
boolean isOpen = false;
boolean isSuspend = false;
boolean isClosed = false;

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
String tabno = request.getParameter("tabno");
String remarkField = request.getParameter("remarkField");
String isFollowup = request.getParameter("isFollowup");
String RemarkValue = request.getParameter("RemarkValue");



boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean remarkAction = false;
boolean upremarkAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}else if ("subremark".equals(command)) {
	remarkAction = true;
}else if ("upremark".equals(command)){
	upremarkAction = true;
}

try {
	if ("1".equals(step)) {
		if (updateAction) {
			
			HashSet figureIDSet = (HashSet) session.getAttribute("crm.figureID");
			String figureID = null;
			String figureValue = null;
			boolean success = false;
			boolean follow_success = false;
			if(figureIDSet != null){
			for (Iterator i = figureIDSet.iterator(); i.hasNext(); ) {
				figureID = (String) i.next();
				figureValue = request.getParameter("figureID_" + figureID);
				if (!CRMClientPhysical.isExist(clientID, eventID, scheduleID, figureID)) {
					success = CRMClientPhysical.add(userBean, clientID, eventID, scheduleID, figureID, figureValue);
				} else {
					success = CRMClientPhysical.update(userBean, clientID, eventID, scheduleID, figureID, figureValue);
				}
			}
			}
			
			if(isFollowup != null)
			{
				follow_success = EnrollmentDB.updateFollowup(isFollowup,userBean.getUserName(),eventID,clientID,scheduleID);
			
			}
			
			if (success || follow_success) {
				message = "Event updated.";
			} else {
				errorMessage = "Event update fail.";
			}
			updateAction = false;
			command = "";
			step = "0";
		}
		else if (upremarkAction){
			String Remark = null;
			boolean update_success = false;
			
			Remark = request.getParameter("remark_input_" + updateReviewfield);
			update_success = EnrollmentDB.updateRemark(updateReviewno,Remark);
			
			if (update_success) {
				message = "Remark updated.";
			} else {
				errorMessage = "Remark update fail.";
			}
			
		}
		else if (remarkAction){
			boolean success = false;
			success = EnrollmentDB.addRemark(eventID,scheduleID,clientID,remarkField,userBean.getUserName());
			
			if(success){
				message = "remark added.";
			} else {
				errorMessage = "remark added fail.";
			}
			remarkAction = false;
			step = "0";
			
		}
	}

	// load data from database
	if (eventID != null && eventID.length() > 0) {
		ArrayList result = ScheduleDB.get("crm", eventID, scheduleID);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			eventDesc = reportableListObject.getValue(2);
			scheduleDate = reportableListObject.getValue(4);
			scheduleSize = reportableListObject.getValue(12);
			scheduleEnrolled = reportableListObject.getValue(13);
			scheduleStatus = reportableListObject.getValue(14);

			isOpen = "open".equals(scheduleStatus);
			isSuspend = "suspend".equals(scheduleStatus);
			isClosed = "close".equals(scheduleStatus);
			// set default value
			if (!isOpen && !isSuspend && !isClosed) {
				isOpen = true;
			}
		} else {
			closeAction = true;
		}
		RemarkValue = EnrollmentDB.getenrollRemark(eventID, clientID );
	} else {
		closeAction = true;
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
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.event." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="4" />
</jsp:include>
<bean:define id="functionLabel"><bean:message key="prompt.event" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="client_enrollment.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.event" /></td>
		<td class="infoData" width="70%"><%=eventDesc %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.eventDate" /></td>
		<td class="infoData" width="70%"><%=scheduleDate %>(DD/MM/YYYY)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.eventSize" /></td>
		<td class="infoData" width="70%"><%=scheduleSize %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.enrolledNumber" /></td>
		<td class="infoData" width="70%"><%=scheduleEnrolled %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="70%"><%if (isOpen) { %><bean:message key="label.open" /><%} else if (isSuspend) { %><bean:message key="label.suspend" /><%} else { %><bean:message key="label.close" /><%} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Event Remark</td>
		<td class="infoData" width="70%"><%=RemarkValue %></td>
	</tr>	
</table>
<div id="container-123">
	<ul id="tabList">
		<li><a href="javascript:changetab('tab1');" id="tab1"><span><bean:message key="prompt.physicalInfo" /></span></a></li>
		<li><a href="javascript:changetab('tab2');" id="tab2"><span><bean:message key="prompt.questionnaire" /></span></a></li>
    	<li><a href="javascript:changetab('tab3');" id="tab3"><span>Follow Up</span></a></li>
    </ul>
    <% %>
	<div id="fragment-1">
	
	</div>
</div>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%		if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.event.update" /></button>
			<button class="btn-delete"><bean:message key="function.event.delete" /></button>
<%		}  %>
			<button onclick="return submitAction('report', 0);" class="btn-click"><bean:message key="button.report" /> - <bean:message key="<%=title %>" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" value=""/>
<input type="hidden" name="step" />
<input type="hidden" name="eventID" value="<%=eventID %>" />
<input type="hidden" name="scheduleID" value="<%=scheduleID %>" />
<input type="hidden" name="tabno" value="<%=tabno %>">
<input type="hidden" name="isFollowup" value="<%=isFollowup %>">
<input type="hidden" name="updateReviewno" value="<%=updateReviewno %>">
<input type="hidden" name="updateReviewfield" value="<%=updateReviewfield %>">


</form>
<script language="javascript">
<!--
	var http = createRequestObject();

	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
	}

	function submitAction(cmd, stp) {
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}	
		function changetab(c) {		
		// reset tab
		document.getElementById('tab1').className = 'linkUnSelected';
		document.getElementById('tab2').className = 'linkUnSelected';
		document.getElementById('tab3').className = 'linkUnSelected';
		
		if (c == 'tab1') {
		document.getElementById('tab1').className = 'linkSelected';
	    http.open('post', 'client_enrollment_physical.jsp?eventID=<%=eventID%>&scheduleID=<%=scheduleID%>&clientID=<%=clientID%>&commandType=<%=command%>&tabno=<%=tabno%>');
		document.form1.tabno.value = c;		
		}
		else if (c == 'tab2') {
		document.getElementById('tab2').className = 'linkSelected';
		}
		else if (c == 'tab3'){
		 document.getElementById('tab3').className = 'linkSelected';
		  http.open('post', 'client_enrollment_followup.jsp?eventID=<%=eventID%>&scheduleID=<%=scheduleID%>&clientID=<%=clientID%>&commandType=<%=command%>&timestamp=<%=(new java.util.Date()).getTime() %>');
		  document.form1.tabno.value = c;
		 }
    	
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);
	}	
	function createremark(){
	
	document.getElementById('inputremark').style.display = "block";
	document.getElementById('remarkControl').style.display = "block";
	document.getElementById('remarkButton').style.display = "none";	
	document.getElementById("hasfollowup").disabled = "disabled";
	return false;
}
	function submitremark(){
	
	submitAction('subremark',1);
	return false;
	
	}
	function updateremark(Reviewno,fieldno){
	document.form1.updateReviewno.value = Reviewno;
	document.form1.updateReviewfield.value = fieldno;
	
	submitAction('upremark',1);
	return false;
	}
	
	
	function editRemark(field,recordnum){
	 document.getElementById('remark_show_'+ field).style.display = "none";
	 document.getElementById('remark_edit_'+ field).style.display = "block";
	 document.getElementById('remarkButton').style.display = "none";
	 document.getElementById("hasfollowup").disabled = "disabled";
	 for(i=0;i<recordnum;i++){
	 if(i!=field)
	 document.getElementById('remark_show_'+ i).style.display = "none";
	 }
	}
	
	function ongetFollowup(){
	
	var followup= document.getElementById("hasfollowup");

		if(followup.checked)
		{
		document.form1.isFollowup.value = followup.value;
		}
		else if(!followup.checked)
		{
		document.form1.isFollowup.value = 'N';
		}
	if(followup.checked)
	{
	document.form1.isFollowup.value = followup.value;
	}
	else if(!followup.checked)
	{
	document.form1.isFollowup.value = 'N';
	}

	return false;
	}
		function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			document.getElementById("fragment-1").innerHTML = http.responseText;
			
		}
	}
	
<% if (updateAction) {	%>
		changetab('<%=tabno %>');
<% } %>
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>