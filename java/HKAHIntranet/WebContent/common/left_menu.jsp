<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.convert.Converter"%>
<%!
	private String checkUrlPermission(UserBean userBean, HttpSession session, String functionID, String displayWord, String imageUrl, String jspPage) {
		if (userBean.isAccessible(functionID)) {
			StringBuffer outputUrl = new StringBuffer();
			outputUrl.append("<li><span class=\"file\"><a href=\"");
			outputUrl.append(jspPage);
			outputUrl.append("\" target=\"content\">");
			if (imageUrl != null && imageUrl.length() > 0) {
				outputUrl.append("<img src=\"");
				outputUrl.append(imageUrl);
				outputUrl.append("\" width=\"16\" height=\"16\" border=\"0\">");
			}
			if (displayWord != null) {
				outputUrl.append(MessageResources.getMessage(session, displayWord));
			} else {
				outputUrl.append(MessageResources.getMessage(session, functionID));
			}
			outputUrl.append("</a></span></li>");
			return outputUrl.toString();
		} else {
			return "";
		}
	}

	private String parseMenuUrl(UserBean userBean, HttpSession session, boolean isCheckLogin, boolean isCheckStaff, boolean isBold, String programUrl, String groupID, String displayWord) {
		return parseMenuUrl(userBean, session, isCheckLogin, isCheckStaff, isBold, programUrl, null, groupID, displayWord, null, null, null, null);
	}

	private String parseMenuUrl(UserBean userBean, HttpSession session, boolean isCheckLogin, boolean isCheckStaff, boolean isBold, String programUrl, String docID, String groupID, String displayWord, String target) {
		return parseMenuUrl(userBean, session, isCheckLogin, isCheckStaff, isBold, programUrl, docID, groupID, displayWord, null, null, null, target);
	}

	private String parseMenuUrl(UserBean userBean, HttpSession session, boolean isCheckLogin, boolean isCheckStaff, boolean isBold, String programUrl, String docID, String groupID, String displayWord, String childURL, String target) {
		return parseMenuUrl(userBean, session, isCheckLogin, isCheckStaff, isBold, programUrl, docID, groupID, displayWord, null, null, childURL, target);
	}

	private String parseMenuUrl(UserBean userBean, HttpSession session, boolean isCheckLogin, boolean isCheckStaff, boolean isBold, String programUrl, String docID, String groupID, String displayWord, String accessRightGroup, String accessRight, String childURL, String target) {
		if ((!isCheckLogin || userBean.isLogin()) && (!isCheckStaff || userBean.isStaff() || userBean.isDoctor())
				&& ((accessRightGroup == null && accessRight == null) || (accessRightGroup != null && userBean.isGroupID(accessRightGroup)) || (accessRight != null && userBean.isAccessible(accessRight)))) {

			//programUrl = "../cms/lms_leaflet_list.jsp";

			StringBuffer outputUrl = new StringBuffer();
			String docURL = null;
			boolean isInformationSharing = "prompt.information".equals(groupID);


			if (programUrl != null && programUrl.indexOf("javascript") >= 0) {
				if (docID != null && !"".equals(docID)) {
					outputUrl.append("<a class=\"topstoryblue\" onclick=\" downloadFile('"+docID+"', ''); return false;\" href=\"javascript:void(0);\" target=\"content\">");
				} else {
					outputUrl.append("<li><a href=\"");
					outputUrl.append(programUrl);
					outputUrl.append(";\">");
				}
			} else if (programUrl != null && programUrl.indexOf("#") >= 0) {
				outputUrl.append("<li><a href=\"#\">");
			} else {
				outputUrl.append("<li><a href=\"javascript:void(0);\" onclick=\"changeUrl('");
				outputUrl.append(programUrl);
				outputUrl.append("', '");
				if (groupID != null && groupID.length() > 0) {
					outputUrl.append(groupID);
				}
				outputUrl.append("');return false;\"");

				if (target != null) {
					outputUrl.append(" target=\"" + target + "\"");
				}

				outputUrl.append(">");
			}
			if (isBold) {
				outputUrl.append("<b>");
			}
			if (isInformationSharing) {
				outputUrl.append("<font color=\"blue\">");
			}
			try {
				outputUrl.append(MessageResources.getMessage(session, displayWord));
			} catch (Exception e) {
				outputUrl.append(displayWord);
			}
			if (isInformationSharing) {
				outputUrl.append("</font>");
			}
			if (isBold) {
				outputUrl.append("</b>");
			}
			outputUrl.append("</a>");
			if (childURL != null) {
				outputUrl.append(childURL);
			}
			outputUrl.append("</li>");
			return outputUrl.toString();
		} else {
			return ConstantsVariable.EMPTY_VALUE;
		}
	}
%>
<%
String pageCategory = (String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY);
String sessionId = session.getId();
UserBean userBean = new UserBean(request);
String menuStyle = (String) session.getAttribute("menuStyle");
if (menuStyle == null) {
	Random random = new Random();
	menuStyle = String.valueOf(random.nextInt(4) + 1);
	session.setAttribute("menuStyle", menuStyle);
}

boolean isSecure = ConstantsServerSide.SECURE_SERVER;

String logoAlt = null;
String portalWordUrl = null;
if (ConstantsServerSide.isTWAH()) {
	logoAlt = MessageResources.getMessage(session, "label.tsuenWanAdventistHospital") + " " +
				MessageResources.getMessage(session, "label.intranetPortal");
} else {
	logoAlt = MessageResources.getMessage(session, "label.hongKongAdventistHospital") + " " +
				MessageResources.getMessage(session, "label.intranetPortal");
}

Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);
if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {
	portalWordUrl = "/images/intranet-portal-zh_tw.jpg";
} else {
	// change logo
	int current_mm = DateTimeUtil.getCurrentMonth();
	int current_dd = DateTimeUtil.getCurrentDay();
	if (current_mm == 1 || current_mm == 2) {
		portalWordUrl = "/images/intranet-portal-newyear.jpg";
	} else if (current_mm == 5) {
		portalWordUrl = "/images/intranet-portal-mothersday.jpg";
	} else if (current_mm == 6) {
		portalWordUrl = "/images/intranet-portal-dragonboat.jpg";
	} else if (current_mm == 7 && current_dd == 1) {
		portalWordUrl = "/images/intranet-portal-hongkong.jpg";
	} else if (current_mm == 12) {
		portalWordUrl = "/images/intranet-portal-xmas.jpg";
	} else {
		portalWordUrl = "/images/intranet-portal.gif";
	}
}

boolean isACHSI = false;
if (userBean.isLogin() && "achsi".equals(userBean.getStaffID())) {
	isACHSI = true;
}

boolean isACHSGuest = false;
if (userBean.isLogin() && "ACHS".equals(userBean.getStaffID())) {
	isACHSGuest = true;
}

boolean isBoardMember = false;
if (userBean.isLogin() && userBean.isGroupID("boardMember") && !userBean.isAdmin()){
	isBoardMember = true;
}
boolean isBoardInvitee = false;
if (userBean.isLogin() && userBean.isGroupID("boardInvitee") && !userBean.isAdmin()){
	isBoardInvitee = true;
}
boolean isFinanceMember = false;
if (userBean.isLogin() && userBean.isGroupID("financeMember") && !userBean.isAdmin()){
	isFinanceMember = true;
}

boolean isBoaOrFinMember = false;
if (isBoardMember || isFinanceMember || isBoardInvitee){
	isBoaOrFinMember = true;
}

boolean isBDO = false;
if (userBean.isLogin() && userBean.isGroupID("bdo") && !userBean.isAdmin()){
	isBDO = true;
}

boolean isPI = false;
if (userBean.isLogin() && userBean.isAccessible("function.view.accreditation")) {
	isPI = true;
}

boolean isACMember = false;
if (userBean.isLogin() && userBean.isGroupID("acMember") && !userBean.isAdmin()){
	isACMember = true;
}

boolean isExecutiveMember = false;
if (userBean.isLogin() && userBean.isGroupID("executiveMember") && !userBean.isAdmin()){
	isExecutiveMember = true;
}

boolean isOperationMember = false;
if (userBean.isLogin() && userBean.isGroupID("operationMember") && !userBean.isAdmin()){
	isOperationMember = true;
}

