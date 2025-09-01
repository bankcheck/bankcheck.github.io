<%@ page import="java.text.*" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
HashMap statusHashSet = new HashMap();
statusHashSet.put("I", MessageResources.getMessage(session, "label.open"));
statusHashSet.put("O", MessageResources.getMessage(session, "label.waiting.for.approve"));
statusHashSet.put("P", MessageResources.getMessage(session, "label.pending"));
statusHashSet.put("A", MessageResources.getMessage(session, "label.approved"));
statusHashSet.put("R", MessageResources.getMessage(session, "label.rejected"));
statusHashSet.put("C", MessageResources.getMessage(session, "label.confirmed"));

NumberFormat balanceFormat = DecimalFormat.getNumberInstance();
balanceFormat.setMaximumFractionDigits(1);
balanceFormat.setMinimumIntegerDigits(1);

UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String loginStaffID = userBean.getStaffID();

String command = request.getParameter("command");
String step = request.getParameter("step");
String eleaveID = request.getParameter("eleaveID");
String staffID = request.getParameter("staffID");

if (staffID == null) {
	staffID = loginStaffID;
}

String staffName = request.getParameter("staffName");
if (staffName == null) {
	staffName = userBean.getUserName();
}
String deptDesc = request.getParameter("deptDesc");
String leaveType = request.getParameter("leaveType");
String fromDate = request.getParameter("fromDate");
String fromDateUnit = request.getParameter("fromDateUnit");
if (fromDateUnit == null) {
	fromDateUnit = "AM";
}
String toDate = request.getParameter("toDate");
String toDateUnit = request.getParameter("toDateUnit");
if (toDateUnit == null) {
	toDateUnit = "PM";
}
String appliedDate = request.getParameter("appliedDate");
String requestRemarks = request.getParameter("requestRemarks");
String responseRemarks = request.getParameter("responseRemarks");
String leaveStatus = null;
String leaveStatusDesc = null;
HashSet approve_staffIDSet = new HashSet();
String approve_staffName = null;

float balanceActual = 20;
float balancePending = 20;
float newBalanceActual = 0;
String balanceYear = null;

boolean createAction = false;
boolean approveAction = false;
boolean rejectAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean searchAction = false;
boolean modifyALAction = false;

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

