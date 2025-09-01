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
	<c:redirect url="evidence_practice.htm" />
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
ul.level1 h4 { font-size: 140%; font-weight: bold; margin: 5px 0; }
ol.level2 { list-style: decimal inside;  margin-left: 20px; }
ol.level2 li { margin: 5px 0; }
ul.level3 { list-style: none;  margin: 0 10px 10px 20px; }  	
ul.level3 li { margin: 5px 0; }
</style>

<font color="blue"><c:out value="${education.message}"/></font>
<font color="red"><c:out value="${education.errorMessage}"/></font>
<div style='background-image: url(../images/pink_effect_fill.png);background-size:auto'>
<form name="form1" method="post">
	<table border="0" style="width:100%">
		<tr style="text-align: right;">
				<td colspan="2"><a  href="reminder.jsp"><b>Staff Education Home</b></a></td>
			</tr>
			<tr style="font-size:150%" bgcolor="rgb(216, 174, 91)">
				<td style="color:rgb(0, 51, 204)" colspan="2" class="bold">
					<%=pageTitle %>&nbsp;<c:out value="${education.eeMenuModule.eeDescriptionZh}"/>
				</td>
		</tr>	
		<tr ><td>
	<div id="staffEducationWrapper">
		<div id="contentPage">		
			<c:if test="${education.userBean.educationManager}">
				<button onclick="return submitAction('update', 0);"><bean:message key="prompt.staffEducationUpdate" /></button>
			</c:if>
			<p style="color:rgb(0, 51, 204)"><b>Different sources of professional healthcare information through internet links are available for staff to review, promote, manage and evaluate our clients' health status.</b></p>
			<div style="background-color:#FF69B4;">
			<ul class="level1">
		<!--	Title level entries	 	-->
		<c:if test="${education.list != null}" >
			<c:forEach var="content" items="${education.list}">
				<li>
					<c:choose>
						<c:when test="${content.eeMenuDocument != null}">
							<c:choose>
								<c:when test="${content.eeMenuDocument.eeIsUrl eq 'Y'}" >
									<a href="<c:out value='${content.eeMenuDocument.eeUrl}' />" target="_blank">
										<h4>
											<font style="color:rgb(0, 51, 204);"><c:out value="${content.eeDescriptionEn}" /></font>											
										</h4>										
									</a>
								</c:when>
								<c:otherwise>
									<c:choose>									
									   <c:when test="${content.eeType eq 'definition'}">   
									 	  <h4>
											<font style="color:rgb(0, 51, 204)"><c:out value="${content.eeDescriptionEn}" /></font>											
											<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content.id.eeMenuContentId}' />', '<c:out value='${content.eeMenuDocument.eeDocumentId}' />')">										
												<font color="white" style="font-weight:bold;">&nbsp;&nbsp;Definition</font>
											</a>
										</h4>
									   </c:when>
									  <c:otherwise> 
	   									<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content.id.eeMenuContentId}' />', '<c:out value='${content.eeMenuDocument.eeDocumentId}' />')">
											<h4>
												<font style="color:rgb(0, 51, 204)"><c:out value="${content.eeDescriptionEn}" /></font>	
											</h4>
										</a>
									  </c:otherwise>
								    </c:choose>								
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<h4><font style="color:rgb(0, 51, 204)"><c:out value="${content.eeDescriptionEn}" /></font></h4>
						</c:otherwise>
					</c:choose>
					
					<!--	2nd level entries	 	-->
					<c:if test="${content.childList != null}" > 
						<li class="level2">
						<c:forEach var="content2" items="${content.childList}">
							<li>
								<c:choose>
									<c:when test="${content2.eeMenuDocument != null}">
										<c:choose>
											<c:when test="${content2.eeMenuDocument.eeIsUrl eq 'Y'}" >
												<a href="<c:out value='${content2.eeMenuDocument.eeUrl}' />" target="_blank">
													<font color="white"><c:out value="${content2.eeDescriptionEn}" /></font>
												</a>
											</c:when>
											<c:otherwise>
												<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content2.id.eeMenuContentId}' />', '<c:out value='${content2.eeMenuDocument.eeDocumentId}' />')">
													<font color="white"><c:out value="${content2.eeDescriptionEn}" /></font>
												</a>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<font color="white"><c:out value="${content2.eeDescriptionEn}" /></font>
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
																<font color="white"><c:out value="${content3.eeDescriptionEn}" /></font>
															</a>
														</c:when>
														<c:otherwise>
															<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content3.id.eeMenuContentId}' />', '<c:out value='${content3.eeMenuDocument.eeDocumentId}' />')">
																<font color="white"><c:out value="${content3.eeDescriptionEn}" /></font>
															</a>
														</c:otherwise>
													</c:choose>
												</c:when>
												<c:otherwise>
													<font color="white"><c:out value="${content3.eeDescriptionEn}" /></font>
												</c:otherwise>
											</c:choose>
										</li>
									</c:forEach>
									</ul>
								</c:if>
							</li>
						</c:forEach>
						</li>
					</c:if>
				</li>
			</c:forEach>
		</c:if>
			</ul>	
			</div>	
		</div>
	</div>
	<input type="hidden" name="documentID" />
	<input type="hidden" name="moduleCode" value="<c:out value='${education.moduleCode}' />" />
	<input type="hidden" name="keyID" />
	</td></tr></table>
</form>
<!-- 
<div style="margin: 10px 0;">
	<p class="mottoText">TWAH Staff Education</p>
	<p class="mottoText">AHHKLSA Health Education & Research</p>
</div>
 -->
</div>
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