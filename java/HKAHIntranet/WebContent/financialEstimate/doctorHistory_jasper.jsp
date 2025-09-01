<%@ page language="java" contentType="text/html; charset=utf-8"
%><%@ page import="java.util.*"
%><%@ page import="java.text.*"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ page import="com.hkah.jasper.*"
%><%@ page import="net.sf.jasperreports.engine.*"
%><%@ page import="net.sf.jasperreports.engine.util.*"
%><%@ page import="net.sf.jasperreports.engine.export.*"
%><%@ page import="net.sf.jasperreports.j2ee.servlets.*"
%><%@ page import="java.io.*"
%><%!
	private ArrayList<ReportableListObject> fetchDoctor(String doccode) {
		return UtilDBWeb.getReportableListHATS("SELECT DOCFNAME || ' ' || DOCGNAME, DOCCNAME FROM DOCTOR WHERE DOCCODE = ?", new String[] { doccode });
	}

	private String fetchProcedureDesc(String procedure) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListHATS("SELECT PROCDESC FROM FIN_PROC WHERE PROCCODE = ?", new String[] { procedure });
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return "";
		}
	}

	private ArrayList<ReportableListObject> getDoctorHistory(String doccode, String procedure2) {
		return UtilDBWeb.getReportableListHATS("select e.slpno, a.acmname, e.los, e.rm, e.ot, e.hosp_fee - e.rm - e.ot, e.hosp_fee from fin_estimate e, fin_acm a where e.acmcode = a.acmcode and e.doccode = ? and e.code IN (SELECT REFCODE FROM FIN_CODE WHERE PROCCODE = ?) order by e.acmcode, e.los, e.hosp_fee", new String[] { doccode, procedure2});
	}

	private ArrayList<ReportableListObject> fetchRegistrationRecord(String regid) {
		return UtilDBWeb.getReportableListHATS("SELECT PATNO, DOCCODE FROM REG WHERE REGID = ?", new String[] { regid });
	}
%><%
UserBean userBean = new UserBean(request);

String doccode = request.getParameter("DocSelect");
if (doccode == null) {
	doccode = request.getParameter("doccode");
}
String hatsDoccode = userBean.getStaffID();
String procedure2 = request.getParameter("ProcedureSelect2");
String regid = request.getParameter("regid");
String docname = null;
boolean fromCIS = false;

ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;

if (regid != null && regid.length() > 0) {
	record = fetchRegistrationRecord(regid);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		hatsDoccode = row.getValue(1);
		fromCIS = true;
	}
} else if (hatsDoccode != null && hatsDoccode.length() > 2) {
	int index = hatsDoccode.indexOf("DR");
	if (index >= 0) {
		hatsDoccode = hatsDoccode.substring(2);
	}
}

if ((userBean.isLogin() || fromCIS) && ((doccode != null && hatsDoccode != null && hatsDoccode.equals(doccode)) || userBean.isAccessible("function.financialEstimation.viewHistory"))) {
	if (doccode != null) {
		record = fetchDoctor(doccode);

		if (record != null && record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			docname = row.getValue(0) + " " + row.getValue(1);
		} else {
			docname = "";
		}
	} else {
		docname = "";
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

	File reportFile = new File(application.getRealPath("/report/finEstFrmTable.jasper"));
	File reportDir = new File(application.getRealPath("/report/"));
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
		parameters.put("Site", ConstantsServerSide.SITE_CODE);
		parameters.put("operation", fetchProcedureDesc(procedure2));
		parameters.put("docname", docname);
		parameters.put("url",url);
		parameters.put("logo",logo);

		record = getDoctorHistory(doccode, procedure2);

		if (record.size() > 0) {

			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport, parameters,
					new ReportListDataSource(record));

			String encodedFileName = "FinancialEstimation_" + doccode + ".pdf";
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/pdf");
			response.setHeader("Content-disposition", "attachment; filename=\"" + encodedFileName + "\"");
			JRPdfExporter exporter = new JRPdfExporter();
		    exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		    exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		    exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

		    exporter.exportReport();
		} else {
			%><script language=Javascript>
				alert('No data!');
				history.go(-1);
			</script><%
		}
	} else {
		%><script language=Javascript>
			alert('Jasper file not found!');</script>
			history.go(-1);
		<%
	}
} else {
	%><script language=Javascript>
		alert('No access right!');
		history.go(-1);
	</script><%
}
return;
%>