<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="java.util.*"%>
<%
UserBean userBean = new UserBean(request);
String staffID = request.getParameter("staffID");
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
String fiscalYear = request.getParameter("fiscalYear_yy");
if(fiscalYear == null ){
	fiscalYear = Integer.toString(DateTimeUtil.getCurrentYear());
}
String deptCode = request.getParameter("deptCode");
String allowAll = userBean.isOfficeAdministrator() ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;	


request.setAttribute("staff_list", UserDB.getList(userBean,userBean.getSiteCode(),deptCode,"","","","1"));


if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<bean:define id="functionLabel"><bean:message key="function.user.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.eappraisal.list" />
	<jsp:param name="accessControl" value="N" />
</jsp:include>

<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText" id="cp_Department">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		 <td class="infoData" width="70%">
			<select name="deptCode">
			<%	if (userBean.isOfficeAdministrator()) { %>
				<option value="">--- All Departments ---</option>
			<%} %>
				<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=deptCode %>" />
				<jsp:param name="allowAll" value="<%=allowAll %>" />
			</jsp:include>
		</select>
	  </td>
	</tr>
	<tr class="smallText" id="cp_fiscalYr">
		<td class="infoLabel" width="30%"><bean:message key="prompt.fiscalYear" /></td>
		<td class="infoData" width="70%"><select name="fiscalYear_yy">
		  <option value="2010">2010</option>
		  <option value="2011" selected>2011</option>
		  <option value="2012">2012</option>
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
<form name="form1" action="<html:rewrite page="/eappraisal/evaluationForm.jsp" />" method="post">
<display:table id="row" name="requestScope.staff_list" export="false" class="tablesorter">
<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.department" style="width:15%">
		<logic:equal name="row" property="fields1" value="">
			<bean:message key="label.all" />
		</logic:equal>
		<logic:notEqual name="row" property="fields1" value="">
			<c:out value="${row.fields1}" />
		</logic:notEqual>
	</display:column>
	<display:column titleKey="prompt.Name" style="width:30%">
		<c:out value="${row.fields3}" />, <c:out value="${row.fields4}" />
	</display:column>
	<display:column property="fields5" titleKey="prompt.adventistStaff" style="width:10%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
	<%
	String getAppraisalID = "";
	getAppraisalID = EappraisalDB.getAppraisalID(((ReportableListObject)pageContext.getAttribute("row")).getValue(5),fiscalYear); 
	if(getAppraisalID != null && !"".equals(getAppraisalID)){%>
		<button onclick="return submitAction('view','<%=((ReportableListObject)pageContext.getAttribute("row")).getValue(5) %>','<%=getAppraisalID %>');">View</button>
	<%} else{%>
		<button onclick="return submitAction('view','<%=((ReportableListObject)pageContext.getAttribute("row")).getValue(5) %>','');">Add</button>
	<%} %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>	
</display:table>

</form>
<script language="javascript">

	function submitAction(cmd, cid,eid) {

		callPopUpWindow(document.form1.action + "?command=" + cmd + "&staffID=" + cid+"&evaluationID="+eid);
		return false;
	}

	function submitSearch() {
		document.search_form.submit();
	}

</script>
</DIV></DIV></DIV>
</body>
</html:html>