<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
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
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>

<c:if test="${education == null}">
	<c:redirect url="mand_inserv_content.htm" />
</c:if>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>
<c:set var="pageTitle" value="${education.eeMenuModule.eeDescriptionEn}" />
<jsp:useBean id="pageTitle" class="java.lang.String" />
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="keepReferer" value="Y" />
</jsp:include>
<style>
#contentPage ul { list-style: url('../images/book_icon2.gif') inside; margin: 10px 0; }
#contentPage ul li { margin: 0; }
#contentPage ul li span { padding-left: 10px; }

#contentHead { width: 100%; background: #ffff99; }
#listStyleCol { width: 5%; padding: 5px 0 5px 5px;}
.detailsCol { width: 45%; padding: 5px 0;}

#videoCol { width: 13.5%; }
#slideCol { width: 31.5%; }
#staffEducationWrapper #slideCol a { color: #ff00ff; text-decoration: underline; }
#staffEducationWrapper #slideCol a:link { color: #ff00ff; text-decoration: underline; }
#staffEducationWrapper #slideCol a:hover { color: #ff0000; text-decoration: underline; }
#staffEducationWrapper #videoCol a { color: #ff00ff; text-decoration: underline; }
#staffEducationWrapper #videoCol a:link { color: #ff00ff; text-decoration: underline; }
#staffEducationWrapper #videoCol a:hover { color: #ff0000; text-decoration: underline; }
#descriptionsCol { padding-left: 10px; }
.reviseRow { text-align: center; background: #ccffff; }

</style>

<font color="blue"><c:out value="${education.message}"/></font>
<font color="red"><c:out value="${education.errorMessage}"/></font>

<form name="form1" method="post">
	<div id="staffEducationWrapper">
		<div id="contentPage">

			<div id="breadcrumb">
				<a href="reminder.jsp"><bean:message key="label.staffEducation" /></a> -> <bean:message key="function.staffEducation.education.is_content" />
			</div>
			<h2><bean:message key="label.staffEducation" /></h2>
			<h3><bean:message key="function.staffEducation.education.is_content" /></h3>
			<c:if test="${education.userBean.educationManager}">
				<button onclick="return submitAction('update', 0);"><bean:message key="prompt.staffEducationUpdate" /></button>
			</c:if>
			<table cellpadding="0" cellspacing="0" border="0" id="contentHead">
				<tr>
					<td id="listStyleCol"></td>
					<td colspan="4">
						<p><a href="education_calendar.jsp"><b>Registration</b> (課堂登記)</a>&nbsp;<b>& Learning Modes</b> (學習方式)&nbsp;&nbsp;
						<a href="elearning_test_list_menu.jsp?eventType=class"><img src="<html:rewrite page="/images/sitin.gif" />" /> <b>sit-in</b> (課堂學習)</a>&nbsp;
						<a href="elearning_test_list_menu.jsp?eventType=online"><img src="<html:rewrite page="/images/online.gif" />" /> <b>on-line</b> (網上學習)</a></p>
						<p>A monthly Education Calendar with the schedule of MIE will be e-mailed to Department Heads/ Managers who will designate departmental staff to attend the education/ training sessions.</p>
					</td>
				</tr>
			</table>
		<table cellpadding="5" cellspacing="0" border="0" style="width: 100%;">
			<c:forEach var="content" items="${education.list}">
			<tr class="detailsRow" style="background: #<c:out value='${content.eeBgColor}' />">
				<td valign="top" id="listStyleCol">
					<img src="../images/<c:out value="${content.eeType}" />.gif">
				</td>

				<c:choose>
					<c:when test="${content.eeMenuDocument != null}">
				<td class="detailsCol" colspan="2" valign="top">
					<c:choose>
						<c:when test="${content.eeMenuDocument.eeIsUrl eq 'Y'}" >
							<a href="<c:out value='${content.eeMenuDocument.eeUrl}' />" target="_blank">
								<c:out value="${content.eeDescriptionEn}" />
							</a>
						</c:when>
						<c:otherwise>
							<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content.id.eeMenuContentId}' />', '<c:out value='${content.eeMenuDocument.eeDocumentId}' />')">
								<c:out value="${content.eeDescriptionEn}" />
							</a>
						</c:otherwise>
					</c:choose>
				</td>
				<td class="detailsCol" colspan="2" valign="top">
					<c:choose>
						<c:when test="${content.eeMenuDocument.eeIsUrl eq 'Y'}" >
							<a href="<c:out value='${content.eeMenuDocument.eeUrl}' />" target="_blank">
								<c:out value="${content.eeDescriptionZh}" />
							</a>
						</c:when>
						<c:otherwise>
							<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content.id.eeMenuContentId}' />', '<c:out value='${content.eeMenuDocument.eeDocumentId}' />')">
								<c:out value="${content.eeDescriptionZh}" />
							</a>
						</c:otherwise>
					</c:choose>
				</td>
					</c:when>
					<c:otherwise>
				<td class="detailsCol" colspan="2" valign="top"><c:out value="${content.eeDescriptionEn}" escapeXml="false" /></td>
				<td class="detailsCol" colspan="2" valign="top"><c:out value="${content.eeDescriptionZh}" escapeXml="false" /></td>
					</c:otherwise>
				</c:choose>
			</tr>

		<c:forEach var="descriptions" items="${content.inserviceContentDescriptionList}">
			<tr class="detailsRow" style="background: #<c:out value='${content.eeBgColor}' />">
				<td></td>
				<td id="descriptionsCol" colspan="4">
					<c:out value="${descriptions.eeDescriptionEn}" escapeXml="false" />
				</td>
			</tr>
		</c:forEach>

		<c:forEach var="i" begin="1" end="${content.maxNoOfVideoAndSlideList}">
			<tr id="fileRow" class="detailsRow" style="background: #<c:out value='${content.eeBgColor}' />">
				<td></td>
				<td id="videoCol" valign="top">
					<c:set var="subContent" value="${content.inserviceContentVideoList[i-1]}" />
					<c:choose>
						<c:when test="${subContent.eeMenuDocument != null}">
							<c:choose>
								<c:when test="${subContent.eeMenuDocument.eeIsUrl eq 'Y'}" >
									<a href="<c:out value='${subContent.eeMenuDocument.eeUrl}' />" target="_blank">
										<c:out value="${subContent.eeDescriptionEn}" />
									</a>
								</c:when>
								<c:otherwise>
									<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${subContent.id.eeMenuContentId}' />', '<c:out value='${subContent.eeMenuDocument.eeDocumentId}' />')">
										<c:out value="${subContent.eeDescriptionEn}" />
									</a>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:out value="${subContent.eeDescriptionEn}" />
						</c:otherwise>
					</c:choose>
				</td>

				<td id="slideCol" valign="top">
					<c:set var="subContent" value="${content.inserviceContentSlidesList[i-1]}" />
					<c:choose>
						<c:when test="${subContent.eeMenuDocument != null}">
							<c:choose>
								<c:when test="${subContent.eeMenuDocument.eeIsUrl eq 'Y'}" >
									<a href="<c:out value='${subContent.eeMenuDocument.eeUrl}' />" target="_blank">
										<c:out value="${subContent.eeDescriptionEn}" />
									</a>
								</c:when>
								<c:otherwise>
									<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${subContent.id.eeMenuContentId}' />', '<c:out value='${subContent.eeMenuDocument.eeDocumentId}' />')">
										<c:out value="${subContent.eeDescriptionEn}" />
									</a>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:out value="${subContent.eeDescriptionEn}" />
						</c:otherwise>
					</c:choose>
				</td>

				<td id="videoCol" valign="top">
				<c:set var="subContent" value="${content.inserviceContentVideoList[i-1]}" />
					<c:choose>
						<c:when test="${subContent.eeMenuDocument != null}">
							<c:choose>
								<c:when test="${subContent.eeMenuDocument.eeIsUrl eq 'Y'}" >
									<a href="<c:out value='${subContent.eeMenuDocument.eeUrl}' />" target="_blank">
										<c:out value="${subContent.eeDescriptionZh}" />
									</a>
								</c:when>
								<c:otherwise>
									<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${subContent.id.eeMenuContentId}' />', '<c:out value='${subContent.eeMenuDocument.eeDocumentId}' />')">
										<c:out value="${subContent.eeDescriptionZh}" />
									</a>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:out value="${subContent.eeDescriptionZh}" />
						</c:otherwise>
					</c:choose>
				</td>
				<td id="slideCol" valign="top">
					<c:set var="subContent" value="${content.inserviceContentSlidesList[i-1]}" />
					<c:choose>
						<c:when test="${subContent.eeMenuDocument != null}">
							<c:choose>
								<c:when test="${subContent.eeMenuDocument.eeIsUrl eq 'Y'}" >
									<a href="<c:out value='${subContent.eeMenuDocument.eeUrl}' />" target="_blank">
										<c:out value="${subContent.eeDescriptionZh}" />
									</a>
								</c:when>
								<c:otherwise>
									<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${subContent.id.eeMenuContentId}' />', '<c:out value='${subContent.eeMenuDocument.eeDocumentId}' />')">
										<c:out value="${subContent.eeDescriptionZh}" />
									</a>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:out value="${subContent.eeDescriptionZh}" />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:forEach>
	</c:forEach>
		</table>
			<div class="nav-footer">
				<a href="#"><bean:message key="button.backToTop" /></a>
			</div>
		</div>
	</div>
	<input type="hidden" name="documentID" />
	<input type="hidden" name="moduleCode" value="<c:out value='${education.moduleCode}' />" />
	<input type="hidden" name="keyID" />
</form>
</DIV>

</DIV></DIV>
<script language="javascript">
<!--
	function downloadDocument(keyID, documentID) {
		document.forms["form1"].action = "../documentManage/download.jsp";
		document.forms["form1"].elements["keyID"].value = keyID;
		document.forms["form1"].elements["documentID"].value = documentID;
		document.forms["form1"].submit();
		return false;
	}

	function submitAction(cmd, level) {
		var moduleCode = document.forms["form1"].elements["moduleCode"].value;
		callPopUpWindow("menu_list.htm?moduleCode=" + moduleCode + "&command=" + cmd + "&level=" + level);
		return false;
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>