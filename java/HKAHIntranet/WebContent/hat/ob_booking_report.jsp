<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private static DecimalFormat pctFormat = new DecimalFormat();

	private ArrayList getCancelBookingByYear(String searchYear) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE, COUNT(1) ");
		sqlStr.append("FROM   BEDPREBOK@IWEB ");
		sqlStr.append("WHERE (BPBNO LIKE 'B%' OR BPBNO LIKE 'S%') ");
		sqlStr.append("AND    BPBHDATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BPBHDATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BPBSTS = 'D' ");
		sqlStr.append("AND    WRDCODE IN ('OB', 'U100') ");
		sqlStr.append("AND    FORDELIVERY = '-1' ");
		sqlStr.append("GROUP BY DOCCODE ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getCancelBookingByMonth(String searchYear, boolean showReference) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT B.DOCCODE, TO_CHAR(B.BPBHDATE, 'MM'), SUM(1), ");
		if (showReference) {
			sqlStr.append("   SUM(DECODE(PATDOCTYPE, 'L', 1, 'C', 1, 0)) ");
		} else {
			sqlStr.append("   SUM(DECODE(ISMAINLAND, '-1', 1, 0)) ");
		}
		sqlStr.append("FROM   BEDPREBOK@IWEB B ");
		sqlStr.append("WHERE (B.BPBNO LIKE 'B%' OR B.BPBNO LIKE 'S%') ");
		sqlStr.append("AND    B.BPBHDATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    B.BPBHDATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    B.BPBSTS = 'D' ");
		sqlStr.append("AND    B.WRDCODE IN ('OB', 'U100') ");
		sqlStr.append("AND    B.FORDELIVERY = '-1' ");
		sqlStr.append("GROUP BY B.DOCCODE, TO_CHAR(B.BPBHDATE, 'MM') ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getDoctorBookingByYear(String searchYear) {
		// No. of doctor's booking = Booking no. start from "B" + Booking no. start from "S"+ doctor code
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE, COUNT(1) ");
		sqlStr.append("FROM   BEDPREBOK@IWEB ");
		sqlStr.append("WHERE (BPBNO LIKE 'B%' OR BPBNO LIKE 'S%') ");
		sqlStr.append("AND    BPBHDATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BPBHDATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BPBSTS != 'D' ");
		sqlStr.append("AND    WRDCODE IN ('OB', 'U100') ");
		sqlStr.append("AND    FORDELIVERY = '-1' ");
		sqlStr.append("GROUP BY DOCCODE ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getDoctorBookingByMonth(String searchYear, boolean showReference) {
		// No. of doctor's booking = Booking no. start from "B" + Booking no. start from "S"+ doctor code
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT B.DOCCODE, TO_CHAR(B.BPBHDATE, 'MM'), SUM(1), ");
		if (showReference) {
			sqlStr.append("   SUM(DECODE(PATDOCTYPE, 'L', 1, 'C', 1, 0)) ");
		} else {
			sqlStr.append("   SUM(DECODE(ISMAINLAND, '-1', 1, 0)) ");
		}
		sqlStr.append("FROM   BEDPREBOK@IWEB B ");
		sqlStr.append("WHERE (B.BPBNO LIKE 'B%' OR B.BPBNO LIKE 'S%') ");
		sqlStr.append("AND    B.BPBHDATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    B.BPBHDATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    B.BPBSTS != 'D' ");
		sqlStr.append("AND    B.WRDCODE IN ('OB', 'U100') ");
		sqlStr.append("AND    B.FORDELIVERY = '-1' ");
		sqlStr.append("GROUP BY B.DOCCODE, TO_CHAR(B.BPBHDATE, 'MM') ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getNoOfDepositPaid(String searchYear, boolean showReference) {
		// No. of deposit paid = Booking no. start from "B" + Booking no. start from "S" +  Slip no. + Amount range from $20,000 to $100,000
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE, TO_CHAR(BPBHDATE, 'MM'), SUM(1), ");
		if (showReference) {
			sqlStr.append("   SUM(DECODE(PATDOCTYPE, 'L', 1, 'C', 1, 0)) ");
		} else {
			sqlStr.append("   SUM(DECODE(ISMAINLAND, '-1', 1, 0)) ");
		}
		sqlStr.append("FROM   BEDPREBOK@IWEB ");
		sqlStr.append("WHERE (BPBNO LIKE 'B%' OR BPBNO LIKE 'S%') ");
		sqlStr.append("AND    BPBHDATE >= TO_DATE('01/01/");
		sqlStr.append(searchYear);
		sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BPBHDATE <= TO_DATE('31/12/");
		sqlStr.append(searchYear);
		sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    BPBSTS != 'D' ");
		sqlStr.append("AND    WRDCODE IN ('OB', 'U100') ");
		sqlStr.append("AND    FORDELIVERY = '-1' ");
		sqlStr.append("AND    SLPNO IS NOT NULL ");
		sqlStr.append("GROUP BY DOCCODE, TO_CHAR(BPBHDATE, 'MM') ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private String parseValue(int value) {
		if (value == 0) {
			return "--";
		} else {
			return String.valueOf(value);
		}
	}

	private String parseValue(String value) {
		if (value == null || "0".equals(value)) {
			return "--";
		} else {
			return value;
		}
	}

	private String parseValueWithAverage(int value) {
		StringBuffer sb = new StringBuffer();
		if (value >= 12) {
			sb.append("<span title=\"number divided by 12\">");
			sb.append("/");
			sb.append(parseValue((int) (value + 6)/ 12));
			sb.append("</span>");
		}
		return sb.toString();
	}

	private String parseValueWithAverage(String value) {
		try {
			return parseValueWithAverage(Integer.parseInt(value));
		} catch (Exception e) {
			return parseValueWithAverage(0);
		}
	}

	private int string2Int(String value) {
		try {
			return Integer.parseInt(value);
		} catch (Exception e) {
			return 0;
		}
	}

	private int string2Int(HashMap<String, String> hashMap, String key) {
		try {
			return string2Int(hashMap.get(key));
		} catch (Exception e) {
			return 0;
		}
	}

	private StringBuffer parseTable(
			HashMap<String, String> totalDoc,
			HashMap<String, String> totalDocMainland,
			HashMap<String, String> totalPaidDoc,
			HashMap<String, String> totalPaidDocMainland,
			HashMap<String, String> totalCancel,
			HashMap<String, String> totalCancelMainland,
			String prevYearData,
			String docCode, String docLName, String docFName,
			HashMap<String, String> data2006, HashMap<String, String> data2010,
			HashMap<String, HashMap> dataTotal,
			boolean showReference) {
		ReportableListObject row = null;

		// initial string buffer
		StringBuffer strbuf = new StringBuffer();

		strbuf.append("<tr><td>");
		strbuf.append(docLName);
		strbuf.append(" ");
		strbuf.append(docFName);
		strbuf.append("</td><td>");
		strbuf.append(docCode);
		strbuf.append("</td>");

		int doc2006Value = 0;
		int doc2010Value = 0;
		if (showReference) {
			doc2006Value = string2Int(data2006.get(docCode));
			doc2010Value = string2Int(data2010.get(docCode));
			strbuf.append("<td class=\"warning\">");
			strbuf.append(parseValue(doc2006Value));
			strbuf.append(parseValueWithAverage(doc2006Value));
			strbuf.append("</td><td class=\"warning\">");
			strbuf.append(parseValue(doc2010Value));
			strbuf.append(parseValueWithAverage(doc2010Value));
			strbuf.append("</td>");
		}
		//strbuf.append("<td class=\"warning\">");
	//	strbuf.append(parseValue(prevYearData));
		//strbuf.append(parseValueWithAverage(prevYearData));
		//strbuf.append("</td>");

		String key = null;
		String valueStr = null;

		int hkValue = 0;
		int hkPaidValue = 0;
		int hkCancelValue = 0;
		int mainlandValue = 0;
		int mainlandPaidValue = 0;
		int mainlandCancelValue = 0;
		int totalValue = 0;
		int totalPaidValue = 0;
		int totalCancelValue = 0;
		int totalValuePerDoc = 0;

		for (int i = 1; i <= 12; i++) {
			strbuf.append("<td align=\"center\" width=\"05%\">");
			key = (i < 10 ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.EMPTY_VALUE) + i;

			mainlandValue = string2Int(totalDocMainland, key);
			mainlandPaidValue = string2Int(totalPaidDocMainland, key);
			mainlandCancelValue = string2Int(totalCancelMainland, key);
			totalValue = string2Int(totalDoc, key);
			totalPaidValue = string2Int(totalPaidDoc, key);
			totalCancelValue = string2Int(totalCancel, key);
			hkValue = totalValue - mainlandValue;
			hkPaidValue = totalPaidValue - mainlandPaidValue;
			hkCancelValue = totalCancelValue - mainlandCancelValue;

			strbuf.append("<table><tr><td class=\"labelColor6\">");
			strbuf.append(parseValue(hkValue));
			strbuf.append("</td><td>/</td><td class=\"labelColor1\">");
			strbuf.append(parseValue(mainlandValue));
			strbuf.append("</td></tr>");
			if (showReference) {
				strbuf.append("<tr><td class=\"labelColor6\">");
				strbuf.append(parseValue(hkPaidValue));
				strbuf.append("</td><td>/</td><td class=\"labelColor1\">");
				strbuf.append(parseValue(mainlandPaidValue));
				strbuf.append("</td></tr><tr><td class=\"labelColor4\">");
				strbuf.append(parseValue(hkCancelValue));
				strbuf.append("</td><td>/</td><td class=\"labelColor4\">");
				strbuf.append(parseValue(mainlandCancelValue));
				strbuf.append("</td></tr>");
			}
			strbuf.append("<tr><td align=\"center\" colspan=\"3\">(<span class=\"labelColor2\">");
			strbuf.append(parseValue(totalValue));
			strbuf.append("</span>)</td></tr></table></td>");

			updateTotal(dataTotal, key, "total", totalValue);
			updateTotal(dataTotal, key, "mainland", mainlandValue);
			updateTotal(dataTotal, key, "cancel", totalCancelValue);

			totalValuePerDoc += totalValue;
		}
		strbuf.append("<td class=\"warning\">");
		strbuf.append(parseValue(totalValuePerDoc));
		strbuf.append("</td>");
		strbuf.append("</tr>");

		if ((!showReference || (doc2006Value == 0 && doc2010Value == 0)) && totalValuePerDoc == 0) {
			strbuf.setLength(0);
		}
		return strbuf;
	}

	private StringBuffer parseTableTotal(HashMap<String, HashMap> dataTotal, boolean showReference) {
		ReportableListObject row = null;

		// initial string buffer
		StringBuffer strbuf = new StringBuffer();

		strbuf.append("<tr><td colspan=\"");

		if (showReference) {
			strbuf.append(4);
		} else {
			strbuf.append(2);
		}
		strbuf.append("\" align=\"right\"><b>Total&nbsp;</b></td>");

		String key = null;

		int dataTotalValue = 0;
		int dataTotalMainlandValue = 0;
		int dataTotalCancelValue = 0;
		int totalValue = 0;
		int totalValueMainland = 0;
		int totalValueCancel = 0;

		for (int i = 1; i <= 12; i++) {
			strbuf.append("<td align=\"center\" width=\"05%\">");
			key = (i < 10 ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.EMPTY_VALUE) + i;

			dataTotalValue = getTotal(dataTotal, key, "total");
			dataTotalMainlandValue = getTotal(dataTotal, key, "mainland");
			dataTotalCancelValue = getTotal(dataTotal, key, "cancel");
			totalValue += dataTotalValue;
			totalValueMainland += dataTotalMainlandValue;
			totalValueCancel += dataTotalCancelValue;

			strbuf.append("<span title=\"Sum of mainland patient");
			if (showReference) {
				strbuf.append("/Sum of cancel patient");
			}
			strbuf.append("\"><span class=\"labelColor1\">");
			strbuf.append(parseValue(dataTotalMainlandValue));
			if (showReference) {
				strbuf.append("</span>/<span class=\"labelColor4\">");
				strbuf.append(parseValue(dataTotalCancelValue));
			}
			strbuf.append("</span></span><br><span title=\"Sum of patient\">(<span class=\"labelColor2\">");
			strbuf.append(parseValue(dataTotalValue));
			strbuf.append("</span>)</span></td>");
		}
		strbuf.append("<td align=\"center\">");
		strbuf.append("<span class=\"labelColor1\">");
		strbuf.append(parseValue(totalValueMainland));
		if (showReference) {
			strbuf.append("</span>/<span class=\"labelColor4\">");
			strbuf.append(parseValue(totalValueCancel));
		}
		strbuf.append("</span><br>(<span class=\"labelColor2\">");
		strbuf.append(parseValue(totalValue));
		strbuf.append("</span>)</td></tr>");
		return strbuf;
	}

	private void updateTotal(HashMap<String, HashMap> dataTotal, String key, String type, int newValue) {
		// get old map
		HashMap<String, String> oldMap = null;
		if (dataTotal.containsKey(key)) {
			oldMap = dataTotal.get(key);
		} else {
			oldMap = new HashMap<String, String>();
		}

		// get old value
		int oldValue = 0;
		if (oldMap.containsKey(type)) {
			try {
				oldValue = Integer.parseInt(oldMap.get(type));
			} catch (Exception e) {}
		}
		oldMap.put(type, String.valueOf(oldValue + newValue));

		// put it back to hash
		dataTotal.put(key, oldMap);
	}

	private int getTotal(HashMap<String, HashMap> dataTotal, String key, String type) {
		int value = 0;

		// get old map
		if (dataTotal.containsKey(key)) {
			value = string2Int(dataTotal.get(key), type);
		}
		return value;
	}

	private HashMap<String, HashMap> arrayList2HashMap(ArrayList record, int index) {
		HashMap<String, HashMap> dataSearchDoc = new HashMap<String, HashMap>();
		HashMap<String, String> dataSearch = null;
		String docCode = null;
		ReportableListObject row = null;

		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				docCode = row.getValue(0);
				if (dataSearchDoc.containsKey(docCode)) {
					dataSearch = dataSearchDoc.get(docCode);
				} else {
					dataSearch = new HashMap<String, String>();
				}
				dataSearch.put(row.getValue(1), row.getValue(index));
				dataSearchDoc.put(docCode, dataSearch);
			}
		}
		return dataSearchDoc;
	}

	private HashMap<String, String> arrayList2HashMapInString(ArrayList record) {
		HashMap<String, String> dataSearchDoc = new HashMap<String, String>();
		ReportableListObject row = null;

		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				dataSearchDoc.put(row.getValue(0), row.getValue(1));
			}
		}
		return dataSearchDoc;
	}