if ("create".equals(command)) {
	createAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("approve".equals(command)) {
	approveAction = true;
} else if ("reject".equals(command)) {
	rejectAction = true;
} else if ("search".equals(command)) {
	searchAction = true;
} else if ("modifyAL".equals(command)) {
	modifyALAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction && (requestRemarks == null || requestRemarks.length() == 0)) {
			errorMessage = MessageResources.getMessage(session, "error.remarks.required");
		} else {
			if (createAction) {
				String[] dateRange = ELeaveDB.parseDateRange(fromDate, fromDateUnit, toDate, toDateUnit);
				if (dateRange == null) {
					errorMessage = MessageResources.getMessage(session, "error.dateRate.required");
				} else if (ELeaveDB.isExist(userBean, dateRange[0], dateRange[1])) {
					errorMessage = "Leave create fail due to duplicate date range.";
				} else {
					eleaveID = ELeaveDB.add(userBean, staffID, leaveType,
							dateRange[0], dateRange[1], dateRange[2], null, requestRemarks);
					if (eleaveID != null) {
						message = "Leave created.";
						createAction = false;
					} else {
						errorMessage = "Leave create fail.";
					}
				}
			} else if (approveAction) {
				if (ELeaveDB.update(userBean, eleaveID, appliedDate, null, "A", responseRemarks)) {
					message = "Leave approved.";
					approveAction = false;
				} else {
					errorMessage = "Leave approve fail due to already approved or cancelled.";
				}
			} else if (rejectAction) {
				if (ELeaveDB.update(userBean, eleaveID, null, null, "R", responseRemarks)) {
					message = "Leave rejected.";
					rejectAction = false;
				} else {
					errorMessage = "Leave reject fail.";
				}
			} else if (deleteAction) {
				String deleteValue = ELeaveDB.delete(userBean, eleaveID, responseRemarks);
				if ("1".equals(deleteValue)) {
					message = "Leave Cancelled.";
					deleteAction = false;
				} else {
					errorMessage = "Leave cancel fail.";
				}
			}
		}
		step = null;
	} else if (createAction) {
		eleaveID = "";
		deptDesc = userBean.getDeptDesc();
		fromDate = DateTimeUtil.getCurrentDate();
		toDate = fromDate;
		appliedDate = "1";
		leaveStatus = null;
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (searchAction){
			eleaveID = "";
			staffName = StaffDB.getStaffName(staffID);
			deptDesc = userBean.getDeptDesc();
			fromDate = DateTimeUtil.getCurrentDate();
			toDate = fromDate;
			appliedDate = "1";
			leaveStatus = null;
		}

		if (eleaveID != null && eleaveID.length() > 0) {
			ArrayList record = ELeaveDB.get(eleaveID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				staffID = row.getValue(0);
				staffName = row.getValue(1);
				deptDesc = row.getValue(2);
				leaveType = row.getValue(3);
				fromDate = row.getValue(4);
				toDate = row.getValue(5);
				appliedDate = row.getValue(6);
				requestRemarks = row.getValue(8);
				responseRemarks = row.getValue(9);
				leaveStatus = row.getValue(10);

				record = ApprovalUserDB.getApprovalUserList("eleave.d", "approve", null, null, staffID);
				if (record.size() > 0) {
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						// cannot self approval
						if (!staffID.equals(userBean.getStaffID())
								|| !row.getValue(0).equals(userBean.getStaffID())) {
							approve_staffIDSet.add(row.getValue(0));
						}
						// check approval priority
						if ("1".equals(row.getValue(3))) {
							approve_staffName = row.getValue(1);
						}
				}
				}
			} else {
				closeAction = true;
			}
		} else {
			if (modifyALAction||searchAction){
				closeAction = false;
			} else {
				closeAction = true;
			}
		}
	}

	// Get number of days in balance
	if (!deleteAction) {
		balanceYear = fromDate.substring(6, 10);
		float balance[] = ELeaveDB.getBalance(staffID, balanceYear);
		if (balance != null) {
			balanceActual = balance[0];
			balancePending = balance[1];
		}
		if (modifyALAction){
			newBalanceActual = Float.parseFloat(request.getParameter("balanceActual"));
			staffName = StaffDB.getStaffName(staffID);
			if ((newBalanceActual - (balanceActual - balancePending)) < 0) {
				errorMessage = MessageResources.getMessage(session, "error.invalidbalance.required");
			} else {
				balancePending = newBalanceActual - (balanceActual - balancePending);
				balanceActual = newBalanceActual;
				ELeaveDB.updateBalance(userBean,staffID,balanceYear,Float.toString(balanceActual),Float.toString(balancePending));
			}
		}
	}

} catch (Exception e) {
	e.printStackTrace();
}

