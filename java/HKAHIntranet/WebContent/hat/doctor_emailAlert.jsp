<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getDoctorProfile(String doccode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT doccode, DOCFNAME || ' ' || DOCGNAME, DOCEMAIL ");
		sqlStr.append("FROM   DOCTOR@IWEB ");
		sqlStr.append("WHERE  DOCSTS = -1 ");
		sqlStr.append("AND    doccode = UPPER('");
		sqlStr.append(doccode);
		sqlStr.append("') ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getDoctorEmailList(String doccode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT HPSTATUS ");
		sqlStr.append("FROM   HPSTATUS@IWEB ");
		sqlStr.append("WHERE  HPTYPE = 'DOCEALERT' ");
		sqlStr.append("AND    HPACTIVE = -1 ");
		sqlStr.append("AND    HPKEY = UPPER('");
		sqlStr.append(doccode);
		sqlStr.append("') ");
		sqlStr.append("ORDER BY HPSTATUS ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private boolean isExist(String doccode, String email) {
		return UtilDBWeb.isExist(
			"SELECT 1 FROM HPSTATUS@IWEB WHERE HPTYPE = 'DOCEALERT' AND HPKEY = ? AND HPSTATUS = ?",
			new String[]{ doccode, email });
	}

	private boolean addEmail(UserBean userBean, String doccode, String email) {
		if (isExist(doccode, email)) {
			return UtilDBWeb.updateQueue(
				"UPDATE HPSTATUS@IWEB SET HPACTIVE = -1, HPMUSR = ?, HPMDATE = SYSDATE WHERE HPTYPE = 'DOCEALERT' AND HPKEY = ? AND HPSTATUS = ?",
				new String[] { userBean.getStaffID(), doccode, email } );
		} else {
			return UtilDBWeb.updateQueue(
				"INSERT INTO HPSTATUS@IWEB (HPTYPE, HPKEY, HPSTATUS, HPCUSR) VALUES ('DOCEALERT', ?, ?, ?)",
				new String[] { doccode, email, userBean.getStaffID() } );
		}
	}

	private boolean deleteEmail(UserBean userBean, String doccode, String email) {
		return UtilDBWeb.updateQueue(
			"UPDATE HPSTATUS@IWEB SET HPACTIVE = 0, HPMUSR = ?, HPMDATE = SYSDATE WHERE HPTYPE = 'DOCEALERT' AND HPKEY = ? AND HPSTATUS = ?",
			new String[] { userBean.getStaffID(), doccode, email } );
	}
%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String step = request.getParameter("step");
String doccode = request.getParameter("doccode");
String docName = null;
String docEmailFromProfile = null;
String[] docEmailFromAlert = null;
String docAddEmail = request.getParameter("docAddEmail");
String docDelEmail = request.getParameter("docDelEmail");

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
			if (addEmail(userBean, doccode, docAddEmail)) {
				message = "Email added.";
				createAction = false;
				step = "0";
			} else {
				errorMessage = "Email add fail.";
			}
		} else if (deleteAction) {
			if (deleteEmail(userBean, doccode, docDelEmail)) {
				message = "Email removed.";
				deleteAction = false;
				step = "0";
			} else {
				errorMessage = "Email remove fail.";
			}
		}
	} else if (createAction) {
		docAddEmail = "";
	}

	ReportableListObject row = null;

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (doccode != null && doccode.length() > 0) {
			ArrayList record = getDoctorProfile(doccode);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				docName = row.getValue(1);
				docEmailFromProfile = row.getValue(2);

				// get doctor email from alert
				record = getDoctorEmailList(doccode);
				docEmailFromAlert = new String[record.size()];
				if (record.size() > 0) {
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						docEmailFromAlert[i] = row.getValue(0);
					}
				}
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
	title = "function.hats.doctorEmailAlert." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" id="form1" action="doctor_emailAlert.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Doctor Code</td>
		<td class="infoData" width="70%"><%=doccode==null?"":doccode %><input type="hidden" name="doccode" value="<%=doccode%>"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Doctor Name</td>
		<td class="infoData" width="70%"><%=docName==null?"":docName %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Email from Profile</td>
		<td class="infoData" width="70%"><%=docEmailFromProfile==null?"":docEmailFromProfile %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Email from Alert</td>
		<td class="infoData" width="70%">
			<table width="100%">
<%	for (int i = 0; i < docEmailFromAlert.length; i++) { %>
				<tr><td><%=docEmailFromAlert[i] %></td><td><% if (userBean.isAccessible("function.hats.doctorEmailAlert.delete")) { %><button onclick="return submitAction('delete', 1, '<%=docEmailFromAlert[i] %>');" class="btn-click"><bean:message key="button.delete" /></button><% } %></td></tr>
<%	} %>
<%	if (userBean.isAccessible("function.hats.doctorEmailAlert.update")) { %>
				<tr><td><input type="text" name="docAddEmail" id="docAddEmail" value="" maxlength="100" size="50"></td><td><button onclick="return submitAction('create', 1, '');" class="btn-click"><bean:message key="button.add" /></button></td></tr>
<%	} %>
			</table>
		</td>
	</tr>
</table>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="docDelEmail">
</form>
<script language="javascript">
<!--
	function submitAction(cmd, stp, email) {
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.docAddEmail.value == '') {
				alert("<bean:message key="error.email.required" />.");
				document.form1.docAddEmail.focus();
				return false;
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.docDelEmail.value = email;
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