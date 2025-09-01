<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@page import="org.apache.commons.lang.StringUtils"%>

<%
// set default locale
MessageResources.getMessage(session, "prompt.loginPage");

UserBean userBean = new UserBean(request);
String[] accessWard = request.getParameterValues("accessWard");
String accessWardList = null;
accessWardList = request.getParameter("accessWardList");

if (accessWard!= null && accessWard.length > 0 ){
	accessWardList = StringUtils.join(accessWard,",");
}

String userInfo = null;
if (userBean.isLogin()) {
	if (userBean.getDeptCode().equals("FOOD") ||
			userBean.getDeptCode().equals("HSKG") ||
			userBean.getDeptCode().equals("U100") ||
			userBean.getDeptCode().equals("U200") ||
			userBean.getDeptCode().equals("U300") ||
			userBean.getDeptCode().equals("SURG") ||
			userBean.getDeptCode().equals("U400") ||
			userBean.getDeptCode().equals("IT") ||
			userBean.getDeptCode().equals("720")) {
		if (userBean.getDeptCode().equals("IT") || userBean.getDeptCode().equals("720")) {
		}

		if (userBean.getDeptCode().equals("HSKG")) {
			if (userBean.getStaffID().equals("16119")) {

			}
			else if (!userBean.isAdmin()){
				%>
				<script>
					alert('You are not granted permission.');
					window.close();
				</script>
				<%
				return;
			}
		}
	}
	else if (!userBean.isAdmin()){
		%>
		<script>
			alert('You are not granted permission.');
			window.close();
		</script>
		<%
		return;
	}

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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%
	if (ConstantsServerSide.SECURE_SERVER) {
%>
<script type="text/javascript">
	var secureProtocol = "https:";
	if (!isSecure(window.location.protocol)) {
		var url = window.location.href;
		window.location.href = secureProtocol + url.substring(url.indexOf(":") + 1, url.length);
	}

	function isSecure(protocol)
	{
   		return protocol == secureProtocol;
	}
</script>
<%
	}
%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id="header">
	<div id="logo_<% if( ConstantsServerSide.isTWAH()) {%>twah<%} else {%>hkah<%} %>" style="cursor:pointer"></div>
	<div id="title"><bean:message key="message.welcome" arg0="<%=userInfo %>" /></div>
	<div id="header_tabs">
	<ul>
		<li id="t1">Home</li>
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
(C) Copyright 2016
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
<input type="hidden" name=accessWardList value="<%=(accessWardList==null)?"":accessWardList%>">
</form>

<script type="text/javascript">
$(document).ready(function() {
	$('div#logo').click(function(){
		window.open('../', '_self');
	});
});
<!--
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
	m101:{l:"../foodtw/login.jsp?accessWardList=<%=accessWardList==null?"":accessWardList%>",	t:"Login Screen", c:"yellow"}
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
<link href="<html:rewrite page="/css/main.css" />" rel="stylesheet" type="text/css"/>
<style type="text/css">
/* centerize login column (override float property in main.css) */
#c1.main_containers {margin: 0 auto; float: none;}
</style>
</body>
</html:html>