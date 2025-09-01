<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%
	UserBean userBean = new UserBean(request);

%>
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>
a {
	margin-left:1cm;
	font-size:150%;
	color:white;
}
</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<c:set var="pageTitle" value="${education.eeMenuModule.eeDescriptionEn}" />
<jsp:useBean id="pageTitle" class="java.lang.String" />
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="keepReferer" value="Y" />
</jsp:include>

<font color="blue"><c:out value="${education.message}"/></font>
<font color="red"><c:out value="${education.errorMessage}"/></font>
<div style='background-image: url(../images/pink_effect_fill.png);background-size:auto'>
<form name="form1" action="elearning_test.jsp" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr style="text-align: right;">
			<td colspan="2"><a  href="reminder.jsp"><b>Staff Education Home</b></a></td>
		</tr>
		<tr style="font-size:150%" bgcolor="rgb(204, 204, 255)">
			<td style="color:rgb(0, 51, 204)" colspan="2" class="bold">
				<%=pageTitle %>&nbsp;<c:out value="${education.eeMenuModule.eeDescriptionZh}"/>
			</td>
		</tr>
	<tr><td>&nbsp;</td></tr>
	<c:if test="${education.list != null}" > 
		<c:forEach var="content" items="${education.list}">
			<c:choose>
				<c:when test="${content.eeMenuDocument != null}">
					<c:choose>
						<c:when test="${content.eeMenuDocument.eeIsUrl eq 'Y'}" >
							<tr><td>
								<a href="<c:out value='${content.eeMenuDocument.eeUrl}' />" target="_blank">
									<b><c:out value="${content.eeDescriptionEn}" /></b>
								</a>
							</td></tr>
						</c:when>
						<c:otherwise>
							<tr><td>
								<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content.id.eeMenuContentId}' />', '<c:out value='${content.eeMenuDocument.eeDocumentId}' />')">
									<c:out value="${content.eeDescriptionEn}" />
								</a>
							</td></tr>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:out value="${content.eeDescriptionEn}" />
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:if>
</table>
<input type="hidden" name="documentID" />
<input type="hidden" name="moduleCode" value="<c:out value='${education.moduleCode}' />" />
<input type="hidden" name="keyID" />
</form>
<br/>
<div style="margin: 10px 0;">
	<p class="mottoText">Extending the Healing Ministry of Christ</p>
	<p class="mottoText">延續基督的醫治大能</p>
</div>
</div>
<script language="javascript">
	function submitAction(cmd, eid) {
		if (cmd != '') {
			callPopUpWindow(document.form1.action + "?command=&elearningID=" + eid);
		}
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>