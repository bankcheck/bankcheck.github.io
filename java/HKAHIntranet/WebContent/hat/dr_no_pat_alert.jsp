<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getMobileBooking() {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("select distinct q6.patno hosp_no, q6.patfname||' '||q6.patgname patient_name from ");
		sqlStr.append("  (select d.doccode, d.docfname, d.docgname, d.docsts, d.docsex, substr(d.docgname, 1,5) as given_name, substr(d.docidno, 1,6) as docid ");
		sqlStr.append("  from doctor d) q3, ");
		sqlStr.append("  (select p.patno, p.patfname, p.patgname, p.patsex, substr(p.patgname, 1,5) as given_name, substr(p.patidno, 1,6) as patid ");
		sqlStr.append("  from patient p) q6 ");
		sqlStr.append("  where q3.docfname=q6.patfname ");
		sqlStr.append("  and q3.given_name=q6.given_name ");
		sqlStr.append("  and q3.docid = q6.patid ");
		sqlStr.append("  and q3.docsex = q6.patsex ");
		sqlStr.append("  and q6.patno not in ");
		sqlStr.append("(select q9.patno from (select q3.docfname, q3.docfname, q6.patfname, q3.docgname, q6.patgname, q3.docsts, q6.patno from ");
		sqlStr.append("  (select d.doccode, d.docfname, d.docgname, d.docsts, d.docsex, substr(d.docgname, 1,5) as given_name, substr(d.docidno, 1,6) as docid ");
		sqlStr.append("  from doctor d) q3, ");
		sqlStr.append("  (select p.patno, p.patfname, p.patgname, p.patsex, substr(p.patgname, 1,5) as given_name, substr(p.patidno, 1,6) as patid ");
		sqlStr.append("  from patient p) q6 ");
		sqlStr.append("  where q3.docfname=q6.patfname ");
		sqlStr.append("  and q3.given_name=q6.given_name ");
		sqlStr.append("  and q3.docid = q6.patid ");
		sqlStr.append("  and q3.docsex = q6.patsex) q9, ");
		sqlStr.append("  pataltlink, alert alt ");
		sqlStr.append("where q9.patno = pataltlink.patno ");
		sqlStr.append("and  pataltlink.altid = alt.altid ");
		sqlStr.append("and (alt.altid = 208 or alt.altid = 209 or alt.altid = 215)) ");
		sqlStr.append("order by patient_name, hosp_no asc ");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

request.setAttribute("mobile_app_list", getMobileBooking());

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
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Patient Number of Doctors without Alert Code in HATS" />
</jsp:include>

<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<form name="search_form" method="post" >
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>

<bean:define id="functionLabel">Mobile App report</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.mobile_app_list" export="false" class="tablesorter">
	<display:column property="fields0" title="Patient No" style="width:40%;text-align:center" />
	<display:column property="fields1" title="Patient Name" style="width:60%;text-align:center" />
</display:table>

<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
		return true;
	}

	function clearSearch() {
		return true;
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>