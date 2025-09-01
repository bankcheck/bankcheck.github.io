<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*" %>
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

<c:if test="${forwardScanning == null}">
	<c:redirect url="category_list.htm" />
</c:if>
<c:set var="canCreateCat" value='forwardScanning.userBean.isAccessible("function.fs.category.create")'/>
<c:set var="canUpdateCat" value='forwardScanning.userBean.isAccessible("function.fs.category.update")'/>
<c:set var="canViewCat" value='forwardScanning.userBean.isAccessible("function.fs.category.view")'/>
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<style>
		.dragClass { color: #ff0000; }
	</style>
	<body>
		<DIV id=indexWrapper>
			<DIV id=mainFrame>
				<DIV id=contentFrame style="min-height:0px;">
					<jsp:include page="../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="function.fs.category.list" />
						<jsp:param name="mustLogin" value="N" />
						<jsp:param name="accessControl" value="N" />
					</jsp:include>
					<c:set var="message" value="${forwardScanning.message}" />
					<jsp:useBean id="message" class="java.lang.String" />
					<c:set var="errorMessage" value="${forwardScanning.errorMessage}" />
					<jsp:useBean id="errorMessage" class="java.lang.String" />
					<jsp:include page="../common/message.jsp" flush="false">
						<jsp:param name="message" value="<%=message %>" />
						<jsp:param name="errorMessage" value="<%=errorMessage %>" />
					</jsp:include>
					<jsp:include page="back.jsp" flush="false" />
					<form name="search_form" action="category_list.htm" method="post"> 
						<table cellpadding="0" cellspacing="0"
							class="contentFrameSearch" border="0">
							<tr class="smallText">
								<td colspan="2" align="center">
									<c:if test="${forwardScanning.level ne 0}">
										<button onclick="return submitSearch('back');"><bean:message key="button.back" /></button>
									</c:if>
									<button onclick="return submitSearch('search');"><bean:message key="button.search" /></button>
								</td>
							</tr>
						</table>
						<input type="hidden" name="cid" value="<c:out value='${forwardScanning.parentCid}' />" />
						<input type="hidden" name="grandCid" value="<c:out value='${forwardScanning.grandCid}' />" />
						<input type="hidden" name="level" value="<c:out value='${forwardScanning.level}' />" />
					</form>
					
					<ul id="breadcrumb-menuContent">
						<c:if test="${empty forwardScanning.ancestors}" >
							<c:set var="level0Class" value="parent"/>
						</c:if>
					<c:forEach var="row" items="${forwardScanning.ancestors}" varStatus="rowCounter">
						<c:set var="listClass" value="level${rowCounter.count}"/>
						<c:if test="${rowCounter.last}" >
							<c:set var="listClass2" value="parent"/>
						</c:if>
						<li class="<c:out value='${listClass}' /> <c:out value='${listClass2}' />">
							<a href="#" onclick="return submitAction('view', '<c:out value='${row.fsCategoryId}' />', '<c:out value='${rowCounter.count}' />')">
								<c:out value='${row.fsName}' />
							</a>
						</li>
					</c:forEach>
					</ul>

					<bean:define id="functionLabel"><bean:message key="function.fs.category.list" /></bean:define>
					<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
					
					<c:set var="level" value="${forwardScanning.level}" />
					<jsp:useBean id="level" class="java.lang.String" />
					
					<form name="form1" action="category_detail.htm" method="post">
						<c:set var="pagesizeInt" value="${forwardScanning.userBean.noOfRecPerPage}"/>
						
						<table id="row">
							<thead>
								<tr>
									<th><bean:message key="prompt.displayOrder" /></th>
									<th><bean:message key="prompt.description" /></th>
									<th><bean:message key="prompt.action" /></th>
								</tr>
							</thead>
							<tbody>
							<c:forEach var="row" items="${forwardScanning.list}" varStatus="rowCounter">
								<c:choose>
									<c:when test="${rowCounter.count % 2 == 0}">
										<c:set var="trClass" value="even" />
									</c:when>
									<c:otherwise>
										<c:set var="trClass" value="odd" />
									</c:otherwise>
								</c:choose>
							
								<tr id="<c:out value='${row.fsCategoryId}' />" class="<c:out value='${trClass}' />">
									<td style="width:5%" class="dragHandler">
										<c:out value="${rowCounter.count}" />
									</td>
									<td>
										<a href="#" onclick="return submitAction('view', '<c:out value='${row.fsCategoryId}' />')"><c:out value="${row.fsName}" /></a>
									</td>
									<td style="width:10%; text-align:center">
										<c:if test="canViewCat">
											<button onclick="return submitAction('viewDetails', '<c:out value='${row.fsCategoryId}' />');"><bean:message key='button.view' /></button>
										</c:if>
									</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
						
						<table width="100%" border="0">
							<tr class="smallText">
								<td colspan="2" align="center">
									<c:if test="canCreateCat">
										<button onclick="return submitAction('create');"><bean:message key="function.title.create" /></button>
									</c:if>
									<c:if test="canUpdateCat">
										<c:if test="${!empty forwardScanning.list}">
											<button onclick="return submitAction('updateSortOrder');"><bean:message key="function.UpdateDisplayOrder" /></button>
										</c:if>
									</c:if>
									
								</td>
							</tr>
						</table>
						<input type="hidden" name="cmd" />
						<input type="hidden" name="step" />
						<input type="hidden" name="cid" />
						<input type="hidden" name="parentCid" value="<c:out value='${forwardScanning.parentCid}' />" />
						<input type="hidden" name="level" value="<c:out value='${forwardScanning.level}' />" />
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
								document.forms['search_form'].elements['cid'].value = '<c:out value="${forwardScanning.grandCid}" />';
							}
							document.forms['search_form'].submit();
						}
					
						function clearSearch() {
						}
					
						function submitAction(cmd, cid, level) {
							var action = "category_list.htm";
							
							if (cmd == 'create' || cmd == 'update' || cmd == 'viewDetails') {
								var parentCid = document.forms['form1'].elements['parentCid'].value;
								var level = document.forms['form1'].elements['level'].value;
								callPopUpWindow("category_detail.htm?command=" + cmd + "&cid=" + cid + "&parentCid=" + parentCid +"&level=" + level);
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
					