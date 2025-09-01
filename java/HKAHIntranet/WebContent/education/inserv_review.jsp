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
	<c:redirect url="inserv_review.htm" />
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
#content { margin: 20px 0 0 0; }

#contentPage h4 { font-size: 120%; font-weight: bold; text-align: left; margin: 2px 0; }
#contentPage h5 { font-size: 120%; font-weight: bold; font-style: italic; margin: 2px 0; }

#categoryBox ul { list-style: none;	margin: 0 2px; }
#categoryBox ul li { margin: 5px 0; }
#categoryBox tr { vertical-align: top; padding: 10px 0; } 
#categoryBox td { padding: 2px; }
#categoryBox-column { float: left; display: inline; margin: 0 10px 0 0; }
#categoryBox-column a { color: #000000; text-decoration: none; }
#categoryBox-column a:hover { color: #000000; text-decoration: none; }
#categoryBox-column a:visited { color: #000000; text-decoration: none; }

ul.level1 li { list-style: none; }
ul.level1 h5 span { padding: 2px; }
ul.level2 { list-style: none;  margin-left: 20px; }
ul.level2 li { margin: 5px 0; }
ul.level3 { list-style: none;  margin: 0 10px 10px 20px; }  	
ul.level3 li { margin: 5px 0; }
</style>

