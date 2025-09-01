package com.hkah.web.db;

import java.util.ArrayList;

import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class AccessControlDB {
	private static Logger logger = Logger.getLogger(AccessControlDB.class);
	//======================================================================
	private final static String HKAH_IP_HEAD = "160";
	private final static String TWAH_IP_HEAD = "192";
	private final static int COL_AC_REFERER_LEN = 2000;
	public final static String CUSTOME_GRP_CODE_PREFIX = "departmental.sharing.accessGrp.";

	//======================================================================
	private static String sqlStr_insertAccessControl = null;
	private static String sqlStr_deleteAccessControl = null;

	private static String sqlStr_addAccessControlLog = null;
	private static String sqlStr_updateDocumentUrl = null;

	public static boolean add(UserBean userBean, String functionID, String siteCode, String staffID) {
		return UtilDBWeb.updateQueue(
			sqlStr_insertAccessControl,
			new String[] { functionID, siteCode, staffID, userBean.getLoginID(), userBean.getLoginID() } );
	}

	public static boolean delete(String siteCode, String staffID) {
		return UtilDBWeb.updateQueue(
			sqlStr_deleteAccessControl,
			new String[] { siteCode, staffID } );
	}

	public static ArrayList getList(UserBean userBean, String groupLevel) {
		StringBuffer sqlStr = new StringBuffer();
		// by group id
		sqlStr.append("(SELECT AF.AC_FUNCTION_ID, AC.AC_ACCESS_MODE ");
		sqlStr.append("FROM   AC_FUNCTION_ACCESS AC, AC_FUNCTION AF, CO_GROUPS G ");
		sqlStr.append("WHERE  AC.AC_FUNCTION_ID = AF.AC_FUNCTION_ID ");
		sqlStr.append("AND    AC.AC_GROUP_ID = G.CO_GROUP_ID ");
		sqlStr.append("AND   (G.CO_GROUP_LEVEL > ? ");
		// same group id
		sqlStr.append("OR     G.CO_GROUP_ID = ?) ");
		sqlStr.append("AND    AC.AC_ENABLED = 1 ");
		sqlStr.append("AND    AF.AC_ENABLED = 1 ");
		sqlStr.append("AND    G.CO_ENABLED = 1 ");
		// check whether the request from intranet
		if (ConstantsServerSide.SECURE_SERVER) {
			// not show intranet only function
			sqlStr.append("AND    AF.AC_INTRANET_ONLY = 'N' ");
		}
		sqlStr.append("GROUP BY AF.AC_FUNCTION_ID, AC.AC_ACCESS_MODE");

		sqlStr.append(") UNION (");

		// by staff id in function access
		sqlStr.append("SELECT AF.AC_FUNCTION_ID, AC.AC_ACCESS_MODE ");
		sqlStr.append("FROM   AC_FUNCTION_ACCESS AC, AC_FUNCTION AF ");
		sqlStr.append("WHERE  AC.AC_FUNCTION_ID = AF.AC_FUNCTION_ID ");
		sqlStr.append("AND    AC.AC_GROUP_ID = 'ALL' ");
		sqlStr.append("AND    AC.AC_SITE_CODE = ? ");
		sqlStr.append("AND    AC.AC_STAFF_ID = ? ");
		sqlStr.append("AND    AC.AC_ENABLED = 1 ");
		sqlStr.append("AND    AF.AC_ENABLED = 1 ");
		// check whether the request from intranet
		if (ConstantsServerSide.SECURE_SERVER) {
			// not show intranet only function
			sqlStr.append("AND    AF.AC_INTRANET_ONLY = 'N' ");
		}
		sqlStr.append("GROUP BY AF.AC_FUNCTION_ID, AC.AC_ACCESS_MODE");

		sqlStr.append(") UNION (");

		// by staff id in user group
		sqlStr.append("SELECT AF.AC_FUNCTION_ID, AC.AC_ACCESS_MODE ");
		sqlStr.append("FROM   AC_USER_GROUPS UG, AC_FUNCTION_ACCESS AC, AC_FUNCTION AF ");
		sqlStr.append("WHERE  UG.AC_GROUP_ID = AC.AC_GROUP_ID ");
		sqlStr.append("AND    AC.AC_FUNCTION_ID = AF.AC_FUNCTION_ID ");
		sqlStr.append("AND    UG.AC_SITE_CODE = ? ");
		sqlStr.append("AND    UG.AC_STAFF_ID = ? ");
		sqlStr.append("AND    UG.AC_ENABLED = 1 ");
		sqlStr.append("AND    AC.AC_ENABLED = 1 ");
		sqlStr.append("AND    AF.AC_ENABLED = 1 ");
		// check whether the request from intranet
		if (ConstantsServerSide.SECURE_SERVER) {
			// not show intranet only function
			sqlStr.append("AND    AF.AC_INTRANET_ONLY = 'N' ");
		}
		sqlStr.append("GROUP BY AF.AC_FUNCTION_ID, AC.AC_ACCESS_MODE");
		sqlStr.append(")");

		return UtilDBWeb.getReportableList(sqlStr.toString(),
				new String[] { groupLevel, userBean.getUserGroupID(), userBean.getSiteCode(), userBean.getStaffID(), userBean.getSiteCode(), userBean.getStaffID() });
	}

	public static ArrayList getGroupIDList(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT AC_GROUP_ID ");
		sqlStr.append("FROM   AC_USER_GROUPS ");
		sqlStr.append("WHERE  AC_STAFF_ID = ? ");
		sqlStr.append("AND    AC_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString(),
				new String[] { staffID });
	}

	public static ArrayList getInformationList(UserBean userBean) {
		return getInformationList(userBean, null, null);
	}

	public static ArrayList getInformationList(UserBean userBean, String category) {
		return getInformationList(userBean, category, null);
	}

	public static ArrayList getInformationList(UserBean userBean, String category, String infoName) {
		String[] parameter = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_INFORMATION_PAGE_ID, CO_INFORMATION_CATEGORY, CO_INFORMATION_TYPE, ");
		sqlStr.append("       CO_DESCRIPTION, CO_FUNCTION_ID, CO_FUNCTION_URL, CO_INFORMATION_SUB_CATEGORY, CO_DOCUMENT_ID, CO_DOCUMENT_URL, ");
		sqlStr.append("       CO_DOCUMENT_WITH_FOLDER, ");
		sqlStr.append("       CO_DOCUMENT_LATEST_FILE, ");
		sqlStr.append("       CO_DOCUMENT_SHOW_SUB_FOLDER, ");
		sqlStr.append("       CO_DOCUMENT_ONLY_CURRENT_YEAR, ");
		sqlStr.append("       CO_DOCUMENT_SHOW_POINT_FORM, ");
		sqlStr.append("       CO_FOLDER_SHOW_ROOT, ");
		sqlStr.append("       CO_TARGET_CONTENT, ");
		sqlStr.append("       CO_DOCUMENT_SHOW_ORDER, ");
		sqlStr.append("       CO_EXPAND_FOLDER ");
		sqlStr.append("FROM   CO_INFORMATION_PAGE ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		// check whether the request from intranet
		if (ConstantsServerSide.SECURE_SERVER) {
			// not show intranet only function
			sqlStr.append("AND    CO_INTRANET_ONLY = 'N' ");
		}
		// check document access if not admin
		if (userBean.isAdmin()) {
			sqlStr.append("AND   CO_ALLOW_ADMIN = 'Y' ");
		} else {
			sqlStr.append("AND   (CO_DOCUMENT_ID IS NULL OR CO_DOCUMENT_ID IN ");
			sqlStr.append("( ");

			sqlStr.append("( SELECT CO_DOCUMENT_ID ");
			sqlStr.append("FROM   CO_DOCUMENT ");
			sqlStr.append("WHERE  CO_ENABLED = 1 ");
			sqlStr.append("AND    CO_DOCUMENT_ID NOT IN (SELECT AC_DOCUMENT_ID FROM AC_DOCUMENT_ACCESS ) )");

			sqlStr.append("UNION ");

			sqlStr.append("( SELECT AC_DOCUMENT_ID ");
			sqlStr.append("FROM   AC_DOCUMENT_ACCESS ");
			sqlStr.append("WHERE  AC_ENABLED = 1 ");
			sqlStr.append("AND   ((AC_SITE_CODE = ? AND AC_STAFF_ID = ?) OR AC_GROUP_ID = ?) ) ");

			sqlStr.append("UNION ");

			sqlStr.append("( SELECT D.AC_DOCUMENT_ID ");
			sqlStr.append("FROM   AC_DOCUMENT_ACCESS D, CO_GROUPS G, AC_USER_GROUPS UG ");
			sqlStr.append("WHERE  D.AC_ENABLED = 1 ");
			sqlStr.append("AND    D.AC_GROUP_ID = G.CO_GROUP_ID ");
			sqlStr.append("AND    G.CO_GROUP_ID = UG.AC_GROUP_ID ");
			sqlStr.append("AND    UG.AC_SITE_CODE = ? ");
			sqlStr.append("AND    UG.AC_STAFF_ID = ? ) ");

			sqlStr.append(") ) " );

			// set parameter
			parameter = new String[] { userBean.getSiteCode(), userBean.getStaffID(), userBean.isStaff()?"staff":"guest", userBean.getSiteCode(), userBean.getStaffID() };
		}
		if (category != null && category.length() > 0) {
			sqlStr.append("AND   CO_INFORMATION_CATEGORY = '");
			sqlStr.append(category);
			sqlStr.append("' ");
		}
		if (infoName != null && infoName.length() > 0) {
			sqlStr.append("AND   UPPER(CO_DESCRIPTION) LIKE '%");
			sqlStr.append(infoName.toUpperCase());
			sqlStr.append("%' ");
		}
		sqlStr.append("ORDER BY CO_INFORMATION_CATEGORY, CO_INFORMATION_PAGE_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), parameter);
	}

	public static void addAccessControlLog(UserBean userBean, String functionID, String referer, String ipAddress) {
		String userID = userBean.getStaffID();
		String userType = null;
		if (userID != null && userID.length() > 0) {
			userType = "staff";
		} else {
			userType = "guest";
			userID = userBean.getLoginID();
		}

		/* Debug start */
		// find out which page cause insert error (by Ricky Leung, at 24/02/2012, disable at 36/03/2013)
		//logger.trace("Insert access log: functionID="+functionID+", referer="+referer);
		/* Debug end */

		if (referer != null && referer.length() > COL_AC_REFERER_LEN) {
			referer = referer.substring(0, COL_AC_REFERER_LEN);
		}
		if (functionID == null || functionID.trim().isEmpty()) {
			functionID = "N/A";
		}

		UtilDBWeb.updateQueue(sqlStr_addAccessControlLog,
				new String[] { functionID, referer, userType, ipAddress, userID, userBean.getLoginID(), userBean.getLoginID() });
	}

	public static void updateDocumentUrl(String category, String description, String documentUrl) {
		UtilDBWeb.updateQueue(sqlStr_updateDocumentUrl,
				new String[] { documentUrl, category, description });
	}

	public static String getPortalStatus() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PARAM1 ");
		sqlStr.append("FROM   SYSPARAM@IWEB ");
		sqlStr.append("WHERE  PARCDE = ? ");
		String portalStatus = null;

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{"PORTAL_STS"});
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			portalStatus = row.getValue(0);
		}
		return portalStatus;
	}

	public static boolean isDisablePortalFunctions() {
		return "PORTAL_DB_MIGRATE".equals(getPortalStatus());
	}

	public static String getFunctionIDbyDesc(String functionDesc) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT AC_FUNCTION_ID ");
		sqlStr.append("FROM   AC_FUNCTION ");
		sqlStr.append("WHERE  AC_FUNCTION_DESC = ? ");
		sqlStr.append("AND  AC_ENABLED = 1");
		
		String result = null;
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{functionDesc});
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			result = row.getValue(0);
		}
		return result;
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO AC_FUNCTION_ACCESS ");
		sqlStr.append("(AC_FUNCTION_ID, AC_SITE_CODE, AC_STAFF_ID, AC_ACCESS_MODE, AC_CREATED_USER, AC_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, 'F', ?, ?)");
		sqlStr_insertAccessControl = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE AC_FUNCTION_ACCESS ");
		sqlStr.append("WHERE  AC_ENABLED = 1 ");
		sqlStr.append("AND    AC_SITE_CODE = ? ");
		sqlStr.append("AND    AC_STAFF_ID = ? ");
		sqlStr_deleteAccessControl = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO AC_FUNCTION_ACCESS_LOG ");
		sqlStr.append("(AC_FUNCTION_ID, AC_REFERER, AC_USER_TYPE, AC_IP_ADDRESS, AC_USER_ID, AC_CREATED_USER, AC_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ?, ?)");
		sqlStr_addAccessControlLog = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_INFORMATION_PAGE ");
		sqlStr.append("SET    CO_DOCUMENT_URL = ? ");
		sqlStr.append("WHERE  CO_INFORMATION_CATEGORY = ? ");
		sqlStr.append("AND    CO_INFORMATION_TYPE = 'DOCUMENT' ");
		sqlStr.append("AND    CO_DESCRIPTION = ? ");
		sqlStr_updateDocumentUrl = sqlStr.toString();
	}
}