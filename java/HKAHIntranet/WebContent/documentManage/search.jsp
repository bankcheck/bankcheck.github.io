<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String query = request.getParameter("query");

request.setAttribute("search_list", AccessControlDB.getInformationList(userBean, null, query));
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
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Results" />
	<jsp:param name="category" value="Search" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="mustLogin" value="N" />
</jsp:include>
<bean:define id="functionLabel"><bean:message key="prompt.document" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="apply.jsp" method="post">
<display:table id="row" name="requestScope.search_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.name" style="width:95%">
		<logic:equal name="row" property="fields2" value="PROGRAM">
			<img src="../images/sys.gif"><a href="<c:out value="${row.fields5}" />">
				<logic:equal name="row" property="fields3" value="">
					<c:out value="${row.fields4}" />
				</logic:equal>
				<logic:notEqual name="row" property="fields3" value="">
					<c:out value="${row.fields3}" />
				</logic:notEqual>
			</a>
		</logic:equal>
		<logic:notEqual name="row" property="fields2" value="PROGRAM">
			<logic:equal name="row" property="fields7" value="">
				<img src="../images/file.gif"><a href="<c:out value="${row.fields8}" />"><c:out value="${row.fields3}" /></a>
			</logic:equal>
			<logic:notEqual name="row" property="fields7" value="">
				<img src="../images/file.gif"><a href="javascript:void(0);" onclick="return downloadFile('<c:out value="${row.fields7}" />', '');"><c:out value="${row.fields3}" /></a>
			</logic:notEqual>
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</form>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>