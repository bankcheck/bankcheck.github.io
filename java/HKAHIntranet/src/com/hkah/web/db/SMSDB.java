package com.hkah.web.db;

import java.util.ArrayList;
import java.util.Arrays;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;


public class SMSDB {
	
	private static String sqlStr_insertRecord = null;
/*	private static String sqlStr_insertList = null;
	private static String sqlStr_updateRecord = null; */
	private static String sqlStr_insertSMSmsg = null;
	private static String sqlStr_updateSMSmsg = null;
	private static String sqlStr_updateMethodCount = null;
	private static String sqlStr_saveSendMsg = null;
	private static String sqlStr_saveExportList = null;
	
	private static String getNextSMSbatch() {
		String recordID = null;
	
		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(BATCH_ID) + 1 FROM SMS_BATCH");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			recordID = reportableListObject.getValue(0);
	
			// set 1 for initial
			if (recordID == null || recordID.length() == 0) return "1";
		}
		return recordID;
	}
	
	public static String addBatch(String noOfRev, String gender, String type,
							String ageGp, String regYr, String hyperlipidemia, 
							String hyperglycaemia, String physicalExam, UserBean userBean) {
	
		// get next record ID
		String batchID = getNextSMSbatch();
		
		// try to insert a new record
		UtilDBWeb.updateQueue(
			sqlStr_insertRecord,
			new String[] {
					batchID, noOfRev, 
					gender, type, ageGp,
					regYr, hyperlipidemia, hyperglycaemia, physicalExam,
					userBean.getLoginID()
						});
		return batchID;
	}
	
	public static String addList(String batchID, String smsList, String mailList,String noProList) {
		StringBuffer sqlStr = new StringBuffer();

		int group = 1000;
		String method = "";
		int count = 0;
		String[] tempList = smsList.split(", "); 
		
		if(smsList != null && smsList.length() > 0 ){
			tempList = smsList.split(", "); 
			for(int i=0; i<=tempList.length; i+=group){
				sqlStr.setLength(0);
				method = "S";
				if(i+group > tempList.length){
					count = tempList.length;
				}else{
					count = i+group;
				}
				String[] tempList1 = Arrays.copyOfRange(tempList, i, count);
		 		String tempList2 = Arrays.toString(tempList1);	
		 		sqlStr.append("PROC_SET_SMSLIST(");
				sqlStr.append("'"+batchID+"', ");
				sqlStr.append("'"+tempList2.substring(1, tempList2.length()-1)+"', ");
				sqlStr.append("'"+method+"') ");
				UtilDBWeb.executeFunction(sqlStr.toString());
			}
		}
		
		if(mailList != null && mailList.length() > 0 ){
			tempList = mailList.split(", ");
			for(int i=0; i<=tempList.length; i+=group){
				sqlStr.setLength(0);
				method = "M";
				if(i+group > tempList.length){
					count = tempList.length;
				}else{
					count = i+group;
				}
				String[] tempList1 = Arrays.copyOfRange(tempList, i, count);
		 		String tempList2 = Arrays.toString(tempList1);	
		 		sqlStr.append("PROC_SET_SMSLIST(");
				sqlStr.append("'"+batchID+"', ");
				sqlStr.append("'"+tempList2.substring(1, tempList2.length()-1)+"', ");
				sqlStr.append("'"+method+"') ");
				UtilDBWeb.executeFunction(sqlStr.toString());
			}
		}
		
		if(noProList != null && noProList.length() > 0 ){
			tempList = noProList.split(", ");
			for(int i=0; i<=tempList.length; i+=group){
				sqlStr.setLength(0);
				method = "0";
				if(i+group > tempList.length){
					count = tempList.length;
				}else{
					count = i+group;
				}
				String[] tempList1 = Arrays.copyOfRange(tempList, i, count);
		 		String tempList2 = Arrays.toString(tempList1);	
		 		sqlStr.append("PROC_SET_SMSLIST(");
				sqlStr.append("'"+batchID+"', ");
				sqlStr.append("'"+tempList2.substring(1, tempList2.length()-1)+"', ");
				sqlStr.append("'"+method+"') ");
				UtilDBWeb.executeFunction(sqlStr.toString());
			}
		}
		
		boolean success = UtilDBWeb.updateQueue(
				sqlStr_updateMethodCount,
				new String[] {batchID});
		
		if(success){
			return batchID;
		} else {
			return "";
		}
	}
	
	
	public static ArrayList getNewBatch(String gender, String type, String ageGp, String regYr, String hyperlipidemia, String hyperglycaemia, String physicalExam){
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT DISTINCT p.PATNO, ");
		sqlStr.append("CONCAT (p.PATFNAME, (' '||p.PATGNAME)) PATNAME, ");
		sqlStr.append("p.PATADD1, p.PATADD2, p.PATADD3, ");
		sqlStr.append("p.PATPAGER, p.PATEMAIL, round((sysdate-p.patbdate)/365.25) ");
		sqlStr.append("FROM PATIENT@IWEB p, REG@IWEB r, BOOKING@IWEB B, SLIPTX@IWEB K, SLIP@IWEB S ");
		sqlStr.append("WHERE p.PATNO = r.PATNO ");
		sqlStr.append(" AND P.PATNO = B.PATNO ");
		sqlStr.append(" AND R.BKGID = B.BKGID ");
		sqlStr.append(" AND S.SLPNO = K.SLPNO ");
		sqlStr.append(" AND R.SLPNO = S.SLPNO ");
		sqlStr.append(" AND P.DEATH IS NULL ");
		sqlStr.append(" AND p.PATSMS = -1 ");
		sqlStr.append(" AND R.REGSTS='N' ");
		sqlStr.append(" AND S.SLPSTS <> 'R' ");
		sqlStr.append("AND NOT REGEXP_LIKE (p.PATIDNO, '^(W|C)') AND p.PATIDNO LIKE ('%(%)%') ");
		if (gender != null && gender.length() > 0 && !("A".equals(gender))) {
			sqlStr.append("AND p.PATSEX = '");
			sqlStr.append(gender);
			sqlStr.append("' ");
		}
		if(type != null && type.length() > 0 && !("A".equals(type))) {
			sqlStr.append("AND REGTYPE = '");
			sqlStr.append(type);
			sqlStr.append("' ");
		}
		if (ageGp != null && ageGp.length() > 0) {
			sqlStr.append("AND round((sysdate-p.patbdate)/365.25) BETWEEN ");
			
			if("0".equals(ageGp)){
				sqlStr.append("'1' AND '10' ");
			}else if("1".equals(ageGp)){
				sqlStr.append("'11' AND '20' ");
			}else if("2".equals(ageGp)){
				sqlStr.append("'21' AND '30' ");
			}else if("3".equals(ageGp)){
				sqlStr.append("'31' AND '40' ");
			}else if("4".equals(ageGp)){
				sqlStr.append("'41' AND '50' ");
			}else if("5".equals(ageGp)){
				sqlStr.append("'51' AND '60' ");
			}else if("6".equals(ageGp)){
				sqlStr.append("'61' AND '70' ");
			}else if("7".equals(ageGp)){
				sqlStr.append("'71' AND '99' ");
			}
		}
		if (regYr != null && regYr.length() > 0) {
			sqlStr.append("AND to_char(r.REGDATE,'YYYY') = '");
			sqlStr.append(regYr);
			sqlStr.append("' ");
		}
		if(hyperlipidemia != null && hyperlipidemia.length() > 0 && !("A".equals(hyperlipidemia))) {
			sqlStr.append(" AND ");
			if("N".equals(hyperlipidemia)){
				sqlStr.append(" not ");
			}
			sqlStr.append(" EXISTS ");
			sqlStr.append("	 (SELECT distinct hospnum ");
			sqlStr.append("	 FROM labo_masthead@lis m , labo_detail@lis d ");
			sqlStr.append("	 WHERE p.PATNO = m.hospnum ");
			sqlStr.append("	 AND m.lab_num = d.lab_num ");
			sqlStr.append("	 AND to_char(date_in,'YYYY') = '");
			sqlStr.append(	regYr);
			sqlStr.append("' ");
			sqlStr.append("  AND (d.test_num = 'CHOL' AND d.result >= 5.2 ");
			sqlStr.append("  OR d.test_num = 'AHDL' AND d.result < 1 ");
			sqlStr.append("  OR d.test_num = 'C/H' AND d.result >= 3.5 ");
			sqlStr.append("  OR d.test_num = 'TGL' AND d.result >= 1.7 ");
			sqlStr.append("  OR d.test_num = 'ALDL' AND d.result >= 3.4 ");
			sqlStr.append("  OR d.test_num = 'NHDLC' AND d.result >= 4.1)) ");
		}
		if(hyperglycaemia != null && hyperglycaemia.length() > 0 && !("A".equals(hyperglycaemia))) {
			sqlStr.append(" AND ");
			if("N".equals(hyperglycaemia)){
				sqlStr.append(" NOT ");
			}
			sqlStr.append(" EXISTS ");
			sqlStr.append("	 (SELECT distinct hospnum ");
			sqlStr.append("	 FROM labo_masthead@lis m , labo_detail@lis d ");
			sqlStr.append("	 WHERE p.PATNO = m.hospnum ");
			sqlStr.append("	 AND m.lab_num = d.lab_num ");
			sqlStr.append("	 AND to_char(date_in,'YYYY') = '");
			sqlStr.append(	 regYr);
			sqlStr.append("' ");
			sqlStr.append("	 AND d.test_num = 'FBS' ");
			sqlStr.append("	 AND result > 6 ) ");
		}if(physicalExam != null && physicalExam.length() > 0 && !("A".equals(physicalExam))) {
			sqlStr.append(" AND ");
			if("N".equals(physicalExam)){
				sqlStr.append(" NOT ");
			}
			sqlStr.append(" REGEXP_LIKE(K.PKGCODE,'^P005$|^P006$|^P005A$|^P006A$|^P003$|^P004$|^P003A$|^P004A$|^PRCHC$|^PRCH3$|^PRCHD$|^PRCH2$|^P001$|^P002$|^P016$|^P017$|^PMF*|^PMM*|^PTF*|^PTM*|^PSF*|^PSM*')");
		}
		sqlStr.append("ORDER BY p.PATPAGER, p.PATADD1, p.PATADD2, p.PATADD3 ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getBatch(String batchID){
		return getBatch(batchID, null, null, null, null, null, null, null);
	}
	
	public static ArrayList getRevList(String batchID){
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT S.PATNO, CONCAT (P.PATFNAME, (' '||P.PATGNAME)) PATNAME,");
		sqlStr.append("P.PATADD1, P.PATADD2, P.PATADD3, ");
		sqlStr.append("P.PATPAGER, P.PATEMAIL, round((sysdate-p.patbdate)/365.25), S.METHOD ");
		sqlStr.append("FROM SMS_BATCH_LIST S, PATIENT@IWEB P ");
		sqlStr.append("WHERE S.PATNO = P.PATNO ");
		sqlStr.append("AND S.BATCH_ID = '");
		sqlStr.append(batchID);
		sqlStr.append("' ");
		sqlStr.append("ORDER BY P.PATPAGER, P.PATADD1, P.PATADD2, P.PATADD3 ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getBatch(String batchID, String gender, String type, String ageGp, String regYr, String hyperlipidemia, String hyperglycaemia, String physicalExam){
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT BATCH_ID, NO_OF_REV, ");
		sqlStr.append("KEY_GENDER, KEY_TYPE, KEY_AGE, ");
		sqlStr.append("KEY_REG_YEAR, KEY_HYPERLIPIDEMIA, KEY_HYPERGLYCAEMIA, ");
		sqlStr.append("TO_CHAR(CREATE_DATE, 'DD/MM/YYYY  HH24:MI') CREATE_DATE, CREATE_BY, ");
		sqlStr.append("SMS_REV, TO_CHAR(SMS_SEND_DATE, 'DD/MM/YYYY  HH24:MI') SMS_SEND_DATE, SMS_SENDER, ");
		sqlStr.append("MAIL_REV, TO_CHAR(EXPORT_LIST_DATE, 'DD/MM/YYYY  HH24:MI') EXPORT_LIST_DATE, EXPORT_USER, MSG_SENT, KEY_PHYSICALEXAM ");
		sqlStr.append("FROM SMS_BATCH ");
		sqlStr.append("WHERE BATCH_ID IS NOT NULL ");
		if (batchID != null && batchID.length() > 0 && !("null".equals(batchID))) {
			sqlStr.append("AND BATCH_ID LIKE '");
			sqlStr.append(batchID);
			sqlStr.append("' ");
		}
		if (gender != null && gender.length() > 0 && !("A".equals(gender))) {
			sqlStr.append("AND KEY_GENDER = '");
			sqlStr.append(gender);
			sqlStr.append("' ");
		}
		if(type != null && type.length() > 0 && !("A".equals(type))) {
			sqlStr.append("AND KEY_TYPE = '");
			sqlStr.append(type);
			sqlStr.append("' ");
		}
		if (ageGp != null && ageGp.length() > 0) {
			sqlStr.append("AND KEY_AGE = '");
			sqlStr.append(ageGp);
			sqlStr.append("' ");
		}
		if (regYr != null && regYr.length() > 0) {
			sqlStr.append("AND KEY_REG_YEAR = '");
			sqlStr.append(regYr);
			sqlStr.append("' ");
		}
		if(hyperlipidemia != null && hyperlipidemia.length() > 0 && !("A".equals(hyperlipidemia))) {
			sqlStr.append("AND KEY_HYPERLIPIDEMIA = '");
			sqlStr.append(hyperlipidemia);
			sqlStr.append("' ");
		}
		if(hyperglycaemia != null && hyperglycaemia.length() > 0 && !("A".equals(hyperglycaemia))) {
			sqlStr.append("AND KEY_HYPERGLYCAEMIA = '");
			sqlStr.append(hyperglycaemia);
			sqlStr.append("' ");
		}
		if(physicalExam != null && physicalExam.length() > 0 && !("A".equals(physicalExam))) {
			sqlStr.append("AND KEY_PHYSICALEXAM = '");
			sqlStr.append(physicalExam);
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY BATCH_ID DESC ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean updateBatch(String batchID, String smsList, String mailList, String noProList) {
		StringBuffer sqlStr = new StringBuffer();

		int group = 1000;
		String method = "";
		int count = 0;
		String[] tempList = smsList.split(", "); 
		
		if(smsList != null && smsList.length() > 0 ){
			tempList = smsList.split(", "); 
			for(int i=0; i<=tempList.length; i+=group){
				sqlStr.setLength(0);
				method = "S";
				if(i+group > tempList.length){
					count = tempList.length;
				}else{
					count = i+group;
				}
				String[] tempList1 = Arrays.copyOfRange(tempList, i, count);
		 		String tempList2 = Arrays.toString(tempList1);	
		 		sqlStr.append("PROC_UPDATE_SMSLIST(");
				sqlStr.append("'"+batchID+"', ");
				sqlStr.append("'"+tempList2.substring(1, tempList2.length()-1)+"', ");
				sqlStr.append("'"+method+"') ");
				UtilDBWeb.executeFunction(sqlStr.toString());
			}
		}
		
		if(mailList != null && mailList.length() > 0 ){
			tempList = mailList.split(", ");
			for(int i=0; i<=tempList.length; i+=group){
				sqlStr.setLength(0);
				method = "M";
				if(i+group > tempList.length){
					count = tempList.length;
				}else{
					count = i+group;
				}
				String[] tempList1 = Arrays.copyOfRange(tempList, i, count);
		 		String tempList2 = Arrays.toString(tempList1);	
		 		sqlStr.append("PROC_UPDATE_SMSLIST(");
				sqlStr.append("'"+batchID+"', ");
				sqlStr.append("'"+tempList2.substring(1, tempList2.length()-1)+"', ");
				sqlStr.append("'"+method+"') ");
				UtilDBWeb.executeFunction(sqlStr.toString());
			}
		}
		
		if(noProList != null && noProList.length() > 0 ){
			tempList = noProList.split(", ");
			for(int i=0; i<=tempList.length; i+=group){
				sqlStr.setLength(0);
				method = "0";
				if(i+group > tempList.length){
					count = tempList.length;
				}else{
					count = i+group;
				}
				String[] tempList1 = Arrays.copyOfRange(tempList, i, count);
		 		String tempList2 = Arrays.toString(tempList1);	
		 		sqlStr.append("PROC_UPDATE_SMSLIST(");
				sqlStr.append("'"+batchID+"', ");
				sqlStr.append("'"+tempList2.substring(1, tempList2.length()-1)+"', ");
				sqlStr.append("'"+method+"') ");
				UtilDBWeb.executeFunction(sqlStr.toString());
			}
		}
		// try to update selected record
		return 	UtilDBWeb.updateQueue(
						sqlStr_updateMethodCount,
						new String[] {batchID});
	}
	
	
	
	public static Boolean addMsg(String smsCode,String smsMsg, UserBean userBean) {
		// try to insert a new record
		Boolean success = UtilDBWeb.updateQueue(
				sqlStr_insertSMSmsg,
		new String[] {
			smsCode, smsMsg, userBean.getLoginID(), userBean.getLoginID()
				});
		return success;
		
	}
	
	public static ArrayList getMsg(String order){
		return getMsg(null, null, order);
	}
	public static ArrayList getMsg(String smsCode, String order){
		return getMsg(smsCode, null, order);
	}
	
	public static ArrayList getMsg(String smsCode, String msgSearch, String order){
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT SMS_CODE, SMS_MSG ");
		sqlStr.append("FROM SMS_MSG ");
		sqlStr.append("WHERE SMS_CODE = SMS_CODE ");
		if (smsCode != null && smsCode.length() > 0) {
			sqlStr.append("AND SMS_CODE = '");
			sqlStr.append(smsCode);
			sqlStr.append("' ");
		}
		if (msgSearch != null && msgSearch.length() > 0) {
			sqlStr.append("AND SMS_MSG LIKE '%");
			sqlStr.append(msgSearch);
			sqlStr.append("%' ");
		}
		sqlStr.append("ORDER BY "+order);
		if (order == "CREATE_DATE"){
			sqlStr.append(" DESC");
		}
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean updateMsg(String smsCode, String smsMsg, UserBean userBean) {

		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_updateSMSmsg,
				new String[] {
						smsMsg, userBean.getLoginID(), smsCode});
	}
	
	public static boolean sendMsg(String batchID, String smsCode, UserBean userBean) {
		
		String smsMsg = null;
		//get msg
		ArrayList result = getMsg(smsCode);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			smsMsg = reportableListObject.getValue(1);
		}
		
		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_saveSendMsg,
				new String[] {
						smsMsg, userBean.getLoginID(), batchID});
	}
	
	public static boolean exportMail(String batchID, UserBean userBean) {
			
		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_saveExportList,
				new String[] {
						userBean.getLoginID(), batchID});
	}
	
	
	
	static{
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO SMS_BATCH ");
		sqlStr.append("(BATCH_ID, NO_OF_REV, ");
		sqlStr.append("KEY_GENDER, KEY_TYPE, KEY_AGE, ");
		sqlStr.append("KEY_REG_YEAR, KEY_HYPERLIPIDEMIA, KEY_HYPERGLYCAEMIA, KEY_PHYSICALEXAM, ");
		sqlStr.append("CREATE_DATE, CREATE_BY) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ");
		sqlStr.append("SYSDATE, ?) ");
	 	sqlStr_insertRecord = sqlStr.toString();
	 	
	 /*	sqlStr.setLength(0);
	 	sqlStr.append("INSERT INTO SMS_BATCH_LIST ");
		sqlStr.append("(BATCH_ID, PATNO, METHOD) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?) ");
	 	sqlStr_insertList = sqlStr.toString();*/
	 	
	 	sqlStr.setLength(0);
	 	sqlStr.append("UPDATE SMS_BATCH B ");
	 	sqlStr.append("SET SMS_REV = ( ");
	 	sqlStr.append("	SELECT COUNT (*) ");
	 	sqlStr.append("	FROM SMS_BATCH_LIST BL "); 
	 	sqlStr.append(" WHERE BL.BATCH_ID = B.BATCH_ID ");
	 	sqlStr.append(" AND METHOD = 'S'), ");
	 	sqlStr.append("Mail_REV = ( ");
	 	sqlStr.append("	SELECT COUNT (*) ");
	 	sqlStr.append("	FROM SMS_BATCH_LIST BL "); 
	 	sqlStr.append(" WHERE BL.BATCH_ID = B.BATCH_ID ");
	 	sqlStr.append(" AND METHOD = 'M'), ");
	 	sqlStr.append("NO_OF_REV = ( ");
	 	sqlStr.append("	SELECT COUNT (*) ");
	 	sqlStr.append("	FROM SMS_BATCH_LIST BL "); 
	 	sqlStr.append(" WHERE BL.BATCH_ID = B.BATCH_ID ");
	 	sqlStr.append(" AND METHOD != '0') ");
	 	sqlStr.append("WHERE BATCH_ID = ? ");
	 	sqlStr_updateMethodCount = sqlStr.toString();
	 	
	/* 	sqlStr.setLength(0);
	 	sqlStr.append("UPDATE SMS_BATCH_LIST ");
	 	sqlStr.append("SET METHOD = ? ");
	 	sqlStr.append("WHERE BATCH_ID = ? ");
	 	sqlStr.append("AND PATNO IN ( ? ) ");
	 	sqlStr_updateRecord = sqlStr.toString();*/
	 	
	 	sqlStr.setLength(0);
	 	sqlStr.append("INSERT INTO SMS_MSG ");
		sqlStr.append("(SMS_CODE, SMS_MSG, CREATE_DATE, CREATE_BY, MODIFIED_DATE, MODIFIED_BY) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, SYSDATE, ?, SYSDATE, ?) ");
	 	sqlStr_insertSMSmsg = sqlStr.toString();

	 	sqlStr.setLength(0);
	 	sqlStr.append("UPDATE SMS_MSG ");
	 	sqlStr.append("SET SMS_MSG = ? , MODIFIED_DATE = SYSDATE , MODIFIED_BY = ? ");
	 	sqlStr.append("WHERE SMS_CODE = ? ");
	 	sqlStr_updateSMSmsg = sqlStr.toString();
	 	
	 	sqlStr.setLength(0);
	 	sqlStr.append("UPDATE SMS_BATCH ");
	 	sqlStr.append("SET MSG_SENT = ? , SMS_SEND_DATE = SYSDATE , SMS_SENDER = ? ");
	 	sqlStr.append("WHERE BATCH_ID = ? ");
	 	sqlStr_saveSendMsg = sqlStr.toString();
	 	
	 	sqlStr.setLength(0);
	 	sqlStr.append("UPDATE SMS_BATCH ");
	 	sqlStr.append("SET EXPORT_LIST_DATE = SYSDATE , EXPORT_USER = ? ");
	 	sqlStr.append("WHERE BATCH_ID = ? ");
	 	sqlStr_saveExportList = sqlStr.toString();

	}
	
	
}
