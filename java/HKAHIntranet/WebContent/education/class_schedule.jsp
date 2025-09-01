<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%!
	private final static SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

	private double parseDouble(String value) {
		try {
			return Double.parseDouble(value);
		} catch (Exception ex) {
			return -1;
		}
	}

	private Date str2Date(String classDate, String classTime) {
		try {
			return dateFormat.parse(classDate + " " + classTime);
		} catch (Exception ex) {
			return null;
		}
	}

	private String date2Str(Date date) {
		try {
			return dateFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}

	private Date dateRoll(Date date, int increment) {
		try {
			Calendar c1 = Calendar.getInstance();
			c1.setTime(date);
			c1.add(Calendar.HOUR, increment);
			return c1.getTime();
		} catch (Exception ex) {
			return null;
		}
	}
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();

String category = "title.education";
String command = request.getParameter("command");
String step = request.getParameter("step");
String deptCode = request.getParameter("deptCode");
String deptDescription = null;
String courseID = request.getParameter("courseID");
String courseDescription = null;
String classID = request.getParameter("classID");
String classDate = request.getParameter("classDate");
String classTimeFrom = request.getParameter("classTimeFrom");
String classTimeTo = request.getParameter("classTimeTo");
String classDuration = request.getParameter("class_duration");
String locationID = request.getParameter("locationID");
String locationDescription = TextUtil.parseStrUTF8(request.getParameter("locationDescription"));
String locationDescriptionOther = TextUtil.parseStrUTF8(request.getParameter("locationDescriptionOther"));
String lecturer = TextUtil.parseStrUTF8(request.getParameter("lecturer"));
String classStart = null;
String classEnd = null;
String classSize = request.getParameter("class_size");
String classEnrolled = "0";
String classStatus = request.getParameter("class_status");
String relatedNewsID = request.getParameter("relatedNewsID");

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
		Date dateTimeFrom = null;
		Date dateTimeTo = null;
		if ((createAction || updateAction) && (classDate == null || classDate.length() == 0)) {
			errorMessage = "Invalid class date.";
		} else if ((createAction || updateAction) && (classTimeFrom == null || classTimeFrom.length() == 0)) {
			errorMessage = "Invalid class time from.";
		} else if ((createAction || updateAction) && (classTimeTo == null || classTimeTo.length() == 0)) {
			errorMessage = "Invalid class time to.";
		} else if ((createAction || updateAction) && (dateTimeFrom = str2Date(classDate, classTimeFrom)) == null) {
			errorMessage = "Invalid class date and time from.";
		} else if ((createAction || updateAction) && (dateTimeTo = str2Date(classDate, classTimeTo)) == null) {
			errorMessage = "Invalid class date and time to.";
		} else if ((createAction || updateAction) && (classDuration == null || classDuration.length() == 0 || parseDouble(classDuration) < 0)) {
			errorMessage = "Invalid duration.";
		} else if ((createAction || updateAction) && (classSize == null || classSize.length() == 0 || !TextUtil.isNumber(classSize))) {
			errorMessage = "Invalid size.";
		} else {
			if (createAction || updateAction) {
				classStart = date2Str(dateTimeFrom);
				classEnd = date2Str(dateTimeTo);
			}

			if (createAction) {
				classID = ScheduleDB.add(userBean, "education", courseID, null, classStart, classEnd, classDuration, locationID, locationDescriptionOther, lecturer, classSize, classStatus);
				if (classID != null) {
					message = MessageResources.getMessage(session, "message.ScheduleDB.createSuccess");
					createAction = false;
				} else {
					errorMessage = MessageResources.getMessage(session, "error.ScheduleDB.createFail");
				}
			} else if (updateAction) {
				if (ScheduleDB.update(userBean, "education", courseID, classID, null, classStart, classEnd, classDuration, locationID, locationDescriptionOther, lecturer, classSize, classStatus,relatedNewsID)) {
					message = MessageResources.getMessage(session, "message.ScheduleDB.updateSuccess");
					updateAction = false;
				} else {
					errorMessage = MessageResources.getMessage(session, "error.ScheduleDB.updateFail");
				}
			} else if (deleteAction) {
				if (ScheduleDB.delete(userBean, "education", courseID, classID)) {
					message = MessageResources.getMessage(session, "message.ScheduleDB.deleteSuccess");
					closeAction = true;
				} else {
					errorMessage = MessageResources.getMessage(session, "error.ScheduleDB.deleteFail");
				}
			}
		}
		step = null;
	} else if (createAction) {
		deptCode = "";
		deptDescription = "";
		courseID = "";
		courseDescription = "";
		classID = "";
		classDate = (new SimpleDateFormat("dd/MM/yyyy")).format(new java.util.Date());
		classTimeFrom = (new SimpleDateFormat("HH:00:00")).format(new java.util.Date());
		classTimeTo = classTimeFrom;
		classDuration = "0";
		classSize = "0";
		classEnrolled = "0";
		classStatus = "";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (courseID != null && courseID.length() > 0) {
			ArrayList result = ScheduleDB.get("education", courseID, classID);
			if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				deptCode = reportableListObject.getValue(0);
				deptDescription = reportableListObject.getValue(1);
				courseDescription = reportableListObject.getValue(2);
				classDate = reportableListObject.getValue(4);
				classTimeFrom = reportableListObject.getValue(5);
				classTimeTo = reportableListObject.getValue(6);
				classDuration = reportableListObject.getValue(7);
				locationID = reportableListObject.getValue(8);
				locationDescription = reportableListObject.getValue(9);
				locationDescriptionOther = reportableListObject.getValue(10);
				lecturer = reportableListObject.getValue(11);
				classSize = reportableListObject.getValue(12);
				classEnrolled = reportableListObject.getValue(13);
				classStatus = reportableListObject.getValue(14);
				relatedNewsID = reportableListObject.getValue(16);
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
	title = "function.classSchedule." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" action="class_schedule.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.course" /></td>
		<td class="infoData" width="70%">
<%		if (createAction) {%>
			<select name="courseID">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventID" value="<%=courseID %>" />
	<jsp:param name="eventType" value="class" />
</jsp:include>
			</select>
<%		} else {%>
			<%=courseDescription %>
			<input type="hidden" name="courseID" value="<%=courseID %>">
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.classDate" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="classDate" value="<%=classDate %>" maxlength="10" size="9" onkeyup="validDate(this)" onblur="validDate(this)">
<%		} else {%>
			<%=classDate %>
<%		} %>
		(DD/MM/YYYY)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.classTime" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="classTimeFrom" value="<%=classTimeFrom %>" maxlength="8" size="8" onkeyup="validTime(this)" onblur="validTime(this)">
			-
			<input type="textfield" name="classTimeTo" value="<%=classTimeTo %>" maxlength="8" size="8" onkeyup="validTime(this)" onblur="validTime(this)">
<%		} else {%>
			<%=classTimeFrom %>
			-
			<%=classTimeTo %>
<%		} %>
	 	(HH:MM:SS)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.duration" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="class_duration" value="<%=classDuration %>" maxlength="100" size="3">
<%		} else {%>
			<%=classDuration %>
<%		} %>
		<bean:message key="label.hours" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.location" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
			<select name="locationID">
