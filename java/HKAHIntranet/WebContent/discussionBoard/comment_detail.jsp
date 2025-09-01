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
				<c:set var="moduleDescription" value="${discussionBoard.moduleDescription}" />
				<jsp:useBean id="moduleDescription" class="java.lang.String" />
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
				
				<form name="form1" action="comment_detail.htm" method="post">
					<span>
						<table cellpadding="0" cellspacing="0" class="contentFrameMenu" border="0">
							<tr class="smallText">
								<td class="infoTitle">
									<c:out value="${discussionBoard.recordTitle}" />
								</td>
								<td class="infoButton" align="right">
									<button onclick="dbCommentDetailForm_submitAction('listComments', 0);" class="btn-click">Board</button>
									<button onclick="dbCommentDetailForm_submitAction('goToReply', '');return false;" class="btn-click">Reply</button>
								</td>
							</tr>
						</table>
						
						<table cellpadding="0" cellspacing="5"
							class="contentFrameMenu" border="0">
							<tr class="smallText">
								<td class="infoLabel" width="20%">Topic</td>
								<td class="infoData" width="80%"><c:out value="${discussionBoard.comment.dbTopicDesc}" /></td>
							</tr>
							
							<tr class="smallText">
								<td class="infoLabel" width="20%">Created By</td>
								<td class="infoData" width="80%"><c:out value="${discussionBoard.comment.dbCreatedUserName}" /></td>
							</tr>
							
							<tr class="smallText">
								<td class="infoLabel" width="10%">Content</td>
								<td class="infoData" width="90%" colspan=3">
									<div id="rr_listing">
										<table border="0" width="100%" cellspacing="0" cellpadding="0">
										<c:forEach var="comment" items="${discussionBoard.comments}">
											<tr>
												<td class="h1_margin">
													<span class="pupular_content" style="line-height: 13px">
														<span id="rr_hideobj_0" style="display:none"><c:out value="${comment.dbCommentDesc}" escapeXml="false" /></span>
														<span id="rr_showobj_0" style="display:inline"><c:out value="${comment.dbCommentDesc}" escapeXml="false" /></span><br/>
														<span id="rr_showhidelink_0" style="CURSOR: pointer" class="visible" onclick="showhide(0, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '[+] More Comment', '[-] Brief Comment');return false;">[-] Brief Comment</span>
													</span>
												</td>
											</tr>
											<tr><td height="7">&nbsp;</td></tr>
											<tr class="topstoryblue">
												<td>
													<i>Posted <span class="time" title="T:00Z"><c:out value="${comment.dbModifiedDate}" /></span> by <b><c:out value="${comment.dbModifiedUserName}" /></b></i>
												</td>
											</tr>
											<tr><td height="7"><HR/></td></tr>
										</c:forEach>
										</table>
									</div>
								</td>
							</tr>
							
							<tr class="smallText">
								<td class="infoLabel" width="20%">Reply</td>
								<td class="infoData" width="80%">
									<div class="box"><textarea id="wysiwyg" name="comment" rows="6" style="width: 100%;"></textarea></div>
									<div class="pane">
										<table width="100%" border="0">
											<tr class="smallText">
												<td colspan="2" align="center">
													<button onclick="dbCommentDetailForm_submitAction('replyComment', 1, 0);" class="btn-click">Submit Reply</button>
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
				</table>
			</div>
		</td>
	</tr>
						</table>
					</span>
					<input type="hidden" name="command" />
					<input type="hidden" name="step" />
					<input type="hidden" name="siteCode" value="<c:out value="${discussionBoard.siteCode}" />" />
					<input type="hidden" name="moduleCode" value="<c:out value="${discussionBoard.moduleCode}" />" />
					<input type="hidden" name="moduleDescription" value="<c:out value="${discussionBoard.moduleDescription}" />" />
					<input type="hidden" name="recordId" value="<c:out value="${discussionBoard.recordId}" />" />
					<input type="hidden" name="recordTitle" value="<c:out value="${discussionBoard.recordTitle}" />" />
					<input type="hidden" name="commentId" value='<c:out value="${discussionBoard.comment.id.dbCommentId}" />' />
					<input type="hidden" name="commentHistoryId" />
				</form>
			</div>
		</div>
	</div>
	<script type="text/javascript" src="<html:rewrite page="/js/discussionBoard.js" />" /></script>
	<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>