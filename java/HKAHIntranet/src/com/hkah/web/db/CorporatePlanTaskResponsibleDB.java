package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class CorporatePlanTaskResponsibleDB {
	private static String sqlStr_insertTaskResponsible = null;
	private static String sqlStr_updateTaskResponsible = null;
	private static String sqlStr_deleteTaskResponsible = null;
	private static String sqlStr_getTaskResponsibles = null;

	// TaskResponsible
	private static String getNextTaskResponsibleID(String siteCode, String fiscalYear, String deptCode, String planID, String goalID, String taskID) {
		String taskResponsibleID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(DS_TASK_RESPONSIBLE_ID) + 1 FROM DS_TASK_RESPONSIBLE WHERE DS_SITE_CODE = ? AND DS_FINANCIAL_YEAR = ? AND DS_DEPARTMENT_CODE = ? AND DS_PLAN_ID = ? AND DS_GOAL_ID = ? AND DS_TASK_ID = ?",
				new String[] { siteCode, fiscalYear, deptCode, planID, goalID, taskID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			taskResponsibleID = reportableListObject.getValue(0);

			// set 1 for initial
			if (taskResponsibleID == null || taskResponsibleID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return taskResponsibleID;
	}

	/**
	 * Add a Task Responsible
	 */
	public static void add(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String taskID,
			String taskResponsibleByDeptCode, String taskResponsibleByStaff) {

		// get next taskResponsibleID
		String taskResponsibleID = getNextTaskResponsibleID(userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, taskID);
		
		// try to insert a new record
		UtilDBWeb.updateQueue(
				sqlStr_insertTaskResponsible,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, taskID, taskResponsibleID,
						taskResponsibleByDeptCode, taskResponsibleByStaff, userBean.getLoginID(), userBean.getLoginID() });
	}
	
	/**
	 * Add a Task Responsible
	 */
	public static void add(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String taskID,
			String taskResponsibleByDeptCode[], String taskResponsibleByStaff[]) {
		if (taskResponsibleByDeptCode != null) {
			for (int i = 0; i < taskResponsibleByDeptCode.length; i++) {
				add(userBean, fiscalYear, deptCode, planID, goalID, taskID, taskResponsibleByDeptCode[i], null);
			}
		}
		if (taskResponsibleByStaff != null) {
			String byDeptCode = null;
			for (int i = 0; i < taskResponsibleByStaff.length; i++) {
				byDeptCode = StaffDB.getDeptCode(taskResponsibleByStaff[i]);
				add(userBean, fiscalYear, deptCode, planID, goalID, taskID, byDeptCode, taskResponsibleByStaff[i]);
			}
		}
	}

	/**
	 * Modify a TaskResponsible
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID,
			String taskID, String taskResponsibleID,
			String taskResponsibleByDeptCode, String taskResponsibleByStaff) {

		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_updateTaskResponsible,
				new String[] {
						taskResponsibleByDeptCode, taskResponsibleByStaff,
						userBean.getLoginID(), userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, taskID, taskResponsibleID });
	}

	/**
	 * delete TaskResponsible
	 */
	public static boolean delete(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID,
			String taskID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteTaskResponsible,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, taskID });
	}

	public static ArrayList getList(UserBean userBean, String fiscalYear, String deptCode, String planID, String goalID, String taskID) {
		// fetch plan
		return UtilDBWeb.getReportableList(
				sqlStr_getTaskResponsibles,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, taskID});
	}
	
	static {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO DS_TASK_RESPONSIBLE ");
		sqlStr.append("(DS_SITE_CODE, DS_FINANCIAL_YEAR, DS_DEPARTMENT_CODE, DS_PLAN_ID, DS_GOAL_ID, DS_TASK_ID, ");
		sqlStr.append("DS_TASK_RESPONSIBLE_ID, DS_BY_DEPARTMENT_CODE, DS_BY_USER_ID,");
		sqlStr.append("DS_CREATED_USER, DS_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?,");
		sqlStr.append("?, ?)");
		sqlStr_insertTaskResponsible = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_TASK_RESPONSIBLE ");
		sqlStr.append("SET    DS_BY_DEPARTMENT_CODE = ?, DS_BY_USER_ID = ?, DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_TASK_ID = ? ");
		sqlStr.append("AND    DS_TASK_RESPONSIBLE_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_updateTaskResponsible = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE DS_TASK_RESPONSIBLE ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_TASK_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_deleteTaskResponsible = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT TR.DS_TASK_RESPONSIBLE_ID, ");
		sqlStr.append("       TR.DS_BY_USER_ID, U.CO_FIRSTNAME || ' ' || U.CO_LASTNAME, ");
		sqlStr.append("       TR.DS_BY_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM   DS_TASK_RESPONSIBLE TR, CO_USERS U, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  TR.DS_SITE_CODE = U.CO_SITE_CODE (+) ");
		sqlStr.append("AND	  TR.DS_BY_USER_ID = U.CO_STAFF_ID (+) ");
		sqlStr.append("AND	  TR.DS_BY_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND	  TR.DS_ENABLED = 1 ");
		sqlStr.append("AND    TR.DS_SITE_CODE = ? ");
		sqlStr.append("AND    TR.DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    TR.DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    TR.DS_PLAN_ID = ? ");
		sqlStr.append("AND    TR.DS_GOAL_ID = ? ");
		sqlStr.append("AND    TR.DS_TASK_ID = ? ");
		sqlStr.append("ORDER BY	TR.DS_TASK_RESPONSIBLE_ID");
		sqlStr_getTaskResponsibles = sqlStr.toString();
	}
	}