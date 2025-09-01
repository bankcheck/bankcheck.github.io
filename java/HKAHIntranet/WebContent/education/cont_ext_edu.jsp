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
	<c:redirect url="cont_ext_edu.htm" />
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
ul.level1 h4 { font-size: 140%; font-weight: bold; margin: 5px 0; }
ul.level2 { list-style: none;  margin-left: 20px; }
ul.level2 li { margin: 5px 0; }
ul.level3 { list-style: none;  margin: 0 10px 10px 20px; }  	
ul.level3 li { margin: 5px 0; }
</style>

<font color="blue"><c:out value="${education.message}"/></font>
<font color="red"><c:out value="${education.errorMessage}"/></font>
<form name="form1" method="post">
	<div id="staffEducationWrapper">
		<div id="contentPage">
			
			<div id="breadcrumb">
				<a href="reminder.jsp"><bean:message key="label.staffEducation" /></a> -> <c:out value="${education.eeMenuModule.eeDescriptionEn}" />
			</div>
			<h2><bean:message key="label.staffEducation" /></h2>
			<h3><c:out value="${education.eeMenuModule.eeDescriptionEn}" /></h3>
			<c:if test="${education.userBean.educationManager}">
				<button onclick="return submitAction('update', 0);"><bean:message key="prompt.staffEducationUpdate" /></button>
			</c:if>
			<ul class="level1" id="level1-list">
		<!--	Title level entries	 	-->
		<c:if test="${education.list != null}" >
			<c:forEach var="content" items="${education.list}">
				<li>
					<c:choose>
						<c:when test="${content.eeMenuDocument != null}">
							<c:choose>
								<c:when test="${content.eeMenuDocument.eeIsUrl eq 'Y'}" >
									<a href="<c:out value='${content.eeMenuDocument.eeUrl}' />" target="_blank">
										<h4>
											<c:out value="${content.eeDescriptionEn}" />
										</h4>
									</a>
								</c:when>
								<c:otherwise>
									<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content.id.eeMenuContentId}' />', '<c:out value='${content.eeMenuDocument.eeDocumentId}' />')">
										<h4>
											<c:out value="${content.eeDescriptionEn}" />
										</h4>
									</a>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<h4><c:out value="${content.eeDescriptionEn}" /></h4>
						</c:otherwise>
					</c:choose>
					
					<!--	2nd level entries	 	-->
					<c:if test="${content.childList != null}" > 
						<ul class="level2" id="level2-list_<c:out value='${content.id.eeMenuContentId}' />">
						<c:forEach var="content2" items="${content.childList}">
							<li id="level2-listItem_<c:out value='${content.id.eeMenuContentId}' />-<c:out value='${content2.id.eeMenuContentId}' />">
								<c:choose>
									<c:when test="${content2.eeMenuDocument != null}">
										<c:choose>
											<c:when test="${content2.eeMenuDocument.eeIsUrl eq 'Y'}" >
												<a href="<c:out value='${content2.eeMenuDocument.eeUrl}' />" target="_blank">
													<c:out value="${content2.eeDescriptionEn}" />
												</a>
											</c:when>
											<c:otherwise>
												<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content2.id.eeMenuContentId}' />', '<c:out value='${content2.eeMenuDocument.eeDocumentId}' />')">
													<c:out value="${content2.eeDescriptionEn}" />
												</a>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<c:out value="${content2.eeDescriptionEn}" />
									</c:otherwise>
								</c:choose>
								
								<!--	3rd level entries	 	-->
								<c:if test="${content2.childList != null}" > 
									<ul class="level3">
									<c:forEach var="content3" items="${content2.childList}">
										<li>
											<c:choose>
												<c:when test="${content3.eeMenuDocument != null}">
													<c:choose>
														<c:when test="${content3.eeMenuDocument.eeIsUrl eq 'Y'}" >
															<a href="<c:out value='${content3.eeMenuDocument.eeUrl}' />" target="_blank">
																<c:out value="${content3.eeDescriptionEn}" />
															</a>
														</c:when>
														<c:otherwise>
															<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content3.id.eeMenuContentId}' />', '<c:out value='${content3.eeMenuDocument.eeDocumentId}' />')">
																<c:out value="${content3.eeDescriptionEn}" />
															</a>
														</c:otherwise>
													</c:choose>
												</c:when>
												<c:otherwise>
													<c:out value="${content3.eeDescriptionEn}" />
												</c:otherwise>
											</c:choose>
										</li>
									</c:forEach>
									</ul>
								</c:if>
							</li>
						</c:forEach>
						</ul>
					</c:if>
				</li>
			</c:forEach>
		</c:if>
			</ul>
			<div class="nav-footer">
				<a href="#"><bean:message key="button.backToTop" /></a>
			</div>
		</div>
	</div>
	<input type="hidden" name="documentID" />
	<input type="hidden" name="moduleCode" value="<c:out value='${education.moduleCode}' />" />
	<input type="hidden" name="keyID" />
</form>
</div>
</div>
</div>
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