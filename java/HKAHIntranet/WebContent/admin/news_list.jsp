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


//System.out.println("<p>good ?</p><p><strong><strike>dsfdasfdsfds</strike></strong></p>".replaceAll("\\<.*?>",""));

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
<%if (!"Y".equals(skipHeader)) { %>
	<jsp:include page="../common/header.jsp"/>
<% } %>
<body>
<%
String keepRef = "Y";
String title="function.news.list";
if("lmc.crm".equals(newsCategory)) {
	keepRef = "N";
	title="function.news.crm.list";
} else if(isRenovUpd) {
	keepRef = "N";
	title="function.renov.upd.list";
}
else {
%>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%} %>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="<%=keepRef %>" />
</jsp:include>

<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<%
/*
	search_form is not working in www-server, but cannot delete it
	user search_form_news_list instead
*/
%>
<% if (true) { %><div style="display: none"><% } %>
<form name="search_form" method="post" >

<% if (!true) { %>

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
<% if(isRenovUpd) { %>
	<tr>
		<td><input type="hidden" name="newsCategory" value="<%=newsCategory %>" /></td>
	</tr>
<% } else { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.category" /></td>
		<td class="infoData" width="70%">
			<select name="newsCategory" onchange="updateNewsType('');">
<jsp:include page="../ui/newsCategoryCMB.jsp" flush="false">
	<jsp:param name="newsCategory" value="<%=newsCategory %>" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
	</tr>
<% } %>	
	<tr class="smallText">
		<td class="infoLabel" width="30%">
<% if(isRenovUpd) { %>	
			<bean:message key="prompt.title" />
<% } else { %>
			<bean:message key="prompt.headline" />
<% } %>	
		</td>
		<td class="infoData" width="70%">
			<input type="text" name="headline" value="<%=headline == null ? "" : headline %>" size="50" />
		</td>
	</tr>
	<tr class="smallText">
<% if(isRenovUpd) { %>	
		<td class="infoLabel" width="30%">		
			<bean:message key="prompt.status" />
		</td>
		<td class="infoData" width="70%">
			<select name="newsType">
				<option value=""></option>
				<option value="status1" <%="status1".equals(newsType) ? " selected=\"selected\"" : "" %>>Completed</option>
				<option value="status2" <%="status2".equals(newsType) ? " selected=\"selected\"" : "" %>>To be Completed</option>
				<option value="status3" <%="status3".equals(newsType) ? " selected=\"selected\"" : "" %>>To Commence</option>
				<option value="status4" <%="status4".equals(newsType) ? " selected=\"selected\"" : "" %>>Delay</option>
			</select>
		</td>
<% } else { %>	
		<td class="infoLabel" width="30%">		
			<bean:message key="prompt.type" />
		</td>
		<td class="infoData" width="70%">
			<span id="matchNewsType_indicator2"></span>
		</td>
<% } %>			
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Sort By</td>
		<td class="infoData" width="70%">
			<select name="sortBy">
<% if(isRenovUpd) { %>
				<option value="1" <%=sortByInt == 1 ? " selected=\"selected\"" : "" %>><bean:message key="prompt.status" /></option>
				<option value="0" <%=sortByInt == 0 ? " selected=\"selected\"" : "" %>>Update Date (Latest)</option>
<% } else { %>	
				<option value="1" <%=sortByInt == 1 ? " selected=\"selected\"" : "" %>>Type</option>
				<option value="0" <%=sortByInt == 0 ? " selected=\"selected\"" : "" %>>Post Date (Latest)</option>
				<option value="2" <%=sortByInt == 2 ? " selected=\"selected\"" : "" %>>Expiry Date (Latest)</option>
<% } %>					
			</select>
		</td>
	</tr>	
</table>

<% } %>

<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>

</form>



<% if (true) { %></div><% } %>