<font color="blue"><c:out value="${education.message}"/></font>
<font color="red"><c:out value="${education.errorMessage}"/></font>
<form name="form1" method="post">
	<div id="staffEducationWrapper">
		<div id="contentPage">
			
			<div id="breadcrumb">
				<a href="reminder.jsp"><bean:message key="label.staffEducation" /></a> -> <bean:message key="function.staffEducation.education.is_review" />
			</div>
			<h2><bean:message key="label.staffEducation" /></h2>
			<h3><bean:message key="function.staffEducation.education.is_review" /></h3>
			<c:if test="${education.userBean.educationManager}">
				<button onclick="return submitAction('update', 0);"><bean:message key="prompt.staffEducationUpdate" /></button>
			</c:if>
			<p>Most of the in-service education notes are available for staff to retrieve when missing to attend the in-service lecture or those would like to review them.</p>
			<div id="categoryBox">
				<h4>Category Code:</h4>
	<c:if test="${education.list != null}" >
		<c:set var="categoryCounter" value="0" />
		<c:forEach var="content" items="${education.list}">
			<c:if test="${categoryCounter % 20 == 0}" >
				<div id="categoryBox-column">
					<table border="0" cellpadding="0" cellspacing="0">
			</c:if>
					<c:if test="${content.eeMenuContentInservReview != null}" >
						<tr>
							<c:set var="styleBgColor" value="${content.eeMenuContentInservReview.bgColorStyle}" /> 
							<td class="catCode-column" style="<c:out value='${styleBgColor}' />">
								<c:if test="${content.eeMenuContentInservReview.eeCategoryCode eq 'MIE' || content.eeMenuContentInservReview.eeCategoryCode eq 'CE'}">								
								<div style="font-size: 120%;font-style: italic;font-weight: bold;text-decoration: underline;">
								</c:if>
									<c:choose>
										<c:when test="${content.eeMenuContentInservReview.eeCategoryCode == null}">
											&nbsp;
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${!empty content.childList}">
														<a href="#<c:out value='${content.id.eeMenuContentId}' />"><b><c:out value="${content.eeMenuContentInservReview.eeCategoryCode}" /></b></a>
												</c:when>
												<c:otherwise>
														<b><c:out value="${content.eeMenuContentInservReview.eeCategoryCode}" /></b>
												</c:otherwise>
											</c:choose>	
										</c:otherwise>
									</c:choose>
								<c:if test="${content.eeMenuContentInservReview.eeCategoryCode eq 'MIE'}">							
								</div>
								</c:if>
							</td>
							
					<c:choose>
						<c:when test="${content.eeMenuContentInservReview.eeCategoryCode eq 'MIE'}">
							<% // Hardcode the link to Mandatory In-service Education page %>
							<c:set var="styleBgColor" value="${content.eeMenuContentInservReview.bgColorStyle}" /> 
							<td style="<c:out value='${styleBgColor}' />">						
								<a style="text-decoration: underline;font-size: 120%;font-style: italic;font-weight: bold; href="mand_inserv_content.htm"><c:out value="${content.eeMenuContentInservReview.eeCategoryDescriptionEn}" /></a>							
							</td>
						</c:when>
						<c:when test="${!empty content.childList}">							
							<td style="<c:out value='${styleBgColor}' />">
								<a href="#<c:out value='${content.id.eeMenuContentId}' />">
									<c:out value="${content.eeMenuContentInservReview.eeCategoryDescriptionEn}" />
								</a>
							</td>
						</c:when>
						<c:otherwise>
							<td style="<c:out value='${styleBgColor}' />">
								<c:if test="${content.eeMenuContentInservReview.eeCategoryCode eq 'CE'}">								
								<div style="font-size: 120%;font-style: italic;font-weight: bold;text-decoration: underline;">
								</c:if>
								<c:out value="${content.eeMenuContentInservReview.eeCategoryDescriptionEn}" />
								<c:if test="${content.eeMenuContentInservReview.eeCategoryCode eq 'CE'}">								
								</div>
								</c:if>
							</td>
						</c:otherwise>
					</c:choose>	
								
							<c:set var="styleBgColor" value="" /> 
						</tr>
					</c:if>
			<c:if test="${categoryCounter % 20 == 19 || categoryCounter eq education.listSize - 1}" >
					</table>
				</div>
			</c:if>
			<c:set var="categoryCounter" value="${categoryCounter + 1}" />
		</c:forEach>
	</c:if>
			</div>
			<div class="clear"></div>
			<div id="content">
				<ul class="level1">
				<!--	Title level entries	 	-->
				<c:if test="${education.list != null}" >
					<c:forEach var="content" items="${education.list}">
						<c:if test="${!empty content.childList}">
							<li>
							<c:if test="${content.eeMenuContentInservReview != null}">
								<c:set var="styleBgColor" value="${content.eeMenuContentInservReview.bgColorStyle}" />	
								<span style="<c:out value='${styleBgColor}' />">
									<c:choose>
										<c:when test="${content.eeMenuDocument != null}">
											<c:choose>
												<c:when test="${content.eeMenuDocument.eeIsUrl eq 'Y'}" >
													<a href="<c:out value='${content.eeMenuDocument.eeUrl}' />" target="_blank">
												</c:when>
												<c:otherwise>
													<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content.id.eeMenuContentId}' />', '<c:out value='${content.eeMenuDocument.eeDocumentId}' />')">
												</c:otherwise>
											</c:choose>
														<h5>
															<c:out value="${content.eeMenuContentInservReview.eeCategoryCode}" />&nbsp;
															<c:out value="${content.eeMenuContentInservReview.eeCategoryDescriptionEn}" />
														</h5>
													</a>
										</c:when>
										<c:otherwise>
											<a name="<c:out value='${content.id.eeMenuContentId}' />">
												<h5>
													<c:choose>
														<c:when test="${content.id.eeMenuContentId eq '110' }">																	
															<a style="color:#0066aa;font-weight:bold;font-style: italic;" class="topstoryblue" href="javascript:downloadFile('423','/INFECTION CONTROL IN-SERVICE TRAINING/IC in-service training 2015.pps');">
																<c:out value="${content.eeMenuContentInservReview.eeCategoryCode}" />&nbsp;
																<c:out value="${content.eeMenuContentInservReview.eeCategoryDescriptionEn}" />
															</a>						
															<font style="font-weight:normal;font-size:80%"><c:out value="(Access IC in-service training presentation files by clicking this highlighted title)" /></font>				
														</c:when>
														<c:otherwise>
															<c:out value="${content.eeMenuContentInservReview.eeCategoryCode}" />&nbsp;
															<c:out value="${content.eeMenuContentInservReview.eeCategoryDescriptionEn}"/>
														</c:otherwise>
													</c:choose>					
												</h5>
											</a>
										</c:otherwise>
									</c:choose>
								</span>
							</c:if>
								<!--	2nd level entries	 	-->
								<c:if test="${!empty content.childList}" > 
									<ul class="level2">
									<c:forEach var="content2" items="${content.childList}">
										<li>
											<c:choose>
												<c:when test="${content2.eeMenuDocument != null}">
													<c:choose>
														<c:when test="${content2.eeMenuDocument.eeIsUrl eq 'Y'}" >
															<a href="<c:out value='${content2.eeMenuDocument.eeUrl}' />" target="_blank">
																<c:out value="${content2.eeDescriptionEn}" />
															</a>
														</c:when>
														<c:otherwise>
															<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content2.id.eeMenuContentId}' />', '<c:out value='${content2.eeMenuDocument.eeDocumentId}' />')">
																<c:out value="${content2.eeDescriptionEn}" />
															</a>
														</c:otherwise>
													</c:choose>
												</c:when>
												<c:otherwise>
													<c:out value="${content2.eeDescriptionEn}" />
												</c:otherwise>
											</c:choose>
											
											<!--	3rd level entries	 	-->
											<c:if test="${content2.childList != null}" > 
												<ul class="level3">
												<c:forEach var="content3" items="${content2.childList}">
													<li>
														<c:choose>
															<c:when test="${content3.eeMenuDocument != null}">
																<c:choose>
																	<c:when test="${content3.eeMenuDocument.eeIsUrl eq 'Y'}" >
																		<a href="<c:out value='${content3.eeMenuDocument.eeUrl}' />" target="_blank">
																			<c:out value="${content3.eeDescriptionEn}" />
																		</a>
																	</c:when>
																	<c:otherwise>
																		<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content3.id.eeMenuContentId}' />', '<c:out value='${content3.eeMenuDocument.eeDocumentId}' />')">
																			<c:out value="${content3.eeDescriptionEn}" />
																		</a>
																	</c:otherwise>
																</c:choose>
															</c:when>
															<c:otherwise>
																<c:out value="${content3.eeDescriptionEn}" />
															</c:otherwise>
														</c:choose>
													</li>
												</c:forEach>
												</ul>
											</c:if>
										</li>
									</c:forEach>
									</ul>
								</c:if>
							</li>
							<div class="nav-footer">
								<a href="#"><bean:message key="button.backToTop" /></a>
							</div>
						</c:if>
					</c:forEach>
				</c:if>
					</ul>
			</div>
		</div>
	</div>
	<input type="hidden" name="documentID" />
	<input type="hidden" name="moduleCode" value="<c:out value='${education.moduleCode}' />" />
	<input type="hidden" name="keyID" />
</form>
</div>
</div>
</div>
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