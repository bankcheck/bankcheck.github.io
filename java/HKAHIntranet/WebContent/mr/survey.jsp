<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%
String action = request.getParameter("act");
String reportID = "";

if(action == null) action = "new";

if(action.equals("view") || action.equals("edit")) {
	reportID = request.getParameter("reportID");
}

String prefix = "function.mr.survey.";
String pageTitle = prefix+action;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
	Licensed to the Apache Software Foundation (ASF) under one or more
	contributor license agreements.  See the NOTICE file distributed with
	this work for additional information regarding copyright ownership.
	The ASF liCensus this file to You under the Apache License, Version 2.0
	(the "License"); you may not use this file except in compliance with
	the License.  You may obtain a copy of the License at

		 http://www.apache.org/liCensus/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/template.css" />"/>
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="<%=pageTitle %>" />
		<jsp:param name="keepReferer" value="Y" />
		<jsp:param name="accessControl" value="Y"/>
		<jsp:param name="isHideTitle" value="Y"/>
	</jsp:include>

	<body>
		<jsp:include page="../common/banner2.jsp" />
		<DIV id=indexWrapper>
			<DIV id=mainFrame>
				<DIV id=Frame>
					<jsp:include page="../template/template.jsp" flush="false">
						<jsp:param name="templateID" value="1" />
						<jsp:param name="action" value="<%=action %>" />
						<jsp:param name="reportID" value="<%=reportID %>" />
						<jsp:param name="accessFunction" value="<%=prefix %>" />
					</jsp:include>
				</DIV>
			</DIV>
		</DIV>
	</body>
	<script type="text/javascript">
		var template_view_url = "../mr/survey.jsp?act=view";
		var template_edit_url = "../mr/survey.jsp?act=edit";
	</script>
	<script type="text/javascript" src="<html:rewrite page="/js/template.js" />"></script>
</html:html>
