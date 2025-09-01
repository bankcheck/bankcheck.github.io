<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private String getHATSID(String staffID) {
		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableListSEED("SELECT MODULE_USER_ID FROM SSO_USER_MAPPING WHERE MODULE_CODE LIKE 'hats.prod%' AND SSO_USER_ID = ? AND ENABLED = 1", new String[] { staffID });
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else{
			return null;
		}
	}

	private ArrayList<ReportableListObject> fetchPatientAlertAvailable(String patno, String userID) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_LIS_PATALERTAVA", new String[] { patno, userID });
	}

	private ArrayList<ReportableListObject> fetchPatientAlert(String patno, String userID) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_LIS_PATALERT", new String[] { patno, "0", userID });
	}


	private String createAlert(String patno, String userID, String altID) {
		return UtilDBWeb.callFunctionHATS("NHS_ACT_PATALERT", "ADD", new String[] { altID, patno, userID, "", ""});
	}

	private String deleteAlert(String patno, String userID, String palID) {
		return UtilDBWeb.callFunctionHATS("NHS_ACT_PATALERT", "DEL", new String[] { "", patno, userID, "", palID});
	}
%>
<%
String command = request.getParameter("command");
String staffID = request.getParameter("staffID");
String altID = request.getParameter("altID");
String palID = request.getParameter("palID");
String patno = request.getParameter("patno");
String patname = null;
String patcname = null;
String patsex = null;
String HATSID = null;
ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;

boolean createAction = false;
boolean deleteAction = false;
boolean success = false;

String message = "";
String errorMessage = "";

UserBean userBean = new UserBean(request);

if (staffID != null) {
	userBean = UserDB.getUserBean(request, staffID);
	HATSID = getHATSID(staffID);
}

if (userBean != null && userBean.isLogin() && staffID != null && HATSID != null) {

	if ("create".equals(command)) {
		createAction = true;
	} else if ("delete".equals(command)) {
		deleteAction = true;
	}

	String queueMessage = null;
	if (createAction) {
		queueMessage = createAlert(patno, HATSID, altID);
		String[] fields = queueMessage.split(ConstantsVariable.FIELD_DELIMITER);
		if (fields[3] != null && fields[3].indexOf("-") >= 0) {
			errorMessage = fields[4];
		}
		createAction = false;
	} else if (deleteAction) {
		queueMessage = deleteAlert(patno, HATSID, palID);
		String[] fields = queueMessage.split(ConstantsVariable.FIELD_DELIMITER);
		if (fields[3] != null && fields[3].indexOf("-") >= 0) {
			errorMessage = fields[4];
		}
		deleteAction = false;
	}

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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<!--jsp:include page="../common/header.jsp"/-->

<script src="../js/jquery-1.3.2.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="../css/jquery-ui.css">
<body>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="patient_alert" id="patient_alert" autocomplete="off" method="post">

<table width="100%" border="1">
<th colspan="3" bgcolor='#D8BFD8'>Patient Alert</th>

<tr bgcolor='#DDDDD'>
	<td width="20%"><b>Patient No.: </b><%=patno %></span></td>
	<td width="60%"><b>Patient Name: </b><span id="patname_indicator"></span> <span id="patcname_indicator"></span></td>
	<td width="20%"><b>Sex: </b><span id="patsex_indicator"></span></td>
</tr>

<tr>
	<td colspan="3">
		<table width="100%">
			<tr><td>Available Alert:</td></tr>
			<tr><td>
				<div id="table-wrapper">
				<div id="table-scroll">
				<table width="100%" border="1">
					<tr bgcolor='#F0F1F3'>
						<td width="10%">Alert code</td>
						<td width="70%">Description</td>
						<td width="20%">Action</td>
					</tr>
					<tr>
<%
	record = fetchPatientAlertAvailable(patno, HATSID);
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
					<tr bgcolor='#<%=i%2==0?"FAFAFA":"FFFFFF" %>'>
						<td><%=row.getValue(1) %></td>
						<td><%=row.getValue(2) %></td>
						<td><button onclick="return submitAction('create', '<%=row.getValue(3) %>', '');">Add</button></td>
					</tr>
<%
		}
	}
