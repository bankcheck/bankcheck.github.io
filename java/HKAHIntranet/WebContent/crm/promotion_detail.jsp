<%@ page import="com.hkah.web.db.hibernate.*"%>
<%@ page import="java.util.*" %>
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
<%
	Map crm = (HashMap) request.getAttribute("crm");
%>
<!--
<c:if test="${crm == null}">
	<c:redirect url="promotion_detail.htm" />
</c:if>
-->

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<c:set var="allowRemove" value="${crm.allowRemove}"/>
<jsp:useBean id="allowRemove" type="java.lang.String"/>
<c:set var="title" value="${crm.title}"/>



<jsp:useBean id="title" type="java.lang.String"/>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<c:set var="message" value="${crm.message}" />
<jsp:useBean id="message" class="java.lang.String" />
<c:set var="errorMessage" value="${crm.errorMessage}" />
<jsp:useBean id="errorMessage" class="java.lang.String" />
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<c:choose>
	<c:when test="${!crm.createAction && crm.coEvent == null}">
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
<form name="form1" id="form1" action="promotion_detail.htm" enctype="multipart/form-data" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.promotionName" /></td>
		<td class="infoData" width="70%">
			<c:choose>
				<c:when test="${crm.createAction || crm.updateAction}" >
					<input type="text" name="coEventDesc" value="<c:out value="${crm.coEvent.coEventDesc}"/>" maxlength="100" size="100" />
				</c:when>
				<c:otherwise>
					<c:out value="${crm.coEvent.coEventDesc}"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.intialDate" /></td>
		<td class="infoData" width="70%">
			<c:choose>
				<c:when test="${crm.createAction || crm.updateAction}" >
					<bean:message key="prompt.from" />
					<input type="text" name="crmInitialDateFm" id="crmInitialDateFm" class="datepickerfield" value="<c:out value='${crm.coEvent.crmPromotion.crmInitialDateFmDisplay}'/>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
					<bean:message key="prompt.to" />
					<input type="text" name="crmInitialDateTo" id="crmInitialDateTo" class="datepickerfield" value="<c:out value='${crm.coEvent.crmPromotion.crmInitialDateToDisplay}'/>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
				</c:when>
				<c:otherwise>
					<bean:message key="prompt.from" />
					<span class="dateHighlight"><c:out value="${crm.coEvent.crmPromotion.crmInitialDateFmDisplay}"/></span>
					<bean:message key="prompt.to" />
					<span class="dateHighlight"><c:out value="${crm.coEvent.crmPromotion.crmInitialDateToDisplay}"/></span>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department(s)" /></td>
		<td class="infoData" width="70%">
			<c:choose>
				<c:when test="${crm.createAction || crm.updateAction}" >
					<div id="crmDepartmentCell">
						<c:forEach var="department" items="${crm.coEvent.crmPromotion.crmPromotionDepartments}">
							<c:set var="departmentCode" value="${department.id.crmDepartmentCode}" />
							<jsp:useBean id="departmentCode" type="java.math.BigDecimal" />
							<p>
								<select name="crmDepartmentCode[]">
									<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
										<jsp:param name="deptCode" value="<%=departmentCode %>" />
									</jsp:include>
								</select>
								<a href="#" class="removeCrmDepartment"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
							</p>
						</c:forEach>
					</div>
					<a href="#" class="addCrmDepartment"><bean:message key="button.add" /></a>
				</c:when>
				<c:otherwise>
					<c:forEach var="department" items="${crm.coEvent.crmPromotion.crmPromotionDepartments}">
						<p><a href="#"><c:out value="${department.coDepartments.coDepartmentDesc}"/></a></p>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Client(s)</td>
		<td>
		<c:choose>
          <c:when test="${crm.createAction || crm.updateAction}" >
		<table border="0">
         <tr>
         <td>
		  <div id="crmClient">
		<jsp:include page="../ui/crmClientCMB.jsp" flush="false">
		<jsp:param name="start" value="1" />
		</jsp:include>
          </div>
          <c:set var="search_client" value=""/>
          <jsp:useBean id="search_client" type="java.lang.String" />
         <div><a href="#" class="prevCrmClient">prev</a>
         <a href="#" class="nextCrmClient">next</a>
		</div>
         <div>search: <input type="text" name="searchField1" id="searchField1" value=""/>
         <button onclick="return search_client();" class="btn-click">search</button>
         </div>
         </td>
         <td>
		<button id="add"><bean:message key="button.add" />&gt;&gt;</button><br />
		<button id="remove">&lt;&lt; <bean:message key="button.delete" /></button>
		</td>
		<td>
		<select name="selected_client[]" size="10" multiple id="selected_client">
		<c:forEach var="client" items="${crm.coEvent.crmPromotion.crmPromotionClient}">

			<option value="<c:out value="${client.id.crmClientId}" />" >
				<c:out value="${client.crmClient_DisplayName}" />
			</option>
			</c:forEach>
		</select>
		</td>
		 </tr>
		  </table>
		   </c:when>
		   <c:otherwise>
			<c:forEach var="client" items="${crm.coEvent.crmPromotion.crmPromotionClient}">
			<p><a href="#"><c:out value="${client.crmClient_DisplayName}"/></a></p>
			</c:forEach>
		   </c:otherwise>
		   </c:choose>
		  </td>
	</tr>


	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.target(s)" /></td>
		<td class="infoData" width="70%">
			<c:choose>
				<c:when test="${crm.createAction || crm.updateAction}" >
					<div id="crmTargetCell">
						<c:forEach var="target" items="${crm.coEvent.crmPromotion.crmPromotionTargets}">
							<c:set var="targetID" value="${target.id.crmTargetId}" />
							<jsp:useBean id="targetID" type="java.math.BigDecimal" />
							<p>
								<select name="crmTargetId[]">
									<jsp:include page="../ui/crmTargetIDCMB.jsp" flush="false">
										<jsp:param name="targetID" value="<%=targetID %>" />
									</jsp:include>
								</select>
								<a href="#" class="removeCrmTarget"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
							</p>
						</c:forEach>
						</div>
					<a href="#" class="addCrmTarget"><bean:message key="button.add" /></a>
				</c:when>
				<c:otherwise>
					<c:forEach var="target" items="${crm.coEvent.crmPromotion.crmPromotionTargets}">
						<p><a href="#"><c:out value="${target.crmTargetNameWithDescription}"/></a></p>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.remarks" /></td>
		<td class="infoData" width="70%">
			<c:choose>
				<c:when test="${crm.createAction || crm.updateAction}" >
					<div class="box"><textarea id="wysiwyg" name="crmPromoteRemarks" rows="5" cols="150"><c:out value="${crm.coEvent.crmPromotion.crmPromoteRemarks}"/></textarea></div>
				</c:when>
				<c:otherwise>
					<c:out value="${crm.coEvent.crmPromotion.crmPromoteRemarks}" escapeXml="false" />
				</c:otherwise>
			</c:choose>
		</td>
	</tr>

		<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.promotionDetails" /></td>
		<td class="infoData" width="70%">
			<c:forEach var="document" items="${crm.coEvent.crmPromotion.crmPromotionDocumentsDetail}">
				<div id="document<c:out value='${document.id.crmDocumentId}' />">
					<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${document.id.crmDocumentId}' />')"><c:out value="${document.coDocumentDesc}" /></a>
					<c:if test="${crm.createAction || crm.updateAction}" >
						<a href="#" class="removeCrmDepartment"></a>
						&nbsp;<a href="javascript:void(0);" onclick="removeDocument('<c:out value='${crm.moduleCodeDocument}' />', '<c:out value="${document.id.crmDocumentId}" />');"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
					</c:if>
				</div>
			</c:forEach>
			<c:if test="${crm.createAction || crm.updateAction}" >
				<input type="file" name="filePromotionDetail" size="50" class="multi" maxlength="10" />
			</c:if>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.promotionMaterials" /></td>
		<td class="infoData" width="70%">
			<c:forEach var="document" items="${crm.coEvent.crmPromotion.crmPromotionDocumentsMaterial}">
				<div id="document<c:out value='${document.id.crmDocumentId}' />">
					<a href="javascript:void(0);" onclick="return downloadDocument('<c:out value='${document.id.crmDocumentId}' />')"><c:out value="${document.coDocumentDesc}" /></a>
					<c:if test="${crm.createAction || crm.updateAction}" >
						<a href="#" class="removeCrmDepartment"></a>
						&nbsp;<a href="javascript:void(0);" onclick="removeDocument('<c:out value='${crm.moduleCodeDocument}' />', '<c:out value="${document.id.crmDocumentId}" />');"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
					</c:if>
				</div>
			</c:forEach>
			<c:if test="${crm.createAction || crm.updateAction}" >
				<input type="file" name="filePromotionMaterials" size="50" class="multi" maxlength="10" />
			</c:if>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.referenceCode" /></td>
		<td class="infoData" width="70%">
			<c:choose>
				<c:when test="${crm.createAction || crm.updateAction}" >
					<div>
						<c:forEach var="refCode" items="${crm.crmPromotionRefCodeList}">
							<input type="radio" name="crmRefTypeCode" value="<c:out value='${refCode.crmRefTypeCode}' />"
									<c:if test='${crm.coEvent.crmPromotion.crmPromotionRefCode.crmRefTypeCode eq refCode.crmRefTypeCode}'> checked="checked"</c:if> />
							<c:out value="${refCode.crmRefTypeDescription}" />
						</c:forEach>
						<input type="radio" name="crmRefTypeCode" value="none"
								<c:if test='${crm.coEvent.crmPromotion.crmPromotionRefCode.crmRefTypeCode == null}'> checked="checked"</c:if> />N/A
					</div>
					<input type="text" name="crmRefCode" value="<c:out value="${crm.coEvent.crmPromotion.crmRefCode}"/>" maxlength="50" size="50" />
				</c:when>
				<c:otherwise>
					<c:if test="${crm.coEvent.crmPromotion.crmPromotionRefCode.crmRefTypeDescription != null}">
						<c:out value="${crm.coEvent.crmPromotion.crmPromotionRefCode.crmRefTypeDescription}" />:
						<c:out value="${crm.coEvent.crmPromotion.crmRefCode}" />
					</c:if>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.furtherEnquiry" /></td>
		<td class="infoData" width="70%">
			<display:table id="rowFurtherEnquiry" name="requestScope.crm.coEvent.crmPromotion.crmPromotionEnquiries"
					class="tablesorter" style="width: 500px">
				<display:setProperty name="basic.empty.showtable" value="true" />
				<display:setProperty name="basic.msg.empty_list_row" value="" />
				<display:column title="&nbsp;" media="html" style="width:5%"><c:out value="${rowFurtherEnquiry_rowNum}"/>)</display:column>
				<display:column titleKey="prompt.detail" style="width:60%">
					<c:choose>
						<c:when test="${crm.createAction || crm.updateAction}" >
							<input type="text" name="crmEnquiry[]" id="crmEnquiry" value="<c:out value="${rowFurtherEnquiry.crmEnquiry}"/>" maxlength="50" size="60" />
						</c:when>
						<c:otherwise>
							<c:out value="${rowFurtherEnquiry.crmEnquiry}" />
						</c:otherwise>
					</c:choose>
				</display:column>
				<display:column titleKey="prompt.phoneNoOrExt" style="width:30%">
					<c:choose>
						<c:when test="${crm.createAction || crm.updateAction}" >
							<input type="text" name="crmPhone[]" id="crmPhone" value="<c:out value="${rowFurtherEnquiry.crmPhone}"/>" maxlength="50" size="10" />
						</c:when>
						<c:otherwise>
							<c:out value="${rowFurtherEnquiry.crmPhone}" />
						</c:otherwise>
					</c:choose>
				</display:column>
				<c:if test="${crm.createAction || crm.updateAction}" >
					<display:column title="&nbsp;" media="html" style="width:5%">
						<a href="#" class="removeCrmEnquiry"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
					</display:column>
				</c:if>
			</display:table>
			<c:if test="${crm.createAction || crm.updateAction}" >
				<a href="#" class="addCrmEnquiry"><bean:message key="button.add" /></a>
			</c:if>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.cashierInstruction" /></td>
		<td class="infoData" width="70%">
			<display:table id="rowInstruction" name="requestScope.crm.coEvent.crmPromotion.crmPromotionInstructions"
					class="tablesorter" style="width: 500px">
				<display:setProperty name="basic.empty.showtable" value="true" />
				<display:setProperty name="basic.msg.empty_list_row" value="" />
				<display:column title="&nbsp;" media="html" style="width:5%"><c:out value="${rowInstruction_rowNum}"/>)</display:column>
				<display:column titleKey="prompt.code" style="width:30%">
					<c:choose>
						<c:when test="${crm.createAction || crm.updateAction}" >
							<input type="text" name="crmPromoInstrCode[]" id="crmPromoInstrCode" value="<c:out value="${rowInstruction.crmPromoInstrCode}"/>" maxlength="20" size="20" />
						</c:when>
						<c:otherwise>
							<c:out value="${rowInstruction.crmPromoInstrCode}" />
						</c:otherwise>
					</c:choose>
				</display:column>
				<display:column titleKey="prompt.remarks" style="width:60%">
					<c:choose>
						<c:when test="${crm.createAction || crm.updateAction}" >
							<input type="text" name="crmPromoInstrRemarks[]" id="crmPromoInstrRemarks" value="<c:out value="${rowInstruction.crmPromoInstrRemarks}"/>" maxlength="100" size="60" />
						</c:when>
						<c:otherwise>
							<c:out value="${rowInstruction.crmPromoInstrRemarks}" />
						</c:otherwise>
					</c:choose>
				</display:column>
				<c:if test="${crm.createAction || crm.updateAction}" >
					<display:column title="&nbsp;" media="html" style="width:5%">
						<a href="#" class="removeCrmInstruction"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
					</display:column>
				</c:if>
			</display:table>
			<c:if test="${crm.createAction || crm.updateAction}" >
				<a href="#" class="addCrmInstruction"><bean:message key="button.add" /></a>
			</c:if>
		</td>
	</tr>