%>
<%
UserBean userBean = new UserBean(request);

pctFormat.applyPattern("0.00%");

String searchYear = request.getParameter("searchYear_yy");
int currentYear = DateTimeUtil.getCurrentYear() + 1;

if (searchYear == null) {
	searchYear = String.valueOf(currentYear);
}

int previousYear = currentYear;
try {
	previousYear = Integer.parseInt(searchYear) - 1;
} catch (Exception e) {
}
String prevSearchYear = String.valueOf(previousYear);

// default data
HashMap<String, String> data2006 = new HashMap<String, String>();
data2006.put("1117", "1");
data2006.put("1107", "14");
data2006.put("1168", "8");
data2006.put("1391", "0");
data2006.put("891",  "18");
data2006.put("1284", "5");
data2006.put("88",   "0");
data2006.put("1443", "0");
data2006.put("566",  "96");
data2006.put("1110", "30");
data2006.put("1062", "22");
data2006.put("696",  "45");
data2006.put("1416", "0");
data2006.put("849",  "0");
data2006.put("956",  "67");
data2006.put("1475", "0");
data2006.put("816",  "26");
data2006.put("220",  "9");
data2006.put("1400", "0");
data2006.put("1185", "0");
data2006.put("596",  "22");
data2006.put("1054", "61");
data2006.put("1323", "0");
data2006.put("237",  "1");
data2006.put("1028", "2");
data2006.put("242",  "12");
data2006.put("258",  "12");
data2006.put("1252", "6");
data2006.put("678",  "9");
data2006.put("1570", "0");
data2006.put("705",  "32");
data2006.put("337",  "1");
data2006.put("1256", "20");
data2006.put("1376", "0");
data2006.put("1499", "0");
data2006.put("1377", "0");
data2006.put("552",  "1");
data2006.put("683",  "20");
data2006.put("820",  "27");
data2006.put("403",  "0");
data2006.put("1382", "0");
data2006.put("1383", "0");
data2006.put("559",  "152");
data2006.put("667",  "20");
data2006.put("1355", "1");
data2006.put("1470", "0");
data2006.put("1192", "16");
data2006.put("1127", "21");
data2006.put("469",  "9");
data2006.put("494",  "15");

