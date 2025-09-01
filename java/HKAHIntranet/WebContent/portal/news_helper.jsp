<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.DateTimeUtil"%>
<%@ page import="org.apache.struts.Globals" %>
<%@ page import="java.text.SimpleDateFormat" %>
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

<%!
public static boolean isAllowSpecial(String staffID) {

	return false;
}

public static boolean isNotAllowSpecial(String staffID) {


	return false;
}
%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
	UserBean userBean = new UserBean(request);
	Locale locale = (Locale) session.getAttribute(Globals.LOCALE_KEY);

	boolean isTopNews = false;
	boolean isPopularNews = false;
	boolean isHospital = false;
	boolean isEducation = false;
	boolean isMarketing = false;
	boolean isPEM = false;
	String newsurl = null;
	String columnTitle = request.getParameter("columnTitle");
	String category = request.getParameter("category");
	String type = request.getParameter("type");
	String source = request.getParameter("source");
	boolean skipColumnTitle = "Y".equals(request.getParameter("skipColumnTitle"));
	boolean skipBrief = "Y".equals(request.getParameter("skipBrief"));
	isPEM = "Y".equals(request.getParameter("isPEM"));
	String newsType_prev = null;
	ArrayList result = null;
	ArrayList result_renovation = null;
	ArrayList result_promotion = null;

	// set default title
	if (columnTitle == null && !skipColumnTitle) {
		if (category != null && category.length() > 0) {
			columnTitle = category.toUpperCase();
		} else if (type != null && type.length() > 0) {
			columnTitle = type.toUpperCase();
		}
	}

	if ("top".equals(category)) {
		isTopNews = true;
		result = (ArrayList) request.getAttribute("top_news_list");
		if (result == null) {
			if ("information".equals(source)) {
				result = NewsDB.getList(userBean, "information", null, null, 1, 10, 1);
			} else {
				result = NewsDB.getTopNewsList(userBean, "generalnews");
				result_renovation = NewsDB.getTopNewsList(userBean, "renovationnews");
				result_promotion = NewsDB.getTopNewsList(userBean, "promotion");
			}
		}
	} else {
		result = NewsDB.getList(userBean, category, type, null, 1, -1, 1);
		result_renovation = NewsDB.getList(userBean, category, type, null, 1, -1, 1);
	}

	String langStr = "en";
	if (Locale.TRADITIONAL_CHINESE.equals(locale)) {
		langStr = "tc";
	} else if (Locale.SIMPLIFIED_CHINESE.equals(locale)) {
		langStr = "sc";
	} else if (Locale.JAPAN.equals(locale)) {
		langStr = "jp";
	}

	ReportableListObject row = null;
	String newsCategory = null;
	String newsType = null;
	String newsID = null;
	String title = null;
	String titleUrl = null;
	String titleImage = null;
	String content1 = null;
	String likeCount = null;
	String likeSelf = null;
	String modifiedDate = null;

	int count = 0;
	String path = request.getContextPath();

	//for xmas
	Calendar curCal = Calendar.getInstance();
	Calendar startCal = Calendar.getInstance();
	Calendar endCal = Calendar.getInstance();
	Calendar regDeadlineCal = Calendar.getInstance();
	boolean hideXmasLink = false;

	if (ConstantsServerSide.isHKAH()) {
		startCal.set(Calendar.MONTH, 10);	// keep 10 (Nov); 	start showing is controlled by (1==2) below, not by startCal.
		startCal.set(Calendar.DATE, 11);	// change day from 12 to 11
		startCal.set(Calendar.HOUR_OF_DAY, 12);	// keep 12:00
		endCal.set(Calendar.MONTH, 11);		// keep month 11
		endCal.set(Calendar.DATE, 26);		// change day from 21 to 26 to make jpg hidden
		endCal.set(Calendar.HOUR_OF_DAY, 22);	// not useful, final closing is controlled by regDeadlineCal;

		regDeadlineCal.set(Calendar.MONTH, 10);	// keep 10 (Nov)
		regDeadlineCal.set(Calendar.DATE, 26);	// change day from 28 to 26
		regDeadlineCal.set(Calendar.HOUR_OF_DAY, 17);	// keep 17:29:59
		regDeadlineCal.set(Calendar.MINUTE, 29);	// keep 29
		regDeadlineCal.set(Calendar.SECOND, 59);	// keep 59, regDeadlineCal control showing confirmation.jsp or registration.jsp; control hideXmasLink or not
	} else {
		//startCal.set(Calendar.MONTH, 10);
		//startCal.set(Calendar.DATE, 4);
		//endCal.set(Calendar.MONTH, 10);
		//endCal.set(Calendar.DATE, 21);
		startCal.set(Calendar.MONTH, 10);	// 10 (Nov)
		startCal.set(Calendar.DATE, 12);
		startCal.set(Calendar.HOUR_OF_DAY, 8);		// 12
		endCal.set(Calendar.MONTH, 10);  //endCal.set(Calendar.MONTH, 12);
		endCal.set(Calendar.DATE, 29);
		endCal.set(Calendar.HOUR_OF_DAY, 22);

		regDeadlineCal.set(Calendar.MONTH, 10);	// 10 (Nov)
		regDeadlineCal.set(Calendar.DATE, 29);
		regDeadlineCal.set(Calendar.HOUR_OF_DAY, 23);
		regDeadlineCal.set(Calendar.MINUTE, 59);
		regDeadlineCal.set(Calendar.SECOND, 59);

	}
	endCal.set(Calendar.YEAR, 2019);
	regDeadlineCal.set(Calendar.YEAR, 2019);

	String xmasLink = null;

	/*
	System.out.println("[news_helper.jsp] curCal.after(regDeadlineCal)="+
			curCal.after(regDeadlineCal)+", regDeadlineCal="+DateTimeUtil.formatDateTime(regDeadlineCal.getTime())+
			", curCal="+DateTimeUtil.formatDateTime(curCal.getTime()));
	*/

	if (curCal.before(startCal) || curCal.after(regDeadlineCal)) {
		xmasLink = "confirmation.jsp";
		hideXmasLink = false;	// original is true
	} else {
		xmasLink = "registration.jsp";
		hideXmasLink = false;
	}

	// System.out.println("[news_helper] hideXmasLink="+hideXmasLink);

	SimpleDateFormat smf = new SimpleDateFormat("ddMMyyyy");
	long endDiff = endCal.getTimeInMillis() - curCal.getTimeInMillis();
	long startDiff = startCal.getTimeInMillis() - curCal.getTimeInMillis();

	if (ConstantsServerSide.isHKAH() && columnTitle != null && columnTitle.indexOf("WHAT'S NEW") >= 0) {
		//if (XmasGatheringDB.isAllow(userBean.getStaffID()) && startDiff <= 0 && endDiff >= 0) {
		//if (!hideXmasLink && (XmasGatheringDB.isAllow(userBean.getStaffID()) || isAllowSpecial(userBean.getStaffID())) && (!isNotAllowSpecial(userBean.getStaffID()))) {		// when deploy
		//if (userBean.getStaffID() != null && userBean.isAccessible("function.xmas.enrollment.list.admin") || "3819".equals(userBean.getStaffID())) {		// when uat
		//if (!hideXmasLink) {
		if (1==2) {		// forbid using
%>
					<div style="float:left;width:100%;">
						<div id="xmas" style="cursor:pointer">
							<img width="70%" src="../images/xmas/registration_button.jpg" alt="" /><br/>
						</div>
					</div>
					<br/>
<%
		}
	}
	if (ConstantsServerSide.isTWAH() && columnTitle != null && columnTitle.indexOf("WHAT'S NEW") >= 0) {
		//if (XmasGatheringDB.isAllow(userBean.getStaffID()) && startDiff <= 0 && endDiff >= 0) {
		if (!hideXmasLink && XmasGatheringDB.isAllow(userBean.getStaffID())) {		// when deploy
		//if (userBean.getStaffID() != null && userBean.isAccessible("function.xmas.enrollment.list.admin") || "3819".equals(userBean.getStaffID())) {	// when uat
		//if (1==2) {
%>
			<div style="float:left">
				<div id="xmas" style="cursor:pointer"><img src="../images/xmas/dinner_party.png" alt="" /><br/><label style="font-size:18px; color:purple"></label></div>
			</div>
			<br/>
			<br/>
			<br/>
			<br/>
<%
		}
	}
	if (ConstantsServerSide.isHKAH() && columnTitle != null && columnTitle.indexOf("WHAT'S NEW") >= 0) {
		if (1!=1) {		// forbid using
%>
					<div style="float:left;width:100%; font-size:120%;">
							<a href="../education/elearning_test.jsp?from=edu&command=&elearningID=27" target="_blank">
							<img width="70%" src="../images/JCI.png" alt="" /><br/>
							<BLINK>JCI- Accreditation Book Presentation (English version)<br/>
							JCI-成功指南（中文版）</BLINK>
							</a><br/>
					</div>
					<br/>
<%
		}
	}

	if (ConstantsServerSide.isHKAH() && columnTitle != null && columnTitle.indexOf("WHAT'S NEW") >= 0) {
		// Ad hoc link to be placed at the beginning of WHAT'S NEW section
%>
		<%-- <a href="../hr/yearOfEmployee_vote.jsp"><img src="../images/yearOfEmployeeVote.jpg" width="351" height="138" alt="Employee of year" /></a>--%>

		<div style="float:left;">			
		
			<a href="http://www.hkah.org.hk/<%=langStr %>/career" target="_top"><img src="../images/logoJob.bmp" alt="HKAH Career" width="150" height="150"/></a>
			
		</div>
		<table  <%if (isPEM) { %>width="70%"<%} %>>
			<tr><td colspan="2" style="text-align:center;<%if (isPEM) { %>font-size:200%;<%}else{%>font-size:150%;<%} %>"><u>Patient Experience Model Sharing Corner</u></td></tr>
			<tr>
				<td><%if ("N".equals(DocumentDB.getURL("418"))) {%><%}else{%>Hit Rate:<%=DocumentDB.showHitRate("418")%><br><a href="<%=DocumentDB.getURL("418")%>"><%} %><img src=<%if (!DocumentDB.checkUpdateWithTwoMth("418")) {%>"../images/PEM_LDISComNotExist.gif"<%}else{%>"../images/PEM_LDISComExist.gif"<%} %> alt="" <%if (isPEM) { %>width="100%" height="100%"<%} %>/></a></td>
				<td><%if ("N".equals(DocumentDB.getURL("419"))) {%><%}else{%>Hit Rate:<%=DocumentDB.showHitRate("419")%><br><a href="<%=DocumentDB.getURL("419")%>"><%} %><img src=<%if (!DocumentDB.checkUpdateWithTwoMth("419")) {%>"../images/PEM_RewardNotExist.gif"<%}else{%>"../images/PEM_RewardExist.gif"<%} %> alt="" <%if (isPEM) { %>width="100%" height="100%"<%} %> class="addHitRate" docID="419"/></a></td>
			</tr>
			<tr>
				<td><%if ("N".equals(DocumentDB.getURL("420"))) {%><%}else{%>Hit Rate:<%=DocumentDB.showHitRate("420")%><br><a href="<%=DocumentDB.getURL("420")%>"><%} %><img src=<%if (!DocumentDB.checkUpdateWithTwoMth("420")) {%>"../images/PEM_ServiceNotExist.gif"<%}else{%>"../images/PEM_ServiceExist.gif"<%} %> alt="" <%if (isPEM) { %>width="100%" height="100%"<%} %>/></a></td>
				<td><%if ("N".equals(DocumentDB.getURL("454"))) {%><%}else{%>Hit Rate:<%=DocumentDB.showHitRate("454")%><br><a href="<%=DocumentDB.getURL("454")%>"><%} %><img src=<%if (!DocumentDB.checkUpdateWithTwoMth("454")) {%>"../images/PEM_CommNotExist.gif"<%}else{%>"../images/PEM_CommExist.gif"<%} %> alt="" <%if (isPEM) { %>width="100%" height="100%"<%} %> class="addHitRate" docID="454"/></a></td>
			</tr>
		</table>
		
<%
	} else if (ConstantsServerSide.isTWAH() && columnTitle != null && columnTitle.indexOf("WHAT'S NEW") >= 0) {

	}

	if ("top".equals(category) && !result_renovation.isEmpty()) {
		int displayRecordNo = 5;
%>
<table style="width:100%;">
<tr><td colspan="3">
	<div class="news-renoupdate-box">
<%
		if (result_renovation.size() > 0 ) {
%>
	<span class="subTitle">Renovation News</span>
<%
		}
%>
	<table>
		<tr>
			<td>
<%
		for (int i = 0; i < result_renovation.size() && (!isTopNews || i < displayRecordNo); i++) {
			row = (ReportableListObject) result_renovation.get(i);
			newsID = row.getValue(0);
			newsCategory = row.getValue(1);
			newsType = row.getValue(2);
			title = row.getValue(3);
			titleUrl = row.getValue(4);
			titleImage = row.getValue(5);
			modifiedDate = row.getValue(6);
			content1 = row.getValue(9);
			likeCount = row.getValue(19);
			likeSelf = row.getValue(20);

			if ("classRelatedNews".equals(newsType)) {
				displayRecordNo ++;
				continue;
			}

			if (content1 != null  && content1.length() > 0) {
				content1 += " ..";
				newsurl = "javascript:readNews('" + newsCategory + "', '" + newsID + "');";
			} else if (titleUrl != null && titleUrl.length() > 0) {
				newsurl = titleUrl;
			} else {
				newsurl = "#";
			}

			if (!isTopNews && (isMarketing || newsType.equals(newsType_prev))) {
%>
		<span class="reported_quote"><%=newsType==null?"":newsType.toUpperCase() %></span>
		<a class="topstoryblue" href="<%=newsurl %>"><%=title %></a><br/><p/>
<%			} else {
				if (!isTopNews && skipColumnTitle) { %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td class="title"><span><%=newsType==null?"":newsType.toUpperCase() %> <img src="<%=path %>/images/title_arrow.gif"></span></td></tr>
				<tr><td height="2" bgcolor="#840010"></td></tr>
				<tr><td height="10"></td></tr>
			</table>
<%				} %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td rowspan="4" width="10" valign="top">
						<img src="<%=path %>/images/A logo.jpg" width="16" height="16"/>
					</td>
					<td rowspan="4" width="10" valign="top">&nbsp;</td>
					<td class="h1_margin">
						<a class="topstoryblue" href="<%=newsurl %>"><H1 id="TS"><%=title %></H1></a>
						<span id="<%=newsCategory.replace(".", "_") %>_<%=newsID %>">
<jsp:include page="../portal/news_like_helper.jsp" flush="false">
	<jsp:param name="newsCategory" value="<%=newsCategory %>" />
	<jsp:param name="newsID" value="<%=newsID %>" />
	<jsp:param name="likeCount" value="<%=likeCount %>" />
	<jsp:param name="likeSelf" value="<%=likeSelf %>" />
</jsp:include>
						</span>
<%				if (userBean.isLogin() && userBean.isAccessible("function.news.type." + newsCategory)) { %>
						[ <a href="../admin/news.jsp?command=view&newsCategory=<%=newsCategory %>&newsID=<%=newsID %>">Edit</a> ]
<%				} %>
					</td>
				</tr>
<%				if (!skipBrief) { %>
				<tr><td height="2" bgcolor="#F2F2F2"></td></tr>
				<tr>
					<td class="h1_margin">
						<span class="reported_quote"><%=modifiedDate %> <%=newsType==null?"":newsType.toUpperCase() %></span>
<%					if (titleImage != null && titleImage.length() > 0) {
						if (titleImage.indexOf("http://") == 0) { %>
						<br/><img style='width:525px' src="<%=titleImage %>"><br/>
<%						} else { %>
							<br/><img style='width:525px' src="/upload/<%=newsCategory %>/<%=newsID %>/<%=titleImage %>"><br/>
<%						}
					}
					if (isTopNews && i == 0) { %>
						<span class="pupular_content" style="line-height: 13px">
<%						if ("LMC".equals(newsCategory) && "3".equals(newsID)) {
							%>...<%
						} else {
%>
							<%=content1 %>
<%
						}
%>
						</span>
<%					} %>
					</td>
				</tr>
<%				} %>
				<tr><td height="7">&nbsp;</td></tr>
			</table>
<%			}
			// keep previous news type
			newsType_prev = newsType;
		}
%>
		</td>
	</tr>
</table>
</div>
</td>
</tr>
</table>

<%
	}

	if (!skipColumnTitle) {
%>
<div>
<%if (ConstantsServerSide.isTWAH()) { %>
<div class="mySlides fade">
  <img src="../images/ic/response_level_twah.jpg" width="675" height="975">
</div>
<!--
<div class="mySlides fade">
  <img src="../images/pi/jci_twah.gif" width="675" height="975">
</div>
-->
<%} else { %>
<div class="mySlides fade">
  <img src="../images/ic/response_level_hkah.jpg" width="675" height="975">
</div>
<%} %>
</div>
<br>

<div style="text-align:center">
  <span class="dot"></span>
</div>
<%
		if (ConstantsServerSide.isTWAH()) {
			if (userBean.isLogin()) {
%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td class="title"><span>Patient Experience Model<img src="../images/title_arrow.gif">
				</span></td>
				</tr>
				<tr><td height="2" bgcolor="#840010"></td></tr>
				<tr><td height="10"></td></tr>
			</table>
			</td></tr>
			<tr><td>
			<a href="../portal/general.jsp?category=pem">Communication Team<img src="../images/title_arrow.gif"></a></br>
			<a href="../portal/general.jsp?category=pem">LeaderShip Development Sub-Committees<img src="../images/title_arrow.gif"></a></br>
			<a href="../portal/general.jsp?category=pem">Reward & Recognition Team<img src="../images/title_arrow.gif"></a></br>
			<a href="../portal/general.jsp?category=pem">Service Recovery Team<img src="../images/title_arrow.gif"></a></br>
			</td></tr>

				<tr><td class="title"><span>
<%				if ((isHospital || isEducation || isMarketing) && !isPEM) { %>
					<a href="../portal/news_view.jsp?newsCategory=<%=category %>"><%=columnTitle %></a>
<%				} else { %>
					<%=columnTitle %>
<%				} %> <img src="../images/title_arrow.gif">
					</span></td>
				</tr>
				<tr><td height="2" bgcolor="#840010"></td></tr>
				<tr><td height="10"></td></tr>
			</table>
<%			}
		}
	}


	if ("top".equals(category) && !result_promotion.isEmpty()) {
		int displayRecordNo = 30;

%>
<table class="news-promotion-box" style="width:100%;">
<tr><td colspan="3">
	<div >
<%
		if (result_promotion.size() > 0 ) {
%>
	<span class="subTitle">Promotion for Staff</span>
<%
		}
%>
	<table >
		<tr>
			<td>
<%
		for (int i = 0; i < result_promotion.size() && (!isTopNews || i < displayRecordNo); i++) {
%>
			<%=(i > 1 ? "<div class='promotionHidden'>" : "") %>
<%
			row = (ReportableListObject) result_promotion.get(i);
			newsID = row.getValue(0);
			newsCategory = row.getValue(1);
			newsType = row.getValue(2);
			title = row.getValue(3);
			titleUrl = row.getValue(4);
			titleImage = row.getValue(5);
			modifiedDate = row.getValue(6);
			content1 = row.getValue(9);
			likeCount = row.getValue(19);
			likeSelf = row.getValue(20);

			if ("classRelatedNews".equals(newsType)) {
				displayRecordNo ++;
				continue;
			}

			if (content1 != null  && content1.length() > 0) {
				content1 += " ..";
				newsurl = "javascript:readNews('" + newsCategory + "', '" + newsID + "');";
			} else if (titleUrl != null && titleUrl.length() > 0) {
				newsurl = titleUrl;
			} else {
				newsurl = "#";
			}

			if (!isTopNews && (isMarketing || newsType.equals(newsType_prev))) {
%>
		<span class="reported_quote"><%=newsType==null?"":newsType.toUpperCase() %></span>
		<a class="topstoryblue" href="<%=newsurl %>"><%=title %></a><br/><p/>
<%			} else {
				if (!isTopNews && skipColumnTitle) { %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td class="title"><span><%=newsType==null?"":newsType.toUpperCase() %> <img src="<%=path %>/images/title_arrow.gif"></span></td></tr>
				<tr><td height="2" bgcolor="#840010"></td></tr>
				<tr><td height="10"></td></tr>
			</table>
<%				} %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td rowspan="4" width="10" valign="top">
						<img src="<%=path %>/images/A logo.jpg" width="16" height="16"/>
					</td>
					<td rowspan="4" width="10" valign="top">&nbsp;</td>
					<td class="h1_margin">
						<a class="topstoryblue" href="<%=newsurl %>"><H1 id="TS"><%=title %></H1></a>
						<span id="<%=newsCategory %>_<%=newsID %>">
<jsp:include page="../portal/news_like_helper.jsp" flush="false">
	<jsp:param name="newsCategory" value="<%=newsCategory %>" />
	<jsp:param name="newsID" value="<%=newsID %>" />
	<jsp:param name="likeCount" value="<%=likeCount %>" />
	<jsp:param name="likeSelf" value="<%=likeSelf %>" />
</jsp:include>
						</span>
<%				if (userBean.isLogin() && userBean.isAccessible("function.news.type." + newsCategory)) { %>
						[ <a href="../admin/news.jsp?command=view&newsCategory=<%=newsCategory %>&newsID=<%=newsID %>">Edit</a> ]
<%				} %>
					</td>
				</tr>
<%				if (!skipBrief) { %>
				<tr><td height="2" bgcolor="#F2F2F2"></td></tr>
				<tr>
					<td class="h1_margin">
						<span class="reported_quote"><%=modifiedDate %> <%=newsType==null?"":newsType.toUpperCase() %></span>
<%					if (titleImage != null && titleImage.length() > 0) {
						if (titleImage.indexOf("http://") == 0) { %>
						<br/><img style='width:525px' src="<%=titleImage %>"><br/>
<%						} else { %>
						<br/><img style='width:525px' src="/upload/<%=newsCategory %>/<%=newsID %>/<%=titleImage %>"><br/>
<%						}
					} %>
<%					if (isTopNews && !("7".equals(newsID))) {%>
					<span class="pupular_content" style="line-height: 13px">
						<%=content1 %>
					</span>
<%					} %>
					</td>
				</tr>
<%					} %>
				<tr><td height="7">&nbsp;</td></tr>
			</table>
<%				}
				// keep previous news type
				newsType_prev = newsType;
%>
			<%=(i > 1 ? "</div>" : "") %>
<%
			}
%>
		</td>
	</tr>
</table>
	<%=(result_promotion.size() > 2 ? "<center><input type='image' id='hide' src='../images/promotion_down_arrow.png' height='25' onclick='return hidePromotionContent(this);'/></center>" : "") %>
</div>
</td>
</tr>
</table>
<%
	}

	if (isEducation) { %>
<jsp:include page="../portal/news.education.jsp" flush="false" />
<%	}
	if (!ConstantsServerSide.isAMC() && !userBean.isLogin()) { %>
				<div style="font-size:18px;width:100%" id="policy-banner">
					Reminder: Hospital Policy can only be viewed after login
				</div><br/><br/>
<%	}

	if (result.size() > 0) {
		if (isPopularNews) {
			%><table width="100%" border="0" cellspacing="0" cellpadding="0"><%
		}

		if (!isPEM) {
			int displayRecordNo = 5;
			for (int i = 0; i < result.size() && (!isTopNews || i < displayRecordNo); i++) {
				row = (ReportableListObject) result.get(i);
				newsID = row.getValue(0);
				newsCategory = row.getValue(1);
				newsType = row.getValue(2);
				title = row.getValue(3);
				titleUrl = row.getValue(4);
				titleImage = row.getValue(5);
				modifiedDate = row.getValue(6);
				content1 = row.getValue(9);
				likeCount = row.getValue(19);
				likeSelf = row.getValue(20);

				if ("classRelatedNews".equals(newsType)) {
					displayRecordNo ++;
					continue;
				}

				if (content1 != null  && content1.length() > 0) {
					content1 += " ..";
					newsurl = "javascript:readNews('" + newsCategory + "', '" + newsID + "');";
				} else if (titleUrl != null && titleUrl.length() > 0) {
					newsurl = titleUrl;
				} else {
					newsurl = "#";
				}

				if (isPopularNews) {
					count++;
%>
				<tr>
					<td class="most_popular" bgcolor="#<%=(count%2==1)?"FFFFFF":"e8e8e8"%>" width="15" valign="top">
						<b class="pupular_content"><%=count %>.</b>
					</td>
					<td class="most_popular" bgcolor="#<%=(count%2==1)?"FFFFFF":"e8e8e8"%>">
						<a href="<%=newsurl %>" class="topstoryblue"><H2 id="TS"><%=title %></H2></a>
						&nbsp;<span class="reported_quote"><%=modifiedDate.substring(0, 10) %><%if (count == 1 && isPopularNews) { %><img src="../images/hot.gif"><%} %></span>
<%					if (userBean.isLogin() && userBean.isAccessible("function.news.type." + newsCategory)) { %>
						[ <a href="../admin/news.jsp?command=view&newsCategory=<%=newsCategory %>&newsID=<%=newsID %>">Edit</a> ]
<%					} %>
					</td>
					<td bgcolor="#FFFFFF" width="10">&nbsp;</td>
				</tr>
<%				} else if (!isTopNews && (isMarketing || newsType.equals(newsType_prev))) { %>
				<span class="reported_quote"><%=newsType==null?"":newsType.toUpperCase() %></span>
				<a class="topstoryblue" href="<%=newsurl %>"><%=title %></a><br/><p/>
<%				} else { %>
<%					if (!isTopNews && skipColumnTitle) { %>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
<%						if ("7".equals(newsID) && "accreditation".equals(newsCategory) && "announcement".equals(newsType) && "Tsuen Wan Centre Map".equals(title)) { %>
						<tr><td class="title"><span>Tsuen Wan Centre Map <img src="<%=path %>/images/title_arrow.gif"></span></td></tr>
<%						} else {%>
						<tr><td class="title"><span><%=newsType==null?"":newsType.toUpperCase() %> <img src="<%=path %>/images/title_arrow.gif"></span></td></tr>
<%						} %>
						<tr><td height="2" bgcolor="#840010"></td></tr>
						<tr><td height="10"></td></tr>
					</table>
<%					} %>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td rowspan="4" width="10" valign="top">
								<img src="<%=path %>/images/A logo.jpg" width="16" height="16"/>
							</td>
							<td rowspan="4" width="10" valign="top">&nbsp;</td>
							<td class="h1_margin">
								<a class="topstoryblue" href="<%=newsurl %>"><H1 id="TS"><%=title %></H1></a>
								<span id="<%=newsCategory %>_<%=newsID %>">
<jsp:include page="../portal/news_like_helper.jsp" flush="false">
	<jsp:param name="newsCategory" value="<%=newsCategory %>" />
	<jsp:param name="newsID" value="<%=newsID %>" />
	<jsp:param name="likeCount" value="<%=likeCount %>" />
	<jsp:param name="likeSelf" value="<%=likeSelf %>" />
</jsp:include>
								</span>
<%					if (userBean.isLogin() && userBean.isAccessible("function.news.type." + newsCategory)) { %>
								[ <a href="../admin/news.jsp?command=view&newsCategory=<%=newsCategory %>&newsID=<%=newsID %>">Edit</a> ]
<%					} %>
							</td>
						</tr>
<%					if (!skipBrief) { %>
						<tr><td height="2" bgcolor="#F2F2F2"></td></tr>
						<tr>
							<td class="h1_margin">
								<span class="reported_quote"><%=modifiedDate %> <%=newsType==null?"":newsType.toUpperCase() %></span>
<%						if (titleImage != null && titleImage.length() > 0) {
							if (titleImage.indexOf("http://") == 0) { %>
								<br/><img style='width:525px' src="<%=titleImage %>"><br/>
<%							} else { %>
								<br/><img style='width:525px' src="/upload/<%=newsCategory %>/<%=newsID %>/<%=titleImage %>"><br/>
<%							}
						} %>
<%						if (isTopNews && i == 0) { %>
								<span class="pupular_content" style="line-height: 13px">
<%							if ("LMC".equals(newsCategory) && "3".equals(newsID)) {
								%>...<%
							} else {
%>
								<!-- <%=content1 %>-->
<%
							}
%>
								</span>
<%						} %>
							</td>
						</tr>
<%					} %>
						<tr><td height="7">&nbsp;</td></tr>
					</table>
<%				}
				// keep previous news type
				newsType_prev = newsType;
			}
			if (isPopularNews) {
				%></table><%
			}
		}
	}
