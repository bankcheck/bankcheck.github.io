<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.commons.io.*"%>
<%!
	private ArrayList<ReportableListObject> fetchTodoExam(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select co_phe_code, co_pkgname, co_itmname, co_optional, co_remark, co_req_status, co_remain_days, co_exm_status ");
		sqlStr.append("FROM table(phe.todo_exam_with_req('" + staffID + "'))");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

%>

<%
/*
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	fileUpload = true;
}
*/
String staffID = ParserUtil.getParameter(request, "staffID");
String command = ParserUtil.getParameter(request, "command");
String pheCode = ParserUtil.getParameter(request, "pheCode");

UserBean userBean = new UserBean(request);

if("".equals(command)||command == null){
	command = "create";
}

boolean createAction = false;
/*
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean success = false;
*/

String[] pheExamCode = new String[10];
String errMsg = null ;
String[] errMsgShow = new String[10];

if ("ADD_REQ".equals(command)) {
	if(pheCode != null){
		pheExamCode = pheCode.split(",");
	}

	for(int i=0;i<pheExamCode.length;i++){
		errMsg = UtilDBWeb.callFunction("PHE.ADD_REQ", "ADD", new String[] { staffID, pheExamCode[i], "MANUAL" }) ;	
		errMsgShow[i] = errMsg;	
	}
}

//if ("create".equals(command) || !userBean.isLogin()) {
if ("create".equals(command)) {
	createAction = true;
} 
/*else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}
*/
String message = "";
String errorMessage = "";

if ( ! ( staffID == null || "".equals( staffID ) ) ) {
	request.setAttribute("todo_exam_list", fetchTodoExam(staffID));
}

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

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>
body{
	width:100%;
}
img {
    cursor: pointer;
}
table{
	width: 100%;
}
</style>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>

<%
	String title = null;
	String commandType = null;
	/*
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	*/
	// set submit label
	title = "function.phe.user." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Request Form" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" id="form1" action="phe_req_form.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Login Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Staff ID</td>
		<td class="infoData" width="70%"><%=staffID %></td>
	</tr>
	<tr>
		<td class="infoLabel" width="30%">Action</td>
		<td class="infoData" width="70%"><button onclick="addReq()">Submit</button></td>
	</tr>
</table>
<div class="pane">
</div>

<display:table id="row1" name="requestScope.todo_exam_list" export="true" pagesize="10">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row1_rowNum")%>)</display:column>
	<display:column property="fields0" title="PHE Code" />
	<display:column title="Package Name">
		<c:choose>
			<c:when test="${row1.fields3 == 'N'}">
				<c:out value="${row1.fields1 }"></c:out>
			</c:when>
			<c:otherwise>
				<b>OPTIONAL - </b><c:out value="${row1.fields2 }"></c:out>
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column property="fields4" title="Remark" />
	<display:column title="Status">
		<c:choose>
			<c:when test="${empty row1.fields5}">
				<c:choose>
					<c:when test="${row1.fields6 <= 0 }">
						Available
					</c:when>
					<c:otherwise>
						Remain <c:out value="${row1.fields6 }"/> Days
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
			<c:out value="${row1.fields7 }"/>
			</c:otherwise>
		</c:choose>
	</display:column>
	<c:choose>
		<c:when test="${empty row1.fields5 }">
			<display:column title="Request">
				<c:choose>
					<c:when test="${row1.fields6 < 0}">
						<c:choose>
							<c:when test="${row1.fields3 == 'N' }">
								<input type="checkbox" name="pheExam" value="${row1.fields0}" checked onclick="mustSelect(this);"/>
							</c:when>
							<c:otherwise>
								<input type="checkbox" name="pheExam" value="${row1.fields0}" checked/>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<input type="checkbox" name="pheExam" value="${row1.fields0}" disabled />
					</c:otherwise>
				</c:choose>
			</display:column>
		</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>



</display:table>
<br/>
<br/>
<input type="hidden" name="command" /><br/>
<input type="hidden" name="pheCode" /><br/>
<input type="hidden" name="staffID" value="<%=staffID%>" />
</form>
<script language="javascript">
	$().ready(function() {

	});
	
	function addReq() {
		var pheCode = [];
		$(':checkbox:checked').each(function(i){
			pheCode[i] = $(this).val();		
		});
		if (pheCode == null ){
			alert("Error!");
			}
		else{
			document.form1.command.value = "ADD_REQ" ;
			document.form1.pheCode.value = pheCode ;
			//document.form1.submit();
		}
	}
	
	function mustSelect(cd){
		cd.checked = 1;
		alert("This is the major package must be selected.");	
	
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>