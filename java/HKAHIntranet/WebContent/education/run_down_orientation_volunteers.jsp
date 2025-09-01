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
	<jsp:param name="pageTitle" value="ORIENTATION PROGRAM FOR VOLUNTEERS" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<table><!-- dummy --></table>
<%if (!ConstantsServerSide.isTWAH()) { %>
<form name="form1" action="../documentManage/download.jsp" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="bigText">
		<td align="center" colspan="2"><b><span class="labelColor7">TOPICS</span></b></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2">&nbsp;</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2">&nbsp;</td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor1">INTRODUCTION FOR VOLUNTEERS SERVICE</span></b></td>
		<td align="center"><button onclick="return downloadFile('17');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor2">SHARE FOR VOLUNTEERS SERVICE</span></td>
		<td align="center"><button onclick="return downloadFile('18');"><bean:message key="button.view" /></button>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
<%if (ConstantsServerSide.isHKAH()) { %>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor5">INFECTION CONTROL FOR VOLUNTEERS SERVICE</span></b></td>
		<td align="center">
			<button onclick="return downloadFile('19');"><bean:message key="button.view" /> (ENG)</button>
			<button onclick="return downloadFile('548');"><bean:message key="button.view" /> (中文)</button>
		</td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
<%} else if (ConstantsServerSide.isTWAH()) { %>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor3">INFECTION CONTROL FOR VOLUNTEERS SERVICE</span></b></td>
		<td align="center"><button onclick="return downloadFile('19');"><bean:message key="button.view" /></button>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
<%} %>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor4">OCCUPATIONAL SAFETY &amp; HEALTH FOR VOLUNTEERS SERVICE</span></b></td>
		<td align="center"><button onclick="return downloadFile('20');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor5">FIRE SAFETY FOR VOLUNTEERS SERVICE</span></b></td>
		<td align="center"><button onclick="return downloadFile('21');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor6"><bean:message key="prompt.eLesson" /></span></b></td>
		<td align="center"><button onclick="return submitAction('12');"><bean:message key='<%=ConstantsServerSide.isTWAH() ? "button.test.twah" : "button.test" %>' /></button></td>
	</tr>
</table>
</form>
<% } else if (ConstantsServerSide.isTWAH()) { %>
<form name="form1" action="../documentManage/download.jsp" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="bigText">
		<td align="left"><b><span class="labelColor2">VOLUNTEERS INFORMATION</span></td>
		<td align="center"><button onclick="return downloadFile('487');"><bean:message key="button.view" /></button>
		</td>
	</tr>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor3">OSH Leaflet</span></td>
		<td align="center"><button onclick="return downloadFile('709');"><bean:message key="button.view" /></button>
		</td>
	</tr>
	</table>
</form>
<% } %>


<script language="javascript">
	function submitAction(eid) {
		callPopUpWindow("elearning_test.jsp?command=&elearningID=" + eid);
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>