boolean showReference = ConstantsServerSide.isHKAH();

HashMap<String, String> data2010 = arrayList2HashMapInString(getDoctorBookingByYear("2010"));
HashMap<String, String> dataSearchPrevYear = arrayList2HashMapInString(getDoctorBookingByYear(prevSearchYear));

HashMap<String, HashMap> totalDoc = arrayList2HashMap(getDoctorBookingByMonth(searchYear, showReference), 2);
HashMap<String, HashMap> totalDocMainland = arrayList2HashMap(getDoctorBookingByMonth(searchYear, showReference), 3);
HashMap<String, HashMap> totalPaidDoc = arrayList2HashMap(getNoOfDepositPaid(searchYear, showReference), 2);
HashMap<String, HashMap> totalPaidDocMainland = arrayList2HashMap(getNoOfDepositPaid(searchYear, showReference), 3);
HashMap<String, HashMap> totalCancel = arrayList2HashMap(getCancelBookingByMonth(searchYear, showReference), 2);
HashMap<String, HashMap> totalCancelMainland = arrayList2HashMap(getCancelBookingByMonth(searchYear, showReference), 3);
HashMap<String, HashMap> dataTotal = new HashMap<String, HashMap>();
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>
.dataSummary {
	border-left:1px solid #000;
	border-top:1px solid #000;
	border-right:1px solid #CCC;
	border-bottom:1px solid #ccc;
	cursor: pointer;
}
</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.monthly.ob.report2" />
	<jsp:param name="category" value="Report" />
