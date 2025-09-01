<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getOBBookingByYear(String docCode, String edcFrom, String edcTo, String type, String orderBy) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.DOCFNAME || ' ' || D.DOCGNAME, TO_CHAR(B.BPBHDATE, 'dd/mm/yyyy'), B.PATNO, B.BPBPNAME, B.BPBNO, ");
		sqlStr.append("       B.USRID, TO_CHAR(B.BPBODATE, 'dd/mm/yyyy'), ");
		sqlStr.append("       B.EDITUSER, TO_CHAR(B.EDITDATE, 'dd/mm/yyyy') ");
		sqlStr.append("FROM   BEDPREBOK@IWEB B, DOCTOR@IWEB D ");
		sqlStr.append("WHERE  B.DOCCODE = D.DOCCODE ");
		sqlStr.append("AND   (B.BPBNO LIKE 'B%' OR B.BPBNO LIKE 'S%') ");
		sqlStr.append("AND    B.BPBHDATE >= TO_DATE('");
		sqlStr.append(edcFrom);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    B.BPBHDATE <= TO_DATE('");
		sqlStr.append(edcTo);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    B.BPBSTS != 'D' ");
		sqlStr.append("AND    B.WRDCODE IN ('OB', 'U100') ");
		sqlStr.append("AND    B.FORDELIVERY = '-1' ");
		if (docCode != null && docCode.length() > 0) {
			sqlStr.append("AND    B.DOCCODE = '");
			sqlStr.append(docCode);
			sqlStr.append("' ");
		}
		if ("A".equals(type)) {
			sqlStr.append("AND    B.PATDOCTYPE NOT IN ('L', 'C') ");
		} else {
			sqlStr.append("AND    B.PATDOCTYPE IN ('L', 'C') ");
			if ("S".equals(type)) {
				sqlStr.append("AND    B.HUSDOCTYPE IS NOT NULL ");
				sqlStr.append("AND    B.HUSDOCTYPE != 'L' ");
				sqlStr.append("AND    B.HUSDOCTYPE != 'C' ");
			} else if ("B".equals(type)) {
				sqlStr.append("AND   (B.HUSDOCTYPE IS NULL ");
				sqlStr.append("OR     B.HUSDOCTYPE = 'L' ");
				sqlStr.append("OR     B.HUSDOCTYPE = 'C') ");
			}
		}
		if ("C".equals(orderBy)) {
			sqlStr.append("ORDER BY B.BPBODATE DESC ");
		} else {
			sqlStr.append("ORDER BY B.BPBHDATE DESC ");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
String[] months = new String [] {
		MessageResources.getMessage(session, "label.january"),
		MessageResources.getMessage(session, "label.february"),
		MessageResources.getMessage(session, "label.march"),
		MessageResources.getMessage(session, "label.april"),
		MessageResources.getMessage(session, "label.may"),
		MessageResources.getMessage(session, "label.june"),
		MessageResources.getMessage(session, "label.july"),
		MessageResources.getMessage(session, "label.august"),
		MessageResources.getMessage(session, "label.september"),
		MessageResources.getMessage(session, "label.october"),
		MessageResources.getMessage(session, "label.november"),
		MessageResources.getMessage(session, "label.december") };

UserBean userBean = new UserBean(request);

String docCode = request.getParameter("docCode");
int edcYearCurrent = DateTimeUtil.getCurrentYear();
int edcYear = 0;
try { edcYear = Integer.parseInt(ParserUtil.getParameter(request, "edcYear")); } catch (Exception e) {}
if (edcYear == 0) {
	edcYear = edcYearCurrent;
}
int edcMonth = 0;
try { edcMonth = Integer.parseInt(ParserUtil.getParameter(request, "edcMonth")); } catch (Exception e) {}
String edcFrom = "01/" + (edcMonth > 0 ? ((edcMonth < 10 ? "0" : "") + edcMonth) : "01") + "/" + edcYear;
String edcTo = null;
if (edcMonth == 0 || edcMonth == 12) {
	edcTo = "31/12/" + edcYear;
} else {
	edcTo = DateTimeUtil.getRollDate(edcFrom, 0, 1, 0);
	edcTo = DateTimeUtil.getRollDate(edcTo, -1, 0, 0);
}
String type = request.getParameter("type");
String orderBy = request.getParameter("orderBy");
if (orderBy == null) {
	orderBy = "E";
}

request.setAttribute("obbooking_list", getOBBookingByYear(docCode, edcFrom, edcTo, type, orderBy));
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
<%@ page language="java" contentType="text/html; charset=big5" %>
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
	<jsp:param name="pageTitle" value="function.monthly.ob.report" />
	<jsp:param name="displayTitle" value="OB Monthly Statistics for Mainland" />
	<jsp:param name="category" value="Report" />
</jsp:include>
<form name="search_form" action="monthly_ob_report_china.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Doctor</td>
		<td class="infoData" width="70%">
			<select name="docCode">
				<option value="">--- Select Doctor ---</option>
<jsp:include page="../ui/docCodeCMB.jsp" flush="false">
	<jsp:param name="doccode" value="<%=docCode %>" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">EDC</td>
		<td class="infoData" width="70%">
			<select name="edcYear">
				<option value="<%=edcYearCurrent - 1 %>"<%=edcYearCurrent - 1 == edcYear?" selected":"" %>><%=edcYearCurrent - 1 %></option>
				<option value="<%=edcYearCurrent %>"<%=edcYearCurrent == edcYear?" selected":"" %>><%=edcYearCurrent %></option>
				<option value="<%=edcYearCurrent + 1 %>"<%=edcYearCurrent + 1 == edcYear?" selected":"" %>><%=edcYearCurrent + 1%></option>
			</select>
			<select name="edcMonth">
				<option value="">All</option>
<%	for (int i = 0; i < 12; i++) { %>
				<option value="<%=i + 1 %>"<%=i + 1 == edcMonth?" selected":"" %>><%=months[i] %></option>
<%	} %>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Type</td>
		<td class="infoData" width="70%">
			<select name="type">
				<option value="A"<%="A".equals(type)?" selected":"" %>>Local/Expatriate Parents</option>
				<option value=""<%=(type == null || "".equals(type))?" selected":"" %>>All Mainland Patients</option>
				<option value="S"<%="S".equals(type)?" selected":"" %>>Mainland Mother + Local/Expatriate Father</option>
				<option value="B"<%="B".equals(type)?" selected":"" %>>Mainland Parents</option>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Order By</td>
		<td class="infoData" width="70%">
			<select name="orderBy">
				<option value="E"<%="E".equals(orderBy)?" selected":"" %>>EDC</option>
				<option value="C"<%="C".equals(orderBy)?" selected":"" %>>Created Date</option>
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
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" width="100%">
	<tr class="smallText">
		<td class="infoSubTitle3">EDC From <%=edcFrom %> To <%=edcTo %></td>
	</tr>
</table>

<bean:define id="functionLabel"><bean:message key="function.obbooking.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.obbooking_list" export="true" pagesize="10" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" titleKey="label.doctor" style="width:20%" />
	<display:column property="fields1" title="EDC" style="width:8%" />
	<display:column property="fields2" titleKey="prompt.patNo" style="width:8%" />
	<display:column property="fields3" titleKey="prompt.patName" style="width:10%" />
	<display:column property="fields4" title="Booking No." style="width:10%" />
	<display:column property="fields5" titleKey="prompt.createdBy" style="width:10%" />
	<display:column property="fields6" titleKey="prompt.createdDate" style="width:10%" />
	<display:column property="fields7" titleKey="prompt.modifiedBy" style="width:10%" />
	<display:column property="fields8" titleKey="prompt.modifiedDate" style="width:10%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<p/><br/><p/>
<a href="monthly_ob_report.jsp?searchYear_yy=<%=edcYear%>"><img src="../images/undo2.gif">Back to Previous Page</a>

</DIV>

</DIV></DIV>

<script language="javascript">
<!--
	function submitSearch() {
		document.forms["search_form"].submit();
		return true;
	}

	function clearSearch() {
		document.forms["search_form"].elements["edcYear"].value = "<%=edcYearCurrent %>";
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>