</table>

<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
				<c:choose>
					<c:when test="${crm.createAction || crm.updateAction || crm.deleteAction}" >
						<button onclick="return submitAction('<c:out value="${crm.commandType}"/>', 1, 0);" class="btn-click">
							<bean:message key="button.save" /> - <bean:message key="<%=title %>" />
						</button>
						<button onclick="return submitAction('view', 0, 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
					</c:when>
					<c:otherwise>
						<button onclick="return submitAction('update', 0, 0);" class="btn-click"><bean:message key="function.promotion.update" /></button>
						<button class="btn-delete"><bean:message key="function.promotion.delete" /></button>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="eventID" value="<c:out value="${crm.coEvent.id.coEventId}" />" />
<input type="hidden" name="keyID" value="<c:out value="${crm.coEvent.id.coEventId}" />" />
<input type="hidden" name="moduleCode" value="<c:out value="${crm.moduleCode}" />" />
<input type="hidden" name="documentID" />

</form>
<bean:define id="loginIDLabel"><bean:message key="prompt.loginID" /></bean:define>
<script language="javascript">
<!--

	var http = createRequestObject();

	$().ready(function(){
		// Crm Department
		$('a.addCrmDepartment').click(function() {
	    	var crmDepartmentSelect = $('div#hiddenCrmDepartmentSelect').html();
	        $(crmDepartmentSelect).appendTo('#crmDepartmentCell');

	        $('a.removeCrmDepartment').click(function() {
	    		$(this).parent().remove();
	    	});
	    });
	    $('a.removeCrmDepartment').click(function() {
	    	$(this).parent().remove();
	    });

	    $('a.nextCrmClient').click(function() {

	      http.open('post', '../ui/crmClientCMB.jsp?start='+document.form1.startvalue.value);

	      http.onreadystatechange = processResponse;

	      http.send(null);


	    });

	    $('a.prevCrmClient').click(function() {
	      if(document.form1.backvalue.value >25){
	     document.form1.backvalue.value = document.form1.backvalue.value -25;
	      http.open('post', '../ui/crmClientCMB.jsp?start='+document.form1.backvalue.value);
	      }

	      http.onreadystatechange = processResponse;

	      http.send(null);


	    });

		// Crm Target
		$('a.addCrmTarget').click(function() {
	    	var crmTargetSelect = $('div#hiddenCrmTargetSelect').html();
	        $(crmTargetSelect).appendTo('#crmTargetCell');

	        $('a.removeCrmTarget').click(function() {
	    		$(this).parent().remove();
	    	});
	    });
	    $('a.removeCrmTarget').click(function() {
	    	$(this).parent().remove();
	    });

	   	// Crm Enquiry
		$('a.addCrmEnquiry').click(function() {
	    	var crmEnquiryRow = $('div#hiddenCrmEnquiryRow').html();
	        $(crmEnquiryRow).appendTo('#rowFurtherEnquiry');

	        $('a.removeCrmEnquiry').click(function() {
	    		$(this).parent().parent().remove();
	    	});
	    });
	    $('a.removeCrmEnquiry').click(function() {
	    	$(this).parent().parent().remove();
	    });

	   	// Crm Instruction
		$('a.addCrmInstruction').click(function() {
	    	var crmInstructionRow = $('div#hiddenCrmInstructionRow').html();
	        $(crmInstructionRow).appendTo('#rowInstruction');

	        $('a.removeCrmInstruction').click(function() {
	    		$(this).parent().parent().remove();
	    	});
	    });
	    $('a.removeCrmInstruction').click(function() {
	    	$(this).parent().parent().remove();
	    });

	    $('#add').click(function() {
			return !$('#clientSelect option:selected').appendTo('#selected_client');
		});
		$('#remove').click(function() {
			return !$('#selected_client option:selected').appendTo('#clientSelect');
		});

	});

	// validate form
