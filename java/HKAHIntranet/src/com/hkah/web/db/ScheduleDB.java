/*
 * Created on April 8, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ScheduleDB {

	private static String getNextScheduleID(String moduleCode, String eventID) {
		String scheduleID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CO_SCHEDULE_ID) + 1 FROM CO_SCHEDULE WHERE CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CO_MODULE_CODE = ? AND CO_EVENT_ID = ?",
				new String[] { moduleCode, eventID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			scheduleID = reportableListObject.getValue(0);

			// set 1 for initial
			if (scheduleID == null || scheduleID.length() == 0) return "1";
		}
		return scheduleID;
	}

	/**
	 * Add a event
	 * @return eventID
	 */
	public static String add(UserBean userBean,
			String moduleCode,
			String eventID,
			String scheduleDesc,
			String classStart, String classEnd,
			String classDuration, String locationID, String locationDesc, String lecturer,
			String classSize, String classStatus, String showRegOnline, String lunchAva) {
		return add(moduleCode, eventID, scheduleDesc, classStart, classEnd, classDuration,
				locationID, locationDesc, lecturer,
				classSize, classStatus, userBean.getLoginID(), showRegOnline, lunchAva);
	}

	public static String add(UserBean userBean,
			String moduleCode,
			String eventID,
			String scheduleDesc,
			String classStart, String classEnd,
			String classDuration, String locationID, String locationDesc, String lecturer,
			String classSize, String classStatus) {
		return add(moduleCode, eventID, scheduleDesc, classStart, classEnd, classDuration,
				locationID, locationDesc, lecturer,
				classSize, classStatus, userBean.getLoginID(), "Y", "N");
	}

	public static String add(
			String moduleCode,
			String eventID,
			String scheduleDesc,
			String classStart, String classEnd,
			String classDuration, String locationID, String locationDesc, String lecturer,
			String classSize, String classStatus,
			String createUser) {
		return add(moduleCode, eventID, scheduleDesc, classStart, classEnd, classDuration,
				locationID, locationDesc, lecturer,
				classSize, classStatus, createUser, "Y", "N");
	}

	public static String add(
			String moduleCode,
			String eventID,
			String scheduleDesc,
			String classStart, String classEnd,
			String classDuration, String locationID, String locationDesc, String lecturer,
			String classSize, String classStatus,
			String createUser,String showRegOnline, String lunchAva) {

		// get next schedule ID
		String scheduleID = getNextScheduleID(moduleCode, eventID);

		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_SCHEDULE (CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID, CO_SCHEDULE_ID, CO_SCHEDULE_DESC, ");
		sqlStr.append("            CO_SCHEDULE_START, CO_SCHEDULE_END, CO_SCHEDULE_DURATION, CO_LOCATION_ID, CO_LOCATION_DESC, CO_LECTURE_DESC, ");
		sqlStr.append("            CO_SCHEDULE_SIZE, CO_SCHEDULE_STATUS,CO_SHOWREGONLINE,CO_LUNCH_AVA, CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ");
		sqlStr.append("TO_DATE(?, 'dd/mm/yyyy HH24:MI:SS'), TO_DATE(?, 'dd/mm/yyyy HH24:MI:SS'), TO_NUMBER(?), ?, ?, ?, ");
		sqlStr.append("TO_NUMBER(?), ?, ?, ?, ?, ?)");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { moduleCode, eventID, scheduleID, scheduleDesc,
					classStart, classEnd, classDuration, locationID, locationDesc, lecturer,
					classSize, classStatus,showRegOnline, lunchAva, createUser, createUser })) {
			return scheduleID;
		} else {
			return null;
		}
	}

	/**
	 * Modify a event
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String moduleCode,
			String eventID, String scheduleID, String scheduleDesc,
			String classStart, String classEnd,
			String classDuration, String locationID, String locationDesc, String lecturer,
			String classSize, String classStatus,String relatedNewsID) {
		return update(moduleCode, eventID, scheduleID, scheduleDesc, classStart, classEnd,
				classDuration, locationID, locationDesc, lecturer,
				classSize, classStatus, userBean.getLoginID(),relatedNewsID,"Y", null);
	}

	public static boolean update(UserBean userBean,
			String moduleCode,
			String eventID, String scheduleID, String scheduleDesc,
			String classStart, String classEnd,
			String classDuration, String locationID, String locationDesc, String lecturer,
			String classSize, String classStatus,String relatedNewsID,String showRegOnline, String lunchAva) {
		return update(moduleCode, eventID, scheduleID, scheduleDesc, classStart, classEnd,
				classDuration, locationID, locationDesc, lecturer,
				classSize, classStatus, userBean.getLoginID(),relatedNewsID,showRegOnline, lunchAva);
	}

	public static boolean update(
			String moduleCode,
			String eventID, String scheduleID, String scheduleDesc,
			String classStart, String classEnd,
			String classDuration, String locationID, String locationDesc, String lecturer,
			String classSize, String classStatus,
			String updateUser,String relatedNewsID) {
		return update(moduleCode, eventID, scheduleID, scheduleDesc, classStart,
						classEnd, classDuration, locationID, locationDesc, lecturer,
						classSize, classStatus, updateUser, relatedNewsID, "Y", null);
	}

	public static boolean update(
			String moduleCode,
			String eventID, String scheduleID, String scheduleDesc,
			String classStart, String classEnd,
			String classDuration, String locationID, String locationDesc, String lecturer,
			String classSize, String classStatus,
			String updateUser,String relatedNewsID,String showRegOnline, String lunchAva) {
		// try to update selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_SCHEDULE ");
		sqlStr.append("SET    CO_SCHEDULE_DESC = ?, ");
		sqlStr.append("       CO_SCHEDULE_START = TO_DATE(?, 'dd/mm/yyyy HH24:MI:SS'), ");
		sqlStr.append("       CO_SCHEDULE_END = TO_DATE(?, 'dd/mm/yyyy HH24:MI:SS'), ");
		sqlStr.append("       CO_SCHEDULE_DURATION = TO_NUMBER(?), ");
		sqlStr.append("       CO_LOCATION_ID = ?, ");
		sqlStr.append("       CO_LOCATION_DESC = ?, ");
		sqlStr.append("       CO_LECTURE_DESC = ?, ");
		sqlStr.append("       CO_SCHEDULE_SIZE = TO_NUMBER(?), ");
		sqlStr.append("       CO_SCHEDULE_STATUS = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("       CO_MODIFIED_USER = ?, ");
		sqlStr.append("       CO_NEWS_ID = ?, ");
		sqlStr.append("       CO_SHOWREGONLINE = ? ");
		if(lunchAva != null && lunchAva.length() > 0){
			sqlStr.append(",      CO_LUNCH_AVA = '" + lunchAva + "' ");
		}
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_SCHEDULE_ID = ?");
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { scheduleDesc, classStart, classEnd,
					classDuration, locationID, locationDesc, lecturer,
					classSize, classStatus, updateUser,relatedNewsID,showRegOnline,
					moduleCode, eventID, scheduleID } );
	}

	public static boolean delete(UserBean userBean,
			String moduleCode,
			String eventID, String scheduleID) {
		// try to delete selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_SCHEDULE SET CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CO_MODULE_CODE = ? AND CO_EVENT_ID = ? AND CO_SCHEDULE_ID = ?" );

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), moduleCode, eventID, scheduleID } );
	}

	public static ArrayList get(
			String moduleCode,
			String eventID, String scheduleID) {
		// get single schedule
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, C.CO_EVENT_DESC, S.CO_SCHEDULE_DESC, ");
		sqlStr.append("       TO_CHAR(S.CO_SCHEDULE_START, 'dd/MM/YYYY'), TO_CHAR(S.CO_SCHEDULE_START, 'HH24:MI:SS'), ");
		sqlStr.append("       TO_CHAR(S.CO_SCHEDULE_END, 'HH24:MI:SS'), S.CO_SCHEDULE_DURATION, ");
		sqlStr.append("       S.CO_LOCATION_ID, L.CO_LOCATION_DESC, S.CO_LOCATION_DESC, S.CO_LECTURE_DESC, S.CO_SCHEDULE_SIZE, ");
		sqlStr.append("       S.CO_SCHEDULE_ENROLLED, S.CO_SCHEDULE_STATUS, C.CO_REQUIRE_ASSESSMENT_PASS,S.CO_NEWS_ID, S.CO_SHOWREGONLINE, ");
		sqlStr.append("       C.CO_EVENT_REMARK, CO_LUNCH_AVA ");
		sqlStr.append("FROM   CO_SCHEDULE S, CO_EVENT C, CO_DEPARTMENTS D, CO_LOCATION L ");
		sqlStr.append("WHERE  S.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    S.CO_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    S.CO_EVENT_ID = C.CO_EVENT_ID ");
//		sqlStr.append("AND    S.CO_ENABLED = C.CO_ENABLED ");
		sqlStr.append("AND    C.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    S.CO_SITE_CODE = L.CO_SITE_CODE (+) ");
		sqlStr.append("AND    S.CO_LOCATION_ID = L.CO_LOCATION_ID (+) ");
		sqlStr.append("AND    S.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    S.CO_EVENT_ID = ? ");
		sqlStr.append("AND    S.CO_SCHEDULE_ID = ? ");
//		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode, eventID, scheduleID });
	}


	public static ArrayList getUserEnrolledList(
			String moduleCode,
			String eventDesc, String eventCategory,
			String scheduleStartDate, String scheduleEndDate,String userID,String userType,String isEnrolled) {
		return getList(moduleCode, null, null, eventDesc,
					null, null,
					null, null,
					scheduleStartDate, scheduleEndDate, null, null,
					userType, userID, 1, null, false, false, null, isEnrolled, null, false);
	}

	public static ArrayList getListByDateWithUserID(
			String moduleCode,
			String eventDesc, String eventCategory,
			String scheduleStartDate, String scheduleEndDate,String userID,String userType) {
		return getList(moduleCode, null, null, eventDesc,
				eventCategory, null, null, null, scheduleStartDate, scheduleEndDate,
				null, null, userType, userID, 1, false, false);
	}

	public static ArrayList getListByDateWithUserIDAndEventType2(
			String moduleCode,
			String eventDesc, String eventCategory,
			String scheduleStartDate, String scheduleEndDate,String userID,String userType,String eventType2) {
		return getList(moduleCode, null, null, eventDesc,
				null, null,
				null, null,
				scheduleStartDate, scheduleEndDate, null, null,
				userType, userID, 1, null, false, false,null,null,eventType2,false);
	}

	public static ArrayList getListByDateWithSorting(
			String moduleCode,
			String eventDesc, String eventCategory,
			String scheduleStartDate, String scheduleEndDate, String sortStr) {
		return getList(moduleCode, null, null, eventDesc,
				eventCategory, null,
				null, null,
				scheduleStartDate, scheduleEndDate, null, null,
				null, null, 1, sortStr, false, false, null,null,null,false);
	}
	
	public static ArrayList getListByDateWithSorting(
			String moduleCode,
			String eventDesc, String eventCategory,
			String scheduleStartDate, String scheduleEndDate, int sortBy) {
		return getList(moduleCode, null, null, eventDesc,
				eventCategory, null,
				null, null,
				scheduleStartDate, scheduleEndDate, null, null,
				null, null, sortBy, null, false, false, null,null,null,false);
	}

	public static ArrayList getListByDate(
			String moduleCode,
			String eventDesc, String eventCategory,
			String scheduleStartDate, String scheduleEndDate) {
		return getList(moduleCode, null, null, eventDesc,
				eventCategory, null, null, null, scheduleStartDate, scheduleEndDate,
				null, null, null, null, 1, false, false);
	}

	public static ArrayList getListByDate(
			String moduleCode,
			String eventDesc, String eventCategory,
			String eventType,
			String scheduleStartDate, String scheduleEndDate) {
		return getList(moduleCode, null, null, eventDesc,
				eventCategory, null,
				eventType, null,
				scheduleStartDate, scheduleEndDate, null, null,
				null, null, 1, false, false);
	}

	public static ArrayList getListByDate(
			String moduleCode,
			String eventDesc, String eventCategory,
			String eventType,
			String scheduleStartDate, String scheduleEndDate,
			boolean showOnline) {
		return getList(moduleCode, null, null, eventDesc,
				eventCategory, null,
				eventType, null,
				scheduleStartDate, scheduleEndDate, null, null,
				null, null, 1, false, showOnline);
	}

	public static ArrayList getListByDate(
			String moduleCode,
			String eventDesc, String eventCategory, String eventCategoryExclude,
			String eventType,
			String scheduleStartDate, String scheduleEndDate,
			boolean showOnline) {
		return getList(moduleCode, null, null, eventDesc,
				eventCategory, eventCategoryExclude,
				eventType, null,
				scheduleStartDate, scheduleEndDate, null, null,
				null, null, 2, false, showOnline);
	}

	public static ArrayList getListByDateAndDisplayTest(
			String moduleCode,
			String eventDesc, String eventCategory, String eventCategoryExclude,
			String eventType,
			String scheduleStartDate, String scheduleEndDate,
			boolean showOnline, boolean displayInserviceTest) {
		return getList(moduleCode, null, null, eventDesc,
				eventCategory, eventCategoryExclude,
				eventType, null,
				scheduleStartDate, scheduleEndDate, null, null,
				null, null, 2, null, false, showOnline, null,null,null,displayInserviceTest);
	}

	public static ArrayList getListByDateAndDisplayTest(
			String moduleCode,String eventID,
			String eventDesc, String eventCategory, String eventCategoryExclude,
			String eventType,
			String scheduleStartDate, String scheduleEndDate,
			boolean showOnline, boolean displayInserviceTest) {
		return getList(moduleCode, null, eventID, eventDesc,
				eventCategory, eventCategoryExclude,
				eventType, null,
				scheduleStartDate, scheduleEndDate, null, null,
				null, null, 2, null, false, showOnline, null,null,null,displayInserviceTest);
	}

	public static ArrayList getListByDate(
			String moduleCode,
			String eventDesc, String eventCategory,
			String eventType,
			String scheduleStartDate, String scheduleEndDate,
			boolean showOnline, int sortby) {
		return getList(moduleCode, null, null, eventDesc,
				eventCategory, null,
				eventType, null,
				scheduleStartDate, scheduleEndDate, null, null,
				null, null, sortby, false, showOnline);
	}

	public static ArrayList getListByDate(
			String moduleCode, String eventID,
			String eventDesc, String eventCategory,
			String eventType,
			String scheduleStartDate, String scheduleEndDate,
			boolean showOnline, int sortby) {
		return getList(moduleCode, null, eventID, eventDesc,
				eventCategory, null,
				eventType, null,
				scheduleStartDate, scheduleEndDate, null, null,
				null, null, sortby, false, showOnline);
	}

	public static ArrayList getListByTime(
			String moduleCode,
			String eventID, String eventDesc,
			String scheduleID,
			String scheduleStartTime, String scheduleEndTime,
			String userType, String userID, boolean showActive) {
		return getList(moduleCode, null, eventID, eventDesc,
				null, null,
				null, scheduleID,
				null, null, scheduleStartTime, scheduleEndTime,
				userType, userID, -1, showActive, false);
	}

	public static ArrayList getListByTime(
			String moduleCode,
			String eventID, String eventDesc,
			String scheduleID,
			String scheduleStartTime, String scheduleEndTime,
			String userType, String userID, boolean showActive,String Year) {
		return getList(moduleCode, null, eventID, eventDesc,
				null, null,
				null, scheduleID,
				null, null, scheduleStartTime, scheduleEndTime,
				userType, userID, 1, showActive, false,Year);
	}

	public static ArrayList getListByTime(
			String moduleCode,
			String eventID, String eventDesc,
			String scheduleID,
			String scheduleStartTime, String scheduleEndTime,
			String userType, String userID,int sortBy, boolean showActive,String Year) {
		return getList(moduleCode, null, eventID, eventDesc,
				null, null,
				null, scheduleID,
				null, null, scheduleStartTime, scheduleEndTime,
				userType, userID, sortBy, showActive, false,Year);
	}
	

	public static ArrayList getList(
			String moduleCode,
			String deptCode, String eventDesc) {
		return getList(moduleCode, deptCode, null, eventDesc,
				null, null,
				null, null,
				null, null, null, null,
				null, null, 1, false, false);
	}

	public static ArrayList getList(
			String moduleCode,
			String deptCode, String eventDesc, String sortby) {
		return getList(moduleCode, deptCode, null, eventDesc,
				null, null,
				null, null,
				null, null, null, null,
				null, null, -1, sortby, false, false, null,null,null,false);
	}

	public static ArrayList getList(
			String moduleCode,
			String eventCategoryInclude, String eventCategoryExclude,
			String userType, String userID, int sortby, boolean showActive) {
		return getList(moduleCode, null, null, null,
				eventCategoryInclude, eventCategoryExclude,
				null, null,
				null, null, null, null,
				userType, userID, sortby, showActive, false);
	}

	public static ArrayList getList(
			String moduleCode, String deptCode, String eventID, String eventDesc,
			String eventCategoryInclude, String eventCategoryExclude,
			String eventType, String scheduleID,
			String scheduleStartDate, String scheduleEndDate, String scheduleStartTime, String scheduleEndTime,
			String userType, String userID, int sortby, boolean showActive, boolean showOnline){

		return getList(moduleCode, deptCode, eventID, eventDesc,
				eventCategoryInclude, eventCategoryExclude,
				eventType, scheduleID,
				scheduleStartDate, scheduleEndDate, scheduleStartTime, scheduleEndTime,
				userType, userID, sortby, showActive, showOnline, null);
	}

	public static ArrayList getList(
			String moduleCode, String deptCode, String eventID, String eventDesc,
			String eventCategoryInclude, String eventCategoryExclude,
			String eventType, String scheduleID,
			String scheduleStartDate, String scheduleEndDate, String scheduleStartTime, String scheduleEndTime,
			String userType, String userID, int sortby, boolean showActive, boolean showOnline,String Year) {

		return getList(moduleCode, deptCode, eventID, eventDesc,
				eventCategoryInclude, eventCategoryExclude,
				eventType, scheduleID,
				scheduleStartDate, scheduleEndDate, scheduleStartTime, scheduleEndTime,
				userType, userID, sortby, null, showActive, showOnline, Year,null,null,false);
	}

	public static ArrayList getList(
			String moduleCode, String deptCode, String eventID, String eventDesc,
			String eventCategoryInclude, String eventCategoryExclude,
			String eventType, String scheduleID,
			String scheduleStartDate, String scheduleEndDate, String scheduleStartTime, String scheduleEndTime,
			String userType, String userID, int sortby, String sortStr, boolean showActive, boolean showOnline,String Year,String isEnrolled,String eventType2,
			boolean displayInserviceTest) {
		// fetch user enrollment
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, CS.CO_EVENT_ID, C.CO_EVENT_DESC, CS.CO_SCHEDULE_DESC, ");
		sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE, CS.CO_SCHEDULE_ID, ");
		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_START, 'dd/MM/YYYY'), TO_CHAR(CS.CO_SCHEDULE_START, 'HH24:MI'), ");
		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_END, 'HH24:MI'), CS.CO_SCHEDULE_DURATION, ");
		sqlStr.append("       L.CO_LOCATION_DESC, CS.CO_SCHEDULE_SIZE, CS.CO_SCHEDULE_ENROLLED, CS.CO_SCHEDULE_SIZE - CS.CO_SCHEDULE_ENROLLED, ");
		if (userType != null && userID != null) {
			sqlStr.append("MAX(E.CO_ENROLL_ID)");
		} else {
			sqlStr.append("NULL");
		}
		sqlStr.append(", CS.CO_SCHEDULE_STATUS, CS.CO_LOCATION_DESC, C.CO_EVENT_REMARK, CS.CO_LUNCH_AVA, CS.CO_LECTURE_DESC, '組別 ' || substr(CS.CO_SCHEDULE_DESC, 7,3) ");
		sqlStr.append("FROM   CO_SCHEDULE CS, CO_EVENT C, CO_DEPARTMENTS D, CO_LOCATION L ");
		if (userType != null && userID != null) {
			sqlStr.append(",(SELECT * FROM CO_ENROLLMENT WHERE CO_ATTEND_STATUS = 0 AND CO_ENABLED = 1 AND CO_MODULE_CODE = '");
			sqlStr.append(moduleCode);
			sqlStr.append("' AND CO_USER_TYPE = '");
			sqlStr.append(userType);
			sqlStr.append("' AND CO_USER_ID = '");
			sqlStr.append(userID);
			sqlStr.append("' ) E ");
		}
		sqlStr.append("WHERE  CS.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    CS.CO_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    CS.CO_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    CS.CO_ENABLED = C.CO_ENABLED ");
		sqlStr.append("AND    C.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    CS.CO_SITE_CODE = L.CO_SITE_CODE (+) ");
		sqlStr.append("AND    CS.CO_LOCATION_ID = L.CO_LOCATION_ID (+) ");
		if (userType != null && userID != null) {
			sqlStr.append("AND    CS.CO_SITE_CODE = E.CO_SITE_CODE (+) ");
			sqlStr.append("AND    CS.CO_MODULE_CODE = E.CO_MODULE_CODE (+) ");
			sqlStr.append("AND    CS.CO_EVENT_ID = E.CO_EVENT_ID (+) ");
			sqlStr.append("AND    CS.CO_SCHEDULE_ID = E.CO_SCHEDULE_ID (+) ");
			sqlStr.append("AND    CS.CO_ENABLED = E.CO_ENABLED (+) ");
		}
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    (C.CO_DEPARTMENT_CODE IS NULL OR C.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("') ");
		}
		if (eventID != null && eventID.length() > 0) {
			sqlStr.append("AND    CS.CO_EVENT_ID = '");
			sqlStr.append(eventID);
			sqlStr.append("' ");
		}
		if (eventDesc != null && eventDesc.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_DESC LIKE '%");
			sqlStr.append(eventDesc);
			sqlStr.append("%' ");
		}
		if (eventCategoryExclude != null && eventCategoryExclude.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_CATEGORY != '");
			sqlStr.append(eventCategoryExclude);
			sqlStr.append("' ");
		}
		if (eventCategoryInclude != null && eventCategoryInclude.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_CATEGORY = '");
			sqlStr.append(eventCategoryInclude);
			sqlStr.append("' ");
		}
		if (eventType != null && eventType.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_TYPE = '");
			sqlStr.append(eventType);
			sqlStr.append("' ");
		}
		if (eventType2 != null && eventType2.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_TYPE2 = '");
			sqlStr.append(eventType2);
			sqlStr.append("' ");
		}
		if (scheduleID != null && scheduleID.length() > 0) {
			sqlStr.append("AND    CS.CO_SCHEDULE_ID = '");
			sqlStr.append(scheduleID);
			sqlStr.append("' ");
		}
		if (scheduleStartDate != null && scheduleStartDate.length() > 0) {
			sqlStr.append("AND    CS.CO_SCHEDULE_START >= TO_DATE('");
			sqlStr.append(scheduleStartDate);
			sqlStr.append(" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') ");
		}
		if (scheduleEndDate != null && scheduleEndDate.length() > 0) {
			sqlStr.append("AND    CS.CO_SCHEDULE_START <= TO_DATE('");
			sqlStr.append(scheduleEndDate);
			sqlStr.append(" 23:59:59', 'dd/MM/YYYY HH24:MI:SS') ");
		}
		if (scheduleStartTime != null && scheduleStartTime.length() > 0) {
			sqlStr.append("AND    TO_CHAR(CS.CO_SCHEDULE_START, 'HH24:MI') >= '");
			sqlStr.append(scheduleStartTime);
			sqlStr.append("' ");
		}
		if (scheduleEndTime != null && scheduleEndTime.length() > 0) {
			sqlStr.append("AND    TO_CHAR(CS.CO_SCHEDULE_START, 'HH24:MI') <= '");
			sqlStr.append(scheduleEndTime);
			sqlStr.append("' ");
		}
		if(Year != null && Year.length() > 0){
			sqlStr.append("AND TO_CHAR(CS.CO_SCHEDULE_START, 'YYYY') = '"+Year+"' ");
		}
		if (showActive) {
//			sqlStr.append("AND    CS.CO_SCHEDULE_START >= SYSDATE ");
			sqlStr.append("AND    CS.CO_SCHEDULE_STATUS = 'open' ");
		}
		if (showOnline) {
			sqlStr.append("AND    CS.CO_SCHEDULE_SIZE > 0 ");
		}

		if (userType != null && userID != null) {
			if(isEnrolled != null && isEnrolled.equals("y")){
				sqlStr.append("AND    E.CO_ENROLL_ID IS NOT NULL ");
			}else if(isEnrolled != null && isEnrolled.equals("n")){
				sqlStr.append("AND    E.CO_ENROLL_ID IS NULL ");
			}
		}

		sqlStr.append("AND    CS.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CS.CO_ENABLED = 1 ");
		sqlStr.append("GROUP BY C.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, CS.CO_EVENT_ID, C.CO_EVENT_DESC, CS.CO_SCHEDULE_DESC, CS.CO_SCHEDULE_ID, ");
		sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE, CS.CO_SCHEDULE_START, CS.CO_SCHEDULE_END, CS.CO_SCHEDULE_DURATION, ");
		sqlStr.append("       L.CO_LOCATION_DESC, CS.CO_SCHEDULE_SIZE, CS.CO_SCHEDULE_ENROLLED, CS.CO_SCHEDULE_STATUS, CS.CO_LOCATION_DESC, C.CO_EVENT_REMARK, CS.CO_LUNCH_AVA, CS.CO_LECTURE_DESC ");

		if(displayInserviceTest){
			sqlStr.append("union all ");
			sqlStr.append("select  null, '1', EE_EVENT_ID,EE_TOPIC, null, ");
			sqlStr.append("null, null, null, null, ");
			sqlStr.append("NULL, NULL,NULL, ");
			sqlStr.append("NULL, NULL, NULL, NULL, ");
			sqlStr.append("null, NULL,NULL,NULL,NULL ");
			sqlStr.append("from   EE_ELEARNING ");
			sqlStr.append("where  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
			sqlStr.append("and    EE_MODULE_CODE =  'education' ");
			sqlStr.append("and    (EE_ELEARNING_ID = 2 or EE_ELEARNING_ID = 3 ");
			sqlStr.append("or EE_ELEARNING_ID = 13 or EE_ELEARNING_ID = 14 ");
			sqlStr.append("or EE_ELEARNING_ID = 15 or EE_ELEARNING_ID = 16) ");
			sqlStr.append("and    EE_ENABLED = 1 ");

			sqlStr.append("ORDER BY 2, 9, 3 ");
		}else{
			if (sortStr != null && sortStr.length() > 0) {
				sqlStr.append(sortStr);
			} else {
				if (sortby == 1) {
					sqlStr.append("ORDER BY CS.CO_SCHEDULE_START DESC, C.CO_EVENT_DESC");
				}
				else if (sortby == 2) {
					sqlStr.append("ORDER BY CS.CO_SCHEDULE_START ");
				}
				else if (sortby == 99){
					sqlStr.append("ORDER BY CS.CO_SCHEDULE_ID ");
				}
				else {
					sqlStr.append("ORDER BY C.CO_EVENT_DESC, CS.CO_SCHEDULE_START");
				}
			}
		}

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode });
	}

	public static ArrayList getCalendar(
			String deptCode, String dateFrom, String dateTo) {
		return getCalendar(deptCode, dateFrom, dateTo, false);
	}
	public static ArrayList getCalendar(
			String deptCode, String dateFrom, String dateTo, boolean noZeroSize) {
		// fetch schedule list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CS.CO_EVENT_ID, CS.CO_SCHEDULE_ID, CE.CO_EVENT_DESC, CS.CO_SCHEDULE_DESC, CE.CO_EVENT_REMARK, ");
		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_START, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_START, 'HH24:MI'), ");
		sqlStr.append("       TO_CHAR(CS.CO_SCHEDULE_END, 'HH24:MI'), ");
		sqlStr.append("       CS.CO_LOCATION_DESC, L.CO_LOCATION_DESC, CS.CO_LECTURE_DESC, ");
		sqlStr.append("       CE.CO_EVENT_CATEGORY, CE.CO_EVENT_TYPE, CS.CO_SCHEDULE_SIZE, CS.CO_SCHEDULE_ENROLLED, ");
		sqlStr.append("       CS.CO_SCHEDULE_SIZE - CS.CO_SCHEDULE_ENROLLED, CS.CO_NEWS_ID, CS.CO_SHOWREGONLINE, CS.CO_SCHEDULE_STATUS, CO_LUNCH_AVA ");
		sqlStr.append("FROM   CO_SCHEDULE CS, CO_EVENT CE, CO_LOCATION L ");
		sqlStr.append("WHERE  CS.CO_SITE_CODE = CE.CO_SITE_CODE ");
		sqlStr.append("AND    CS.CO_MODULE_CODE = CE.CO_MODULE_CODE ");
		sqlStr.append("AND    CS.CO_EVENT_ID = CE.CO_EVENT_ID ");
		sqlStr.append("AND    CS.CO_ENABLED = CE.CO_ENABLED ");
		sqlStr.append("AND    CS.CO_SITE_CODE = L.CO_SITE_CODE (+) ");
		sqlStr.append("AND    CS.CO_LOCATION_ID = L.CO_LOCATION_ID (+) ");
		sqlStr.append("AND    CE.CO_MODULE_CODE = 'education' ");
		sqlStr.append("AND    CE.CO_NON_HOSP_COURSE = 'N' ");
//		sqlStr.append("AND   (CE.CO_EVENT_CATEGORY in ('inservice', 'other') ");
//		sqlStr.append("OR     CS.CO_EVENT_ID in ('");
//		sqlStr.append(ConstantsCourseVariable.SHARE_NE_CLASS_ID);
//		sqlStr.append("', '");
//		sqlStr.append(ConstantsCourseVariable.HOSPITAL_ORIENTATION_NE_CLASS_ID);
//		sqlStr.append("', '");
//		sqlStr.append(ConstantsCourseVariable.NURSE_ORIENTATION_NE_CLASS_ID);
//		sqlStr.append("', '");
//		sqlStr.append(ConstantsCourseVariable.CPR_CLASS_ID);	// hardcode to represent for all compulsory classes on same day
//		sqlStr.append("')) ");
//		sqlStr.append("AND    CE.CO_EVENT_TYPE = 'class' ");
		sqlStr.append("AND    CE.CO_ENABLED = 1 ");
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    (CE.CO_DEPARTMENT_CODE IS NULL OR CE.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("') ");
		}
		sqlStr.append("AND    CS.CO_SCHEDULE_START >= TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND    CS.CO_SCHEDULE_START <= TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS') ");
		if (noZeroSize) {
			sqlStr.append("AND    CS.CO_SCHEDULE_SIZE > 0 ");
		}
		sqlStr.append("ORDER BY CS.CO_SCHEDULE_START ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString(),
			new String[] { dateFrom + " 00:00:00", dateTo + " 23:59:59" }
		);
	}

	public static String getScheduleID(
			String moduleCode,
			String eventID,
			String scheduleDesc) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_SCHEDULE_ID ");
		sqlStr.append("FROM   CO_SCHEDULE ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_SCHEDULE_DESC = ? ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode, eventID, scheduleDesc });

		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	public static String getScheduleIDByDateTime(
			String moduleCode,
			String eventID,
			String startTime, String endTime) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_SCHEDULE_ID ");
		sqlStr.append("FROM   CO_SCHEDULE ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_SCHEDULE_START = TO_DATE(?, 'dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    CO_SCHEDULE_END = TO_DATE(?, 'dd/mm/yyyy HH24:MI:SS') ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode, eventID, startTime, endTime });

		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	public static boolean expire(
			String moduleCode, String updateUser) {
		// try to update selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_SCHEDULE ");
		sqlStr.append("SET    CO_SCHEDULE_STATUS = 'close', ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("       CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_SCHEDULE_START < SYSDATE ");
		sqlStr.append("AND    CO_SCHEDULE_STATUS = 'open' ");


		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { updateUser, moduleCode } );
	}
}