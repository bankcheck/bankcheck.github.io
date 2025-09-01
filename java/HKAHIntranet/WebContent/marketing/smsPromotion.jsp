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

int count = 0;
ArrayList result = null;
ArrayList patList = new ArrayList();
boolean success = false;
UserBean userBean = new UserBean(request);
String mode = ParserUtil.getParameter(request,"mode");
String mode2 = null;
String export = null;

String batchID = ParserUtil.getParameter(request, "batchID");
String noOfRev = ParserUtil.getParameter(request, "noOfRev");
String gender = ParserUtil.getParameter(request,"gender");
String type = ParserUtil.getParameter(request,"type");
String ageGp = ParserUtil.getParameter(request,"ageGp");
String regYr = ParserUtil.getParameter(request,"regYr");
String hyperlipidemia = ParserUtil.getParameter(request,"hyperlipidemia");
String hyperglycaemia = ParserUtil.getParameter(request,"hyperglycaemia");
String physicalExam = ParserUtil.getParameter(request,"physicalExam");
String rev = ParserUtil.getParameter(request, "rev");
String revMethod = ParserUtil.getParameter(request, "revMethod");
String smsRev = ParserUtil.getParameter(request, "smsRev");
String mailRev = ParserUtil.getParameter(request, "mailRev");
String smsMsg = null;
String smsSentDate = null;
String exportListDate = null;

Boolean sent = false;
Boolean smsSent = false;
Boolean listExport = false;


String smsList = null;
String mailList = null;
String noProList = null;
Enumeration<String> parameterNames = request.getParameterNames();
int n = 0;
String patno = null;
Map<String, String> patMethods = new HashMap<String, String>(); 
while (parameterNames.hasMoreElements()) {
	String paramName = parameterNames.nextElement();

	if (paramName.startsWith("z")) {
		patno = paramName.substring(1);
		String paramValue = ParserUtil.getParameter(request, paramName);
		if(paramValue != null){
			n++;
			if("S".equals(paramValue)){
				if(smsList == null || smsList.isEmpty()){
					smsList = patno;
				}else{
					smsList += ", " + patno ;
				}
			}else if("M".equals(paramValue)){
				if(mailList == null || mailList.isEmpty()){
					mailList = patno;
				}else{
					mailList += ", " + patno ;
				}
			}else if ("0".equals(paramValue)){
				n--;
				if(noProList == null || noProList.isEmpty()){
					noProList = patno;
				}else{
					noProList += ", " + patno;
				}
			}
			//patMethods.put(patno, paramValue);
		}
	}
}
noOfRev = String.valueOf(n);

// do save methods before original mode
if ("UpdateMethod".equals(mode) || "SendEdit".equals(mode) || "Mail".equals(mode)){
	
	mode2 = mode;
	mode = "SaveSendMethod";
}

if (mode == null || mode.isEmpty()){
	mode = "Find";	
	gender = "A";
	type = "A";
	hyperlipidemia = "A";
	hyperglycaemia = "A";
	physicalExam = "A";
}

if ("Create".equals(mode)){
	batchID = "";
	gender = "A";
	type = "A";
	ageGp = "";
	regYr = "";
	hyperlipidemia = "A";
	hyperglycaemia = "A";
	physicalExam = "A";
}

if("Save".equals(mode)){
	//Add new batch
	batchID = SMSDB.addBatch(noOfRev, gender, type, ageGp, regYr, hyperlipidemia, hyperglycaemia, physicalExam, userBean);
	batchID = SMSDB.addList(batchID, smsList, mailList, noProList);
	
	mode = "Update";
	if (batchID != null){
		message = "Batch " + batchID + " is created.";
	} else {
		errorMessage = "Batch cannot create. Please try again.";
	}
}