<%
	if ((Boolean) crm.get("createAction") || (Boolean) crm.get("updateAction")){
%>
	$("#form1").validate({
		rules: {
			coEventDesc: { required: true }
		},
		messages: {
			coEventDesc: { required: "<bean:message key="error.promotionName.required" />" }
		}
	});
<%}%>

	function search_client(){
		  http.open('post', '../ui/crmClientCMB.jsp?search='+ encodeURIComponent(document.form1.searchField1.value) + '&start=0');
	      http.onreadystatechange = processResponse;

	      http.send(null);
		     return false;

	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			document.getElementById("crmClient").innerHTML = http.responseText;

		}
	}

	function submitAction(cmd, stp, seq) {
		if (stp == 1) {
			if (cmd == 'create' || cmd == 'update') {
				// validation
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;

		$('#selected_client option').each(function(i) {
			$(this).attr("selected", "selected");
		});

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

	function downloadDocument(did) {
		document.form1.action = "../documentManage/download.jsp";
		document.form1.documentID.value = did;
		document.form1.submit();

		// restore action url
		document.form1.action = "promotion_detail.htm";
		return false;
	}

	function removeDocument(moduleCode, did) {
		// save the document id in a variable
		var removeDocumentInput = "<input type=\"hidden\" name=\"removeDocumentId[]\" value=\"" + did + "\" />";
		$(removeDocumentInput).appendTo('#form1');
		$('#document' + did).remove();
	}

-->
</script>
	</c:otherwise>
</c:choose>
</div>
</div>
</div>
<div id="hiddenCrmTargetSelect" style="display:none">
	<p>
		<select name="crmTargetId[]">
			<jsp:include page="../ui/crmTargetIDCMB.jsp" flush="false" />
		</select>
		<a href="#" class="removeCrmTarget"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
	</p>
</div>
<div id="hiddenCrmDepartmentSelect" style="display:none">
	<p>
		<select name="crmDepartmentCode[]">
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false" />
		</select>
		<a href="#" class="removeCrmDepartment"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
	</p>
</div>
<div id="hiddenCrmEnquiryRow" style="display:none">
	<tr>
		<td style="width:5%"></td>
		<td style="width:60%">
			<input type="text" name="crmEnquiry[]" id="crmEnquiry" value="" maxlength="50" size="60" />
		</td>
		<td style="width:30%">
			<input type="text" name="crmPhone[]" id="crmPhone" value="" maxlength="50" size="10" />
		</td>
		<td style="width:5%">
			<a href="#" class="removeCrmEnquiry"><img src="/intranet/images/remove-button.gif" alt="Delete" /></a>
		</td>
	</tr>
</div>
<div id="hiddenCrmInstructionRow" style="display:none">
	<tr>
		<td style="width:5%"></td>
		<td style="width:30%">
			<input type="text" name="crmPromoInstrCode[]" id="crmPromoInstrCode" value="" maxlength="20" size="20" />
		</td>
		<td style="width:60%">
			<input type="text" name="crmPromoInstrRemarks[]" id="crmPromoInstrRemarks" value="" maxlength="100" size="60" />
		</td>
		<td style="width:5%">
			<a href="#" class="removeCrmInstruction"><img src="/intranet/images/remove-button.gif" alt="Delete" /></a>
		</td>
	</tr>
</div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>