<% if (true) { %>
<form id="search_form_news_list" name="search_form_news_list" method="post">



<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
<% if(isRenovUpd) { %>
	<tr>
		<td><input type="hidden" name="newsCategory" value="<%=newsCategory %>" /></td>
	</tr>
<% } else { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.category" /></td>
		<td class="infoData" width="70%">
			<select name="newsCategory" onchange="updateNewsType('');">
<jsp:include page="../ui/newsCategoryCMB.jsp" flush="false">
	<jsp:param name="newsCategory" value="<%=newsCategory %>" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
	</tr>
<% } %>	
	<tr class="smallText">
		<td class="infoLabel" width="30%">
<% if(isRenovUpd) { %>	
			<bean:message key="prompt.title" />
<% } else { %>
			<bean:message key="prompt.headline" />
<% } %>	
		</td>
		<td class="infoData" width="70%">
			<input type="text" name="headline" value="<%=headline == null ? "" : headline %>" size="50" />
		</td>
	</tr>
	<tr class="smallText">
<% if(isRenovUpd) { %>	
		<td class="infoLabel" width="30%">		
			<bean:message key="prompt.status" />
		</td>
		<td class="infoData" width="70%">
			<select name="newsType">
				<option value=""></option>
				<option value="status1" <%="status1".equals(newsType) ? " selected=\"selected\"" : "" %>>Completed</option>
				<option value="status2" <%="status2".equals(newsType) ? " selected=\"selected\"" : "" %>>To be Completed</option>
				<option value="status3" <%="status3".equals(newsType) ? " selected=\"selected\"" : "" %>>To Commence</option>
				<option value="status4" <%="status4".equals(newsType) ? " selected=\"selected\"" : "" %>>Delay</option>
			</select>
		</td>
<% } else { %>	
		<td class="infoLabel" width="30%">		
			<bean:message key="prompt.type" />
		</td>
		<td class="infoData" width="70%">
			<span id="matchNewsType_indicator"></span>
		</td>
<% } %>			
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Sort By</td>
		<td class="infoData" width="70%">
			<select name="sortBy">
<% if(isRenovUpd) { %>
				<option value="1" <%=sortByInt == 1 ? " selected=\"selected\"" : "" %>><bean:message key="prompt.status" /></option>
				<option value="0" <%=sortByInt == 0 ? " selected=\"selected\"" : "" %>>Update Date (Latest)</option>
<% } else { %>	
				<option value="1" <%=sortByInt == 1 ? " selected=\"selected\"" : "" %>>Type</option>
				<option value="0" <%=sortByInt == 0 ? " selected=\"selected\"" : "" %>>Post Date (Latest)</option>
				<option value="2" <%=sortByInt == 2 ? " selected=\"selected\"" : "" %>>Expiry Date (Latest)</option>
<% } %>					
			</select>
		</td>
	</tr>	
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<% } %>


