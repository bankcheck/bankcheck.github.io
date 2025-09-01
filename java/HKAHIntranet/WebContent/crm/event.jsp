<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.config.*"%>

<%!
public static ArrayList getCampaign(){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT CRM_CAMPAIGN_ID, CRM_CAMPAIGN_DESC, CRM_ENABLED ");
	sqlStr.append("FROM CRM_CAMPAIGN ");
	//sqlStr.append("WHERE CRM_ENABLED = 1 ");
	sqlStr.append("ORDER BY CRM_CAMPAIGN_DESC");
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
public static Boolean update(String eventID, String campaign){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("Update CO_EVENT ");
	sqlStr.append("SET CRM_CAMPAIGN_ID = '" + campaign +"' ");
	sqlStr.append("WHERE CO_EVENT_ID = '" + eventID + "' ");
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}
public static ArrayList get(String eventID){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT CRM_CAMPAIGN_ID ");
	sqlStr.append("FROM CO_EVENT ");
	sqlStr.append("WHERE CO_EVENT_ID = '" + eventID + "' ");
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();

String command = request.getParameter("command");
String step = request.getParameter("step");
String eventID = request.getParameter("eventID");
String eventDesc = TextUtil.parseStrUTF8(request.getParameter("eventDesc"));
String eventCategory = request.getParameter("eventCategory");
String eventType = request.getParameter("eventType");
String eventType2 = request.getParameter("eventType2");
String scheduleID = request.getParameter("scheduleID");
String scheduleDate = request.getParameter("scheduleDate");
String locationID = request.getParameter("locationID");
String locationDescription = null;
String scheduleSize = request.getParameter("scheduleSize");
String scheduleEnrolled = "0";
String scheduleStatus = request.getParameter("scheduleStatus");
String[] figureID = request.getParameterValues("figureID");

String campaign = request.getParameter("campaign");
ArrayList campaignID  = new ArrayList();
ArrayList campaignDesc = new ArrayList();
ArrayList campaignActive = new ArrayList();

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
		Date dateTime = null;
		if ((createAction || updateAction) && (scheduleDate == null || scheduleDate.length() == 0)) {
			errorMessage = "Invalid class date.";
		} else if ((createAction || updateAction) && (scheduleSize == null || scheduleSize.length() == 0 || !TextUtil.isNumber(scheduleSize))) {
			errorMessage = "Invalid size.";
		} else {
			String newScheduleDate = scheduleDate + " 00:00:00";
			if (createAction) {
				eventID = EventDB.add(userBean, "crm", null, eventCategory, eventType, eventType2, eventDesc, null);
				//update campaign id 
				update(eventID, campaign);
				scheduleID = ScheduleDB.add(userBean, "crm", eventID, null, newScheduleDate, newScheduleDate, ConstantsVariable.ZERO_VALUE, locationID, null, null, scheduleSize, scheduleStatus);
				if (scheduleID != null) {
					message = MessageResources.getMessage(session, "message.seminar.createSuccess");
					createAction = false;
				} else {
					errorMessage = MessageResources.getMessage(session, "error.seminar.createFail");
				}
			} else if (updateAction) {
				if (ScheduleDB.update(userBean, "crm", eventID, scheduleID, null, newScheduleDate, newScheduleDate, ConstantsVariable.ZERO_VALUE, locationID, null, null, scheduleSize, scheduleStatus,null)) {
					// update event
					EventDB.update(userBean, "crm", eventID, null, eventCategory, eventType, eventType2, eventDesc, null);
					//update campaign id 
					update(eventID, campaign);
					// update physical
					//CRMSchedulePhysical.update(userBean, eventID, scheduleID, figureID);

					message = MessageResources.getMessage(session, "message.seminar.updateSuccess");
					updateAction = false;
				} else {
					errorMessage = MessageResources.getMessage(session, "error.seminar.updateFail");
				}
			} else if (deleteAction) {
				if (ScheduleDB.delete(userBean, "crm", eventID, scheduleID)) {
					
					// update physical flag
					//CRMSchedulePhysical.delete(userBean, eventID, scheduleID);

					message = MessageResources.getMessage(session, "message.seminar.deleteSuccess");
					closeAction = true;
				} else {
					errorMessage = MessageResources.getMessage(session, "error.seminar.deleteFail");
				}
			}
		}
		step = null;
	} else if (createAction) {
		eventID = "";
		eventDesc = "";
		eventCategory = "foundation";
		eventType = "seminar";
		scheduleID = "";
		scheduleDate = DateTimeUtil.getCurrentDate();
		scheduleSize = "0";
		scheduleEnrolled = "0";
		scheduleStatus = "";
		campaign = "";
	}

	ArrayList record = getCampaign();

	if(record.size()>0){
		for (int i=0; i<record.size();i++){
			ReportableListObject row1 = (ReportableListObject) record.get(i);
			campaignID.add(row1.getValue(0));
			campaignDesc.add(row1.getValue(1));
			campaignActive.add(row1.getValue(2));
		}
		
	}
	
	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (eventID != null && eventID.length() > 0) {
			ArrayList result = EventDB.get("crm", eventID);
			if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				eventDesc = reportableListObject.getValue(1);
				eventCategory = reportableListObject.getValue(2);
				eventType = reportableListObject.getValue(3);
				eventType2 = reportableListObject.getValue(4);

				result = ScheduleDB.get("crm", eventID, scheduleID);
				if (result.size() > 0) {
					reportableListObject = (ReportableListObject) result.get(0);
					scheduleDate = reportableListObject.getValue(4);
					locationID = reportableListObject.getValue(8);
					if (reportableListObject.getValue(9) != null) {
						locationDescription = reportableListObject.getValue(9);
					} else {
						locationDescription = reportableListObject.getValue(10);
					}
					scheduleSize = reportableListObject.getValue(12);
					scheduleEnrolled = reportableListObject.getValue(13);
					scheduleStatus = reportableListObject.getValue(14);
				}
				
				result = get(eventID);
				if (result.size() > 0) {
					reportableListObject = (ReportableListObject) result.get(0);
					campaign = reportableListObject.getValue(0);
				}
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
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
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
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
<form name="form1" action="event.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Campaign</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<select id="campaignID" name="campaignID">
				<option value=""></option>
<% for(int c=0;c<campaignID.size();c++){%>
	<%if("1".equals(campaignActive.get(c))){ %>
				<option <%=((campaign.equals(campaignID.get(c)))?"selected":"") %>  value="<%=campaignID.get(c) %>"><%=campaignDesc.get(c) %></option>
	<%}else if(campaign.equals(campaignID.get(c))){ %>
				<option <%=((campaign.equals(campaignID.get(c)))?"selected":"") %> disabled value="<%=campaignID.get(c) %>"><%=campaignDesc.get(c) %></option>
	<%}else{} %>
<%} %>
			</select>
			<input type="hidden" id="campaign" name="campaign" value="<%=campaign==null?"":campaign%>"  maxlength="30" size="25"/>
<%	} else { %>
			<%int index = campaignID.indexOf( campaign ); %>
			<%=campaignDesc.get(index) %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.event" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<input type="textfield" name="eventDesc" value="<%=eventDesc %>" maxlength="100" size="50">
<%	} else {%>
			<%=eventDesc %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.eventDate" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<input type="textfield" name="scheduleDate" id="scheduleDate" class="datepickerfield" value="<%=scheduleDate %>" maxlength="10" size="9" onkeyup="validDate(this)" onblur="validDate(this)">
<%	} else {%>
			<%=scheduleDate %>
<%	} %>
		(DD/MM/YYYY)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<input type="radio" name="eventCategory" value="lmc"<%="lmc".equals(eventCategory)?" checked":"" %>><bean:message key="department.520" />
			<input type="radio" name="eventCategory" value="marketing"<%="marketing".equals(eventCategory)?" checked":"" %>><bean:message key="department.750" />
			<input type="radio" name="eventCategory" value="chaplaincy"<%="chaplaincy".equals(eventCategory)?" checked":"" %>><bean:message key="department.660" />
			<input type="radio" name="eventCategory" value="foundation"<%="foundation".equals(eventCategory)?" checked":"" %>><bean:message key="department.670" />
<%	} else {
			if ("lmc".equals(eventCategory)) {
				%><bean:message key="department.520" /><%
			} else if ("marketing".equals(eventCategory)) {
				%><bean:message key="department.750" /><%
			} else if ("chaplaincy".equals(eventCategory)) {
				%><bean:message key="department.660" /><%
			} else if ("foundation".equals(eventCategory)) {
				%><bean:message key="department.670" /><%
			}
	} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.eventType" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<select name="eventType" onchange="return updateEventType('');">
