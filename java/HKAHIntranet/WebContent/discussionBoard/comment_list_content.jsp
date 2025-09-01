<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
	<c:if test="${columnTitle != null}" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td class="title"><span><c:out value="${columnTitle}" /></span></td></tr>
			<tr><td height="2" bgcolor="#840010"></td></tr>
			<tr><td height="10"></td></tr>
		</table>
	</c:if>
	
	<c:forEach var="comments" items="${requestScope.discussionBoard.dbCommentList}" varStatus="rowCounter" >
	    <c:choose>
          <c:when test="${rowCounter.count % 2 == 0}">
            <c:set var="rowStyle" scope="page" value="odd" />
          </c:when>
          <c:otherwise>
            <c:set var="rowStyle" scope="page" value="even" />
          </c:otherwise>
        </c:choose>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="most_popular" width="15" valign="top" class="${rowStyle}">
					<b class="pupular_content"><c:out value="${rowCounter.count}" />.</b>
				</td>
				<td class="most_popular" class="${rowStyle}">
					<h2 id="TS">
						<a href="#" onclick="dbListForm_showCommentDetails('viewComment', '<c:out value="${comments.id.dbCommentId}" />');" class="topstoryblue">
							<c:out value="${comments.dbTopicDesc}" />
						</a>
					</h2>
					<br><span class="reported_quote"><c:out value="${comments.dbModifiedDate}" /> by <c:out value="${comments.issuerName}" /></span>
					<br><span class="reported_quote"><b>Handle By:</b> <c:out value="${comments.departmentDesc}" /></span>
				</td>
				<td bgcolor="#ffffff" width="10">&nbsp;</td>
			</tr>
		</table>
	</c:forEach>
	
<style type="text/css">
	table .odd {
		background: #ffffff;
	}
	table .even {
		background: #e8e8e8;
	}
</style>