boolean isBomMember = false;
if (userBean.isLogin() && userBean.isGroupID("bomMember") && !userBean.isAdmin()){
	isBomMember = true;
}

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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/dcdrilldown.css" />" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/skins/demo.css" />" />
<script type="text/javascript" src="<html:rewrite page="/js/jquery.cookie.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.dcdrilldown.1.2.min.js" />" /></script>
<style>
a{color:#036;text-decoration:none;}a:hover{color:#ff3300;text-decoration:none;}
body { margin: 0px; font: 12px Arial, Helvetica, sans-serif; background-color: #ffffff; }

/* For menu with very long title */
.menuSmallText li a:link, .menuSmallText li a:visited { padding-top: 1px !important; font-size: 9px; }
.menuSmallText li a:hover { padding-top: 1px !important; font-size: 9px; }
.menuSmallText li a:active { padding-top: 1px !important; font-size: 9px; }
</style>
<body leftmargin='5' topmargin='5' marginleft='5' marginleft='5' bgcolor='#ffffff'>
<form name="search_doc" action="../documentManage/search.jsp" method="post" target="content">
<% if (!ConstantsServerSide.isAMC() && !ConstantsServerSide.isAMC2() && !"ic".equals(pageCategory) && ((!userBean.isGuest() && !isBoaOrFinMember) || "piuser".equals(userBean.getLoginID())) && !"crm.portal".equals(pageCategory) && !isSecure) { %>
<table id="headerSearch" border="0" cellpadding="5" cellspacing="5">
	<tbody>
		<tr>
			<td class="boxSearch">
				<input type="textfield" name="query" value="<bean:message key="menu.search" /> ..."
					maxlength="25" size="10" class="searchField" onclick="searchClear();" onblur="searchDefault();"
					onkeypress="handleEnter(this, event)" />
				<input type="image" src="../images/search.gif" onclick="return searchEngine();">
			</td>
		</tr>
		<tr>
			<td><input type="radio" name="searchType" value="doc"<% if (isSecure) { %> checked<%} %>><bean:message key="menu.document" />
				<input type="radio" name="searchType" value="policy" checked><bean:message key="menu.policy" />
			</td>
		</tr>
	</tbody>
</table>
<% } %>
</form>
<%if ("ic".equals(pageCategory)) {%>
<div style="padding-top:120px;">
</div>
<div style="margin: 5px; border-width:1px; border-style:solid; border-color:#06a; padding-left:50px; width:200px;">
<ul id="browser" class="filetree"  style="list-style-type: none;">
	<%if (ConstantsServerSide.isTWAH()) { %>
	<li STYLE="list-style-image: url(../images/ic/icMenu16.jpg)"><html:link page="/ic/material_index_test.jsp" target="content">Home</html:link></li>
	<%} else{ %>
	<li STYLE="list-style-image: url(../images/ic/icMenu16.jpg)"><html:link page="/ic/material_index_test.jsp" target="content">Home</html:link></li>
	<%} %>
	<%if (ConstantsServerSide.isTWAH()) { %>
	<li STYLE="list-style-image: url(../images/ic/icMenu2.jpg)"><html:link page="/ic/material_content.jsp?category=scopeOfService" target="content">Scope Of Service</html:link></li>
	<%} else{ %>
	<%} %>
	<%if ("4112".equals(userBean.getStaffID())) { %>
	<li STYLE="list-style-image: url(../images/ic/icMenu1.jpg)"><html:link page="/ic/material_content.jsp?category=Department Policy" target="content">Department Policy</html:link></li>
	<%} %>
	<%if (ConstantsServerSide.isTWAH()) { %>
	<li STYLE="list-style-image: url(../images/ic/icMenu1.jpg)"><html:link page="/ic/material_content.jsp?category=Department Policy" target="content">Department Policy</html:link></li>
	<li STYLE="list-style-image: url(../images/ic/icMenu5.jpg)"><html:link page="/ic/material_content.jsp?category=ICPractice" target="content">Infection Control Practice</html:link></li>
	<%} else{ %>
	<li STYLE="list-style-image: url(../images/ic/icMenu2.jpg)"><html:link page="/ic/material_content.jsp?category=gown" target="content">Gowning and<br>Degowing Procedure</html:link></li>
	<li STYLE="list-style-image: url(../images/ic/icMenu2.jpg)"><html:link page="/ic/material_content.jsp?category=isolate" target="content">Isolation and Notification<br>Of Infectious Disease</html:link></li>
	<li STYLE="list-style-image: url(../images/ic/icMenu2.jpg)"><html:link page="/ic/material_content.jsp?category=aviFlu" target="content">Avian Flu<br>Information</html:link></li>
	<li STYLE="list-style-image: url(../images/ic/icMenu2.jpg)"><html:link page="/ic/material_content.jsp?category=handHygiene" target="content">Hand Hygiene</html:link></li>
	<li STYLE="list-style-image: url(../images/ic/icMenu5.jpg)"><html:link page="/ic/material_content.jsp?category=WasteManagement" target="content">Waste Management</html:link></li>
	<%} %>
	<li STYLE="list-style-image: url(../images/ic/icMenu6.jpg)" class="closed"><span>Infection Control Committee</span>
		<!-- *SUB MENU* --><ul style="list-style-type: none;">
			<li style="list-style-type: none;"><span><html:link page="/ic/material_content.jsp?category=ICCCharts" target="content">Organization Chart</html:link></span></li>
			<li style="list-style-type: none;"><span><html:link page="/ic/material_content.jsp?category=ICCMinutes" target="content">Minutes</html:link></span></li>
		<!-- *END SUB* --></ul>
	</li>
	<li STYLE="list-style-image: url(../images/ic/icMenu6.jpg)" class="closed"><span>Link Nurse and Link Person</span>
		<!-- *SUB MENU* --><ul>
			<li><span><html:link page="/ic/material_content.jsp?category=ICLNPCharts" target="content">Organisation Chart</html:link></span></li>
			<li><span><html:link page="/ic/material_content.jsp?category=ICLNPMinutes" target="content">Minutes</html:link></span></li>
		<!-- *END SUB* --></ul>
	</li>
	<%if (ConstantsServerSide.isTWAH()) { %>
	<li STYLE="list-style-image: url(../images/ic/icMenu18.jpg)"><html:link page="/ic/material_content.jsp?category=program" target="content">Program</html:link></li>
	<%} %>
	<li STYLE="list-style-image: url(../images/ic/icMenu18.jpg)"><html:link page="/ic/material_content.jsp?category=fitTest" target="content">Fit Test</html:link></li>
	<li STYLE="list-style-image: url(../images/ic/icMenu8.jpg)"><html:link page="/ic/material_content.jsp?category=Audit" target="content">Audit</html:link></li>
	<li STYLE="list-style-image: url(../images/ic/icMenu8.jpg)"><html:link page="/ic/material_content.jsp?category=Video" target="content">Video</html:link></li>
	<li STYLE="list-style-image: url(../images/ic/icMenu11.jpg)"><html:link page="/ic/material_content.jsp?category=Form" target="content">Form</html:link></li>
	<li STYLE="list-style-image: url(../images/ic/icMenu13.jpg)"><html:link page="/ic/material_content.jsp?category=Poster" target="content">Poster</html:link></li>
	<%if (ConstantsServerSide.isHKAH()) { %>
	<li class="closed"><span class="folder"><html:link page="/ic/material_content.jsp?category=eduMaterial" target="content">Education Material</html:link></span>
		<!-- *SUB MENU* --><ul>
			<li><span class="file"><html:link page="/ic/material_content.jsp?category=inService" target="content">In Service</html:link></span></li>
		<!-- *END SUB* --></ul>
	</li>
	<li STYLE="list-style-image: url(../images/ic/icMenu18.jpg)"><html:link page="/ic/material_content.jsp?category=ICPractice"
	target="content">Useful website</html:link></li>
	<%} %>
	<%if (ConstantsServerSide.isTWAH()) { %>
	<li STYLE="list-style-image: url(../images/ic/icMenu17.gif)"><html:link page="/ic/material_content.jsp?category=newsletter" target="content">Newsletter</html:link></li>
	<%} %>
	<%if (ConstantsServerSide.isTWAH()) { %>

	<li STYLE="list-style-image: url(../images/ic/icMenu19.jpg)"><html:link page="/ic/material_content.jsp?category=surveillance" target="content">Surveillance</html:link></li>
	<%} %>
		<%if (userBean.isAdmin() || userBean.isAccessible("function.ic.admin")) { %>

	<li STYLE="list-style-image: url(../images/code.gif)"><html:link page="/ic/webinfo_list.jsp" target="content">Administration</html:link></li>
	<%} %>
</ul>
</div>
<%} else if ("title.education".equals(pageCategory) && ConstantsServerSide.isHKAH() && userBean.isLogin() && (userBean.isStaff() || userBean.isAccessible("function.educationRecord.list"))) { %>
<div style="margin: 5px; border-width:1px; border-style:solid; border-color:#06a; padding:5px; width:195px;">
<ul id="browser" class="filetree">
	<!-- *SUB MENU* -->
		<li><html:link page="/education/reminder.jsp" target="content"><img src="../images/learn.gif" width="16" height="16" border="0"><bean:message key="prompt.reminder.compulsoryClass" /></html:link></li>
		<li class="closed"><span class="folder"><html:link page="/education/education_calendar.jsp" target="content"><bean:message key="title.education.monthlyCalendar" /></html:link></span>
		<!-- *SUB MENU* --><ul>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=0" target="content"><bean:message key="label.january" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=1" target="content"><bean:message key="label.february" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=2" target="content"><bean:message key="label.march" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=3" target="content"><bean:message key="label.april" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=4" target="content"><bean:message key="label.may" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=5" target="content"><bean:message key="label.june" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=6" target="content"><bean:message key="label.july" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=7" target="content"><bean:message key="label.august" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=8" target="content"><bean:message key="label.september" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=9" target="content"><bean:message key="label.october" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=10" target="content"><bean:message key="label.november" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=11" target="content"><bean:message key="label.december" /></html:link></span></li>
		<!-- *END SUB* --></ul></li>
		<li><span class="folder"><bean:message key="title.cne" /></span>
		<!-- *SUB MENU* --><ul>
			<li><span class="file"><html:link page="/education/class_enrollment.jsp?courseName=CNE&courseTime=L" target="content"><bean:message key="prompt.lunch" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/class_enrollment.jsp?courseName=CNE&courseTime=E" target="content"><bean:message key="prompt.evening" /></html:link></span></li>
			<li><span class="file"><html:link page="/portal/general.jsp?category=edu.poster" target="content">Poster</html:link></span></li>
		<!-- *END SUB* --></ul></li>
		<li><span class="folder"><bean:message key="prompt.compulsoryClass" /></span>
		<!-- *SUB MENU* --><ul>
			<li><span class="file"><html:link page="/education/revise_com_classes.jsp" target="content">Revised Compulsory Classes for Employees</html:link></span></li>
			<li><span class="file"><html:link page="/education/run_down_compulsory.jsp" target="content"><bean:message key="label.sitIn" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/elearning_test_list_menu.jsp?eventCategory=compulsory&eventType=online" target="content"><bean:message key="label.onLine" /></html:link></span></li>
			<li><span class="file"><html:link page="/portal/general.jsp?category=education.compulsory.nursing" target="content"><bean:message key="label.compulsoryNursing" /></html:link></span></li>
		<!-- *END SUB* --></ul></li>
		<li><span class="folder"><bean:message key="title.orientation.program" /></span>
		<!-- *SUB MENU* --><ul>
			<li><span class="file"><html:link page="/education/run_down_orientation.jsp?type=NO" target="content"><bean:message key="title.orientation.nursing" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/run_down_orientation_contract_worker.jsp" target="content"><bean:message key="title.orientation.contractWorker" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/run_down_orientation_agency_nurse.jsp" target="content"><bean:message key="title.orientation.agencyNurse" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/run_down_orientation_volunteers.jsp" target="content"><bean:message key="title.orientation.volunteers" /></html:link></span></li>
		<!-- *END SUB* --></ul></li>
		<li><span class="folder">In-Service Topics</span>
		<!-- *SUB MENU* --><ul>
			<li><span class="file"><a href="../documentManage/download2.jsp?embedVideoYN=Y&rootFolder=\\WWW-SERVER\Swf\&locationPath=Education"  target="content">Policy Education</a></span></li>
			<li><span class="file"><a href="javascript:void(0);" onclick="elearningTest(22);return false;">Laser Safety</a></span></li>
			<!-- <li><span class="file"><a href="javascript:void(0);" onclick="elearningTest(20);return false;">ACHS 2016</a></span></li> -->
			<li><span class="file"><a href="javascript:void(0);" onclick="elearningTest(18);return false;">Radiation Protection and Safety</a></span></li>
			<li><span class="file"><a href="javascript:void(0);" onclick="elearningTest(19);return false;">Pharmacology and Therapeutics of Cancer Pain</a></span></li>
			<li><span class="file"><a href="javascript:void(0);" onclick="elearningTest(13);return false;">MRI Safety</a></span></li>
			<li><span class="file"><a href="javascript:void(0);" onclick="elearningTest(14);return false;">IV Course</a></span></li>
			<li><span class="file"><a href="javascript:void(0);" onclick="elearningTest(25);return false;">FMEA</a></span></li>
			<li><span class="file"><a href="javascript:void(0);" onclick="elearningTest(28);return false;">ICAC Talk</a></span></li>
			<li><span class="file"><a href="javascript:void(0);" onclick="elearningTest(29);return false;">Mental Health Talk</a></span></li>
			<li><span class="file"><a href="javascript:void(0);" onclick="elearningTest(30);return false;">Prevent sexual harassment in the workplace</a></span></li>
		<!-- *END SUB* --></ul></li>
		<li><span class="file"><html:link page="/portal/general.jsp?category=education.powerpoint" target="content">Lecture PowerPoint</html:link></span></li>
			<li><span class="file"><html:link page="/portal/general.jsp?category=education.seformdl" target="content">Useful Forms Download</html:link></span></li>
<%		if ("5512".equals(userBean.getStaffID())) { %>
			<li><span class="file"><html:link page="/education/education_material_list.jsp" target="content"><bean:message key="title.departmental.education.material" /></html:link></span></li>
<%		} %>
		<li><span class="file"><html:link page="/education/record_list.jsp" target="content"><bean:message key="title.educationRecord" /></html:link></span></li>
		<li><span class="file"><html:link page="/education/video.jsp" target="content">Video</html:link></span></li>
		<!--<li><span class="file"><html:link page="/education/ce_list.jsp" target="content"><bean:message key="label.continuousEducation" /></html:link></span></li>-->
		<li><span class="file"><html:link page="/portal/general.jsp?category=e-resource" target="content"><bean:message key="menu.e.resource" /></html:link></span></li>
<%		if (userBean.isAccessible("function.course.admin")
		|| userBean.isAccessible("function.classSchedule.admin")
		|| userBean.isAccessible("function.classEnrollment.admin")
		|| userBean.isAccessible("function.eLesson.admin")
		|| userBean.isAccessible("function.eLesson.report")
		|| userBean.isAccessible("function.evaluation.list")
		|| userBean.isAccessible("function.ceBudget.admin")
		|| userBean.isAccessible("function.ceClaim.admin")) { %>
			<li class="closed"><span class="folder"><bean:message key="title.maintenance" /></span>
			<!-- *SUB MENU* --><ul>
				<%=checkUrlPermission(userBean, session, "function.course.admin", "prompt.course", null, "../education/course_list.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.classSchedule.admin", "prompt.classSchedule", null, "../education/class_schedule_list.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.classEnrollment.admin", "prompt.classEnrollment", null, "../education/class_enrollment_admin_list.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.eLesson.admin", "prompt.eLesson", null, "../education/elearning_list.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.eLesson.report", "function.eLesson.report", null, "../education/test_report_list.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.att.report", "function.att.report", null, "../education/qtrAttReport.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.evaluation.list", null, null, "../education/evaluation_list.jsp?evaluationID=1") %>
				<%=checkUrlPermission(userBean, session, "function.ceClaim.admin", "prompt.ceClaim", null, "../education/ce_claim_list.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.ceBudget.admin", "prompt.ceBudget", null, "../education/ce_budget_list.jsp") %>
			<!-- *END SUB* --></ul></li>
<%		} %>
</div>
<% } else if ("title.education".equals(pageCategory) && ConstantsServerSide.isTWAH() && userBean.isLogin() && (userBean.isStaff() || userBean.isAccessible("function.educationRecord.list"))) { %>
<div style="margin: 5px; border-width:1px; border-style:solid; border-color:#06a; padding:5px; width:195px;">
<ul id="browser" class="filetree">
	<!-- *SUB MENU* -->
		<li><html:link page="/education/reminder.jsp" target="content"><img src="../images/learn.gif" width="16" height="16" border="0"><bean:message key="prompt.reminder.compulsoryClass" /></html:link></li>
<%	if (!ConstantsServerSide.SECURE_SERVER) { %>
		<li><span class="file"><html:link page="/education/hospital_policies.htm" target="content"><bean:message key="function.staffEducation.education.hep" /></html:link></span></li>
<%	} %>

		<li class="closed"><span class="folder"><html:link page="/education/education_calendar.jsp" target="content"><bean:message key="title.education.monthlyCalendar" /></html:link></span>
		<!-- *SUB MENU* --><ul>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=0" target="content"><bean:message key="label.january" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=1" target="content"><bean:message key="label.february" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=2" target="content"><bean:message key="label.march" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=3" target="content"><bean:message key="label.april" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=4" target="content"><bean:message key="label.may" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=5" target="content"><bean:message key="label.june" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=6" target="content"><bean:message key="label.july" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=7" target="content"><bean:message key="label.august" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=8" target="content"><bean:message key="label.september" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=9" target="content"><bean:message key="label.october" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=10" target="content"><bean:message key="label.november" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=11" target="content"><bean:message key="label.december" /></html:link></span></li>
		<!-- *END SUB* --></ul></li>

		<li><span class="folder"><bean:message key="title.orientation.program" /></span>
		<!-- *SUB MENU* --><ul>
			<li><span class="file"><html:link page="/education/twah_hospital_orientation.jsp" target="content"><bean:message key="title.orientation.hospital" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/run_down_orientation.jsp?type=NO" target="content"><bean:message key="title.orientation.nursing" /></html:link></span></li>
			<!-- <li><span class="file"><html:link page="/education/run_down_orientation_contract_worker.jsp" target="content"><bean:message key="title.orientation.contractWorker" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/run_down_orientation_agency_nurse.jsp" target="content"><bean:message key="title.orientation.agencyNurse" /></html:link></span></li> -->
			<li><span class="file"><html:link page="/education/run_down_orientation_volunteers.jsp" target="content"><bean:message key="title.orientation.volunteers" /></html:link></span></li>
		<!-- *END SUB* --></ul></li>
		<!-- *SUB MENU* <ul>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=0" target="content"><bean:message key="label.january" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=1" target="content"><bean:message key="label.february" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=2" target="content"><bean:message key="label.march" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=3" target="content"><bean:message key="label.april" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=4" target="content"><bean:message key="label.may" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=5" target="content"><bean:message key="label.june" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=6" target="content"><bean:message key="label.july" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=7" target="content"><bean:message key="label.august" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=8" target="content"><bean:message key="label.september" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=9" target="content"><bean:message key="label.october" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=10" target="content"><bean:message key="label.november" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/education_calendar.jsp?select_month=11" target="content"><bean:message key="label.december" /></html:link></span></li>
			</ul>--></li>
		<li><span class="folder"><bean:message key="prompt.mandatoryClass" /></span>
		<!-- *SUB MENU* --><ul>
			<li><span class="file"><html:link page="/education/mand_inserv_info.htm" target="content"><bean:message key="function.staffEducation.education.is_info" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/mand_inserv_content.htm" target="content"><bean:message key="function.staffEducation.education.is_content" /></html:link></span></li>
			<li><span class="file"><html:link page="/education/elearning_test_list_menu.jsp?eventCatrgory=compulsory&eventType=online" target="content"><bean:message key='<%=ConstantsServerSide.isTWAH() ? "label.onLine.twah" : "label.onLine" %>' /></html:link></span></li>
		<!-- *END SUB* --></ul></li>
		<li><span class="file"><html:link page="/portal/general.jsp?category=education.seformdl" target="content">Useful Forms Download</html:link></span></li>
		<!-- <li><span class="file"><html:link page="/education/education_material_list.jsp" target="content"><bean:message key="title.departmental.education.material" /></html:link></span></li> -->
		<li><span class="file"><html:link page="/education/other_inserv.htm" target="content">Other In-service Education(e-Learning)</html:link></span></li>
		<li><span class="file"><html:link page="/education/inserv_review.htm" target="content"><bean:message key="function.staffEducation.education.is_review" /></html:link></span></li>
		<!--  <li><span class="file"><html:link page="/education/evidence_practice.htm" target="content"><bean:message key="function.staffEducation.education.ebp" /></html:link></span></li>
		<li><span class="file"><html:link page="/education/literature_search.htm" target="content"><bean:message key="function.staffEducation.education.lsb" /></html:link></span></li>-->
		<li><span class="file"><html:link page="/education/cont_ext_edu.htm" target="content"><bean:message key="function.staffEducation.education.cee" /></html:link></span></li>
		<li><span class="file"><html:link page="/education/nchk.htm" target="content"><bean:message key="function.staffEducation.education.nchk" /></html:link></span></li>

		<li><span class="file"><html:link page="/education/record_list.jsp" target="content"><bean:message key="title.educationRecord" /></html:link></span></li>
		<!-- <li><span class="file"><html:link page="/education/video.jsp" target="content">Video</html:link></span></li> -->
		<!--<li><span class="file"><html:link page="/education/ce_list.jsp" target="content"><bean:message key="label.continuousEducation" /></html:link></span></li>-->
<%		if (userBean.isAccessible("function.course.admin")
		|| userBean.isAccessible("function.classSchedule.admin")
		|| userBean.isAccessible("function.classEnrollment.admin")
		|| userBean.isAccessible("function.eLesson.admin")
		|| userBean.isAccessible("function.eLesson.report")
		|| userBean.isAccessible("function.evaluation.list")
		|| userBean.isAccessible("function.ceBudget.admin")
		|| userBean.isAccessible("function.ceClaim.admin")) { %>
			<li class="closed"><span class="folder"><bean:message key="title.maintenance" /></span>
			<!-- *SUB MENU* --><ul>
				<%=checkUrlPermission(userBean, session, "function.course.admin", "prompt.course", null, "../education/course_list.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.classSchedule.admin", "prompt.classSchedule", null, "../education/class_schedule_list.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.classEnrollment.admin", "prompt.classEnrollment", null, "../education/class_enrollment_admin_list.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.eLesson.admin", "prompt.eLesson", null, "../education/elearning_list.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.eLesson.report", "function.eLesson.report", null, "../education/test_report_list.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.att.report", "function.att.report", null, "../education/qtrAttReport.jsp") %>
				<%=checkUrlPermission(userBean, session, "function.evaluation.list", null, null, "../education/evaluation_list.jsp?evaluationID=1") %>
			<!-- *END SUB* --></ul></li>
<%		} %>
</div>
<%	} else if ("group.crm".equals(pageCategory) && userBean.isLogin() && userBean.isAccessible("function.client.list")) { %>
<form name="form1" method="post" target="content">
<div style="margin: 5px; border-width:1px; border-style:solid; border-color:#06a; padding:5px; width:195px;">
	<ul id="browser" class="filetree">
		<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/client_info_list.jsp", "group.crm", "function.client.list") %>
		<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/client_info_approval.jsp", "group.crm", "function.client.approval") %>
		<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/client_info_export.jsp", "group.crm", "function.client.export") %>
		<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/event_enrollment_list.jsp", "group.crm", "function.event.enrollment") %>
		<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/promotion_list.htm", "group.crm", "function.event.promotion") %>
		<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/target_list.htm", "group.crm", "function.event.target") %>
<%		if (userBean.isAccessible("function.fund.list")
		|| userBean.isAccessible("function.appeal.list")
		|| userBean.isAccessible("function.campaign.list")
		|| userBean.isAccessible("function.event.list")
		|| userBean.isAccessible("function.eventType.list")
		|| userBean.isAccessible("function.membership.list")
		|| userBean.isAccessible("function.questionnaire.list")
		|| userBean.isAccessible("function.activity.list")
		|| userBean.isAccessible("function.occupation.list")
		|| userBean.isAccessible("function.title.list")
		|| userBean.isAccessible("function.religion.list")
		|| userBean.isAccessible("function.communationMethod.list")) { %>
		<li>Maintenance
			<ul>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/activity_list.jsp", "group.crm", "function.activity.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/appeal_list.jsp", "group.crm", "function.appeal.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/campaign_list.jsp", "group.crm", "function.campaign.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/club_membership_list.jsp", "group.crm", "function.membership.list") %>
				<!--<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/communation_method_list.jsp", "group.crm", "function.communationMethod.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/eventType_list.jsp", "group.crm", "function.eventType.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/occupation_list.jsp", "group.crm", "function.occupation.list") %>-->
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/donation_list.jsp", "group.crm", "function.donation.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/donor_info_list.jsp", "group.crm", "function.donor.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/event_list.jsp", "group.crm", "function.event.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/fund_list.jsp", "group.crm", "function.fund.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/physical_group_list.jsp", "group.crm", "function.crm.physicalGroup.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/questionnaire_list.jsp", "group.crm", "function.questionnaire.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/receipt_list.jsp", "group.crm", "function.receipt.list") %>
				<!--<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/religion_list.jsp", "group.crm", "function.religion.list") %>
				<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), true, "../crm/title_list.jsp", "group.crm", "function.title.list") %>-->
			</ul>
		</li>
<%		} %>
	</ul>
</ul>
<input type="hidden" name="newsCategory"/>
<input type="hidden" name="newsID"/>
<input type="hidden" name="category"/>
</form>
<%	} else if ("crm.portal".equals(pageCategory)) {
	if (userBean.isLogin()) { %>
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/crm.main.css" />" />
	<div style="background-color: #e6e6e6!important;height:100%">
		<form name="form1" method="post" target="content">
			<div id="crm-menu">
				<ul id="main">
					<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/portal.jsp", "group.crm", "function.crm.portal.home")%>
					<%--
					<li>
						<a href="#">Introduction</a>
						<ul>
							<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/chm.jsp", "group.crm", "Corporate Health Management")%>
							<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/chm_plan.jsp", "group.crm", "Corporate Health Management Plan")%>
						</ul>
					</li>
					--%>
					<li>
						<a href="#"><bean:message key="function.crm.portal.clientInfo" /></a>
						<ul>
							<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/basic_info.jsp", "group.crm", "function.crm.portal.basicInfo")%>
							<%--
							<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/maintenance.jsp", "group.crm", "Club Membership")%>
							<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/maintenance.jsp", "group.crm", "Affiliation")%>
							<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/maintenance.jsp", "group.crm", "Hobby")%>
							<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/maintenance.jsp", "group.crm", "Interest")%>
							--%>
							<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/physical_info.jsp", "group.crm", "function.crm.portal.phyInfo")%>
						</ul>
					</li>
					<%--<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/newstart.jsp", "group.crm", "N.E.W.S.T.A.R.T")%>--%>
					<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/newstart_list.jsp", "group.crm", "function.crm.portal.logBook")%>
					<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/client_calendar.jsp", "group.crm", "function.crm.portal.calendar")%>
					<%--<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/event_enrollment_list.jsp", "group.crm", "Events")--%>
					<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/course.jsp", "group.crm", "function.crm.portal.onlineCourse")%>
					<%=parseMenuUrl(userBean, session, true, false, true, "../crm/progress_note.jsp", "group.crm", "function.crm.portal.progressNote")%>
					<%if (userBean != null) {
						if (CRMClientDB.isAllTeamCaseManager(CRMClientDB.getClientID(userBean.getLoginID()))) {
					%>
						<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/case_manager_view_teamlist.jsp", "group.crm", "Team Members")%>
					<%
						}
					}
					%>

					<%if (userBean != null && userBean.isAccessible("function.crm.portal.admin")) {%>
						<li>
							<a href="#">Maintenance</a>
							<ul>
								<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/client_group_list.jsp", "group.crm", "function.crm.group.list")%>
								<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/client_info_list.jsp", "group.crm", "function.client.list")%>
								<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/user_list.jsp", "group.crm", "function.user.list")%>
								<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/event_list.jsp", "group.crm", "function.event.list")%>
								<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/event_summary.jsp", "group.crm", "Event Summary")%>
								<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/news_list.jsp", "group.crm", "function.news.list")%>
								<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/summary.jsp", "group.crm", "Summary")%>
								<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/newstart_question_list.jsp", "group.crm", "Log Book")%>
								<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/logbook_summary.jsp", "group.crm", "Log Book Summary")%>
								<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/sendEmailSMS.jsp", "group.crm", "Send Email/SMS")%>
								<%=parseMenuUrl(userBean, session, true, false, true, "../crm/portal/smsReport.jsp", "group.crm", "SMS Report")%>
							</ul>
						</li>
					<%}%>
				</ul>
				<br/>
				<input type="hidden" name="newsCategory"/>
				<input type="hidden" name="newsID"/>
				<input type="hidden" name="category"/>
			</div>
		</form>
	</div>
	<script>
		function initsidebarmenu() {
			$.each($('div#crm-menu li'), function(i, v) {
				if ($(v).find('ul').length > 0) {
					$(v).find('a:first').click(function() {
						if ($(v).attr('selected')) {
							$(v).attr('selected', false);
							//$(v).find('ul').slideUp('fast');
							//$(v).find('ul').css('display', 'none');
						} else {
							$(v).attr('selected', true);
							$(v).find('ul').slideDown('fast');
						}
					}).trigger('click');
				}
			});
		}

		$(document).ready(function() {
			initsidebarmenu();
		});

	</script>
<%	} else { %>
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/crm.main.css" />" />

	<form name="form1" method="post" target="login_content">
		<ul class="topnav">
			<li>
				<%=parseMenuUrl(userBean, session, false, false, true, "../../crm/portal/index_content.jsp", "group.crm", "function.crm.portal.home")%>
			</li>
			<%-- <li>
				<a href="/upload/CRM/Draft_chi.pdf" target="login_content">Manual (Chi)</a>
			</li>
			<li>
				<a href="/upload/CRM/Draft_eng.pdf" target="login_content">Manual (Eng)</a>
			</li>
			--%>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			 <li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li>&nbsp;</li>
			<li><a href="http://www.hphnet.org/index.php/members/hhsmembers/1794-hong-kong-adventist-hospital" target="_blank" class="special"><bean:message key="label.crm.healthPromo" /></a></li>
			<li><a href="http://hk.yahoo.com" target="_blank" class="special">Yahoo!</a></li>
			<li><a href="http://www.google.com.hk" target="_blank" class="special">Google</a></li>
			<li><%=parseMenuUrl(userBean, session, false, false, true, "../../crm/portal/contact.jsp", "group.crm", "function.crm.portal.contactUs")%></li>
		</ul>
		<input type="hidden" name="category" value=""/>
	  </form>
	<script>
	$(document).ready(function() {
		$("ul.subnav").parent().append("<span></span>"); //Only shows drop down trigger when js is enabled (Adds empty span tag after ul.subnav*)

		$("ul.topnav li span").click(function() { //When trigger is clicked...

			//Following events are applied to the subnav itself (moving subnav up and down)
			$(this).parent().find("ul.subnav").slideDown('fast').show(); //Drop down the subnav on click

			$(this).parent().hover(function() {
			}, function() {
				$(this).parent().find("ul.subnav").slideUp('slow'); //When the mouse hovers out of the subnav, move it back up
			});

			//Following events are applied to the trigger (Hover events for the trigger)
			}).hover(function() {
				$(this).addClass("subhover"); //On hover over, add class "subhover"
			}, function() {  //On Hover Out
				$(this).removeClass("subhover"); //On hover out, remove class "subhover"
		});
	});

	function getContent(link, target) {
		$.ajax({
			type: "GET",
			async: true,
			url: link,
			success: function(content) {
				$('div#'+target).html(content);
				hideOverLay('body');
				hideLoadingBox('body', 500);
			},
			error: function() {
				alert('error');
				hideLoadingBox('body', 500);
				hideOverLay('body');
			}
		});
	}
	</script>
<%
	}
} else { %>
<form name="form1" method="post" target="content">
<div class="demo-dd demo-container">
	<ul id="drilldown">
<%	if (ConstantsServerSide.isTWAH()) { %>
		<html:img page="<%=portalWordUrl %>" width="200" height="40" alt="<%=logoAlt %>" />
		<%=parseMenuUrl(userBean, session, false, false, true, "../marketing/event_calendar.jsp", null, "Master Calendar") %>
<%		if (userBean.isLogin() && isPI) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=accreditation", null, "menu.accreditation") %>
<%		} %>
<%		if (!isSecure && !isBoaOrFinMember && !isBDO && !isACHSGuest) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=bls",null, "Clinical Training Center") %>
<%		} %>
<%		if (userBean.isLogin()) { %>
<%			if (userBean.isAccessible("function.board.member") || isBoardMember) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=boardmember", null, "Board Member") %>
<%			}else if (userBean.isAccessible("function.board.invitee") || isBoardInvitee) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=boardInvitee", null, "Board Member") %>
<%			} %>
<%		} %>
<%		if (userBean.isLogin()) { %>
<%			if (userBean.isAccessible("function.committee.member")) {
				StringBuffer strBuf = new StringBuffer();
				strBuf.append("<ul>");
				strBuf.append("	<li><a href=\"../portal/general.jsp?category=committeememberComp\" target=\"content\">AHHK Compensation Review Committee</a></li>\n");
				strBuf.append("	<li><a href=\"../portal/general.jsp?category=committeememberInvest\" target=\"content\">AHHK Investment Sub-Committee</a></li>\n");
				strBuf.append("	<li><a href=\"../portal/general.jsp?category=committeememberRetire\" target=\"content\">AHHK Retirement Sub-Committee</a></li>\n");
				strBuf.append("	<li><a href=\"../portal/general.jsp?category=committeememberAudit\" target=\"content\">Audit Committee</a></li>\n");
				strBuf.append("	<li><a href=\"../portal/general.jsp?category=committeememberMedical\" target=\"content\">Medical Dental Executive Committee</a></li>\n");
				strBuf.append("	<li><a href=\"../portal/general.jsp?category=committeememberStrat\" target=\"content\">Strategic Planning Committee</a></li>\n");
				strBuf.append("	<li><a href=\"../portal/general.jsp?category=committeememberTWJoint\" target=\"content\">TW Joint Conference Committee</a></li>\n");
				strBuf.append("	<li><a href=\"../portal/general.jsp?category=committeememberTender\" target=\"content\">Tender Process & Review Committee</a></li>\n");
				strBuf.append("</ul>");
%>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "#", null, "Committee", "Committee", strBuf.toString(), null) %>
<%			} %>
<%		} %>

