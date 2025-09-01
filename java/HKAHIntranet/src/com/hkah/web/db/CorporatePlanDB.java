package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class CorporatePlanDB {
	private static String sqlStr_insertCorporatePlan = null;
	private static String sqlStr_updateCorporatePlan = null;
	private static String sqlStr_deleteCorporatePlan = null;
	private static String sqlStr_getCorporatePlan = null;

	private static String getNextPlanID(String siteCode, String fiscalYear, String deptCode) {
		String planID = null;

		// get next plan id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(DS_PLAN_ID) + 1 FROM DS_CORPORATE_PLAN WHERE DS_SITE_CODE = ? AND DS_FINANCIAL_YEAR = ? AND DS_DEPARTMENT_CODE = ?",
				new String[] { siteCode, fiscalYear, deptCode });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			planID = reportableListObject.getValue(0);

			// set 1 for initial
			if (planID == null || planID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return planID;
	}

	/**
	 * Add a Corporate Plan
	 */
	public static String add(UserBean userBean,
			String fiscalYear, String deptCode) {

		// get next plan ID
		String planID = getNextPlanID(userBean.getSiteCode(), fiscalYear, deptCode);

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertCorporatePlan,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID,
						userBean.getLoginID(), userBean.getLoginID() })) {
			return planID;
		} else {
			return null;
		}
	}

	/**
	 * Modify a CorporatePlan
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String fiscalYear, String deptCode, String planID,
			String subject) {

		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_updateCorporatePlan,
				new String[] {
						subject, userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID});
	}

	/**
	 * delete CorporatePlan
	 */
	public static boolean delete(UserBean userBean,
			String fiscalYear, String deptCode, String planID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteCorporatePlan,
				new String[] { userBean.getLoginID(), userBean.getSiteCode(), fiscalYear, deptCode, planID });
	}

	public static ArrayList getList(UserBean userBean, String fiscalYear, String deptCode) {
		// fetch plan
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT P.DS_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, P.DS_FINANCIAL_YEAR, P.DS_PLAN_ID, ");
		sqlStr.append("       P.DS_SUBJECT ");
		sqlStr.append("FROM   DS_CORPORATE_PLAN P, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  P.DS_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    P.DS_ENABLED = 1 ");
		sqlStr.append("AND    P.DS_SITE_CODE = '");
		sqlStr.append(userBean.getSiteCode());
		sqlStr.append("' ");
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    P.DS_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		sqlStr.append("AND    P.DS_FINANCIAL_YEAR = '");
		sqlStr.append(fiscalYear);
		sqlStr.append("' ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList get(UserBean userBean, String fiscalYear, String deptCode, String planID) {
		// fetch plan
		return UtilDBWeb.getReportableList(
				sqlStr_getCorporatePlan,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID});
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO DS_CORPORATE_PLAN ");
		sqlStr.append("(DS_SITE_CODE, DS_FINANCIAL_YEAR, DS_DEPARTMENT_CODE, DS_PLAN_ID, ");
		sqlStr.append("DS_CREATED_USER, DS_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?,");
		sqlStr.append("?, ?)");
		sqlStr_insertCorporatePlan = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_CORPORATE_PLAN ");
		sqlStr.append("SET    DS_SUBJECT = ?, ");
		sqlStr.append("       DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_updateCorporatePlan = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_CORPORATE_PLAN ");
		sqlStr.append("SET    DS_ENABLED = 0, DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_deleteCorporatePlan = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT P.DS_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, P.DS_FINANCIAL_YEAR, P.DS_PLAN_ID, ");
		sqlStr.append("       P.DS_SUBJECT, P.DS_MODIFIED_USER, TO_CHAR(P.DS_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   DS_CORPORATE_PLAN P, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  P.DS_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    P.DS_ENABLED = 1 ");
		sqlStr.append("AND    P.DS_SITE_CODE = ? ");
		sqlStr.append("AND    P.DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    P.DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    P.DS_PLAN_ID = ? ");
		sqlStr.append("AND    P.DS_ENABLED = 1 ");
		sqlStr_getCorporatePlan = sqlStr.toString();
	}
}