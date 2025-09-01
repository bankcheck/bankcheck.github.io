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

<!-- 
<c:if test="${document == null}">
	<c:redirect url="document_details.htm" />
</c:if>
-->

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<c:set var="documentID" value="${document.documentID}"/>
<jsp:useBean id="documentID" type="java.lang.String"/>
<c:set var="allowRemove" value="${document.allowRemove}"/>
<jsp:useBean id="allowRemove" type="java.lang.String"/>
<c:set var="title" value="${document.title}"/>
<jsp:useBean id="title" type="java.lang.String"/>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<c:set var="message" value="${document.message}" />
<jsp:useBean id="message" class="java.lang.String" />
<c:set var="errorMessage" value="${document.errorMessage}" />
<jsp:useBean id="errorMessage" class="java.lang.String" />
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<c:choose>
	<c:when test="${!document.createAction && document.coDocument == null}">
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
<form name="form1" id="form1" action="document_details.htm" enctype="multipart/form-data" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.document.description" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${document.createAction || document.updateAction}" > 
					<input type="text" name="documentDesc" value="<c:out value="${document.coDocument.coDescription}"/>" maxlength="100" size="100" />
				</c:when>
				<c:otherwise>
					<c:out value="${document.coDocument.coDescription}"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	
	<c:choose> 
		<c:when test="${!(document.createAction || document.updateAction)}" > 
			<tr class="smallText">
				<td class="infoLabel" width="30%"><bean:message key="prompt.document.name" /></td>
				<td class="infoData" width="70%">
					<c:choose>
						<c:when test="${document.coDocument.coLocationWithFilename eq 'N'}" > 
							<c:choose>
								<c:when test="${document.coDocument.subFileNames != null}" > 
									<c:forEach var="subFileName" items="${document.coDocument.subFileNames}">
										<a href="#" onclick="downloadFileWithFileName('<c:out value="${subFileName}" />')"><c:out value="${subFileName}" /></a><br />
									</c:forEach>
								</c:when>
								<c:otherwise>
									<bean:message key="prompt.document.noFile" />
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<a href="#" onclick="downloadDocument()"><c:out value="${document.coDocument.fileName}" /></a>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:when>
	</c:choose>
	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.document.location" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${document.createAction || document.updateAction}" > 
					<c:out value="${document.coDocument.filePath}" /><br />
					<table border="0">
						<tr>
							<td>
								<input type="radio" name="fileMethod" value="file1" 
										onclick="changeFilePrefixSuffixDisplayStyle('');" />
								<bean:message key="prompt.document.upload" />
							</td>
							<td>
								<input type="file" name="file1" size="50" maxlength="100" class="multi" onclick="autoCheckRadio(this)" onkeypress="autoCheckRadio(this)" /><br />
							</td>		
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>
								<c:if test="${document.isMultiFileUploaded && document.coDocument.subFileNames != null}" > 
									<c:forEach var="subFileName" items="${document.coDocument.subFileNames}">
										<c:out value="${subFileName}" /><br />
									</c:forEach>
								</c:if>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="fileMethod" value="filePath" 
										onclick="changeFilePrefixSuffixDisplayStyle('none');" 
										<c:if test='${document.isFilePathSpecified}'>checked="checked"</c:if> />
								<bean:message key="prompt.document.filePath" />
							</td>
							<td>
								<input type="text" name="filePath"
										value="<c:if test='${document.isFilePathSpecified}'><c:out value="${document.coDocument.coLocation}"/></c:if>"
										size="50" maxlength="200"
										onclick="autoCheckRadio(this)" onkeypress="autoCheckRadio(this)" />
							</td>						
						</tr>
						<tr>
							<td>
								<input type="radio" name="fileMethod" value="fileDirectory" 
										onclick="changeFilePrefixSuffixDisplayStyle('');" 
										<c:if test='${document.isDirectoryPathSpecified}'>checked="checked"</c:if>/>
								<bean:message key="prompt.document.directoryPath" />	
							</td>
							<td>
								<input type="text" name="fileDirectory" 
										value="<c:if test='${document.isDirectoryPathSpecified}'><c:out value="${document.coDocument.coLocation}"/></c:if>"
										size="50" maxlength="200" 
										onclick="autoCheckRadio(this)" onkeypress="autoCheckRadio(this)" />
							</td>						
						</tr>
					</table>
				</c:when>
				<c:otherwise>
					<c:out value="${document.coDocument.filePath}" />
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	
	<tr id="filePrefixRow" class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.document.filePrefix" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${document.createAction || document.updateAction}" >
					<input type="text" name="filePrefix" value="<c:out value="${document.coDocument.coFilePrefix}"/>" 
							size="25" maxlength="50" />
				</c:when>
				<c:otherwise>
					<c:out value="${document.coDocument.coFilePrefix}"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	
	<tr id="fileSuffixRow" class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.document.fileSuffix" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${document.createAction || document.updateAction}" >
					<input type="text" name="fileSuffix" value="<c:out value="${document.coDocument.coFileSuffix}"/>" 
							size="25" maxlength="50" />
				</c:when>
				<c:otherwise>
					<c:out value="${document.coDocument.coFileSuffix}"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
		
	<c:if test="${!document.createAction}" > 
		<tr class="smallText">
			<td class="infoLabel" width="30%"><bean:message key="prompt.modifiedDate" /></td>
			<td class="infoData" width="70%">
				<c:out value="${document.coDocument.coModifiedDateDisplay}"/>
			</td>
		</tr>
		
		<tr class="smallText">
			<td class="infoLabel" width="30%"><bean:message key="prompt.createdDate" /></td>
			<td class="infoData" width="70%">
				<c:out value="${document.coDocument.coCreatedDateDisplay}"/>
			</td>
		</tr>
	</c:if>
	
	<tr class="smallText">
		<td class="infoTitle" colspan="2"><bean:message key="prompt.access" /></td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.groups" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${document.createAction || document.updateAction}" > 
					<table border="0">
						<tr>
							<td><bean:message key="prompt.groupsAvailable" /></td>
							<td>&nbsp;</td>
							<td><bean:message key="prompt.groupsSelected" /></td>
						</tr>
						<tr>
							<td>
								<select name="groupIDAvailable" size="10" multiple id="groupIDSelect1">
								
									<c:forEach var="groupAvailable" varStatus="status"
											items="${requestScope.document.coGroupsList}">
										<c:set var="coGroupDescAvailableKey" value="${groupAvailable.coGroupDesc}"/>
										<jsp:useBean id="coGroupDescAvailableKey" type="java.lang.String"/>
											
										<option value="<c:out value="${groupAvailable.coGroupId}" />" >
											<c:catch var="noKeyException">
												<bean:message key="<%=coGroupDescAvailableKey %>" />
											</c:catch>
											<c:if test = "${noKeyException != null}">
												<c:out value="${groupAvailable.coGroupDesc}" />
											</c:if>
										</option>
									</c:forEach>
								
								</select>
								<div>
									<bean:message key="button.search" />:&nbsp;
									<input name="searchField1" onkeyup="myfilter1.set(this.value, event)" />
								</div>
							</td>
							<td>
								<button id="add"><bean:message key="button.add" /> &gt;&gt;</button><br />
								<button id="remove">&lt;&lt; <bean:message key="button.delete" /></button>
							</td>
							<td>
								<select name="groupID" size="10" multiple id="groupIDSelect2">
									<c:forEach var="groupSelected" varStatus="status"
											items="${requestScope.document.coGroupsSelectedList}">
										<c:set var="coGroupDescSelectedKey" value="${groupSelected.coGroupDesc}"/>
										<jsp:useBean id="coGroupDescSelectedKey" type="java.lang.String"/>
											
										<option value="<c:out value="${groupSelected.coGroupId}" />" >
											<c:catch var="noKeyException">
												<bean:message key="<%=coGroupDescSelectedKey %>" />
											</c:catch>
											<c:if test = "${noKeyException != null}">
												<c:out value="${groupSelected.coGroupDesc}" />
											</c:if>
										</option>
									</c:forEach>
								</select>
								<div>
									<bean:message key="button.search" />:&nbsp;
									<input name="searchField2" onkeyup="myfilter2.set(this.value, event)" />
								</div>
							</td>
						</tr>
					</table>
				</c:when>
				<c:otherwise>
					<c:forEach var="groupSelected" varStatus="status"
							items="${requestScope.document.coGroupsSelectedList}">
							
						<c:set var="coGroupDescKey" value="${groupSelected.coGroupDesc}"/>
						<jsp:useBean id="coGroupDescKey" type="java.lang.String"/>
							
						<c:catch var="noKeyException">
							<a href="access_control.jsp?command=view&userRoleID=<c:out value="${groupSelected.coGroupId}" />">
								<bean:message key="<%=coGroupDescKey %>" />
							</a>
							<br />
						</c:catch>
						<c:if test = "${noKeyException != null}">
							<a href="access_control.jsp?command=view&userRoleID=<c:out value="${groupSelected.coGroupId}" />">
								<c:out value="${groupSelected.coGroupDesc}" />
							</a>
							<br />
						</c:if>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.users" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${document.createAction || document.updateAction}" > 
					<table border="0">
						<tr>
							<td><bean:message key="prompt.usersAvailable" /></td>
							<td>&nbsp;</td>
							<td><bean:message key="prompt.usersSelected" /></td>
						</tr>
						<tr>
							<td>
								<select name="userIDAvailable" size="10" multiple id="userIDSelect1">
								
									<c:forEach var="userAvailable" varStatus="status"
											items="${requestScope.document.coUsersList}">
										<c:set var="coUsersDescAvailableKey" value="${userAvailable.nameDept}"/>
										<jsp:useBean id="coUsersDescAvailableKey" type="java.lang.String"/>
											
										<option value="<c:out value="${userAvailable.coStaffId}" />" >
											<c:catch var="noKeyException">
												<bean:message key="<%=coUsersDescAvailableKey %>" />
											</c:catch>
											<c:if test = "${noKeyException != null}">
												<c:out value="${userAvailable.nameDept}" />
											</c:if>
										</option>
									</c:forEach>
								
								</select>
								<div>
									<bean:message key="button.search" />:&nbsp;
									<input name="searchFieldUser1" onkeyup="myfilterUser1.set(this.value, event)" />
								</div>
							</td>
							<td>
								<button id="add2"><bean:message key="button.add" /> &gt;&gt;</button><br />
								<button id="remove2">&lt;&lt; <bean:message key="button.delete" /></button>
							</td>
							<td>
								<select name="userID" size="10" multiple id="userIDSelect2">
									<c:forEach var="userSelected" varStatus="status"
											items="${requestScope.document.coUsersSelectedList}">
										<c:set var="coUsersDescSelectedKey" value="${userSelected.nameDept}"/>
										<jsp:useBean id="coUsersDescSelectedKey" type="java.lang.String"/>
											
										<option value="<c:out value="${userSelected.coStaffId}" />" >
											<c:catch var="noKeyException">
												<bean:message key="<%=coUsersDescSelectedKey %>" />
											</c:catch>
											<c:if test = "${noKeyException != null}">
												<c:out value="${userSelected.nameDept}" />
											</c:if>
										</option>
									</c:forEach>
								</select>
								<div>
									<bean:message key="button.search" />:&nbsp;
									<input name="searchFieldUser2" onkeyup="myfilterUser2.set(this.value, event)" />
								</div>
							</td>
						</tr>
					</table>
				</c:when>
				<c:otherwise>
					<c:forEach var="userSelected" varStatus="status"
							items="${requestScope.document.coUsersSelectedList}">
							
						<c:set var="coUsersDescKey" value="${userSelected.nameDept}"/>
						<jsp:useBean id="coUsersDescKey" type="java.lang.String"/>
							
						<c:catch var="noKeyException">
							<bean:message key="<%=coUsersDescKey %>" />
							<br />
						</c:catch>
						<c:if test = "${noKeyException != null}">
							<c:out value="${userSelected.nameDept}" />
							<br />
						</c:if>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
