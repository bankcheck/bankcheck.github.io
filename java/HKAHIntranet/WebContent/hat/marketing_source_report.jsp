<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private static DecimalFormat pctFormat = new DecimalFormat();

	private ArrayList getMarketingSource() {
		return UtilDBWeb.getReportableListHATS("SELECT MKTSRCCODE, MKTSRCDESC FROM MARKETINGSOURCE ORDER BY MKTSRCDESC");
	}

	private ArrayList getData(String searchYear) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(PatRDate, 'MM'), PatMktSrc, COUNT(1) ");
		sqlStr.append("FROM   Patient ");
		sqlStr.append("WHERE  PatMktSrc IS NOT NULL ");
		sqlStr.append("AND    PatRDate >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    PatRDate <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("GROUP BY TO_CHAR(PatRDate, 'MM'), PatMktSrc ");

		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}

	private HashMap<String, String> arrayList2HashMap(ArrayList record, String key) {
		HashMap<String, String> dataSearch = new HashMap<String, String>();
		ReportableListObject row = null;

		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				if (key.equals(row.getValue(1))) {
					dataSearch.put(row.getValue(0), row.getValue(2));
				}
			}
		}
		return dataSearch;
	}

	private ReportableListObject parse2ReportableListObject(HashMap booking, String description) {
		ReportableListObject row = new ReportableListObject(14);
		String key = null;
		int value = 0;
		int totalValue = 0;

		row.setValue(0, description);
		for (int i = 1; i <= 12; i++) {
			key = (i < 10 ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.EMPTY_VALUE) + i;
			value = 0;
			if (booking.containsKey(key)) {
				try {
					value = Integer.parseInt((String) booking.get(key));
				} catch (Exception e) {}
			}
			if (value == 0) {
				row.setValue(i, "--");
			} else {
				row.setValue(i, String.valueOf(value));
				totalValue += value;
			}
		}
		row.setValue(13, String.valueOf(totalValue));
		return row;
	}
%>
<%
UserBean userBean = new UserBean(request);

pctFormat.applyPattern("0.00%");

String searchYear = request.getParameter("searchYear_yy");
int currentYear = DateTimeUtil.getCurrentYear();

if (searchYear == null) {
	searchYear = String.valueOf(currentYear);
}

int previousYear = currentYear;
try {
	previousYear = Integer.parseInt(searchYear) - 1;
} catch (Exception e) {
}
String prevSearchYear = String.valueOf(previousYear);

ArrayList recordMktSrc = getMarketingSource();
ArrayList recordData = getData(searchYear);

ReportableListObject reportableListObject = null;
ArrayList record = new ArrayList<ReportableListObject>();
for (int i = 0; i < recordMktSrc.size(); i++) {
	reportableListObject = (ReportableListObject) recordMktSrc.get(i);
	record.add(parse2ReportableListObject(arrayList2HashMap(recordData, reportableListObject.getValue(0)), reportableListObject.getValue(1)));
}
request.setAttribute("admission_list", record);
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
	<jsp:param name="pageTitle" value="function.marketing.source.report" />
	<jsp:param name="displayTitle" value="Statistics of Marketing Source" />
	<jsp:param name="category" value="Report" />
</jsp:include>
<form name="search_form" action="marketing_source_report.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Search Year</td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="searchYear" />
	<jsp:param name="day_yy" value="<%=searchYear %>" />
	<jsp:param name="yearRange" value="1" />
	<jsp:param name="isYearOnly" value="Y" />
</jsp:include>
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

<bean:define id="functionLabel"><bean:message key="function.admission.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.admission_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable">
	<display:column property="fields0" title="<%=searchYear %>" style="width:20%" />
	<display:column property="fields1" title="Jan" style="width:5%" />
	<display:column property="fields2" title="Feb" style="width:5%" />
	<display:column property="fields3" title="Mar" style="width:5%" />
	<display:column property="fields4" title="Apr" style="width:5%" />
	<display:column property="fields5" title="May" style="width:5%" />
	<display:column property="fields6" title="Jun" style="width:5%" />
	<display:column property="fields7" title="Jul" style="width:5%" />
	<display:column property="fields8" title="Aug" style="width:5%" />
	<display:column property="fields9" title="Sep" style="width:5%" />
	<display:column property="fields10" title="Oct" style="width:5%" />
	<display:column property="fields11" title="Nov" style="width:5%" />
	<display:column property="fields12" title="Dec" style="width:5%" />
	<display:column property="fields13" title="Total" style="width:5%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>

</DIV>

</DIV></DIV>

<script language="javascript">
<!--
	function clearSearch() {
		document.forms["search_form"].elements["searchYear_yy"].value = "<%=currentYear %>";
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>