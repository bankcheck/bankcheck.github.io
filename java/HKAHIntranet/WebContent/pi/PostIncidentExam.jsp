<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.jasper.*"%>


    
<%
	UserBean userBean = new UserBean(request);

	ArrayList record = null; 
	ArrayList<String> emptyRecord = new ArrayList<String>();

	String pirID = request.getParameter("pirID");
//	String incidentType = request.getParameter("incidentType");
// print doctor slip
// jasper report
	File reportFile = new File(application.getRealPath("/report/pi_confirm_slip.jasper"));
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map parameters = new HashMap();
		
		//pirID = "120";
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select to_char(pir_incident_date, 'dd/mm/yyyy'), pir_incident_time, ");
		sqlStr.append("       decode(pir_incident_classification , ");
		sqlStr.append("       '1', 'Patient Fall', '2', 'Staff Fall', '3', 'Visitor Fall', '4', 'Patient Injury',");
		sqlStr.append("       '5', 'Staff Injury', '6', 'Visitor Injury', '7', 'Needle Stick (Staff Injury BBF)', ");
		sqlStr.append("		  '8', 'Medication', '9', 'Equipment', '10', 'Other', '11', 'Security') inc_class, pc.pi_value");
		sqlStr.append(" from pi_report p");
		sqlStr.append(" join pi_report_content pc on p.pirid = pc.pirid and pc.pi_option_id = '284' ");
		sqlStr.append(" where p.pirid = '" + pirID + "'");
		
		record = UtilDBWeb.getReportableList(sqlStr.toString());
		
		emptyRecord.add("No Record");
		
		if (record.size() > 0) {
		
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("siteFrom",userBean.getSiteCode());
			if ("hkah".equals(userBean.getSiteCode())) {
				parameters.put("Site","Hong Kong Adventist Hospital");	
			}
			else {
				parameters.put("Site","Tsuen Wan Adventist Hospital");
			}
	
			JasperPrint jasperPrint = 
				JasperFillManager.fillReport(
					jasperReport, 
					parameters, 
					new ReportListDataSource(record) 
				);
	
			
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
// end print doctor slip
%>    