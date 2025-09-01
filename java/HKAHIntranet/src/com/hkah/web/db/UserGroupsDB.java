package com.hkah.web.db;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.UserBean;

public class UserGroupsDB {

	private static String sqlStr_insertUserGroups = null;
	private static String sqlStr_deleteUserGroups = null;

	public static boolean add(UserBean userBean, String groupID, String siteCode, String staffID) {
		// get co_staff_id from co_user

		return UtilDBWeb.updateQueue(
				sqlStr_insertUserGroups,
			//(AC_SITE_CODE, AC_STAFF_ID, AC_GROUP_ID, AC_CREATED_USER, AC_MODIFIED_USER)
			new String[] {siteCode, staffID, groupID, userBean.getLoginID(), userBean.getLoginID() } );
	}

	public static boolean delete(String siteCode, String staffID) {
		return UtilDBWeb.updateQueue(
				sqlStr_deleteUserGroups,
			new String[] { siteCode, staffID } );
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO AC_USER_GROUPS ");
		sqlStr.append("(AC_SITE_CODE, AC_STAFF_ID, AC_GROUP_ID, AC_CREATED_USER, AC_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?)");
		sqlStr_insertUserGroups = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE AC_USER_GROUPS ");
		sqlStr.append("WHERE  AC_ENABLED = 1 ");
		sqlStr.append("AND    AC_SITE_CODE = ? ");
		sqlStr.append("AND    AC_STAFF_ID = ? ");
		sqlStr_deleteUserGroups = sqlStr.toString();

	}
}