<%		if (userBean.isLogin() && !userBean.isGuest()) { %>
<%			if (userBean.isAccessible("function.cs.service")) { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../portal/general.jsp?category=chaplaincy", null, "menu.chaplaincy.services") %>
<%			} else { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../portal/general.jsp?category=chaplaincy", null, null, "menu.chaplaincy.services", null, "function.cs.service", null, null) %>
<%			} %>
<%			if (userBean.isAdmin() || "LAB".equals(userBean.getDeptCode())) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=clinical%20laboratory", null, "Clinical Laboratory") %>
<%			} %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure && !isACHSI && !isBoaOrFinMember && !isBDO) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=corporate", "prompt.administration", "menu.corporate") %>
<%		} %>
<%		if (!isSecure) { %>
<%			if (!isACHSI && !isBoaOrFinMember && !isBDO) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=crisis%20and%20disaster", null, "Crisis and Disaster") %>
<%			} %>
<%			if (!isBoaOrFinMember && !isBDO && !isACHSGuest) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=foodmenu", null, "Daily Food Menu") %>
<%			} %>
<%			if (!isACHSI && !isBoaOrFinMember && !isBDO) { %>
		<%=parseMenuUrl(userBean, session, true, userBean.isStaff(), true, "../portal/general.jsp?category=dept.sharing", null, null, "Departmental Sharing", null, "function.hidden", null, null) %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=doctor", null, null, "Doctor", null, null, null, null) %>
<%			} %>
<%		} %>

