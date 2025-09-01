<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.db.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.hkah.web.common.*" %>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="org.apache.pdfbox.pdmodel.*" %>
<%@ page import="org.apache.pdfbox.pdmodel.PDPage" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.net.*"%>

<%@ page import="java.io.*"%>
<%!

private static HashMap<String, String> keyIsChar = new HashMap<String, String>();
private static HashMap<String, String> keyIsNum = new HashMap<String, String>();


	private ArrayList<ReportableListObject> fetchDoctor(String doccode) {
		return UtilDBWeb.getReportableList("SELECT DOCFNAME || ' ' || DOCGNAME, DOCCNAME FROM DOCTOR@IWEB WHERE DOCCODE = ?", new String[] { doccode });
	}

	private String joinNameFromList(ArrayList<HashMap<String,String>> list, String key){
		String joinedString = "";
		HashMap<String,String> map = new HashMap<String,String>();
		for ( int i = 0; i < list.size(); i++) {
			map = list.get(i);
			joinedString += (("".equals(map.get(key))||map.get(key)== null)?"":(map.get(key)+";"));
		}
		return joinedString;
	}


	private HashMap<String,String> fetchProcedure(String proccode) {
		HashMap<String,String> positionMap = new HashMap<String,String>();
		positionMap.put("Left","Left 左");
		positionMap.put("Right","Right 右");
		positionMap.put("Bilateral","Bilateral 雙側");
		positionMap.put("Upper","Upper 上");
		positionMap.put("Lower","Lower 下");
		positionMap.put("Anterior","Anterior 前");
		positionMap.put("Posterior","Posterior 後");
		System.out.println("proccode:"+proccode);
		String[] procedureArray = proccode.split("<s>");

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(
				"SELECT C.REF_CODE,P.PROCDESC,NVL(P.PROCCDESC,''),P.FSHT_DOCID,P.FSHT_DOCNAME,P.FSHT_DOCCNAME,P.FSHT_VERNO,P.FSHT_CVERNO,P.PROCTYPE,P.FSHT_DOCJNAME,P.FSHT_JVERNO FROM CFM_PROC@IWEB P,CFM_CODE@IWEB C WHERE P.PROCCODE=C.PROCCODE(+) AND P.PROCCODE= ?", new String[] { procedureArray[0] });
		ReportableListObject row = null;
		HashMap<String,String> procedure = new HashMap<String,String>();


		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			if ("P".equals(row.getValue(8))) {
				procedure.put("refCode",row.getValue(0));
				procedure.put("procDesc",row.getValue(1)+(!"".equals(row.getValue(2))?row.getValue(2):"")+(procedureArray.length>1?"("+positionMap.get(procedureArray[1])+")":""));
				procedure.put("procCDesc",row.getValue(2)+(procedureArray.length>1?"("+procedureArray[1]+")":""));
				procedure.put("fshtDocID",row.getValue(3));
				procedure.put("fshtDocName",row.getValue(4));
				procedure.put("fshtDocCName",row.getValue(5));
				procedure.put("fshtVerNo",row.getValue(6));
				procedure.put("fshtCVerNo",row.getValue(7));
				procedure.put("fshtDocJName",row.getValue(9));
				procedure.put("fshtJVerNo",row.getValue(10));
				procedure.put("hasFS",(!"".equals(row.getValue(4))||!"".equals(row.getValue(5))|| !"".equals(row.getValue(9)))?"Y":"N");
			}
			if ("A".equals(row.getValue(8))) {
				procedure.put("procType","A");
				procedure.put("afshtVerNo",row.getValue(6));
				procedure.put("afshtCVerNo",row.getValue(7));
				procedure.put("afshtJVerNo",row.getValue(10));
			}
			if (row.getValue(3) != null && row.getValue(3).length() > 0 ){
				if (ConstantsServerSide.isTWAH()) {
					procedure.put("fshtUrl","http://192.168.0.20/intranet/documentManage/download.jsp?src=inapp&documentID="+row.getValue(3)+"&fileName=/"+row.getValue(4));
					procedure.put("fshtCUrl","http://192.168.0.20/intranet/documentManage/download.jsp?src=inapp&documentID="+row.getValue(3)+"&fileName=/"+row.getValue(5));
				} else {
					procedure.put("fshtUrl","http://www-server/intranet/documentManage/download.jsp?src=inapp&documentID="+row.getValue(3)+"&fileName=/"+URLEncoder.encode(row.getValue(4)));
					procedure.put("fshtCUrl","http://www-server/intranet/documentManage/download.jsp?src=inapp&documentID="+row.getValue(3)+"&fileName=/"+URLEncoder.encode(row.getValue(5)));
					procedure.put("fshtJUrl","http://www-server/intranet/documentManage/download.jsp?src=inapp&documentID="+row.getValue(3)+"&fileName=/"+URLEncoder.encode(row.getValue(9)));
				}
			}

		} else {
			procedure.put("refCode","");
			procedure.put("procDesc",proccode);
		}
		return procedure;
	}

	private void saveConsent(UserBean userBean, String patNo, String patName, String patCName,
			String docCode, String procCode, String procDesc, String anaestType, String anaestTypeExtra,
			String formLang, String formCopy, String factSheetVer, String aFactSheetVer,String complication,String consentDate,
			String aFormCopy,String isTimeOut)
	{
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CFM_CONSENT@IWEB (");
		sqlStr.append("CONSENT_ID,PATNO, PATNAME, PATCNAME, DOCCODE, PROCCODE,PROCDESC, ");	// 1
		sqlStr.append("ANAESTTYPE, ANAESTTYPE_EXTRA, FORM_LANG, FORM_COPY, FACT_SHEET_VER, ");	// 2
		sqlStr.append("CREATE_DATE, CREATE_USER, AFACT_SHEET_VER,COMPLICATION,SIGN_DATE,AFORM_COPY,TIMEOUT");	// 3
		sqlStr.append(") VALUES (");
		sqlStr.append("(SEQ_CFMCONSENT.NEXTVAL@IWEB), ?, ?, ?, ?, ?, ?, ");	// 1
		sqlStr.append("?, ?, ?, ?, ?, ");	// 2
		sqlStr.append("SYSDATE, ?, ?, ?,TO_DATE(?,'dd/mm/yyyy'),?,?)"); //3

		UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					patNo, patName, patCName, docCode, procCode, procDesc, // 1
 					anaestType, anaestTypeExtra, formLang, formCopy, factSheetVer,
					userBean.getStaffID(), aFactSheetVer,complication,consentDate,aFormCopy,isTimeOut
				});
	}
