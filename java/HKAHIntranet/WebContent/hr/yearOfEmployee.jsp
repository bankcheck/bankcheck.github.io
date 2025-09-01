<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String step = request.getParameter("step");
String nomineeStaffID = null;
String nomineeStaffName = null;
String nomineeDeptDesc = null;
String staffID = request.getParameter("staffID");
String staffName = null;
String staffDeptDesc = null;
String comment = null;
String forwardDate = request.getParameter("forwardDate");
String decision = TextUtil.parseStrUTF8(request.getParameter("decision"));
String finalist = request.getParameter("finalist");
String notSelected = request.getParameter("notSelected");
String notRule = request.getParameter("notRule");
String createdDate = null;
String modifiedDate = null;

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
		if (createAction) {
		} else if (updateAction) {
			if (EmployeeVoteDB.update(userBean, staffID, forwardDate, decision, finalist, notSelected, notRule)) {
				message = "nominate info updated.";
				updateAction = false;
			} else {
				errorMessage = "nominate info update fail.";
			}
		} else if (deleteAction) {
			if (EmployeeVoteDB.delete(userBean, staffID)) {
				message = "nominate info removed.";
				closeAction = true;
			} else {
				errorMessage = "nominate info remove fail.";
			}
		}
		step = null;
	} else if (createAction) {
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (staffID != null && staffID.length() > 0) {
			ArrayList record = EmployeeVoteDB.get(staffID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				nomineeStaffID = row.getValue(0);
				nomineeStaffName = row.getValue(1);
				nomineeDeptDesc = row.getValue(2);
				staffID = row.getValue(3);
				staffName = row.getValue(4);
				staffDeptDesc = row.getValue(5);
				comment = row.getValue(6);
				forwardDate = row.getValue(7);
				decision = row.getValue(8);
				finalist = row.getValue(9);
				notSelected = row.getValue(10);
				notRule = row.getValue(11);
				createdDate = row.getValue(12);
				modifiedDate = row.getValue(13);
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
<DIV id=Frame>
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
	title = "function.yearOfEmployee." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.hr" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="yearOfEmployee.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td colspan="3"><bean:message key="prompt.nominatingStaff" /></td>
	</tr>
	<tr class="smallText">
		<td><b><bean:message key="prompt.name" />:</b> <%=staffName %></td>
		<td><b><bean:message key="prompt.staffID" />:</b> <%=staffID %></td>
		<td><b><bean:message key="prompt.department" />:</b> <%=staffDeptDesc %></td>
	</tr>
	<tr class="smallText">
		<td colspan="3"><bean:message key="prompt.nomineeStaff" /></td>
	</tr>
	<tr class="smallText">
		<td><b><bean:message key="prompt.name" />:</b> <%=nomineeStaffName %></td>
		<td><b><bean:message key="prompt.staffID" />:</b> <%=nomineeStaffID %></td>
		<td><b><bean:message key="prompt.department" />:</b> <%=nomineeDeptDesc %></td>
	</tr>
	<tr class="smallText">
		<td colspan="3">Reason(s) for nominating this employee:</td>
	</tr>
	<tr class="smallText">
		<td colspan="3"><%=comment==null?"":comment %></td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td colspan="2">For HR Department Use Only</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Received on :</td>
		<td class="infoData" width="30%"><%=createdDate==null?"":createdDate %></td>
		<td class="infoLabel" width="20%">Forwarded to Social Committee on :</td>
		<td class="infoData" width="30%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="forwardDate" id="forwardDate" class="datepickerfield" value="<%=forwardDate==null?"":forwardDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else { %>
			<%=forwardDate==null?"":forwardDate %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.remarks" /> :</td>
		<td class="infoData" colspan="3">
<%	if (createAction || updateAction) { %>
			<textarea name="decision" rows="6" cols="100"><%=decision==null?"":decision %></textarea>
<%	} else { %>
			<%=decision==null?"":decision %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Selected for Finalists :</td>
		<td class="infoData" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="checkbox" name="finalist" value="Y"<%="Y".equals(finalist)?" checked":"" %>>
<%	} else { %>
			<%=finalist==null?"":finalist %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Not Selected :</td>
		<td class="infoData" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="checkbox" name="notSelected" value="Y"<%="Y".equals(notSelected)?" checked":"" %>>
			Rule # <select name="notRule">
				<option value=""></option>
				<option value="1"<%="1".equals(notRule)?" selected":"" %>>1</option>
				<option value="2"<%="2".equals(notRule)?" selected":"" %>>2</option>
				<option value="3"<%="3".equals(notRule)?" selected":"" %>>3</option>
				<option value="4"<%="4".equals(notRule)?" selected":"" %>>4</option>
				<option value="5"<%="5".equals(notRule)?" selected":"" %>>5</option></select>
<%	} else { %>
			<%=notSelected==null?"":notSelected %>Rule # <%=notRule==null?"":notRule %>
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
<%		if (userBean.isAccessible("function.yearOfEmployee.update")) { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.yearOfEmployee.update" /></button>
<%		}  %>
			<!--button class="btn-delete"><bean:message key="function.yearOfEmployee.delete" /></button-->
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="staffID" value="<%=staffID %>" />
</form>
<script language="javascript">
<!--
	function submitAction(cmd, stp) {
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>