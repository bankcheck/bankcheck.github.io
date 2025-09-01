package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class HAACheckListDB {
	UserBean userBean = new UserBean();
	private static String sqlStr_insertCorp = null;
	private static String sqlStr_updateCorp = null;
	private static String sqlStr_updateCorpEnabled = null;
	private static String sqlStr_listCorp = null;
	private static String sqlStr_listCorpEnabled = null;
	private static String sqlStr_getCorp = null;

	private static String sqlStr_insertDate = null;
	private static String sqlStr_updateDate = null;

	private static String sqlStr_expireContract = null;
	private static String sqlStr_expireContractWithID = null;

	private static String getNextHaaID() {
		String haaID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(HAA_CHECKLIST_ID) + 1 FROM HAA_CHECKLIST");
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
		String haaID = getNextHaaID();

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

	public static boolean update(UserBean userBean, String haaID, String haaCorpName, 
								String busType, String contactDateFrom, 
								String contactDateTo, String haaCorpCode, String enabled) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateCorp,
				new String[] { haaCorpName, busType, contactDateFrom, contactDateTo, haaCorpCode, 
								enabled, userBean.getLoginID(), haaID } );
	}

	public static boolean delete(UserBean userBean, String haaID) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateCorpEnabled,
				new String[] { ConstantsVariable.ZERO_VALUE, userBean.getLoginID(), haaID } );
	}

	public static boolean archive(UserBean userBean, String haaID) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateCorpEnabled,
				new String[] { ConstantsVariable.TWO_VALUE, userBean.getLoginID(), haaID } );
	}

	public static ArrayList get(UserBean userBean, String haaID) {
		return UtilDBWeb.getReportableList(sqlStr_getCorp, new String[] { haaID });
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

	public static boolean emailSent(UserBean userBean, String haaid) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE HAA_CHECKLIST  ");
		sqlStr.append("SET HAA_EMAILED = 1, ");
		sqlStr.append("HAA_MODIFIED_DATE = SYSDATE, ");		
		sqlStr.append("HAA_MODIFIED_USER = '"+ (userBean == null ? "SYSTEM" : userBean.getLoginID()) +"' ");
		sqlStr.append("WHERE HAA_CHECKLIST_ID = '"+haaid+"' ");
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
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
		sqlStr.append("       HAA_CODE = ?, ");
		sqlStr.append("       HAA_ENABLED = ?, ");
		sqlStr.append("       HAA_MODIFIED_DATE = SYSDATE, HAA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  HAA_ENABLED > 0 ");
		sqlStr.append("AND    HAA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    HAA_CHECKLIST_ID = ? ");
		sqlStr_updateCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE HAA_CHECKLIST ");
		sqlStr.append("SET    HAA_ENABLED = ?, ");
		sqlStr.append("       HAA_MODIFIED_DATE = SYSDATE, HAA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  HAA_ENABLED > 0 ");
		sqlStr.append("AND    HAA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    HAA_CHECKLIST_ID = ? ");
		sqlStr_updateCorpEnabled = sqlStr.toString();

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
		sqlStr.append("SELECT HAA_CHECKLIST_ID, HAA_CORP_NAME, HAA_BUSINESS_TYPE, ");
		sqlStr.append("       TO_CHAR(HAA_CONTRACT_DATE_FROM, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(HAA_CONTRACT_DATE_TO, 'dd/MM/YYYY'), ");
		sqlStr.append("       HAA_CODE, ");
		sqlStr.append("       HAA_ENABLED ");
		sqlStr.append("FROM   HAA_CHECKLIST ");
		sqlStr.append("WHERE  HAA_ENABLED > 0 ");
		sqlStr.append("AND    HAA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    HAA_CHECKLIST_ID = ? ");
		sqlStr.append("ORDER BY HAA_CORP_NAME");
		sqlStr_getCorp = sqlStr.toString();

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
		sqlStr.append("AND    ADD_MONTHS( HAA_CONTRACT_DATE_TO,1) < SYSDATE ");
		sqlStr.append("AND    HAA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr_expireContract = sqlStr.toString();

		sqlStr.append("AND    HAA_CHECKLIST_ID = ? ");
		sqlStr_expireContractWithID = sqlStr.toString();
	}
}