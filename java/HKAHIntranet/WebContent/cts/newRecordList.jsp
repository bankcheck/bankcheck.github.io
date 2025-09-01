<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.TreeMap"%>
<%

UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String as_docNo = request.getParameter("docNo");
String as_recType = request.getParameter("recType");
String as_recStatus = request.getParameter("rdStatus");
String as_ctsNo = null;
String as_createPdf = request.getParameter("createPdf");
String as_colDesc5 = null;

boolean letter1Action = false;
boolean letter2Action = false;

String sendAppTo = null;

List class_enrollment = null;
ArrayList ctsList = null;
String[] ctsNo = null;

if ("N".equals(as_recType)) {
	as_colDesc5 = "License Number";
}else{
	as_colDesc5 = "Termination Date";
}


if ("Y".equals(as_createPdf)) {
	as_ctsNo = request.getParameter("ctsNo");	
	letter1Action = true;
}
if ("pdf".equals(command)) {
	as_ctsNo = request.getParameter("ctsNo");
	letter2Action = true;
}

String message = request.getParameter("message");
if (message == null) {
	message = "";
}

String errorMessage = "";
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<div id=mainFrame>
<div id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.cts.list2" />
	<jsp:param name="category" value="group.cts" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.cts.list2" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="search_form" action="newRecordList.htm" method="post" >
<input type="hidden" name="search" value="yes"/>
<c:set var="ctstable" value="${cts.table}" />
<%

if((ArrayList)pageContext.getAttribute("ctstable")!=null){
	ctsList = (ArrayList)pageContext.getAttribute("ctstable");
}

%>
<table cellpadding="0" cellspacing="5" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="10%"><bean:message key="prompt.docNo" /></td>
		<td class="infoData" width="15%"><input type="textfield" name="docNo" value="<c:out value="${cts.as_docNo }"/>" maxlength="10" size="50"></td>
		<td class="infoLabel" width="10%"><bean:message key="prompt.recType" /></td>	
		<td class="infoData" width="15%" >
			<select name="recType">
				<option value="">			
				<option value="N"<%="N".equals(as_recType)?" selected":""%>>New</option>
				<option value="R"<%="R".equals(as_recType)?" selected":""%>>Renewal</option>					
				<option value="D"<%="D".equals(as_recType)?" selected":""%>>Inactive</option>
			</select>		
		</td>
		<td class="infoLabel" width="10%"><bean:message key="prompt.recStatus" /></td>	
		<td class="infoData" width="15%">
			<select name="rdStatus">
			<option value="">			
			<option value="S"<%="S".equals(as_recStatus)?" selected":""%>>Start</option>
			<option value="X"<%="X".equals(as_recStatus)?" selected":""%>>1st Send(Email)</option>
			<option value="Y"<%="Y".equals(as_recStatus)?" selected":""%>>2nd Send(Email)</option>			
			<option value="Z"<%="Z".equals(as_recStatus)?" selected":""%>>3rd Send(Email)</option>
			<option value="I"<%="I".equals(as_recStatus)?" selected":""%>>1st Send(Post)</option>
			<option value="L"<%="L".equals(as_recStatus)?" selected":""%>>2nd Send(Post)</option>			
			<option value="K"<%="K".equals(as_recStatus)?" selected":""%>>3rd Send(Post)</option>			
			<option value="R"<%="R".equals(as_recStatus)?" selected":""%>>Application received</option>						
			<option value="F"<%="F".equals(as_recStatus)?" selected":""%>>User follow up</option>			
			<option value="V"<%="V".equals(as_recStatus)?" selected":""%>>Information verified</option>			
			<option value="A"<%="A".equals(as_recStatus)?" selected":""%>>Approved</option>
			<option value="N"<%="N".equals(as_recStatus)?" selected":""%>>Inactive</option>						
			<option value="J"<%="J".equals(as_recStatus)?" selected":""%>>Reject</option>			
			<option value="D"<%="D".equals(as_recStatus)?" selected":""%>>Deleted</option>
			<option value="U"<%="U".equals(as_recStatus)?" selected":""%>>Updated-HATS&Email</option>						
			<option value="P"<%="P".equals(as_recStatus)?" selected":""%>>Updated-HATS&Post</option>
			<option value="E"<%="E".equals(as_recStatus)?" selected":""%>>Updated-No Respone</option>						
			</select>		
		</td>		
		<td align="left">
			<button onclick="return submitSearch();">Search</button>		
		</td>
		<td align="left">
			<button onclick="return submitAction('create','','','');">New Doctor</button>								
		</td>
		<td align="left">
			<button onclick="return submitAction('accept','','','');">Accept Verify</button>				
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="10%"><bean:message key="prompt.docfName" /></td>
		<td class="infoData" width="15%"><input type="textfield" name="docfName" value="<c:out value="${cts.as_docFname }"/>" maxlength="10" size="50"></td>				
		<td class="infoLabel" width="10%"><bean:message key="prompt.docgName" /></td>
		<td class="infoData" width="35%" colspan=3><input type="textfield" name="docgName" value="<c:out value="${cts.as_docGname }"/>" maxlength="10" size="50"></td>
