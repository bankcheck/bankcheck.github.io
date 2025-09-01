<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String category = "title.education";
String courseCategory = request.getParameter("courseCategory");
String courseType = null;
if (courseCategory == null) {
	courseCategory = (String) session.getAttribute("courseCategory");
	if (courseCategory == null) {
		courseCategory = "O";
	}
}
session.setAttribute("courseCategory", courseCategory);

String title = null;
if ("C".equals(courseCategory)) {
	// only show online when compulsory class
	courseType = "O";
	title = "prompt.compulsoryClass";
} else {
	title = "label.optional";
}

String courseGroup = request.getParameter("courseGroup");
request.setAttribute("class_enrollment_list", EnrollmentDB.getList(courseCategory, courseType, courseGroup));

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
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<table><!-- dummy --></table>
<bean:define id="functionLabel"><bean:message key="function.classEnrollment.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="class_enrollment.jsp" method="post">
<display:table id="row" name="requestScope.class_enrollment_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.department" style="width:20%">
		<logic:equal name="row" property="fields1" value="">
			<bean:message key="label.all" />
		</logic:equal>
		<logic:notEqual name="row" property="fields1" value="">
			<c:out value="${row.fields1}" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields3" titleKey="prompt.courseDescription" style="width:40%" />
	<display:column titleKey="prompt.type" style="width:10%">
		<logic:equal name="row" property="fields5" value="C">
			<bean:message key='<%=ConstantsServerSide.isTWAH() ? "label.sitIn.twah" : "label.sitIn" %>' />
		</logic:equal>
		<logic:notEqual name="row" property="fields5" value="C">
			<bean:message key='<%=ConstantsServerSide.isTWAH() ? "label.onLine.twah" : "label.onLine" %>' />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<logic:equal name="row" property="fields5" value="C">
			<button onclick="return submitAction('register', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields6}" />');"><bean:message key="button.register" /></button>
		</logic:equal>
		<logic:notEqual name="row" property="fields5" value="C">
			<button onclick="return submitAction('test', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields6}" />');"><bean:message key='<%=ConstantsServerSide.isTWAH() ? "button.test.twah" : "button.test" %>' /></button>
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="courseID">
<input type="hidden" name="elearningID">
<input type="hidden" name="courseGroup">
</form>
<script language="javascript">
	function deptDirectory(cg) {
		document.form1.action = "class_enrollment_list.jsp";
		document.form1.courseGroup.value = cg;
		document.form1.submit();
	}

	function submitAction(cmd, cid, eid) {
		if (cmd == 'register') {
			document.form1.action = "class_enrollment.jsp";
			document.form1.courseID.value = cid;
			document.form1.elearningID.value = eid;
			document.form1.submit();
		} else {
			document.form1.action = "elearning_test.jsp";
			callPopUpWindow(document.form1.action + "?command=&elearningID=" + eid);
			return false;
		}
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>