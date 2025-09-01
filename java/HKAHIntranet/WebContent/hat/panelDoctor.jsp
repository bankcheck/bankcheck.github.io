<%@ page language="java" import="org.json.JSONObject" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.apache.commons.io.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>

<%

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

ArrayList result = new ArrayList();
ReportableListObject row1 = null;
UserBean userBean = new UserBean(request);
String mode = request.getParameter("mode");

String doccode = request.getParameter("doccode");
String docFname = "";
String docGname = "";
String docname = "";
String spccode = "";
String spcname = "";
String arccode = request.getParameter("arccode");
String addArccode = request.getParameter("addArccode");

String arCode[] = null;
String arName[] = null;
String arCodeAvailable[] = null;
String arNameAvailable[] = null;

Boolean success = false;

if (mode == null || mode.isEmpty()){
	mode = "View";	
}

if("View".equals(mode)){
	
} else if ("Edit".equals(mode)){
	result = PanelDoctorDB.getPanelAR(null, null, doccode);	
	if(result.size() > 0){
		arCode = new String[result.size()];
		arName = new String[result.size()];
		ReportableListObject row = null;
		for (int i = 0; i < result.size(); i++) {
			row = (ReportableListObject) result.get(i);
			arCode[i] = row.getValue(0);
			arName[i] = row.getValue(1);
		}
	} else {
		arCode = null;
	}
		
	result = PanelDoctorDB.getArList();
	if(result.size() > 0){
		arCodeAvailable = new String[result.size()];
		arNameAvailable = new String[result.size()];
		ReportableListObject row = null;
		for (int i = 0; i < result.size(); i++) {
			row = (ReportableListObject) result.get(i);
			arCodeAvailable[i] = row.getValue(0);
			arNameAvailable[i] = row.getValue(1);
		}
	} else {
		arCodeAvailable = null;
	}
	
}else if ("Update".equals(mode)){
	success = PanelDoctorDB.insertPanelDoctor("DR", null, addArccode, doccode, null);
	if(success){
		message = "Doctor update successful.";
		mode = "View";
	}else{
		message = "Update fail. Please try again later.";
	}
}else if ("Delete".equals(mode)){
	arccode = request.getParameter("delArccode");
	success = PanelDoctorDB.delARfromDoc(arccode, doccode);
	if(success){
		message = "Doctor update successful.";
		mode = "View";
	}else{
		message = "Update fail. Please try again later.";
	}
}

result = PanelDoctorDB.getDoctorInfo(doccode);
if (result.size() > 0) {
	ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
	docFname = reportableListObject.getValue(1);
	docGname = reportableListObject.getValue(2);
	docname = (docFname == null ? "" : docFname + ", ") + (docGname == null ? "" : docGname);
	spccode = reportableListObject.getValue(4);
	spcname = reportableListObject.getValue(5);
	
}
request.setAttribute("ar_list", PanelDoctorDB.getPanelAR(null, null, doccode));

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

%>
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
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
<style>
img {
    cursor: pointer;
}
table{
	width:100%;
}
</style>

<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame style="width: 100%;">
<%
	String title = null;
	// set submit label
	title = mode + " Panel Doctor";
	
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>


<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="docInfo" id="docInfo" action="panelDoctor.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr>
		<td class="infoLabel" width="30%">Doctor Code</td>
		<td class="infoData" width="70%">
			<input type="hidden" id="doccode" name="doccode" style="width: 400px;"  value="<%=doccode %>"/>
			<%=doccode %>
		</td>
	</tr>
	<tr>
		<td class="infoLabel" width="30%">Doctor Name</td>
		<td class="infoData" width="70%">
			<%=docname %>
		</td>
	</tr>
	<tr>
		<td class="infoLabel" width="30%">Specialty</td>
		<td class="infoData" width="70%">
			<%=spcname %>
		</td>
	</tr>
</table> 

<input type="hidden" name="mode"/>
<input type="hidden" name="delArccode" id="delArccode"/>
<input type="hidden" name="addArccode" id="addArccode"/>

<display:table id="row" name="requestScope.ar_list" pagesize="20" export="true" class="generaltable">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column title="Insurance Company" style="width:%" property="fields1" media="html" />
	<%	if ("Edit".equals(mode)){ %>
	<display:column titleKey="prompt.action" media="html" style="width:5%; text-align:center"><button onclick="delAction('Delete', '<c:out value="${row.fields0}" />');"><bean:message key="button.delete" /></button></display:column>
	<% 	} %>
</display:table>
<br/><br/>
<%	if ("Edit".equals(mode)){ %>
	<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
		<tr class="smallText">
			<td class="infoTitle" colspan="3">Add Insurance Company to doctor</td>
		</tr>
		<tr class="smallText">
				<td>Available Company</td>
				<td>&nbsp;</td>
				<td>Selected Company</td>
		</tr>
		<tr class="smallText">
			<td width="40%">
				<select name="arccodeAvailable" id="select1" size="10" multiple="">
<%	if (arCodeAvailable != null) {
		for (int i = 0; i < arCodeAvailable.length; i++) {
%>					<option value="<%=arCodeAvailable[i] %>"><%=arNameAvailable[i] %></option><%
		}
	} %>
				</select>
			</td>
			<td width="20%">
				<input type="button" class="btn-click" onclick="appendToSelected()" value="Add >>"></input><br/>
				<input type="button" class="btn-click" onclick="removeFromSelected()" value="<< Delete"></input></span>
			</td>
			<td width="40%">
				<select name="arccode" id="select2" size="10" multiple="">
<%	if (arCode != null) {
		for (int i = 0; i < arCode.length; i++) {
%>					<option value="<%=arCode[i] %>"><%=arName[i] %></option><%
		}
	} %>
				</select>
			</td>
		</tr>
	</table>
<%	} %> 
</form>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
		<%if("Edit".equals(mode)){ %>
			<button onclick="return submitAction('Update');" class="btn-click">Update</button>
		<%} %>
		<%if("View".equals(mode)){ %>
			<button onclick="return submitAction('Edit');" class="btn-click">Edit</button>
		<%} %>
		</td>
	</tr>
</table>
</div>

<script language="javascript">
	$(document).ready(function(){

	});

	function delAction(cmd, arccode){
		$("#delArccode").val(arccode);
		document.docInfo.mode.value = cmd;
		document.docInfo.submit();
	}
	
	function submitAction(cmd){
		$("#select2 option").attr("selected", true);
		document.docInfo.addArccode.value = $("#select2").val();
		document.docInfo.mode.value = cmd;
		document.docInfo.submit();
	}
	
	function appendToSelected(){
		$('#select1 option:selected').appendTo('#select2');
	}

	function removeFromSelected(){
		$('#select2 option:selected').appendTo('#select1');
	}

	removeDuplicateItem('docInfo', 'arccodeAvailable', 'arccode');
	
</script>
</DIV>
</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>