leaveStatusDesc = (String) statusHashSet.get(leaveStatus);
if (leaveStatusDesc == null) {
	leaveStatusDesc = MessageResources.getMessage(session, "label.open");
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
	if (createAction||searchAction||modifyALAction) {
		commandType = "create";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.eleave." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" action="apply.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
<%	if (balanceYear != null) {%>
		<tr class="smallText">
			<td class="infoLabel" width="30%">Balance (<%=balanceYear%>)</td>
			<td class="infoData" width="70%">
<%		if (staffName==null) { %>
			0 day(s); 0 day(s) when approved
<%		} else {
			if (commandType == "view") {%>
				<%=balanceFormat.format(balanceActual) %> day(s); <%=balanceFormat.format(balancePending) %> day(s) when approved
<% 			} else {
				if (userBean.isAccessible("function.eleave.admin")) {%>
					<input type="textfield" name="balanceActual" value="<%=balanceFormat.format(balanceActual) %>" maxlength="50" size="20">
					day(s); <%=balanceFormat.format(balancePending) %> day(s) when approved
					<button onclick="submitAction('modifyAL', 0);"><bean:message key='button.update' /></button>
<% 				} else {%>
					<%=balanceFormat.format(balanceActual) %> day(s); <%=balanceFormat.format(balancePending) %> day(s) when approved
<%				}
			}
		}%>
			</td>
		</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="70%">
<%		if (userBean.isAccessible("function.eleave.admin")) {%>
			<input type="textfield" name="staffID" value="<%=staffID==null?"":staffID %>" maxlength="50" size="20">
<%			if (staffName==null) { %>
				<font color="red">No such staff</font>
<%			} else { %>
				(<%=staffName %>)
				<button onclick="submitAction('search', 0);"><bean:message key='button.search' /></button>
<%			}
		} else {%>
				<%=staffID %>(<%=staffName %>)
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.leaveType" /></td>
		<td class="infoData" width="70%">
<%		if (createAction||searchAction||modifyALAction) {%>
		<select name="leaveType">
			<option value="AL"<%="AL".equals(leaveType)?" selected":"" %>>Annual Leave</option>
			<!-->option value="SL"<%="SL".equals(leaveType)?" selected":"" %>>Sick Leave</option-->
		</select>
<%		} else {%>
		<%="AL".equals(leaveType)?"Annual Leave":"Sick Leave" %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.from" /></td>
		<td class="infoData" width="70%">
<%		if (createAction||searchAction||modifyALAction) {%>
			<input type="textfield" name="fromDate" id="fromDate" class="datepickerfield" value="<%=fromDate==null?"":fromDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			<select name="fromDateUnit" onchange="return calculateAppliedDate();">
				<option value="AM">A.M.</option>
				<option value="PM"<%="PM".equals(fromDateUnit)?" selected":"" %>>P.M.</option>
			</select>
<%		} else {%>
		<%=fromDate %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.to" /></td>
		<td class="infoData" width="70%">
<%		if (createAction||searchAction||modifyALAction) { %>
			<input type="textfield" name="toDate" id="toDate" class="datepickerfield" value="<%=toDate==null?"":toDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			<select name="toDateUnit" onchange="return calculateAppliedDate();">
				<option value="AM">A.M.</option>
				<option value="PM"<%="PM".equals(toDateUnit)?" selected":"" %>>P.M.</option>
			</select>
<%		} else {%>
		<%=toDate %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="70%">
<%
		String formattedAppliedDate = null;
		try {
			formattedAppliedDate = balanceFormat.format(Float.parseFloat(appliedDate));
		} catch (Exception e) {
			formattedAppliedDate = "";
		}
%>
<% 		if (createAction||searchAction||modifyALAction) { %>
			<span id="showAppliedDate_indicator">
<jsp:include page="calculateAppliedDate.jsp" flush="false">
	<jsp:param name="fromDate" value="<%=fromDate %>" />
	<jsp:param name="fromDateUnit" value="<%=fromDateUnit %>" />
	<jsp:param name="toDate" value="<%=toDate %>" />
	<jsp:param name="toDateUnit" value="<%=toDateUnit %>" />
</jsp:include>
			</span>
<% 		} else if (("O".equals(leaveStatus) || "P".equals(leaveStatus))
			&& approve_staffIDSet.contains(userBean.getStaffID())) { %>
			<input type="textfield" name="appliedDate" value="<%=formattedAppliedDate==null?"":formattedAppliedDate %>" maxlength="2" size="2">
<%		} else {
			%><%=formattedAppliedDate %><%
		} %>
			&nbsp;Day(s)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.remarks" /> (Request)</td>
<%		if (createAction||searchAction||modifyALAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="requestRemarks" value="<%=requestRemarks==null?"":requestRemarks %>" maxlength="100" size="50"></td>
<%		} else {%>
		<td class="infoData" width="70%"><%=requestRemarks==null?"":requestRemarks %></td>
<%		} %>
	</tr>
<%		if (!createAction&&!searchAction||!modifyALAction) {%>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.remarks" /> (Response)</td>
<%			if (("O".equals(leaveStatus) || "P".equals(leaveStatus)) && approve_staffIDSet.contains(userBean.getStaffID())) { %>
		<td class="infoData" width="70%"><input type="textfield" name="responseRemarks" value="<%=responseRemarks==null?"":responseRemarks %>" maxlength="100" size="50"></td>
<%			} else {%>
		<td class="infoData" width="70%"><%=responseRemarks==null?"":responseRemarks %></td>
<%			} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.sendApprovalTo" /></td>
		<td class="infoData" width="70%">
			<%=approve_staffName==null?"":approve_staffName %>
		</td>
	</tr>
<%		} %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="70%"><%=leaveStatusDesc %></td>
	</tr>
	<tr class="smallText">
		<td align="center" colspan="2">
<%		if (createAction||deleteAction||searchAction||modifyALAction) { %>
			<button onclick="submitAction('<%=commandType %>', 1);"
<%			if (staffName==null) { %>disabled="disabled"<%		} %>>
			<bean:message key='button.save' /> - <bean:message key="<%=title %>" />
			</button>
			<button onclick="submitAction('view', 0);"><bean:message key='button.cancel' /> - <bean:message key="<%=title %>" /></button>
<%		}
		if ("O".equals(leaveStatus) || "P".equals(leaveStatus)) { %>
<%			if (approve_staffIDSet.contains(userBean.getStaffID())) { %>
			<button onclick="submitAction('approve', 1);"><bean:message key="button.approve" /></button>
			<button onclick="submitAction('reject', 1);"><bean:message key="button.reject" /></button>
<%			}
			if (staffID.equals(userBean.getStaffID())) { %>
			<button onclick="submitAction('delete', 1);"><bean:message key="function.eleave.cancel" /></button>
<%			}  %>
<%		}  %>
		</td>
	</tr>
</table>
<input type="hidden" name="command"/>
<input type="hidden" name="step"/>
<input type="hidden" name="eleaveID" value="<%=eleaveID %>"/>
<input type="hidden" name="staffID" value="<%=staffID %>"/>
<input type="hidden" name="leaveStatus" value="<%=leaveStatus %>"/>
</form>
<script language="javascript">
<!--
	var balanceActual = <%=balanceActual %>;
	var balancePending = <%=balancePending %>;

	function submitAction(cmd, stp) {
		if (cmd == 'create') {
			if (document.form1.fromDate.value == '') {
				alert('Empty from date!');
				document.form1.fromDate.focus();
				return false;
			}
			if (document.form1.fromDate.value.length != 10) {
				alert('Invalid from date!');
				document.form1.fromDate.focus();
				return false;
			}
			if (document.form1.toDate.value == '') {
				alert('Empty to date!');
				document.form1.toDate.focus();
				return false;
			}
			if (document.form1.toDate.value.length != 10) {
				alert('Invalid to date!');
				document.form1.toDate.focus();
				return false;
			}
			var fd = document.form1.fromDate.value;
			var fd1 = fd.split('/');
			var fd2 = fd1[2] + '/' + fd1[1] + '/' + fd1[0];
			var td = document.form1.toDate.value;
			var td1 = td.split('/');
			var td2 = td1[2] + '/' + td1[1] + '/' + td1[0];
			if (fd2 > td2) {
				alert('From date is after to date!');
				document.form1.fromDate.focus();
				return false;
			}

//			alert('balanceActual:'+'<%=balanceActual %>'+';'+<%=balancePending %>);
<% 		if (balanceYear != null) { %>
			// Basic check for only this year
			var appliedDate = parseFloat(document.getElementById("showAppliedDate_indicator").innerHTML);
//			alert('AppliedDate:'+appliedDate+'; balancePending:'+balancePending+'; fd1[2]'+fd1[2]);
			if (appliedDate > balancePending && fd1[2] == '<%=balanceYear %>') {
				alert('Applied date exceeds allowed balance');
				document.form1.toDate.focus();
				return false;
			}
<% 		} %>
			if (document.form1.requestRemarks.value == '') {
				alert('Empty Remarks!');
				document.form1.requestRemarks.focus();
				return false;
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function calculateAppliedDate() {
		var fromDate = document.form1.fromDate.value;
		var fromDateUnit = document.form1.fromDateUnit.value;
		var toDate = document.form1.toDate.value;
		var toDateUnit = document.form1.toDateUnit.value;

		http.open('get', 'calculateAppliedDate.jsp?fromDate=' + fromDate + '&fromDateUnit=' + fromDateUnit + '&toDate=' + toDate + '&toDateUnit=' + toDateUnit + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponseAppliedDate;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function processResponseAppliedDate() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("showAppliedDate_indicator").innerHTML = response;
		}
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>