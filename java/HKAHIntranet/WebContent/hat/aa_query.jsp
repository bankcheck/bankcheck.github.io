<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getName() {
		return UtilDBWeb.getReportableListHATS("SELECT NAME FROM AA_QUERY ORDER BY STATEMENT_NO");
	}

	private String getStatement(String name) {
		ArrayList record = UtilDBWeb.getReportableListHATS("SELECT STATEMENT FROM AA_QUERY WHERE NAME = ?", new String[] { name });
		if (record.size() == 1) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return null;
		}
	}

	private ArrayList runStatement(String statement) {
		return UtilDBWeb.getReportableListHATS(statement);
	}
%>
<%
String name = request.getParameter("name");
ArrayList record = getName();
ReportableListObject row = null;
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>
<jsp:include page="../common/page_title.jsp">
	<jsp:param name="pageTitle" value="HATS Query" />
	<jsp:param name="isAccessControl" value="N" />
	<jsp:param name="mustLogin" value="N" />
</jsp:include>
<form name="search_form" action="aa_query.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Name</td>
		<td class="infoData" width="70%">
			<select name="name">
<%	for (int i = 0; i < record.size(); i++) { %>
<%		row = (ReportableListObject) record.get(i); %>
				<option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(name)?" selected":"" %>><%=row.getValue(0) %></option>
<%	} %>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<%
	String statement = null;
	int size = 0;
	if (name != null) {
		statement = getStatement(name);
		if (statement != null) {
			record = runStatement(statement);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				size = row.getSize();
				request.setAttribute("aa_query", record);
%>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="Data" /></bean:define>
<display:table id="row2" name="requestScope.aa_query" export="false" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row2_rowNum")%>)</display:column>
	<c:forEach var="cl" items="${row2.values}" varStatus="rowCounter">
		<display:column title="${rowCounter.count}"><c:out value="${row2.values[rowCounter.count-1]}" /></display:column>
	</c:forEach>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%
			}
		} else {
			out.println("Not found!");
		}
	}
%>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
		return true;
	}

	function clearSearch() {
		return false;
	}
</script>
</div>
</div>
</div>
<br/><p/><br/><p/><br/>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>