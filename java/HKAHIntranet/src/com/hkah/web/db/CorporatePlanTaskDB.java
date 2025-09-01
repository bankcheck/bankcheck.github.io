package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class CorporatePlanTaskDB {
	private static String sqlStr_insertTask = null;
	private static String sqlStr_updateTask = null;
	private static String sqlStr_deleteTask = null;
	private static String sqlStr_getTask = null;
	private static String sqlStr_getTasks = null;
	private static String sqlStr_approveTask = null;
	private static String sqlStr_rejectTask = null;

	// Task
	private static String getNextTaskID(String siteCode, String fiscalYear, String deptCode, String planID, String goalID) {
		String taskID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(DS_TASK_ID) + 1 FROM DS_TASK WHERE DS_SITE_CODE = ? AND DS_FINANCIAL_YEAR = ? AND DS_DEPARTMENT_CODE = ? AND DS_PLAN_ID = ? AND DS_GOAL_ID = ?",
				new String[] { siteCode, fiscalYear, deptCode, planID, goalID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			taskID = reportableListObject.getValue(0);

			// set 1 for initial
			if (taskID == null || taskID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return taskID;
	}

	private static String getNextTaskOrder(String siteCode, String fiscalYear, String deptCode ,String planID, String goalID) {
		String taskOrder = null;

		// get next goalID from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(DS_TASK_ORDER) + 1 FROM DS_TASK WHERE DS_SITE_CODE = ? AND DS_FINANCIAL_YEAR = ? AND DS_DEPARTMENT_CODE = ? AND DS_PLAN_ID = ? AND DS_GOAL_ID = ? AND DS_ENABLED = 1 ",
				new String[] { siteCode, fiscalYear, deptCode, planID, goalID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			taskOrder = reportableListObject.getValue(0);

			// set 1 for initial
			if (taskOrder == null || taskOrder.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return taskOrder;
	}

	/**
	 * Add a Task
	 */
	public static String add(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID,
			String taskDescription,
			String estimateCompleteDate, String actuallCompleteDate, String[] taskResponsibleByDeptCode, String[] taskResponsibleByStaff) {

		// get next task ID
		String taskID = getNextTaskID(userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID);
		String taskOrder = getNextTaskOrder(userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID);

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertTask,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, taskID,
						taskDescription,
						estimateCompleteDate, actuallCompleteDate,
						userBean.getLoginID(), userBean.getLoginID(),taskOrder })) {
				CorporatePlanTaskResponsibleDB.add(userBean, fiscalYear, deptCode, planID, goalID, taskID, taskResponsibleByDeptCode, taskResponsibleByStaff);
			return taskID;
		} else {
			return null;
		}
	}
	/**
	 * Update a Goal Order
	 * @return whether it is successful to update the record
	 */
	public static boolean updateOrder(UserBean userBean,String fiscalYear, String deptCode, String planID,String goalID, String direction, String taskOrder){

		StringBuffer sqlStr = new StringBuffer();
		String targetTaskID = null;

		sqlStr.append("SELECT DS_TASK_ID FROM DS_TASK ");
		sqlStr.append("WHERE DS_SITE_CODE = ? " );
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		if("up".equals(direction)){
			sqlStr.append("AND    DS_TASK_ORDER = ? -1");
		}
		else if ("down".equals(direction)){
			sqlStr.append("AND    DS_TASK_ORDER = ? +1");
		}
		sqlStr.append("AND    DS_ENABLED = 1 ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(),new String[] {userBean.getSiteCode(), fiscalYear, deptCode, planID,goalID,taskOrder });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			targetTaskID = reportableListObject.getValue(0);
		}

		if (targetTaskID != null) {
			sqlStr.setLength(0);
			sqlStr.append(" UPDATE DS_TASK ");
			if("up".equals(direction)){
				sqlStr.append(" SET DS_TASK_ORDER = ? - 1 ");
			} else if("down".equals(direction)){
				sqlStr.append(" SET DS_TASK_ORDER = ? + 1 ");
			}

			sqlStr.append("WHERE DS_SITE_CODE = ? " );
			sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
			sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
			sqlStr.append("AND    DS_PLAN_ID = ? ");
			sqlStr.append("AND    DS_GOAL_ID = ? ");
			sqlStr.append("AND    DS_TASK_ORDER = ? ");
			sqlStr.append("AND    DS_ENABLED = 1 ");

			UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {taskOrder,userBean.getSiteCode(),fiscalYear,deptCode, planID,goalID, taskOrder } );

			sqlStr.setLength(0);
			sqlStr.append(" UPDATE DS_TASK ");
			sqlStr.append(" SET DS_TASK_ORDER = ?  ");
			sqlStr.append("WHERE DS_SITE_CODE = ? " );
			sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
			sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
			sqlStr.append("AND    DS_PLAN_ID = ? ");
			sqlStr.append("AND    DS_GOAL_ID = ? ");
			sqlStr.append("AND    DS_TASK_ID = ? ");
			sqlStr.append("AND    DS_ENABLED = 1 ");

			return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {taskOrder,userBean.getSiteCode(),fiscalYear,deptCode, planID,goalID, targetTaskID } );
		}
		else{
			return false;
		}
	}



	/**
	 * Modify a Task
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String taskID,
			String taskDescription,
			String estimateCompleteDate, String actuallCompleteDate, String[] taskResponsibleByDeptCode, String[] taskResponsibleByStaff) {

		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updateTask,
				new String[] {
						taskDescription,
						estimateCompleteDate, actuallCompleteDate,
						userBean.getLoginID(), userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, taskID })) {
			// delete all existing
			CorporatePlanTaskResponsibleDB.delete(userBean, fiscalYear, deptCode, planID, goalID, taskID);
			CorporatePlanTaskResponsibleDB.add(userBean, fiscalYear, deptCode, planID, goalID, taskID, taskResponsibleByDeptCode, taskResponsibleByStaff);
			return true;
		} else {
			return false;
		}
	}

	/**
	 * delete Task
	 */
	public static boolean delete(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String taskID) {
		// try to delete selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_deleteTask,
				new String[] { userBean.getLoginID(), userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, taskID })) {
			// delete all responsible person
			CorporatePlanTaskResponsibleDB.delete(userBean, fiscalYear, deptCode, planID, goalID, taskID);

			ArrayList result = UtilDBWeb.getReportableList(
					"SELECT DS_TASK_ID FROM DS_TASK WHERE DS_SITE_CODE = ? AND DS_FINANCIAL_YEAR = ? AND DS_DEPARTMENT_CODE = ? AND DS_PLAN_ID = ?  AND DS_GOAL_ID = ? AND DS_ENABLED = 1 ORDER BY DS_TASK_ID ",
					new String[] {userBean.getSiteCode(),fiscalYear, deptCode, planID, goalID });
					if (result.size() > 0) {
						for(int i =0; i<result.size();i++)
						{
							ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
							UtilDBWeb.updateQueue(
								"UPDATE DS_TASK SET DS_TASK_ORDER = "+i+"+1 WHERE DS_SITE_CODE = ? AND    DS_FINANCIAL_YEAR = ? AND    DS_DEPARTMENT_CODE = ? AND    DS_PLAN_ID = ? AND    DS_GOAL_ID = ? AND DS_TASK_ID = ? AND DS_ENABLED = 1",
								new String[] {userBean.getSiteCode(),fiscalYear,deptCode, planID,goalID, reportableListObject.getValue(0) } );
						}
					}
			return true;
		} else {
			return false;
		}
	}

	public static ArrayList get(UserBean userBean, String fiscalYear, String deptCode, String planID, String goalID, String taskID) {
		// fetch plan
		return UtilDBWeb.getReportableList(
				sqlStr_getTask,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, taskID});
	}

	public static ArrayList getList(UserBean userBean, String fiscalYear, String deptCode, String planID, String goalID) {
		// fetch plan
		return UtilDBWeb.getReportableList(
				sqlStr_getTasks,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID});
	}

	/**
	 * approval
	 */
	public static boolean approve(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String taskID) {

		// update approval
		return UtilDBWeb.updateQueue(
				sqlStr_approveTask,
				new String[] { userBean.getLoginID(), userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, taskID });
	}

	public static boolean reject(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String taskID) {

		// update approval
		return UtilDBWeb.updateQueue(
				sqlStr_rejectTask,
				new String[] { userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID, taskID });
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO DS_TASK ");
		sqlStr.append("(DS_SITE_CODE, DS_FINANCIAL_YEAR, DS_DEPARTMENT_CODE, DS_PLAN_ID, DS_GOAL_ID, DS_TASK_ID, ");
		sqlStr.append("DS_TASK_DESC, DS_EST_COMPLETE_DATE, DS_COMPLETE_DATE,");
		sqlStr.append("DS_CREATED_USER, DS_MODIFIED_USER, DS_TASK_ORDER ) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ?, ");
		sqlStr.append("?, TO_DATE(?, 'dd/MM/YYYY'), TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("?, ?, ? )");
		sqlStr_insertTask = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_TASK ");
		sqlStr.append("SET    DS_TASK_DESC = ?, ");
		sqlStr.append("		  DS_EST_COMPLETE_DATE = TO_DATE(?, 'dd/MM/YYYY'), DS_COMPLETE_DATE = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_TASK_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_updateTask = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_TASK ");
		sqlStr.append("SET    DS_ENABLED = 0, DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_TASK_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_deleteTask = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT T.DS_TASK_ID, T.DS_TASK_DESC, ");
		sqlStr.append("       TO_CHAR(T.DS_EST_COMPLETE_DATE, 'dd/MM/YYYY'), TO_CHAR(T.DS_COMPLETE_DATE, 'dd/MM/YYYY'), T.DS_TASK_ORDER, ");
		sqlStr.append("       T.DS_APPROVED, TO_CHAR(T.DS_APPROVED_DATE, 'dd/MM/YYYY'), T.DS_APPROVED_BY, ");
		sqlStr.append("       U.CO_FIRSTNAME || ' ' || U.CO_LASTNAME ");
		sqlStr.append("FROM   DS_TASK T, CO_USERS U ");
		sqlStr.append("WHERE  T.DS_SITE_CODE = U.CO_SITE_CODE (+) ");
		sqlStr.append("AND	  T.DS_APPROVED_BY = U.CO_USERNAME (+) ");
		sqlStr.append("AND    T.DS_ENABLED = 1 ");
		sqlStr.append("AND    T.DS_SITE_CODE = ? ");
		sqlStr.append("AND    T.DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    T.DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    T.DS_PLAN_ID = ? ");
		sqlStr.append("AND    T.DS_GOAL_ID = ? ");
		sqlStr.append("AND    T.DS_TASK_ID = ? ");
		sqlStr_getTask = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT T.DS_TASK_ID, T.DS_TASK_DESC, ");
		sqlStr.append("       TO_CHAR(T.DS_EST_COMPLETE_DATE, 'dd/MM/YYYY'), TO_CHAR(T.DS_COMPLETE_DATE, 'dd/MM/YYYY'), T.DS_TASK_ORDER, ");
		sqlStr.append("       T.DS_APPROVED, TO_CHAR(T.DS_APPROVED_DATE, 'dd/MM/YYYY'), T.DS_APPROVED_BY, ");
		sqlStr.append("       U.CO_FIRSTNAME || ' ' || U.CO_LASTNAME ");
		sqlStr.append("FROM   DS_TASK T, CO_USERS U ");
		sqlStr.append("WHERE  T.DS_SITE_CODE = U.CO_SITE_CODE (+) ");
		sqlStr.append("AND	  T.DS_APPROVED_BY = U.CO_USERNAME (+) ");
		sqlStr.append("AND    T.DS_ENABLED = 1 ");
		sqlStr.append("AND    T.DS_SITE_CODE = ? ");
		sqlStr.append("AND    T.DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    T.DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    T.DS_PLAN_ID = ? ");
		sqlStr.append("AND    T.DS_GOAL_ID = ? ");
		sqlStr.append("ORDER BY	T.DS_TASK_ORDER");
		sqlStr_getTasks = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_TASK ");
		sqlStr.append("SET    DS_APPROVED = 'Y', DS_APPROVED_DATE = SYSDATE, DS_APPROVED_BY = ?, ");
		sqlStr.append("		    DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_TASK_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr.append("AND    DS_APPROVED = 'N' ");
		sqlStr_approveTask = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_TASK ");
		sqlStr.append("SET    DS_APPROVED = 'N', DS_APPROVED_DATE = '', DS_APPROVED_BY = '', ");
		sqlStr.append("		    DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_TASK_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr.append("AND    DS_APPROVED = 'Y' ");
		sqlStr_rejectTask = sqlStr.toString();
	}
}