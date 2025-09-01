<%
String source = request.getParameter("source");
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
<%@ page language="java" contentType="text/html; charset=big5" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<table width="800" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td rowspan="20" width="10%">&nbsp;</td>
	<td width="80%">&nbsp;</td>
	<td rowspan="20" width="10%">&nbsp;</td>
</tr>
<tr>
	<td align="center"><a href="online_enquiry.jsp?source=<%=source==null?"":source %>"><img src="landing_V1.jpg" border="0" /></a></td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
</body>
</html:html>