if ("SaveSendMethod".equals(mode)) {
	//Add list in batch
	if(!smsList.isEmpty() || !mailList.isEmpty()){
		success = SMSDB.updateBatch(batchID, smsList, mailList, noProList);
	}
	
	if (success){
		message = "Batch " + batchID + " is updated.";
	} else {
		errorMessage = "Batch cannot update. Please try again.";
	}

	// revert original mode
	mode = mode2;
}

if("UpdateMethod".equals(mode)){
	mode = "Update";
	message = "Batch " + batchID + " is updated.";
}

if("SendEdit".equals(mode)){
	export = "sms";
}

if ("Edit".equals(mode)){
	result = SMSDB.getNewBatch(gender, type, ageGp, regYr, hyperlipidemia, hyperglycaemia, physicalExam);
	if (result.size() > 0) {
		for (int i=0; i<result.size(); i++){
			ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
			patList.add(reportableListObject.getValue(0));
			
		}
	} 
	//find patient match with the criteria
	request.setAttribute("BatchInformation", result);
}
if ("Update".equals(mode)){
	result = SMSDB.getBatch(batchID);
	if (result.size() > 0){
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		gender = reportableListObject.getValue(2);
		type = reportableListObject.getValue(3);
		ageGp = reportableListObject.getValue(4);
		regYr = reportableListObject.getValue(5);
		hyperlipidemia = reportableListObject.getValue(6);
		hyperglycaemia = reportableListObject.getValue(7);
		physicalExam = reportableListObject.getValue(17);
		noOfRev = reportableListObject.getValue(1);
		smsRev = reportableListObject.getValue(10);
		mailRev = reportableListObject.getValue(13);
		smsMsg = reportableListObject.getValue(16);
		smsSentDate = reportableListObject.getValue(11);
		exportListDate = reportableListObject.getValue(14);
		
		if (smsMsg == null || smsMsg.isEmpty()){
			sent = false;
		}else{
			sent = true;
		}
		if (smsSentDate == null || smsSentDate.isEmpty()){
			smsSent = false;
		}else{
			smsSent = true;
		}
		if (exportListDate == null || exportListDate.isEmpty()){
			listExport = false;
		}else{
			listExport = true;
		}
		
	}
	result = SMSDB.getRevList(batchID);
	if (result.size() > 0) {
		for (int i=0; i<result.size(); i++){
			ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
			patList.add(reportableListObject.getValue(0));
			
		}
	} 
	request.setAttribute("BatchInformation", result);
}
if ("Find".equals(mode)){
	//DB get batch;
	request.setAttribute("BatchInformation", SMSDB.getBatch(batchID, gender, type, ageGp, regYr, hyperlipidemia, hyperglycaemia, physicalExam));
}
if ("Mail".equals(mode)) {
	response.sendRedirect("mailPromotion.jsp?mode="+mode+"&batchID="+batchID);
}
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
<%if ("Update".equals(mode)){%>
.batchInfo{
	border: 0;
	color: black;
}
<%}%>

