<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
UserBean userBean = new UserBean(request);
//String command = ParserUtil.getParameter(request, "command");
String command = request.getParameter("command");
System.err.println("1[command]:"+command);
String step = (String) request.getParameter("step");
if (step == null) {
	step = request.getParameter("step");
}
String deptCode = request.getParameter("deptCode");
String deptName = request.getParameter("deptName");
String budgetCode = request.getParameter("budgetCode");
String budgetDesc = request.getParameter("budgetDesc");
String budgetAmt = request.getParameter("budgetAmt");
String effStartDate = request.getParameter("effStartDate");
String effEndDate = request.getParameter("effEndDate");
String remarks = request.getParameter("remarks");
String budgetEnabled = request.getParameter("budgetEnabled");
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

String title = null;
int noOfRecord = 0; 
boolean successUpt = false;
boolean createAction = false;
boolean updateAction = false;
boolean viewAction = false;
boolean deleteAction = false;
boolean closeAction = false;
	
if("view".equals(command)){
	viewAction = true;
}else if ("save".equals(command)) {
	if("0".equals(step)){
		updateAction = true;			
	}else if("1".equals(step)){
		createAction = true;
	}
}else if ("cancel".equals(command)) {
	deleteAction = true;
}

try {
	if ("create".equals(command)) {
		budgetCode = "";
		budgetDesc = "";
		budgetAmt = "";
		remarks = "";
		budgetEnabled = "1";
		
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.DAY_OF_YEAR, 1);    
		//cal.set(Calendar.DAY_OF_MONTH, 31); // new years eve
		Date date = cal.getTime();
		SimpleDateFormat format1 = new SimpleDateFormat("dd/MM/yyyy");
		effStartDate = format1.format(date);
		cal.set(Calendar.MONTH, 11); // 11 = december
		cal.set(Calendar.DAY_OF_MONTH, 31);
		date = cal.getTime();
		effEndDate = format1.format(date);		
	}
	
	budgetCode = budgetCode == null ? budgetCode : budgetCode.trim();
} catch (Exception e) {
	e.printStackTrace();
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%

System.err.println("[budgetCode]:"+budgetCode+";[budgetEnabled]:"+budgetEnabled+";[remarks]:"+remarks);
if(createAction){
	successUpt = EPORequestDB.addBudgetCode(userBean, "BC", budgetCode, effStartDate, effEndDate, deptCode, budgetDesc,  budgetAmt, remarks, budgetEnabled);
	
	if (successUpt){
		message = "Budget create success";
		createAction = false;
		viewAction = true;
		command = "view";		
		
		ArrayList record = EPORequestDB.getBudgetList(deptCode, budgetCode, budgetDesc, budgetAmt, budgetEnabled); 
		noOfRecord = record.size();		
		if(noOfRecord>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			deptCode = row.getValue(0);
			deptName = row.getValue(1);				
			budgetCode = row.getValue(2);
			budgetDesc = row.getValue(3);			
			budgetAmt = row.getValue(4);
			effStartDate = row.getValue(5);				
			effEndDate = row.getValue(6);
			remarks = row.getValue(7);
			budgetEnabled = row.getValue(8);			
		}		
	} else {
		errorMessage = "Budget create fail.";
		updateAction = false;			
	}
}else if(updateAction){
	successUpt = EPORequestDB.updateBudgetDetail(userBean, "BC", budgetCode, budgetAmt, budgetDesc,  effStartDate, effEndDate, remarks, budgetEnabled);
	
	if (successUpt){
		message = "Budget update success";
		updateAction = false;
		viewAction = true;
		command = "view";
		
		ArrayList record = EPORequestDB.getBudgetList(deptCode, budgetCode, budgetDesc, budgetAmt, budgetEnabled); 
		noOfRecord = record.size();		
		if(noOfRecord>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			deptCode = row.getValue(0);
			deptName = row.getValue(1);				
			budgetCode = row.getValue(2);
			budgetDesc = row.getValue(3);			
			budgetAmt = row.getValue(4);
			effStartDate = row.getValue(5);				
			effEndDate = row.getValue(6);
			remarks = row.getValue(7);
			budgetEnabled = row.getValue(8);			
		}		
	} else {
		errorMessage = "Budget update fail.";
		updateAction = false;			
	}				
}else if(viewAction){		
//load data from database
	if (budgetCode != null && budgetCode.length() > 0) {	
		ArrayList record = EPORequestDB.getBudgetList(deptCode, budgetCode, budgetDesc, budgetAmt, budgetEnabled); 
		noOfRecord = record.size();
		if(noOfRecord>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			deptCode = row.getValue(0);
			deptName = row.getValue(1);				
			budgetCode = row.getValue(2);
			budgetDesc = row.getValue(3);			
			budgetAmt = row.getValue(4);
			effStartDate = row.getValue(5);				
			effEndDate = row.getValue(6);
			remarks = row.getValue(7);
			budgetEnabled = row.getValue(8);			
		}		
	}
}
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Budget Update" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="BudgetForm" id="BudgetForm" action="budget_update.jsp" method=post >
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
<%	if ("create".equals(command)) { %>			
			<select name="deptCode">
				<option value="">--- All Departments ---</option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>
<%	} else { %>
		<input type="hidden" name="deptCode" value="<%=deptCode %>"><%=deptName %></input>
<%	} %>				
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Budget Code</td>
		<td class="infoData" width="70%">
<%	if ("create".equals(command)) { %>		
			<input type="text" name="budgetCode" value="" maxlength="30" size="20" ></input>
<%	}else{ %>
			<input type="hidden" name="budgetCode" value="<%=budgetCode %>" maxlength="30" size="30"><%=budgetCode %></input>
<%	} %>			
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Description</td>
		<td class="infoData" width="70%">
			<input type="text" name="budgetDesc" value="<%=budgetDesc%>" maxlength="100" size="80" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Amount</td>
		<td class="infoData" width="70%">
			<input type="text" name="budgetAmt" value="<%=budgetAmt%>" maxlength="9" size="9" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Remarks</td>
		<td class="infoData" width="70%">
			<input type="text" name="remarks" value="<%=remarks%>" maxlength="500" size="80" />
		</td>
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
			<input type="checkbox" name="budgetEnabled" id="budgetEnabled" value="1" <%="1".equals(budgetEnabled)?" checked=checked":"" %>/> 
		</td>
	</tr>			
</table>	
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if ("create".equals(command)) { %>
			<button onclick="return submitAction('save', 1);" class="btn-click"><bean:message key="button.save" /></button>
<%	} else { %>
			<button onclick="return submitAction('save', 0);" class="btn-click">Update</button>
<%	}  %>
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command"/>
<input type="hidden" name="step"/>
<input type="hidden" name="budgetCode" value="<%=budgetCode %>"/>
<input type="hidden" name="deptName" value="<%=deptName %>"/>
</form>
<script language="javascript">
	$(document).ready(function() {	
		window.opener.refresh();
	});
	
	function closeAction() {
		window.close();
	}

	$('BudgetForm').submit(function() {
		$('#select2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});

		$('#noLevelGroupIDSelect2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
	});

	function submitAction(cmd, stp) {	
		if (cmd == 'save') {
			if(document.BudgetForm.deptCode.value==""){
				alert('Please select department first!');
				document.BudgetForm.deptCode.focus();
				return false;				
			}
			if (document.BudgetForm.budgetCode.value == "") {
				alert('Please input budget code!');
				document.BudgetForm.budgetCode.focus();
				return false;
			}			
			if(document.BudgetForm.budgetDesc.value==""){
				alert('Please input budget description!');
				document.BudgetForm.deptCode.focus();
				return false;				
			}			
			if(isNaN(document.BudgetForm.budgetAmt.value) || document.BudgetForm.budgetAmt.value==""){
				alert('Please input valid amount!');
				document.BudgetForm.budgetAmt.focus();
				return false;								
			}
		}
		
		var budgetEnabled = null;
		if ($('input[name=budgetEnabled]:checked').is(':checked')){
			budgetEnabled = "1";
		}else{
			budgetEnabled = "0";				
		}

		var r=confirm("Confirm to save?");			
			
		if (r==true){			
			document.BudgetForm.command.value = cmd;
			document.BudgetForm.budgetEnabled.value = budgetEnabled;
			document.BudgetForm.step.value = stp;			
			document.BudgetForm.submit();
			return false;	
		 }else{
			 return false;	
		 }		
	}
</script>
<br/>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp"/>
</body>
</html:html>