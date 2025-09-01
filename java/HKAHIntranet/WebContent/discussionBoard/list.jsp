<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<form name="dbListForm" method="post">
	<c:if test="${discussionBoard.listCommentAction}" >
		<table cellpadding="0" cellspacing="5"
			class="contentFrameMenu" border="0">
			<tr class="smallText">
				<td class="infoTitle" colspan="2">Discussion</td>
			</tr>
		</table>
	<div id="dbListForm_commentList">
		<display:table id="db_Row" name="requestScope.discussionBoard.dbCommentList" class="tablesorter"
				export="false" pagesize="" decorator="com.hkah.web.displaytag.DiscussionBoardListDecorator">
			<display:column property="topicDescWithLinkNewWindow" title="Thread" style="width:60%"/>
			<display:column property="dbCreatedUserName" title="Author" style="width:15%"/>
			<display:column property="replies" title="Relies" style="width:10%; text-align:center;"/>
			<display:column property="formattedLastPostDate" title="Last Post" style="width:15%"/>
		</display:table>
	</div>
	<table cellpadding="0" cellspacing="5"
			class="contentFrameMenu" border="0">
		<tr>
			<td>
				Total number of topics: <c:out value="${discussionBoard.totalNumOfComments}" />
				<button onclick="return dbListForm_submitAction('viewComment', 1, 0);" class="btn-click">
					All Topics
				</button>
			</td>
		</tr>
	</table>
	</c:if>
	
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="seq" />
<input type="hidden" name="siteCode" value="<c:out value="${discussionBoard.siteCode}" />" />
<input type="hidden" name="moduleCode" value="<c:out value="${discussionBoard.moduleCode}" />" />
<input type="hidden" name="moduleDescription" value="<c:out value="${discussionBoard.moduleDescription}" />" />
<input type="hidden" name="recordId" value="<c:out value="${discussionBoard.recordId}" />" />
<input type="hidden" name="recordTitle" value="<c:out value="${discussionBoard.recordTitle}" />" />
<input type="hidden" name="commentId" />
</form>
<script type="text/javascript" src="<html:rewrite page="/js/discussionBoard.js" />" /></script>