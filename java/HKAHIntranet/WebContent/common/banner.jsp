<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.AccessControlDB"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private HashMap<String, String> getAllowModule(String staffID) {
		HashMap<String, String> moduleMap = new HashMap<String, String>();
		try {
			ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListSEED("SELECT MODULE_CODE, MODULE_USER_ID FROM SSO_USER_MAPPING WHERE SSO_USER_ID = ? AND ENABLED = 1", new String[] { staffID });
			ReportableListObject row = null;
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
					moduleMap.put(row.getValue(0), row.getValue(1));
				}
			}
		} catch (Exception e) {
		}
		return moduleMap;
	}
%>
<%
// set default locale
MessageResources.getMessage(session, "prompt.loginPage");

UserBean userBean = new UserBean(request);
String mode = request.getParameter("mode");
boolean isAllowHKPRODHATSFlag = false;
boolean isAllowHKUATHATSFlag = false;
boolean isAllowTWPRODHATSFlag = false;
boolean isAllowTWUATHATSFlag = false;
boolean isAllowTWUATHATS2Flag = false;
boolean isAllowAMCPRODHATSFlag = false;
boolean isAllowAMCUATHATSFlag = false;
boolean isAllowAMC1PRODHATSFlag = false;
boolean isAllowAMC1UATHATSFlag = false;
boolean isAllowAMC2PRODHATSFlag = false;
boolean isAllowAMC2UATHATSFlag = false;
boolean isAllowCMS3Flag = false;

if (userBean.isLogin()) {
	HashMap<String, String> moduleMap = getAllowModule(userBean.getStaffID());
	isAllowHKPRODHATSFlag = moduleMap.containsKey("hats.prod.hkah");
	isAllowHKUATHATSFlag = moduleMap.containsKey("hats.uat.hkah");
	isAllowTWPRODHATSFlag = moduleMap.containsKey("hats.prod.twah");
	isAllowTWUATHATSFlag = moduleMap.containsKey("hats.uat.twah");
	isAllowTWUATHATS2Flag = moduleMap.containsKey("hats.uat.twah2");
	isAllowAMCPRODHATSFlag = moduleMap.containsKey("hats.prod.amc");
	isAllowAMCUATHATSFlag = moduleMap.containsKey("hats.uat.amc");
	isAllowAMC1PRODHATSFlag = moduleMap.containsKey("hats.prod.amc1");
	isAllowAMC1UATHATSFlag = moduleMap.containsKey("hats.uat.amc1");
	isAllowAMC2PRODHATSFlag = moduleMap.containsKey("hats.prod.amc2");
	isAllowAMC2UATHATSFlag = moduleMap.containsKey("hats.uat.amc2");
	//isAllowCMS3Flag = moduleMap.containsKey("cis");
}

