<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="net.sf.jasperreports.engine.JasperPrint" %>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.util.*" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>

<%!
	private String getFolderPath() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT Param1 ");
		sqlStr.append("FROM   Sysparam@IWEB ");
		sqlStr.append("WHERE  Parcde = 'DOCPICPATH'");

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject result = null;
		if (record.size() > 0) {
			result = (ReportableListObject) record.get(0);
			return result.getValue(0);
		}
		return null;
	}
		
	private ArrayList getDoctorCode(String deptCode) {
		ArrayList docCode = new ArrayList();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_CODE, CO_DOCCODE ");
		sqlStr.append("FROM   CO_DEPARTMENT_DOCTOR ");
		sqlStr.append("WHERE  CO_DEPARTMENT_CODE = '"+deptCode+"' ");
		sqlStr.append("AND 	  CO_ENABLED = 1 ");
		
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			for (int i=0; i<record.size(); i++){	
				ReportableListObject reportableListObject = (ReportableListObject) record.get(i);
				docCode.add(reportableListObject.getValue(1));
			}
			return docCode;
		}
		return null;
	}

	private String get(String doctorID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCFNAME, DOCGNAME, DOCCNAME ");
		sqlStr.append("FROM   DOCTOR@IWEB ");
		sqlStr.append("WHERE  DOCCODE = '");
		sqlStr.append(doctorID);
		sqlStr.append("' ");
		//System.out.println(sqlStr);
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject result = null;
		if (record.size() > 0) {
			result = (ReportableListObject) record.get(0);
			String cname = result.getValue(2);
			if (cname == ""){
				String name = "Dr. " + result.getValue(0);
				return name;
			}else{
				String drName = "";
				if("SIHOE".equals(result.getValue(0)) || "AU YEUNG".equals(result.getValue(0))){
					drName = cname.substring(0, 2) + "醫生";
				} else {
					drName = cname.substring(0, 1) + "醫生";
				}
				return drName;
			}
		}
		return "DocID <"+doctorID+"> not correct";
	}
%>
<%
String url = getFolderPath();
String dept = request.getParameter("dept");
String deptCode = request.getParameter("deptCode");
ArrayList drCode = getDoctorCode(deptCode);
ArrayList docChinName = new ArrayList();
for(int i=0; i<drCode.size(); i++){
	String doccode = drCode.get(i).toString();
	docChinName.add(get(doccode));
}
int numDoc = drCode.size();

File reportFile = new File(application.getRealPath("/report/docList.jasper"));
File reportDir = new File(application.getRealPath("/report/"));

if (reportFile.exists()) {
	JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	
	Map parameters = new HashMap();
	parameters.put("BaseDir", reportFile.getParent());
	parameters.put("dept", dept);
	parameters.put("url", url);
	parameters.put("numDoc", numDoc);

	for(int i=0;i<docChinName.size();i++){
		parameters.put("docChinName"+i , docChinName.get(i));
	}
	
	for(int i=0;i<drCode.size(); i++){
		parameters.put("drCode"+i , drCode.get(i).toString());
	}
	
	JasperPrint jasperPrint =
		JasperFillManager.fillReport(
			jasperReport, parameters, new JREmptyDataSource(1));
	


	String encodedFileName = deptCode + ".pdf";
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