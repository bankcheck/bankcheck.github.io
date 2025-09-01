<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.struts.Globals"%>
<%!
	private ArrayList fetchIncr(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(CO_ANNUAL_INCR, 'MM') ");
		sqlStr.append("FROM   CO_STAFFS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_STAFF_ID = '");
		sqlStr.append(staffID);
		sqlStr.append("' ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);
String loginStaffID = userBean.getStaffID();

String category = "title.education";
String incr = null;
String date_from = null;
String date_to = null;
try {
	ArrayList record = fetchIncr(loginStaffID);
	ReportableListObject row = null;
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);

		Calendar calendar = Calendar.getInstance();
		String currentDate = DateTimeUtil.formatDate(calendar.getTime());
		calendar.set(Calendar.DAY_OF_MONTH, 1);
		Integer annIncrMth = null;
		try {
			annIncrMth = Integer.parseInt(row.getValue(0));
			calendar.set(Calendar.MONTH, annIncrMth - 1);
		} catch (Exception e) {
			calendar.set(Calendar.MONTH, Calendar.JANUARY);
		}
		// go to the last day of annual incr month
		calendar.add(Calendar.DAY_OF_MONTH, -1);
		date_to = DateTimeUtil.formatDate(calendar.getTime());
		// check date whether it needs to roll forward
		if (DateTimeUtil.compareTo(date_to, currentDate) < 0) {
			// add one year
			calendar.add(Calendar.YEAR, 1);
			date_to = DateTimeUtil.formatDate(calendar.getTime());
		}
		incr = (new SimpleDateFormat("EEEE, MMMM dd, yyyy", Locale.ENGLISH)).format(calendar.getTime());
		// back to one year before
		calendar.add(Calendar.YEAR, -1);
		// go to the last day of annual incr month
		calendar.add(Calendar.DAY_OF_MONTH, 1);
		date_from = DateTimeUtil.formatDate(calendar.getTime());
	}
} catch (Exception e) {
	e.printStackTrace();
}

String compulsoryClassKey = null;
if (ConstantsServerSide.isTWAH()) {
	// show news
	request.setAttribute("cee_list", NewsDB.getList(userBean, "education", "cee", 5));
	request.setAttribute("literature_list", NewsDB.getList(userBean, "education", "literature", 5));
	// show enroll class
	request.setAttribute("enroll_class_list", EventDB.getNotYetEnroll("education", "compulsory", "staff", loginStaffID, date_from, date_to));
	// only show not attended class
	request.setAttribute("enrolled_class_list", EnrollmentDB.getEnrolledClass("education", null, null, "staff", loginStaffID, "0",null, null, null));

	compulsoryClassKey = "prompt.mandatoryClass";
} else {
	// show news
	request.setAttribute("news_list", NewsDB.getList(userBean, "education", 1));
	// show enroll class
	request.setAttribute("enroll_class_list", EventDB.getNotYetEnroll("education", "compulsory", "staff", loginStaffID, date_from, date_to));
	// only show not attended class
	request.setAttribute("enrolled_class_list", EnrollmentDB.getEnrolledClass("education", null, null, "staff", loginStaffID, "0",null, null, null));

	compulsoryClassKey = "prompt.compulsoryClass";
}

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
%>
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
	<jsp:param name="pageTitle" value="prompt.reminder.compulsoryClass" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<%