%>
<%
UserBean userBean = new UserBean(request);

String lang = request.getParameter("lang");
String patno = request.getParameter("patno");
if (patno == null) {
	patno = "";
}
String patname = request.getParameter("patname");
String patcname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patcname"));
String patDOB = request.getParameter("patDOB");
String patSex = request.getParameter("patSex");
String patIDno = request.getParameter("patidno");
String patCheckDight = !"".equals(patno)?PatientInfo.generateCheckDigit(patno):"";


String doccode = request.getParameter("DocSelect");
if (doccode == null) {
	doccode = request.getParameter("doccode");
}
patname=request.getParameter("patname");
String docname = request.getParameter("DocInput");
//String procedure1 = request.getParameter("ProcedureSelect1");
String[] procedure1 = request.getParameterValues("ProcedureSelect1");
String freeTextProc = request.getParameter("freeTextProc");
String complication = request.getParameter("complication");
String patientYN = request.getParameter("patientYN");
String todayYN = request.getParameter("todayYN");
String consentDate = request.getParameter("date_from");
String[] anaeMeth = (String[]) request.getParameterValues("anaeMeth");
String timeOutFormYN = request.getParameter("timeOutForm");
String withAn = request.getParameter("withAn");
String anaeJoin = null;
String anaeFactSheetNoJoin = "";
String anaeCFactSheetNoJoin = "";
String anaeJFactSheetNoJoin = "";
String anaeFactSheetNo = null;
String anaeCFactSheetNo = null;
String anaeJFactSheetNo = null;
/* String consentDate = null;
if ("Y".equals(todayYN)) {
	consentDate = DateTimeUtil.getCurrentDate();
} else {
	consentDate = DateTimeUtil.getRollDate(1,0,0);
} */



