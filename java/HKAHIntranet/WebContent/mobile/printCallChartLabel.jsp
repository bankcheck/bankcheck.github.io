<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.print.attribute.PrintRequestAttributeSet" %>
<%@ page import="javax.print.attribute.standard.Copies" %>
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

	private int getAppLableNum() {
		int tempGetAppLableNum;
		int getAppLableNum;

		try {
			tempGetAppLableNum = Integer.parseInt(getSystemParameter("AppLabNum"));
		} catch (Exception e) {
			tempGetAppLableNum = 0;
		}

		if (tempGetAppLableNum < 1) {
			getAppLableNum = 1;
		} else {
			getAppLableNum = tempGetAppLableNum;
		}

		return getAppLableNum;
	}
%>
<%
UserBean userBean = new UserBean(request);
String bkgID = request.getParameter("bkgID");
String patno = request.getParameter("patno");

boolean isClChartLog = "Y".equals(getSystemParameter("CLCHARTLOG"));
boolean isAsterisk = "YES".equals(getSystemParameter("Chk*"));
String labelType = getSystemParameter("LBLTYP");

String encodedFileName = null;

Map<String, String> map = new HashMap();
int getAppLableNumInt = getAppLableNum();
if (getAppLableNumInt < 1) {
	return;
}

ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
ReportMapDataSource queueDS = null;
int noOfCopies = 1;

String sVolNumber = ConstantsVariable.EMPTY_VALUE;
String sSteCode = null;
String sSteName = null;
String bkgpname = null;
String sDocCode = null;
String sDoctorName = null;
String bkgsdate = null;
String bkgstime = null;
String bkgsdatetime = null;
String variable_current_location = "";

StringBuffer sqlStr = new StringBuffer();
sqlStr.append("SELECT B.STECODE, ST.STENAME, ");
sqlStr.append("       DR.DOCCODE, DR.DOCFNAME || ' ' || DR.DOCGNAME, ");
sqlStr.append("       P.PATNO, P.PATFNAME || ' ' || P.PATGNAME, ");
sqlStr.append("       TO_CHAR(SYSDATE, 'DD/MM/YYYY'), TO_CHAR(SYSDATE, 'HH24:MI'), ");
sqlStr.append("       TO_CHAR(B.BKGSDATE, 'DD/MM/YYYY HH24:MI') ");
sqlStr.append("FROM   BOOKING B ");
sqlStr.append("LEFT JOIN SCHEDULE S ON B.SCHID = S.SCHID ");
sqlStr.append("LEFT JOIN PATIENT P ON B.PATNO = P.PATNO ");
sqlStr.append("LEFT JOIN DOCTOR DR ON S.DOCCODE = DR.DOCCODE ");
sqlStr.append("LEFT JOIN SITE ST ON B.STECODE = ST.STECODE ");
sqlStr.append("WHERE B.BKGID = ? ");
sqlStr.append("AND   B.PATNO = ? ");

record = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { bkgID, patno });
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	sSteCode = row.getValue(0);
	sSteName = row.getValue(1);
	sDocCode = row.getValue(2);
	sDoctorName = row.getValue(3);
	bkgpname = row.getValue(5);
	bkgsdate = row.getValue(6);
	bkgstime = row.getValue(7);
	bkgsdatetime = row.getValue(8);
} else {
	return;
}

record = UtilDBWeb.getFunctionResultsHATS("NHS_GET_MEDREC_FILL_PAPERPRI", new String[] { patno });
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	sVolNumber = row.getValue(5);
}
try {
	if (Integer.parseInt(sVolNumber) <= 0) {
		sVolNumber = "00";
	}
} catch (Exception e) {
	sVolNumber = "00";
}