String userInfo = null;
if (userBean.isLogin()) {
	if ((userBean.isAllowAdmin() || userBean.isSwitchUser()) && !userBean.isAdmin() && "admin".equals(mode)) {
		if (userBean.isAllowAdmin() || userBean.isSwitchUser()) {
			userBean.setAdmin(request);
		}
		userBean = new UserBean(request);
		%><script language="javascript">top.frames['bigcontent'].location.reload();</script><%
	} else if (userBean.isAdmin() && "switch".equals(mode)) {
		userBean = UserDB.getUserBean(request, request.getParameter("staffID"));
		%><script language="javascript">top.frames['bigcontent'].location.reload();</script><%
	}

	StringBuffer strbuf = new StringBuffer();
	if (userBean.isAdmin()) {
		HashSet<String> switchUserSet = userBean.getSwitchUserID();
		String switchUserID = null;
		int counter = 0;
//		strbuf.append(userBean.getLoginID());
		strbuf.append("admin");
		if (switchUserSet != null) {
			strbuf.append(" [ ");
			for (Iterator<String> i = switchUserSet.iterator(); i.hasNext(); ) {
				switchUserID = i.next();
				if (counter++ > 0) strbuf.append("| ");
				strbuf.append("<a href=\"banner.jsp?mode=switch&staffID=");
				strbuf.append(switchUserID);
				strbuf.append("\"> ");
				strbuf.append(StaffDB.getStaffName(switchUserID));
				strbuf.append(" (");
				strbuf.append(switchUserID);
				strbuf.append(") </a>");
			}
			strbuf.append(" ]");
		}
	} else {
		strbuf.append(userBean.getUserName());

		StringBuffer desc = new StringBuffer();
		if (ConstantsServerSide.DEBUG) {
			desc.append(userBean.getUserGroupDesc());
			desc.append("@");
		}
		desc.append((userBean.getDeptDesc() == null || "".equals(userBean.getDeptDesc())?"":userBean.getDeptDesc()));
		if (desc.length() > 0) {
			strbuf.append(" (");
			strbuf.append(desc);
			strbuf.append(")");
		}

		if ((userBean.isAdmin() || userBean.isAllowAdmin() || userBean.isSwitchUser()) && (!ConstantsServerSide.SECURE_SERVER || ConstantsServerSide.DEBUG)) {
			if (!ConstantsServerSide.CORE_SERVER && ConstantsServerSide.LOAD_BALANCE) {
				strbuf.append(" [ <a href=\"http://");
				strbuf.append(ConstantsServerSide.INTRANET_URL);
				strbuf.append("/intranet/index.jsp?mode=admin&sessionID=");
				if (request.getSession() != null) {
					strbuf.append(request.getSession().getId());
				}
				strbuf.append("&staffID=");
				if (userBean != null && userBean.isLogin()) {
					strbuf.append(userBean.getStaffID());
				}
				strbuf.append("\">Switch to Admin</a> ]");
			} else {
				strbuf.append(" [ <a href=\"banner.jsp?mode=admin\">Switch");
				if (userBean.isSwitchUser()) {
					strbuf.append(" back");
				}
				strbuf.append(" to Admin</a> ]");
			}
		}
	}
	userInfo = strbuf.toString();
} else {
	userInfo = "";
}

String logoUrl = null;
String logoAlt = null;
String portalWordUrl = null;
String anotherUrl = "http://" + ConstantsServerSide.INTRANET_ANOTHER_SITE_URL + "/intranet";
String anotherLabel = null;
if (ConstantsServerSide.isHKAH()) {
	logoUrl = "/images/hkah_portal_logo.gif";
	logoAlt = MessageResources.getMessage(session, "label.hongKongAdventistHospital") + " " +
				MessageResources.getMessage(session, "label.intranetPortal");
	anotherLabel = "TWAH";
} else if (ConstantsServerSide.isTWAH()) {
	logoUrl = "/images/twah_portal_logo.gif";
	logoAlt = MessageResources.getMessage(session, "label.tsuenWanAdventistHospital") + " " +
				MessageResources.getMessage(session, "label.intranetPortal");
	anotherLabel = "HKAH";
} else if (ConstantsServerSide.isAMC1()) {
	logoUrl = "/images/amc_portal_logo.gif";
	logoAlt = MessageResources.getMessage(session, "label.amc1") + " " +
				MessageResources.getMessage(session, "label.intranetPortal");
	anotherUrl = "http://" + ConstantsServerSide.OFFSITE_URL + "/intranet";
	anotherLabel = "HKAH";
} else if (ConstantsServerSide.isAMC2()) {
	logoUrl = "/images/amc_portal_logo.gif";
	logoAlt = MessageResources.getMessage(session, "label.amc2") + " " +
				MessageResources.getMessage(session, "label.intranetPortal");
	anotherUrl = "http://" + ConstantsServerSide.OFFSITE_URL + "/intranet";
	anotherLabel = "HKAH";
} else {
	logoUrl = "/images/amc_portal_logo.gif";
	logoAlt = MessageResources.getMessage(session, "label.amc") + " " +
				MessageResources.getMessage(session, "label.intranetPortal");
	anotherUrl = "http://" + ConstantsServerSide.OFFSITE_URL + "/intranet";
	anotherLabel = "HKAH";
}

Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);
if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {
	portalWordUrl = "intranet-portal-zh_tw.jpg";
} else {
	portalWordUrl = "intranet-portal.gif";

	// change logo
	int current_mm = DateTimeUtil.getCurrentMonth();
	int current_dd = DateTimeUtil.getCurrentDay();
	if (current_mm == 1 || current_mm == 2) {
		portalWordUrl = "intranet-portal-newyear.jpg";
	} else if (current_mm == 5) {
		portalWordUrl = "intranet-portal-mothersday.jpg";
	} else if (current_mm == 6) {
		portalWordUrl = "intranet-portal-dragonboat.jpg";
	} else if (current_mm == 7 && current_dd == 1) {
		portalWordUrl = "intranet-portal-hongkong.jpg";
	} else if (current_mm == 12) {
		portalWordUrl = "intranet-portal-xmas.jpg";
	}

/*
	if (userBean != null && userBean.isLogin() && (userBean.isAdmin() || userBean.isAllowAdmin())) {
		int randomno = (new Random()).nextInt(30);

		if (randomno == 1) {
			portalWordUrl = "intranet-portal-captain.jpg";
		} else if (randomno == 2) {
			portalWordUrl = "intranet-portal-ironman.jpg";
		} else if (randomno == 3) {
			portalWordUrl = "intranet-portal-spiderman.jpg";
		} else if (randomno == 4) {
			portalWordUrl = "intranet-portal-ultraman.jpg";
		} else if (randomno == 5) {
			portalWordUrl = "intranet-portal-pacman.gif";
		} else if (randomno == 6) {
			portalWordUrl = "intranet-portal-sun.jpg";
		}
	}
*/
}