</jsp:include>
<div id="obBookingDetail"></div>
<form name="search_form" action="ob_booking_report.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch search" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Search Year</td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="searchYear" />
	<jsp:param name="day_yy" value="<%=searchYear %>" />
	<jsp:param name="yearRange" value="1" />
	<jsp:param name="isYearOnly" value="Y" />
	<jsp:param name="isYearOrderDesc" value="Y" />
	<jsp:param name="isObBkUse" value="Y" />
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

<div id="floating-header" style="z-index:100; position:absolute; background-color:#F0F0F0">
	<table border="1" width="100%">
		<tr>
			<td colspan="<%=showReference?"17":"15"%>">
				<table cellpadding="0" cellspacing="5"
					class="contentFrameSearch" border="0">

					<tr class="smallText">
						<td class="infoLabel" width="30%">Legend for each cell</td>
						<td class="infoData" width="70%">
							<table>
								<tr><td class="labelColor6">Total non-mainland patient</td><td>/</td><td class="labelColor1">Total mainland patient</td></tr>
				<%	if (showReference) { %>
								<tr><td class="labelColor6">Total non-mainland paid patient</td><td>/</td><td class="labelColor1">Total mainland paid patient</td></tr>
								<tr><td class="labelColor4">Total non-mainland cancelled patient</td><td>/</td><td class="labelColor4">Total mainland cancelled patient</td></tr>
				<%	} %>
								<tr><td align="center" colspan="3"><span class="labelColor2">Total patient</span></td></tr>
							</table>
						</td>
					</tr>

				</table>
			</td>
		</tr>
		<tr>
			<td class="infoCenterLabel" width="15%">Obstetricians</td>
			<td class="infoCenterLabel" width="05%">Code</td>
	<%	if (showReference) { %>
			<td class="warning" width="05%">2006</td>
			<td class="warning" width="05%">2010</td>
	<%	} %>
			<!--  <td class="warning" width="05%"><%=prevSearchYear %></td>-->
			<td class="infoCenterLabel monthDetail" width="05%" id="1" style="cursor:pointer;">Jan</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="2" style="cursor:pointer;">Feb</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="3" style="cursor:pointer;">Mar</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="4" style="cursor:pointer;">Apr</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="5" style="cursor:pointer;">May</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="6" style="cursor:pointer;">Jun</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="7" style="cursor:pointer;">Jul</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="8" style="cursor:pointer;">Aug</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="9" style="cursor:pointer;">Sep</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="10" style="cursor:pointer;">Oct</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="11" style="cursor:pointer;">Nov</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="12" style="cursor:pointer;">Dec</td>
			<td class="warning" width="05%" id="resultYear"><%=searchYear %></td>
		</tr>
	</table>
