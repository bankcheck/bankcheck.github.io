package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class PanelDoctorDB {
	private static String sqlStr_insertARtoDoc = null;
	private static String sqlStr_insertDoctoAR = null;
	private static String sqlStr_deleteARfromDoc = null;

	public static ArrayList getArList() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ARCCODE, ARCNAME, ARCCNAME ");
		sqlStr.append("FROM   ARCODE@IWEB ");
		sqlStr.append("ORDER BY ARCNAME");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getSpecList() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT SPCCODE, SPCNAME, SPCCNAME ");
		sqlStr.append("FROM   SPEC@IWEB ");
		sqlStr.append("ORDER BY SPCNAME");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getAllDocList(){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.DOCCODE, D.DOCFNAME, D.DOCGNAME, D.DOCCNAME, D.SPCCODE, S.SPCNAME ");
		sqlStr.append("FROM DOCTOR@IWEB D, SPEC@IWEB S ");
		sqlStr.append("WHERE D.SPCCODE = S.SPCCODE ");
		sqlStr.append("AND D.MSTRDOCCODE IS NULL ");
		sqlStr.append("AND D.DOCSTS = -1 "); 
		sqlStr.append("AND D.ISDOCTOR = -1 "); 
		sqlStr.append("ORDER BY D.DOCFNAME, D.DOCGNAME");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getDoctorList(String arccode){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT D.DOCCODE, D.DOCFNAME, D.DOCGNAME, D.DOCCNAME, D.SPCCODE, S.SPCNAME ");
		sqlStr.append("FROM PANDOCTOR@IWEB P, DOCTOR@IWEB D, SPEC@IWEB S ");
		sqlStr.append("WHERE P.DOCCODE = D.DOCCODE ");
		sqlStr.append("AND D.SPCCODE = S.SPCCODE ");
		if(arccode != null && arccode.length() > 0){
			sqlStr.append("AND P.ARCCODE = '"+ arccode +"' ");
		}
		sqlStr.append("ORDER BY D.DOCFNAME, D.DOCGNAME");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getDoctorList(String doccode, String docname){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.DOCCODE, D.DOCFNAME, D.DOCGNAME, D.DOCCNAME, D.SPCCODE, S.SPCNAME ");
		sqlStr.append("FROM DOCTOR@IWEB D, SPEC@IWEB S ");
		sqlStr.append("WHERE D.SPCCODE = S.SPCCODE ");
		if (doccode != null  && doccode.length() > 0) {
			sqlStr.append("AND D.DOCCODE = UPPER('"+ doccode +"') ");
		}
		if (docname != null  && docname.length() > 0) {
			sqlStr.append("AND D.DOCFNAME || ' ' || D.DOCGNAME LIKE UPPER('%"+ docname +"%') ");
		}
		sqlStr.append("AND D.MSTRDOCCODE IS NULL ");
		sqlStr.append("AND D.DOCSTS = -1 "); 
		sqlStr.append("AND D.ISDOCTOR = -1 "); 
		sqlStr.append("ORDER BY D.DOCCODE");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getDoctorInfo(String doccode){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.DOCCODE, D.DOCFNAME, D.DOCGNAME, D.DOCCNAME, D.SPCCODE, S.SPCNAME ");
		sqlStr.append("FROM DOCTOR@IWEB D, SPEC@IWEB S ");
		sqlStr.append("WHERE D.SPCCODE = S.SPCCODE ");
		sqlStr.append("AND D.MSTRDOCCODE IS NULL ");
		sqlStr.append("AND D.DOCSTS = -1 "); 
		sqlStr.append("AND D.ISDOCTOR = -1 "); 
		sqlStr.append("AND D.DOCCODE = '"+ doccode +"' ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getPanelAR(String arccode, String spccode, String doccode){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT P.ARCCODE, A.ARCNAME ");
		sqlStr.append("FROM PANDOCTOR@IWEB P, DOCTOR@IWEB D, SPEC@IWEB S, ARCODE@IWEB A ");
		sqlStr.append("WHERE P.DOCCODE = D.DOCCODE ");
		sqlStr.append("AND D.SPCCODE = S.SPCCODE ");
		sqlStr.append("AND P.ARCCODE = A.ARCCODE ");
		if(arccode != null && arccode.length() > 0){
			sqlStr.append("AND P.ARCCODE = '"+ arccode +"' ");
		}
		if(spccode != null && spccode.length() > 0){
			sqlStr.append("AND D.SPCCODE = '"+ spccode +"' ");
		}
		if(doccode != null && doccode.length() > 0){
			sqlStr.append("AND P.DOCCODE = '"+ doccode +"' ");
		}
		sqlStr.append("ORDER BY A.ARCNAME ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getPanelSP(String arccode, String spccode, String doccode){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT D.SPCCODE, S.SPCNAME ");
		sqlStr.append("FROM PANDOCTOR@IWEB P, DOCTOR@IWEB D, SPEC@IWEB S, ARCODE@IWEB A ");
		sqlStr.append("WHERE P.DOCCODE = D.DOCCODE ");
		sqlStr.append("AND D.SPCCODE = S.SPCCODE ");
		sqlStr.append("AND P.ARCCODE = A.ARCCODE ");
		if(arccode != null && arccode.length() > 0){
			sqlStr.append("AND P.ARCCODE = '"+ arccode +"' ");
		}
		if(spccode != null && spccode.length() > 0){
			sqlStr.append("AND D.SPCCODE = '"+ spccode +"' ");
		}
		if(doccode != null && doccode.length() > 0){
			sqlStr.append("AND P.DOCCODE = '"+ doccode +"' ");
		}
		sqlStr.append("ORDER BY S.SPCNAME ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getPanelDoctor(String arccode, String spccode, String doccode){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT D.DOCCODE, D.DOCFNAME, D.DOCGNAME, D.DOCCNAME ");
		sqlStr.append("FROM PANDOCTOR@IWEB P, DOCTOR@IWEB D, SPEC@IWEB S, ARCODE@IWEB A ");
		sqlStr.append("WHERE P.DOCCODE = D.DOCCODE ");
		sqlStr.append("AND D.SPCCODE = S.SPCCODE ");
		sqlStr.append("AND P.ARCCODE = A.ARCCODE ");
		if(arccode != null && arccode.length() > 0){
			sqlStr.append("AND P.ARCCODE = '"+ arccode +"' ");
		}
		if(spccode != null && spccode.length() > 0){
			sqlStr.append("AND D.SPCCODE = '"+ spccode +"' ");
		}
		if(doccode != null && doccode.length() > 0){
			sqlStr.append("AND P.DOCCODE = '"+ doccode +"' ");
		}
		sqlStr.append("ORDER BY D.DOCFNAME, D.DOCGNAME ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList retrieveRecord(String arccode, String spccode, String doccode){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT P.ARCCODE, A.ARCNAME, D.DOCCODE, D.DOCFNAME, D.DOCGNAME, D.DOCCNAME, D.SPCCODE, S.SPCNAME ");
		sqlStr.append("FROM PANDOCTOR@IWEB P, DOCTOR@IWEB D, SPEC@IWEB S, ARCODE@IWEB A ");
		sqlStr.append("WHERE P.DOCCODE = D.DOCCODE ");
		sqlStr.append("AND D.SPCCODE = S.SPCCODE ");
		sqlStr.append("AND P.ARCCODE = A.ARCCODE ");
		if(arccode != null && arccode.length() > 0){
			sqlStr.append("AND P.ARCCODE = '"+ arccode +"' ");
		}
		if(spccode != null && spccode.length() > 0){
			sqlStr.append("AND D.SPCCODE = '"+ spccode +"' ");
		}
		if(doccode != null && doccode.length() > 0){
			sqlStr.append("AND P.DOCCODE = '"+ doccode +"' ");
		}
		sqlStr.append("ORDER BY D.DOCFNAME, D.DOCGNAME ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean delARfromDoc(String arccode, String doccode){
		boolean success = false;
		ArrayList<ReportableListObject> record = new ArrayList();
		record = UtilDBWeb.getFunctionResultsHATS("NHS_ACT_PANELDOCTOR", new String[] {"DEL", null, arccode, null, doccode, null});
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			if("0".equals(row.getValue(0))){
				success = true;
			}else{
				success = false;
			}
		}
		return success;
	}
	
	public static boolean insertPanelDoctor(String by, String arccode, String arList, String doccode, String docList){
		boolean success = false;
		ArrayList<ReportableListObject> record = new ArrayList();
		record = UtilDBWeb.getFunctionResultsHATS("NHS_ACT_PANELDOCTOR", new String[] {"ADD", by, arccode, arList, doccode, docList});
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			if("0".equals(row.getValue(0))){
				success = true;
			}else{
				success = false;
			}
		}
		return success;
	}
	
	public static ArrayList getHATSDocInfo(String hatsCode, boolean isGetMasterInfo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE, DOCIDNO, to_char(DOCBDATE, 'dd/mm/yyyy'), MSTRDOCCODE, DOCFNAME, DOCGNAME FROM DOCTOR@IWEB ");
		if (isGetMasterInfo) {
			sqlStr.append("WHERE DOCCODE IN (SELECT MSTRDOCCODE FROM DOCTOR@IWEB where DOCCODE = '" + hatsCode + "') ");
			sqlStr.append("OR (DOCCODE = '" + hatsCode + "' AND MSTRDOCCODE IS NULL) ");
		} else {
			sqlStr.append("WHERE DOCCODE = '" + hatsCode + "'");
		}
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static String getDoctorFullName(String docCode) {
		ArrayList docList = getHATSDocInfo(docCode, false);
		ReportableListObject row = null;
		String docName = null;
		String docFName = null;
		String docGName = null;
		for (int i = 0; i < docList.size(); i++) {
			row = (ReportableListObject) docList.get(0);
			docFName = row.getValue(4);
			docGName = row.getValue(5);
			docName = (docFName == null ? "" : docFName + ", ") + (docGName == null ? "" : docGName);
		}

		return docName;
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO PANDOCTOR ");
		sqlStr.append("(ARCCODE, DOCCODE) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?)");
		sqlStr_insertARtoDoc = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_DOCTORS ");
		sqlStr.append("SET    CO_LASTNAME = ?, CO_FIRSTNAME = ?, CO_CHINESENAME = ?, ");
		sqlStr.append("       CO_OFFICE_NUMBER = ?, CO_MOBILE_NUMBER = ?, ");
		sqlStr.append("       CO_SPECIALTY_CODE = ?, CO_SPECIALTY_DESC = ?, CO_DOCUMENTS = ?, ");
		sqlStr.append("       CO_CREDENTIAL = ?, CO_INTEREST = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_DOCTOR_ID = ?");
		sqlStr_insertDoctoAR = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM PANDOCTOR ");
		sqlStr.append("WHERE ARCCODE = ? AND DOCCODE = ? ");
		sqlStr_deleteARfromDoc = sqlStr.toString();

	}
}
