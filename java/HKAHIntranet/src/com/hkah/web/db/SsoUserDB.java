/*
 * Created on April 9, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class SsoUserDB {
	private static Logger logger = Logger.getLogger(SsoUserDB.class);

	/*
	 * User details update from:
	 *
	 * SSO_USER_ID
	 * STAFF_NO			(CIS
	 * FIRST_NAME
	 * LAST_NAME
	 * GIVEN_NAME
	 * DISPLAY_NAME		(HR System, CIS)
	 * CN_FIRST_NAME	(HR System)
	 * CN_LAST_NAME		(HR System)
	 * MOBILE_PHONE_NO
	 * HOME_PHONE_NO
	 * OFFICE_PHONE_NO
	 * PAGER_NO
	 * QUAL
	 * USER_TYPE		(CIS)
	 *
	 */

	private static String sqlStr_getCISAhSysUser = null;
	private static String sqlStr_getPortalUser = null;
	private static String sqlStr_permDeleteSsoUser = null;
	private static String sqlStr_resetUserMappingByModule = null;
	private static String sqlStr_getSsoUserIdByModuleUser = null;
	private static String sqlStr_getModuleUserIdBySsoUserId = null;
	private static String sqlStr_isExistUserMapping = null;
	private static String sqlStr_isExistUserMappingByModule = null;
	private static String sqlStr_getSsoUsers = null;
	private static String sqlStr_getSsoUserBySsoUserId = null;
	private static String sqlStr_insertSsoUser = null;
	private static String sqlStr_enableSsoUser = null;
	private static String sqlStr_insertSsoUserMin = null;
	private static String sqlStr_insertSsoUserMapping = null;
	private static String sqlStr_updateSsoUserDetails = null;
	private static String sqlStr_updateSsoUserDetailsFromHRStaff = null;
	private static String sqlStr_updateSsoUserFromCIS = null;
	private static String sqlStr_updateSsoMappingModuleUserId = null;
	private static String sqlStr_enableSsoUserMapping = null;
	private static String sqlStr_deleteSsoMapping = null;
	private static String sqlStr_deleteAllSsoMapping = null;
	private static String sqlStr_disableAllSsoMapping = null;
	private static String sqlStr_deleteSsoUser = null;
	private static String sqlStr_getSsoUserMappingByModule = null;
	private static String sqlStr_getSsoUserByStaffNo = null;
	private static String sqlStr_getAllSsoUserMappingByModule = null;
	private static String sqlStr_selectAccessStaff = null;
	private static String sqlStr_selectTWAHStaff = null;
	private static String sqlStr_isPortalStaffDisabled = null;
	private static String sqlStr_isSsoStaffDisabled = null;
	private static String sqlStr_insertSsoSessionId = null;
	private static String sqlStr_updateSsoSessionId = null;
	private static String sqlStr_deleteSsoSessionId = null;
	private static String sqlStr_deleteInactiveSsoSessionId = null;

	private static String SSO_MODULE_CODE_HK_CIS = "cis";
	private static String SSO_MODULE_CODE_HK_EWELL_MCS = "mcs";
	private static String SSO_MODULE_CODE_TW_EWELL_MCS = "mcs";
	private static String SSO_MODULE_CODE_HK_PORTAL = "hk.portal";
	private static String SSO_MODULE_CODE_TW_PORTAL = "hk.portal";

	private static String CIS_USER_DEPT_DOCTOR = "DR";
	private static String CIS_USER_DEPT_PHARMACY = "PX";
	private static String CIS_USER_DEPT_NURSE = "NX";

	private static String SSO_USER_TYPE_DOCTOR = "DOCTOR";
	private static String SSO_USER_TYPE_NURSE = "NURSE";
	private static String SSO_USER_TYPE_STAFF = "STAFF";

	public static ArrayList getList(String ssoUserId, String staffNo, String name, String enabled) {
		// fetch user
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	SSO_USER_ID, STAFF_NO, ");
		sqlStr.append("			FIRST_NAME, LAST_NAME, GIVEN_NAME, DISPLAY_NAME, ");
		sqlStr.append("			CN_FIRST_NAME, CN_LAST_NAME, ");
		sqlStr.append("			MOBILE_PHONE_NO, HOME_PHONE_NO, OFFICE_PHONE_NO, PAGER_NO, ");
		sqlStr.append("			QUAL, USER_TYPE, ENABLED ");
		sqlStr.append("FROM   	SSO_USER ");
		sqlStr.append("WHERE   	1=1 ");
		if (ssoUserId != null && ssoUserId.length() > 0) {
			sqlStr.append("AND    TRIM(SSO_USER_ID) LIKE '%");
			sqlStr.append(ssoUserId.trim());
			sqlStr.append("%' ");
		}
		if (staffNo != null && staffNo.length() > 0) {
			sqlStr.append("AND    TRIM(STAFF_NO) LIKE '%");
			sqlStr.append(staffNo.trim());
			sqlStr.append("%' ");
		}
		if (enabled != null && enabled.length() > 0) {
			sqlStr.append("AND    ENABLED = '" + enabled + "'");
		}
		if (name != null && name.length() > 0) {
			sqlStr.append("AND   ( UPPER(TRIM(FIRST_NAME)) LIKE '%");
			sqlStr.append(name.trim().toUpperCase());
			sqlStr.append("%' ");
			sqlStr.append("  OR	 UPPER(TRIM(LAST_NAME)) LIKE '%");
			sqlStr.append(name.trim().toUpperCase());
			sqlStr.append("%' ");
			sqlStr.append("  OR	 UPPER(TRIM(GIVEN_NAME)) LIKE '%");
			sqlStr.append(name.trim().toUpperCase());
			sqlStr.append("%' ");
			sqlStr.append("  OR	 UPPER(TRIM(DISPLAY_NAME)) LIKE '%");
			sqlStr.append(name.trim().toUpperCase());
			sqlStr.append("%' ");
			sqlStr.append("  OR	 UPPER(TRIM(CN_FIRST_NAME)) LIKE '%");
			sqlStr.append(name.trim().toUpperCase());
			sqlStr.append("%' ");
			sqlStr.append("  OR	 UPPER(TRIM(CN_LAST_NAME)) LIKE '%");
			sqlStr.append(name.trim().toUpperCase());
			sqlStr.append("%' ) ");
		}
		sqlStr.append("ORDER BY SSO_USER_ID");

		//System.out.println("[SsoUserDB] getList="+sqlStr.toString());
		
		/* Not designed for out of non-intranet use */
		return UtilDBWeb.getReportableListSEED(sqlStr.toString());
	}

	public static ArrayList getMappingList(String ssoUserId) {
		// fetch user mapping
		List<String> params = new ArrayList<String>();

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	UM.SSO_USER_ID, UM.MODULE_CODE, M.DESCRIPTION, UM.MODULE_USER_ID ");
		sqlStr.append("FROM   	SSO_USER_MAPPING UM LEFT JOIN SSO_MODULE M ");
		sqlStr.append("				ON UM.MODULE_CODE = M.MODULE_CODE ");
		sqlStr.append("WHERE   	UM.ENABLED = 1 ");
		if (ssoUserId != null && ssoUserId.length() > 0) {
			sqlStr.append("AND    UM.SSO_USER_ID = ? ");
			params.add(ssoUserId);
		}
		sqlStr.append("ORDER BY UM.SSO_USER_ID, UM.MODULE_CODE, UM.MODULE_USER_ID");

		/* Not designed for out of non-intranet use */
		return UtilDBWeb.getReportableListSEED(sqlStr.toString(), (String[]) params.toArray(new String[params.size()]));
	}

	public static ArrayList getSsoModuleList() {
		// fetch sso module
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	MODULE_CODE, DESCRIPTION ");
		sqlStr.append("FROM   	SSO_MODULE ");
		sqlStr.append("ORDER BY MODULE_CODE");

		/* Not designed for out of non-intranet use */
		return UtilDBWeb.getReportableListSEED(sqlStr.toString());
	}
	
	public static ArrayList getSsoUserIdByModuleUser(String moduleCode, String moduleUserId) {
		return UtilDBWeb.getReportableListSEED(sqlStr_getSsoUserIdByModuleUser.toString(), new String[]{moduleCode, moduleUserId});
	}
	
	public static ArrayList getModuleUserIdBySsoUserId(String moduleCode, String ssoUserId) {
		return UtilDBWeb.getReportableListSEED(sqlStr_getModuleUserIdBySsoUserId.toString(), new String[]{moduleCode, ssoUserId});
	}
	
	public static void getAllTWAHUserFromMasterSystem(UserBean userBean) {
			Map<String, String> userIds2 = new HashMap<String, String>(); // userId -> system from
			List<String> addEwellUsers = new ArrayList<String>(); // userId -> system from

			try {
				ArrayList result = null;
				ReportableListObject rlo = null;

				result = UtilDBWeb.getReportableList(sqlStr_getPortalUser);
			   
				if (result.size() > 0) {
					for (int i = 0; i < result.size(); i++) {
						rlo = (ReportableListObject) result.get(i);
						String staffId = rlo.getValue(7);
						if (staffId != null && !staffId.isEmpty())
							userIds2.put(staffId, SSO_MODULE_CODE_TW_PORTAL);
					}
				}
				
				// insert into sso_user
				Set<String> keys = userIds2.keySet();
				Iterator<String> itr = keys.iterator();
				
				while (itr.hasNext()) {
					String userId = itr.next();
					boolean updateDetails = false;
					String system = userIds2.get(userId);

					if (SSO_MODULE_CODE_TW_PORTAL.equals(system)) {
						if (!SsoUserDB.isUserExist(userId)) {
							UtilDBWeb.updateQueueSEED(sqlStr_permDeleteSsoUser, new String[]{userId});

							// insert
							List list = StaffDB.get(userId);
							ReportableListObject rlo2 = (ReportableListObject) list.get(0);
							String staffname = rlo2.getFields3();
							System.out.println("Insert new user id <" + userId + ", "+staffname+"> from master source (Portal) to SSO.");
							
							if (!UtilDBWeb.updateQueueSEED(
									sqlStr_insertSsoUserMin,
									new String[] {userId, userId, staffname})) {
								System.err.println("Fail to insert new user in sso_user.");
							} else {
								updateDetails = true;
							}
						}

						// DO NOT update details if user already exists
						if (updateDetails) {
							System.out.println("Update user id <" + userId + "> from master source (Portal) to SSO.");

							// update user details
							if (SSO_MODULE_CODE_TW_PORTAL.equals(system)) {
								updateSsoUserDetailsFromHRStaff(userBean, userId);
							}

							// enable old disabled user mapping
							UtilDBWeb.updateQueueSEED(sqlStr_enableSsoUserMapping,
									new String[]{"SYSTEM", userId});

							// add sso_user_mapping (portal)
							UtilDBWeb.updateQueueSEED(sqlStr_insertSsoUserMapping,
									new String[]{SSO_MODULE_CODE_TW_PORTAL, UserDB.getUserName(userId), userId,
									userBean != null ? userBean.getLoginID() : "SYSTEM", userBean != null ? userBean.getLoginID() : "SYSTEM"});

							// add sso_user_mapping (mcs)
							UtilDBWeb.updateQueueSEED(sqlStr_insertSsoUserMapping,
									new String[]{SSO_MODULE_CODE_TW_EWELL_MCS, userId.toLowerCase(), userId,
									userBean != null ? userBean.getLoginID() : "SYSTEM", userBean != null ? userBean.getLoginID() : "SYSTEM"});

							// add mail alert list
							addEwellUsers.add(userId);
						}
					}
				}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void adddUserFromMasterSystem() {
		if (ConstantsServerSide.isHKAH()) {
			getAllHKAHUserFromMasterSystem(null);
		} else if (ConstantsServerSide.isTWAH()) {
			getAllTWAHUserFromMasterSystem(null);
		}
		disableUserFromMasterSystem(null);
	}

	public static void getAllHKAHUserFromMasterSystem(UserBean userBean) {

		// Master system include Portal
//		DataSource dsCIS = null;
//		DataSource dsPortal = null;
//		DataSource dsSEED = null;
		Map<String, String> userIds2 = new HashMap<String, String>(); // userId -> system from
		List<String> addEwellUsers = new ArrayList<String>(); // userId -> system from

		try {
//			dsCIS = HKAHInitServlet.getDataSourceCIS();
//			dsPortal = HKAHInitServlet.getDataSourceIntranet();
//			dsSEED = HKAHInitServlet.getDataSourceSEED();

			ArrayList result = null;
			ReportableListObject rlo = null;

			/*
			result = UtilDBWeb.getReportableList(dsCIS, sqlStr_getCISAhSysUser);
			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);
					if (rlo.getValue(0) != null && !rlo.getValue(0).isEmpty())
						userIds2.put(rlo.getValue(0), SSO_MODULE_CODE_HK_CIS);
				}
			}
			*/

			result = UtilDBWeb.getReportableList(sqlStr_getPortalUser);

			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);
					String staffId = rlo.getValue(7);
					if (staffId != null && !staffId.isEmpty())
						userIds2.put(staffId, SSO_MODULE_CODE_HK_PORTAL);
				}
			}

			// insert into sso_user
			Set<String> keys = userIds2.keySet();
			Iterator<String> itr = keys.iterator();
			while (itr.hasNext()) {
				String userId = itr.next();
				boolean updateDetails = false;
				String system = userIds2.get(userId);

				if (SSO_MODULE_CODE_HK_PORTAL.equals(system) ||
						(SSO_MODULE_CODE_HK_CIS.equals(system) && userId.toUpperCase().startsWith("DR"))) {
					if (!SsoUserDB.isUserExist(userId)) {
						UtilDBWeb.updateQueueSEED(sqlStr_permDeleteSsoUser, new String[]{userId});

						// insert
						List list = StaffDB.get(userId);
						ReportableListObject rlo2 = (ReportableListObject) list.get(0);
						String staffname = rlo2.getFields3();
						System.out.println("Insert new user id <" + userId + ", "+staffname+"> from master source (Portal) to SSO.");
						if (!UtilDBWeb.updateQueueSEED(
								sqlStr_insertSsoUserMin,
								new String[] {userId, userId, staffname})) {
							System.err.println("Fail to insert new user in sso_user.");
						} else {
							updateDetails = true;
						}
					}

					// DO NOT update details if user already exists
					if (updateDetails) {
						// update user details
						if (SSO_MODULE_CODE_HK_CIS.equals(system)) {
							updateSsoUserFromCIS(userBean, userId);
						} else if (SSO_MODULE_CODE_HK_PORTAL.equals(system)) {
							updateSsoUserDetailsFromHRStaff(userBean, userId);
						}

						// add sso_user_mapping (portal)
						UtilDBWeb.updateQueueSEED(sqlStr_insertSsoUserMapping,
								new String[]{SSO_MODULE_CODE_HK_PORTAL, UserDB.getUserName(userId), userId,
								userBean != null ? userBean.getLoginID() : "SYSTEM", userBean != null ? userBean.getLoginID() : "SYSTEM"});

						// add sso_user_mapping (mcs)
						UtilDBWeb.updateQueueSEED(sqlStr_insertSsoUserMapping,
								new String[]{SSO_MODULE_CODE_HK_EWELL_MCS, userId.toLowerCase(), userId,
								userBean != null ? userBean.getLoginID() : "SYSTEM", userBean != null ? userBean.getLoginID() : "SYSTEM"});

						// add mail alert list
						addEwellUsers.add(userId);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void disableUserFromMasterSystem(UserBean userBean) {
		// Master system include Portal and CIS
//		DataSource dsPortal = null;
//		DataSource dsSEED = null;
		ArrayList resultSso = null;
		ArrayList resultHr = null;

		try {
//			dsSEED = HKAHInitServlet.getDataSourceSEED();
//			dsPortal = HKAHInitServlet.getDataSourceIntranet();
			resultSso = UtilDBWeb.getReportableListSEED(sqlStr_getSsoUsers);

			List<String> disableStaffIDs = new ArrayList<String>();
			String ssoUserId = null;
			String staffId = null;
			for (int i = 0; i < resultSso.size(); i++) {
				ReportableListObject rlo = (ReportableListObject) resultSso.get(i);
				ssoUserId = rlo.getValue(0);
				staffId = rlo.getValue(1);

				resultHr = UtilDBWeb.getReportableList(sqlStr_isPortalStaffDisabled, new String[]{staffId});
				if (resultHr != null && !resultHr.isEmpty()) {
					// disable user in SSO that also disabled in portal
					disableStaffIDs.add(staffId);
					boolean success = UtilDBWeb.updateQueueSEED(sqlStr_deleteSsoUser,
							new String[] { userBean != null ? userBean.getLoginID() : "SYSTEM", ssoUserId });
					if (success) {
						// disable sso_user_mapping
						UtilDBWeb.updateQueueSEED(sqlStr_disableAllSsoMapping,
								new String[] {"SYSTEM", ssoUserId });
					}
					System.out.println("SSO user with Staff ID:" + staffId + " is disabled in Intranet Portal (Synchronized with HR staff list).\n" +
							"Disable SSO user (together with user mapping) with this Staff ID: " + staffId +" (" + (success ? "success" : "fail") + ")");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void getAllUserFromMasterSystem() {
		System.out.println(new Date() + "=== SsoUserDB.getAllUserFromMasterSystem  ===");

		if (ConstantsServerSide.isHKAH()) {
			getAllHKAHUserFromMasterSystem(null);
		} else if (ConstantsServerSide.isTWAH()) {
			getAllTWAHUserFromMasterSystem(null);
		}
		disableUserFromMasterSystem(null);
	}

	public static ArrayList get(UserBean userBean) {
		return get(userBean, null);
	}

	public static ArrayList get(UserBean userBean, String staffId) {
		ArrayList result = null;
		Connection conn = null;
		try {
			Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
			conn = DriverManager.getConnection("jdbc:odbc:stafflist");

			String sql = sqlStr_selectAccessStaff;
			String[] param =  new String[1];
			if (staffId != null) {
				sql += " WHERE [Staff No] = ?";
				param[0] = staffId;
			}
			result = UtilDBWeb.getReportableList(conn, sql, param);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	public static boolean add(UserBean userBean, String ssoUserId, String staffNo,
			String firstName, String lastName, String givenName, String displayName,
			String cnFirstName, String cnLastName,
			String mobilePhoneNo, String homePhoneNo, String officePhoneNo, String pagerNo,
			String qual, String userType) {
		return UtilDBWeb.updateQueueSEED(sqlStr_insertSsoUser,
				new String[] { ssoUserId, staffNo, firstName, lastName, givenName,
				displayName, cnFirstName, cnLastName, mobilePhoneNo, homePhoneNo,
				officePhoneNo, pagerNo, qual, userType, userBean.getLoginID(), userBean.getLoginID()} );
	}

	public static boolean update(UserBean userBean, String ssoUserId, String staffNo,
			String firstName, String lastName, String givenName, String displayName,
			String cnFirstName, String cnLastName,
			String mobilePhoneNo, String homePhoneNo, String officePhoneNo, String pagerNo,
			String qual, String userType) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE	SSO_USER ");
		sqlStr.append("SET		STAFF_NO = ? ");
		sqlStr.append("			, FIRST_NAME = ? ");
		sqlStr.append("			, LAST_NAME = ? ");
		sqlStr.append("			, GIVEN_NAME = ? ");
		sqlStr.append("			, DISPLAY_NAME = ? ");
		sqlStr.append("			, CN_FIRST_NAME = ? ");
		sqlStr.append("			, CN_LAST_NAME = ? ");
		sqlStr.append("			, MOBILE_PHONE_NO = ? ");
		sqlStr.append("			, HOME_PHONE_NO = ? ");
		sqlStr.append("			, OFFICE_PHONE_NO = ? ");
		sqlStr.append("			, PAGER_NO = ? ");
		sqlStr.append("			, QUAL = ? ");
		sqlStr.append("			, USER_TYPE = ? ");
		sqlStr.append("			, UPDATED_USER = ? ");
		sqlStr.append("			, UPDATED_DATE = sysdate ");
		sqlStr.append("WHERE	SSO_USER_ID = ?");
		return UtilDBWeb.updateQueueSEED(
				sqlStr.toString(),
				new String[] { staffNo, firstName, lastName, givenName, displayName,
					cnFirstName, cnLastName, mobilePhoneNo, homePhoneNo, officePhoneNo, pagerNo,
					qual, userType, userBean.getLoginID(), ssoUserId });
	}
	
	public static boolean enableSsoUser(UserBean userBean, String ssoUserId) {
		boolean success = UtilDBWeb.updateQueueSEED(sqlStr_enableSsoUser,
				new String[] { userBean == null ? "SYSTEM" : userBean.getLoginID(), ssoUserId} );
		if (success) {
			UtilDBWeb.updateQueueSEED(sqlStr_enableSsoUserMapping,
					new String[] { userBean == null ? "SYSTEM" : userBean.getLoginID(), ssoUserId} );
		}
		
		return success;
	}

	public static void updateSsoUserDetailsFromHRStaff(UserBean userBean) {
		updateSsoUserDetailsFromHRStaff(userBean, null);
	}

	public static void updateSsoUserDetailsFromHRStaff(UserBean userBean, String staffId) {
		Connection conn = null;
		try {
			ArrayList result = StaffDB.get(staffId, "1");
			ReportableListObject rlo = null;

			/*
		sqlStr.append("SELECT S.CO_SITE_CODE, S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       S.CO_STAFFNAME, ");
		sqlStr.append("       S.CO_STATUS, TO_CHAR(S.CO_ANNUAL_INCR, 'MM'), TO_CHAR(S.CO_HIRE_DATE, 'DD/MM/YYYY'), S.CO_CATEGORY, ");
		sqlStr.append("		  S.CO_POSITION_1, S.CO_POSITION_2, TO_CHAR(CO_TERMINATION_DATE,'DD/MM/YYYY'), S.CO_HOSP_NO, S.CO_FIX_DEPARTMENT_CODE, S.CO_MARK_DELETED, S.CO_ENABLED, ");
		sqlStr.append("		  S.CO_POSITION_CODE, S.CO_CHI_NAME, S.CO_LASTNAME, S.CO_FIRSTNAME, S.CO_EMAIL, S.CO_JOB_CODE, S.CO_JOB_DESCRIPTION, S.CO_DISPLAY_NAME, ");
		sqlStr.append("       TO_CHAR(S.CO_CREATED_DATE, 'DD/MM/YYYY HH24:MI:SS'), S.CO_CREATED_USER, TO_CHAR(S.CO_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI:SS'), S.CO_MODIFIED_USER ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE(+) ");
		sqlStr.append("AND    S.CO_ENABLED = ? ");
		sqlStr.append("AND    S.CO_STAFF_ID = ? ");
			 */
			if (result.size() > 0) {
				String staffID = null;
				String staffName = null;
				String lastname = null;
				String firstname = null;
				String cname = null;
				String qual = null;

				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					staffID = rlo.getValue(0);
					staffName = TextUtil.parseStr(rlo.getValue(3));
					lastname = TextUtil.parseStr(rlo.getValue(17));
					firstname = TextUtil.parseStr(rlo.getValue(18));
					cname = TextUtil.parseStr(rlo.getValue(16));
					//qual = TextUtil.parseStr(rlo.getValue(8));

					if (SsoUserDB.isUserExist(staffID)) {
						if (!UtilDBWeb.updateQueueSEED(
								sqlStr_updateSsoUserDetailsFromHRStaff,
								new String[] {
										staffName,
										firstname,
										lastname,
										cname,
										qual,
										userBean == null ? null : userBean.getLoginID(),
										staffID
								} )) {
							System.out.println("Failed to update sso user id <" + staffID + ">.");
						} else {
							System.out.println("Update sso user id <" + staffID + ">.");
						}
					} else {
						System.err.println("User id (staff id) " + staffID + " not exist in the SSO system.");
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void updateSsoUserFromCIS(UserBean userBean) {
		updateSsoUserFromCIS(userBean, null);
	}

	public static void updateSsoUserFromCIS(UserBean userBean, String a_userId) {
//		DataSource dsCIS = null;
//		DataSource dsSEED = null;
		try {
//			dsCIS = HKAHInitServlet.getDataSourceCIS();
//			dsSEED = HKAHInitServlet.getDataSourceSEED();

			ArrayList result = null;
			String sql = sqlStr_getCISAhSysUser;
			String[] param = null;
			if (a_userId != null) {
				sql += " AND USER_ID = ?";
				param = new String[]{a_userId};
			} else {
				param = new String[]{};
			}
			result = UtilDBWeb.getReportableListCIS(sql, param);
			ReportableListObject rlo = null;

			if (result.size() > 0) {
				String userId = null;
				String userName = null;
				String userDept = null;
				String userTeam = null;
				String userType = null;

				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					userId = rlo.getValue(0);
					userName = rlo.getValue(1);
					userDept = rlo.getValue(3);
					userTeam = rlo.getValue(4);

					if (CIS_USER_DEPT_DOCTOR.equals(userDept)) {
						userType = SSO_USER_TYPE_DOCTOR;
					} else if (CIS_USER_DEPT_NURSE.equals(userDept)) {
						userType = SSO_USER_TYPE_NURSE;
					}

					// update/insert user mapping
					if (SsoUserDB.isUserExist(userId)) {
						// update user details
						System.out.println("Update existing user details id <" + userId + "> already exist.");

						if (!UtilDBWeb.updateQueueSEED(
								sqlStr_updateSsoUserFromCIS,
								new String[] {
										userName,
										userType,
										"SYSTEM",
										userId
								} )) {
							System.err.println("[" + userId + "] update user fail");
						}
					} else {
						// insert
						System.out.println("Insert new user id <" + userId + "> from master source (CIS).");
						if (!UtilDBWeb.updateQueueSEED(
								sqlStr_insertSsoUserMin,
								new String[] {userId, userId, userName})) {
							System.err.println("Fail to insert new user in sso_user.");
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void updateSsoMappingUser(UserBean userBean) {
		System.out.println(new Date() + "=== SsoUserDB.updateSsoMappingUser  ===");

		if (ConstantsServerSide.isHKAH()) {
			updateHKAHSsoMappingUserFromCIS(userBean);
		} else if (ConstantsServerSide.isTWAH()) {
			updateTWAHSsoMappingUser(userBean);
		}

	}

	public static void updateTWAHSsoMappingUser(UserBean userBean) {
//		DataSource dsSEED = null;

		try {
//			dsSEED = HKAHInitServlet.getDataSourceSEED();

			ArrayList result = UtilDBWeb.getReportableList(sqlStr_getPortalUser);
			ReportableListObject rlo = null;

			if (result.size() > 0) {
				// reset all user mapping status
				UtilDBWeb.updateQueueSEED(sqlStr_resetUserMappingByModule, new String[]{SSO_MODULE_CODE_TW_PORTAL});

				String userId = null;
				String userName = null;

				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					userName = rlo.getValue(0);
					userId = rlo.getValue(7);

					// update/insert user mapping
					if (SsoUserDB.isUserMapingExist(SSO_MODULE_CODE_TW_PORTAL, userId, userId)) {
						// update user
						System.out.println("User id <" + userId + "> already exist.");
					} else {
						// insert
						System.out.println("Insert new user id <" + userId + "> for module code <" + SSO_MODULE_CODE_TW_PORTAL + ">.");
						if (!UtilDBWeb.updateQueueSEED(
								sqlStr_insertSsoUserMapping,
								new String[] {SSO_MODULE_CODE_TW_PORTAL, userName, userId, userBean.getLoginID(), userBean.getLoginID()})) {
							System.err.println("Fail to insert new user in sso_user_mapping (module code: " + SSO_MODULE_CODE_TW_PORTAL + ", module user id: " + userId + ", sso user id: " + userId);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void updateHKAHSsoMappingUserFromCIS(UserBean userBean) {
//		DataSource dsCIS = null;
//		DataSource dsSEED = null;
		try {
//			dsCIS = HKAHInitServlet.getDataSourceCIS();
//			dsSEED = HKAHInitServlet.getDataSourceSEED();

			ArrayList result = UtilDBWeb.getReportableListCIS(sqlStr_getCISAhSysUser);
			ReportableListObject rlo = null;

			if (result.size() > 0) {
				// reset all user mapping status
				UtilDBWeb.updateQueueSEED(sqlStr_resetUserMappingByModule, new String[]{SSO_MODULE_CODE_HK_CIS});

				String userId = null;
				String userName = null;

				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					userId = rlo.getValue(0);
					userName = rlo.getValue(1);

					// update/insert user mapping
					if (SsoUserDB.isUserMapingExist(SSO_MODULE_CODE_HK_CIS, userId, userId)) {
						// update user
						System.out.println("User id <" + userId + "> already exist.");
						/*
						ArrayList ssoUser = SsoUserDB.get(userId);
						if (staff != null && staff.size() > 0) {
							ReportableListObject rlo2 = (ReportableListObject) staff.get(0);

							if (rlo2 != null && !"3784".equals(staffID)) {
								String curDeptCode = rlo2.getValue(1);
								staffPortalDeptCodes.put(staffID, curDeptCode);
								staffHRDeptCodes.put(staffID, deptCode);
							}
						}

						if (!UtilDBWeb.updateQueue(
								sqlStr_updateStaff2,
								new String[] {
										TextUtil.parseStr(rlo.getValue(1)),
//										deptCode,
										TextUtil.parseStr(rlo.getValue(3)),
										TextUtil.parseStr(rlo.getValue(4)),
										TextUtil.parseStr(rlo.getValue(5)),
										ConstantsServerSide.SITE_CODE,
										staffID
								} )) {
							System.err.println("[" + staffID + "] update staff fail");
						}
						*/
					} else {
						// insert
						System.out.println("Insert new user id <" + userId + "> for module code <" + SSO_MODULE_CODE_HK_CIS + ">.");
						if (!UtilDBWeb.updateQueueSEED(
								sqlStr_insertSsoUserMapping,
								new String[] {SSO_MODULE_CODE_HK_CIS, userId, userId, userBean.getLoginID(), userBean.getLoginID()})) {
							System.err.println("Fail to insert new user in sso_user_mapping (module code: " + SSO_MODULE_CODE_HK_CIS + ", module user id: " + userId + ", sso user id: " + userId);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void updateSsoMappingUserForPortal(UserBean userBean) {
//		DataSource dsIntranet = null;
//		DataSource dsSEED = null;
		try {
//			dsIntranet = HKAHInitServlet.getDataSourceIntranet();
//			dsSEED = HKAHInitServlet.getDataSourceSEED();

			ArrayList result = UtilDBWeb.getReportableList(sqlStr_getPortalUser);
			ReportableListObject rlo = null;

			/*
		sqlStr.append("SELECT U.CO_USERNAME, S.CO_STAFFNAME, U.CO_GROUP_ID, G.CO_GROUP_DESC, ");
		sqlStr.append("       U.CO_SITE_CODE, S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       U.CO_STAFF_ID, S.CO_CATEGORY, S.CO_ENABLED, G.CO_GROUP_LEVEL, ");
		sqlStr.append("       U.CO_REMARK_1, U.CO_REMARK_2, U.CO_REMARK_3, TO_CHAR(S.CO_HIRE_DATE,'dd/mm/yyyy') ");
		sqlStr.append("FROM   CO_USERS U, CO_GROUPS G, CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  U.CO_GROUP_ID = G.CO_GROUP_ID ");
		sqlStr.append("AND    U.CO_SITE_CODE = S.CO_SITE_CODE (+) ");
		sqlStr.append("AND    U.CO_STAFF_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    U.CO_ENABLED = 1 ");
			 */

			if (result.size() > 0) {
				// reset all user mapping status
				UtilDBWeb.updateQueueSEED(sqlStr_resetUserMappingByModule, new String[]{SSO_MODULE_CODE_HK_PORTAL});

				String staffId = null;
				String userName = null;

				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					userName = rlo.getValue(0);
					staffId = rlo.getValue(7);

					// update/insert user mapping
					if (SsoUserDB.isUserMapingExist(SSO_MODULE_CODE_HK_PORTAL, staffId, staffId)) {
						// update user
						System.out.println("(Module " + SSO_MODULE_CODE_HK_PORTAL + ") User id <" + staffId + "> already exist.");
					} else {
						// insert
						System.out.println("Insert new user id <" + staffId + "> for module code <" + SSO_MODULE_CODE_HK_PORTAL + ">.");
						if (!UtilDBWeb.updateQueueSEED(
								sqlStr_insertSsoUserMapping,
								new String[] {SSO_MODULE_CODE_HK_PORTAL, userName, staffId, userBean.getLoginID(), userBean.getLoginID()})) {
							System.err.println("Fail to insert new user in sso_user_mapping (module code: " + SSO_MODULE_CODE_HK_PORTAL + ", module user id: " + staffId + ", sso user id: " + staffId);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void initEwellUserFromCIS(UserBean userBean) {
//		DataSource dsSEED = null;
		try {
//			dsSEED = HKAHInitServlet.getDataSourceSEED();

			ArrayList result = UtilDBWeb.getReportableListSEED(sqlStr_getAllSsoUserMappingByModule,
					new String[]{SSO_MODULE_CODE_HK_CIS});
			ReportableListObject rlo = null;

			if (result.size() > 0) {
				String moduleCode = null;
				String moduleUserId = null;
				String ssoUserId = null;

				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					//moduleCode = rlo.getValue(0);
					moduleUserId = rlo.getValue(1);
					ssoUserId = rlo.getValue(2);

					// update/insert user mapping
					if (SsoUserDB.isUserMapingExist(SSO_MODULE_CODE_HK_EWELL_MCS, moduleUserId, ssoUserId)) {
						// update user
						System.out.println("Module user id <" + moduleUserId + "> already exist for module <" + SSO_MODULE_CODE_HK_EWELL_MCS + ">.");
					} else {
						// insert
						System.out.println("Copy new module user id <" + moduleUserId + "> from Module " + SSO_MODULE_CODE_HK_EWELL_MCS + ".");
						if (!UtilDBWeb.updateQueueSEED(
								sqlStr_insertSsoUserMapping,
								new String[] {SSO_MODULE_CODE_HK_EWELL_MCS, moduleUserId, ssoUserId, userBean.getLoginID(), userBean.getLoginID()})) {
							System.err.println("Fail to insert new user mapping in sso_user.");
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static boolean insertSsoMapping(UserBean userBean, String ssoUserId, String moduleCode, String moduleUserId) {
		return UtilDBWeb.updateQueueSEED(sqlStr_insertSsoUserMapping,
				new String[] { moduleCode, moduleUserId, ssoUserId, userBean.getLoginID(), userBean.getLoginID()} );
	}

	public static boolean updateSsoMappingModuleUserId(UserBean userBean, String ssoUserId, String moduleCode, String moduleUserId) {
		//if (isUserMapingExist(moduleCode, moduleUserId, ssoUserId)) {
			return UtilDBWeb.updateQueueSEED(sqlStr_updateSsoMappingModuleUserId,
					new String[] { moduleUserId, userBean.getLoginID(), ssoUserId, moduleCode} );
		//} else {
		//	return UtilDBWeb.updateQueueSEED(sqlStr_insertSsoUserMapping,
		//			new String[] { moduleCode, moduleUserId, ssoUserId, userBean.getLoginID(), userBean.getLoginID() } );
		//}
	}

	public static boolean isUserMapingExist(String moduleCode, String moduleUserId, String ssoUserId) {
		ArrayList result = UtilDBWeb.getReportableListSEED(sqlStr_isExistUserMapping, new String[]{moduleCode, moduleUserId, ssoUserId});
		if (result != null && result.size() > 0) {
			return true;
		} else {
			return false;
		}
		//return UtilDBWeb.isUserMapingExist(sqlStr_isExistUserByModule, new String[]{SSO_MODULE_CODE_HK_CIS, userId});
	}

	public static boolean isUserExist(String userId) {
		ArrayList result = UtilDBWeb.getReportableListSEED(sqlStr_getSsoUserBySsoUserId, new String[]{userId});
		if (result != null && result.size() > 0) {
			return true;
		} else {
			return false;
		}
		//return UtilDBWeb.isUserMapingExist(sqlStr_isExistUserByModule, new String[]{SSO_MODULE_CODE_HK_CIS, userId});
	}
	
	public static boolean isUserDisabled(String userId) {
		ArrayList result = UtilDBWeb.getReportableListSEED(sqlStr_isSsoStaffDisabled, new String[]{userId});
		if (result != null && result.size() > 0) {
			return true;
		} else {
			return false;
		}
		//return UtilDBWeb.isUserMapingExist(sqlStr_isExistUserByModule, new String[]{SSO_MODULE_CODE_HK_CIS, userId});
	}

	public static ArrayList getSsoUser(String moduleCode, String moduleUserId) {
		return UtilDBWeb.getReportableList(sqlStr_getSsoUserMappingByModule, new String[] {moduleCode, moduleUserId});
	}
	
	public static String getSsoUserIdByStaffNo(String staffNo) {
		String ssoUserId = null;

		ArrayList<ReportableListObject> result = 
				UtilDBWeb.getReportableListSEED(sqlStr_getSsoUserByStaffNo, new String[] {staffNo});
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			ssoUserId = reportableListObject.getValue(0);
		}
		return ssoUserId;
	}
	
	public static ArrayList getSsoUserBySsoUserId(String ssoUserId) {
		return UtilDBWeb.getReportableListSEED(
				sqlStr_getSsoUserBySsoUserId, new String[] {ssoUserId});
	}

	public static boolean delete(UserBean userBean, String ssoUserId) {
		if(UtilDBWeb.updateQueueSEED(
				sqlStr_deleteSsoUser, new String[] {userBean.getLoginID(), ssoUserId})) {
			UtilDBWeb.updateQueueSEED(sqlStr_disableAllSsoMapping,
					new String[] {userBean.getLoginID(), ssoUserId });
			return true;
		} else {
			return false;
		}
	}

	public static boolean deleteAllSsoMapping(UserBean userBean, String ssoUserId) {
		return UtilDBWeb.updateQueueSEED(
				sqlStr_deleteAllSsoMapping, new String[] {ssoUserId});
	}

	public static boolean deleteSsoMapping(UserBean userBean, String ssoUserId, String moduleCode, String moduleUserId) {
		return UtilDBWeb.updateQueueSEED(
				sqlStr_deleteSsoMapping, new String[] {ssoUserId, moduleCode, moduleUserId});
	}
	
	public static boolean batchDelete(UserBean userBean, String ssoUserIdsStr) {
		System.out.println("intranet SsoUserDB batchDelete ssoUserIdsStr="+ssoUserIdsStr);
		if (ssoUserIdsStr == null || ssoUserIdsStr.trim().isEmpty()) {
			return false;
		}
		
		String[] ssoUserIds = null;
		if (ssoUserIdsStr != null && !ssoUserIdsStr.trim().isEmpty()) {
			ssoUserIdsStr = StringUtils.deleteWhitespace(ssoUserIdsStr).toUpperCase();
			ssoUserIds = ssoUserIdsStr.split(",");
		}
		
		//String[] splitUserIds = ssoUserIds[0].split(",");
		String[] splitUserIds = ssoUserIds;
		String[] tempUserIds = new String[(int)Math.ceil(splitUserIds.length/1000.0)];
		
		for(int i=0;i<tempUserIds.length;i++){
			tempUserIds[i] = StringUtils.join(Arrays.copyOfRange(splitUserIds,(i*1000),(((splitUserIds.length)<(((i+1)*1000)))?(splitUserIds.length):(((i+1)*1000))) ), "','");
		}
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE	SSO_USER ");
		sqlStr.append("SET    ENABLED = 0, UPDATED_DATE = SYSDATE, UPDATED_USER = ? ");
		sqlStr.append("WHERE  ENABLED = 1 ");
		for(int j=0;j<tempUserIds.length;j++){
		   if(j==0){	
			 sqlStr.append("AND  	(UPPER(STAFF_NO) IN ('" + tempUserIds[j] + "') ");
		   }else{
			 sqlStr.append("OR  	UPPER(STAFF_NO) IN ('" + tempUserIds[j] + "') ");
		   }
		}
		if (tempUserIds.length > 0) {
			sqlStr.append(")");
		}
		
		System.out.println("[SsoUserDB] batchDelete sql="+sqlStr.toString());
		return UtilDBWeb.updateQueueSEED(sqlStr.toString(), new String[]{ userBean.getLoginID()});
	}

	public static boolean testConn() {
		try {
			ArrayList result = UtilDBWeb.getReportableListSEED("select * from dual");
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	public static boolean addSessionID(String sessionID, UserBean userBean, String ipAddress) {
		return UtilDBWeb.updateQueueSEED(sqlStr_insertSsoSessionId,
				new String[] { sessionID,  userBean.getLoginID(), userBean.getDeptCode(), ipAddress} );
	}

	public static boolean updateSessionID(String sessionID, UserBean userBean) {
		return UtilDBWeb.updateQueueSEED(sqlStr_updateSsoSessionId,
				new String[] { sessionID,  userBean.getLoginID(), userBean.getDeptCode(), SSO_MODULE_CODE_HK_PORTAL} );
	}

	public static boolean deleteSessionID(String sessionID) {
		return UtilDBWeb.updateQueueSEED(sqlStr_deleteSsoSessionId,
				new String[] { sessionID} );
	}

	public static boolean deleteInactiveSessionID() {
		return UtilDBWeb.updateQueueSEED(sqlStr_deleteInactiveSsoSessionId);
	}

	//===================


	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT   USER_ID, ");
		sqlStr.append("			USER_NAME, ");
		sqlStr.append("			PASSWORD, ");
		sqlStr.append("			USER_DEPT, ");
		sqlStr.append("			USER_TEAM, ");
		sqlStr.append("			EMAIL, ");
		sqlStr.append("			TEL_NO, ");
		sqlStr.append("			EFFECTIVE_DATE, ");
		sqlStr.append("			EXPIRED_DATE, ");
		sqlStr.append("			UPDATE_USER, ");
		sqlStr.append("			UPDATE_DATE ");
		sqlStr.append("FROM   AH_SYS_USER ");
		sqlStr.append("WHERE ");
		sqlStr.append("  trunc(effective_date) <= trunc(sysdate) ");
		sqlStr.append("  and  (expired_date is null or trunc(expired_date) > trunc(sysdate))");
		//sqlStr.append("ORDER  BY USER_ID ");
		sqlStr_getCISAhSysUser = sqlStr.toString();

		// Fetch logic same as portal login procedure
		sqlStr.setLength(0);
		sqlStr.append("SELECT U.CO_USERNAME, S.CO_STAFFNAME, U.CO_GROUP_ID, G.CO_GROUP_DESC, ");
		sqlStr.append("       U.CO_SITE_CODE, S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       U.CO_STAFF_ID, S.CO_CATEGORY, S.CO_ENABLED, G.CO_GROUP_LEVEL, ");
		sqlStr.append("       U.CO_REMARK_1, U.CO_REMARK_2, U.CO_REMARK_3, TO_CHAR(S.CO_HIRE_DATE,'dd/mm/yyyy') ");
		sqlStr.append("FROM   CO_USERS U, CO_GROUPS G, CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  U.CO_GROUP_ID = G.CO_GROUP_ID ");
		sqlStr.append("AND    U.CO_SITE_CODE = S.CO_SITE_CODE (+) ");
		sqlStr.append("AND    U.CO_STAFF_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    U.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		sqlStr_getPortalUser = sqlStr.toString();

		/*
		sqlStr.setLength(0);
		sqlStr.append("SELECT 	U.CO_USERNAME, S.CO_STAFFNAME, U.CO_GROUP_ID, G.CO_GROUP_DESC, ");
		sqlStr.append("       	U.CO_SITE_CODE, S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       	U.CO_STAFF_ID, S.CO_CATEGORY, S.CO_ENABLED, G.CO_GROUP_LEVEL, ");
		sqlStr.append("       	U.CO_REMARK_1, U.CO_REMARK_2, U.CO_REMARK_3, TO_CHAR(S.CO_HIRE_DATE,'dd/mm/yyyy') ");
		sqlStr.append("FROM   	CO_USERS ");
		sqlStr.append("WHERE 	CO_ENABLED = 1");
		sqlStr.append("AND		CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "'");
		sqlStr.append("ORDER BY CO_STAFF_ID ");
		sqlStr_getPortalUser = sqlStr.toString();
		*/

		sqlStr.setLength(0);
		sqlStr.append("UPDATE 	SSO_USER_MAPPING ");
		sqlStr.append("SET 		ENABLED = 0 ");
		sqlStr.append("WHERE 	MODULE_CODE = ? AND ENABLED = 1 ");
		sqlStr_resetUserMappingByModule = sqlStr.toString();	// do not set update date/user

		sqlStr.setLength(0);
		sqlStr.append("SELECT 	SSO_USER_ID ");
		sqlStr.append("FROM 	SSO_USER_MAPPING ");
		sqlStr.append("WHERE 	MODULE_CODE = ? ");
		sqlStr.append("AND	 	MODULE_USER_ID = ? ");
		sqlStr.append("AND    	ENABLED = 1 ");
		sqlStr_getSsoUserIdByModuleUser = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 	MODULE_USER_ID ");
		sqlStr.append("FROM 	SSO_USER_MAPPING ");
		sqlStr.append("WHERE 	MODULE_CODE = ? ");
		sqlStr.append("AND	 	SSO_USER_ID = ? ");
		sqlStr.append("AND    	ENABLED = 1 ");
		sqlStr_getModuleUserIdBySsoUserId = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT 	1 ");
		sqlStr.append("FROM 	SSO_USER_MAPPING ");
		sqlStr.append("WHERE 	MODULE_CODE = ? ");
		sqlStr.append("AND	 	MODULE_USER_ID = ? ");
		sqlStr.append("AND	 	SSO_USER_ID = ? ");
		sqlStr.append("AND    	ENABLED = 1 ");
		sqlStr_isExistUserMapping = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 	1 ");
		sqlStr.append("FROM 	SSO_USER_MAPPING ");
		sqlStr.append("WHERE 	MODULE_CODE = ? ");
		sqlStr.append("AND	 	SSO_USER_ID = ? ");
		sqlStr.append("AND    	ENABLED = 1 ");
		sqlStr_isExistUserMappingByModule = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 	SSO_USER_ID, ");
		sqlStr.append("			STAFF_NO, ");
		sqlStr.append("			FIRST_NAME, ");
		sqlStr.append("			LAST_NAME, ");
		sqlStr.append("			GIVEN_NAME, ");
		sqlStr.append("			DISPLAY_NAME, ");
		sqlStr.append("			CN_FIRST_NAME, ");
		sqlStr.append("			CN_LAST_NAME, ");
		sqlStr.append("			MOBILE_PHONE_NO, ");
		sqlStr.append("			HOME_PHONE_NO, ");
		sqlStr.append("			OFFICE_PHONE_NO, ");
		sqlStr.append("			PAGER_NO, ");
		sqlStr.append("			QUAL, ");
		sqlStr.append("			USER_TYPE, ");
		sqlStr.append("			ENABLED ");
		sqlStr.append("FROM 	SSO_USER ");
		sqlStr.append("WHERE 	ENABLED = 1 ");
		sqlStr_getSsoUsers = sqlStr.toString();
		sqlStr_getSsoUsers += "ORDER BY 	SSO_USER_ID";

		sqlStr.setLength(0);
		sqlStr.append("SELECT 	SSO_USER_ID, ");
		sqlStr.append("			STAFF_NO, ");
		sqlStr.append("			FIRST_NAME, ");
		sqlStr.append("			LAST_NAME, ");
		sqlStr.append("			GIVEN_NAME, ");
		sqlStr.append("			DISPLAY_NAME, ");
		sqlStr.append("			CN_FIRST_NAME, ");
		sqlStr.append("			CN_LAST_NAME, ");
		sqlStr.append("			MOBILE_PHONE_NO, ");
		sqlStr.append("			HOME_PHONE_NO, ");
		sqlStr.append("			OFFICE_PHONE_NO, ");
		sqlStr.append("			PAGER_NO, ");
		sqlStr.append("			QUAL, ");
		sqlStr.append("			USER_TYPE, ");
		sqlStr.append("			ENABLED ");
		sqlStr.append("FROM 	SSO_USER ");
		sqlStr.append("WHERE 	SSO_USER_ID = ? ");
		sqlStr.append("ORDER BY 	SSO_USER_ID");
		sqlStr_getSsoUserBySsoUserId = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 	1 ");
		sqlStr.append("FROM 	SSO_USER ");
		sqlStr.append("WHERE 	STAFF_NO = ? ");
		sqlStr.append("AND    	ENABLED = 0 ");
		sqlStr_isSsoStaffDisabled = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 	MODULE_CODE, ");
		sqlStr.append("			MODULE_USER_ID, ");
		sqlStr.append("			SSO_USER_ID ");
		sqlStr.append("FROM 	SSO_USER_MAPPING ");
		sqlStr.append("AND    	MODULE_CODE = ? ");
		sqlStr.append("AND    	MODULE_USER_ID = ? ");
		sqlStr.append("AND    	ENABLED = 1 ");
		sqlStr_getSsoUserMappingByModule = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT 	SSO_USER_ID ");
		sqlStr.append("FROM 	SSO_USER ");
		sqlStr.append("WHERE    STAFF_NO = ? ");
		sqlStr.append("AND    	ENABLED = 1 ");
		sqlStr_getSsoUserByStaffNo = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 	MODULE_CODE, ");
		sqlStr.append("			MODULE_USER_ID, ");
		sqlStr.append("			SSO_USER_ID, ");
		sqlStr.append("			CREATED_DATE, ");
		sqlStr.append("			CREATED_USER, ");
		sqlStr.append("			UPDATED_DATE, ");
		sqlStr.append("			UPDATED_USER ");
		sqlStr.append("FROM 	SSO_USER_MAPPING ");
		sqlStr.append("WHERE   	MODULE_CODE = ? ");
		sqlStr.append("AND    	ENABLED = 1 ");
		sqlStr_getAllSsoUserMappingByModule = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 	1 ");
		sqlStr.append("FROM 	CO_STAFFS ");
		sqlStr.append("WHERE 	CO_STAFF_ID = ? ");
		sqlStr.append("AND	 	CO_ENABLED = 0 ");
		sqlStr_isPortalStaffDisabled = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO SSO_USER_MAPPING ");
		sqlStr.append("(MODULE_CODE, MODULE_USER_ID, SSO_USER_ID, CREATED_USER, UPDATED_USER) ");
		sqlStr.append("VALUES (?, ?, ?, ?, ?) ");
		sqlStr_insertSsoUserMapping = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE SSO_USER_MAPPING ");
		sqlStr.append("SET ENABLED = 1, ");
		sqlStr.append("			UPDATED_DATE = sysdate, ");
		sqlStr.append("			UPDATED_USER = ? ");
		sqlStr.append("WHERE SSO_USER_ID = ? ");
		sqlStr_enableSsoUserMapping = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO SSO_USER ");
		sqlStr.append("(SSO_USER_ID, STAFF_NO, DISPLAY_NAME) ");
		sqlStr.append("VALUES (?, ?, ?) ");
		sqlStr_insertSsoUserMin = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO SSO_USER ");
		sqlStr.append("(SSO_USER_ID, STAFF_NO, FIRST_NAME, LAST_NAME, GIVEN_NAME, ");
		sqlStr.append(" DISPLAY_NAME, CN_FIRST_NAME, CN_LAST_NAME, MOBILE_PHONE_NO, HOME_PHONE_NO, ");
		sqlStr.append(" OFFICE_PHONE_NO, PAGER_NO, QUAL, USER_TYPE, CREATED_USER, UPDATED_USER) ");
		sqlStr.append("VALUES (?, ?, ?, ?, ?, ");
		sqlStr.append("	?, ?, ?, ?, ?, ");
		sqlStr.append("	?, ?, ?, ?, ?, ?)");
		sqlStr_insertSsoUser = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE SSO_USER ");
		sqlStr.append("SET ");
		sqlStr.append("			STAFF_NO = ?, ");
		sqlStr.append("			FIRST_NAME = ?, ");
		sqlStr.append("			LAST_NAME = ?, ");
		sqlStr.append("			GIVEN_NAME = ?, ");
		sqlStr.append("			DISPLAY_NAME = ?, ");
		sqlStr.append("			CN_FIRST_NAME = ?, ");
		sqlStr.append("			CN_LAST_NAME = ?, ");
		sqlStr.append("			MOBILE_PHONE_NO = ?, ");
		sqlStr.append("			HOME_PHONE_NO = ?, ");
		sqlStr.append("			OFFICE_PHONE_NO = ?, ");
		sqlStr.append("			PAGER_NO = ?, ");
		sqlStr.append("			QUAL = ?, ");
		sqlStr.append("			USER_TYPE = ?, ");
		sqlStr.append("			UPDATED_DATE = sysdate, ");
		sqlStr.append("			UPDATED_USER = ? ");
		sqlStr.append("WHERE SSO_USER_ID = ? AND ENABLED = 1");
		sqlStr_updateSsoUserDetails = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE SSO_USER ");
		sqlStr.append("SET ");
		sqlStr.append("			ENABLED = 1, ");
		sqlStr.append("			UPDATED_DATE = sysdate, ");
		sqlStr.append("			UPDATED_USER = ? ");
		sqlStr.append("WHERE SSO_USER_ID = ?");
		sqlStr_enableSsoUser = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE SSO_USER ");
		sqlStr.append("SET ");
		sqlStr.append("			DISPLAY_NAME = ?, ");
		sqlStr.append("			FIRST_NAME = ?, ");
		sqlStr.append("			LAST_NAME = ?, ");
		sqlStr.append("			CN_LAST_NAME = ?, ");
		sqlStr.append("			QUAL = ?, ");
		sqlStr.append("			UPDATED_DATE = sysdate, ");
		sqlStr.append("			UPDATED_USER = ? ");
		sqlStr.append("WHERE SSO_USER_ID = ? AND ENABLED = 1");
		sqlStr_updateSsoUserDetailsFromHRStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE SSO_USER ");
		sqlStr.append("SET ");
		sqlStr.append("			DISPLAY_NAME = ?, ");
		sqlStr.append("			USER_TYPE = ?, ");
		sqlStr.append("			UPDATED_DATE = sysdate, ");
		sqlStr.append("			UPDATED_USER = ? ");
		sqlStr.append("WHERE SSO_USER_ID = ? AND ENABLED = 1");
		sqlStr_updateSsoUserFromCIS = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE SSO_USER_MAPPING ");
		sqlStr.append("SET ");
		sqlStr.append("			MODULE_USER_ID = ?, ");
		sqlStr.append("			UPDATED_DATE = sysdate, ");
		sqlStr.append("			UPDATED_USER = ? ");
		sqlStr.append("WHERE SSO_USER_ID = ? AND MODULE_CODE = ? AND ENABLED = 1");
		sqlStr_updateSsoMappingModuleUserId = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM SSO_USER ");
		sqlStr.append("WHERE SSO_USER_ID = ?");
		sqlStr_permDeleteSsoUser = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT [Staff No], [Staff Name], CNAME, qual, [Dept Code], Status, [Pos1], [Pos2], PosCode1, PosCode2, PosCode3 ");
		sqlStr.append("FROM   [Staff List] ");
		sqlStr_selectAccessStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE SSO_USER ");
		sqlStr.append("SET    ENABLED = 0, UPDATED_DATE = SYSDATE, UPDATED_USER = ? ");
		sqlStr.append("WHERE SSO_USER_ID = ? AND ENABLED = 1");
		sqlStr_deleteSsoUser = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM SSO_USER_MAPPING ");
		sqlStr.append("WHERE SSO_USER_ID = ? AND MODULE_CODE = ? AND MODULE_USER_ID = ?");
		sqlStr_deleteSsoMapping = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM SSO_USER_MAPPING ");
		sqlStr.append("WHERE SSO_USER_ID = ?");
		sqlStr_deleteAllSsoMapping = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE SSO_USER_MAPPING ");
		sqlStr.append("SET ");
		sqlStr.append("			enabled = 0, ");
		sqlStr.append("			UPDATED_DATE = sysdate, ");
		sqlStr.append("			UPDATED_USER = ? ");
		sqlStr.append("WHERE SSO_USER_ID = ? AND ENABLED = 1");
		sqlStr_disableAllSsoMapping = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT V.STAFF_CODE, V.SURNAME, V.GIVEN_NAME, V.CHRISTIAN_NAME, " +
				"V.DATE_JOINED, V.DEPT_CODE, V.EMAIL_ADDRESS, V.JOB_DESCRIPTION, V.STAFF_STATUS, V.SITE, V2.DEPT_DESCRIPTION, V.JOB_CODE, V.TYPE_CODE  ");
		sqlStr.append("FROM   TWAH_INTRANET_VIEW V LEFT JOIN TWAH_INTRANET_VIEW2 V2 ");
		sqlStr.append("ON	  V.DEPT_CODE = V2.DEPT_CODE ");
		// do not update this user_type (job desc) from HR because error in mcs system
		sqlStr.append("WHERE V.JOB_DESCRIPTION <> 'Acting Nursing Officer/Registered Nurse'");  
		sqlStr_selectTWAHStaff = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO SSO_SESSION ");
		sqlStr.append("(SESSION_ID, USER_ID, DEPT_CODE, MODULE_CODE, IP_ADDRESS) ");
		sqlStr.append("VALUES (?, ?, ?, '" + SSO_MODULE_CODE_HK_PORTAL + "', ?) ");
		sqlStr_insertSsoSessionId = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE SSO_SESSION ");
		sqlStr.append("SET TIMESTAMP_UPDATE = SYSDATE ");
		sqlStr.append("WHERE SESSION_ID = ? AND USER_ID = ? AND DEPT_CODE = ? AND MODULE_CODE = ? ");
		sqlStr_updateSsoSessionId = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM SSO_SESSION ");
		sqlStr.append("WHERE SESSION_ID = ?");
		sqlStr_deleteSsoSessionId = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM SSO_SESSION ");
		sqlStr.append("WHERE  TIMESTAMP < (sysdate-1)");
		sqlStr_deleteInactiveSsoSessionId = sqlStr.toString();
	}
}