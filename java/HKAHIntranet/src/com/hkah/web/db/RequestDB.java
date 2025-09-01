package com.hkah.web.db;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class RequestDB {
	private static final int DEFAULT_COLUMN_LENGTH = 1000;

	public static ArrayList get(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT REQ_NO, TO_CHAR(REQ_DATE, 'DD/MM/YYYY'), SITE, REQ_DEPT, REQ_BY, SYS_NAME, ");
		sqlStr.append("       REQ_TYPE, REQ_NAME, EST_DAYS, REQ_STATUS, TO_CHAR(ACT_START, 'DD/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(ACT_RUN_HK, 'DD/MM/YYYY'), TO_CHAR(ACT_RUN_TW, 'DD/MM/YYYY'), TO_CHAR(ACT_RUN_AMC, 'DD/MM/YYYY'), REMARKS, ");
		sqlStr.append("       TO_CHAR(CREATE_DATE, 'DD/MM/YYYY'), CREATE_USER ");
		sqlStr.append("FROM   REQ_MASTER ");
		sqlStr.append("WHERE  REQ_NO = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { reqNo });
	}

	public static ArrayList getRequestList(UserBean userBean, String status, String reqNo) {
		// fetch summary
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT R.REQ_NO, R.REQ_NAME, R.REQ_BY, D.CO_DEPARTMENT_DESC || NVL2(S.CO_STAFFNAME, ' / ' || S.CO_STAFFNAME, '') , R.REQ_STATUS, TO_CHAR(R.REQ_DATE, 'YYYY MM DD') ");
		sqlStr.append("FROM   REQ_MASTER R, CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  R.REQ_BY = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND  R.REQ_DEPT = D.CO_DEPARTMENT_CODE (+) ");

		if (!userBean.isAdmin()) {
			sqlStr.append(" AND   R.CREATE_USER = ? ");
		}

		if (reqNo != null && reqNo.length() > 0) {
			sqlStr.append(" AND   R.REQ_NO = '");
			sqlStr.append(reqNo);
			sqlStr.append("' ");
		} else if (status != null && status.length() > 0) {
			sqlStr.append(" AND   R.REQ_STATUS = '");
			sqlStr.append(status);
			sqlStr.append("' ");
		}

		sqlStr.append(" ORDER BY R.REQ_NO ");

		if (userBean.isAdmin()) {
			return UtilDBWeb.getReportableList(sqlStr.toString());
		} else {
			return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userBean.getStaffID() });
		}
	}

	public static ArrayList getAvailableUser(String reqNo, UserBean userBean) {
		// fetch summary
		StringBuffer sqlStr = new StringBuffer();
		String deptCode = userBean.getDeptCode();

		sqlStr.append("SELECT CO_STAFF_ID, CO_STAFFNAME ");
		sqlStr.append("FROM   CO_STAFFS ");
		sqlStr.append("WHERE  CO_STAFF_ID IN ");
		sqlStr.append("(SELECT CO_STAFF_ID ");
		sqlStr.append(" FROM CO_STAFFS ");
		sqlStr.append(" WHERE CO_TERMINATION_DATE IS NULL ");
		sqlStr.append(" AND CO_MARK_DELETED = 'N' ");
		sqlStr.append(" AND CO_ENABLED = 1 ");
		if (!userBean.isAdmin()) {
			sqlStr.append(" AND CO_DEPARTMENT_CODE = ? ");
		}
		sqlStr.append(" MINUS ");
		sqlStr.append(" SELECT CO_STAFF_ID ");
		sqlStr.append(" FROM REQ_ASSIGN ");
		sqlStr.append(" WHERE REQ_NO = ?) ");
		sqlStr.append("ORDER BY CO_STAFFNAME");

		if (userBean.isAdmin()) {
			return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { reqNo });
		} else {
			return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { deptCode, reqNo });
		}
	}

	public static ArrayList getAssignedUser(String reqNo) {
		// fetch summary
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT A.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_DEPARTMENT_CODE ");
		sqlStr.append("FROM   REQ_ASSIGN A, CO_STAFFS S ");
		sqlStr.append("WHERE  A.CO_STAFF_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    REQ_NO = ? ");
		sqlStr.append("ORDER BY S.CO_STAFFNAME");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { reqNo });
	}

	public static boolean assignStaff(UserBean userBean,
			String reqNo, String staffID) {

		String userID = userBean.getStaffID();
		if (userID == null || userID.length() > 0) {
			userID = userBean.getUserName();
		}

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO REQ_ASSIGN ");
		sqlStr.append(" (REQ_NO, CO_STAFF_ID, CREATED_DATE, CREATED_USER) ");
		sqlStr.append(" VALUES (?, ?, SYSDATE, ?) ");
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
						reqNo, staffID, userID})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean assignAllStaff (String reqNo, UserBean userBean) {
		// fetch summary
		StringBuffer sqlStr = new StringBuffer();
		String deptCode = userBean.getDeptCode();

		String userID = userBean.getStaffID();
		if (userID == null || userID.length() > 0) {
			userID = userBean.getUserName();
		}

		sqlStr.append("INSERT INTO REQ_ASSIGN ");
		sqlStr.append(" (REQ_NO, CO_STAFF_ID, CREATED_DATE, CREATED_USER) ");
		sqlStr.append(" (SELECT ?, CO_STAFF_ID, SYSDATE, ? ");
		sqlStr.append(" FROM CO_STAFFS ");
		sqlStr.append(" WHERE CO_TERMINATION_DATE IS NULL ");
		sqlStr.append(" AND CO_MARK_DELETED = 'N' ");
		sqlStr.append(" AND CO_ENABLED = 1 ");
		if (!userBean.isAdmin()) {
			sqlStr.append(" AND CO_DEPARTMENT_CODE = ? ");
		}
		sqlStr.append(" MINUS ");
		sqlStr.append(" SELECT REQ_NO, CO_STAFF_ID, SYSDATE, ? ");
		sqlStr.append(" FROM REQ_ASSIGN ");
		sqlStr.append(" WHERE REQ_NO = ?) ");

		if (userBean.isAdmin()) {
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] {
							reqNo, userID, userID, reqNo})) {
				return true;
			} else {
				return false;
			}
		} else {
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] {
							reqNo, userID, deptCode, userID, reqNo})) {
				return true;
			} else {
				return false;
			}
		}
	}

	public static boolean removeStaff(String reqNo, String staffID) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("DELETE REQ_ASSIGN ");
		sqlStr.append(" WHERE REQ_NO = ? ");
		sqlStr.append(" AND CO_STAFF_ID = ? ");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					reqNo, staffID })) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean removeAllStaff(String reqNo) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("DELETE REQ_ASSIGN ");
		sqlStr.append(" WHERE REQ_NO = ? ");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					reqNo })) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean update(String reqNo,
			String reqDate,	String site, String reqDept,
			String reqBy, String sysName, String taskType,
			String taskName, String estDay,	String status,
			String startDate, String HKDate, String TWDate,
			String AMCDate,	String remark) {

		System.out.println(estDay);

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE REQ_MASTER SET REQ_DATE = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" SITE = ?, ");
		sqlStr.append(" REQ_DEPT = ?, ");
		sqlStr.append(" REQ_BY = ?, ");
		sqlStr.append(" SYS_NAME = ?, ");
		sqlStr.append(" REQ_TYPE = ?, ");
		sqlStr.append(" REQ_NAME = ?, ");
		sqlStr.append(" EST_DAYS = TO_NUMBER(?), ");
		sqlStr.append(" REQ_STATUS = ?, ");
		sqlStr.append(" ACT_START = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" ACT_RUN_HK = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" ACT_RUN_TW = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" ACT_RUN_AMC = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" REMARKS = ? ");
		sqlStr.append(" WHERE REQ_NO = ? ");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					reqDate, site, reqDept,
					reqBy, sysName, taskType,
					taskName, estDay, status,
					startDate, HKDate, TWDate,
					AMCDate, remark, reqNo })) {
			return true;
		} else {
			return false;
		}

	}

	public static boolean create(UserBean userBean, String reqNo,
			String reqDate,	String site, String reqDept,
			String reqBy, String sysName, String taskType,
			String taskName, String estDay,	String status,
			String startDate, String HKDate, String TWDate,
			String AMCDate,	String remark) {

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO REQ_MASTER (REQ_NO, REQ_DATE, SITE, ");
		sqlStr.append(" REQ_DEPT, REQ_BY, SYS_NAME, REQ_TYPE, REQ_NAME, ");
		sqlStr.append(" EST_DAYS, REQ_STATUS, ACT_START, ");
		sqlStr.append(" ACT_RUN_HK, ACT_RUN_TW, ACT_RUN_AMC, REMARKS, ");
		sqlStr.append(" CREATE_DATE, CREATE_USER) ");
		sqlStr.append(" VALUES (?, TO_DATE(?, 'DD/MM/YYYY'), ?, ?, ?, ?, ?, ?, ");
		sqlStr.append(" TO_NUMBER(?), ?, TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" TO_DATE(?, 'DD/MM/YYYY'), TO_DATE(?, 'DD/MM/YYYY'), TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" ?, SYSDATE, ?) ");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					reqNo, reqDate, site, reqDept,
					reqBy, sysName, taskType,
					taskName, estDay, status,
					startDate, HKDate, TWDate,
					AMCDate, remark, userBean.getStaffID() })) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean delete(String reqNo) {

		 removeAllStaff(reqNo);

		 StringBuffer sqlStr = new StringBuffer();
		 sqlStr.append("DELETE REQ_MASTER WHERE REQ_NO = ? ");

		 if (UtilDBWeb.updateQueue(
			sqlStr.toString(),
			new String[] { reqNo })) {

			 return true;
		 } else {
			 return false;
		 }
	}

	public static boolean createTask(UserBean userBean, String reqNo,
			String task, String taskDate, String manTime, String taskDept, String staffID) {

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO REQ_TASK (TASK_ID, REQ_NO, CO_STAFF_ID, TASK, TASK_DATE, MAN_TIME, TASK_DEPT, CREATE_USER, CREATE_DATE) ");
		sqlStr.append(" VALUES (TASK_SEQ.NEXTVAL, ?, ?, ?, TO_DATE(?, 'DD/MM/YYYY'), TO_NUMBER(?), ?, ?, SYSDATE )");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					reqNo, staffID, task, taskDate, manTime, taskDept, userBean.getStaffID() })) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean updateTask(UserBean userBean, String taskID, String reqNo, String task, String manTime, String taskDept) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE REQ_TASK SET REQ_NO = ?, ");
		sqlStr.append(" TASK = ?, ");
		sqlStr.append(" MAN_TIME = TO_NUMBER(?), ");
		sqlStr.append(" TASK_DEPT = ?, ");
		sqlStr.append(" MODIFY_USER = ?, ");
		sqlStr.append(" MODIFY_DATE = SYSDATE ");
		sqlStr.append(" WHERE TASK_ID = TO_NUMBER(?) ");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					reqNo, task, manTime, taskDept, userBean.getStaffID(), taskID })) {
			return true;
		} else {
			return false;
		}

	}

	public static boolean deleteTask(String taskID) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("DELETE REQ_TASK WHERE TASK_ID = TO_NUMBER(?) ");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { taskID })) {
			return true;
		} else {
			return false;
		}
	}

	public static ArrayList getTask(String staffID, String taskDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TASK_ID, REQ_NO, TASK, MAN_TIME, TASK_DEPT ");
		sqlStr.append("FROM   REQ_TASK ");
		sqlStr.append("WHERE  CO_STAFF_ID = ? ");
		sqlStr.append(" AND   TO_CHAR(TASK_DATE, 'DD/MM/YYYY') = ? ");
		sqlStr.append(" ORDER BY TASK_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID, taskDate});
	}

	public static String getManTimeTotal(String staffID, String taskDate) {

		String total;

		ArrayList record = getManTimeByDate(staffID, taskDate, taskDate);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			total = row.getValue(0);
		} else
			total = "0";

		return total;
	}

	public static ArrayList getManTimeByDate(String staffID, String date_from, String date_to ) {

		StringBuffer sqlStr = new StringBuffer();
		String total;

		sqlStr.append("SELECT SUM(MAN_TIME), TO_CHAR(TASK_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   REQ_TASK ");
		sqlStr.append("WHERE  CO_STAFF_ID = ? ");
		if (date_from != null && date_from.length() == 10) {
			sqlStr.append(" AND   TASK_DATE >= TO_DATE('");
			sqlStr.append(date_from);
			sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		if (date_to != null && date_to.length() == 10) {
			sqlStr.append(" AND   TASK_DATE <= TO_DATE('");
			sqlStr.append(date_to);
			sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		sqlStr.append(" GROUP BY TO_CHAR(TASK_DATE, 'dd/MM/YYYY') ");

		return UtilDBWeb.getReportableList(sqlStr.toString(),
					new String[] { staffID });
	}

	public static ArrayList getAssignReq(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT M.REQ_NO, M.REQ_NAME ");
		sqlStr.append("FROM   REQ_ASSIGN A INNER JOIN REQ_MASTER M ON A.REQ_NO = M.REQ_NO ");
		sqlStr.append("WHERE  CO_STAFF_ID = ? ");
		sqlStr.append(" ORDER BY M.REQ_NO ");
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID });
	}

	public static ArrayList getHolidayList(String date_from, String date_to) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DESCRIPTION, TO_CHAR(HOLIDAY, 'dd/MM/YYYY') ");
		sqlStr.append("FROM PUBLIC_HOLIDAY@IWEB   ");
		sqlStr.append("WHERE  1 = 1 ");
		if (date_from != null && date_from.length() == 10) {
			sqlStr.append(" AND   HOLIDAY >= TO_DATE('");
			sqlStr.append(date_from);
			sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		if (date_to != null && date_to.length() == 10) {
			sqlStr.append(" AND   HOLIDAY <= TO_DATE('");
			sqlStr.append(date_to);
			sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { });
	}

	public static String getHoliday(String date) {
		ArrayList record = getHolidayList(date, date);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else
			return null;
	}

	public static ArrayList getDeptReport(UserBean userBean, String date_from, String date_to) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT T.REQ_NO, S.CO_STAFFNAME, T.TASK, T.MAN_TIME, TO_CHAR(T.TASK_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append(" SUBSTR(T.TASK_DEPT, 1, 2) || ' ' || NVL(DECODE(SUBSTR(T.TASK_DEPT, 1, 2), 'HK', D.CO_DEPARTMENT_DESC, 'TW', TD.CO_DEPARTMENT_DESC, SUBSTR(T.TASK_DEPT, 3)), '(None Specify)') ");
		sqlStr.append(" FROM REQ_TASK T INNER JOIN REQ_MASTER M ON T.REQ_NO = M.REQ_NO " );
		sqlStr.append(" LEFT OUTER JOIN CO_STAFFS S ON T.CO_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append(" LEFT OUTER JOIN CO_DEPARTMENTS D ON SUBSTR(T.TASK_DEPT, 3) = D.CO_DEPARTMENT_CODE ");
		sqlStr.append(" LEFT OUTER JOIN CO_DEPARTMENTS@TWAH TD ON SUBSTR(T.TASK_DEPT, 3) = TD.CO_DEPARTMENT_CODE ");
		sqlStr.append(" WHERE M.CREATE_USER = ? ");
		if (date_from != null && date_from.length() == 10) {
			sqlStr.append(" AND T.TASK_DATE >= TO_DATE('");
			sqlStr.append(date_from);
			sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		if (date_to != null && date_to.length() == 10) {
			sqlStr.append(" AND T.TASK_DATE <= TO_DATE('");
			sqlStr.append(date_to);
			sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		sqlStr.append(" AND T.MAN_TIME IS NOT NULL ");
		sqlStr.append(" ORDER BY D.CO_DEPARTMENT_DESC, T.TASK_DATE, T.TASK ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userBean.getStaffID() });
	}

	public static ArrayList getReqReport(UserBean userBean, String date_from, String date_to) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT T.REQ_NO, M.REQ_NAME, ");
		sqlStr.append(" SUBSTR(M.REQ_DEPT, 1, 2) || ' ' || NVL(DECODE(SUBSTR(M.REQ_DEPT, 1, 2), 'HK', D.CO_DEPARTMENT_DESC, 'TW', TD.CO_DEPARTMENT_DESC, SUBSTR(M.REQ_DEPT, 3)), '(None Specify)'), ");
		sqlStr.append(" S.CO_STAFFNAME, T.TASK, T.MAN_TIME, TO_CHAR(T.TASK_DATE, 'DD/MM/YYYY') ");
		sqlStr.append(" FROM REQ_TASK T LEFT OUTER JOIN REQ_MASTER M ON T.REQ_NO = M.REQ_NO ");
		sqlStr.append(" LEFT OUTER JOIN CO_STAFFS S ON T.CO_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append(" LEFT OUTER JOIN CO_DEPARTMENTS D ON SUBSTR(M.REQ_DEPT, 3) = D.CO_DEPARTMENT_CODE ");
		sqlStr.append(" LEFT OUTER JOIN CO_DEPARTMENTS@TWAH TD ON SUBSTR(M.REQ_DEPT, 3) = TD.CO_DEPARTMENT_CODE ");
		sqlStr.append(" WHERE M.CREATE_USER = ? ");
		if (date_from != null && date_from.length() == 10) {
			sqlStr.append(" AND T.TASK_DATE >= TO_DATE('");
			sqlStr.append(date_from);
			sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		if (date_to != null && date_to.length() == 10) {
			sqlStr.append(" AND T.TASK_DATE <= TO_DATE('");
			sqlStr.append(date_to);
			sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		sqlStr.append(" AND T.MAN_TIME IS NOT NULL ");
		sqlStr.append(" ORDER BY D.CO_DEPARTMENT_DESC, M.REQ_NO, T.TASK_DATE, T.TASK ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userBean.getStaffID() });
	}

	public static ArrayList getStaffReport(UserBean userBean, String date_from, String date_to) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT T.REQ_NO,  M.REQ_NAME, T.CO_STAFF_ID, S.CO_STAFFNAME, SUM(T.MAN_TIME) ");
		sqlStr.append(" FROM REQ_TASK T LEFT OUTER JOIN REQ_MASTER M ON T.REQ_NO = M.REQ_NO ");
		sqlStr.append(" LEFT OUTER JOIN CO_STAFFS S ON T.CO_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append(" WHERE M.CREATE_USER = ? ");
		if (date_from != null && date_from.length() == 10) {
			sqlStr.append(" AND T.TASK_DATE >= TO_DATE('");
			sqlStr.append(date_from);
			sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		if (date_to != null && date_to.length() == 10) {
			sqlStr.append(" AND T.TASK_DATE <= TO_DATE('");
			sqlStr.append(date_to);
			sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		sqlStr.append(" GROUP BY  T.REQ_NO,  M.REQ_NAME, T.CO_STAFF_ID, S.CO_STAFFNAME ");
		sqlStr.append(" ORDER BY T.CO_STAFF_ID, T.REQ_NO ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userBean.getStaffID() });
	}

	public static String getDefaultReqNo() {
		String reqNo;

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT NVL( MAX( CONV_NUM(SUBSTR(REQ_NO, 2)) ), 0) + 1 ");
		sqlStr.append(" FROM REQ_MASTER WHERE REQ_NO LIKE 'R%' ");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			reqNo = "R" + row.getValue(0);
		} else
			reqNo = "R1";

		return reqNo;
	}

	// ---------------------------------------------------------------------
	static {

	}
}