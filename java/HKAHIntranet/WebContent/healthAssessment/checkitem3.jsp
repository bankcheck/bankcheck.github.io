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
<c:if test="${healthAssessment == null}">
	<c:redirect url="checkitem3.htm" />
</c:if>
-->

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<c:if test="${healthAssessment.closeAction}">
<script type="text/javascript">window.close();</script>
</c:if>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<c:set var="haaID" value="${healthAssessment.haaID}"/>
<jsp:useBean id="haaID" type="java.lang.String"/>
<c:set var="allowRemove" value="${healthAssessment.allowRemove}"/>
<jsp:useBean id="allowRemove" type="java.lang.String"/>
<c:set var="title" value="${healthAssessment.title}"/>
<jsp:useBean id="title" type="java.lang.String"/>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<c:set var="message" value="${healthAssessment.message}" />
<jsp:useBean id="message" class="java.lang.String" />
<c:set var="errorMessage" value="${healthAssessment.errorMessage}" />
<jsp:useBean id="errorMessage" class="java.lang.String" />
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" enctype="multipart/form-data" action="checkitem3.htm" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.corpName" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${healthAssessment.createAction || healthAssessment.updateAction}" > 
					<input type="text" name="corporationName" value="<c:out value="${healthAssessment.haaChecklist.haaCorpName}"/>" maxlength="50" size="50" />
				</c:when>
				<c:otherwise>
					<c:out value="${healthAssessment.haaChecklist.haaCorpName}"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.busType" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${healthAssessment.createAction || healthAssessment.updateAction}" > 
					<select name="businessType">
						<option value="NB"<c:if test="${'NB' == healthAssessment.haaChecklist.haaBusinessType }"> selected</c:if>><bean:message key="label.newBusiness" /></option>
						<option value="RB"<c:if test="${'RB' == healthAssessment.haaChecklist.haaBusinessType }"> selected</c:if>><bean:message key="label.renewalBusiness" /></option>
						<option value="PM"<c:if test="${'PM' == healthAssessment.haaChecklist.haaBusinessType }"> selected</c:if>><bean:message key="label.promotion" /></option>
					</select>
				</c:when>
				<c:otherwise>
					<c:if test="${'NB' == healthAssessment.haaChecklist.haaBusinessType }"><bean:message key="label.newBusiness" /></c:if>
					<c:if test="${'RB' == healthAssessment.haaChecklist.haaBusinessType }"><bean:message key="label.renewalBusiness" /></c:if>
					<c:if test="${'PM' == healthAssessment.haaChecklist.haaBusinessType }"><bean:message key="label.promotion" /></c:if>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.caseSummary" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${!healthAssessment.createAction}" >
					<span id="showDocument_indicator">
						<jsp:include page="../common/document_list.jsp" flush="false">
							<jsp:param name="moduleCode" value="haa" />
							<jsp:param name="keyID" value="<%=haaID %>" />
							<jsp:param name="allowRemove" value="<%=allowRemove %>" />
						</jsp:include>
					</span>
				</c:when> 
			</c:choose>
			<c:choose>
				<c:when test="${healthAssessment.createAction || healthAssessment.updateAction}" >
					<input type="file" name="file1" size="50" class="multi" maxlength="10" />
				</c:when> 
			</c:choose>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.contractDate" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${healthAssessment.createAction || healthAssessment.updateAction}" >
					<input type="text" name="contractDateFrom" id="contractDateFrom" class="datepickerfield" value="<c:if test="${healthAssessment.haaChecklist.haaContractDateFromDisplay != null}"><c:out value="${healthAssessment.haaChecklist.haaContractDateFromDisplay}" /></c:if>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
					-
					<input type="text" name="contractDateTo" id="contractDateTo" class="datepickerfield" value="<c:if test="${healthAssessment.haaChecklist.haaContractDateToDisplay != null}"><c:out value="${healthAssessment.haaChecklist.haaContractDateToDisplay}" /></c:if>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
				</c:when>
				<c:otherwise>
					<c:out value="${healthAssessment.haaChecklist.haaContractDateFromDisplay}" /> - <c:out value="${healthAssessment.haaChecklist.haaContractDateToDisplay}" />
				</c:otherwise> 
			</c:choose>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="70%">
			<c:choose> 
				<c:when test="${healthAssessment.createAction || healthAssessment.updateAction}" >
					<select name="enabled">
						<option value="1"<c:if test="${'1' == healthAssessment.haaChecklist.haaEnabled }"> selected</c:if>>Normal</option>
						<option value="2"<c:if test="${'2' == healthAssessment.haaChecklist.haaEnabled }"> selected</c:if>>Archive</option>
					</select>
				</c:when>
				<c:otherwise>
					<c:choose>
						<c:when test="${'2' == healthAssessment.haaChecklist.haaEnabled }">
							<bean:message key="label.archive" />
						</c:when>
						<c:otherwise>
							<bean:message key="label.normal" />
						</c:otherwise>
					</c:choose>
				</c:otherwise> 
			</c:choose>
		</td>
	</tr>
</table>

