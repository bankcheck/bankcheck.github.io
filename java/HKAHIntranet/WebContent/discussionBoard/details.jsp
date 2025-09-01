<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>
Discussion Board (topic)
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/thickbox.css" />" media="screen" />
	<div id=indexWrapper>
		<div id=mainFrame>
			<div id=Frame>
				<jsp:useBean id="moduleDescription" class="java.lang.String" />
				<c:set var="moduleDescription" value="${discussionBoard.moduleDescription}" />
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="<%=moduleDescription %>" />
					<jsp:param name="category" value="admin" />
					<jsp:param name="keepReferer" value="N" />
					<jsp:param name="translate" value="N" />
				</jsp:include>
				<font color="blue"><c:out value="${discussionBoard.message}"/></font>
				<font color="red"><c:out value="${discussionBoard.errorMessage}"/></font>
				<form name="dbDetailForm" action="details.htm" method="post" onsubmit="return false;">
					<span>
						<jsp:useBean id="commentId" class="java.lang.String" />
						<c:set var="commentId" value="${discussionBoard.comment.id.dbCommentId}" />
			
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
											<button onclick="dbDetailForm_submitAction('viewComment', '<c:out value="${commentId}" />');return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.update" /></button>
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
										<input type="radio" name="emailNotify" value="N" checked /><bean:message key="label.no" />
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
												<button onclick="dbDetailForm_submitAction('viewComment', '<c:out value="${commentId}" />');return false;" class="btn-click"><bean:message key="label.cancel" /> - <bean:message key="button.update" /></button>
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
