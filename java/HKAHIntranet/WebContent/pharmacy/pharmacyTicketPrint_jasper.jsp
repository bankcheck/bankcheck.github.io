<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*" %><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%@
page import="net.sf.jasperreports.engine.*" %><%@
page import="net.sf.jasperreports.engine.util.*" %><%@
page import="java.io.*" %><%
String locid = request.getParameter("locid");
String patNo = request.getParameter("patNo");
String ticketNo = request.getParameter("ticketNo");
String pickupTime = request.getParameter("pickupTime");

JasperPrint jasperPrint = null;
String reportPath = null;
String filePath = null;
String reportName = null;

if (ticketNo != null) {
	Map parameters = new HashMap();
	parameters.put("locid", locid);
	parameters.put("patno", patNo);
	parameters.put("ticketNum", ticketNo);
	parameters.put("barcodeNum", ticketNo);
	parameters.put("pickupTime", pickupTime);

	try {
		if (locid == null || locid.length() == 0 || "OW".equals(locid) || "NW".equals(locid)) {
			reportPath = "report/pharmacyTicketOP.jasper";
		} else if (ticketNo.length() >=4) {
			parameters.put("ticketNum", locid + "-" + ticketNo.substring(4));
			reportPath = "report/pharmacyTicketIP.jasper";
		}

		// file.jasper path
		filePath = getServletConfig().getServletContext().getRealPath(reportPath);
		InputStream inputStream = new FileInputStream(filePath);
		jasperPrint = JasperFillManager.fillReport(inputStream, parameters);
	} catch (Exception e) {
		jasperPrint = null;
	}

	if (jasperPrint != null) {
		long sysTime = System.currentTimeMillis();
		reportName = jasperPrint.getName() + sysTime;
		jasperPrint.setName(reportName);

		String exportReportName = filePath.substring(0, filePath.length() - 7) + sysTime + ".pdf";
		JasperExportManager.exportReportToPdfFile(jasperPrint, exportReportName);
	}
}
%><%=reportName %>