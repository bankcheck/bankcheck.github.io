<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String as_docNo = request.getParameter("docNo");
String as_recType = request.getParameter("recType");
String as_docFname = null;
String as_docGname = null;
request.setAttribute("CTS", CTS.getRecord(as_docNo, as_recType, null, as_docFname, as_docGname));

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
	<jsp:param name="pageTitle" value="function.cts.list" />
	<jsp:param name="category" value="group.cts" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.cts.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="search_form" action="recordList.jsp" method="post" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5" 
		class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.docNo" /></td>
		<td class="infoData" width="35%"><input type="textfield" name="docNo" value="<%=as_docNo==null?"":as_docNo %>" maxlength="10" size="50"></td>	
		<td align="left">
			<button onclick="return submitSearch();">Search</button>
		</td>
		<td align="left">
			<button onclick="return submitAction('create');">New Doctor</button>
		</td>														
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.recType" /></td>	
		<td class="infoData" width="35%">
			<select name="recType">
				<option value="">			
				<option value="N"<%="N".equals(as_recType)?" selected":""%>>New</option>
				<option value="R"<%="R".equals(as_recType)?" selected":""%>>Renewal</option>					
				<option value="D"<%="D".equals(as_recType)?" selected":""%>>Inactive</option>
			</select>		
		</td>	
	</tr>	
</table>
<display:table id="row" name="requestScope.CTS" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="CTS NO." style="width:5%" />
	<display:column property="fields1" title="Doctor NO." style="width:5%" />
	<display:column property="fields2" title="Doctor Name" style="width:10%" />
	<display:column property="fields3" title="Specialty" style="width:13%" />
	<display:column property="fields4" title="Start Date" style="width:5%" />
	<display:column property="fields5" title="Termination Date" style="width:5%" />	
	<display:column property="fields6" title="Email" style="width:10%" />
	<display:column property="fields7" title="Record Type" style="width:5%" />
	<display:column title="Record Status" style="width:5%">		
		<select name="recordStatus">
			<option value="S"<%="S".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>Start</option>
			<option value="X"<%="X".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>1st Renenal</option>
			<option value="Y"<%="Y".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>2nd Renenal</option>			
			<option value="Z"<%="Z".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields8())?" selected":"" %>>3rd Renenal</option>			
		</select>
	</display:column>
	<!--display:column title="Surgeon" style="width:3%; text-align:center"--> 
		<!--input type="checkbox" name="isSurg" value=1-->
	<!--/display:column-->
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
	<button onclick="submitAction('submit','<c:out value="${row.fields0}" />');"><bean:message key='button.submit' /></button>
	<%if("NEW RECORD".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields7())){ %>
		<button onclick="submitAction('view','<c:out value="${row.fields0}" />');"><bean:message key='button.modify' /></button>
	<%} %>				
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>	
</display:table>
</form>
<script language="javascript">

	function submitSearch() {
		document.search_form.submit();
	}

	function submitAction(cmd,cts_no) {
		if (cmd=='create') {
			callPopUpWindow("../cts/newDoc.jsp");	
			return false;
		} else if(cmd=='view') {
			callPopUpWindow("../cts/newDoc.jsp?command="+cmd+"&cts_no="+cts_no);
			return false;						
		}
	}
	
	function clearSearch() {
		return false;
	}

	// ajax
	var http = createRequestObject();	
	
	$(document).ready(function(){
		$('#date_from').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#date_to').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#flw_date_from').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#flw_date_to').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });		
	});	
</script>
</div>
</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>