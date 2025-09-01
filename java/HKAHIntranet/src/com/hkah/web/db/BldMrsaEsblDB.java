package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class BldMrsaEsblDB {
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
	private static String sqlStr_updateGE_Resp = null;
	

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
		String haaID = getNextCaseNum();

		if (UtilDBWeb.updateQueue(
				sqlStr_insertCorp,
				new String[] { haaID, userBean.getLoginID(), userBean.getLoginID() })) {

			// insert default date
			UtilDBWeb.updateQueue(
					sqlStr_insertDate,
					new String[] { haaID, userBean.getLoginID(), userBean.getLoginID() });

			return haaID;
		} else {
			return null;
		}
	}

	// GE_Resp
	
	public static ArrayList get(UserBean userBean, String LabNum, String FromDateIn, String ToDateIn) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT IC_SITE_CODE, CASE_NUM, CASE_DATE, LAB_NUM, HOSPNUM, PATNAME, PATSEX, ");
		sqlStr.append("TO_CHAR(PATBDATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY'), ");		
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_BLD_MRSA_ESBL ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND TO_DATE(?, 'dd/MM/YYYY') <= CASE_DATE AND TO_DATE(?, 'dd/MM/YYYY') >= CASE_DATE ");
		sqlStr.append("AND LAB_NUM like " + "'%" + LabNum + "%'");
		sqlStr.append("ORDER BY CASE_NUM");	
		
		System.out.println(sqlStr.toString() + " " + FromDateIn + " " + ToDateIn);
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {FromDateIn, ToDateIn});
	}

	public static boolean updateGe_Resp(UserBean userBean, String caseNum, String TOCC, String fever38C, String onset_date, String DV, String admit_icu, String hai_cai, String oahr, String remark, String CaseNum, String enable) {
		System.out.println(sqlStr_updateGE_Resp);
		System.out.println(DV);
		System.out.println(onset_date);		
		return UtilDBWeb.updateQueue(
				sqlStr_updateGE_Resp,
				new String[] { TOCC, fever38C, admit_icu, DV, onset_date, hai_cai, oahr, remark, userBean.getLoginID(), CaseNum} );
	}

	public static boolean delete(UserBean userBean, String caseNum) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateCorpEnabled,
				new String[] { ConstantsVariable.ZERO_VALUE, userBean.getLoginID(), caseNum } );
	}
	
	//////////////////////
	
	public static boolean update(UserBean userBean, String haaID, String haaCorpName, String busType, String contactDateFrom, String contactDateTo, String enabled) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateCorp,
				new String[] { haaCorpName, busType, contactDateFrom, contactDateTo, enabled, userBean.getLoginID(), haaID } );
	}

	public static boolean archive(UserBean userBean, String haaID) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateCorpEnabled,
				new String[] { ConstantsVariable.TWO_VALUE, userBean.getLoginID(), haaID } );
	}

	public static ArrayList getList(UserBean userBean, String enabled) {
		// fetch HAACheckList

		if (enabled != null && enabled.length() > 0) {
			return UtilDBWeb.getReportableList(sqlStr_listCorpEnabled, new String[] { enabled });
		} else {
			return UtilDBWeb.getReportableList(sqlStr_listCorp);
		}
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
/*		sqlStr.setLength(0);
		sqlStr.append("SELECT IC_SITE_CODE, CASE_NUM, CASE_DATE, LAB_NUM, HOSPNUM, PATNAME, PATSEX, ");
		sqlStr.append("TO_CHAR(PATBDATE, 'dd/MM/YYYY'), ");
		sqlStr.append("AGE, MONTH, WARD, ROOM_NUM, BED_NUM,");
		sqlStr.append("TO_CHAR(DATE_IN, 'dd/MM/YYYY'), ");
		sqlStr.append("TOCC, FEVER38C, ");				
		sqlStr.append("ADMIT_ICU, HAI_CAI, OAHR, REMARKS,");
		sqlStr.append("IC_CREATED_DATE, IC_CREATED_USER, IC_MODIFIED_DATE, IC_MODIFIED_USER, IC_ENABLED ");
		sqlStr.append("FROM IC_GE_RESP ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND TO_DATE(?, 'dd/MM/YYYY') <= CASE_DATE AND TO_DATE(?, 'dd/MM/YYYY') >= CASE_DATE ");
		sqlStr.append("ORDER BY CASE_NUM");
		sqlStr_getICGeResp = sqlStr.toString();  */

		sqlStr.setLength(0);
		sqlStr.append("UPDATE IC_GE_RESP ");
		sqlStr.append("SET    TOCC = ?, ");
		sqlStr.append("		  FEVER38C = ?, ");
		sqlStr.append("       ADMIT_ICU = ?, ");
		sqlStr.append("       DV = ?, ");
		sqlStr.append("       ONSET_DATE = TO_DATE(?, 'dd/MM/YYYY'), ");		
		sqlStr.append("       HAI_CAI = ?, ");
		sqlStr.append("       OAHR = ?, ");
		sqlStr.append("       REMARKS = ?, ");		
		sqlStr.append("       IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND    IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CASE_NUM = to_number(?) ");
		sqlStr_updateGE_Resp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE IC_GE_RESP ");
		sqlStr.append("SET    IC_ENABLED = ?, ");
		sqlStr.append("       IC_MODIFIED_DATE = SYSDATE, IC_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  IC_ENABLED > 0 ");
		sqlStr.append("AND    IC_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CASE_NUM = ? ");
		sqlStr_updateCorpEnabled = sqlStr.toString();
		
		//////////////////////

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO HAA_CHECKLIST (");
		sqlStr.append("HAA_SITE_CODE, HAA_CHECKLIST_ID, HAA_CREATED_USER, HAA_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?)");
		sqlStr_insertCorp = sqlStr.toString();
	
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
	}
}