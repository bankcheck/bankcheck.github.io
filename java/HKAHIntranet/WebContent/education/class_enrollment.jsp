<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%
UserBean userBean = new UserBean(request);

String category = "title.education";
String loginStaffID = userBean.getStaffID();

String command = request.getParameter("command");
String step = request.getParameter("step");
String module = request.getParameter("module");
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
boolean eatLunch = false;
boolean removeLunch = false;

String message = null;
String errorMessage = null;

if ("take".equals(command)) {
	takeAction = true;
} else if ("withdraw".equals(command)) {
	withdrawAction = true;
} else if ("eatLunch".equals(command)) {
	eatLunch = true;	
} else if ("removeLunch".equals(command)) {
	removeLunch = true;
}
if ("L".equals(courseTime)) {
	courseStartTime = "00:00";
	courseEndTime = "14:00";
} else if ("E".equals(courseTime)) {
	courseStartTime = "14:01";
	courseEndTime = "23:59";
}

if ("".equals(module) || module == null ){
	module = "education";
}

try {
	if ("1".equals(step)) {
		if (userBean.isAdmin() && (takeAction || withdrawAction)) {
			message = "No register for admin.";
		} else if (takeAction) {
				int returnValue = EnrollmentDB.enroll(userBean, module, courseID, classID, "staff", loginStaffID,("vaccine".equals(module)?true:false));
			if (returnValue == 0) {
				message = "Class enrolled.";
			} else if (returnValue == -1) {
				errorMessage = "Class enrolled previously.";
			} else if (returnValue == -2) {
				errorMessage = "Class fulled.";
			} else {
				errorMessage = "Class enroll fail.";
			}
		} else if (withdrawAction) {
			int returnValue = EnrollmentDB.withdraw(userBean, module, courseID, classID, enrollID, "staff", loginStaffID);
			if (returnValue == 0) {
				message = "Class withdrawn.";
				// display other class after withdraw
				classID = "";
			} else if (returnValue == -1) {
				errorMessage = "Class haven't enrolled yet.";
			} else {
				errorMessage = "Class withdraw fail.";
			}
		} else if (eatLunch) {
			boolean returnValue = EnrollmentDB.updateLunch(userBean, module, courseID, classID, enrollID, "Y");
			if (returnValue){
				message = "Lunch ordered.";
			} else {
				errorMessage = "Lunch update fail.";
			}
			
		} else if (removeLunch) {
			boolean returnValue = EnrollmentDB.updateLunch(userBean, module, courseID, classID, enrollID, "N");
			if (returnValue){
				message = "Lunch not ordered.";
			} else {
				errorMessage = "Lunch update fail.";
			}
		}
	}

	if (courseID != null && courseID.length() > 0) {
		ArrayList record = EventDB.get(module, courseID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			courseID = row.getValue(0);
			description = row.getValue(1);
			detail = row.getValue(5);
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

if (courseID != null || courseDesc != null) {
	if ("vaccine".equals(module)) {
		request.setAttribute("class_enrollment", ScheduleDB.getListByTime(module, courseID, courseDesc, null, courseStartTime, courseEndTime, "staff", userBean.getStaffID(),2, true,Integer.toString(DateTimeUtil.getCurrentYear())));
	} else {
		request.setAttribute("class_enrollment", ScheduleDB.getListByTime(module, courseID, courseDesc, classID, courseStartTime, courseEndTime, "staff", userBean.getStaffID(), false,null));
	}
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
	<jsp:param name="pageTitle" value="function.classEnrollment.list" />
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="keepReferer" value="Y" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" action="class_enrollment.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
<%	if (courseID != null) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key='prompt.courseDescription' /></td>
		<td class="infoData" width="70%"><%=description %></td>
	</tr>
<%		if (detail != null && detail.length() > 0) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key='prompt.remarks' /></td>
		<td class="infoData" width="70%"><%=detail %></td>
	</tr>
<%		} %>
<%	} %>
</table>
<bean:define id="functionLabel"><bean:message key="function.classEnrollment.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.class_enrollment" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.courseDescription" style="width:20%">
<%	if (courseID == null) { %>
		<c:out value="${row.fields3}" />
<%	} %>
		<logic:notEqual name="row" property="fields4" value="">
			<c:out value="${row.fields4}" />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.classSchedule" style="width:15%">
		<c:out value="${row.fields8}" />
	</display:column>
	<display:column titleKey="prompt.duration" style="width:10%">
		<c:out value="${row.fields9}" />-<c:out value="${row.fields10}" /><br/>
		( <c:out value="${row.fields11}" /> <bean:message key="label.hours" /> )
	</display:column>
	<display:column property="fields12" titleKey="prompt.location" style="width:10%" />
	<display:column titleKey="prompt.available" style="width:10%">
		<c:out value="${row.fields15}" />/<c:out value="${row.fields13}" />
	</display:column>
	<display:column titleKey="prompt.status" style="width:10%">
		<logic:equal name="row" property="fields16" value="">
			<bean:message key="label.notYetEnroll" />
		</logic:equal>
		<logic:notEqual name="row" property="fields16" value="">
			<bean:message key="label.enrolled" />
		</logic:notEqual>
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
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
	
<% 	if(tempClose){ %>
	<bean:message key="label.close" />
<%	}else{ %>
		<logic:equal name="row" property="fields15" value="0">
			<logic:equal name="row" property="fields16" value="">
				<bean:message key="label.full" />
			</logic:equal>
			<logic:notEqual name="row" property="fields16" value="">
				<button name="btn-fs-action" onclick="return submitAction('withdraw', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />', '<c:out value="${row.fields16}" />', 1);"><bean:message key="button.withdraw" /></button>
			</logic:notEqual>
		</logic:equal>
		<logic:notEqual name="row" property="fields15" value="0">
			<logic:equal name="row" property="fields17" value="open">
				<logic:equal name="row" property="fields16" value="">
					<button name="btn-fs-action" onclick="return submitAction('take', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />', '', 1);"><bean:message key="button.enroll" /></button>
				</logic:equal>
				<logic:notEqual name="row" property="fields16" value="">
					<button name="btn-fs-action" onclick="return submitAction('withdraw', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />', '<c:out value="${row.fields16}" />', 1);"><bean:message key="button.withdraw" /></button>
				</logic:notEqual>
			</logic:equal>
			<logic:equal name="row" property="fields17" value="suspend">
				<bean:message key="label.suspend" />
			</logic:equal>
			<logic:equal name="row" property="fields17" value="close">
				<bean:message key="label.close" />
			</logic:equal>
		</logic:notEqual>
<%	} %>
	</display:column>
	<c:set var="tempLunchAva" value="${row.fields20}"/>
	<c:set var="tempEnrollID" value="${row.fields16}"/>
	<c:set var="tempCourseID" value="${row.fields2}"/>
	<c:set var="tempClassDate" value="${row.fields8}"/>
<%						

	String tempLunchAva = (String)pageContext.getAttribute("tempLunchAva");
	String tempEnrollID = (String)pageContext.getAttribute("tempEnrollID");
	String tempCourseID = (String)pageContext.getAttribute("tempCourseID");
	String tempLunch = "N";
	
	if(tempEnrollID != null && tempEnrollID.length() > 0){
		if(tempLunchAva != null && "Y".equals(tempLunchAva)){
			boolean allowEdit = false;
			ArrayList eRecord = EnrollmentDB.get("education", tempCourseID, tempEnrollID);
			if (eRecord.size() > 0) {
				ReportableListObject eRow = (ReportableListObject) eRecord.get(0);
				tempLunch = eRow.getValue(17);
			}
//			Calendar today = Calendar.getInstance();
			Calendar cutOffDate = null;
//			DateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			if(tempClassDate != null && tempClassDate.length() > 0){
				String cutOffHour = " " + (ConstantsServerSide.isTWAH() ? "17:00" : "17:30");	
				tempClassDate = tempClassDate + cutOffHour;
				Date date = df.parse(tempClassDate);
				cutOffDate = Calendar.getInstance();
				cutOffDate.setTime(date);
				if(ConstantsServerSide.isTWAH()){	// can edit lunch before office hour 4 weekdays before for TWAH
					if (cutOffDate.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY) {
						cutOffDate.add(Calendar.DAY_OF_MONTH, -4);
					}else {
						cutOffDate.add(Calendar.DAY_OF_MONTH, -6);
					}
				}else{
					cutOffDate.add(Calendar.DAY_OF_MONTH, -2); // can edit lunch before office hour 2 days before for HKAH
				}
			}
						
			if(cutOffDate != null && today.before(cutOffDate)){
				allowEdit = true;
			}

%>
		<display:column title="Order Lunch" media="html" style="width:15%; text-align:center">
<%			if("N".equals(tempLunch)){ %>
<%				if(allowEdit){	%>
			<input <%="N".equals(tempLunch)?"":"checked" %> id='lunchChkBox' onclick="return submitAction('lunch', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />', '<c:out value="${row.fields16}" />', 1);" type="checkbox" >
<%				} else { %>
					No
<%				} %>
<%			} else { %>
<%				if(allowEdit){	%>
			<input <%="N".equals(tempLunch)?"":"checked" %> id='lunchChkBox' onclick="return submitAction('lunch', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields7}" />', '<c:out value="${row.fields16}" />', 1);" type="checkbox" >
<%				} else { %>
					Yes
<%				} %>			
<%			} %>		

				
		</display:column>
<%		
			
		}
	}
%>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="courseID" />
<input type="hidden" name="classID" />
<input type="hidden" name="enrollID" />
<input type="hidden" name="module" value="<%=module%>"/>
</form>
<script language="javascript">
<!--
	function submitAction(cmd, cid, cid2, eid, stp) {
		$('button[name=btn-fs-action]').attr("disabled", true);
		if(cmd == 'lunch'){
			if(document.getElementById('lunchChkBox').checked) {
			    cmd='eatLunch';
			} else {
			    cmd='removeLunch';
			}
		}
		document.form1.command.value = cmd;
		document.form1.courseID.value = cid;
		document.form1.classID.value = cid2;
		document.form1.enrollID.value = eid;
		document.form1.step.value = stp;
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