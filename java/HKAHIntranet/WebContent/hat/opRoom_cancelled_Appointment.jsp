<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.ArrayList.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%
UserBean userBean = new UserBean(request);

String[] current_year = DateTimeUtil.getCurrentYearRange();
String date_from = request.getParameter("date_from");

String date_to = request.getParameter("date_to");


String[] current_month = DateTimeUtil.getCurrentMonthRange();
String curent_date = DateTimeUtil.getCurrentDate();
String site = request.getParameter("site");
StringBuffer sqlStr = new StringBuffer();

if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital- Stubbs Road";
}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}


ArrayList record = null;
if (date_from != null && date_to != null) {
sqlStr.append("SELECT TO_CHAR(OT.OTAOSDATE,'dd/MM/YYYY'), OT.PATNO, ");
sqlStr.append("       OT.OTAFNAME || ' ' || OT.OTAGNAME, ");
sqlStr.append("       DR.DOCFNAME || ' ' || DR.DOCGNAME, ");
sqlStr.append("       (SELECT OTCDESC from OT_CODE@IWEB WHERE OTCID = OT.CANCELISADM and  OTCTYPE = 'AD'), ");
sqlStr.append("       (SELECT OTCDESC from OT_CODE@IWEB WHERE OTCID = OT.CANCELBY and  OTCTYPE = 'CA'), ");
sqlStr.append("decode(");
sqlStr.append("(select stecode from site@iweb),'HKAH',");
sqlStr.append("decode(OT.CANCELRSNCDE,'01','Medical Reason','02','Cancelled by Doctor','03','Other',''),");
sqlStr.append("(SELECT OTCDESC from OT_CODE@IWEB WHERE OTCID = OT.CANCELRSNCDE2 and  OTCTYPE = 'RA')),");
sqlStr.append("OT.OTACNCLRMK ");
sqlStr.append("FROM OT_APP@IWEB OT ");
sqlStr.append("LEFT JOIN ");
sqlStr.append("DOCTOR@IWEB DR ON OT.DOCCODE_S = DR.DOCCODE ");
sqlStr.append("OR ");
sqlStr.append("OT.DOCCODE_E = DR.DOCCODE ");
sqlStr.append("WHERE OT.OTASTS = 'C' ");
if (date_from != null && date_from.length() > 0) {
	sqlStr.append("AND OT.OTAOSDATE >= TO_DATE('");
	sqlStr.append(date_from);
	sqlStr.append(" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') ");
}
else {
	date_from = "";
}
if (date_to != null && date_to.length() > 0) {
	sqlStr.append("AND OT.OTAOSDATE <= TO_DATE('");
	sqlStr.append(date_to);
	sqlStr.append(" 23:59:59', 'dd/MM/YYYY HH24:MI:SS') ");
}
else {
	date_to = "";
}
sqlStr.append("ORDER BY OT.OTAOSDATE, OT.PATNO");



record = UtilDBWeb.getReportableList(sqlStr.toString());
//jasper report

if (record.size() > 0) {
	File reportFile = new File(application.getRealPath("/report/cancelledAppointment_report.jasper"));
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("DateFrom", date_from);
		parameters.put("DateTo", date_to);
		parameters.put("Site", site);
		parameters.put("siteFrom",userBean.getSiteCode());


		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportListDataSource(record) {
					public Object getFieldValue(int index) throws JRException {
						String value = (String) super.getFieldValue(index);
						return value;
					}
				});


		//request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		JRPdfExporter exporter = new JRPdfExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
        //exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

        exporter.exportReport();
        ouputStream.flush();
        ouputStream.close();
		return;
	}
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
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%String PageTitle = "Cancelled Appointment Report"; %>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.ot.cancelled.appointment.report" />
	<jsp:param name="category" value="Report" />
</jsp:include>

<form name="search_form" action="opRoom_cancelled_Appointment.jsp" method="post" target="_blank">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="bigText">
		<td width="30%"></td>
		<td  width="70%" align="center"><%=site %></td>
	</tr>
	<tr class="bigText">
		<td  width="30%"></td>
		<td  width="70%" align="center">OT Cancelled Appointment Report</td>

	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="70%">
			From <input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=date_from==null?"":date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
			-
			To <input type="textfield" name="date_to" id="date_to" class="datepickerfield" value="<%=date_to==null?"":date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)<br>

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

<script language="javascript">
<!--//
	function submitSearch() {
		document.search_form.submit();
		return false;
	}

	function clearSearch() {
		document.search_form.date_to.value = "";
		document.search_form.date_from.value = "";
	}
//-->
</script>


</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>