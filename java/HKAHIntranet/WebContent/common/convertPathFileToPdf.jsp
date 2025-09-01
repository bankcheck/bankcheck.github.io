<%@ page language="java"
%><%@ page import="java.io.*"
%><%@ page import="java.util.*"
%><%@ page import="java.net.*"
%><%@ page import="java.nio.*"
%><%@page import="java.nio.channels.*"
%><%@ page import="org.apache.commons.lang.StringUtils"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.upload.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ page import="org.apache.commons.io.FileUtils"
%><%@ page import="org.apache.commons.io.comparator.LastModifiedFileComparator"
%><%@ page import="com.hkah.convert.Converter"
%>
<%
UserBean userBean = new UserBean(request);

String type = TextUtil.parseStrUTF8(request.getParameter("type"));
String rootFolder = "";
String isTest = request.getParameter("isTest");
System.out.println(isTest);
if("policyTest".equals(isTest)){
	if ("deptPolicy".equals(type)) {
		rootFolder = ConstantsServerSide.POLICY_FOLDER + "\\departmental_test";
	} else {
		rootFolder = ConstantsServerSide.POLICY_FOLDER + "\\hospital-wide_test";			
	}
} else {
	if ("deptPolicy".equals(type)) {
		rootFolder = ConstantsServerSide.POLICY_FOLDER + "\\departmental";
	} else {
		rootFolder = ConstantsServerSide.POLICY_FOLDER + "\\hospital-wide";			
	}
}

Converter.convertAllPolicy2Pdf(rootFolder);
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>

.swf-display {margin:10px 20px;}
</style>  
<body >

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>