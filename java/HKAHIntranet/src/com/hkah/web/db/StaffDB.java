/*
 * Created on April 9, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.sql.Connection;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.PasswordUtil;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class StaffDB {

	private static String sqlStr_insertStaff = null;
	private static String sqlStr_updateStaff = null;
	private static String sqlStr_deleteStaff = null;
	private static String sqlStr_deleteStaffRecord = null;
	private static String sqlStr_getStaff = null;
	private static String sqlStr_getNewStaffIDAMC1 = null;
	private static String sqlStr_getNewStaffIDAMC2 = null;
	private static String sqlStr_isExistStaff = null;
	private static String sqlStr_isExistActiveStaff = null;
	private static String sqlStr_isExistSiteStaff = null;
	private static String sqlStr_getStaffSiteCode = null;
	private static String sqlStr_atLeastOneYearStaff = null;
	private static String sqlStr_getStaffOtherSite = null;

	private static String sqlStr_insertStaffID = null;
	private static String sqlStr_insertStaff2 = null;
	private static String sqlStr_updateStaffIfChanged = null;
	private static String sqlStr_updateDeptCode = null;
	private static String sqlStr_selectAccessStaff = null;
	private static String sqlStr_resetStaff = null;
	private static String sqlStr_terminateUsers = null;
	private static String sqlStr_terminateUsersAMC = null;
	private static String sqlStr_terminateStaffs = null;
	private static String sqlStr_terminateStaffsAMC = null;
	private static String sqlStr_hireUsers = null;
	private static String sqlStr_hireStaffs = null;
	private static String sqlStr_getTerminateTodayStaffs = null;
	private static String sqlStr_getHireTodayStaffs = null;
	private static String sqlStr_turnOffMarkDeleted = null;
	private static String sqlStr_updateMarkDelete = null;

	private static String sqlStr_insertStaffDeptCode = null;
	private static String sqlStr_deleteStaffDeptCode = null;

	private static String sqlStr_selectHRStaff = null;
	private static String sqlStr_updateTWAHStaff = null;
	private static String sqlStr_insertStaffFromHR = null;
	private static String sqlStr_selectHRDept = null;

	private static String sqlStr_insertDoctor = null;

	public static Map<String, String> nursingPosCode = null;

	/**
	 * Add a staff
	 */
	public static boolean add(UserBean userBean,
			String siteCode,
			String staffID,
			String deptCode,
			String deptCode2[],
			String staffName,
			String status,
			String annual_incr,
			String hireDate,
			String category,
			String terminationDate,
			String position1,
			String position2,
			String markDeleted,

			String hospNo,
			String isFixDepartmentCode,
			String positionCode,
			String chiName,
			String lastName,
			String firstName,
			String email,
			String jobCode,
			String jobDescription,
			String displayName,

			String enabled
			) {

		if (UtilDBWeb.updateQueue(
				sqlStr_insertStaff,
				new String[] { siteCode, staffID,
						deptCode, staffName, status, annual_incr == null || annual_incr.isEmpty() ? annual_incr : "01/" + annual_incr + "/1900", hireDate, category, terminationDate, position1, position2, markDeleted,
						hospNo, isFixDepartmentCode, positionCode, chiName, lastName, firstName, email, jobCode, jobDescription, displayName,
						enabled, userBean.getStaffID(), userBean.getStaffID() })) {
			return updateDeptCode2(userBean, staffID, deptCode, deptCode2);
		} else {
			return false;
		}
	}

	public static boolean add(String staffID) {
		if (UtilDBWeb.updateQueue(
				sqlStr_insertStaffID,
				new String[] {
						staffID
				} )) {
			return true;
		}
		return false;
	}

	public static boolean addDoctor(String staffID) {
		if (UtilDBWeb.updateQueue(
				sqlStr_insertDoctor,
				new String[] {
						staffID, "", "995", "", "", "", ""
				} )) {
			return true;
		}
		return false;
	}

	/**
	 * Modify a staff
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String siteCode,
			String staffID,
			String deptCode,
			String deptCode2[],
			String staffName,
			String status,
			String annual_incr,
			String hireDate,
			String category) {
		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updateStaff,
				new String[] { deptCode, staffName, status, annual_incr == null || annual_incr.isEmpty() ? annual_incr : "01/" + annual_incr + "/1900", hireDate, category, "", "N",
						"", "", "", "", "", "", "", "", "", "",
						"1", userBean.getStaffID(),"", siteCode, staffID })) {
			return updateDeptCode2(userBean, staffID, deptCode, deptCode2);
		} else {
			return false;
		}
	}

	public static boolean update(UserBean userBean,
			String siteCode,
			String staffID,
			String deptCode,
			String deptCode2[],
			String staffName,
			String status,
			String annual_incr,
			String hireDate,
			String category,
			String terminationDate,
			String position1,
			String position2,
			String markDeleted,

			String hospNo,
			String isFixDepartmentCode,
			String positionCode,
			String chiName,
			String lastName,
			String firstName,
			String email,
			String jobCode,
			String jobDescription,
			String displayName,

			String enabled,
			String displayPhoto
			) {
		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updateStaff,
				new String[] { deptCode, staffName, status, annual_incr == null || annual_incr.isEmpty() ? annual_incr : "01/" + annual_incr + "/1900", hireDate, category, terminationDate, position1, position2, markDeleted,
						hospNo, isFixDepartmentCode, positionCode, chiName, lastName, firstName, email, jobCode, jobDescription, displayName,
						enabled, userBean.getStaffID(), displayPhoto, siteCode, staffID })) {
			if ("1".equals(enabled)) {
				// enable all co_users.co_staff_id
				UserDB.enableUserByStaffId(userBean, siteCode, staffID);
			}

			return updateDeptCode2(userBean, staffID, deptCode, deptCode2);
		} else {
			return false;
		}
	}

	public static boolean updateDeptCode2(UserBean userBean, String staffID, String deptCode, String[] deptCode2) {
		if (deptCode2 != null) {
			UtilDBWeb.updateQueue(sqlStr_deleteStaffDeptCode, new String[] { staffID });
			for (int i = 0; i < deptCode2.length; i++) {
				if (!deptCode.equals(deptCode2[i])) {
					UtilDBWeb.updateQueue(sqlStr_insertStaffDeptCode, new String[] { staffID, deptCode2[i], userBean.getStaffID(), userBean.getStaffID() });
				}
			}
		}
		return true;
	}

	public static boolean turnOffMarkDeleted(UserBean userBean, String staffID) {
		String modifiedUser = null;
		if (userBean == null || userBean.getStaffID() == null) {
			modifiedUser = "SYSTEM";
		} else {
			modifiedUser = userBean.getStaffID();
		}
		return UtilDBWeb.updateQueue(
				sqlStr_turnOffMarkDeleted,
				new String[] { modifiedUser, staffID });
	}

	public static boolean delete(
			String siteCode,
			String staffID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteStaffRecord,
				new String[] { siteCode, staffID });
	}

	public static boolean disable(UserBean userBean,
			String siteCode,
			String staffID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteStaff,
				new String[] { userBean.getStaffID(), siteCode, staffID });
	}

	public static boolean disable(
			String siteCode,
			String staffID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteStaff,
				new String[] { "SYSTEM", siteCode, staffID });
	}

	public static boolean batchDelete(UserBean userBean, String staffIdsStr) {
		System.out.println("intranet StaffDB batchDelete staffIdsStr="+staffIdsStr);
		if (staffIdsStr == null || staffIdsStr.trim().isEmpty()) {
			return false;
		}
		boolean success = false;
		boolean success2 = false;

		String[] staffIds = null;
		if (staffIdsStr != null && !staffIdsStr.trim().isEmpty()) {
			staffIdsStr = StringUtils.deleteWhitespace(staffIdsStr).toUpperCase();
			staffIds = staffIdsStr.split(",");
		}

		String[] splitStaffIds = staffIds;
		String[] tempStaffIds = new String[(int)Math.ceil(splitStaffIds.length/1000.0)];

		for (int i=0;i<tempStaffIds.length;i++) {
			tempStaffIds[i] = StringUtils.join(Arrays.copyOfRange(splitStaffIds,(i*1000),(((splitStaffIds.length)<(((i+1)*1000)))?(splitStaffIds.length):(((i+1)*1000))) ), "','");
		}

		// staffs
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_STAFFS ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MARK_DELETED = 'Y', CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		for (int j=0; j<tempStaffIds.length; j++) {
		   	if (j==0) {
				sqlStr.append("AND (UPPER(CO_STAFF_ID) IN ('" + tempStaffIds[j] + "') ");
		   	} else {
			 	sqlStr.append("OR   UPPER(CO_STAFF_ID) IN ('" + tempStaffIds[j] + "') ");
		   	}
		}
		if (tempStaffIds.length > 0) {
			sqlStr.append(")");
		}

		success = UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{ userBean.getStaffID()});

		// users with staff_id
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_USERS ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		for (int j=0;j<tempStaffIds.length;j++) {
		   if (j==0) {
			 sqlStr.append("AND (UPPER(CO_STAFF_ID) IN ('" + tempStaffIds[j] + "') ");
		   } else {
			 sqlStr.append("OR   UPPER(CO_STAFF_ID) IN ('" + tempStaffIds[j] + "') ");
		   }
		}
		if (tempStaffIds.length > 0) {
			sqlStr.append(")");
		}

		success2 = UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{ userBean.getStaffID()});

		return success;
	}

	public static boolean batchDeleteHATS(UserBean userBean, String staffIdsStr) {
		System.out.println("intranet StaffDB batchDeleteHATS staffIdsStr="+staffIdsStr);
		if (staffIdsStr == null || staffIdsStr.trim().isEmpty()) {
			return false;
		}

		String[] staffIds = null;
		if (staffIdsStr != null && !staffIdsStr.trim().isEmpty()) {
			staffIdsStr = StringUtils.deleteWhitespace(staffIdsStr).toUpperCase();
			staffIds = staffIdsStr.split(",");
		}

		String[] splitStaffIds = staffIds;
		String[] tempStaffIds = new String[(int)Math.ceil(splitStaffIds.length/1000.0)];

		for (int i=0;i<tempStaffIds.length;i++) {
			tempStaffIds[i] = StringUtils.join(Arrays.copyOfRange(splitStaffIds,(i*1000),(((splitStaffIds.length)<(((i+1)*1000)))?(splitStaffIds.length):(((i+1)*1000))) ), "','");
		}

		// HATS user (disable individual account only)
		String moduleCode = "hats." + (ConstantsServerSide.DEBUG ? "uat" : "prod") + "." + ConstantsServerSide.SITE_CODE.toLowerCase();
		String moduleUserIdExclude = ConstantsServerSide.SITE_CODE.toUpperCase();

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("update usr@iweb set usrsts = 0 ");
		sqlStr.append("where usrid in ( ");
		sqlStr.append(" select module_user_id ");
		sqlStr.append(" from sso_user_mapping@sso ");
		sqlStr.append(" where enabled = 1 ");
		sqlStr.append(" and module_code = ? ");
		sqlStr.append(" and module_user_id in ( ");
		sqlStr.append("  select ");
		sqlStr.append("    um.module_user_id ");
		sqlStr.append("  from sso_user@sso u ");
		sqlStr.append("    join sso_user_mapping@sso um on u.sso_user_id = um.sso_user_id ");
		sqlStr.append("  where um.enabled = 1 ");
		sqlStr.append("  and um.module_code = ? ");
		sqlStr.append("  and um.module_user_id <> ? ");

		for (int j=0;j<tempStaffIds.length;j++) {
		   if (j==0) {
			 sqlStr.append("AND (upper(u.staff_no) IN ('" + tempStaffIds[j] + "') ");
		   } else {
			 sqlStr.append("OR   upper(u.staff_no) IN ('" + tempStaffIds[j] + "') ");
		   }
		}
		if (tempStaffIds.length > 0) {
			sqlStr.append(")");
		}
		sqlStr.append(" )");
		sqlStr.append("group by module_user_id ");
		sqlStr.append("having count(1) = 1 ");
		sqlStr.append(") ");
		sqlStr.append("and usrsts <> 0");

		System.out.println("[StaffDB] batchDeleteHATS sql="+sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{moduleCode, moduleCode, moduleUserIdExclude});
	}


	public static boolean batchDeleteCIS(UserBean userBean, String staffIdsStr) {
		System.out.println("intranet StaffDB batchDeleteCIS staffIdsStr="+staffIdsStr);
		if (staffIdsStr == null || staffIdsStr.trim().isEmpty()) {
			return false;
		}

		String[] staffIds = null;
		if (staffIdsStr != null && !staffIdsStr.trim().isEmpty()) {
			staffIdsStr = StringUtils.deleteWhitespace(staffIdsStr).toUpperCase();
			staffIds = staffIdsStr.split(",");
		}

		String[] splitStaffIds = staffIds;
		String[] tempStaffIds = new String[(int)Math.ceil(splitStaffIds.length/1000.0)];

		for (int i=0;i<tempStaffIds.length;i++) {
			tempStaffIds[i] = StringUtils.join(Arrays.copyOfRange(splitStaffIds,(i*1000),(((splitStaffIds.length)<(((i+1)*1000)))?(splitStaffIds.length):(((i+1)*1000))) ), "','");
		}

		// CIS user
		// update ah_sys_user set expired_date=sysdate where user_id=:staff_no;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE	ah_sys_user ");
		sqlStr.append("SET    expired_date=sysdate ");
		sqlStr.append("WHERE 1=1 ");
		for (int j=0;j<tempStaffIds.length;j++) {
		   if (j==0) {
			 sqlStr.append("AND  	(upper(user_id) IN ('" + tempStaffIds[j] + "') ");
		   } else {
			 sqlStr.append("OR  	upper(user_id) IN ('" + tempStaffIds[j] + "') ");
		   }
		}
		if (tempStaffIds.length > 0) {
			sqlStr.append(")");
		}
		sqlStr.append(" AND expired_date is null ");

		System.out.println("[StaffDB] batchDeleteCIS sql="+sqlStr.toString());
		return UtilDBWeb.updateQueueCIS(sqlStr.toString());
	}

	public static boolean batchDeleteNIS(UserBean userBean, String staffIdsStr) {
		System.out.println("intranet StaffDB batchDeleteNIS staffIdsStr="+staffIdsStr);
		if (staffIdsStr == null || staffIdsStr.trim().isEmpty()) {
			return false;
		}

		String[] staffIds = null;
		if (staffIdsStr != null && !staffIdsStr.trim().isEmpty()) {
			staffIdsStr = StringUtils.deleteWhitespace(staffIdsStr).toLowerCase();
			staffIds = staffIdsStr.split(",");
		}

		String[] splitStaffIds = staffIds;
		String[] tempStaffIds = new String[(int)Math.ceil(splitStaffIds.length/1000.0)];

		for (int i=0;i<tempStaffIds.length;i++) {
			tempStaffIds[i] = StringUtils.join(Arrays.copyOfRange(splitStaffIds,(i*1000),(((splitStaffIds.length)<(((i+1)*1000)))?(splitStaffIds.length):(((i+1)*1000))) ), "','");
		}

		// NIS user
		// UPDATE nis_sys_user_basic SET status='D' WHERE user_id= 'staff_no';
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE nis.nis_sys_user_basic@nis ");
		sqlStr.append("SET    status='D' ");
		sqlStr.append("WHERE 1=1 ");
		for (int j=0;j<tempStaffIds.length;j++) {
		   if (j==0) {
			 sqlStr.append("AND  	(lower(user_id) IN ('" + tempStaffIds[j] + "') ");
		   } else {
			 sqlStr.append("OR  	lower(user_id) IN ('" + tempStaffIds[j] + "') ");
		   }
		}
		if (tempStaffIds.length > 0) {
			sqlStr.append(")");
		}
		sqlStr.append(" AND status <> 'D'");
		
		System.out.println("[StaffDB] batchDeleteNIS sql="+sqlStr.toString());
		return UtilDBWeb.updateQueueCIS(sqlStr.toString());
	}

	public static boolean batchDeleteHelpdesk(UserBean userBean, String staffIdsStr) {
		System.out.println("intranet StaffDB batchDelete Helpdesk staffIdsStr="+staffIdsStr);
		if (staffIdsStr == null || staffIdsStr.trim().isEmpty()) {
			return false;
		}

		String[] staffIds = null;
		if (staffIdsStr != null && !staffIdsStr.trim().isEmpty()) {
			staffIdsStr = StringUtils.deleteWhitespace(staffIdsStr).toUpperCase();
			staffIds = staffIdsStr.split(",");
		}

		String[] splitStaffIds = staffIds;
		String[] tempStaffIds = new String[(int)Math.ceil(splitStaffIds.length/1000.0)];

		for (int i=0;i<tempStaffIds.length;i++) {
			tempStaffIds[i] = StringUtils.join(Arrays.copyOfRange(splitStaffIds,(i*1000),(((splitStaffIds.length)<(((i+1)*1000)))?(splitStaffIds.length):(((i+1)*1000))) ), "','");
		}

		// NIS user
		// UPDATE nis_sys_user_basic SET status='D' WHERE user_id= 'staff_no';
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE appuser@helpdesk ");
		sqlStr.append("SET    password='ACCOUNT_DISABLED' ");
		sqlStr.append("WHERE 1=1 ");
		for (int j=0;j<tempStaffIds.length;j++) {
		   if (j==0) {
			 sqlStr.append("AND  	(upper(userid) IN ('" + tempStaffIds[j] + "') ");
		   } else {
			 sqlStr.append("OR  	upper(userid) IN ('" + tempStaffIds[j] + "') ");
		   }
		}
		if (tempStaffIds.length > 0) {
			sqlStr.append(")");
		}
		sqlStr.append(" AND password <> 'ACCOUNT_DISABLED' ");

		System.out.println("[StaffDB] batchDeleteHelpdesk sql="+sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean batchDeleteRIS(UserBean userBean, String staffIdsStr) {
		System.out.println("intranet StaffDB batchDelete RIS staffIdsStr="+staffIdsStr);
		if (staffIdsStr == null || staffIdsStr.trim().isEmpty()) {
			return false;
		}

		String[] staffIds = null;
		if (staffIdsStr != null && !staffIdsStr.trim().isEmpty()) {
			staffIdsStr = StringUtils.deleteWhitespace(staffIdsStr).toUpperCase();
			staffIds = staffIdsStr.split(",");
		}

		String[] splitStaffIds = staffIds;
		String[] tempStaffIds = new String[(int)Math.ceil(splitStaffIds.length/1000.0)];

		for (int i=0;i<tempStaffIds.length;i++) {
			tempStaffIds[i] = StringUtils.join(Arrays.copyOfRange(splitStaffIds,(i*1000),(((splitStaffIds.length)<(((i+1)*1000)))?(splitStaffIds.length):(((i+1)*1000))) ), "','");
		}

		// RIS user
		// update USERS@RIS set user_stat = 'L' where userid = 'staff_no';
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE USERS@RIS ");
		sqlStr.append("SET    user_stat = 'L' ");
		sqlStr.append("WHERE 1=1 ");
		for (int j=0;j<tempStaffIds.length;j++) {
		   if (j==0) {
			 sqlStr.append("AND  	(upper(userid) IN ('" + tempStaffIds[j] + "') ");
		   } else {
			 sqlStr.append("OR  	upper(userid) IN ('" + tempStaffIds[j] + "') ");
		   }
		}
		if (tempStaffIds.length > 0) {
			sqlStr.append(")");
		}
		sqlStr.append(" AND (user_stat <> 'L' OR user_stat is null) ");

		System.out.println("[StaffDB] batchDeleteRIS sql="+sqlStr.toString());
		return UtilDBWeb.updateQueueHATS(sqlStr.toString());
	}

	public static ArrayList get(String staffID) {
		return get(staffID, "1");
	}

	public static ArrayList get(String staffID, String enabled) {
		// fetch staff
		return UtilDBWeb.getReportableList(sqlStr_getStaff, new String[] { enabled, staffID });
	}

	public static String getHireDate(String staffID) {
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_getStaff, new String[] { "1", staffID });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getValue(6);
		} else {
			return null;
		}
	}

	public static String getDepartmentCode(String staffID) {
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_getStaff, new String[] { "1", staffID });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getValue(1);
		} else {
			return null;
		}
	}

	public static ArrayList getList4StaffList(UserBean userBean,
			String siteCode, String deptCode, String staffID, String staffName, String category, String markdeleted, String enabled) {
		// fetch staff
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT S.CO_SITE_CODE, D.CO_DEPARTMENT_DESC, S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_STATUS, ");
		sqlStr.append("       TO_CHAR(S.CO_ANNUAL_INCR, 'MM'), TO_CHAR(S.CO_HIRE_DATE, 'DD/MM/YYYY'), S.CO_CATEGORY, S.CO_POSITION_1, S.CO_POSITION_2, S.CO_ENABLED, ");
		sqlStr.append("       TO_CHAR(S.CO_TERMINATION_DATE, 'DD/MM/YYYY'), S.CO_CHI_NAME, S.CO_MARK_DELETED ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    S.CO_SITE_CODE = '");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
		}
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND    UPPER(TRIM(S.CO_STAFF_ID)) LIKE '%");
			sqlStr.append(staffID.trim().toUpperCase());
			sqlStr.append("%' ");
		}
		if (staffName != null && staffName.length() > 0) {
			sqlStr.append("AND    UPPER(TRIM(S.CO_STAFFNAME)) LIKE '%");
			sqlStr.append(staffName.trim().toUpperCase());
			sqlStr.append("%' ");
		}
		if ("A".equals(category)) {
		} else if ("".equals(category)) {
			sqlStr.append("AND  S.CO_CATEGORY IS NULL  ");
		} else if (category != null && category.length() > 0) {
			sqlStr.append("AND    S.CO_CATEGORY LIKE '%");
			sqlStr.append(category);
			sqlStr.append("%' ");
		}
		if (markdeleted != null && markdeleted.length() > 0) {
			sqlStr.append("AND    S.CO_MARK_DELETED = '");
			sqlStr.append(markdeleted.trim());
			sqlStr.append("' ");
		}
		if ("0".equals(enabled)) {
			sqlStr.append("AND    S.CO_ENABLED = 0 ");
		} else {
			sqlStr.append("AND    S.CO_ENABLED = 1 ");
		}
		sqlStr.append("ORDER BY S.CO_STAFF_ID");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getEducationList(UserBean userBean, String deptCode, String enable, String staffID) {
		return getEducationList(userBean, deptCode, enable, true, false, false, staffID);
	}

	public static ArrayList getCEList(UserBean userBean) {
		return getEducationList(userBean, null, "1", false, true, false, null);
	}

	public static ArrayList getOSHList(UserBean userBean) {
		return getEducationList(userBean, null, "1", false, false, true, null);
	}

	public static ArrayList getEducationList(UserBean userBean, String deptCode,
						String enable, boolean includeEducationManager, boolean isCE, boolean isOSH, String staffID) {

		if(staffID == null || staffID.isEmpty()) {
			if (!userBean.isManager()
					&& !userBean.isEducationManager()
					&& !userBean.isHRManager()
					&& !userBean.isAccessible("function.educationRecord.list.viewall")
					&& !userBean.isAccessible("function.hr.allcerecord.view")
					&& !userBean.isAccessible("function.osh.allimmurecord.view")
					&& !userBean.isAccessible("function.osh.allimmurecord.viewall")
					&& !userBean.isAccessible("function.educationRecord.list.viewdept")) {
				if (userBean.getDeptCode() != null) {
					staffID = userBean.getStaffID();
				}
				if (userBean.getDeptCode() != null && (deptCode == null || !isExistDeptCode(userBean, deptCode))) {
					// only show related department
					deptCode = userBean.getDeptCode();
				}
			}
		}

		if (userBean.isAccessible("function.osh.allimmurecord.viewall") && isOSH) {
			deptCode = null;
			ArrayList record = getList(ConstantsServerSide.SITE_CODE, deptCode, staffID, null, null, 1, enable);
			HashSet associatedDeptCode = userBean.getAssociatedDeptCode();
			associatedDeptCode.remove(deptCode);
			for (Iterator i = userBean.getAssociatedDeptCode().iterator(); i.hasNext(); ) {
				deptCode = (String) i.next();
				record.addAll(getList(ConstantsServerSide.SITE_CODE, deptCode, staffID, null, null, 1, enable));
			}
			return record;
		} else if (userBean.isAccessible("function.hr.allcerecord.view") && isCE) {
			deptCode = null;
			ArrayList record = getList(ConstantsServerSide.SITE_CODE, deptCode, staffID, null, null, 1, enable);
			HashSet associatedDeptCode = userBean.getAssociatedDeptCode();
			associatedDeptCode.remove(deptCode);
			for (Iterator i = userBean.getAssociatedDeptCode().iterator(); i.hasNext(); ) {
				deptCode = (String) i.next();
				record.addAll(getList(ConstantsServerSide.SITE_CODE, deptCode, staffID, null, null, 1, enable));
			}
			return record;
		} else if ((deptCode != null && deptCode.length() > 0) || (includeEducationManager && userBean.isEducationManager()) || userBean.isHRManager() || userBean.isAccessible("function.educationRecord.list.viewdept")) {
			HashSet associatedDeptCode = userBean.getAssociatedDeptCode();
			if (includeEducationManager && associatedDeptCode.size()>0 && userBean.isAccessible("function.educationRecord.list.viewdept")) {
				staffID =null;
			}

			if (userBean.getAssociatedDeptCode().contains("220") && "220".equals(deptCode)) {
				ArrayList allList = new ArrayList();
				allList.addAll(getList(ConstantsServerSide.SITE_CODE, deptCode, staffID, null, null, 1, enable));

				String[] staffIds = new String[]{"4201","3368","4384","5257","5300"};
				for (String staffId : staffIds) {
					ArrayList list1 = getList(ConstantsServerSide.SITE_CODE, new ArrayList<String>(), staffId, null,
							null, 1, enable);
					allList.addAll(list1);
				}

				return allList;
			} else {
				if (userBean.isAdmin() == false) {
					if (userBean.isAccessible("function.educationRecord.list.viewdept")) {
						String tempDeptCode = userBean.getDeptCode();
						System.out.println("[StaffDB] edu ce viewdept staff id=" + userBean.getStaffID() + ", deptCode="+deptCode+", tempDeptCode="+tempDeptCode);

						List<String> tempDeptCodes = new ArrayList<String>();
						for (Iterator i = userBean.getAssociatedDeptCode().iterator(); i.hasNext(); ) {
							String val = (String) i.next();
							System.out.println(" asso dept="+val);

							if(deptCode == null || "null".equals(deptCode) || (deptCode != null && deptCode.equals((val)))) {
								System.out.println("  add asso dept="+val);
								tempDeptCodes.add(val);
							}
						}

						if (!(deptCode == null || "null".equals(deptCode))) {
							if (deptCode.equals((tempDeptCode))) {
								System.out.println("  1 add tempDeptCode="+tempDeptCode);
								tempDeptCodes.add(tempDeptCode);
							}
							if (tempDeptCodes.isEmpty()) {
								System.out.println("  add No dept");
								tempDeptCodes.add("No dept");
							}
						} else {
							System.out.println("  2 add tempDeptCode="+tempDeptCode);
							tempDeptCodes.add(tempDeptCode);
						}

						return getList(ConstantsServerSide.SITE_CODE, tempDeptCodes, staffID, null, null, 2, enable);
						//return getList(ConstantsServerSide.SITE_CODE, userBean.getDeptCode(), staffID, null, null, 1, enable);
					}
				}
				if ( "all".equals(deptCode)) {
					deptCode = null;
				}
				return getList(ConstantsServerSide.SITE_CODE, deptCode, staffID, null, null, 1, enable);
			}
		} else {
			deptCode = userBean.getDeptCode();

			ArrayList record =  new ArrayList();
			// hardcode until Joe's staff change dept code to CS (220) 2015-09-23
			if ("4112".equals(userBean.getStaffID())) {
				ArrayList allList = new ArrayList();
				allList.addAll(getList(ConstantsServerSide.SITE_CODE, deptCode, staffID, null, null, 1, enable));

				String[] staffIds = new String[]{"4201","3368","4384","5257","5300"};
				for (String staffId : staffIds) {
					ArrayList list1 = getList(ConstantsServerSide.SITE_CODE, new ArrayList<String>(), staffId, null,
							null, 1, enable);
					allList.addAll(list1);
				}

				record.addAll(allList);
			} else {
				record.addAll(getList(ConstantsServerSide.SITE_CODE, deptCode, staffID, null, null, 1, enable));
			}

			HashSet associatedDeptCode = userBean.getAssociatedDeptCode();
			associatedDeptCode.remove(deptCode);
			for (Iterator i = userBean.getAssociatedDeptCode().iterator(); i.hasNext(); ) {
				deptCode = (String) i.next();
				record.addAll(getList(ConstantsServerSide.SITE_CODE, deptCode, staffID, null, null, 1, enable));
			}
			return record;
		}
	}

	public static ArrayList getNomineeList(String deptCode) {
		return getList(ConstantsServerSide.SITE_CODE, deptCode, null, null, null, 0);
	}

	public static ArrayList getList(String siteCode, String deptCode, String groupLevel) {
		return getList(siteCode, deptCode, null, null, groupLevel, 0);
	}

	public static ArrayList getList(String siteCode, String deptCode, String staffID, String staffName,
			String groupLevel) {
		return getList(siteCode, deptCode, null, null, groupLevel, 0,false);
	}

	public static ArrayList getList(String siteCode, String deptCode, String staffID, String staffName,
			String groupLevel, int sortBy) {
		return getList(siteCode, deptCode, null, null, groupLevel, sortBy,false);
	}

	public static ArrayList getList(String siteCode, String deptCode, String staffID, String staffName,
			String groupLevel, int sortBy, boolean onlyFT) {
		// fetch staff
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT S.CO_DEPARTMENT_CODE, DECODE(S.CO_DEPARTMENT_DESC, null, D.CO_DEPARTMENT_DESC, S.CO_DEPARTMENT_DESC), ");
		sqlStr.append("       S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_STATUS, ");
		sqlStr.append("       TO_CHAR(S.CO_ANNUAL_INCR, 'MM'), TO_CHAR(S.CO_HIRE_DATE,'MM/YYYY'), TO_CHAR(S.CO_HIRE_DATE,'DD/MM/YYYY'), ");
		sqlStr.append("       S.CO_DISPLAY_NAME, DECODE(S.CO_EMAIL, null, U.CO_EMAIL, S.CO_EMAIL), S.CO_DISPLAY_PHOTO ");
		if (groupLevel != null && groupLevel.length() > 0) {
			sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U, CO_GROUPS G ");
			sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
			sqlStr.append("AND    S.CO_SITE_CODE = U.CO_SITE_CODE ");
			sqlStr.append("AND    S.CO_STAFF_ID = U.CO_STAFF_ID ");
			sqlStr.append("AND    U.CO_GROUP_ID = G.CO_GROUP_ID ");
			sqlStr.append("AND    G.CO_GROUP_LEVEL <= '");
			sqlStr.append(groupLevel);
			sqlStr.append("' ");
		} else {
			sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U ");
			sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
			sqlStr.append("AND    S.CO_STAFF_ID = U.CO_STAFF_ID ");
		}
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    S.CO_SITE_CODE IN ('");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
			if (ConstantsServerSide.isHKAH() && deptCode.contains("421")) {
				sqlStr.append(", 'amc2'");
			}
			sqlStr.append(") ");
		}
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND    S.CO_STAFF_ID = '");
			sqlStr.append(staffID);
			sqlStr.append("' ");
		}
		if (staffName != null && staffName.length() > 0) {
			sqlStr.append("AND    S.CO_STAFFNAME LIKE '%");
			sqlStr.append(staffName);
			sqlStr.append("%' ");
		}
		if (onlyFT) {
			sqlStr.append("AND    S.CO_STATUS = 'FT' AND S.CO_MARK_DELETED IN ('B', 'N') ");
		}
		if (sortBy == 1) {
			sqlStr.append("ORDER BY S.CO_STAFF_ID, S.CO_DEPARTMENT_CODE, S.CO_STAFFNAME");
		} else if (sortBy == 2) {
			sqlStr.append("ORDER BY upper(co_display_name) ");
		} else if (sortBy == 3) {
			sqlStr.append("ORDER BY upper(CO_LASTNAME) ");
		} else {
			sqlStr.append("ORDER BY S.CO_STAFFNAME, S.CO_STAFF_ID");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getList(String siteCode, String deptCode, String staffID, String staffName,
			String groupLevel, int sortBy, String enable) {
		List<String> deptCodes = new ArrayList<String>();
		if (deptCode != null && deptCode.trim().length() > 0) {
			deptCodes.add(deptCode);
		}
		return getList(siteCode, deptCodes, staffID, staffName, groupLevel, sortBy, enable);
	}

	public static ArrayList getList(String siteCode, List<String> deptCodes, String staffID, String staffName,
			String groupLevel, int sortBy, String enable) {
		// fetch staff
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		if (ConstantsServerSide.isTWAH()) {
			sqlStr.append("       S.CO_STAFF_ID, S.CO_DISPLAY_NAME, S.CO_STATUS, ");
			sqlStr.append("       TO_CHAR(S.CO_ANNUAL_INCR, 'MM'),S.CO_JOB_CODE,S.CO_JOB_DESCRIPTION,TO_CHAR(S.CO_HIRE_DATE, 'DD/MM/YYYY') ");
		} else {
			sqlStr.append("       S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_STATUS, ");
			sqlStr.append("       TO_CHAR(S.CO_ANNUAL_INCR, 'MM'),TO_CHAR(S.CO_HIRE_DATE, 'MM/YYYY'),S.CO_POSITION_1||' '||S.CO_POSITION_2 ");
		}
		if (groupLevel != null && groupLevel.length() > 0) {
			sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U, CO_GROUPS G ");
			sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
			sqlStr.append("AND    S.CO_SITE_CODE = U.CO_SITE_CODE ");
			sqlStr.append("AND    S.CO_STAFF_ID = U.CO_STAFF_ID ");
			sqlStr.append("AND    U.CO_GROUP_ID = G.CO_GROUP_ID ");
			sqlStr.append("AND    G.CO_GROUP_LEVEL <= '");
			sqlStr.append(groupLevel);
			sqlStr.append("' ");
		} else {
			sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D ");
			sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		}
		if ("1".equals(enable)) {
			sqlStr.append("AND    S.CO_ENABLED = 1 ");
		} else if ("0".equals(enable)) {
			sqlStr.append("AND    S.CO_ENABLED = 0 ");
		}
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    S.CO_SITE_CODE IN ('");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
			if (ConstantsServerSide.isHKAH()) {
				if (deptCodes.contains("420")) {
					sqlStr.append(", 'amc1'");
				}
				if (deptCodes.contains("421")) {
					sqlStr.append(", 'amc2'");
				}
			}
			sqlStr.append(") ");
		}
		if (deptCodes != null && !deptCodes.isEmpty()) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE in ('");
			sqlStr.append(StringUtils.join(deptCodes, "','"));
			sqlStr.append("') ");
		}
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND    S.CO_STAFF_ID = '");
			sqlStr.append(staffID);
			sqlStr.append("' ");
		}
		if (staffName != null && staffName.length() > 0) {
			sqlStr.append("AND    S.CO_STAFFNAME LIKE '%");
			sqlStr.append(staffName);
			sqlStr.append("%' ");
		}
		// skip internal account
		sqlStr.append("AND CO_STAFF_ID NOT LIKE '9%' AND CO_STAFF_ID <> 'IPD' AND CO_STAFF_ID NOT LIKE 'DR%' ");
		if (sortBy == 1) {
			if (ConstantsServerSide.isTWAH()) {
				sqlStr.append("ORDER BY upper(S.co_display_name), S.CO_DEPARTMENT_CODE ");
			} else {
				sqlStr.append("ORDER BY S.CO_STAFF_ID, S.CO_DEPARTMENT_CODE, S.CO_STAFFNAME");
			}
		} else if (sortBy == 2) {
			sqlStr.append("ORDER BY S.CO_DEPARTMENT_CODE, S.CO_STAFF_ID");
		} else {
			sqlStr.append("ORDER BY S.CO_STAFFNAME, S.CO_STAFF_ID");
		}
		System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	// Get Depthead list
	public static ArrayList getdHeadList(String siteCode, String deptCode, String staffID, String staffName,
			String groupLevel, int sortBy, boolean onlyFT) {
		// fetch staff
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT distinct s.CO_DEPARTMENT_CODE, DECODE(S.CO_DEPARTMENT_DESC, null, D.CO_DEPARTMENT_DESC, S.CO_DEPARTMENT_DESC),        S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_STATUS,        TO_CHAR(S.CO_ANNUAL_INCR, 'MM'), TO_CHAR(S.CO_HIRE_DATE,'MM/YYYY'), TO_CHAR(S.CO_HIRE_DATE,'DD/MM/YYYY'),        S.CO_DISPLAY_NAME, DECODE(S.CO_EMAIL, null, U.CO_EMAIL, S.CO_EMAIL)  ");
		if (groupLevel != null && groupLevel.length() > 0) {
			sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U, CO_GROUPS G ");
			sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
			sqlStr.append("AND    S.CO_SITE_CODE = U.CO_SITE_CODE ");
			sqlStr.append("AND    S.CO_STAFF_ID = U.CO_STAFF_ID ");
			sqlStr.append("AND    U.CO_GROUP_ID = G.CO_GROUP_ID ");
			sqlStr.append("AND    G.CO_GROUP_LEVEL <= '");
			sqlStr.append(groupLevel);
			sqlStr.append("' ");
		} else {
			sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U ");
			//sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
			sqlStr.append("WHERE    S.CO_STAFF_ID = U.CO_STAFF_ID ");
		}
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    S.CO_SITE_CODE = '");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
		}
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND    S.CO_STAFF_ID = '");
			sqlStr.append(staffID);
			sqlStr.append("' ");
		}
		if (staffName != null && staffName.length() > 0) {
			sqlStr.append("AND    S.CO_STAFFNAME LIKE '%");
			sqlStr.append(staffName);
			sqlStr.append("%' ");
		}
		if (onlyFT) {
			sqlStr.append("AND    S.CO_STATUS in ('FT', 'FTW', 'MEDB') ");
		}
		sqlStr.append("AND    S.CO_STAFF_ID = D.CO_DEPARTMENT_HEAD ");

		if (sortBy == 1) {
			sqlStr.append("ORDER BY S.CO_STAFF_ID, S.CO_DEPARTMENT_CODE, S.CO_STAFFNAME");
		} else if (sortBy == 2) {
			sqlStr.append("ORDER BY upper(co_display_name) ");
		} else if (sortBy == 3) {
			sqlStr.append("ORDER BY upper(CO_LASTNAME) ");
		} else {
			if (ConstantsServerSide.isHKAH()) {
				sqlStr.append("ORDER BY S.CO_STAFFNAME, S.CO_STAFF_ID");
			} else {
				sqlStr.append("ORDER BY S.CO_DISPLAY_NAME, S.CO_STAFF_ID");
			}
			//sqlStr.append("ORDER BY S.CO_STAFFNAME, S.CO_STAFF_ID");
		}

		//System.out.println("getdHeadList sql="+sqlStr.toString());

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	// Get Depthead and Deptsubhead list
	public static ArrayList getdHeadSubHeadList(String siteCode, String deptCode, String staffID, String staffName,
			String groupLevel, int sortBy, boolean onlyFT) {
		// fetch staff
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT distinct s.CO_DEPARTMENT_CODE, DECODE(S.CO_DEPARTMENT_DESC, null, D.CO_DEPARTMENT_DESC, S.CO_DEPARTMENT_DESC),        S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_STATUS,        TO_CHAR(S.CO_ANNUAL_INCR, 'MM'), TO_CHAR(S.CO_HIRE_DATE,'MM/YYYY'), TO_CHAR(S.CO_HIRE_DATE,'DD/MM/YYYY'),        S.CO_DISPLAY_NAME, DECODE(S.CO_EMAIL, null, U.CO_EMAIL, S.CO_EMAIL)  ");
		if (groupLevel != null && groupLevel.length() > 0) {
			sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U, CO_GROUPS G ");
			sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
			sqlStr.append("AND    S.CO_SITE_CODE = U.CO_SITE_CODE ");
			sqlStr.append("AND    S.CO_STAFF_ID = U.CO_STAFF_ID ");
			sqlStr.append("AND    U.CO_GROUP_ID = G.CO_GROUP_ID ");
			sqlStr.append("AND    G.CO_GROUP_LEVEL <= '");
			sqlStr.append(groupLevel);
			sqlStr.append("' ");
		} else {
			sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U ");
			//sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
			sqlStr.append("WHERE    S.CO_STAFF_ID = U.CO_STAFF_ID ");
		}
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
/*	// comment because other sitecode dept head
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    S.CO_SITE_CODE = '");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
		}
*/
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND    S.CO_STAFF_ID = '");
			sqlStr.append(staffID);
			sqlStr.append("' ");
		}
		if (staffName != null && staffName.length() > 0) {
			sqlStr.append("AND    S.CO_STAFFNAME LIKE '%");
			sqlStr.append(staffName);
			sqlStr.append("%' ");
		}
		if (onlyFT) {
			sqlStr.append("AND    S.CO_STATUS in ('FT', 'FTW', 'MEDB') ");
		}
		sqlStr.append("AND    S.CO_STAFF_ID = D.CO_DEPARTMENT_HEAD ");

		if (sortBy == 1) {
			sqlStr.append("ORDER BY S.CO_STAFF_ID, S.CO_DEPARTMENT_CODE, S.CO_STAFFNAME");
		} else if (sortBy == 2) {
			sqlStr.append("ORDER BY upper(co_display_name) ");
		} else if (sortBy == 3) {
			sqlStr.append("ORDER BY upper(CO_LASTNAME) ");
		} else {
			if (ConstantsServerSide.isHKAH()) {
				//sqlStr.append("ORDER BY S.CO_STAFFNAME, S.CO_STAFF_ID");
			} else {
				//sqlStr.append("ORDER BY S.CO_DISPLAY_NAME, S.CO_STAFF_ID");
			}
			//sqlStr.append("ORDER BY S.CO_STAFFNAME, S.CO_STAFF_ID");
		}

		// get subhead
		sqlStr.append("UNION ");
		sqlStr.append("SELECT distinct s.CO_DEPARTMENT_CODE, DECODE(S.CO_DEPARTMENT_DESC, null, D.CO_DEPARTMENT_DESC, S.CO_DEPARTMENT_DESC),        S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_STATUS,        TO_CHAR(S.CO_ANNUAL_INCR, 'MM'), TO_CHAR(S.CO_HIRE_DATE,'MM/YYYY'), TO_CHAR(S.CO_HIRE_DATE,'DD/MM/YYYY'),        S.CO_DISPLAY_NAME, DECODE(S.CO_EMAIL, null, U.CO_EMAIL, S.CO_EMAIL)  ");
		if (groupLevel != null && groupLevel.length() > 0) {
			sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U, CO_GROUPS G ");
			sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
			sqlStr.append("AND    S.CO_SITE_CODE = U.CO_SITE_CODE ");
			sqlStr.append("AND    S.CO_STAFF_ID = U.CO_STAFF_ID ");
			sqlStr.append("AND    U.CO_GROUP_ID = G.CO_GROUP_ID ");
			sqlStr.append("AND    G.CO_GROUP_LEVEL <= '");
			sqlStr.append(groupLevel);
			sqlStr.append("' ");
		} else {
			sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U ");
			//sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
			sqlStr.append("WHERE    S.CO_STAFF_ID = U.CO_STAFF_ID ");
		}
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
/*	// comment because other sitecode dept head
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    S.CO_SITE_CODE = '");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
		}
*/
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND    S.CO_STAFF_ID = '");
			sqlStr.append(staffID);
			sqlStr.append("' ");
		}
		if (staffName != null && staffName.length() > 0) {
			sqlStr.append("AND    S.CO_STAFFNAME LIKE '%");
			sqlStr.append(staffName);
			sqlStr.append("%' ");
		}
		if (onlyFT) {
			sqlStr.append("AND    S.CO_STATUS in ('FT', 'FTW', 'MEDB') ");
		}
		sqlStr.append("AND    S.CO_STAFF_ID = D.CO_DEPARTMENT_SUBHEAD ");

		if (sortBy == 1) {
			sqlStr.append("ORDER BY S.CO_STAFF_ID, S.CO_DEPARTMENT_CODE, S.CO_STAFFNAME");
		} else if (sortBy == 2) {
			sqlStr.append("ORDER BY upper(co_display_name) ");
		} else if (sortBy == 3) {
			sqlStr.append("ORDER BY upper(CO_LASTNAME) ");
		} else {
			if (ConstantsServerSide.isHKAH()) {
				//sqlStr.append("ORDER BY S.CO_STAFFNAME, S.CO_STAFF_ID");
			} else {
				//sqlStr.append("ORDER BY S.CO_DISPLAY_NAME, S.CO_STAFF_ID");
			}
			//sqlStr.append("ORDER BY S.CO_STAFFNAME, S.CO_STAFF_ID");
		}

		//System.out.println("getdHeadList sql="+sqlStr.toString());
		if (ConstantsServerSide.isHKAH()) {
			sqlStr.append("ORDER BY CO_STAFFNAME, CO_STAFF_ID");
		} else {
			sqlStr.append("ORDER BY CO_DISPLAY_NAME, CO_STAFF_ID");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getDeptCodeList(String deptCode) {
		// fetch staff
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM   CO_DEPARTMENTS D, ");
		sqlStr.append("(SELECT CO_DEPARTMENT_CODE, CO_ENABLED FROM CO_STAFFS UNION SELECT CO_DEPARTMENT_CODE, CO_ENABLED FROM CO_STAFF_DEPARTMENTS) S ");
		sqlStr.append("WHERE S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND S.CO_ENABLED = 1 ");
		sqlStr.append("AND D.CO_ENABLED = 1 ");
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		sqlStr.append("GROUP BY S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC ");
		sqlStr.append("ORDER BY D.CO_DEPARTMENT_DESC");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getDeptCodeListWithCode(String deptCode) {
		// fetch staff
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT X.CO_DEPARTMENT_CODE, X.CO_DEPARTMENT_DESC||' - '||X.CO_DEPARTMENT_CODE FROM (");
		sqlStr.append("SELECT S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM   CO_DEPARTMENTS D, ");
		sqlStr.append("(SELECT CO_DEPARTMENT_CODE, CO_ENABLED FROM CO_STAFFS UNION SELECT CO_DEPARTMENT_CODE, CO_ENABLED FROM CO_STAFF_DEPARTMENTS) S ");
		sqlStr.append("WHERE S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND S.CO_ENABLED = 1 ");
		sqlStr.append("AND D.CO_ENABLED = 1 ");
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		sqlStr.append("GROUP BY S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC) X ");
		sqlStr.append("ORDER BY X.CO_DEPARTMENT_DESC");
		System.err.println("[sqlStr.toString()]:"+sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean isExistDeptCode(UserBean userBean, String deptCode) {
		if (deptCode.equals(userBean.getDeptCode())) {
			return true;
		} else {
			// fetch staff
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT 1 ");
			sqlStr.append("FROM   CO_STAFF_DEPARTMENTS ");
			sqlStr.append("WHERE  CO_ENABLED = 1 ");
			sqlStr.append("AND    CO_STAFF_ID = ? ");
			sqlStr.append("AND    CO_DEPARTMENT_CODE = ? ");

			return UtilDBWeb.isExist(sqlStr.toString(), new String[] { userBean.getStaffID(), deptCode });
		}
	}

	public static ArrayList getDeptCode2List(String staffID) {
		// fetch staff
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM   CO_STAFF_DEPARTMENTS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_ENABLED = D.CO_ENABLED ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND    S.CO_STAFF_ID = '");
			sqlStr.append(staffID);
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY D.CO_DEPARTMENT_DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getDeptCode2ListWithCode(String staffID) {
		// fetch staff
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC||'-'||D.CO_DEPARTMENT_CODE ");
		sqlStr.append("FROM   CO_STAFF_DEPARTMENTS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_ENABLED = D.CO_ENABLED ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND    S.CO_STAFF_ID = '");
			sqlStr.append(staffID);
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY D.CO_DEPARTMENT_DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getCompulsory(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_EVENT_ID, CO_EVENT_DESC, CO_EVENT_TYPE ");
		sqlStr.append("FROM   CO_EVENT ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = 'education' ");
		sqlStr.append("AND    CO_EVENT_CATEGORY = 'compulsory' ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_EVENT_ID NOT IN ( ");
		sqlStr.append("       SELECT CO_EVENT_ID ");
		sqlStr.append("       FROM   CO_ENROLLMENT ");
		sqlStr.append("       WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("       AND    CO_MODULE_CODE = 'education' ");
		sqlStr.append("       AND    CO_USER_TYPE = 'staff' ");
		sqlStr.append("       AND    CO_USER_ID = ? ");
		sqlStr.append("       AND    CO_ENABLED = 1 ");
		sqlStr.append(")");
		sqlStr.append("ORDER BY CO_EVENT_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID });
	}

	public static ArrayList getEducationRecord(
			String courseCategory, String dateFrom, String dateTo) {
		// fetch course
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_EVENT_ID, CO_EVENT_DESC, CO_EVENT_SHORT_DESC ");
		sqlStr.append("FROM   CO_EVENT ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = 'education' ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		if (courseCategory != null && courseCategory.length() > 0) {
			sqlStr.append("AND    CO_EVENT_CATEGORY = '");
			sqlStr.append(courseCategory);
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY CO_EVENT_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String getEventID(
			String moduleCode,
			String eventDesc) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_EVENT_ID ");
		sqlStr.append("FROM   CO_EVENT ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_DESC = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode, eventDesc });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	public static String getPosition(String id) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_POSITION_1, CO_POSITION_2, CO_JOB_DESCRIPTION  ");
		sqlStr.append("FROM   CO_STAFFS ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_STAFF_ID = ? ");
		//sqlStr.append("AND    CO_ENABLED = 1 ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { id });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			if (rlo.getFields0().length() > 0) {
				return rlo.getFields0() + " " + rlo.getFields1();
			} else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(ConstantsServerSide.SITE_CODE)) {
				return rlo.getFields2();
			} else {
				return rlo.getFields1();
			}
		} else {
			return null;
		}
	}

	public static String getCategory(String id) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_CATEGORY  ");
		sqlStr.append("FROM   CO_STAFFS ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_STAFF_ID = ? ");
		//sqlStr.append("AND    CO_ENABLED = 1 ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { id });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}
	public static String getEduCategory(String staffID) {
		String position = getPosition(staffID);
		String deptCode = StaffDB.getDeptCode(staffID);
		StringBuffer sqlStr = new StringBuffer();
		StringBuffer sqlStr1 = new StringBuffer();
		String category = null;
		String siteCode = null;
		if (position!= null && position.length()> 0) {
			sqlStr.append("SELECT CO_EVENT_ID,CO_SITE_CODE,CO_REMARKS ");
			sqlStr.append(" FROM CO_DEPARTMENT_EVENT ");
			sqlStr.append(" WHERE CO_REMARKS like '%"+position.trim()+"%'");
			sqlStr.append(" AND CO_DEPARTMENT_CODE='"+deptCode+"' ");
			sqlStr.append(" AND CO_MODULE_CODE='staffCat'");

			sqlStr1.append("SELECT CO_EVENT_ID,CO_SITE_CODE ");
			sqlStr1.append(" FROM CO_DEPARTMENT_EVENT ");
			sqlStr1.append(" WHERE CO_DEPARTMENT_CODE='"+deptCode+"' ");
			sqlStr1.append(" AND CO_REMARKS is null ");
			sqlStr1.append(" AND CO_MODULE_CODE='staffCat' ");

			ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
			ArrayList result1 = UtilDBWeb.getReportableList(sqlStr1.toString());
			if (result.size() > 0) {
				ReportableListObject rlo = (ReportableListObject) result.get(0);
				category = rlo.getValue(0);
				siteCode = rlo.getValue(1);
			} else if (result1.size()>0) {
				ReportableListObject rlo = (ReportableListObject) result1.get(0);
				category = rlo.getValue(0);
				siteCode = rlo.getValue(1);
			}
			if ("6338".equals(category)) {
				return "Nursing";
			} else if ("6339".equals(category)) {
				return "Allied Health";
			} else if ("6340".equals(category)) {
				return "Ancillary";
			} else if ("6341".equals(category)) {
				return "Others";
			} else if ("6342".equals(category)) {
				if("twah".equals(siteCode)) {
					return "Outsider / Dr / SR";
				}else{
					return "Outsider / Dr / TW";
				}
			} else if ("6343".equals(category)) {
				return "Nursing School / Student";
			} else if ("6344".equals(category)) {
				return "Contractor Staff";
			} else if ("6345".equals(category)) {
				return "Volunteer / Intern";
			} else {
				return "Others";
			}
		}
		return null;
	}

	public static boolean atLeastOneYearAndFullTime(String staffID) {
		String date = (new SimpleDateFormat("dd/mm/yyyy")).format(new java.util.Date());
		return UtilDBWeb.isExist(sqlStr_atLeastOneYearStaff, new String[] { date, staffID } );
	}

	public static boolean atLeastOneYearAndFullTime(String staffID, String date) {
		return UtilDBWeb.isExist(sqlStr_atLeastOneYearStaff, new String[] { date, staffID } );
	}

	public static boolean isExist(String staffID) {
		return UtilDBWeb.isExist(sqlStr_isExistStaff, new String[] { staffID } );
	}
	
	public static boolean isExistActive(String staffID) {
		return UtilDBWeb.isExist(sqlStr_isExistActiveStaff, new String[] { staffID } );
	}

	public static boolean isExist(String siteCode, String staffID) {
		return UtilDBWeb.isExist(sqlStr_isExistSiteStaff, new String[] { siteCode, staffID } );
	}

	public static boolean isInProbationForEL(String siteCode, String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM EL_EMPLOYEE ");
		sqlStr.append("WHERE EL_STATUS='FC' AND EL_ENABLED = 1 AND add_months(EL_HIRE_DATE,3) > SYSDATE" );
		sqlStr.append(" AND EL_STAFF_ID = '"+staffID+"'" );

		return UtilDBWeb.isExist(sqlStr.toString());
	}

	public static boolean isInLastMonthOfTerminationForEL(String siteCode, String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM EL_EMPLOYEE ");
		sqlStr.append("WHERE EL_STATUS='FC' AND EL_ENABLED = 1 AND EL_TERMINATION_DATE IS NOT NULL AND sysdate >= add_months(EL_TERMINATION_DATE,-1) " );
		sqlStr.append(" AND EL_STAFF_ID = '"+staffID+"'" );

		return UtilDBWeb.isExist(sqlStr.toString());
	}

	public static String getStaffName(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_STAFFNAME ");
		sqlStr.append("FROM   CO_STAFFS ");
		sqlStr.append("WHERE  CO_STAFF_ID = ? ");
		//sqlStr.append("AND    CO_ENABLED = 1 ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	public static String getStaffEmail(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DECODE(S.CO_EMAIL, null, U.CO_EMAIL, S.CO_EMAIL) ");
		sqlStr.append("FROM CO_USERS U, CO_STAFFS S ");
		sqlStr.append("WHERE 	S.CO_SITE_CODE = U.CO_SITE_CODE ");
		sqlStr.append("AND    S.CO_STAFF_ID = U.CO_STAFF_ID ");
		sqlStr.append("AND    S.CO_STAFF_ID = ? ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getValue(0);
		} else {
			return null;
		}
	}

	public static String getStaffFullName(String loginID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_FIRSTNAME||', '||CO_LASTNAME ");
		sqlStr.append("FROM   CO_USERS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_USERNAME = ? ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { loginID });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	public static String getStaffFullName2(String loginID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT DECODE(Trim(CS.CO_FIRSTNAME)||', '||Trim(CS.CO_LASTNAME),', ',CS.CO_STAFFNAME,Trim(CS.CO_FIRSTNAME)||', '||Trim(CS.CO_LASTNAME)) ");
		sqlStr.append("FROM   CO_STAFFS CS, CO_USERS CU ");
		sqlStr.append("WHERE CU.CO_STAFF_ID = CS.CO_STAFF_ID AND ? IN (CU.CO_USERNAME, CU.CO_STAFF_ID) AND CU.CO_GROUP_ID <> 'guest'");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { loginID});
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	public static String getDeptCode(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_CODE ");
		sqlStr.append("FROM   CO_STAFFS ");
		sqlStr.append("WHERE  CO_STAFF_ID = ? ");
		//sqlStr.append("AND	  CO_ENABLED = 1 ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	public static String getStaffSiteCode(String loginID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_SITE_CODE ");
		sqlStr.append("FROM   CO_USERS ");
		sqlStr.append("WHERE  CO_USERNAME = ? ");
		sqlStr.append("AND	  CO_ENABLED = 1 ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { loginID });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}
	
	public static ArrayList getStaffOtherSite(String staffID, String siteCode) {
		return UtilDBWeb.getReportableList(sqlStr_getStaffOtherSite.replace("<DBLINK>", 
				ConstantsServerSide.getDBLinkPortal(siteCode)), new String[] { staffID });
	}

	public static ArrayList getStaffNameDeptByEmail(String email) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT S.CO_STAFFNAME,S.CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM CO_STAFFS S,CO_DEPARTMENTS D , CO_USERS U ");
		sqlStr.append("WHERE S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND   S.CO_STAFF_ID = U.CO_STAFF_ID ");
		sqlStr.append("AND   U.CO_EMAIL = '"+email+"' ");
		//System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean isDeptHead(String staffID, String deptCode) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM CO_DEPARTMENTS ");
		sqlStr.append("WHERE CO_DEPARTMENT_CODE = '"+deptCode+"' ");
		sqlStr.append("AND CO_DEPARTMENT_HEAD = '"+staffID+"' ");

		return UtilDBWeb.isExist(sqlStr.toString());
	}

	public static ArrayList getPositionList(String positionCode, Boolean isNursing) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_POSITION_CODE, CO_POSITION_NAME, CO_IS_NURSING, CO_CREATED_DATE, CO_CREATED_USER, CO_MODIFIED_DATE, CO_MODIFIED_USER ");
		sqlStr.append("FROM   CO_POSITION ");
		sqlStr.append("WHERE    CO_ENABLED = 1 ");
		if (positionCode != null && positionCode.length() > 0) {
			sqlStr.append("AND    CO_POSITION_CODE = '");
			sqlStr.append(positionCode);
			sqlStr.append("' ");
		}
		if (isNursing != null) {
			sqlStr.append("AND    CO_IS_NURSING = '");
			sqlStr.append(isNursing ? "Y" : "N");
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY CO_POSITION_CODE ");

		//System.out.println("[getPositionList] sqlStr.toString()="+sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean updateStaffIfChanged(String siteCode, String staffID, String staffName, String surname, String givenName,
			String displayName, String chiName,
			String fte, String positionCode, String positionName, String hospitalNo,
			String dateOfAvailability, String resignationDate) {
		String status = hrFTE2Status(fte);

		// update staff info except department code
		//System.out.println(" staffID="+staffID+", sqlStr_updateStaffIfChanged="+sqlStr_updateStaffIfChanged);

		boolean ret = UtilDBWeb.updateQueue(
				sqlStr_updateStaffIfChanged,
				new String[] {
						staffName,	// CO_STAFFNAME
						displayName,	// CO_DISPLAY_NAME
						surname,	// CO_LASTNAME
						givenName,	// CO_FIRSTNAME
						chiName,
						status,	// CO_STATUS
						positionCode,	// CO_POSITION_CODE
						positionName,	// CO_POSITION_1
						null,	// CO_POSITION_2
						hospitalNo,					// CO_HOSP_NO
						dateOfAvailability,					// CO_HIRE_DATE
						resignationDate, 					// CO_TERMINATION_DATE

						"SYSTEM",
						siteCode,
						staffID,

						staffName,	// CO_STAFFNAME
						displayName,	// CO_DISPLAY_NAME
						surname,	// CO_LASTNAME
						givenName,	// CO_FIRSTNAME
						chiName,
						status, // CO_STATUS
						positionCode,	// CO_POSITION_CODE
						positionName,	// CO_POSITION_1
						null,	// CO_POSITION_2
						hospitalNo,				// CO_HOSP_NO
						dateOfAvailability,				// CO_HIRE_DATE
						resignationDate,					// CO_TERMINATION_DATE
				} );
		
		//System.out.println(" staffID="+staffID+", ret="+ret);
		
		return ret;
	}

	public static void update() {
		if (ConstantsServerSide.isTWAH()) {
			updateTWAH();
		} else if (ConstantsServerSide.isHKAH()) {
			updateHKAH();
			updateAMC1();
			updateAMC2();
		}
		
		if (ConstantsServerSide.isHKAH() || ConstantsServerSide.isTWAH()) {
			updateDept();
			updateMarkDelete();
		}
	}

	public static void updateHKAH() {
		System.out.println(new Date() + " [StaffDB] updateHKAH");

		try {
		   ArrayList result = UtilDBWeb.getReportableList(sqlStr_selectHRStaff, new String[]{null, null});
		   ReportableListObject rlo = null;

		   System.out.println("COL staff result size="+result.size());
		   if (result.size() > 0) {
			   StringBuffer emailStr = new StringBuffer();
			   
			   // reset all staff status
			   // UtilDBWeb.updateQueue(sqlStr_resetStaff, new String[] { ConstantsServerSide.SITE_CODE });

			   String siteCode = null;
			   String staffCode = null;
			   String name = null;
			   String staffName = null;
			   String surname = null;
			   String givenName = null;
			   String chinFullName = null;
			   String calledName = null;
			   String hospitalNo = null;
			   String deptCodeHR = null;
			   String deptCode = null;
			   String deptDescription = null;
			   String positionCode = null;
			   String positionName = null;
			   String fte = null;
			   String dateOfAvailability = null;
			   String resignationDate = null;
			   String staffType = null;
			   String formerEmpNo = null;
			   String emailAddress = null;
			   
			   String staffEnabled = null;
			   String staffStatus = null;
			   String givenNameInShort = null;
			   String[] givenNameSplit = null;
			   String jobStatus = null;
			   String displayName = null;

			   DateFormat coHireDateFormat = new SimpleDateFormat("dd/MM/yyyy");
			   Date dateOfAvailabilityDate = null;
			   int j = 0;
			   List<String> hrStaffIDs = new ArrayList<String>();
			   
			   for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);
					j = 0;

					staffCode = rlo.getValue(j++);
					name = rlo.getValue(j++);
					surname = TextUtil.parseStr(rlo.getValue(j++));
					givenName = TextUtil.parseStr(rlo.getValue(j++));
					chinFullName = TextUtil.parseStr(rlo.getValue(j++));
					calledName = TextUtil.parseStr(rlo.getValue(j++));
					hospitalNo = TextUtil.parseStr(rlo.getValue(j++));
					deptCodeHR = TextUtil.parseStr(rlo.getValue(j++));
					deptCode = DepartmentDB.getPortalDeptCodeByHRDeptCode(deptCodeHR, ConstantsServerSide.SITE_CODE_HKAH, true);
					deptDescription = TextUtil.parseStr(rlo.getValue(j++));
					positionCode = TextUtil.parseStr(rlo.getValue(j++));
					positionName = TextUtil.parseStr(rlo.getValue(j++));
					fte = TextUtil.parseStr(rlo.getValue(j++));
					dateOfAvailability = TextUtil.parseStr(rlo.getValue(j++));
					if (dateOfAvailability != null && !dateOfAvailability.isEmpty()) {
						dateOfAvailabilityDate = DateTimeUtil.parseDate(dateOfAvailability);
					}
					resignationDate = TextUtil.parseStr(rlo.getValue(j++));
					staffType = TextUtil.parseStr(rlo.getValue(j++));
					staffStatus = hrFTE2Status(fte);
					formerEmpNo = TextUtil.parseStr(rlo.getValue(j++));
					emailAddress = TextUtil.parseStr(rlo.getValue(j++));

				 	givenNameSplit = (givenName != null) ? givenName.split(" ") : null;
					givenNameInShort = "";
					if (givenNameSplit != null && givenNameSplit.length > 0) {
						for (String thisName : givenNameSplit) {
							if (thisName != null && !"".equals(thisName)) {
								if (!"".equals(givenNameInShort))
									givenNameInShort += " ";
								givenNameInShort += thisName.length() > 0 ? thisName.substring(0, 1).toUpperCase() : "";
							}
						}
					}
					staffName = getStaffNameFromHR(name, surname, givenName, calledName);
					displayName = getDisplayNameFromHR(name, surname, givenName, calledName);
					staffEnabled = (resignationDate == null || resignationDate.isEmpty()) ? "1" : (DateTimeUtil.compareTo(resignationDate, DateTimeUtil.getCurrentDate()) >= 1 ? "1" : "0");
					siteCode = DepartmentDB.getSiteCodeByDept(deptCode);
					
					/*
					System.out.println("COL:" + siteCode + ", " + staffCode + ", " + displayName + ", " + staffName + ", " + surname + ", " + givenName + ", "  + chinFullName + ", " + calledName + ", " +
							hospitalNo + ", " + ", " + deptCodeHR + ", " + deptCode + ", " + deptDescription + ", " + 
							positionCode + ", " + positionName + ", " + fte + ", " + dateOfAvailability + ", " + resignationDate + ", " +
							staffType + ", " + staffStatus + ", " + formerEmpNo + ", " + emailAddress + ", " + staffEnabled);
					*/
					
					// if cannot map deptcode
					if (deptCode == null) {
						System.out.println("   No deptcode mapping staff ID: " + staffCode + ", deptCode HR: " + deptCodeHR);
						deptCode = deptCodeHR;
					}
					hrStaffIDs.add(staffCode);
					
					// System.out.println(" Staff ID (" + staffCode + "): " + isExist(ConstantsServerSide.SITE_CODE_HKAH, staffCode));
					
					if (isExist(ConstantsServerSide.SITE_CODE_HKAH, staffCode) ||
							isExist(ConstantsServerSide.SITE_CODE_AMC1, staffCode) ||
							isExist(ConstantsServerSide.SITE_CODE_AMC2, staffCode)) {
						// update staff info except department code
						if (updateStaffIfChanged(siteCode, staffCode, staffName, surname, givenName, displayName, chinFullName, fte,
								positionCode, positionName, hospitalNo,
								dateOfAvailability, resignationDate)) {
							// update department code if not fix department
							//System.out.println(" update sqlStr_updateDeptCode if not fix");

							UtilDBWeb.updateQueue(
									sqlStr_updateDeptCode,
									new String[] {
											DepartmentDB.getPortalDeptCodeByHRDeptCode(deptCode, ConstantsServerSide.SITE_CODE),	// CO_DEPARTMENT_CODE
											deptDescription,		// CO_DEPARTMENT_DESC
											ConstantsServerSide.SITE_CODE,
											staffCode
									} );
							System.out.println("   Update staff ID: " + staffCode);
						}
					} else {
						if (!UtilDBWeb.updateQueue(
								sqlStr_insertStaffFromHR,
								new String[] {
										siteCode,
										staffCode,
										staffName,
										surname,
										givenName,
										deptCode,
										deptDescription,
										emailAddress,
										coHireDateFormat.format(dateOfAvailabilityDate),
										staffEnabled,
										positionCode,
										positionName,
										jobStatus,
										displayName
								} )) {
							System.out.println("   Cannot insert staff ID: " + staffCode);
						} else {
							System.out.println("   Insert new staff ID: " + staffCode);
						}
					}
					
					if (!UserDB.isExistByStaffID(staffCode) && "1".equals(staffEnabled)) {
						// create user in co_user table
						UserDB.add(siteCode, staffCode, PasswordUtil.cisEncryption("123456"), staffCode);
					}

					// TW only
					/*
					if (positionCode != null && positionCode.length() > 0 && !isExistsByJobCode(positionCode)) {
						emailStr.append(sendEmailNotifyNewJobCodeHelper(i + 1, positionCode, positionName, staffCode, staffName));
					}
					*/
				}

				terminateStaffs(null, true);
				if (ConstantsServerSide.isAMC1() || ConstantsServerSide.isAMC2()) {
					terminateStaffsAMC(null, true, ConstantsServerSide.SITE_CODE);
				}
				hireStaffs(null, true);

				disableNotExistStaffs(hrStaffIDs);
			} else {
				System.out.println("[StaffDB] updateHKAH hr staff list is empty");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void updateDept() {
		System.out.println(new Date() + " [StaffDB] updateDept");
		
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_selectHRDept);
		ReportableListObject rlo = null;

		System.out.println(" COL dept result size="+result.size());
		try {
			if (result.size() > 0) {
				String deptCode = null;
				String deptName = null;

				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					deptCode = rlo.getValue(0);
					deptName = rlo.getValue(1);

					DepartmentDB.syncDept(deptCode, deptName, true);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void updateAMC1() {
		System.out.println(new Date() + " [StaffDB] updateAMC1");

		try {
			ArrayList result = UtilDBWeb.getReportableList(sqlStr_getNewStaffIDAMC1);
			ReportableListObject rlo = null;

			if (result.size() > 0) {
				String staffID = null;
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);
					staffID = rlo.getValue(0);
					String record = UtilDBWeb.callFunction("HAT_ACT_STAFF_AMC1", "ADD", new String[] { staffID });

					System.out.println("Add staff to AMC1: " + staffID + ", return:" + record);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void updateAMC2() {
		System.out.println(new Date() + " [StaffDB] updateAMC2");

		try {
			ArrayList result = UtilDBWeb.getReportableList(sqlStr_getNewStaffIDAMC2);
			ReportableListObject rlo = null;

			if (result.size() > 0) {
				String staffID = null;
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);
					staffID = rlo.getValue(0);
					String record = UtilDBWeb.callFunction("HAT_ACT_STAFF_AMC2", "ADD", new String[] { staffID });

					System.out.println("Add staff to AMC2: " + staffID + ", return:" + record);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/*
	public static void verifyHKAHStaff() {
		System.out.println(new Date() + " [StaffDB] verifyHKAHStaff");

		String staffViewUserName = "sync_person_view_4IT";
		String staffViewPassword = "P@ssw0rd4ITSync";
		String staffViewTableName = "sync_person_view_4IT";
		String staffViewCols = "[Person_Code],[Dept_Code]";
		String staffViewOrderByCols = "[Person_Code]";

		try {
			List<ReportableListObject> result = getSqlServerReportableListObject(
					staffViewUserName, staffViewPassword, staffViewCols, staffViewTableName, null, staffViewOrderByCols);
			ReportableListObject rlo = null;

			if (result.size() > 0) {
				String staffID = null;
				String deptCode = null;

				Map<String, String> staffPortalDeptCodes = new HashMap<String, String>();
				Map<String, String> staffHRDeptCodes = new HashMap<String, String>();

				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					staffID = rlo.getValue(0);
					deptCode = rlo.getValue(1);

					if (StaffDB.isExist(staffID)) {
						ArrayList staff = StaffDB.get(staffID);
						if (staff != null && staff.size() > 0) {
							ReportableListObject rlo2 = (ReportableListObject) staff.get(0);

							if (rlo2 != null) {
								String curDeptCode = rlo2.getValue(1);
								String isFixDeptCode = rlo2.getValue(12);

								if (!ConstantsVariable.YES_VALUE.equals(isFixDeptCode)) {
									staffPortalDeptCodes.put(staffID, curDeptCode);
									staffHRDeptCodes.put(staffID, deptCode);
								}
							}
						}
					}
				}

				// alert portal admin if staff department has changed (except rachel account)
				if (!ConstantsServerSide.SECURE_SERVER) {
					alertUpdateStaffDeptCodeConflict(staffPortalDeptCodes, staffHRDeptCodes);
					alertUpdateStaffDeptCodeConflictEwell(staffPortalDeptCodes, staffHRDeptCodes);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static boolean alertUpdateStaffDeptCodeConflictEwell(
			Map<String, String> staffPortalDeptCodes, Map<String, String> staffHRDeptCodes) {
		StringBuffer staffDeptCodeChange = new StringBuffer();
		String BodyMessage = null;
		StringBuffer message = new StringBuffer();

		//staffHRDeptCodes.put("1014", "720");

		try {
			Set<String> key = staffPortalDeptCodes.keySet();
			Iterator<String> it = key.iterator();
			int i = 1;
			while (it.hasNext()) {
				String staffId = it.next();
				String curDeptCode = staffPortalDeptCodes.get(staffId);
				String hrDeptCode = staffHRDeptCodes.get(staffId);
				String hrDeptDesc = null;

				if (!curDeptCode.equals(hrDeptCode)) {
					// get dept desc of hr dept code
					String sqlhr = "SELECT CO_DEPARTMENT_DESC FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_CODE = ?";
					ArrayList resulthr = UtilDBWeb.getReportableList(sqlhr, new String[]{hrDeptCode});
					ReportableListObject rowhr = (ReportableListObject) resulthr.get(0);
					hrDeptDesc = rowhr.getValue(0);

					//String staffId = itr.next();
					String sql = "SELECT CO_DEPARTMENT_CODE, CO_DEPARTMENT_DESC, CO_STAFFNAME, " +
							" CO_POSITION_1, CO_POSITION_2, TO_CHAR(CO_MODIFIED_DATE, 'dd/mm/yyyy hh24:mi:ss')" +
							" FROM CO_STAFFS WHERE CO_SITE_CODE = ? AND CO_STAFF_ID = ?";
					ArrayList result = UtilDBWeb.getReportableList(sql, new String[]{ConstantsServerSide.SITE_CODE.toLowerCase(), staffId});
					if (result != null && !result.isEmpty()) {
						ReportableListObject row = (ReportableListObject) result.get(0);
						String staffName = row.getValue(2);
						String deptCode = row.getValue(0);
						String deptDesc = row.getValue(1);
						String posDesc1 = row.getValue(3);
						String posDesc2 = row.getValue(4);
						String lastModifiedDate = row.getValue(5);

						String posDescStr = "";
						if (posDesc1 != null && !"".equals(posDesc1)) {
							posDescStr += posDesc1;
						}
						if (posDesc2 != null && !"".equals(posDesc2)) {
							if (posDescStr.length() > 0) {
								posDescStr += ", ";
							}
							posDescStr += posDesc2;
						}

						if (SsoUserDB.alertPosDesc.contains(posDesc1) || SsoUserDB.alertPosDesc.contains(posDesc2)) {
							staffDeptCodeChange.append("<tr>");
							staffDeptCodeChange.append("<td style='font-size:18px;text-align:left;background-color:#FFE9E9'>" + staffId + "</td>");
							staffDeptCodeChange.append("<td style='font-size:18px;text-align:left;background-color:#FFE9E9'>" + staffName + "</td>");
							staffDeptCodeChange.append("<td style='font-size:18px;text-align:left;background-color:#FFE9E9'>" + deptDesc + " (" + deptCode + ")" + "</td>");
							staffDeptCodeChange.append("<td style='font-size:18px;text-align:left;background-color:#FFE9E9'>" + hrDeptDesc + " (" + hrDeptCode + ")" + "</td>");
							staffDeptCodeChange.append("<td style='font-size:18px;text-align:left;background-color:#FFE9E9'>" + posDescStr + "</td>");
							staffDeptCodeChange.append("<td style='font-size:18px;text-align:left;background-color:#FFE9E9'>" + lastModifiedDate + "</td>");
							staffDeptCodeChange.append("</tr>");

						}
					}

					//staffDeptCodeChange.append("<tr><td>" + i + "</td><td>" + staffId + "</td><td>" + curDeptCode + "</td><td>" + hrDeptCode + "</td></tr>");
				}
				i++;
			}

			if (staffDeptCodeChange.length() > 0) {

				message.append("<p>The follow staff(s) using Ewell in the Intranet Portal have department code different from HR access system:</p>");
				message.append("<p>Please check the data immediately.</p>");
				message.append("<table border=\"1\">");
				message.append("<tr><td>Staff ID</td><td>Staff Name</td><td>Dept Code (Portal)</td><td>Dept Code (HR)</td><td>Pos Desc (Portal)</td><td>last Modified Date</td></tr>");
				message.append(staffDeptCodeChange.toString());
				message.append("</table>");

				return EmailAlertDB.sendEmail("toy", "Intranet Portal alert - staff department conflict (Ewell User)", message.toString());
			}
		} catch (Exception e) {
			System.err.println("[" + new Date() + "]" + "Error: Cannot send mail alert for staff department conflict");
		}
		return false;
	}


	public static boolean alertUpdateStaffDeptCodeConflict(
			Map<String, String> staffPortalDeptCodes, Map<String, String> staffHRDeptCodes) {
		StringBuffer staffDeptCodeChange = new StringBuffer();

		try {
			Set<String> key = staffPortalDeptCodes.keySet();
			Iterator<String> it = key.iterator();
			int i = 1;
			while (it.hasNext()) {
				String staffId = it.next();
				String curDeptCode = staffPortalDeptCodes.get(staffId);
				String hrDeptCode = staffHRDeptCodes.get(staffId);
				if (!curDeptCode.equals(hrDeptCode)) {
					staffDeptCodeChange.append("<tr><td>" + i + "</td><td>" + staffId + "</td><td>" + curDeptCode + "</td><td>" + hrDeptCode + "</td></tr>");
				}
				i++;
			}

			if (staffDeptCodeChange.length() > 0) {
				StringBuffer message = new StringBuffer();
				message.append("<p>The follow staff(s) in the Intranet Portal have department code different from HR access system:</p>");
				message.append("<p>Please check the data immediately.</p>");
				message.append("<table border=\"1\">");
				message.append("<tr><td></td><td>Staff ID</td><td>Dept Code (Portal)</td><td>Dept Code (HR)</td></tr>");
				message.append(staffDeptCodeChange.toString());
				message.append("</table>");

				return EmailAlertDB.sendEmail("admin", "Intranet Portal alert - staff department conflict", message.toString());
			}
		} catch (Exception e) {
			System.err.println("[" + new Date() + "]" + "Error: Cannot send mail alert for staff department conflict");
		}
		return false;
	}
	*/

	public static ArrayList getManager(String deptCode) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT S.CO_STAFFNAME, U.CO_EMAIL ");
		sqlStr.append("FROM CO_STAFFS S, CO_USERS U ");
		sqlStr.append("WHERE S.CO_SITE_CODE = U.CO_SITE_CODE ");
		sqlStr.append("AND   U.CO_ENABLED = 1 ");
		sqlStr.append("AND   S.CO_STAFF_ID = U.CO_STAFF_ID ");
		sqlStr.append("AND   S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
		sqlStr.append("AND   U.CO_GROUP_ID = 'manager' ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String getStaffNameFromHR(String staffName, String surname, String givenName, String callName) {
		String ret = "";
		if (ConstantsServerSide.isHKAH()) {
			ret = callName;
		} else if (ConstantsServerSide.isTWAH()) {
			StringBuffer sb = new StringBuffer();
			String christianName = StringUtils.removeEndIgnoreCase(callName, surname);
			sb.append(StringUtils.trimToEmpty(christianName));
			sb.append(" ");
			sb.append(StringUtils.trimToEmpty(surname));
			sb.append(" ");
			sb.append(StringUtils.trimToEmpty(givenName));
			ret = StringUtils.trimToEmpty(sb.toString());
		} else {
			ret = staffName;
		}

		return ret;
	}

	public static String getDisplayNameFromHR(String staffName, String surname, String givenName, String callName) {
		String ret = "";
		if (ConstantsServerSide.isHKAH()) {
			ret = staffName;
		} else if (ConstantsServerSide.isTWAH()) {
			StringBuffer sb = new StringBuffer();
			String christianName = StringUtils.removeEndIgnoreCase(callName, surname);
			sb.append(StringUtils.trimToEmpty(surname));
			sb.append(" ");
			sb.append(StringUtils.trimToEmpty(givenName));
			if (!StringUtils.trimToEmpty(christianName).isEmpty())
				sb.append(", ");
			sb.append(StringUtils.trimToEmpty(christianName));
			ret = StringUtils.trimToEmpty(sb.toString());
		} else {
			ret = staffName;
		}

		return ret;
	}
	
	public static boolean isNotAMC(String staffID) {
		boolean ret = true;
		String siteCode = null;
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_getStaffSiteCode.toString(), new String[]{staffID});
		ReportableListObject rlo = null;
		if (!result.isEmpty()) {
			rlo = (ReportableListObject) result.get(0);
			siteCode = rlo.getFields0();
			if (ConstantsServerSide.SITE_CODE_AMC.equals(siteCode) ||
					ConstantsServerSide.SITE_CODE_AMC1.equals(siteCode) ||
					ConstantsServerSide.SITE_CODE_AMC2.equals(siteCode)) {
				ret = false;
			}
		}
		return ret;
	}

   /*
	* Description of the TWAH table fields
	* STAFF_CODE,
	* SURNAME,
	* GIVEN_NAME,
	* CHRISTIAN_NAME,
	* DATE_JOINED,		(format e.g.: 2009-12-01 00:00:00.0 yyyy-MM-dd hh:mm:ss.S)
	* DEPT_CODE,
	* EMAIL_ADDRESS,
	* STAFF_STATUS  ('A'=active -> 1, 'L'=leaving next month, 'P'=probation -> 1, 'T'=inactive -> 0, 'N'=joining next month),
	* CO_ENABLED = 0 ('T', 'N')
	* CO_ENABLED = 1 ('A', 'L', 'P')
	* SITE  ('TWAH' = Hong Kong Adventist Hospital - Tsuen Wan),
	* DEPT_DESCRIPTION
	*/
	public static void updateTWAH() {
		System.out.println(new Date() + " [StaffDB] updateTWAH");
		try {
		   ArrayList result = UtilDBWeb.getReportableList(sqlStr_selectHRStaff, new String[]{null, null});
		   ReportableListObject rlo = null;

		   System.out.println(" COL staff result size="+result.size());
		   if (result.size() > 0) {
			   StringBuffer emailStr = new StringBuffer();

			   // reset all staff status
			  // UtilDBWeb.updateQueue(sqlStr_resetStaff, new String[] { ConstantsServerSide.SITE_CODE });

			   String siteCode = null;
			   String staffCode = null;
			   String staffName = null;
			   String surname = null;
			   String givenName = null;
			   String chinFullName = null;
			   String calledName = null;
			   String hospitalNo = null;
			   String deptCodeHR = null;
			   String deptCode = null;
			   String deptDescription = null;
			   String positionCode = null;
			   String positionName = null;
			   String fte = null;
			   String dateOfAvailability = null;
			   String resignationDate = null;
			   String staffType = null;
			   String formerEmpNo = null;
			   String emailAddress = null;
			   
			   String staffEnabled = null;
			   String staffStatus = null;
			   String givenNameInShort = null;
			   String[] givenNameSplit = null;
			   String jobStatus = null;
			   String displayName = null;

			   DateFormat coHireDateFormat = new SimpleDateFormat("dd/MM/yyyy");
			   Date dateOfAvailabilityDate = null;
			   int j = 0;
			   
			   for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);
					j = 0;
					
					staffCode = rlo.getValue(j++);
					staffName = rlo.getValue(j++);
					surname = TextUtil.parseStr(rlo.getValue(j++));
					givenName = TextUtil.parseStr(rlo.getValue(j++));
					chinFullName = TextUtil.parseStr(rlo.getValue(j++));
					calledName = TextUtil.parseStr(rlo.getValue(j++));
					hospitalNo = TextUtil.parseStr(rlo.getValue(j++));
					deptCodeHR = TextUtil.parseStr(rlo.getValue(j++));
					deptCode = DepartmentDB.getPortalDeptCodeByHRDeptCode(deptCodeHR, ConstantsServerSide.SITE_CODE_TWAH, true);
					deptDescription = TextUtil.parseStr(rlo.getValue(j++));
					positionCode = TextUtil.parseStr(rlo.getValue(j++));
					positionName = TextUtil.parseStr(rlo.getValue(j++));
					fte = TextUtil.parseStr(rlo.getValue(j++));
					dateOfAvailability = TextUtil.parseStr(rlo.getValue(j++));
					if (dateOfAvailability != null && !dateOfAvailability.isEmpty()) {
						dateOfAvailabilityDate = DateTimeUtil.parseDate(dateOfAvailability);
					}
					resignationDate = TextUtil.parseStr(rlo.getValue(j++));
					staffType = TextUtil.parseStr(rlo.getValue(j++));
					staffStatus = hrFTE2Status(fte);
					formerEmpNo = TextUtil.parseStr(rlo.getValue(j++));
					emailAddress = TextUtil.parseStr(rlo.getValue(j++));

				 	givenNameSplit = (givenName != null) ? givenName.split(" ") : null;
					givenNameInShort = "";
					if (givenNameSplit != null && givenNameSplit.length > 0) {
						for (String name : givenNameSplit) {
							if (name != null && !"".equals(name)) {
								if (!"".equals(givenNameInShort))
									givenNameInShort += " ";
								givenNameInShort += name.length() > 0 ? name.substring(0, 1).toUpperCase() : "";
							}
						}
					}
					staffName = getStaffNameFromHR(staffName, surname, givenName, calledName);
					displayName = getDisplayNameFromHR(staffName, surname, givenName, calledName);
					staffEnabled = (resignationDate == null || resignationDate.isEmpty()) ? "1" : (DateTimeUtil.compareTo(resignationDate, DateTimeUtil.getCurrentDate()) >= 1 ? "1" : "0");
					siteCode = DepartmentDB.getSiteCodeByDept(deptCode);
					
					/*
					System.out.println("COL:" + siteCode + ", " + staffCode + ", " + displayName + ", " + staffName + ", " + surname + ", " + givenName + ", "  + chinFullName + ", " + calledName + ", " +
							hospitalNo + ", " + ", " + deptCodeHR + ", " + deptCode + ", " + deptDescription + ", " + 
							positionCode + ", " + positionName + ", " + fte + ", " + dateOfAvailability + ", " + resignationDate + ", " +
							staffType + ", " + staffStatus + ", " + formerEmpNo + ", " + emailAddress + ", " + staffEnabled);
					*/
					
					// if cannot map deptcode
					if (deptCode == null) {
						System.out.println("   No deptcode mapping staff ID: " + staffCode + ", deptCode HR: " + deptCodeHR);
						deptCode = deptCodeHR;
					}
					
					if (isExist(ConstantsServerSide.SITE_CODE_TWAH, staffCode)) {
						if (!UtilDBWeb.updateQueue(
								sqlStr_updateTWAHStaff,
								new String[] {
										staffName,
										surname,
										givenName,
										//emailAddress,	// do not update email from hr (value not update)
										DateTimeUtil.formatDate(dateOfAvailabilityDate),
										staffEnabled,
										positionCode,
										positionName,
										staffStatus,
										displayName,
										deptCode,
										deptDescription,
										resignationDate,
										staffCode
								} )) {
							System.out.println("   Cannot update staff ID: " + staffCode);
						}
					} else {
						if (!UtilDBWeb.updateQueue(
								sqlStr_insertStaffFromHR,
								new String[] {
										siteCode,
										staffCode,
										staffName,
										surname,
										givenName,
										deptCode,
										deptDescription,
										emailAddress,
										coHireDateFormat.format(dateOfAvailabilityDate),
										staffEnabled,
										positionCode,
										positionName,
										jobStatus,
										displayName
								} )) {
							System.out.println("   Cannot insert staff ID: " + staffCode);
						} else {
							System.out.println("   Insert new staff ID: " + staffCode);
						}
					}

					if (!UserDB.isExistByStaffID(staffCode) && "1".equals(staffEnabled)) {
						// create user in co_user table
						UserDB.add(siteCode, staffCode, PasswordUtil.cisEncryption(UserDB.PASSWORD_DEFAULT), staffCode);
					}

					if (positionCode != null && positionCode.length() > 0 && !isExistsByJobCode(positionCode)) {
						emailStr.append(sendEmailNotifyNewJobCodeHelper(i + 1, positionCode, positionName, staffCode, staffName));
					}
			   }

			   if (emailStr.length() > 0) {
					sendEmailNotifyNewJobCode(emailStr.toString());
			   }
		   }
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static boolean updateMarkDelete() {
		return UtilDBWeb.updateQueue(
				sqlStr_updateMarkDelete,
				new String[] { ConstantsServerSide.SITE_CODE });
	}

	public static boolean isExistsHRSystem(String staffCode) {
		return !UtilDBWeb.getReportableList(sqlStr_selectHRStaff, new String[]{staffCode, staffCode}).isEmpty();
	}

	public static boolean isExistsByJobCode(String jobCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   EE_COMPULSORY_CRITERIA ");
		sqlStr.append("WHERE  EE_POSITION_CODE = '"+jobCode+"'");

		return UtilDBWeb.isExist(sqlStr.toString());
	}

	public static String sendEmailNotifyNewJobCodeHelper(int rowcount, String jobCode, String jobDescription, String staffID, String staffName) {
		StringBuffer commentStr = new StringBuffer();
		commentStr.append("<tr><td>");
		commentStr.append(rowcount);
		commentStr.append("</td><td>");
		commentStr.append(jobCode);
		commentStr.append("</td><td>");
		commentStr.append(jobDescription);
		commentStr.append("</td><td>");
		commentStr.append(staffID);
		commentStr.append("</td><td>");
		commentStr.append(staffName);
		commentStr.append("</td></tr>");
		return commentStr.toString();
	}

	public static boolean sendEmailNotifyNewJobCode(String content) {
		StringBuffer commentStr = new StringBuffer();
		commentStr.append("<br>The details of new job code are as follows:<br><table border=\"1\">");
		commentStr.append("<tr><td>#</td><td>Job Code</td><td>Job Description</td><td>Staff ID</td><td>Staff Name</td></tr>");
		commentStr.append(content);
		commentStr.append("</table>");

		return EmailAlertDB.sendEmail("new.job.code", "TWAH Update - New Job Code Found", commentStr.toString());
	}

	public static String getCoUsername(String loginID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_USERNAME ");
		sqlStr.append("FROM   CO_USERS ");
		sqlStr.append("WHERE  CO_STAFF_ID = ? OR CO_USERNAME = ? ");
		System.err.println(sqlStr.toString());
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { loginID,  loginID });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	public static ArrayList getDeptHeadSupervisor(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.co_department_head, D.co_department_supervisor ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_STAFF_ID = ? ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getStaffNurse(int sortBy) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT S.CO_DEPARTMENT_CODE, DECODE(S.CO_DEPARTMENT_DESC, null, D.CO_DEPARTMENT_DESC, S.CO_DEPARTMENT_DESC), ");
		sqlStr.append("       S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_STATUS, ");
		sqlStr.append("       TO_CHAR(S.CO_ANNUAL_INCR, 'MM'), TO_CHAR(S.CO_HIRE_DATE,'MM/YYYY'), TO_CHAR(S.CO_HIRE_DATE,'DD/MM/YYYY'), ");
		sqlStr.append("       S.CO_DISPLAY_NAME, DECODE(S.CO_EMAIL, null, U.CO_EMAIL, S.CO_EMAIL) ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U, STAFF_NURSE SN ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_STAFF_ID = U.CO_STAFF_ID ");
		sqlStr.append("AND    S.CO_STAFF_ID = SN.CO_STAFF_ID ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		if (sortBy == 1) {
			sqlStr.append("ORDER BY S.CO_STAFF_ID, S.CO_DEPARTMENT_CODE, S.CO_STAFFNAME");
		} else if (sortBy == 2) {
			sqlStr.append("ORDER BY upper(S.co_display_name)");
		} else if (sortBy == 3) {
			sqlStr.append("ORDER BY upper(S.CO_LASTNAME)");
		} else {
			if (ConstantsServerSide.isHKAH()) {
				sqlStr.append("ORDER BY S.CO_STAFFNAME, S.CO_STAFF_ID");
			} else {
				sqlStr.append("ORDER BY S.CO_DISPLAY_NAME, S.CO_STAFF_ID");
			}
		}

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String hrName2PortalName(String surname, String givenName, String calledName) {
		String givenNameWOcalledName = null;
		try {
			givenNameWOcalledName = givenName.replaceAll(calledName, "").trim();
		} catch (Exception ex) {}

		if (calledName.toLowerCase().equals(surname.toLowerCase())) {
			calledName = "";
		}

		//System.out.println("[hrName2PortalName] calledName="+calledName+", surname.toLowerCase()="+surname.toLowerCase());

		String firstCaps = getFirst2Letters(givenName);
		return (calledName == null || calledName.isEmpty() ? "" : calledName + " ") + surname + (firstCaps == null || firstCaps.isEmpty() ? "" : " " + firstCaps);
	}

	private static String getFirst2Letters(String givenName) {
		Pattern p = Pattern.compile("\\b[a-zA-Z]");
		Matcher m = p.matcher(givenName);
		StringBuffer retBuf = new StringBuffer();

		int n = 0;
		while (m.find() && n < 2) {
			if (retBuf.length() > 0) {
				retBuf.append(" ");
			}
			retBuf.append(m.group());
			n++;
		}

		return retBuf.toString();
	}

	public static String hrFTE2Status(String fte) {
		String ret = null;

		// FTE, casual if < 0.5, PT if >= 0.5 but < 1, FT if =1
		Double fteDouble = null;
		try {
			fteDouble = Double.parseDouble(fte);
		} catch (Exception e) {}
		if (fteDouble < 0.5) {
			ret = getStaffStatusCode("CA");
		} else if (fteDouble >= 0.5 && fteDouble < 1) {
			ret = getStaffStatusCode("PT");
		} else {
			ret = getStaffStatusCode("FT");
		}
		return ret;
	}

	private static String getStaffStatusCode(String genStatusCode) {
		String ret = null;
		if (ConstantsServerSide.isTWAH()) {
			if ("CA".equals(genStatusCode)) {
				ret = "CAS";
			} else if ("PT".equals(genStatusCode)) {
				ret = "PTW";
			} else if ("FT".equals(genStatusCode)) {
				ret = "FTW";
			}
		} else {
			if ("CA".equals(genStatusCode)) {
				ret = "CA";
			} else if ("PT".equals(genStatusCode)) {
				ret = "PT";
			} else if ("FT".equals(genStatusCode)) {
				ret = "FT";
			}
		}
		return ret;
	}

	private boolean isResigned(String resignationDate) {
		boolean ret = false;

		final String FORMAT_DISPLAY_DATE_HR = "yyyy-MM-dd";
		final SimpleDateFormat displayDateHrFormat = new SimpleDateFormat(FORMAT_DISPLAY_DATE_HR);
		Date resignationDateD = null;
		try {
			resignationDateD = displayDateHrFormat.parse(resignationDate);
		} catch (ParseException e) {}
		if (resignationDateD != null &&
				DateTimeUtil.compareTo(DateTimeUtil.getCurrentDate(), DateTimeUtil.formatDate(resignationDateD)) < 1) {
			ret = true;
		}
		return ret;
	}

	public static boolean terminateStaffs(List<String> excludeStaffIDs, boolean isDisableUser) {
		StringBuffer sqlStr = new StringBuffer();
		if (excludeStaffIDs != null && !excludeStaffIDs.isEmpty()) {
			String[] tempStaffIds = new String[(int)Math.ceil(excludeStaffIDs.size()/1000.0)];
			for (int i=0;i<tempStaffIds.length;i++) {
				tempStaffIds[i] = StringUtils.join(excludeStaffIDs.subList(i*1000, Math.min((i+1)*1000, excludeStaffIDs.size()-1)), "','");
			}

			for (int j=0;j<tempStaffIds.length;j++) {
				if (j==0) {
					sqlStr.append(" AND  	(co_staff_id IN ('" + tempStaffIds[j] + "') ");
				} else {
					sqlStr.append(" OR  	co_staff_id IN ('" + tempStaffIds[j] + "') ");
				}
			}
			if (tempStaffIds.length > 0) {
				sqlStr.append(")");
			}
		}

		System.out.println("[terminateStaffs] tempStaffIds="+ sqlStr.toString());

		if (isDisableUser) {
			UtilDBWeb.updateQueue(sqlStr_terminateUsers + sqlStr.toString());
		}

		return UtilDBWeb.updateQueue(sqlStr_terminateStaffs + sqlStr.toString());
	}

	public static boolean terminateStaffsAMC(List<String> excludeStaffIDs, boolean isDisableUser, String siteCode) {
		StringBuffer sqlStr = new StringBuffer();
		if (excludeStaffIDs != null && !excludeStaffIDs.isEmpty()) {
			String[] tempStaffIds = new String[(int)Math.ceil(excludeStaffIDs.size()/1000.0)];
			for (int i=0;i<tempStaffIds.length;i++) {
				tempStaffIds[i] = StringUtils.join(excludeStaffIDs.subList(i*1000, Math.min((i+1)*1000, excludeStaffIDs.size()-1)), "','");
			}

			for (int j=0;j<tempStaffIds.length;j++) {
				if (j==0) {
					sqlStr.append(" AND  	(co_staff_id IN ('" + tempStaffIds[j] + "') ");
				} else {
					sqlStr.append(" OR  	co_staff_id IN ('" + tempStaffIds[j] + "') ");
				}
			}
			if (tempStaffIds.length > 0) {
				sqlStr.append(")");
			}
		}

		System.out.println("[terminateStaffsAMC] tempStaffIds="+ sqlStr.toString());

		String sql = null;
		String dbLink = ConstantsServerSide.getDBLinkPortal(siteCode);
		if (isDisableUser) {
			sql = sqlStr_terminateUsersAMC.replace("<DBLINK>", dbLink);
			UtilDBWeb.updateQueue(sql + sqlStr.toString());
		}

		sql = sqlStr_terminateStaffsAMC.replace("<DBLINK>", dbLink);
		return UtilDBWeb.updateQueue(sql + sqlStr.toString());
	}

	public static boolean hireStaffs(List<String> excludeStaffIDs, boolean isEnableUser) {
		StringBuffer sqlStr = new StringBuffer();
		if (excludeStaffIDs != null && !excludeStaffIDs.isEmpty()) {
			String[] tempStaffIds = new String[(int)Math.ceil(excludeStaffIDs.size()/1000.0)];
			for (int i=0;i<tempStaffIds.length;i++) {
				tempStaffIds[i] = StringUtils.join(excludeStaffIDs.subList(i*1000, Math.min((i+1)*1000, excludeStaffIDs.size()-1)), "','");
			}

			for (int j=0;j<tempStaffIds.length;j++) {
				if (j==0) {
					sqlStr.append(" AND  	(co_staff_id IN ('" + tempStaffIds[j] + "') ");
				} else {
					sqlStr.append(" OR  	co_staff_id IN ('" + tempStaffIds[j] + "') ");
				}
			}
			if (tempStaffIds.length > 0) {
				sqlStr.append(")");
			}
		}

		System.out.println("[hireStaffs] tempStaffIds="+ sqlStr.toString());

		if (isEnableUser) {
			UtilDBWeb.updateQueue(sqlStr_hireUsers + sqlStr.toString());
		}

		return UtilDBWeb.updateQueue(sqlStr_hireStaffs + sqlStr.toString());
	}

	public static boolean disableNotExistStaffs(List<String> staffIDs) {
		System.out.println("[StaffDB] disableNotExistStaffs staffIDs size="+staffIDs.size());
		if (staffIDs == null || staffIDs.isEmpty()) {
			return false;
		}

		String[] tempStaffIds = new String[(int)Math.ceil(staffIDs.size()/1000.0)];
		for (int i=0;i<tempStaffIds.length;i++) {
			tempStaffIds[i] = StringUtils.join(staffIDs.subList(i*1000, Math.min((i+1)*1000, staffIDs.size()-1)), "','");
		}

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE co_staffs ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  co_enabled = 1 ");
		sqlStr.append("AND    CO_MARK_DELETED = 'N' ");
		for (int j=0;j<tempStaffIds.length;j++) {
		   if (j==0) {
			 sqlStr.append("AND  	(co_staff_id NOT IN ('" + tempStaffIds[j] + "') ");
		   } else {
			 sqlStr.append("AND  	co_staff_id NOT IN ('" + tempStaffIds[j] + "') ");
		   }
		}
		if (tempStaffIds.length > 0) {
			sqlStr.append(")");
		}

		System.out.println(" sql="+sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{"SYSTEM"});

	}

	public static Map<String, String> loadNursingPositionCode() {
		Map<String, String> ret = new HashMap<String, String>();
		ArrayList<ReportableListObject> result = getPositionList(null, new Boolean(true));
		if (result.size() > 0) {
			ReportableListObject rlo = null;
			for (int i = 0; i < result.size(); i++) {
				rlo = (ReportableListObject) result.get(i);
				ret.put(rlo.getFields0(), rlo.getFields1());
			}
		}
		return ret;
	}

	/*
	 * Old HR system (before 01/01/2021)
	 */
	protected static String hrDatabaseConnUrl() {
		Connection conn = null;
		String url = "jdbc:sqlserver://";
		String serverName= "192.168.0.59";
		String portNumber = "1433";
		String databaseName= "NCAH_Production";
		// Informs the driver to use server a side-cursor,
		// which permits more than one active statement
		// on a connection.
		String selectMethod = "cursor";

		return url + serverName + ":" + portNumber + ";databaseName=" + databaseName + ";selectMethod=" + selectMethod + ";";
	}

	/*
	 * Old HR system (before 01/01/2021)
	 */
	public static List<ReportableListObject> getSqlServerReportableListObject(String userName, String password, String selectCols, String tableName, String whereClause, String orderClause) {
		Connection conn = null;
		ReportableListObject rlo = null;
		List<ReportableListObject> list = new ArrayList<ReportableListObject>();
		String sql = null;
		String connUrl = hrDatabaseConnUrl();

		try {
		   //Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");		sqljdbc.jar
		   Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); 		// sqljdbc4.jar
		   conn = java.sql.DriverManager.getConnection(connUrl, userName, password);
		   if (conn != null) {
			   //String sql = "SELECT Person_Code, Name, Surname, Given_Name FROM sync_person_view_4IT";
			   sql = "SELECT " + selectCols + " FROM " + tableName +
					   (whereClause == null ? "" : " WHERE " + whereClause) +
					   (orderClause == null ? "" : " ORDER BY " + orderClause);

			   //System.out.println("[getSqlServerReportableListObject] sql="+sql);

			   list = UtilDBWeb.getReportableList(conn, sql);
		   }

		   if (conn != null) {
			   conn.close();
		   }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public static boolean sendTerminateStaffEmail() {
		boolean ret = true;
		StringBuffer subject = new StringBuffer();

		StringBuffer subjectTemplate = new StringBuffer();
		subjectTemplate.append("[HKAH");
		subjectTemplate.append((ConstantsServerSide.isHKAH() ? "-SR" : (ConstantsServerSide.isTWAH() ? "-TW" : "")));
		subjectTemplate.append(ConstantsServerSide.DEBUG ? " UAT" : "");
		subjectTemplate.append("] ");
		subjectTemplate.append("Staff employment termination notice");

		StringBuffer content = new StringBuffer();
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_getTerminateTodayStaffs.toString());
		ReportableListObject rlo = null;

		System.out.println("[StaffDB] sendTerminateStaffEmail result.size()="+result.size());

		for (int i = 0; i < result.size(); i++) {
			rlo = (ReportableListObject) result.get(i);
			String staffNo = rlo.getFields0();
			/*
		sqlStr.append("select co_staff_id, co_staffname, co_department_desc, co_position_1 ");
			 */
			subject.setLength(0);
			subject.append(subjectTemplate.toString());
			subject.append(" (Staff No. : " + staffNo + ")");

			content.setLength(0);
			content.append("Staff Name : " + StringUtils.trimToEmpty(rlo.getFields1()) + "<br />");
			content.append("Staff No. : " + staffNo + "<br />");
			content.append("Department : " + StringUtils.trimToEmpty(rlo.getFields2()) + "<br />");
			content.append("Position : " + StringUtils.trimToEmpty(rlo.getFields3()) + "<br />");
			content.append("<br />");
			content.append("<b><i>The above staff's employment ceased on [" + StringUtils.trimToEmpty(rlo.getFields4()) + "].</i></b>" + "<br />");
			content.append("<br />");
			content.append("<b><u>For Information Technology Department:</u></b>" + "<br />");
			content.append("Please disable any hospital E-mail accounts, computer user logins, and other hospital information systems associated with the above staff, if any." + "<br /><br />");
			content.append("<b><u>For Housekeeping Department:</u></b>" + "<br />");
			content.append("Please withdraw all distributed uniform, if any.");

			if (!EmailAlertDB.sendEmail("hr.staff.term", subject.toString(), content.toString())) {
				ret = false;
			}
		}
		return ret;
	}

	public static boolean sendHireStaffEmail() {
		boolean ret = true;
		StringBuffer subject = new StringBuffer();

		StringBuffer subjectTemplate = new StringBuffer();
		subjectTemplate.append("[HKAH");
		subjectTemplate.append((ConstantsServerSide.isHKAH() ? "-SR" : (ConstantsServerSide.isTWAH() ? "-TW" : "")));
		subjectTemplate.append(ConstantsServerSide.DEBUG ? " UAT" : "");
		subjectTemplate.append("] ");
		subjectTemplate.append("Staff employment hire notice");

		StringBuffer content = new StringBuffer();
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_getHireTodayStaffs.toString());
		ReportableListObject rlo = null;
		String isNursing = null;
		String isNursingHtml = null;

		System.out.println("[StaffDB] sendHireStaffEmail result.size()="+result.size());

		for (int i = 0; i < result.size(); i++) {
			rlo = (ReportableListObject) result.get(i);
			String staffNo = rlo.getFields0();
			String markDeleted = rlo.getFields7();

			boolean isTurnOffMarkDeleted = false;
			if (ConstantsVariable.YES_VALUE.equals(markDeleted) && isExistsHRSystem(staffNo)) {
				isTurnOffMarkDeleted = turnOffMarkDeleted(null, staffNo);
				System.out.println("Staff " + staffNo + " markDeleted is "+markDeleted+", auto turn off on hire date success is " + isTurnOffMarkDeleted);
			}
			
			isNursing = StringUtils.trimToEmpty(rlo.getFields6());
			isNursingHtml = "Y".equals(isNursing) ? "<span style='color:red'>" + isNursing + "</span>" : isNursing;

			subject.setLength(0);
			subject.append(subjectTemplate.toString());
			subject.append(" (Staff No. : " + staffNo + ")");

			content.setLength(0);
			content.append("Staff Name : " + StringUtils.trimToEmpty(rlo.getFields1()) + " (Display Name: " + StringUtils.trimToEmpty(rlo.getFields8()) + ")<br />");
			content.append("Staff No. : " + staffNo + "<br />");
			content.append("Department : " + StringUtils.trimToEmpty(rlo.getFields2()) + "<br />");
			content.append("Position : " + StringUtils.trimToEmpty(rlo.getFields3()) + " (Code: " + StringUtils.trimToEmpty(rlo.getFields5()) + ")<br />");
			content.append("Nursing staff : " + isNursingHtml + "<br />");
			content.append("<br />");
			content.append("<b><i>The above staff's employment hire on [" + StringUtils.trimToEmpty(rlo.getFields4()) + "].</i></b>" + "<br />");
			content.append("<br />");
			content.append("<b><u>For Information Technology Department:</u></b>" + "<br />");
			content.append("Please create clinical related user account (e.g. Ewell, RIS) for nursing staffs." + "<br /><br />");
			if (isTurnOffMarkDeleted) {
				content.append("*The \"Fix staff info\" setting has been turned off. All this staff info and enable/disable status will be synchronized from HR system to Intranet Portal from now on.");
			}
			if (!EmailAlertDB.sendEmail("hr.staff.hire", subject.toString(), content.toString())) {
				ret = false;
			}
		}
		return ret;
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_STAFFS ");
		sqlStr.append("(CO_SITE_CODE, CO_STAFF_ID, CO_DEPARTMENT_CODE, CO_STAFFNAME, CO_STATUS, CO_ANNUAL_INCR, CO_HIRE_DATE, CO_CATEGORY, CO_TERMINATION_DATE, CO_POSITION_1, CO_POSITION_2, CO_MARK_DELETED, ");
		sqlStr.append("CO_HOSP_NO, CO_FIX_DEPARTMENT_CODE, CO_POSITION_CODE, CO_CHI_NAME, CO_LASTNAME, CO_FIRSTNAME, CO_EMAIL, CO_JOB_CODE, CO_JOB_DESCRIPTION, CO_DISPLAY_NAME, ");
		sqlStr.append("CO_ENABLED, CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, UPPER(?), ?, ?, ?, TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?, TO_DATE(?, 'dd/MM/yyyy'), ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?)");
		sqlStr_insertStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_STAFFS (");
		sqlStr.append("CO_SITE_CODE, CO_STAFF_ID, CO_STAFFNAME, CO_LASTNAME, CO_FIRSTNAME, CO_CHI_NAME, CO_DEPARTMENT_CODE, CO_STATUS, CO_POSITION_CODE, CO_POSITION_1, CO_POSITION_2, CO_HOSP_NO, CO_HIRE_DATE, CO_TERMINATION_DATE )");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', UPPER(?), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, TO_DATE(?,'yyyy-mm-dd'), TO_DATE(?,'yyyy-mm-dd') ) ");
		sqlStr_insertStaff2 = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_STAFFS (");
		sqlStr.append("CO_SITE_CODE, CO_STAFF_ID)");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', UPPER(?)) ");
		sqlStr_insertStaffID = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_STAFFS (");
		sqlStr.append("CO_SITE_CODE, CO_STAFF_ID, CO_STAFFNAME, CO_DEPARTMENT_CODE, CO_STATUS, CO_POSITION_1, CO_POSITION_2, CO_HOSP_NO, CO_MARK_DELETED )");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', UPPER(?), ?, ?, ?, ?, ?, ?, 'Y' ) ");
		sqlStr_insertDoctor = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_STAFFS ");
		sqlStr.append("SET    CO_DEPARTMENT_CODE = ?, CO_STAFFNAME = ?, CO_STATUS = ?, CO_ANNUAL_INCR = TO_DATE(?, 'dd/MM/yyyy'), CO_HIRE_DATE = TO_DATE(?, 'dd/MM/yyyy'), CO_CATEGORY = ?, CO_TERMINATION_DATE = TO_DATE(?,'dd/MM/yyyy'), CO_POSITION_1 = ?, CO_POSITION_2 = ?, CO_MARK_DELETED = ?, ");
		sqlStr.append("       CO_HOSP_NO = ?, CO_FIX_DEPARTMENT_CODE = ?, CO_POSITION_CODE = ?, CO_CHI_NAME = ?, CO_LASTNAME = ?, CO_FIRSTNAME = ?, CO_EMAIL = ?, CO_JOB_CODE = ?, CO_JOB_DESCRIPTION = ?, CO_DISPLAY_NAME = ?, ");
		sqlStr.append("       CO_ENABLED = ?, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ?, CO_DISPLAY_PHOTO = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_STAFF_ID = ? ");
		sqlStr_updateStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_STAFFS ");
		sqlStr.append("SET    CO_STAFFNAME = ?, CO_DISPLAY_NAME = ?, CO_LASTNAME = ?, CO_FIRSTNAME = ?, CO_CHI_NAME = ?, CO_STATUS = ?, CO_ENABLED = 1, CO_POSITION_CODE = ?, CO_POSITION_1 = ?, CO_POSITION_2 = ?, CO_HOSP_NO = ?, CO_HIRE_DATE = TO_DATE(?,'DD/MM/YYYY'), CO_TERMINATION_DATE = TO_DATE(?,'DD/MM/YYYY') ");
		sqlStr.append("	, CO_MODIFIED_DATE = sysdate, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_STAFF_ID = ? ");
		sqlStr.append("AND    CO_MARK_DELETED = 'N' ");

		sqlStr.append("AND ( ");
		sqlStr.append("		  (NVL(CO_STAFFNAME, '~') <> NVL(?, '~')) ");
		sqlStr.append("			OR (NVL(CO_DISPLAY_NAME, '~') <> NVL(?, '~')) ");
		sqlStr.append("			OR (NVL(CO_LASTNAME, '~') <> NVL(?, '~')) ");
		sqlStr.append("			OR (NVL(CO_FIRSTNAME, '~') <> NVL(?, '~')) ");
		sqlStr.append("			OR (NVL(CO_CHI_NAME, '~') <> NVL(?, '~')) ");
		sqlStr.append("			OR (NVL(CO_STATUS, '~') <> NVL(?, '~')) ");
		sqlStr.append("			OR (NVL(CO_POSITION_CODE, '~') <> NVL(?, '~')) ");
		sqlStr.append("			OR (NVL(CO_POSITION_1, '~') <> NVL(?, '~')) ");
		sqlStr.append("			OR (NVL(CO_POSITION_2, '~') <> NVL(?, '~')) ");
		sqlStr.append("			OR (NVL(CO_HOSP_NO, '~') <> NVL(?, '~')) ");
		sqlStr.append("			OR (NVL(to_char(CO_HIRE_DATE, 'DD/MM/YYYY'), '~') <> NVL(?, '~')) ");
		sqlStr.append("			OR (NVL(to_char(CO_TERMINATION_DATE, 'DD/MM/YYYY'), '~') <> NVL(?, '~')) ");
		sqlStr.append("	) ");
		sqlStr_updateStaffIfChanged = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_STAFFS ");
		sqlStr.append("SET    CO_DEPARTMENT_CODE = ?, CO_DEPARTMENT_DESC = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_STAFF_ID = ? ");
		sqlStr.append("AND    CO_FIX_DEPARTMENT_CODE = 'N' ");
		sqlStr_updateDeptCode = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_STAFFS ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_STAFF_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_deleteStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM CO_STAFFS ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_STAFF_ID = ? ");
		sqlStr_deleteStaffRecord = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_STAFF_DEPARTMENTS (");
		sqlStr.append("CO_SITE_CODE, CO_STAFF_ID, CO_DEPARTMENT_CODE, CO_CREATED_USER, CO_MODIFIED_USER)");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', UPPER(?), ?, ?, ?) ");
		sqlStr_insertStaffDeptCode = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE CO_STAFF_DEPARTMENTS ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_STAFF_ID = ? ");
		sqlStr_deleteStaffDeptCode = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT S.CO_SITE_CODE, S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       S.CO_STAFFNAME, ");
		sqlStr.append("       S.CO_STATUS, TO_CHAR(S.CO_ANNUAL_INCR, 'MM'), TO_CHAR(S.CO_HIRE_DATE, 'DD/MM/YYYY'), S.CO_CATEGORY, ");
		sqlStr.append("		  S.CO_POSITION_1, S.CO_POSITION_2, TO_CHAR(CO_TERMINATION_DATE,'DD/MM/YYYY'), S.CO_HOSP_NO, S.CO_FIX_DEPARTMENT_CODE, S.CO_MARK_DELETED, S.CO_ENABLED, ");
		sqlStr.append("		  S.CO_POSITION_CODE, S.CO_CHI_NAME, S.CO_LASTNAME, S.CO_FIRSTNAME, S.CO_EMAIL, S.CO_JOB_CODE, S.CO_JOB_DESCRIPTION, S.CO_DISPLAY_NAME, ");
		sqlStr.append("       TO_CHAR(S.CO_CREATED_DATE, 'DD/MM/YYYY HH24:MI:SS'), S.CO_CREATED_USER, TO_CHAR(S.CO_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI:SS'), S.CO_MODIFIED_USER, S.CO_DISPLAY_PHOTO ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE(+) ");
		sqlStr.append("AND    S.CO_ENABLED = ? ");
		sqlStr.append("AND    S.CO_STAFF_ID = ? ");
		sqlStr_getStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 1 FROM CO_STAFFS WHERE CO_STAFF_ID = ? ");
		sqlStr_isExistStaff = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT 1 FROM CO_STAFFS WHERE CO_STAFF_ID = ? AND CO_ENABLED = 1 ");
		sqlStr_isExistActiveStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 1 FROM CO_STAFFS WHERE CO_SITE_CODE = ? AND CO_STAFF_ID = ? ");
		sqlStr_isExistSiteStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 1 FROM CO_STAFFS ");
		sqlStr.append("WHERE CO_STATUS='FT' AND CO_ENABLED = 1 AND CO_HIRE_DATE+365 <= TO_DATE(?,'DD/MM/YYYY')  AND CO_STAFF_ID = ? ");
		sqlStr_atLeastOneYearStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT [Staff No], [Staff Name], [Dept Code], Status, [Pos1], [Pos2], hosp_no,[Hire_Date] ");
		sqlStr.append("FROM   [Staff List] ");
		sqlStr_selectAccessStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_SITE_CODE FROM CO_STAFFS WHERE CO_STAFF_ID = ? ");
		sqlStr_getStaffSiteCode = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_STAFFS SET CO_ENABLED = 0 WHERE CO_SITE_CODE = ? AND CO_MARK_DELETED = 'N' AND CO_ENABLED = 1 ");
		sqlStr_resetStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_USERS SET CO_ENABLED = 0, CO_MODIFIED_DATE = sysdate, CO_MODIFIED_USER = 'SYSTEM' WHERE CO_STAFF_ID IN (SELECT CO_STAFF_ID FROM CO_STAFFS WHERE (TRUNC(CO_TERMINATION_DATE) <= TRUNC(SYSDATE) OR TRUNC(co_hire_date) > TRUNC(SYSDATE)) AND CO_MARK_DELETED = 'N' AND CO_ENABLED = 1) AND CO_ENABLED = 1 ");
		sqlStr_terminateUsers = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_USERS@<DBLINK> SET CO_ENABLED = 0, CO_MODIFIED_DATE = sysdate, CO_MODIFIED_USER = 'SYSTEM' WHERE CO_STAFF_ID IN (SELECT CO_STAFF_ID FROM CO_STAFFS WHERE (TRUNC(CO_TERMINATION_DATE) <= TRUNC(SYSDATE) OR TRUNC(co_hire_date) > TRUNC(SYSDATE)) AND CO_MARK_DELETED = 'N' AND CO_ENABLED = 1) AND CO_ENABLED = 1 ");
		sqlStr_terminateUsersAMC = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_STAFFS SET CO_ENABLED = 0, CO_MODIFIED_DATE = sysdate, CO_MODIFIED_USER = 'SYSTEM' WHERE (TRUNC(CO_TERMINATION_DATE) <= TRUNC(SYSDATE) OR TRUNC(co_hire_date) > TRUNC(SYSDATE)) AND CO_MARK_DELETED = 'N' AND CO_ENABLED = 1 ");
		sqlStr_terminateStaffs = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_STAFFS@<DBLINK> SET CO_ENABLED = 0, CO_MODIFIED_DATE = sysdate, CO_MODIFIED_USER = 'SYSTEM' WHERE (TRUNC(CO_TERMINATION_DATE) <= TRUNC(SYSDATE) OR TRUNC(co_hire_date) > TRUNC(SYSDATE)) AND CO_MARK_DELETED = 'N' AND CO_ENABLED = 1 ");
		sqlStr_terminateStaffsAMC = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_USERS SET CO_ENABLED = 1, CO_MODIFIED_DATE = sysdate, CO_MODIFIED_USER = 'SYSTEM' WHERE CO_STAFF_ID IN (SELECT CO_STAFF_ID FROM CO_STAFFS WHERE (TRUNC(SYSDATE) >= TRUNC(co_hire_date) AND (CO_TERMINATION_DATE IS NULL OR TRUNC(CO_TERMINATION_DATE) > TRUNC(SYSDATE))) AND CO_ENABLED = 0) AND CO_ENABLED = 0 ");
		sqlStr_hireUsers = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_STAFFS SET CO_ENABLED = 1, CO_MODIFIED_DATE = sysdate, CO_MODIFIED_USER = 'SYSTEM' WHERE (TRUNC(SYSDATE) >= TRUNC(co_hire_date) AND (CO_TERMINATION_DATE IS NULL OR TRUNC(CO_TERMINATION_DATE) > TRUNC(SYSDATE))) AND CO_ENABLED = 0 ");
		sqlStr_hireStaffs = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("select co_staff_id, co_staffname, co_department_desc, co_position_1, to_char(co_termination_date, 'yyyy-mm-dd'), co_position_code ");
		sqlStr.append("from co_staffs ");
		sqlStr.append("where trunc(co_termination_date) = trunc(sysdate) ");
		sqlStr.append("order by co_department_desc, co_staff_id");
		sqlStr_getTerminateTodayStaffs = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("select s.co_staff_id, s.co_staffname, s.co_department_desc, s.co_position_1, to_char(s.co_hire_date, 'yyyy-mm-dd'), s.co_position_code, ");
		sqlStr.append(" case when p.co_enabled = 1 then p.co_is_nursing else 'N/A' end as is_nursing, ");
		sqlStr.append(" s.co_mark_deleted, s.co_display_name ");
		sqlStr.append("from co_staffs s left join co_position p on s.co_position_code = p.co_position_code ");
		sqlStr.append("where trunc(co_hire_date) = trunc(sysdate) ");
		sqlStr.append("order by co_department_desc, co_staff_id");
		sqlStr_getHireTodayStaffs = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_STAFFS SET CO_MARK_DELETED = 'N', CO_MODIFIED_DATE = sysdate, CO_MODIFIED_USER = ? WHERE co_staff_id = ? AND CO_MARK_DELETED = 'Y'");
		sqlStr_turnOffMarkDeleted = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_STAFFS SET CO_MARK_DELETED = 'N', CO_MODIFIED_DATE = sysdate, CO_MODIFIED_USER = 'SYSTEM' WHERE CO_SITE_CODE = ? AND CO_MARK_DELETED = 'Y' AND CO_STAFF_ID NOT LIKE 'DR%' AND CO_STAFF_ID NOT LIKE 'M%' AND CO_STAFF_ID NOT LIKE 'E%' AND CO_MODIFIED_DATE > SYSDATE - 180 AND CO_ENABLED = 1");
		sqlStr_updateMarkDelete = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT PERSON_CODE,NAME,SURNAME,GIVEN_NAME,CHIN_FULL_NAME,CALLED_NAME,HOSPITAL_NO,DEPT_CODE,DEPT_NAME,POSITION_CODE,POSITION_NAME,FTE,TO_CHAR(DATE_OF_AVAILABILITY, 'DD/MM/YYYY'),TO_CHAR(RESIGNATION_DATE, 'DD/MM/YYYY'),STAFF_TYPE,FORMER_EMP_ID,EMAIL_ADDRESS FROM " + ConstantsServerSide.getSiteShortTermSymbol() + "_PERSONAL_DATA_TABLE@HR_COL ");
		if (ConstantsServerSide.isTWAH()) {
			sqlStr.append("WHERE PERSON_CODE NOT LIKE 'SRC%' ");
		} else if (ConstantsServerSide.isHKAH()) {
			sqlStr.append("WHERE PERSON_CODE NOT LIKE 'TWC%' ");
		} else {
			sqlStr.append("WHERE 1=1 ");
		}
		sqlStr.append("AND (PERSON_CODE = ? OR ? IS NULL) ");
		sqlStr.append("ORDER BY PERSON_CODE ");
		sqlStr_selectHRStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_STAFFS ");
		sqlStr.append("SET    CO_STAFFNAME = ?, CO_LASTNAME = ?, CO_FIRSTNAME = ?, CO_HIRE_DATE = TO_DATE(?, 'DD/MM/YYYY'), CO_ENABLED = ?, CO_JOB_CODE = ?, CO_JOB_DESCRIPTION = ?, CO_STATUS = ?,CO_DISPLAY_NAME = ?, ");
		sqlStr.append("  CO_DEPARTMENT_CODE = (case when co_fix_department_code = 'Y' then CO_DEPARTMENT_CODE else ? end), CO_DEPARTMENT_DESC = (case when co_fix_department_code = 'Y' then CO_DEPARTMENT_DESC else ? end), ");
		sqlStr.append("  CO_TERMINATION_DATE = TO_DATE(?, 'DD/MM/YYYY') ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_STAFF_ID = ?  ");
		sqlStr.append("AND    CO_MARK_DELETED = 'N' ");
		sqlStr_updateTWAHStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_STAFFS (");
		sqlStr.append("CO_SITE_CODE, CO_STAFF_ID, CO_STAFFNAME, CO_LASTNAME, CO_FIRSTNAME, CO_DEPARTMENT_CODE, CO_DEPARTMENT_DESC, CO_EMAIL, CO_HIRE_DATE, CO_ENABLED, CO_JOB_CODE,CO_JOB_DESCRIPTION, CO_STATUS, CO_DISPLAY_NAME )");
		sqlStr.append("VALUES (?, UPPER(?), ?, ?, ?, ?, ?, ?, TO_DATE(?, 'DD/MM/YYYY'), ?, ?,?,?, ? ) ");
		sqlStr_insertStaffFromHR = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT DEPARTMENT_CODE, DEPARTMENT_NAME FROM " + ConstantsServerSide.getSiteShortTermSymbol() + "_DEPARTMENT_TABLE@HR_COL ");
		sqlStr.append("ORDER BY DEPARTMENT_CODE ");
		sqlStr_selectHRDept = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_STAFF_ID ");
		sqlStr.append("FROM CO_STAFFS ");
		sqlStr.append("WHERE CO_DEPARTMENT_CODE = '" + DepartmentDB.HK_DEPT_CODE_AMC1 + "' AND CO_ENABLED = 1 ");
		sqlStr.append("AND CO_STAFF_ID NOT IN (SELECT CO_STAFF_ID FROM CO_STAFFS@AMC1_PORTAL)");
		sqlStr_getNewStaffIDAMC1 = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_STAFF_ID ");
		sqlStr.append("FROM CO_STAFFS ");
		sqlStr.append("WHERE CO_DEPARTMENT_CODE = '" + DepartmentDB.HK_DEPT_CODE_AMC2 + "' AND CO_ENABLED = 1 ");
		sqlStr.append("AND CO_STAFF_ID NOT IN (SELECT CO_STAFF_ID FROM CO_STAFFS@AMC2_PORTAL)");
		sqlStr_getNewStaffIDAMC2 = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_SITE_CODE, CO_STAFF_ID, CO_ENABLED ");
		sqlStr.append("FROM CO_STAFFS@<DBLINK> ");
		sqlStr.append("WHERE CO_STAFF_ID = ?");
		sqlStr_getStaffOtherSite = sqlStr.toString();
		
		nursingPosCode = loadNursingPositionCode();
	}
}