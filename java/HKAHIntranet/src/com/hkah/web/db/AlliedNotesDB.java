package com.hkah.web.db;

import java.util.*;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
//for image
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import sun.misc.BASE64Decoder;

public class AlliedNotesDB {
	private static String sqlStr_insertForm = null;
	private static String sqlStr_updateForm = null;
	private static String sqlStr_insertProgNotes = null;
	private static String sqlStr_saveLog = null;
	
	public static ArrayList getDocInfo(String userid) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT U.USER_ID, U.USER_NAME ");
		sqlStr.append("FROM AH_SYS_USER U ");
		sqlStr.append("WHERE U.USER_ID = '");
		sqlStr.append(userid);
		sqlStr.append("' ");

		//System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static ArrayList getAlliedType(){
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CODE_NO, CODE_VALUE1 ");
		sqlStr.append("FROM AH_SYS_CODE ");
		sqlStr.append("WHERE SYS_ID = 'ALL' ");
		sqlStr.append("AND CODE_TYPE = 'ALLIED_TYPE' ");
		sqlStr.append("AND STATUS = 'V' ");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static ArrayList getPatID(String regid) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT R.REGID, R.PATNO, p.patfname || ' ' || p.patgname AS patname, TO_CHAR(P.Patbdate, 'dd/mm/yyyy') AS DOB, P.PATSEX ");
		sqlStr.append("FROM REG@IWEB R, PATIENT@IWEB P");
		sqlStr.append(" WHERE R.PATNO = P.PATNO AND R.REGID = '");
		sqlStr.append(regid);
		sqlStr.append("' ");

//		System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private static String getNextCaseNo(){
		String caseNo = "";
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT SEQ_OPD_CASE_MAS.nextval ");
		sqlStr.append("FROM DUAL ");
		
		ArrayList result = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		if (result.size() > 0){
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			caseNo = reportableListObject.getValue(0);
			
			if (caseNo == "" || caseNo.length() == 0) return "1";
		}