<%--		
		<td align="left">
			<button onclick="return submitAction('genlist','','','');"><bean:message key='button.regenlist' /></button>
		</td>
		<td align="left">
			<button onclick="return submitAction('view1','','','');"><bean:message key='button.inact' /></button>			
		</td>		
		<td align="left">
<!-- For urgent sent APL alert email		
			<button onclick="return submitAction('noResp','','','');">No Response</button>	 
-->
		<button onclick="return submitAction('urgent','','','');">Urgent Send</button>
		</td>
											 --%>
	</tr>
	<table width="100%" border="0">
		<tr class="middleText">
			<td class=infoLabelBlk width="100" >
				<input type="checkbox" id="selectAll" />&nbsp;Select all
				&nbsp
				<select id="allRdStatus">
				<option value="">			
				<option value="S"<%="S".equals(as_recStatus)?" selected":""%>>Start</option>
				<option value="X"<%="X".equals(as_recStatus)?" selected":""%>>1st Send(Email)</option>
				<option value="Y"<%="Y".equals(as_recStatus)?" selected":""%>>2nd Send(Email)</option>			
				<option value="Z"<%="Z".equals(as_recStatus)?" selected":""%>>3rd Send(Email)</option>
				<option value="I"<%="I".equals(as_recStatus)?" selected":""%>>1st Send(Post)</option>
				<option value="L"<%="L".equals(as_recStatus)?" selected":""%>>2nd Send(Post)</option>			
				<option value="K"<%="K".equals(as_recStatus)?" selected":""%>>3rd Send(Post)</option>			
				<option value="R"<%="R".equals(as_recStatus)?" selected":""%>>Application received</option>						
				<option value="F"<%="F".equals(as_recStatus)?" selected":""%>>User follow up</option>			
				<option value="V"<%="V".equals(as_recStatus)?" selected":""%>>Information verified</option>			
				<option value="A"<%="A".equals(as_recStatus)?" selected":""%>>Approved</option>
				<option value="N"<%="N".equals(as_recStatus)?" selected":""%>>Inactive</option>						
				<option value="J"<%="J".equals(as_recStatus)?" selected":""%>>Reject</option>			
				<option value="D"<%="D".equals(as_recStatus)?" selected":""%>>Deleted</option>
				<option value="U"<%="U".equals(as_recStatus)?" selected":""%>>Updated-HATS&Email</option>						
				<option value="P"<%="P".equals(as_recStatus)?" selected":""%>>Updated-HATS&Post</option>
				<option value="E"<%="E".equals(as_recStatus)?" selected":""%>>Updated-No Respone</option>						
				</select>
				&nbsp
				<button onclick="return submitAllAction();" >
						Submit ALL
				</button>								
			</td>
		</tr>
	</table>		
