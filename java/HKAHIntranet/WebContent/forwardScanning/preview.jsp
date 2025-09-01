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
private boolean isLoadImageInHtml(String pathname) {
	if (pathname == null) {
		return false;
	}
	
	String patternStr = "(\\.jpg|\\.jpeg|\\.gif|\\.png)$";
	Pattern pattern = Pattern.compile(patternStr);
    Matcher matcher = pattern.matcher(pathname);
    return matcher.find();
}

private boolean isLoadImageInQT(String pathname) {
	if (pathname == null) {
		return false;
	}
	
	String patternStr = "(\\.tif|\\.tiff)$";
	Pattern pattern = Pattern.compile(patternStr);
    Matcher matcher = pattern.matcher(pathname);
    return matcher.find();
}

private boolean isLoadInBinary(String pathname) {
	if (pathname == null) {
		return false;
	}
	
	String patternStr = "(\\.pdf|\\.doc|\\.docx|\\.xls|\\.xlsx)$";
	Pattern pattern = Pattern.compile(patternStr);
    Matcher matcher = pattern.matcher(pathname);
    return matcher.find();
}

private boolean isLoadImageInFlash(String pathname) {
	return false;
}
%>
<%
	UserBean userBean = new UserBean(request);
	//if (!userBean.isAccessible("function.fs"))
	//	return;

	String step = ParserUtil.getParameter(request, "step");
	String coDocscanID = ParserUtil.getParameter(request, "coDocscanID");
	String documentID = ParserUtil.getParameter(request, "documentID");
	String filePath = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "filePath"));
	
	String directory = null;
	String desc = null;
	
	boolean goToStep1 = false;
	
	if (filePath != null && !"".equals(filePath)) {
		if ("1".equals(step)) {
			String redirectPath = "../documentManage/download.jsp?locationPath=" + URLEncoder.encode(filePath, "UTF-8")+ "&dispositionType=inline&intranetPathYN=Y&src=inapp";
			response.sendRedirect(redirectPath);
		} else {
			goToStep1 = true;
		}
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
<DIV id=indexWrapper style="border: 2px solid #808080;">
	<DIV id=mainFrame>
		<DIV id="contentFrame">
		<% if (goToStep1) { %>
			<p class="loading">Loading<img src="../images/wait30trans.gif"></p>
			<div id="loading_spinner" >
			</div>
		<% } else { %>
			<!-- <p class="title">Click the document name in the left side to preview.</p> -->
		<% } %>
		</DIV>
	</DIV>
</DIV>
<script language="JavaScript">
<!--
<% 	if (isLoadImageInQT(desc)) { %>
	$().ready(function(){
		embedQuickTime('<%=desc %>');
	});

	function embedQuickTime(filename)
	{
		document.write('<OBJECT CLASSID="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" WIDTH="1000px" height="1500px" CODEBASE="http://www.apple.com/qtactivex/qtplugin.cab">');
		document.write('<PARAM name="SRC" VALUE="' + filename + '">');
		document.write('<PARAM name="CONTROLLER" VALUE="true">');
		document.write('<PARAM name="SCALE" VALUE="0.75">');
		document.write('<PARAM name="bgcolor" VALUE="#808080">');
		document.write('</object>');
	}
<%	} %>
<%	if (isLoadImageInHtml(desc)) { 

%>
	$().ready(function(){
		$("#contentFrame").html("<img id='theImg' src='<%=directory %>/<%=desc %>'/>");
	});
<%	} %>

	function download() {
		var uri = 'preview.jsp' + document.location.search + '&step=1';
		window.location = uri;
	}
	
<% if (goToStep1) { %>
	var target = document.getElementById('loading_spinner');
	var spinner = new Spinner().spin(target);
	//showLoadingBox('body', 500, $(window).scrollTop());
	download();
<% } %>
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>