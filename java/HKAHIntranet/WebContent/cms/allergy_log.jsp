<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>

<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%
String systemLogin = ParserUtil.getParameter(request, "systemLogin");
String sourceSystem = ParserUtil.getParameter(request, "sourceSystem");
String login = ParserUtil.getParameter(request, "login");
String loginName = ParserUtil.getParameter(request, "loginName");
String action = ParserUtil.getParameter(request, "action");
String patno = ParserUtil.getParameter(request, "mrnPatientIdentity");
String engSurName = ParserUtil.getParameter(request, "engSurName");
String engGivenName = ParserUtil.getParameter(request, "engGivenName");
String sex = ParserUtil.getParameter(request, "sex");
String dob = ParserUtil.getParameter(request, "dob");
String age = ParserUtil.getParameter(request, "age");
String hkid = ParserUtil.getParameter(request, "hkid");
String logDesc = ParserUtil.getParameter(request, "logDesc");

Boolean success = AllergyDB.addLog(patno, action, logDesc, sourceSystem, login);

String lastAckUser = null;
String lastAckDateTime = null;
ArrayList result = null;

if("ACK".equals(action)){
	if(success){
		result = AllergyDB.getLog(action, patno);
		if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				lastAckUser = reportableListObject.getValue(5);
				lastAckDateTime = reportableListObject.getValue(4);
				
		} 
		%>
		Last acknowledged by:<span><%=lastAckUser %></span> 
		(Date:<span><%=lastAckDateTime %></span>)
		<%
	}else{
		%>
		<%=success %>
		<%	
	}
}

if ("PRINT".equals(action)) {
	String patName = engSurName + ", " + engGivenName ;
	//String connection = HKAHInitServlet.getDataSourceIntranet().getConnection();
	File reportFile = new File(application.getRealPath("/report/Allergy_Summary.jasper"));
	File reportDir = new File(application.getRealPath("/report/"));
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
		parameters.put("Site", ConstantsServerSide.SITE_CODE);
		parameters.put("hkid", hkid);
		parameters.put("patno", patno);
		parameters.put("patName", patName);
		parameters.put("age", age);
		parameters.put("dob", dob);
		parameters.put("sex", sex);
		parameters.put("loginName", loginName);
		
		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
			jasperReport, parameters, HKAHInitServlet.getDataSourceIntranet().getConnection());


		String encodedFileName = "StructuredAlert_" + patno  + ".pdf";
        
    	request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
    	File outputFile = new File(encodedFileName); 
    	JRPdfExporter exporter = new JRPdfExporter();
    	

    	OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		response.setHeader("Content-disposition", "inline; filename=\"" + encodedFileName + "\"");//<--inline=display in browser; attachment=save as attactment
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
	    exporter.setParameter(JRPdfExporterParameter.PDF_JAVASCRIPT, "this.print();");
	    exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		exporter.exportReport();
    	
    	
		return;
	}
}

%>