if ("A".equals(labelType)) {
	encodedFileName = "PickLslLblNewAppointment";

	if (getAppLableNumInt > 0) {
		sqlStr.setLength(0);
		sqlStr.append("SELECT L.MRLDESC AS LOCATION, DOC.DOCFNAME || ' ' || DOC.DOCGNAME AS DOCNAME ");
		sqlStr.append("FROM   MEDRECHDR H, MEDRECDTL D, MEDRECLOC L, DOCTOR DOC ");
		sqlStr.append("WHERE  H.PATNO = ? ");
		sqlStr.append("AND    D.DOCCODE = DOC.DOCCODE(+) ");
		sqlStr.append("AND    H.MRHVOLLAB = ");
		sqlStr.append("       ( SELECT MAX(MRHVOLLAB) AS MAXVOL FROM MEDRECHDR WHERE PATNO = H.PATNO AND MRHSTS = 'N' )");
		sqlStr.append("AND    H.MRDID = D.MRDID ");
		sqlStr.append("AND    NVL(D.MRLID_R, MRLID_L) = L.MRLID ");

		record = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { patno });
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			variable_current_location = row.getValue(0);
			if (row.getValue(1) != null && row.getValue(1).trim().length() > 0) {
				variable_current_location += "(" + row.getValue(1) + ")";
			}
		}
		map.put("DOCNAME", sDoctorName);
		map.put("BKGSDATE", bkgstime + "(" + bkgsdate + ")" + (isAsterisk?" *":""));
		map.put("PATNO", patno);
		map.put("VOLNUM", sVolNumber);
		map.put("PATNAME", bkgpname);
		map.put("LOCATION", variable_current_location);
		map.put("SENDTO", "OPD");
	} else {
		return;
	}
} else {
	encodedFileName = "RegPrtCallChtDrApp";

	sqlStr.setLength(0);
	sqlStr.append("SELECT max(H.mrhvollab) as maxvol ");
	sqlStr.append("FROM   MedRecHdr H ");
	sqlStr.append("INNER JOIN MEDRECMED M ON H.MrmID = m.MrmID ");
	sqlStr.append("WHERE M.MRMID = 1 ");
	sqlStr.append("AND   H.mrhsts = 'N' ");
	sqlStr.append("AND   H.PATNO = ? ");

	record = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { patno });
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		if (row.getValue(0).length() > 0) {
			sVolNumber = row.getValue(0);
		}
	} else if (isClChartLog) {
		// It does not have any medical chart
		return;
	}

	map.put("bkgsDate", bkgsdatetime);
	map.put("SteName", sSteName);
	map.put("Volume",  "(" + (sVolNumber == null ? ConstantsVariable.SPACE_VALUE : sVolNumber) + ")");
	map.put("walkin", "");
	map.put("pcName", "OPB Registration");

	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		queueDS = new ReportMapDataSource(
			UtilDBWeb.getFunctionResultsHATS("NHS_RPT_REGPRTCALLCHTDRAPP", new String[] { bkgpname, patno, sSteCode, sDocCode, bkgID, "", String.valueOf(getAppLableNumInt)}),
			new String[] {"bkgname", "patno", "patnoA", "patnoB", "patnoC", "patnoD", "patnoE", "docName", "docCode", "spcname", "bkgsdate2", "bkgsdate", "stename", "isStaff", "alert", "userID"},
			new boolean[]{false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false});
	}
	noOfCopies = 2;
}

if (isClChartLog) {
	if (sVolNumber == null ||  sVolNumber.length() == 0) {
		// It does not have any medical chart
		return;
	}

	UtilDBWeb.callFunctionHATS("NHS_ACT_MEDRECDTL", "ADD", new String[] {
				sDocCode,
				ConstantsVariable.EMPTY_VALUE,
				"Out-patient Registration",
				"MOBILE",
				"KIOSK",
				sVolNumber,
				patno
		});
}

File reportFile = new File(application.getRealPath("/report/" + encodedFileName + ".jasper"));
File reportDir = new File(application.getRealPath("/report/"));
if (!reportFile.exists()) {
	return;
}
JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
JasperPrint jasperPrint = null;
if (queueDS != null) {
	jasperPrint = JasperFillManager.fillReport(jasperReport, map, queueDS);
} else {
	jasperPrint = JasperFillManager.fillReport(jasperReport, map);
}
List<JasperPrint> jasperPrintList = new ArrayList<JasperPrint>();
for (int z = 1; z <= noOfCopies; z++) {
	if (jasperPrint.getPages().size() > 0) {
		jasperPrintList.add(jasperPrint);
	}
}

request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
OutputStream ouputStream = response.getOutputStream();
response.setContentType("application/pdf");
response.setHeader("Content-disposition", "inline; filename=\"" + encodedFileName + Long.toString((new Date()).getTime()) + ".pdf\"");

//PrintRequestAttributeSet printRequestAttributeSet = new HashPrintRequestAttributeSet();
//printRequestAttributeSet.add(new Copies(noOfCopies));

JRPdfExporter exporter = new JRPdfExporter();
exporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST, jasperPrintList);
//exporter.setParameter(JRPrintServiceExporterParameter.PRINT_REQUEST_ATTRIBUTE_SET, printRequestAttributeSet);
exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

exporter.exportReport();
return;
%>