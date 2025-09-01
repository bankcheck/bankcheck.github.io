<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	public static ArrayList getApprovalDoctor(String docCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(" SELECT D.DOCCODE, D.DOCFNAME || ' ' || D.DOCGNAME ");
		sqlStr.append(" FROM DOCTOR@IWEB D ");
		sqlStr.append(" INNER JOIN CTS_DOC_APPROVER A ON D.DOCCODE = A.DOCCODE ");
		sqlStr.append(" WHERE D.DOCSTS = -1 ");
		sqlStr.append(" AND   A.ENABLED = 1 ");
		if (docCode != null && docCode.length() > 0) {
			sqlStr.append(" AND   D.DOCCODE = ? ");
		}
		sqlStr.append(" ORDER BY D.DOCFNAME, D.DOCGNAME ");

		if (docCode != null && docCode.length() > 0) {
			return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { docCode });
		} else {
			return UtilDBWeb.getReportableList(sqlStr.toString());
		}
	}
%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String docCode = request.getParameter("docCode");
String approver = null;
String docFname = null;
String docGname = null;
String message = "";
String errorMessage = "";

ArrayList record = null;
ArrayList record2 = null;
ReportableListObject row = null;

try {
	// load data from database
	if (userBean != null && userBean.isLogin()) {
		if (userBean.isAccessible("function.cts.list2")) {
			record = getApprovalDoctor(null);
			command = "view";
		} else if (userBean.getStaffID() != null) {
			docCode = userBean.getStaffID().substring(2);
			record = getApprovalDoctor(docCode);
		}

		if (CTS.chkApprovalDoc(docCode)) {
			approver = docCode;
    			record2 = CTS.getDocList1(approver);
			row = (ReportableListObject) record2.get(0);
			docFname = row.getValue(1);
			docGname = row.getValue(2);

			if ("default".equals(command)) {
				command = "view";
			}
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<div id=mainFrame>
<div id=Frame>
<%
	String title = "function.cts.docAssign";
	String suffix = "_2";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="suffix" value="<%=suffix %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.cts.docAssign" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="openDocApproval.jsp" method="post">
<table cellpadding="0" cellspacing="5" align="left"
		class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.approvalDoc" /></td>
		<td class="infoData" width="80%">
			<select name="docCode" id="docCode">
<%
			if (record != null) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
					%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(docCode)?" selected":"" %>><%=row.getValue(1) %><%
				}
			}
%>
			</select>
			&nbsp;<button onclick="return submitAction('view');">Enter</button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" />
</form>
<script language="javascript">
	function submitAction(command) {
		var docCode = document.getElementById("docCode").value;
		if (docCode == '') {
			alert('Please enter Doctor NO.');
			document.form1.docCode.focus();
			return false;
		} else {
			document.form1.command.value = command;
			document.form1.submit();
			return false;
		}
	}

	function openAction(approver) {
		if (approver == '') {
			alert('Doctor ID [' + '<%=docCode%>' + '] is not a vaild doctor approver.');
			return false;
		} else {
			$.prompt('Before doing approval, please reconfirm you are the correct approver:<br>Doctor ID:'+approver+'<br>Doctor Family Name:'+'<%=docFname%>'+'<br>Doctor Given Name:'+'<%=docGname%>',{
				buttons: { Ok: true, Cancel: false },
				callback: function(v,m,f) {
					if (v) {
						submit: callPopUpWindow('../cts/docAgnRecordList.htm?approver='+approver+'&command=view');
						return true;
					} else {
						return false;
					}
				},
				prefix:'cleanblue'
			});
		}
	}

<%if ("view".equals(command) && approver != null && approver.length() > 0) {%>
	openAction('<%=approver%>');
<%}%>
</script>
</div>

</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>