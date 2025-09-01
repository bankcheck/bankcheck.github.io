<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="net.sf.jasperreports.engine.JasperPrint" %>


<%!
	private ArrayList<ReportableListObject> getOBlocation(){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT LISTAGG(BEDCODE,',')WITHIN GROUP (ORDER BY BEDCODE) ");
		sqlStr.append("FROM BED ");
		sqlStr.append("WHERE BEDOFF = '-1' ");
		sqlStr.append("AND BEDCODE LIKE '6%' ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}
%><%
ArrayList obBedcode = getOBlocation();
int numBed = obBedcode.size();

File reportFile = new File(application.getRealPath("/report/obBedLabel.jasper"));
File reportDir = new File(application.getRealPath("/report/"));

if (reportFile.exists()) {
	JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	
	Map parameters = new HashMap();
	parameters.put("BaseDir", reportFile.getParent());

	
	for(int i=0;i<obBedcode.size(); i++){
		parameters.put("obBedcode"+i , obBedcode.get(i).toString());
	}
	
	JasperPrint jasperPrint =
		JasperFillManager.fillReport(
			jasperReport, parameters, new JREmptyDataSource(1));
	


	String encodedFileName = "obBedLabel.pdf";
	request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
	OutputStream ouputStream = response.getOutputStream();
	response.setContentType("application/pdf");
	response.setHeader("Content-disposition", "inline; filename=\"" + encodedFileName + "\"");
	JRPdfExporter exporter = new JRPdfExporter();
	exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

	exporter.exportReport();
	return;
}
%>