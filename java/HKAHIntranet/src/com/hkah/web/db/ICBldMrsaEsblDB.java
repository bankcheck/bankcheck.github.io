package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class ICBldMrsaEsblDB {

	// bld mrsa esbl
	private static String sqlStr_getBldMrsaEsbl = null;
	private static String sqlStr_getBldMrsaEsblList = null;
	private static String sqlStr_getBldMrsaEsblList_bld = null;
	private static String sqlStr_insertBldMrsaEsbl = null;
	private static String sqlStr_updateBldMrsaEsbl = null;	
	private static String sqlStr_deleteBldMrsaEsbl = null;	

	private static String getNextCaseNum() {
		String caseNum = null;

		// get next case num from db //
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CASE_NUM) + 1 FROM IC_BLD_MRSA_ESBL WHERE IC_SITE_CODE = ?",
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
			String Source, 
			String CaseDefine,	
			String Status, String BodySystem, String IsolateOrgan, String Phx, String PhxOther, String ClinicalInfo,
			String BpP, String BpPTemp, String ISOLATE, String STD_PRECAUTION, String TRAN_DATE, String TRANSFER, String Wcc, String WccN, String WccL,
			String Device, String IVCatheter, String IVCatheterOther, String Proc, String ChestSign,			
			String IVSite, String IVSiteOther, String Urinary, 
			String OtherPhySign, String Antibiotics, String FinalDisp, String TransferTo,	
			String HospDefine, String AdmissionCO, String DeviceMrsaEsbl, String UrinaryOther
	) {
		// get next schedule ID
		String CaseNum = getNextCaseNum();
		
//		System.out.println("add(.... : " + BodySystem);
		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertBldMrsaEsbl,
				new String[] {						
						ConstantsServerSide.SITE_CODE,
						icType,
						CaseNum, CaseDate, LabNum, HospNum,
						PatName, PatSex, PatBDate, Age, Month,
						Ward, RoomNum, BedNum, DateIn, Source, CaseDefine,
						Status, BodySystem, IsolateOrgan, Phx, PhxOther, ClinicalInfo,
						BpP, BpPTemp, ISOLATE, STD_PRECAUTION, TRAN_DATE, TRANSFER, Wcc, WccN, WccL,
						Device, IVCatheter, IVCatheterOther, Proc, ChestSign,
						IVSite, IVSiteOther, Urinary, 
						OtherPhySign, Antibiotics, FinalDisp, TransferTo,
						HospDefine, AdmissionCO, DeviceMrsaEsbl, UrinaryOther,
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
			String Source, 
			String CaseDefine, 
			String Status, 
			String BodySystem, 
			String IsolateOrgan, 
			String Phx, 
			String PhxOther, 
			String ClinicalInfo, 
			String BpP, String BpPTemp, String ISOLATE, String STD_PRECAUTION, String TRAN_DATE, String TRANSFER, String Wcc, String WccN, String WccL,
			String Device, String IVCatheter, String IVCatheterOther, String Proc, String ChestSign,
			String IVSite, String IVSiteOther, String Urinary, String OtherPhySign, 
			String Antibiotics, String FinalDisp, String TransferTo, String HospDefine, String AdmissionCO,
			String DeviceMrsaEsbl, String UrinaryOther, String icType,
			String CaseNum
	) {
		//System.out.println("update(.... : " +  IVCatheter);
		// try to update selected record
		if(UtilDBWeb.updateQueue(
				sqlStr_updateBldMrsaEsbl,
				new String[] {
						CaseDate, 
						LabNum, HospNum, PatName, 
						PatSex, 
						PatBDate,
						Age, Month, Ward, RoomNum, BedNum, 
						DateIn, 
						Source, CaseDefine, Status, BodySystem, 
						IsolateOrgan, Phx, PhxOther, ClinicalInfo,
						BpP, BpPTemp, ISOLATE, STD_PRECAUTION, TRAN_DATE, TRANSFER, Wcc, WccN, WccL,
						Device, IVCatheter, IVCatheterOther, Proc, ChestSign,
						IVSite, IVSiteOther, Urinary, OtherPhySign,
						Antibiotics, FinalDisp, TransferTo, HospDefine, AdmissionCO, DeviceMrsaEsbl,
						UrinaryOther, icType,
						userBean.getLoginID(),
						ConstantsServerSide.SITE_CODE, CaseNum,
				})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean delete(UserBean userBean, String caseNum) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteBldMrsaEsbl,
				new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, caseNum });
	}

	public static ArrayList get(String caseNum) {
		return UtilDBWeb.getReportableList(sqlStr_getBldMrsaEsbl, new String[] {caseNum });
	}

	public static ArrayList getList(String LabNum, String DateFrom, String DateTo) {
		return UtilDBWeb.getReportableList(sqlStr_getBldMrsaEsblList, new String[] {DateFrom, DateTo, "%" + LabNum + "%"});
	}
	
	public static ArrayList getListBld(String LabNum, String DateFrom, String DateTo, String icType) {
		return UtilDBWeb.getReportableList(sqlStr_getBldMrsaEsblList_bld, new String[] {DateFrom, DateTo, "%" + LabNum + "%", icType});
	}	

	static {
		StringBuffer sqlStr = new StringBuffer();
		
		
		// bld  
		sqlStr.setLength(0);		
		sqlStr.append("SELECT IC_SITE_CODE, CASE_NUM, TO_CHAR(CASE_DATE, 'dd/MM/YYYY'), LAB_NUM, HOSPNUM, PATNAME, PATSEX, ");
		sqlStr.append("TO_CHAR(PATBDATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY'), ");		
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_BLD_MRSA_ESBL ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
//		sqlStr.append("AND TO_DATE(?, 'dd/MM/YYYY') <= CASE_DATE AND TO_DATE(?, 'dd/MM/YYYY') >= CASE_DATE ");
		sqlStr.append("AND CASE_DATE > TO_DATE(?, 'dd/MM/YYYY') -1 and CASE_DATE < TO_DATE(?, 'dd/MM/YYYY') + 1");
		sqlStr.append("AND LAB_NUM like ? ");
		sqlStr.append("AND ICTYPE = ? ");
		sqlStr.append("ORDER BY CASE_NUM");
		sqlStr_getBldMrsaEsblList_bld = sqlStr.toString(); 
		
		
		// mrsa esbl 
		sqlStr.setLength(0);		
		sqlStr.append("SELECT ");
	    sqlStr.append("IC_SITE_CODE, CASE_NUM, TO_CHAR(CASE_DATE, 'dd/MM/YYYY'), LAB_NUM, HOSPNUM, PATNAME, PATSEX, ");
		sqlStr.append("TO_CHAR(PATBDATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY'), ");
		sqlStr.append("decode(ictype, 'esbl', 'ESBL','cmrsa', 'CA-MRSA','mrsa', 'MRSA','other', 'Others', ictype),");		
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_BLD_MRSA_ESBL ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND TO_DATE(?, 'dd/MM/YYYY') <= CASE_DATE AND TO_DATE(?, 'dd/MM/YYYY') >= CASE_DATE ");
		sqlStr.append("AND LAB_NUM like ? ");
		sqlStr.append("AND ICTYPE <> 'bld' ");
		sqlStr.append("ORDER BY CASE_NUM");
		sqlStr_getBldMrsaEsblList = sqlStr.toString();
		
		sqlStr.setLength(0);		
		sqlStr.append("SELECT IC_SITE_CODE, CASE_NUM, TO_CHAR(CASE_DATE, 'dd/MM/yyyy'), LAB_NUM, HOSPNUM, PATNAME, PATSEX, ");
		sqlStr.append("TO_CHAR(PATBDATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY'), ");
		sqlStr.append("SOURCE, CASE_DEFINE, STATUS, BODY_SYSTEM, ");
		sqlStr.append("ISOLATE_ORGAN, PHX, PHX_OTHER, CLINICAL_INFO, ");
		sqlStr.append("BP_P, BP_P_TEMP, WCC, WCC_N, WCC_L, ");
		sqlStr.append("DEVICE, IVCATHETER, IVCATHETER_OTHER, PROC, CHEST_SIGN, ");
		sqlStr.append("IVSITE, IVSITE_OTHER, URINARY, OTHER_PHY_SIGN, ");		
		sqlStr.append("ANTIBIOTICS, FINAL_DISP, TRANSFER_TO, ");
		sqlStr.append("HOSP_DEFINE, ADMISSION_CO, DEVICE_MRSA_ESBL, URINARY_OTHER, ICTYPE, ");
		sqlStr.append("ISOLATE, STD_PRECAUTION, TO_CHAR(TRAN_DATE, 'dd/MM/yyyy'), TRANSFER, ");
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_BLD_MRSA_ESBL ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND CASE_NUM = ?");
		sqlStr_getBldMrsaEsbl = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO IC_BLD_MRSA_ESBL ");
		sqlStr.append("(");
		sqlStr.append("IC_SITE_CODE, ICTYPE, ");
		sqlStr.append(" CASE_NUM, CASE_DATE, LAB_NUM, HOSPNUM,");
		sqlStr.append(" PATNAME, PATSEX, PATBDATE, AGE, MONTH,");
		sqlStr.append(" WARD, ROOM_NUM, BED_NUM, DATE_IN, SOURCE, CASE_DEFINE,");
		sqlStr.append(" STATUS, BODY_SYSTEM, ISOLATE_ORGAN, PHX, PHX_OTHER, CLINICAL_INFO,");
		sqlStr.append(" BP_P, BP_P_TEMP, ");
		sqlStr.append(" ISOLATE, STD_PRECAUTION, TRAN_DATE, TRANSFER, ");
		sqlStr.append(" WCC, WCC_N, WCC_L, ");
		sqlStr.append(" DEVICE, IVCATHETER, IVCATHETER_OTHER, PROC, CHEST_SIGN,");
		sqlStr.append(" IVSITE, IVSITE_OTHER, URINARY,");		
		sqlStr.append(" OTHER_PHY_SIGN, ANTIBIOTICS, FINAL_DISP, TRANSFER_TO,");
		sqlStr.append(" HOSP_DEFINE, ADMISSION_CO, DEVICE_MRSA_ESBL, URINARY_OTHER,");
		sqlStr.append(" IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append(") ");
		sqlStr.append("VALUES ");
		sqlStr.append("(");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" TO_NUMBER(?), TO_DATE(?, 'dd/MM/yyyy'), ?, ?,");
		sqlStr.append(" ?, ?, TO_DATE(?, 'dd/MM/yyyy'), ?, ?,");
		sqlStr.append(" ?, ?, ?, TO_DATE(?, 'dd/MM/yyyy'), ?, ?,");		
		sqlStr.append(" ?, ?, ?, ?, ?, ?,");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, TO_DATE(?, 'dd/mm/yyyy'), ?, ");
		sqlStr.append(" ?, ?, ?, ");
		sqlStr.append(" ?, ?, ?, ?, ?, ");
		sqlStr.append(" ?, ?, ?,");
		sqlStr.append(" ?, ?, ?, ?,");
		sqlStr.append(" ?, ?, ?, ?,");
		sqlStr.append("SYSDATE, ?, null, null, TO_NUMBER(?)");
		sqlStr.append(") ");		
		sqlStr_insertBldMrsaEsbl = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE IC_BLD_MRSA_ESBL ");
		sqlStr.append("SET ");
		sqlStr.append(" CASE_DATE = TO_DATE(?, 'dd/MM/yyyy'), LAB_NUM = ?, HOSPNUM = ?, PATNAME = ?, PATSEX = ?, ");
		sqlStr.append(" PATBDATE = TO_DATE(?, 'dd/MM/yyyy'), ");
		sqlStr.append(" AGE = ?, MONTH = ?, WARD = ?, ROOM_NUM = ?, BED_NUM = ?, ");
		sqlStr.append(" DATE_IN = TO_DATE(?, 'dd/MM/yyyy'), ");
		sqlStr.append(" SOURCE = ?, CASE_DEFINE = ?, STATUS = ?, BODY_SYSTEM = ?, ");
		sqlStr.append(" ISOLATE_ORGAN = ?, PHX = ?, PHX_OTHER = ?, CLINICAL_INFO = ?, ");
		sqlStr.append(" BP_P = ?, BP_P_TEMP = ?, ISOLATE = ?, STD_PRECAUTION = ?, TRAN_DATE = TO_DATE(?, 'dd/MM/YYYY'), TRANSFER = ?, WCC = ?, WCC_N = ?, WCC_L = ?, ");
		sqlStr.append(" DEVICE = ?, IVCATHETER = ?, IVCATHETER_OTHER = ?, PROC = ?, CHEST_SIGN = ?, ");
		sqlStr.append(" IVSITE = ?, IVSITE_OTHER = ?, URINARY = ?, OTHER_PHY_SIGN = ?, ");
		sqlStr.append(" ANTIBIOTICS = ?, FINAL_DISP = ?, TRANSFER_TO = ?, HOSP_DEFINE = ?, ADMISSION_CO = ?,");
		sqlStr.append(" DEVICE_MRSA_ESBL = ?, URINARY_OTHER = ?, ICTYPE = ?,");
		sqlStr.append(" IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = ? ");		
		sqlStr.append("WHERE");
		sqlStr.append(" IC_SITE_CODE = ?");
		sqlStr.append(" AND CASE_NUM = TO_NUMBER(?)");
		sqlStr.append(" AND IC_ENABLED = 1");
		sqlStr_updateBldMrsaEsbl = sqlStr.toString();

		
		//new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, caseNum });
		sqlStr.setLength(0);
		sqlStr.append("UPDATE IC_BLD_MRSA_ESBL ");
		sqlStr.append("SET    IC_ENABLED = 0, IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  IC_SITE_CODE = ? ");
		sqlStr.append("AND    CASE_NUM = ? ");
		sqlStr.append("AND    IC_ENABLED = 1 ");
		sqlStr_deleteBldMrsaEsbl = sqlStr.toString();
		//////////////////////////////////////
	}
}