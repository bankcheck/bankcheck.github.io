<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
	UserBean userBean = new UserBean(request);
	String loginID = userBean.getLoginID();
	String command = request.getParameter("command");
	String step = request.getParameter("step");
	String approvedTransID = request.getParameter("approvedTransID");

	String claimMoney = request.getParameter("claimMoney");
	String claimHours = request.getParameter("claimHours");
	String hrRemark = request.getParameter("hrRemark");
	String transID = request.getParameter("transID");
	String siteCode = request.getParameter("siteCode");

	String approvedDate = request.getParameter("approvedDate");
	String category = request.getParameter("category");
	String deptName = request.getParameter("eptName");
	String staffID = request.getParameter("staffID");
	String staffName = request.getParameter("staffName");
	String amount = request.getParameter("amount");
	String hours = request.getParameter("hours");
	String actionNo = request.getParameter("actionNo");
	String attendingDate = request.getParameter("AttendingDate");
	String courseName = request.getParameter("courseName");
	String usedMoney=request.getParameter("usedMoney");
	String usedHours=request.getParameter("usedHours");

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
System.err.println("command ["+command);
	try {
		if ("1".equals(step)) {
		//	if (createAction) {
			//	createAction=false;
		//	} else 
			if (updateAction) {
				StringBuffer sqlStr = new StringBuffer();
				sqlStr.append("UPDATE CE_APPROVED_TRANS ");
				sqlStr.append("SET    CE_HR_REMARK = ?, CE_CLAIMEDMONEY = ?, CE_CLAIMEDHOURS = ?,CE_USEDMONEY=?,CE_USEDHOURS=?,");
				sqlStr.append("       CE_MODIFIED_DATE = SYSDATE, CE_MODIFIED_USER = ? ");
				sqlStr.append("WHERE  CE_ENABLED = 1 ");
				sqlStr.append("AND    CE_APPROVED_TRANS_ID = ?");
				if (UtilDBWeb.updateQueue(sqlStr.toString(),
					new String[] { hrRemark, claimMoney,claimHours,usedMoney, usedHours,  loginID,
					approvedTransID })) {
					message = "CE Claim updated.";
					updateAction = false;
					step="0";
				} else {
					errorMessage = "CE Claim update fail.";
				}
			} else if (deleteAction) {
				StringBuffer sqlStr = new StringBuffer();
				sqlStr.append("UPDATE CE_APPROVED_TRANS ");
				sqlStr.append("SET    CE_ENABLED = 0, CE_MODIFIED_DATE = SYSDATE, CE_MODIFIED_USER = ? ");
				sqlStr.append("WHERE  CE_ENABLED = 1 ");
				sqlStr.append("AND    CE_APPROVED_TRANS_ID = ?");
				System.err.println("approvedTransid[ "+approvedTransID);
				if (UtilDBWeb.updateQueue(sqlStr.toString(),
					new String[] { loginID, approvedTransID })) {
					message = "CE Claim removed.";
					closeAction = true;
					step="0";
				} else {
					errorMessage = "CE claim remove fail.";
				}
			}
		} 

		// load data from database
		if (!createAction && !"1".equals(step)) {
			if (approvedTransID != null && approvedTransID.length() > 0) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT T.CE_APPROVED_TRANS_ID, T.CE_SITE_CODE, TO_CHAR(T.CE_APPROVED_DATE,'DD/MM/YYYY'), ");
		sqlStr.append("     T.CE_CATEGORY, T.CE_DEPT_NAME, ");
		sqlStr.append("     T.CE_STAFF_ID, S.CO_STAFFNAME, T.CE_AMOUNT, T.CE_HOURS, T.CE_ACTION_NO,  ");
		sqlStr.append("     T.CE_ATTENDING_DATE, T.CE_COURSE_NAME, T.CE_CLAIMEDMONEY, T.CE_CLAIMEDHOURS,  T.CE_HR_REMARK,  ");
		sqlStr.append("     T.CE_USEDMONEY, T.CE_USEDHOURS  ");
		sqlStr.append("FROM CE_APPROVED_TRANS T , CO_STAFFS S ");
		sqlStr.append("WHERE  T.CE_SITE_CODE = S.CO_SITE_CODE(+) ");
		sqlStr.append("AND    T.CE_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND   T.CE_ENABLED = 1 ");
		sqlStr.append("AND  T.CE_APPROVED_TRANS_ID = ?");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { approvedTransID });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			transID = row.getValue(0);
			siteCode = row.getValue(1);
			approvedDate = row.getValue(2);
			category = row.getValue(3);
			deptName = row.getValue(4);
			staffID = row.getValue(5);
			staffName= row.getValue(6);
			amount = row.getValue(7);
			hours = row.getValue(8);
			actionNo = row.getValue(9);
			attendingDate = row.getValue(10);
			courseName = row.getValue(11);
			claimMoney = row.getValue(12);
			claimHours = row.getValue(13);
			hrRemark = row.getValue(14);
			usedMoney=row.getValue(15);
			usedHours=row.getValue(16);

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
<%
if (closeAction) {
%>
<script type="text/javascript">window.close();</script>
<%
} else {
%>
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
		title = "function.ceClaim." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message%></font>
<font color="red"><%=errorMessage%></font>
<form name="form1" action="ce_claim.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.site" /></td>
		<td class="infoData" width="70%"><%=siteCode == null ? "" : siteCode%>	</td>
	</tr>
<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%"><%=deptName == null ? "" : deptName%>	</td>
	</tr>
<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.approvedDate" /></td>
		<td class="infoData" width="70%"><%=approvedDate == null ? "" : approvedDate%>	</td>
	</tr>	
<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="70%"><%=staffID == null ? "" : staffID%> (<%=staffName %>)	</td>
	</tr>
<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.category" /></td>
		<td class="infoData" width="70%"><%=category == null ? "" : category%>	</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.amount" /></td>
		<td class="infoData" width="70%"><%=amount == null ? "" : amount%> </td>

	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.hours" /></td>
		<td class="infoData" width="70%"><%=hours == null ? "" : hours%> </td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.actionNo" /></td>
		<td class="infoData" width="70%"><%=actionNo == null ? "" : actionNo%> </td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.attendingDate" /></td>
		<td class="infoData" width="70%"><%=attendingDate == null ? "" : attendingDate%> </td>
	</tr>	

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.courseName" /></td>
		<td class="infoData" width="70%"><%=courseName == null ? "" : courseName%> </td>
	</tr>
	
	

	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.claimMoney" /></td>
		<td class="infoData" width="70%">
<%
if (createAction || updateAction) {
%>
			<input type="radio" name="claimMoney" onclick="toggleMoneyFields(this)" value="1"<%="1".equals(claimMoney)?"checked":"" %>><bean:message key="label.yes"    />
			<input type="radio" name="claimMoney" onclick="toggleMoneyFields(this)" value="0"<%="0".equals(claimMoney)?"checked":"" %>><bean:message key="label.no"   />
			

<%
} else {
%>
			<%=claimMoney.equals("0") ? "No" : "Yes" %>
<%
}

%>
    	</td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.claimHours" /></td>
		<td class="infoData" width="70%">
<%
if (createAction || updateAction) {
%>
			<input type="radio" name="claimHours" onclick="toggleHoursFields(this)" value="1"<%="1".equals(claimHours)?"checked":"" %>><bean:message key="label.yes" />
			<input type="radio" name="claimHours" onclick="toggleHoursFields(this)" value="0"<%="0".equals(claimHours)?"checked":"" %>><bean:message key="label.no" />
<%
} else {
%>
			<%=claimHours.equals("0") ? "No" : "Yes" %>
<%
}

%>
    	</td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.hrRemark" /></td>
		<td class="infoData" width="70%">
<%
if (createAction || updateAction) {
%>
			<input type="textfield" name="hrRemark" value="<%=hrRemark==null?"":hrRemark %>" maxlength="100" size="50">
<%
} else {
%>
			<%=hrRemark == null ? "" : hrRemark%>
<%
}
%>
		</td>
	</tr>
<%
if (!claimMoney.equals("1") ) {
%>	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.usedMoney" /></td>
		<td class="infoData" width="70%">
<%
if (createAction || updateAction ) {
%>
			<input type="textfield" name="usedMoney" value="<%=usedMoney==null?"0":usedMoney %>" maxlength="100" size="50">
<%
} else {
%>
			<%=usedMoney == null ? "0" : usedMoney%>
<%
}
%>
		</td>
	</tr>
<%
}
%>
	

<%
if (!claimHours.equals("1") ) {
%>		
<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.usedHours" /></td>
		<td class="infoData" width="70%">
<%
if (createAction || updateAction) {
%>
			<input type="textfield" name="usedHours" value="<%=usedHours==null?"0":usedHours %>" maxlength="100" size="50">
<%
} else {
%>
			<%=usedHours == null ? "0" : usedHours%>
<%
}
%>
		</td>
	</tr>
<%
}
%>

</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%
if (createAction || updateAction || deleteAction) {
%>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
	
<%
} else {
%>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.ceClaim.update" /></button>
			<button class="btn-delete"><bean:message key="function.ceClaim.delete" /></button>
<%
} 
%>


		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="approvedTransID" value="<%=approvedTransID %>">
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.hrRemark.value == '') {
				alert("Missing HR Remark field.");
				document.form1.hrRemark.focus();
				return false;
			}
			if (isNaN(document.form1.usedMoney.value)){ 
				alert("Invilad Claimed Money. ");
				document.form1.usedMoney.focus();
				return false;
			}
			if (isNaN(document.form1.usedHours.value)){ 
				alert("Invilad Claimed Hours. ");
				document.form1.usedHours.focus();
				return false;
			}
		}


<%	} %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
	

function toggleMoneyFields(myField)
{
	if (myField.value=='1'){
		document.forms["form1"].usedMoney.style.visibility = 'hidden';
		document.forms["form1"].usedMoney.value=0;		
	}else{
	document.forms["form1"].usedMoney.style.visibility = 'visible';
	document.forms["form1"].usedMoney.value=<%=usedMoney == null ? "0" : usedMoney%>;
	}
}
function toggleHoursFields(myField)
{
	if (myField.value=='1'){
		document.forms["form1"].usedHours.style.visibility = 'hidden';
		document.forms["form1"].usedHours.value=0;		
	}else{
	document.forms["form1"].usedHours.style.visibility = 'visible';
	document.forms["form1"].usedHours.value=<%=usedHours == null ? "0" : usedHours%>;
	}
}



	
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%
}
%>
</html:html>