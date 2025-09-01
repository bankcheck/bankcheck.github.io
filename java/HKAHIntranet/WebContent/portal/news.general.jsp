<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.Calendar" %>
<%
UserBean userBean = new UserBean(request);
String infoCategory = ParserUtil.getParameter(request, "infoCategory");

boolean isACHSI = false;
if(userBean.isLogin() && "achsi".equals(userBean.getStaffID())){
	isACHSI = true;
}

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

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements. See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License. You may obtain a copy of the License at

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
<body style="overflow:visible;">
<script type="text/javascript" src="../js/jquery.cookie.js"></script>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/thickbox.css" />" media="screen" />
<form name="form1" method="post">
<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0" align="left" valign="top">
	<tr>
		<td colspan="2">
<jsp:include page="../portal/slideshow.jsp" flush="false" />
		</td>
		<td></td>

	</tr>
<tr><td><%if ((userBean.isLogin() && !userBean.isGuest() && !isBoaOrFinMember && !isBDO) || userBean.isAccessible("function.news.popular")) { %>
	<a href="../documentManage/download2.jsp?embedVideoYN=Y&rootFolder=\\WWW-SERVER\Swf\&locationPath=\ic\"><img src="../images/ic/covidVideo.jpg" alt="COVID-19 Video" /></a>
<% } %></td></tr>
	<tr>
		<td valign="top">

<% 
	Calendar curCal = Calendar.getInstance();
	Calendar cal = Calendar.getInstance();
	cal.set(2017, 9 - 1, 20, 0, 0, 0);
	
	Calendar calChaplMorningDevZoomStart = Calendar.getInstance();
	calChaplMorningDevZoomStart.set(Calendar.HOUR_OF_DAY, 8);
	calChaplMorningDevZoomStart.set(Calendar.MINUTE, 15);
	calChaplMorningDevZoomStart.set(Calendar.SECOND, 00);
	
	Calendar calChaplMorningDevZoomEnd = Calendar.getInstance();
	calChaplMorningDevZoomEnd.set(Calendar.HOUR_OF_DAY, 9);
	calChaplMorningDevZoomEnd.set(Calendar.MINUTE, 30);
	calChaplMorningDevZoomEnd.set(Calendar.SECOND, 00);
	
	if (ConstantsServerSide.isHKAH() && curCal.compareTo(cal) < 0) { %>
	<img src="../images/nursing/SHARE_w631.jpg" alt="SHARE Carnival 2017" style="padding:0 25px"/>
<% } %>

<% if (ConstantsServerSide.isHKAH() && 
		(!ConstantsServerSide.SECURE_SERVER || (ConstantsServerSide.SECURE_SERVER && userBean.isLogin())) &&
		//userBean.isAccessible("function.chap.onlineMD.view") &&	// UAT
		curCal.get(Calendar.DAY_OF_WEEK) != Calendar.SATURDAY &&
		curCal.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY &&
		curCal.after(calChaplMorningDevZoomStart) && 
		curCal.before(calChaplMorningDevZoomEnd)) { %>
<%  // 30 Apr-31 May 2021 Zoom link: https://us02web.zoom.us/j/84015323176?pwd=RzgvbnE1RHl2d1lDL2JIWEIvWUN1dz09 %>		
	<a href="https://us02web.zoom.us/j/84015323176?pwd=RzgvbnE1RHl2d1lDL2JIWEIvWUN1dz09" target=_blank"><img src="../images/Morning_Devotion_sr2021.png" alt="Morning Devotion on Zoom Mon-Fri 08:15-09:30" style="padding:0 25px"/></a>     
<% } %>	

<%if ((!userBean.isGuest() && !isBoaOrFinMember && !isBDO) || userBean.isAccessible("function.news.popular")) { %>
	<a href="../documentManage/download2.jsp?embedVideoYN=Y&rootFolder=\\WWW-SERVER\Swf\&locationPath=CookingVideo\Current"><img src="../images/food/Poster1.png" alt="Cook Better Eat Better" style="padding:0 25px"/></a>
<% } %>