<display:table id="row" name="requestScope.cts.table" export="true" pagesize="" class="tablesorter" requestURI="recordList2.htm">
	<display:column title="&nbsp;" media="html" style="width:10%">
		<%=pageContext.getAttribute("row_rowNum")%></br></br>	
		<input type="checkbox" name="isRcdCheck" id="isRcdCheck_<c:out value="${row.fields0}" />" value="Y" class="isRcdCheck" />
	</display:column>
	<display:column title="CTS NO." media="csv excel xml pdf">
		<c:out value="${row.fields0}" />		
	</display:column>
	<display:column title="CTS NO." media="html" style="width:5%">
		<c:set var="tempCtsType" value="${row.fields7}"/>   
		<c:set var="tempCtsStatus" value="${row.fields8}"/>
		<logic:equal name="row" property="fields8" value="R">
		<%if("N".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7())){ %>
			<a href="javascript:void(0);" onclick="submitNew('<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><c:out value="${row.fields0}" /></a>
		<%}else if("R".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7())){ %>	
			<a href="javascript:void(0);" onclick="submitRenew('<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><c:out value="${row.fields0}" /></a>
		<%}%>							
		</logic:equal>		 
		<logic:equal name="row" property="fields8" value="F">
			<a href="javascript:void(0);" onclick="submitRenew('<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><c:out value="${row.fields0}" /></a>							
		</logic:equal>
		<logic:equal name="row" property="fields8" value="V">
			<a href="javascript:void(0);" onclick="submitRenew('<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><c:out value="${row.fields0}" /></a>
		</logic:equal>
		<logic:equal name="row" property="fields8" value="A">
		<%if("N".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7())){ %>
			<a href="javascript:void(0);" onclick="submitNew('<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><c:out value="${row.fields0}" /></a>
		<%}else if("R".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7())){ %>	
			<a href="javascript:void(0);" onclick="submitRenew('<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><c:out value="${row.fields0}" /></a>
		<%}%>
		</logic:equal>						
		<logic:equal name="row" property="fields8" value="S">
			<c:out value="${row.fields0}" />	
		</logic:equal>
		<logic:equal name="row" property="fields8" value="X">
			<c:out value="${row.fields0}" />	
		</logic:equal>
		<logic:equal name="row" property="fields8" value="Y">
			<c:out value="${row.fields0}" />	
		</logic:equal>
		<logic:equal name="row" property="fields8" value="Z">
			<c:out value="${row.fields0}" />	
		</logic:equal>
		<logic:equal name="row" property="fields8" value="I">
			<c:out value="${row.fields0}" />	
		</logic:equal>
		<logic:equal name="row" property="fields8" value="L">
			<c:out value="${row.fields0}" />	
		</logic:equal>
		<logic:equal name="row" property="fields8" value="K">
			<c:out value="${row.fields0}" />	
		</logic:equal>
		<logic:equal name="row" property="fields8" value="N">
			<c:out value="${row.fields0}" />	
		</logic:equal>
		<logic:equal name="row" property="fields8" value="D">
			<c:out value="${row.fields0}" />	
		</logic:equal>
		<logic:equal name="row" property="fields8" value="U">
			<a href="javascript:void(0);" onclick="submitRenew('<c:out value="${row.fields0}" />');"><c:out value="${row.fields0}" /></a>
		</logic:equal>
		<logic:equal name="row" property="fields8" value="P">
			<a href="javascript:void(0);" onclick="submitRenew('<c:out value="${row.fields0}" />');"><c:out value="${row.fields0}" /></a>
		</logic:equal>
		<logic:equal name="row" property="fields8" value="E">
			<c:out value="${row.fields0}" />	
		</logic:equal>								
	</display:column>
	<display:column property="fields1" title="Doctor NO." style="width:5%" />
	<display:column property="fields2" title="Doctor Name" style="width:5%" />
	<display:column property="fields3" title="Specialty" style="width:10%" />
	<display:column property="fields4" title="Start_Date" style="width:5%" />
	<display:column property="fields5" title="<%=as_colDesc5%>" style="width:5%" />
	<display:column property="fields11" title="Record Create Date" style="width:5%" />		
	<display:column property="fields6" title="Email" style="width:8%" />	
	<display:column title="Record Type" media="html" style="width:5%">
		<logic:equal name="row" property="fields7" value="N">
			<input type=hidden name="recordType<c:out value="${row.fields0}" />" value="N">New Record</input>
		</logic:equal>
		<logic:equal name="row" property="fields7" value="R">
			<input type=hidden name="recordType<c:out value="${row.fields0}" />" value="R">Renewal</input>		
		</logic:equal>
		<logic:equal name="row" property="fields7" value="D">
			<input type=hidden name="recordType<c:out value="${row.fields0}" />" value="D">Inactive</input>
		</logic:equal>		
	</display:column>
	<display:column title="Record Status" media="html" style="width:5%">	
		<logic:equal name="row" property="fields7" value="N">
			<%if(((ReportableListObject)pageContext.getAttribute("row")).getFields6()!=null&&((ReportableListObject)pageContext.getAttribute("row")).getFields6().length()>0){ %>			
			<select name="recordStatus<c:out value="${row.fields0}" />" id="recordStatus_<c:out value="${row.fields0}" />">
				<option value="S"<%="S".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Start</option>
				<option value="X"<%="X".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>1st Send(Email)</option>
				<option value="Y"<%="Y".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>2nd Send(Email)</option>			
				<option value="Z"<%="Z".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>3rd Send(Email)</option>
				<option value="I"<%="I".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>1st Send(Post)</option>
				<option value="L"<%="L".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>2nd Send(Post)</option>			
				<option value="K"<%="K".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>3rd Send(Post)</option>			
				<option value="R"<%="R".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Application received</option>						
				<option value="F"<%="F".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>User follow up</option>			
				<option value="V"<%="V".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Information verified</option>			
				<option value="A"<%="A".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Approved</option>
				<option value="N"<%="N".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Inactive</option>			
				<option value="D"<%="D".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Deleted</option>			
			</select>
			<%}else{ %>
			<select name="recordStatus<c:out value="${row.fields0}" />" id="recordStatus_<c:out value="${row.fields0}" />">
				<option value="S"<%="S".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Start</option>
				<option value="I"<%="I".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>1st Send(Post)</option>
				<option value="L"<%="L".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>2nd Send(Post)</option>			
				<option value="K"<%="K".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>3rd Send(Post)</option>			
				<option value="R"<%="R".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Application received</option>						
				<option value="F"<%="F".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>User follow up</option>			
				<option value="V"<%="V".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Information verified</option>			
				<option value="A"<%="A".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Approved</option>
				<option value="N"<%="N".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Inactive</option>			
				<option value="D"<%="D".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Deleted</option>			
			</select>			
			<%} %>
		</logic:equal>
		<logic:equal name="row" property="fields7" value="R">
		<%if("U".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())){ %>			
			Updated-HATS&Email
		<%} else if("P".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())){ %>			
			Updated-HATS&Post					
		<%} else if("E".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())){ %>
			Updated-No Respone		
		<%} else { %>
			<%if(((ReportableListObject)pageContext.getAttribute("row")).getFields6()!=null&&((ReportableListObject)pageContext.getAttribute("row")).getFields6().length()>0){ %>
			<select name="recordStatus<c:out value="${row.fields0}" />" id="recordStatus_<c:out value="${row.fields0}" />">
				<option value="S"<%="S".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Start</option>
				<option value="X"<%="X".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>1st Renewal(Email)</option>
				<option value="Y"<%="Y".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>2nd Renewal(Email)</option>			
				<option value="Z"<%="Z".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>3rd Renewal(Email)</option>
				<option value="I"<%="I".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>1st Renewal(Post)</option>
				<option value="L"<%="L".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>2nd Renewal(Post)</option>			
				<option value="K"<%="K".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>3rd Renewal(Post)</option>			
				<option value="R"<%="R".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Application received</option>						
				<option value="F"<%="F".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>User follow up</option>			
				<option value="V"<%="V".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Information verified</option>			
				<option value="A"<%="A".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Approved</option>						
				<option value="J"<%="J".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Reject</option>			
				<option value="D"<%="D".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Deleted</option>			
			</select>			
			<%}else{ %>
			<select name="recordStatus<c:out value="${row.fields0}" />" id="recordStatus_<c:out value="${row.fields0}" />">
				<option value="S"<%="S".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Start</option>
				<option value="I"<%="I".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>1st Renewal(Post)</option>
				<option value="L"<%="L".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>2nd Renewal(Post)</option>			
				<option value="K"<%="K".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>3rd Renewal(Post)</option>			
				<option value="R"<%="R".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Application received</option>						
				<option value="F"<%="F".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>User follow up</option>			
				<option value="V"<%="V".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Information verified</option>			
				<option value="A"<%="A".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Approved</option>						
				<option value="J"<%="J".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Reject</option>			
				<option value="D"<%="D".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Deleted</option>			
			</select>			
			<%} %>
		<%} %>		
		</logic:equal>
		<logic:equal name="row" property="fields7" value="D">
		<select name="recordStatus<c:out value="${row.fields0}" />" id="recordStatus_<c:out value="${row.fields0}" />">
			<option value="S"<%="S".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Start</option>					
			<option value="A"<%="A".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Approved</option>			
			<option value="D"<%="D".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Deleted</option>			
		</select>		
		</logic:equal>					
	</display:column>
	<!--display:column title="Surgeon" style="width:3%; text-align:center"--> 
		<!--input type="checkbox" name="isSurg" value=1-->
	<!--/display:column-->
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">	
		<%if("J".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8()) ||
			 "A".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8()) ||				
			 "U".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8()) ||
			 "P".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8()) ||			 
			 "E".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())){ %>
		<%} else { %>
			<button onclick="return submitAction('submit','<c:out value="${row.fields0}" />','<c:out value="${row.fields7}" />','<c:out value="${row.fields8}" />');">
				<bean:message key='button.submit' />
			</button>		
		<%} %>
		<button onclick="return submitAction('view','<c:out value="${row.fields0}" />','','');">
			<bean:message key='button.history' />
		</button>				
	</display:column>
	<display:column titleKey="prompt.approver" media="html" style="width:10%; text-align:center">
		<%if(("F".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8()) ||
			 "V".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8()) ||
			 "R".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())) &&
			 "R".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7())){ %>	
			<select name="sendAppTo<c:out value="${row.fields0}" />">
			<%sendAppTo = ((ReportableListObject)pageContext.getAttribute("row")).getFields13() == null ? "" : ((ReportableListObject)pageContext.getAttribute("row")).getFields13(); %>
			<%if(sendAppTo!=null && sendAppTo.length()>0){ %>
				<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">
					<jsp:param name="sendAppTo" value="<%=sendAppTo %>" />
					<jsp:param name="category" value="cts" />								
				</jsp:include>									
			<%}else{ %>
				<option value=""></option>			
				<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">
					<jsp:param name="sendAppTo" value="<%=sendAppTo %>" />
					<jsp:param name="category" value="cts" />								
				</jsp:include>						
			<%} %>
			</select>
		<%} %>					
	</display:column>
	<display:column titleKey="prompt.assign" media="html" style="width:10%; text-align:center">
		<%if(("F".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8()) ||
			 "V".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8()) ||				
			 "R".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8()))&&
			 "R".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7())
			 ){ %>
			<button onclick="return submitAction('assign','<c:out value="${row.fields0}" />');"><bean:message key="button.assignDoc" /></button>		
		<%}%>
	</display:column>
	<display:column property="fields10" media="html" title="Password" style="width:5%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>	
