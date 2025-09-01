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

	private JasperPrint getJasperReport(ServletContext application, String encodedFileName, Map parameters, String[] inparam, String[] label) {
		return getJasperReport(application, encodedFileName, parameters, inparam, label, false);
	}

	private JasperPrint getJasperReport(ServletContext application, String encodedFileName, Map parameters, String[] inparam, String[] label,boolean isNoPageWhenNoData) {
		try {
			File reportFile = new File(application.getRealPath("/report/" + encodedFileName + ".jasper"));
			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport) JRLoader.loadObject(reportFile.getPath());

				ReportMapDataSource dataSrc = new ReportMapDataSource(UtilDBWeb.getFunctionResultsHATS("NHS_RPT_" + encodedFileName, inparam), label);
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
%><%
UserBean userBean = new UserBean(request);
String bkgID = request.getParameter("bkgID");
String patno = request.getParameter("patno");
String regID = null;
String tempChkDigit = null;
String max_mrhvollab = null;
boolean isAsterisk = "YES".equals(getSystemParameter("Chk*"));
boolean isChkDigit = "YES".equals(getSystemParameter("ChkDigit"));
String ticketGen = getSystemParameter("TicketGen");
String ticketLblN = getSystemParameter("TicketLblN");
String noPatLabel = getSystemParameter("NOPATLABEL");
String noToBePrintStr = "1";

Map<String, String> mapPba = new HashMap<String, String>();
Map<String, String> mapGeneral = new HashMap<String, String>();
Map<String, String> mapTicket = new HashMap<String, String>();
Map<String, String> mapPatient = new HashMap<String, String>();
Map<String, String> mapNurseNote = new HashMap<String, String>();

ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
File reportDir = new File(application.getRealPath("/report/"));

StringBuffer sqlStr = new StringBuffer();
sqlStr.append("SELECT MAX(HDR.MRHVOLLAB), NHS_GEN_CHECKDIGIT(B.PATNO), R.REGID ");
sqlStr.append("FROM   BOOKING B ");
sqlStr.append("INNER JOIN MEDRECHDR HDR ON B.PATNO = HDR.PATNO ");
sqlStr.append("INNER JOIN REG R ON B.BKGID = R.BKGID ");
sqlStr.append("WHERE  B.PATNO = ? ");
sqlStr.append("AND    B.BKGID = ? ");
sqlStr.append("GROUP BY B.PATNO, R.REGID ");

record = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { patno, bkgID });
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	max_mrhvollab = row.getValue(0);
	tempChkDigit = (isChkDigit ? row.getValue(1) : "") + "#";
	regID = row.getValue(2);
}

record = UtilDBWeb.getFunctionResultsHATS("NHS_RPT_PBA", new String[] { patno, noPatLabel });
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	List<JasperPrint> jasperPrintList = new ArrayList<JasperPrint>();

	mapTicket.put("TicketLblN", ticketLblN);
	mapTicket.put("newbarcode", patno + tempChkDigit);
	mapTicket.put("TicketGenMth", ticketGen);
	jasperPrintList.add(getJasperReport(application, "REGTICKETLABEL", mapTicket, new String[] {regID}, new String[] {"patno", "ticketNo", "newticketno", "docname", "doccname", "patname", "patcname", "arrivalTime", "apptTime"}));

	mapPba.put("SUBREPORT_DIR", reportDir.getPath() + "\\");
	mapPba.put("number", noToBePrintStr);
	mapPba.put("outPatType", "O");
	mapPba.put("newbarcode", patno + tempChkDigit);
	mapPba.put("TicketGenMth", ticketGen);
	mapPba.put("isasterisk", String.valueOf(isAsterisk));
	mapPba.put("stecode", row.getValue(0));
	mapPba.put("patno", row.getValue(1));
	mapPba.put("patname", row.getValue(2));
	mapPba.put("ppatcname", row.getValue(3));
	mapPba.put("patbdate", row.getValue(4));
	mapPba.put("patsex", row.getValue(5));
	mapPba.put("pdocname", row.getValue(6));
	mapPba.put("pregdate", row.getValue(7));
	mapPba.put("padmdate", row.getValue(8));
	mapPba.put("pregcat", row.getValue(9));
	mapPba.put("regcount", row.getValue(10));
	mapPba.put("pticketno", row.getValue(11));
//	mapPba.put("plblrmk", row.getValue(12));
	mapPba.put("plblrmk", "Mobile Apps");
	jasperPrintList.add(getJasperReport(application, "PBA", mapPba, new String[] {patno, noPatLabel}, new String[] {"stecode", "patno", "patname", "patcname", "patbdate", "patsex", "docname", "regdate", "admdate", "regcat", "regcount", "ticketno", "lblrmk"}));

	mapPatient.put("isasterisk", String.valueOf(isAsterisk));
	mapPatient.put("newbarcode", patno + tempChkDigit);
	jasperPrintList.add(getJasperReport(application, "REGSEARCHPRINTDOBWTHNO", mapPatient, new String[] {patno, "3"}, new String[] {"stecode", "patno", "patname", "patcname", "patbdate", "patsex"}));

	mapNurseNote.put("patno", patno);
	jasperPrintList.add(getJasperReport(application, "NurseNote", mapNurseNote, new String[] { "" }, new String[] { }));

	mapGeneral.put("SUBREPORT_DIR", reportDir.getPath() + "\\");
	mapGeneral.put("number", noToBePrintStr);
	mapGeneral.put("outPatType", "O");
	mapGeneral.put("newbarcode", patno + tempChkDigit);
	mapGeneral.put("TicketGenMth", ticketGen);
	mapGeneral.put("isasterisk", String.valueOf(isAsterisk));
	jasperPrintList.add(getJasperReport(application, "ALERTLABEL", mapGeneral, new String[] {(ConstantsServerSide.SITE_CODE).toUpperCase(), patno}, new String[] { }, true));

	Iterator<JasperPrint> iterator = jasperPrintList.iterator();
	while (iterator.hasNext()) {
		if (iterator.next() == null) {
			iterator.remove();
		}
	}

//	request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
	OutputStream ouputStream = response.getOutputStream();
	response.setContentType("application/pdf");
	response.setHeader("Content-disposition", "inline; filename=\"PBA" + Long.toString((new Date()).getTime()) + ".pdf\"");

	JRPdfExporter exporter = new JRPdfExporter();
	exporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST, jasperPrintList);
//	exporter.setParameter(JRPrintServiceExporterParameter.PRINT_REQUEST_ATTRIBUTE_SET, printRequestAttributeSet);
	exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

	exporter.exportReport();
	return;
}
%>