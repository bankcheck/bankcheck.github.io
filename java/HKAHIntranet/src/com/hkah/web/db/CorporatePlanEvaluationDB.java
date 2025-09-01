package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class CorporatePlanEvaluationDB {
	private static String sqlStr_insertEvaluation = null;
	private static String sqlStr_updateEvaluation = null;
	private static String sqlStr_deleteEvaluation = null;
	private static String sqlStr_getEvaluations = null;

	private static String getNextEvaluationID(String siteCode, String fiscalYear, String deptCode, String planID, String goalID) {
		String evaluationID = null;

		// get next evaluationID from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(DS_EVALUATION_ID) + 1 FROM DS_EVALUATION WHERE DS_SITE_CODE = ? AND DS_FINANCIAL_YEAR = ? AND DS_DEPARTMENT_CODE = ? AND DS_PLAN_ID = ? AND DS_GOAL_ID = ? ",
				new String[] { siteCode, fiscalYear, deptCode, planID, goalID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			evaluationID = reportableListObject.getValue(0);

			// set 1 for initial
			if (evaluationID == null || evaluationID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return evaluationID;
	}

	public static String add(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID,
			String evaluationType, String evaluationTypeOther, String evaluationObjective, String targetRevenue, String actualRevenue, String targetCensus, String actualCensus ) {

		// get next schedule ID
		String evaluationID = getNextEvaluationID(userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID);

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertEvaluation,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, evaluationID,
						evaluationType, evaluationTypeOther, evaluationObjective, targetRevenue, actualRevenue, targetCensus, actualCensus, userBean.getLoginID(), userBean.getLoginID() })) {
			return evaluationID;
		} else {
			return null;
		}
	}

	/**
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String evaluationID,
			String evaluationType, String evaluationTypeOther, String evaluationObjective, String targetRevenue, String actualRevenue, String targetCensus, String actualCensus) {

		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_updateEvaluation,
				new String[] {
						evaluationType, evaluationTypeOther, evaluationObjective, targetRevenue, actualRevenue, targetCensus, actualCensus,
						userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, evaluationID });
	}

	/**
	 * delete Goal
	 */
	public static boolean delete(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String evaluationID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteEvaluation,
				new String[] {
						userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, evaluationID });
	}

	public static ArrayList getList(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID) {
		// fetch plan
		return UtilDBWeb.getReportableList(
				sqlStr_getEvaluations,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID});
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO DS_EVALUATION ");
		sqlStr.append("(DS_SITE_CODE, DS_FINANCIAL_YEAR, DS_DEPARTMENT_CODE, DS_PLAN_ID, DS_GOAL_ID, DS_EVALUATION_ID, ");
		sqlStr.append("DS_EVALUATION_TYPE, DS_EVALUATION_OTHER, DS_OBJECTIVE, ");
		sqlStr.append("DS_TARGET_REVENUE, DS_ACTUAL_REVENUE, DS_TARGET_CENSUS, DS_ACTUAL_CENSUS, ");
		sqlStr.append("DS_CREATED_USER, DS_MODIFIED_USER ) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ");
		sqlStr.append("?, ? )");
		sqlStr_insertEvaluation = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_EVALUATION ");
		sqlStr.append("SET    DS_EVALUATION_TYPE = ?, DS_EVALUATION_OTHER = ?, DS_OBJECTIVE = ?, ");
		sqlStr.append("       DS_TARGET_REVENUE = ?, DS_ACTUAL_REVENUE = ?, DS_TARGET_CENSUS = ?, DS_ACTUAL_CENSUS = ?, ");
		sqlStr.append("       DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_EVALUATION_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_updateEvaluation = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_EVALUATION ");
		sqlStr.append("SET    DS_ENABLED = 0, DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_EVALUATION_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_deleteEvaluation = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT DS_EVALUATION_ID, DS_EVALUATION_TYPE, DS_EVALUATION_OTHER, DS_OBJECTIVE, ");
		sqlStr.append("       DS_TARGET_REVENUE, DS_ACTUAL_REVENUE, DS_TARGET_CENSUS, DS_ACTUAL_CENSUS ");
		sqlStr.append("FROM   DS_EVALUATION ");
		sqlStr.append("WHERE  DS_ENABLED = 1 ");
		sqlStr.append("AND    DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("ORDER BY DS_EVALUATION_ID ");
		sqlStr_getEvaluations = sqlStr.toString();
	}
}