</div>

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch legend" border="0" style="visibility:hidden">

	<tr class="smallText">
		<td class="infoLabel" width="30%">Legend for each cell</td>
		<td class="infoData" width="70%">
			<table>
				<tr><td class="labelColor6">Total non-mainland patient</td><td>/</td><td class="labelColor1">Total mainland patient</td></tr>
<%	if (showReference) { %>
				<tr><td class="labelColor6">Total non-mainland paid patient</td><td>/</td><td class="labelColor1">Total mainland paid patient</td></tr>
				<tr><td class="labelColor4">Total non-mainland cancelled patient</td><td>/</td><td class="labelColor4">Total mainland cancelled patient</td></tr>
<%	} %>
				<tr><td align="center" colspan="3"><span class="labelColor2">Total patient</span></td></tr>
			</table>
		</td>
	</tr>

</table>

<table border="1" width="100%">
		<tr class="floating header" style="visibility:hidden">
			<td class="infoCenterLabel" width="15%">Obstetricians</td>
			<td class="infoCenterLabel" width="05%">Code</td>
	<%	if (showReference) { %>
			<td class="warning" width="05%">2006</td>
			<td class="warning" width="05%">2010</td>
	<%	} %>
			<!--  <td class="warning" width="05%"><%=prevSearchYear %></td>-->
			<td class="infoCenterLabel monthDetail" width="05%" id="1" style="cursor:pointer;">Jan</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="2" style="cursor:pointer;">Feb</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="3" style="cursor:pointer;">Mar</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="4" style="cursor:pointer;">Apr</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="5" style="cursor:pointer;">May</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="6" style="cursor:pointer;">Jun</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="7" style="cursor:pointer;">Jul</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="8" style="cursor:pointer;">Aug</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="9" style="cursor:pointer;">Sep</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="10" style="cursor:pointer;">Oct</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="11" style="cursor:pointer;">Nov</td>
			<td class="infoCenterLabel monthDetail" width="05%" id="12" style="cursor:pointer;">Dec</td>
			<td class="warning" width="05%" id="resultYear"><%=searchYear %></td>
		</tr>
