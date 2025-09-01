<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*" %>
<%@ page import="com.hkah.web.common.*"%>
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<c:if test="${forwardScanning == null}">
	<c:redirect url="category_detail.htm" />
</c:if>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<c:if test="${forwardScanning.closeAction}">
		<script type="text/javascript">window.close();</script>
	</c:if>
	<body>
	<jsp:include page="../common/banner2.jsp"/>
		<div id=indexWrapper>
			<div id=mainFrame>
				<div id=contentFrame>
					<c:set var="pageTitle" value="${forwardScanning.pageTitle}" />
					<jsp:useBean id="pageTitle" class="java.lang.String" />
					<jsp:include page="../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="<%=pageTitle %>" />
					</jsp:include>
					<c:set var="message" value="${forwardScanning.message}" />
					<jsp:useBean id="message" class="java.lang.String" />
					<c:set var="errorMessage" value="${forwardScanning.errorMessage}" />
					<jsp:useBean id="errorMessage" class="java.lang.String" />
					<jsp:include page="../common/message.jsp" flush="false">
						<jsp:param name="message" value="<%=message %>" />
						<jsp:param name="errorMessage" value="<%=errorMessage %>" />
					</jsp:include>
					<c:set var="level" value="${forwardScanning.level}" />
					<jsp:useBean id="level" class="java.lang.String" />
					<c:set var="fsCategory" value="${forwardScanning.fsCategory}" />
					<jsp:useBean id="fsCategory" class="com.hkah.web.db.model.FsCategory" />
					
					<c:choose>
						<c:when test="${!forwardScanning.createAction && forwardScanning.fsCategory == null}">
							<div class="pane">
								<bean:message key="prompt.notExist" />
								<table width="100%" border="0">
									<tr class="smallText">
										<td align="center">
											<button onclick="window.close();" class="btn-click"><bean:message key="label.close" /></button>
										</td>
									</tr>
								</table>
							</div>
						</c:when>
						<c:otherwise>
							<form name="form1" id="form1" action="category_detail.htm" enctype="multipart/form-data" method="post">
								<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
									<tr class="smallText">
										<td class="infoLabel" width="30%"><bean:message key="prompt.description" />/ <bean:message key="prompt.title" /> (English)</td>
										<td class="infoData" width="70%">
											<c:choose> 
												<c:when test="${forwardScanning.createAction || forwardScanning.updateAction}" > 
													<input type="text" name="fsName" value="<c:out value="${forwardScanning.fsCategory.fsName}"/>" maxlength="400" size="150" />
												</c:when>
												<c:otherwise>
													<c:out value="${forwardScanning.fsCategory.fsName}"/>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									
									<tr class="smallText">
										<td class="infoLabel" width="30%">Dynamic Level<br />(according to "Admission Date" e.t.c)</td>
										<td class="infoData" width="70%">
											<c:choose> 
												<c:when test="${forwardScanning.createAction || forwardScanning.updateAction}" > 
													<input type="radio" name="fsIsMulti" value="Y"
															<c:if test='${forwardScanning.fsCategory.fsIsMulti eq "Y"}'>checked="checked"</c:if> />
													Yes 
													<input type="radio" name="fsIsMulti" value="N"
															<c:if test='${forwardScanning.fsCategory.fsIsMulti ne "Y"}'>checked="checked"</c:if> />
													No
												</c:when>
												<c:otherwise>
													<c:choose> 
														<c:when test="${forwardScanning.fsCategory.fsIsMulti eq 'Y'}" >
															Yes
														</c:when> 
														<c:otherwise>
															No
														</c:otherwise>
													</c:choose>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									
									<tr class="smallText" style="display:none;">
										<td class="infoLabel" width="30%"><bean:message key="prompt.description" />/ <bean:message key="prompt.title" /> (English)</td>
										<td class="infoData" width="70%">
											<input type="hidden" name="fsSeq" value="<c:out value="${forwardScanning.fsCategory.fsSeq}"/>"/>
										</td>
									</tr>
									
								</table>
								
								<div class="pane">
									<table width="100%" border="0">
										<tr class="smallText">
											<td align="center">
												<c:choose>
													<c:when test="${forwardScanning.createAction || forwardScanning.updateAction || forwardScanning.deleteAction}" >
														<button onclick="return submitAction('<c:out value="${forwardScanning.commandType}"/>', 1, 0);" class="btn-click">
															<bean:message key="button.save" />
														</button>
														<button onclick="return submitAction('view', 0, 0);" class="btn-click"><bean:message key="button.cancel" /></button>
													</c:when>
													<c:otherwise>
														<button onclick="return submitAction('update', 0, 0);" class="btn-click"><bean:message key="button.update" /></button>
														<button class="btn-delete-category"><bean:message key="button.delete" /></button>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
									</table>
								</div>
								<input type="hidden" name="command" />
								<input type="hidden" name="step" />
								<input type="hidden" name="level" value="<c:out value='${forwardScanning.level}' />" />
								<input type="hidden" name="cid" value="<c:out value="${forwardScanning.categoryId}" />" />
								<input type="hidden" name="parentCid" value="<c:out value="${forwardScanning.parentCid}" />" />
								<input type="hidden" name="seq" />
								<input type="hidden" name="moduleCode" value="<c:out value='${forwardScanning.moduleCode}' />" />
								<input type="hidden" name="keyID" />
								<input type="hidden" name="documentID" />
							</form>
							<script type="text/javascript" src="<html:rewrite page="/js/filterlist.js" />"></script> 
							<script language="javascript">
							<!--
								
								$().ready(function() {
									$(".pane .btn-delete-category").click(function(){
										$(this).parents(".pane").animate({ backgroundColor: "#fbc7c7" }, "fast")
										.animate({ backgroundColor: "#F9F3F7" }, "slow")
										$.prompt('<bean:message key="message.record.delete" />!',{
											buttons: { Ok: true, Cancel: false },
											callback: function(v,m,f){
												if (v){
													submit: submitAction('delete', 1, 0)
													return true;
												} else {
													return false;
												}
											},
											prefix:'cleanblue'
										});
									});
									
								});
								
								function submitAction(cmd, stp, seq) {
									if (stp == 1) {
										if (cmd == 'create' || cmd == 'update') {
											if (document.forms['form1'].elements['fsName'].value == '') {
												document.forms['form1'].elements['fsName'].focus();
												alert('<bean:message key="error.documentDesc.required" />!');
												return false;
											}
										} 
									}
									
									document.forms["form1"].action = "category_detail.htm";
									document.forms["form1"].elements["command"].value = cmd;
									document.forms["form1"].elements["step"].value = stp;
									document.forms["form1"].submit();
								}
							-->
							</script>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>