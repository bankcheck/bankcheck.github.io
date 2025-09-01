<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>


<%
UserBean userBean = new UserBean(request);
String siteCode = userBean.getSiteCode()==null?"twah":userBean.getSiteCode();
String pageName = request.getParameter("pageName");
if("".equals(pageName)|| pageName == null){
pageName = "view";
}


String infoCategory = request.getParameter("infoCategory");
if (infoCategory != null) {
	request.setAttribute("info_list", ICPageDB.getList(infoCategory)); 
}

String infoName = infoCategory;

if (ConstantsServerSide.isHKAH()) {
	if ("Information".equals(infoCategory)) {
		infoName = "Alert";
	} else if ("Disease".equals(infoCategory)) {
		infoName = "News";
	} 
}

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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
<tr>
	<td align="center" style="padding:3px;">
	<img src="../images/ic/icTitle.jpg"  width="800" height="120" border="0"/>
	</td>
</tr>
</table>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="" />
	<jsp:param name="suffix" value="_1"/>
	<jsp:param name="pageMap" value="N"/>
</jsp:include>

<form name="list_form" action="webinfo_list.jsp"" method="post">
<%if("view".equals(pageName)){ %>
  <table>
  <tr><td><a href="javascript:void(0);" onclick="return submitPage('front','<%=siteCode%>');"><img src="../images/ic/TextEdit.png"  width="100" height="100"/><font size="bigger">Page Content Management</font></a></td></tr>
  <tr><td><a href="javascript:void(0);" onclick="return submitPage('file','<%=siteCode%>');"><img src="../images/ic/TextEdit.png"  width="100" height="100"/><font size="bigger">File List Management</font></a></td></tr>
<%if (ConstantsServerSide.isTWAH()) {%>
  <tr><td><a href="javascript:void(0);" onclick="return submitAction('ICPractice','infection control','1');"><img src="../images/ic/TextEdit.png"  width="100" height="100"/><font size="bigger">IC Practice Management</font></a></td></tr>
<%}else{ %>
  <tr><td><a href="javascript:void(0);" onclick="return submitAction('ICPractice','infection control','1');"><img src="../images/ic/TextEdit.png"  width="100" height="100"/><font size="bigger">WebSite/Organisation Management</font></a></td></tr>
<%} %>
  </table>
<%} %>  
  <input type="hidden" name="pageName"/>  
</form>

<%if("front".equals(pageName)){ %>
<form name="search_form" method="post">
  <table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.category" /></td>
		<td class="infoData" width="70%">
			<select name="infoCategory">
			<%if (ConstantsServerSide.isTWAH()) {%>	
				<option value="Calendar" <%="Calendar".equals(infoCategory)?" selected":"" %>>Calendar</option>	
				<option value="News" <%="News".equals(infoCategory)?" selected":"" %>>News</option>
				<option value="Hot" <%="Hot".equals(infoCategory)?" selected":"" %>>Hot Search</option>
				<option value="notification" <%="notification".equals(infoCategory)?" selected":"" %>>Notification</option>		
				<option value="Disease" <%="Disease".equals(infoCategory)?" selected":"" %>>Infectious Disease</option>
				<option value="Surveilance" <%="Surveilance".equals(infoCategory)?" selected":"" %>>Surveilance</option>
				<option value="notification" <%="notification".equals(infoCategory)?" selected":"" %>>Notification</option>
			<%} else { %>
				<option value="Calendar" <%="Calendar".equals(infoCategory)?" selected":"" %>>Calendar</option>	
				<option value="Information" <%="Information".equals(infoCategory)?" selected":"" %>>Alert</option>
				<option value="Disease" <%="Disease".equals(infoCategory)?" selected":"" %>>News</option>
				<option value="Isolation" <%="Isolation".equals(infoCategory)?" selected":"" %>>Isolation</option>		
			
			<%} %>

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
<input type="hidden" name="pageName" value="front"/> 
</form>
<form name="form1" action="<html:rewrite page="/ic/webinfo_content.jsp" />" method="post">
<%if(infoCategory != null){ %>
<display:table id="row" name="requestScope.info_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<%if(!"Hot".equals(infoCategory)){ %>
	<display:column property="fields2" titleKey="prompt.date" style="width:10%"/>
	<%} %>
	<display:column property="fields0" titleKey="prompt.description" style="width:10%"/>
	<%if(!"Calendar".equals(infoCategory)){ %>
	<display:column property="fields1" title="Link" style="width:10%"/>
	<%} %>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view','<c:out value="${row.fields3}" />','<%=infoCategory%>');"><bean:message key="button.view" /></button>
	</display:column>
</display:table>
<%} %>
<table width="100%" border="0">
	<tr class="smallText">
		<%if(!"Surveilance".equals(infoCategory)){ %>
		<td align="center"><button onclick="return submitAction('create', '','<%=infoCategory%>');">Create <%=infoCategory==null?"":infoName %></button></td>
		<%} %>
	</tr>
</table>
<input type="hidden" name="infoID"/>
 
</form>
<%} %>
<script language="javascript">
function submitSearch() {
	document.search_form.submit();

}
function submitAction(cmd, cid,aid) {
	if(cmd == 'ICPractice'){
		callPopUpWindow("../admin/news.jsp" + "?command=view&newsType=article&newsCategory=" + cid + "&newsID=" + aid);
	}else{
		aid = document.search_form.infoCategory.value;
		callPopUpWindow(document.form1.action + "?command=" + cmd  + "&infoID=" + cid+"&infoCategory="+aid);
	}

	return false;
}
function submitPage(page,siteCode){
	if(page =='file'){
			if(siteCode == 'hkah'){
			  window.location = '../documentManage/download.jsp?rootFolder=\\\\www-server\\document\\Upload\\Infection Control\\portal&icYN=Y';
			}else{
			  window.location = '../documentManage/download.jsp?rootFolder=\\\\192.168.0.20\\document\\Upload\\Infection Control&icYN=Y';
			}
	}else{
	document.list_form.pageName.value = page;
	document.list_form.submit();
	}
	
}
</script>
</DIV></DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>