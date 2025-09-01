<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%
UserBean userBean = new UserBean(request);

String newsCategory = request.getParameter("newsCategory");
String command = request.getParameter("command");
String newsType = request.getParameter("newsType");
String newsID = request.getParameter("newsID");
String title = null;
String titleImage = null;
String postDate = null;
String content = null;
String hitRate = null;
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

boolean showList = false;

try {
	if (newsID == null && newsCategory != null) {
		String[] resultArr = NewsDB.getNewsID(newsCategory, newsType);
		if (resultArr != null){
			newsID = resultArr[0];
			newsCategory = resultArr[1];
		}
	}

	if (newsID != null && newsID.length() > 0) {
		// update hit rate
		NewsDB.updateHitRate(newsID, newsCategory);
		ArrayList result = null;
		// get news content
		if("approve".equals(command) || "poster".equals(newsCategory)){
			result = NewsDB.get(userBean, newsID, newsCategory,"0");
			if (result.size()==0){
				result = NewsDB.get(userBean, newsID, newsCategory);
			}
		}else{
			result = NewsDB.get(userBean, newsID, newsCategory);
		}
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			title = row.getValue(3);
			titleImage = row.getValue(5);
			postDate = row.getValue(6);
			hitRate = row.getValue(8);

			StringBuffer contentSB = new StringBuffer();
			result = NewsDB.getContent(newsID, newsCategory);
			if (result != null) {
				for (int i = 0; i < result.size(); i++) {
					row = (ReportableListObject) result.get(i);
					contentSB.append(row.getValue(0));
				}
			}
			content = contentSB.toString();
		}
	} else {
		showList = true;
		// show news list
		request.setAttribute("news_list", NewsDB.getList(userBean, newsCategory, 100));

	}
} catch (Exception e) {
	e.printStackTrace();
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<%if (showList) { %>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.news.list" />
	<jsp:param name="accessControl" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<bean:define id="functionLabel"><bean:message key="function.news.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.news_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.date" style="width:10%">
		<c:out value="${row.fields5}" />
	</display:column>
	<display:column property="fields3" titleKey="prompt.headline" style="width:40%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return readNews('<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
</DIV>

</DIV></DIV>
<%} else { %>
<div class="memo">
<a class="topstoryblue" href="#"><H1 id="TS"><%=title %></H1></a>&nbsp;&nbsp;<span class="reported_quote"><%if(!"poster".equals(newsCategory)){ %><bean:message key="prompt.hitRate" />: <%=hitRate %><%} %></span><p/><br/>
<span class="reported_quote"><%=postDate %></span>
<span class="pupular_content" style="line-height: 20px">
<%	if (titleImage != null && titleImage.length() > 0) {
		if (titleImage.indexOf("http://") == 0) { %>
			<br/><img src="<%=titleImage %>"><br/>
<%		} else { %>
			<br/><img src="/upload/<%=newsCategory %>/<%=newsID %>/<%=titleImage %>"><br/>
<%		}
	} %>
<%if ("e-resource".equals(newsCategory)) {
	if (ConstantsServerSide.isHKAH()) {
		List menuList = StaffEducationDB.getEeMenuModuleList(1);
		request.setAttribute("menuList", menuList);
%>
	<table width="100%" border="0">
		<tr>
			<td>
				<div id="staffEducationWrapper">
					<div id="educationFrontPage">
						<table width="100%" border="0" cellpadding="5" cellspacing="0">
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
			</td>
		</tr>
	</table>
<%
	}
} %>
	<%=content %>

	<%if("poster".equals(newsCategory)){%>
	<button onclick="return approveNews('<%=newsID %>','<%=newsCategory %>');" class="btn-click">Approve</button>
	<div id="approve"></div>
	<%} %>
</span>
</div>
<%} %>
<script language="javascript">
<!--
	$('div.memo').each(function() {
		$(this).corner("dog");
	});

	function readNews(nid) {
		callPopUpWindow("../portal/news_view.jsp?newsCategory=<%=newsCategory %>&newsID=" + nid);
		return false;
	}
	function approveNews(newsID,newsCategory){
		$('#approve').load('../ui/docHitRateCMB.jsp?docID='+newsID+
				'&module='+newsCategory,new Date()
				, function() { 
					if($('#approve').html() =='Approved'){
						alert("approve Successfully.");
					}else{
						alert("approve failed");
					}
					window.close();
				  });
		return false;
	}

</script>
</body>
</html:html>