<%
ReportableListObject row = null;
ArrayList record = UtilDBWeb.getFunctionResults("HAT_CMB_DOCTOR", new String[] { "" });
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		%><%=parseTable(
				totalDoc.get(row.getValue(0)),
				totalDocMainland.get(row.getValue(0)),
				totalPaidDoc.get(row.getValue(0)),
				totalPaidDocMainland.get(row.getValue(0)),
				totalCancel.get(row.getValue(0)),
				totalCancelMainland.get(row.getValue(0)),
				dataSearchPrevYear.get(row.getValue(0)),
				row.getValue(0), row.getValue(1), row.getValue(2), data2006, data2010,
				dataTotal, showReference) %><%
	}
}
%>
<%=parseTableTotal(dataTotal, showReference) %>
</table>

<br/>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Legend for total</td>
		<td class="infoData" width="70%">
			<table>
				<tr><td><span class="labelColor1">Total Sum of mainland patient (Include NEP1 & NEP1.5)</span>
<%	if (showReference) { %>
						<span class="labelColor4">/Total Sum of cancel patient</span>
<%	} %>
				</td></tr>
				<tr><td align="center" colspan="3"><span class="labelColor2">Total Sum of patient</span></td></tr>
			</table>
		</td>
	</tr>
</table>
<br/><p/><br/>
</DIV>

