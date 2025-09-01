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

String url = null;
String logo = null;
String VIPRoom = null;
String privateRoom = null;
String semiPrivateRoom = null;
String standardRoom = null;
if (ConstantsServerSide.isTWAH()) {
	url = "http://www.twah.org.hk";
	logo = "twah_portal_logo.gif";
	VIPRoom = "4,000";
	privateRoom = "2,000-2,500";
	semiPrivateRoom = "1,100-1,300";
	standardRoom = "800-1,100";
} else {
	url = "http://www.hkah.org.hk";
	logo = "hkah_portal_logo.gif";
	VIPRoom = "3,800-8,400";
	privateRoom = "2,300-3,300";
	semiPrivateRoom = "2,000-2,200";
	standardRoom = "750-900";
}

File reportFile = new File(application.getRealPath("/report/finEstFrm.jasper"));
File reportDir = new File(application.getRealPath("/report/"));
if (reportFile.exists()) {
	JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

	Map parameters = new HashMap();
	parameters.put("BaseDir", reportFile.getParentFile());
	parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
	parameters.put("Site", ConstantsServerSide.SITE_CODE);
	parameters.put("patno", "");
	parameters.put("patcname", "");
	parameters.put("patname", "");
	parameters.put("patidno", "");
	parameters.put("DiagnosisText", "");
	parameters.put("day", "     ");
	parameters.put("acmdesc", "");
	parameters.put("operation", "");
	parameters.put("docname", "");
	parameters.put("docRdFee", "");
	parameters.put("proFee", "");
	parameters.put("annaesFee", "");
	parameters.put("otherFee1", "");
	parameters.put("otherFee2", "");
	parameters.put("total", "");
	parameters.put("currentDate", "___/___/_____");
	parameters.put("drRndDaySum", "");
	parameters.put("otCharge", "");
	parameters.put("otherFee3", "");
	parameters.put("drRndDaySum", "");
	parameters.put("remark1", "");
	parameters.put("remark2", "");
	parameters.put("remark3", "");
	parameters.put("staffID", "");
	parameters.put("hospitalTotal", "");
	parameters.put("url", url);
	parameters.put("logo", logo);
	parameters.put("VIPRoom", VIPRoom);
	parameters.put("privateRoom", privateRoom);
	parameters.put("semiPrivateRoom", semiPrivateRoom);
	parameters.put("standardRoom", standardRoom);

	JasperPrint jasperPrint =
		JasperFillManager.fillReport(
			jasperReport, parameters);

	String encodedFileName = "FinancialEstimation_blank.pdf";
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