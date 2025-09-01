<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.struts.*"%>
<%
UserBean userBean = new UserBean(request);
String style = request.getParameter("style");
String language = request.getParameter("language");
Locale locale = Locale.US;
//20181009 Arran add new categories for informed consent Chinese and English
String category;

if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
	category = "informed consent CHT";
} else{
	locale = Locale.US;
	category = "informed consent ENG";
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
<body>
		<ul id="browser" class="filetree">
			<jsp:include page="../registration/important_information.jsp" flush="false" />
			<jsp:include page="../common/information_helper.jsp" flush="false">
				<jsp:param name="category" value="<%=category %>" />
				<jsp:param name="skipColumnTitle" value="Y" />
				<jsp:param name="mustLogin" value="N" />
				<jsp:param name="skipTreeview" value="Y" />
				<jsp:param name="oldTreeStyle" value="Y" />
			</jsp:include>
		</ul>
<% if ("popup".equals(style)) { %>
<table style="width:100%" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td align=center>
		<button onclick="closeBox();"><%=MessageResources.getMessage(locale, "label.returnAdmissionDate") %></button>
		</td>
	</tr>
</table>
<% } %>
<script language="javascript">
	function closeAction() {
		if (parent)
			parent.closeAction();
		else 
			window.close(); 
	}	
	
	function closeBox(){		
		parent.$.fancybox.close();	
		var focusField = parent.document.form1.expectedAdmissionDate;		
		$(focusField).focus();
	}
	
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>