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
	private ArrayList<ReportableListObject> fetchPheOutstanding( String status, String reqBy) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT R.CO_REQ_NO, R.CO_STAFF_ID, R.CO_PATNO, R.CO_PATNAME, r.co_patcname, to_char( R.CO_REQ_DATE, 'dd-mm-yyyy') CO_REQ_DATE, R.CO_POSITION, decode( R.CO_PATSEX, 'M', 'Male', 'F', 'Female') CO_PATSEX, R.CO_PATAGE, E.CO_PHE_CODE, E.CO_STATUS, to_char(R.CO_COMPLETE_DATE , 'dd-mm-yyyy') CO_COMPLETE_DATE ");
		sqlStr.append("FROM CO_PHE_REQ R ");
		sqlStr.append("JOIN (SELECT CO_REQ_NO, LISTAGG(CO_PHE_CODE,',<br/> ') WITHIN GROUP (ORDER BY CO_PHE_CODE) CO_PHE_CODE, CO_STATUS ");
		sqlStr.append("			FROM CO_PHE_REQ_EXM ");
		sqlStr.append("			WHERE CO_STATUS = 'APPROVED' ");
		sqlStr.append("			GROUP BY CO_REQ_NO, CO_STATUS) E ");
		sqlStr.append("ON R.CO_REQ_NO = E.CO_REQ_NO ");
		sqlStr.append("WHERE '"+ status +"' like '%'||r.co_status||'%' ");
		sqlStr.append("AND r.co_req_by = nvl('" + reqBy + "', r.co_req_by) ");
		sqlStr.append("ORDER BY CO_REQ_DATE DESC, CO_REQ_NO DESC, CO_STAFF_ID ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> fetchPheOutstandingNeedApproval( String status, String reqBy, String needApproval) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT r.co_req_no, r.co_staff_id, r.co_patno, r.co_patname, r.co_patcname, to_char( r.co_req_date, 'dd-mm-yyyy') co_req_date, r.co_position, decode( r.co_patsex, 'M', 'Male', 'F', 'Female') co_patsex, r.co_patage, re.co_phe_code, re.co_status, to_char(R.CO_COMPLETE_DATE , 'dd-mm-yyyy') CO_COMPLETE_DATE ");
		sqlStr.append("FROM co_phe_req r ");
		sqlStr.append("JOIN co_phe_req_exm re ");
		sqlStr.append("ON re.co_req_no = r.co_req_no ");
		sqlStr.append("WHERE '"+ status +"' like '%'||r.co_status||'%' ");
		sqlStr.append("AND r.co_req_by = nvl('" + reqBy + "', r.co_req_by) ");
		sqlStr.append("AND re.co_status = '"+ needApproval +"' ");
		sqlStr.append("ORDER BY r.co_staff_id, r.co_req_date");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> fetchPheOutstandingByStaffId( String staffId ) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT r.co_req_no, r.co_staff_id, r.co_patno, r.co_patname, r.co_patcname, to_char( r.co_req_date, 'dd-mm-yyyy') co_req_date, r.co_position, decode( r.co_patsex, 'M', 'Male', 'F', 'Female') co_patsex, r.co_patage, re.co_phe_code, re.co_status, to_char(R.CO_COMPLETE_DATE , 'dd-mm-yyyy') CO_COMPLETE_DATE ");
		sqlStr.append("FROM co_phe_req r ");
		sqlStr.append("JOIN co_phe_req_exm re ");
		sqlStr.append("ON re.co_req_no = r.co_req_no ");
		sqlStr.append("WHERE r.co_staff_id = '" + staffId + "' ");
		sqlStr.append("ORDER BY r.co_req_no DESC, r.co_req_date ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>

<%
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
String reqNo = ParserUtil.getParameter(request, "reqNo");
//String status = ParserUtil.getParameter(request, "status");
String status = null ;
String needApproval = null;

String staffId = ParserUtil.getParameter(request, "staffId");
if ( staffId == null ) staffId = "" ;
String filter = ParserUtil.getParameter(request, "filter");
String reqBy = null ;

UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");

String pheCode = ParserUtil.getParameter(request, "pheCode");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean success = false;

String errMsg = null ;
if ("COM_REQ".equals(command)) {
	errMsg = UtilDBWeb.callFunction("PHE.UPD_STATUS", "UPD", new String[] { reqNo, "COMPLETED" }) ;
} else if ("ADD_ALL_REQ".equals(command)) {
	
} else if ("APP_REQ".equals(command)) {
	errMsg = UtilDBWeb.callFunction("PHE.upd_exm_status", "UPD", new String[] { reqNo, pheCode, "APPROVED" }) ;
} else if ("REJ_REQ".equals(command)) {
	errMsg = UtilDBWeb.callFunction("PHE.upd_exm_status", "UPD", new String[] { reqNo, pheCode, "REJECTED" }) ;
} 

String SR_buttonStyle = null ;
String MR_buttonStyle = null ;
String C_buttonStyle = null ;
String AP_buttonStyle = null ;
String selectStyle = "font-size: 120% ; font-weight:bold" ;
if ( filter == null || "".equals( filter ) ){
	status = "RECEIVED" ;
	reqBy = "MANUAL" ;
	needApproval = "";
	MR_buttonStyle = selectStyle ;
} else if ( "SYSTEM".equals(filter) ) {
	status = "RECEIVED" ;
	reqBy = "SYSTEM" ;
	needApproval = "";
	SR_buttonStyle = selectStyle ;
} else if ( "MANUAL".equals(filter) ) {
	status = "RECEIVED" ;
	reqBy = "MANUAL" ;
	needApproval = "";
	MR_buttonStyle = selectStyle ;
} else if ( "COMPLETED".equals(filter) ) {
	status = "COMPLETED" ;
	reqBy = "" ;
	needApproval = "";
	C_buttonStyle = selectStyle ;
} else if ( "APPROVAL".equals(filter) ) {
	status = "RECEIVED" ;
	reqBy = "MANUAL" ;
	needApproval = "WAIT_APPROVAL";
	AP_buttonStyle = selectStyle ;
}

//if ("create".equals(command) || !userBean.isLogin()) {
if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

String message = "";
String errorMessage = "";

/*
try {
	if ("1".equals(step)) {
		if (createAction) {

		} else if (updateAction) {

		} else if (deleteAction) {

		}
		
		if (fileUpload) {
			
		}
	} else if (createAction) {
		// init value
	}

	ReportableListObject row = null; 

	// load data from database
	if (!createAction && !"1".equals(step)) {
		ArrayList record = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);

		} else {
			closeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}
*/
//request.setAttribute("todo_exam_list", fetchTodoExam(staffID));
//request.setAttribute("outstanding_list", fetchPheOutstanding( status ));
if("WAIT_APPROVAL".equals(needApproval)){
	request.setAttribute("outstanding_list", fetchPheOutstandingNeedApproval( status, reqBy ,needApproval));	
}else{
	if ( staffId == null || staffId.isEmpty()) {
		request.setAttribute("outstanding_list", fetchPheOutstanding( status, reqBy));	
	} else {
		request.setAttribute("outstanding_list", fetchPheOutstandingByStaffId( staffId ) );
	}
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
img {
    cursor: pointer;
}
table{
	width:100%
}
input[type=button]{
    margin: 0 7px 0 0;
    border: 1px solid #dedede;
    border-top: 1px solid #eee;
    border-left: 1px solid #eee;
    font: 12px Arial, Helvetica, sans-serif;
    font-size: 100%;
    line-height: 100%;
    text-decoration: none;
    color: #565656;
    cursor: pointer;
    padding: 5px 10px 6px 7px;
}
</style>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.phe.user." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="PHE Outstanding Request" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" id="form1" action="phe_outstanding.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Login Info</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="10%">Staff ID.</td>
		<td class="infoData" width="70%"><input type="textfield" name="staffId" value="<%=staffId%>" maxlength="10" size="10">
			<button onclick="return searchByStaffId();">Search</button>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="10%">Filter</td>
		<td class="infoData" width="70%">
			<button style="<%=MR_buttonStyle%>" onclick="return setFilter('MANUAL');">Manual</button>
			<button style="<%=SR_buttonStyle%>" onclick="return setFilter('SYSTEM');">System</button>
			<button style="<%=C_buttonStyle%>" onclick="return setFilter('COMPLETED');">Completed</button>
			<button style="<%=AP_buttonStyle%>" onclick="return setFilter('APPROVAL');">Approval</button>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="10%">System Request</td>
		<td class="infoData" width="70%">
			<input type="button" onclick="addAllReq('01')" value="JAN"/>
			<input type="button" onclick="addAllReq('02')" value="FEB"/>
			<input type="button" onclick="addAllReq('03')" value="MAR"/>
			<input type="button" onclick="addAllReq('04')" value="APR"/>
			<input type="button" onclick="addAllReq('05')" value="MAY"/>
			<input type="button" onclick="addAllReq('06')" value="JUN"/>
			<input type="button" onclick="addAllReq('07')" value="JUL"/>
			<input type="button" onclick="addAllReq('08')" value="AUG"/>
			<input type="button" onclick="addAllReq('09')" value="SEP"/>
			<input type="button" onclick="addAllReq('10')" value="OCT"/>
			<input type="button" onclick="addAllReq('11')" value="NOV"/>
			<input type="button" onclick="addAllReq('12')" value="DEC"/>
		</td>
	</tr>
</table>

<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="reqNo" value="<%=reqNo%>" />
<input type="hidden" name="pheCode" value="" />
<input type="hidden" name="filter" value="<%=filter%>" />
</form>

<br/>
<display:table id="row1" name="requestScope.outstanding_list" export="true" pagesize="10" class="generaltable">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row1_rowNum")%>)</display:column>
	<display:column property="fields0" title="Req No." style="width:5%"/>
	<display:column property="fields1" title="Staff ID." style="width:5%"/>
	<display:column property="fields2" title="Patient No." style="width:5%"/>
	<display:column property="fields3" title="English Name" style="width:11%"/>
	<display:column property="fields4" title="Chinese Name" style="width:5%"/>
	<display:column property="fields5" title="Req Date" style="width:7%"/>
	<display:column property="fields6" title="Pos." style="width:15%"/>
	<display:column property="fields7" title="Sex." style="width:5%"/>
	<display:column property="fields8" title="Age." style="width:5%"/>
	<display:column property="fields9" title="PHE Code." style="width:12%"/>
	<c:choose>
		<c:when test="${empty row1.fields11 }">
			<display:column title="Action" style="width:20%">
				<c:choose>
					<c:when test="${row1.fields10 == 'WAIT_APPROVAL'}">
						<button onclick="return approveReq('<c:out value="${row1.fields0}" />','<c:out value="${row1.fields9}" />');">Approve</button>
						<button onclick="return rejectReq('<c:out value="${row1.fields0}" />','<c:out value="${row1.fields9}" />');">Reject</button>
					</c:when>
					<c:when test="${row1.fields10 == 'REJECTED'}">
						REJECTED 
					</c:when>
					<c:otherwise>
						<button onclick="return printAllLabel('<c:out value="${row1.fields0}" />');">Label</button>
						<button onclick="return printReplyLetter('<c:out value="${row1.fields0}" />');">Letter</button>
						<button onclick="return completeReq('<c:out value="${row1.fields0}" />');">Complete</button>
					</c:otherwise>
			</c:choose>
			</display:column>
		</c:when>
		<c:otherwise>
			<display:column property="fields11" title="Completed Date" style="width:20%" />
		</c:otherwise>
	</c:choose>
</display:table>
<br/>

<script language="javascript">
	$().ready(function() {
		
	});

	function completeReq( reqNo ) {
		document.form1.command.value = "COM_REQ" ;
		document.form1.reqNo.value = reqNo ;
		document.form1.submit();
	}
	
	function setFilter( filter ) {
		document.form1.command.value = "SET_FILTER" ;
		document.form1.filter.value = filter ;
		document.form1.staffId.value = "" ;
		document.form1.submit();
	}
	
	function addAllReq( month ) {
		
		$.ajax({
	        url: "/intranet/AddSystemRequest",
	        data: {"month" : month},
	        type: 'POST',
			cache: false,
	        success: function(data){
	        	//console.log(data);
	        	alert(data+" records added.");
				document.form1.command.value = "SET_FILTER" ;
				document.form1.filter.value = "SYSTEM" ;
				document.form1.submit();
	        },
	       	error: function(data){
	       		//console.log(data);
	       		alert("Please refresh.");
	       	}
	    });
		
	}
	
	function approveReq( reqNo, pheCode ) {
		document.form1.command.value = "APP_REQ" ;
		document.form1.reqNo.value = reqNo ;
		document.form1.pheCode.value = pheCode ;
		document.form1.submit();
	}
	
	function rejectReq( reqNo, pheCode ) {
		document.form1.command.value = "REJ_REQ" ;
		document.form1.reqNo.value = reqNo ;
		document.form1.pheCode.value = pheCode ;
		document.form1.submit();
	}

	function searchByStaffId() {
		document.form1.command.value = "SEARCH_BY_STAFF_ID" ;
		document.form1.filter.value = "" ;
		document.form1.submit();
	}

	function printAllLabel( reqNo ) {
		parent.parent.window.open( "../education/phe_print_all_label.jsp?reqNo=" + reqNo ) ;
		return false ;
	}

	function printReplyLetter( reqNo ) {
		parent.parent.window.open( "../education/phe_print_reply_letter.jsp?reqNo=" + reqNo ) ;
		return false ;
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>