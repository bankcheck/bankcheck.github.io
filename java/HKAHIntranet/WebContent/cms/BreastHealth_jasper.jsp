<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page language="java" import="org.json.JSONObject" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.Object"%>
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
<%@ page import="net.sf.jasperreports.engine.JasperPrint" %>
<%@ page import="java.io.*"%>

<%
String userid = request.getParameter("userid");
String patno = request.getParameter("patno");
String regid = request.getParameter("regid");
String formuid = request.getParameter("formuid");
String mode = request.getParameter("mode");

String patName = request.getParameter("patName");
String patAge = request.getParameter("patAge");
String patSex = request.getParameter("gender");
String patDob = request.getParameter("patDob");
String docName = request.getParameter("docName");

String formContent = request.getParameter("formContent");
String formDate = request.getParameter("formDate"); 
String formType = request.getParameter("formType");
String imgPath = request.getParameter("imgPath");

JSONObject content = new JSONObject(formContent);
String consulationDate = content.getString("consulationDate");
String sourceOfReferral = content.getString("sourceOfReferral");
String educationLv = content.getString("educationLv");
String occupation = content.getString("occupation");
String smoking = content.getString("smoking");
String quantityOfSmoke = content.getString("quantityOfSmoke");
String drinking = content.getString("drinking");
String quantityOfDrink = content.getString("quantityOfDrink");
String goh = content.getString("goh");
String poh = content.getString("poh");
String moh = content.getString("moh");
String toh = content.getString("toh");
String ageOfDelivery = content.getString("ageOfDelivery");
String breastFeeding = content.getString("breastFeeding");
String hrt = content.getString("HRT");
String hrtMonth = content.getString("hrtMonth");
String hrtYear = content.getString("hrtYear");
String menarcheAge = content.getString("menarcheAge");
String menopause = content.getString("menopause");
String menopauseAge = content.getString("menopauseAge");
String lmpDate = content.getString("lmpDate");
String pastMedicalHistory = content.getString("pastMedicalHistory");
String familyHistory = content.getString("familyHistory");
String finding = content.getString("finding");
String imaging = content.getString("imaging");
String referToBioBoolean = content.getString("referToBioBoolean");
String mammogramFollowUpBoolean = content.getString("mammogramFollowUpBoolean");
String usgFollowUpBoolean = content.getString("usgFollowUpBoolean");
String mFollowUpPlace = content.getString("mFollowUpPlace");
String mFollowUpDate = content.getString("mFollowUpDate");
String uFollowUpPlace = content.getString("uFollowUpPlace");
String uFollowUpDate = content.getString("uFollowUpDate");


//insert form to db
if("null".equals(formuid)){
	formuid = BreastHealthDB.insertForm(formType, regid, patno, userid, formContent);
	BreastHealthDB.createImage(imgPath, formuid);
}else{
	formuid = BreastHealthDB.updateForm(formuid, formType, regid, patno, userid, formContent);
}

String url = null;
String logo = null;
if (ConstantsServerSide.isTWAH()) {
	url = "http://www.twah.org.hk";
	logo = "twah_portal_logo.gif";
} else {
	url = "http://www.hkah.org.hk";
	logo = "hkah_portal_logo.gif";
}

ArrayList result = null;
String path = "";
result = BreastHealthDB.getFormPath();
if (result.size() > 0) {
	ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
	path = reportableListObject.getValue(0);
}
	
File reportFile = new File(application.getRealPath("/report/Breast_Health.jasper"));
File reportDir = new File(application.getRealPath("/report/"));
if (reportFile.exists()) {
	JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	
	Map parameters = new HashMap();
	parameters.put("BaseDir", reportFile.getParentFile());
	parameters.put("Site", ConstantsServerSide.SITE_CODE);
	parameters.put("path", path);
	parameters.put("formuid", formuid);
	parameters.put("formDate", formDate);
	parameters.put("docName", docName);
	parameters.put("patno", patno);
	parameters.put("patName", patName);
	parameters.put("patDob", patDob);
	parameters.put("patSex", patSex);
	parameters.put("consulationDate", consulationDate);
	parameters.put("sourceOfReferral", sourceOfReferral);
	parameters.put("educationLv", educationLv);
	parameters.put("occupation", occupation);
	parameters.put("smoking", smoking);
	parameters.put("quantityOfSmoke", quantityOfSmoke);
	parameters.put("drinking", drinking);
	parameters.put("quantityOfDrink", quantityOfDrink);
	parameters.put("goh", goh);
	parameters.put("poh", poh);
	parameters.put("moh", moh);
	parameters.put("toh", toh);
	parameters.put("ageOfDelivery", ageOfDelivery);
	parameters.put("breastFeeding", breastFeeding);
	parameters.put("hrt", hrt);
	parameters.put("hrtMonth", hrtMonth);
	parameters.put("hrtYear", hrtYear);
	parameters.put("menarcheAge", menarcheAge);
	parameters.put("menopause", menopause);
	parameters.put("menopauseAge", menopauseAge);
	parameters.put("lmpDate", lmpDate);
	parameters.put("pastMedicalHistory", pastMedicalHistory);
	parameters.put("familyHistory", familyHistory);
	parameters.put("finding", finding);
	parameters.put("imaging", imaging);
	parameters.put("referToBioBoolean", referToBioBoolean);
	parameters.put("mammogramFollowUpBoolean", mammogramFollowUpBoolean);
	parameters.put("usgFollowUpBoolean", usgFollowUpBoolean);
	parameters.put("mFollowUpPlace", mFollowUpPlace);
	parameters.put("mFollowUpDate", mFollowUpDate);
	parameters.put("uFollowUpPlace", uFollowUpPlace);
	parameters.put("uFollowUpDate", uFollowUpDate);
	
	JasperPrint jasperPrint =
		JasperFillManager.fillReport(
			jasperReport, parameters, new JREmptyDataSource(1));
	
	String encodedFileName = "BreastHealth" + "_" + formuid + ".pdf";
	request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
	File outputFile = new File(path + encodedFileName); 
	JRPdfExporter exporter = new JRPdfExporter();
	exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);

	exporter.setParameter(JRExporterParameter.OUTPUT_FILE, outputFile);
	exporter.setParameter(JRPdfExporterParameter.PDF_VERSION, JRPdfExporterParameter.PDF_VERSION_1_2);
	exporter.exportReport();
	
	if ("viewPage".equals(mode)){
		response.reset();
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		response.setHeader("Content-disposition", "inline; filename=\"" + encodedFileName + "\"");//<--inline=display in browser; attactment=save as attactment
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
	    exporter.setParameter(JRPdfExporterParameter.PDF_JAVASCRIPT, "this.print();");
		exporter.exportReport();
	//	String redirectURL = "../cms/BreastHealthCentreProgressSheet.jsp";
	//	redirectURL += "?mode=" + "view";
	//	redirectURL += "&formuid=" + formuid;
	//    response.sendRedirect(redirectURL);
	}
	if ("save".equals(mode)){
		//exporter.exportReport();
		String redirectURL = "../cms/BreastHealthCentreProgressSheet.jsp";
		redirectURL += "?mode=" + "viewFromID";
		redirectURL += "&formuid=" + formuid;
	    response.sendRedirect(redirectURL);
	}
}
%>
