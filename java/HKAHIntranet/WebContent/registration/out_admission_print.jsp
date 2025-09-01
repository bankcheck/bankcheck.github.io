<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.google.zxing.*" %>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String admissionID = request.getParameter("admissionID");

if(command != null && command.equals("pdfAction")){	
	if (admissionID != null && admissionID.length() > 0) {
		ArrayList record = AdmissionDB.get(admissionID);	
		if (record.size() > 0  && "pdfAction".equals(command) ) {		
			File reportFile = new File(application.getRealPath("/report/ADMFRM2PAT.jasper"));
			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
				
				Map parameters = new HashMap();
				parameters.put("BaseDir", reportFile.getParentFile());
				ReportableListObject row = (ReportableListObject) record.get(0);	
				parameters.put("patNo", row.getValue(1));
				parameters.put("patSname", row.getValue(2));
				parameters.put("patDOB", row.getValue(15));
				parameters.put("patFname", row.getValue(3));
				  
				String patSex = row.getValue(10);
				if("M".equals(patSex)){
					patSex = "Male";
				}else if("F".equals(patSex)){
					patSex = "Female";
				}
				parameters.put("patSex", patSex);
				
				String patidno = row.getValue(7);
				String patidno1 = null;
				String patidno2 = null;
				if (patidno.length() > 7) {
					int tempIDLastNo = patidno.length() - 1;
					patidno1 = patidno.substring(0, tempIDLastNo);
					patidno2 = patidno.substring(tempIDLastNo);
				} else {
					patidno1 = patidno;
					patidno2 = "";
				}
				parameters.put("patIDNo", patidno1 + "(" + patidno2 + ")");
				parameters.put("patHPhone", row.getValue(20));		
				
				String patMStatus = row.getValue(16);
				if("S".equals(patMStatus)){
					patMStatus = "Single";
				}else if("M".equals(patMStatus)){
					patMStatus = "Married";
				}else if("D".equals(patMStatus)){
					patMStatus = "Divorce";
				}else if("X".equals(patMStatus)){
					patMStatus = "Separate";
				}				
				parameters.put("patMStatus", patMStatus + " " + row.getValue(88));
				parameters.put("patMPhone", row.getValue(22));				
				parameters.put("patEduLvl", row.getValue(19) + " " + row.getValue(89));
				parameters.put("patOPhone", row.getValue(21));
				parameters.put("patOccptn", row.getValue(24));
				parameters.put("patNation", row.getValue(11) + " " + row.getValue(12));
				
				String patLang = row.getValue(17);
				if("ENG".equals(patLang)){
					patLang = "English";
				}else if("TRC".equals(patLang)){
					patLang = "Traditional Chinese";
				}else if("SMC".equals(patLang)){
					patLang = "Simplified Chinese";
				}else if("JAP".equals(patLang)){
					patLang = "Japanese";
				}				
				parameters.put("patCorrLang", patLang);		
				
				String patReli = row.getValue(13);
				if("NO".equals(patReli)){
					patReli = "None";
				}else if("BU".equals(patReli)){
					patReli = "Buddhism";
				}else if("CA".equals(patReli)){
					patReli = "Catholic";
				}else if("CH".equals(patReli)){
					patReli = "Christian";
				}else if("HI".equals(patReli)){
					patReli = "Hinduism";
				}else if("SH".equals(patReli)){
					patReli = "Shintoism";
				}else if("SD".equals(patReli)){
					patReli = "SDA";
				}else if("Others".equals(patReli)){
					patReli = "Others";
				}			
				parameters.put("patReli", patReli + " " + row.getValue(14));
				
				parameters.put("patEmail", row.getValue(25));
				parameters.put("patAdd", row.getValue(26) + " " + row.getValue(27) + " " + row.getValue(28) + " " + row.getValue(29) + " " + row.getValue(31));
			
				parameters.put("NKName", row.getValue(33) + ", " + row.getValue(32));
				parameters.put("NKRetnshp", row.getValue(36));
				parameters.put("NKOPhone", row.getValue(38));
				parameters.put("NKMPhone", row.getValue(39));
				parameters.put("NKEmail", row.getValue(41));
				parameters.put("NKHPhone", row.getValue(37));
				parameters.put("NKAdd", row.getValue(42) + " " + row.getValue(43) + " " + row.getValue(44) + " " + row.getValue(45) + " " + row.getValue(85));
				
				parameters.put("patHowInfo", row.getValue(95));
				parameters.put("patHowInfoOther", row.getValue(96));				
				parameters.put("promotionYN", row.getValue(68));
				
				parameters.put("BaseDir", reportFile.getParentFile());
				
				JasperPrint jasperPrint =
					JasperFillManager.fillReport(
						jasperReport,
						parameters,
						new ReportListDataSource(record));
				
				request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
				OutputStream ouputStream = response.getOutputStream();
				response.setContentType("application/pdf");
				JRPdfExporter exporter = new JRPdfExporter();
		        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../../servlets/image?image=");

		        exporter.exportReport();
		        ouputStream.close();
			}
		}
	}
}
%>