<jsp:include page="../ui/eventTypeCMB.jsp" flush="false">
	<jsp:param name="level" value="1" />
	<jsp:param name="parentValue" value="ROOT" />
	<jsp:param name="currentValue" value="<%=eventType %>" />
</jsp:include>
			</select>
<%	} else {
			%><%=eventType==null?"":eventType.toUpperCase() %><%
	} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.eventType" /> 2</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<span id="matchEventType2_indicator">
<%	} else {
			%><%=eventType2==null?"":eventType2.toUpperCase() %><%
	} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.eventSize" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<input type="textfield" name="scheduleSize" value="<%=scheduleSize %>" maxlength="3" size="50">
<%	} else {%>
			<%=scheduleSize %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.enrolledNumber" /></td>
		<td class="infoData" width="70%"><%=scheduleEnrolled %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.status" /></td>
<%
	boolean isOpen = "open".equals(scheduleStatus);
	boolean isSuspend = "suspend".equals(scheduleStatus);
	boolean isClosed = "close".equals(scheduleStatus);
	// set default value
	if (!isOpen && !isSuspend && !isClosed) {
		isOpen = true;
	}
	if (createAction || updateAction) {
%>
		<td class="infoData" width="70%">
			<input type="radio" name="scheduleStatus" value="open"<%=isOpen?" checked":"" %>><bean:message key="label.open" />
			<input type="radio" name="scheduleStatus" value="suspend"<%=isSuspend?" checked":"" %>><bean:message key="label.suspend" />
			<input type="radio" name="scheduleStatus" value="close"<%=isClosed?" checked":"" %>><bean:message key="label.close" /></td>
<%	} else {%>
		<td class="infoData" width="70%"><%if (isOpen) { %><bean:message key="label.open" /><%} else if (isSuspend) { %><bean:message key="label.suspend" /><%} else { %><bean:message key="label.close" /><%} %></td>
<%	} %>
	</tr>
</table>

<!-- 
<div id="container-123">
	<ul id="tabList">
		<li><a href="#fragment-1" class="linkSelected"><span><bean:message key="prompt.physicalInfo" /></span></a></li>
    </ul>
	<div id="fragment-1">
<jsp:include page="seminar_physical.jsp" flush="false">
	<jsp:param name="eventID" value="<%=eventID %>" />
	<jsp:param name="scheduleID" value="<%=scheduleID %>" />
	<jsp:param name="commandType" value="<%=commandType %>" />
</jsp:include>
	</div>
</div>
 -->
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
			<button class="btn-click" onclick="return window.close();"><bean:message key="button.close" /></button>
<%		}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="eventID" value="<%=eventID %>">
<input type="hidden" name="scheduleID" value="<%=scheduleID %>">
</form>
<script language="javascript">
<!--
	$(document).ready(function(){
		$('#container-1 > ul').tabs();
	});

	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (cmd == 'create' && document.form1.eventDesc.value == '') {
				alert("<bean:message key="error.seminarDescription.required" />.");
				document.form1.eventDesc.focus();
				return false;
			} else if (document.form1.scheduleSize.value == '') {
				alert("Empty seminar size.");
				document.form1.scheduleSize.focus();
				return false;
			} else if (isNaN(document.form1.scheduleSize.value)) {
				alert("Invalid seminar size.");
				document.form1.scheduleSize.focus();
				return false;
			}
		}
<%	} %>
		var campaignSeleted = $('#campaignID option:selected' ).val();
		$('#campaign').val(campaignSeleted);
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function updateEventType(pvalue) {
		var eventType = document.forms["form1"].elements["eventType"].value;

		http.open('get', '../ui/eventTypeCMB.jsp?level=2&parentValue=' + eventType + '&currentValue=' + pvalue + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponseEventType2;

		//actually send the request to the server
		http.send(null);
	}

	function processResponseEventType2() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("matchEventType2_indicator").innerHTML = '<select name="eventType2">' + http.responseText + '</select>';
		}
	}

<%	if (createAction || updateAction) { %>
	updateEventType('<%=eventType2 %>');
<%	} %>
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>