<%		if (userBean.isLogin() && !isBoaOrFinMember && !isBDO && !isACHSGuest) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=FMInfo", null, "Facility Management Information") %>
<%		} %>
<%		if (userBean.isLogin()) { %>
<%			if (userBean.isAccessible("function.finance.member") || isFinanceMember) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=financemember", null, "Finance Member") %>
<%			} %>
<%		} %>
<%		if (!isSecure) { %>
<%			if (!isACHSI && !isBoaOrFinMember && !isBDO) { %>
		<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=finance", null, null, "Finance", null, null, null, null) %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=forms%20and%20templates", null, "menu.forms.and.templates") %>
		<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), false, "../healthAssessment/ha_reportlist.jsp", null, null, "Health Assessmnet", null, "function.haa.report", null, null) %>
<%
			StringBuffer strBuf = new StringBuffer();
			strBuf.append("<ul>\n");
			strBuf.append("	<li><a href=\"https://ess.twah.org.hk:15443/HrPro_TW\" target=\"_blank\">ESS Login</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.userGuide\" target=\"content\">HR System User Guide</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.conduct\" target=\"content\">Code of Professional Conduct</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.handbook\" target=\"content\">Employee Handbook</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.fidelity\" target=\"content\">Fidelity Member Briefing</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.forms\" target=\"content\">Forms</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.calendar\" target=\"content\">Hospital Holiday</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.orientation\" target=\"content\">Orientation Schedule</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.payroll\" target=\"content\">Payroll Schedule</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.evaluation\" target=\"content\">Performance Evaluation</a></li>\n");
			strBuf.append("</ul>");
