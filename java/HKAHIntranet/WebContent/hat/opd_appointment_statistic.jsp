<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getAppointment(JspWriter out, String searchYear, String searchMonth, boolean amount) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(st.stncdate, '");
		if (searchMonth != null && searchMonth.length() > 0) {
			sqlStr.append("DD");
		} else {
			sqlStr.append("MM");
		}
		sqlStr.append("'), sp.spccode, st.doccode, DECODE(st.itmcode, 'DFSC', 'RA', 'DFGC', 'RA', 'DFH', 'RA', 'UC'), ");
		if (amount) {
			sqlStr.append("sum(st.stnbamt) ");
		} else {
			sqlStr.append("count(1) ");
		}
		sqlStr.append("FROM   SlipTx@IWEB st, Slip@IWEB s, Doctor@IWEB d, Spec@IWEB sp ");
		sqlStr.append("WHERE  st.slpno = s.slpno ");
		sqlStr.append("AND    st.doccode = d.doccode ");
		sqlStr.append("AND    d.spccode = sp.spccode (+) ");
		if (amount) {
			sqlStr.append("AND    st.stnsts IN ('A', 'N') ");
		} else {
			sqlStr.append("AND    st.stnsts = 'N' ");
		}
		sqlStr.append("AND    st.itmcode IN ('DFE3', 'DFE2', 'DFE1', 'DFSC', 'DFGC', 'DFH') ");
		sqlStr.append("AND    s.slpsts != 'R' ");
		sqlStr.append("AND    s.slptype = 'O' ");
		if (searchMonth != null && searchMonth.length() > 0) {
			sqlStr.append("AND    st.stncdate >= TO_DATE('01/");
			sqlStr.append(searchMonth);
			sqlStr.append("/");
			sqlStr.append(searchYear);
			sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
			sqlStr.append("AND    st.stncdate < ADD_MONTHS(TO_DATE('01/");
			sqlStr.append(searchMonth);
			sqlStr.append("/");
			sqlStr.append(searchYear);
			sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS'), 1) ");
		} else {
			sqlStr.append("AND    st.stncdate >= TO_DATE('01/01/");
			sqlStr.append(searchYear);
			sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
			sqlStr.append("AND    st.stncdate <= TO_DATE('31/12/");
			sqlStr.append(searchYear);
			sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS') ");
		}
		sqlStr.append("AND    st.doccode in ('1494', '1838', '740', '1420', '2005', '1991', '1924', '845', '1256', '1499', '1168', '1586', '1159', '1811', '2017', '2263', '1879', '1327', '1556', '2074', '1945', '2140', '940', '1260', '2149', '2069', '1964') ");
		sqlStr.append("GROUP BY TO_CHAR(st.stncdate, '");
		if (searchMonth != null && searchMonth.length() > 0) {
			sqlStr.append("DD");
		} else {
			sqlStr.append("MM");
		}
		sqlStr.append("'), sp.spccode, st.doccode, DECODE(st.itmcode, 'DFSC', 'RA', 'DFGC', 'RA', 'DFH', 'RA', 'UC') ");
		sqlStr.append("ORDER BY TO_CHAR(st.stncdate, '");
		if (searchMonth != null && searchMonth.length() > 0) {
			sqlStr.append("DD");
		} else {
			sqlStr.append("MM");
		}
		sqlStr.append("'), sp.spccode, st.doccode, DECODE(st.itmcode, 'DFSC', 'RA', 'DFGC', 'RA', 'DFH', 'RA', 'UC') ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private HashMap<String, String> parseListObject2Map(ArrayList record) {
		HashMap<String, String> dataSearch = new HashMap<String, String>();
		ReportableListObject row = null;

		StringBuffer keyStr = new StringBuffer();

		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				keyStr.setLength(0);
				keyStr.append(row.getValue(0));
				keyStr.append(ConstantsVariable.MINUS_VALUE);
				keyStr.append(row.getValue(1));
				keyStr.append(ConstantsVariable.MINUS_VALUE);
				keyStr.append(row.getValue(2));
				keyStr.append(ConstantsVariable.MINUS_VALUE);
				keyStr.append(row.getValue(3));

				dataSearch.put(keyStr.toString(), row.getValue(4));
			}
		}

		return dataSearch;
	}

	private void parseTable(JspWriter out, String specCode, String specName, String[] doccode, String[] docname, ArrayList record, int interval, int leadGap) {
		int value = 0;
		int totalvalue = 0;

		StringBuffer strbuf = new StringBuffer();
		HashMap<String, String> dataSearch = parseListObject2Map(record);

		strbuf.append("<tr>");
		strbuf.append("<td rowspan='");
		strbuf.append(doccode.length * 2);
		strbuf.append("'>");
		strbuf.append(specName);
		strbuf.append("</td>");

		for (int j = 0; j < doccode.length; j++) {
			if (j > 0) {
				strbuf.append("<tr>");
			}
			strbuf.append("<td rowspan='2'>");
			strbuf.append(doccode[j]);
			strbuf.append("</td><td rowspan='2'>");
			strbuf.append(docname[j]);
			strbuf.append("</td><td>RA</td>");

			totalvalue = 0;
			for (int i = 1; i <= interval; i++) {
				strbuf.append("<td align=\"center\"");
				if (interval != 12 && (i + leadGap - 2) % 7 == 6) {
					strbuf.append(" bgcolor=\"#CCFFCC\"");
				}
				strbuf.append(">");

				value = getDisplayValue(dataSearch, i, specCode, doccode[j], "RA");
				if (value == 0) {
					strbuf.append("&nbsp");
				} else {
					strbuf.append(value);
				}
				totalvalue += value;

				strbuf.append("</td>");
			}

			strbuf.append("<td align=\"center\">");
			strbuf.append(totalvalue);
			strbuf.append("</td></tr><tr><td>UC/SA</td>");

			totalvalue = 0;
			for (int i = 1; i <= interval; i++) {
				strbuf.append("<td align=\"center\"");
				if (interval != 12 && (i + leadGap - 2) % 7 == 6) {
					strbuf.append(" bgcolor=\"#CCFFCC\"");
				}
				strbuf.append(">");

				value = getDisplayValue(dataSearch, i, specCode, doccode[j], "UC");
				if (value == 0) {
					strbuf.append("&nbsp");
				} else {
					strbuf.append(value);
				}
				totalvalue += value;

				strbuf.append("</td>");
			}

			strbuf.append("<td align=\"center\">");
			strbuf.append(totalvalue);
			strbuf.append("</td></tr>");
/*
			strbuf.append("<tr><td><font color=\"red\">Total</font></td>");

			totalvalue = 0;
			for (int i = 1; i <= interval; i++) {
				strbuf.append("<td align=\"center\"");
				if (interval != 12 && (i + leadGap - 2) % 7 == 6) {
					strbuf.append(" bgcolor=\"#CCFFCC\"");
				}
				strbuf.append("><font color=\"red\">");

				value = getDisplayValue(dataSearch, i, specCode, doccode[j], "RA");
				value += getDisplayValue(dataSearch, i, specCode, doccode[j], "UC");

				if (value == 0) {
					strbuf.append("&nbsp");
				} else {
					strbuf.append(value);
				}
				totalvalue += value;

				strbuf.append("</font></td>");
			}

			strbuf.append("<td align=\"center\">");
			strbuf.append(totalvalue);
			strbuf.append("</td></tr>");
*/
		}

		strbuf.append("</tr>");

		try {
			out.println(strbuf.toString());
		} catch (Exception e) {}
	}

	private int getDisplayValue(HashMap<String, String> dataSearch, int count, String specCode, String docCode, String itemCode) {
		StringBuffer keyStr = new StringBuffer();
		int value = 0;

		if (count < 10) {
			keyStr.append(ConstantsVariable.ZERO_VALUE);
		}
		keyStr.append(count);
		keyStr.append(ConstantsVariable.MINUS_VALUE);
		keyStr.append(specCode);
		keyStr.append(ConstantsVariable.MINUS_VALUE);
		keyStr.append(docCode);
		keyStr.append(ConstantsVariable.MINUS_VALUE);
		keyStr.append(itemCode);

		try {
			value += Integer.parseInt(dataSearch.get(keyStr.toString()));
		} catch (Exception e) {}

		return value;
	}
