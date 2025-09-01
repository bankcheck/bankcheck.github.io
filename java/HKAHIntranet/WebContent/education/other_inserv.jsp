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
	<c:redirect url="other_inserv.htm" />
</c:if>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id="indexWrapper">
<div id="mainFrame">

<div id="contentFrame" style="width:100%">
<c:set var="pageTitle" value="${education.eeMenuModule.eeDescriptionEn}" />
<jsp:useBean id="pageTitle" class="java.lang.String" />
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="keepReferer" value="Y" />
</jsp:include>
<style>
h4 { font-size: 140%; font-weight: bold; margin: 5px 0; }
ul.level2 { list-style: none;  margin-left: 20px; }
ul.level2 li { margin: 5px 0; }
ul.level3 { list-style: none;  margin: 0 10px 10px 20px; }  	
ul.level3 li { margin: 5px 0; }
</style>

<font color="blue"><c:out value="${education.message}"/></font>
<font color="red"><c:out value="${education.errorMessage}"/></font>
<div style='background-image: url(../images/pink_effect_fill.png);background-size:auto;width:100%'>
<form name="form1" method="post" style="width:100%">
<table  cellpadding="0" cellspacing="0" class="contentFrameMenu" border="0" style="width:100%">
	<tr style="text-align: right;">
		<td colspan="2"><a  href="reminder.jsp"><b>Staff Education Home</b></a></td>
	</tr>
	<tr style="font-size:150%" bgcolor="rgb(204, 204, 255)">
		<td style="color:rgb(0, 51, 204)" colspan="2" class="bold">
			<%=pageTitle %>&nbsp;<c:out value="${education.eeMenuModule.eeDescriptionZh}"/>
		</td>
	</tr>
	<tr>
		<td>
			<div id="staffEducationWrapper" style="width:100%">
				<div id="contentPage" style="width:100%">
					<table cellpadding="0" cellspacing="0" class="contentFrameMenu" border="0" style="width:100%" class="level1">
					<c:if test="${education.userBean.educationManager}">
						<tr>
							<td colspan="2">
							<button onclick="return submitAction('update', 0);"><bean:message key="prompt.staffEducationUpdate" /></button>
							</td>
						</tr>
					</c:if>
					<c:if test="${education.list != null}" >
						<c:forEach var="content" items="${education.list}">
							<tr>
								<c:choose>
									<c:when test="${content.eeMenuDocument != null}">
										<c:choose>
											<c:when test="${content.eeMenuDocument.eeIsUrl eq 'Y'}" >
												<td>
													<h4>
														<c:out value="${content.eeDescriptionEn}" /> <c:out value="${content.eeDescriptionZh}" />
													</h4>
												</td> 
												<td>
													<button onclick="viewSlide('${content.eeMenuDocument.eeUrl}')">
														View the slides  参閱投影片
													</button>
												</td>
											</c:when>
											<c:otherwise>
												<td colspan="2">
													<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content.id.eeMenuContentId}' />', '<c:out value='${content.eeMenuDocument.eeDocumentId}' />')">
														<h4>
															<c:out value="${content.eeDescriptionEn}" />
														</h4>
													</a>
												</td>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<td colspan="2">
											<h4><c:out value="${content.eeDescriptionEn}" /></h4>
										</td>
									</c:otherwise>
								</c:choose>
							</tr>
						</c:forEach>
					</c:if>
					</table>
				</div>
			</div>
		</td>
	</tr>
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
	
	function viewSlide(url) {
		window.open(url, '_blank');
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>