ArrayList<HashMap<String,String>> procedureList = new ArrayList<HashMap<String,String>>();
HashMap<String,String> tempProc = new HashMap<String,String>();
if (procedure1 != null && procedure1.length > 0) {
	for (int i = 0; i < procedure1.length; i++) {
		tempProc = fetchProcedure(procedure1[i]);
		procedureList.add(tempProc);
	}
}
if (anaeMeth != null && anaeMeth.length > 0 ) {
	for (int k = 0; k < anaeMeth.length; k++ ) {
			tempProc = fetchProcedure(anaeMeth[k].toUpperCase());
			anaeFactSheetNo = tempProc.get("afshtVerNo");
			anaeCFactSheetNo = tempProc.get("afshtCVerNo");
			anaeJFactSheetNo = tempProc.get("afshtJVerNo");
			procedureList.add(tempProc);
			anaeFactSheetNoJoin = anaeFactSheetNoJoin + ((!"".equals(anaeFactSheetNoJoin)&& anaeFactSheetNoJoin != null)?",":"")+anaeFactSheetNo;
			anaeCFactSheetNoJoin = anaeCFactSheetNoJoin + ((!"".equals(anaeCFactSheetNoJoin)&& anaeCFactSheetNoJoin != null)?",":"")+ anaeCFactSheetNo;
			anaeJFactSheetNoJoin = anaeJFactSheetNoJoin + ((!"".equals(anaeJFactSheetNoJoin)&& anaeJFactSheetNoJoin != null)?",":"")+ anaeJFactSheetNo;
	}
	anaeJoin = StringUtils.join(anaeMeth,",");


}



String regionAnaeSelect = request.getParameter("regionAnaeSelect");
String regionOther = request.getParameter("regionOther");
String copy = request.getParameter("copy");
String fsCopy = request.getParameter("fsCopy");


ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
String doccname = null;
if (doccode != null && doccode.length() > 0) {
	record = fetchDoctor(doccode);

	if (record != null && record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		docname = row.getValue(0);
		doccname = row.getValue(1);
	} else {
		docname = "";
		doccname = "";
	}
}
	for (int i = 0; i < procedureList.size(); i++) {
		if (!"A".equals(procedureList.get(i).get("procType"))) {
			saveConsent(userBean, patno, patname, patcname, doccode, procedureList.get(i).get("refCode"),
						 procedureList.get(i).get("procDesc"),
						 anaeJoin,regionAnaeSelect+(!"".equals(regionOther)?"("+regionOther+")":""),
				lang, copy,
				("chi".equals(lang)?procedureList.get(i).get("fshtCVerNo"):
					("jap".equals(lang)?procedureList.get(i).get("fshtJVerNo"):
							procedureList.get(i).get("fshtVerNo"))),
				("chi".equals(lang)?anaeCFactSheetNoJoin:
					("jap".equals(lang)?anaeJFactSheetNoJoin:anaeFactSheetNoJoin)),
				complication,consentDate,fsCopy,timeOutFormYN);
		}
	}

File reportFile = new File(application.getRealPath("/report/consentSurg"+("N".equals(withAn)?"WOutAnes":"")
		+"_"+(lang==null?"eng":lang)+(ConstantsServerSide.isHKAH()?"_HKAH":"")+".jasper"));

File reportFileTimeOut = new File(application.getRealPath("/report/timeOutSheet.jasper"));

