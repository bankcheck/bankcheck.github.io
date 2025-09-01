package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;


public class AllergyDB {
	
	private static String sqlStr_insertRecord = null;
	private static String sqlStr_updateRecord = null;
	private static String sqlStr_insertAckRecord = null;
	
	public static ArrayList getSAAM(){
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT PARAM1 ");
		sqlStr.append("FROM sysparam@IWEB ");
		//sqlStr.append("WHERE parcde = 'ALLERGYAPI'");
		sqlStr.append("WHERE parcde = 'EHRSAAMITG'");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private static String getNextAllergyRecordID() {
		String recordID = null;
	
		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableListCIS(
				"SELECT MAX(ID) + 1 FROM CMS_ALLERGY");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			recordID = reportableListObject.getValue(0);
	
			// set 1 for initial
			if (recordID == null || recordID.length() == 0) return "1";
		}
		return recordID;
	}
	
	/**
	 * Add a Record
	 */
	public static boolean add(String patno, String  allergyType, String allergyCode,
							String descrption, String reaction, String remarks, 
							String login, String updateFrom) {
	
		// get next record ID
		String recordID = getNextAllergyRecordID();
		String status = "A";
		
		// try to insert a new record
		if(UtilDBWeb.updateQueueCIS(
			sqlStr_insertRecord,
			new String[] {
						recordID, patno, status, allergyType, allergyCode,
						descrption, reaction, remarks,
						login, updateFrom, login
						})){
			addLog(patno, "ADD", recordID,  updateFrom, login);
			return true;
		}else{
			addLog(patno, "ADD", "ERROR",  updateFrom, login);
			return false;
		}
	}
	
	
	public static ArrayList getAllergyType(){
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CODE_NO, CODE_VALUE2 ");
		sqlStr.append("FROM AH_SYS_CODE@CIS ");
		sqlStr.append("WHERE SYS_ID = 'CMS' ");
		sqlStr.append("AND CODE_TYPE = 'ALLERGY_TYPE' ");
		sqlStr.append("AND STATUS = 'V' ");
		sqlStr.append("ORDER BY REMARKS ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getAllergy(String allergyType){
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CODE_NO, CODE_VALUE1 ");
		sqlStr.append("FROM AH_SYS_CODE@CIS ");
		sqlStr.append("WHERE SYS_ID = 'CMS' ");
		sqlStr.append("AND CODE_TYPE = 'ALLERGY_CODE' ");
		sqlStr.append("AND CODE_NO LIKE '" + allergyType + "%' ");
		sqlStr.append("AND STATUS = 'V' ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getAllergySeverity(){
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CODE_NO, CODE_VALUE1 ");
		sqlStr.append("FROM AH_SYS_CODE@CIS ");
		sqlStr.append("WHERE SYS_ID = 'CMS' ");
		sqlStr.append("AND CODE_TYPE = 'SEVERITY' ");
		sqlStr.append("AND STATUS = 'V' ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getAllergyRecord(String patno, String status, String orderBy){
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT row_number() over (partition by T.TYPE order by T.TYPE) AS ROW_NUM, R.ID, R.PATNO, R.STATUS, T.TYPE, C.ALLERGY_NAME, R.DESCRIPTION, A.REACTION, R.REMARKS, R.UPDATE_USER, TO_CHAR(R.UPDATE_DATE, 'YYYY-MM-DD HH24:MI') UPDATE_DATE ");
		sqlStr.append("FROM CMS_ALLERGY@CIS R ");
		sqlStr.append("JOIN (SELECT CODE_NO, CODE_VALUE2 TYPE ");
		sqlStr.append("      FROM AH_SYS_CODE@CIS ");
		sqlStr.append("      WHERE SYS_ID = 'CMS' ");
		sqlStr.append("      AND CODE_TYPE = 'ALLERGY_TYPE') T ");
		sqlStr.append("      ON T.CODE_NO = R.ALLERGY_TYPE ");
		sqlStr.append("LEFT JOIN (SELECT CODE_NO, CODE_VALUE1 ALLERGY_NAME ");
		sqlStr.append("      FROM AH_SYS_CODE@CIS ");
		sqlStr.append("      WHERE SYS_ID = 'CMS' ");
		sqlStr.append("      AND CODE_TYPE = 'ALLERGY_CODE') C ");
		sqlStr.append("      ON C.CODE_NO = R.ALLERGY_CODE ");
		sqlStr.append("LEFT JOIN (SELECT CODE_NO, CODE_VALUE1 REACTION ");
		sqlStr.append("      FROM AH_SYS_CODE@CIS ");
		sqlStr.append("      WHERE SYS_ID = 'CMS' ");
		sqlStr.append("      AND CODE_TYPE = 'SEVERITY') A ");
		sqlStr.append("      ON A.CODE_NO = R.REACTION ");
		sqlStr.append("WHERE R.PATNO = '"+patno+"' ");
		if(status != null && !"".equals(status)){
			sqlStr.append("AND R.STATUS = '"+status+"' ");
		}
		if("ID".equals(orderBy)){
			sqlStr.append("ORDER BY R.ID DESC ");
		}else if ("TYPE".equals(orderBy)){
			sqlStr.append("ORDER BY T.TYPE ");
		}
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean getNKDA(String patno){
		StringBuffer sqlStr = new StringBuffer();

		boolean nkda = false;
		
		sqlStr.append("SELECT COUNT(ID) ");
		sqlStr.append("FROM CMS_ALLERGY ");
		sqlStr.append("WHERE PATNO = '"+patno+"' ");
		sqlStr.append("AND STATUS = 'A' ");
		sqlStr.append("AND ALLERGY_TYPE = 'N' ");
		
		ArrayList result = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		if (result.size() > 0){
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			nkda = Integer.parseInt(reportableListObject.getValue(0))>0;
		}
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT COUNT(PATIENT_REF_KEY) ");
		sqlStr.append("FROM CMS_STRUCTURE_ALERT ");
		sqlStr.append("WHERE PATIENT_REF_KEY = '"+patno+"' ");
		sqlStr.append("AND SUB_TYPE = 'N' ");
		
		ArrayList result1 = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		if (result1.size() > 0){
			ReportableListObject reportableListObject1 = (ReportableListObject) result1.get(0);
			nkda = Integer.parseInt(reportableListObject1.getValue(0))>0;
		}
		
		return nkda;
	}
	
	public static ArrayList getCancelReason(){
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT CODE_NO, CODE_VALUE1 ");
		sqlStr.append("FROM AH_SYS_CODE ");
		sqlStr.append("WHERE SYS_ID = 'CMS' ");
		sqlStr.append("AND CODE_TYPE = 'ALLERGY_DEL_REASON' ");
		sqlStr.append("ORDER BY CODE_NO DESC");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static ArrayList getAllergyCancelReason(String recordID){
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT R.ID, R.CANCEL_REASON, R.CANCEL_REASON_ID ");
		sqlStr.append("FROM CMS_ALLERGY R ");
		sqlStr.append("WHERE R.ID = '"+recordID+"' ");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	/**
	 * Update record
	 * @return whether it is successful to update the record
	 */
	public static boolean update(String login, String recordID,	String delReasonID, String delReasonRemark, String updateFrom, String patno) {

		String status = "D";
		// try to update selected record
		if(UtilDBWeb.updateQueueCIS(
				sqlStr_updateRecord,
				new String[] {
						delReasonID, delReasonRemark, status, 
						updateFrom, login, recordID})){
				addLog(patno, "UPDATE", recordID,  updateFrom, login);
				return true;
			}else{
				addLog(patno, "UPDATE", "ERROR",  updateFrom, login);
				return false;
			}
	}
	
	public static ArrayList getEHRrecord(String patno){
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT row_number() over (partition by ALERT_TYPE order by ALERT_TYPE) AS ROW_NUM,  ALERT_TYPE, SHORT_DISPLAY_NAME, SEVERITY, REACTION, REMARK, UPDATE_USER, SUBSTR(UPDATE_DTM,0,16) AS UPDATE_DATE ");
		sqlStr.append("FROM CMS_STRUCTURE_ALERT ");
		sqlStr.append("WHERE PATIENT_REF_KEY = '"+patno+"' ");
		//sqlStr.append("ORDER BY ALERT_TYPE");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	private static String getNextLogID(){
		String logID = "";
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT SEQ_CMS_ALLERGY_LOG.nextval ");
		sqlStr.append("FROM DUAL ");
		
		ArrayList result = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		if (result.size() > 0){
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			logID = reportableListObject.getValue(0);
			
			if (logID == "" || logID.length() == 0) return "1";
		}

		return logID;
	}
	/**
	 * Add acknowledge record
	 */
	public static boolean addLog(String patno, String  action, String description, String updateFrom, String login) {
	
		// get next record ID
		String logID = getNextLogID();

		
		// try to insert a new record
		return UtilDBWeb.updateQueueCIS(
				sqlStr_insertAckRecord,
				new String[] {
							logID, patno, action, description, updateFrom, login
							});
	
	}
	
	public static ArrayList getLog(String action, String patno){
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT L.ACTION, L.DESCRIPTION, L.UPDATE_FROM, L.UPDATE_USER, TO_CHAR(L.UPDATE_DATE , 'YYYY-MM-DD HH24:MI' ) UPDATE_DATE, U.USER_NAME ");
		sqlStr.append("FROM CMS_ALLERGY_LOG L, AH_SYS_USER U ");
		sqlStr.append("WHERE U.USER_ID = L.UPDATE_USER ");
		sqlStr.append("AND L.ACTION = '"+action+"' ");
		sqlStr.append("AND L.PATNO = '"+patno+"' ");
		sqlStr.append("ORDER BY L.UPDATE_DATE DESC ");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	static{
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO CMS_ALLERGY ");
		sqlStr.append("(ID, PATNO, STATUS, ALLERGY_TYPE, ALLERGY_CODE, ");
		sqlStr.append("DESCRIPTION, REACTION, REMARKS, ");
		sqlStr.append("CREATE_USER, CREATE_DATE, UPDATE_FROM, UPDATE_USER, UPDATE_DATE) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ");
	 	sqlStr.append("?, ?, ?, ");
	 	sqlStr.append("?, SYSDATE, ?, ?, SYSDATE)");
	 	sqlStr_insertRecord = sqlStr.toString();
	 	
	 	sqlStr.setLength(0);
	 	sqlStr.append("UPDATE CMS_ALLERGY ");
	 	sqlStr.append("SET CANCEL_REASON_ID = ?, CANCEL_REASON = ?, STATUS = ?, ");
	 	sqlStr.append("UPDATE_FROM = ?, UPDATE_USER = ?, UPDATE_DATE = SYSDATE ");
	 	sqlStr.append("WHERE ID = ?");
	 	sqlStr_updateRecord = sqlStr.toString();
	 	
	 	sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CMS_ALLERGY_LOG ");
		sqlStr.append("(ID, PATNO, ACTION, DESCRIPTION, UPDATE_FROM, UPDATE_USER, UPDATE_DATE) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ?, SYSDATE) ");
	 	sqlStr_insertAckRecord = sqlStr.toString();
	 	
	}
	
	
}
