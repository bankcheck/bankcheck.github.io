<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="net.sf.jasperreports.engine.JasperPrint" %>


<%!
private static ArrayList getBookingInfo(String bkgid) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT 	BKGID, INITCAP(BKGPNAME), TO_CHAR(BKGSDATE,'DD/MM/YYYY HH24:MI'), D.DOCCODE, INITCAP('DR. ' || D.DOCFNAME ||', '|| D.DOCGNAME), BKGPCNAME "); 
	sqlStr.append("FROM		BOOKING@IWEB B, DOCTOR@IWEB D, SCHEDULE@IWEB S, SLOT@IWEB T ");
	sqlStr.append("WHERE 	D.DOCCODE = S.DOCCODE ");
	sqlStr.append("AND 		S.SCHID = T.SCHID ");
	sqlStr.append("AND 		T.SLTID = B.SLTID ");
	sqlStr.append("AND 		BKGID = '" + bkgid + "' ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}
private static ArrayList getDept(String govDept) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT	ARCCODE, INITCAP(ARCNAME) "); 
	sqlStr.append("FROM		ARCODE@IWEB ");
	sqlStr.append("WHERE   	ARCCODE = '" + govDept + "' ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private static ArrayList getPosition(String govPosition) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT	GOVJOBCODE, INITCAP(GOVPOSITION), ARCCODE "); 
	sqlStr.append("FROM		GOVJOB@IWEB ");
	sqlStr.append("WHERE   	GOVJOBCODE = '" + govPosition + "' ");
	sqlStr.append("ORDER BY GOVPOSITION ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private static ArrayList getGovReg(String bkgid){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT	BKGID, GOVJOBCODE, GOVSEX, TO_CHAR(TESTDATE,'DD/MM/YYYY HH24:MI') "); 
	sqlStr.append("FROM		GOVREG@IWEB ");
	sqlStr.append("WHERE   	BKGID = '" + bkgid + "' ");
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private static ArrayList getItem(String govPosition, String sex) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT	G.ITMCODE, I.ITMNAME, G.GUIDELINE "); 
	sqlStr.append("FROM		GOVITEM@IWEB G, ITEM@IWEB I ");
	sqlStr.append("WHERE   	G.ITMCODE = I.ITMCODE ");
	sqlStr.append("AND 		G.GOVJOBCODE = '" + govPosition + "' ");
	sqlStr.append("AND 		G.GOVSEX LIKE '%" + sex + "%' ");
	sqlStr.append("AND I.ITMTYPE != 'D' ");
	sqlStr.append("ORDER BY G.ITMCODE ");

	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}


%>

<% 
String command = request.getParameter("command");
String step = request.getParameter("step");
String bkgid = request.getParameter("bkgid");
ArrayList record = new ArrayList();

boolean govbkgExist = false;

String name = "";
String cname = "";
String bookingDate = "";
String doccode = "";
String docName = "";

String govDept = "";
String govPosition = "";
String govPositionName = "";
String sex = "";
String catBbooking = "";

ArrayList deptlistCode = new ArrayList();
ArrayList deptlistName = new ArrayList();
ArrayList positionListCode = new ArrayList();
ArrayList positionListName = new ArrayList();

record = getBookingInfo(bkgid);
if(record.size() > 0){
	ReportableListObject row = (ReportableListObject) record.get(0);
	name = row.getValue(1);
	cname = row.getValue(5);
	bookingDate = row.getValue(2);
	doccode = row.getValue(3);
	docName = row.getValue(4);
}

record = getGovReg(bkgid);
if(record.size() > 0){
	ReportableListObject row = (ReportableListObject) record.get(0);
	govPosition = row.getValue(1);
	sex = row.getValue(2);
	catBbooking = row.getValue(3);
}
//get deptCode
record = getPosition(govPosition);
if(record.size() > 0){
	for(int i=0; i<record.size(); i++){
		ReportableListObject row = (ReportableListObject) record.get(i);
		govPositionName = row.getValue(1);
		govDept = row.getValue(2);
	}
}

record = getDept(govDept);
if(record.size() > 0){
		ReportableListObject row = (ReportableListObject) record.get(0);
		govDept = row.getValue(1);
}

record = getItem(govPosition, sex);
if(record.size() > 0){

File reportFile = new File(application.getRealPath("/report/GOV_ORDER_FORM.jasper"));
	File reportDir = new File(application.getRealPath("/report/"));
	
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("Site", ConstantsServerSide.SITE_CODE);
		parameters.put("name", name);
		parameters.put("cname", cname);
		parameters.put("sex", sex);
		parameters.put("govDept", govDept);
		parameters.put("govPosition", govPositionName);
		parameters.put("bookingDate", bookingDate);
		parameters.put("catBbooking", catBbooking);
		parameters.put("docName", docName);
		//parameters.put(JRParameter.IS_IGNORE_PAGINATION, Boolean.TRUE);
		
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
	
		String encodedFileName = "GovOrderForm-" + bkgid + ".pdf";
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		response.setHeader("Content-disposition", "inline; filename=\"" + encodedFileName + "\"");
		JRPdfExporter exporter = new JRPdfExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
		exporter.setParameter(JRPdfExporterParameter.PDF_JAVASCRIPT, "this.print();");

		exporter.exportReport();
		return;
	}
}
%>
