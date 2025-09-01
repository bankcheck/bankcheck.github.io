<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.awt.print.*" %>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.print.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.db.*" %>
<%@ page import="com.hkah.web.common.*" %>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%
File reportFile = new File(application.getRealPath("/report/pharmacyTicket.jasper"));
File reportDir = new File(application.getRealPath("/report/"));
if (reportFile.exists()) {
	JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

	Map parameters = new HashMap();
	parameters.put("BaseDir", reportFile.getParentFile());
	parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
	parameters.put("Site", ConstantsServerSide.SITE_CODE);
	parameters.put("patno", "123456");
	parameters.put("ticketNum", "A0001");
	parameters.put("currentDateTime", "12:34:56");

	JasperPrint jasperPrint =
		JasperFillManager.fillReport(
			jasperReport, parameters);

	jasperPrint.setPageHeight(100);
	jasperPrint.setPageWidth(80);
	jasperPrint.setOrientation(jasperReport.getOrientationValue().LANDSCAPE);
	JasperPrintManager.printReport(jasperPrint, false);

/*
	PrinterJob job = PrinterJob.getPrinterJob();
	PrintService[] services = PrintServiceLookup.lookupPrintServices(null, null);
	for (int i = 0; i < services.length; i++) {
		out.println("service[" + i + "]:" + services[i].getName().toUpperCase());
		out.println("<br>");
	}

	out.println("defaultName.toUpperCase():" + PrintServiceLookup.lookupDefaultPrintService().getName());
	out.println("<br>");

	PrintService ps = PrintServiceLookup.lookupDefaultPrintService();

	JRPrintServiceExporter pse = new JRPrintServiceExporter();
	pse.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
//	pse.setParameter(JRPrintServiceExporterParameter.PRINT_REQUEST_ATTRIBUTE_SET, printRequestAttributeSet);
	pse.setParameter(JRPrintServiceExporterParameter.DISPLAY_PAGE_DIALOG, Boolean.FALSE);
	pse.setParameter(JRPrintServiceExporterParameter.PRINT_SERVICE, ps);
	pse.setParameter(JRPrintServiceExporterParameter.PRINT_SERVICE_ATTRIBUTE_SET, ps.getAttributes());
	pse.setParameter(JRPrintServiceExporterParameter.CHARACTER_ENCODING, "UTF-8");
	pse.exportReport();
*/
//	return;

	out.println("printed");
}
%>