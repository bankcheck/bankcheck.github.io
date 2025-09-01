<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.util.*" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

	<jsp:useBean id="userBean" class="com.hkah.web.common.UserBean" />
	<c:set var="userBean" value="${discussionBoard.userBean}" />
	<%
		boolean allowToEdit = false;
	%>
	<c:set var="allowToEdit" value="${discussionBoard.allowToEdit}" />

	<% // The latest comment shown first %>
	
	<c:set var="commentDesc" value="${discussionBoard.comment.dbCommentDesc}"/>
	<jsp:useBean id="commentDesc" class="java.lang.String"/>
	<jsp:useBean id="commentDescDisplay" class="java.lang.String" />
	<%
		boolean moreDetail = false;
	%>
	
	<%
		if (commentDesc.length() > 300) {
			commentDescDisplay = commentDesc.substring(0, 300);
	%>
			<c:set var="moreDetail" value="true" />
	<%	
		} else {
	%>
			<c:set var="commentDescDisplay" value="${commentDesc}" />
			<c:set var="moreDetail" value="false" />
	<%
		}
	%>
			
	<tr>
		<td class="h1_margin">
			<span class="pupular_content" style="line-height: 13px">
				<span id="rr_hideobj_0" style="display:none">
					<c:out value="${commentDescDisplay}" />
					<c:if test="${moreDetail}">
						<c:out value="..." />
					</c:if>
				</span>
				<span id="rr_showobj_0" style="display:inline">
					<c:out value="${commentDescDisplay}" />
				</span>
				<br/>
				<span id="rr_showhidelink_0" style="CURSOR: pointer" class="visible" onclick="db_showhide(0, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '[+] More Comment', '[-] Brief Comment');return false;">
					<c:out value="[-] Brief Comment" />
				</span>
			</span>
		</td>
	</tr>
	<tr><td height="7">&nbsp;</td></tr>
			<tr class="topstoryblue">
				<td>
					<i>Posted&nbsp;
						<span class="time" title="<c:out value="${discussionBoard.comment.createdDateString}" />T<c:out value="${discussionBoard.comment.createdTimeString}" />:00Z">
						<c:out value="${discussionBoard.comment.createdDateTimeString}" />
						</span> by <b><c:out value="${discussionBoard.comment.dbModifiedUserName}" /></b>
					</i>
					<jsp:useBean id="dbModifiedUser" class="java.lang.String" />
					<c:set var="dbModifiedUser" value="${discussionBoard.comment.dbModifiedUserName}" />
