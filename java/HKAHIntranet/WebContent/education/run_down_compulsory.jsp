<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%
	UserBean userBean = new UserBean(request);

	String category = "title.education";
	String pageTitle = null;
	List elearning_list = ELearning.getCourse("compulsory", "class");
	if (ConstantsServerSide.isTWAH()) {
		pageTitle = "MANDATORY SIT-IN CLASSES FOR ALL STAFF";

		request.setAttribute("elearning_list", elearning_list);
	} else {
		pageTitle = "COMPULSORY CLASSES FOR ALL STAFF";
	}

	String message = request.getParameter("message");
	if (message == null) {
		message = "";
	}
	String errorMessage = "";
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<form name="form1" method="post">
<%
	if (ConstantsServerSide.isTWAH()) {
%>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
<%		if (elearning_list != null) {
			ReportableListObject reportableListObject = null;
			String eventID = null;
			String eventDesc = null;
			String eventShortDesc = null;
			for (Iterator itr = elearning_list.iterator() ; itr.hasNext();) {
				reportableListObject = (ReportableListObject) itr.next();
				eventID = reportableListObject.getValue(0);
				eventDesc = reportableListObject.getValue(1);
				eventShortDesc = reportableListObject.getValue(2);	%>
	<tr class="bigText">
		<td align="left"><b><span class="labelColor5"><%=eventDesc %></span></b></td>
		<td align="center"></td>
	</tr>
<%				if (itr.hasNext()) { %>
	<tr class="bigText">
		<td align="center" colspan="2"><hr></td>
	</tr>
<%				} %>
<%			} %>
<%		} %>
</table>
<%
	} else {
%>
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="bigText">
		<td align="left"><b><span class="labelColor1">CPR &amp; CODE BLUE WORKSHOP</span></b></td>
		<td align="center"><button onclick="return submitAction('1050');"><bean:message key="button.register" /></button></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="left"><span style="font-size: 14px; font-weight: bold; color: #FF0000;">*Please read the following documents before attending the class</span></td>
	</tr>
	<tr class="mediumText">
		<td align="left"><b><span class="labelColor2">Notes for In-house CPR class (For Clinical Staff)</span></b></td>
		<td align="center"><button onclick="return downloadFile('662');"><bean:message key="button.view" /></button></td> 
	</tr>
	<tr class="mediumText">
		<td align="left"><b><span class="labelColor3">Notes for In-house Layman CPR Class (Cantonese version) 心肺復甦法(民眾)講義</span></b></td>
		<td align="center"><button onclick="return downloadFile('692');"><bean:message key="button.view" /></button></td>
	</tr>
	<tr class="mediumText">
		<td align="left"><b><span class="labelColor4">Notes for In-house Layman CPR Class (English version)</span></b></td>
		<!-- <td align="center"><button onclick="return downloadFile('636');"><bean:message key="button.view" /></button></td> -->
	</tr>
</table>
<%
	}
%>
<input type="hidden" name="courseID" />
</form>
<script language="javascript">
<!--
	function submitAction(cid) {
		document.form1.action = "class_enrollment.jsp";
		document.form1.courseID.value = cid;
		document.form1.submit();
	}
-->
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>