</display:table>
<div id="progressbar" style="position:absolute; z-index:15;display:none;"
		class="ui-dialog ui-widget ui-widget-content ui-corner-all">
	<div class="ui-widget-header">Status</div><br/>
	<div class="progress-label">Loading...</div><br/>
</div>
<input type="hidden" name="command"/>
<input type="hidden" name="ctsNo"/>
<input type="hidden" name="recType"/>
<input type="hidden" name="recStatus"/>
<input type="hidden" name="createPdf"/>
<input type="hidden" name="assignDoc"/>
<input type="hidden" name="pageName"/>
</form>
<script language="javascript">
$(document).ready(function(){
	$('#selectAll').click(function() {
		if ($(this).attr('checked')) {
			$('.isRcdCheck').attr('checked', true);
		} else {
			$('.isRcdCheck').attr('checked', false);
		}
	});
	
	$('#allRdStatus').change(function() {
		if ($(this).attr("selected","selected")) {
            var value = $(this).val();
		<%
			if (ctsList != null) {
				if (ctsList.size()>0) {
					String field0 = null;
					for (int i = 0; i < ctsList.size(); i++) {
						ReportableListObject rlo = (ReportableListObject) ctsList.get(i);
						field0 = rlo.getValue(0);
		%>
					$('select[name=recordStatus<%=field0%>] option[value='+value+']').attr('selected', 'selected');
		<%					
					}
				}
			}
		%>			
			
		}	
	});
});

	// ajax
	var http = createRequestObject();

	function submitSearch() {
		document.search_form.pageName.value = 'cts/newRecordList';	
		document.search_form.submit();
	}

	function clearSearch() {
		document.location = "?";
	}
	
	function submitRenew(ctsNO,docCode) {		
		callPopUpWindow('../cts/renewForm.jsp?ctsNo='+ctsNO+'&docCode='+docCode+'&command=check&role=admin');
	}
	
	function submitNew(ctsNO,docCode) {
		alert('submitNew');
		callPopUpWindow('../cts/newDocForm.jsp?ctsNo='+ctsNO+'&docCode='+docCode+'&command=check&role=admin');
	}	
	
	function submitPreview() {
		callPopUpWindow("../cts/renewFormPreview.jsp");
	}	
	
	function submitAllAction() {
		//showLoadingBox('body', 100, 350);
		$('#progressbar').css('top', 350);
		$('#progressbar').css('left', $(window).width()/2-$('#progressbar').width()/2);
		$('#progressbar').show();		
		
		var successPost = 0;
		var failPost = 0;
		var totalPost=0;
		var postRecord=0;
        var isCheck = null;
        var select8 = null;
		
<%		
		if (ctsList != null) {
			for (int i = 0; i < ctsList.size(); i++) {				
				ReportableListObject rlo = (ReportableListObject) ctsList.get(i);
%>
				isCheck = $('#isRcdCheck_<%=rlo.getValue(0)%>').attr('checked');
				
				if(isCheck){
					totalPost++;
				}
<%			
			}	

			for (int i = 0; i < ctsList.size(); i++) {
				ReportableListObject rlo = (ReportableListObject) ctsList.get(i);				
%>
				isCheck = $('#isRcdCheck_<%=rlo.getValue(0)%>').attr('checked');
				

				if(isCheck){
					select8 = $('#recordStatus_<%=rlo.getValue(0)%> option:selected').val();
					$.ajax({
						url: '../cts/submitAllCtsRecord.jsp',
						data: {ctsNo:'<%=rlo.getValue(0)%>', docNo:'<%=rlo.getValue(1)%>', recType:'<%=rlo.getValue(7)%>', recStatus: select8},
						async: true,
						type: 'POST',
						success: function(data, textStatus, jqXHR) {
							if ($.trim(data)=='true') {
								successPost++;
							}else {
								failPost++;
							}							
						},
						error: function(jqXHR, textStatus, errorThrown) {
							failPost++;
						},
						complete: function(jqXHR, textStatus) {
							postRecord++;							
							if(totalPost==postRecord){
								submitSearch();
							}
							$('.progress-label').html(
									'Posting.......'+postRecord+'/'+totalPost+'<br/>'+
									'(Success: '+successPost+' Fail: '+failPost+')');
						}
					});					
				}
<%			}
		}%>	
		return false;
	}	
	
	function submitAction(cmd,arg1,arg2,arg3) {
		if (cmd=='submit') {			
			arg2 = document.search_form.elements["recordType" + arg1].value;
			arg3 = document.search_form.elements["recordStatus" + arg1].value;

			document.search_form.command.value = cmd;
			document.search_form.ctsNo.value = arg1;
			document.search_form.recType.value = arg2;
			document.search_form.recStatus.value = arg3;
			document.search_form.pageName.value = 'cts/newRecordList';				
						
			if (arg3=='I'||arg3=='L'||arg3=='K'||arg3=='N') {
				document.search_form.createPdf.value = "Y";
			}
					
			document.search_form.submit();
			return false;					
		} else if (cmd=='create') {
			callPopUpWindow("../cts/newDocByManual.jsp");	
			return false;
		} else if(cmd=='view') {
			callPopUpWindow("../cts/newDoc.jsp?command="+cmd+"&cts_no="+arg1);
			return false;						
		} else if(cmd=='view1') {
			callPopUpWindow("../cts/inactiveDoc.jsp");
			return false;	
		} else if(cmd=='genlist') {
			document.search_form.command.value = cmd;		
			document.search_form.submit();							
		} else if(cmd=='accept') {
			callPopUpWindow("../cts/accept_verify.jsp");
			return false;
		} else if (cmd=='assign') {
			document.search_form.command.value = cmd;
			document.search_form.ctsNo.value = arg1;
			document.search_form.assignDoc.value = document.search_form.elements["sendAppTo" + arg1].value;					
			document.search_form.submit();
			return false;
		} else if (cmd=='urgent') {
			document.search_form.command.value = cmd;		
			document.search_form.submit();				
		} else if(cmd=='noResp') {
			callPopUpWindow("../cts/no_response.jsp");
			return false;
		}				
	}

	function getApproverList(inputObj) {
		var did = inputObj.value;
		$.ajax({
			type: "POST",
			url: "../ui/approvalIDCMB.jsp",
			data: "sendAppTo=" + did + "&category=cts",
			success: function(values){
				if(values != '') {
					$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
				}//if
			}//success
		});//$.ajax			
	}
	
	// ajax
	var http = createRequestObject();	
	
<%	if (letter1Action) { %>
	callPopUpWindow('/intranet/FopServlet?fo=<%=ConstantsServerSide.UPLOAD_WEB_FOLDER %>/CTS/<%=as_ctsNo %>/letter1.fo');
<%	} %>
<%	if (letter2Action) { %>
	callPopUpWindow('/intranet/FopServlet?fo=<%=ConstantsServerSide.UPLOAD_WEB_FOLDER %>/CTS/<%=as_ctsNo %>/letter2.fo');
<%	} %>
</script>
</div>
</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>