%>
<script language="javascript">
	$(document).ready(function() {
		$('#xmas').click(function() {
			window.open('../xmas/<%=xmasLink %>', '_blank');
		});
		setInterval("animation()",1500);

		$(".promotionHidden").hide();
	});

	function hidePromotionContent(img) {
		if (img.src.match(/promotion_down_arrow/)) {
			img.src = "../images/promotion_up_arrow.png";
		} else {
			img.src = "../images/promotion_down_arrow.png";
		}

		$(".promotionHidden").toggle(500);
		return false;
	}

	function animation() {
		$('div#policy-banner').animate( { backgroundColor: 'yellow' }, 500)
    			.animate( { backgroundColor: 'white' }, 500);
	}

	$(document).find('.addHitRate').each(function(i, v) {
		$(v).click(function() {
			$.ajax({
				type: "POST",
				url: "../ui/docHitRateCMB.jsp",
				data: "docID=" + this.getAttribute("docID")+"&module=PEM",
				success: function(values) {
				if (values != '') {
				}//if
				}//success
			});//$.ajax
		});
	});

	function showSlides() {
		var i;
		var slides = document.getElementsByClassName("mySlides");
		var dots = document.getElementsByClassName("dot");
		for (i = 0; i < slides.length; i++) {
			slides[i].style.display = "none";
		}
		slideIndex++;
		if (slideIndex > slides.length) {slideIndex = 1}
			for (i = 0; i < dots.length; i++) {
			dots[i].className = dots[i].className.replace(" active", "");
		}
		slides[slideIndex-1].style.display = "block";
		dots[slideIndex-1].className += " active";
		setTimeout(showSlides, 10000); // Change image every 10 seconds
	}

	var slideIndex = 0;
<%
	if (!skipColumnTitle) {
%>
	showSlides();
<%
	}
%>
</script>
<style>
* {box-sizing: border-box;}
body {font-family: Verdana, sans-serif;}
.mySlides {display: none;}
img {vertical-align: middle;}

/* The dots/bullets/indicators */
.dot {
  height: 15px;
  width: 15px;
  margin: 0 2px;
  background-color: #bbb;
  border-radius: 50%;
  display: inline-block;
  transition: background-color 0.6s ease;
}

.active {
  background-color: #717171;
}

/* Fading animation */
.fade {
  -webkit-animation-name: fade;
  -webkit-animation-duration: 1.5s;
  animation-name: fade;
  animation-duration: 1.5s;
}

@-webkit-keyframes fade {
  from {opacity: .4}
  to {opacity: 1}
}

@keyframes fade {
  from {opacity: .4}
  to {opacity: 1}
}

/* On smaller screens, decrease text size */
@media only screen and (max-width: 300px) {
  .text {font-size: 11px}
}
</style>