%>
<%				if (userBean != null && userBean.isLogin()) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "#", null, "human%20resources", "department.710", strBuf.toString(), null) %>
<%				} %>
<%			} %>
<%		} %>
<%		if (userBean.isLogin() && userBean.isAccessible("function.hr.essExternal")) { %>
			<li><a href="https://mail.twah.org.hk:15443/HrPro_TW\" target=_blank"><b>Human Resources - ESS Login(External)</b></a></li>
<%		} %>
<%		if (userBean.isLogin() && (!userBean.isGuest() || "piuser".equals(userBean.getLoginID())) && !isSecure && !isBoaOrFinMember && !isBDO) { %>
		<%=parseMenuUrl(userBean, session, true, false, true, "../pi/incident_reporting.jsp", null, "Incident Reporting") %>
<%		} %>
<%		if (!isSecure && !isBoaOrFinMember && !isBDO && !isACHSGuest) { %>
		<li><a href="../ic/testNewIndex.jsp" target=_blank"><b>Infection Control</b></a></li>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isACHSI && !isBoaOrFinMember && !isBDO && !isACHSGuest) { %>
		<%=parseMenuUrl(userBean, session, true, false, true, "../portal/general.jsp?category=information%20sharing", "prompt.information", "Information Sharing") %>
<%		} %>
<%		if (!isSecure) { %>
<%			if (!isACHSI && !isBoaOrFinMember && !isBDO) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=informed%20consent", null, "menu.informed.consent") %>
<%			} %>
<%		} %>
<%		if (userBean.isAccessible("function.info.type.ias")) { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../portal/general.jsp?category=ias", null, "Internal Audit Service") %>
<%		} %>
<%		if (!isSecure) { %>
<%			if (!isBoaOrFinMember && !isBDO) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=LMC", null, "department.520") %>
<%			} %>
<%			if (!isACHSI && !isBoaOrFinMember && !isBDO) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=marketing", null, "department.750") %>
<%			} %>
<%			if (!isBoaOrFinMember && !isBDO && !isACHSGuest) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=medical%20affairs", null, "Medical Affairs") %>
<%			} %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isBoaOrFinMember && !isBDO && !isACHSGuest) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=nursing", null, "Nursing") %>
<%		} %>
<%		if (!isSecure){ %>
		<li><a href="http://192.168.0.83/" target=_blank"><b>Nursing Information System (NIS)</b></a></li>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isACHSI && !isBoaOrFinMember && !isBDO && !isACHSGuest) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=nursingSchool", null, "Nursing School") %>
