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
.detailsCol { width: 35%; padding: 10px 15px; text-align:right;}

ul.level2 li {  padding: 0px 0px 10px 5px; }
.detailsRow span { margin: 0 0 0 10px; }
hr { height: 1px;color:black;background-color:black; }
.colorPink { color:#F0F }
.darkPink {color:#D60093}
</style>

<font color="blue"><c:out value="${education.message}"/></font>
<font color="red"><c:out value="${education.errorMessage}"/></font>

<form name="form1" method="post">
	<div id="staffEducationWrapper" >	
		<div id="contentPage">
			<c:if test="${education.userBean.educationManager}">
				<button onclick="return submitAction('update', 0);"><bean:message key="prompt.staffEducationUpdate" /></button>
			</c:if>	
			<table style="width:100%" cellspacing="0" cellpadding="0">
			<tr>
				<td style="BORDER-BOTTOM:black 1pt solid;BORDER-LEFT:medium none;WIDTH:100%;BORDER-TOP:black 1pt solid;BORDER-RIGHT:medium none;" valign="top">
					<div style='text-align:center;font-weight:bold; background-color:#FABF8F;'>
						<p style='text-weight:bold;'><font class='colorPink'>SMART</font> Strategic & Operation Plan</p>
						<p><font class='colorPink'>S</font>pecific (program)/ 
						   <font class='colorPink'>M</font>easureable (evaluation)/ 
						   <font class='colorPink'>A</font>chievement & 
						   <font class='colorPink'>R</font>ealistic (team-expense-action)/ 
						   <font class='colorPink'>T</font>imely (period)</p>			
					</div>
				</td>
			</tr>
			</table>	
		<table cellspacing="0" border="0" style="width: 100%;">
			<c:forEach var="content" items="${education.list}">
			<tr class="detailsRow" style="background: #<c:out value='${content.eeBgColor}' />">		
				<td class="detailsCol" colspan="2" valign="top">		
					<c:choose>
						<c:when test="${content.eeMenuDocument != null}">					
						<c:choose>
							<c:when test="${content.eeMenuDocument.eeIsUrl eq 'Y'}" >
								<a href="<c:out value='${content.eeMenuDocument.eeUrl}' />" target="_blank">
									<c:out value="${content.eeDescriptionEn}" escapeXml="false"  />
								</a>
							</c:when>
							<c:otherwise>
								<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content.id.eeMenuContentId}' />', '<c:out value='${content.eeMenuDocument.eeDocumentId}' />')">
									<c:out value="${content.eeDescriptionEn}" escapeXml="false"  />
								</a>
							</c:otherwise>
						</c:choose>				
						</c:when>
						<c:otherwise>				
							<c:out value="${content.eeDescriptionEn}" escapeXml="false" />
						</c:otherwise>
					</c:choose>
				</td>
				
				<td>
					<!--	2nd level entries	 	-->
					<c:if test="${content.childList != null}" > 
						<ul class="level2">
						<c:forEach var="content2" items="${content.childList}">
							<li>
								<c:choose>
									<c:when test="${content2.eeMenuDocument != null}">
										<c:choose>
											<c:when test="${content2.eeMenuDocument.eeIsUrl eq 'Y'}" >
												<a href="<c:out value='${content2.eeMenuDocument.eeUrl}' />" target="_blank">
													<c:out value="${content2.eeDescriptionEn}" escapeXml="false"  />
												</a>
											</c:when>
											<c:otherwise>
												<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${content2.id.eeMenuContentId}' />', '<c:out value='${content2.eeMenuDocument.eeDocumentId}' />')">
													<c:out value="${content2.eeDescriptionEn}" escapeXml="false"  />
												</a>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<c:out value="${content2.eeDescriptionEn}" escapeXml="false"  />
									</c:otherwise>
								</c:choose>
							</li>
						</c:forEach>
						</ul>
					</c:if>
				</td>
				
			</tr>
	</c:forEach>
		</table>		
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