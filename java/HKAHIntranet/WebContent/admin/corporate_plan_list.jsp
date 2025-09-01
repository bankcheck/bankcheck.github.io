<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="java.util.*"%>
<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
String selectType = request.getParameter("selectType");

if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

String fiscalYear = request.getParameter("fiscalYear_yy");
String deptCode = request.getParameter("deptCode");
String allowAll = userBean.isOfficeAdministrator() ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;

if (fiscalYear == null || selectType == null || deptCode == null) {
//	fiscalYear = Integer.toString(DateTimeUtil.getCurrentYear());
	fiscalYear = "2010";
	selectType = "Date";
	deptCode = userBean.getDeptCode();
}
if (deptCode == null) {
	deptCode = ConstantsVariable.EMPTY_VALUE;
}
ArrayList record = CorporatePlanDB.getList(userBean, fiscalYear, deptCode);
if (record.size() == 0 && userBean.isOfficeAdministrator()) {
	for (Iterator i = userBean.getAssociatedDeptCode().iterator(); record.size() == 0 && i.hasNext(); ) {
		deptCode = (String) i.next();
		record = CorporatePlanDB.getList(userBean, fiscalYear, deptCode);
	}
}
request.setAttribute("plan_list", record);

%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.corporate.plan.list" />
	<jsp:param name="category" value="Corporate" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="post" action="<html:rewrite page="/admin/corporate_plan_list.jsp" />">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText" id="cp_Select">
		<td class="infoLabel" width="30%">Filter</td>
		<td class="infoData" width="70%">
			<select name="selectType">
				<option value="Date"<%="Date".equals(selectType)?" selected":"" %>><%="Date"%></option>
			</select>
		</td>
	</tr>
	<!--
	<tr class="smallText" id="cp_fiscalYr">
		<td class="infoLabel" width="30%"><bean:message key="prompt.fiscalYear" /></td>
		<td class="infoData" width="70%"><select name="fiscalYear_yy"><option value="2010">2010</option></select></td>
	</tr>
	-->
	<tr class="smallText" id="cp_fiscalYr">
		<td class="infoLabel" width="30%"><bean:message key="prompt.fiscalYear" /></td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="fiscalYear" />
	<jsp:param name="day_yy" value="<%=fiscalYear %>" />
	<jsp:param name="yearRange" value="2" />
	<jsp:param name="isYearOnly" value="Y" />
	<jsp:param name="isYearOrderDesc" value="Y" />
</jsp:include>
		</td>
	</tr>
	<tr class="smallText" id="cp_Department">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
			<select name="deptCode">
<%	if (userBean.isOfficeAdministrator()) { %>
				<option value="">--- All Departments ---</option>
<%	} %>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="allowAll" value="<%=allowAll %>" />
</jsp:include>
			</select>
		</td>
	</tr>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<form name="form1" action="<html:rewrite page="/admin/corporate_plan.jsp" />" method="post">
<bean:define id="functionLabel"><bean:message key="function.corporate.plan.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<%if("Date".equals(selectType)){%>
<display:table id="row" name="requestScope.plan_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields2" titleKey="prompt.fiscalYear" style="width:10%"/>
	<display:column property="fields1" titleKey="prompt.department" style="width:20%"/>
	<display:column property="fields4" title="Subject" style="width:20%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields3}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<%} %>
<%if("Goal".equals(selectType)){%>
<display:table id="row" name="requestScope.plan_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" titleKey="prompt.department" style="width:15%"/>
	<display:column property="fields10" title="Goal" style="width:15%"/>
	<display:column property="fields6" title="Setup Cost" style="width:15%"/>
	<display:column property="fields7" title="Equipment Cost" style="width:15%"/>
	<display:column property="fields8" title="Recruit Cost" style="width:15%"/>
	<display:column property="fields9" title="FTE Cost" style="width:15%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields3}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<%} %>
<%if("FTE".equals(selectType)){%>
<display:table id="row" name="requestScope.plan_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields4" title="Subject" style="width:20%"/>
	<display:column property="fields2" titleKey="prompt.fiscalYear" style="width:20%"/>
	<display:column property="fields9" title="FTE Cost" style="width:15%"/>
	<display:column title="Approved Budget" media="html" style="width:10%; text-align:center">
	<%
	Integer count = 0;
	if(!"".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields11().toString())){
	 count ++;
	}
	if(!"".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields12().toString())){
		 count ++;
		}
	if(!"".equals(((ReportableListObject)pageContext.getAttribute("row")).getFields13().toString())){
		 count ++;
		}
	%>
	<%=count %>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />', '<c:out value="${row.fields2}" />', '<c:out value="${row.fields3}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>
<%} %>

<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '', '', '');"><bean:message key="function.corporate.plan.create" /></button></td>
	</tr>
</table>


</form>
<script language="javascript">
<!--//

	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.deptCode.value = "";
		document.search_form.fiscalYear_yy.value = "";
	}

	function submitAction(cmd, did, fid, pid) {
		if (cmd == 'create') {
			did = document.search_form.deptCode.value;
			fid = document.search_form.fiscalYear_yy.value;
		}
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&deptCode=" + did + "&fiscalYear_yy=" + fid + "&planID=" + pid);
		return false;
	}
//-->
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>