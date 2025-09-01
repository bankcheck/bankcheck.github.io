package com.hkah.web.db;

import java.util.ArrayList;
import java.util.Map;

import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;

public class DoctorChargeDB {
	public static ArrayList fetchClass() {
		return UtilDBWeb.getReportableListHATS("SELECT ACMCODE, ACMNAME FROM FIN_ACM ORDER BY SORT");
	}
	
	public static ArrayList getRegInfo(String regid) {
		return UtilDBWeb.getReportableListHATS("SELECT SLPNO FROM REG WHERE REGID ='"+regid+"'");
	}
	
	public static ArrayList getDrProcCharge(String regid, String patno) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_GET_DPCHARGE", new String[] { regid, patno });
	}
	
	public static ArrayList getPreviousCharge(String dpcid) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_GET_DPCHARGE_ITEM", new String[] { dpcid });
	}
	
	public static ArrayList getPrintReport(String dpcid, String printOpt) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_RPT_DPCHARGE", new String[] {  dpcid, printOpt });
	}
	
	public static ArrayList getPrintReportFromPortal(String dpcid,String selectItem, String patNo, String docCode, String slpNo) {
		return UtilDBWeb.getFunctionResults("NHS_RPT_DPCHARGE_PORTALBK", new String[] {  dpcid, selectItem, patNo, docCode, slpNo });
	}
	
/*	public static ArrayList currentItem(String category, String patType, String itmCode, String option, String pqItmPrefix, String contrast, String timeslot) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_GET_QUOTATIONITEM", new String[] {category,  patType,  itmCode,  option, pqItmPrefix, contrast, timeslot});
	}*/
	
	public static ArrayList currentItem(String slpNo, String patType, String itmCode, String docCode, String acmCode, String unit, String usrid) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_GET_ITEMCHG", new String[] {"ADD",slpNo,patType,DateTimeUtil.getCurrentDate(),itmCode,docCode,"","1","0","0","0","-1","TWAH", "N", "0.0",""});
	}

	public static String addToHATS(String regid, String docCode, String patno, String dpcid, String slpNo, String userid){
		ArrayList record = new ArrayList();
		String result = null;
		record = UtilDBWeb.getFunctionResultsHATS("NHS_ACT_DRCHARGE_ADDHAT1", new String[] {
					docCode, dpcid, regid, slpNo, userid,getComputerName()});
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			result = row.getValue(0);
		}
		return result;
	}
	
	public static String insertCharge(String regid, String docCode, String patno, String version, String userid, String selectItem, String source){
		ArrayList record = new ArrayList();
		String dpcid = null;
		record = UtilDBWeb.getFunctionResultsHATS("NHS_ACT_CREATE_DPC", new String[] {"ADD", regid, patno, docCode, version, userid, selectItem, source});
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			dpcid = row.getValue(0);
		}
		return dpcid;
	}
	
	public static String insertFavor(String userid, String selectedItems){
		ArrayList record = new ArrayList();
		String success = "-1";
		record = UtilDBWeb.getFunctionResultsHATS("NHS_ACT_PQFAVOR", new String[] { "ADD", userid, selectedItems });
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			success = row.getValue(0);
		}
		return success;
	}
	
	public static ArrayList getPatInfo(String regid) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT R.PATNO, D.DOCCODE, D.DOCFNAME "); 
		sqlStr.append("FROM REG R, DOCTOR D ");
		sqlStr.append("WHERE R.DOCCODE = D.DOCCODE ");
		sqlStr.append("AND R.REGID = '" + regid + "' ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}
	
	public static ArrayList getMenu() {
		return getMenu(null);
	}
	
	public static ArrayList getMenu(String pqCategory) {
		return getMenu(pqCategory,"drProcChg");
	}
	
	public static ArrayList getMenu(String pqCategory,String module) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DSCCODE, DSCDESC  "); 
		sqlStr.append("FROM PQMENU ");
		sqlStr.append("WHERE ENABLED = '1' ");
		if(pqCategory != null) { 
			sqlStr.append("AND DSCCODE = '" + pqCategory + "' ");
		}
		if (module != null) {
			sqlStr.append("AND MODULE = '" + module + "'");
		}
		sqlStr.append("ORDER BY DSCDESC ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}
	
	public static ArrayList getFavorList(String userid) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT LISTAGG(PQBOX,',') WITHIN GROUP (ORDER BY DOCCODE) "); 
		sqlStr.append("FROM PQFAVOR ");
		sqlStr.append("WHERE DOCCODE = '" + userid + "' ");
		sqlStr.append("AND ENABLED = '1' ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}
	
	public static ArrayList getOption(String category) {
		return getOption(category, null);
	}
	public static ArrayList getOption(String category, String itmcode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT INITCAP(OPTDESC), ITMPREFIX, PKGPREFIX, TIMESLOT "); 
		sqlStr.append("FROM PQCATEGORY ");
		sqlStr.append("WHERE PQCATEGORY = '" + category + "' ");
		if(itmcode != null) {
			sqlStr.append("AND ITMCODE = '" + itmcode + "' ");
		}
		sqlStr.append("AND ENABLED = '1' ");
		sqlStr.append("ORDER BY TIMESLOT DESC ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}
	
	public static ArrayList getItem(String category) {
		return getItem(category, null);
	}
	
	public static ArrayList getItem(String category, String itmType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ITMCODE, ITMDESC, ITMTYPE, MAXUNIT "); 
		sqlStr.append("FROM PQITEM ");
		sqlStr.append("WHERE PQCATEGORY = '" + category + "' ");
		if(itmType != null) {
			sqlStr.append("AND ITMTYPE = '" + itmType + "' ");
		}
		sqlStr.append("AND ENABLED = '1' ");
		sqlStr.append("ORDER BY ITMDESC, ITMCODE ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}
	
	public static ArrayList getItemType(String category) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PQCATEGORY, TYPECODE, TYPEDESC "); 
		sqlStr.append("FROM PQTYPE ");
		sqlStr.append("WHERE PQCATEGORY = '" + category + "' ");
		sqlStr.append("ORDER BY TYPEORDER ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}
	
	public static ArrayList getPrintInfo(String dpcid) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DP.DPCID,DP.PATNO, P.PATFNAME||' '||P.PATGNAME, D.DOCFNAME||' '||D.DOCGNAME, R.SLPNO, TO_CHAR(DP.CREATEDATE,'DD/MM/YYYY'), 'ERROR', DP.VERSION ");
		sqlStr.append("FROM DPCHARGE DP, PATIENT P, DOCTOR D, REG R ");
		sqlStr.append("WHERE DP.PATNO = P.PATNO ");
		sqlStr.append("AND DP.DOCCODE = D.DOCCODE ");
		sqlStr.append("AND DP.REGID = R.REGID ");
		sqlStr.append("AND DP.DPCID = '" + dpcid + "' ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString()); 
	}
	
	private static String getComputerName()
	{
	    Map<String, String> env = System.getenv();
	    if (env.containsKey("COMPUTERNAME"))
	        return env.get("COMPUTERNAME");
	    else if (env.containsKey("HOSTNAME"))
	        return env.get("HOSTNAME");
	    else
	        return "Unknown Computer";
	}
}
