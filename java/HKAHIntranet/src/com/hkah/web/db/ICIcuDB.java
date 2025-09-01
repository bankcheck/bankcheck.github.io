package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class ICIcuDB {

	// bld mrsa esbl
	private static String sqlStr_getIcu = null;
	private static String sqlStr_getIcuList = null;
	private static String sqlStr_insertIcu = null;
	private static String sqlStr_updateIcu = null;	
	private static String sqlStr_deleteIcu = null;	

	private static String getNextCaseNum() {
		String caseNum = null;

		// get next case num from db //
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CASE_NUM) + 1 FROM IC_ICU WHERE IC_SITE_CODE = ?",
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
			String PREV_ICU_ADM, String UNIT_TEAM, String TRANSFER_FROM, String ICU_ADM_DATE,String  TRANS_OUT_DATE,
			String DISC_DEST, String DIAG_ON_ICU,String BHX, String UNDER_DISE, String PREM_STAT, String ALLERGY,
			String DIAG_IN_ICU_DATE1,String DIAG_ON_ICU_DESC1,String DIAG_IN_ICU_DATE2,String DIAG_ON_ICU_DESC2,String DIAG_IN_ICU_DATE3,String DIAG_ON_ICU_DESC3,
			String DIAG_IN_ICU_DATE4,String DIAG_ON_ICU_DESC4,String DIAG_IN_ICU_DATE5,String DIAG_ON_ICU_DESC5,String DIAG_IN_ICU_DATE6,String DIAG_ON_ICU_DESC6,
			String DIAG_IN_ICU_DATE7,String DIAG_ON_ICU_DESC7,String DIAG_IN_ICU_DATE8,String DIAG_ON_ICU_DESC8,String DIAG_IN_ICU_DATE9,String DIAG_ON_ICU_DESC9,
			String DEV_INF,String VAP1,String CABSI11,String CAUT1,
			String INFECT_DATE1,String DEVICE_ONOFF_DATE1,String DEVICE_DAY1,
			String VAP2,String CABSI12,String CAUT2,
			String INFECT_DATE2,String DEVICE_ONOFF_DATE2,String DEVICE_DAY2,
			String SS1,String LAB_EVID1,String TREATMENT1,String SS2,String LAB_EVID2,String TREATMENT2,
			//
			String SI_DATE1, String SI_DESC1, String AIRWAY1,
			String VENT_ON1, String VENT_OFF1,String CL_SITE1, String CL_TYPE1,
			String CL_ON1, String CL_OFF1, String UC_TYPE1,
			String UC_ON1, String UC_OFF1, String AL_ON1, String AL_OFF1, String OTHER_DEV1,
			String SI_DATE2, String SI_DESC2, String AIRWAY2,
			String VENT_ON2, String VENT_OFF2,String CL_SITE2, String CL_TYPE2,
			String CL_ON2, String CL_OFF2, String UC_TYPE2,
			String UC_ON2, String UC_OFF2, String AL_ON2, String AL_OFF2, String OTHER_DEV2,						
			String SI_DATE3, String SI_DESC3, String AIRWAY3,
			String VENT_ON3, String VENT_OFF3, String CL_SITE3, String CL_TYPE3,
			String CL_ON3, String CL_OFF3, String UC_TYPE3,
			String UC_ON3, String UC_OFF3, String AL_ON3, String AL_OFF3, String OTHER_DEV3,						
			String SI_DATE4, String SI_DESC4, String AIRWAY4,
			String VENT_ON4, String VENT_OFF4, String CL_SITE4, String CL_TYPE4,
			String CL_ON4, String CL_OFF4, String UC_TYPE4,
			String UC_ON4, String UC_OFF4, String AL_ON4, String AL_OFF4, String OTHER_DEV4			
	) {
		// get next schedule ID
		String CaseNum = getNextCaseNum();
		
//		System.out.println("add(.... : " + BodySystem);
		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertIcu,
				new String[] {						
						ConstantsServerSide.SITE_CODE,
						icType,
						CaseNum, CaseDate, LabNum, HospNum,
						PatName, PatSex, PatBDate, Age, Month,
						Ward, RoomNum, BedNum, DateIn,
						PREV_ICU_ADM, UNIT_TEAM, TRANSFER_FROM, ICU_ADM_DATE, TRANS_OUT_DATE,
						DISC_DEST, DIAG_ON_ICU, BHX,UNDER_DISE, PREM_STAT, ALLERGY,
						DIAG_IN_ICU_DATE1, DIAG_ON_ICU_DESC1, DIAG_IN_ICU_DATE2, DIAG_ON_ICU_DESC2, DIAG_IN_ICU_DATE3, DIAG_ON_ICU_DESC3,	
						DIAG_IN_ICU_DATE4, DIAG_ON_ICU_DESC4, DIAG_IN_ICU_DATE5, DIAG_ON_ICU_DESC5, DIAG_IN_ICU_DATE6, DIAG_ON_ICU_DESC6,
						DIAG_IN_ICU_DATE7, DIAG_ON_ICU_DESC7, DIAG_IN_ICU_DATE8, DIAG_ON_ICU_DESC8, DIAG_IN_ICU_DATE9, DIAG_ON_ICU_DESC9,
						DEV_INF, 
						VAP1, CABSI11, CAUT1,
						INFECT_DATE1, DEVICE_ONOFF_DATE1, DEVICE_DAY1,
						VAP2, CABSI12, CAUT2,
						INFECT_DATE2, DEVICE_ONOFF_DATE2, DEVICE_DAY2,
						SS1, LAB_EVID1, TREATMENT1, SS2, LAB_EVID2, TREATMENT2,
						SI_DATE1, SI_DESC1, AIRWAY1,
						VENT_ON1, VENT_OFF1, CL_SITE1, CL_TYPE1,
						CL_ON1, CL_OFF1, UC_TYPE1,
						UC_ON1, UC_OFF1, AL_ON1, AL_OFF1, OTHER_DEV1,
						SI_DATE2, SI_DESC2, AIRWAY2,
						VENT_ON2, VENT_OFF2, CL_SITE2, CL_TYPE2,
						CL_ON2, CL_OFF2, UC_TYPE2,
						UC_ON2, UC_OFF2, AL_ON2, AL_OFF2, OTHER_DEV2,
						SI_DATE3, SI_DESC3, AIRWAY3,
						VENT_ON3, VENT_OFF3, CL_SITE3, CL_TYPE3,
						CL_ON3, CL_OFF3, UC_TYPE3,
						UC_ON3, UC_OFF3, AL_ON3, AL_OFF3, OTHER_DEV3,
						SI_DATE4, SI_DESC4, AIRWAY4,
						VENT_ON4, VENT_OFF4, CL_SITE4, CL_TYPE4,
						CL_ON4, CL_OFF4, UC_TYPE4,
						UC_ON4, UC_OFF4, AL_ON4, AL_OFF4, OTHER_DEV4,			
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
			String PREV_ICU_ADM, String UNIT_TEAM, String TRANSFER_FROM, String ICU_ADM_DATE, String TRANS_OUT_DATE,
			String DISC_DEST, String DIAG_ON_ICU, String BHX, String UNDER_DISE, String PREM_STAT, String ALLERGY,
			String DIAG_IN_ICU_DATE1, String DIAG_ON_ICU_DESC1, String DIAG_IN_ICU_DATE2, String DIAG_ON_ICU_DESC2, String DIAG_IN_ICU_DATE3, String DIAG_ON_ICU_DESC3,
			String DIAG_IN_ICU_DATE4, String DIAG_ON_ICU_DESC4, String DIAG_IN_ICU_DATE5, String DIAG_ON_ICU_DESC5, String DIAG_IN_ICU_DATE6, String DIAG_ON_ICU_DESC6,
			String DIAG_IN_ICU_DATE7, String DIAG_ON_ICU_DESC7, String DIAG_IN_ICU_DATE8, String DIAG_ON_ICU_DESC8, String DIAG_IN_ICU_DATE9, String DIAG_ON_ICU_DESC9,					
			String DEV_INF, String VAP1, String CABSI11, String CAUT1,
			String INFECT_DATE1, String DEVICE_ONOFF_DATE1, String DEVICE_DAY1,
			String VAP2, String CABSI12, String CAUT2,
			String INFECT_DATE2, String DEVICE_ONOFF_DATE2, String DEVICE_DAY2,
			String SS1, String LAB_EVID1, String TREATMENT1, String SS2, String LAB_EVID2, String TREATMENT2,
			//
			String SI_DATE1, String SI_DESC1, String AIRWAY1,
			String VENT_ON1, String VENT_OFF1,String CL_SITE1, String CL_TYPE1,
			String CL_ON1, String CL_OFF1, String UC_TYPE1,
			String UC_ON1, String UC_OFF1, String AL_ON1, String AL_OFF1, String OTHER_DEV1,
			String SI_DATE2, String SI_DESC2, String AIRWAY2,
			String VENT_ON2, String VENT_OFF2,String CL_SITE2, String CL_TYPE2,
			String CL_ON2, String CL_OFF2, String UC_TYPE2,
			String UC_ON2, String UC_OFF2, String AL_ON2, String AL_OFF2, String OTHER_DEV2,						
			String SI_DATE3, String SI_DESC3, String AIRWAY3,
			String VENT_ON3, String VENT_OFF3, String CL_SITE3, String CL_TYPE3,
			String CL_ON3, String CL_OFF3, String UC_TYPE3,
			String UC_ON3, String UC_OFF3, String AL_ON3, String AL_OFF3, String OTHER_DEV3,						
			String SI_DATE4, String SI_DESC4, String AIRWAY4,
			String VENT_ON4, String VENT_OFF4, String CL_SITE4, String CL_TYPE4,
			String CL_ON4, String CL_OFF4, String UC_TYPE4,
			String UC_ON4, String UC_OFF4, String AL_ON4, String AL_OFF4, String OTHER_DEV4,						
			
			//
			String icType,
			String CaseNum
	) {
		//System.out.println("update(.... : " +  IVCatheter);
		// try to update selected record
		if(UtilDBWeb.updateQueue(
				sqlStr_updateIcu,
				new String[] {
						HospAdmDate, 
						LabNum, HospNum, PatName, 
						PatSex, 
						PatBDate,
						Age, Month, Ward, RoomNum, BedNum, 
						DateIn,	
						PREV_ICU_ADM, UNIT_TEAM, TRANSFER_FROM, ICU_ADM_DATE, TRANS_OUT_DATE,
						DISC_DEST, DIAG_ON_ICU, BHX,UNDER_DISE, PREM_STAT, ALLERGY,
						DIAG_IN_ICU_DATE1, DIAG_ON_ICU_DESC1, DIAG_IN_ICU_DATE2, DIAG_ON_ICU_DESC2, DIAG_IN_ICU_DATE3, DIAG_ON_ICU_DESC3,	
						DIAG_IN_ICU_DATE4, DIAG_ON_ICU_DESC4, DIAG_IN_ICU_DATE5, DIAG_ON_ICU_DESC5, DIAG_IN_ICU_DATE6, DIAG_ON_ICU_DESC6,
						DIAG_IN_ICU_DATE7, DIAG_ON_ICU_DESC7, DIAG_IN_ICU_DATE8, DIAG_ON_ICU_DESC8, DIAG_IN_ICU_DATE9, DIAG_ON_ICU_DESC9,
						DEV_INF, VAP1, CABSI11, CAUT1,
						INFECT_DATE1, DEVICE_ONOFF_DATE1, DEVICE_DAY1,
						VAP2, CABSI12, CAUT2,
						INFECT_DATE2, DEVICE_ONOFF_DATE2, DEVICE_DAY2,
						SS1, LAB_EVID1, TREATMENT1, SS2, LAB_EVID2, TREATMENT2,
						//
						SI_DATE1, SI_DESC1, AIRWAY1,
						VENT_ON1, VENT_OFF1, CL_SITE1, CL_TYPE1,
						CL_ON1, CL_OFF1, UC_TYPE1,
						UC_ON1, UC_OFF1, AL_ON1, AL_OFF1, OTHER_DEV1,
						SI_DATE2, SI_DESC2, AIRWAY2,
						VENT_ON2, VENT_OFF2, CL_SITE2, CL_TYPE2,
						CL_ON2, CL_OFF2, UC_TYPE2,
						UC_ON2, UC_OFF2, AL_ON2, AL_OFF2, OTHER_DEV2,
						SI_DATE3, SI_DESC3, AIRWAY3,
						VENT_ON3, VENT_OFF3, CL_SITE3, CL_TYPE3,
						CL_ON3, CL_OFF3, UC_TYPE3,
						UC_ON3, UC_OFF3, AL_ON3, AL_OFF3, OTHER_DEV3,
						SI_DATE4, SI_DESC4, AIRWAY4,
						VENT_ON4, VENT_OFF4, CL_SITE4, CL_TYPE4,
						CL_ON4, CL_OFF4, UC_TYPE4,
						UC_ON4, UC_OFF4, AL_ON4, AL_OFF4, OTHER_DEV4,						
						//
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
				sqlStr_deleteIcu,
				new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, caseNum });
	}

	public static ArrayList get(String caseNum) {
		return UtilDBWeb.getReportableList(sqlStr_getIcu, new String[] {caseNum });
	}

	public static ArrayList getList(String LabNum, String DateFrom, String DateTo) {
		return UtilDBWeb.getReportableList(sqlStr_getIcuList, new String[] {DateFrom, DateTo, "%" + LabNum + "%"});
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
		sqlStr.append("DISC_DEST, DIAG_ON_ICU, BHX, UNDER_DISE, PREM_STAT, ALLERGY,");		

		sqlStr.append("DIAG_IN_ICU_DATE1, DIAG_ON_ICU_DESC1, DIAG_IN_ICU_DATE2, DIAG_ON_ICU_DESC2, DIAG_IN_ICU_DATE3, DIAG_ON_ICU_DESC3, ");
		sqlStr.append("DIAG_IN_ICU_DATE4, DIAG_ON_ICU_DESC4, DIAG_IN_ICU_DATE5, DIAG_ON_ICU_DESC5, DIAG_IN_ICU_DATE6, DIAG_ON_ICU_DESC6, ");
		sqlStr.append("DIAG_IN_ICU_DATE7, DIAG_ON_ICU_DESC7, DIAG_IN_ICU_DATE8, DIAG_ON_ICU_DESC8, DIAG_IN_ICU_DATE9, DIAG_ON_ICU_DESC9, ");
		sqlStr.append("DEV_INF, ");
		sqlStr.append("VAP1, CABSI11, CAUT1, INFECT_DATE1, DEVICE_ONOFF_DATE1, DEVICE_DAY1, ");
		sqlStr.append("VAP2, CABSI12, CAUT2, INFECT_DATE2, DEVICE_ONOFF_DATE2, DEVICE_DAY2, ");		
		sqlStr.append("SS1, LAB_EVID1, TREATMENT1, SS2, LAB_EVID2, TREATMENT2, ");

		sqlStr.append("SI_DATE1, SI_DESC1, AIRWAY1, VENT_ON1, VENT_OFF1, CL_SITE1, CL_TYPE1, CL_ON1, CL_OFF1,");
		sqlStr.append("UC_TYPE1, UC_ON1, UC_OFF1, AL_ON1, AL_OFF1, OTHER_DEV1,");
		sqlStr.append("SI_DATE2, SI_DESC2, AIRWAY2, VENT_ON2, VENT_OFF2, CL_SITE2, CL_TYPE2, CL_ON2, CL_OFF2, ");
		sqlStr.append("UC_TYPE2, UC_ON2, UC_OFF2, AL_ON2, AL_OFF2, OTHER_DEV2,");
		sqlStr.append("SI_DATE3, SI_DESC3, AIRWAY3, VENT_ON3, VENT_OFF3, CL_SITE3, CL_TYPE3, CL_ON3, CL_OFF3, ");
		sqlStr.append("UC_TYPE3, UC_ON3, UC_OFF3, AL_ON3, AL_OFF3, OTHER_DEV3,");
		sqlStr.append("SI_DATE4, SI_DESC4, AIRWAY4, VENT_ON4, VENT_OFF4, CL_SITE4, CL_TYPE4, CL_ON4, CL_OFF4, ");
		sqlStr.append("UC_TYPE4, UC_ON4, UC_OFF4, AL_ON4, AL_OFF4, OTHER_DEV4,");
		
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_ICU ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND HOSP_ADM_DATE > TO_DATE(?, 'dd/MM/YYYY') -1 and HOSP_ADM_DATE < TO_DATE(?, 'dd/MM/YYYY') + 1");
		sqlStr.append("AND LAB_NUM like ? ");
		sqlStr.append("AND ICTYPE = 'icu' ");
		sqlStr.append("ORDER BY CASE_NUM");
		sqlStr_getIcuList = sqlStr.toString();
		
		sqlStr.setLength(0);		
		sqlStr.append("SELECT IC_SITE_CODE, CASE_NUM, TO_CHAR(HOSP_ADM_DATE, 'dd/MM/yyyy'), LAB_NUM, HOSPNUM, PATNAME, PATSEX, ");
		sqlStr.append("TO_CHAR(PATBDATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY'), ");
		sqlStr.append("PREV_ICU_ADM, UNIT_TEAM, TRANSFER_FROM, TO_CHAR(ICU_ADM_DATE, 'dd/MM/YYYY'), TO_CHAR(TRANS_OUT_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("DISC_DEST, DIAG_ON_ICU, BHX, UNDER_DISE, PREM_STAT, ALLERGY, ");
		sqlStr.append("TO_CHAR(DIAG_IN_ICU_DATE1, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC1, TO_CHAR(DIAG_IN_ICU_DATE2, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC2, TO_CHAR(DIAG_IN_ICU_DATE3, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC3, ");
		sqlStr.append("TO_CHAR(DIAG_IN_ICU_DATE4, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC4, TO_CHAR(DIAG_IN_ICU_DATE5, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC5, TO_CHAR(DIAG_IN_ICU_DATE6, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC6, ");
		sqlStr.append("TO_CHAR(DIAG_IN_ICU_DATE7, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC7, TO_CHAR(DIAG_IN_ICU_DATE8, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC8, TO_CHAR(DIAG_IN_ICU_DATE9, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC9, ");
		sqlStr.append("DEV_INF, VAP1, CABSI11, CAUT1, ");
		sqlStr.append("TO_CHAR(INFECT_DATE1, 'dd/MM/yyyy'), TO_CHAR(DEVICE_ONOFF_DATE1, 'dd/MM/yyyy'), DEVICE_DAY1, ");
		sqlStr.append("         VAP2, CABSI12, CAUT2, ");
		sqlStr.append("TO_CHAR(INFECT_DATE2, 'dd/MM/yyyy'), TO_CHAR(DEVICE_ONOFF_DATE2, 'dd/MM/yyyy'), DEVICE_DAY2, " );
		sqlStr.append("SS1, LAB_EVID1, TREATMENT1, SS2, LAB_EVID2, TREATMENT2, ");
		sqlStr.append("TO_CHAR(SI_DATE1, 'dd/MM/yyyy'), SI_DESC1, AIRWAY1, ");
		sqlStr.append("TO_CHAR(VENT_ON1, 'dd/MM/yyyy'), TO_CHAR(VENT_OFF1, 'dd/MM/yyyy'), CL_SITE1, CL_TYPE1, ");
		sqlStr.append("TO_CHAR(CL_ON1, 'dd/MM/yyyy'), TO_CHAR(CL_OFF1, 'dd/MM/yyyy'), UC_TYPE1, ");
		sqlStr.append("TO_CHAR(UC_ON1, 'dd/MM/yyyy'), TO_CHAR(UC_OFF1, 'dd/MM/yyyy'), TO_CHAR(AL_ON1, 'dd/MM/yyyy'), TO_CHAR(AL_OFF1, 'dd/MM/yyyy'), OTHER_DEV1,");
		sqlStr.append("TO_CHAR(SI_DATE2, 'dd/MM/yyyy'), SI_DESC2, AIRWAY2, ");
		sqlStr.append("TO_CHAR(VENT_ON2, 'dd/MM/yyyy'), TO_CHAR(VENT_OFF2, 'dd/MM/yyyy'), CL_SITE2, CL_TYPE2, ");
		sqlStr.append("TO_CHAR(CL_ON2, 'dd/MM/yyyy'), TO_CHAR(CL_OFF2, 'dd/MM/yyyy'), UC_TYPE2, ");
		sqlStr.append("TO_CHAR(UC_ON2, 'dd/MM/yyyy'), TO_CHAR(UC_OFF2, 'dd/MM/yyyy'), TO_CHAR(AL_ON2, 'dd/MM/yyyy'), TO_CHAR(AL_OFF2, 'dd/MM/yyyy'), OTHER_DEV2,");
		sqlStr.append("TO_CHAR(SI_DATE3, 'dd/MM/yyyy'), SI_DESC3, AIRWAY3, ");
		sqlStr.append("TO_CHAR(VENT_ON3, 'dd/MM/yyyy'), TO_CHAR(VENT_OFF3, 'dd/MM/yyyy'), CL_SITE3, CL_TYPE3, ");
		sqlStr.append("TO_CHAR(CL_ON3, 'dd/MM/yyyy'), TO_CHAR(CL_OFF3, 'dd/MM/yyyy'), UC_TYPE3, ");
		sqlStr.append("TO_CHAR(UC_ON3, 'dd/MM/yyyy'), TO_CHAR(UC_OFF3, 'dd/MM/yyyy'), TO_CHAR(AL_ON3, 'dd/MM/yyyy'), TO_CHAR(AL_OFF3, 'dd/MM/yyyy'), OTHER_DEV3,");
		sqlStr.append("TO_CHAR(SI_DATE4, 'dd/MM/yyyy'), SI_DESC4, AIRWAY4, ");
		sqlStr.append("TO_CHAR(VENT_ON4, 'dd/MM/yyyy'), TO_CHAR(VENT_OFF4, 'dd/MM/yyyy'), CL_SITE4, CL_TYPE4, ");
		sqlStr.append("TO_CHAR(CL_ON4, 'dd/MM/yyyy'), TO_CHAR(CL_OFF4, 'dd/MM/yyyy'), UC_TYPE4, ");
		sqlStr.append("TO_CHAR(UC_ON4, 'dd/MM/yyyy'), TO_CHAR(UC_OFF4, 'dd/MM/yyyy'), TO_CHAR(AL_ON4, 'dd/MM/yyyy'), TO_CHAR(AL_OFF4, 'dd/MM/yyyy'), OTHER_DEV4,");

		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_ICU ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND CASE_NUM = ?");
		sqlStr_getIcu = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO IC_ICU ");
		sqlStr.append("(");
		sqlStr.append("IC_SITE_CODE, ICTYPE, ");
		sqlStr.append(" CASE_NUM, HOSP_ADM_DATE, LAB_NUM, HOSPNUM,");
		sqlStr.append(" PATNAME, PATSEX, PATBDATE, AGE, MONTH,");
		sqlStr.append(" WARD, ROOM_NUM, BED_NUM, DATE_IN, ");
//
		sqlStr.append(" PREV_ICU_ADM, UNIT_TEAM, TRANSFER_FROM, ICU_ADM_DATE, TRANS_OUT_DATE, ");
		sqlStr.append(" DISC_DEST, DIAG_ON_ICU, BHX, UNDER_DISE, PREM_STAT, ALLERGY, ");
		sqlStr.append(" DIAG_IN_ICU_DATE1, DIAG_ON_ICU_DESC1, DIAG_IN_ICU_DATE2, DIAG_ON_ICU_DESC2, DIAG_IN_ICU_DATE3, DIAG_ON_ICU_DESC3, ");
		sqlStr.append(" DIAG_IN_ICU_DATE4, DIAG_ON_ICU_DESC4, DIAG_IN_ICU_DATE5, DIAG_ON_ICU_DESC5, DIAG_IN_ICU_DATE6, DIAG_ON_ICU_DESC6, ");
		sqlStr.append(" DIAG_IN_ICU_DATE7, DIAG_ON_ICU_DESC7, DIAG_IN_ICU_DATE8, DIAG_ON_ICU_DESC8, DIAG_IN_ICU_DATE9, DIAG_ON_ICU_DESC9, ");
		sqlStr.append(" DEV_INF, "); 
		sqlStr.append(" VAP1, CABSI11, CAUT1, ");
		sqlStr.append(" INFECT_DATE1, DEVICE_ONOFF_DATE1, DEVICE_DAY1, ");
		sqlStr.append(" VAP2, CABSI12, CAUT2, ");
		sqlStr.append(" INFECT_DATE2, DEVICE_ONOFF_DATE2, DEVICE_DAY2,");
		sqlStr.append("SS1, LAB_EVID1, TREATMENT1, SS2, LAB_EVID2, TREATMENT2, ");
		//
		sqlStr.append("SI_DATE1, SI_DESC1, AIRWAY1, ");
		sqlStr.append("VENT_ON1, VENT_OFF1, CL_SITE1, CL_TYPE1, ");
		sqlStr.append("CL_ON1, CL_OFF1, UC_TYPE1, ");
		sqlStr.append("UC_ON1, UC_OFF1, AL_ON1, AL_OFF1, OTHER_DEV1,");
		sqlStr.append("SI_DATE2, SI_DESC2, AIRWAY2,");
		sqlStr.append("VENT_ON2, VENT_OFF2, CL_SITE2, CL_TYPE2,");
		sqlStr.append("CL_ON2, CL_OFF2, UC_TYPE2,");
		sqlStr.append("UC_ON2, UC_OFF2, AL_ON2, AL_OFF2, OTHER_DEV2,");
		sqlStr.append("SI_DATE3, SI_DESC3, AIRWAY3,");
		sqlStr.append("VENT_ON3, VENT_OFF3, CL_SITE3, CL_TYPE3,");
		sqlStr.append("CL_ON3, CL_OFF3, UC_TYPE3,");
		sqlStr.append("UC_ON3, UC_OFF3, AL_ON3, AL_OFF3, OTHER_DEV3,");
		sqlStr.append("SI_DATE4, SI_DESC4, AIRWAY4,");
		sqlStr.append("VENT_ON4, VENT_OFF4, CL_SITE4, CL_TYPE4,");
		sqlStr.append("CL_ON4, CL_OFF4, UC_TYPE4,");
		sqlStr.append("UC_ON4, UC_OFF4, AL_ON4, AL_OFF4, OTHER_DEV4,");
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
		sqlStr.append(" ?, ?, ?, TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ");
		sqlStr.append(" ?, ?, ?, ?, ?, ?, ");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), ?, TO_DATE(?, 'dd/MM/yyyy'), ?, TO_DATE(?, 'dd/MM/yyyy'), ?, ");		
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), ?, TO_DATE(?, 'dd/MM/yyyy'), ?, TO_DATE(?, 'dd/MM/yyyy'), ?, ");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), ?, TO_DATE(?, 'dd/MM/yyyy'), ?, TO_DATE(?, 'dd/MM/yyyy'), ?, ");
		sqlStr.append(" ?, ");
		sqlStr.append(" ?, ?, ?, ");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?,");
		sqlStr.append(" ?, ?, ?, ");		
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?,");
		sqlStr.append(" ?, ?, ?, ?, ?, ?, ");
//
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), ?, ?,");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?, ?,");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?, ");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?,");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), ?, ?,");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?, ?,");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?, ");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?,");		
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), ?, ?,");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?, ?,");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?, ");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?,");		
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), ?, ?,");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?, ?,");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?, ");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?,");	
//		
		sqlStr.append(" sysdate, ?, 1");		