String useragent = request.getHeader( "User-Agent" );
boolean isMSIE = ( useragent != null && useragent.indexOf( "MSIE" ) != -1 );
boolean isMSIE9 = ( useragent != null && useragent.indexOf( "MSIE 9" ) != -1 );

boolean isBoardMember = false;
if (userBean.isLogin() && userBean.isGroupID("boardMember") && !userBean.isAdmin()){
	isBoardMember = true;
}

boolean isFinanceMember = false;
if (userBean.isLogin() && userBean.isGroupID("financeMember") && !userBean.isAdmin()){
	isFinanceMember = true;
}

boolean isBoaOrFinMember = false;
if(isBoardMember || isFinanceMember){
	isBoaOrFinMember = true;
}

boolean isBDO = false;
if (userBean.isLogin() && userBean.isGroupID("bdo") && !userBean.isAdmin()){
	isBDO = true;
}

boolean isDisablePortalFunctions = AccessControlDB.isDisablePortalFunctions();
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
<!--  performance: load essential js and css ONLY -->
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/style.css" />" />
<script type="text/javascript" src="<html:rewrite page="/js/jquery-1.5.1.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/hkah.js" />" /></script>
<body style="overflow: hidden">
<DIV id=titleHeader>
<table width="100%" height="20" border="0">
	<tr>
		<td nowrap><bean:message key="message.welcome" arg0="<%=userInfo %>" /></td>
		<td align="right" nowrap>
<!--
	<html:link page="#">Help<html:img page="/images/Help.gif" width="15" height="15" border="0" /></html:link>
