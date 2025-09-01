<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

// load userbean if load balance is on
if (ConstantsServerSide.CORE_SERVER && ConstantsServerSide.LOAD_BALANCE) {
	String loadBalance = request.getParameter("loadBalance");
	String sessionID = request.getParameter("sessionID");
	String staffID = request.getParameter("staffID");
	String referer = request.getParameter("referer");

	if ("N".equals(loadBalance) && sessionID != null && sessionID.length() > 0 && staffID != null && staffID.length() > 0 && referer != null && referer.length() > 0) {
		if ((userBean == null || !userBean.isLogin() || userBean.getStaffID() == null || !userBean.getStaffID().equals(staffID))) {
			ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList("SELECT u.CO_STAFF_ID FROM SSO_SESSION@SSO s, co_users u WHERE s.USER_ID = U.CO_USERNAME AND s.MODULE_CODE = 'hk.portal' AND s.SESSION_ID = ? AND u.CO_STAFF_ID = ? AND s.TIMESTAMP_UPDATE > SYSDATE - 1", new String[] { sessionID, staffID });
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				userBean = UserDB.getUserBean(request, row.getValue(0));
			}
		}
		%><script language="javascript">window.location.href = "../<%=referer%>";</script><%
		return;
	}
}

// set default locale
MessageResources.getMessage(session, "prompt.loginPage");

String userInfo = null;
if (userBean != null && userBean.isLogin()) {
	if (userBean.isAdmin()) {
		userInfo = userBean.getLoginID();
	} else {
		StringBuffer strbuff = new StringBuffer();
		strbuff.append(userBean.getUserName());
		strbuff.append(" (");
		if (ConstantsServerSide.DEBUG) {
			strbuff.append(userBean.getUserGroupDesc());
			strbuff.append("@");
		}
		strbuff.append((userBean.getDeptDesc() == null || "".equals(userBean.getDeptDesc())?"":userBean.getDeptDesc()));
		strbuff.append(")");
		userInfo = strbuff.toString();
	}
} else {
	userInfo = "";
}