//
		sqlStr.append(") ");		
		sqlStr_insertIcu = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE IC_ICU ");
		sqlStr.append("SET ");
		sqlStr.append(" HOSP_ADM_DATE = TO_DATE(?, 'dd/MM/yyyy'), LAB_NUM = ?, HOSPNUM = ?, PATNAME = ?, PATSEX = ?, ");
		sqlStr.append(" PATBDATE = TO_DATE(?, 'dd/MM/yyyy'), ");
		sqlStr.append(" AGE = ?, MONTH = ?, WARD = ?, ROOM_NUM = ?, BED_NUM = ?, ");
		sqlStr.append(" DATE_IN = TO_DATE(?, 'dd/MM/yyyy'), ");
		//
		sqlStr.append(" PREV_ICU_ADM = ?, UNIT_TEAM = ?, TRANSFER_FROM = ?, ICU_ADM_DATE = TO_DATE(?, 'dd/MM/yyyy'), TRANS_OUT_DATE  = TO_DATE(?, 'dd/MM/YYYY'),");
		sqlStr.append(" DISC_DEST = ?, DIAG_ON_ICU = ?, BHX = ?, UNDER_DISE = ?, PREM_STAT = ?, ALLERGY = ?, ");
		sqlStr.append(" DIAG_IN_ICU_DATE1 = TO_DATE(?, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC1 = ?, DIAG_IN_ICU_DATE2 = TO_DATE(?, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC2 = ?, DIAG_IN_ICU_DATE3 = TO_DATE(?, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC3 = ?, ");
		sqlStr.append(" DIAG_IN_ICU_DATE4 = TO_DATE(?, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC4 = ?, DIAG_IN_ICU_DATE5 = TO_DATE(?, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC5 = ?, DIAG_IN_ICU_DATE6 = TO_DATE(?, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC6 = ?, ");
		sqlStr.append(" DIAG_IN_ICU_DATE7 = TO_DATE(?, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC7 = ?, DIAG_IN_ICU_DATE8 = TO_DATE(?, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC8 = ?, DIAG_IN_ICU_DATE9 = TO_DATE(?, 'dd/MM/yyyy'), DIAG_ON_ICU_DESC9 = ?, ");		
		sqlStr.append(" DEV_INF = ?, " );
		sqlStr.append("VAP1 = ?, CABSI11 = ?, CAUT1 = ?, INFECT_DATE1 = TO_DATE(?, 'dd/MM/yyyy'), DEVICE_ONOFF_DATE1 = TO_DATE(?, 'dd/MM/yyyy'), DEVICE_DAY1 = ?, ");
		sqlStr.append("VAP2 = ?, CABSI12 = ?, CAUT2 = ?, INFECT_DATE2 = TO_DATE(?, 'dd/MM/yyyy'), DEVICE_ONOFF_DATE2 = TO_DATE(?, 'dd/MM/yyyy'), DEVICE_DAY2 = ?, ");
		sqlStr.append("SS1 = ?, LAB_EVID1 = ?, TREATMENT1 = ?, SS2 = ?, LAB_EVID2 = ?, TREATMENT2 = ?, ");
		//
		sqlStr.append("SI_DATE1 = TO_DATE(?, 'dd/MM/yyyy'), SI_DESC1 = ?, AIRWAY1 = ?, ");
		sqlStr.append("VENT_ON1 = TO_DATE(?, 'dd/MM/yyyy'), VENT_OFF1 = TO_DATE(?, 'dd/MM/yyyy'), CL_SITE1 = ?, CL_TYPE1 = ?, ");
		sqlStr.append("CL_ON1 = TO_DATE(?, 'dd/MM/yyyy'), CL_OFF1 = TO_DATE(?, 'dd/MM/yyyy'), UC_TYPE1 = ?, ");
		sqlStr.append("UC_ON1 = TO_DATE(?, 'dd/MM/yyyy'), UC_OFF1 = TO_DATE(?, 'dd/MM/yyyy'), AL_ON1 = TO_DATE(?, 'dd/MM/yyyy'), AL_OFF1 = TO_DATE(?, 'dd/MM/yyyy'), OTHER_DEV1 = ?,");
		sqlStr.append("SI_DATE2 = TO_DATE(?, 'dd/MM/yyyy'), SI_DESC2 = ?, AIRWAY2 = ?, ");
		sqlStr.append("VENT_ON2 = TO_DATE(?, 'dd/MM/yyyy'), VENT_OFF2 = TO_DATE(?, 'dd/MM/yyyy'), CL_SITE2 = ?, CL_TYPE2 = ?, ");
		sqlStr.append("CL_ON2 = TO_DATE(?, 'dd/MM/yyyy'), CL_OFF2 = TO_DATE(?, 'dd/MM/yyyy'), UC_TYPE2 = ?, ");
		sqlStr.append("UC_ON2 = TO_DATE(?, 'dd/MM/yyyy'), UC_OFF2 = TO_DATE(?, 'dd/MM/yyyy'), AL_ON2 = TO_DATE(?, 'dd/MM/yyyy'), AL_OFF2 = TO_DATE(?, 'dd/MM/yyyy'), OTHER_DEV2 = ?,");
		sqlStr.append("SI_DATE3 = TO_DATE(?, 'dd/MM/yyyy'), SI_DESC3 = ?, AIRWAY3 = ?, ");
		sqlStr.append("VENT_ON3 = TO_DATE(?, 'dd/MM/yyyy'), VENT_OFF3 = TO_DATE(?, 'dd/MM/yyyy'), CL_SITE3 = ?, CL_TYPE3 = ?, ");
		sqlStr.append("CL_ON3 = TO_DATE(?, 'dd/MM/yyyy'), CL_OFF3 = TO_DATE(?, 'dd/MM/yyyy'), UC_TYPE3 = ?, ");
		sqlStr.append("UC_ON3 = TO_DATE(?, 'dd/MM/yyyy'), UC_OFF3 = TO_DATE(?, 'dd/MM/yyyy'), AL_ON3 = TO_DATE(?, 'dd/MM/yyyy'), AL_OFF3 = TO_DATE(?, 'dd/MM/yyyy'), OTHER_DEV3 = ?,");
		sqlStr.append("SI_DATE4 = TO_DATE(?, 'dd/MM/yyyy'), SI_DESC4 = ?, AIRWAY4 = ?, ");
		sqlStr.append("VENT_ON4 = TO_DATE(?, 'dd/MM/yyyy'), VENT_OFF4 = TO_DATE(?, 'dd/MM/yyyy'), CL_SITE4 = ?, CL_TYPE4 = ?, ");
		sqlStr.append("CL_ON4 = TO_DATE(?, 'dd/MM/yyyy'), CL_OFF4 = TO_DATE(?, 'dd/MM/yyyy'), UC_TYPE4 = ?, ");
		sqlStr.append("UC_ON4 = TO_DATE(?, 'dd/MM/yyyy'), UC_OFF4 = TO_DATE(?, 'dd/MM/yyyy'), AL_ON4 = TO_DATE(?, 'dd/MM/yyyy'), AL_OFF4 = TO_DATE(?, 'dd/MM/yyyy'), OTHER_DEV4 = ?,");
		//
		sqlStr.append(" ICTYPE = ?, ");
		sqlStr.append(" IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = ? ");		
		sqlStr.append(" WHERE ");
		sqlStr.append(" IC_SITE_CODE = ?");
		sqlStr.append(" AND CASE_NUM = TO_NUMBER(?)");
		sqlStr.append(" AND IC_ENABLED = 1");
		sqlStr_updateIcu = sqlStr.toString();

		
		//new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, caseNum });
		sqlStr.setLength(0);
		sqlStr.append("UPDATE IC_ICU ");
		sqlStr.append("SET    IC_ENABLED = 0, IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  IC_SITE_CODE = ? ");
		sqlStr.append("AND    CASE_NUM = ? ");
		sqlStr.append("AND    IC_ENABLED = 1 ");
		sqlStr_deleteIcu = sqlStr.toString();
		//////////////////////////////////////
	}
}