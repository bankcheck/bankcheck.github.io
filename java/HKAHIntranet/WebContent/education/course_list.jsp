<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();

String category = "title.education";
String deptCode = request.getParameter("deptCode");
if (deptCode == null) {
	deptCode = userBean.getDeptCode();
}
String courseDesc = request.getParameter("courseDesc");
String courseCategory = request.getParameter("courseCategory");
// set default value
if (courseCategory == null) {
	courseCategory = "compulsory";
}
boolean isCompulsory = "compulsory".equals(courseCategory);
boolean isInservice = "inservice".equals(courseCategory);
boolean isOptional = "other".equals(courseCategory);
boolean isCNE = "CNE".equals(courseCategory);
boolean isFireDrill = "firedrill".equals(courseCategory);
boolean isTND = "tND".equals(courseCategory);
boolean isIntClass = "intClass".equals(courseCategory);
boolean isMockCode = "mockCode".equals(courseCategory);
boolean isMockDrill = "mockDrill".equals(courseCategory);

String courseType = request.getParameter("courseType");
// set default value
if (courseType == null) {
	courseType = "class";
}
boolean isClassRoom = "class".equals(courseType);
boolean isOnline = "online".equals(courseType);
request.setAttribute("course_list", EventDB.getList("education", deptCode, courseDesc, courseCategory, courseType));

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
<jsp:include page="../common/header.jsp">
	<jsp:param name="sortColumn" value="2" />
</jsp:include>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.course.list" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="course_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.courseDescription"/></td>
		<td class="infoData" width="70%"><input type="textfield" name="courseDesc" value="<%=courseDesc==null?"":courseDesc %>" maxlength="100" size="50"> (<bean:message key="prompt.optional" />)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.courseCategory" /></td>
		<td class="infoData" width="70%">
			<input type="radio" name="courseCategory" value="compulsory"<%=isCompulsory?" checked":"" %>><bean:message key="label.compulsory" />
			<input type="radio" name="courseCategory" value="inservice"<%=isInservice?" checked":"" %>><bean:message key="label.inservice" />
			<input type="radio" name="courseCategory" value="other"<%=isOptional?" checked":"" %>><bean:message key="label.optional" />
			<input type="radio" name="courseCategory" value="CNE"<%=isCNE?" checked":"" %>>CNE
<%			if(ConstantsServerSide.isTWAH()){ %>		
				<input type="radio" name="courseCategory" value="firedrill"<%=isFireDrill?" checked":"" %>>Fire and Disaster Drills
<%			} %>					
				<input type="radio" name="courseCategory" value="tND"<%=isTND?" checked":"" %>>T&D
<%			if(ConstantsServerSide.isHKAH()){ %>
				<input type="radio" name="courseCategory" value="intClass"<%=isIntClass?" checked":"" %>>Interest Class / Other Activities
				<input type="radio" name="courseCategory" value="mockCode"<%=isMockCode?" checked":"" %>>Mock Code
				<input type="radio" name="courseCategory" value="mockDrill"<%=isMockDrill?" checked":"" %>>Drill
<%			} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.courseType" /></td>
		<td class="infoData" width="70%">
			<input type="radio" name="courseType" value="class"<%=isClassRoom?" checked":"" %>><bean:message key='<%=ConstantsServerSide.isTWAH() ? "label.sitIn.twah" : "label.sitIn" %>' />
			<input type="radio" name="courseType" value="online"<%=isOnline?" checked":"" %>><bean:message key='<%=ConstantsServerSide.isTWAH() ? "label.onLine.twah" : "label.onLine" %>' />
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<bean:define id="functionLabel"><bean:message key="function.course.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="course.jsp" method="post">
<display:table id="row" name="requestScope.course_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" titleKey="prompt.courseDescription" style="width:35%" />
	<display:column titleKey="prompt.courseCategory" style="width:20%">
		<logic:equal name="row" property="fields4" value="compulsory">
			<bean:message key="label.compulsory" />
		</logic:equal>
		<logic:equal name="row" property="fields4" value="inservice">
			<bean:message key="label.inservice" />
		</logic:equal>
		<logic:equal name="row" property="fields4" value="other">
			<bean:message key="label.optional" />
		</logic:equal>
		<logic:equal name="row" property="fields4" value="mockCode">
			Mock Code
		</logic:equal>
		<logic:equal name="row" property="fields4" value="mockDrill">
			Drill
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.courseType" style="width:20%">
		<logic:equal name="row" property="fields5" value="class">
			<bean:message key='<%=ConstantsServerSide.isTWAH() ? "label.sitIn.twah" : "label.sitIn" %>' />
		</logic:equal>
		<logic:notEqual name="row" property="fields5" value="class">
			<bean:message key='<%=ConstantsServerSide.isTWAH() ? "label.onLine.twah" : "label.onLine" %>' />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key='button.view' /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.course.create" /></button></td>
	</tr>
</table>
</form>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.courseDesc.value = '';
	}

	function submitAction(cmd, cid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&courseID=" + cid);
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>