-->
	[
	<%if (Locale.US.equals(locale)) { %><html:img page="/images/lang_en.gif" align="top" /><%} else {%><html:link page="/common/language.jsp?language=en" target="_top"><html:img page="/images/lang_en.gif" align="top" /></html:link><%} %> |
	<%if (Locale.TRADITIONAL_CHINESE.equals(locale)) { %><html:img page="/images/lang_zh_TW.gif" align="top" /><%} else {%><html:link page="/common/language.jsp?language=zh_TW" target="_top"><html:img page="/images/lang_zh_TW.gif" align="top" /></html:link><%} %> |
	<%if (Locale.SIMPLIFIED_CHINESE.equals(locale)) { %><html:img page="/images/lang_zh_CN.gif" align="top" /><%} else {%><html:link page="/common/language.jsp?language=zh_CN" target="_top"><html:img page="/images/lang_zh_CN.gif" align="top" /></html:link><%} %> |
	<%if (Locale.JAPAN.equals(locale)) { %><html:img page="/images/lang_jp.gif" align="top" /><%} else {%><html:link page="/common/language.jsp?language=ja_JP" target="_top"><html:img page="/images/lang_jp.gif" align="top" /></html:link><%} %> |
	<a href="<%=anotherUrl %>" target="_top"><BLINK>Go To <%=anotherLabel %> Portal</BLINK></a>
	<%if (ConstantsServerSide.isHKAH() || ConstantsServerSide.isTWAH()) { %> | <a href="http://205.0.1.41/intranet/" target="_top"><span class="amc2-text">AMC-TKP Portal</span></a><%}%>
<%if (userBean.isLogin()) { %>
<%	if (!isDisablePortalFunctions && ConstantsServerSide.SITE_CODE.equals(userBean.getSiteCode())) { %>
<%		if (!userBean.isAdmin()) { %>
<%			if (ConstantsServerSide.isTWAH()) { %>
	| <html:link page="/admin/change_password.jsp" target="bigcontent"><html:img page="/images/forget.gif" align="top" width="15" height="15" alt="Change Password" /><bean:message key="prompt.change.password" /></html:link>
<% 			} else { %>
	| <html:link page="/admin/staff.jsp?command=SelfView&enabled=1" target="content"><html:img page="/images/forget.gif" align="top" width="15" height="15" alt="Account Profile" /><bean:message key="prompt.accountProfile" /></html:link>
<%			} %>
<%		} %>
<%	} %>
	| <html:link page="/Logoff.do" target="_top"><html:img page="/images/Lock.gif" width="17" height="17" align="top" alt="Logout" /><bean:message key="prompt.logout" /></html:link>
<%} else { %>
<!--
	| <html:link page="/admin/reset_password.jsp" target="bigcontent"><html:img page="/images/forget.gif" align="top" width="15" height="15" alt="Forgot Password" /><bean:message key="prompt.reset.password" /></html:link>
-->
<%} %>
	]
	<%-- <html:img page="/images/running_task.gif" styleId="status" /> --%>
		</td>
	</tr>
</table>
</DIV>

<DIV id=titleHeader2>
<table width="100%" height="93" border="0" style="position: absolute; top: 24px;">
	<tr>
		<td <% if (ConstantsServerSide.isTWAH()) { %>style="min-width: 430px;"<% } %>>
			<html:link page="/common/leftright_portal.jsp?category=home" target="bigcontent">
				<html:img page="<%=logoUrl %>" width="300" height="80" alt="<%=logoAlt %>" />
			</html:link>
		</td>
		<td>
			<a href="/intranet/common/leftright_portal.jsp?category=home" target="bigcontent">
<%	if (ConstantsServerSide.isTWAH()) { %>
				<img src="/intranet/images/twahBanner.gif" width="400" height="100"alt="<%=logoAlt %>" />
<%	} else { %>
				<img src="/intranet/images/<%=portalWordUrl %>" width="302" height="75" alt="<%=logoAlt %>" />
<%	} %>
			</a>
		</td>
<% if (ConstantsServerSide.SECURE_SERVER) { %>
		<td>
			<div>
				<svg width="90" height="50">
				  <rect x="0" y="0" rx="10" ry="10" width="90" height="50"
					style="fill:rgb(55,200,55);opacity:0.5" />
				  <text x="35" y="20" fill="white" style="font-size:16px;">Off-</text>
				  <text x="15" y="38" fill="white" style="font-size:16px;">Campus</text>
				</svg>
			</div>
		</td>
<% } %>
		<td align="right">
