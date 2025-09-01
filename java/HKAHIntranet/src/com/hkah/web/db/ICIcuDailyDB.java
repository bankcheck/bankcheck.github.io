package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class ICIcuDailyDB {

	// bld mrsa esbl
	private static String sqlStr_getIcuDaily = null;
	private static String sqlStr_getIcuDailyList = null;
	private static String sqlStr_insertIcuDaily = null;
	private static String sqlStr_updateIcuDaily = null;	
	private static String sqlStr_deleteIcuDaily = null;	

	private static String getNextCaseNum() {
		String caseNum = null;

		// get next case num from db //
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CASE_NUM) + 1 FROM IC_ICU_DAILY WHERE IC_SITE_CODE = ?",
				new String[] { ConstantsServerSide.SITE_CODE });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			caseNum = reportableListObject.getValue(0);

			// set 1 for initial
			if (caseNum == null || caseNum.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return caseNum;
	}

	public static String add(
			UserBean userBean,
			String icType,
			String CaseDate, 
			String LabNum, 
			String HospNum, 
			String PatName, 
			String PatSex,
			String PatBDate,
			String Age, 
			String Month,
			String Ward, 
			String RoomNum, 
			String BedNum, 
			String DateIn,
			//
			String REC_DATE,
			String TEMP, 
			String WBC,
			String BP, 
			String UO,
			String VENT_FIO2,
			String CXR,
			String RESP_SS,
			String PROGRESS,
			String ANTIBIOTICS,
			String LAB_RESULT
	) {
		// get next schedule ID
		String CaseNum = getNextCaseNum();
		
//		System.out.println("add(.... : " + BodySystem);
		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertIcuDaily,
				new String[] {						
						ConstantsServerSide.SITE_CODE,
						icType,
						CaseNum, CaseDate, LabNum, HospNum,
						PatName, PatSex, PatBDate, Age, Month,
						Ward, RoomNum, BedNum, DateIn,	
						REC_DATE, TEMP, WBC, BP, UO,
						VENT_FIO2, CXR, RESP_SS, PROGRESS, ANTIBIOTICS, LAB_RESULT,
						userBean.getLoginID()
				})) {
			return CaseNum;
		} else {
			return null;
		}
	}

	public static boolean update(
			UserBean userBean,
			String HospAdmDate, 
			String LabNum, 
			String HospNum, 
			String PatName, 
			String PatSex, 
			String PatBDate,
			String Age, 
			String Month, 
			String Ward, 
			String RoomNum, 
			String BedNum, 
			String DateIn,
			//
			String REC_DATE,
			String TEMP, 
			String WBC,
			String BP, 
			String UO,
			String VENT_FIO2,
			String CXR,
			String RESP_SS,
			String PROGRESS,
			String ANTIBIOTICS,
			String LAB_RESULT,
			//
			String icType,
			String CaseNum
	) {
		//System.out.println("update(.... : " +  IVCatheter);
		// try to update selected record
		if(UtilDBWeb.updateQueue(
				sqlStr_updateIcuDaily,
				new String[] {
						HospAdmDate, 
						LabNum, HospNum, PatName, 
						PatSex, 
						PatBDate,
						Age, Month, Ward, RoomNum, BedNum, 
						DateIn,
						REC_DATE, TEMP, WBC, BP, UO,
						VENT_FIO2, CXR, RESP_SS, PROGRESS, ANTIBIOTICS, LAB_RESULT,
						icType,
						userBean.getLoginID(),
						ConstantsServerSide.SITE_CODE, CaseNum})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean delete(UserBean userBean, String caseNum) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteIcuDaily,
				new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, caseNum });
	}

	public static ArrayList get(String caseNum) {
		return UtilDBWeb.getReportableList(sqlStr_getIcuDaily, new String[] {caseNum });
	}

	public static ArrayList getList(String LabNum, String DateFrom, String DateTo) {
		return UtilDBWeb.getReportableList(sqlStr_getIcuDailyList, new String[] {DateFrom, DateTo, "%" + LabNum + "%"});
	}
	
	static {
		StringBuffer sqlStr = new StringBuffer();
		
	
		// mrsa esbl 
		sqlStr.setLength(0);		
		sqlStr.append("SELECT ");		                                             
	    sqlStr.append("IC_SITE_CODE, CASE_NUM, TO_CHAR(HOSP_ADM_DATE, 'dd/MM/YYYY'), LAB_NUM, HOSPNUM, PATNAME, PATSEX, ");
		sqlStr.append("TO_CHAR(PATBDATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY'), ");	
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_ICU_DAILY ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND TO_DATE(?, 'dd/MM/YYYY') <= HOSP_ADM_DATE AND TO_DATE(?, 'dd/MM/YYYY') >= HOSP_ADM_DATE ");
		sqlStr.append("AND LAB_NUM like ? ");
		sqlStr.append("AND ICTYPE = 'icu_d' ");
		sqlStr.append("ORDER BY CASE_NUM");
		sqlStr_getIcuDailyList = sqlStr.toString();
		
		sqlStr.setLength(0);		
		sqlStr.append("SELECT IC_SITE_CODE, CASE_NUM, TO_CHAR(HOSP_ADM_DATE, 'dd/MM/yyyy'), LAB_NUM, HOSPNUM, PATNAME, PATSEX, ");
		sqlStr.append("TO_CHAR(PATBDATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY'), ");
		//
		sqlStr.append("TO_CHAR(REC_DATE, 'dd/MM/YYYY'), TEMP, WBC, BP, UO, ");
		sqlStr.append("VENT_FIO2, CXR, RESP_SS, PROGRESS, ANTIBIOTICS, LAB_RESULT, ");
		//
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_ICU_DAILY ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND CASE_NUM = ?");
		sqlStr_getIcuDaily = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO IC_ICU_DAILY ");
		sqlStr.append("(");
		sqlStr.append("IC_SITE_CODE, ICTYPE, ");
		sqlStr.append(" CASE_NUM, HOSP_ADM_DATE, LAB_NUM, HOSPNUM,");
		sqlStr.append(" PATNAME, PATSEX, PATBDATE, AGE, MONTH,");
		sqlStr.append(" WARD, ROOM_NUM, BED_NUM, DATE_IN, ");
//
		sqlStr.append("REC_DATE, TEMP, WBC, BP, UO, ");
		sqlStr.append("VENT_FIO2, CXR, RESP_SS, PROGRESS, ANTIBIOTICS, LAB_RESULT, ");
//		
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_ENABLED ");		
//	
		sqlStr.append(") ");
		sqlStr.append("VALUES ");
		sqlStr.append("(");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" TO_NUMBER(?), TO_DATE(?, 'dd/MM/yyyy'), ?, ?, ");
		sqlStr.append(" ?, ?, TO_DATE(?, 'dd/MM/yyyy'), ?, ?, ");
		sqlStr.append(" ?, ?, ?, TO_DATE(?, 'dd/MM/yyyy'), ");
