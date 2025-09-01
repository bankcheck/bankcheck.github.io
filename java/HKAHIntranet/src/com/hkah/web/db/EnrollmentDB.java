/*
 * Created on April 8, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;


/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class EnrollmentDB {

	private static String sqlStr_SelectEnrollNo = null;
	private static String sqlStr_updateAttendStatus  = null;

	public static String getNextEnrollID(String moduleCode, String eventID) {
		String enrollID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CO_ENROLL_ID) + 1 FROM CO_ENROLLMENT WHERE CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CO_MODULE_CODE = ? AND CO_EVENT_ID = ?",
				new String[] { moduleCode, eventID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			enrollID = reportableListObject.getValue(0);

			// set 1 for initial
			if (enrollID == null || enrollID.length() == 0) return "1";
		}
		return enrollID;
	}

	public static String add(UserBean userBean,
			String moduleCode, String eventID, String scheduleID,
			String userType, String userID, String attendDate, String remark) {
		return add(
				moduleCode, eventID, scheduleID,
				userType, userID, ConstantsVariable.ONE_VALUE, attendDate, null, remark,
				userBean.getLoginID(), null);
	}

	public static String add(UserBean userBean,
			String moduleCode, String eventID, String scheduleID,
			String userType, String userID, String attendDate, String remark, String createDate) {
		return add(
				moduleCode, eventID, scheduleID,
				userType, userID, ConstantsVariable.ONE_VALUE, attendDate, null, remark,
				userBean.getLoginID(), createDate);
	}

	public static String add(UserBean userBean,
			String moduleCode, String eventID, String staffID, String attendDate, String attendDate2) {
		return add(
				moduleCode, eventID, null,
				"staff", staffID, ConstantsVariable.ONE_VALUE, attendDate, attendDate2, null,
				userBean.getLoginID(), null);
	}

	public static String add(
			String moduleCode, String eventID, String scheduleID,
			String userType, String userID, String enrollNo, String attendDate, String remark,
			String createUser, String createDate) {
		return add(
				moduleCode, eventID, scheduleID,
				userType, userID, enrollNo, attendDate, null, remark,
				createUser, createDate);
	}

	public static String add(
			String moduleCode, String eventID, String scheduleID,
			String userType, String userID, String enrollNo, String attendDate, String attendDate2, String remark,
			String createUser, String createDate) {
		// get next event ID
		String enrollID = getNextEnrollID(moduleCode, eventID);

		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_ENROLLMENT (CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID, CO_SCHEDULE_ID, CO_ENROLL_ID, ");
		sqlStr.append("CO_USER_TYPE, CO_USER_ID, CO_ENROLL_NO, CO_ATTEND_DATE, CO_ATTEND_DATE2, CO_ATTEND_STATUS, CO_REMARK, ");
		if (createDate != null) {
			sqlStr.append("CO_CREATED_DATE, CO_MODIFIED_DATE, ");
		}
		sqlStr.append("CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?, ?, TO_DATE(?, 'dd/MM/YYYY");
		if (attendDate != null && attendDate.length() == 19) {
			// add time if necessary
			sqlStr.append(" HH24:MI:SS");
		}
		sqlStr.append("'), TO_DATE(?, 'dd/MM/YYYY");
		if (attendDate2 != null && attendDate2.length() == 19) {
			// add time if necessary
			sqlStr.append(" HH24:MI:SS");
		}
		sqlStr.append("'), ?, ?, ");
		if (createDate != null) {
			sqlStr.append("TO_DATE('");
			sqlStr.append(createDate);
			sqlStr.append("', 'dd/MM/YYYY HH24:MI:SS'), TO_DATE('");
			sqlStr.append(createDate);
			sqlStr.append("', 'dd/MM/YYYY HH24:MI:SS'), ");
		}
		sqlStr.append("?, ?)");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { moduleCode, eventID, scheduleID, enrollID, userType, userID, enrollNo,
					attendDate, attendDate2, (attendDate == null ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.ONE_VALUE), remark,
					createUser, createUser })) {
			return enrollID;
		} else {
			return null;
		}
	}
	
	public static String addExtClient(
			String moduleCode, String eventID, String scheduleID,
			String userType, String userID, String enrollNo, String attendDate, String remark,
			String hasFollowUp,
			String createUser, String remark2, String remark3) {
		// get next event ID
		String enrollID = getNextEnrollID(moduleCode, eventID);

		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_ENROLLMENT (CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID, CO_SCHEDULE_ID, CO_ENROLL_ID, ");
		sqlStr.append("CO_USER_TYPE, CO_USER_ID, CO_ENROLL_NO, CO_ATTEND_DATE, CO_ATTEND_STATUS, CO_REMARK, ");
		sqlStr.append("CO_CREATED_DATE, CO_MODIFIED_DATE, ");
		sqlStr.append("CO_CREATED_USER, CO_MODIFIED_USER, CO_REMARK2, CO_REMARK3 ) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?, ?, TO_DATE(?, 'dd/MM/YYYY");
		if (attendDate != null && attendDate.length() == 19) {
			// add time if necessary
			sqlStr.append(" HH24:MI:SS");
		}
		sqlStr.append("'),");

		sqlStr.append(" ?, ?, SYSDATE, SYSDATE, ");
		sqlStr.append("?, ?, ?, ?)");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { moduleCode, eventID, scheduleID, enrollID, userType, userID, enrollNo,
					attendDate, (attendDate == null ? ConstantsVariable.ZERO_VALUE : ConstantsVariable.ONE_VALUE), remark,
					createUser, createUser, remark2, remark3 })) {
			return enrollID;
		} else {
			return null;
		}
	}
	
	

	/**
	 * update enrollment
	 * @return whether it is successful
	 */
	public static boolean update(UserBean userBean, String moduleCode,
							String eventID, String scheduleID, String enrollID,
							String userType, String userID, String enrollNo) {
		return update(moduleCode, eventID, scheduleID, enrollID, userType,
				userID, enrollNo, null, null, null, userBean.getLoginID());
	}

	public static boolean update(UserBean userBean,
			String moduleCode, String eventID, String scheduleID, String enrollID,
			String userType, String userID, String attendDate, String remark) {
		return update(moduleCode, eventID, scheduleID, enrollID,
			userType, userID, ConstantsVariable.ONE_VALUE, attendDate, null, remark, userBean.getLoginID());
	}

	public static boolean update(UserBean userBean,
			String moduleCode, String eventID, String enrollID,
			String userID, String attendDate, String attendDate2) {
		return update(moduleCode, eventID, null, enrollID,
			"staff", userID, ConstantsVariable.ONE_VALUE, attendDate, attendDate2, null, userBean.getLoginID());
	}

	public static boolean update(
			String moduleCode, String eventID, String scheduleID, String enrollID,
			String userType, String userID, String enrollNo, String attendDate, String remark, String updateUser) {
		return update(
				moduleCode, eventID, scheduleID, enrollID,
				userType, userID, enrollNo, attendDate, null, remark, updateUser);
	}

	public static boolean update(
			String moduleCode, String eventID, String scheduleID, String enrollID,
			String userType, String userID, String enrollNo, String attendDate, String attendDate2, String remark, String updateUser) {
		// try to update record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_ENROLL_NO = ?, ");
		sqlStr.append("       CO_ATTEND_DATE = TO_DATE(?, 'dd/MM/yyyy");
		if (attendDate != null && attendDate.length() == 19) {
			// add time if necessary
			sqlStr.append(" HH24:MI:SS");
		}
		sqlStr.append("'), ");
		sqlStr.append("       CO_ATTEND_DATE2 = TO_DATE(?, 'dd/MM/yyyy");
		if (attendDate2 != null && attendDate2.length() == 19) {
			// add time if necessary
			sqlStr.append(" HH24:MI:SS");
		}
		sqlStr.append("'), ");
		sqlStr.append("       CO_REMARK = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		if (scheduleID != null && scheduleID.length() > 0) {
			sqlStr.append("AND    CO_SCHEDULE_ID = '");
			sqlStr.append(scheduleID);
			sqlStr.append("' ");
		}
		sqlStr.append("AND    CO_ENROLL_ID = ? ");
		sqlStr.append("AND    CO_USER_TYPE = ? ");
		sqlStr.append("AND    CO_USER_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					enrollNo, attendDate, attendDate2, remark, updateUser,
					moduleCode, eventID, enrollID, userType, userID });
	}

	public static boolean updateAttendStatus(
			String moduleCode, String eventID,
			String userType, String userID, String attendDate, String updateUser) {

		// get next event ID
		String enrollID = null;
		String scheduleID = null;

		ArrayList record = UtilDBWeb.getReportableList(sqlStr_SelectEnrollNo, new String [] { moduleCode, eventID, userType, userID, attendDate });
		if (record.size() > 0) {
			ReportableListObject row = null;
			for (int i = 0; enrollID == null && i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				enrollID = row.getValue(0);
				scheduleID = row.getValue(1);
			}

			if (enrollID != null) {
				return UtilDBWeb.updateQueue(
						sqlStr_updateAttendStatus,
						new String[] {
								attendDate, updateUser, moduleCode, eventID, scheduleID, enrollID, userType, userID  });
			}
		}
		return false;
	}

	/**
	 * delete enrollment
	 * @return whether it is successful
	 */
	public static boolean delete(UserBean userBean,
			String moduleCode, String eventID, String enrollID) {
		return delete(userBean, moduleCode, eventID, null, enrollID);
	}

	public static boolean delete(UserBean userBean,
			String moduleCode, String eventID, String scheduleID, String enrollID) {
		// try to delete record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		if (scheduleID != null && scheduleID.length() > 0) {
			sqlStr.append("AND    CO_SCHEDULE_ID = '");
			sqlStr.append(scheduleID);
			sqlStr.append("' ");
		}
		sqlStr.append("AND    CO_ENROLL_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					userBean.getLoginID(),
					moduleCode, eventID, enrollID });
	}

	public static boolean deleteExemption(UserBean userbean, String clientID,
			String moduleCode, String eventID, String scheduleID,String dateFrom,String dateTo) {
		// try to delete record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND CO_USER_ID like '"+clientID+"' ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		if (scheduleID != null && scheduleID.length() > 0) {
			sqlStr.append("AND    CO_SCHEDULE_ID = '");
			sqlStr.append(scheduleID);
			sqlStr.append("' ");
		}
		sqlStr.append(" AND CO_ATTEND_DATE > TO_DATE('"+dateFrom+"','dd/mm/yyyy')");
		sqlStr.append(" AND CO_ATTEND_DATE < TO_DATE('"+dateTo+"','dd/mm/yyyy')");
		sqlStr.append("AND    CO_REMARK like 'Exemption' ");
		sqlStr.append("AND    CO_ENABLED = 1");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					userbean.getLoginID(),
					moduleCode, eventID });
	}

	public static boolean deleteClass(UserBean userbean, String clientID,
			String moduleCode, String eventID, String scheduleID,String dateFrom,String dateTo) {
		// try to delete record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND CO_USER_ID like '"+clientID+"' ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		if (scheduleID != null && scheduleID.length() > 0) {
			sqlStr.append("AND    CO_SCHEDULE_ID = '");
			sqlStr.append(scheduleID);
			sqlStr.append("' ");
		}
		sqlStr.append(" AND CO_ATTEND_DATE > TO_DATE('"+dateFrom+"','dd/mm/yyyy')");
		sqlStr.append(" AND CO_ATTEND_DATE < TO_DATE('"+dateTo+"','dd/mm/yyyy')");
		sqlStr.append("AND    CO_ENABLED = 1");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					userbean.getLoginID(),
					moduleCode, eventID });
	}

	public static ArrayList getList(
			String eventCategory, String eventType, String courseGroup) {
		// fetch course
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_CODE, CO_DEPARTMENT_DESC, ");
		sqlStr.append("       CO_EVENT_ID, CO_EVENT_DESC, ");
		sqlStr.append("       CO_EVENT_CATEGORY, CO_EVENT_TYPE, '' ");
		sqlStr.append("FROM (");
		sqlStr.append("SELECT C.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_ID, C.CO_EVENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE ");
		sqlStr.append("FROM   CO_SCHEDULE CS, CO_EVENT C, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  CS.CO_ENABLED = 1 ");
		sqlStr.append("AND    CS.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    CS.CO_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    C.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		if (eventCategory != null && eventCategory.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_CATEGORY = '");
			sqlStr.append(eventCategory);
			sqlStr.append("' ");
		}
		if (eventType != null && eventType.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_TYPE = '");
			sqlStr.append(eventType);
			sqlStr.append("' ");
		}
		if (courseGroup != null && courseGroup.length() > 0) {
//			sqlStr.append("AND    C.CO_EVENT_GROUP = '");
//			sqlStr.append(courseGroup);
//			sqlStr.append("' ");
		}
		sqlStr.append("GROUP BY C.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("         C.CO_EVENT_ID, C.CO_EVENT_DESC, ");
		sqlStr.append("         C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE ");

		sqlStr.append(") UNION (");

		sqlStr.append("SELECT C.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_ID, C.CO_EVENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE, EL.CO_ELEARNING_ID ");
		sqlStr.append("FROM   CO_ELEARNING EL, CO_EVENT C, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  EL.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    EL.EE_MODULE_CODE = C.EE_MODULE_CODE ");
		sqlStr.append("AND    EL.EE_EVENT_ID = C.EE_EVENT_ID ");
		sqlStr.append("AND    C.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		if (eventCategory != null && eventCategory.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_CATEGORY = '");
			sqlStr.append(eventCategory);
			sqlStr.append("' ");
		}
		if (eventType != null && eventType.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_TYPE = '");
			sqlStr.append(eventType);
			sqlStr.append("' ");
		}
		if (courseGroup != null && courseGroup.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_GROUP = '");
			sqlStr.append(courseGroup);
			sqlStr.append("' ");
		}
		sqlStr.append("AND    EL.CO_ENABLED = 1 ");

		sqlStr.append(")");

		sqlStr.append("ORDER BY CO_DEPARTMENT_CODE, CO_EVENT_DESC ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList get(String moduleCode, String eventID, String enrollID) {
		// fetch enrollment
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CO_DEPARTMENT_CODE, D1.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_ID, C.CO_EVENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE, ");
		sqlStr.append("       CE.CO_ENROLL_ID, CE.CO_ENROLL_NO, ");
		sqlStr.append("       CE.CO_USER_TYPE, CE.CO_USER_ID, S.CO_STAFFNAME, D2.CO_DEPARTMENT_DESC, ");
 		sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE, 'dd/MM/YYYY'), ");
 		sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE, 'HH24:MI'), ");
 		sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE2, 'HH24:MI'), ");
 		sqlStr.append("       CO_ATTEND_STATUS, ");
		sqlStr.append("       CE.CO_CREATED_USER, CE.CO_LUNCH ");
		sqlStr.append("FROM   CO_ENROLLMENT CE, CO_EVENT C, CO_DEPARTMENTS D1, CO_DEPARTMENTS D2, CO_STAFFS S ");
		sqlStr.append("WHERE  CE.CO_ENABLED = 1 ");
		sqlStr.append("AND    CE.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    CE.CO_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    CE.CO_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    C.CO_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE (+) ");
		if (moduleCode != null && moduleCode.length() > 0) {
			sqlStr.append("AND    CE.CO_MODULE_CODE = '");
			sqlStr.append(moduleCode);
			sqlStr.append("' ");
		}
		if (eventID != null && eventID.length() > 0) {
			sqlStr.append("AND    CE.CO_EVENT_ID = '");
			sqlStr.append(eventID);
			sqlStr.append("' ");
		}
		if (enrollID != null && enrollID.length() > 0) {
			sqlStr.append("AND    CE.CO_ENROLL_ID = '");
			sqlStr.append(enrollID);
			sqlStr.append("' ");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	public static ArrayList getListByDate(
			String moduleCode, String eventID, String date_from, String date_to) {
		return getListByDate(moduleCode, null, eventID, null, null, date_from, date_to);
	}

	public static ArrayList getListByDate(
			String moduleCode, String deptCode, String eventID, String eventCategory, String eventType, String date_from, String date_to) {
		// fetch course
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CO_DEPARTMENT_CODE, D1.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_ID, C.CO_EVENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE, ");
		sqlStr.append("       CE.CO_ENROLL_ID, CE.CO_ENROLL_NO, ");
		sqlStr.append("       CE.CO_USER_TYPE, CE.CO_USER_ID, S.CO_STAFFNAME, D2.CO_DEPARTMENT_DESC, ");
 		sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE, 'dd/MM/YYYY'), ");
 		sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE, 'HH24:MI'), ");
 		sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE2, 'HH24:MI'), ");
 		sqlStr.append("       CO_ATTEND_STATUS ");
		sqlStr.append("FROM   CO_EVENT C, CO_DEPARTMENTS D1, CO_DEPARTMENTS D2, CO_ENROLLMENT CE, CO_STAFFS S ");
		sqlStr.append("WHERE  CE.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    CE.CO_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    CE.CO_ENABLED = 1 ");
		sqlStr.append("AND    CE.CO_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.CO_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE (+) ");
		if (moduleCode != null && moduleCode.length() > 0) {
			sqlStr.append("AND    C.CO_MODULE_CODE = '");
			sqlStr.append(moduleCode);
			sqlStr.append("' ");
		}
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    D1.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (eventID != null && eventID.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_ID = '");
			sqlStr.append(eventID);
			sqlStr.append("' ");
		}
		if (eventCategory != null && eventCategory.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_CATEGORY = '");
			sqlStr.append(eventCategory);
			sqlStr.append("' ");
		}
		if (eventType != null && eventType.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_TYPE = '");
			sqlStr.append(eventType);
			sqlStr.append("' ");
		}
		if (date_from != null && date_from.length() == 10) {
			sqlStr.append("AND    CE.CO_ATTEND_DATE >= TO_DATE('");
			sqlStr.append(date_from);
			sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		if (date_to != null && date_to.length() == 10) {
			sqlStr.append("AND    CE.CO_ATTEND_DATE <= TO_DATE('");
			sqlStr.append(date_to);
			sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		sqlStr.append("ORDER BY C.CO_EVENT_ID, CE.CO_ATTEND_DATE");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean isExist(String moduleCode, String eventID, String userType, String userID, String enrolledDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CO_ENROLLMENT ");
		sqlStr.append("WHERE  CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_USER_TYPE like '"+userType+"' ");
		sqlStr.append("AND    CO_USER_ID like '"+userID+"' ");
		sqlStr.append("AND    TO_CHAR(CO_ATTEND_DATE, 'dd/mm/YYYY') = ? ");
		sqlStr.append("AND    CO_ATTEND_STATUS = 1 ");
		return UtilDBWeb.isExist(sqlStr.toString(), new String[] { moduleCode, eventID, enrolledDate });
	}

	public static boolean isEnrollednotAttend(String moduleCode, String eventID,String scheduleID, String userType, String userID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CO_ENROLLMENT ");
		sqlStr.append("WHERE  CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND 	  CO_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CO_USER_TYPE like '"+userType+"' ");
		sqlStr.append("AND    CO_USER_ID like '"+userID+"' ");
		sqlStr.append("AND    CO_ATTEND_DATE IS NULL ");
		return UtilDBWeb.isExist(sqlStr.toString(), new String[] { moduleCode, eventID,scheduleID });
	}

	public static boolean updateOnDuty(UserBean userBean, String moduleCode, String eventID, String scheduleID, String enrollID, String onDuty) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_REMARK = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_ENROLL_ID = ? ");
		sqlStr.append("AND    CO_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { onDuty, userBean.getLoginID(), moduleCode, eventID, enrollID, scheduleID } );
	}

	public static boolean updateLunch(UserBean userBean, String moduleCode, String eventID, String scheduleID, String enrollID, String lunch) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_LUNCH = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_ENROLL_ID = ? ");
		sqlStr.append("AND    CO_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { lunch, userBean.getLoginID(), moduleCode, eventID, enrollID, scheduleID } );
	}
	
	public static boolean isExistCurrentYear(String moduleCode, String eventID, String userType, String userID, String enrolledYear) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CO_ENROLLMENT ");
		sqlStr.append("WHERE  CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_USER_TYPE like '"+userType+"' ");
		sqlStr.append("AND    CO_USER_ID like '"+userID+"' ");
		sqlStr.append("AND    TO_CHAR(CO_ATTEND_DATE, 'YYYY') = ? ");
		sqlStr.append("AND    CO_ATTEND_STATUS = 1 AND CO_ENABLED = 1 ");

		return UtilDBWeb.isExist(sqlStr.toString(), new String[] { moduleCode, eventID, enrolledYear });
	}


	public static boolean isExist(String moduleCode, String eventID, boolean include, String enrollID, String attendDate, String attendDate2) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CO_ENROLLMENT ");
		sqlStr.append("WHERE  CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		if (enrollID != null && enrollID.length() > 0) {
			if (include) {
				sqlStr.append("AND    CO_ENROLL_ID = '");
			} else {
				sqlStr.append("AND    CO_ENROLL_ID != '");
			}
			sqlStr.append(enrollID);
			sqlStr.append("' ");
		}
		// for new start date before other start and new end date after other start
		sqlStr.append("AND  ((CO_ATTEND_DATE >= TO_DATE(?, 'dd/MM/YYYY");	// ? startdate
		if (attendDate != null && attendDate.length() == 19) {
			// add time if necessary
			sqlStr.append(" HH24:MI:SS");
		}
		sqlStr.append("') ");
		sqlStr.append("AND    CO_ATTEND_DATE < TO_DATE(?, 'dd/MM/YYYY");	// ? enddate
		if (attendDate != null && attendDate.length() == 19) {
			// add time if necessary
			sqlStr.append(" HH24:MI:SS");
		}
		sqlStr.append("')) ");
		
		
		// for new start date after other start but before other end
		sqlStr.append("OR    (CO_ATTEND_DATE < TO_DATE(?, 'dd/MM/YYYY");	// ? startdate
		if (attendDate2 != null && attendDate2.length() == 19) {
			// add time if necessary
			sqlStr.append(" HH24:MI:SS");
		}
		sqlStr.append("') ");
		sqlStr.append("AND    CO_ATTEND_DATE2 > TO_DATE(?, 'dd/MM/YYYY");	// ? startdate
		if (attendDate2 != null && attendDate2.length() == 19) {
			// add time if necessary
			sqlStr.append(" HH24:MI:SS");
		}
		sqlStr.append("'))) ");

		return UtilDBWeb.isExist(sqlStr.toString(), new String[] { moduleCode, eventID, attendDate, attendDate2, attendDate, attendDate });
	}

	public static ArrayList getEnrolledClass(String moduleCode, String eventID, String scheduleID, String userType, String userID, String attendStatus, String followup, String userStatus, String staffName) {
		return getEnrolledClass(moduleCode, eventID, scheduleID, userType, userID, attendStatus, followup, userStatus, null, null, false, staffName);
	}

	public static ArrayList getEnrolledClass(String moduleCode, String eventID,
								String scheduleID, String userType, String userID,
								String attendStatus, String followup, String userStatus,
								String attendDateFrom, String attendDateTo,
								boolean show1YearOnly, String staffName) {
		if (moduleCode.equals("education") || moduleCode.equals("vaccine")) {
			return getEnrolledClass4Education(moduleCode, eventID, scheduleID, userType, userID, attendStatus, attendDateFrom, attendDateTo, show1YearOnly);
		} else if (moduleCode.equals("crm")) {
			return getEnrolledClass4CRM(moduleCode, eventID, scheduleID, userType, userID, attendStatus, followup);
		} else if (moduleCode.equals("christmas")) {
			return getEnrolledGroup4XmasParty(moduleCode, eventID, scheduleID,
						userID, userStatus, attendStatus, followup, staffName);
		}
		else {
			return null;
		}
	}

	private static ArrayList getEnrolledGroup4XmasParty(String moduleCode,
			String eventID, String scheduleID, String userID,
			String userStatus,String subDate,String confirmStatus, String staffName) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("(SELECT CE.CO_EVENT_ID, C.CO_EVENT_DESC, CE.CO_SCHEDULE_ID, CE.CO_ENROLL_ID, ");
		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_START, 'dd/MM/YYYY'), ");
 		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_START, 'HH24:MI'), ");
 		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_END, 'HH24:MI'), ");
 		sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE, 'dd/MM/YYYY'), ");
 		if (ConstantsServerSide.isTWAH()) {
 		sqlStr.append("       CE.CO_ATTEND_STATUS, S.CO_STAFF_ID, S.CO_DISPLAY_NAME, ");
 		}else{
 		sqlStr.append("       CE.CO_ATTEND_STATUS, S.CO_STAFF_ID, S.CO_STAFFNAME, ");
 		}
		sqlStr.append("       S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       TO_CHAR(CE.CO_ASSESSMENT_PASS_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append(" 	  TO_CHAR(CE.CO_ATTEND_DATE2, 'HH24:MI'),CE.CO_REMARK, ");
		sqlStr.append(" 	  CS.CO_SCHEDULE_DESC, TO_CHAR(CE.CO_CREATED_DATE, 'DD/MM/YYYY HH24:MI'), S.CO_STATUS, CE.CO_ENROLL_NO, ");
		sqlStr.append(" 	  CO_LOCATION_DESC, '' AS CO_FAMILYTYPE_DESC, '' AS CO_REMARK, 0 AS F_ENROLL_NO, ");
		sqlStr.append(" 	  TO_CHAR(S.CO_HIRE_DATE, 'dd/MM/YYYY') HIREDATE, CE.HAS_FOLLOWUP, '組別 ' || substr(CS.CO_SCHEDULE_DESC, 7,3), CE.CO_REMARK2, CE.CO_REMARK3  ");
		sqlStr.append("FROM   CO_ENROLLMENT CE, CO_EVENT C, CO_SCHEDULE CS, CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  CE.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    CE.CO_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CE.CO_SITE_CODE = CS.CO_SITE_CODE (+) ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = CS.CO_MODULE_CODE (+) ");
		sqlStr.append("AND    CE.CO_EVENT_ID = CS.CO_EVENT_ID (+) ");
		sqlStr.append("AND    CE.CO_SCHEDULE_ID = CS.CO_SCHEDULE_ID (+) ");
		sqlStr.append("AND    CE.CO_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		if (eventID != null && eventID.length() > 0) {
			sqlStr.append("AND    CE.CO_EVENT_ID = '");
			sqlStr.append(eventID);
			sqlStr.append("' ");
		}
		if (staffName != null && staffName.length() > 0) {
			if (ConstantsServerSide.isTWAH()) {
				sqlStr.append("AND    UPPER(S.CO_DISPLAY_NAME) like '%");
				sqlStr.append(staffName.toUpperCase());
				sqlStr.append("%' ");
			}
			else {
				sqlStr.append("AND    UPPER(S.CO_STAFFNAME) like '%");
				sqlStr.append(staffName.toUpperCase());
				sqlStr.append("%' ");
			}
		}
		if (scheduleID != null && scheduleID.length() > 0) {
			sqlStr.append("AND    CE.CO_SCHEDULE_ID = '");
			sqlStr.append(scheduleID);
			sqlStr.append("' ");
		}
		if (userID != null && userID.length() > 0) {
			sqlStr.append("AND    CE.CO_USER_ID = '");
			sqlStr.append(userID);
			sqlStr.append("' ");
		}
		if (userStatus != null && userStatus.length() > 0) {
			sqlStr.append("AND    S.CO_STATUS = '");
			sqlStr.append(userStatus);
			sqlStr.append("' ");
		}
		if (subDate != null && subDate.length() > 0) {
			sqlStr.append("AND CE.CO_CREATED_DATE BETWEEN TO_DATE('" + subDate + " 00:00:00' ,'dd/mm/yyyy HH24:MI:SS') " +
					"AND TO_DATE('" + subDate+ " 23:59:59' , 'dd/mm/yyyy HH24:MI:SS') ");
		}
		if (confirmStatus != null && confirmStatus.length() > 0) {
			if ("Y".equals(confirmStatus)) {
				sqlStr.append("AND (CE.CO_REMARK = 'confirm' OR CE.CO_ENROLL_NO =1) ");
			}else if ("N".equals(confirmStatus)) {
				sqlStr.append("AND CE.CO_REMARK IS NULL AND CE.CO_ENROLL_NO != 1 ");
			}
		}
		// only show 1 year history
		sqlStr.append("AND    CE.CO_MODIFIED_DATE >= SYSDATE - 365 ");
		sqlStr.append("AND    CE.CO_ENABLED = 1) ");
		sqlStr.append("UNION ALL ");
		sqlStr.append("(");
		sqlStr.append("SELECT CE.CO_EVENT_ID, C.CO_EVENT_DESC, CE.CO_SCHEDULE_ID, CE.CO_ENROLL_ID, ");
		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_START, 'dd/MM/YYYY'), ");
 		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_START, 'HH24:MI'), ");
 		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_END, 'HH24:MI'), ");
 		sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE, 'dd/MM/YYYY'), ");
 		if (ConstantsServerSide.isTWAH()) {
 		sqlStr.append("       CE.CO_ATTEND_STATUS, S.CO_STAFF_ID, S.CO_DISPLAY_NAME, ");
 		}else{
 		sqlStr.append("       CE.CO_ATTEND_STATUS, S.CO_STAFF_ID, S.CO_STAFFNAME, ");
 		}
		sqlStr.append("       S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       TO_CHAR(CE.CO_ASSESSMENT_PASS_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append(" 	  TO_CHAR(CE.CO_ATTEND_DATE2, 'HH24:MI'),CE.CO_REMARK, ");
		sqlStr.append(" 	  CS.CO_SCHEDULE_DESC, TO_CHAR(CE.CO_CREATED_DATE, 'DD/MM/YYYY HH24:MI'), S.CO_STATUS, CE.CO_ENROLL_NO, ");
		sqlStr.append(" 	  CO_LOCATION_DESC, FT.CO_FAMILYTYPE_DESC, F.CO_REMARK, F.CO_ENROLL_NO AS F_ENROLL_NO, ");
		sqlStr.append(" 	  TO_CHAR(S.CO_HIRE_DATE, 'dd/MM/YYYY') HIREDATE,  F.CO_MEAL_TYPE, CE.CO_REMARK2, CE.CO_REMARK3, '組別 ' || substr(CS.CO_SCHEDULE_DESC, 7,3) ");
		sqlStr.append("FROM   CO_ENROLLMENT CE, CO_EVENT C, CO_SCHEDULE CS, CO_STAFFS S, CO_DEPARTMENTS D, CO_ENROLLMENT_FAMILY F, CO_ENROLLMENT_FAMILYTYPE FT ");
		sqlStr.append("WHERE  CE.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    CE.CO_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CE.CO_SITE_CODE = CS.CO_SITE_CODE (+) ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = CS.CO_MODULE_CODE (+) ");
		sqlStr.append("AND    CE.CO_EVENT_ID = CS.CO_EVENT_ID (+) ");
		sqlStr.append("AND    CE.CO_SCHEDULE_ID = CS.CO_SCHEDULE_ID (+) ");
		sqlStr.append("AND    CE.CO_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		if (eventID != null && eventID.length() > 0) {
			sqlStr.append("AND    CE.CO_EVENT_ID = '");
			sqlStr.append(eventID);
			sqlStr.append("' ");
		}
		if (staffName != null && staffName.length() > 0) {
			if (ConstantsServerSide.isTWAH()) {
				sqlStr.append("AND    UPPER(S.CO_DISPLAY_NAME) like '%");
				sqlStr.append(staffName.toUpperCase());
				sqlStr.append("%' ");
			}
			else {
				sqlStr.append("AND    UPPER(S.CO_STAFFNAME) like '%");
				sqlStr.append(staffName.toUpperCase());
				sqlStr.append("%' ");
			}
		}
		if (scheduleID != null && scheduleID.length() > 0) {
			sqlStr.append("AND    CE.CO_SCHEDULE_ID = '");
			sqlStr.append(scheduleID);
			sqlStr.append("' ");
		}
		if (userID != null && userID.length() > 0) {
			sqlStr.append("AND    CE.CO_USER_ID = '");
			sqlStr.append(userID);
			sqlStr.append("' ");
		}
		if (userStatus != null && userStatus.length() > 0) {
			sqlStr.append("AND    S.CO_STATUS = '");
			sqlStr.append(userStatus);
			sqlStr.append("' ");
		}
		if (subDate != null && subDate.length() > 0) {
			sqlStr.append("AND CE.CO_CREATED_DATE BETWEEN TO_DATE('" + subDate + " 00:00:00' ,'dd/mm/yyyy HH24:MI:SS') " +
					"AND TO_DATE('" + subDate+ " 23:59:59' , 'dd/mm/yyyy HH24:MI:SS') ");
		}
		if (confirmStatus != null && confirmStatus.length() > 0) {
			if ("Y".equals(confirmStatus)) {
				sqlStr.append("AND (CE.CO_REMARK = 'confirm' OR CE.CO_ENROLL_NO =1) ");
			}else if ("N".equals(confirmStatus)) {
				sqlStr.append("AND CE.CO_REMARK IS NULL AND CE.CO_ENROLL_NO != 1 ");
			}
		}
		sqlStr.append("AND    CE.CO_MODIFIED_DATE >= SYSDATE - 365 ");
		sqlStr.append("AND    CE.CO_ENABLED = 1 ");
		sqlStr.append("AND    CE.CO_SITE_CODE = F.CO_SITE_CODE ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = F.CO_MODULE_CODE  ");
		sqlStr.append("AND    CE.CO_EVENT_ID = F.CO_EVENT_ID ");
		sqlStr.append("AND    CE.CO_SCHEDULE_ID = F.CO_SCHEDULE_ID ");
		sqlStr.append("AND    CE.CO_USER_ID = F.CO_USER_ID ");
		sqlStr.append("AND    CE.CO_ENROLL_ID = F.CO_ENROLL_ID ");
		sqlStr.append("AND    F.CO_SITE_CODE = FT.CO_SITE_CODE ");
		sqlStr.append("AND    F.CO_MODULE_CODE = FT.CO_MODULE_CODE ");
		sqlStr.append("AND    F.CO_FAMILY_TYPE_ID = FT.CO_FAMILYTYPE_ID) ");
		sqlStr.append("ORDER BY CO_SCHEDULE_ID, CO_STAFF_ID, CO_ENROLL_ID, F_ENROLL_NO");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode, moduleCode });
	}

	private static ArrayList getEnrolledClass4Education(String moduleCode, String eventID, String scheduleID, String userType, String userID,
			String attendStatus, String attendDateFrom, String attendDateTo, boolean show1YearOnly) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CE.CO_EVENT_ID, C.CO_EVENT_DESC, CE.CO_SCHEDULE_ID, CE.CO_ENROLL_ID, ");
		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_START, 'dd/MM/YYYY'), ");
 		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_START, 'HH24:MI'), ");
 		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_END, 'HH24:MI'), ");
 		sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE, 'dd/MM/YYYY'), ");
 		if (ConstantsServerSide.isTWAH()) {
 		sqlStr.append("       CE.CO_ATTEND_STATUS, S.CO_STAFF_ID, S.CO_DISPLAY_NAME, ");
 		}else{
 		sqlStr.append("       CE.CO_ATTEND_STATUS, S.CO_STAFF_ID, S.CO_LASTNAME || ' ' || S.CO_FIRSTNAME as CO_FULLNAME, ");
 		}
		sqlStr.append("       S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       TO_CHAR(CE.CO_ASSESSMENT_PASS_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append(" 	  TO_CHAR(CE.CO_ATTEND_DATE2, 'HH24:MI'),CE.CO_REMARK,CS.CO_SCHEDULE_DESC, ");
		sqlStr.append(" 	  C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE, C.CO_REQUIRE_ASSESSMENT_PASS, TO_CHAR(CE.CO_CREATED_DATE, 'dd/MM/YYYY'), CE.CO_LUNCH, CS.CO_SCHEDULE_DURATION, CE.CO_REMARK2, S.CO_STAFFNAME ");
		sqlStr.append("FROM   CO_ENROLLMENT CE, CO_EVENT C, CO_SCHEDULE CS, CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  CE.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    CE.CO_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CE.CO_SITE_CODE = CS.CO_SITE_CODE (+) ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = CS.CO_MODULE_CODE (+) ");
		sqlStr.append("AND    CE.CO_EVENT_ID = CS.CO_EVENT_ID (+) ");
		sqlStr.append("AND    CE.CO_SCHEDULE_ID = CS.CO_SCHEDULE_ID (+) ");
		sqlStr.append("AND    CE.CO_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		if (eventID != null && eventID.length() > 0) {
			sqlStr.append("AND    CE.CO_EVENT_ID = '");
			sqlStr.append(eventID);
			sqlStr.append("' ");
		}
		if (scheduleID != null && scheduleID.length() > 0) {
			sqlStr.append("AND    CE.CO_SCHEDULE_ID = '");
			sqlStr.append(scheduleID);
			sqlStr.append("' ");
		}
		if (userType != null && userType.length() > 0) {
			sqlStr.append("AND    CE.CO_USER_TYPE = '");
			sqlStr.append(userType);
			sqlStr.append("' ");
		}
		if (userID != null && userID.length() > 0) {
			sqlStr.append("AND    CE.CO_USER_ID = '");
			sqlStr.append(userID);
			sqlStr.append("' ");
		}
		if (attendStatus != null && attendStatus.length() > 0) {
			sqlStr.append("AND    CE.CO_ATTEND_STATUS = '");
			sqlStr.append(attendStatus);
			sqlStr.append("' ");
		}
		if (attendDateFrom != null && attendDateFrom.length() > 0) {
			sqlStr.append("AND    CE.CO_ATTEND_DATE >= to_date('"+attendDateFrom+"','dd/mm/yyyy') ");
		}
		if (attendDateTo != null && attendDateTo.length() > 0) {
			sqlStr.append("AND    CE.CO_ATTEND_DATE < to_date('"+attendDateTo+"','dd/mm/yyyy') ");
		}
		if (show1YearOnly) {
		// only show 1 year history
			sqlStr.append("AND    CE.CO_MODIFIED_DATE >= SYSDATE - 365 ");
		}
		sqlStr.append("AND    CE.CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY CE.CO_USER_ID, CS.CO_SCHEDULE_START DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode });
	}

	private static ArrayList getEnrolledClass4CRM(String moduleCode, String eventID, String scheduleID, String userType, String userID, String attendStatus, String followup) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CE.CO_EVENT_ID, E.CO_EVENT_DESC, CE.CO_SCHEDULE_ID, CE.CO_ENROLL_ID, ");
		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_START, 'dd/MM/YYYY'), ");
 		sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       CE.CO_ATTEND_STATUS, CE.CO_ENROLL_NO, ");
		sqlStr.append("       C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME, C.CRM_CHINESENAME, C.CRM_HKID , CE.HAS_FOLLOWUP, CE.CO_REMARK ");
		sqlStr.append("FROM   CO_ENROLLMENT CE, CO_EVENT E, CO_SCHEDULE CS, CRM_CLIENTS C ");
		sqlStr.append("WHERE  CE.CO_SITE_CODE = E.CO_SITE_CODE ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = E.CO_MODULE_CODE ");
		sqlStr.append("AND    CE.CO_EVENT_ID = E.CO_EVENT_ID ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CE.CO_SITE_CODE = CS.CO_SITE_CODE (+) ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = CS.CO_MODULE_CODE (+) ");
		sqlStr.append("AND    CE.CO_EVENT_ID = CS.CO_EVENT_ID (+) ");
		sqlStr.append("AND    CE.CO_SCHEDULE_ID = CS.CO_SCHEDULE_ID (+) ");
		sqlStr.append("AND    CE.CO_USER_TYPE = 'patient' ");
		sqlStr.append("AND    CE.CO_USER_ID = C.CRM_CLIENT_ID ");
		if (followup!=null && followup.length() > 0) {
		sqlStr.append("AND CE.HAS_FOLLOWUP = '");
		sqlStr.append(followup);
		sqlStr.append("' ");
		}
		if (eventID != null && eventID.length() > 0) {
			sqlStr.append("AND    CE.CO_EVENT_ID = '");
			sqlStr.append(eventID);
			sqlStr.append("' ");
		}
		if (scheduleID != null && scheduleID.length() > 0) {
			sqlStr.append("AND    CE.CO_SCHEDULE_ID = '");
			sqlStr.append(scheduleID);
			sqlStr.append("' ");
		}
		if (userType != null && userType.length() > 0) {
			sqlStr.append("AND    CE.CO_USER_TYPE = '");
			sqlStr.append(userType);
			sqlStr.append("' ");
		}
		if (userID != null && userID.length() > 0) {
			sqlStr.append("AND    CE.CO_USER_ID = '");
			sqlStr.append(userID);
			sqlStr.append("' ");
		}
		if (attendStatus != null && attendStatus.length() > 0) {
			sqlStr.append("AND    CE.CO_ATTEND_STATUS = '");
			sqlStr.append(attendStatus);
			sqlStr.append("' ");
		}
		sqlStr.append("AND    CE.CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY C.CRM_LASTNAME, C.CRM_FIRSTNAME");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode });
	}

	public static ArrayList getAttendedClass(String moduleCode, String eventID, String eventCategory, String userType, String userID, String date_from, String date_to) {
		return getAttendedClass(moduleCode, eventID, eventCategory, null, userType, userID, date_from, date_to);
	}

	public static ArrayList getAttendedClass(String moduleCode, String eventID, String eventCategory, String elearningID, String userType, String userID, String date_from, String date_to) {
		return getAttendedClass(moduleCode, eventID, eventCategory, null, userType, userID, null, date_from, date_to);
	}

	public static ArrayList getAttendedClass(String moduleCode, String eventID, String eventCategory, String elearningID, String userType, String userID, String deptCode, String date_from, String date_to) {
		// fetch course taken
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CE.CO_SITE_CODE, CE.CO_EVENT_ID, CE.CO_ENROLL_ID, ");
		sqlStr.append("       C.CO_EVENT_DESC, CE.CO_SCHEDULE_ID, ");
		sqlStr.append("       CE.CO_USER_TYPE, CE.CO_USER_ID, ");
		// * If the course is sit-in class and require a sit-in assessment to be pass, the complete date would use co_assessment_pass_date, otherwise, use co_attend_date
		sqlStr.append("       CASE WHEN C.CO_EVENT_TYPE = 'class' AND C.CO_REQUIRE_ASSESSMENT_PASS = 'Y' THEN TO_CHAR(CE.CO_ASSESSMENT_PASS_DATE, 'dd/MM/yyyy') ELSE TO_CHAR(CE.CO_ATTEND_DATE, 'dd/MM/yyyy') END, ");
		sqlStr.append("       CASE WHEN C.CO_EVENT_TYPE = 'class' AND C.CO_REQUIRE_ASSESSMENT_PASS = 'Y' THEN TO_CHAR(CE.CO_ASSESSMENT_PASS_DATE, 'HH24:MI') ELSE TO_CHAR(CE.CO_ATTEND_DATE, 'HH24:MI') END ");

		if ("staff".equals(userType)) {
			sqlStr.append("      , S.CO_STAFFNAME, D.CO_DEPARTMENT_DESC, ES.EE_CORRECT_ANS ");
		}		
		sqlStr.append("      ,To_Char(Ce.Co_Attend_Date, 'dd/MM/yyyy'), TO_CHAR(CE.CO_ASSESSMENT_PASS_DATE, 'dd/MM/yyyy') ");
		if ("CNE".equals(eventCategory)) {
			sqlStr.append("		 , TRUNC((CES.CO_SCHEDULE_END-CES.CO_SCHEDULE_START )*24/0.5)/2 CNEPT ");
		}
		sqlStr.append("FROM   CO_ENROLLMENT CE, CO_EVENT C ");
		if ("staff".equals(userType)) {
			sqlStr.append("       , CO_STAFFS S, CO_DEPARTMENTS D, EE_ELEARNING_STAFF ES ");
		}
		if ("CNE".equals(eventCategory)) {
			sqlStr.append(" , CO_SCHEDULE CES ");
		}
		sqlStr.append("WHERE  CE.CO_ENABLED = 1 ");
		if ("staff".equals(userType)) {
			sqlStr.append("AND    CE.CO_USER_ID = S.CO_STAFF_ID ");
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
			sqlStr.append("AND    CE.CO_SITE_CODE = ES.EE_SITE_CODE (+) ");
			sqlStr.append("AND    CE.CO_MODULE_CODE = ES.EE_MODULE_CODE (+) ");
			sqlStr.append("AND    CE.CO_EVENT_ID = ES.EE_EVENT_ID (+) ");
			sqlStr.append("AND    CE.CO_ENROLL_ID = ES.EE_ENROLL_ID (+) ");
		}
		if ("CNE".equals(eventCategory)) {
			sqlStr.append("AND (CES.CO_SCHEDULE_ID = CE.CO_SCHEDULE_ID AND CES.CO_EVENT_ID = CE.CO_EVENT_ID) ");
		}
		sqlStr.append("AND    CE.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    CE.CO_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = ? ");
		if (eventID != null && eventID.length() > 0) {
			sqlStr.append("AND    CE.CO_EVENT_ID = '");
			sqlStr.append(eventID);
			sqlStr.append("' ");
		}
		if (eventCategory != null && eventCategory.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_CATEGORY = '");
			sqlStr.append(eventCategory);
			sqlStr.append("' ");
		}
		if ("staff".equals(userType) && (elearningID != null && elearningID.length() > 0)) {
			sqlStr.append("AND    ES.EE_ELEARNING_ID = '");
			sqlStr.append(elearningID);
			sqlStr.append("' ");
		}
		if (userType != null && userType.length() > 0) {
			sqlStr.append("AND    CE.CO_USER_TYPE = '");
			sqlStr.append(userType);
			sqlStr.append("' ");
		}
		if (userID != null && userID.length() > 0) {
			sqlStr.append("AND    CE.CO_USER_ID = '");
			sqlStr.append(userID);
			sqlStr.append("' ");
		}
		if ("staff".equals(userType) && (deptCode != null && deptCode.length() > 0)) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if( "education".equals(moduleCode)) {
			if ((date_from != null && date_from.length() == 10) || (date_to != null && date_to.length() == 10)){
				sqlStr.append("AND ( ");
			}
			
			if (date_from != null && date_from.length() == 10) {
				sqlStr.append(" CE.CO_ATTEND_DATE >= TO_DATE('");
				sqlStr.append(date_from);
				sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
			}
			if ((date_from != null && date_from.length() == 10) && (date_to != null && date_to.length() == 10)){
				sqlStr.append("AND ");
			}
		
			if (date_to != null && date_to.length() == 10) {
				sqlStr.append(" CE.CO_ATTEND_DATE <= TO_DATE('");
				sqlStr.append(date_to);
				sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
			}
			
			if ((date_from != null && date_from.length() == 10) || (date_to != null && date_to.length() == 10)){
				sqlStr.append("OR ( C.Co_Require_Assessment_Pass = 'Y' AND ");
			}
			
			if (date_from != null && date_from.length() == 10) {
				sqlStr.append(" CE.CO_ASSESSMENT_PASS_DATE >= TO_DATE('");
				sqlStr.append(date_from);
				sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
			}
			/*
			if ((date_from != null && date_from.length() == 10) && (date_to != null && date_to.length() == 10)){
				sqlStr.append("AND ");
			}
		
			if (date_to != null && date_to.length() == 10) {
				sqlStr.append(" CE.CO_ASSESSMENT_PASS_DATE <= TO_DATE('");
				sqlStr.append(date_to);
				sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
			}
			*/
			if ((date_from != null && date_from.length() == 10) || (date_to != null && date_to.length() == 10)){
				sqlStr.append(" ) ");
				sqlStr.append(" ) ");
			}
		} else {
			if (date_from != null && date_from.length() == 10) {
				sqlStr.append("AND    CE.CO_ATTEND_DATE >= TO_DATE('");
				sqlStr.append(date_from);
				sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
			}
			if (date_to != null && date_to.length() == 10) {
				sqlStr.append("AND    CE.CO_ATTEND_DATE <= TO_DATE('");
				sqlStr.append(date_to);
				sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
			}
		}

		sqlStr.append("AND    (C.CO_REQUIRE_ASSESSMENT_PASS <> 'Y' OR C.CO_REQUIRE_ASSESSMENT_PASS IS NULL OR (C.CO_REQUIRE_ASSESSMENT_PASS = 'Y' AND CE.CO_ASSESSMENT_PASS_DATE IS NOT NULL)) ");

		sqlStr.append("AND    CE.CO_ATTEND_STATUS = 1 ");
		sqlStr.append("AND    CE.CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY CE.CO_EVENT_ID, CE.CO_ATTEND_DATE");
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode });
	}
	
	public static ArrayList getExpireDate(String moduleCode, String eventID, String userID, String date_from, String date_to) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CE.CO_SITE_CODE, CE.CO_EVENT_ID, CE.CO_ENROLL_ID, ");
		sqlStr.append("       C.CO_EVENT_DESC, CE.CO_SCHEDULE_ID, ");
		sqlStr.append("       CE.CO_USER_TYPE, CE.CO_USER_ID, ");
		sqlStr.append("       TO_CHAR(CE.CO_ASSESSMENT_PASS_DATE, 'dd/MM/yyyy'), TO_CHAR(CE.CO_ASSESSMENT_PASS_DATE, 'HH24:MI'), ");
		sqlStr.append("       S.CO_STAFFNAME, D.CO_DEPARTMENT_DESC, ES.EE_CORRECT_ANS, ");
		sqlStr.append("       CASE WHEN CE.CO_ASSESSMENT_PASS_DATE > SYSDATE THEN 'VALID' ELSE 'EXPIRED' END,  ");
		sqlStr.append("       TO_CHAR(CE.CO_ATTEND_DATE, 'dd/MM/yyyy'), TO_CHAR(CE.CO_ATTEND_DATE, 'HH24:MI') ");
		sqlStr.append("FROM   CO_ENROLLMENT CE, CO_EVENT C, CO_STAFFS S, CO_DEPARTMENTS D, EE_ELEARNING_STAFF ES ");
		sqlStr.append("WHERE  CE.CO_ENABLED = 1 ");
		sqlStr.append("AND    CE.CO_USER_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    CE.CO_SITE_CODE = ES.EE_SITE_CODE (+) ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = ES.EE_MODULE_CODE (+) ");
		sqlStr.append("AND    CE.CO_EVENT_ID = ES.EE_EVENT_ID (+) ");
		sqlStr.append("AND    CE.CO_ENROLL_ID = ES.EE_ENROLL_ID (+) ");
		sqlStr.append("AND    CE.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    CE.CO_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = '" + moduleCode + "' ");
		sqlStr.append("AND    CE.CO_EVENT_ID IN (" + eventID + ") ");
		sqlStr.append("AND    CE.CO_USER_TYPE = 'staff'" );
		if (userID != null && userID.length() > 0) {
		sqlStr.append("AND    CE.CO_USER_ID = '" + userID + "' ");
		}
		if( "education".equals(moduleCode)) {
		if ((date_from != null && date_from.length() == 10) || (date_to != null && date_to.length() == 10)){
		sqlStr.append("AND ( ");
		}
		
		if (date_from != null && date_from.length() == 10) {
		sqlStr.append(" CE.CO_ATTEND_DATE >= TO_DATE('");
		sqlStr.append(date_from);
		sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		if ((date_from != null && date_from.length() == 10) && (date_to != null && date_to.length() == 10)){
		sqlStr.append("AND ");
		}
		
		if (date_to != null && date_to.length() == 10) {
		sqlStr.append(" CE.CO_ATTEND_DATE <= TO_DATE('");
		sqlStr.append(date_to);
		sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		
		if ((date_from != null && date_from.length() == 10) || (date_to != null && date_to.length() == 10)){
		sqlStr.append("OR ( C.Co_Require_Assessment_Pass = 'Y' AND ");
		}
		
		if (date_from != null && date_from.length() == 10) {
		sqlStr.append(" CE.CO_ASSESSMENT_PASS_DATE >= TO_DATE('");
		sqlStr.append(date_from);
		sqlStr.append(" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		if ((date_from != null && date_from.length() == 10) && (date_to != null && date_to.length() == 10)){
		sqlStr.append("AND ");
		}
		
		if (date_to != null && date_to.length() == 10) {
		sqlStr.append(" CE.CO_ASSESSMENT_PASS_DATE <= TO_DATE('");
		sqlStr.append(date_to);
		sqlStr.append(" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		
		if ((date_from != null && date_from.length() == 10) || (date_to != null && date_to.length() == 10)){
		sqlStr.append(" ) ");
		sqlStr.append(" ) ");
		}
		}
		sqlStr.append("AND    (C.CO_REQUIRE_ASSESSMENT_PASS <> 'Y' OR C.CO_REQUIRE_ASSESSMENT_PASS IS NULL OR (C.CO_REQUIRE_ASSESSMENT_PASS = 'Y' AND CE.CO_ASSESSMENT_PASS_DATE IS NOT NULL)) ");
		
		sqlStr.append("AND    CE.CO_ATTEND_STATUS = 1 ");
		sqlStr.append("AND    CE.CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY CE.CO_ASSESSMENT_PASS_DATE DESC");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getCRMAttendedClass(String userName) {
		// fetch course taken
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CE.CO_SITE_CODE, CE.CO_EVENT_ID, CE.CO_ENROLL_ID, ");
		sqlStr.append("C.CO_EVENT_DESC, CE.CO_SCHEDULE_ID,        CE.CO_USER_TYPE, CE.CO_USER_ID, ");
		sqlStr.append("CASE WHEN C.CO_EVENT_TYPE = 'class' AND C.CO_REQUIRE_ASSESSMENT_PASS = 'Y' ");
		sqlStr.append("THEN TO_CHAR(CE.CO_ASSESSMENT_PASS_DATE, 'dd/MM/yyyy') ELSE TO_CHAR(CE.CO_ATTEND_DATE, 'dd/MM/yyyy') END, ");
		sqlStr.append("CASE WHEN C.CO_EVENT_TYPE = 'class' ");
		sqlStr.append("AND C.CO_REQUIRE_ASSESSMENT_PASS = 'Y' THEN TO_CHAR(CE.CO_ASSESSMENT_PASS_DATE, 'HH24:MI') ");
		sqlStr.append("ELSE TO_CHAR(CE.CO_ATTEND_DATE, 'HH24:MI') END       ,ES.EE_CORRECT_ANS, E.EE_QUESTION_NUM, C.CO_EVENT_SHORT_DESC ");
		sqlStr.append("FROM   CO_ENROLLMENT CE, CO_EVENT C ,   EE_ELEARNING_STAFF ES , EE_ELEARNING E ");
		sqlStr.append("WHERE  CE.CO_ENABLED = 1 ");
		sqlStr.append("AND    CE.CO_SITE_CODE = ES.EE_SITE_CODE (+) ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = ES.EE_MODULE_CODE (+) ");
		sqlStr.append("AND    CE.CO_EVENT_ID = ES.EE_EVENT_ID (+) ");
		sqlStr.append("AND    CE.CO_ENROLL_ID = ES.EE_ENROLL_ID (+) ");
		sqlStr.append("AND    E.EE_ELEARNING_ID = ES.EE_ELEARNING_ID ");
		sqlStr.append("AND    CE.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    CE.CO_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = 'lmc.crm' ");
		sqlStr.append("AND   (C.CO_EVENT_TYPE = 'class' OR C.CO_EVENT_TYPE = 'online') ");
		sqlStr.append("AND    CE.CO_USER_TYPE = 'guest' ");
		if (userName != null && userName.length()>0) {
			 sqlStr.append("AND   CE.CO_USER_ID = '"+userName+"' ");
		}
		sqlStr.append("AND    (C.CO_REQUIRE_ASSESSMENT_PASS <> 'Y' OR C.CO_REQUIRE_ASSESSMENT_PASS IS NULL OR (C.CO_REQUIRE_ASSESSMENT_PASS = 'Y' ");
		sqlStr.append("AND CE.CO_ASSESSMENT_PASS_DATE IS NOT NULL)) ");
		sqlStr.append("AND    CE.CO_ATTEND_STATUS = 1 ");
		sqlStr.append("AND    CE.CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY CE.CO_ATTEND_DATE DESC ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	/**
	 * return 0 - success
	 * return -1 - already enrolled
	 * return -2 - class full
	 */
	public static int enroll(UserBean userBean, String moduleCode, String eventID, String scheduleID, String enrollNo, String userType, String userID) {
		return enroll(moduleCode, eventID, scheduleID, enrollNo, userType, userID, userBean.getLoginID(), null);
	}

	public static int enroll(UserBean userBean, String moduleCode, String eventID, String scheduleID, String userType, String userID) {
		return enroll(moduleCode, eventID, scheduleID, ConstantsVariable.ONE_VALUE, userType, userID, userBean.getLoginID(), null);
	}
	
	public static int enroll(UserBean userBean, String moduleCode, String eventID, String scheduleID, String userType, String userID,Boolean isSkipSchedule) {
		return enroll(moduleCode, eventID, scheduleID, ConstantsVariable.ONE_VALUE, userType, userID, userBean.getLoginID(), null,null,isSkipSchedule);
	}


	public static int enroll(String moduleCode, String eventID, String scheduleID, String enrollNo, String userType, String userID, String updateUser, String updateDate) {

		return enroll(moduleCode, eventID, scheduleID, enrollNo, userType, userID, updateUser,updateDate, null);
	}
	
	public static int enroll(String moduleCode, String eventID, String scheduleID, String enrollNo, String userType, String userID, String updateUser, String updateDate, String remark) {
		return enroll(moduleCode, eventID, scheduleID, enrollNo, userType, userID, updateUser,updateDate, remark, false);
	}

	public static int enroll(String moduleCode, String eventID, String scheduleID, String enrollNo, String userType, String userID, String updateUser, String updateDate, String remark,boolean isSkipSchedule) {
		boolean isExistRecord = false;
		if (isSkipSchedule) {
			isExistRecord = UtilDBWeb.isExist("SELECT 1 FROM CO_ENROLLMENT WHERE CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CO_MODULE_CODE = ? AND CO_EVENT_ID = ?  AND CO_USER_TYPE = ? AND CO_USER_ID = ? AND CO_ENABLED = 1",
					new String[] { moduleCode, eventID, userType, userID } );
		} else {
			isExistRecord = UtilDBWeb.isExist("SELECT 1 FROM CO_ENROLLMENT WHERE CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CO_MODULE_CODE = ? AND CO_EVENT_ID = ? AND CO_SCHEDULE_ID = ? AND CO_USER_TYPE = ? AND CO_USER_ID = ? AND CO_ENABLED = 1",
					new String[] { moduleCode, eventID, scheduleID, userType, userID } );
		}
		
		if (isExistRecord) {
			return -1;
		} else {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CO_SCHEDULE ");
			sqlStr.append("SET    CO_SCHEDULE_ENROLLED = CO_SCHEDULE_ENROLLED + ?, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
			sqlStr.append("AND    CO_MODULE_CODE = ? ");
			sqlStr.append("AND    CO_EVENT_ID = ? ");
			sqlStr.append("AND    CO_SCHEDULE_ID = ? ");
			sqlStr.append("AND   (CO_SCHEDULE_SIZE >= CO_SCHEDULE_ENROLLED + ? OR CO_SCHEDULE_SIZE = 0) ");
			sqlStr.append("AND    CO_ENABLED = 1");

			if (UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { enrollNo, updateUser, moduleCode, eventID, scheduleID, enrollNo } )) {
				// insert enrollment table
				if (remark != null) {
					add(moduleCode, eventID, scheduleID, userType, userID, enrollNo, null, remark, updateUser, updateDate);
				}
				else{
				add(moduleCode, eventID, scheduleID, userType, userID, enrollNo, null, null, updateUser, updateDate);
				}
				// only staff can get notification
				if ("staff".equals(userType)) {
					// insert todo list
					sqlStr.setLength(0);
					sqlStr.append("INSERT INTO CO_TODO (CO_SITE_CODE, CO_TODO_ID, CO_TASK_ID, CO_JOB_ID, CO_CLASS_ID, CO_USERNAME, CO_CREATED_USER, CO_MODIFIED_USER) ");
					sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', (SELECT COUNT(1) + 1 FROM CO_TODO), ?, ?, ?, ?, ?, ?)");

					UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { "1", eventID, scheduleID,
						updateUser, updateUser, updateUser } );
				}
				return 0;
			} else {
				return -2;
			}
		}
	}

	/**
	 * return 0 - success
	 * return -1 - haven't enrolled yet
	 * return -2 - fail to withdraw
	 */
	public static int withdraw(UserBean userBean, String moduleCode, String eventID, String scheduleID, String enrollID, String userType, String userID) {
		if (!UtilDBWeb.isExist("SELECT 1 FROM CO_ENROLLMENT WHERE CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CO_MODULE_CODE = ? AND CO_EVENT_ID = ? AND CO_SCHEDULE_ID = ? AND CO_USER_TYPE = ? AND CO_USER_ID = ? AND CO_ENABLED = 1",
				new String[] { moduleCode, eventID, scheduleID, userType, userID } )) {
			return -1;
		} else {
			if (delete(userBean, moduleCode, eventID, scheduleID, enrollID)) {
				String enrolledNum = getEnrolledNumber(moduleCode, eventID, scheduleID);

				StringBuffer sqlStr = new StringBuffer();
				sqlStr.append("UPDATE CO_SCHEDULE ");
				sqlStr.append("SET    CO_SCHEDULE_ENROLLED = ?, ");
				sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
				sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
				sqlStr.append("AND    CO_MODULE_CODE = ? ");
				sqlStr.append("AND    CO_EVENT_ID = ? ");
				sqlStr.append("AND    CO_SCHEDULE_ID = ? ");
				sqlStr.append("AND    CO_SCHEDULE_SIZE > 0 ");
				sqlStr.append("AND    CO_ENABLED = 1");

				UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { enrolledNum, userBean.getLoginID(), moduleCode, eventID, scheduleID } );

				// only staff can get notification
				if ("staff".equals(userType)) {
					// update todo list
					sqlStr.setLength(0);
					sqlStr.append("UPDATE CO_TODO SET CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
					sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
					sqlStr.append("AND    CO_TASK_ID = 1 ");
					sqlStr.append("AND    CO_JOB_ID = ? ");
					sqlStr.append("AND    CO_CLASS_ID = ? ");
					sqlStr.append("AND    CO_USERNAME = ? ");
					sqlStr.append("AND    CO_ENABLED = 1");

					UtilDBWeb.updateQueue(
						sqlStr.toString(),
						new String[] { userBean.getLoginID(), eventID, scheduleID, userBean.getLoginID()} );
				}
				return 0;
			} else {
				return -2;
			}
		}
	}

	public static boolean attend(UserBean userBean, String moduleCode, String eventID, String scheduleID, String enrollID, String attendDate) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_ATTEND_DATE = TO_DATE(?, 'DD/MM/YYYY'), CO_ATTEND_STATUS = 1, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_ENROLL_ID = ? ");
		sqlStr.append("AND    CO_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { attendDate, userBean.getLoginID(), moduleCode, eventID, enrollID, scheduleID } );
	}

	public static boolean attend(UserBean userBean, String moduleCode, String eventID, String scheduleID, String enrollID,String userID, String attendDate,String attendTime,String onDuty) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_ATTEND_DATE = TO_DATE('"+attendDate+"', 'DD/MM/YYYY'),CO_ATTEND_DATE2 = TO_DATE('"+attendTime+"','HH24:mi:ss'), CO_ATTEND_STATUS = 1, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = '"+userBean.getLoginID()+"', ");
		sqlStr.append("		  CO_REMARK = '"+onDuty+"' ");
		sqlStr.append("WHERE  CO_SITE_CODE = '"+ ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = '"+moduleCode+"' ");
		sqlStr.append("AND    CO_EVENT_ID = "+eventID+" ");
		sqlStr.append("AND    CO_SCHEDULE_ID = "+scheduleID+" ");
		sqlStr.append("AND 	  CO_USER_ID like '"+userID+"' ");
		sqlStr.append("AND    CO_ENABLED = 1");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	public static boolean attendIgnoreStatus(UserBean userBean, String moduleCode, String eventID, String scheduleID, String enrollID,String userID, String attendDate,String attendTime,String onDuty) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_ATTEND_DATE = TO_DATE('"+attendDate+"', 'DD/MM/YYYY'),CO_ATTEND_DATE2 = TO_DATE('"+attendTime+"','HH24:mi:ss'), CO_ATTEND_STATUS = 1, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = '"+userBean.getLoginID()+"', ");
		sqlStr.append("		  CO_REMARK = '"+onDuty+"' ");
		sqlStr.append("WHERE  CO_SITE_CODE = '"+ ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = '"+moduleCode+"' ");
		sqlStr.append("AND    CO_EVENT_ID = "+eventID+" ");
		sqlStr.append("AND    CO_SCHEDULE_ID = "+scheduleID+" ");
		sqlStr.append("AND 	  CO_USER_ID like '"+userID+"' ");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean passTest(UserBean userBean, String moduleCode, String eventID, String scheduleID, String enrollID, String assessmentDate) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_ASSESSMENT_PASS_DATE = TO_DATE(?, 'DD/MM/YYYY");
		if (assessmentDate != null && assessmentDate.length() == 19) {
			// add time if necessary
			sqlStr.append(" HH24:MI:SS");
		}
		sqlStr.append("'), ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_ENROLL_ID = ? ");
		if (scheduleID != null) {
		sqlStr.append("AND    CO_SCHEDULE_ID = "+scheduleID);
		}
		sqlStr.append("  AND    CO_ENABLED = 1");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { assessmentDate, userBean.getLoginID(), moduleCode, eventID, enrollID } );
	}
	
	public static boolean addRemarks(UserBean userBean, String moduleCode, String eventID, String scheduleID, String enrollID, String remarks2) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_REMARK2 = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_ENROLL_ID = ? ");
		if (scheduleID != null) {
		sqlStr.append("AND    CO_SCHEDULE_ID = "+scheduleID);
		}
		sqlStr.append("  AND    CO_ENABLED = 1");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { remarks2, userBean.getLoginID(), moduleCode, eventID, enrollID } );
	}

	private static String getEnrolledNumber(String moduleCode, String eventID, String scheduleID) {
		String enrolledNum = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT SUM(CO_ENROLL_NO) FROM CO_ENROLLMENT WHERE CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CO_MODULE_CODE = ? AND CO_EVENT_ID = ? AND CO_SCHEDULE_ID = ? AND CO_ENABLED = 1",
				new String[] { moduleCode, eventID, scheduleID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			enrolledNum = reportableListObject.getValue(0);

			// set 1 for initial
			if (enrolledNum == null || enrolledNum.length() == 0) return ConstantsVariable.ZERO_VALUE;
		}
		return enrolledNum;
	}
	public static String getenrollRemark(String eventID, String clientID, String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_REMARK ");
		sqlStr.append("FROM CO_ENROLLMENT WHERE CO_EVENT_ID = ? ");
		sqlStr.append("	AND CO_USER_ID like '"+clientID+"'");
		sqlStr.append(" AND CO_ATTEND_DATE > TO_DATE('"+dateFrom+"','dd/mm/yyyy')");
		sqlStr.append(" AND CO_ATTEND_DATE < TO_DATE('"+dateTo+"','dd/mm/yyyy')");
		sqlStr.append(" AND CO_ENABLED = 1 ");

		 ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID });

			if (result.size() > 0) {
				ReportableListObject rlo = (ReportableListObject) result.get(0);
				return rlo.getFields0();
			} else {
				return null;
			}
	}
	public static String getenrollRemark(String eventID, String clientID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_REMARK ");
		sqlStr.append("FROM CO_ENROLLMENT WHERE CO_EVENT_ID = ? ");
		sqlStr.append("AND CO_USER_ID = ? ");
		 ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, clientID });

			if (result.size() > 0) {
				ReportableListObject rlo = (ReportableListObject) result.get(0);
				return rlo.getFields0();
			} else {
				return null;
			}
	}
	public static boolean updateFollowup(String followup,String modifyUser,String eventID, String userID, String scheduleID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET HAS_FOLLOWUP = ?, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE CO_EVENT_ID = ? AND CO_USER_ID = ? ");
		sqlStr.append("AND CO_MODULE_CODE = 'crm' ");
		sqlStr.append("AND CO_SCHEDULE_ID = ? ");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { followup, modifyUser, eventID, userID, scheduleID } );
	}

	public static boolean addRemark(String eventID, String scheduleID, String userID, String remark, String createUSER)	{
		StringBuffer sqlStr = new StringBuffer();
		String nextRemarkID = getRemarkIDmax();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_ENROLLMENT_FOLLOWUP (CO_SITE_CODE, CO_EVENT_ID, ");
		sqlStr.append("CO_SCHEDULE_ID, CO_USER_ID, REMARK, CO_CREATED_USER, CO_CREATED_DATE, REMARK_ID ) ");

		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, SYSDATE, "+nextRemarkID+" )");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { eventID, scheduleID, userID, remark, createUSER } );
	}
	public static boolean updateRemark(String remarkID, String remark) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_ENROLLMENT_FOLLOWUP SET REMARK= ? ");
		sqlStr.append("WHERE REMARK_ID = ?");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { remark, remarkID } );

	}

	public static String getFollowup(String eventID, String scheduleID, String userID)
	{
	 String followup = null;
	 StringBuffer sqlStr = new StringBuffer();
	 sqlStr.setLength(0);
	 sqlStr.append("SELECT HAS_FOLLOWUP FROM CO_ENROLLMENT ");
	 sqlStr.append("WHERE CO_EVENT_ID = ? AND CO_SCHEDULE_ID = ? AND ");
	 sqlStr.append("CO_USER_ID = ? ");
	 ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, scheduleID, userID });

		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}
	public static String getRemarkIDmax() {
		String nextRemarkID = null;

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT MAX(REMARK_ID)+ 1 FROM CO_ENROLLMENT_FOLLOWUP ");

		 ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());

		 if (result.size() > 0) {
				ReportableListObject rlo = (ReportableListObject) result.get(0);
				nextRemarkID = rlo.getFields0();

				if (nextRemarkID == null || nextRemarkID.length() == 0) return ConstantsVariable.ONE_VALUE;
		 }
		 return nextRemarkID;
	}
	public static ArrayList getremarkList(String eventID, String userID, String scheduleID)
	{
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT REMARK ,CO_CREATED_USER,TO_CHAR(CO_CREATED_DATE " +
				", 'dd/MM/YYYY HH24:MI'), REMARK_ID FROM CO_ENROLLMENT_FOLLOWUP ");
		sqlStr.append("WHERE CO_EVENT_ID = ? AND ");
		sqlStr.append("CO_USER_ID = ? AND CO_SCHEDULE_ID = ? ");
		sqlStr.append("ORDER BY CO_CREATED_DATE ");


		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {
			eventID, userID, scheduleID });
	}

	public static boolean checkCompletion(String staffID, String criteriaYear) {
		Vector<String> compulsoryList = new Vector<String>();
		String jobCode = null;
		String hireYear = null;
		String ruleYear = criteriaYear;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_JOB_CODE,TO_CHAR(CO_HIRE_DATE,'yyyy') FROM CO_STAFFS WHERE CO_STAFF_ID like '"+ staffID+"'" );
		ArrayList resultStaff = UtilDBWeb.getReportableList(sqlStr.toString());
		if (resultStaff.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) resultStaff.get(0);
			jobCode = rlo.getFields0();
			hireYear = rlo.getValue(1);
		}

		sqlStr.setLength(0);
		sqlStr.append(" SELECT EE_EVENT_ID_01, EE_EVENT_ID_02, EE_EVENT_ID_03, ");
		sqlStr.append(" EE_EVENT_ID_04, EE_EVENT_ID_05, EE_EVENT_ID_06, ");
		sqlStr.append(" EE_EVENT_ID_07, EE_EVENT_ID_08, EE_EVENT_ID_09,EE_EVENT_ID_10 ");
		sqlStr.append(" FROM EE_COMPULSORY_CRITERIA ");
		sqlStr.append(" WHERE EE_POSITION_CODE = '"+jobCode+"' ");
		sqlStr.append(" AND EE_YEAR = "+ criteriaYear);
		sqlStr.append(" AND EE_SITE_CODE like 'twah' AND EE_ENABLED  = 1 ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());

		while(result.size() == 0 && !"".equals(jobCode)&& jobCode !=null
				&& Integer.parseInt(ruleYear)>2009) {
			sqlStr.setLength(0);
			sqlStr.append(" SELECT EE_EVENT_ID_01, EE_EVENT_ID_02, EE_EVENT_ID_03, ");
			sqlStr.append(" EE_EVENT_ID_04, EE_EVENT_ID_05, EE_EVENT_ID_06, ");
			sqlStr.append(" EE_EVENT_ID_07, EE_EVENT_ID_08, EE_EVENT_ID_09,EE_EVENT_ID_10 ");
			sqlStr.append(" FROM EE_COMPULSORY_CRITERIA ");
			sqlStr.append(" WHERE EE_POSITION_CODE = '"+jobCode+"' ");
			sqlStr.append(" AND EE_YEAR = "+ Integer.toString((Integer.parseInt(ruleYear)-1)));
			sqlStr.append(" AND EE_SITE_CODE like 'twah' AND EE_ENABLED  = 1 ");
			result = UtilDBWeb.getReportableList(sqlStr.toString());
			ruleYear=Integer.toString((Integer.parseInt(ruleYear)-1));
		}
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			for(int i =0 ; i<10 ;i++) {
				if (rlo.getValue(i)!= null && !"".equals(rlo.getValue(i))) {
				  if (Integer.parseInt(hireYear) == DateTimeUtil.getCurrentYear()) { 
					  if ("1010".equals(rlo.getValue(i))) {
						  compulsoryList.add("1120");
						  compulsoryList.add("1110");
					  }else{
						  compulsoryList.add(rlo.getValue(i));
					  }
				  }else if ("LAB".equals(StaffDB.getDeptCode(staffID))){
					  if ("ASST".equals(jobCode)) {
						  if ("1025".equals(rlo.getValue(i))) {
							  //enable special dept head criteria
							  compulsoryList.add("1020");
						  }else{
							  compulsoryList.add(rlo.getValue(i));
						  }
					  }else{
					  	  compulsoryList.add(rlo.getValue(i));					  	  
					  }
				  }else if ("RHAB".equals(StaffDB.getDeptCode(staffID))
						  || "DI".equals(StaffDB.getDeptCode(staffID))) {
					  if ("HEAD".equals(jobCode)) {
						  if ("1025".equals(rlo.getValue(i))) {
							  //enable special dept head criteria
							  compulsoryList.add("1020");
						  }else{
							  compulsoryList.add(rlo.getValue(i));
						  }
							  compulsoryList.add("1080");
							  compulsoryList.add("1042");
							  compulsoryList.add("1045");
					  	}else{
					  	  compulsoryList.add(rlo.getValue(i));

					  	}
				  }else if ("NUAD".equals(StaffDB.getDeptCode(staffID))) {
					  if ("DIR".equals(jobCode)) {
						  if ("1025".equals(rlo.getValue(i))) {
							  //enable special dept head criteria
							  compulsoryList.add("1020");
						  }else if ("1070".equals(rlo.getValue(i))) {
							  compulsoryList.add("1030");
						  }else{
							  compulsoryList.add(rlo.getValue(i));
						  }
					  }else{
						  	compulsoryList.add(rlo.getValue(i));
					  }
				  }else{
					compulsoryList.add(rlo.getValue(i));
				  }

				}
			}
			
			if(compulsoryList.contains("6238")||compulsoryList.contains("6730")){
				boolean acls = true;
				boolean bls = true;
				compulsoryList.remove("6730");
				String startYear = Integer.toString((Integer.parseInt(criteriaYear)-2));
				ArrayList attendedACLSArray = getExpireDate("education", "6730", staffID, "01/01/"+startYear, "31/12/"+criteriaYear);
				if (attendedACLSArray.size()>0) {
					ReportableListObject rattend = (ReportableListObject) attendedACLSArray.get(0);
					if("EXPIRED".equals(rattend.getValue(12))){
						acls = false;
					}
				}else{
					acls = false;
				}
				compulsoryList.remove("6238");
				ArrayList attendedBLSArray = getExpireDate("education", "6238", staffID, "01/01/"+startYear, "31/12/"+criteriaYear);
				if (attendedBLSArray.size()>0) {
					ReportableListObject rattend = (ReportableListObject) attendedBLSArray.get(0);
					if("EXPIRED".equals(rattend.getValue(12))){
						bls = false;
					}
				}else{
					bls = false;
				}
				
				if(acls || bls){}else{
					return false;
				}
				
			}
			
			ArrayList attendedArray = getAttendedClass("education", null, null,
					"staff", staffID, "01/01/"+criteriaYear, "31/12/"+criteriaYear);
			Vector<String> attendedList = new Vector<String> ();
			if (attendedArray.size()>0) {
				for(int i=0;i<attendedArray.size();i++) {
					ReportableListObject rattend =
						(ReportableListObject) attendedArray.get(i);
					attendedList.add(rattend.getValue(1));
				}
			}
			if (attendedList.contains("1040")&&
					!attendedList.contains("1041")) {
				return false;
			}else if (attendedList.contains("1041")&&
					!attendedList.contains("1040")) {
				return false;
			}else if (attendedList.contains("1042")&&
					!attendedList.contains("1045")) {
				return false;
			}else if (attendedList.contains("1045")&&
					!attendedList.contains("1042")) {
				return false;
			}
		for (int i=0;i<compulsoryList.size();i++) {
			if (compulsoryList.get(i)!= null && !"".equals(compulsoryList.get(i))) {
					if ("1010".equals(compulsoryList.get(i))&&
						attendedList.contains("6015")) {
					} else if ("1080".equals(compulsoryList.get(i))&&
						attendedList.contains("6020")) {
					} else if ("1030".equals(compulsoryList.get(i))&&
						attendedList.contains("6018")) {
					} else if ("1070".equals(compulsoryList.get(i))&&
						attendedList.contains("6019")) {
					} else if ("1020".equals(compulsoryList.get(i))&&
						attendedList.contains("6016")) {
					} else if ("1025".equals(compulsoryList.get(i))&&
						attendedList.contains("6017")) {
					} else if ("1040".equals(compulsoryList.get(i))&&
						((attendedList.contains("1040")&&attendedList.contains("1041")) ||
						  (!attendedList.contains("1040")&&!attendedList.contains("1041")))) {
					} else if ("1041".equals(compulsoryList.get(i))&&
							((attendedList.contains("1040")&&attendedList.contains("1041")) ||
							  (!attendedList.contains("1040")&&!attendedList.contains("1041")))) {
					} else if ("1042".equals(compulsoryList.get(i))&&
							((attendedList.contains("1042")&&attendedList.contains("1045")) ||
							  (!attendedList.contains("1042")&&!attendedList.contains("1045")))) {
					} else if ("1045".equals(compulsoryList.get(i))&&
							((attendedList.contains("1042")&&attendedList.contains("1045")) ||
							  (!attendedList.contains("1042")&&!attendedList.contains("1045")))) {
					} else if ("1025".equals(compulsoryList.get(i))&&
							attendedList.contains("6017")) {
					} else if (attendedList.contains(compulsoryList.get(i))) {
					} else {
						return false;
					}
				}
			}

			if (compulsoryList.size() ==0) {
				return false;
			}else{
				return true;
			}
		}

		return false;
	}
	
	public static List<String> getCompulsoryList(String staffID, String criteriaYear) {
		System.out.println("[EnrollmentDB] getCompulsoryList staffID="+staffID+", criteriaYear="+criteriaYear);
		
		List<String> compulsoryList = new ArrayList<String>();
		String jobCode = null;
		String hireYear = null;
		String ruleYear = criteriaYear;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_JOB_CODE,TO_CHAR(CO_HIRE_DATE,'yyyy') FROM CO_STAFFS WHERE CO_STAFF_ID like '"+ staffID+"'" );
		ArrayList resultStaff = UtilDBWeb.getReportableList(sqlStr.toString());
		if (resultStaff.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) resultStaff.get(0);
			jobCode = rlo.getFields0();
			hireYear = rlo.getValue(1);
		}

		sqlStr.setLength(0);
		sqlStr.append(" SELECT EE_EVENT_ID_01, EE_EVENT_ID_02, EE_EVENT_ID_03, ");
		sqlStr.append(" EE_EVENT_ID_04, EE_EVENT_ID_05, EE_EVENT_ID_06, ");
		sqlStr.append(" EE_EVENT_ID_07, EE_EVENT_ID_08, EE_EVENT_ID_09,EE_EVENT_ID_10 ");
		sqlStr.append(" FROM EE_COMPULSORY_CRITERIA ");
		sqlStr.append(" WHERE EE_POSITION_CODE like '"+jobCode+"' ");
		sqlStr.append(" AND EE_YEAR = "+ criteriaYear);
		sqlStr.append(" AND EE_SITE_CODE like 'twah' AND EE_ENABLED  = 1 ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		
		//System.out.println("[EnrollmentDB] getCompulsoryList jobCode="+jobCode+", criteriaYear="+criteriaYear);
		//System.out.println("[EnrollmentDB] getCompulsoryList sqlStr="+sqlStr.toString());
		//System.out.println("[EnrollmentDB] getCompulsoryList result size="+result.size());

		while(result.size() == 0 && !"".equals(jobCode)&& jobCode !=null
				&& Integer.parseInt(ruleYear)>2009) {
			sqlStr.setLength(0);
			sqlStr.append(" SELECT EE_EVENT_ID_01, EE_EVENT_ID_02, EE_EVENT_ID_03, ");
			sqlStr.append(" EE_EVENT_ID_04, EE_EVENT_ID_05, EE_EVENT_ID_06, ");
			sqlStr.append(" EE_EVENT_ID_07, EE_EVENT_ID_08, EE_EVENT_ID_09,EE_EVENT_ID_10 ");
			sqlStr.append(" FROM EE_COMPULSORY_CRITERIA ");
			sqlStr.append(" WHERE EE_POSITION_CODE like '"+jobCode+"' ");
			sqlStr.append(" AND EE_YEAR = "+ Integer.toString((Integer.parseInt(ruleYear)-1)));
			sqlStr.append(" AND EE_SITE_CODE like 'twah' AND EE_ENABLED  = 1 ");
			result = UtilDBWeb.getReportableList(sqlStr.toString());
			ruleYear=Integer.toString((Integer.parseInt(ruleYear)-1));
		}
		
		//System.out.println("[EnrollmentDB] getCompulsoryList sqlStr="+sqlStr.toString());
		System.out.println("[EnrollmentDB] getCompulsoryList result size="+result.size());
		
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			for(int i =0 ; i<10 ;i++) {
				if (rlo.getValue(i)!= null && !"".equals(rlo.getValue(i))) {
				  if (Integer.parseInt(hireYear) == DateTimeUtil.getCurrentYear()) { 
					  if ("1010".equals(rlo.getValue(i))) {
						  compulsoryList.add("1120");
					  }else{
						  compulsoryList.add(rlo.getValue(i));
					  }
				  }else if ("LAB".equals(StaffDB.getDeptCode(staffID))){
					  if ("ASST".equals(jobCode)) {
						  if ("1025".equals(rlo.getValue(i))) {
							  //enable special dept head criteria
							  compulsoryList.add("1020");
						  }else{
							  compulsoryList.add(rlo.getValue(i));
						  }
					  }else{
					  	  compulsoryList.add(rlo.getValue(i));					  	  
					  }
				  }else if ("RHAB".equals(StaffDB.getDeptCode(staffID))
						  || "DI".equals(StaffDB.getDeptCode(staffID))) {
					  if ("HEAD".equals(jobCode)) {
						  if ("1025".equals(rlo.getValue(i))) {
							  //enable special dept head criteria
							  compulsoryList.add("1020");
						  }else if ("1070".equals(rlo.getValue(i))) {
							  compulsoryList.add("1030");
						  }else{
							  compulsoryList.add(rlo.getValue(i));
						  }
							  compulsoryList.add("1080");
							  compulsoryList.add("1042");
							  compulsoryList.add("1045");
					  	}else{
					  	  compulsoryList.add(rlo.getValue(i));

					  	}
				  }else if ("NUAD".equals(StaffDB.getDeptCode(staffID))) {
					  if ("DIR".equals(jobCode)) {
						  if ("1025".equals(rlo.getValue(i))) {
							  //enable special dept head criteria
							  compulsoryList.add("1020");
						  }else if ("1070".equals(rlo.getValue(i))) {
							  compulsoryList.add("1030");
						  }else{
							  compulsoryList.add(rlo.getValue(i));
						  }
					  }else{
						  	compulsoryList.add(rlo.getValue(i));
					  }
				  }else{
					compulsoryList.add(rlo.getValue(i));
				  }

				}
			}
			
		}

		return compulsoryList;
	}

	public static ArrayList isAttendWorkshop(String moduleCode, String clientID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_ENROLL_ID ");
		sqlStr.append("FROM   CO_ENROLLMENT ");
		sqlStr.append("WHERE  CO_MODULE_CODE = '"+moduleCode+"' ");
		sqlStr.append("AND    CO_USER_ID = '"+clientID+"' ");
		sqlStr.append("AND    CO_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT E.CO_ENROLL_ID, E.CO_SCHEDULE_ID ");
		sqlStr.append("FROM   CO_ENROLLMENT E, CO_SCHEDULE S ");
		sqlStr.append("WHERE  E.CO_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    E.CO_MODULE_CODE = S.CO_MODULE_CODE ");
		sqlStr.append("AND    E.CO_EVENT_ID = S.CO_EVENT_ID ");
		sqlStr.append("AND    E.CO_SCHEDULE_ID = S.CO_SCHEDULE_ID ");
		sqlStr.append("AND    E.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    E.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    E.CO_EVENT_ID = ? ");
		sqlStr.append("AND    E.CO_USER_TYPE = ? ");
		sqlStr.append("AND    E.CO_USER_ID = ? ");
		sqlStr.append("AND    E.CO_ENABLED = 1 ");
		sqlStr.append("AND    TO_CHAR(S.CO_SCHEDULE_START, 'dd/MM/YYYY') = ? ");
		sqlStr.append("ORDER BY S.CO_SCHEDULE_START ");
		sqlStr_SelectEnrollNo = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_ATTEND_DATE = TO_DATE(?, 'dd/MM/yyyy'), ");
		sqlStr.append("       CO_ATTEND_STATUS = 1, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CO_ENROLL_ID = ? ");
		sqlStr.append("AND    CO_USER_TYPE = ? ");
		sqlStr.append("AND    CO_USER_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_updateAttendStatus = sqlStr.toString();
	}
}