<c:if test="${!healthAssessment.updateDateAction}" >
	<div class="pane">
		<table width="100%" border="0">
			<tr class="smallText">
				<td align="center">
					<c:choose>
						<c:when test="${healthAssessment.createAction || healthAssessment.updateAction || healthAssessment.deleteAction}" >
							<button onclick="return submitAction('<c:out value="${healthAssessment.commandType}"/>', 1, 0);" class="btn-click">
								<bean:message key="button.save" /> - <bean:message key="<%=title %>" />
							</button>
							<button onclick="return submitAction('view', 0, 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
						</c:when>
						<c:otherwise>
							<button onclick="return submitAction('update', 0, 0);" class="btn-click"><bean:message key="function.haa.update" /></button>
							<button class="btn-delete-haa"><bean:message key="function.haa.delete" /></button>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</table>
	</div>
</c:if>

<c:if test="${!healthAssessment.createAction && !healthAssessment.updateAction}" >
	<bean:define id="functionLabel"><bean:message key="function.haa.list" /></bean:define>
	<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
	<display:table id="row" name="requestScope.healthAssessment.progressList" export="false" requestURI="checkitem3.htm">
		<display:column property="haaChecklistProgress.haaProgress" title="Progress" style="width:30%"/>
		<display:column property="haaChecklistProgress.haaDept" title="Dept" style="width:10%"/>
		<display:column property="haaChecklistProgress.haaInitParty" title="Initiate Party" style="width:10%"/>
		<display:column title="Initiate Date" style="width:10%">
			<c:choose>
				<c:when test="${healthAssessment.updateDateAction && row.haaChecklistProgress.haaChecklistPid == healthAssessment.seq}">
					<input type="text" name="initDate" id="initDate" class="datepickerfield" value="<c:out value="${row.haaInitDateDisplay}"/>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
				</c:when>
				<c:otherwise>
					<c:out value="${row.haaInitDateDisplay}" />
				</c:otherwise>
			</c:choose>
		</display:column>	
		<display:column property="haaChecklistProgress.haaRspn" title="Responsive Party" style="width:10%; text-align:center"/>
		<display:column title="Completed Date" style="width:10%">
			<c:choose>
				<c:when test="${healthAssessment.updateDateAction && row.haaChecklistProgress.haaChecklistPid == healthAssessment.seq}">
					<input type="text" name="completeDate" id="completeDate" class="datepickerfield" value="<c:out value="${row.haaCmpltDateDisplay }"/>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
				</c:when>
				<c:otherwise>
					<c:out value="${row.haaCmpltDateDisplay}" />
				</c:otherwise>
			</c:choose>
		</display:column>

		<display:column title="Action" style="width:10%">
			<c:if test="${row.haaChecklistProgress.haaDept != ''}">
				<c:choose>
					<c:when test="${healthAssessment.updateDateAction && row.haaChecklistProgress.haaChecklistPid == healthAssessment.seq}">
						<button onclick="return submitAction('<c:out value="${healthAssessment.commandType}" />', 1, '<c:out value="${row.haaChecklistProgress.haaChecklistPid}" />');" class="btn-click"><bean:message key="button.save" /></button>
						<button onclick="return submitAction('view', 0, '<c:out value="${row.haaChecklistProgress.haaChecklistPid}" />');" class="btn-click"><bean:message key="button.cancel" /></button>
					</c:when>
					<c:otherwise>
						<button onclick="return submitAction('updateDate', 0, '<c:out value="${row.haaChecklistProgress.haaChecklistPid}" />');" class="btn-click"><bean:message key="button.update" /></button>
					</c:otherwise>
				</c:choose>
			</c:if>
		</display:column>

	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</c:if>

<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="HaaID" value="<c:out value="${healthAssessment.haaID}" />" />
<input type="hidden" name="seq" />
</form>

<!-- Discussion board plugin -->
<c:if test="${!(healthAssessment.createAction || healthAssessment.updateAction || healthAssessment.updateDateAction || healthAssessment.deleteAction)}">
	<c:set var="discussionBoard" value="${healthAssessment.discussionBoard}" scope="request" />
	<span id="discussionBoard_indicator">
		<jsp:include page="../discussionBoard/list.jsp" flush="false" />
	</span>
	<script type="text/javascript" src="<html:rewrite page="/js/discussionBoard.js" />" /></script>
</c:if>

<script language="javascript">
<!--
	$().ready(function(){
		$(".pane .btn-delete-haa").click(function(){
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
				if (document.form1.corporationName.value == '') {
					document.form1.corporationName.focus();
					alert("Please input Corporation Name!");
					return false;
				}
			} else if (cmd == 'updateDate') {
				if (document.form1.initDate.value == '') {
					document.form1.initDate.focus();
					alert("Please input initiate date!");
					return false;
				}
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.seq.value = seq;
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function removeDocument(did) {
		http.open('get', '../common/document_list.jsp?command=delete&moduleCode=haa&keyID=<c:out value="${healthAssessment.haaChecklist.id.haaChecklistId}"/>&documentID=' + did + '&allowRemove=<c:choose><c:when test="${healthAssessment.updateAction}"><c:out value="Y"></c:out></c:when><c:otherwise><c:out value="N"></c:out></c:otherwise></c:choose>&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}
	
	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById('showDocument_indicator').innerHTML = response;
		}
	}

-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>