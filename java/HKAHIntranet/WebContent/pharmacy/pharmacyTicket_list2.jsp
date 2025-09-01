<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList<ReportableListObject> fetchWard() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PH_LOC_ID, PH_LOC_DESC, PH_LOC_TYPE ");
		sqlStr.append("FROM   PH_LOCATION ");
		sqlStr.append("ORDER BY PH_LOC_TYPE, PH_LOC_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getReportList1(String[] locid, String ticketStartDate, String ticketEndDate, String ticketStartTime, String ticketEndTime, String ordering) {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', Q.PH_TICKET_QUEUE_ID, TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy hh24:mi:ss'), ");
		sqlStr.append("       TO_CHAR((Q.PH_CHARGED_DATE - Q.PH_PRESCRIPTION_DATE) * 1440, 'FM99999999999999990.0'),  ");
		sqlStr.append("       TO_CHAR((Q.PH_COLLECTION_DATE - Q.PH_CHARGED_DATE) * 1440, 'FM99999999999999990.0'),  ");
		sqlStr.append("       TO_CHAR((Q.PH_COMPLETED_DATE - Q.PH_COLLECTION_DATE) * 1440, 'FM99999999999999990.0'),  ");
		sqlStr.append("       TO_CHAR((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_COLLECTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_COMPLETED_DATE - Q.PH_PRESCRIPTION_DATE) * 1440, 'FM99999999999999990.0'),  ");
		sqlStr.append("       TO_CHAR((Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       Q.PH_LOC_ID, L.PH_LOC_TYPE ");
		sqlStr.append("FROM   PH_TICKET_QUEUE Q INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID ");
		sqlStr.append("WHERE  Q.PH_CREATED_DATE >= TO_DATE(? || ' 00:00:00', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    Q.PH_CREATED_DATE <= TO_DATE(? || ' 23:59:59', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') >= ? ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') <= ? ");

		sqlStr.append("AND    Q.PH_LOC_ID IN (");
		for (int i = 0; i < locid.length; i++) {
			if (i > 0) {
				sqlStr.append(",");
			}
			sqlStr.append("'");
			sqlStr.append(locid[i]);
			sqlStr.append("'");
		}
		sqlStr.append(") ");

		if ("2".equals(ordering)) {
			sqlStr.append("ORDER BY L.PH_LOC_TYPE, L.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID DESC");
		} else {
			sqlStr.append("ORDER BY L.PH_LOC_TYPE, L.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID ASC");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime });
	}

	private ArrayList getReportList2(String[] locid, String ticketStartDate, String ticketEndDate, String ticketStartTime, String ticketEndTime, String ordering) {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', Q.PH_TICKET_QUEUE_ID, TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy hh24:mi:ss'), ");
		sqlStr.append("       TO_CHAR(Q.PH_PRESCRIPTION_DATE, 'dd/MM/yyyy hh24:mi:ss'),  ");
		sqlStr.append("       TO_CHAR(Q.PH_CHARGED_DATE, 'dd/MM/yyyy hh24:mi:ss'),  ");
		sqlStr.append("       TO_CHAR(Q.PH_COLLECTION_DATE, 'dd/MM/yyyy hh24:mi:ss'),  ");
		sqlStr.append("       TO_CHAR(Q.PH_COMPLETED_DATE, 'dd/MM/yyyy hh24:mi:ss'),  ");
		sqlStr.append("       TO_CHAR((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_COLLECTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       Q.PH_LOC_ID, L.PH_LOC_TYPE ");
		sqlStr.append("FROM   PH_TICKET_QUEUE Q INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID ");
		sqlStr.append("WHERE  Q.PH_CREATED_DATE >= TO_DATE(? || ' 00:00:00', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    Q.PH_CREATED_DATE <= TO_DATE(? || ' 23:59:59', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') >= ? ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') <= ? ");

		sqlStr.append("AND    Q.PH_LOC_ID IN (");
		for (int i = 0; i < locid.length; i++) {
			if (i > 0) {
				sqlStr.append(",");
			}
			sqlStr.append("'");
			sqlStr.append(locid[i]);
			sqlStr.append("'");
		}
		sqlStr.append(") ");

		if ("2".equals(ordering)) {
			sqlStr.append("ORDER BY L.PH_LOC_TYPE, L.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID DESC");
		} else {
			sqlStr.append("ORDER BY L.PH_LOC_TYPE, L.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID ASC");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime });
	}

	private ArrayList getReportList3(String[] locid, String ticketStartDate, String ticketEndDate, String ticketStartTime, String ticketEndTime, String ordering) {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy'), ");
		sqlStr.append("       COUNT(1), ");
		sqlStr.append("       TO_CHAR(MAX(Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR(MIN(Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR(AVG(Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((SUM(CASE WHEN Q.PH_COLLECTION_DATE < Q.PH_EST_COMPLETED_DATE THEN 1 ELSE 0 END) / COUNT(1) * 100), 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR(PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0') ");
		sqlStr.append("FROM   PH_TICKET_QUEUE Q INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID ");
		sqlStr.append("WHERE  Q.PH_CREATED_DATE >= TO_DATE(? || ' 00:00:00', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    Q.PH_CREATED_DATE <= TO_DATE(? || ' 23:59:59', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') >= ? ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') <= ? ");

		sqlStr.append("AND    Q.PH_LOC_ID IN (");
		for (int i = 0; i < locid.length; i++) {
			if (i > 0) {
				sqlStr.append(",");
			}
			sqlStr.append("'");
			sqlStr.append(locid[i]);
			sqlStr.append("'");
		}
		sqlStr.append(") ");

		if (locid != null && locid.length > 0) {
			if (locid.equals("IP")) {
				sqlStr.append("AND    L.PH_LOC_TYPE = 'I' ");
			} else if (locid.equals("OP")) {
				sqlStr.append("AND    L.PH_LOC_TYPE = 'O' ");
			} else {
				sqlStr.append("AND    Q.PH_LOC_ID = ? ");
			}
		}

		sqlStr.append("GROUP BY L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', Q.PH_TICKET_DT, TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy') ");
		sqlStr.append("ORDER BY L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', Q.PH_TICKET_DT, TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy') ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime });
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

String[] locid = request.getParameterValues("locid");
HashSet locidSet = new HashSet();
if (locid != null && locid.length > 0) {
	for (int i = 0; i < locid.length; i++) {
		locidSet.add(locid[i]);
	}
}
String ticketStartDate = request.getParameter("ticketStartDate");
String ticketEndDate = request.getParameter("ticketEndDate");
String ticketStartTime = "00:00";
String ticketStartTime_hh = request.getParameter("ticketStartTime_hh");
String ticketStartTime_mi = request.getParameter("ticketStartTime_mi");
if (ticketStartTime_hh != null && ticketStartTime_mi != null) {
	ticketStartTime = ticketStartTime_hh + ":" + ticketStartTime_mi;
}
String ticketEndTime = "23:59";
String ticketEndTime_hh = request.getParameter("ticketEndTime_hh");
String ticketEndTime_mi = request.getParameter("ticketEndTime_mi");
if (ticketEndTime_hh != null && ticketEndTime_mi != null) {
	ticketEndTime = ticketEndTime_hh + ":" + ticketEndTime_mi;
}

String reportType = request.getParameter("reportType");
String ordering = request.getParameter("ordering");

TreeMap<String, String> allIPWard = new TreeMap<String, String>();
TreeMap<String, String> allOPWard = new TreeMap<String, String>();
ArrayList<ReportableListObject> record = fetchWard();
ReportableListObject row2 = null;
for (int i = 0; i < record.size(); i++) {
	row2 = (ReportableListObject) record.get(i);
	if ("I".equals(row2.getValue(2))) {
		allIPWard.put(row2.getValue(0), row2.getValue(1));
	} else if ("O".equals(row2.getValue(2))) {
		allOPWard.put(row2.getValue(0), row2.getValue(1));
	}
}

// default search current delivery date
if (ticketStartDate == null || ticketStartDate.length() == 0) {
	ticketStartDate = DateTimeUtil.getCurrentDate();
}
if (ticketEndDate == null || ticketEndDate.length() == 0) {
	ticketEndDate = DateTimeUtil.getCurrentDate();
}

if (locid != null && locid.length > 0) {
	if ("1".equals(reportType)) {
		request.setAttribute("pharmacyTicket_list", getReportList1(locid, ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime, ordering));
	} else if ("2".equals(reportType)) {
		request.setAttribute("pharmacyTicket_list", getReportList2(locid, ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime, ordering));
	} else if ("3".equals(reportType)) {
		request.setAttribute("pharmacyTicket_list", getReportList3(locid, ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime, ordering));
	}
} else {
	errorMessage = "No ward is selected.";
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
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Pharmacy Ticket Report" />
	<jsp:param name="category" value="prompt.admin" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="get" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Location</td>
		<td class="infoData" width="70%">
			<table>
			<tr>
				<td colspan="2"><button onclick="return setAllWard('IP');">All IP Ward</button>
			</tr>
			<tr>
				<td>&nbsp;</td><td>
<%for(Map.Entry<String, String> entry : allIPWard.entrySet()) { %>
				<input type="checkbox" name="locid" value="<%=entry.getKey() %>"<%if (locidSet.contains(entry.getKey())) {%> checked<%} %> onclick="return unsetAllWard(this, 'OP');"><%=entry.getValue() %><br>
<%} %>
				</td>
			</tr>
			<tr>
				<td colspan="2"><button onclick="return setAllWard('OP');">All OP Ward</button>
			</tr>
			<tr>
				<td>&nbsp;</td><td>
<%for(Map.Entry<String, String> entry : allOPWard.entrySet()) { %>
				<input type="checkbox" name="locid" value="<%=entry.getKey() %>"<%if (locidSet.contains(entry.getKey())) {%> checked<%} %> onclick="return unsetAllWard(this, 'IP');"><%=entry.getValue() %><br>
<%} %>
				</td>
			</tr>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Date Period</td>
		<td class="infoData" width="70%">
			<input type="text" name="ticketStartDate" id="ticketStartDate" class="datepickerfield" value="<%=ticketStartDate == null ? "" : ticketStartDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
			-
			<input type="text" name="ticketEndDate" id="ticketEndDate" class="datepickerfield" value="<%=ticketEndDate == null ? "" : ticketEndDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Time Period</td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="ticketStartTime" />
	<jsp:param name="time" value="<%=ticketStartTime %>" />
	<jsp:param name="interval" value="1" />
</jsp:include>
			-
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="ticketEndTime" />
	<jsp:param name="time" value="<%=ticketEndTime %>" />
	<jsp:param name="interval" value="1" />
</jsp:include>&nbsp;&nbsp;&nbsp;<button onclick="return setAllDay();">All Day</button>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Report Type</td>
		<td class="infoData" width="70%">
			<select name="reportType" id="reportType">
				<option value="1"<%if (reportType == null || "1".equals(reportType)) {%> selected<%} %>>Report 1</option>
				<option value="2"<%if ("2".equals(reportType)) {%> selected<%} %>>Report 2</option>
				<option value="3"<%if ("3".equals(reportType)) {%> selected<%} %>>Report 3</option>
			</select>
		</td>
	</tr>
<!--
	<tr class="smallText">
		<td class="infoLabel" width="30%">Ordering</td>
		<td class="infoData" width="70%">
			<select name="ordering">
				<option value="1"<%if ("1".equals(ordering)) {%> selected<%} %>>Ticket No (Ascending)</option>
				<option value="2"<%if ("2".equals(ordering)) {%> selected<%} %>>Ticket No (Descending)</option>
			</select>
		</td>
	</tr>
-->
	<tr class="smallText">
		<td colspan="2" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
			<button type="reset"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>

<bean:define id="functionLabel">Pharmacy Ticket</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<%if ("1".equals(reportType)) { %>
<display:table id="row" name="requestScope.pharmacyTicket_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Location" style="width:8%" />
	<display:column title="Ticket No." style="width:8%">
		<logic:equal name="row" property="fields11" value="O">
			<c:out value="${row.fields1}" />
		</logic:equal>
		<logic:equal name="row" property="fields11" value="I">
			<c:set var="string" value="${row.fields1}"/>
			<c:out value="${row.fields10}" />-<c:out value="${fn:substring(string, 4, 10)}"/>
		</logic:equal>
	</display:column>
	<display:column property="fields2" title="Start Time" style="width:8%" />
	<display:column title="Scan Point 1 to 2 Time" style="width:8%">
		<logic:equal name="row" property="fields3" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields3" value="">
			<c:out value="${row.fields3}" /> mins
		</logic:notEqual>
	</display:column>
	<display:column title="Scan Point 2 to 3 Time" style="width:8%">
		<logic:equal name="row" property="fields4" value="">
				--
		</logic:equal>
		<logic:notEqual name="row" property="fields3" value="">
			<c:out value="${row.fields4}" /> mins
		</logic:notEqual>
	</display:column>
	<display:column title="Scan Point 3 to 4 Time" style="width:8%">
		<logic:equal name="row" property="fields5" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields6" value="">
			<c:out value="${row.fields5}" /> mins
		</logic:notEqual>
	</display:column>
	<display:column title="Estimated Waiting Time" style="width:8%">
		<logic:equal name="row" property="fields6" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields5" value="">
			<c:out value="${row.fields6}" /> mins
		</logic:notEqual>
	</display:column>
	<display:column title="Real Waiting Time" style="width:8%">
		<logic:equal name="row" property="fields7" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields6" value="">
			<c:out value="${row.fields7}" /> mins
		</logic:notEqual>
	</display:column>
	<display:column title="Total Used Time (Up to Scan Point 3)" style="width:8%">
		<logic:equal name="row" property="fields8" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields7" value="">
			<c:out value="${row.fields8}" /> mins
		</logic:notEqual>
	</display:column>
	<display:column title="Total Used Time" style="width:8%">
		<logic:equal name="row" property="fields9" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="">
			<c:out value="${row.fields9}" /> mins
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%} else if ("2".equals(reportType)) { %>
<display:table id="row" name="requestScope.pharmacyTicket_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Location" style="width:8%" />
	<display:column title="Ticket No." style="width:8%">
		<logic:equal name="row" property="fields11" value="O">
			<c:out value="${row.fields1}" />
		</logic:equal>
		<logic:equal name="row" property="fields11" value="I">
			<c:set var="string" value="${row.fields1}"/>
			<c:out value="${row.fields10}" />-<c:out value="${fn:substring(string, 4, 10)}"/>
		</logic:equal>
	</display:column>
	<display:column property="fields2" title="Start Time" style="width:8%" />
	<display:column property="fields3" title="Scan Point 1 Time" style="width:8%" />
	<display:column property="fields4" title="Scan Point 2 Time" style="width:8%" />
	<display:column property="fields5" title="Scan Point 3 Time" style="width:8%" />
	<display:column property="fields6" title="Completed Time" style="width:8%" />
	<display:column title="Estimated Waiting Time" style="width:8%">
		<logic:equal name="row" property="fields7" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields7" value="">
			<c:out value="${row.fields7}" /> mins
		</logic:notEqual>
	</display:column>
	<display:column title="Real Waiting Time" style="width:8%">
		<logic:equal name="row" property="fields8" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="">
			<c:out value="${row.fields8}" /> mins
		</logic:notEqual>
	</display:column>
	<display:column title="Total Used Time" style="width:8%">
		<logic:equal name="row" property="fields9" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields9" value="">
			<c:out value="${row.fields9}" /> mins
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%} else if ("3".equals(reportType)) { %>
<display:table id="row" name="requestScope.pharmacyTicket_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Location" style="width:8%" />
	<display:column property="fields1" title="Date" style="width:8%" />
	<display:column property="fields2" title="Total no of ticket" style="width:8%" />
	<display:column property="fields3" title="Max (mins)" style="width:8%" />
	<display:column property="fields4" title="Min (mins)" style="width:8%" />
	<display:column property="fields5" title="Mean (mins)" style="width:8%" />
	<display:column property="fields6" title="% within estimated time" style="width:8%" />
	<display:column property="fields7" title="25th Percentile" style="width:8%" />
	<display:column property="fields8" title="75th Percentile" style="width:8%" />
	<display:column property="fields9" title="95th Percentile" style="width:8%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%}%>

<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.ticketStartDate.value = "<%=ticketStartDate %>";
		document.search_form.ticketEndDate.value = "<%=ticketEndDate %>";
		return setAllDay();
	}

	function setAllDay() {
		document.search_form.ticketStartTime_hh.selectedIndex = "0";
		document.search_form.ticketStartTime_mi.selectedIndex = "0";
		document.search_form.ticketEndTime_hh.selectedIndex = "23";
		document.search_form.ticketEndTime_mi.selectedIndex = "59";
		return false;
	}

	function setAllWard(type) {
		var array_ip = [<%for(Map.Entry<String, String> entry : allIPWard.entrySet()) { %>'<%=entry.getKey() %>',<%} %>];
		var array_op = [<%for(Map.Entry<String, String> entry : allOPWard.entrySet()) { %>'<%=entry.getKey() %>',<%} %>];
		var checkboxes = document.getElementsByName('locid');
		for (var j = 0; j < checkboxes.length; j++) {
			checkboxes[j].checked = false;
			if (type == 'IP') {
				for (var i = 0; i < array_ip.length; i++) {
					if (checkboxes[j].value == array_ip[i]) {
						checkboxes[j].checked = true;
					}
				}
			} else {
				for (var i = 0; i < array_op.length; i++) {
					if (checkboxes[j].value == array_op[i]) {
						checkboxes[j].checked = true;
					}
				}
			}
		}
		return false;
	}

	function unsetAllWard(cb, type) {
		var array_ip = [<%for(Map.Entry<String, String> entry : allIPWard.entrySet()) { %>'<%=entry.getKey() %>',<%} %>];
		var array_op = [<%for(Map.Entry<String, String> entry : allOPWard.entrySet()) { %>'<%=entry.getKey() %>',<%} %>];
		var checkboxes = document.getElementsByName('locid');
		for (var j = 0; j < checkboxes.length; j++) {
			if (type == 'IP') {
				for (var i = 0; i < array_ip.length; i++) {
					if (checkboxes[j].value == array_ip[i]) {
						checkboxes[j].checked = false;
					}
				}
			} else {
				for (var i = 0; i < array_op.length; i++) {
					if (checkboxes[j].value == array_op[i]) {
						checkboxes[j].checked = false;
					}
				}
			}
		}
		return true;
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>