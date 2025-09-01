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
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");
String admDate = request.getParameter("admDate");
String curent_date = DateTimeUtil.getCurrentDate();
if ("today".equals(admDate)) {
	date_from = curent_date;
	date_to = curent_date;
}
String command = ParserUtil.getParameter(request, "command");
String ward = request.getParameter("ward");
String doctorCode = request.getParameter("doctorCode");
String site = request.getParameter("site");
if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital- Stubbs Road";
}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}

ArrayList record = OsbDB.getServUsageReport(date_from, date_to, ward, doctorCode);
request.setAttribute("serv_usage_list", record);

if (record.size() > 0 && "export".equals(command) ) {
	File reportFile = new File(application.getRealPath("/report/RPT_OSB_SERVUSAGE.jasper"));
	String dateStr = null;
	if (date_from != null && date_from.equals(date_to)) {
		dateStr = date_from;
	} else {
		dateStr = date_from + " to " + date_to;
	}
	String wardName = request.getParameter("wardName");
	if (ward == null || ward.isEmpty()) {
		wardName = "ALL";
	}
	String doctorName = request.getParameter("doctorName");
	if (doctorCode == null || doctorCode.isEmpty()) {
		doctorName = "ALL";
	}
	
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		
		Map parameters = new HashMap();
		parameters.put("T_DATE", dateStr);
		parameters.put("T_WARD", wardName);
		parameters.put("T_DOCTOR", doctorName);
		parameters.put("DATE_FROM", date_from);
		parameters.put("DATE_TO", date_to);
		parameters.put("WRDCODE", ward);
		parameters.put("DOCCODE", doctorCode);

		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
					jasperReport,
					parameters,
					HKAHInitServlet.getDataSourceIntranet().getConnection());

		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setHeader("Content-Disposition", "attachment;filename=ServiceUsageReport_" + tsFormat.format(new Date()) + ".csv");
		response.setContentType("text/csv");
		JRCsvExporter exporter = new JRCsvExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
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
.total-row { font-weight: bold; }
</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.osb.serv_usage.list" />
</jsp:include>
<form name="search_form" action="serv_usage_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Selection for Service Usage Report</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Admission from :</td>
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
		<td class="infoLabel" width="30%">Ordering Dr :</td>
		<td class="infoData" width="70%">
			<select name="doctorCode">
				<option value="">--- ALL ---</option>
<jsp:include page="../ui/docCodeCMB.jsp" flush="false">
	<jsp:param name="selectFrom" value="osb" />
	<jsp:param name="doccode" value="<%=doctorCode %>" />
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
<input type="hidden" name="wardName" />
<input type="hidden" name="docName" />
</form>
<bean:define id="functionLabel">Service Usage</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.serv_usage_list" export="false" pagesize="-1" class="generaltable">
	<display:column property="fields0" title="Ward / Unit" style="width:15%" />
	<display:column property="fields1" title="Doctor" style="width:20%" />
	<display:column property="fields2" title="" style="width:5%; text-align: center;" />
	<display:column property="fields3" title="" style="width:5%; text-align: center;" />
	<display:column property="fields4" title="" style="width:5%; text-align: center;" />
	<display:column property="fields5" title="" style="width:5%; text-align: center;" />
	<display:column property="fields6" title="" style="width:5%; text-align: center;" />
	<display:column property="fields7" title="" style="width:5%; text-align: center;" />
	<display:column property="fields8" title="" style="width:5%; text-align: center;" />
	<display:column property="fields9" title="" style="width:5%; text-align: center;" />
	<display:column property="fields10" title="Total # of booking" style="width:15%; text-align: center;" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<script language="javascript">
	$(document).ready(function() {
		$("#row thead tr").before('<tr><th class="header"></th><th class="header"></th><th class="header" colspan="2"># of Success Booking</th><th class="header" colspan="2"># of No Show</th><th class="header" colspan="2"># of Cancellation</th><th class="header" colspan="2"># of Fail to book</th><th class="header"></th></tr>');
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
		document.search_form.doctorCode.value = "";
		submitSearch();
	}

	function submitAction(cmd, eid) {
		if (cmd == 'export') {
			document.search_form.command.value = 'export';
			$("input[name=wardName]").val($('select[name=ward]>option:selected').text());
			$("input[name=docName]").val($('select[name=doctorCode]>option:selected').text());
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