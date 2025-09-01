<%@ page import="com.hkah.constant.*"%>
<%
// reset page referer to avoid looping
session.setAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_REFERER, null);
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %><html>
<head>
<title>Access Denied</title>
<script language="javascript">
<!--
	alert("<bean:message key="error.access.deny" />!");
	if (window.parent.frames.length > 0) {
		parent.location.href = "../index.jsp";
	} else {
		window.history.go(-2);
		window.close();
	}
-->
</script>
</head>
<body>
</body>
</html>