<%
				StringBuffer strBuf = new StringBuffer();
				strBuf.append("<ul>");
				strBuf.append("	<li><a href=\"#\">Warehouse Requisition</a>");
				strBuf.append("		<ul>");
				strBuf.append("	<li><a href=\"../common/gwt2mm.jsp?moduleCode=ivs\" target=\"content\">Warehouse Requisition</a></li>\n");
				strBuf.append("		</ul>");
				strBuf.append("	</li>");
				strBuf.append("	<li><a href=\"#\">Purchase Requisition</a>");
				strBuf.append("		<ul>");
				strBuf.append("			<li><a href=\"../common/gwt2mm.jsp?moduleCode=pms&catType=form\" target=\"content\">Hospital Form</a>");
				strBuf.append("			<li><a href=\"../common/gwt2mm.jsp?moduleCode=pms&catType=wardstock\" target=\"content\">Self/Ward stock for patient</a>");
				strBuf.append("			<li><a href=\"../epo/retrieveRequest.jsp?catType=noninv\" target=\"content\">Non-inventory item(EPR)</a></li>\n");
				strBuf.append("			<li><a href=\"../epo/retrieveRequest.jsp?catType=capitem\" target=\"content\">Captial item</a></li>\n");
				strBuf.append("			<li><a href=\"javascript:void(0);\" onclick=\"callMms();return false;\" target=\"content\">MMS</a>");
				strBuf.append("		</ul>");
				strBuf.append("	</li>");
				strBuf.append("	<li><a href=\"#\">Stationary</a>");
				strBuf.append("		<ul>");
				strBuf.append("			<li><a href=\"javascript:void(0);\" onclick=\"callBigBoxx();return false;\" target=\"content\">Bigboxx</a>");
				strBuf.append("			<li><a href=\"javascript:void(0);\" onclick=\"callUnion();return false;\" target=\"content\">Union</a>");
				strBuf.append("			<li><a href=\"../epo/retrieveRequest.jsp\" target=\"content\">Others</a></li>\n");
				strBuf.append("		</ul>");
				strBuf.append("	</li>");
				strBuf.append("</ul>");
%>
<%			if (!isACHSI && !isBoaOrFinMember && !isBDO && !isACHSGuest) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "#", null, "Order%Requisition", "menu.material.management", strBuf.toString(), null) %>
<%			} %>
<%		} %>
<%		if (!isSecure && !isBoaOrFinMember && !isBDO) { %>
		<li><a href="\\it-fs1\Public\TW_Intranet\Dept\OSH\OSH FRONT PAGE\OSH Front page.htm" target="_blank">OSH</a></li>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isBoaOrFinMember && !isBDO) { %>
<%//20210125 Arran added for TWAH leafet
			if (ConstantsServerSide.isTWAH()) { %>
				<%=parseMenuUrl(userBean, session, false, false, true, "../cms/lms_leaflet_list.jsp", null, "Patient and Family Education Information") %>
<%			} else { %>
				<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=pfeInfo", null, "Patient and Family Education Information") %>
<%			}
		} %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=pem", null, "Patient Experience Model Program") %>
<%			if (!isACHSI && !isACHSGuest) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=pharm", null, "Pharmacy") %>
<%			} %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../portal/general.jsp?category=physician", null, "prompt.administration", "Physician", "viewPhy", null, null, null) %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isBoaOrFinMember && !isBDO) { %>
		<%=parseMenuUrl(userBean, session, true, false, true, "../portal/general.jsp?category=price.transparency", null, "Price Transparency") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure && !isBoaOrFinMember && !isBDO) { %>
		<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=policy", null, "menu.policy.and.resources") %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=regulations", null, "menu.regulation.and.ordinance") %>
<%		} else if (userBean.isLogin() && userBean.isAccessible("function.pi.policy") && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, true, isSecure, false, "../portal/general.jsp?category=policy", null, "menu.policy.and.resources") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isBoaOrFinMember && !isBDO) { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../common/leftright_portal.jsp", "title.education", "Staff Education") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure && ! isACHSI && !isBoaOrFinMember && !isBDO && !isACHSGuest) { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../portal/general.jsp?category=statistics", "prompt.administration", "menu.statistics") %>
<%		} %>
<%	} else if (ConstantsServerSide.isHKAH()) { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../marketing/event_calendar.jsp", null, "Master Calendar") %>
<%		if (userBean.isLogin()) { %>
<%			if (userBean.isAccessible("function.ac.member") || isACMember) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=acmember", null, "AC Members") %>
<%			} %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
<%			if (isPI) {%>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=accreditation", null, "menu.accreditation") %>
<%			} %>
<%		} %>
<%		if (userBean.isLogin() && (userBean.isAccessible("function.bom.member") || isBomMember)) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=bomMeeting", null, "BOM Meeting") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=briefing%20room", null, "menu.briefing.room") %>
<%			if (userBean.isAdmin() || "230".equals(userBean.getDeptCode())) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=clinical%20laboratory", null, "Clinical Laboratory") %>
<%			} %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=corporate", "prompt.administration", "menu.corporate") %>
<%		} %>
<%		if (!isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=crisis%20and%20disaster", null, "menu.crisis.and.disaster") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest()) { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../portal/general.jsp?category=chaplaincy", null, null, "menu.chaplaincy.services", null, "function.cs.service", null, null) %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
<%			if (!isACHSGuest){ %>
		<%=parseMenuUrl(userBean, session, true, userBean.isStaff(), true, "../portal/general.jsp?category=dept.sharing", null, null, "Departmental Sharing", null, "function.hidden", null, null) %>
<%			} %>
<%		} %>
<%		if (userBean.isLogin() && (userBean.isAccessible("function.executive.member") || isExecutiveMember)) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=executiveMeeting", null, "Executive Meeting") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=financial.information", null, "Financial Information") %>
<%		} %>
<%		if (!isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=forms%20and%20templates", null, "menu.forms.and.templates") %>
<%
			StringBuffer strBuf = new StringBuffer();
			strBuf.append("<ul>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.aboutHR\" target=\"content\">About HR</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.contactHR\" target=\"content\">Contact HR</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.training\" target=\"content\">Training & Development</a></li>\n");
			if (userBean.isLogin()) {
				if (Converter.checkPolicyAccess(userBean) || userBean.isAdmin()) {
					strBuf.append("	<li><a onclick=\" downloadFile('770', ''); return false;\" href=\"javascript:void(0);\" target=\"_blank\">Policies</a></li>\n");
				} else {
					strBuf.append("	<li><a onclick=\" downloadFile('770', ''); return false;\" href=\"javascript:void(0);\" target=\"_blank\">Policies</a></li>\n");
				}
			}
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.evaluation\" target=\"content\">Performance Evaluation</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.payroll\" target=\"content\">Payroll</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.news\" target=\"content\">News & Events</a></li>\n");
			//strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.directory\" target=\"content\">Directory</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.jobs\" target=\"content\">Jobs</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.forms\" target=\"content\">Forms & Documents</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.benefits\" target=\"content\">Employee Benefits</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.calendar\" target=\"content\">Calendar</a></li>\n");
			strBuf.append("	<li><a href=\"https://ess.twah.org.hk:15443/hrpro_sr\" target=\"_blank\">eHR Login</a></li>\n");
			strBuf.append("	<li><a href=\"../documentManage/download2.jsp?embedVideoYN=Y&rootFolder=\\\\WWW-SERVER\\Swf\\&locationPath=\\e-CE Training\" target=\"content\">e-CE Training</a></li>\n");
			if (!isSecure && userBean != null && userBean.isLogin()) {
				//strBuf.append("	<li><a href=\"http://192.168.0.59/\" target=\"_blank\">eHR Login</a></li>\n");
				//strBuf.append("	<li><a onclick=\" downloadFile('702', ''); return false;\" href=\"javascript:void(0);\" target=\"content\">Employee Self-service (ESS) Manual - eLeave</a></li>\n");
				//strBuf.append("	<li><a onclick=\" downloadFile('713', ''); return false;\" href=\"javascript:void(0);\" target=\"content\">員工自助服務使用手冊－<br/>休假申請</a></li>\n");
			}
			strBuf.append("</ul>");
