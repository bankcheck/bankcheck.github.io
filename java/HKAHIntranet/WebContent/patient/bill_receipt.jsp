<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="java.util.ArrayList.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.data.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>

<%!

private ArrayList getMainReportData(String slipNo) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT NVL(S.SLPFNAME, P.PATFNAME) || ' ' || NVL(S.SLPGNAME, P.PATGNAME) AS PATNAME, ");
	sqlStr.append("P.PATCNAME, S.SLPNO, P.PATNO, TO_CHAR(R.REGDATE, 'DD-MM-YYYY') AS REGDATE, ");
	sqlStr.append("TO_CHAR(R.REGDATE, 'HH24:MI') AS REGTIME, I.BEDCODE || '-' || I.ACMCODE AS BEDACM, ");
	sqlStr.append("TO_CHAR(I.INPDDATE, 'DD-MM-YYYY') AS INPDDATE, TO_CHAR(I.INPDDATE, 'HH24:MI') AS INPDTIME, ");
	sqlStr.append("D.DOCFNAME || ' ' || D.DOCGNAME AS DOCNAME, D.DOCCNAME ");
	sqlStr.append("FROM SLIP@IWeb S, PATIENT@IWeb P, REG@IWeb R, INPAT@IWeb I, DOCTOR@IWeb D ");
	sqlStr.append("WHERE S.REGID = R.REGID AND S.PATNO = P.PATNO(+) AND R.INPID = I.INPID(+) ");
	sqlStr.append("AND S.DOCCODE = D.DOCCODE AND S.SLPNO = '"+slipNo+"'");
	
	System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getSubReportData(String slipNo) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT TO_CHAR(STNTDATE, 'DD-MM-YYYY') AS STNTDATE,AMOUNT,DESCRIPTION FROM (");
	sqlStr.append("SELECT TB.STNTDATE, SUM(TB.STNNAMT) AMOUNT, TB.DESCRIPTION ");
	sqlStr.append("FROM (SELECT ST.STNTDATE STNTDATE, ST.STNNAMT, ");
	sqlStr.append("DECODE(ST.STNRLVL, 1, DPS.DSCDESC, 2, DP.DPTNAME, 3, ST.STNDESC, 4, PK.PKGNAME, NULL) DESCRIPTION ");
	sqlStr.append("FROM SLIPTX@IWeb ST, DPSERV@IWeb DPS, DEPT@IWeb DP, PACKAGE@IWeb PK ");
	sqlStr.append("WHERE ST.DSCCODE = DPS.DSCCODE(+) ");
	sqlStr.append("AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+) AND ST.PKGCODE = PK.PKGCODE(+) ");
	sqlStr.append("AND ST.SLPNO IN ('"+slipNo+"') AND ST.STNSTS IN ('N', 'A') ");
	sqlStr.append("AND ST.STNTYPE IN ('S', 'R') AND ST.STNRLVL <> 3) TB ");
	sqlStr.append("GROUP BY TB.STNTDATE, TB.DESCRIPTION ");
	sqlStr.append("UNION ALL ");
	sqlStr.append("SELECT * ");
	sqlStr.append("FROM (SELECT ST.STNTDATE, ST.STNNAMT AS AMOUNT, ");
	sqlStr.append("DECODE(ST.STNRLVL, 1, DPS.DSCDESC, 2, DP.DPTNAME, 3, ST.STNDESC, 4, PK.PKGNAME, NULL) DESCRIPTION ");
	sqlStr.append("FROM SLIPTX@IWeb ST, DPSERV@IWeb DPS, DEPT@IWeb DP, PACKAGE@IWeb PK ");
	sqlStr.append("WHERE ST.DSCCODE = DPS.DSCCODE(+) AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+) ");
	sqlStr.append("AND ST.PKGCODE = PK.PKGCODE(+) AND ST.SLPNO IN ('"+slipNo+"') ");
	sqlStr.append("AND ST.STNSTS IN ('N', 'A') AND ST.STNTYPE IN ('S', 'R') AND ST.STNRLVL = 3) TB2) ORDER BY STNTDATE ");

	System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

%>

<%
UserBean userBean = new UserBean(request);

if (userBean == null || !userBean.isLogin()) {
	%><jsp:forward page="../patient/index.jsp" /><%
}
else {
	String slipNo = request.getParameter("slipNo");
	
	ArrayList record = getMainReportData(slipNo);
	ReportableListObject row = null;
	
	if (record.size() > 0) {
		/*	for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				for(int j = 0; j < row.getSize(); j++) {
					System.out.println(row.getValue(j));
				}
			}*/
		File reportFile = new File(application.getRealPath("/report/IPReceipt.jasper"));
		File subReportFile = new File(application.getRealPath("/report/IPReceipt_Sub.jasper"));
		if (reportFile.exists() && subReportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
			File reportDir = new File(application.getRealPath("/report/"));
	
			Map parameters = new HashMap();
			parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
			parameters.put("P_SLPNO", slipNo);
			parameters.put("ALLSLPNO", slipNo);
			parameters.put("ISCOPY", "COPY");
			parameters.put("SubDataSource", 
					new ReportMapDataSource(getSubReportData(slipNo), new String[]{"STNTDATE","AMOUNT","DESCRIPTION"}, new boolean[]{false,true,false}));
			
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport,
					parameters,
					new ReportMapDataSource(record, new String[]{"PATNAME","PATCNAME","SLPNO","PATNO","REGDATE","REGTIME","BEDACM","INPDDATE","INPDTIME","DOCNAME","DOCCNAME"},
							null));
			
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/pdf");
			JRPdfExporter exporter = new JRPdfExporter();
	        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	
	        exporter.exportReport();
			return;
		}
	}
}
%>