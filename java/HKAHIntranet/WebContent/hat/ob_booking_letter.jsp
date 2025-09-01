<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@
page import="net.sf.jasperreports.engine.*" %><%@
page import="net.sf.jasperreports.engine.util.*" %><%@
page import="net.sf.jasperreports.engine.export.*" %><%@
page import="net.sf.jasperreports.j2ee.servlets.*" %><%@
page import="java.io.*"%><%@
page import="java.text.SimpleDateFormat"%><%@
page import="java.util.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.web.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.servlet.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.jasper.*"%><%
UserBean userBean = new UserBean(request);
String pbpID = request.getParameter("pbpID");

if (pbpID != null && pbpID.length() > 0) {
	File reportFile = new File(application.getRealPath("/report/OBBooking.jasper"));
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map<String, String> map = new HashMap<String, String>();
		map.put("Image", "http://localhost:8080/intranet/images/rpt_logo2.jpg");

		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				map,
				new ReportMapDataSource(
						UtilDBWeb.getFunctionResults("NHS_RPT_OBBOOKING", new String[] { pbpID }),
						new String[]{"PATNAME","PATCNAME","BPBHDATE","BPBNO","DOCNAME","DOCFAXNO","DOCOTEL","PRINTDATE"}));

		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		JRPdfExporter exporter = new JRPdfExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

        exporter.exportReport();
		return;
	}
}
%>