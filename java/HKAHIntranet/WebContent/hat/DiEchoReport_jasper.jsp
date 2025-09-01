<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page language="java" import="org.json.JSONObject" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.Object"%>
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
<%@ page import="net.sf.jasperreports.engine.JasperPrint" %>
<%@ page import="java.io.*"%>
<%!
private static ArrayList getReportContent(String xrpid) {
	return UtilDBWeb.getFunctionResults("NHS_RPT_DIECHOREPORT", new String[] {xrpid});
}
%>

<%
String xrgid = request.getParameter("xrgid");
String xrpid = request.getParameter("xrpid");

ArrayList record = new ArrayList();
record = getReportContent(xrpid);
if(record.size() > 0){
	File reportFile = new File(application.getRealPath("/report/DIEchoReport.jasper"));
	File reportDir = new File(application.getRealPath("/report/"));
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
		Map parameters = new HashMap();
	
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("Site", ConstantsServerSide.SITE_CODE_TWAH);
		
		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport, 
				parameters,
				new ReportListDataSource(
						UtilDBWeb.getFunctionResults("NHS_RPT_DIECHOREPORT", new String[] {xrpid})));
		
		String encodedFileName = "DiEchoReport" + "_" + xrgid + ".pdf";
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		response.setHeader("Content-disposition","inline; filename=\"" + encodedFileName + "\"");
		JRPdfExporter exporter = new JRPdfExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
		//exporter.setParameter(JRPdfExporterParameter.PDF_JAVASCRIPT, "this.print();");
		exporter.exportReport();
		return;
	}
}
%>
