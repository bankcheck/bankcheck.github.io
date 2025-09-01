package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class IcGeRespDB {
	UserBean userBean = new UserBean();
	private static String sqlStr_insertCorp = null;
	private static String sqlStr_updateCorp = null;	
	private static String sqlStr_updateCorpEnabled = null;
	private static String sqlStr_listCorp = null;
	private static String sqlStr_listCorpEnabled = null;

	private static String sqlStr_insertDate = null;
	private static String sqlStr_updateDate = null;

	private static String sqlStr_expireContract = null;
	private static String sqlStr_expireContractWithID = null;
	
	
	// ge_resp
	//private static String sqlStr_getICGeResp = null;	
//	private static String sqlStr_updateGE_Resp = null;
	private static String sqlStr_updateGE_RespEnabled = null;
	private static String sqlStr_InsertGE_Resp = null;	
	
	// bld mrsa esbl
	private static String sqlStr_getGEResp = null;
	private static String sqlStr_getGERespList = null;
	private static String sqlStr_InsertGEResp = null;
	private static String sqlStr_UpdateGEResp = null;	
	private static String sqlStr_DeleteGEResp = null;	


	private static String getNextCaseNum() {
		String haaID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CASE_NUM) + 1 FROM IC_GE_RESP");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			haaID = reportableListObject.getValue(0);

			// set 1 for initial
			if (haaID == null || haaID.length() == 0) return "1";
		}
		return haaID;
	}

	public static String add(UserBean userBean) {
		// get next ID
		String CaseNum = getNextCaseNum();

		if (UtilDBWeb.updateQueue(
				sqlStr_insertCorp,
				new String[] { CaseNum, userBean.getLoginID(), userBean.getLoginID() })) {

			// insert default date
			UtilDBWeb.updateQueue(
					sqlStr_insertDate,
					new String[] { CaseNum, userBean.getLoginID(), userBean.getLoginID() });

			return CaseNum;
		} else {
			return null;
		}
	}

	
	// GE Resp
	
	public static ArrayList getList(String LabNum, String DateFrom, String DateTo, String icType) {
//		System.out.println("java get(.... :" +  DateFrom + " " + DateTo + " " + LabNum + " " + icType);
//		System.out.println(sqlStr_getBldMrsaEsblList);
		return UtilDBWeb.getReportableList(sqlStr_getGERespList, new String[] {DateFrom, DateTo, "%" + LabNum + "%", icType});
	}

	public static ArrayList get(String caseNum) {
		return UtilDBWeb.getReportableList(sqlStr_getGEResp, new String[] {caseNum });
	}
	
	public static ArrayList getOLD(UserBean userBean, String LabNum, String FromDateIn, String ToDateIn, String ICType) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT IC_SITE_CODE, CASE_NUM, TO_CHAR(CASE_DATE, 'dd/MM/YYYY'), LAB_NUM, HOSPNUM, PATNAME, PATSEX, ");
		sqlStr.append("TO_CHAR(PATBDATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY'), ");
		sqlStr.append("TOCC, TOCC2, ISOLATE, STD_PRECAUTION, FEVER38C, ");				
		sqlStr.append("ADMIT_ICU, TO_CHAR(ONSET_DATE, 'dd/MM/YYYY'), DV, ");
		sqlStr.append("HAI_CAI, OAHR, REMARKS, TO_CHAR(TRAN_DATE, 'dd/MM/YYYY'), TRANSFER");
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_GE_RESP ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND TO_DATE(?, 'dd/MM/YYYY') <= CASE_DATE AND TO_DATE(?, 'dd/MM/YYYY') >= CASE_DATE ");
		sqlStr.append("AND LAB_NUM like " + "'%" + LabNum + "%' ");
		sqlStr.append("AND IC_TYPE = '" + ICType + "' ");
		sqlStr.append("ORDER BY CASE_NUM");				
		
		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {FromDateIn, ToDateIn});
	}
	
	public static ArrayList getPatInfoByLabNum(UserBean userBean, String labNum) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		
		sqlStr.append("SELECT HOSPNUM, PATIENT, SEX, ");
		sqlStr.append("TO_CHAR(BIRTH_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, AGE_MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY') ");
		sqlStr.append("FROM LABO_MASTHEAD@LIS ");
		sqlStr.append("WHERE LAB_NUM = ?");
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {labNum});
	}
	
	public static ArrayList getPatInfoByHospNum(UserBean userBean, String HospNum) {
		
		System.out.println("getPatInfoByHospNum....");
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);		
		sqlStr.append("SELECT LM.LAB_NUM, LM.PATIENT, LM.SEX, ");
		sqlStr.append("TO_CHAR(LM.BIRTH_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("LM.AGE, LM.AGE_MONTH, LM.WARD, LM.ROOM_NUM, LM.BED_NUM,");
		sqlStr.append("TO_CHAR(LM.DATE_IN, 'dd/MM/YYYY') ");
		sqlStr.append("FROM LABO_MASTHEAD@LIS LM ");
		sqlStr.append("JOIN LABO_HEADER@LIS LH ON LM.LAB_NUM = LH.LAB_NUM AND LH.TEST_TYPE = '3' and lh.SPEC_TYPE IN ('BLOOD', 'URINE', 'SPU', 'SPUTUM1', 'SPUTUM2', 'SPUTUM3')");  
		sqlStr.append("JOIN LABO_DETAIL@LIS LD ON LM.LAB_NUM = LD.LAB_NUM AND LD.TEST_TYPE = '3' AND LD.TEST_NUM IN ('BC', 'UC', 'RESP')");
		sqlStr.append("WHERE HOSPNUM = ? AND TYPE = 'I' ORDER BY DATE_IN DESC");
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {HospNum});
	}

	public static ArrayList getMicBioOrganByLabNum(UserBean userBean, String LabNum) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);		
		sqlStr.append("SELECT ORG.DESCRIPTION, QTY.DESC_ENG ");
		sqlStr.append("FROM LABO_BACT_ORGANDTL@LIS DTL ");
		sqlStr.append("JOIN LABM_BACT_ORGANISM@LIS ORG ON ORG.ORGAN_CODE = DTL.ORGAN_CODE ");
		sqlStr.append("LEFT OUTER JOIN LABM_BACT_QUANTITY@LIS QTY ON QTY.INT_TCODE = DTL.QUAN_CODE ");
		sqlStr.append("WHERE DTL.LAB_NUM = ?");
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {LabNum});
	}

	public static ArrayList getMicBioAntiByLabNum(UserBean userBean, String LabNum) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);		
		sqlStr.append("SELECT  TEST_NUM, LP.SHORT_DESC, ");
		sqlStr.append("(SELECT DESCRIPTION FROM LABM_BACT_ORGANISM@LIS ORG ");
		sqlStr.append("WHERE TRIM(ORG.ORGAN_CODE) = TRIM(DTL.ORGAN_CODE)) AS ORGAN_DESC, ");
		sqlStr.append("(SELECT GENERIC_NAME || CASE WHEN (TRADE_NAME IS NULL) THEN ' ' ");
		sqlStr.append("ELSE ' (' || TRADE_NAME || ')'  END  FROM LABM_BACT_ANTIBIO@LIS ORG ");
		sqlStr.append("WHERE TRIM(ORG.ANTIBIO_CODE) = TRIM(DTL.ANTIBIO_CODE)) SUSCEP_DESC, ");
		sqlStr.append("SUSCEP_RST FROM LABO_BACT_SENSIDTL@LIS DTL JOIN LABM_PRICES@LIS LP ON ");
		sqlStr.append("LP.CODE =  DTL.TEST_NUM WHERE LAB_NUM = ? ORDER BY ORGAN_DESC, SUSCEP_DESC");
				
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {LabNum});
	}
	
	public static ArrayList getMicBioTextResultByLabNum(UserBean userBean, String LabNum) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT LD.RESULT_COMMENT, LD.RESULT, TO_CHAR(LM.DATE_RPT, 'DD-MM-YYYY') ");
		sqlStr.append("FROM LABO_DETAIL@LIS LD JOIN LABO_MASTHEAD@LIS LM ON LM.LAB_NUM = LD.LAB_NUM ");
		sqlStr.append("WHERE LD.LAB_NUM = ? AND LD.TEST_TYPE = '3'");
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {LabNum});
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
			String TOCC, String TOCC2, String ISOLATE, String STD_PRECAUTION, String Fever38C,
			String AdmitICU, String OnsetDate, String DV, String HaiCai,  
			String OAHR, String Remark, String TRAN_DATE, String TRANSFER
	) {
		// get next schedule ID
		String CaseNum = getNextCaseNum();
		
		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_InsertGEResp,
				new String[] {												
						CaseNum, CaseDate, LabNum, 
						HospNum, PatName, PatSex, PatBDate, 
						Age, Month, Ward, RoomNum, 
						BedNum, DateIn, TOCC, TOCC2, ISOLATE, STD_PRECAUTION, Fever38C,
						AdmitICU, OnsetDate, DV, HaiCai,  
						OAHR, Remark, TRAN_DATE, TRANSFER, icType,
						userBean.getLoginID(), "1"
				})) {
			return CaseNum;
		} else {
			return null;
		}
	}
	
	public static boolean update(
			UserBean userBean,
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
			String TOCC, String TOCC2, String ISOLATE, String STD_PRECAUTION, String Fever38C,
			String AdmitICU, String OnsetDate, String DV, String HaiCai,  
			String OAHR, String Remark, String TRAN_DATE, String TRANSFER, 			
			String CaseNum
	) {
		// try to update selected record
		if(UtilDBWeb.updateQueue(
				sqlStr_UpdateGEResp, 
				new String[] {
						CaseDate, LabNum, 
						HospNum, PatName, PatSex, PatBDate,
						Age, Month, Ward, RoomNum, 
						BedNum, DateIn,
						TOCC,
						TOCC2,
						ISOLATE, 
						STD_PRECAUTION,
						Fever38C,
						AdmitICU,
						DV,
						OnsetDate,
						HaiCai,
						OAHR,
						Remark,
						TRAN_DATE, 
						TRANSFER,
						userBean.getLoginID(),
						CaseNum
				})) {
			return true;
		} else {
			return false;
		}
	}	

	public static boolean delete(UserBean userBean, String caseNum) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateGE_RespEnabled,
				new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, caseNum } );
	}
	
	public static boolean insertGe_Resp(UserBean userBean, String CaseDate, String LabNum, 
										String HospNum, String PatName, String PatSex, String PatBdate, 
										String Age, String Month, String Ward, String RoomNum,
										String BedNum, String DateIn, String TOCC, String TOCC2, String ISOLATE, String STD_PRECAUTION, String Fever38C,
										String AdmitICU, String OnsetDate, String DV, String HaiCai,  
										String OAHR, String Remark, String TRAN_DATE, String TRANSFER, String icType) {
		// get next ID
		String CaseNum = getNextCaseNum();
		System.out.println(CaseDate);
		System.out.println(PatBdate);		
		System.out.println(DateIn);
		System.out.println(OnsetDate);	
		
		return UtilDBWeb.updateQueue(
				sqlStr_InsertGE_Resp,
				new String[] { CaseNum, CaseDate, LabNum,
								HospNum, PatName, PatSex, PatBdate, 
								Age, Month, Ward, RoomNum,
								BedNum, DateIn, TOCC, TOCC2, ISOLATE, STD_PRECAUTION, Fever38C,
								AdmitICU, OnsetDate, DV, HaiCai,  
								OAHR, Remark, TRAN_DATE, TRANSFER, icType,
								userBean.getLoginID(), "1"} );
	}

	
	//////////////////////
	
	public static boolean updateOld(UserBean userBean, String haaID, String haaCorpName, String busType, String contactDateFrom, String contactDateTo, String enabled) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateCorp,
				new String[] { haaCorpName, busType, contactDateFrom, contactDateTo, enabled, userBean.getLoginID(), haaID } );
	}

	public static boolean archive(UserBean userBean, String haaID) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateCorpEnabled,
				new String[] { ConstantsVariable.TWO_VALUE, userBean.getLoginID(), haaID } );
	}

	public static String updateDate(UserBean userBean, String haaID, String haaDID, String initDate, String compDate) {
		// Update HAA_CHECKLIST_DATE
		if (UtilDBWeb.updateQueue(
				sqlStr_updateDate,
				new String[] {initDate, compDate, userBean.getLoginID(), haaID, haaDID})) {
			return haaDID;
		} else {
			return null;
		}
	}	

	public static ArrayList getProgress(UserBean userBean, String haaid) {
		// fetch HAACheckList Progress
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT P.HAA_CHECKLIST_PID, P.HAA_PROGRESS, P.HAA_DEPT, P.HAA_INIT_PARTY, ");
		sqlStr.append("		  TO_CHAR(D.HAA_INIT_DATE, 'dd/MM/YYYY'), P.HAA_RSPN, TO_CHAR(D.HAA_CMPLT_DATE, 'dd/MM/YYYY'), P.HAA_INDENT ");
		sqlStr.append("FROM   HAA_CHECKLIST_PROGRESS P, HAA_CHECKLIST_DATE D ");
		sqlStr.append("WHERE  D.HAA_ENABLED = P.HAA_ENABLED ");
		sqlStr.append("AND    D.HAA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    D.HAA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    D.HAA_CHECKLIST_DID = P.HAA_CHECKLIST_PID ");
		sqlStr.append("AND    D.HAA_ENABLED = 1 ");
		sqlStr.append("ORDER BY P.HAA_CHECKLIST_PID");
	
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { haaid });
	}

	public static boolean expiredContract(UserBean userBean) {
		return UtilDBWeb.updateQueue(
				sqlStr_expireContract );
	}

	public static boolean expiredContract(UserBean userBean, String haaid) {
		return UtilDBWeb.updateQueue(
				sqlStr_expireContractWithID,
				new String[] { haaid } );
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		// 	GE_RESP
		sqlStr.setLength(0);		
		sqlStr.append("SELECT IC_SITE_CODE, CASE_NUM, TO_CHAR(CASE_DATE, 'dd/MM/yyyy'), LAB_NUM, HOSPNUM, PATNAME, PATSEX, ");
		sqlStr.append("TO_CHAR(PATBDATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY'), ");		
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_GE_RESP ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
//		sqlStr.append("AND TO_DATE(?, 'dd/MM/YYYY') <= CASE_DATE AND TO_DATE(?, 'dd/MM/YYYY') >= CASE_DATE ");
		sqlStr.append("AND CASE_DATE > TO_DATE(?, 'dd/MM/YYYY') -1 and CASE_DATE < TO_DATE(?, 'dd/MM/YYYY') + 1");
		sqlStr.append("AND LAB_NUM like ? ");
		sqlStr.append("AND ICTYPE = ? ");
		sqlStr.append("ORDER BY CASE_NUM");
		sqlStr_getGERespList = sqlStr.toString();				
		
		sqlStr.setLength(0);		
		sqlStr.append("SELECT IC_SITE_CODE, CASE_NUM, TO_CHAR(CASE_DATE, 'dd/MM/yyyy'), LAB_NUM, HOSPNUM, PATNAME, PATSEX, ");
		sqlStr.append("TO_CHAR(PATBDATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY'), ");
		sqlStr.append("TOCC, TOCC2, ISOLATE, STD_PRECAUTION, FEVER38C, ADMIT_ICU, TO_CHAR(ONSET_DATE, 'dd/MM/yyyy'), ");
		sqlStr.append("DV, HAI_CAI, OAHR, REMARKS, TO_CHAR(TRAN_DATE, 'dd/MM/yyyy'), TRANSFER, ");
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_GE_RESP ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND CASE_NUM = ?");
		sqlStr_getGEResp = sqlStr.toString();
		
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE IC_GE_RESP ");
		sqlStr.append("SET    ");
		sqlStr.append("		  CASE_DATE = TO_DATE(?, 'dd/MM/YYYY'), LAB_NUM = ?, ");
		sqlStr.append("		  HOSPNUM = ?, PATNAME = ?, PATSEX = ?, PATBDATE = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("		  AGE = ?, MONTH = ?, WARD = ?, ROOM_NUM = ?, ");		
		sqlStr.append("       BED_NUM = ?, DATE_IN = TO_DATE(?, 'dd/MM/YYYY'),");
		sqlStr.append("		  TOCC = ?, ");
		sqlStr.append("		  TOCC2 = ?, ");
		sqlStr.append("		  ISOLATE = ?, ");
		sqlStr.append("		  STD_PRECAUTION = ?, ");		
		sqlStr.append("		  FEVER38C = ?, ");
		sqlStr.append("       ADMIT_ICU = ?, ");
		sqlStr.append("       DV = ?, ");
		sqlStr.append("       ONSET_DATE = TO_DATE(?, 'dd/MM/YYYY'), ");		
		sqlStr.append("       HAI_CAI = ?, ");
		sqlStr.append("       OAHR = ?, ");
		sqlStr.append("       REMARKS = ?, ");
		sqlStr.append("       TRAN_DATE = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       TRANSFER = ?, ");		 
		sqlStr.append("       IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND    IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CASE_NUM = to_number(?) ");
		sqlStr_UpdateGEResp = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO IC_GE_RESP (");
		sqlStr.append("IC_SITE_CODE, CASE_NUM, CASE_DATE, LAB_NUM, ");
		sqlStr.append("HOSPNUM, PATNAME, PATSEX, PATBDATE, ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, ");		
		sqlStr.append("BED_NUM, DATE_IN, TOCC, TOCC2, ISOLATE, STD_PRECAUTION, FEVER38C, ");		
		sqlStr.append("ADMIT_ICU, ONSET_DATE, DV, HAI_CAI, ");		
		sqlStr.append("OAHR, REMARKS, TRAN_DATE, TRANSFER, ICTYPE, ");
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED) "); 
		sqlStr.append("VALUES ");
		sqlStr.append("('" + ConstantsServerSide.SITE_CODE + "', ?, TO_DATE(?, 'dd/MM/YYYY'), ?,");
		sqlStr.append("?, ?, ?, TO_DATE(?, 'dd/MM/YYYY'),");
		sqlStr.append("?, ?, ?, ?,");
		sqlStr.append("?, TO_DATE(?, 'dd/MM/YYYY'), ?, ?, ?, ?, ?,");
		sqlStr.append("?, TO_DATE(?, 'dd/MM/YYYY'), ?, ?,");
		sqlStr.append("?, ?, TO_DATE(?, 'dd/MM/YYYY'), ?, ?,");
		sqlStr.append("SYSDATE, ?, null, null, TO_NUMBER(?))");		
		sqlStr_InsertGEResp = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE IC_GE_RESP ");
		sqlStr.append("SET    IC_ENABLED = ?, ");
		sqlStr.append("       IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND    IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CASE_NUM = ? ");
		sqlStr_updateCorpEnabled = sqlStr.toString();
		
		
//		CaseNum, CaseDate, LabNum,
//		HospNum, PatName, PatSex, PatBdate, 
//		Age, Month, Ward, RoomNum,
//		BedNum, DateIn, TOCC, Fever38C,
//		AdmitICU, OnsetDate, DV, HaiCai,  
//		OAHR, Remark, 
//		userBean.getLoginID(), "1"} );
		
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO IC_GE_RESP (");
		sqlStr.append("IC_SITE_CODE, CASE_NUM, CASE_DATE, LAB_NUM, ");
		sqlStr.append("HOSPNUM, PATNAME, PATSEX, PATBDATE, ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, ");		
		sqlStr.append("BED_NUM, DATE_IN, TOCC, TOCC2, STD_PRECAUTION, FEVER38C, ");		
		sqlStr.append("ADMIT_ICU, ONSET_DATE, DV, HAI_CAI, ");		
		sqlStr.append("OAHR, REMARKS, TRAN_DATE, TRANSFER, ICTYPE ");
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED) "); 
		sqlStr.append("VALUES ");
		sqlStr.append("('" + ConstantsServerSide.SITE_CODE + "', ?, TO_DATE(?, 'dd/MM/YYYY'), ?,");
		sqlStr.append("?, ?, ?, TO_DATE(?, 'dd/MM/YYYY'),");
		sqlStr.append("?, ?, ?, ?,");
		sqlStr.append("?, TO_DATE(?, 'dd/MM/YYYY'), ?, ?, ?, ?,");
		sqlStr.append("?, TO_DATE(?, 'dd/MM/YYYY'), ?, ?,");
		sqlStr.append("?, ?, TO_DATE(?, 'dd/MM/YYYY'), ?, ?,");
		sqlStr.append("SYSDATE, ?, null, null, TO_NUMBER(?))");		
		sqlStr_InsertGE_Resp = sqlStr.toString();
		
		//////////////////////
	
		sqlStr.setLength(0);
		sqlStr.append("UPDATE HAA_CHECKLIST ");
		sqlStr.append("SET    HAA_CORP_NAME = ?, HAA_BUSINESS_TYPE = ?, ");
		sqlStr.append("       HAA_CONTRACT_DATE_FROM = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       HAA_CONTRACT_DATE_TO = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       HAA_ENABLED = ?, ");
		sqlStr.append("       HAA_MODIFIED_DATE = SYSDATE, HAA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  HAA_ENABLED > 0 ");
		sqlStr.append("AND    HAA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    HAA_CHECKLIST_ID = ? ");
		sqlStr_updateCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT HAA_CHECKLIST_ID, HAA_CORP_NAME, HAA_BUSINESS_TYPE, ");
		sqlStr.append("       TO_CHAR(HAA_CONTRACT_DATE_FROM, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(HAA_CONTRACT_DATE_TO, 'dd/MM/YYYY'), ");
		sqlStr.append("       HAA_ENABLED ");
		sqlStr.append("FROM   HAA_CHECKLIST ");
		sqlStr.append("WHERE  HAA_ENABLED > 0 ");
		sqlStr.append("AND    HAA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("ORDER BY HAA_CORP_NAME");
		sqlStr_listCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT HAA_CHECKLIST_ID, HAA_CORP_NAME, HAA_BUSINESS_TYPE, ");
		sqlStr.append("       TO_CHAR(HAA_CONTRACT_DATE_FROM, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(HAA_CONTRACT_DATE_TO, 'dd/MM/YYYY'), ");
		sqlStr.append("       HAA_ENABLED ");
		sqlStr.append("FROM   HAA_CHECKLIST ");
		sqlStr.append("WHERE  HAA_ENABLED = ? ");
		sqlStr.append("AND    HAA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("ORDER BY HAA_CORP_NAME");
		sqlStr_listCorpEnabled = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO HAA_CHECKLIST_DATE (");
		sqlStr.append("HAA_SITE_CODE, HAA_CHECKLIST_ID, HAA_CHECKLIST_DID, HAA_CREATED_USER, HAA_MODIFIED_USER) ");
		sqlStr.append("SELECT '" + ConstantsServerSide.SITE_CODE + "', ?, HAA_CHECKLIST_PID, ?, ? FROM HAA_CHECKLIST_PROGRESS");
		sqlStr_insertDate = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE HAA_CHECKLIST_DATE ");
		sqlStr.append("SET    HAA_INIT_DATE = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       HAA_CMPLT_DATE = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       HAA_MODIFIED_DATE = SYSDATE, HAA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  HAA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    HAA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    HAA_CHECKLIST_DID = ? ");
		sqlStr_updateDate = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE HAA_CHECKLIST ");
		sqlStr.append("SET    HAA_ENABLED = 2 ");
		sqlStr.append("WHERE  HAA_ENABLED = 1 ");
		sqlStr.append("AND    HAA_CONTRACT_DATE_TO IS NOT NULL ");
		sqlStr.append("AND    HAA_CONTRACT_DATE_TO < SYSDATE ");
		sqlStr.append("AND    HAA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr_expireContract = sqlStr.toString();
		sqlStr.append("AND    HAA_CHECKLIST_ID = ? ");
		sqlStr_expireContractWithID = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE IC_GE_RESP ");
		sqlStr.append("SET    IC_ENABLED = 0, IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  IC_SITE_CODE = ? ");
		sqlStr.append("AND    CASE_NUM = ? ");
		sqlStr.append("AND    IC_ENABLED = 1 ");
		sqlStr_updateGE_RespEnabled = sqlStr.toString();
		
	}
}