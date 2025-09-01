<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*"%>
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
UserBean userBean = new UserBean(request);

File reportFile = new File(application.getRealPath("/report/pharmacyTicket.jasper"));
File reportDir = new File(application.getRealPath("/report/"));
if (reportFile.exists()) {
	JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

	Map parameters = new HashMap();
	parameters.put("patno", "123456");
	parameters.put("ticketNum", "B001");

	JasperPrint jasperPrint =
		JasperFillManager.fillReport(
			jasperReport, parameters);

	String encodedFileName = "pharmacyTicket.pdf";
	request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
	OutputStream ouputStream = response.getOutputStream();
	response.setContentType("application/pdf");
	response.setHeader("Content-disposition", "attachment; filename=\"" + encodedFileName + "\"");
	JRPdfExporter exporter = new JRPdfExporter();
	exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

	exporter.exportReport();
	return;
}
%>