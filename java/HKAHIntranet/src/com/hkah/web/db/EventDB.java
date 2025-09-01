/*
 * Created on April 8, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class EventDB {
	private static String sqlStr_insertEvent = null;
	private static String sqlStr_updateEvent = null;
	private static String sqlStr_deleteEvent = null;

	private static String getNextEventID(String moduleCode) {
		String eventID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CO_EVENT_ID) + 1 FROM CO_EVENT WHERE CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CO_MODULE_CODE = ?",
				new String[] { moduleCode });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			eventID = reportableListObject.getValue(0);

			// set 1 for initial
			if (eventID == null || eventID.length() == 0) return "1001";
		}
		return eventID;
	}

	/**
	 * Add a event
	 * @return eventID
	 */
	public static String add(UserBean userBean,
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType,
			String eventDesc, String evenDetail) {
		return add(moduleCode,
				deptCode, eventCategory, eventType, null,
				eventDesc, evenDetail, userBean.getLoginID());
	}

	public static String add(UserBean userBean,
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String evenDetail) {
		return add(moduleCode,
				deptCode, eventCategory, eventType, eventType2,
				eventDesc, evenDetail, userBean.getLoginID());
	}

	public static String add(UserBean userBean,
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String evenDetail, boolean isRequireAssessmentPass) {
		return add(moduleCode,
				deptCode, eventCategory, eventType, eventType2,
				eventDesc, evenDetail, userBean.getLoginID(), isRequireAssessmentPass, false);
	}
	
	public static String add(UserBean userBean,
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String evenDetail, boolean isRequireAssessmentPass, boolean nonHospCourse) {
		return add(moduleCode,
				deptCode, eventCategory, eventType, eventType2,
				eventDesc, evenDetail, userBean.getLoginID(), isRequireAssessmentPass, nonHospCourse);
	}

	public static String add(
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType,
			String eventDesc, String evenDetail,
			String createUser) {
		return add(moduleCode,
				deptCode, eventCategory, eventType, null,
				eventDesc, evenDetail, createUser);
	}

	public static String add(
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String evenDetail,
			String createUser) {
		return add(moduleCode, deptCode, eventCategory, eventType, eventType2,
				eventDesc, evenDetail, createUser, false, false);
	}

	public static String add(
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String evenDetail,
			String createUser, boolean isRequireAssessmentPass, boolean nonHospCourse) {
		// get next event ID
		String eventID = getNextEventID(moduleCode);

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertEvent,
				new String[] { moduleCode, eventID, eventDesc, evenDetail, deptCode,
					eventCategory, eventType, eventType2,
					isRequireAssessmentPass ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE,
					createUser, createUser, nonHospCourse ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE})) {
			return eventID;
		} else {
			return null;
		}
	}

	/**
	 * Modify a event
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String moduleCode, String eventID,
			String deptCode,
			String eventCategory, String eventType,
			String eventDesc, String evenDetail) {

		return update(
				moduleCode, eventID, deptCode,
				eventCategory, eventType, null, eventDesc, evenDetail, false, userBean.getLoginID(), false);
	}

	public static boolean update(UserBean userBean,
			String moduleCode, String eventID,
			String deptCode,
			String eventCategory, String eventType,
			String eventDesc, String evenDetail, boolean isRequireAssessmentPass) {

		return update(
				moduleCode, eventID, deptCode,
				eventCategory, eventType, null, eventDesc, evenDetail, isRequireAssessmentPass, userBean.getLoginID(), false);
	}
	
	public static boolean update(UserBean userBean,
			String moduleCode, String eventID,
			String deptCode,
			String eventCategory, String eventType,
			String eventDesc, String evenDetail, boolean isRequireAssessmentPass, boolean nonHospCourse) {

		return update(
				moduleCode, eventID, deptCode,
				eventCategory, eventType, null, eventDesc, evenDetail, isRequireAssessmentPass, userBean.getLoginID(), nonHospCourse);
	}

	public static boolean update(UserBean userBean,
			String moduleCode, String eventID,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String evenDetail) {

		return update(
				moduleCode, eventID, deptCode,
				eventCategory, eventType, eventType2, eventDesc, evenDetail, false, userBean.getLoginID(), false);
	}

	public static boolean update(UserBean userBean,
			String moduleCode, String eventID,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String evenDetail, boolean isRequireAssessmentPass) {

		return update(
				moduleCode, eventID, deptCode,
				eventCategory, eventType, eventType2, eventDesc, evenDetail, isRequireAssessmentPass, userBean.getLoginID(), false);
	}

	public static boolean update(
			String moduleCode, String eventID,
			String deptCode,
			String eventCategory, String eventType,
			String eventDesc, String evenDetail,
			String modifiedUser) {

		return update(
				moduleCode, eventID, deptCode,
				eventCategory, eventType, null, eventDesc, evenDetail, false, modifiedUser, false);
	}

	public static boolean update(
			String moduleCode, String eventID,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String evenDetail, boolean isRequireAssessmentPass,
			String modifiedUser, boolean nonHospCourse) {

		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_updateEvent,
				new String[] { eventDesc, evenDetail, deptCode,
					eventCategory, eventType, eventType2,
					isRequireAssessmentPass ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE,
					modifiedUser, nonHospCourse ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE,
					moduleCode, eventID} );
	}

	public static boolean delete(UserBean userBean,
			String moduleCode, String eventID,
			String deptCode) {

		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteEvent,
				new String[] { userBean.getLoginID(), moduleCode, eventID } );
	}

	public static ArrayList get(
			String moduleCode, String eventID) {
		return get(moduleCode, eventID, null, null, null);
	}

	public static ArrayList get(
			String moduleCode, String eventID, String eventCategory, String eventType) {
		return get(moduleCode, eventID, eventCategory, eventType, null);
	}

	public static ArrayList get(
			String moduleCode, String eventID, String eventCategory, String eventType, String eventType2) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CO_EVENT_ID, C.CO_EVENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE, C.CO_EVENT_TYPE2, ");
		sqlStr.append("       C.CO_EVENT_REMARK, C.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.CO_REQUIRE_ASSESSMENT_PASS, C.CO_EVENT_REMARK2, C.CO_NON_HOSP_COURSE ");
		sqlStr.append("FROM   CO_EVENT C, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  C.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    C.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    C.CO_ENABLED = 1 ");
		sqlStr.append("AND    C.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.CO_EVENT_ID = ? ");
		if (eventCategory != null && eventCategory.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_CATEGORY = '");
			sqlStr.append(eventCategory);
			sqlStr.append("'");
		}
		if (eventType != null && eventType.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_TYPE = '");
			sqlStr.append(eventType);
			sqlStr.append("'");
		}
		if (eventType2 != null && eventType2.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_TYPE2 = '");
			sqlStr.append(eventType2);
			sqlStr.append("'");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode, eventID });
	}

	public static ArrayList getList(
			String moduleCode,
			String deptCode, String eventDesc, String eventCategory, String eventType) {
		// fetch event
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CO_EVENT_ID, C.CO_EVENT_DESC, ");
		sqlStr.append("       C.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE ");
		sqlStr.append("FROM   CO_EVENT C, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  UPPER(C.CO_SITE_CODE) = UPPER('" + ConstantsServerSide.SITE_CODE + "') ");
		sqlStr.append("AND    C.CO_MODULE_CODE = '");
		sqlStr.append(moduleCode);
		sqlStr.append("' ");
		sqlStr.append("AND    C.CO_ENABLED = 1 ");
		sqlStr.append("AND    C.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    (C.CO_DEPARTMENT_CODE IS NULL OR C.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("') ");
		}
		if (eventDesc != null && eventDesc.length() > 0) {
			sqlStr.append("AND    UPPER(C.CO_EVENT_DESC) LIKE '%");
			sqlStr.append(eventDesc.toUpperCase());
			sqlStr.append("%' ");
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
		sqlStr.append("ORDER BY C.CO_EVENT_DESC, C.CO_EVENT_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getListById(
			String moduleCode,
			String eventId) {
		// fetch event
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CO_EVENT_ID, C.CO_EVENT_DESC, ");
		sqlStr.append("       C.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE ");
		sqlStr.append("FROM   CO_EVENT C, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  UPPER(C.CO_SITE_CODE) = UPPER('" + ConstantsServerSide.SITE_CODE + "') ");
		sqlStr.append("AND    C.CO_MODULE_CODE = '");
		sqlStr.append(moduleCode);
		sqlStr.append("' ");
		sqlStr.append("AND    C.CO_ENABLED = 1 ");
		sqlStr.append("AND    C.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		if (eventId != null && eventId.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_ID = '");
			sqlStr.append(eventId);
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY C.CO_EVENT_DESC, C.CO_EVENT_ID");
System.err.println("sqlStr.toString()"+sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}	
/*
	public static ArrayList getNotYetEnroll(
			String moduleID, String eventCategory, String userType, String userID, String date_from, String date_to) {
		// only handle which department need to take class
		// TODO: how to handle once 2 year
		// TODO: new staff orientation
		// TODO: day range for every year
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT E.CO_EVENT_ID, E.CO_EVENT_DESC, E.CO_EVENT_TYPE ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENT_EVENT D, CO_EVENT E ");
		sqlStr.append("WHERE  S.CO_SITE_CODE = D.CO_SITE_CODE ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    D.CO_MODULE_CODE = E.CO_MODULE_CODE ");
		sqlStr.append("AND    D.CO_EVENT_ID = E.CO_EVENT_ID ");
		sqlStr.append("AND    S.CO_STAFF_ID = ? ");
		sqlStr.append("AND    E.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    E.CO_MODULE_CODE = ? ");
		if (eventCategory != null && eventCategory.length() > 0) {
			sqlStr.append("AND    E.CO_EVENT_CATEGORY = '");
			sqlStr.append(eventCategory);
			sqlStr.append("' ");
		}
		sqlStr.append("AND    E.CO_ENABLED = 1 ");
		sqlStr.append("AND    E.CO_EVENT_ID NOT IN ( ");
		sqlStr.append("       SELECT CO_EVENT_ID ");
		sqlStr.append("       FROM   CO_ENROLLMENT ");
		sqlStr.append("       WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("       AND    CO_MODULE_CODE = ? ");
		sqlStr.append("       AND    CO_USER_TYPE = ? ");
		sqlStr.append("       AND    CO_USER_ID = ? ");
		if (date_from != null && date_from.length() == 10) {
			sqlStr.append("       AND    CO_ATTEND_DATE >= TO_DATE('");
			sqlStr.append(date_from);
			sqlStr.append("', 'dd/mm/yyyy') ");
		}
		if (date_to != null && date_to.length() == 10) {
			sqlStr.append("       AND    CO_ATTEND_DATE <= TO_DATE('");
			sqlStr.append(date_to);
			sqlStr.append("', 'dd/mm/yyyy') ");
		}
		sqlStr.append("       AND    CO_ATTEND_STATUS = 1 ");
		sqlStr.append("       AND    CO_ENABLED = 1 ");
		sqlStr.append(") ");
		sqlStr.append("ORDER BY E.CO_EVENT_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userID, moduleID, moduleID, userType, userID });
	}
*/

	public static ArrayList getNotYetEnroll(
			String moduleID, String eventCategory, String userType, String userID, String date_from, String date_to) {
		// only handle which department need to take class
		// TODO: how to handle once 2 year
		// TODO: new staff orientation
		// TODO: day range for every year
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT E.CO_EVENT_ID, E.CO_EVENT_DESC, E.CO_EVENT_TYPE ");
		sqlStr.append("FROM   CO_STAFFS S, CO_STAFF_EVENT_INTERVAL D, CO_EVENT E ");
		sqlStr.append("WHERE  S.CO_SITE_CODE = D.CO_SITE_CODE(+) ");
		sqlStr.append("AND    S.CO_CATEGORY = D.CO_CATEGORY(+) ");
		sqlStr.append("AND    D.CO_EVENT_ID = E.CO_EVENT_ID ");
		sqlStr.append("AND    S.CO_STAFF_ID = ? ");
		sqlStr.append("AND    E.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    E.CO_MODULE_CODE = ? ");
		if (eventCategory != null && eventCategory.length() > 0) {
			sqlStr.append("AND    E.CO_EVENT_CATEGORY = '");
			sqlStr.append(eventCategory);
			sqlStr.append("' ");
		}
		sqlStr.append("AND    E.CO_ENABLED = 1 ");
		sqlStr.append("AND NOT EXISTS ( ");
		sqlStr.append("SELECT 1  ");
		sqlStr.append("FROM CO_ENROLLMENT F  ");
		sqlStr.append("WHERE S.CO_SITE_CODE = F.CO_SITE_CODE ");
		sqlStr.append("AND    S.CO_STAFF_ID = F.CO_USER_ID ");
		sqlStr.append("AND    E.CO_MODULE_CODE = F.CO_MODULE_CODE ");
		sqlStr.append("AND    D.CO_EVENT_ID = F.CO_EVENT_ID  ");
		sqlStr.append("AND    ADD_MONTHS(TO_DATE(TO_CHAR(CO_ATTEND_DATE,'YYYY')||TO_CHAR(S.CO_ANNUAL_INCR,'MM')||'01','YYYYMMDD'),d.co_time_interval) >= SYSDATE   ");
		sqlStr.append("AND    F.CO_ATTEND_STATUS = 1 ");
		sqlStr.append("AND    F.CO_ENABLED = 1 ");
		sqlStr.append(") ");
		sqlStr.append("ORDER BY E.CO_EVENT_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userID, moduleID });
	}

	public static ArrayList getEducationRecord(
			String eventCategory, String dateFrom, String dateTo) {
		// fetch course
		StringBuffer sqlStr = new StringBuffer();
		if ("compulsory".equals(eventCategory)) {
			sqlStr.append("SELECT E.CO_EVENT_ID, E.CO_EVENT_DESC, E.CO_EVENT_SHORT_DESC, E.CO_REQUIRE_ASSESSMENT_PASS, E.CO_EVENT_TYPE ");
			sqlStr.append("FROM   CO_EVENT E, EE_EVENT_ORDER O ");
			sqlStr.append("WHERE  E.CO_SITE_CODE = O.EE_SITE_CODE ");
			sqlStr.append("AND    E.CO_MODULE_CODE = O.EE_MODULE_CODE ");
			sqlStr.append("AND    E.CO_EVENT_ID = O.EE_EVENT_ID ");
			sqlStr.append("AND    E.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
			sqlStr.append("AND    E.CO_MODULE_CODE = 'education' ");
			sqlStr.append("AND    E.CO_ENABLED = 1 ");
			sqlStr.append("AND    E.CO_EVENT_CATEGORY = 'compulsory' ");
			sqlStr.append("ORDER BY O.EE_EVENT_ORDER, E.CO_EVENT_ID");
		} else if ("other".equals(eventCategory)) {
			sqlStr.append("SELECT E.CO_EVENT_ID, E.CO_EVENT_DESC, E.CO_EVENT_SHORT_DESC, E.CO_REQUIRE_ASSESSMENT_PASS, E.CO_EVENT_TYPE ");
			sqlStr.append("FROM   CO_EVENT E, EE_EVENT_ORDER O ");
			sqlStr.append("WHERE  E.CO_SITE_CODE = O.EE_SITE_CODE ");
			sqlStr.append("AND    E.CO_MODULE_CODE = O.EE_MODULE_CODE ");
			sqlStr.append("AND    E.CO_EVENT_ID = O.EE_EVENT_ID ");
			sqlStr.append("AND    E.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
			sqlStr.append("AND    E.CO_MODULE_CODE = 'education' ");
			sqlStr.append("AND    E.CO_ENABLED = 1 ");
			sqlStr.append("AND    E.CO_EVENT_CATEGORY = 'other' ");
			sqlStr.append("ORDER BY O.EE_EVENT_ORDER, E.CO_EVENT_ID");
		} else if ("inservice".equals(eventCategory) && ConstantsServerSide.isTWAH()) {
			sqlStr.append("SELECT CS.CO_EVENT_ID, CE.CO_EVENT_DESC, CE.CO_EVENT_SHORT_DESC , CE.CO_REQUIRE_ASSESSMENT_PASS, CE.CO_EVENT_TYPE "); 
			sqlStr.append("FROM   CO_SCHEDULE CS, CO_EVENT CE, CO_LOCATION L WHERE  CS.CO_SITE_CODE = CE.CO_SITE_CODE "); 
			sqlStr.append("AND    CS.CO_MODULE_CODE = CE.CO_MODULE_CODE AND    CS.CO_EVENT_ID = CE.CO_EVENT_ID "); 
			sqlStr.append("AND    CS.CO_ENABLED = CE.CO_ENABLED AND    CS.CO_SITE_CODE = L.CO_SITE_CODE (+) "); 
			sqlStr.append("AND    CS.CO_LOCATION_ID = L.CO_LOCATION_ID (+) AND    CE.CO_MODULE_CODE = 'education' "); 
			sqlStr.append("AND    CE.CO_NON_HOSP_COURSE = 'N' AND    CE.CO_ENABLED = 1 "); 
			sqlStr.append("AND    (CE.CO_DEPARTMENT_CODE IS NULL OR CE.CO_DEPARTMENT_CODE = 'EDUCATION') ");
			sqlStr.append("AND    CS.CO_SCHEDULE_START >= TO_DATE('" + dateFrom + "','dd/mm/yyyy') ");
			sqlStr.append("AND    CS.CO_SCHEDULE_START <= TO_DATE('" + dateTo + "','dd/mm/yyyy') "); 
			sqlStr.append("ORDER BY CS.CO_SCHEDULE_START "); 
		} else {	
			sqlStr.append("SELECT E.CO_EVENT_ID, E.CO_EVENT_DESC, E.CO_EVENT_SHORT_DESC, E.CO_REQUIRE_ASSESSMENT_PASS, E.CO_EVENT_TYPE ");
			sqlStr.append("FROM   CO_EVENT E, CO_SCHEDULE S ");
			sqlStr.append("WHERE  E.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
			sqlStr.append("AND    E.CO_MODULE_CODE = 'education' ");
			sqlStr.append("AND    E.CO_ENABLED = 1 ");
			if (eventCategory != null && eventCategory.length() > 0) {
				sqlStr.append("AND    E.CO_EVENT_CATEGORY = '");
				sqlStr.append(eventCategory);
				sqlStr.append("' ");
			}
			sqlStr.append("AND    E.CO_EVENT_ID = S.CO_EVENT_ID (+) ");
			if(dateFrom != null && dateFrom.length() > 0 && dateTo != null && dateTo.length() > 0){
				sqlStr.append("AND (( ");
				sqlStr.append("   S.CO_SCHEDULE_START >= TO_DATE('" + dateFrom + "','dd/mm/yyyy') ");
				sqlStr.append("AND    S.CO_SCHEDULE_END <= TO_DATE('" + dateTo + "','dd/mm/yyyy') ");

				sqlStr.append(") ");
				sqlStr.append("OR (S.CO_SCHEDULE_START IS NULL AND S.CO_SCHEDULE_END IS NULL) ");
				sqlStr.append(") ");
			}
			 
			sqlStr.append("GROUP BY E.Co_Event_Id, E.Co_Event_Desc, E.Co_Event_Short_Desc, E.Co_Require_Assessment_Pass, E.Co_Event_Type "); 
			sqlStr.append("ORDER BY E.CO_EVENT_ID");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getEducationRecord(
			String eventCategory, String dateFrom, String dateTo, String enable) {
		// fetch course
		StringBuffer sqlStr = new StringBuffer();
		if ("compulsory".equals(eventCategory)) {
			sqlStr.append("SELECT E.CO_EVENT_ID, E.CO_EVENT_DESC, E.CO_EVENT_SHORT_DESC, E.CO_REQUIRE_ASSESSMENT_PASS ");
			sqlStr.append("FROM   CO_EVENT E, EE_EVENT_ORDER O ");
			sqlStr.append("WHERE  E.CO_SITE_CODE = O.EE_SITE_CODE ");
			sqlStr.append("AND    E.CO_MODULE_CODE = O.EE_MODULE_CODE ");
			sqlStr.append("AND    E.CO_EVENT_ID = O.EE_EVENT_ID ");
			sqlStr.append("AND    E.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
			sqlStr.append("AND    E.CO_MODULE_CODE = 'education' ");
			sqlStr.append("AND    E.CO_ENABLED = 1 ");
			sqlStr.append("AND    E.CO_EVENT_CATEGORY = 'compulsory' ");
			sqlStr.append("ORDER BY O.EE_EVENT_ORDER, E.CO_EVENT_ID");
		} else {
			sqlStr.append("SELECT CO_EVENT_ID, CO_EVENT_DESC, CO_EVENT_SHORT_DESC, CO_REQUIRE_ASSESSMENT_PASS ");
			sqlStr.append("FROM   CO_EVENT ");
			sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
			sqlStr.append("AND    CO_MODULE_CODE = 'education' ");
			if("1".equals(enable)){
				sqlStr.append("AND    CO_ENABLED = 1 ");
			}
			else if("0".equals(enable)){
				sqlStr.append("AND    CO_ENABLED = 0 ");
			}
			if (eventCategory != null && eventCategory.length() > 0) {
				sqlStr.append("AND    CO_EVENT_CATEGORY = '");
				sqlStr.append(eventCategory);
				sqlStr.append("' ");
			}
			sqlStr.append("ORDER BY CO_EVENT_ID");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String getEventID(
			String moduleCode,
			String eventDesc) {
		return getEventID(moduleCode, eventDesc, false, null, null);
	}

	public static String getEventID(
			String moduleCode,
			String eventDesc,
			String eventCategory,
			String eventType) {
		return getEventID(moduleCode, eventDesc, false, eventCategory, eventType);
	}

	public static String getEventID(
			String moduleCode,
			String eventDesc,
			boolean eventDescIgnoreCase) {
		return getEventID(moduleCode, eventDesc, eventDescIgnoreCase, null, null);
	}

	public static String getEventID(
			String moduleCode,
			String eventDesc,
			boolean eventDescIgnoreCase,
			String eventCategory,
			String eventType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_EVENT_ID ");
		sqlStr.append("FROM   CO_EVENT ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		if (eventDescIgnoreCase) {
			sqlStr.append("AND    UPPER(CO_EVENT_DESC) = ? ");
		} else {
			sqlStr.append("AND    CO_EVENT_DESC = ? ");
		}
		if (eventCategory != null && eventCategory.length() > 0) {
			sqlStr.append("AND    CO_EVENT_CATEGORY = '");
			sqlStr.append(eventCategory);
			sqlStr.append("'");
		}
		if (eventType != null && eventType.length() > 0) {
			sqlStr.append("AND    CO_EVENT_TYPE = '");
			sqlStr.append(eventType);
			sqlStr.append("'");
		}
		sqlStr.append("AND    CO_ENABLED = 1 ");
		if (eventDescIgnoreCase) {
			eventDesc = eventDesc == null ? eventDesc : eventDesc.toUpperCase();
		}
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode, eventDesc });

		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	public static String addCRMEvent(UserBean userBean,
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String evenDetail, String workShopType) {
		String eventID = getNextEventID(moduleCode);

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_EVENT (");
		sqlStr.append("CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID, CO_EVENT_DESC, CO_EVENT_REMARK, CO_DEPARTMENT_CODE, ");
		sqlStr.append("CO_EVENT_CATEGORY, CO_EVENT_TYPE, CO_EVENT_TYPE2, CO_REQUIRE_ASSESSMENT_PASS,CO_EVENT_REMARK2, CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?)");

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { moduleCode, eventID, eventDesc, evenDetail, deptCode,
					eventCategory, eventType, eventType2,
					false ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE,workShopType,
							userBean.getLoginID(), userBean.getLoginID() })) {
			return eventID;
		} else {
			return null;
		}
	}

	public static boolean updateCRMEvent(UserBean userBean,
			String moduleCode, String eventID,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String evenDetail, String workShopType) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_EVENT ");
		sqlStr.append("SET    CO_EVENT_DESC = ?, CO_EVENT_REMARK = ?, CO_DEPARTMENT_CODE = ?, ");
		sqlStr.append("       CO_EVENT_CATEGORY = ?, CO_EVENT_TYPE = ?, CO_EVENT_TYPE2 = ?, ");
		sqlStr.append("       CO_REQUIRE_ASSESSMENT_PASS = ?,CO_EVENT_REMARK2 = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { eventDesc, evenDetail, deptCode,
					eventCategory, eventType, eventType2,
					false ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE,workShopType,
							userBean.getLoginID(), moduleCode, eventID } );
	}
	
	public static boolean isOutsideCourse(String eventID){
		boolean outsideCourse = false;
		if("hkah".equals(ConstantsServerSide.SITE_CODE)){
			String[] courseList = {"7443", "7442", "7441",
							   "7440", "7439", "7438", "7437",
							   "7436", "7435", "7434", "1050", "7992" };	
			for(String s : courseList){
				if(s.equals(eventID)){
					outsideCourse = true;
					break;
				}
			}
		}else if("twah".equals(ConstantsServerSide.SITE_CODE)){
			String[] courseList = {"6238", "6730"};
			for(String s : courseList){
				if(s.equals(eventID)){
					outsideCourse = true;
					break;
				}
			}
		}
		
		return outsideCourse;
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_EVENT (");
		sqlStr.append("CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID, CO_EVENT_DESC, CO_EVENT_REMARK, CO_DEPARTMENT_CODE, ");
		sqlStr.append("CO_EVENT_CATEGORY, CO_EVENT_TYPE, CO_EVENT_TYPE2, CO_REQUIRE_ASSESSMENT_PASS, CO_CREATED_USER, CO_MODIFIED_USER, CO_NON_HOSP_COURSE) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
		sqlStr_insertEvent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_EVENT ");
		sqlStr.append("SET    CO_EVENT_DESC = ?, CO_EVENT_REMARK = ?, CO_DEPARTMENT_CODE = ?, ");
		sqlStr.append("       CO_EVENT_CATEGORY = ?, CO_EVENT_TYPE = ?, CO_EVENT_TYPE2 = ?, ");
		sqlStr.append("       CO_REQUIRE_ASSESSMENT_PASS = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ?, ");
		sqlStr.append("       CO_NON_HOSP_COURSE = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr_updateEvent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_EVENT ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ?");
		sqlStr_deleteEvent = sqlStr.toString();
	}
}