<%if (userBean.isLogin()) { %>
<%	if(!userBean.isStudentUser()){ %>
	<form name="ChangeUrLForm" target="bigcontent">
	<span class=container id=header>
		<ul class="topnav">
			<li id="home" class="home"><a href="javascript:void(0);" onclick="changeUrl('home');return false;"></a></li>
<% if (!isDisablePortalFunctions) { %>
<%		if (userBean.isAccessible("function.educationRecord.list") && !isBoaOrFinMember && !isBDO) { %>
			<li id="education" class="education"><a href="javascript:void(0);" onclick="changeUrl('education');return false;"></a></li>
<%		} %>
<% } %>
<%		if (!ConstantsServerSide.SECURE_SERVER || isDisablePortalFunctions) { %>
<%			if (isAllowHKPRODHATSFlag) { %>
			<li id="hkprodhats" class="hats"><a href="javascript:void(0);" onclick="changeUrl('hkprodhats');return false;"></a></li>
<%			} %>
<%			if (isAllowHKUATHATSFlag) { %>
			<li id="hkuathats" class="uathats"><a href="javascript:void(0);" onclick="changeUrl('hkuathats');return false;"></a></li>
<%			} %>
<%			if (isAllowTWPRODHATSFlag) { %>
			<li id="twprodhats" class="hats"><a href="javascript:void(0);" onclick="changeUrl('twprodhats');return false;"></a></li>
<%			} %>
<%			if (isAllowTWUATHATSFlag) { %>
			<li id="twuathats" class="uathats"><a href="javascript:void(0);" onclick="changeUrl('twuathats');return false;"></a></li>
<%			} %>
<%			if (isAllowTWUATHATS2Flag) { %>
			<li id="twuathats2" class="uathats"><a href="javascript:void(0);" onclick="changeUrl('twuathats2');return false;">TW 2.88</a></li>
<%			} %>
<%			if (isAllowAMCPRODHATSFlag) { %>
			<li id="amcprodhats" class="hats"><a href="javascript:void(0);" onclick="changeUrl('amcprodhats');return false;"></a></li>
<%			} %>
<%			if (isAllowAMCUATHATSFlag) { %>
			<li id="amcuathats" class="amcuathats"><a href="javascript:void(0);" onclick="changeUrl('amcuathats');return false;"></a></li>
<%			} %>
<%			if (isAllowAMC2UATHATSFlag) { %>
			<li id="amc2uathats" class="amc2uathats"><a href="javascript:void(0);" onclick="changeUrl('amc2uathats');return false;"></a></li>
<%			} %>
<%			if (isAllowAMC1UATHATSFlag) { %>
			<li id="amc1uathats" class="amc1uathats"><a href="javascript:void(0);" onclick="changeUrl('amc1uathats');return false;"></a></li>
<%			} %>
<%			if (isAllowCMS3Flag) { %>
			<li id="cms3" class="cms3"><a href="javascript:void(0);" onclick="changeUrl('cms3');return false;"></a></li>
<%			} %>
<%		} %>
		</ul>
	</span>
	<input type="hidden" name="category"/>
	</form>
<%	} %>
<%} else {%>
<%
	if (ConstantsServerSide.CAS_SINGLESIGNON) {
%>
<div style="margin: 10px;"><a id="login_button" href="javascript:void();" onclick="goToCasAuth();"></a></div>
<%
	} else {
		//Application specific login module
%>
<html:form action="/Logon.do" focus="loginID" onsubmit="return submitAction();">
<table>
	<tr align="left">
		<td><bean:message key="prompt.loginID" />:<br><html:text property="loginID" size="20"/></td>
		<td><bean:message key="prompt.password" />:<br><html:password property="loginPwd" value="" size="20"/></td>
		<td><button type="submit"><bean:message key="button.login" /></button></td>
	</tr>
	<tr align="left">
		<td><html:checkbox property="savePwd" value="Y"/><span style="CURSOR: pointer" class="visible" onclick="checkSavePwd();return false;"><bean:message key="prompt.save.password" /></span></td>
		<td><font color="red"><html:errors/></font>
			<font color="blue"><html:messages id="messages" message="true"><bean:write name="messages"/></html:messages></font>
		</td>
	</tr>
</table>
</html:form>
<%
	}
%>
<%} %>
		</td>
	</tr>
