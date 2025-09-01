<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
UserBean userBean = new UserBean(request);
String loginStaffID = (userBean.getStaffID() != null && userBean.getStaffID().length()>0?userBean.getStaffID():userBean.getUserName());

String command = request.getParameter("command");
String step = request.getParameter("step");
String courseID = request.getParameter("courseID");
String classID = request.getParameter("classID");
String enrollID = request.getParameter("enrollID");
String courseDesc = request.getParameter("courseName");
String courseTime = request.getParameter("courseTime");
String courseStartTime = null;
String courseEndTime = null;
String description = null;
String detail = null;

boolean takeAction = false;
boolean withdrawAction = false;

String message = null;
String errorMessage = null;

if ("take".equals(command)) {
	takeAction = true;
} else if ("withdraw".equals(command)) {
	withdrawAction = true;
}

if ("L".equals(courseTime)) {
	courseStartTime = "00:00";
	courseEndTime = "14:00";
} else if ("E".equals(courseTime)) {
	courseStartTime = "14:01";
	courseEndTime = "23:59";
}

try {
	if ("1".equals(step)) {
		if (userBean.isAdmin() && (takeAction || withdrawAction)) {
			message = "Unable to enroll as Admin.";
		} else if (takeAction) {
			int returnValue = EnrollmentDB.enroll(userBean, "lmc.crm", courseID, classID, "guest", loginStaffID);
			if (returnValue == 0) {
				message = "Event enrolled.";
			} else if (returnValue == -1) {
				errorMessage = "Event have already been enrolled.";
			} else if (returnValue == -2) {
				errorMessage = "Event is full.";
			} else {
				errorMessage = "Fail to enroll for event.";
			}
		} else if (withdrawAction) {
			int returnValue = EnrollmentDB.withdraw(userBean, "lmc.crm", courseID, classID, enrollID, "guest", loginStaffID);
			if (returnValue == 0) {
				message = "Event withdrawn successfully.";
				// display other class after withdraw
				classID = "";
			} else if (returnValue == -1) {
				errorMessage = "Event have not yet been enrolled.";
			} else {
				errorMessage = "Fail to withdraw from event.";
			}
		}
	}

	
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
 
ArrayList allEvents = ScheduleDB.getListByDateWithUserID("lmc.crm",null, null,null, null,userBean.getLoginID(),"guest");
ArrayList userEvents = ScheduleDB.getUserEnrolledList("lmc.crm",null, null,null	, null,userBean.getLoginID(),"guest","y");

//SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
//Calendar pastDate = Calendar.getInstance();
//pastDate.add(Calendar.DATE, -1);
ArrayList majorEvents = ScheduleDB.getListByDateWithUserIDAndEventType2("lmc.crm",null, null,null,null,userBean.getLoginID(),"guest","major");

//Calendar upcomingDate = Calendar.getInstance();
ArrayList minorEvents = ScheduleDB.getListByDateWithUserIDAndEventType2("lmc.crm",null, null,null,null,userBean.getLoginID(),"guest","minor");

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
<jsp:include page="header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="title.jsp" flush="false">
	<jsp:param name="title" value="Events" />
</jsp:include>
<%-- 
<jsp:include page="../../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
 --%>
<form name="form1" action="event_enrollment_list.jsp" method="post">
<div class="infoBox">
	<div class="infoHead3">
		Your Events
	</div>
	<div class="infoContent4">
		<div class="content">
		<table>
<% 
				ReportableListObject userEvent = null;
				for(int i = 0; i < userEvents.size(); i++) {
					userEvent = (ReportableListObject)userEvents.get(i);
%>
					<tr style="height:30px;align:left">
						<td width="20%">
							<label>- <%=userEvent.getValue(8) %></label>
						</td>
						<td width="40%">
							<label><b><%=userEvent.getValue(3) %></b></label>&nbsp;&nbsp;
<%
							if(userEvent.getValue(17).equals("close")) {
%>
								<span style="background-color:white;font-size:10px;color:red;padding:5px 1px 5px 7px;">
									<b>CLOSE</b>
								</span>
<%
							}
							else if(userEvent.getValue(17).equals("suspend")) {
%>
								<span style="background-color:blue;font-size:10px;color:yellow;padding:5px 1px 5px 7px;">
									<b>SUSPEND</b>
								</span>
<%
							}
							else {
								if(userEvent.getValue(15).equals("0")) {
%>
									<span style="background-color:red;font-size:10px;color:yellow;padding:5px 1px 5px 7px;">
										<b>FULL</b>
									</span>
<%
								}
							}
%>
						</td>
						<td>
							<label>(Available: <%=userEvent.getValue(15) %>)</label>
						</td>
					</tr>
					<tr>
						<td colspan="3">
<%
							if(userEvent.getValue(17).equals("open") && (!userEvent.getValue(15).equals("0") || !userEvent.getValue(16).equals(""))) {
								if(userEvent.getValue(16).equals("")) {
%>
							&nbsp;&nbsp;<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
												onclick="return submitAction('take', '<%=userEvent.getValue(2) %>', '<%=userEvent.getValue(7) %>', '', 1);">
											<label><b>Join</b></label>
										</button>
<%									
								}
								else {
%>
							&nbsp;&nbsp;<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
												onclick="return submitAction('withdraw', '<%=userEvent.getValue(2) %>', '<%=userEvent.getValue(7) %>', '<%=userEvent.getValue(16) %>', 1);">
											<label><b>Unjoin</b></label>
										</button>
<%										
								}
							}
%>
							
						</td>
					</tr>
					<tr>
						<td colspan="3" style="border-bottom-style:dashed; border-width:1px;padding:0px">
							
						</td>
					</tr>
<%
				}
%>
				</table>
		</div>
	</div>
</div>

<div class="infoBox">
	<div class="infoHead3" style="width:35%">
		<ul id="eventTab">
			<li>
				<label href="#all"><u>All Events</u></label>
			</li>
			<li>
				<label href="#major"><u>Major Events</u></label>
			</li>
			<li>
				<label href="#minor"><u>Minor Events</u></label>
			</li>
		</ul>
	</div>
	<div class="infoContent4">
		<div class="content" id="eventCont">
			<div id="all" style="display:none;">
				<label style="font-size:16px;line-height:40px;"><b><u>ALL EVENTS</u></b></label>
				<br/>
				<table>
<% 
				ReportableListObject event = null;
				for(int i = 0; i < allEvents.size(); i++) {
					event = (ReportableListObject)allEvents.get(i);
%>
					<tr style="height:30px;align:left">
						<td width="20%">
							<label>- <%=event.getValue(8) %></label>
						</td>
						<td width="40%">
							<label><b><%=event.getValue(3) %></b></label>&nbsp;&nbsp;
<%
							if(event.getValue(17).equals("close")) {
%>
								<span style="background-color:white;font-size:10px;color:red;padding:5px 1px 5px 7px;">
									<b>CLOSE</b>
								</span>
<%
							}
							else if(event.getValue(17).equals("suspend")) {
%>
								<span style="background-color:blue;font-size:10px;color:yellow;padding:5px 1px 5px 7px;">
									<b>SUSPEND</b>
								</span>
<%
							}
							else {
								if(event.getValue(15).equals("0")) {
%>
									<span style="background-color:red;font-size:10px;color:yellow;padding:5px 1px 5px 7px;">
										<b>FULL</b>
									</span>
<%
								}
							}
%>
						</td>
						<td>
							<label>(Available: <%=event.getValue(15) %>)</label>
						</td>
					</tr>
					<tr>
						<td colspan="3">
<%
							if(event.getValue(17).equals("open") && (!event.getValue(15).equals("0") || !event.getValue(16).equals(""))) {
								if(event.getValue(16).equals("")) {
%>
							&nbsp;&nbsp;<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
												onclick="return submitAction('take', '<%=event.getValue(2) %>', '<%=event.getValue(7) %>', '', 1);">
											<label><b>Join</b></label>
										</button>
<%									
								}
								else {
%>
							&nbsp;&nbsp;<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
												onclick="return submitAction('withdraw', '<%=event.getValue(2) %>', '<%=event.getValue(7) %>', '<%=event.getValue(16) %>', 1);">
											<label><b>Unjoin</b></label>
										</button>
<%										
								}
							}
%>
							
						</td>
					</tr>
					<tr>
						<td colspan="3" style="border-bottom-style:dashed; border-width:1px;padding:0px">
							
						</td>
					</tr>
<%
				}
%>
				</table>
			</div>
			<div id="major" style="display:none;">
				<label style="font-size:16px;line-height:40px;"><b><u>MAJOR EVENTS</u></b></label>
				<table>
<% 
				ReportableListObject majorEvent = null;
				for(int i = 0; i < majorEvents.size(); i++) {
					majorEvent = (ReportableListObject)majorEvents.get(i);
%>
					<tr style="height:30px;align:left">
						<td width="20%">
							<label>- <%=majorEvent.getValue(8) %></label>
						</td>
						<td width="40%">
							<label><b><%=majorEvent.getValue(3) %></b></label>&nbsp;&nbsp;
<%
							if(majorEvent.getValue(17).equals("close")) {
%>
								<span style="background-color:white;font-size:10px;color:red;padding:5px 1px 5px 7px;">
									<b>CLOSE</b>
								</span>
<%
							}
							else if(majorEvent.getValue(17).equals("suspend")) {
%>
								<span style="background-color:blue;font-size:10px;color:yellow;padding:5px 1px 5px 7px;">
									<b>SUSPEND</b>
								</span>
<%
							}
							else {
								if(majorEvent.getValue(15).equals("0")) {
%>
									<span style="background-color:red;font-size:10px;color:yellow;padding:5px 1px 5px 7px;">
										<b>FULL</b>
									</span>
<%
								}
							}
%>
						</td>
						<td>
							<label>(Available: <%=majorEvent.getValue(15) %>)</label>
						</td>
					</tr>
					<tr>
						<td colspan="3">
<%
						if(majorEvent.getValue(17).equals("open") && (!majorEvent.getValue(15).equals("0") || !majorEvent.getValue(16).equals(""))) {
								if(majorEvent.getValue(16).equals("")) {
%>
							&nbsp;&nbsp;<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
												onclick="return submitAction('take', '<%=majorEvent.getValue(2) %>', '<%=majorEvent.getValue(7) %>', '', 1);">
											<label><b>Join</b></label>
										</button>
<%									
								}
								else {
%>
							&nbsp;&nbsp;<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
												onclick="return submitAction('withdraw', '<%=majorEvent.getValue(2) %>', '<%=majorEvent.getValue(7) %>', '<%=majorEvent.getValue(16) %>', 1);">
											<label><b>Unjoin</b></label>
										</button>
<%										
								}
							}
%>
							
						</td>
					</tr>
					<tr>
						<td colspan="3" style="border-bottom-style:dashed; border-width:1px;padding:0px">
							
						</td>
					</tr>
<%
				}
%>
				</table>
			</div>
			<div id="minor" style="display:none;">
				<label style="font-size:16px;line-height:40px;"><b><u>MINOR EVENTS</u></b></label>
					<table>
<% 
				ReportableListObject minorEvent = null;
				for(int i = 0; i < minorEvents.size(); i++) {
					minorEvent = (ReportableListObject)minorEvents.get(i);
%>
					<tr style="height:30px;align:left">
						<td width="20%">
							<label>- <%=minorEvent.getValue(8) %></label>
						</td>
						<td width="40%">
							<label><b><%=minorEvent.getValue(3) %></b></label>&nbsp;&nbsp;
<%
							if(minorEvent.getValue(17).equals("close")) {
%>
								<span style="background-color:white;font-size:10px;color:red;padding:5px 1px 5px 7px;">
									<b>CLOSE</b>
								</span>
<%
							}
							else if(minorEvent.getValue(17).equals("suspend")) {
%>
								<span style="background-color:blue;font-size:10px;color:yellow;padding:5px 1px 5px 7px;">
									<b>SUSPEND</b>
								</span>
<%
							}
							else {
								if(minorEvent.getValue(15).equals("0")) {
%>
									<span style="background-color:red;font-size:10px;color:yellow;padding:5px 1px 5px 7px;">
										<b>FULL</b>
									</span>
<%
								}
							}
%>
						</td>
						<td>
							<label>(Available: <%=minorEvent.getValue(15) %>)</label>
						</td>
					</tr>
					<tr>
						<td colspan="3">
<%
							if(minorEvent.getValue(17).equals("open") && (!minorEvent.getValue(15).equals("0") || !minorEvent.getValue(16).equals(""))) {
								if(minorEvent.getValue(16).equals("")) {
%>
							&nbsp;&nbsp;<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
												onclick="return submitAction('take', '<%=minorEvent.getValue(2) %>', '<%=minorEvent.getValue(7) %>', '', 1);">
											<label><b>Join</b></label>
										</button>
<%									
								}
								else {
%>
							&nbsp;&nbsp;<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
												onclick="return submitAction('withdraw', '<%=minorEvent.getValue(2) %>', '<%=minorEvent.getValue(7) %>', '<%=minorEvent.getValue(16) %>', 1);">
											<label><b>Unjoin</b></label>
										</button>
<%										
								}
							}
%>
							
						</td>
					</tr>
					<tr>
						<td colspan="3" style="border-bottom-style:dashed; border-width:1px;padding:0px">
							
						</td>
					</tr>
<%
				}
%>
				</table>
			</div>
		</div>
	</div>
</div>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="courseID" />
<input type="hidden" name="classID" />
<input type="hidden" name="enrollID" />
</form>
<script language="javascript">
	function tabEvent() {
		$('#eventTab').find('label').click(function() {
			$('#eventTab').find('label').each(function(i, v) {
				$(v).parent().parent().parent().next().find($(this).attr('href'))
					.css('display', 'none');
			});
			
			$(this).parent().parent().parent().next().find($(this).attr('href'))
				.css('display', '');
		});
		
		$('#eventTab').find('label:first').trigger('click');
	}
	
	$(document).ready(function() {
		tabEvent();
	});

	function submitAction(cmd, cid, cid2, eid, stp) {
		document.form1.command.value = cmd;
		document.form1.courseID.value = cid;
		document.form1.classID.value = cid2;
		document.form1.enrollID.value = eid;
		document.form1.step.value = stp;
		document.form1.submit();
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../../common/footer.jsp" flush="false" />
</body>
</html:html>