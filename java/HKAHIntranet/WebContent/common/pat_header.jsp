<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%
// set default locale
MessageResources.getMessage(session, "prompt.loginPage");

UserBean userBean = new UserBean(request);
String pageCategory = request.getParameter("category");
String mode = request.getParameter("mode");
String viewMode = request.getParameter("viewMode");
String a_patno = ParserUtil.getParameter(request, "patno");
String patSex = ParserUtil.getParameter(request, "patSex");
String patIdNo = ParserUtil.getParameter(request, "patIdNo");
String patName = ParserUtil.getParameter(request, "patName");
String patcName = ParserUtil.getParameter(request, "patcName");
String patage = ParserUtil.getParameter(request, "patage");
String patPager = ParserUtil.getParameter(request, "patPager");
String pathTel = ParserUtil.getParameter(request, "pathTel");
String patEmail = ParserUtil.getParameter(request, "patEmail");
String patReli = ParserUtil.getParameter(request, "patReli");

boolean noRecord = true;
String userInfo = null;
String patno = null;
String pageTitle = "Patient Information";
if (viewMode != null && !viewMode.trim().isEmpty() && !"null".equalsIgnoreCase(viewMode) && !"live".equalsIgnoreCase(viewMode)) {
	pageTitle += " (MODE: " + viewMode + ")";
}

try {
	if (a_patno != null) {
		ArrayList record = PatientDB.getPatInfo(a_patno);
		
		if (record.size() > 0) {
			noRecord = false;
			ReportableListObject row = (ReportableListObject) record.get(0);
			patno = row.getValue(0);
			patSex = row.getValue(1);
			patIdNo = row.getValue(2);
			patName = row.getValue(3);
			patcName = row.getValue(4);
			patage = row.getValue(5);
			patPager = row.getValue(6);
			pathTel = row.getValue(7);
			patEmail = row.getValue(8);
			patReli = row.getValue(9);
		}
	}
 	
} catch (Exception e) {
	
}
%>
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>
#contentFrame {
	width: 90%;
}
td.infoLabel {
	width: 100px;
}
td.infoData {
	width: 200px;
}
</style>
<body>
	<div id=indexWrapper>
		<div id=mainFrame>
			<div id=contentFrame>
<jsp:include page="../common/page_title.jsp">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="pageMap" value="N" />
	<jsp:param name="isAccessControl" value="N" />
	<jsp:param name="mustLogin" value="N" />
</jsp:include>
<% if (noRecord) { %>
<% String notFoundMsg = "No record for patient no: " + a_patno; %>
<bean:message key="message.notFound" arg0="<%=notFoundMsg %>" />
<% } else { %>
<table cellpadding="0" cellspacing="5" width="100%">
	<tr class="smallText">
		<td class="infoLabel">Patient No.</td>
		<td class="infoData">
			<!-- <input type="text" name="patno" size="10" value="<%=patno == null ? "" : patno %>" style="font-weight: bold" /> -->
			<%=patno == null ? "" : patno %>
		</td>
		<td class="infoLabel">Name</td>
		<td class="infoData" colspan="3">
			<!-- <input type="text" name="patName" size="30" value="<%=patName == null ? "" : patName %>" /> -->
			<%=patName == null ? "" : patName %>
		</td>
		<td class="infoLabel">Chinese Name</td>
		<td class="infoData">
			<!-- <input type="text" name="patcName" size="30" value="<%=patcName == null ? "" : patcName %>" /> -->
			<%=patcName == null ? "" : patcName %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel">Gender</td>
		<td class="infoData">
			<!-- <input type="text" name="patSex" size="10" value="<%=patSex == null ? "" : patSex %>" /> -->
			<%=patSex == null ? "" : patSex %>
		</td>
		<td class="infoLabel">Age</td>
		<td class="infoData">
			<!-- <input type="text" name="patage" size="30" value="<%=patage == null ? "" : patage %>" /> -->
			<%=patage == null ? "" : patage %>
		</td>
		<td class="infoLabel">ID No</td>
		<td class="infoData">
			<!-- <input type="text" name="patIdNo" size="30" value="<%=patIdNo == null ? "" : patIdNo %>" /> -->
			<%=patIdNo == null ? "" : patIdNo %>
		</td>
		<td class="infoLabel">Religion</td>
		<td class="infoData">
			<!-- <input type="text" name=patReli size="30" value="<%=patReli == null ? "" : patReli %>" /> -->
			<%=patReli == null ? "" : patReli %>
		</td>
	</tr>
</table>
<% } %>
<% /* %>
<!-- 
<form name="search_form" action="pat_header.jsp?category=<%=pageCategory %>">
	<table cellpadding="0" cellspacing="0" class="contentFrameSearch" border="0">
		<tr class="smallText">
			<td colspan="2" align="right">
				Patient No: <input type="text" name="patno" size="30" />
				<button onclick="return submitSearch();">Search</button>
			</td>
		</tr>
	</table>
</form>
-->
<% */ %>
			</div>
		</div>
	</div>
</body>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}
</script>
</html:html>