.exportlinks{
	border:1px;
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
	title = mode + " SMS Batch";
	
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
<%if ("Find".equals(mode)||"Update".equals(mode)){ %>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return createBatch();" class="btn-click">Create New Batch</button> 
		</td>
	</tr>
</table>
</div>
<%} %>


<form name="criteriaForm" id="criteriaForm" action="smsPromotion.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
<%if ("Find".equals(mode)||"Update".equals(mode)) {%>
	<tr class="">
		<td class="infoLabel" width="30%">Batch ID</td>
		<td class="infoData" width="70%">
			<input class="batchInfo" type="text" id="batchID" name="batchID" <%if(!("Find".equals(mode))){ %> value="<%=batchID %>"<%} %> /> 
			
		</td>
	</tr>
<%} %>
	<tr class="">
		<td class="infoLabel" width="30%">Gender</td>
		<td class="infoData" width="70%">
			<input type="radio" class="searchInfo" name="gender" value="M" <% if ("M".equals(gender)){ %>checked<%} %>/> Male 
			<input type="radio" class="searchInfo" name="gender" value="F" <% if ("F".equals(gender)){ %>checked<%} %>/> Female 
			<input type="radio" class="searchInfo" name="gender" value="A" <% if ("A".equals(gender)){ %>checked<%} %>/> All 
		</td>
	</tr>
	<tr class="">
		<td class="infoLabel" width="30%">Registration Type</td>
		<td class="infoData" width="70%">
			<input type="radio" class="searchInfo" name="type" value="I" <% if ("I".equals(type)){ %>checked<%} %>/> In Patient 
			<input type="radio" class="searchInfo" name="type" value="O" <% if ("O".equals(type)){ %>checked<%} %>/> Out Patient
			<input type="radio" class="searchInfo" name="type" value="D" <% if ("D".equals(type)){ %>checked<%} %>/> Daycase 
			<input type="radio" class="searchInfo" name="type" value="A" <% if ("A".equals(type)){ %>checked<%} %>/> All 
		</td>
	</tr>
	<tr class="">
		<td class="infoLabel" width="30%">Age Group</td>
		<td class="infoData" width="70%">
			<select id="ageGp" name="ageGp">
				<option value="" ></option>
				<option value="0" <% if ("0".equals(ageGp)){ %>selected="selected"<%} %>>1-10</option>
				<option value="1" <% if ("1".equals(ageGp)){ %>selected="selected"<%} %>>11-20</option>
				<option value="2" <% if ("2".equals(ageGp)){ %>selected="selected"<%} %>>21-30</option>
				<option value="3" <% if ("3".equals(ageGp)){ %>selected="selected"<%} %>>31-40</option>
				<option value="4" <% if ("4".equals(ageGp)){ %>selected="selected"<%} %>>41-50</option>
				<option value="5" <% if ("5".equals(ageGp)){ %>selected="selected"<%} %>>51-60</option>
				<option value="6" <% if ("6".equals(ageGp)){ %>selected="selected"<%} %>>61-70</option>
				<option value="7" <% if ("7".equals(ageGp)){ %>selected="selected"<%} %>>71+</option>
			</select>
		</td>
	</tr>
		<tr class="">
		<td class="infoLabel" width="30%">Registration Year</td>
		<td class="infoData" width="70%">
			<select name="regYr" id="regYr">
				<option value=""></option>
			</select>
		</td>
	</tr>
		<tr class="">
		<td class="infoLabel" width="30%">Lipidemia</td>
		<td class="infoData" width="70%">
			<input type="radio" class="searchInfo" name="hyperlipidemia" value="Y" <% if ("Y".equals(hyperlipidemia)){ %>checked<%} %>/> High 
			<input type="radio" class="searchInfo" name="hyperlipidemia" value="N" <% if ("N".equals(hyperlipidemia)){ %>checked<%} %>/> Low / No Test 
			<input type="radio" class="searchInfo" name="hyperlipidemia" value="A" <% if ("A".equals(hyperlipidemia)){ %>checked<%} %>/> All 
		</td>
	</tr>
	<tr class="">
		<td class="infoLabel" width="30%">Glycaemia</td>
		<td class="infoData" width="70%">
			<input type="radio" class="searchInfo" name="hyperglycaemia" value="Y" <% if ("Y".equals(hyperglycaemia)){ %>checked<%} %>/> High 
			<input type="radio" class="searchInfo" name="hyperglycaemia" value="N" <% if ("N".equals(hyperglycaemia)){ %>checked<%} %>/> Low / Not Test 
			<input type="radio" class="searchInfo" name="hyperglycaemia" value="A" <% if ("A".equals(hyperglycaemia)){ %>checked<%} %>/> All
		</td>
	</tr>
	<tr class="">
		<td class="infoLabel" width="30%">Physical Exam</td>
		<td class="infoData" width="70%">
			<input type="radio" class="searchInfo" name="physicalExam" value="Y" <% if ("Y".equals(physicalExam)){ %>checked<%} %>/> Include 
			<input type="radio" class="searchInfo" name="physicalExam" value="N" <% if ("N".equals(physicalExam)){ %>checked<%} %>/> Not Include 
			<input type="radio" class="searchInfo" name="physicalExam" value="A" <% if ("A".equals(physicalExam)){ %>checked<%} %>/> All
		</td>
	</tr>
<%if("Update".equals(mode)){ %>
	<tr class="">
		<td class="infoLabel" width="30%">Total Receiver</td>
		<td class="infoData" width="70%">
			<input class="batchInfo" type="text" id="noOfRev" name="noOfRev" value="<%=noOfRev %>"/>
		</td>
	</tr>
	<tr class="">
		<td class="infoLabel" width="30%">SMS Receiver</td>
		<td class="infoData" width="70%">
			<input class="batchInfo" type="text" id="smsRev" name="smsRev" value="<%=smsRev %>"/>
			<%if(smsSent){ %>
			<p>(Sent on <%=smsSentDate %>) </p>
			<%} %>
		</td>
	</tr>
	<tr class="">
		<td class="infoLabel" width="30%">Mail Receiver</td>
		<td class="infoData" width="70%">
			<input class="batchInfo" type="text" id="mailRev" name="mailRev" value="<%=mailRev %>"/>
			<%if(listExport){ %>
			<p>(Exported on <%=exportListDate %>) </p>
			<%} %>
		</td>
	</tr>
<%if(smsSent){ %>
	<tr>
		<td class="infoLabel" width="30%">Message Sent</td>
		<td class="infoData" width="70%">
		<%String newMsg = smsMsg.replace("&#13;", "<br/>"); %>
			<span><%=newMsg %></span>
		</td>
	</tr>	
<%} %>
<%}%>
</table>

<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
		<%if ("Find".equals(mode)){ %>
			<button onclick="return submitAction('Find');" class="btn-click" id="btn-find"><%=title %></button>
		<%} else if ("Create".equals(mode) || "Edit".equals(mode)){ %>
			<button onclick="return submitAction('Edit');" class="btn-click" id="btn-create_edit"><%=title %></button><br/>
			It may take a few minutes to create a new batch. Please try again if it takes more than 10 minutes.
		<%} %>

		</td>
	</tr>
</table>
</div>
<input type="hidden" name="mode"/>


</form>

<%if("Find".equals(mode)){ %>
<div id="tbl-container" style="height: 580px">
<display:table id="row1" name="requestScope.BatchInformation" pagesize="10" export="true" class="generaltable">
	<display:column title="&nbsp;" media="html" style="width:2%">
		<button onclick="return showBatch('<c:out value="${row1.fields0}" />');">View/<br/>Edit</button>
	</display:column>
	<display:column property="fields0" title="Batch ID" style=""/>
	<display:column property="fields1" title="Total Receiver" style=""/>
	<display:column title="Criteria <br/> Gender" style="">
		<c:choose>
			<c:when test="${row1.fields2 == 'M'}">
				<c:out value="Male" />
			</c:when>
			<c:when test="${row1.fields2 == 'F'}">
				<c:out value="Female" />
			</c:when>
			<c:otherwise>
				<c:out value="ALL" />
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Criteria <br/> Registration Type" style="">
		<c:choose>
			<c:when test="${row1.fields3 == 'I'}">
				<c:out value="In Patient" />
			</c:when>
			<c:when test="${row1.fields3 == 'O'}">
				<c:out value="Out Patient" />
			</c:when>
			<c:when test="${row1.fields3 == 'D'}">
				<c:out value="Daycase" />
			</c:when>
			<c:otherwise>
				<c:out value="ALL" />
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Criteria <br/> Age Group" style="">
		<c:choose>
			<c:when test="${row1.fields4 == '0'}">
				<c:out value="0-10" />
			</c:when>
			<c:when test="${row1.fields4 == '1'}">
				<c:out value="11-20" />
			</c:when>
			<c:when test="${row1.fields4 == '2'}">
				<c:out value="21-30" />
			</c:when>
			<c:when test="${row1.fields4 == '3'}">
				<c:out value="31-40" />
			</c:when>
			<c:when test="${row1.fields4 == '4'}">
				<c:out value="41-50" />
			</c:when>
			<c:when test="${row1.fields4 == '5'}">
				<c:out value="51-60" />
			</c:when>
			<c:when test="${row1.fields4 == '6'}">
				<c:out value="61-70" />
			</c:when>
			<c:when test="${row1.fields4 == '7'}">
				<c:out value="71+" />
			</c:when>
		</c:choose>
	</display:column>
	<display:column property="fields5" title="Criteria <br/> Registration Year" style=""/>
	<display:column title="Criteria <br/> Lipidemia" style="">	
		<c:choose>
			<c:when test="${row1.fields6 == 'Y'}">
				<c:out value="High" />
			</c:when>
			<c:when test="${row1.fields6 == 'N'}">
				<c:out value="Low / Not Test" />
			</c:when>
			<c:otherwise>
				<c:out value="ALL" />
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Criteria <br/> Glycaemia" style="">
		<c:choose>
			<c:when test="${row1.fields7 == 'Y'}">
				<c:out value="High" />
			</c:when>
			<c:when test="${row1.fields7 == 'N'}">
				<c:out value="Low / Not Test" />
			</c:when>
			<c:otherwise>
				<c:out value="ALL" />
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column title="Criteria <br/> Physical Exam" style="">
		<c:choose>
			<c:when test="${row1.fields17 == 'Y'}">
				<c:out value="Include" />
			</c:when>
			<c:when test="${row1.fields17 == 'N'}">
				<c:out value="Not Include" />
			</c:when>
			<c:otherwise>
				<c:out value="ALL" />
			</c:otherwise>
		</c:choose>
	</display:column>
	<display:column property="fields8" title="Create Date" style=""/>
	<display:column property="fields9" title="Create By" style=""/>
	<display:column property="fields10" title="No. of SMS" style=""/>
	<display:column property="fields11" title="SMS Send Date" style=""/>
	<display:column property="fields12" title="Send By" style=""/>
	<display:column property="fields13" title="No. of Mail" style=""/>
	<display:column property="fields14" title="Export List Date" style=""/>
	<display:column property="fields15" title="Export By" style=""/>
	<display:column title="Message Sent" style="">
		<c:choose>
			<c:when test="${not empty row1.fields16}">
				<c:set var = "msg" value = "${fn:replace(row1.fields16, '&#13;',' ')}"/>
				<c:out value="${fn:substring(msg, 0, 200)} ... " />
			</c:when>
		</c:choose>
	</display:column>
</display:table>
</div>
<%} %>

<%if("Edit".equals(mode)||"Update".equals(mode)){ %>
<div id="tbl-container" style="height: 380px">
<form name="newBatchForm" id="newBatchForm" action="smsPromotion.jsp" method="post">
<display:table id="row1" name="requestScope.BatchInformation" export="true" class="generaltable">
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row1_rowNum")%>)
	</display:column>
	<display:column property="fields0" title="Patient No." style=""/>
	<display:column property="fields1" title="Patient Name" style=""/>
	<display:column title="Address">
		<c:out value="${row1.fields2}" /> <c:out value="${row1.fields3}" /> <c:out value="${row1.fields4}" /> 
	</display:column>
	<display:column property="fields5" title="Mobile" style=""/>
	<display:column property="fields6" title="Email" style=""/>
	<display:column property="fields7" title="Age" style=""/>
<%if("Update".equals(mode)){ %>
	<display:column title="By SMS">
		<input type="radio" name="z<c:out value="${row1.fields0}" />" value="S" <c:if test="${row1.fields8 == 'S' }">checked</c:if> <c:if test="${empty row1.fields5 }">disabled</c:if> />
	</display:column>
	<display:column title="By Mail">
		<input type="radio" name="z<c:out value="${row1.fields0}" />" value="M" <c:if test="${row1.fields8 == 'M' }">checked</c:if> <c:if test="${empty row1.fields2 && empty row1.fields3 && empty row1.fields4 }">disabled</c:if> />
	</display:column>
	<display:column title="No Promotion">
		<input type="radio" name="z<c:out value="${row1.fields0}" />" value="0" <c:if test="${row1.fields8 == '0' }">checked</c:if> />
	</display:column>
<%} %>
<%if("Edit".equals(mode)){ %>
	<display:column title="By SMS">
		<input type="radio" name="z<c:out value="${row1.fields0}" />" value="S" checked <c:if test="${empty row1.fields5 }">disabled</c:if> />
	</display:column>
	<display:column title="By Mail">
		<input type="radio" name="z<c:out value="${row1.fields0}" />" value="M" <c:if test="${empty row1.fields5 }">checked</c:if> <c:if test="${empty row1.fields2 && empty row1.fields3 && empty row1.fields4 }">disabled</c:if> />
	</display:column>
	<display:column title="No Promotion">
		<input type="radio" name="z<c:out value="${row1.fields0}" />" value="0" <c:if test="${empty row1.fields5 && empty row1.fields2 && empty row1.fields3 && empty row1.fields4}">checked <%count++; %> </c:if> />
	</display:column>
<%} %>
<display:setProperty name="export.excel.filename" value="MailPromotion.xls" />
</display:table>

<%if("Edit".equals(mode)){ %>
Total Receiver: <%=(result.size()-count) %> (with valid information)
<%}%>

<input type="hidden" name="mode"/>
<input type="hidden" name="batchID" value="<%=batchID %>"/>
<input type="hidden" name="noOfRev" id="noOfRev" value=""/>
<input type="hidden" name="gender" id="" value="<%=gender %>" />
<input type="hidden" name="type" id="" value="<%=type %>" />
<input type="hidden" name="ageGp" id="" value="<%=ageGp %>" />
<input type="hidden" name="regYr" id="" value="<%=regYr %>" />
<input type="hidden" name="hyperlipidemia" id="" value="<%=hyperlipidemia %>" />
<input type="hidden" name="hyperglycaemia" id="" value="<%=hyperglycaemia %>" />
<input type="hidden" name="physicalExam" id="" value="<%=physicalExam %>" />
<input type="hidden" name="rev" id="rev" value="<%=rev %>"/>
<input type="hidden" name="revMethod" id="revMethod" value="<%=revMethod %>"/>

</form>

<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%if("Edit".equals(mode)){ %>
			<button onclick="return submitAction('Save');" class="btn-click" id="btn-save">Save New Batch</button>
<%} else if("Update".equals(mode)||"Mail".equals(mode)){ %>
 			<button onclick="return updateContent('UpdateMethod');" class="btn-click btn-update_mail" id="updateBatch">Update Batch</button>
 			<button onclick="return updateContent('SendEdit');" class="btn-click btn-update_mail" id="sendSms">Send SMS</button>
			<button onclick="return updateContent('Mail');" class="btn-click btn-update_mail" id="sendMail">Export Mailing list</button>
			<!-- <button onclick="return submitAction('Mail');" class="btn-click btn-update_mail" id="sendMail">Export Mailing list</button> -->
			<button onclick="return window.close();" class="btn-click" >Close</button>
<%} %>
		</td>
	</tr>
</table>
</div>
</div>
<%} %>

<script language="javascript">
	$().ready(function() {
		<% if("xml".equals(export)){ %>
			window.open('mailPromotion.jsp?batchID=<%=batchID %>');
		<% } %>
		<% if("sms".equals(export)){ %>
			window.location.replace('smsSend.jsp?batchID=<%=batchID %>');
		<% } %>
		getRegYear();
		<%if("Update".equals(mode)) {%>
		lockfield();
		<%} %>
	});
	
	function showBatch(batchID){
		var w = 1100;
		var h = 900;
		var t = 0;
		var l = 0;
		var props = "channelmode=no,directories=no,fullscreen=no,location=no,menubar=no,resizable=yes,";
		props += "scrollbars=yes,status=no,titlebar=no,toolbar=no,";
		props += "top=" + t + ",left=" + l + ",height=" + h + ",width=" + w;

		win = window.open("", "_blank", props, false);
		win.location.href = "smsPromotion.jsp?mode=Update&batchID=" + batchID;
		var win_timer = setInterval(function() {   
			if(win.closed) {
		    window.location.href = "smsPromotion.jsp";
		    clearInterval(win_timer);
		} 
		}, 100); 
	}
	
	function createBatch(){
		var w = 1100;
		var h = 900;
		var t = 0;
		var l = 0;
		var props = "channelmode=no,directories=no,fullscreen=no,location=no,menubar=no,resizable=yes,";
		props += "scrollbars=yes,status=no,titlebar=no,toolbar=no,";
		props += "top=" + t + ",left=" + l + ",height=" + h + ",width=" + w;

		win = window.open("", "_blank", props, false);
		win.location.href = "smsPromotion.jsp?mode=Create";
		var win_timer = setInterval(function() {   
			if(win.closed) {
		    window.location.href = "smsPromotion.jsp";
		    clearInterval(win_timer);
		} 
		}, 100); 
	}
	
	function getRegYear(){
		var today = new Date();
		var yyyy = today.getFullYear();
		$('#year').val(yyyy);
		do{
			$('#regYr').append($('<option></option>').val(yyyy).text(yyyy));
			yyyy--;
		}while (yyyy>2000);	
		var selectYr = "<%=regYr %>";
		$('#regYr').val(selectYr);
	}

	function lockfield(){
		document.getElementById("batchID").readOnly = true;
		document.getElementById("noOfRev").readOnly = true;
		document.getElementById("smsRev").readOnly = true;
		document.getElementById("mailRev").readOnly = true;
		$(".searchInfo").prop('disabled', true);
		document.getElementById("regYr").disabled = true;
		document.getElementById("ageGp").disabled = true;
		<%if(smsSent){ %>
			$(".sentType").prop('disabled', true);
			document.getElementById("updateBatch").disabled = true;
			document.getElementById("sendSms").disabled = true;	
		<%} %>
	}
	
	function submitAction(cmd){
		if(cmd == "Create" || cmd == "Edit" || cmd == "Find"){
			if (cmd == "Create" || cmd == "Edit") {
				$("#btn-create_edit").attr('disabled','disabled');
			}
			if (cmd == "Find") {
				$("#btn-find").attr('disabled','disabled');
			}
			showLoadingBox('body', 500, $(window).scrollTop());
			
			document.criteriaForm.mode.value = cmd;
			document.criteriaForm.submit();
			
			
		} else if(cmd == "Save"){
			document.newBatchForm.mode.value = cmd;
			document.newBatchForm.submit();
			
			$("#btn-save").attr('disabled','disabled');
			showLoadingBox('body', 500, $(window).scrollTop());
		} 
	}

	function updateContent(cmd){
<%	if(!smsSent){ %>	
		$(".btn-update_mail").attr('disabled','disabled');
		showLoadingBox('body', 500, $(window).scrollTop());
		
		document.newBatchForm.mode.value = cmd;
		document.newBatchForm.submit();
		
		<%} else {%>
		if(cmd == "Mail"){
			document.newBatchForm.action = "mailPromotion.jsp";
		}
		document.newBatchForm.mode.value = cmd;
		document.newBatchForm.submit();
		
		showLoadingBox('body', 500, $(window).scrollTop());
<%}%>
		
	}

	

</script>
</DIV>
</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>