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
		sqlStr.append("SELECT R.CO_REQ_NO, R.CO_STAFF_ID, R.CO_PATNO, R.CO_PATNAME, R.CO_PATCNAME, R.CO_PATSEX, R.CO_PATBDATE, R.CO_PATAGE, I.CO_ITMCODE ");
		sqlStr.append("FROM CO_PHE_REQ R ");
		sqlStr.append("JOIN (SELECT CO_REQ_NO, LISTAGG(CO_ITMCODE,';&nbsp;&nbsp; ') WITHIN GROUP (ORDER BY CO_ITMCODE) CO_ITMCODE ");
		sqlStr.append("			FROM CO_PHE_REQ_ITM ");
		sqlStr.append("			GROUP BY CO_REQ_NO) I ");
		sqlStr.append("ON R.CO_REQ_NO = I.CO_REQ_NO ");
		sqlStr.append("WHERE R.CO_REQ_NO = '"+reqNo+"' ");
		
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
	jasperName = "phe_all_label.jasper";

	String patno = null ;
	String patname = null ;
	String patcname = null ;
	String patsex = null ;
	String patbdate = null ;
	String patage = null ;
	
	String itmcode = null;
	String staffId = null;

	//if(list.size()>0){
		reportFile = new File(application.getRealPath("/report/" + jasperName));
		ReportListDataSource report = null;

		if (reportFile != null && reportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
			
			Map parameters = new HashMap();
			if (reqNo != null) {
				ArrayList record = fetchReqLabel( reqNo );
				if (record.size() > 0) {
					ReportableListObject row = null;
					row = (ReportableListObject) record.get(0);
					staffId = row.getValue(1);
					patno = row.getValue(2);
					patname = row.getValue(3);
					patcname = row.getValue(4);
					patsex = row.getValue(5);
					patbdate = row.getValue(6);
					patage = row.getValue(7);
					itmcode = row.getValue(8);

				}
			}
			
			parameters.put("patno", patno );
			parameters.put("patname", patname );
			parameters.put("patcname", patcname );
			parameters.put("patsex", patsex );
			parameters.put("patbdate", patbdate );
			parameters.put("patage", patage );

			parameters.put("reqno", reqNo);
			parameters.put("itmcode", itmcode );
			parameters.put("staffId", staffId);

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
