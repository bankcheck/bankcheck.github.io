<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*" %><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%@
page import="net.sf.jasperreports.engine.*" %><%@
page import="net.sf.jasperreports.engine.util.*" %><%@
page import="java.io.*"%><%!
	private JasperPrint generateReportOP(Map parameters) {
		return generateReport(parameters, "report/pharmacyTicket.jasper");
	}

	private JasperPrint generateReportIP(Map parameters) {
		return generateReport(parameters, "report/pharmacyTicketIP.jasper");
	}

	private JasperPrint generateReport(Map parameters, String jasperReport) {
		JasperPrint jasperPrint = null;
		try {
			// file.jasper path
			String filePath = getServletConfig().getServletContext().getRealPath(jasperReport);
			InputStream inputStream = new FileInputStream(filePath);
			return JasperFillManager.fillReport(inputStream, parameters);
		} catch (Exception e) {
			return null;
		}
	}
%><%
String locid = request.getParameter("locid");
String patNo = request.getParameter("patNo");
String ticketNo = request.getParameter("ticketNo");
String pickupTime = request.getParameter("pickupTime");

if (ticketNo != null) {
	Map parameters = new HashMap();
	parameters.put("locid", locid);
	parameters.put("patno", patNo);
	parameters.put("ticketNum", ticketNo);
	parameters.put("barcodeNum", ticketNo);
	parameters.put("pickupTime", pickupTime);

	JasperPrint jasperPrint = null;
	if (locid == null || locid.length() == 0 || "OW".equals(locid) || "NW".equals(locid)) {
		jasperPrint = generateReportOP(parameters);
	} else {
		parameters.put("ticketNum", locid + "-" + ticketNo.substring(4));
		jasperPrint = generateReportIP(parameters);
	}
	if (jasperPrint != null) {
		response.setContentType("application/octet-stream;charset=UTF-8");
		ObjectOutputStream oos = new ObjectOutputStream(response.getOutputStream());
		oos.writeObject(jasperPrint);
		oos.flush();
		oos.close();
	}
	return;
}
%>