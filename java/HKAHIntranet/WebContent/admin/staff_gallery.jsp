<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
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

String deptCode = request.getParameter("deptCode");

ArrayList list = EmployeeVoteDB.getNomineeList(deptCode);;
request.setAttribute("list", list);

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
	<jsp:param name="pageTitle" value="Staff Gallery" />
	<jsp:param name="category" value="prompt.admin" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" id="search_form" action="staff_gallery.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Department</td>
		<td class="infoData" width="70%">
			<select name="deptCode">
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
			<jsp:param name="allowAll" value="Y" />
			<jsp:param name="category" value="nominee" />
			</jsp:include>
			</select>
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
<display:table id="row" name="requestScope.list" export="true" pagesize="100" class="tablesorter">
	<display:column property="fields2" title="Staff ID" />
	<display:column property="fields3" title="Staff Name" />
	<display:column title="Display Photo">
		<c:choose>
			<c:when test="${row.fields9 == 'N'}">
				<font color="red">No</font>
			</c:when>
			<c:otherwise>
				<font color="black">Yes</font>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="text-align:center">
		<img id="staffPhoto" src="../admin/staffPhoto.jsp?staffID=<c:out value="${row.fields2}" />" height="157" width="120" onerror="this.src='../images/Photo_not_available.jpg';"></img><br>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="No record"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<script language="javascript">

	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.inParam.value = "";
	}

</script>

</DIV>
</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>