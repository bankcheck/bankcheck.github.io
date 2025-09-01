<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%!
	private ArrayList<ReportableListObject> fetchReqLabel( String reqNo ) {
		// fetch fund
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT patno, patname, patcname, staff_id, dept, printdate ");
		sqlStr.append("FROM table( phe.req_letter( '" + reqNo + "') ) ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> getDeptDesc(String staffId){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM CO_DEPARTMENTS ");
		sqlStr.append("WHERE CO_DEPARTMENT_CODE = ");
		sqlStr.append("		(SELECT CO_DEPARTMENT_CODE ");
		sqlStr.append("		FROM CO_STAFFS ");
		sqlStr.append("		WHERE CO_STAFF_ID = '"+ staffId +"')");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
		
	}
%>
<%
//String staffID = request.getParameter("staffID");
String reqNo = request.getParameter("reqNo");
String site = request.getParameter("site");
String message = request.getParameter("message");
String errorMessage = "";
File reportFile = null;
String reportDateTitle = null;
SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMddHHmmss");

if (message == null) {
	message = "";
}

	ArrayList list = null;
	String jasperName = null;
	String[] fieldNames = null;
	String outFileName = null;
	//list = PatientDB.getInpAvgLOS(reportDate);
	jasperName = "phe_reply_letter.jasper";
	//fieldNames = new String[]{"WARD","TOT_NUM_DISCH","TOT_LOS","AVG_LOS"};
	//outFileName = "";

	String staffid = null ;
	String patname = null ;
	String patcname = null ;
	String dept = null;
	String printdate = null ;

	//if(list.size()>0){
		reportFile = new File(application.getRealPath("/report/" + jasperName));
		ReportListDataSource report = null;

		if (reportFile != null && reportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
			
			Map parameters = new HashMap();
			parameters.put("BaseDir", reportFile.getParentFile());
			//if (staffID != null) {
			if (reqNo != null) {
				//ArrayList record = fetchReqLabel( staffID );
				ArrayList record = fetchReqLabel( reqNo );
				if (record.size() > 0) {
					ReportableListObject row = null;
					row = (ReportableListObject) record.get(0);
					
					patname = row.getValue(1);
					patcname = row.getValue(2);
					staffid = row.getValue(3);
					//dept = row.getValue(4);
					printdate = row.getValue(5);
				}
				record = getDeptDesc(staffid);
				if (record.size() > 0){
					ReportableListObject row1 = null;
					row1 = (ReportableListObject) record.get(0);
					
					dept = row1.getValue(0);
				}
			}
			
			parameters.put("patname", patname );
			parameters.put("patcname", patcname );
			parameters.put("staffid", staffid );
			parameters.put("printdate", printdate );
			parameters.put("dept", dept);

			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport,
					parameters,
					new JREmptyDataSource() );

			/*
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/vnd.ms-excel");
			JRXlsExporter exporterXLS = new JRXlsExporter();
			response.setHeader("Content-Disposition", "attachment;filename=" + outFileName + "_" + tsFormat.format(new Date()) + ".xls");
			exporterXLS.setParameter(JRXlsExporterParameter.JASPER_PRINT, jasperPrint);
			exporterXLS.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, ouputStream);
			exporterXLS.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
			exporterXLS.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, false);
			exporterXLS.setParameter(JRXlsExporterParameter.IS_AUTO_DETECT_CELL_TYPE, true);
			exporterXLS.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, false);
			exporterXLS.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, true);
			
			exporterXLS.exportReport();
			*/
	
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			response.setContentType("application/pdf");
			OutputStream ouputStream = response.getOutputStream();

			JRPdfExporter exporter = new JRPdfExporter();
	        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	        //exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

	        exporter.exportReport();

			ouputStream.flush();
			ouputStream.close();
			
			// used to disable "java.lang.IllegalStateException: getOutputStream() has already been called for this response" error 
			out.clear();
			out = pageContext.pushBody();
			//
			return;			
		}	
	//} else {
	//	message = "No records found.";
	//}
%>
