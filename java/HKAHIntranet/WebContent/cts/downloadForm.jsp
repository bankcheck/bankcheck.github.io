<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.search.*" %>
<%@ page import="org.apache.lucene.document.Document"%>
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
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
<tr>
	<td>
		<h2>
			<b class="b1_2"></b><b class="b2_2"></b><b class="b3_2%>"></b><b class="b4_2"></b>
			<div class="contentb_2">
				<span class="pageTitle bigText"><bean:message key="function.cts.download" /></span>
			</div>
			<b class="b4_2"></b><b class="b3_2"></b><b class="b2_2"></b><b class="b1_2"></b>
		</h2>
	</td>
</tr>
<table cellpadding="0" cellspacing="0" border="0">
	<tr class="bigText">
		<td align="right">&nbsp;</td>
		<td><a href="/upload/CTS/download/Signature and MPS Pre-Authorization Form (Combined 20131010).pdf"><H1 id="TS">MPS Pre-Authorization Release Form</H1></a></td>
		<td align="left"></td>
	</tr>
</table>
</div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>