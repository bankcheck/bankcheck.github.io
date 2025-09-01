<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%
UserBean userBean = new UserBean(request);

String category = "title.education";
String[] eventTypes = null;
if (ConstantsServerSide.isTWAH()) {
	eventTypes = new String[]{"online", "class"};
} else {
	eventTypes = new String[]{};
}
request.setAttribute("elearning_list", ELearning.getList(eventTypes));

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.eLesson.list" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<table><!-- dummy --></table>
<bean:define id="functionLabel"><bean:message key="function.eLesson.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="elearning.jsp" method="post">
<display:table id="row" name="requestScope.elearning_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" titleKey="prompt.topic" style="width:45%" />
	<display:column titleKey="prompt.category" style="width:25%">
		<logic:equal name="row" property="fields5" value="compulsory">
<%
	if (ConstantsServerSide.isTWAH()) {
%>
			<bean:message key="prompt.mandatoryClass" />
<%
	} else {
%>
			<bean:message key="prompt.compulsoryClass" />
<%
	}
%>
		</logic:equal>
		<logic:equal name="row" property="fields5" value="inservice">
			<bean:message key="label.inservice" />
		</logic:equal>
		<logic:equal name="row" property="fields5" value="ce">
			<bean:message key="label.continuousEducation" />
		</logic:equal>
		<logic:equal name="row" property="fields5" value="other">
			<bean:message key="label.others" />
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.eventType" style="width:15%">
		<logic:equal name="row" property="fields6" value="online">
			<bean:message key='<%=ConstantsServerSide.isTWAH() ? "label.onLine.twah" : "label.onLine" %>' />
		</logic:equal>
		<logic:equal name="row" property="fields6" value="class">
			<bean:message key='<%=ConstantsServerSide.isTWAH() ? "label.sitIn.twah" : "label.sitIn" %>' />
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key='button.view' /></button>
<%if (userBean.isEducationManager()) { %>
		<button onclick="return submitAction('result', '<c:out value="${row.fields0}" />');"><bean:message key='prompt.eLessonResult' /></button>
<%} %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.eLesson.create" /></button></td>
	</tr>
</table>
<input type="hidden" name="elearningID"/>
</form>
<script language="javascript">
	function submitAction(cmd, eid) {
		if (cmd == 'result') {
			document.form1.action = "elearning_result_list.jsp";
			document.form1.elearningID.value = eid;
			document.form1.submit();
		} else {
			if (cmd == 'test') {
				document.form1.action = "elearning_test.jsp";
				cmd = "";
			} else {
				document.form1.action = "elearning.jsp";
			}
			callPopUpWindow(document.form1.action + "?command=" + cmd + "&elearningID=" + eid);
			return false;
		}
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>