//
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), ?, ?, ?, ?, ");
		sqlStr.append(" ?, ?, ?, ?, ?, ?, ");
//		
		sqlStr.append(" sysdate, ?, 1");		
//
		sqlStr.append(") ");		
		sqlStr_insertIcuDaily = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE IC_ICU_DAILY ");
		sqlStr.append("SET ");
		sqlStr.append(" HOSP_ADM_DATE = TO_DATE(?, 'dd/MM/yyyy'), LAB_NUM = ?, HOSPNUM = ?, PATNAME = ?, PATSEX = ?, ");
		sqlStr.append(" PATBDATE = TO_DATE(?, 'dd/MM/yyyy'), ");
		sqlStr.append(" AGE = ?, MONTH = ?, WARD = ?, ROOM_NUM = ?, BED_NUM = ?, ");
		sqlStr.append(" DATE_IN = TO_DATE(?, 'dd/MM/yyyy'), ");
		//
		sqlStr.append("REC_DATE = TO_DATE(?, 'dd/MM/YYYY'), TEMP = ?, WBC = ?, BP = ?, UO = ?, ");
		sqlStr.append("VENT_FIO2 = ?, CXR = ?, RESP_SS = ?, PROGRESS = ?, ANTIBIOTICS = ?, LAB_RESULT = ?, ");
		//
		sqlStr.append(" ICTYPE = ?, ");
		sqlStr.append(" IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = ? ");		
		sqlStr.append(" WHERE ");
		sqlStr.append(" IC_SITE_CODE = ?");
		sqlStr.append(" AND CASE_NUM = TO_NUMBER(?)");
		sqlStr.append(" AND IC_ENABLED = 1");
		sqlStr_updateIcuDaily = sqlStr.toString();

		
		//new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, caseNum });
		sqlStr.setLength(0);
		sqlStr.append("UPDATE IC_ICU_DAILY ");
		sqlStr.append("SET    IC_ENABLED = 0, IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  IC_SITE_CODE = ? ");
		sqlStr.append("AND    CASE_NUM = ? ");
		sqlStr.append("AND    IC_ENABLED = 1 ");
		sqlStr_deleteIcuDaily = sqlStr.toString();
		//////////////////////////////////////
	}
}