</table>
</DIV>
<script language="javascript">
<!--
	function closeWarning() {
		$('#warning-box').hide('slow');
	}

	function checkSavePwd() {
		document.forms["LogonForm"].elements["savePwd"].checked = !document.forms["LogonForm"].elements["savePwd"].checked;
	}

	function submitAction() {
<%
	if (!ConstantsServerSide.CAS_SINGLESIGNON) {
%>
		//Application specific login module
		if (document.forms["LogonForm"].elements["loginID"].value == "") {
			document.forms["LogonForm"].elements["loginID"].focus();
			return false;
		}
		if (document.forms["LogonForm"].elements["loginPwd"].value == "") {
			document.forms["LogonForm"].elements["loginPwd"].focus();
			return false;
		}
<%
	}
%>
		return true;
	}

	function changeUrl(action) {
		// ie problem inside frameset, lead to form post data encoding wrong
		if (action == 'hkuathats' || action == 'twuathats' || action == 'twuathats2' || action == 'amcuathats' || action == 'amc1uathats' || action == 'amc2uathats'
				|| action == 'hkprodhats' || action == 'twprodhats' || action == 'amcprodhats') {
			if (isChrome()) {
				window.open('/intranet/common/gwt2hats2.jsp?hatSite=' + action, '_top', '');
			} else {
				callPopUpWindow('../common/gwt2hats2.jsp?hatSite=' + action, screen.width*0.985, screen.height*0.92);
				window.opener = null;
//				window.open('/intranet/Logoff.do','_parent','');
				window.open('/intranet/common/close.jsp', '_parent', '');
			}
			return;
		} else if (action == 'cms3') {
			callPopUpWindow('http://160.100.2.73:9080/HKAHCMS/HKAHCMS.html?userID=<%=userBean.getLoginID() %>&userName=<%=StringEscapeUtils.escapeJavaScript(userBean.getUserName()) %>');
			window.opener = null;
			window.open('/intranet/Logoff.do','_parent','');
			window.open('/intranet/common/close.jsp', '_parent', '');
			return;
		}

		document.getElementById('home').className = 'home';
<%	if (userBean.isAccessible("function.educationRecord.list")) { %>
		document.getElementById('education').className = 'education';
<%	} %>
<%	if (isAllowHKPRODHATSFlag) { %>
		document.getElementById('hkprodhats').className = 'hats';
<%	} %>
<%	if (isAllowHKUATHATSFlag) { %>
		document.getElementById('hkuathats').className = 'uathats';
<%	} %>
<%	if (isAllowTWPRODHATSFlag) { %>
		document.getElementById('twprodhats').className = 'hats';
<%	} %>
<%	if (isAllowTWUATHATSFlag) { %>
		document.getElementById('twuathats').className = 'uathats';
<%	} %>
<%	if (isAllowTWUATHATS2Flag) { %>
		document.getElementById('twuathats2').className = 'uathats';
<%	} %>
<%	if (isAllowAMCPRODHATSFlag) { %>
	document.getElementById('amcprodhats').className = 'hats';
<%	} %>
<%	if (isAllowAMC2PRODHATSFlag) { %>
	document.getElementById('amc2prodhats').className = 'hats';
<%	} %>
<%	if (isAllowAMCUATHATSFlag) { %>
	document.getElementById('amcuathats').className = 'amcuathats';
<%	} %>
<%	if (isAllowAMC1UATHATSFlag) { %>
	document.getElementById('amc1uathats').className = 'amc1uathats';
<%	} %>
<%	if (isAllowAMC2UATHATSFlag) { %>
	document.getElementById('amc2uathats').className = 'amc2uathats';
<%	} %>
<%	if (isAllowCMS3Flag) { %>
		document.getElementById('cms3').className = 'cms3';
<%	} %>

		if (action == 'education') {
			document.getElementById('education').className = 'educationselected';
			document.forms["ChangeUrLForm"].elements["category"].value = 'title.education';
		} else {
			document.getElementById(action).className = action + 'selected';
			document.forms["ChangeUrLForm"].elements["category"].value = action;
		}
		document.forms["ChangeUrLForm"].action = "../common/leftright_portal.jsp";
		document.forms["ChangeUrLForm"].submit();
	}

	function isIE() {
		  var myNav = navigator.userAgent.toLowerCase();
		  var ret = (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
		  return ret;
	}

	function isChrome() {
		var isChromium = window.chrome,
			winNav = window.navigator,
			vendorName = winNav.vendor,
			isOpera = winNav.userAgent.indexOf("OPR") > -1,
			isIEedge = winNav.userAgent.indexOf("Edge") > -1,
			isIOSChrome = winNav.userAgent.match("CriOS");

		if (isIOSChrome) {
			return true;
		} else if (isChromium !== null && isChromium !== undefined && vendorName === "Google Inc." && isOpera == false && isIEedge == false) {
			return true;
		} else {
			return false;
		}
	}

<%if (userBean.isLogin()) { %>
	// default news
	document.getElementById('home').className = 'homeselected';
<%} %>
-->
</script>
<style type="text/css">
#header UL.topnav {
	FLOAT: right; WIDTH: 479px
}
#header UL.topnav LI {
	FLOAT: left; WIDTH: auto; TEXT-INDENT: -9999px; LIST-STYLE-TYPE: none
}
#header UL.topnav LI A {
	DISPLAY: block; HEIGHT: 80px
}
BODY #header UL.topnav LI A:hover {
	BACKGROUND-POSITION: 0px -80px
}
#header UL.topnav LI.home A {
	BACKGROUND: url(../images/title_button_home.png) no-repeat; WIDTH: 56px
}
#header UL.topnav LI.education A {
	BACKGROUND: url(../images/title_button_eduction.png) no-repeat; WIDTH: 93px
}
#header UL.topnav LI.uathats A {
	BACKGROUND: url(../images/title_button_hats_uat.png) no-repeat; WIDTH: 56px
}
#header UL.topnav LI.amcuathats A {
	BACKGROUND: url(../images/title_button_amc2hats_uat.png) no-repeat; WIDTH: 56px
}
#header UL.topnav LI.amc1uathats A {
	BACKGROUND: url(../images/title_button_amc1hats_uat.png) no-repeat; WIDTH: 56px
}
#header UL.topnav LI.hats A {
	BACKGROUND: url(../images/title_button_hats.png) no-repeat; WIDTH: 56px
}
#header UL.topnav LI.cms3 A {
	BACKGROUND: url(../images/title_button_cms3.png) no-repeat; WIDTH: 56px
}
#header UL.topnav LI.homeselected A {
	BACKGROUND: url(../images/title_button_home.png) no-repeat; WIDTH: 56px; BACKGROUND-POSITION: 0px bottom
}
#header UL.topnav LI.educationselected A {
	BACKGROUND: url(../images/title_button_eduction.png) no-repeat; WIDTH: 93px; BACKGROUND-POSITION: 0px bottom
}
#header UL.topnav LI.uathatsselected A {
	BACKGROUND: url(../images/title_button_hats_uat.png) no-repeat; WIDTH: 56px; BACKGROUND-POSITION: 0px bottom
}
#header UL.topnav LI.amcuathatsselected A {
	BACKGROUND: url(../images/title_button_amc2hats_uat.png) no-repeat; WIDTH: 56px; BACKGROUND-POSITION: 0px bottom
}
#header UL.topnav LI.amc1uathatsselected A {
	BACKGROUND: url(../images/title_button_amc1hats_uat.png) no-repeat; WIDTH: 56px; BACKGROUND-POSITION: 0px bottom
}
#header UL.topnav LI.hatsselected A {
	BACKGROUND: url(../images/title_button_hats.png) no-repeat; WIDTH: 56px; BACKGROUND-POSITION: 0px bottom
}
#header UL.topnav LI.cms3selected A {
	BACKGROUND: url(../images/title_button_cms3.png) no-repeat; WIDTH: 56px; BACKGROUND-POSITION: 0px bottom
}
BODY#home UL.topnav LI.home A {
	BACKGROUND-POSITION: 0px bottom
}
BODY#education UL.topnav LI.education A {
	BACKGROUND-POSITION: 0px bottom
}
BODY#home UL.topnav LI.uathats A {
	BACKGROUND-POSITION: 0px bottom
}
BODY#home UL.topnav LI.hats A {
	BACKGROUND-POSITION: 0px bottom
}
BODY#education UL.topnav LI.cms3 A {
	BACKGROUND-POSITION: 0px bottom
}
</style>

</body>
</html:html>