<%@ page import="com.hkah.constant.*"%>
<%
String category = "title.education";
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
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="RUN-DOWN FOR ORIENTATION PROGRAM FOR AGENCY NURSES & HCA" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<%if (!ConstantsServerSide.isTWAH()) { %>
<form name="search_form" action="class_enrollment.jsp" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="bigText">
		<td align="right" width="20%"><b>1. </b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor1">Introduce the ward environment</span>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>2. </b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor2">Prevention of fire hazard.</span>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>3. </b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor3">Infection control and prevention</span>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>4. </b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%"><b>Patient safety</b></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="right" width="20%"><b>5. </b></td>
		<td align="right" width="10%">&nbsp;</td>
		<td align="left" width="70%">
			<span class="labelColor4">Competence Test</span>
		</td> 
	</tr>
	<tr class="bigText">
		<td align="center" colspan="3"><button type="button" onclick="return downloadFile('588');">Download Package Material</button></td>
	</tr>
</table>
</form>
<%} %>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>