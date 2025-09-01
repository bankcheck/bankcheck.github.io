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
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp" />
	<c:if test="${discussionBoard.closeAction}">
		<script type="text/javascript">window.close();</script>
	</c:if>
	<body>
	<jsp:include page="../common/banner2.jsp"/>
	<div id="indexWrapper">
		<div id="mainFrame">
			<div id="Frame">
				<c:set var="moduleDescription" value="${moduleDescription}" />
				<jsp:useBean id="moduleDescription" class="java.lang.String" />
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="<%=moduleDescription %>" />
					<jsp:param name="keepReferer" value="N" />
					<jsp:param name="translate" value="N" />
				</jsp:include>
				
				<c:set var="message" value="${education.message}" />
				<jsp:useBean id="message" class="java.lang.String" />
				<c:set var="errorMessage" value="${education.errorMessage}" />
				<jsp:useBean id="errorMessage" class="java.lang.String" />
				<jsp:include page="../common/message.jsp" flush="false">
					<jsp:param name="message" value="<%=message %>" />
					<jsp:param name="errorMessage" value="<%=errorMessage %>" />
				</jsp:include>
				
				<form name="dbDetailForm" action="details.htm" method="post" onsubmit="return false;">
					<span>
						<table cellpadding="0" cellspacing="0" class="contentFrameMenu" border="0">
							<tr class="smallText">
								<td class="infoTitle">
									<c:choose>
										<c:when test="${discussionBoard.viewCommentAction}">
											<c:out value="${discussionBoard.comment.dbTopicDesc}" />
										</c:when>
										<c:when test="${discussionBoard.createCommentAction}">
											<c:out value="New Topic" />
										</c:when>
										<c:when test="${discussionBoard.updateCommentAction || discussionBoard.editCommentAction}">
											<c:out value="Update Topic" />
										</c:when>
									</c:choose>
								</td>
								<td class="infoButton" align="right">
									<c:choose>
										<c:when test="${discussionBoard.createCommentAction}">
											<button onclick="dbDetailForm_submitAction('createComment', 1);return false;" class="btn-click"><bean:message key="button.save" /></button>
											<button onclick="dbDetailForm_submitAction('hiddenComment', '');return false;" class="btn-click"><bean:message key="label.cancel" /></button>
										</c:when>
										<c:when test="${discussionBoard.updateCommentAction}">
											<c:if test="${discussionBoard.allowToEdit }" >
												<button onclick="dbDetailForm_submitAction('updateComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.update" /></button>
											</c:if>
											<button onclick="dbDetailForm_submitAction('viewComment', '<c:out value="${discussionBoard.comment.id.dbCommentId}" />');return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.update" /></button>
										</c:when>
										<c:when test="${discussionBoard.editCommentAction}">
											<c:if test="${discussionBoard.allowToEdit }" >
												<button onclick="dbDetailForm_submitAction('updateComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.update" /></button>
											</c:if>
										</c:when>						
										<c:when test="${discussionBoard.replyCommentAction}">
											<button onclick="dbDetailForm_submitAction('replyComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.update" /></button>
											<button onclick="dbDetailForm_submitAction('viewComment', 1);return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.update" /></button>
										</c:when>		
										<c:when test="${discussionBoard.viewCommentAction}">
											<c:choose>
												<c:when test="${discussionBoard.allowToEdit }" >
													<button onclick="dbDetailForm_submitAction('updateComment', 0);return false;" class="btn-click"><bean:message key="button.update" /></button>
												</c:when>
												<c:otherwise>
													<button onclick="dbDetailForm_submitAction('replyComment', 0);return false;" class="btn-click">Reply</button>
												</c:otherwise>
											</c:choose>
										</c:when>						
									</c:choose>
									<button onclick="dbDetailForm_submitAction('listComments', '');return false;" class="btn-click"><bean:message key="label.cancel" /></button>
								</td>
							</tr>
						</table>
				
						<%
							//HashMap<String, String> staffsInfo = (HashMap<String, String>) request.getAttribute("discussionBoard.staffsInfo");
						%>
						<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
							<tr class="smallText">
								<td class="infoLabel" width="10%"><bean:message key="prompt.from" /></td>
								<td class="infoData" width="90%" colspan="3">
									<c:choose>
										<c:when test="${discussionBoard.createCommentAction || discussionBoard.updateCommentAction || discussionBoard.editCommentAction}">
											<select name="fromStaffID">
												<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
													<jsp:param name="value" value="${discussionBoard.fromStaffId}" />
													<jsp:param name="allowAll" value="Y" />
												</jsp:include>
											</select>
										</c:when>
										<c:otherwise>
											<c:forEach var="staff" items="${discussionBoard.staffsInfo}" >
												<% System.out.println("# staff = " + pageContext.getAttribute("staff")); %>
											</c:forEach>
										
											<c:out value="${discussionBoard.staffsInfo[discussionBoard.fromStaffId]}"/>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
				
							<tr class="smallText">
								<td class="infoLabel" width="10%"><bean:message key="prompt.topic" /></td>
								<td class="infoData" width="40%">
									<c:choose>
										<c:when test="${discussionBoard.createCommentAction || discussionBoard.updateCommentAction || discussionBoard.editCommentAction}">
											<input type="textfield" name="commentTopic" value='<c:out value="${discussionBoard.comment.dbTopicDesc}"/>' maxlength="50" size="50" />
										</c:when>
										<c:otherwise>
											<c:out value="${discussionBoard.comment.dbTopicDesc}"/>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
				
							<c:if test="${discussionBoard.createCommentAction || discussionBoard.updateCommentAction
									|| discussionBoard.editCommentAction || discussionBoard.replyCommentAction}" >
								<tr class="smallText">
									<td class="infoLabel" width="10%">Email Notify</td>
									<td class="infoData" width="90%" colspan="3">
										<input type="radio" name="emailNotify" value="YY" /><bean:message key="label.yes" /> (login)
											<c:if test="${discussionBoard.createCommentAction || discussionBoard.updateCommentAction
													|| discussionBoard.editCommentAction}" >
												<input type="radio" name="emailNotify" value="YN" /><bean:message key="label.yes" /> (create comment)
											</c:if>
										<input type="radio" name="emailNotify" value="N" checked="checked" /><bean:message key="label.no" />
									</td>
								</tr>
							</c:if>
				
							<c:if test="${discussionBoard.createCommentAction || discussionBoard.updateCommentAction
									|| discussionBoard.editCommentAction || discussionBoard.replyCommentAction}" >
								<tr class="smallText">
									<td class="infoLabel" width="10%"><bean:message key="prompt.comment" /></td>
									<td class="infoData" width="90%" colspan="3">
										<div class="box">
											<textarea name="comment" rows="20" cols="160">
												<c:if test="${discussionBoard.editCommentAction}" >
													<c:out value="${discussionBoard.comment.dbCommentDesc}" />
												</c:if>
											</textarea>
										</div>
									</td>
								</tr>
							</c:if>
				
							<c:if test="${!discussionBoard.createCommentAction}" >
								<tr class="smallText">
									<td class="infoLabel" width="10%">History</td>
									<td class="infoData" width="90%" colspan="3">
										<div id="rr_listing">
											<table border="0" width="100%" cellspacing="0" cellpadding="0">
												<jsp:include page="history.jsp" flush="false" />
											</table>
										</div>
									</td>
								</tr>
							</c:if>
							<!-- Input layout  -->	
							
							</table>
							
							<table cellpadding="0" cellspacing="0" class="contentFrameMenu" border="0">
								<tr class="smallText">
									<td class="infoTitle">&nbsp;</td>
									<td class="infoButton" align="right">
										<c:choose>
											<c:when test="${discussionBoard.createCommentAction}">
												<button onclick="dbDetailForm_submitAction('createComment', 1);return false;" class="btn-click"><bean:message key="button.save" /></button>
												<button onclick="dbDetailForm_submitAction('hiddenComment', '');return false;" class="btn-click"><bean:message key="label.cancel" /></button>
											</c:when>
											<c:when test="${discussionBoard.updateCommentAction}">
												<c:if test="${discussionBoard.allowToEdit }" >
													<button onclick="dbDetailForm_submitAction('updateComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.update" /></button>
												</c:if>
												<button onclick="dbDetailForm_submitAction('viewComment', '<c:out value="${discussionBoard.comment.id.dbCommentId}" />');return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.update" /></button>
											</c:when>
											<c:when test="${discussionBoard.editCommentAction}">
												<c:if test="${discussionBoard.allowToEdit }" >
													<button onclick="dbDetailForm_submitAction('updateComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.update" /></button>
												</c:if>
											</c:when>						
											<c:when test="${discussionBoard.replyCommentAction}">
												<button onclick="dbDetailForm_submitAction('replyComment', 1);return false;" class="btn-click"><bean:message key="button.save" /> - <bean:message key="button.update" /></button>
												<button onclick="dbDetailForm_submitAction('viewComment', 1);return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.update" /></button>
											</c:when>		
											<c:when test="${discussionBoard.viewCommentAction}">
												<c:choose>
													<c:when test="${discussionBoard.allowToEdit }" >
														<button onclick="dbDetailForm_submitAction('updateComment', 0);return false;" class="btn-click"><bean:message key="button.update" /></button>
													</c:when>
													<c:otherwise>
														<button onclick="dbDetailForm_submitAction('replyComment', 0);return false;" class="btn-click">Reply</button>
													</c:otherwise>
												</c:choose>
												<button onclick="dbDetailForm_submitAction('viewComment', '');return false;" class="btn-click"><bean:message key="label.cancel" /></button>
											</c:when>						
										</c:choose>
										<button onclick="dbDetailForm_submitAction('listComments', '');return false;" class="btn-click">Back</button>
									</td>
								</tr>
							</table>
						</span>
						<input type="hidden" name="command" />
						<input type="hidden" name="step" />
						<input type="hidden" name="siteCode" value="<c:out value="${discussionBoard.siteCode}" />" />
						<input type="hidden" name="moduleCode" value="<c:out value="${discussionBoard.moduleCode}" />" />
						<input type="hidden" name="recordId" value="<c:out value="${discussionBoard.recordId}" />" />
						<input type="hidden" name="commentId" value='<c:out value="${discussionBoard.comment.id.dbCommentId}" />' />
						<input type="hidden" name="commentHistoryId" />
						<input type="hidden" name="dbListCurPage" value='<c:out value="${discussionBoard.dbListCurPage}" />' />
					</form>
	
			</div>
		</div>
	</div>
	<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>