<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%
	UserBean userBean = new UserBean(request);

	String category = "title.education";
	String pageTitle = null;
	pageTitle = "Revised Compulsory Classes for Employees";

	String message = request.getParameter("message");
	if (message == null) {
		message = "";
	}
	String errorMessage = "";
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<form name="form1" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">	
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>	
	<tr class="mediumText">
		<td align="left"><b><span class="labelColor3">Compulsory Classes for Employees of Hong Kong Adventist Hospital − Stubbs Road</span></b></td>
		<td align="center"><button onclick="return downloadFile('637');"><bean:message key="button.view" /></button></td>
	</tr>	
</table>
<input type="hidden" name="courseID" />
</form>
<script language="javascript">
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>