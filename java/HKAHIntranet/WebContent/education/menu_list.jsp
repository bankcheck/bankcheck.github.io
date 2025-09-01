<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*" %>
<%@ page import="com.hkah.web.db.hibernate.*" %>
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
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/displaytag.css" />" />

<c:if test="${education == null}">
	<c:redirect url="menu_list.htm" />
</c:if>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<style>
		.dragClass { color: #ff0000; }
	</style>
	<body>
		<DIV id=indexWrapper>
			<DIV id=mainFrame>
				<DIV id=contentFrame>
					<c:set var="pageSubTitle" value="function.staffEducation.${education.moduleCode}" scope="request" />
					<jsp:include page="../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="function.staffEducation" />
						<jsp:param name="pageSubTitle" value='<%=request.getAttribute("pageSubTitle") %>' />
					</jsp:include>
					<c:set var="message" value="${education.message}" />
					<jsp:useBean id="message" class="java.lang.String" />
					<c:set var="errorMessage" value="${education.errorMessage}" />
					<jsp:useBean id="errorMessage" class="java.lang.String" />
					<jsp:include page="../common/message.jsp" flush="false">
						<jsp:param name="message" value="<%=message %>" />
						<jsp:param name="errorMessage" value="<%=errorMessage %>" />
					</jsp:include>
					<form name="search_form" action="menu_list.htm" method="post"> 
						<table cellpadding="0" cellspacing="0"
							class="contentFrameSearch" border="0">
							<tr class="smallText">
								<td colspan="2" align="center">
									<c:if test="${education.level ne 0}">
										<button onclick="return submitSearch('back');"><bean:message key="button.back" /></button>
									</c:if>
									<button onclick="return submitSearch('search');"><bean:message key="button.search" /></button>
								</td>
							</tr>
						</table>
						<input type="hidden" name="moduleCode" value="<c:out value='${education.moduleCode}' />" />
						<input type="hidden" name="cid" value="<c:out value='${education.parentCid}' />" />
						<input type="hidden" name="grandCid" value="<c:out value='${education.grandCid}' />" />
						<input type="hidden" name="level" value="<c:out value='${education.level}' />" />
					</form>
					
					<ul id="breadcrumb-menuContent">
						<c:if test="${empty education.ancestors}" >
								<a href="#" onclick="return submitAction('view', 'null', '<c:out value='${rowCounter.count}' />')">
								<c:out value="${education.eeMenuModule.eeDescriptionEn}" />
							</a>
						</c:if>
						<li class="level0 <c:out value='${level0Class}' />">
							<a href="#" onclick="return submitAction('view', 'null', '<c:out value='${rowCounter.count}' />')">
								<c:out value="${education.eeMenuModule.eeDescriptionEn}" />
							</a>
						</li>
					<c:forEach var="row" items="${education.ancestors}" varStatus="rowCounter">
						<c:set var="listClass" value="level${rowCounter.count}"/>
						<c:if test="${rowCounter.last}" >
									 <a href="#" onclick="return submitAction('view', 'null', '<c:out value='${rowCounter.count}' />')">
								<c:out value="${education.eeMenuModule.eeDescriptionEn}" />
							</a>
						</c:if>
						<li class="<c:out value='${listClass}' /> <c:out value='${listClass2}' />">
							<a href="#" onclick="return submitAction('view', '<c:out value='${row.id.eeMenuContentId}' />', '<c:out value='${rowCounter.count}' />')">
							<%
								/*
									support special handling for different module: 
									- In-service Education Review
								*/
							%> 
							<c:choose>
								<c:when test="${education.level eq 1}">
									<c:out value='${row.eeMenuContentInservReview.eeCategoryCode}' />&nbsp;
									<c:out value='${row.eeMenuContentInservReview.eeCategoryDescriptionEn}' />
								</c:when>
								<c:otherwise>
									<c:out value='${row.eeDescriptionEn}' />
								</c:otherwise>
							</c:choose>
							</a>
						</li>
					</c:forEach>
					</ul>

					<bean:define id="functionLabel"><bean:message key="function.document.list" /></bean:define>
					<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
					
					<c:set var="moduleCode" value="${education.moduleCode}" />
					<jsp:useBean id="moduleCode" class="java.lang.String" />
					<c:set var="level" value="${education.level}" />
					<jsp:useBean id="level" class="java.lang.String" />
					
					<form name="form1" action="menu_details.htm" method="post">
						<c:set var="pagesizeInt" value="${education.userBean.noOfRecPerPage}"/>
						
						<%
							/*
								Support special handling for different module: 
								- Mandatory In-service Education: Content
							*/
						%> 
						<c:choose>
						<c:when test="${education.isModuleCodeIsContent && (education.level eq 0 || education.level eq 1)}">
							<table id="row">
								<thead>
									<tr>
										<th><bean:message key="prompt.displayOrder" /></th>
										<th><bean:message key="prompt.type" /></th>
										<th><bean:message key="prompt.description" /></th>
										<th><bean:message key="prompt.action" /></th>
									</tr>
								</thead>
								<tbody>
								<c:forEach var="row" items="${education.list}" varStatus="rowCounter">
									<c:choose>
										<c:when test="${rowCounter.count % 2 == 0}">
											<c:set var="trClass" value="even" />
										</c:when>
										<c:otherwise>
											<c:set var="trClass" value="odd" />
										</c:otherwise>
									</c:choose>
							
									<tr id="<c:out value='${row.id.eeMenuContentId}' />" class="<c:out value='${trClass}' />">
										<td style="width:5%" class="dragHandler">
											<c:out value="${rowCounter.count}" />
										</td>
										<td style="width:5%" class="dragHandler">
											<%=StaffEducationModelHelper.getEeTypes(moduleCode, level).get(((EeMenuContent)pageContext.getAttribute("row")).getEeType()) %>
										</td>
										<td>
											<a href="#" onclick="return submitAction('view', '<c:out value='${row.id.eeMenuContentId}' />')"><c:out value="${row.eeDescriptionEn}" /></a>
										</td>
										<td style="width:10%; text-align:center">
											<button onclick="return submitAction('viewDetails', '<c:out value='${row.id.eeMenuContentId}' />');"><bean:message key='button.view' /></button>
										</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
							
						</c:when>
						<c:otherwise>
						
							<table id="row">
								<thead>
									<tr>
										<th><bean:message key="prompt.displayOrder" /></th>
								<%
									/*
										support special handling for different module: 
										- In-service Education Review
									*/
								%> 
								<c:choose>
								
									<c:when test="${education.isModule_IsReview && (education.level eq 0)}">
										<th><bean:message key="prompt.categoryCode" /></th>
										<th><bean:message key="prompt.categoryName" /></th>
									</c:when>
									<c:otherwise>
										<th><bean:message key="prompt.description" /></th>
									</c:otherwise>
								</c:choose>
										<th><bean:message key="prompt.action" /></th>
									</tr>
								</thead>
								<tbody>
								<c:forEach var="row" items="${education.list}" varStatus="rowCounter">
									<c:choose>
										<c:when test="${rowCounter.count % 2 == 0}">
											<c:set var="trClass" value="even" />
										</c:when>
										<c:otherwise>
											<c:set var="trClass" value="odd" />
										</c:otherwise>
									</c:choose>
								
									<tr id="<c:out value='${row.id.eeMenuContentId}' />" class="<c:out value='${trClass}' />">
										<td style="width:5%" class="dragHandler">
											<c:out value="${rowCounter.count}" />
										</td>
										
										<%
											/*
												support special handling for different module: 
												- In-service Education Review
											*/
										%> 
								<c:choose>
									<c:when test="${education.isModule_IsReview && (education.level eq 0)}">
										<td style="width: 10%">
											<a href="#" onclick="return submitAction('view', '<c:out value='${row.id.eeMenuContentId}' />')"><c:out value="${row.eeMenuContentInservReview.eeCategoryCode}" /></a>
										</td>
										<td>
											<a href="#" onclick="return submitAction('view', '<c:out value='${row.id.eeMenuContentId}' />')"><c:out value="${row.eeMenuContentInservReview.eeCategoryDescriptionEn}" /></a>													
										</td>
									</c:when>
									<c:otherwise>
										<td>
											<a href="#" onclick="return submitAction('view', '<c:out value='${row.id.eeMenuContentId}' />')"><c:out value="${row.eeDescriptionEn}" /></a>
										</td>
									</c:otherwise>
								</c:choose>
										<td style="width:10%; text-align:center">

											<button onclick="return submitAction('viewDetails', '<c:out value='${row.id.eeMenuContentId}' />');"><bean:message key='button.view' /></button>

										</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
							</c:otherwise>
						</c:choose>
						
						<table width="100%" border="0">
							<tr class="smallText">
								<td colspan="2" align="center">
									<button onclick="return submitAction('create');"><bean:message key="function.title.create" /></button>
									<c:if test="${!empty education.list}">
										<button onclick="return submitAction('updateSortOrder');"><bean:message key="function.UpdateDisplayOrder" /></button>
									</c:if>
								</td>
							</tr>
						</table>
						<input type="hidden" name="moduleCode" value="<c:out value='${education.moduleCode}' />" />
						<input type="hidden" name="cmd" />
						<input type="hidden" name="step" />
						<input type="hidden" name="cid" />
						<input type="hidden" name="parentCid" value="<c:out value='${education.parentCid}' />" />
						<input type="hidden" name="level" value="<c:out value='${education.level}' />" />
						<input type="hidden" name="order" />
					</form>
					<script type="text/javascript" src="<html:rewrite page="/js/jquery.tablednd_0_5.js" />" /></script>
					<script language="javascript">
						$(document).ready(function()	 {
						    $("#row").tableDnD({
					            onDrop: function(table, row) {
					            	var order = $.tableDnD.serialize();
					            	document.forms['form1'].elements['order'].value = order;
						        },
						        onDragStart: function(table, row) {
					            	$(row).parent().css('background-color', '#ecfbff');
						        },
						        onDrop: function(table, row) {
						        	$(row).css('background-color', '#96e8ff');
						        }, 
						        dragHandle: "dragHandler"
						    });
						});
					
						function submitSearch(cmd) {
							if (cmd == 'back') {
								// var levelElem = document.forms['search_form'].elements['level'];
								// levelElem.value = parseInt(levelElem.value) - 1;
								document.forms['search_form'].elements['cid'].value = '<c:out value="${education.grandCid}" />';
							}
							document.forms['search_form'].submit();
						}
					
						function clearSearch() {
						}
					
						function submitAction(cmd, cid, level) {
							var action = "menu_list.htm";
							
							if (cmd == 'create' || cmd == 'update' || cmd == 'viewDetails') {
								var moduleCode = document.forms['form1'].elements['moduleCode'].value;
								var parentCid = document.forms['form1'].elements['parentCid'].value;
								var level = document.forms['form1'].elements['level'].value;
								callPopUpWindow("menu_details.htm?command=" + cmd + "&moduleCode=" + moduleCode + "&cid=" + cid + "&parentCid=" + parentCid +"&level=" + level);
								return false;
							} else if (cmd == 'updateSortOrder') {
								document.forms['form1'].elements['step'].value = '1';
								document.forms['form1'].elements['cid'].value = document.forms['form1'].elements['parentCid'].value;
								var orderEle = document.forms['form1'].elements['order'];
								var order = $.tableDnD.serializeTable(document.getElementById("row"));
								action += '?' + order;
							} else if (cmd == 'view') {
								document.forms['form1'].elements['cid'].value = cid;
								if (level) {
									document.forms['form1'].elements['level'].value = parseInt(level);
								}
							}
							
							document.forms['form1'].elements['cmd'].value = cmd;
							document.forms['form1'].action = action;
							document.forms['form1'].submit();
							
							return true;
						}
					</script>
				</DIV>
			</DIV>
		</DIV>
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>
					