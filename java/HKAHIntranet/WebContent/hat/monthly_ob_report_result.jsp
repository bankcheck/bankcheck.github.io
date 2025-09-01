<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getDoctorBooking(String searchYear, String docCode) {
		// No. of doctor��s booking = Booking no. start from "B" + Booking no. start from "S"+ doctor code
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(BPBHDATE, 'MM'), COUNT(1) ");
		sqlStr.append("FROM   BEDPREBOK@IWEB ");
		sqlStr.append("WHERE (BPBNO LIKE 'B%' OR BPBNO LIKE 'S%') ");
		sqlStr.append("AND    BPBHDATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BPBHDATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    DOCCODE = '");
		sqlStr.append(docCode);
		sqlStr.append("' ");
		sqlStr.append("AND    BPBSTS != 'D' ");
		sqlStr.append("AND    WRDCODE = 'OB' ");
		sqlStr.append("AND    FORDELIVERY = '-1' ");
		sqlStr.append("GROUP BY TO_CHAR(BPBHDATE, 'MM') ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private StringBuffer parseTable(ArrayList record) {
		ReportableListObject row = null;
		String key = null;
		String value = null;
		HashMap booking = new HashMap();
		int totalValue = 0;

		// initial string buffer
		StringBuffer strbuf = new StringBuffer();

		// loop the result
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				booking.put(row.getValue(0), row.getValue(1));
			}
		}

		for (int i = 1; i <= 12; i++) {
			strbuf.append("<td align=\"center\" width=\"05%\">");
			key = (i < 10 ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.EMPTY_VALUE) + i;
			if (booking.containsKey(key)) {
				value = (String) booking.get(key);
				strbuf.append(value);
				try {
					totalValue += Integer.parseInt(value);
				} catch (Exception e) {}
			} else {
				strbuf.append("--");
			}
			strbuf.append("<br/>(");
			strbuf.append(totalValue);
			strbuf.append(")</td>");
		}
		return strbuf;
	}
%>
<%
UserBean userBean = new UserBean(request);

String docCode = request.getParameter("docCode");
String searchYear = request.getParameter("searchYear_yy");
int currentYear = DateTimeUtil.getCurrentYear();

if (searchYear == null) {
	searchYear = String.valueOf(currentYear);
}
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
<%
if (docCode != null && docCode.length() > 0) {
	ArrayList record = UtilDBWeb.getFunctionResults("HAT_CMB_DOCTOR", new String[] { "" });
	ReportableListObject row = null;
	String temp_docCode = null;
	if (record.size() > 0) {
%>
<table border="1" width="100%">
<%
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			temp_docCode = row.getValue(0);
			if ("ALL".equals(docCode) || docCode.equals(temp_docCode)) {
%>
	<tr>
		<td width="20%">Dr. <%=row.getValue(1) %> <%=row.getValue(2) %>'s Booking</td>
<%=parseTable(getDoctorBooking(searchYear, temp_docCode)) %>
	</tr>
<%
			}
		}
	}
}
%>