if (ConstantsServerSide.isTWAH()) {
	// Fetch front page menu
	List menuList = StaffEducationDB.getEeMenuModuleList(1);
	request.setAttribute("menuList", menuList);
%>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form_reminder" method="post">
<div style="background-image: url(../images/education_menu.jpg);">
<table  width="100%" border="0">
	<tr><td align="center">
		<div id="staffEducationWrapper">
			<div  id="educationFrontPage">
				<table width="100%" border="0" cellpadding="5" cellspacing="0">
					<tr class="header bigText">
						<td colspan="2"><h2><bean:message key="label.staffEducation" /></h2></td>
					</tr>
					<tr class="header">
						<td colspan="2">
							<b>Health Education & Research</b>
						</td>
					</tr>
					<tr style="text-align: right;">
						<td colspan="2">
							<%if(ConstantsServerSide.isTWAH()) { %>
							<a href="contact.htm"><b>Contact</b></a>
							<%} %>
						</td>
					</tr>
					<tr class="nav-header">
						<td class="bold" colspan="2">
							<marquee> Welcome to Staff Education / Health Education & Research&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;歡迎流覽 員工培訓 / 健康教育 科研 網頁</marquee>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="height: 10px;"></td>
					</tr>
			<c:if test="${menuList != null}" >
				<c:forEach var="menu" items="${menuList}">
					<tr style="<c:out value='${menu.bgColorStyle}' />">
						<td class="nav">
							<a href="<c:out value='${menu.eeUrl}' />" class="nav bold">
								<c:out value="${menu.eeDescriptionEn}" />
							</a>
						</td>
						<td class="nav">
							<a href="<c:out value='${menu.eeUrl}' />" class="nav">
								<c:out value="${menu.eeDescriptionZh}" />
							</a>
						</td>
					</tr>
				</c:forEach>
			</c:if>
				</table>
			</div>
		</div>
	</td></tr>
</table>
<div style="margin: 10px 0;">
	<p class="mottoText">Extending the Healing Ministry of Christ</p>
	<p class="mottoText">延續基督的醫治大能 </p>
</div>
</div>
<%} else {%>
<form name="form_reminder" method="post">
<bean:define id="functionLabel1"><bean:message key="title.departmental.education.material" /></bean:define>
<bean:define id="notFoundMsg1"><bean:message key="message.notFound" arg0="<%=functionLabel1 %>" /></bean:define>
<bean:define id="functionLabel2"><bean:message key="<%=compulsoryClassKey %>" /></bean:define>
<bean:define id="notFoundMsg2"><bean:message key="message.notFound" arg0="<%=functionLabel2 %>" /></bean:define>
<img src="../images/AHA.jpg" width="80" height="80"/>
<a href="javascript:void(0);" onclick="return downloadFile('658');"><font style="font-weight: bolder;font-size:large;">Update on American Heart Association Guideline 2015</font></a>
</br>
<jsp:include page="../education/NSI_Popup.jsp" flush="false">
	<jsp:param name="module" value="education" />
</jsp:include>

<table width="100%" border="0">
	<tr class="smallText">
		<td class="portletCaption"><bean:message key="title.education.news" /></td>
	</tr>
</table>
<%	if (incr != null) {%><p><bean:message key="message.reminder.compulsoryClass" arg0="<%=incr %>" /></p><%} %>

<display:table id="row" name="requestScope.news_list" export="false" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.date" style="width:10%">
		<c:out value="${row.fields5}" />
	</display:column>
	<display:column property="fields3" titleKey="prompt.headline" style="width:40%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return readNews('<c:out value="${row.fields1}" />', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg1 %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>

<table width="100%" border="0">
	<tr class="smallText">
		<td class="portletCaption"><bean:message key="label.notYetEnroll" /> (<%=date_from %> - <%=date_to %>)</td>
	</tr>
</table>
<display:table id="row1" name="requestScope.enroll_class_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><img src="../images/code.gif"></display:column>
	<display:column property="fields1" titleKey="prompt.course" style="width:45%" />
	<display:column titleKey="prompt.courseType" style="width:30%">
		<logic:equal name="row1" property="fields2" value="class">
			<bean:message key='<%=ConstantsServerSide.isTWAH() ? "label.sitIn.twah" : "label.sitIn" %>' />
		</logic:equal>
		<logic:notEqual name="row1" property="fields2" value="class">
			<bean:message key='<%=ConstantsServerSide.isTWAH() ? "label.onLine.twah" : "label.onLine" %>' />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<logic:equal name="row1" property="fields2" value="class">
			<button onclick="return submitRegisterAction('<c:out value="${row1.fields0}" />', '');"><bean:message key="button.register" /></button>
		</logic:equal>
		<logic:notEqual name="row1" property="fields2" value="class">
			<button onclick="return submitELearningAction('test', '<c:out value="${row1.fields0}" />');"><bean:message key='<%=ConstantsServerSide.isTWAH() ? "button.test.twah" : "button.test" %>' /></button>
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg2 %>"/>
</display:table>
<table width="100%" border="0">
	<tr><td>&nbsp;</td></tr>
	<tr class="smallText">
		<td class="portletCaption"><bean:message key="label.enrolled" /></td>
	</tr>
</table>
<display:table id="row2" name="requestScope.enrolled_class_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><img src="../images/code.gif"></display:column>
	<display:column property="fields1" titleKey="prompt.course" style="width:25%" />
	<display:column titleKey="prompt.classSchedule" style="width:30%">
		<c:out value="${row2.fields4}" />
		<logic:notEqual name="row2" property="fields5" value="">
			(
				<c:out value="${row2.fields5}" />
				<logic:notEqual name="row2" property="fields6" value="">
					- <c:out value="${row2.fields6}" />
				</logic:notEqual>
			)
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.status" style="width:20%">
		<logic:equal name="row2" property="fields8" value="1">
			<bean:message key="label.attend" /> at <c:out value="${row2.fields7}" />
		</logic:equal>
		<logic:notEqual name="row2" property="fields8" value="1">
			<bean:message key="label.enrolled" />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<logic:equal name="row2" property="fields8" value="1">
			<bean:message key="label.close" />
		</logic:equal>
		<logic:notEqual name="row2" property="fields8" value="1">
			<button onclick="return submitRegisterAction('<c:out value="${row2.fields0}" />','<c:out value="${row2.fields2}" />');"><bean:message key="button.view" /></button>
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg2 %>"/>
</display:table>
<input type="hidden" name="courseID">
<input type="hidden" name="classID">
<input type="hidden" name="elearningID">
<input type="hidden" name="eventType" value="online">
<input type="hidden" name="eventCategory" value="compulsory">
</form>
<%} %>
<script language="javascript">
	function submitRegisterAction(cid, cid2) {
		document.form_reminder.action = "class_enrollment.jsp";
		document.form_reminder.courseID.value = cid;
		document.form_reminder.classID.value = cid2;
		document.form_reminder.submit();
	}

	function submitELearningAction(cmd, eid) {
		document.form_reminder.action = "elearning_test_list_menu.jsp";
		document.form_reminder.elearningID.value = eid;
		document.form_reminder.submit();
	}

	function readNews(cid, nid) {
		callPopUpWindow("../portal/news_view.jsp?newsCategory=" + cid + "&newsID=" + nid);
		return false;
	}

	function playMovie(file) {
		var FO = {
			movie:"../swf/flvplayer.swf",
			width:"640px",
			height:"480px",
			majorversion:"7",
			build:"0",
			flashvars:"file="+file+"&autoStart=true&repeat=true"
		};

		UFO.create(FO, 'player');
	}
	//playMovie('/swf/video/NSI Prevention - Episode 1 (IV Cannulation).flv');
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>