<%if ((!userBean.isGuest() && !isBoaOrFinMember && !isBDO) || userBean.isAccessible("function.news.popular")) { %>
<jsp:include page="../portal/news.popular.jsp" flush="false">
	<jsp:param name="skipColumnTitle" value="N" />
	<jsp:param name="skipBrief" value="N" />
	<jsp:param name="infoCategory" value="<%=infoCategory %>" />
</jsp:include>
<br/><br/>
<% } %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
<% if ((!userBean.isGuest() && !isBoaOrFinMember && !isBDO) || userBean.isAccessible("function.news.popular")) { %>
		<td valign="bottom">
<%	if (userBean.isLogin()) { %>
			<a href="../portal/general.jsp?category=achs">
<%	} else { %>
			<a href="javascript:void();" onclick="alert('Please Login!');">
<%	} %>
<%if(!"PEM".equals(infoCategory)){ %>
<!--
			<img src="../images/ACHSI.jpg" />
			<br />Australian Council on Healthcare Standards (ACHS)</a>
		</td>
-->
<%} %>
<% } %>
	</tr>
</table>
		</td>
		<td>&nbsp;</td>
		<td valign="top" style="width: 30%;">
	<%if(!"PEM".equals(infoCategory) || infoCategory == null){ %>
		<%	/*
				Replaced by portal/slideshow.jsp %>
					<jsp:include page="../portal/photo.gallery.jsp" flush="false"/>
					<br />
		<%	*/ %>
					<table style="overflow-x: hidden;"width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr><td class="title"><span>ADVENTIST CORNER <img src="../images/title_arrow.gif"></span>
						<% if (userBean.isLogin() && userBean.isAdmin()) { %>
						[ <a href="javascript:void()" onclick="callPopUpWindow('../admin/information_page_list.jsp?infoCategory=adventist.corner');">Edit</a> ]
						<%} %>
						</td>
						</tr>
						<tr><td height="2" bgcolor="#840010"></td></tr>
						<tr><td height="10"></td></tr>
						<tr><td>
						<%
							String category = "adventist.corner";
							if(isACHSI){
								category = "adventist.corner.achsi";
							}
						%>
						<% if (userBean.isGuest() || isBoaOrFinMember) { %>
							<%
								category += ".guest";
								if (userBean.isAccessible("function.guest.special_co_information_category")) {
									category += "." + userBean.getLoginID();
								}
							%>
							<jsp:include page="../common/information_helper.jsp" flush="false">
								<jsp:param name="category" value="<%=category %>" />
								<jsp:param name="skipColumnTitle" value="Y" />
								<jsp:param name="mustLogin" value="N" />
							</jsp:include>
						<% } else if ((!ConstantsServerSide.SECURE_SERVER || userBean.isStaff()) && !isBDO) { %>
							<jsp:include page="../common/information_helper.jsp" flush="false">
								<jsp:param name="category" value="<%=category %>" />
								<jsp:param name="skipColumnTitle" value="Y" />
								<jsp:param name="mustLogin" value="N" />
								<jsp:param name="oldTreeStyle" value="Y" />
							</jsp:include>
						<% } %>
						</td></tr>
					</table>
 <%} %>
		</td>
	</tr>
</table>
<input type="hidden" name="newsCategory"/>
<input type="hidden" name="newsID"/>
<input type="hidden" name="category"/>
</form>
<script language="javascript">
<!--
	$(document).ready(function(){
		$("#tab").tabs();
		
		var video = document.getElementById("video1");
		video.muted= true;
	});

	function readNews(cid, nid) {
		document.form1.action = "../portal/news_view.jsp";
		document.form1.newsCategory.value = cid;
		document.form1.newsID.value = nid;
		document.form1.submit();
		return true;
	}

	function changeUrl(aid, cid) {
		if (aid != '') {
			document.form1.action = aid;
			document.form1.category.value = cid;
			document.form1.submit();
		} else {
			alert("Under Construction");
		}
	}

	function likeMe(category, id, act) {
		$.ajax({
			type: "POST",
			url: "../portal/news_like_helper.jsp",
			data: "action=" + act + "&newsCategory=" + category + "&newsID=" + id,
			success: function(values) {
				if (values != '') {
					$("#" + category.replace(".", "_") + "_" + id).html(values);
				}//if
			}//success
		});//$.ajax
		return false;
	};
-->
</script>
<script type="text/javascript" src="http://www.google.com/jsapi">
		google.load("jquery", "1.3.2");
</script>
<style type="text/css">
ul { list-style: none; margin: 0; padding: 0; }
</style>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>