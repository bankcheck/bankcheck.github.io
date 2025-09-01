<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.ArrayList.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%
String batchID = ParserUtil.getParameter(request, "batchID");
UserBean userBean = new UserBean(request);
String noOfRev = null;
String gender = null;
String type = null;
String ageGp = null;
String regYr = null;
String hyperlipidemia = null;
String hyperglycaemia = null;
String physicalExam = null;
String mailRev = null;
String smsMsg = null;

StringBuffer sqlStr = new StringBuffer();

ArrayList result = null;
result = SMSDB.getBatch(batchID);
if (result.size() > 0){
	ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
	noOfRev = reportableListObject.getValue(1);
	gender = reportableListObject.getValue(2);
	type = reportableListObject.getValue(3);
	ageGp = reportableListObject.getValue(4);
	regYr = reportableListObject.getValue(5);
	hyperlipidemia = reportableListObject.getValue(6);
	hyperglycaemia = reportableListObject.getValue(7);
	physicalExam = reportableListObject.getValue(17);
	mailRev = reportableListObject.getValue(13);
	smsMsg = reportableListObject.getValue(16);
	if (smsMsg == null || smsMsg.isEmpty()){
		smsMsg = "";
	}else{
		smsMsg = smsMsg.replace("&#13;", "<br/>");
	}
}

ArrayList record = null;
sqlStr.append("SELECT S.PATNO, DECODE(P.PATSEX, 'M', 'Mr.', 'F', 'Ms.', 'Mr./Ms.') PATTIT, ");
sqlStr.append("CONCAT(P.PATFNAME, (' '||P.PATGNAME)) PATNAME, ");
sqlStr.append("P.PATADD1, P.PATADD2, P.PATADD3, ");
sqlStr.append("P.PATPAGER, P.PATEMAIL, S.METHOD ");
sqlStr.append("FROM SMS_BATCH_LIST S, PATIENT@IWEB P ");
sqlStr.append("WHERE S.PATNO = P.PATNO ");
sqlStr.append("AND S.BATCH_ID = '");
sqlStr.append(batchID);
sqlStr.append("' ");
sqlStr.append("AND S.METHOD = 'M' ");
sqlStr.append("ORDER BY P.PATADD1, P.PATADD2, P.PATADD3 ");
//System.out.println("DEBUG: sql = " + sqlStr.toString());
record = UtilDBWeb.getReportableList(sqlStr.toString());
//jasper report

if (record.size() > 0) {
	
	SMSDB.exportMail(batchID, userBean);
	
	File reportFile = new File(application.getRealPath("/report/mailPromotion.jasper"));
	File reportDir = new File(application.getRealPath("/report/"));
	
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map parameters = new HashMap();
		parameters.put("batchID", batchID);
		parameters.put("noOfRev", noOfRev);
		parameters.put("gender", gender);
		parameters.put("type", type);
		parameters.put("ageGp", ageGp);
		parameters.put("regYr", regYr);
		parameters.put("hyperlipidemia", hyperlipidemia);
		parameters.put("hyperglycaemia", hyperglycaemia);
		parameters.put("physicalExam", physicalExam);
		parameters.put("mailRev", mailRev);
		parameters.put("smsMsg", smsMsg);
		parameters.put(JRParameter.IS_IGNORE_PAGINATION, Boolean.TRUE);


		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportListDataSource(record) {
					public Object getFieldValue(int index) throws JRException {
						String value = (String) super.getFieldValue(index);

						return value;
					}
				});

		String encodedFileName = "MailingList-" + batchID + ".xls";
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setHeader("Content-disposition","inline; filename=\"" + encodedFileName + "\""); 
		response.setContentType("application/vnd.ms-excel");
		JRXlsExporter exporter = new JRXlsExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

        exporter.exportReport();
        ouputStream.flush();
        ouputStream.close();
		return;
		
	}
}

%>