%>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "#", null, "human%20resources", "department.710", strBuf.toString(), null) %>
<%		}else{ %>
		<li><a href="https://ess.twah.org.hk:15443/hrpro_sr" target=_blank"><b>eHR Login</b></a></li>
<%		} %>
<%		if (userBean.isLogin() && (!userBean.isGuest() || "piuser".equals(userBean.getLoginID())) && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, true, false, true, "../pi/incident_reporting.jsp", null, "menu.incident.reporting") %>
<%			if (userBean.isAdmin()) { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../pi/incident_reporting3.jsp", null, "IR (admin only)") %>
<%			} %>
<%		} %>
<%		if (userBean.isLogin() &&!isSecure && !isBoaOrFinMember && !isBDO && !isACHSGuest) { %>
		<li><a href="../ic/testNewIndex.jsp" target=_blank"><b>Infection Control</b></a></li>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isACHSGuest) { %>
		<%=parseMenuUrl(userBean, session, true, false, true, "../portal/general.jsp?category=information%20sharing", "prompt.information", "menu.information.sharing") %>
<%		} %>
<%		if (!isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=informed%20consent", null, "menu.informed.consent") %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=LMC", null, "department.520") %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=marketing", null, "department.750") %>
<%		} %>

<%		if (!isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, false, false, "../portal/typhoon.jsp", null, "menu.typhoon.notice") %>
<%		} %>

<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
<%			if ("100".equals(userBean.getDeptCode())
				|| "110".equals(userBean.getDeptCode())
				|| "120".equals(userBean.getDeptCode())
				|| "130".equals(userBean.getDeptCode())
				|| "140".equals(userBean.getDeptCode())
				|| "150".equals(userBean.getDeptCode())
				|| "160".equals(userBean.getDeptCode())
				|| "330".equals(userBean.getDeptCode())
				|| "360".equals(userBean.getDeptCode())
				|| "365".equals(userBean.getDeptCode())
				|| "370".equals(userBean.getDeptCode())
				|| "200".equals(userBean.getDeptCode())
				|| "790".equals(userBean.getDeptCode())
				|| "770".equals(userBean.getDeptCode())
				|| "210".equals(userBean.getDeptCode())
				|| userBean.isGroupID("nursing.library")) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=nursingLibrary", null, "Nursing Virtual Library") %>
<%			} %>
<%			if (!isACHSGuest){ %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=nursingSchool", null, "Nursing School") %>
<%			} %>
<%		} %>
<%		if (!isSecure){ %>
		<li><a href="http://160.100.3.42/" target=_blank"><b>Nursing Information System (NIS)</b></a></li>
<%		} %>
<%		if (userBean.isLogin() && (userBean.isAccessible("function.operation.member") || isOperationMember)) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=operationMeeting", null, "Operation Meeting") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest()) { %>
<%
				StringBuffer strBuf = new StringBuffer();
				strBuf.append("<ul>");
				strBuf.append("	<li><a href=\"#\">Warehouse Requisition</a>");
				strBuf.append("		<ul>");
				strBuf.append("	<li><a href=\"../common/gwt2mm.jsp?moduleCode=ivs\" target=\"content\">Warehouse Requisition</a></li>\n");
				strBuf.append("		</ul>");
				strBuf.append("	</li>");
				strBuf.append("	<li><a href=\"#\">Purchase Requisition</a>");
				strBuf.append("		<ul>");
				strBuf.append("			<li><a href=\"../common/gwt2mm.jsp?moduleCode=pms&catType=form\" target=\"content\">Hospital Form</a>");
				strBuf.append("			<li><a href=\"../common/gwt2mm.jsp?moduleCode=pms&catType=wardstock\" target=\"content\">Self/Ward stock for patient</a>");
				strBuf.append("			<li><a href=\"../epo/retrieveRequest.jsp?catType=noninv\" target=\"content\">Non-inventory item(EPR)</a></li>\n");
				strBuf.append("			<li><a href=\"../epo/retrieveRequest.jsp?catType=capitem\" target=\"content\">Captial item</a></li>\n");
				strBuf.append("			<li><a href=\"javascript:void(0);\" onclick=\"callMms();return false;\" target=\"content\">MMS</a>");
				strBuf.append("		</ul>");
				strBuf.append("	</li>");
				strBuf.append("	<li><a href=\"#\">Stationary</a>");
				strBuf.append("		<ul>");
				strBuf.append("			<li><a href=\"javascript:void(0);\" onclick=\"callBigBoxx();return false;\" target=\"content\">Bigboxx</a>");
				strBuf.append("			<li><a href=\"javascript:void(0);\" onclick=\"callUnion();return false;\" target=\"content\">Union</a>");
				strBuf.append("			<li><a href=\"../epo/retrieveRequest.jsp\" target=\"content\">Others</a></li>\n");
				strBuf.append("		</ul>");
				strBuf.append("	</li>");
				strBuf.append("</ul>");
%>
<%			if (!isACHSGuest){ %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "#", null, "Order%Requisition", "menu.material.management", strBuf.toString(), null) %>
<%			} %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=osh%20documents", null, "menu.osh.documents") %>
<%		} %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=nur", null, "Patient and Family Education") %>
<%		if (!isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, false, false, "../portal/general.jsp?category=pem", null, "Patient Experience Model Program") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../portal/general.jsp?category=physician", null, "prompt.administration", "Physician", "administration.statistic", "function.physician.view", null, null) %>
		<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=policy", null, "menu.policy.and.resources") %>
<%			if ("3761".equals(userBean.getStaffID()) || "5272".equals(userBean.getStaffID()) || userBean.isAdmin()) { %>
		<%=parseMenuUrl(userBean, session, true, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=policyTest", null, "Policy Test") %>
<%			} %>
<%		} else if (userBean.isLogin() && userBean.isAccessible("function.pi.policy") && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, true, isSecure, false, "../portal/general.jsp?category=policy", null, "menu.policy.and.resources") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest()) { %>
		<%=parseMenuUrl(userBean, session, true, false, true, "../portal/general.jsp?category=price.transparency", null, "Price Transparency") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=regulations", null, "menu.regulation.and.ordinance") %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=roster", null, "menu.roster") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest()) { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../common/leftright_portal.jsp", "title.education", "Staff Education") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../portal/general.jsp?category=statistics", null, "prompt.administration", "menu.statistics", "administration.statistic", null, null, null) %>
<%			if (!isACHSGuest){ %>
		<%=parseMenuUrl(userBean, session, true, true, false, "../portal/general.jsp?category=special%20sharing", null, "menu.special.sharing") %>
<%			} %>
<%		} %>
<%		if (!isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=usefullink", null, "Useful Link") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, true, true, false, "../documentManage/vpa.jsp?locationPath=\\VPA", null, null, "VPA", "vpa.dir.view", null, null, null) %>
<%		} else { %>
<%			if ("dr1967".equals(userBean.getUserName())) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=roster", null, "menu.roster") %>
<%			} %>
<%		} %>
<%	} else if (ConstantsServerSide.isAMC()) { %>
<%		if (userBean.isLogin() && !userBean.isGuest()) { %>
		<%=parseMenuUrl(userBean, session, true, false, true, "../portal/general.jsp?category=information%20sharing", "prompt.information", "menu.information.sharing") %>
<%		} %>
<%	} else if (ConstantsServerSide.isAMC() || ConstantsServerSide.isAMC2()) { %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=briefing%20room", null, "menu.briefing.room") %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=corporate", "prompt.administration", "menu.corporate") %>
<%		} %>
<%		if (!isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=crisis%20and%20disaster", null, "menu.crisis.and.disaster") %>
<%		} %>
<%
			StringBuffer strBuf = new StringBuffer();
			strBuf.append("<ul>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.forms\" target=\"content\">Forms & Documents</a></li>\n");
			strBuf.append("	<li><a href=\"../portal/general.jsp?category=hr.hris\" target=\"content\">HRIS</a></li>\n");
			strBuf.append("	<li><a href=\"https://ess.twah.org.hk:15443/hrpro_sr\" target=\"_blank\">eHR Login</a></li>\n");
			if (!isSecure && userBean != null && userBean.isLogin()) {
				//strBuf.append("	<li><a href=\"http://192.168.0.59/\" target=\"_blank\">eHR Login</a></li>\n");
				//strBuf.append("	<li><a onclick=\" downloadFile('702', ''); return false;\" href=\"javascript:void(0);\" target=\"content\">Employee Self-service (ESS) Manual - eLeave</a></li>\n");
				//strBuf.append("	<li><a onclick=\" downloadFile('713', ''); return false;\" href=\"javascript:void(0);\" target=\"content\">員工自助服務使用手冊－<br/>休假申請</a></li>\n");
			}
			strBuf.append("</ul>");