%>
				</table>
				</div>
				</div>
			</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>Selected Alert:</td></tr>
			<tr><td>
				<div id="table-wrapper">
				<div id="table-scroll">
				<table width="100%" border="1">
					<tr bgcolor='#F0F1F3'>
						<td width="10%">Alert code</td>
						<td width="40%">Description</td>
						<td width="15">Added by</td>
						<td width="15%">Added Date</td>
						<td width="20%">Action</td>
					</tr>
<%
	record = fetchPatientAlert(patno, HATSID);
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
					<tr bgcolor='#<%=i%2==0?"FAFAFA":"FFFFFF" %>'>
						<td><%=row.getValue(1) %></td>
						<td><%=row.getValue(2) %></td>
						<td><%=row.getValue(3) %></td>
						<td><%=row.getValue(4) %></td>
						<td><button onclick="return submitAction('delete', '', '<%=row.getValue(8) %>');">Remove</button></td>
					</tr>
<%
		}
	}
%>
				</table>
				</div>
				</div>
			</td></tr>
		</table>
	</td>
</tr>

</table>

<span id="showAdmission_indicator"></span>
<input type="hidden" name="command">
<input type="hidden" name="staffID" value="<%=staffID==null?"":staffID %>">
<input type="hidden" name="patno" value="<%=patno==null?"":patno %>">
<input type="hidden" name="altID">
<input type="hidden" name="palID">
</form>

<script type="text/javascript">
	function submitAction(cmd, altID, palID) {
		if (cmd == 'create' || cmd == 'delete') {
			document.patient_alert.command.value = cmd;
			if (cmd == 'create') {
				document.patient_alert.altID.value = altID;
			} else if (cmd == 'delete') {
				document.patient_alert.palID.value = palID;
			}
		}
		document.patient_alert.submit();
		return true;
	}


	function getPatName(patno) {
		$("#patname_indicator").html("")
		$("#patcname_indicator").html("");
		$("#patsex_indicator").html("");

		if (patno.length > 0) {
			$.ajax({
				type: "POST",
				url: "../registration/admission_hats.jsp",
				data: "patno=" + patno,
				success: function(values) {
				if (values != '') {
					$("#showAdmission_indicator").html(values);
					if (values.substring(0, 1) == 1) {
						$("#patname_indicator").html(document.patient_alert.hats_patfname.value + ' ' + document.patient_alert.hats_patgname.value);
						$("#patcname_indicator").html(document.patient_alert.hats_patcname.value);
						$("#patsex_indicator").html(document.patient_alert.hats_patsex.value);
					} else {
						alert('Patient not found.');
						patno.value = '';
					}
				}//if
				$("#showAdmission_indicator").html("");
				}//success
			});//$.ajax
		}
	}

<%if (patno != null && patno.length() > 0) { %>
	getPatName('<%=patno %>');
<%} %>

</script>
<style>
body {
	 font-family:Arial;
	 width:1024px;
	 size:9px;
	 line-height:1.7;
	 margin-top:0;
	 padding-top:0;
}

td {
	font-size: 12px;
}

#patno, #patcname, #patsex {
	width: 35%;
}
#patname {
	width: 45%;
}

#table-wrapper {
  position:relative;
}
#table-scroll {
	height:200px;
	overflow:auto;
	margin-top:20px;
}
#table-wrapper table {
	width:100%;
}
#table-wrapper table thead th .text {
	position:absolute;
	top:-20px;
	z-index:2;
	height:20px;
	width:35%;
	border:1px solid red;
}

</style>
</body>
</html:html>
<%
} else {
%>
<script type="text/javascript">
	alert('Access Denied.');
	window.close();
</script>
<%
}
%>