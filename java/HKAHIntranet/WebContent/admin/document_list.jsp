<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
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

<!-- 
<c:if test="${document == null}">
	<c:redirect url="document_list.htm" />
</c:if>
-->

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<body>
		<DIV id=indexWrapper>
			<DIV id=mainFrame>
				<DIV id=contentFrame>
					
					<jsp:include page="../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="function.document.list" />
					</jsp:include>
					<c:set var="message" value="${document.message}" />
					<jsp:useBean id="message" class="java.lang.String" />
					<c:set var="errorMessage" value="${document.errorMessage}" />
					<jsp:useBean id="errorMessage" class="java.lang.String" />
					<jsp:include page="../common/message.jsp" flush="false">
						<jsp:param name="message" value="<%=message %>" />
						<jsp:param name="errorMessage" value="<%=errorMessage %>" />
					</jsp:include>
					<bean:define id="functionLabel"><bean:message key="function.haa.list" /></bean:define>
					<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
					<form name="search_form" action="document_list.htm" method="post"> 
						<table cellpadding="0" cellspacing="5"
							class="contentFrameSearch" border="0">
							<tr class="smallText">
								<td class="infoLabel" width="30%"><bean:message key="prompt.document.description" /></td>
								<td class="infoData" width="70%">
									<input type="text" name="documentDescSearch" id="documentDescSearch" value="<c:out value="${document.documentDescSearch}"/>" size="100" />
								</td>
							</tr>
							<tr class="smallText">
								<td class="infoLabel" width="30%"><bean:message key="prompt.document.name" />/<bean:message key="prompt.document.location" /></td>
								<td class="infoData" width="70%">
									<input type="text" name="documentNameLocSearch" id="documentNameLocSearch" value="<c:out value="${document.documentNameLocSearch}"/>" size="100" />
								</td>
							</tr>
							<tr class="smallText">
								<td colspan="2" align="center">
									<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
									<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
								</td>
							</tr>
						</table>
					</form>

					<bean:define id="functionLabel"><bean:message key="function.document.list" /></bean:define>
					<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
					
					<form name="form1" action="document_details.htm" method="post">
						<c:set var="pagesizeInt" value="${document.userBean.noOfRecPerPage}"/>
						<jsp:useBean id="pagesizeInt" type="java.lang.Integer"/>
						<display:table id="row" name="requestScope.document.list" export="true" 
								 pagesize="<%=pagesizeInt %>"
								 class="tablesorter" requestURI="document_list.htm">
							<display:column title="&nbsp;" media="html" style="width:5%"><c:out value="${row_rowNum}"/>)</display:column>
							<display:column property="coDescription" titleKey="prompt.document.description" style="width:35%"/>
							<display:column property="filePath" titleKey="prompt.document.location" style="width:50%"/>
							<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
								<button onclick="return submitAction('View', '<c:out value="${row.coDocumentId}" />');"><bean:message key='button.view' /></button>
							</display:column>
							<display:setProperty name="basic.msg.empty_list">
								<c:out value="${document.notFoundMsg}"/>
							</display:setProperty>
						</display:table>
						<table width="100%" border="0">
							<tr class="smallText">
								<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="prompt.documentUpload" /></button></td>
							</tr>
						</table>
						<input type="hidden" name="command" />
						<input type="hidden" name="documentID" />
					</form>
					<script language="javascript">
						function submitSearch() {
							document.search_form.submit();
						}
					
						function clearSearch() {
							document.forms["search_form"].elements["documentDescSearch"].value = "";
							document.forms["search_form"].elements["documentNameLocSearch"].value = "";
						}
					
						function submitAction(cmd, did) {
								callPopUpWindow("document_details.htm?command=" + cmd + "&documentID=" + did);
								return false;
						}
					</script>
				</DIV>
			</DIV>
		</DIV>
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>
