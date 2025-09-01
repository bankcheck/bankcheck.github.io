<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
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
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>

<c:if test="${education == null}">
	<c:redirect url="mand_inserv_info.htm" />
</c:if>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>
<c:set var="pageTitle" value="${education.eeMenuModule.eeDescriptionEn}" />
<jsp:useBean id="pageTitle" class="java.lang.String" />
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="keepReferer" value="Y" />
</jsp:include>
<style>
#contentPage ol { list-style: decimal inside; margin: 10px 0; }
#contentPage ol li { margin: 5px 0; }
</style>

<font color="blue"><c:out value="${education.message}"/></font>
<font color="red"><c:out value="${education.errorMessage}"/></font>
<form name="form1" method="post">
	<div id="staffEducationWrapper">
		<div id="contentPage">
			<div id="breadcrumb">
				<a href="reminder.jsp"><bean:message key="label.staffEducation" /></a> -> <bean:message key="function.staffEducation.education.is_info" />
			</div>
			<h2><bean:message key="label.staffEducation" /></h2>
			<h3><bean:message key="function.staffEducation.education.is_info" /></h3>
			<c:if test="${education.userBean.educationManager}">
				<button onclick="return submitAction('update', 0);"><bean:message key="prompt.staffEducationUpdate" /></button>
			</c:if>
			<ol>
		<c:if test="${education.list != null}" > 
			<c:forEach var="content" items="${education.list}">
				<li>
				<c:choose>
					<c:when test="${content.eeMenuDocument != null}">
						<span style="width: 300px">							
							<c:choose>
								<c:when test="${content.eeMenuDocument.eeIsUrl eq 'Y'}" >
									<a href="<c:out value='${content.eeMenuDocument.eeUrl}' />" target="_blank">
										<c:out value="${content.eeDescriptionEn}" />
									</a>
								</c:when>
								<c:otherwise>
									<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content.id.eeMenuContentId}' />', '<c:out value='${content.eeMenuDocument.eeDocumentId}' />')">
										<c:out value="${content.eeDescriptionEn}" />
									</a>
								</c:otherwise>
							</c:choose>
						</span>
						<span>
							<c:choose>
								<c:when test="${content.eeMenuDocument.eeIsUrl eq 'Y'}" >
									<a href="<c:out value='${content.eeMenuDocument.eeUrl}' />" target="_blank">
										<c:out value="${content.eeDescriptionZh}" />
									</a>
								</c:when>
								<c:otherwise>
									<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content.id.eeMenuContentId}' />', '<c:out value='${content.eeMenuDocument.eeDocumentId}' />')">
										<c:out value="${content.eeDescriptionZh}" />
									</a>
								</c:otherwise>
							</c:choose>
						</span>
					</c:when>
					<c:otherwise>
						<span style="width: 300px"><c:out value="${content.eeDescriptionEn}" /></span>
						<span><c:out value="${content.eeDescriptionZh}" /></span>
					</c:otherwise>
				</c:choose>
				</li>
			</c:forEach>
		</c:if>
			</ol>
			<div class="nav-footer">
				<a href="#"><bean:message key="button.backToTop" /></a>
			</div>
		</div>
	</div>
	<input type="hidden" name="documentID" />
	<input type="hidden" name="moduleCode" value="<c:out value='${education.moduleCode}' />" />
	<input type="hidden" name="keyID" />
</form>
</DIV>

</DIV></DIV>
<script language="javascript">
<!--
	function downloadDocument(keyID, documentID) {
		document.forms["form1"].action = "../documentManage/download.jsp";
		document.forms["form1"].elements["keyID"].value = keyID;
		document.forms["form1"].elements["documentID"].value = documentID;
		document.forms["form1"].submit();
		return false;
	}
	
	function submitAction(cmd, level) {
		var moduleCode = document.forms["form1"].elements["moduleCode"].value;
		callPopUpWindow("menu_list.htm?moduleCode=" + moduleCode + "&command=" + cmd + "&level=" + level);
		return false;
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>