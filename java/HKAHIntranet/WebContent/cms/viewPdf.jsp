<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.math.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%!
%>
<%	
	String filePath = ParserUtil.getParameter(request, "filePath");	
	if(filePath != null && filePath.length() > 0 && !"null".equals(filePath)){
		//String redirectPath = "../documentManage/download.jsp?locationPath="+filePath+"&dispositionType=inline&intranetPathYN=Y&#view=FitH";
		String redirectPath = "../documentManage/download.jsp?locationPath="+filePath+"&src=inapp&dispositionType=inline&intranetPathYN=Y&useSambaYN=Y&#view=FitH";	

		response.sendRedirect(redirectPath);
	}
%>
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
#contentFrame, #loading_spinner {
	height: 100%;
}
</style>
<body leftmargin='5' topmargin='5' marginleft='5' marginleft='5' bgcolor='#ffffff'>
<p class="title">Unable to find pdf, no filepath provided.</p>
<script language="JavaScript">

</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>