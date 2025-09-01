<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>

<%
UserBean userBean = new UserBean(request);
ArrayList record = new ArrayList();
ReportableListObject row1 = null;
String command = request.getParameter("command");

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
String searchBy = ParserUtil.getParameter(request, "searchBy")!=null?ParserUtil.getParameter(request, "searchBy"):"AR";
String arccode = ParserUtil.getParameter(request, "arccode")!=null?ParserUtil.getParameter(request, "arccode"):"";
String spccode = ParserUtil.getParameter(request, "spccode")!=null?ParserUtil.getParameter(request, "spccode"):"";
String doccode = ParserUtil.getParameter(request, "doccode");
String docname = ParserUtil.getParameter(request, "docname");
String Phone = ParserUtil.getParameter(request, "Phone");
String Sex = ParserUtil.getParameter(request, "Sex");

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

if("AR".equals(searchBy)){
	if(arccode != null && arccode.length() > 0){
		request.setAttribute("doctor_list", PanelDoctorDB.getDoctorList(arccode));
	}
}else if("DOC".equals(searchBy)){
	request.setAttribute("doctor_list", PanelDoctorDB.getDoctorList(doccode, docname));
}

String arName = "";
String arList = "<option></option>";
String specList = "<option></option>";

record = PanelDoctorDB.getArList();
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row1 = (ReportableListObject) record.get(i);
		if(arccode.equals(row1.getValue(0))){
			arName = row1.getValue(1);
			arList += "<option class=\"w3-small\" value=\"" + row1.getValue(0) + "\" selected>" + row1.getValue(1) + "</option>";
		}else{
			arList += "<option class=\"w3-small\" value=\"" + row1.getValue(0) + "\" >" + row1.getValue(1) + "</option>";
		}
	}
}

record = PanelDoctorDB.getSpecList();
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row1 = (ReportableListObject) record.get(i);
		if(spccode.equals(row1.getValue(0))){
			specList += "<option class=\"w3-small\" value=\"" + row1.getValue(0) + "\" selected>" + row1.getValue(1) + "</option>";
		}else{
			specList += "<option class=\"w3-small\" value=\"" + row1.getValue(0) + "\" >" + row1.getValue(1) + "</option>";
		}
	}
}
%>


<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Panel Doctor List" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="search_form" action="panelDoctor_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
		<tr class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Search By: </td>
			<td class="infoData" width="70%">
				<span onclick="switchSearchBy('AR')"><input type="radio" id="searchByArCompany" name="searchBy" value="AR" <%="AR".equals(searchBy)? " checked" : ""%>/>Insurance Company</span>
			 	<span onclick="switchSearchBy('DOC')"><input type="radio" id="searchByDoctor" name="searchBy" value="DOC" <%="DOC".equals(searchBy)? " checked" : ""%>/>Doctor</span>
			</td>
		</tr>
		<tr id="ARsection" class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Insurance Company: </td>
			<td class="infoData" width="70%"><select name="arccode" id="arccode"><%=arList %></select></td>
		</tr>
		<tr id="DoctorSectionCode" class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Doctor Code: </td>
			<td class="infoData" width="70%"><input type="text" name="doccode" id="doccode" value="<%=doccode == null ? "" : doccode%>" maxlength="200" size="40" ></td>
		</tr>
		<tr id="DoctorSectionName" class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Doctor Name: </td>
			<td class="infoData" width="70%"><input type="text" name="docname" id="docname" value="<%=docname == null ? "" : docname%>" maxlength="200" size="40" ></td>
		</tr>
		<!-- <tr class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Specialty: </td>
			<td class="infoData" width="70%"><select name="spccode" id="spccode"><%=specList %></select></td>
		</tr> -->
		<tr class="smallText">
			<td colspan="2" align="center">
				<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
				<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
			</td>
		</tr>		
	</table>
</form>

<div id="searchByArResult" >
	<display:table id="row" name="requestScope.doctor_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
		<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
		<display:column title="Doctor Code" style="width:15%" property="fields0" media="html" />
		<display:column title="Doctor Name" style="" media="html" >
			<c:out value="${row.fields1}"/>, <c:out value="${row.fields2}" />
		</display:column>
		<display:column titleKey="prompt.action" media="html" style="width:5%; text-align:center"><button onclick="return submitAction('View', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button></display:column>
	</display:table>
	<br/>
<%if("AR".equals(searchBy) && arccode.length() > 0){ %>	
	<div style="text-align:center">
		<button onclick="return addDoctorAction();">Add new doctor to Company - <%=arName %></button>
	</div>
<%} %>
</div>
<br/>
<br/>
<br/>
<div id="addDrToAr"></div>
</DIV>

</DIV>
</DIV>
<script>
$(document).ready(function () {
	switchSearchBy("<%=searchBy%>");
});

function switchSearchBy(i){
	if(i == "AR"){
		document.getElementById("searchByArCompany").checked = true;
		$("#ARsection").show();
		$("#DoctorSectionCode").hide();
		$("#DoctorSectionName").hide();
	}else if(i == "DOC"){
		document.getElementById("searchByDoctor").checked = true;
		$("#ARsection").hide();
		$("#DoctorSectionCode").show();
		$("#DoctorSectionName").show();
	}
}

function submitSearch() {
	document.search_form.submit();
}

function clearSearch(){
	$("input[type=text]").val("");
	$("option:selected").removeAttr("selected");
}

function submitAction(cmd, doccode) {
	callPopUpWindow("panelDoctor.jsp?command=" + cmd + "&doccode=" + doccode);
	return false;
}

function addDoctorAction(){
	$.ajax({
		type: "POST",
		url: "panelDoctorByAR.jsp",
		data: "arccode=<%=arccode%>&arName=<%=arName%>",
		success: function(values) {
			if(values.trim().length > 0){
				$("#addDrToAr").html(values.trim());
			}
		}
	});//$.ajax
}

function appendToSelected(){
	$('#select1 option:selected').appendTo('#select2');
}

function removeFromSelected(){
	$('#select2 option:selected').appendTo('#select1');
}

function saveAction(){
	$("#select2 option").attr("selected", true);
	addDoccode = $("#select2").val();
	$.ajax({
		type: "POST",
		url: "panelDoctorByAR.jsp",
		data: "mode=save&arccode=<%=arccode%>&doccode="+addDoccode,
		success: function(values) {
			if (values.trim() == "true"){
				submitSearch();			
			}
		}
	});//$.ajax
}

</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
