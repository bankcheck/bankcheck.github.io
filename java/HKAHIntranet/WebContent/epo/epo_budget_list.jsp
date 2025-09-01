<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
System.err.println("111[command]:"+command);
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

Calendar cal = Calendar.getInstance();
cal.set(Calendar.DAY_OF_YEAR, 1);    
//cal.set(Calendar.DAY_OF_MONTH, 31); // new years eve
Date date = cal.getTime();
SimpleDateFormat format1 = new SimpleDateFormat("dd/MM/yyyy");
String effStartDate = format1.format(date);
cal.set(Calendar.MONTH, 11); // 11 = december
cal.set(Calendar.DAY_OF_MONTH, 31);
date = cal.getTime();
String effEndDate = format1.format(date);
String deptCode = request.getParameter("deptCode");
System.err.println("1[deptCode]:"+deptCode);
String budgetCode = request.getParameter("budgetCode");
String budgetDesc = request.getParameter("budgetDesc");
String budgetAmt = request.getParameter("budgetAmt");
String budgetEnabled = request.getParameter("budgetEnabled");


if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

boolean searchAction = false;

if("search".equals(command)){
	searchAction = true;
}

if(searchAction){
	System.err.println("[searchAction]:");
	request.setAttribute("budget_list", EPORequestDB.getBudgetList( deptCode, budgetCode, budgetDesc, budgetAmt, budgetEnabled));	
}


%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="ePR Budget Code" />
		<jsp:param name="category" value="Report" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="epo_budget_list.jsp" method="post" onsubmit="return submitSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
			<select name="deptCode">
				<option value="">--- All Departments ---</option>
				<%deptCode = deptCode == null ? "" : deptCode; %>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="allowAll" value="Y" />
	<jsp:param name="includeAllDept" value="Y" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Budget Code</td>
		<td class="infoData" width="70%"><input type="textfield" name="budgetCode" value="" maxlength="30" size="50"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Description</td>
		<td class="infoData" width="70%"><input type="textfield" name="budgetDesc" value="" maxlength="100" size="50"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Amount</td>
		<td class="infoData" width="70%"><input type="textfield" name="budgetAmt" value="" maxlength="38" size="50"></td>
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="30%">Effective Start Date</td>
		<td class="infoData" width="70%">		
			<input type="textfield" name="effStartDate" id="effStartDate" class="datepickerfield" value="<%=effStartDate==null?"":effStartDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)				
		</td>
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="30%">Effective End Date</td>
		<td class="infoData" width="70%">		
			<input type="textfield" name="effEndDate" id="effEndDate" class="datepickerfield" value="<%=effEndDate==null?"":effEndDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)				
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="30%">Enabled</td>	
		<td class="infoData" width="70%">
			<input type="checkbox" name="budgetEnabled" id="budgetEnabled" value="1" checked="checked"></input>
		</td>
	</tr>	
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitAction('create', '', '', '', '', '', '');"><bean:message key="button.create" /></button>		
			<button onclick="return submitSearch('search');"><bean:message key="button.search" /></button>
			<button type="reset"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
<display:table id="row" name="requestScope.budget_list" export="true" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%></display:column>
	<display:column property="fields0" title="Dept Code" style="width:5%" />
	<display:column property="fields1" title="Department Name" style="width:20%" />
	<display:column property="fields2" title="Budget Code" style="width:10%" />
	<display:column property="fields3" title="Description" style="width:25%" />
	<display:column property="fields4" title="Amount" style="width:10%" />
	<display:column property="fields9" title="Enabled" style="width:5%" />	
	<display:column property="fields7" title="Remarks" style="width:15%" />	
	<display:column property="fields8" title="" style="width:0%" media="none"/>	
	<display:column titleKey="prompt.action" media="html" style="width:5%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields1}" />', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields3}" />', '<c:out value="${row.fields4}" />', '<c:out value="${row.fields8}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="sort.budgetCode" value="list"/>
</display:table>
<input type="hidden" name="command" />
</form>
<script language="javascript">
	function refresh(){
		submitSearch('search');
	}		

	function submitSearch(cmd) {		
		document.search_form.command.value = cmd;
		document.search_form.submit();
		return false;
	}
	
	function submitAction(cmd, deptCode, deptName ,budgetCode , budgetDesc, budgetAmt, budgetEnabled) {
		callPopUpWindow("../epo/budget_update.jsp?command=" + cmd + "&deptCode=" + deptCode + "&deptName=" + deptName + "&budgetCode=" + budgetCode + "&budgetDesc=" + budgetDesc + "&budgetAmt=" + budgetAmt + "&budgetEnabled=" + budgetEnabled + "&step=0");
		return false;
	}

	function clearSearch() {
		document.search_form.deptCode.value = "";		
		document.search_form.budgetCode.value = "";
		document.search_form.budgetDesc.value = "";
		document.search_form.budgetAmt.value = "";
		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){

			//read and assign the response from the server
			var response = http.responseText;

			//do additional parsing of the response, if needed

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("budget_list_result").innerHTML = response;

			//If the server returned an error message like a 404 error, that message would be shown within the div tag!!.
			//So it may be worth doing some basic error before setting the contents of the <div>
		}
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>