<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

boolean hasCategory = false;
String newsCategory = request.getParameter("newsCategory");

String category = "title.education";
String subTitle = null;
if (newsCategory != null && newsCategory.length() > 0) {
	if ("infection control".equals(newsCategory)) {
		subTitle = "department.780";
		hasCategory = true;
	} else if ("osh".equals(newsCategory)) {
		subTitle = "department.785";
		hasCategory = true;
	} else if ("nursing".equals(newsCategory)) {
		subTitle = "label.nursing";
		hasCategory = true;
	} else if ("pi".equals(newsCategory)) {
		subTitle = "label.performanceImprovement";
		hasCategory = true;
	} else {
		subTitle = "";
	}
} else {
	subTitle = "";
}

if (hasCategory) {
	request.setAttribute("news_list", NewsDB.getList(userBean, newsCategory, 100));
}

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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
	<jsp:param name="pageTitle" value="title.departmental.education.material" />
	<jsp:param name="pageSubTitle" value="<%=subTitle %>" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<table><!-- dummy --></table>
<form name="form1" action="education_material_list.jsp" method="post">
<%if (hasCategory) { %>
<bean:define id="functionLabel"><bean:message key="title.departmental.education.material" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.news_list" export="false" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields3" titleKey="prompt.headline" style="width:50%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return readNews('<c:out value="${row.fields1}" />', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<%} else { %>
<table cellpadding="0" cellspacing="0" class="contentFrameMenu" border="0">
	<tr class="bigText">
		<td align="left"><a class="topstoryblue" href="javascript:deptDirectory('infection control');"><span class="labelColor1">Infection Control</a></span></td>
	</tr>
	<tr class="bigText">
		<td align="left"><a class="topstoryblue" href="javascript:deptDirectory('osh');"><span class="labelColor2">OSH</a></span></td>
	</tr>
	<tr class="bigText">
		<td align="left"><a class="topstoryblue" href="javascript:deptDirectory('nursing');"><span class="labelColor3">Nursing</a></span></td>
	</tr>
	<tr class="bigText">
		<td align="left"><a class="topstoryblue" href="javascript:deptDirectory('pi');"><span class="labelColor4">PI</a></span></td>
	</tr>
</table>
<%} %>
<input type="hidden" name="newsCategory">
</form>
<script language="javascript">
	function deptDirectory(c) {
		document.form1.newsCategory.value = c;
		document.form1.submit();
	}

	function readNews(cid, nid) {
		document.form1.action = "../portal/news_view.jsp";
		callPopUpWindow(document.form1.action + "?newsCategory=" + cid + "&newsID=" + nid);
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>