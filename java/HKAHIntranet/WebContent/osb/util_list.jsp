<%@ page import="java.math.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.HKAHInitServlet"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.engine.export.ooxml.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
private String[] getAmountRate(ArrayList record) {
	String[] ret = new String[2];
	BigDecimal totalHrSum = new BigDecimal(2);
	BigDecimal avaHrSum = new BigDecimal(2);
	BigDecimal occHrSum = new BigDecimal(2);
	BigDecimal naHrSum = new BigDecimal(2);
	
	for (Object o : record) {
		ReportableListObject r = (ReportableListObject) o;
		String totalHr = r.getFields3();
		String avaHr = r.getFields4();
		String occHr = r.getFields5();
		String naHr = r.getFields7();
		
		try {
			totalHrSum = totalHrSum.add(new BigDecimal(totalHr));
		} catch (NumberFormatException nfe) {}
		try {
			avaHrSum = avaHrSum.add(new BigDecimal(avaHr));
		} catch (NumberFormatException nfe) {}
		try {
			occHrSum = occHrSum.add(new BigDecimal(occHr));
		} catch (NumberFormatException nfe) {}
		try {
			naHrSum = naHrSum.add(new BigDecimal(naHr));
		} catch (NumberFormatException nfe) {}
	}
	try {
		ret[0] = occHrSum.divide(avaHrSum, 1, RoundingMode.HALF_UP).multiply(new BigDecimal(100)).toPlainString() + "%";
	} catch (Exception e) {
		ret[0] = (new BigDecimal(0)).toPlainString() + "%";
	}
	
	try {
		ret[1] = naHrSum.divide(totalHrSum, 1, RoundingMode.HALF_UP).multiply(new BigDecimal(100)).toPlainString() + "%";
	} catch (Exception e) {
		ret[1] = (new BigDecimal(0)).toPlainString() + "%";
	}
	return ret;
}
%>
<%
UserBean userBean = new UserBean(request);

String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");
String sDate = request.getParameter("sDate");
String curent_date = DateTimeUtil.getCurrentDate();
if ("today".equals(sDate)) {
	date_from = curent_date;
	date_to = curent_date;
}
String command = ParserUtil.getParameter(request, "command");
String ward = request.getParameter("ward");
String site = request.getParameter("site");
if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital- Stubbs Road";
}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}

ArrayList record = OsbDB.getUtilReportByUnit(date_from, date_to, ward);
request.setAttribute("util_list", record);
String[] totals = getAmountRate(record);

if (record.size() > 0 && "export".equals(command) ) {
	File reportFile = new File(application.getRealPath("/report/RPT_OSB_UTIL.jasper"));
	String dateStr = null;
	if (date_from != null && date_from.equals(date_to)) {
		dateStr = date_from;
	} else {
		dateStr = date_from + " - " + date_to;
	}
	
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		
		Map parameters = new HashMap();
		parameters.put("T_DATE", dateStr);
		parameters.put("DATE_FROM", date_from);
		parameters.put("DATE_TO", date_to);
		parameters.put("WRDCODE", ward);
		parameters.put("Image", application.getRealPath("/images/rpt_logo_osb.jpg"));
		parameters.put(JRParameter.REPORT_LOCALE, Locale.ENGLISH); 

		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
					jasperReport,
					parameters,
					HKAHInitServlet.getDataSourceIntranet().getConnection());

		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setHeader("Content-Disposition", "attachment;filename=UtilizationReport_" + tsFormat.format(new Date()) + ".xls");
		response.setContentType("application/vnd.ms-excel");
		JRXlsExporter exporter = new JRXlsExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
        exporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, false);
        exporter.exportReport();
		return;
	}
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>
.total-row { text-align: center; font-weight: bold; }
</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.osb.util.list" />
</jsp:include>
<form name="search_form" action="util_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Selection for Utilization Report</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">From :</td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">To :</td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_to" id="date_to" class="datepickerfield" value="<%=date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Ward :</td>
		<td class="infoData" width="70%">
			<select name="ward">
<jsp:include page="../ui/wardCMB.jsp" flush="false">
	<jsp:param name="wrdCode" value="<%=ward %>" />
	<jsp:param name="allowAll" value="Y" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td align="left" width="30%">
			<button name="btn-export" onclick="return submitAction('export', '');">Export</button>
		</td>
		<td align="left" width="70%">
			<button onclick="return submitSearch();">Generate</button>
			<button onclick="return clearSearch();">Cancel</button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="dateStr" />
</form>
<bean:define id="functionLabel">Utilization Report By Unit</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.util_list" export="false" pagesize="-1" class="generaltable">
	<display:column property="fields0" title="Ward / Unit" style="width:10%" />
	<display:column property="fields1" title="Class" style="width:5%" />
	<display:column property="fields2" title="Bed No." style="width:12%; text-align: center;" />
	<display:column property="fields3" title="Total Hours" style="width:12%; text-align: center;" />
	<display:column property="fields4" title="Available Hours" style="width:12%; text-align: center;" />
	<display:column property="fields5" title="Occupied Hours" style="width:12%; text-align: center;" />
	<display:column property="fields6" title="Occupied %" style="width:12%; text-align: center;" />
	<display:column property="fields7" title="N/A Hours" style="width:12%; text-align: center;" />
	<display:column property="fields8" title="N/A %" style="width:12%; text-align: center;" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" style="margin-top: 20px;">
	<tr>
		<td>Total Hours</td>
		<td>(# of days in range) * 24hrs</td>
	</tr>
	<tr>
		<td>Available Hours</td>
		<td>Total Hours - Not Applicable (N/A) Hours in range</td>
	</tr>
	<tr>
		<td>Unavailable Hours</td>
		<td># of hours that the bed was out of service or suspended</td>
	</tr>
	<tr>
		<td>N/A %</td>
		<td>(N/A Hours / Total Hours) %</td>
	</tr>	
	<tr>
		<td>Occupied Hours</td>
		<td># of hours that the bed was occupied in range</td>
	</tr>
	<tr>
		<td>Occupied %</td>
		<td>(Occupied Hours / Available Hours) %</td>
	</tr>
</table>
<script language="javascript">
	$(document).ready(function() {
		$("#row tbody tr:last-child td").addClass("total-row");
		$("#row tbody tr:last-child td:nth-child(1)").html("Total");
		
		<% if (record.size() <= 1) { %>
		//$("button[name=btn-export]").attr("disabled", true);
		<% } %>
	});

	function submitSearch() {
		document.search_form.command.value = '';
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.date_from.value = "<%=curent_date %>";
		document.search_form.date_to.value = "<%=curent_date %>";
		document.search_form.ward.value = "";
		submitSearch();
	}

	function submitAction(cmd, eid) {
		if (cmd == 'export') {
			document.search_form.command.value = 'export';
			document.search_form.submit();
		}
		return false;
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>