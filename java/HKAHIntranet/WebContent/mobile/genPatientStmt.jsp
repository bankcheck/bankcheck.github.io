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
private ArrayList getIPSubDetails(String slpNo) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT STNTDATE, STNBAMT, STNNAMT, DESCRIPTION, QTY, DSCCODE, ITMFLAG,  ");
	sqlStr.append(" CDESCCODE, STNTYPE, ITMTYPE, STNRLVL, DPTCODE, PKGCODE  ");	
	sqlStr.append("FROM SLIPTX_STATEMENT@IWEB ");
	sqlStr.append("WHERE SLPNO IN ('" +slpNo+"')" ); 
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

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
	
	private ReportMapDataSource getSubRptDataSource(String encodedFileName,String[] inparam, String[] label, boolean[] isNumericColumn) {
		ReportMapDataSource dataSrc = new  ReportMapDataSource(UtilDBWeb.getFunctionResultsHATS("NHS_RPT_" + encodedFileName.toUpperCase(), inparam), label, isNumericColumn);
		
		return dataSrc;
	}
	
	private ReportMapDataSource getSubRptDataSource(String slpNo, String[] label) {
		ReportMapDataSource dataSrc = new  ReportMapDataSource(getIPSubDetails(slpNo), label);
		
		return dataSrc;
	}
	
	private Map getIPStatementParamSet(String reportDirectory, String slip, String lang, String imgDir) {
		Map map = new HashMap();
		map.put("SUBREPORT_DIR", reportDirectory + "\\");
		map.put("P_SLPNO", slip );
		map.put("ISCOPY", "Y");
		map.put("watermark", imgDir+"\\"+"app_watermark.gif");

		map.put("ALLSLPNO", slip );
		
		addRequiredReportDesc(initRptDescMap(),map,
				new String[] {
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage"
				},
				new String[] {
						"StaOfAut", "AdmDtTime", "PatName", "DisDtTime",
						"TreDr", "BillNo", "PatNo", "BedNo", "Copy",
						"Page", "Date", "Item", "Amount", "TotChg",
						"TotRfd", "Balance", "patM", "patB", "BirthDt",
						"DelDr"
				},
				lang);

		
  		map.put("SubDataSource1",
  				getSubRptDataSource("IPSTATEMENT_SUB1", new String[] {"'"+slip+"'",""}, 
 						new String[] {"STNTDATE","AMOUNT","DESCRIPTION","QTY","TOTALREFUND","TOTALCHARGE", "CDESCCODE"}, null));
 						


		return map;
	}
	
	private Map getIPChrgSmyParamSet(String reportDirectory, String slip, String lang, String imgDir) {
		Map map = new HashMap();
		map.put("SUBREPORT_DIR", reportDirectory + "\\");
		map.put("P_SLPNO", slip );
		map.put("ISCOPY", "Y");
		map.put("watermark", imgDir+"\\"+"app_watermark.gif");


		addRequiredReportDesc(initRptDescMap(),map,
				new String[] {
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage"
					},
					new String[] {
							"TotChgTtl", "Copy", "BillNo", "BedNo", "DisDtTime",
							"PatName", "TreDr", "AdmDtTime", "PatNo", "Page",
							"SpecialFee", "DocCredit", "Credits", "HosCharge",
							"DocCharge", "HosCredit", "Charges", "Refund",
							"SpecialSrv", "Packages", "Balance"
					},
				lang);

		
  		map.put("SubDataSource",
  				getSubRptDataSource("CHRGSMY_SUB", new String[] {"'"+slip+"'",""}, 
 						new String[] {"DESCRIPTION","QTY","AMOUNT","STNTYPE","ITMTYPE","DOCCODE", "DOCNAME", "DOCCNAME", "CDESCCODE"},
 						new boolean[]{false, true, false, false, false,false, false, false, false} ));
 						


		return map;
	}
	
	
%><%
UserBean userBean = new UserBean(request);
String slpNo = request.getParameter("slpNo");
String slpType = request.getParameter("slpType");
String lang = request.getParameter("lang");
String billID = request.getParameter("billID");
JasperPrint jasperPrint = null;
JasperPrint jasperPrintChrgSmy = null;


ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
File reportDir = new File(application.getRealPath("/report/"));
File imgDir = new File(application.getRealPath("/images/"));


  jasperPrint = getJasperReport(application, "IPStatementAPP", getIPStatementParamSet(reportDir.getPath(),
			slpNo,lang,imgDir.getPath()), 
			new String[] {slpNo}, new String[] {
					"PATNAME", "PATCNAME" ,"SLPNO", "PATNO",
					"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
					"INPDTIME", "DOCNAME", "DOCCNAME"
			});

  jasperPrintChrgSmy = getJasperReport(application, "ChrgSmyAPP", getIPChrgSmyParamSet(reportDir.getPath(),
			slpNo,lang,imgDir.getPath()), 
			new String[] {slpNo}, new String[] {"PATNAME", "PATCNAME", "SLPNO", "PATNO", "REGDATE", "REGTIME", "BEDACM", "INPDDATE","INPDTIME", "DOCNAME", "DOCCNAME"});
  
    if (jasperPrintChrgSmy.getPages().size() > 0 ) {
	  List<JRPrintPage> pages = jasperPrintChrgSmy.getPages();
	  for (JRPrintPage jpp : pages) {
		  jasperPrint.addPage(jpp);
	  }
  } 
  
	String outputFilePath = getSystemParameter("ABillPath").replace("\\","\\\\")+"\\billNo_"+billID+".pdf";

    JasperExportManager.exportReportToPdfFile(jasperPrint, outputFilePath);

	return;

%>