<form name="form1_news" action="<html:rewrite page="/admin/news.jsp" />" method="post">
<%if (newsCategory != null) { %>
<bean:define id="functionLabel"><bean:message key="function.news.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.news_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields6" titleKey="prompt.date" style="width:10%"/>
<% if (!isRenovUpd) { %>	
	<display:column property="fields7" titleKey="prompt.expired" style="width:10%"/>
<% } %>
<% if (isRenovUpd) { %>
	<display:column property="fields22" titleKey="prompt.postHomepage" style="width:10%"/>
<%} %>
<%if ("poster".equals(newsCategory) || isRenovUpd){ %>
	<c:set var="tempType" value="${row.fields2}"/>	
<% String tempType = (String)pageContext.getAttribute("tempType");
	if("hospital".equals(tempType)){
		tempType = "Hospital (All)";
	}else if("hospital.gf".equals(tempType)){
		tempType = "Hospital G/F";
	}else if("hospital.8f".equals(tempType)){
		tempType = "Hospital 8/F";
	}else if("larue.gf".equals(tempType)){
		tempType = "LaRue LG/F";
	}else if("larue.1f".equals(tempType)){
		tempType = "LaRue 1/F";
	}else if("message".equals(tempType)){
		tempType = "Message";
	}else if("all".equals(tempType)){
		tempType = "All";
	}else if("status1".equals(tempType)){
		tempType = "Completed";
	}else if("status2".equals(tempType)){
		tempType = "To be Completed";
	}else if("status3".equals(tempType)){
		tempType = "To Commence";
	}else if("status4".equals(tempType)){
		tempType = "Delay";		
	}
%>
	<% if (isRenovUpd) { %>	
	<display:column titleKey="prompt.status" style="width:10%">
			<c:out value='<%=tempType%>'/>
	</display:column>
	<% } else {%>
	<display:column titleKey="prompt.type" style="width:10%">
			<c:out value='<%=tempType%>'/>
	</display:column>
	<% }%>

<% } else {%>
	<display:column property="fields2" titleKey="prompt.type" style="width:10%"/>
<% }%>
<%if (showSender) { %>
	<display:column property="fields21" titleKey="prompt.sender" style="width:10%"/>
<%} %>
<% if (isRenovUpd) { %>	
	<display:column property="fields3" titleKey="prompt.title" style="width:30%"/>
<% } else {%>
	<display:column property="fields3" titleKey="prompt.headline" style="width:30%"/>
<%} %>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
<%if (isRenovUpd){ %>
	<c:set var="tempContent" value="${row.fields23}"/>	
<% String tempContent = (String)pageContext.getAttribute("tempContent");
   tempContent = tempContent == null ? tempContent : tempContent.replaceAll("\\<.*?>","");
	//System.out.println(tempContent);
%>	
	<display:column media="csv excel xml pdf" titleKey="prompt.content" style="width:30%">
		<c:out value='<%=tempContent%>'/>
	</display:column>
<%
} 
%>	
</display:table>
<%} %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.news.create" /></button></td>
	</tr>
</table>
</form>
<script language="javascript">
<!--
	function submitSearch() {
<% if (true) { %>
		document.search_form_news_list.submit();
<% } else { %>
		document.search_form.submit();
<% } %>		
	}

	function clearSearch() {
<% if (true) { %>
	<% if (!isRenovUpd) { %>
		document.search_form_news_list.newsCategory.value = "";
	<% } %>
		document.search_form_news_list.headline.value = "";
	
<% } else { %>
		document.search_form.newsCategory.value = "";
		document.search_form.headline.value = "";
<% } %>	
	}

	function submitAction(cmd, cid, nid) {
		//alert('cmd='+cmd);
<% if (isRenovUpd) { %>
		cid = '<%=newsCategory %>';
		//alert('cid='+cid);
<% } else {%>
		if (cmd == 'create') {
			cid = document.search_form_news_list.newsCategory.value;
		}
<%} %>
		callPopUpWindow(document.form1_news.action + "?command=" + cmd + "&newsCategory=" + cid + "&newsID=" + nid);
		return false;
	}
	
	// ajax
	var http = createRequestObject();

	function updateNewsType(pvalue) {
		var newsCategory = document.forms["search_form_news_list"].elements["newsCategory"].value;

		<%if("lmc.crm".equals(newsCategory)) {%>
			http.open('get', '../../ui/newsTypeCMB.jsp?newsCategory=' + newsCategory + '&newsType=' + pvalue + '&timestamp=<%=(new java.util.Date()).getTime() %>');
		<%}else {%>
			http.open('get', '../ui/newsTypeCMB.jsp?newsCategory=' + newsCategory + '&newsType=' + pvalue + '&timestamp=<%=(new java.util.Date()).getTime() %>');
		<%}%>
		//assign a handler for the response
		http.onreadystatechange = processResponseNewsType;

		//actually send the request to the server
		http.send(null);
	}

	function processResponseNewsType() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("matchNewsType_indicator").innerHTML = '<select name="newsType">' + http.responseText + '</select>';
		}
	}
<% if (!isRenovUpd) { %>
	updateNewsType('<%=newsType %>');
<% } %>
-->
</script>
<%if (!"lmc.crm".equals(newsCategory)) { %>
</DIV>

</DIV></DIV>
<%} %>
<%if (!"Y".equals(skipHeader)) { %>
	<jsp:include page="../common/footer.jsp" flush="false" />
<%} %>
</body>
</html:html>