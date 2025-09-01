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
	<c:redirect url="hospital_policies.htm" />
</c:if>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
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
<style>
#contentPage ul { margin: 10px 0; }
#contentPage ul li { list-style: url("../images/tick2.gif") inside; margin: 5px 0; }
</style>

<font color="blue"><c:out value="${education.message}"/></font>
<font color="red"><c:out value="${education.errorMessage}"/></font>
<div style='background-image: url(../images/pink_effect_fill.png);background-size:auto'>
<form name="form1" method="post">
	<table border="0" style="width:100%">
	<tr style="text-align: right;">
			<td colspan="2"><a  href="reminder.jsp"><b>Staff Education Home</b></a></td>
		</tr>
		<tr style="font-size:150%" bgcolor="rgb(102, 255, 102)">
			<td style="color:rgb(0, 51, 204)" colspan="2" class="bold">
				<%=pageTitle %>&nbsp;<c:out value="${education.eeMenuModule.eeDescriptionZh}"/>
			</td>
	</tr>	
	<tr><td>
	<div style="width:100%" id="staffEducationWrapper">
		<div style="width:100%" id="contentPage">	
			<c:if test="${education.userBean.educationManager}">
				<button onclick="return submitAction('update', 0);"><bean:message key="prompt.staffEducationUpdate" /></button>
			</c:if>
			<p style="width:100%;font-size:150%;">Some relevant hospital policies of Staff Education available at TWAH Intranet are also displayed below as well for reference to facilitate professional development and training required by DoH & ACHS.</p>
			<ul>
		<c:if test="${education.list != null}" > 
			<c:forEach var="content" items="${education.list}">
				<li>
					<c:choose>
						<c:when test="${content.eeMenuDocument != null}">
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
						</c:when>
						<c:otherwise>
							<c:out value="${content.eeDescriptionEn}" />
						</c:otherwise>
					</c:choose>
				</li>
			</c:forEach>
		</c:if>
			</ul>		
		</div>
	</div>
	<input type="hidden" name="documentID" />
	<input type="hidden" name="moduleCode" value="<c:out value='${education.moduleCode}' />" />
	<input type="hidden" name="keyID" />
	</td></tr></table>
</form>
<div style="margin: 10px 0;">
	<p class="mottoText">Extending the Healing Ministry of Christ</p>
	<p class="mottoText">延續基督的醫治大能</p>
</div>
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