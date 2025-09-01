<%@ page import="com.hkah.web.db.helper.*" %>
<%@ page import="com.hkah.web.db.hibernate.*"%>
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

<c:if test="${education == null}">
	<c:redirect url="menu_details.htm" />
</c:if>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<c:if test="${education.closeAction}">
		<script type="text/javascript">window.close();</script>
	</c:if>
	<body>
	<jsp:include page="../common/banner2.jsp"/>
		<div id=indexWrapper>
			<div id=mainFrame>
				<div id=contentFrame>
					<c:set var="pageSubTitle" value="function.staffEducation.${education.moduleCode}" scope="request" />
					<jsp:include page="../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="function.staffEducation" />
						<jsp:param name="pageSubTitle" value='<%=request.getAttribute("pageSubTitle") %>' />
					</jsp:include>
					<c:set var="message" value="${education.message}" />
					<jsp:useBean id="message" class="java.lang.String" />
					<c:set var="errorMessage" value="${education.errorMessage}" />
					<jsp:useBean id="errorMessage" class="java.lang.String" />
					<jsp:include page="../common/message.jsp" flush="false">
						<jsp:param name="message" value="<%=message %>" />
						<jsp:param name="errorMessage" value="<%=errorMessage %>" />
					</jsp:include>
					
					<c:set var="moduleCode" value="${education.moduleCode}" />
					<jsp:useBean id="moduleCode" class="java.lang.String" />
					<c:set var="level" value="${education.level}" />
					<jsp:useBean id="level" class="java.lang.String" />
					<c:set var="eeMenuContent" value="${education.eeMenuContent}" />
					<jsp:useBean id="eeMenuContent" class="com.hkah.web.db.hibernate.EeMenuContent" />
					
					
					<c:choose>
						<c:when test="${!education.createAction && education.eeMenuContent == null}">
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
							<form name="form1" id="form1" action="menu_details.htm" enctype="multipart/form-data" method="post">
							<table cellpadding="0" cellspacing="5"
								class="contentFrameMenu" border="0">
							<%
								/*
									Support special handling for different module: 
									- Mandatory In-service Education: Content
								*/
							%> 
							<c:if test="${education.isModuleCodeIsContent && (education.level eq 0 || education.level eq 1)}">
								<tr class="smallText">
									<td class="infoLabel" width="30%"><bean:message key="prompt.type" /></td>
									<td class="infoData" width="70%">
										<c:choose> 
											<c:when test="${education.createAction || education.updateAction ||education.updateReviewAction||education.updateReviewAction}" > 
												<select name="eeType">
													<jsp:include page="../ui/staffEducationContentTypeCMB.jsp" flush="false">
														<jsp:param name="moduleCode" value="<%=moduleCode %>" />
														<jsp:param name="level" value="<%=level %>" />
														<jsp:param name="eeType" value="<%=eeMenuContent.getEeType() %>" />
														<jsp:param name="allowEmpty" value="N" />
													</jsp:include>
												</select>
											</c:when>
											<c:otherwise>
												<%=StaffEducationModelHelper.getEeTypes(moduleCode, level).get(eeMenuContent.getEeType()) %>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</c:if>
								
								<tr class="smallText">
									<td class="infoLabel" width="30%"><bean:message key="prompt.description" />/ <bean:message key="prompt.title" /> (English)</td>
									<td class="infoData" width="70%">
										<c:choose> 
											<c:when test="${education.createAction || education.updateAction ||education.updateReviewAction||updateReviewAction}" > 
											  <c:choose>
												  <c:when test="${(education.isModuleCodeIsReview && education.level eq 0)}">
													<input type="text" name="eeDescriptionEn" value="<c:out value="${education.eeMenuContent.eeMenuContentInservReview.eeCategoryDescriptionEn}"/>" maxlength="200" size="100" />
												  </c:when>
													<c:otherwise>
														<input type="text" name="eeDescriptionEn" value="<c:out value="${education.eeMenuContent.eeDescriptionEn}"/>" maxlength="200" size="100" />											
													</c:otherwise>
											  </c:choose>											  
											</c:when>
											<c:otherwise>	
											  <c:choose>
												  <c:when test="${(education.isModuleCodeIsReview && education.level eq 0)}">
													<c:out value="${education.eeMenuContent.eeMenuContentInservReview.eeCategoryDescriptionEn}"/>
												  </c:when>
												  <c:otherwise>			  											  
											  		<c:out value="${education.eeMenuContent.eeDescriptionEn}"/>											  		
												  </c:otherwise>
											  </c:choose>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr class="smallText">
									<td class="infoLabel" width="30%"><bean:message key="prompt.description" />/ <bean:message key="prompt.title" /> (Chinese)</td>
									<td class="infoData" width="70%">
										<c:choose> 
											<c:when test="${education.createAction || education.updateAction ||education.updateReviewAction||updateReviewAction}" > 
												<input type="text" name="eeDescriptionZh" value="<c:out value="${education.eeMenuContent.eeDescriptionZh}"/>" maxlength="200" size="100" />
											</c:when>
											<c:otherwise>
											<c:choose>
												  <c:when test="${(education.isModuleCodeIsReview && education.level eq 0)}">
													<c:out value="${education.eeMenuContent.eeMenuContentInservReview.eeCategoryDescriptionZh}"/>
												  </c:when>
												  <c:otherwise>			  											  
											  		<c:out value="${education.eeMenuContent.eeDescriptionZh}"/>											  		
												  </c:otherwise>
											  </c:choose>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								
								<!-- Upload document/ External link -->
								<tr class="smallText">
									<td class="infoLabel" width="30%"><bean:message key="prompt.document" /></td>
									<td class="infoData" width="70%">
									
										<c:choose>
											<c:when test="${education.createAction || education.updateAction||updateReviewAction}" > 
												<c:if test="${education.eeMenuContent.eeMenuDocument.eeDocumentId != null}">
													<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${education.eeMenuContent.id.eeMenuContentId}' />', '<c:out value='${education.eeMenuContent.eeMenuDocument.eeDocumentId}' />')">
														<c:out value="${education.eeMenuContent.eeMenuDocument.documentDesc}" />
													</a><br />
												</c:if>
												<table border="0">
													<tr>
														<td>
															<input type="radio" name="fileMethod" value="file1" />
															<bean:message key="prompt.uploadFile" />
														</td>
														<td>
															<input type="file" name="file1" size="50" maxlength="10" 
																	onclick="autoCheckRadio(this)" onkeypress="autoCheckRadio(this)" />
														</td>		
													</tr>
													<tr>
														<td colspan="2">
															(Files in local computer (e.g. C:\education.pdf))
														</td>
													</tr>
													<tr></tr>
													<tr>
														<td>
															<input type="radio" name="fileMethod" value="filePath" 
																	<c:if test='${education.eeMenuContent.eeMenuDocument.documentUrlFilePath}'>checked="checked"</c:if> />
															<bean:message key="prompt.document.filePath" />
														</td>
														<td>
															<input type="text" name="filePath"
																	value="<c:if test='${education.eeMenuContent.eeMenuDocument.documentUrlFilePath}'><c:out value="${education.eeMenuContent.eeMenuDocument.documentUrl}"/>\<c:out value="${education.eeMenuContent.eeMenuDocument.documentDesc}"/></c:if>"
																	size="50" maxlength="200"
																	onclick="autoCheckRadio(this)" onkeypress="autoCheckRadio(this)" />
														</td>						
													</tr>
													<tr>
														<td colspan="2">
															(Files located in file server (e.g. \\it-fs1\education.pdf))
														</td>
													</tr>
													<tr></tr>
													<tr>
														<td>
															<input type="radio" name="fileMethod" value="url" 
																	<c:if test='${education.eeMenuContent.eeMenuDocument.eeIsUrl eq "Y"}'>checked="checked"</c:if> />
															<bean:message key="prompt.url" />
														</td>
														<td>
															<input type="text" name="url"
																	value="<c:if test='${education.eeMenuContent.eeMenuDocument.eeIsUrl eq "Y"}'><c:out value="${education.eeMenuContent.eeMenuDocument.eeUrl}"/></c:if>"
																	size="50" maxlength="200"
																	onclick="autoCheckRadio(this)" onkeypress="autoCheckRadio(this)" />
														</td>						
													</tr>
													<tr>
														<td colspan="2">
															(Website (e.g. http://www.hkah.org.hk/))
														</td>
													</tr>
													<tr></tr>
													<tr>
														<td>
															<input type="radio" name="fileMethod" value="remove" />
															<bean:message key="prompt.noDocument" />
														</td>
														<td></td>						
													</tr>
												</table>
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${education.eeMenuContent.eeMenuDocument.eeIsUrl eq 'Y'}" >
														<a href="<c:out value='${education.eeMenuContent.eeMenuDocument.eeUrl}' />" target="_blank">
															<c:out value="${education.eeMenuContent.eeMenuDocument.eeUrl}" />
														</a><br />
													</c:when>
													<c:otherwise>
														<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${education.eeMenuContent.id.eeMenuContentId}' />', '<c:out value='${education.eeMenuContent.eeMenuDocument.eeDocumentId}' />')">
															<c:out value="${education.eeMenuContent.eeMenuDocument.documentDesc}" />
														</a><br />
													</c:otherwise>
												</c:choose>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								
							<%
								/*
									Support special handling for different module: 
									- Mandatory In-service Education: Content
								*/
							%> 
							<c:if test="${education.isModuleCodeIsContent && education.level eq 0}">
								<tr class="smallText">
									<td class="infoLabel" width="30%"><bean:message key="prompt.backgroundColor" /></td>
									<td class="infoData" width="70%">
										<c:choose> 
											<c:when test="${education.createAction || education.updateAction||education.updateReviewAction||updateReviewAction}" > 
												<table border="0">
													<tr>
														<td>
															<input type="radio" name="colorMethod" value="color" />
														</td>
														<td>
															<button id="colorSelector"><bean:message key="prompt.pickColor" />...</button>
															RGB: <input id="eeBgColor" name="eeBgColor" type="text" value="<c:out value='${education.eeMenuContent.eeBgColor}' />" maxlength="6" size="4" />
															<div id="colorDemo" style="background: #<c:out value='${education.eeMenuContent.eeBgColor}' />">&nbsp;</div>
														</td>		
													</tr>
													<tr>
														<td>
															<input type="radio" name="colorMethod" value="remove" <c:if test="${education.eeMenuContent.eeBgColor == null}">checked="checked"</c:if> />
														</td>
														<td><bean:message key="prompt.noBackgroundColor" /></td>						
													</tr>
												</table>
											
											</c:when>
											<c:otherwise>
												<c:if test="${education.eeMenuContent.eeBgColor != null}">
													<span style="width: 50%">RGB: <c:out value="${education.eeMenuContent.eeBgColor}" /></span>
													<div id="colorDemo" style="background: #<c:out value='${education.eeMenuContent.eeBgColor}' />">&nbsp;</div>
												</c:if>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</c:if>
							</table>
							
							<div class="pane">
								<table width="100%" border="0">
									<tr class="smallText">
										<td align="center">
											<c:choose>
												<c:when test="${education.createAction || education.updateReviewAction|| education.updateAction  || education.deleteAction}" >
													<c:choose>
														<c:when test="${education.updateReviewAction }">
															<button onclick="return submitAction('updateReview', 1, 0);" class="btn-click">
																<bean:message key="button.save" />
															</button>
															<button onclick="return submitAction('view', 0, 0);" class="btn-click"><bean:message key="button.cancel" /></button>															
														</c:when>
														<c:otherwise>	
															<button onclick="return submitAction('<c:out value="${education.commandType}"/>', 1, 0);" class="btn-click">
																<bean:message key="button.save" />
															</button>
															<button onclick="return submitAction('view', 0, 0);" class="btn-click"><bean:message key="button.cancel" /></button>
														</c:otherwise>
												    </c:choose>
												</c:when>
												<c:otherwise>
													<c:choose>
												  		<c:when test="${(education.isModuleCodeIsReview && education.level eq 0)}">
													    	<button onclick="return submitAction('updateReview', 0, 0);" class="btn-click"><bean:message key="function.staffEducation.update" /></button>													    													  		
													    </c:when>
													    <c:otherwise>
													    	<button onclick="return submitAction('update', 0, 0);" class="btn-click"><bean:message key="function.staffEducation.update" /></button>													    	
													    </c:otherwise>
													</c:choose>
													<button  onclick="return false;" class="btn-delete-staffEducation"><bean:message key="function.staffEducation.delete" /></button>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</table>
							</div>
							<input type="hidden" name="command" />
							<input type="hidden" name="moduleCode" value="<c:out value='${education.moduleCode}' />" />
							<input type="hidden" name="step" />
							<input type="hidden" name="level" value="<c:out value='${education.level}' />" />
							<input type="hidden" name="cid" value="<c:out value="${education.eeMenuContent.id.eeMenuContentId}" />" />
							<input type="hidden" name="parentCid" value="<c:out value="${education.parentCid}" />" />
							<input type="hidden" name="fileName" />
							<input type="hidden" name="seq" />
							<input type="hidden" name="keyID" />
							<input type="hidden" name="documentID" />
							</form>
							<script type="text/javascript" src="<html:rewrite page="/js/filterlist.js" />"></script> 
							<script language="javascript">
							<!--
								
								$().ready(function() {
									$(".pane .btn-delete-staffEducation").click(function(){
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
								
								$("#eeBgColor").change(function(){
									$('#colorDemo').css('backgroundColor', '#' + $("#eeBgColor").val());
								});
								
								$("#eeBgColor").click(function(){
									autoCheckRadio2();
								});
								
								$("#colorSelector").click(function(){
									autoCheckRadio2();
								});
								
								function autoCheckRadio2() {
									var colorMethod = document.forms["form1"].elements["colorMethod"];
									
									if (colorMethod) {
										for (var i = 0; i < colorMethod.length; i++) {
											if (colorMethod[i].value == "color")
												colorMethod[i].checked = true;
										}
									}
								}
								
								$('#colorSelector').ColorPicker({
									color: '#0000ff',
									onShow: function (colpkr) {
										$(colpkr).fadeIn(500);
										return false;
									},
									onHide: function (colpkr) {
										$(colpkr).fadeOut(500);
										return false;
									},
									onChange: function (hsb, hex, rgb) {
										$('#colorDemo').css('backgroundColor', '#' + hex);
										$("#eeBgColor").val(hex);
									}
								});
								
								function submitAction(cmd, stp, seq) {
									if (stp == 1) {
										if (cmd == 'create' || cmd == 'update') {
											if (document.forms['form1'].elements['eeDescriptionEn'].value == '') {
												document.forms['form1'].elements['eeDescriptionEn'].focus();
												alert('<bean:message key="error.documentDesc.required" />!');
												return false;
											}
										} 
									}
									
									document.forms["form1"].action = "menu_details.htm";
									document.forms["form1"].elements["command"].value = cmd;
									document.forms["form1"].elements["step"].value = stp;
									document.forms["form1"].submit();
								}
								
								function downloadDocument(keyID, documentID) {
									document.forms["form1"].action = "../documentManage/download.jsp";
									document.forms["form1"].elements["keyID"].value = keyID;
									document.forms["form1"].elements["documentID"].value = documentID;
									document.forms["form1"].submit();
									return false;
								}
								
								function autoCheckRadio(inputObj) {
									var fileMethod = document.forms["form1"].elements["fileMethod"];
									
									if (fileMethod && inputObj) {
										if (inputObj.name == "file1") {
											for (var i = 0; i < fileMethod.length; i++) {
												if (fileMethod[i].value == "file1")
													fileMethod[i].checked = true;
											}
										}
										else if (inputObj.name == "filePath") {
											for (var i = 0; i < fileMethod.length; i++) {
												if (fileMethod[i].value == "filePath")
													fileMethod[i].checked = true;
											}
										}
										else if (inputObj.name == "url") {
											for (var i = 0; i < fileMethod.length; i++) {
												if (fileMethod[i].value == "url")
													fileMethod[i].checked = true;
											}
										}
									}
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