<%	if (allowToEdit && userBean.getUserName().equals(dbModifiedUser)) { %>
					<button onclick="submitAction('editComment', 0);return false;" class="btn-click"><bean:message key="button.edit" /></button>
				</td>
<%	} %>
			</tr>
			<tr><td height="7"><HR/></td></tr>

	<% // Show historic comments %>
	<c:if test="${discussionBoard.commentHistories != null}">
		<c:forEach var="histories" items="${requestScope.discussionBoard.commentHistories}" 
				varStatus="rowCounter" >
			<c:set var="commentDesc" value="${histories.dbCommentDesc}" />
			<%
				if (commentDesc.length() > 300) {
					commentDescDisplay = commentDesc.substring(0, 300);
			%>
					<c:set var="moreDetail" value="true" />
			<%	
				} else {
			%>
					<c:set var="commentDescDisplay" value="${commentDesc}" />
					<c:set var="moreDetail" value="false" />
			<%
				}
			%>
			
			<tr>
				<td class="h1_margin">
				
					<c:choose>
						<c:when test="${discussionBoard.editCommentHistoryAction && 
								discussionBoard.commentHistoryId eq histories.id.dbCommentHistoryId}" >
							<div class="box">
								<textarea name="commentHistoryDesc" rows="20" cols="160">
									<c:out value="${histories.dbCommentDesc}" />
								</textarea>
							</div>
						</c:when>
						<c:otherwise>
							<jsp:useBean id="styleDisplay1" class="java.lang.String" />
							<jsp:useBean id="styleDisplay2" class="java.lang.String" />
							<c:choose>
								<c:when test="${rowCounter.count == 0}">
									<c:set var="styleDisplay1" value="none" />
									<c:set var="styleDisplay2" value="inline" />
								</c:when>
								<c:otherwise>
									<c:set var="styleDisplay1" value="inline" />
									<c:set var="styleDisplay2" value="none" />
								</c:otherwise>
							</c:choose>
						
							<span class="pupular_content" style="line-height: 13px">
								<span id="rr_hideobj_<c:out value='${rowCounter.count + 1}' />" 
										style="display:<c:out value='${styleDisplay1 }' />">
									<c:out value='${commentDescDisplay}' />
									<c:if test="${moreDetail }">
										<c:out value="..." />
									</c:if>
								</span>
								<span id="rr_showobj_<c:out value='${rowCounter.count + 1}' />" 
										style="display:<c:out value='${styleDisplay2 }' />">
										<c:out value='${commentDescDisplay}' />
								</span>
								<br/>
								<span id="rr_showhidelink_<c:out value='${rowCounter.count + 1}' />" 
										style="CURSOR: pointer" class="visible" 
										onclick="return db_showhide(<c:out value='${rowCounter.count + 1}' />, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '[+] More Comment', '[-] Brief Comment');">
									<c:choose>
										<c:when test="${rowCounter.count == 0}">
											<c:out value="[-] Brief Comment" />
										</c:when>
										<c:otherwise>
											<c:out value="[+] More Comment" />
										</c:otherwise>
									</c:choose>	
								</span>
							</span>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr><td height="7">&nbsp;</td></tr>
			<tr class="topstoryblue">
				<td>
					<c:choose>
						<c:when test="${userBean.loginID eq histories.dbCreatedUser}" >
							<c:choose>
								<c:when test="${discussionBoard.editCommentHistoryAction}">
									<button onclick="dbDetailForm_editCommentHistory(1, '<c:out value="${histories.id.dbCommentHistoryId}" />');return false;" class="btn-click"><bean:message key="button.save" /></button>
								</c:when>
								<c:otherwise>
									<i>Posted&nbsp;
										<span class="time" title="<c:out value="${histories.createdDateString}" />T<c:out value="${histories.createdTimeString}" />:00Z"><c:out value="${histories.createdDateTimeString}" />
										</span> by <b><c:out value="${histories.dbCreatedUserName}" /></b>
									</i>
									<button onclick="dbDetailForm_editCommentHistory(0, '<c:out value="${histories.id.dbCommentHistoryId}" />');return false;" class="btn-click"><bean:message key="button.edit" /></button>
									<br />
									<i>Last Modified&nbsp;
										<span class="time" title="<c:out value="${histories.modifiedDateString}" />T<c:out value="${histories.modifiedTimeString}" />:00Z"><c:out value="${histories.modifiedDateTimeString}" />
										</span> by <b><c:out value="${histories.dbModifiedUserName}" /></b>
									</i>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<i>Posted&nbsp;
								<span class="time" title="<c:out value="${histories.createdDateString}" />T<c:out value="${histories.createdTimeString}" />:00Z"><c:out value="${histories.createdDateTimeString}" />
								</span> by <b><c:out value="${histories.dbCreatedUserName}" /></b>
							</i>
							<c:if test="${histories.modifiedDateTimeString ne histories.createdDateTimeString || histories.dbModifiedUserName ne histories.dbCreatedUserName}">
								<br />
								<i>Last Modified&nbsp;
									<span class="time" title="<c:out value="${histories.modifiedDateString}" />T<c:out value="${histories.modifiedTimeString}" />:00Z"><c:out value="${histories.modifiedDateTimeString}" />
									</span> by <b><c:out value="${histories.dbModifiedUserName}" /></b>
								</i>
							</c:if>
						</c:otherwise>
					</c:choose>
					

				</td>
			</tr>
			<tr>
				<td height="7"><hr /></td>
			</tr>
		</c:forEach>
	</c:if>