File reportDir = new File(application.getRealPath("/report/"));
if (reportFile.exists()) {
	JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	JasperReport jasperReportTimeOut = (JasperReport)JRLoader.loadObject(reportFileTimeOut.getPath());

 	Map parameters = new HashMap();
	parameters.put("BaseDir", reportFile.getParentFile());
	parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
	parameters.put("Site", "twah");
	parameters.put("patno", patno+patCheckDight);
	parameters.put("patcname", patcname);
	parameters.put("patname", patname);
	parameters.put("patDOB", patDOB);
	parameters.put("patSex", patSex);
	parameters.put("patIDno", patIDno);
	parameters.put("procedure", joinNameFromList(procedureList,"procDesc"));
	parameters.put("anaethesiaType", anaeJoin);
	parameters.put("regionAnaeSelect", regionAnaeSelect);
	parameters.put("anaethesiaOtherText", regionOther);
	parameters.put("docname", docname);
	parameters.put("doccname", doccname);
	parameters.put("factSheetNo", "chi".equals(lang)?joinNameFromList(procedureList,"fshtCVerNo"):
										("jap".equals(lang)?joinNameFromList(procedureList,"fshtJVerNo"):joinNameFromList(procedureList,"fshtVerNo")));
	parameters.put("afactSheetNo", "chi".equals(lang)?joinNameFromList(procedureList,"afshtCVerNo"):
										("jap".equals(lang)?joinNameFromList(procedureList,"afshtJVerNo"):joinNameFromList(procedureList,"afshtVerNo")));
	parameters.put("lang", lang);
	parameters.put("SubDataSource", new ReportListDataSource(UtilDBWeb.getReportableList("Select 1 From Dual Connect By Level <= 1")));
	parameters.put("SubDataSource1", new ReportListDataSource(UtilDBWeb.getReportableList("Select 1 From Dual Connect By Level <= 1")));
	parameters.put("patientYN",patientYN);
	parameters.put("complication",complication);
	parameters.put("consentDate",consentDate);
	parameters.put("isPrintTimeOut",timeOutFormYN);
	parameters.put("hasFS",String.valueOf((joinNameFromList(procedureList,"hasFS")).indexOf("Y")));

	JasperPrint jasperPrint =
		JasperFillManager.fillReport(
			jasperReport, parameters,new ReportListDataSource(UtilDBWeb.getReportableList("Select 1 From Dual Connect By Level <= 1")));

 	JasperPrint jasperPrintTimeOut =
		JasperFillManager.fillReport(
				jasperReportTimeOut,parameters,
				new ReportListDataSource(UtilDBWeb.getReportableList("Select 1 From Dual Connect By Level <= 1")));

	String encodedFileName = "ConsentSurg"+lang+"_"+ doccode + "_" + patname + ".pdf";

	JRPdfExporter exporter = new JRPdfExporter();

	if ("2".equals(copy)) {
		List<JasperPrint> jasperPrintList= new ArrayList<JasperPrint>();
		if ("Y".equals(timeOutFormYN)) {
			jasperPrintList.add(jasperPrintTimeOut);
		}
		jasperPrintList.add(jasperPrint);
		jasperPrintList.add(jasperPrint);
		exporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST, jasperPrintList);
	} else {
		List<JasperPrint> jasperPrintList= new ArrayList<JasperPrint>();
		if ("Y".equals(timeOutFormYN)) {
			jasperPrintList.add(jasperPrintTimeOut);
		}
		jasperPrintList.add(jasperPrint);
		exporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST, jasperPrintList);
	}
	//=================
	ByteArrayOutputStream os = new ByteArrayOutputStream();
	String fileName = "/report/"+"ConsentSurg"+new java.util.Date().getTime()+".pdf";
	exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, os);
	exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
	exporter.exportReport();

	PDDocument samplePdf = new PDDocument();
	PDDocument factPDF = new PDDocument();
	ByteArrayInputStream in = new ByteArrayInputStream(os.toByteArray());
	File f = new File(application.getRealPath(fileName));
	try {
	    samplePdf = PDDocument.load(in);

 	 	String FactSheet = null;
		for (int i = 0; i < procedureList.size(); i++) {
				FactSheet = "chi".equals(lang)? procedureList.get(i).get("fshtCUrl"):
									("jap".equals(lang)?procedureList.get(i).get("fshtJUrl"):procedureList.get(i).get("fshtUrl"));
			if (FactSheet!= null && FactSheet.length() > 0 ) {
				factPDF = PDDocument.load(new URL(FactSheet).openStream());
				PDPageTree sourcePageTree = factPDF.getDocumentCatalog().getPages();
				for(int k = 0; k < Integer.parseInt(fsCopy); k++) {
					for (PDPage page1 : sourcePageTree) {
						samplePdf.importPage(page1);
					}
				}
			}
		}

		samplePdf.save(f);
		factPDF.close();

	} catch (IOException e) {
	    e.printStackTrace();
	}
	samplePdf.close();
	in.close();

	ServletOutputStream outStream = response.getOutputStream();
	response.reset();
	response.setContentType("application/pdf");
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
	response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
	response.setHeader("Expires", "0"); // Proxies.
	response.setHeader("Content-disposition", "inline; filename=\"" + encodedFileName + "\"");

	int byteRead;
	FileInputStream inStream = new FileInputStream(f);

	int inStreamAva = inStream.available();
	byte []  buf = new byte [ 4 * 1024 ] ; // 4K buffer
	outStream = response.getOutputStream();

	int readCount = 0;
	long progressPerc = 0;
	while ((byteRead = inStream.read(buf)) != -1) {
		outStream.write(buf, 0, byteRead);

		readCount += byteRead;
		progressPerc = Math.round(((double) readCount / inStreamAva) * 100);
		// store the progress % value (0 - 100) in a session attribute 'progress-download'
		session.setAttribute("progress-download", progressPerc);
	}

	inStream.close();
	outStream.flush();
	outStream.close();
	out.clearBuffer();
	os.close();
	f.delete();

	return;
}
%>
</html:html>