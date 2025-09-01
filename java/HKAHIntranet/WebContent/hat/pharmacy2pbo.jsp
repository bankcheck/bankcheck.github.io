<%@ page import="java.util.*" %>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private static String getNextID() {
		String id = null;

		ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(PH_CHECKOUT_ID) + 1 FROM PH_CHECKOUT");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			id = reportableListObject.getValue(0);
			// set 1 for initial
			if (id == null || id.length() == 0) return "1";
		}
		return id;
	}

	private static String getBedCode(String patno) {
		String bedcode = null;

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT I.Bedcode ");
		sqlStr.append("FROM   PATIENT P, REG R, Inpat I ");
		sqlStr.append("WHERE  P.REGID_C = R.REGID ");
		sqlStr.append("AND    R.Inpid = I.Inpid ");
		sqlStr.append("AND    P.PATNO = ? ");
		ArrayList record = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { patno });
		if (record.size() > 0) {
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				bedcode = row.getValue(0);
				break;
			}
		}
		return bedcode;
	}
%>
<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String command = ParserUtil.getParameter(request, "command");
String patno = ParserUtil.getParameter(request, "patno");
String patfname = null;
String patgname = null;
String patadd1 = null;
String patadd2 = null;
String patadd3 = null;
String coucode = null;
String coudesc = null;
String bedcode = null;

String actionid = ParserUtil.getParameter(request, "actionid");
String remark = ParserUtil.getParameter(request, "remark");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

ArrayList record = null;
boolean foundPatNo = false;
if (patno != null && patno.length() > 0) {
	record = AdmissionDB.getHATSPatient(patno, null, null);
	if (record != null && record.size() > 0) {
		foundPatNo = true;

		if ("action".equals(command) && actionid != null && actionid.length() > 0) {
			UtilDBWeb.updateQueue("INSERT INTO PH_CHECKOUT (PH_SITE_CODE, PH_CHECKOUT_ID, PH_PATNO, PH_BEDCODE, PH_REMARK, PH_OUT_STATUS) VALUES ('HKAH', ?, ?, ?, ?, ?)",
				new String[] { getNextID(), patno, getBedCode(patno), remark, actionid});
		} else {
			ReportableListObject row = (ReportableListObject) record.get(0);
			patfname = row.getValue(1);
			patgname = row.getValue(2);
			patadd1 = row.getValue(19);
			patadd2 = row.getValue(20);
			patadd3 = row.getValue(21);
			coucode = row.getValue(31);

			record = UtilDBWeb.getFunctionResults("NHS_CMB_COUNTRY", null);
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
					if (row.getValue(0).equals(coucode)) {
						coudesc = row.getValue(1);
						break;
					}
				}
			}

			bedcode = getBedCode(patno);
		}
	} else {
		errorMessage = "Invalid Patient No.";
		patno = null;
	}
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.pharmacy2pbo.list" />
	<jsp:param name="displayTitle" value="Pharmacy Checkout List" />
	<jsp:param name="category" value="Report" />
</jsp:include>

<font color="blue"><%=message==null?"":message %></font>
<font color="red"><%=errorMessage==null?"":errorMessage %></font>
<form name="form1" id="form1" action="pharmacy2pbo.jsp" method="post">
<%	if (foundPatNo) { %>
<%		if ("action".equals(command) && actionid != null && actionid.length() > 0) { %>
<br><font size="+1">Patient <font color="green"><%=patno==null?"":patno %></font>
<%			if ("NOMED".equals(actionid)) { %>
			<font color="blue">No Discharge Medicine</font>
<%			} else if ("BEDSIDE".equals(actionid)) { %>
			<font color="blue">Bedside Discharge Counseling</font>
<%			} else if ("PICKUP".equals(actionid)) { %>
			<font color="red">Pick up at Pharmacy Counter</font>
<%			} else if ("MEDGIVEN".equals(actionid)) { %>
			<font color="green">Medication Consultation Completed</font>
<%			} %>
	is submitted to PBO!!</font><br/>
<%			patno = null; %>
<%			foundPatNo = false; %>
<%		}%>
<%	}%>
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" width="300">
	<tr class="smallText">
		<td class="infoLabel" width="20%">Hospital No. :</td>
		<td class="infoData" width="80%" colspan="3">
