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
	
	sqlStr.append("SELECT NVL(S.SLPFNAME, P.PATFNAME) || ' ' || NVL(S.SLPGNAME, P.PATGNAME) AS PATNAME, ");
	sqlStr.append("P.PATCNAME, S.SLPNO, P.PATNO, TO_CHAR(R.REGDATE, 'DD-MON-YYYY','nls_date_language=ENGLISH') AS REGDATE, ");
	sqlStr.append("TO_CHAR(R.REGDATE, 'HH24:MI') AS REGTIME, I.BEDCODE || '-' || I.ACMCODE AS BEDACM, ");
	sqlStr.append("TO_CHAR(I.INPDDATE, 'DD-MON-YYYY','nls_date_language=ENGLISH') AS INPDDATE, TO_CHAR(I.INPDDATE, 'HH24:MI') AS INPDTIME, ");
	sqlStr.append("D.DOCFNAME || ' ' || D.DOCGNAME AS DOCNAME, D.DOCCNAME ");
	sqlStr.append("FROM SLIP@IWEB S, PATIENT@IWEB P, REG@IWEB R, INPAT@IWEB I, DOCTOR@IWEB D ");
	sqlStr.append("WHERE S.REGID = R.REGID AND S.PATNO = P.PATNO(+) AND R.INPID = I.INPID(+) ");
	sqlStr.append("AND S.DOCCODE = D.DOCCODE AND S.SLPNO = '"+slipNo+"'");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getSubReportData(String slipNo) {
	StringBuffer mainSql = new StringBuffer();
	StringBuffer sqlStr = new StringBuffer();

	mainSql.append("SELECT ST.STNNAMT, ST.STNBAMT, UPPER(DECODE(ST.STNRLVL, 1, DPS.DSCDESC||'  '||DPS.DSCCDESC, 2, ");
	mainSql.append("DP.DPTNAME||'  '||DP.DPTCNAME, 3, ST.STNDESC || ' ' || ST.STNDESC1, 4, ");
	mainSql.append("PK.PKGNAME||CPK.PKGNAME||' '||PK.PKGCNAME||CPK.PKGCNAME, 5, ");
	mainSql.append("PK.PKGNAME||CPK.PKGNAME||' '||PK.PKGCNAME||CPK.PKGCNAME, 6, ");
	mainSql.append("DPS.DSCDESC||' '||ST.STNDESC||'  '||DPS.DSCCDESC||' '||ST.STNDESC1, 7, ");
	mainSql.append("PK.PKGNAME||CPK.PKGNAME||' '||PK.PKGCNAME||CPK.PKGCNAME, NULL)) DESCRIPTION, ");
	mainSql.append("ST.UNIT AS QTY, DECODE(ST.STNRLVL,5,'D',4,'W',ST.ITMTYPE) AS ITMTYPE, ");
	mainSql.append("DECODE(ST.STNRLVL,4,'D',ST.STNTYPE) AS STNTYPE, ");
	mainSql.append("DECODE(ST.STNRLVL,4,NULL,7,NULL,DPS.DSCCODE) AS DSCCODE, ");
	mainSql.append("CASE WHEN ST.STNRLVL=4 THEN NULL  WHEN ST.ITMTYPE<>'D' THEN NULL ");
	mainSql.append("ELSE ST.DOCCODE END AS DOCCODE, ");
	mainSql.append("DECODE(ST.STNRLVL, 1, 'DEPSERVICE.'||DPS.DSCCODE, ");
	mainSql.append("2, 'DEPARTMENT.'||DP.DPTCODE, 3, 'ITEM.'||ST.ITMCODE, ");
	mainSql.append("4, 'PACKAGE.'||PK.PKGCODE, 5, 'PACKAGE.'||PK.PKGCODE, ");
	mainSql.append("6, 'DEPSERVICE.'||DPS.DSCCODE||' '||'ITEM.'||ST.ITMCODE, ");
	mainSql.append("7, 'PACKAGE.'||PK.PKGCODE ) AS CDESCCODE ");
	mainSql.append("FROM SLIPTX@IWEB ST, DPSERV@IWEB DPS, DEPT@IWEB DP, PACKAGE@IWEB PK,CREDITPKG@IWEB CPK ");
	mainSql.append("WHERE ST.DSCCODE = DPS.DSCCODE(+) AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+) ");
	mainSql.append("AND ST.PKGCODE = PK.PKGCODE(+) AND ST.PKGCODE = CPK.PKGCODE(+) ");
	mainSql.append("AND ST.STNSTS IN ('N', 'A') AND ST.STNTYPE NOT IN ('S', 'R') ");
	mainSql.append("AND ST.SLPNO IN ('"+slipNo+"') ");
	
	sqlStr.append("SELECT * ");
	sqlStr.append("FROM ( ");
	sqlStr.append("SELECT DESCRIPTION,QTY,AMOUNT,STNTYPE,ITMTYPE,T.DOCCODE, ");
	sqlStr.append("D.DOCFNAME||' '||D.DOCGNAME||' '||D.DOCCNAME AS DOCNAME, CDESCCODE ");
	sqlStr.append("FROM ( ");
	sqlStr.append("SELECT  SUM(TB.STNBAMT) AMOUNT, TB.DESCRIPTION,1 AS QTY,STNTYPE,ITMTYPE,DOCCODE,DSCCODE, MAX(CDESCCODE) CDESCCODE ");
	sqlStr.append("FROM ( ");
	sqlStr.append(mainSql.toString());
	sqlStr.append("AND ST.STNTYPE <> 'R' AND ST.STNRLVL NOT IN (3,6) ");
	sqlStr.append("AND ST.STNTDATE <= TO_DATE(TO_CHAR(SYSDATE-1, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')) TB ");
	sqlStr.append("GROUP BY STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION ");
	sqlStr.append("UNION ALL ");
	sqlStr.append("SELECT SUM(TB2.STNBAMT) AMOUNT, TB2.DESCRIPTION,SUM(QTY) QTY,STNTYPE,ITMTYPE,DOCCODE,DSCCODE, MAX(CDESCCODE) CDESCCODE ");
	sqlStr.append("FROM ( ");
	sqlStr.append(mainSql.toString());
	sqlStr.append("AND ST.STNTYPE <> 'R' AND ST.STNRLVL IN (3,6) ");
	sqlStr.append("AND ST.STNTDATE <= TO_DATE(TO_CHAR(SYSDATE-1, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')) TB2 ");
	sqlStr.append("GROUP BY  STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION ");
	
	sqlStr.append("UNION ALL ");
	sqlStr.append("SELECT SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, ");
	sqlStr.append("DSCCODE, CDESCCODE ");
	sqlStr.append("FROM ( ");
	sqlStr.append("SELECT SUM(TB4.STNNAMT - TB4.STNBAMT) AMOUNT, 'DOCTOR DISCOUNT' AS DESCRIPTION ,1 AS QTY, ");
	sqlStr.append("'C' AS STNTYPE,'D' AS ITMTYPE,'' AS DOCCODE,'' AS DSCCODE, 'MAPLANGUAGE.DocDis' AS CDESCCODE ");
	sqlStr.append("FROM ( ");
	sqlStr.append(mainSql.toString());
	sqlStr.append(") TB4 ");
	sqlStr.append("WHERE STNTYPE IN ('D', 'O') ");
	sqlStr.append("AND ITMTYPE = 'D' ");
	sqlStr.append("GROUP BY  STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION ");
	sqlStr.append(") ");
	sqlStr.append("WHERE AMOUNT <> 0 ");
	sqlStr.append("GROUP BY  DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE ");
	
	sqlStr.append("UNION ALL ");
	sqlStr.append("SELECT SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, ");
	sqlStr.append("DSCCODE, CDESCCODE ");
	sqlStr.append("FROM ( ");
	sqlStr.append("SELECT SUM(TB3.STNNAMT - TB3.STNBAMT) AMOUNT, 'HOSPITAL DISCOUNT' AS DESCRIPTION ,1 AS QTY, ");
	sqlStr.append("'C' AS STNTYPE,'H' AS ITMTYPE,'' AS DOCCODE,'' AS DSCCODE, 'MAPLANGUAGE.HosDis' AS CDESCCODE ");
	sqlStr.append("FROM ( ");
	sqlStr.append(mainSql.toString());
	sqlStr.append(") TB3 ");
	sqlStr.append("WHERE STNTYPE IN ('D', 'O') ");
	sqlStr.append("AND ITMTYPE = 'H' ");
	sqlStr.append("GROUP BY  STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION ");
	sqlStr.append(") ");
	sqlStr.append("WHERE AMOUNT <> 0 ");
	sqlStr.append("GROUP BY  DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE ");
	
	sqlStr.append("UNION ALL ");
	sqlStr.append("SELECT SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, ");
	sqlStr.append("DSCCODE, CDESCCODE ");
	sqlStr.append("FROM ( ");
	sqlStr.append("SELECT SUM(TB5.STNNAMT - TB5.STNBAMT) AMOUNT, 'SPECIAL DISCOUNT' AS DESCRIPTION ,1 AS QTY, ");
	sqlStr.append("'C' AS STNTYPE,'S' AS ITMTYPE,'' AS DOCCODE,'' AS DSCCODE, 'MAPLANGUAGE.SpcDis' AS CDESCCODE ");
	sqlStr.append("FROM ( ");
	sqlStr.append(mainSql.toString());
	sqlStr.append(") TB5 ");
	sqlStr.append("WHERE STNTYPE IN ('D', 'O') ");
	sqlStr.append("AND ITMTYPE = 'S' ");
	sqlStr.append("GROUP BY  STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION ");
	sqlStr.append(") ");
	sqlStr.append("WHERE AMOUNT <> 0 ");
	sqlStr.append("GROUP BY  DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE ");
	
	sqlStr.append("UNION ALL ");
	sqlStr.append("SELECT SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, ");
	sqlStr.append("DSCCODE, CDESCCODE ");
	sqlStr.append("FROM ( ");
	sqlStr.append("SELECT SUM(TB6.STNNAMT - TB6.STNBAMT) AMOUNT, 'OTHER DISCOUNT' AS DESCRIPTION ,1 AS QTY, ");
	sqlStr.append("'C' AS STNTYPE,'O' AS ITMTYPE,'' AS DOCCODE,'' AS DSCCODE, 'MAPLANGUAGE.OthDis' AS CDESCCODE ");
	sqlStr.append("FROM ( ");
	sqlStr.append(mainSql.toString());
	sqlStr.append(") TB6 ");
	sqlStr.append("WHERE STNTYPE IN ('D', 'O') ");
	sqlStr.append("AND ITMTYPE = 'O' ");
	sqlStr.append("GROUP BY  STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION ");
	sqlStr.append(") ");
	sqlStr.append("WHERE AMOUNT <> 0 ");
	sqlStr.append("GROUP BY  DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE ");
	
	sqlStr.append(") T,DOCTOR@IWEB D ");
	sqlStr.append("WHERE T.DOCCODE=D.DOCCODE(+) ");
	sqlStr.append(") ");
	sqlStr.append("ORDER BY DECODE(STNTYPE, 'D', 1, 'O', 2, 'R', 3, 'C', 4, 'S', 5, 'I', 6, 'P', 7, 8), ITMTYPE, DOCCODE, DESCRIPTION ");
	
	
	System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

%>

<%
UserBean userBean = new UserBean(request);

if (userBean == null || !userBean.isLogin()) {
	%><jsp:forward page="../patient/login.jsp" /> <%
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
		File reportFile = new File(application.getRealPath("/report/ChrgSmy.jasper"));
		File subReportFile = new File(application.getRealPath("/report/ChrgDayCase_Sub.jasper"));
		if (reportFile.exists() && subReportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
			File reportDir = new File(application.getRealPath("/report/"));
	
			Map parameters = new HashMap();
			parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
			parameters.put("P_SLPNO", slipNo);
			parameters.put("ALLSLPNO", slipNo);
			parameters.put("ISCOPY", "COPY 副本");
			//parameters.put("DESC_PNAME", "測試");
			parameters.put("SubDataSource", 
					new ReportMapDataSource(getSubReportData(slipNo), new String[]{"DESCRIPTION", "QTY", "AMOUNT", "STNTYPE", "ITMTYPE", "DOCCODE", "DOCNAME", "CDESCCODE"},
							new boolean[]{false, true, true, false, false, false, false, false}) {
				public Object getFieldValue(int index) throws JRException {
					String descValue = (String) super.getFieldValue(index);
					String cdescKey = (String) super.getFieldValue(7);

					if (index == 0) {
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