</table>

<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
				<c:choose>
					<c:when test="${document.createAction || document.updateAction || document.deleteAction}" >
						<button onclick="return submitAction('<c:out value="${document.commandType}"/>', 1, 0);" class="btn-click">
							<bean:message key="button.save" /> - <bean:message key="<%=title %>" />
						</button>
						<button onclick="return submitAction('view', 0, 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
					</c:when>
					<c:otherwise>
						<button onclick="return submitAction('update', 0, 0);" class="btn-click"><bean:message key="function.document.update" /></button>
						<button class="btn-delete-document"><bean:message key="function.document.delete" /></button>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</table>
</div>

<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="documentID" value="<c:out value="${document.coDocument.coDocumentId}" />" />
<input type="hidden" name="fileName" />
<input type="hidden" name="seq" />
<c:if test="${document.isMultiFileUploaded}">
	<input type="hidden" name="isMultiFileInWebFolder" value="Y" />
</c:if>
</form>
<script type="text/javascript" src="<html:rewrite page="/js/filterlist.js" />"></script> 
<script language="javascript">
<!--
	var myfilter1 = new filterlist(document.forms['form1'].elements['groupIDAvailable'], document.forms['form1'].elements['searchField1']);
	var myfilter2 = new filterlist(document.forms['form1'].elements['groupID'], document.forms['form1'].elements['searchField2']);
	
	var myfilterUser1 = new filterlist(document.forms['form1'].elements['userIDAvailable'], document.forms['form1'].elements['searchFieldUser1']);
	var myfilterUser2 = new filterlist(document.forms['form1'].elements['userID'], document.forms['form1'].elements['searchFieldUser2']);
	
	$().ready(function() {
		$(".pane .btn-delete-document").click(function(){
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
		$('#add').click(function() {
			return !$('#groupIDSelect1 option:selected').appendTo('#groupIDSelect2');
		});
		$('#remove').click(function() {
			return !$('#groupIDSelect2 option:selected').appendTo('#groupIDSelect1');
		});
		
		$('#add2').click(function() {
			return !$('#userIDSelect1 option:selected').appendTo('#userIDSelect2');
		});
		$('#remove2').click(function() {
			return !$('#userIDSelect2 option:selected').appendTo('#userIDSelect1');
		});
	});
	
	$('form1').submit(function() {
		$('#groupIDSelect2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
			
		$('#userIDSelect2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
	});
	
	function submitAction(cmd, stp, seq) {
		if (stp == 1) {
			if (cmd == 'create' || cmd == 'update') {
				if (document.forms['form1'].elements['documentDesc'].value == '') {
					document.forms['form1'].elements['documentDesc'].focus();
					alert('<bean:message key="error.documentDesc.required" />!');
					return false;
				}
				
				var checkedRadio = getCheckedRadio();
				var checkedRadioObj = document.forms['form1'].elements[checkedRadio];
				if (checkedRadioObj) {
					var locationValue = checkedRadioObj.value;
					if (checkedRadio != 'file1' && locationValue == '') {
						checkedRadioObj.focus();
						if (checkedRadio == 'filePath') {
							alert('<bean:message key="error.filePath.required" />!');
						} else if (checkedRadio == 'fileDirectory') {
							alert('<bean:message key="error.fileDirectory.required" />!');
						}
						return false;
					}
				}
			} 
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		
		<c:if test="${document.createAction || document.updateAction}">
			selectItem('form1', 'groupID');
			selectItem('form1', 'userID');
		</c:if>

		document.form1.submit();
	}
	
	function getCheckedRadio() {
		var fileMethod = document.forms["form1"].elements["fileMethod"];
		for (var i=0; i < fileMethod.length; i++) {
		   if (fileMethod[i].checked) {
		      return fileMethod[i].value;
		   }
		}
		return null;
	}

	
	
	function autoCheckRadio(inputObj) {
		var fileMethod = document.forms["form1"].elements["fileMethod"];
		
		if (fileMethod && inputObj) {
			if (inputObj.name == "file1") {
				for (var i = 0; i < fileMethod.length; i++) {
					if (fileMethod[i].value == "file1")
						fileMethod[i].checked = true;
				}
				changeFilePrefixSuffixDisplayStyle("");
			}
			else if (inputObj.name == "filePath") {
				for (var i = 0; i < fileMethod.length; i++) {
					if (fileMethod[i].value == "filePath")
						fileMethod[i].checked = true;
				}
				changeFilePrefixSuffixDisplayStyle("none");
			}
			else if (inputObj.name == "fileDirectory") {
				for (var i = 0; i < fileMethod.length; i++) {
					if (fileMethod[i].value == "fileDirectory") {
						fileMethod[i].checked = true;
					}
				}
				changeFilePrefixSuffixDisplayStyle("");
			}
		}
	}
	
	function changeFilePrefixSuffixDisplayStyle(style) {
		var filePrefixRow = document.getElementById("filePrefixRow");
		var fileSuffixRow = document.getElementById("fileSuffixRow");
		if (filePrefixRow) {
			filePrefixRow.style.display = style;
		}
		if (fileSuffixRow) {
			fileSuffixRow.style.display = style;
		}
	}
	
	<c:if test="${document.isFilePathSpecified}">
		changeFilePrefixSuffixDisplayStyle("none");
	</c:if>
	
	<c:if test="${document.createAction || document.updateAction}">
		removeDuplicateItem('form1', 'groupIDAvailable', 'groupID');
		removeDuplicateItem('form1', 'userIDAvailable', 'userID');
	</c:if>
		
	function downloadFileWithFileName(fileName) {
		document.form1.action = "../documentManage/download.jsp?fileName=/" + fileName;
		document.form1.submit();
		
		// restore action url
		document.form1.action = "document_details.htm";
	}
	
	function downloadDocument() {
		document.form1.action = "../documentManage/download.jsp";
		document.form1.submit();
		
		// restore action url
		document.form1.action = "document_details.htm";
	}

-->
</script>
<style>
	.fileDirectoryOption { text-align: right; }
</style>
	</c:otherwise>
</c:choose>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>