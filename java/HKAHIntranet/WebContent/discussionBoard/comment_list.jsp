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
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<c:if test="${discussionBoard.closeAction}">
<script type="text/javascript">window.close();</script>
</c:if>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/thickbox.css" />" media="screen" />
<body>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper>
	<div id=mainFrame>
		<div id=Frame>
			<c:set var="moduleDescription" value="${discussionBoard.moduleDescription}" />
			<jsp:useBean id="moduleDescription" class="java.lang.String" />
			<%
				System.out.println("DEBUG: moduleDescription = " + moduleDescription);
			%>
			<jsp:include page="../common/page_title.jsp" flush="false">
				<jsp:param name="pageTitle" value="<%=moduleDescription %>" />
				<jsp:param name="keepReferer" value="N" />
				<jsp:param name="translate" value="N" />
			</jsp:include>
			<c:set var="message" value="${discussionBoard.message}" />
			<jsp:useBean id="message" class="java.lang.String" />
			<c:set var="errorMessage" value="${discussionBoard.errorMessage}" />
			<jsp:useBean id="errorMessage" class="java.lang.String" />
			<jsp:include page="../common/message.jsp" flush="false">
				<jsp:param name="message" value="<%=message %>" />
				<jsp:param name="errorMessage" value="<%=errorMessage %>" />
			</jsp:include>
			<form name="form1" action="comment_list.htm" method="post">
				<div id="showOverall_indicator">
					<table cellpadding="0" cellspacing="0"
							class="contentFrameMenu" border="0">
						<tr class="smallText">
							<td class="infoTitle"><c:out value="${discussionBoard.recordTitle}" /></td>
							<td class="infoButton">
								<button onclick="return dbCommentListForm_submitAction('createComment', '0');"><bean:message key="function.projectSummary.comment.create" /></button>
							</td>
						</tr>
					</table>
					<table width="1000" cellpadding="0" cellspacing="0" border="0" align="left" valign="top" style="width: 100%;">
						<tr>
							<td valign="top" width="60%">
		<display:table id="db_Row" name="requestScope.discussionBoard.dbCommentList" class="tablesorter" requestURI="comment_list.htm"
				export="false" pagesize="10" decorator="com.hkah.web.displaytag.DiscussionBoardListDecorator">
			<display:column property="topicDescWithLink" title="Thread" style="width:60%"/>
			<display:column property="dbCreatedUserName" title="Author" style="width:15%"/>
			<display:column property="replies" title="Relies" style="width:10%; text-align:center;"/>
			<display:column property="formattedLastPostDate" title="Last Post" style="width:15%"/>
		</display:table>
							</td>
							<td valign="top" width="40%">
							
								<!-- Quick add comment -->
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr><td class="title"><span>New Topic >></span></td></tr>
									<tr><td height="2" bgcolor="#840010"></td></tr>
									<tr><td height="10"></td></tr>
									<tr><td>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr class="smallText">
											<td class="infoLabel" width="30%"><bean:message key="prompt.topic" /></td>
											<td class="infoData" width="70%"><input type="text" name="topicDesc" value="" maxlength="100" size="50" /></td>
										</tr>
										<tr class="smallText">
											<td class="infoLabel" width="30%">Comment</td>
											<td class="infoData" width="70%">
												<div class="box"><textarea id="wysiwyg" name="commentDesc" rows="6" cols="70"></textarea></div>
											</td>
										</tr>
										<tr class="smallText">
											<td colspan="2" align="center">
												<button onclick="return dbCommentListForm_submitAction('createComment', 1, 0);" class="btn-click">Submit Comment</button>
											</td>
										</tr>
									</table>
									</td></tr>
								</table>	
								<jsp:include page="comment_search.jsp" flush="false" />
						</td>
					</tr>
				</table>
				<input type="hidden" name="command" />
				<input type="hidden" name="step" />
				<input type="hidden" name="seq" />
				<input type="hidden" name="moduleCode" value='<c:out value="${discussionBoard.moduleCode}" />' />
				<input type="hidden" name="moduleDescription" value="<c:out value="${discussionBoard.moduleDescription}" />" />
				<input type="hidden" name="recordId" value='<c:out value="${discussionBoard.recordId}" />' />
				<input type="hidden" name="recordTitle" value="<c:out value="${discussionBoard.recordTitle}" />" />
				<input type="hidden" name="commentId" />
			</form>
<script type="text/javascript" src="<html:rewrite page="/js/discussionBoard.js" />" /></script>
		</div>
	</div>
</div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>