%>
		<%=parseMenuUrl(userBean, session, true, userBean.isStaff(), true, "#", null, "human%20resources", "department.710", strBuf.toString(), null) %>
<%		if (userBean.isLogin() && (!userBean.isGuest() || "piuser".equals(userBean.getLoginID())) && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, true, false, true, "../pi/incident_reporting.jsp", null, "menu.incident.reporting") %>
<%			if (userBean.isAdmin()) { %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../pi/incident_reporting3.jsp", null, "IR (admin only)") %>
<%			} %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest()) { %>
		<%=parseMenuUrl(userBean, session, true, false, true, "../portal/general.jsp?category=information%20sharing", "prompt.information", "menu.information.sharing") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest()) { %>
<%
				strBuf.setLength(0);
				strBuf.append("<ul>");
				strBuf.append("	<li><a href=\"#\">Warehouse Requisition</a>");
				strBuf.append("		<ul>");
				strBuf.append("	<li><a href=\"../common/gwt2mm.jsp?moduleCode=ivs\" target=\"content\">Warehouse Requisition</a></li>\n");
				strBuf.append("		</ul>");
				strBuf.append("	</li>");
				strBuf.append("	<li><a href=\"#\">Purchase Requisition</a>");
				strBuf.append("		<ul>");
				strBuf.append("			<li><a href=\"../common/gwt2mm.jsp?moduleCode=pms&catType=form\" target=\"content\">Hospital Form</a>");
				strBuf.append("			<li><a href=\"../common/gwt2mm.jsp?moduleCode=pms&catType=wardstock\" target=\"content\">Self/Ward stock for patient</a>");
				strBuf.append("			<li><a href=\"../epo/retrieveRequest.jsp?catType=noninv\" target=\"content\">Non-inventory item(EPR)</a></li>\n");
				strBuf.append("			<li><a href=\"../epo/retrieveRequest.jsp?catType=capitem\" target=\"content\">Captial item</a></li>\n");
				strBuf.append("			<li><a href=\"javascript:void(0);\" onclick=\"callMms();return false;\" target=\"content\">MMS</a>");
				strBuf.append("		</ul>");
				strBuf.append("	</li>");
				strBuf.append("	<li><a href=\"#\">Stationary</a>");
				strBuf.append("		<ul>");
				strBuf.append("			<li><a href=\"javascript:void(0);\" onclick=\"callBigBoxx();return false;\" target=\"content\">Bigboxx</a>");
				strBuf.append("			<li><a href=\"javascript:void(0);\" onclick=\"callUnion();return false;\" target=\"content\">Union</a>");
				strBuf.append("			<li><a href=\"../epo/retrieveRequest.jsp\" target=\"content\">Others</a></li>\n");
				strBuf.append("		</ul>");
				strBuf.append("	</li>");
				strBuf.append("</ul>");
%>
<%			if (!isACHSGuest){ %>
		<li><a href="http://160.100.2.80/intranet/" target=_blank"><b>Order Requisition (HKAH-SR)</b></a></li>
<%			} %>
<%		} %>
		<%=parseMenuUrl(userBean, session, true, true, true, "../portal/general.jsp?category=physician", null, "prompt.administration", "Physician", "administration.statistic", "function.physician.view", null, null) %>
<%		if (userBean.isLogin() && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, true, isSecure, false, "../portal/general.jsp?category=policy", null, "menu.policy.and.resources") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest()) { %>
		<%=parseMenuUrl(userBean, session, true, false, true, "../portal/general.jsp?category=price.transparency", null, "Price Transparency") %>
<%		} %>
<%		if (userBean.isLogin() && !userBean.isGuest() && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), true, "../portal/general.jsp?category=regulations", null, "menu.regulation.and.ordinance") %>
		<%=parseMenuUrl(userBean, session, false, isSecure || userBean.isStaff(), false, "../portal/general.jsp?category=roster", null, "menu.roster") %>
<%		} %>
<%	} else if ("achsi".equals(userBean.getLoginID())) { %>
		<!-- <%=parseMenuUrl(userBean, session, false, isSecure, true, "../portal/general.jsp?category=accreditation", null, "menu.accreditation") %> -->
		<%=parseMenuUrl(userBean, session, true, false, true, "../pi/incident_reporting.jsp", null, "Incident Reporting") %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=regulations", null, "menu.regulation.and.ordinance") %>
		<%=parseMenuUrl(userBean, session, true, false, true, "../common/leftright_portal.jsp", "title.education", "Staff Education") %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=usefullink", null, "Useful Link") %>
<%	} %>
<%	if (!ConstantsServerSide.isAMC() && !ConstantsServerSide.isAMC2() && userBean.isLogin()) { %>
<%		if (userBean.isNSUser() && !isSecure) { %>
		<%=parseMenuUrl(userBean, session, false, false, true, "../portal/general.jsp?category=nursingSchool", null, "Nursing School") %>
		<li><span class="file"><html:link page="/portal/general.jsp?category=e-resource" target="content"><bean:message key="menu.e.resource" /></html:link></span></li>
<%		}%>
		<%=parseMenuUrl(userBean, session, true, false, true, "../forwardScanning/index.jsp", null, null, "Forward Scanning", null, "function.fs.admin", null, null) %>
<%	} %>
		<!--<%=parseMenuUrl(userBean, session, false, false, false, "../portal/contactUs.jsp", null, "menu.contact.us") %>-->
<%	if (userBean.isLogin()) { %>
		<li><html:link page="/Logoff.do" target="_top"><b><bean:message key="menu.logout" /></b></html:link></li>
<%	} %>
	</ul>
</div>
<br/>
<input type="hidden" name="newsCategory"/>
<input type="hidden" name="newsID"/>
<input type="hidden" name="category"/>
</form>
<script language="JavaScript">
<!--
	$(document).ready(function($) {
		$('#drilldown').dcDrilldown({
			speed			: 'fast',
			saveState		: true,
			showCount		: false,
//			linkType		: 'link',
//			linkType		: 'breadcrumb',
			linkType		: 'backlink',
//			backText		: 'All',
			defaultText		: '<bean:message key="button.select" />'
		});

		//added extra height on menu. problem:unable to display some of the items.
		$('#drilldown').css("height",'1300px');
	});
-->
</script>
<%	} %>
<script language="JavaScript">
<!--
	function elearningTest(eid) {
		callPopUpWindow('../education/elearning_test.jsp?command=&elearningID=' + eid);
		window.open("../education/education_calendar.jsp", "content");
	}

	function callMms() {
		<%	if (ConstantsServerSide.DEBUG) { %>
			callPopUpWindow("http://160.100.2.73:9080/MMS/mms_entrance.do?session_id=<%=sessionId%>");
		<%}else{ %>
			callPopUpWindow("http://192.168.0.244:9080/MMS/mms_entrance.do?session_id=<%=sessionId%>");
		<%}; %>
	}

	function callBigBoxx() {
		callPopUpWindow("http://www.bigboxx.com");
	}

	function callUnion() {
		callPopUpWindow("http://www.union.com.hk/");
	}

	function readNews(cid, nid) {
		document.form1.action = "../portal/news_view.jsp";
		document.form1.newsCategory.value = cid;
		document.form1.newsID.value = nid;
		document.form1.submit();
		return true;
	}

	function changeUrl(aid, cid) {
		if (aid != '') {
			if (cid == 'title.education') {
				top.frames['bigcontent'].location.href = aid + '?category=' + cid;
			} else if (cid == 'ic') {
				top.frames['bigcontent'].location.href = aid;
							} else {
				document.form1.action = aid;
				document.form1.category.value = cid;
				document.form1.submit();
			}
		} else {
			alert("Under Construction");
		}
	}

	function searchClear() {
		if (document.search_doc.query.value == "<bean:message key="menu.search" /> ...") {
			document.search_doc.query.value = "";
		}
	}

	function searchDefault() {
		if (document.search_doc.query.value == "") {
			document.search_doc.query.value = "<bean:message key="menu.search" /> ...";
		}
	}

	function searchEngine() {
		if (document.search_doc.query.value == "" || document.search_doc.query.value == "<bean:message key="menu.search" /> ...") {
			alert("Empty search value");
			document.search_doc.query.value = "";
			document.search_doc.query.focus();
			return false;
		} else {
			var searchType = document.forms["search_doc"].elements["searchType"];
			if (searchType[0].checked) {
<%	if (userBean.isLogin()) { %>
				document.search_doc.action = "../documentManage/search.jsp";
				document.search_doc.submit();
				return true;
<%	} else { %>
				alert('Please login to access hospital document!');
				return false;
<%	} %>
			} else {
<%	if (userBean.isLogin()) { %>
				document.search_doc.action = "../documentManage/search_doc.jsp";
				document.search_doc.submit();
				return true;
<%	} else { %>
				alert('Please login to access hospital policy!');
				return false;
<%	} %>
			}
		}
	}

	function handleEnter(inField, e) {
		var charCode;

		if (e && e.which) {
			charCode = e.which;
		} else if (window.event) {
			e = window.event;
			charCode = e.keyCode;
		}

		if (charCode == 13) {
			searchEngine();
		}
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>