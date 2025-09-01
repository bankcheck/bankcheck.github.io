<%@ page language="java" contentType="text/html; charset=utf-8" %>
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
<%@ page import="com.hkah.config.MessageResources" %>

<%!

private ArrayList getMainReportData(String slipNo) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT S.SLPNO AS SLPNO, ");
	sqlStr.append("P.PATNO, ");
	sqlStr.append("DECODE(S.SLPFNAME, ");
	sqlStr.append("       NULL, ");
	sqlStr.append("       P.PATFNAME || ' ' || P.PATGNAME, ");
	sqlStr.append("       S.SLPFNAME || ' ' || S.SLPGNAME) AS PATNAME, ");
	sqlStr.append("P.PATCNAME, ");
	sqlStr.append("D.DOCFNAME || ' ' || D.DOCGNAME AS DOCNAME, ");
	sqlStr.append("D.DOCCNAME ");
	sqlStr.append("FROM SLIP@IWEB S, PATIENT@IWEB P, DOCTOR@IWEB D ");
	sqlStr.append("WHERE S.PATNO = P.PATNO(+) ");
	sqlStr.append("AND S.DOCCODE = D.DOCCODE(+) ");
	sqlStr.append("AND S.SLPNO = '"+slipNo+"'");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getSubReportData(String slipNo) {
	StringBuffer mainSql = new StringBuffer();
	StringBuffer sqlStr = new StringBuffer();

	mainSql.append("SELECT ST.STNTDATE STNTDATE, ");
	mainSql.append("ST.STNBAMT, ");
	mainSql.append("DECODE(ST.STNRLVL, ");
	mainSql.append("1, ");
	mainSql.append("DPS.DSCDESC||'  '||DPS.DSCCDESC, ");
	mainSql.append("2, ");
	mainSql.append("DP.DPTNAME||'  '||DP.DPTCNAME, ");
	mainSql.append("3, ");
	mainSql.append("ST.STNDESC || ' ' || ST.STNDESC1, ");
	mainSql.append("4, ");
	mainSql.append("PK.PKGNAME||CPK.PKGNAME||' '||PK.PKGCNAME||CPK.PKGCNAME, ");
	mainSql.append("5, ");
	mainSql.append("PK.PKGNAME||CPK.PKGNAME||' '||PK.PKGCNAME||CPK.PKGCNAME, ");
	mainSql.append("6, ");
	mainSql.append("DPS.DSCDESC||' '||ST.STNDESC||'  '||DPS.DSCCDESC||' '||ST.STNDESC1, ");
	mainSql.append("7, ");
	mainSql.append("PK.PKGNAME||CPK.PKGNAME||' '||PK.PKGCNAME||CPK.PKGCNAME, ");
	mainSql.append("NULL) DESCRIPTION, ");
	mainSql.append("ST.UNIT AS QTY, ");
	mainSql.append("DECODE(ST.STNRLVL,4,NULL,7,NULL,ST.DSCCODE) AS DSCCODE, ");
	mainSql.append("DECODE(ST.STNTYPE,'D','A','I','A','O','A','X','A','B') AS ITMFLAG, ");
	mainSql.append("DECODE(ST.STNRLVL, 1, 'DEPSERVICE.'||DPS.DSCCODE, ");
	mainSql.append("2, 'DEPARTMENT.'||DP.DPTCODE, 3, 'ITEM.'||ST.ITMCODE, ");
	mainSql.append("4, 'PACKAGE.'||PK.PKGCODE, 5, 'PACKAGE.'||PK.PKGCODE, ");
	mainSql.append("6, 'DEPSERVICE.'||DPS.DSCCODE||' '||'ITEM.'||ST.ITMCODE, ");
	mainSql.append("7, 'PACKAGE.'||PK.PKGCODE ) AS CDESCCODE ");
	mainSql.append("FROM SLIPTX@IWEB ST, DPSERV@IWEB DPS, DEPT@IWEB DP, PACKAGE@IWEB PK,CREDITPKG@IWEB CPK ");
	mainSql.append("WHERE ST.DSCCODE = DPS.DSCCODE(+) ");
	mainSql.append("AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+) ");
	mainSql.append("AND ST.PKGCODE = PK.PKGCODE(+) ");
	mainSql.append("AND ST.PKGCODE = CPK.PKGCODE(+) ");
	mainSql.append("AND ST.STNSTS IN ('N', 'A') ");
	mainSql.append("AND ST.SLPNO = '"+slipNo+"' ");
	
	sqlStr.append("SELECT TO_CHAR(STNTDATE, 'DD/MM/YYYY') AS STNTDATE,AMOUNT,DESCRIPTION,QTY, ");
	sqlStr.append("ITMFLAG, CDESCCODE FROM ( ");
	sqlStr.append("(SELECT TB.STNTDATE, SUM(TB.STNBAMT) AMOUNT, TB.DESCRIPTION,1 AS QTY,TB.ITMFLAG,TB.CDESCCODE ");
	sqlStr.append("  FROM (  ");
	sqlStr.append(mainSql.toString());
	sqlStr.append("           AND ST.STNRLVL NOT IN (3,6)) TB ");
	sqlStr.append("  GROUP BY STNTDATE, DESCRIPTION ,ITMFLAG,DSCCODE, CDESCCODE) ");
	sqlStr.append("UNION ALL ");
	sqlStr.append("(SELECT TB2.STNTDATE, TB2.STNBAMT AMOUNT, TB2.DESCRIPTION,TB2.QTY,TB2.ITMFLAG,TB2.CDESCCODE ");
	sqlStr.append("  FROM (  ");
	sqlStr.append(mainSql.toString());
	sqlStr.append("           AND ST.STNRLVL IN (3,6)) TB2)) ");
	sqlStr.append("ORDER BY ITMFLAG,STNTDATE ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

%>

<%
UserBean userBean = new UserBean(request);

if (userBean == null || !userBean.isLogin()) {
	%><jsp:forward page="../patient/login.jsp" /><%
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
		File reportFile = new File(application.getRealPath("/report/OPStatement.jasper"));
		File subReportFile = new File(application.getRealPath("/report/OPStatement_Sub.jasper"));
		if (reportFile.exists() && subReportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
			File reportDir = new File(application.getRealPath("/report/"));
	
			Map parameters = new HashMap();
			parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
			parameters.put("P_SLPNO", slipNo);
			parameters.put("ISCOPY", "COPY 副本");
			//parameters.put("DESC_PNAME", "測試");
			parameters.put("SubDataSource", 
					new ReportMapDataSource(getSubReportData(slipNo), new String[]{"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "ITMFLAG", "CDESCCODE"},
							new boolean[]{false, true, false, true, false, false}) {
				public Object getFieldValue(int index) throws JRException {
					String descValue = (String) super.getFieldValue(index);
					String cdescKey = (String) super.getFieldValue(5);

					if (index == 2) {
						if (cdescKey != null && cdescKey.length() > 0) {
							//System.out.println("------------------");
							//System.out.println(cdescKey);
							String[] cdescKeys = cdescKey.split(" ");
							
							for (int i = 0; i < cdescKeys.length; i++) {
								String cdescValue = MessageResources.getMessageTraditionalChinese(cdescKeys[i].trim());
								if (!cdescValue.equals(cdescKeys[i])) {
									descValue = descValue + " " + cdescValue;
								}
							}
							
							//System.out.println(descValue);
						}
					}
					
					return descValue;
				}
			});
			
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport,
					parameters,
					new ReportMapDataSource(record, new String[]{"SLPNO","PATNO","PATNAME","PATCNAME","DOCNAME","DOCCNAME"},
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