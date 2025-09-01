<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

String newsCategory = request.getParameter("newsCategory");
String headline = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "headline"));
String newsType = ParserUtil.getParameter(request, "newsType");
String sortBy = request.getParameter("sortBy");
String skipHeader = request.getParameter("skipHeader");
int sortByInt = 1;

try {
	sortByInt = Integer.parseInt(sortBy);
} catch (Exception e) {}
if (newsCategory != null) {
	request.setAttribute("news_list", NewsDB.getList(userBean, newsCategory, newsType, headline, 800, sortByInt));
}
boolean showSender = "executive order".equals(newsCategory) ||
		"physician".equals(newsCategory) ||
		"vpma".equals(newsCategory);
boolean isRenovUpd = "renov.upd".equals(newsCategory);

%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Test" />
</jsp:include>

<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<form name="search_form" method="post" >
<table width="100%" border="1">
	<tr>
		<td>abc</td><td>abc</td><td>abc</td>
	</tr>
</table>
</form>
<script language="javascript">
	function submitSearch() {

	}

</script>

</DIV>

</DIV></DIV>

</body>
</html:html>