<%	if (patno != null && patno.length() > 0) { %>
			<input type="hidden" name="patno" value="<%=patno %>"><%=patno %>
			&nbsp;
			<button onclick="return submitAction('clear');" style="text-decoration:none;font-size:20px;width:100px;height:50px;" class="btn-click">Clear</button>
<%	} else { %>
			<input type="text" name="patno" value="<%=patno==null?"":patno %>" id="patno" maxlength="10" size="20" onblur="checkPatNo(this);">
			&nbsp;
			<button onclick="return submitAction('search');" style="text-decoration:none;font-size:20px;width:100px;height:50px;" class="btn-click">Search</button>
			&nbsp;
			&nbsp;
			<button onclick="return submitAction('report');" style="text-decoration:none;font-size:20px;width:100px;height:50px;" class="btn-click">Report</button>
			<button onclick="return submitAction('history');" style="text-decoration:none;font-size:20px;width:100px;height:50px;" class="btn-click">History</button>
<%	} %>
		</td>
	</tr>
<%	if (foundPatNo) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Surname :</td>
		<td class="infoData" width="30%"><%=patfname!=null?patfname:"" %></td>
		<td class="infoLabel" width="20%">Firstname :</td>
		<td class="infoData" width="30%"><%=patgname!=null?patgname:"" %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Address :</td>
		<td class="infoData" width="30%">
			<%=patadd1!=null?patadd1:"" %><br />
			<%=patadd2!=null?patadd2:"" %><br />
			<%=patadd3!=null?patadd3:"" %><br />
			<%=coudesc!=null?coudesc:"" %>
		</td>
		<td class="infoLabel" width="20%">Bed Code :</td>
		<td class="infoData" width="30%"><%=bedcode!=null?bedcode:"N/A" %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Remark :</td>
<%		if ("action".equals(command) && actionid != null && actionid.length() > 0) { %>
		<%=remark %>
<%		} else { %>
		<td class="infoData" width="80%" colspan="3"><input type="text" name="remark" maxlength="100" size="100"></td>
<%		} %>
	</tr>
<%	} %>
</table>
<%	if (foundPatNo) { %>
<%		if ("action".equals(command) && actionid != null && actionid.length() > 0) { %>
<%		} else { %>
<table cellpadding="0" cellspacing="5" border="0" style="width:100%">
	<tr style="width:100%"><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
			<button type="button" onclick="submitAction('action', 'NOMED')" style="text-decoration:none;font-size:30px;width:250px;height:200px;" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">No Discharge Medicine</button>
		</td>
		<td align="center">
			<button type="button" onclick="submitAction('action', 'BEDSIDE')" style="text-decoration:none;font-size:30px;width:250px;height:200px;" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Bedside Discharge Counseling</button>
		</td>
	</tr>
	<tr>
		<td align="center">
			<button type="button" onclick="submitAction('action', 'PICKUP')" style="text-decoration:none;font-size:30px;width:250px;height:200px;" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Pick up at Pharmacy Counter</button>
		</td>
		<td align="center">
			<button type="button" onclick="submitAction('action', 'MEDGIVEN')" style="text-decoration:none;font-size:30px;width:250px;height:200px;" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Medication Consultation Completed </button>
		</td>
	</tr>
</table>
<%		} %>
<%	} %>
<input type="hidden" name="command">
<input type="hidden" name="actionid">
</form>

<script language="javascript">
<!--//
	$(document).ready(function() {
<%	if (patno != null && patno.length() > 0) { %>
		document.form1.remark.focus();
<%	} else { %>
		document.form1.patno.focus();
<%	} %>
	});

	function submitAction(cmd, actionid) {
		if (cmd == 'search' && document.form1.patno.value == '') {
			alert("Empty Patient No.");
			document.form1.patno.focus();
			return false;
		} else if (cmd == 'clear') {
			clearSearch();
		} else if (cmd == 'report' || cmd == 'history') {
			alert("Under Construction!");
			return false;
		}
		document.form1.command.value = cmd;
		document.form1.actionid.value = actionid;
		document.form1.submit();
	}

	function clearSearch() {
		document.form1.patno.value = "";
	}
//-->
</script>
</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>