package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.UserBean;

public class CorporatePlanCommentDB {
	private static String sqlStr_insertComment = null;
	private static String sqlStr_getComments = null;

	/**
	 * Add a Comment
	 */
	public static boolean add(UserBean userBean,
			String deptCode, String fiscalYear, String planID, String goalID,
			String objectType, String objectID, String commentStatus, String commentDesc) {
		
		// try to insert a new record
		return UtilDBWeb.updateQueue(
				sqlStr_insertComment,
				new String[] { userBean.getSiteCode(),deptCode, fiscalYear, planID, goalID,
					objectType, objectID, commentStatus, commentDesc, userBean.getStaffID(),
					userBean.getLoginID(), userBean.getLoginID() });
	}

	public static ArrayList getList(UserBean userBean, String fiscalYear, String deptCode, String planID, String goalID, String objectType, String objectID) {
		// fetch plan
		return UtilDBWeb.getReportableList(
				sqlStr_getComments,
				new String[] { userBean.getSiteCode(), deptCode, fiscalYear, planID, goalID, objectType, objectID});
	}
	
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO DS_COMMENT ");
		sqlStr.append("(DS_SITE_CODE, DS_DEPARTMENT_CODE, DS_FINANCIAL_YEAR, DS_PLAN_ID, DS_GOAL_ID, ");
		sqlStr.append("DS_OBJECT_TYPE, DS_OBJECT_ID, DS_COMMENT_STATUS, DS_COMMENT_DESC, DS_COMMENT_USER_ID, ");
		sqlStr.append("DS_CREATED_USER, DS_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ");
		sqlStr.append("?, ? )");
		sqlStr_insertComment = sqlStr.toString();
		
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT C.DS_COMMENT_STATUS, C.DS_COMMENT_DESC, ");
		sqlStr.append("       C.DS_CREATED_USER, U.CO_FIRSTNAME || ' ' || U.CO_LASTNAME, ");
		sqlStr.append("       TO_CHAR(DS_CREATED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   DS_COMMENT C, CO_USERS U ");
		sqlStr.append("WHERE  C.DS_SITE_CODE = U.CO_SITE_CODE ");
		sqlStr.append("AND	  C.DS_COMMENT_USER_ID = U.CO_STAFF_ID ");
		sqlStr.append("AND	  C.DS_ENABLED = 1 ");
		sqlStr.append("AND    C.DS_SITE_CODE = ? ");
		sqlStr.append("AND    C.DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    C.DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    C.DS_PLAN_ID = ? ");
		sqlStr.append("AND    C.DS_GOAL_ID = ? ");
		sqlStr.append("AND    C.DS_OBJECT_TYPE = ? ");
		sqlStr.append("AND    C.DS_OBJECT_ID = ? ");
		sqlStr.append("ORDER BY	C.DS_CREATED_DATE DESC ");
		sqlStr_getComments = sqlStr.toString();
	}
}