<jsp:include page="../ui/locationIDCMB.jsp" flush="false">
	<jsp:param name="locationID" value="<%=locationID %>" />
	<jsp:param name="allowEmpty" value="Y" />
	<jsp:param name="emptyLabel" value="N/A" />
</jsp:include>
			</select>
			<input type="textfield" name="locationDescriptionOther" value="<%=locationDescriptionOther==null?"":locationDescriptionOther %>" maxlength="500" size="50">
<%		} else {%>
		<%=locationDescription + " " + locationDescriptionOther %>
<%		} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Lecturer</td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="lecturer" value="<%=lecturer==null?"":lecturer %>" maxlength="500" size="150">
<%		} else {%>
			<%=lecturer %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.classSize" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="class_size" value="<%=classSize %>" maxlength="3" size="50">
<%		} else {%>
			<%=classSize %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.enrolledNumber" /></td>
		<td class="infoData" width="70%"><%=classEnrolled %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.status" /></td>
<%
			boolean isOpen = "open".equals(classStatus);
			boolean isSuspend = "suspend".equals(classStatus);
			boolean isClosed = "close".equals(classStatus);
			// set default value
			if (!isOpen && !isSuspend && !isClosed) {
				isOpen = true;
			}
			if (createAction || updateAction) {
%>
		<td class="infoData" width="70%">
			<input type="radio" name="class_status" value="open"<%=isOpen?" checked":"" %>><bean:message key="label.open" />
			<input type="radio" name="class_status" value="suspend"<%=isSuspend?" checked":"" %>><bean:message key="label.suspend" />
			<input type="radio" name="class_status" value="close"<%=isClosed?" checked":"" %>><bean:message key="label.close" /></td>
<%		} else {%>
<% 			
			String tempClassDate = classDate;
			String tempClassTime = classTimeFrom;
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
			if(tempClose){ %>
		<td class="infoData" width="70%"><bean:message key="label.close" /></td>
<%			}else{ %>
		<td class="infoData" width="70%"><%if (isOpen) { %><bean:message key="label.open" /><%} else if (isSuspend) { %><bean:message key="label.suspend" /><%} else { %><bean:message key="label.close" /><%} %></td>
<%			} %>
<%		} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Related News</td>
		<td class="infoData" width="50%">
		<%if(updateAction){ %>
			<select name="relatedNewsID">
				<jsp:include page="../ui/newsListCMB.jsp" flush="false">
					<jsp:param name="newsID" value="<%=relatedNewsID %>" />
					<jsp:param name="newsCategory" value="education" />
					<jsp:param name="newsType" value="classRelatedNews" />
				</jsp:include>
			</select>
		<%} else{
			ArrayList relatedNewsRecord;
			if(relatedNewsID!=null && relatedNewsID.length()>0){
				relatedNewsRecord = NewsDB.get(userBean, relatedNewsID, "education","1");
				System.out.println(relatedNewsRecord.size());
				if(relatedNewsRecord.size()>0){
					ReportableListObject relatedNewsRow = (ReportableListObject) relatedNewsRecord.get(0);
					String tempNewsTitle = relatedNewsRow.getValue(3);
					String tempNewsID = relatedNewsRow.getValue(0);
					String displayNews = "ID: "+tempNewsID+" | Headline: " + tempNewsTitle;
					%>
					<%=displayNews%>
					<%
				}
			}

		%>
			<div>
				<button onclick="return createRelatedNews();">Create Related News</button>
			</div>
		<%
		}
		%>
		</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%		if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.classSchedule.update" /></button>
			<button class="btn-delete"><bean:message key="function.classSchedule.delete" /></button>
<%		}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="deptCode" value="<%=deptCode %>">
<input type="hidden" name="classID" value="<%=classID %>">
</form>
<script language="javascript">
<!--
	function createRelatedNews(cmd, cid, nid) {

		callPopUpWindow("../admin/news.jsp?command=create&newsCategory=education&newsType=classRelatedNews");
		return false;
	}

	function submitAction(cmd, stp) {
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function createClassSchedule() {
		document.form1.action = "class_schedule.jsp";
		document.form1.submit();
	}

	function createELearning() {
		document.form1.action = "elearning.jsp";
		document.form1.submit();
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>