boolean isLogin = userBean != null && userBean.isLogin();
String sLoginID = request.getParameter("sLoginID");
String sSource = request.getParameter("sSource");
String sLoginMessage = null;
if (sSource != null) {
	if ("lab".equals(sSource)) {
		sLoginMessage = "Lab/Pathology";
	} else if ("di".equals(sSource)) {
		sLoginMessage = "DI";
	}
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<script type="text/javascript">
<%
	// redirect to landing page if already login
	if (isLogin) {
%>
		var url = window.location.href;
		var index1 = url.indexOf('//');
		var index2 = url.indexOf('/', index1 + 2);
		var index3 = url.indexOf('/', index2 + 1);
		var protocol;
		var landingUrl;
<%
		if (ConstantsServerSide.SECURE_SERVER) {
%>
			protocol = 'https://';
<%
		} else {
%>
			protocol = 'http://';
<%
		}
%>
		landingUrl = protocol + url.substring(index1 + 2, index3) + '/';
		//window.location.href = landingUrl;

<%
	} else if (ConstantsServerSide.SECURE_SERVER) {
%>
	var secureProtocol = "https:";
	if (!isSecure(window.location.protocol)) {
		var url = window.location.href;
		window.location.href = secureProtocol + url.substring(url.indexOf(":") + 1, url.length);
	}

	function isSecure(protocol)
	{
   		return protocol == secureProtocol;
	}

<%
	}
%>
</script>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id="header">
	<div id="logo_<% if( ConstantsServerSide.isTWAH()) {%>twah<%} else if( ConstantsServerSide.isHKAH()) {%>hkah<%} else {%>amc<%} %>" style="cursor:pointer"></div>
	<div id="title"><bean:message key="message.welcome" arg0="<%=userInfo %>" /></div>
	<div id="header_tabs">
	<ul>
		<li id="t1">If you forget your password, please contact <%if (ConstantsServerSide.isHKAH()) {%>7316-5729<%} else if (ConstantsServerSide.isTWAH()) {%>2275-6133<%}%> during the office hours <%if (ConstantsServerSide.isHKAH()) {%>8:30 a.m. to 5:30 p.m.<%} else if (ConstantsServerSide.isTWAH()) {%>8:00 a.m. to 5:00 p.m.<%}%></li>
	</ul>
	</div>
	<div id="header_bar">
		<span class="right">
			<img id="expd" src="../images/module-expand.png" alt="Expand All Modules"/>
			<img id="clps" src="../images/module-collapse.png" alt="Collapse All"/>
		</span>
		<span class="hint right">Adjust module layout</span>
	</div>
</div>

<div id="helper"></div>

<table id="main_table">
<tr><td style="position:relative">
<div id="main">
	<div id="c1" class="main_containers"></div>
	<div id="c2" class="main_containers"></div>
	<div id="c3" class="main_containers"></div>
</div>
</td></tr></table>

<div id="footer">
<div id="footer_bar">[ <a href="https://www.hkah.org.hk/en/main">Hong Kong Adventist Hospital - Stubbs Road</a> | <a href="https://www.twah.org.hk/en/main">Hong Kong Adventist Hospital - Tsuwn Wan</a> ]</div>
(C) Copyright 2015
</div>

<!-- A hidden module template is carried within the page, which can be modified easily -->
<div id="module_template" class="module" style="display:none">
	<div class="moduleFrame">
		<div class='moduleHeader'>
			<span class="moduleIcon"><img alt="icon" src="../images/icon.gif"/></span>
			<div class='moduleTitle'></div>
			<div class='moduleActions'>
				<img src='../images/s.gif' alt="Refresh" class="action_refresh"/>
				<img src='../images/s.gif' alt="Collapse" class="action_min"/>
				<img src='../images/s.gif' alt="Expand" class="action_max"/>
				<img src='../images/s.gif' alt="Close" class="action_close"/>
			</div>
		</div>
		<div class='moduleContent'>
			<img src="../images/loading.gif" alt="Loading..."/> Loading...
		</div>
	</div>
</div>

<form name="IndexForm" method="post">
<input type="hidden" name="newsCategory" />
<input type="hidden" name="newsID" />
<input type="hidden" name="category" />
</form>

<script type="text/javascript">
$(document).ready(function() {
	$('div#logo').click(function(){
		window.open('../', '_self');
	});
});
<!--
if (this.window.name == 'content' || this.window.name == 'bigcontent') {
	parent.location.href = "../portal/index.jsp";
}

function changeUrl(aid, cid) {
	document.IndexForm.action = aid;
	document.IndexForm.category.value = cid;
	document.IndexForm.submit();
}

function readNews(cid, nid) {
	document.IndexForm.action = "../portal/news_view.jsp";
	document.IndexForm.newsCategory.value = cid;
	document.IndexForm.newsID.value = nid;
	document.IndexForm.submit();
	return true;
}

// Module ID & link definitions
// Format:
// moduleId:{l:"url_of_this_module",
// 			 t:"title_for_this_module",
// 			 c:"optional color definition for title bar"}
var _modules={
	m101:{l:"../portal/login.jsp?redirect=Y<%=sLoginID==null?"":"&sLoginID="+sLoginID %><%=sLoginMessage==null?"":"&sLoginMessage="+sLoginMessage %>", t:"Login Screen", c:"yellow"}
};

// Layout definitions for each tab, aka, which modules go to which columns under which tab
// Format:
//	{i:"id_of_the_module	(refer to _modules)",
//	c:"column_it_belongs_to	(c1, c2, c3)"
//	t:"tab_it_belongs_to	(t1, t2, ...)"}
var _layout=[
	{i:'m101',c:'c1',t:'t1'}
];

// Column width definitions for each tab
// Valid values are pixel, % or auto
// Currently, "auto" is only valid on column2
// You can support more features by refining function HeaderTabClick()
var _tabs={
	t1:{c1:"356px",c2:0,c3:0,helper:true}
};
-->
</script>
<script type="text/javascript" src="<html:rewrite page="/js/thickbox.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.myext.js" />"></script>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/main.css" />"/>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/portal.login.css" />"/>
<style type="text/css">
/* centerize login column (override float property in main.css) */
#c1.main_containers {margin: 0 auto; float: none;}
</style>
</body>
</html:html>