%>
<%
UserBean userBean = new UserBean(request);

String searchYear = request.getParameter("searchYear_yy");
int currentYear = DateTimeUtil.getCurrentYear();

String searchMonth = request.getParameter("searchYear_mm");
int currentMonth = DateTimeUtil.getCurrentMonth();
int searchMonthInt = -1;
if (searchMonth != null) {
	try {
		searchMonthInt = Integer.parseInt(searchMonth);
	} catch (Exception e) {}
} else {
	searchMonth = String.valueOf(currentMonth);
	searchMonthInt = currentMonth;
}

String statistic = request.getParameter("statistic");

ArrayList recordService = null;

if (searchYear != null) {
	recordService = getAppointment(out, searchYear, searchMonth, "a".equals(statistic));
}

HashMap<String, String> docspec = new HashMap<String, String>();

String[] monthAbb = new String [] {
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

String[] dayAbb = new String[] {
	MessageResources.getMessage(session, "label.sunday"),
	MessageResources.getMessage(session, "label.monday"),
	MessageResources.getMessage(session, "label.tuesday"),
	MessageResources.getMessage(session, "label.wednesday"),
	MessageResources.getMessage(session, "label.thursday"),
	MessageResources.getMessage(session, "label.friday"),
	MessageResources.getMessage(session, "label.saturday") };


int leadGap = 0;
if (searchYear != null && searchMonth != null) {
	Calendar calendar = Calendar.getInstance();
	calendar.set(Calendar.YEAR, Integer.parseInt(searchYear));
	calendar.set(Calendar.MONTH, searchMonthInt - 1);
	calendar.set(Calendar.DATE, 1);
	leadGap = calendar.get(Calendar.DAY_OF_WEEK);
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
	<jsp:param name="pageTitle" value="function.opd.appointment.statistic" />
	<jsp:param name="displayTitle" value="Outpatient Visit Review" />
	<jsp:param name="category" value="Report" />
</jsp:include>
<form name="search_form" action="opd_appointment_statistic.jsp" method="post">
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
		<td class="infoLabel" width="30%">Search Month</td>
		<td class="infoData" width="70%">
			<select name="searchYear_mm">
				<option value=""<%=searchMonthInt<1?" selected":""%>>All Month</option>
				<option value="01"<%=searchMonthInt==1?" selected":""%>><%=monthAbb[0] %></option>
				<option value="02"<%=searchMonthInt==2?" selected":""%>><%=monthAbb[1] %></option>
				<option value="03"<%=searchMonthInt==3?" selected":""%>><%=monthAbb[2] %></option>
				<option value="04"<%=searchMonthInt==4?" selected":""%>><%=monthAbb[3] %></option>
				<option value="05"<%=searchMonthInt==5?" selected":""%>><%=monthAbb[4] %></option>
				<option value="06"<%=searchMonthInt==6?" selected":""%>><%=monthAbb[5] %></option>
				<option value="07"<%=searchMonthInt==7?" selected":""%>><%=monthAbb[6] %></option>
				<option value="08"<%=searchMonthInt==8?" selected":""%>><%=monthAbb[7] %></option>
				<option value="09"<%=searchMonthInt==9?" selected":""%>><%=monthAbb[8] %></option>
				<option value="10"<%=searchMonthInt==10?" selected":""%>><%=monthAbb[9] %></option>
				<option value="11"<%=searchMonthInt==11?" selected":""%>><%=monthAbb[10] %></option>
				<option value="12"<%=searchMonthInt==12?" selected":""%>><%=monthAbb[11] %></option>
			</select>
		</td>
	</tr>
<!--
	<tr class="smallText">
		<td class="infoLabel" width="30%">Statistic</td>
		<td class="infoData" width="70%">
			<select name="statistic">
				<option value="c"<%="c".equals(statistic)?" selected":""%>>Count</option>
				<option value="a"<%="a".equals(statistic)?" selected":""%>>Amount</option>
			</select>
		</td>
	</tr>
-->
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<% if (recordService != null) { %>
<table border="1" width="100%">
	<tr>
		<td class="infoCenterLabel" width="10%" rowspan="2" valign="middle">Specialty</td>
		<td class="infoCenterLabel" width="5%" rowspan="2">Doctor<br>Code</td>
		<td class="infoCenterLabel" width="10%" rowspan="2" valign="middle">Doctor Name</td>
		<td class="infoCenterLabel" width="5%" rowspan="2" valign="middle">Service</td>
<%		if (searchMonthInt > 0) { %>
		<td class="warning" colspan="31"><%=monthAbb[searchMonthInt - 1] %> <%=searchYear%> / Total No. of Visits</td>
<%		} else { %>
		<td class="warning" colspan="12">Year <%=searchYear%> / Total No. of Visits</td>
<%		} %>
		<td class="infoCenterLabel" width="05%" rowspan="2" valign="middle">Total</td>
	</tr>
	<tr>
<%		if (searchMonthInt > 0) { %>
<%			for (int i = 1; i <= 31; i++) { %>
			<td class="infoCenterLabel" width="02%"><%=dayAbb[(i + leadGap - 2) % 7] %><br><%=i %></td>
<%			} %>
<%		} else { %>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[0] %></td>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[1] %></td>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[2] %></td>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[3] %></td>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[4] %></td>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[5] %></td>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[6] %></td>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[7] %></td>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[8] %></td>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[9] %></td>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[10] %></td>
		<td class="infoCenterLabel" width="05%"><%=monthAbb[11] %></td>
<%		} %>
	</tr>
<%
int interval = searchMonthInt > 0 ? 31 : 12;

parseTable(out, "GENSUR", "General Surgery", new String[] {"1494", "1838", "740", "1420", "2069"}, new String[] {"Kwan Tim Lok, Henry", "Yang Pei Cheung, George", "Lai Cheuck Seen, Edward", "Kwok Po Yin, Samuel", "Leung Siu Lan"}, recordService, interval, leadGap);
parseTable(out, "GENSUR", "Breast Surgery", new String[] {"2005"}, new String[] {"Wong Sung Man, Heidi"}, recordService, interval, leadGap);
parseTable(out, "INTMED", "Geriatric/Internal Medicine", new String[] {"1991"}, new String[] {"Chan Chun Chung"}, recordService, interval, leadGap);
parseTable(out, "NEPHRO", "Nephrology", new String[] {"1924", "845"}, new String[] {"Lam Man Fai", "Tam Kwok Kuen"}, recordService, interval, leadGap);
parseTable(out, "OBGYN", "Obstetrics & Gynaecology", new String[] {"1256", "1499", "1168", "1964"}, new String[] {"Ngai Suk Wai, Cora", "Pang Man Wah, Selina", "Chan Yik Ming, Joe", "Yeung Wing Yee, Tracy"}, recordService, interval, leadGap);
parseTable(out, "OPTHAL", "Ophthalmology", new String[] {"1586", "1159", "1811", "2017", "2263"}, new String[] {"Pong Chiu Fai, Jeffrey", "Tam Sau Man, Barbara", "Yu Kim Hun, Derek", "Tam Tak Yau", "Chung Chung Yee, Derek"}, recordService, interval, leadGap);
parseTable(out, "NEURSUR", "Neurosurgery", new String[] {"1879", "1327"}, new String[] {"Leung Kar Ming", "Leung Hin Shuen"}, recordService, interval, leadGap);
parseTable(out, "ORTHOTR", "Orthopaedics & Traumatology", new String[] {"1556", "2140", "940"}, new String[] {"Yeung Yeung", "Lam Hin Tseuk, Francis", "Sum Kai Hoi"}, recordService, interval, leadGap);
parseTable(out, "UROLOGY", "Urology", new String[] {"2074"}, new String[] {"Wong Ming Ho, Edmond"}, recordService, interval, leadGap);
parseTable(out, "GP", "General Practice", new String[] {"1945"}, new String[] {"Chung Pui Yi, Rebecca"}, recordService, interval, leadGap);
parseTable(out, "RESPMED", "Respiratory Medicine", new String[] {"1260"}, new String[] {"Tsang Wah Tak, Kenneth"}, recordService, interval, leadGap);
parseTable(out, "CARDIO", "Cardiology", new String[] {"2149"}, new String[] {"Ko Kwok Chun, Jason"}, recordService, interval, leadGap);
%>
</table>

<br><b><u>Remarks</u></b>
<br>RA:	Regular Appointment
<br>UC/SA:	Urgent Care/Special Appointment
<br>
<br>Record as of <%=DateTimeUtil.getCurrentDateTime() %>

<% } %>
</DIV>

</DIV></DIV>

<script language="javascript">
<!--
	function submitSearch() {
		showLoadingBox('body', 500, $(window).scrollTop());
		document.forms["search_form"].submit();
		return true;
	}

	function clearSearch() {
		document.forms["search_form"].elements["searchYear_yy"].value = "<%=currentYear %>";
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>