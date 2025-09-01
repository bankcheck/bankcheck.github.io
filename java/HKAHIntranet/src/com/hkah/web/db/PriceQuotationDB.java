package com.hkah.web.db;

import java.util.ArrayList;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;

public class PriceQuotationDB {
	public static ArrayList fetchClass() {
		return UtilDBWeb.getReportableListHATS("SELECT ACMCODE, ACMNAME FROM FIN_ACM ORDER BY SORT");
	}
	
	public static ArrayList getQuotation(String regid, String patno) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_GET_PQUOTATION", new String[] { regid, patno });
	}
	
	public static ArrayList getPreviousQuotation(String pqId) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_GET_PQUOTATION_ITEM", new String[] { pqId });
	}
	
	public static ArrayList getPrintReport(String pqId) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_RPT_PQUOTATION", new String[] {  pqId });
	}
	
	public static ArrayList currentItem(String category, String patType, String itmCode, String option, String pqItmPrefix, String contrast, String timeslot) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_GET_QUOTATIONITEM", new String[] {category,  patType,  itmCode,  option, pqItmPrefix, contrast, timeslot});
	}
	
	public static String insertNewQuotation(String regid, String docCode, String patno, String version, String userid, String selectItem, String source){
		ArrayList record = new ArrayList();
		String pqId = null;
		record = UtilDBWeb.getFunctionResultsHATS("NHS_ACT_CREATE_PQ", new String[] {"ADD", regid, patno, docCode, version, userid, selectItem, source});
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			pqId = row.getValue(0);
		}
		return pqId;
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
		return getMenu(null,null);
	}
	public static ArrayList getMenu(String pqCategory) {
		return getMenu(pqCategory, null);
	}
	
	public static ArrayList getMenu(String pqCategory, String group) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DSCCODE, DSCDESC  "); 
		sqlStr.append("FROM PQMENU ");
		sqlStr.append("WHERE ENABLED = '1' ");
		sqlStr.append("AND MODULE IN ('PQ' ");
		if("OT".equals(group)) 
			sqlStr.append(", 'OT' ");
		sqlStr.append(") ");
		if(pqCategory != null) 
			sqlStr.append("AND DSCCODE = '" + pqCategory + "' ");
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
		if(itmcode != null)
			sqlStr.append("AND ITMCODE = '" + itmcode + "' ");
		sqlStr.append("AND ENABLED = '1' ");
		sqlStr.append("ORDER BY TIMESLOT DESC ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}
	
	public static ArrayList getItem(String category) {
		return getItem(category, null);
	}
	
	public static ArrayList getItem(String category, String itmType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ITMCODE, ITMDESC, ITMTYPE "); 
		sqlStr.append("FROM PQITEM ");
		sqlStr.append("WHERE PQCATEGORY = '" + category + "' ");
		if(itmType != null) 
			sqlStr.append("AND ITMTYPE = '" + itmType + "' ");
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
	
	public static ArrayList getPrintInfo(String pqId) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT P.PQID, P.VERSION, TO_CHAR(P.CREATEDATE,'DD-MM-YYYY'), SUM(X.PQAMT) ");
		sqlStr.append("FROM PQUOTATION P, PQTX X ");
		sqlStr.append("WHERE P.PQID = X.PQID ");
		sqlStr.append("AND X.ENABLED = '1' ");
		sqlStr.append("AND P.PQID = '" + pqId + "' ");
		sqlStr.append("GROUP BY P.PQID, P.VERSION, TO_CHAR(P.CREATEDATE,'DD-MM-YYYY') ");
		return UtilDBWeb.getReportableListHATS(sqlStr.toString()); 
	}
}
