<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchQuestionaire() {
		// fetch each question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_QUESTIONAIRE_ID, CRM_QUESTIONAIRE_DESC, TO_CHAR(CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_QUESTIONAIRE WHERE CRM_ENABLED = 1");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.questionnaire.list" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="questionnaire.jsp" method="post">
<table cellpadding="0" cellspacing="0"
	class="tablesorter" border="0">
	<thead>
	<tr class="smallText">
		<th class="{sorter: false}">&nbsp;</th>
		<th width="50%"><bean:message key="prompt.description" /></th>
		<th width="25%"><bean:message key="prompt.modifiedDate" /></th>
		<th class="{sorter: false}"><bean:message key="prompt.action" /></th>
		<th class="{sorter: false}">&nbsp;</th>
	</tr>
	</thead>
	<tbody>
<%
	boolean success = false;
	try {
		ArrayList record = fetchQuestionaire();
		ReportableListObject row = null;
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
%>
	<tr>
		<td align="center"><%=i + 1 %>)</td>
		<td align="left"><%=row.getValue(1) %></td>
		<td align="center"><%=row.getValue(2) %></td>
		<td align="center">
			<button onclick="return submitAction('view', '<%=row.getValue(0) %>');"><bean:message key="button.view" /></button>
		<td align="right">&nbsp;</td>
	</tr>
<%
			}
			success = true;
		}
	} catch (Exception e) {
		e.printStackTrace();
	}

	if (!success) {
%>
	<tr class="smallText">
		<td align="center" colspan="5">
			<bean:define id="functionLabel"><bean:message key="function.questionnaire.list" /></bean:define>
			<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
		</td>
	</tr>
<%
	}
%>
	</tbody>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.questionnaire.create" /></button></td>
	</tr>
</table>
</form>
<script language="javascript">
	function submitAction(cmd, qid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&questionnaireID=" + qid);
		return false;
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>