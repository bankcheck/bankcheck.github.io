<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%
String category = "title.education";
String eventID = request.getParameter("eventID");
String evaluationID = request.getParameter("evaluationID");
String searchYear = request.getParameter("searchYear_yy");
if("".equals(searchYear) || searchYear == null){
	searchYear = Integer.toString(DateTimeUtil.getCurrentYear()) ;
}
ArrayList evaluation_list = EvaluationDB.getList(eventID, evaluationID, ConstantsVariable.NO_VALUE,searchYear);
ArrayList evaluation_freeText_list = EvaluationDB.getFreeTextList(eventID, evaluationID);
request.setAttribute("evaluation_list", evaluation_list);
request.setAttribute("evaluation_freeText_list", evaluation_freeText_list);

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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.evaluation.list" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="evaluation_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.course" /></td>
		<td class="infoData" width="70%">
			<select name="eventID" onchange="return submitSearch()">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="education" />
	<jsp:param name="eventType" value="online" />
	<jsp:param name="eventID" value="<%=eventID %>" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText" >
		<td class="infoLabel" width="30%">Year</td>
		<td class="infoData" width="70%" >
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="searchYear" />
	<jsp:param name="day_yy" value="<%=searchYear %>" />
	<jsp:param name="yearRange" value="1" />
	<jsp:param name="isYearOnly" value="Y" />
</jsp:include>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="evaluationID" value="<%=evaluationID %>" />
</form>
<bean:define id="functionLabel"><bean:message key="function.evaluation.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="evaluation_list.jsp" method="post">
<!-- Selectable question -->
<div id="select_q" style="margin: 10px 0;">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle">Questions (Select) </td>
	</tr>
</table>
<display:table id="row" name="requestScope.evaluation_list" export="true" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" titleKey="prompt.question" style="width:30%"/>
	<display:column property="fields3" title="Strongly Disagree" style="width:10%" />
	<display:column property="fields4" title="Disagree" style="width:10%"/>
	<display:column property="fields5" title="Neutral" style="width:10%" />
	<display:column property="fields6" title="Agree" style="width:10%" />
	<display:column property="fields7" title="Strongly Agree" style="width:10%"/>
	<display:column property="fields8" title="N/A" style="width:10%"/>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</div>
<!-- Free text question -->
<div id="select_ft" style="margin: 10px 0;">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle">Questions (Free text) </td>
	</tr>
</table>
<display:table id="row2" name="requestScope.evaluation_freeText_list" export="true" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"></display:column>
	<display:column property="fields1" titleKey="prompt.question" style="width:30%"/>
	<display:column property="fields3" titleKey="prompt.answer" style="width:65%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</div>
</form>
<script language="javascript">
<!--
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
	}

	function submitAction(cmd, sid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&staffID=" + sid);
		return false;
	}
-->
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>