</DIV></DIV>

<script language="javascript">
	//var scrollBody = new ScrollTableHeader();
	$(document).ready(function() {
		$('#obBookingDetail').dialog({
			autoOpen: false,
			modal: false,
			draggable: false,
			resizable:false,
			title: "Detail",
			width: "100%",
			height: "80%",
			buttons: {
				"Close": function() {
					$(this).dialog("close");
				}
			},
			open: function(event, ui) {
			}
		});

		$('div#floating-header').css('top',
				$('.search').position().top+$('.search').height())
				.css('left', 0);

		$(window).scroll(function() {
			if($(window).scrollTop() > $('.search').position().top+$('.search').height()) {
				$('div#floating-header').css('top', $(window).scrollTop());
				$('#obBookingDetail').css('top', 120);
			}
			else {

				$('div#floating-header').css('top', $('.search').position().top+$('.search').height());
			}
		});

		$('.monthDetail').click(function() {
			$('#obBookingDetail').dialog('close');
			var syf = $('#resultYear').html();
			var syt = (parseInt($(this).attr('id'))>11)?(parseInt($('#resultYear').html()) + 1):syf;
			var smf = ((parseInt($(this).attr('id'))<10))?("0"+parseInt($(this).attr('id'))):($(this).attr('id'));
			var smt = ((parseInt($(this).attr('id'))+1)<10)?
						("0"+(parseInt($(this).attr('id'))+1)):
						(((parseInt($(this).attr('id'))+1)>12)?"01":(parseInt($(this).attr('id'))+1));

			getObDetailByDate(syf, syt, smf, smt);

			$('#obBookingDetail').css('top', 0);

			$('#obBookingDetail').dialog('open');
		});
	});

	function getObDetailByDate(syf, syt, smf, smt) {
		$('#obBookingDetail').html('Loading....');
		$.ajax({
			type: "GET",
			url: "../ui/obBookingDetail.jsp",
			data: "syf=" + syf +'&syt=' + syt + '&smf=' + smf + '&smt=' + smt,
			success: function(values){
				$('#obBookingDetail').html(values);
				$('div.dataSummary').unbind('click');
				$('div.dataSummary').click(function() {
					$(this).next().toggle();
				});
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
			}
		});//$.ajax
	}


	function submitSearch() {
		document.forms["search_form"].submit();
		return true;
	}

	function clearSearch() {
		document.forms["search_form"].elements["searchYear_yy"].value = "<%=currentYear %>";
	}

</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>