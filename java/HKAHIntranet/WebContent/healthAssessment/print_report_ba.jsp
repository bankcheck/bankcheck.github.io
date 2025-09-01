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
<%!
public byte[] generateReport(JasperPrint jasperPrint1, JasperPrint jasperPrint2, JasperPrint jasperPrint3, JasperPrint jasperPrint4, JasperPrint jasperPrint5,
		HttpServletResponse response) {
//throw the JasperPrint Objects in a list
ByteArrayOutputStream baos = null;
try {
List<JasperPrint> jasperPrintList = new ArrayList<JasperPrint>();
jasperPrintList.add(jasperPrint1);
//jasperPrintList.add(jasperPrint2);
//jasperPrintList.add(jasperPrint3);
//jasperPrintList.add(jasperPrint4);
//jasperPrintList.add(jasperPrint5);

baos = new ByteArrayOutputStream();
JRPdfExporter exporter = new JRPdfExporter();
//Add the list as a Parameter
exporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST, jasperPrintList);
//this will make a bookmark in the exported PDF for each of the reports
exporter.setParameter(JRPdfExporterParameter.IS_CREATING_BATCH_MODE_BOOKMARKS, Boolean.TRUE);
exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, baos);

OutputStream ouputStream = response.getOutputStream();
response.setContentType("application/pdf");

exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../../servlets/image?image=");

exporter.exportReport();
ouputStream.close();
} catch (Exception e){

}
return baos.toByteArray();
}
%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String baID = request.getParameter("baID");
String formType = request.getParameter("formType");
String reportName = "";
command = "pdfAction";

if(command != null && command.equals("pdfAction")){
	if (baID != null && baID.length() > 0) {
		ArrayList record = BAFormDB.fetchAccessForm(baID);
		if (record.size() > 0  && "pdfAction".equals(command) ) {
			
			reportName = "/report/breastHealthQuestionaire_eng_TWAH.jasper";
			
			File reportFile = new File(application.getRealPath(reportName));
			//File reportFile = new File(application.getRealPath("/report/HAForm_newstyle.jasper"));
			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

				Map parameters = new HashMap();
				parameters.put("BaseDir", reportFile.getParentFile());
				ReportableListObject row = (ReportableListObject) record.get(0);

				parameters.put("patno"   , row.getValue(6));
				parameters.put("patname" , row.getValue(78));
				parameters.put("patcname", row.getValue(79));
				parameters.put("patSex"  , row.getValue(80));
				parameters.put("patDOB"  , row.getValue(81));
				parameters.put("docname" , row.getValue(4));
				parameters.put("doccname", row.getValue(5));
				parameters.put("occupation", row.getValue(20));
				parameters.put("eduLevel"  , row.getValue(19));
				parameters.put("isDiabetes", row.getValue(21));
				parameters.put("isHyper"   , row.getValue(22));
				parameters.put("isHeartDis", row.getValue(23));
				parameters.put("isCancer"  , row.getValue(24));
				parameters.put("isPIllnessOther" , row.getValue(25));
				parameters.put("pIllnessOther"  , row.getValue(26));
				parameters.put("isPresentMed"   , row.getValue(27));
				parameters.put("presentMed"     , row.getValue(28));
				parameters.put("isOnHormonal"   , row.getValue(29));
				parameters.put("onHormonal"     , row.getValue(30));
				parameters.put("isTakAntiCDrug" , row.getValue(31));
				parameters.put("takAntiCDrug"   , row.getValue(32));
				parameters.put("isSmoking"      , row.getValue(33));
				parameters.put("isDrinking"     , row.getValue(34));
				parameters.put("breastLump_left", row.getValue(35));
				parameters.put("breastLump_left_mm" , row.getValue(36));
				parameters.put("breastLump_right"         , row.getValue(37));
				parameters.put("breastLump_right_mm"      , row.getValue(38));
				parameters.put("breastDischarge_left"      , row.getValue(39));
				parameters.put("breastDischarge_left_mm"  , row.getValue(40));
				parameters.put("breastDischarge_right"    , row.getValue(41));
				parameters.put("breastDischarge_right_mm" , row.getValue(42));
				parameters.put("breastNRetract_left"      , row.getValue(43));
				parameters.put("breastNRetract_left_mm"   , row.getValue(44));
				parameters.put("breastNRetract_right"     , row.getValue(45));
				parameters.put("breastNRetract_right_mm"  , row.getValue(46));
				parameters.put("breastSizeChange_left"    , row.getValue(47));
				parameters.put("breastSizeChange_left_mm" , row.getValue(48));
				parameters.put("breastSizeChange_right"   , row.getValue(49));
				parameters.put("breastSizeChange_right_mm", row.getValue(50));
				parameters.put("breastPain_left"     , row.getValue(51));
				parameters.put("breastPain_left_mm"  , row.getValue(52));
				parameters.put("breastPain_right"    , row.getValue(53));
				parameters.put("breastPain_right_mm" , row.getValue(54));
				parameters.put("breastSkinP_left"    , row.getValue(55));
				parameters.put("breastSkinP_left_mm" , row.getValue(56));
				parameters.put("breastSkinP_right"   , row.getValue(57));
				parameters.put("breastSkinP_right_mm", row.getValue(58));
				parameters.put("menarcheAge"   , row.getValue(59));
				parameters.put("menopauseAge"  , row.getValue(60));
				parameters.put("lastMenPeriod" , row.getValue(61));
				parameters.put("noOfPregnancy" , row.getValue(62));
				parameters.put("noOfDelivery"  , row.getValue(77));
				parameters.put("1stNoOfDeliAge", row.getValue(63));
				parameters.put("breastFExp"    , row.getValue(64));
				parameters.put("breastSurDone" , row.getValue(65));
				parameters.put("breastSurDone_Left" , row.getValue(66));
				parameters.put("breastSurDone_Right", row.getValue(67));
				parameters.put("breastSTest_US"  , row.getValue(68));
				parameters.put("breastSTest_MMG" , row.getValue(69));
				parameters.put("breastSTest_MMT" , row.getValue(70));
				parameters.put("breastSTest_FNAC", row.getValue(71));
				parameters.put("breastSTest_BIO" , row.getValue(72));
				parameters.put("breastFHis"      , row.getValue(73));
				parameters.put("breastFHis_BC"   , row.getValue(74));
				parameters.put("breastFHis_OC"   , row.getValue(75));
				parameters.put("breastFHis_Rel"  , row.getValue(76));
				
				
				JasperPrint jasperPrint =
					JasperFillManager.fillReport(
						jasperReport,
						parameters,
						new ReportListDataSource(record));

				generateReport(jasperPrint, jasperPrint, jasperPrint, jasperPrint, jasperPrint, response);

			}
		}
	}
}
%>
