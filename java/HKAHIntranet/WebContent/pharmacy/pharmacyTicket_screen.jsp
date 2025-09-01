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
UserBean userBean = new UserBean(request);

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

	// display in html
	JRHtmlExporter exporter = new JRHtmlExporter();
	request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
	exporter.setParameter(JRHtmlExporterParameter.OUTPUT_WRITER, out);
	exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	exporter.setParameter(JRHtmlExporterParameter.IS_USING_IMAGES_TO_ALIGN ,Boolean.FALSE);
	exporter.setParameter(JRHtmlExporterParameter.IGNORE_PAGE_MARGINS ,Boolean.TRUE);
	exporter.setParameter(JRHtmlExporterParameter.IS_WHITE_PAGE_BACKGROUND,Boolean.FALSE);
	exporter.setParameter(JRHtmlExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS,Boolean.TRUE);
	exporter.setParameter(JRHtmlExporterParameter.IS_OUTPUT_IMAGES_TO_DIR, Boolean.TRUE);
	exporter.setParameter(JRHtmlExporterParameter.BETWEEN_PAGES_HTML,"");
	exporter.setParameter(JRExporterParameter.OUTPUT_WRITER, response.getWriter());
	float f1=1.2f;
	exporter.setParameter(JRHtmlExporterParameter.ZOOM_RATIO ,f1);
	exporter.exportReport();
}
%>