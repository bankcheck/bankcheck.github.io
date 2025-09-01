<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*"%>
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
<%@ page import="org.apache.pdfbox.pdmodel.*" %>
<%@ page import="java.net.URL"%>
<%@ page import="java.io.*"%>
<%!
	private String getSystemParameter(String key) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListHATS("select param1 from sysparam where parcde = ?", new String[] { key });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return null;
		}
	}

private HashMap<String, String> initRptDescMap() {
	HashMap<String, String> rptDescMap = new HashMap<String, String>();
	ArrayList<ReportableListObject> record = 
		UtilDBWeb.getReportableListHATS("select TYPE, ID, LANGUAGE, DESCRIPTION from DESCRIPTION_MAPPING where TYPE IN ('MAPLANGUAGE', 'PAYMENTMETHOD') AND ENABLE = 1");
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			ReportableListObject row = (ReportableListObject) record.get(i);
			rptDescMap.put(row.getValue(0).toUpperCase()
					+ "_" + row.getValue(1).toUpperCase()
					+ "_" + row.getValue(2).toUpperCase(),
					row.getValue(3));
		}
	} 
	
	return rptDescMap;

}

public void addRequiredReportDesc(Map<String,String> descMap,Map<String, String> map, 
		String[] type, String[] id, String lang) {
	for (int i = 0; i < type.length; i++) {
		String desc = descMap.get(type[i].toUpperCase()+"_"+id[i].toUpperCase()+"_"+lang.toUpperCase());
		map.put(id[i], desc);
	}
}

	private JasperPrint getJasperReport(ServletContext application, String encodedFileName, Map parameters, String[] inparam, String[] label) {
		return getJasperReport(application, encodedFileName, parameters, inparam, label, false);
	}

	private JasperPrint getJasperReport(ServletContext application, String encodedFileName, Map parameters, String[] inparam, String[] label,boolean isNoPageWhenNoData) {
		try {
			File reportFile = new File(application.getRealPath("/report/" + encodedFileName + ".jasper"));
			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport) JRLoader.loadObject(reportFile.getPath());

				ReportMapDataSource dataSrc = new ReportMapDataSource(UtilDBWeb.getFunctionResultsHATS("NHS_RPT_" + encodedFileName.toUpperCase(), inparam), label);
				if (dataSrc.getSize() > 0 || !isNoPageWhenNoData) {
					return JasperFillManager.fillReport(jasperReport, parameters, dataSrc);
				} else {
					return null;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private ReportMapDataSource getSubRptDataSource(String encodedFileName,String[] inparam, String[] label) {
		ReportMapDataSource dataSrc = new  ReportMapDataSource(UtilDBWeb.getFunctionResults("NHS_RPT_" + encodedFileName.toUpperCase(), inparam), label);
		
		return dataSrc;
	}
	
	private Map getOPStatementParamSet(String reportDirectory, String slip, String rptType,String lang, String imgDir) {
		Map map = new HashMap();
		map.put("SUBREPORT_DIR", reportDirectory + "\\");
		map.put("P_SLPNO", slip );
		map.put("ISCOPY", "Y");
		map.put("RPTTYPE", rptType);
		map.put("watermark", imgDir+"\\"+"refOnly.gif");
		map.put("ISSHOWDIAG", "Y");
		map.put("AppIOSQRImg","");
		map.put("AppAndImg","");
		map.put("isShwPromo","Y");

		addRequiredReportDesc(initRptDescMap(),map,
				new String[] {
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage","Maplanguage"
				},
				new String[] {
					"receipt", "offsta", "PatNo",
					"PatName", "TreDr", "BillNo",
					"Copy", "Page", "Date",
					"Item", "Amount", "HKD",
					"Signature","Diagnosis","OpTreDr"
				},
				lang);

		map.put("isShowSign", "N");
		map.put("isOpShowSignL", "N");
		map.put("Diagnosis", "N");
		map.put("DiagnosisContent", "");
		
 		map.put("SubDataSource1",
 				new ReportMapDataSource(UtilDBWeb.getFunctionResults("NHS_RPT_OPSTATEMENT_SUB", new String[] {slip}), 
 						new String[] {"STNTDATE","AMOUNT","DESCRIPTION","QTY","ITMFLAG","CDESCCODE"})); 

		return map;
	}
%><%
UserBean userBean = new UserBean(request);
String slpNo = request.getParameter("slpNo");
String slpType = request.getParameter("slpType");
String lang = request.getParameter("lang");
String billID = request.getParameter("billID");
String baseURL = request.getParameter("baseURL");
String rptPath = request.getParameter("rptPath");
String from = request.getParameter("from");
String URL = baseURL.replace("hkahnhs/",rptPath);
String patno = request.getParameter("patno");
String docPath = request.getParameter("docPath");
if (docPath!= null && docPath.length() > 0 ) { 
	docPath = baseURL.replace("hkahnhs/",docPath);
}
%>
<%=URL %>

<%

List<JasperPrint> jasperPrintList = new ArrayList<JasperPrint>();
JasperPrint jasperPrint = null;


String outputFilePath = getSystemParameter("ABillPath").replace("\\","\\\\")+"\\billNo_"+billID+".pdf";
String outputNewFilePath = getSystemParameter("ABillPath").replace("\\","\\\\")+"\\billNo_"+billID+new java.util.Date().getTime()+".pdf";
URL url = new URL(URL);
InputStream is = url.openStream();
BufferedInputStream fileToParse = new BufferedInputStream(is);
PDDocument document = null;
PDDocument otherDoc = new PDDocument();
String output = null;
  File file = new File(outputFilePath); 
  File newfile = new File(outputNewFilePath);
  if (file.exists()) {
	  file.renameTo(newfile);
	}

try{
	document = PDDocument.load(fileToParse);
	if (docPath!= null && docPath.length() > 0 ) { 
		otherDoc = PDDocument.load(new URL(docPath).openStream());
		PDPageTree sourcePageTree = otherDoc.getDocumentCatalog().getPages();
			for (PDPage page1 : sourcePageTree) {
				document.importPage(page1);
			}	            
	}
	document.save(file);
} catch (IOException e) {
    e.printStackTrace();
} 
fileToParse.close();
otherDoc.close();
document.close();
is.close();
%>
<%if ("txnDetail".equals(from) && FileUtil.isExist(getSystemParameter("ABillPath").replace("\\","\\\\")+"\\billNo_"+billID+".pdf")) { %>
				<jsp:include page="sendAppMsg.jsp" flush="false">
					<jsp:param name="user" value="MOBILEAPP" />
					<jsp:param name="type" value="sendMsg" />
					<jsp:param name="patNo" value="<%=patno%>" />
					<jsp:param name="billID" value="<%=billID%>" />

				</jsp:include>
<%} %>
<%return;

%>