<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getDoctorEmailList(String doccode, String docName) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.DOCCODE, D.DOCFNAME, D.DOCGNAME, D.DOCEMAIL, wm_concat(H.HPSTATUS) ");
		sqlStr.append("FROM   DOCTOR@IWEB D, HPSTATUS@IWEB H ");
		sqlStr.append("WHERE  H.HPTYPE = 'DOCEALERT' ");
		sqlStr.append("AND    D.DOCSTS = -1 ");
		sqlStr.append("AND    H.HPACTIVE = -1 ");
		sqlStr.append("AND    D.DOCCODE = H.HPKEY ");
//		sqlStr.append("AND    D.DOCEMAIL != H.HPSTATUS ");
		if (doccode != null && doccode.length() > 0) {
			sqlStr.append("AND    D.DOCCODE = UPPER('");
			sqlStr.append(doccode);
			sqlStr.append("') ");
		}
		if (docName != null && docName.length() > 0) {
			sqlStr.append("AND   (D.DOCFNAME LIKE UPPER('%");
			sqlStr.append(docName);
			sqlStr.append("%') OR D.DOCGNAME LIKE UPPER('%");
			sqlStr.append(docName);
			sqlStr.append("%')) ");
		}
		sqlStr.append("GROUP BY D.DOCCODE, D.DOCFNAME, D.DOCGNAME, D.DOCEMAIL ");
		sqlStr.append("ORDER BY D.DOCFNAME, D.DOCGNAME, D.DOCCODE, D.DOCEMAIL ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private boolean isExist(String doccode, String status) {
		return UtilDBWeb.isExist(
			"SELECT 1 FROM HPSTATUS@IWEB WHERE HPTYPE = 'DOCEALERT' AND HPKEY = ? AND HPACTIVE = ?",
			new String[]{ doccode, status });
	}

 	private boolean addDoctor(UserBean userBean, String doccode) {
		if (!isExist(doccode, "-1")) {
			if (!isExist(doccode, "0")) {
				return UtilDBWeb.updateQueue(
					"INSERT INTO HPSTATUS@IWEB (HPTYPE, HPKEY, HPSTATUS, HPCUSR) SELECT 'DOCEALERT', DOCCODE, NVL(DOCEMAIL, '@'), ? FROM DOCTOR@IWEB WHERE DOCCODE = ? AND DOCSTS = -1",
					new String[] { userBean.getStaffID(), doccode } );
			} else {
				return UtilDBWeb.updateQueue(
					"UPDATE HPSTATUS@IWEB SET HPACTIVE = -1, HPMUSR = ?, HPMDATE = SYSDATE WHERE HPTYPE = 'DOCEALERT' AND HPKEY = ? AND HPACTIVE = 0",
					new String[] { userBean.getStaffID(), doccode } );
			}
		} else {
			return false;
		}
	}
%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String doccodeAdd = request.getParameter("doccodeAdd");
boolean createAction = false;
if ("create".equals(command)) {
	createAction = true;
}

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String doccode = ParserUtil.getParameter(request, "doccode");
String doctorName = ParserUtil.getParameter(request, "doctorName");

try {
	if (createAction) {
		if (addDoctor(userBean, doccodeAdd)) {
			message = "Doctor alert added.";
			doccode = doccodeAdd;
		} else {
			message = "Doctor alert fail to add.";
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

request.setAttribute("doctor_emailAlert_list", getDoctorEmailList(doccode, doctorName));
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.hats.doctorEmailAlert.list" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="search_form" action="doctor_emailAlert_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
		<tr class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Doctor Code: </td>
			<td class="infoData" width="70%"><input type="text" name="doccode" id="doccode" value="<%=doccode == null ? "" : doccode%>" maxlength="200" size="20" ></td>
		</tr>
		<tr class="smallText" style="padding:10px;">
			<td class="infoLabel" width="30%">Doctor Name: </td>
			<td class="infoData" width="70%"><input type="text" name="doctorName" id="doctorName" value="<%=doctorName == null ? "" : doctorName%>" maxlength="200" size="40" ></td>
		</tr>
		<tr class="smallText">
			<td colspan="2" align="center">
				<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
				<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
			</td>
	</tr>
	</table>
</form>

<form name="form1" action="doctor_emailAlert_list.jsp" method="post">
<display:table id="row" name="requestScope.doctor_emailAlert_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column title="Doctor Code" style="width:25%" media="html"><c:out value="${row.fields0}" /></display:column>
	<display:column title="Doctor Name" style="width:25%">
		<c:out value="${row.fields1}" /> <c:out value="${row.fields2}" />
	</display:column>
	<display:column property="fields3" title="Email from Profile" style="width:10%" />
	<display:column property="fields4" title="Email from Alert" style="width:10%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
</display:table>
</form>

<%	if (userBean.isAccessible("function.hats.doctorEmailAlert.create")) { %>
<form name="create_form" action="doctor_emailAlert_list.jsp" method="post">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<table width="80%" border=0>
				<tr>
					<td width="25%" align="right">New Doctor Code for Alert: <input type="text" name="doccodeAdd" id="doccodeAdd" value="" maxlength="10" size="10"></td>
					<td width="25%" align="left"><button onclick="return submitAction('create', '');"><bean:message key="button.create" /></button></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<input type="hidden" name="command">
</form>
<%	} %>
</DIV>

</DIV>
</DIV>
<script>
function submitSearch() {
	document.search_form.submit();
}

function submitAction(cmd, did) {
	if (cmd == 'view') {
		callPopUpWindow("doctor_emailAlert.jsp?command=" + cmd + "&doccode=" + did);
		return false;
	} else if (cmd == 'create') {
		if (document.create_form.doccodeAdd.value == '') {
			alert("Empty doctor code.");
			document.create_form.doccodeAdd.focus();
			return false;
		}
		document.create_form.command.value = cmd;
		document.create_form.submit();
	}
}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