		return caseNo;
	}

	public static String insertForm(
			String caseNo, String caseType, String caseDate, String patno, String regid,
			String diagnosis, String past_med_hist, String social_history, String emotional, String func_assmt, 
			String fall_assmt, String patient_goal, String hpi, String subjective, String objective,  
			String treatment_goal, String treatment, String defection,
			String update_user, String progNotes ){
		
		caseNo = getNextCaseNo();
		
		System.err.println("[update_user]:"+update_user+";[patno]:"+patno+";[regid]"+regid+";[caseNo]:"+caseNo);
		//System.out.println(caseDate);
		System.out.println("INSERT FORM::");

		if(UtilDBWeb.updateQueueCIS(
				sqlStr_insertForm,
				new String[] {
						caseNo, caseType, caseDate, patno, regid, 
						diagnosis, past_med_hist, social_history, emotional, func_assmt,
						fall_assmt, patient_goal, hpi, subjective, objective,
						treatment_goal, treatment, defection, 
						update_user, update_user})){
			System.err.println("[sqlStr_insertForm][initial record]:"+sqlStr_insertForm);
			
			saveLog(caseNo, patno, "SUCCESS-FORM", update_user);	
			if(UtilDBWeb.updateQueueCIS(
					sqlStr_insertProgNotes,
					new String[] {
							patno, progNotes, caseNo, update_user, update_user})){
				System.err.println("[sqlStr_insertProgNotes][initial record]:"+sqlStr_insertProgNotes);
				saveLog(caseNo, patno, "SUCCESS-ALL", update_user);				
				return caseNo;			
				
			}else{
				saveLog(caseNo, patno, "FAIL-PROGNOTES", update_user);				
				return "0";
			}
		}else{
			saveLog(caseNo, patno, "FAIL-ALL", update_user);	
			return "0";
		}
	}
	
	public static boolean saveLog(String caseNo, String patNO, String isSuccess, String update_user){
		if(UtilDBWeb.updateQueueCIS(
				sqlStr_saveLog,
				new String[] {caseNo, patNO, isSuccess, getComputerName(), update_user})){

			System.err.println("[sqlStr_saveLog]:"+sqlStr_saveLog);				
			return true;
		}else{
			System.err.println("[sqlStr_saveLog][FALSE]:"+sqlStr_saveLog+";[caseNo]:"+caseNo+"[patNO]:"+patNO+";[getComputerName()]:"+getComputerName()+";[update_user]:"+update_user);			
			return false;
		}
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
	
	public static String updateForm(
			String caseNo, String caseType, String caseDate, String patno, String regid,
			String diagnosis, String past_med_hist, String social_history, String emotional, String func_assmt, 
			String fall_assmt, String patient_goal, String hpi, String subjective, String objective,  
			String treatment_goal, String treatment, String defection,
			String update_user, String progNotes ){

			if(UtilDBWeb.updateQueueCIS(
					sqlStr_updateForm,
					new String[] {
							caseType, caseDate, "A", patno, regid, 
							diagnosis, past_med_hist, social_history, emotional, func_assmt,
							fall_assmt, patient_goal, hpi, subjective, objective,
							treatment_goal, treatment, defection, 
							update_user, caseNo})){
				System.err.println("[sqlStr_updateForm][initial record]:"+sqlStr_updateForm);
				saveLog(caseNo, patno, "SUCCESS-UPDATEFORM", update_user);
				
				if(progNotes.length() > 0){
					if(UtilDBWeb.updateQueueCIS(
							sqlStr_insertProgNotes,
							new String[] {
									patno, progNotes, caseNo, update_user, update_user})){
						System.err.println("[sqlStr_insertProgNotes][initial record]:"+sqlStr_insertProgNotes);
						saveLog(caseNo, patno, "SUCCESS-NEWPROGNOTE", update_user);
					}
				}
				return caseNo;
			
		}else{
			System.err.println("[sqlStr_updateForm][fail]:"+sqlStr_updateForm);
			return "0";
		}
	}
	
	public static ArrayList getAlliedCaseProgress(String caseNo) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT ID, PATNO, TO_CHAR(NOTE_DATE, 'DD/MM/YYYY'), NOTE_TYPE, DESCRIPTION, REF_NO, STATUS, NVL((SELECT ASU.USER_NAME FROM AH_SYS_USER ASU WHERE ASU.USER_ID =N.UPDATE_USER),UPDATE_USER) ");
		sqlStr.append("FROM OPD_MISC_NOTE N ");
		sqlStr.append("WHERE NOTE_TYPE = 'allied-progress' ");
		sqlStr.append("AND STATUS = 'A' ");
		sqlStr.append("AND REF_NO = '" + caseNo + "' ");
		sqlStr.append("ORDER BY NOTE_DATE ");

		System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	public static ArrayList getAlliedCaseByPatno(String patno, String caseType) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("	SELECT ");
		sqlStr.append(" CASE_NO, CASE_TYPE, TO_CHAR(CASE_DATE,'DD/MM/YYYY'), STATUS, PATNO, REGID, "); // 1, 2, 3, 4, 5, 6, 
		sqlStr.append(" DIAGNOSIS, PAST_MED_HIST, SOCIAL_HISTORY, EMOTIONAL, FUNC_ASSMT, "); // 7, 8, 9, 10, 11,
		sqlStr.append(" FALL_ASSMT, PATIENT_GOAL, HPI, SUBJECTIVE, OBJECTIVE, "); // 12, 13, 14, 15, 16, 
		sqlStr.append(" TREATMENT_GOAL, TREATMENT, DEFECTION, "); // 17, 18, 19, 
		sqlStr.append(" F_GET_OPTION(DEFECTION,'ad1','N'), F_GET_OPTION(DEFECTION,'ad5','N'), "); // 20, 21
		sqlStr.append(" CREATE_USER, TO_CHAR(CREATE_DATE,'DD/MM/YYYY') ");	// 22, 23
		sqlStr.append(" FROM OPD_CASE_MAS ");
		sqlStr.append(" WHERE PATNO = '" + patno + "' ");
		if (!"".equals(caseType) && caseType != null) {
			sqlStr.append(" AND CASE_TYPE = '" + caseType + "' ");
		}
		sqlStr.append(" AND STATUS = 'A' ");
		sqlStr.append(" ORDER BY CREATE_DATE DESC ");

		System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static ArrayList getAlliedCaseInfo(String caseNo, String caseType) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("	SELECT ");
		sqlStr.append(" CASE_NO, CASE_TYPE, TO_CHAR(CASE_DATE,'DD/MM/YYYY'), STATUS, PATNO, REGID, "); // 1, 2, 3, 4, 5, 6, 
		sqlStr.append(" DIAGNOSIS, PAST_MED_HIST, SOCIAL_HISTORY, EMOTIONAL, FUNC_ASSMT, "); // 7, 8, 9, 10, 11,
		sqlStr.append(" FALL_ASSMT, PATIENT_GOAL, HPI, SUBJECTIVE, OBJECTIVE, "); // 12, 13, 14, 15, 16, 
		sqlStr.append(" TREATMENT_GOAL, TREATMENT, DEFECTION, "); // 17, 18, 19, 
		sqlStr.append(" F_GET_OPTION(DEFECTION,'ad1','N'), F_GET_OPTION(DEFECTION,'ad5','N'), "); // 20, 21
		sqlStr.append(" CREATE_USER, TO_CHAR(CREATE_DATE,'DD/MM/YYYY') ");	// 22, 23
		sqlStr.append(" FROM OPD_CASE_MAS ");
		sqlStr.append(" WHERE CASE_NO = '" + caseNo + "' ");
		if (!"".equals(caseType) && caseType != null) {
			sqlStr.append(" AND CASE_TYPE = '" + caseType + "' ");
		}
		sqlStr.append(" AND STATUS = 'A' ");
		sqlStr.append(" ORDER BY CREATE_DATE DESC ");

		System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	
	static{
		StringBuffer sqlStr = new StringBuffer();
				
		sqlStr.append("INSERT INTO OPD_CASE_MAS (");
		sqlStr.append("CASE_NO, CASE_TYPE, CASE_DATE, STATUS, PATNO, REGID, ");
		sqlStr.append("DIAGNOSIS, PAST_MED_HIST, SOCIAL_HISTORY, EMOTIONAL, FUNC_ASSMT,");
		sqlStr.append("FALL_ASSMT, PATIENT_GOAL, HPI, SUBJECTIVE, OBJECTIVE, ");
		sqlStr.append("TREATMENT_GOAL, TREATMENT, DEFECTION, CREATE_USER, CREATE_DATE, UPDATE_USER, UPDATE_DATE)");
		sqlStr.append(" VALUES ( ");
		sqlStr.append("?, ?, TO_DATE(?,'DD/MM/YYYY'), 'A', ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, SYSDATE, ?, SYSDATE )");
		sqlStr_insertForm = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE OPD_CASE_MAS SET ");
		sqlStr.append("CASE_TYPE = ?, CASE_DATE = TO_DATE(?,'DD/MM/YYYY'), STATUS = ?, PATNO = ?, REGID = ?, ");
		sqlStr.append("DIAGNOSIS = ?, PAST_MED_HIST = ?, SOCIAL_HISTORY = ?, EMOTIONAL = ?, FUNC_ASSMT = ?, ");
		sqlStr.append("FALL_ASSMT = ?, PATIENT_GOAL = ?, HPI = ?, SUBJECTIVE = ?, OBJECTIVE = ?, ");
		sqlStr.append("TREATMENT_GOAL = ?, TREATMENT = ?, DEFECTION = ?, ");
		sqlStr.append("UPDATE_USER = ?, UPDATE_DATE = SYSDATE ");
		sqlStr.append("WHERE  CASE_NO = ?");
		sqlStr_updateForm = sqlStr.toString();
		
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO OPD_MISC_NOTE ");
		sqlStr.append("(ID, PATNO, NOTE_DATE, NOTE_TYPE, DESCRIPTION, REF_NO, STATUS, CREATE_USER, CREATE_DATE, UPDATE_USER, UPDATE_DATE ) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(SEQ_OPD_MISC_NOTE.nextval, ?, SYSDATE, 'allied-progress', ?, ?, 'A', ?, SYSDATE, ?, SYSDATE )");		
		sqlStr_insertProgNotes = sqlStr.toString();		
		
		sqlStr.setLength(0);
		sqlStr.append("insert into ah_sys_log"); 
		sqlStr.append(" (sys_id, sys_time, user_id, user_dept, user_team, keyword, description, pcname)");
		sqlStr.append(" select 'CIS', sysdate, user_id, user_dept, user_team, 'ALLIED', 'Update record refer by caseNo:'||?||',patNO:'||?||'||['||?||']''',?");
		sqlStr.append(" from ah_sys_user"); 
		sqlStr.append(" where user_id= ?");
		sqlStr_saveLog = sqlStr.toString();		
	}
}
