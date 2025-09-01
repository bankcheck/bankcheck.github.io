  <%@ page import="java.util.*"
%><%@ page import="com.hkah.config.*"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%
UserBean userBean = new UserBean(request);
String ceTotalID = request.getParameter("ceTotalID");
String loginID = userBean.getLoginID();
String command = request.getParameter("command");
String step = request.getParameter("step");
String siteCode = request.getParameter("siteCode");
String deptCode = request.getParameter("deptCode");
String deptName = request.getParameter("deptName");
String positionDesc= request.getParameter("positionDesc");
String positionCode= request.getParameter("positionCode");
String hireDate= request.getParameter("hireDate");
String staffID= request.getParameter("staffID");
String staffName=request.getParameter("staffName");
String budgetYear= request.getParameter("budgetYear");
String budgetYearAmount= request.getParameter("budgetYearAmount");
String budgetYearHours= request.getParameter("budgetYearHours");
String leftBudgetYearAmount= request.getParameter("leftBudgetYearAmount");
String leftBudgetYearHours= request.getParameter("leftBudgetYearHours");
String remark= request.getParameter("remark");



boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
	//	if (createAction || updateAction){
	//	errorMessage = MessageResources.getMessage(session, "error.ceBudget.required");
	//	} else 
		if (createAction) {
			if(Budget.add(userBean,siteCode,deptCode,deptName,
				positionDesc,positionCode,hireDate,
				staffID, budgetYear,budgetYearAmount, 
				budgetYearHours,leftBudgetYearAmount,leftBudgetYearHours,remark)){
				message = "CE Budget created.";
				createAction = false;
				step="0";
			} else {
				errorMessage = "CE Budget create fail.";
			}
		} else if (updateAction) {
			if(Budget.update(userBean,staffID,deptCode,	deptName,
			positionDesc, positionCode,budgetYearHours, budgetYearAmount,
			leftBudgetYearHours,leftBudgetYearAmount,remark)) {	
				message = "CE Budget updated.";
				updateAction = false;
				step="0";
			} else {
				errorMessage = "CE Budget update fail.";
			}
		} else if (deleteAction) {
			if (Budget.delete(userBean,ceTotalID)) {
				message = "CE Budget removed.";
				System.err.println(message);
				closeAction = true;
			} else {
				errorMessage = "CE Budget remove fail.";
				System.err.println(message);
			}
		}
	} else if (createAction) {
		siteCode = ConstantsServerSide.SITE_CODE;
	}

	

	// load data from database
	if (!createAction && !"1".equals(step)) {
	if (ceTotalID != null && ceTotalID.length() > 0) {
			ArrayList record = Budget.getBudgetList(ceTotalID);	
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				siteCode = row.getValue(1);
				deptCode = row.getValue(2);
				deptName = row.getValue(3);
				positionDesc = row.getValue(4);
				positionCode = row.getValue(5);
				hireDate = row.getValue(6);
				staffName = row.getValue(7);
				staffID = row.getValue(8);
			 	budgetYear= row.getValue(9);
				budgetYearHours = row.getValue(10);
				budgetYearAmount = row.getValue(11);
				leftBudgetYearAmount = row.getValue(12);
				leftBudgetYearHours= row.getValue(13);
				remark=row.getValue(14);
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
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
	title = "function.ceBudget." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="ce_budget.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.site" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
<jsp:include page="../ui/siteCodeRDB.jsp" flush="false">
	<jsp:param name="allowAll" value="<%=siteCode.toLowerCase()%>" />
</jsp:include>
<%	} else { %>
			<%=siteCode.toUpperCase() %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="deptName" value="<%=deptName==null?"":deptName %>" maxlength="100" size="50">
<%	} else { %>
			<%=deptName==null?"":deptName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.positionDesc" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="positionDesc" value="<%=positionDesc==null?"":positionDesc %>" maxlength="100" size="50">
<%	} else { %>
			<%=positionDesc==null?"":positionDesc %>
<%	} %>
		</td>
	</tr>	

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.hireDate" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="hireDate" value="<%=hireDate==null?"":hireDate %>" maxlength="100" size="50">
<%	} else { %>
			<%=hireDate==null?"":hireDate %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="70%">
			<%=staffID==null?"":staffID %> ( <%=staffName==null?"":staffName %> )
		</td>
	</tr>		
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.budgetYear" /></td>
		<td class="infoData" width="70%"> <%=budgetYear==null?"":budgetYear %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.budgetHours" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="budgetYearHours" value="<%=budgetYearHours==null?"":budgetYearHours %>" maxlength="100" size="50">
<%	} else { %>
			<%=budgetYearHours==null?"":budgetYearHours %>
<%	} %>
		</td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.budgetAmount" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="budgetYearAmount" value="<%=budgetYearAmount==null?"":budgetYearAmount %>" maxlength="100" size="50">
<%	} else { %>
			<%=budgetYearAmount==null?"":budgetYearAmount %>
<%	} %>
		</td>
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.leftBudgetHours" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="leftBudgetYearHours" value="<%=leftBudgetYearHours==null?"":leftBudgetYearHours %>" maxlength="100" size="50">
<%	} else { %>
			<%=leftBudgetYearHours==null?"":leftBudgetYearHours %>
<%	} %>
		</td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.leftBudgetAmount" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="leftBudgetYearAmount" value="<%=leftBudgetYearAmount==null?"":leftBudgetYearAmount %>" maxlength="100" size="50">
<%	} else { %>
			<%=leftBudgetYearAmount==null?"":leftBudgetYearAmount %>
<%	} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.remarks" /></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="remark" value="<%=remark==null?"":remark %>" maxlength="100" size="50">
<%	} else { %>
			<%=remark==null?"":remark %>
<%	} %>
		</td>
	</tr>


	
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.ceBudget.update" /></button>
			<button class="btn-delete"><bean:message key="function.ceBudget.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<html:hidden property="command" value="" />
<html:hidden property="step" value="" />
<input type="hidden" name="ceTotalID" value="<%=ceTotalID %>">
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>