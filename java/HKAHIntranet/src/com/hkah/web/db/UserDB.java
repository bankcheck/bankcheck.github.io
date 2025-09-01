package com.hkah.web.db;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;
import com.hkah.web.exception.LoginException;
import com.hkah.web.exception.LoginPwdInvalidException;
import com.hkah.web.exception.LoginStaffExpiredException;
import com.hkah.web.exception.NSNOAccessRightinvalidException;
import com.hkah.web.exception.NoAccessRightException;

public class UserDB {

	//======================================================================
	private static Logger logger = Logger.getLogger(UserDB.class);

	//======================================================================
	private static String sqlStr_isExistUser = null;
	private static String sqlStr_insertUser = null;
	private static String sqlStr_insertDoctor = null;
	private static String sqlStr_enableUserByStaffId = null;

	//======================================================================
	private static final String DOCTOR_PREFIX = "DR";
	
	public static final String PASSWORD_DEFAULT = "123456";
	public static final String PASSWORD_DEFAULT_UAT = "654321";

	/*
	 * copy login logic from LogonAction, centralize login process
	 */
	public static UserBean login(HttpServletRequest request, HttpServletResponse response,
			String loginUserID, String loginPwd, String savePwd) throws Exception {
		UserBean userBean = null;
		boolean isNSMsg = false;

		try {
			// get site code
			String siteCode = UserDB.getSiteCode(loginUserID);
			
			System.out.println("[UserBean] login loginUserID="+loginUserID+", siteCode=" + siteCode);

			// check to different site code
			if (siteCode != null && !ConstantsServerSide.SITE_CODE.equals(siteCode)) {
				userBean = UserDB.getUserBeanFromAnotherSiteCode(siteCode, request, loginUserID, loginPwd);
				if (userBean != null) {
					// retrieve dept code from local staff db
					String deptCode = StaffDB.getDeptCode(userBean.getStaffID());
					if (deptCode != null) {
						userBean.setDeptCode(deptCode);
						// store in session
						userBean.writeToSession(request);
					}
				} else {
					// fail to login in another site, invalidate current local login
					UserBean userBeanLocal = new UserBean(request);
					if (userBeanLocal != null) {
						userBeanLocal.invalidate(request, response);
					}
				}
			} else {
				// check user login from mailserver and is nursing school user
				if (ConstantsServerSide.SECURE_SERVER && UserDB.isNSUser(loginUserID.toUpperCase())) {
					userBean = null;
					isNSMsg = true;
				} else {
					// accept either username or staff id to login
					userBean = UserDB.getUserBean(request, loginUserID, loginPwd);
				}
			}

			// check from (NO authentication from CIS anymore (2012 Oct 17))
			/*
			if (userBean == null) {
				String encryptedPwd = PasswordUtil.cisEncryption(loginPwd);
				if (UserDB.isCISUser(loginUserID, encryptedPwd)) {
					// check user from CIS
					userBean = UserDB.getUserBean(request, loginUserID);

					// store cis password
					UserDB.updatePassword(userBean, loginPwd);
				}
			}
			*/

			// create user id if only exists in staff table
			if (userBean == null
					&& StaffDB.isExistActive(loginUserID) && !UserDB.isExistByStaffID(loginUserID)) {
				UserDB.add(ConstantsServerSide.SITE_CODE, loginUserID, PasswordUtil.cisEncryption("123456"), loginUserID);
				// retrieve again
				userBean = UserDB.getUserBean(request, loginUserID, loginPwd);
			}

			// create user id if only exists in hats doctor table
			if (userBean == null) {
				String doccode = getDoctorCode(loginUserID);

				if (doccode != null) {
					String docPwd = getDoctorPassword(doccode);

					if (docPwd != null) {
						// create doctor in portal table
						UtilDBWeb.callFunction("HAT_ACT_CREATEDOCTOR", "ADD", new String[] { doccode,  PasswordUtil.cisEncryption(docPwd)});
					}

					// retrieve again
					userBean = UserDB.getUserBean(request, loginUserID, loginPwd);
				}
			}

			if (userBean != null) {
				if (isDoctor(userBean.getStaffID()) && ConstantsServerSide.SITE_CODE.equals(userBean.getSiteCode())) {
					if (getDoctorCode(userBean.getStaffID()) == null) {
						// inactive doctor cannot login
						// throw new NoAccessRightException();
					}
				} else if (!ConstantsVariable.ZERO_VALUE.equals(userBean.getStaffStatus())) {
					// write to cookie
					if (ConstantsVariable.YES_VALUE.equals(savePwd)) {
						userBean.writeToCookie(response);
					}
				} else {
					// staff status is expired
					throw new LoginStaffExpiredException();
				}
			} else {
				if (isNSMsg) {
					// Nursing School User cannot login
					throw new NSNOAccessRightinvalidException();
				} else {
					// invalid password
					throw new LoginPwdInvalidException();
				}
			}
		} catch (LoginException e) {
			if (!(e instanceof LoginStaffExpiredException
					|| e instanceof LoginPwdInvalidException
					|| e instanceof NSNOAccessRightinvalidException)) {
				e.printStackTrace();
			}
			throw e;
		}

		return userBean;
	}

	public static boolean add(String siteCode, String userName, String password, String staffID) {
		return UtilDBWeb.updateQueue(
				sqlStr_insertUser,
				new String[] { siteCode, userName, password, staffID });
	}

	public static boolean addDoctor(String siteCode, String userName, String password, String staffID) {
		return UtilDBWeb.updateQueue(
				sqlStr_insertDoctor,
				new String[] { siteCode, userName, password, staffID });
	}

	public static boolean enableUserByStaffId(UserBean userBean, String siteCode, String staffID) {
		return UtilDBWeb.updateQueue(
				sqlStr_enableUserByStaffId,
				new String[] { userBean == null ? "SYSTEM" : userBean.getLoginID(), siteCode, staffID });
	}


	public static boolean update(UserBean userBean, String userName, String siteCode, String lastName, String firstName, String email, String telephone, String staffID, String enabled) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE	CO_USERS ");
		sqlStr.append("SET		CO_LASTNAME = ?, ");
		sqlStr.append("			CO_FIRSTNAME = ?, ");
		sqlStr.append("			CO_EMAIL = ?, ");
		sqlStr.append("			CO_TELEPHONE = ?, ");
		sqlStr.append("			CO_STAFF_ID = ?, ");
		sqlStr.append("			CO_MODIFIED_USER = ?, ");
		sqlStr.append("			CO_MODIFIED_DATE = sysdate, ");
		sqlStr.append("			CO_ENABLED = ? ");
		sqlStr.append("WHERE	CO_USERNAME = ? ");
		sqlStr.append("			AND	CO_SITE_CODE = ? ");
		sqlStr.append("			AND	CO_ENABLED = 1 ");
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { lastName, firstName, email, telephone, staffID, enabled, userBean.getLoginID(), userName, siteCode });
	}

	public static boolean updatePassword(UserBean userBean, String newPassword) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE   CO_USERS ");
		sqlStr.append("SET      CO_PASSWORD = ?, ");
		sqlStr.append("         CO_MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("         CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE   (CO_USERNAME = ? OR CO_STAFF_ID = ?) ");
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					PasswordUtil.cisEncryption(newPassword),
					userBean.getLoginID(),
					userBean.getLoginID(),
					userBean.getLoginID()
				});
	}

	public static boolean updatePassword(String usrID, String newPassword) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE   CO_USERS ");
		sqlStr.append("SET      CO_PASSWORD = ?, ");
		sqlStr.append("         CO_MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("         CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE   (CO_USERNAME = ? OR CO_STAFF_ID = ?) ");
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					PasswordUtil.cisEncryption(newPassword),
					usrID,
					usrID,
					usrID
				});
	}

	public static boolean syncPassword(String usrID, String otherSiteCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE   CO_USERS@");
		sqlStr.append(ConstantsServerSide.getDBLinkPortal(otherSiteCode));
		sqlStr.append(" ");
		sqlStr.append("SET     CO_PASSWORD = (SELECT CO_PASSWORD FROM CO_USERS WHERE (CO_USERNAME = ? OR CO_STAFF_ID = ?)), ");
		sqlStr.append("         CO_MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("         CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE   (CO_USERNAME = ? OR CO_STAFF_ID = ?) ");
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					usrID,
					usrID,
					usrID,
					usrID,
					usrID
				});
	}
	
	public static boolean syncPassword2AMC(String usrID) {
		boolean retAMC1 = false;
		boolean retAMC2 = false;
		if ((ConstantsServerSide.isHKAH() || ConstantsServerSide.isTWAH()) &&
				StaffDB.isNotAMC(usrID)) {
			// wait for AMC1 launch
			//retAMC1 = syncPassword(usrID, ConstantsServerSide.SITE_CODE_AMC1);
			retAMC2 = syncPassword(usrID, ConstantsServerSide.SITE_CODE_AMC2);
			System.out.println(DateTimeUtil.getCurrentDateTime() + " [UserDB] sync pw to AMC1, AMC2 usrID="+usrID+", retAMC1="+retAMC1+", retAMC2="+retAMC2);
		}
		return retAMC1 || retAMC2;
	}

	public static ArrayList<ReportableListObject> getList4UserList(UserBean userBean, String siteCode, String deptCode, String staffID, String firstName, String lastName, String enabled) {
		// fetch user
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT U.CO_SITE_CODE, D.CO_DEPARTMENT_DESC, U.CO_USERNAME, ");
		sqlStr.append("       U.CO_LASTNAME, U.CO_FIRSTNAME, U.CO_STAFF_ID, ");
		sqlStr.append("       U.CO_GROUP_ID, G.CO_GROUP_DESC, U.CO_ENABLED, S.CO_STAFFNAME, S.CO_LASTNAME, S.CO_FIRSTNAME ");
		sqlStr.append("FROM   CO_USERS U, CO_STAFFS S, CO_DEPARTMENTS D, CO_GROUPS G ");
		sqlStr.append("WHERE  U.CO_SITE_CODE = S.CO_SITE_CODE (+) ");
		sqlStr.append("AND    U.CO_STAFF_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    U.CO_GROUP_ID = G.CO_GROUP_ID ");
		sqlStr.append("AND    U.CO_GROUP_ID != 'admin' ");
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    U.CO_SITE_CODE = '");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
		}
		if (!userBean.isSuperManager() && !userBean.isAllowAdmin()) {
			// only show related department
			sqlStr.append("AND    UPPER(S.CO_DEPARTMENT_CODE) = '");
			sqlStr.append(userBean.getDeptCode().toUpperCase());
			sqlStr.append("' ");
		} else if (deptCode != null && deptCode.length() > 0) {
			// only admin or super manager can see all the departments
			sqlStr.append("AND    UPPER(S.CO_DEPARTMENT_CODE) = '");
			sqlStr.append(deptCode.trim().toUpperCase());
			sqlStr.append("' ");
		}
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND    UPPER(TRIM(U.CO_STAFF_ID)) LIKE '%");
			sqlStr.append(staffID.trim().toUpperCase());
			sqlStr.append("%' ");
		}
		if (firstName != null && firstName.length() > 0) {
			sqlStr.append("AND   (UPPER(TRIM(U.CO_FIRSTNAME)) LIKE '%");
			sqlStr.append(firstName.trim().toUpperCase());
			sqlStr.append("%' OR UPPER(TRIM(S.CO_FIRSTNAME)) LIKE '%");
			sqlStr.append(firstName.trim().toUpperCase());
			sqlStr.append("%') ");
		}
		if (lastName != null && lastName.length() > 0) {
			sqlStr.append("AND   (UPPER(TRIM(U.CO_LASTNAME)) LIKE '%");
			sqlStr.append(lastName.trim().toUpperCase());
			sqlStr.append("%' OR UPPER(TRIM(S.CO_LASTNAME)) LIKE '%");
			sqlStr.append(lastName.trim().toUpperCase());
			sqlStr.append("%') ");
		}
		if ("0".equals(enabled)) {
			sqlStr.append("AND    U.CO_ENABLED = 0 ");
		} else {
			sqlStr.append("AND    U.CO_ENABLED = 1 ");
		}
		sqlStr.append("ORDER BY D.CO_DEPARTMENT_DESC, U.CO_USERNAME");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList<ReportableListObject> getList(UserBean userBean, String siteCode, String deptCode, String staffID, String firstName, String lastName,String orderBy) {
		// fetch user
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT U.CO_SITE_CODE, D.CO_DEPARTMENT_DESC, U.CO_USERNAME, ");
		sqlStr.append("       U.CO_LASTNAME, U.CO_FIRSTNAME, U.CO_STAFF_ID, ");
		sqlStr.append("       U.CO_GROUP_ID, G.CO_GROUP_DESC ");
		sqlStr.append("FROM   CO_USERS U, CO_STAFFS S, CO_DEPARTMENTS D, CO_GROUPS G ");
		sqlStr.append("WHERE  U.CO_SITE_CODE = S.CO_SITE_CODE (+) ");
		sqlStr.append("AND    U.CO_STAFF_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    U.CO_GROUP_ID = G.CO_GROUP_ID ");
		sqlStr.append("AND    U.CO_ENABLED = 1 ");
		sqlStr.append("AND    U.CO_GROUP_ID != 'admin' ");
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    U.CO_SITE_CODE = '");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
		}
		if (!userBean.isSuperManager() && !userBean.isAllowAdmin()) {
			// only show related department
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(userBean.getDeptCode());
			sqlStr.append("' ");
		} else if (deptCode != null && deptCode.length() > 0) {
			// only admin or super manager can see all the departments
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND    TRIM(U.CO_STAFF_ID) LIKE '%");
			sqlStr.append(staffID.trim());
			sqlStr.append("%' ");
		}
		if (firstName != null && firstName.length() > 0) {
			sqlStr.append("AND    UPPER(TRIM(U.CO_FIRSTNAME)) LIKE '%");
			sqlStr.append(firstName.trim().toUpperCase());
			sqlStr.append("%' ");
		}
		if (lastName != null && lastName.length() > 0) {
			sqlStr.append("AND    UPPER(TRIM(U.CO_LASTNAME)) LIKE '%");
			sqlStr.append(lastName.trim().toUpperCase());
			sqlStr.append("%' ");
		}
		if ("0".equals(orderBy)) {
			sqlStr.append("ORDER BY D.CO_DEPARTMENT_DESC, U.CO_USERNAME");
		} else if ("1".equals(orderBy)) {
			sqlStr.append("ORDER BY U.CO_STAFF_ID");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList<ReportableListObject> get(String userName) {
		return get(userName, "1");
	}

	public static ArrayList<ReportableListObject> get(String userName, String enabled) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT U.CO_SITE_CODE, U.CO_USERNAME, U.CO_LASTNAME, U.CO_FIRSTNAME, U.CO_EMAIL, ");
		sqlStr.append("       U.CO_STAFF_ID, U.CO_GROUP_ID, G.CO_GROUP_DESC, U.CO_ENABLED ");
		sqlStr.append("FROM   CO_USERS U, CO_GROUPS G ");
		sqlStr.append("WHERE  U.CO_GROUP_ID = G.CO_GROUP_ID ");
		sqlStr.append("AND   (U.CO_USERNAME = ? OR U.CO_STAFF_ID = ?) ");
		sqlStr.append("AND    U.CO_ENABLED = ?");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userName, userName, enabled });
	}

	public static boolean isExistByStaffID(String staffID) {
		return UtilDBWeb.isExist(sqlStr_isExistUser, new String[] { staffID } );
	}

	public static UserBean getUserBean(HttpServletRequest request, String loginUserID, String loginPwd) {
		return getUserBean(request, null, loginUserID, loginPwd, null, null, null, false);
	}

	public static UserBean getUserBean(HttpServletRequest request, String loginUserID, String loginPwd,
										String groupID) {
		return getUserBean(request, null, loginUserID, loginPwd, null, groupID, null, false);
	}

	public static UserBean getUserBean(HttpServletRequest request, String loginUserID, String loginPwd,
										String[] notIncludedGroup) {
		return getUserBean(request, null, loginUserID, loginPwd, null, null, notIncludedGroup, false);
	}

	public static UserBean getUserBean(HttpServletRequest request, String loginStaffID) {
		return getUserBean(request, null, null, null, loginStaffID, null, null, false);
	}

	public final static UserBean getUserBeanSkipPassword(HttpServletRequest request, String loginUserID) {
		return getUserBean(request, null, loginUserID, null, null, null, null, true);
	}

	public final static UserBean getUserBeanSkipPasswordByStaffID(HttpServletRequest request, String staffID) {
		return getUserBean(request, null, null, null, staffID, null, null, true);
	}

	public static UserBean getUserBeanFromAnotherSiteCode(HttpServletRequest request, String loginUserID, String loginPwd) {
		String siteCode = null;
		if (ConstantsServerSide.isHKAH()) {
			siteCode = ConstantsServerSide.SITE_CODE_TWAH;
		} else if (ConstantsServerSide.isTWAH()) {
			siteCode = ConstantsServerSide.SITE_CODE_HKAH;
		} else if (ConstantsServerSide.isAMC()) {
			siteCode = ConstantsServerSide.SITE_CODE_AMC;
		} else if (ConstantsServerSide.isAMC2()) {
			siteCode = ConstantsServerSide.SITE_CODE_AMC2;
		}
		return getUserBean(request, siteCode, loginUserID, loginPwd, null, null, null, false);
	}

	public static UserBean getUserBeanFromAnotherSiteCode(HttpServletRequest request,
			String loginUserID,
			String loginPwd,
			String groupID) {
		String siteCode = null;
		if (ConstantsServerSide.isHKAH()) {
			siteCode = ConstantsServerSide.SITE_CODE_TWAH;
		} else if (ConstantsServerSide.isTWAH()) {
			siteCode = ConstantsServerSide.SITE_CODE_HKAH;
		} else if (ConstantsServerSide.isAMC()) {
			siteCode = ConstantsServerSide.SITE_CODE_AMC;
		} else if (ConstantsServerSide.isAMC2()) {
			siteCode = ConstantsServerSide.SITE_CODE_AMC2;
		}
		return getUserBean(request, siteCode, loginUserID, loginPwd, null, groupID, null, false);
	}

	public static UserBean getUserBeanFromAnotherSiteCode(HttpServletRequest request,
			String loginUserID,
			String loginPwd,
			String[] notIncludedGroup) {
		String siteCode = null;
		if (ConstantsServerSide.isHKAH()) {
			siteCode = ConstantsServerSide.SITE_CODE_TWAH;
		} else if (ConstantsServerSide.isTWAH()) {
			siteCode = ConstantsServerSide.SITE_CODE_HKAH;
		} else if (ConstantsServerSide.isAMC()) {
			siteCode = ConstantsServerSide.SITE_CODE_AMC;
		} else if (ConstantsServerSide.isAMC2()) {
			siteCode = ConstantsServerSide.SITE_CODE_AMC2;
		}
		return getUserBean(request, siteCode, loginUserID, loginPwd, null, null, notIncludedGroup, false);
	}
	
	public static UserBean getUserBeanFromAnotherSiteCode(String siteCode, HttpServletRequest request, String loginUserID, String loginPwd) {
		return getUserBean(request, siteCode, loginUserID, loginPwd, null, null, null, false);
	}

	private static UserBean getUserBean(HttpServletRequest request, String siteCode,
			String loginUserID, String loginPwd,
			String loginStaffID, String groupID,
			String[] notIncludedGroup,
			boolean skipPasswordValidation) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT U.CO_USERNAME, S.CO_STAFFNAME, U.CO_GROUP_ID, G.CO_GROUP_DESC, ");
		sqlStr.append("       U.CO_SITE_CODE, S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       U.CO_STAFF_ID, S.CO_CATEGORY, S.CO_ENABLED, G.CO_GROUP_LEVEL, ");
		sqlStr.append("       U.CO_REMARK_1, U.CO_REMARK_2, U.CO_REMARK_3, TO_CHAR(S.CO_HIRE_DATE, 'dd/mm/yyyy'), ");
		sqlStr.append("       SIGN(U.CO_MODIFIED_DATE - SYSDATE + 360) ");
		if (siteCode != null) {
			// remove after db link TWAH fix
			if (ConstantsServerSide.isAMC2() && ConstantsServerSide.SITE_CODE_TWAH.equals(siteCode)) {
				siteCode = "HKAH";
			} else if (ConstantsServerSide.SITE_CODE_AMC1.equals(siteCode) || ConstantsServerSide.SITE_CODE_AMC2.equals(siteCode)) {
				siteCode += "_Portal";	// dblink
			}
			sqlStr.append("FROM   CO_USERS@");
			sqlStr.append(siteCode);
			sqlStr.append(" U, CO_GROUPS@");
			sqlStr.append(siteCode);
			sqlStr.append(" G, CO_STAFFS@");
			sqlStr.append(siteCode);
			sqlStr.append(" S, CO_DEPARTMENTS@");
			sqlStr.append(siteCode);
			sqlStr.append(" D ");
		} else {
			sqlStr.append("FROM   CO_USERS U, CO_GROUPS G, CO_STAFFS S, CO_DEPARTMENTS D ");
		}
		sqlStr.append("WHERE  U.CO_GROUP_ID = G.CO_GROUP_ID ");
		sqlStr.append("AND    U.CO_SITE_CODE = S.CO_SITE_CODE (+) ");
		sqlStr.append("AND    U.CO_STAFF_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		if (loginStaffID != null) {
			sqlStr.append("AND    U.CO_STAFF_ID = '");
			sqlStr.append(loginStaffID.toUpperCase());
			sqlStr.append("' ");
		} else {
			sqlStr.append("AND   (LOWER(U.CO_USERNAME) = '");
			sqlStr.append(loginUserID.toLowerCase());
			sqlStr.append("' OR U.CO_STAFF_ID = '");
			sqlStr.append(loginUserID.toUpperCase());
			sqlStr.append("') ");
			if (!skipPasswordValidation) {
				sqlStr.append("AND    U.CO_PASSWORD = '");
				sqlStr.append(PasswordUtil.cisEncryption(loginPwd));
				sqlStr.append("' ");
			}
		}
		sqlStr.append("AND    U.CO_ENABLED = 1 ");

		if (groupID != null) {
			sqlStr.append("AND    U.CO_GROUP_ID = '" + groupID + "' ");
		}
		if (notIncludedGroup != null) {
			sqlStr.append("AND    U.CO_GROUP_ID NOT IN (" + Arrays.toString(notIncludedGroup).replace("[", "").replace("]", "") + ") ");
		}

		//System.out.println("[UserBean] getUserBean sql= " + sqlStr.toString());
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());

		UserBean userBean = null;
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			userBean = getBeanHelper(
					request,
					row.getValue(0),
					row.getValue(1),
					row.getValue(2),
					row.getValue(3),
					row.getValue(4),
					row.getValue(5),
					row.getValue(6),
					row.getValue(7),
					row.getValue(8),
					row.getValue(9),
					row.getValue(10),
					row.getValue(11),
					row.getValue(12),
					row.getValue(13),
					row.getValue(14),
					row.getValue(15)
			);
		}
		return userBean;
	}

	private static UserBean getBeanHelper(
			HttpServletRequest request,
			String loginUserID,
			String loginUserName,
			String loginUserGroupID, String loginUserGroupDesc,
			String loginSiteCode, String loginDeptCode,
			String loginDeptDesc,
			String loginStaffID,
			String loginStaffCategory,
			String staffStatus,
			String groupLevel,
			String remark1, String remark2, String remark3,
			String hireDate,
			String expiredPassword) {
		if (!ConstantsVariable.ZERO_VALUE.equals(staffStatus)) {
			// default use staff id
			UserBean userBean = new UserBean(request, false);
			if (!userBean.isAdmin() && !userBean.isSwitchUser()) {
				// create new UserBean
				userBean = new UserBean();
			}
			userBean.setLoginID(loginUserID);
			if (loginUserName != null && loginUserName.length() > 0) {
				userBean.setUserName(loginUserName);
			} else {
				userBean.setUserName(loginUserID);
			}

			userBean.setUserGroupID(loginUserGroupID);
			userBean.setUserGroupDesc(loginUserGroupDesc);
			if (userBean.isAdmin()) {
				userBean.setSiteCode(ConstantsServerSide.SITE_CODE);
				userBean.setSwitchUser(true);
			} else {
				if (userBean.isSwitchUser()) {
					// store login user id
					userBean.addSwitchUserID(request, loginStaffID);
				}
				userBean.setSiteCode(loginSiteCode);
				userBean.setDeptCode(loginDeptCode);
				userBean.setDeptDesc(loginDeptDesc);
				userBean.setStaffID(loginStaffID);
				userBean.setStaffCategory(loginStaffCategory);
			}
			userBean.setExpiredPassword(!ConstantsVariable.ONE_VALUE.equals(expiredPassword));

			// set associated dept code
			userBean.setAssociatedDeptCode(getAssociatedDeptCode(userBean.isAdmin(), loginStaffID));

			// store additional information
			userBean.setRemark1(remark1);
			userBean.setRemark2(remark2);
			userBean.setRemark3(remark3);
			userBean.setHireDate(hireDate);

			// set no of record per page
			userBean.setNoOfRecPerPage(20);

			// show debug message
			if (ConstantsServerSide.DEBUG) {
				logger.info("UserBean.setLoginID:[" + userBean.getLoginID() + "]");
				logger.info("UserBean.setUserName:[" + userBean.getUserName() + "]");
				logger.info("UserBean.setUserGroupID:[" + userBean.getUserGroupID() + "]");
				logger.info("UserBean.setUserGroupDesc:[" + userBean.getUserGroupDesc() + "]");
				logger.info("UserBean.setSiteCode:[" + userBean.getSiteCode() + "]");
				logger.info("UserBean.setDeptCode:[" + userBean.getDeptCode() + "]");
				logger.info("UserBean.setDeptDesc:[" + userBean.getDeptDesc() + "]");
				logger.info("UserBean.setStaffID:[" + userBean.getStaffID() + "]");
				logger.info("UserBean.setStaffCategory:[" + userBean.getStaffCategory() + "]");
				logger.info("UserBean.setHireDate:[" + userBean.getHireDate() + "]");
				logger.info("UserBean.isAdmin:[" + userBean.isAdmin() + "]");
				logger.info("userBean.isAllowAdmin:[" + userBean.isAllowAdmin() + "]");
				logger.info("userBean.isSwitchUser:[" + userBean.isSwitchUser() + "]");
				logger.info("userBean.isExpiredPassword:[" + userBean.isExpiredPassword() + "]");
			}

			// get access control
			userBean.setAccessControl(getAccessControl(request, userBean, groupLevel));

			// get access group id
			userBean.setAccessGroupID(getAccessGroupID(request, loginStaffID));

			// Save our logged-in user in the session
			userBean.writeToSession(request);

			return userBean;
		} else {
			return null;
		}
	}

	public static HashSet<String> getAssociatedDeptCode(boolean isAdmin, String loginStaffID) {
		HashSet<String> associatedDeptCodeHashMap = new HashSet<String>();

		if (!isAdmin) {
			ArrayList<ReportableListObject> record = StaffDB.getDeptCode2List(loginStaffID);
			if (record.size() > 0) {
				ReportableListObject row = null;
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
					associatedDeptCodeHashMap.add(row.getValue(0));
				}
			}
		}
		return associatedDeptCodeHashMap;
	}

	public static HashMap<String, String> getAccessControl(HttpServletRequest request, UserBean userBean, String groupLevel) {
		HashMap<String, String> accessControlHashMap = new HashMap<String, String>();

		ArrayList<ReportableListObject> record = AccessControlDB.getList(userBean, groupLevel);
		if (record.size() > 0) {
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				accessControlHashMap.put(row.getValue(0), row.getValue(1));
			}
		}
		return accessControlHashMap;
	}

	public static HashSet<String> getAccessGroupID(HttpServletRequest request, String staffID) {
		HashSet<String> accessGroupIDHashSet = new HashSet<String>();

		ArrayList<ReportableListObject> record = AccessControlDB.getGroupIDList(staffID);
		if (record.size() > 0) {
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				accessGroupIDHashSet.add(row.getValue(0));
			}
		}
		return accessGroupIDHashSet;
	}

	public static boolean isPortalUser(String userID, String password) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CO_USERS ");
		sqlStr.append("WHERE (CO_USERNAME = ? OR CO_STAFF_ID = ?) ");
		sqlStr.append("AND    CO_PASSWORD = ? ");

		return UtilDBWeb.isExist(
				sqlStr.toString(),
				new String[] { userID, userID, password });
	}

	public static boolean isCISUser(String userID, String password) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   AH_SYS_USER ");
		sqlStr.append("WHERE  USER_ID = ? ");
		sqlStr.append("AND    PASSWORD = ? ");

		return UtilDBWeb.isExistCIS(
				sqlStr.toString(),
				new String[] { userID, password });
	}

	public static boolean isCISUser(String userID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   AH_SYS_USER ");
		sqlStr.append("WHERE  USER_ID = ? ");
		sqlStr.append("AND    PASSWORD = ? ");

		return UtilDBWeb.isExistCIS(
				sqlStr.toString(),
				new String[] { userID });
	}

	public static boolean isNSUser(String userID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CO_USERS ");
		sqlStr.append("WHERE  TRIM(CO_USERNAME) LIKE 'NS%' ");
		sqlStr.append("AND  TRIM(CO_USERNAME) = ?");

		return UtilDBWeb.isExist(
				sqlStr.toString(),
				new String[] { userID });
	}

	public static boolean isDoctor(String staffID) {
		return staffID != null && staffID.indexOf(DOCTOR_PREFIX) == 0;
	}

	public static boolean isActiveDoctor(String loginID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   DOCTOR ");
		sqlStr.append("WHERE (HKMCLICNO = ? OR 'DR' || DOCCODE = ?) ");
		sqlStr.append("AND    DOCSTS = -1 ");

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableListHATS(
				sqlStr.toString(),
				new String[] { loginID, loginID });
		return result.size() > 0;
	}

	public static String getDoctorCode(String loginID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE ");
		sqlStr.append("FROM   DOCTOR ");
		sqlStr.append("WHERE (HKMCLICNO = ? OR 'DR' || DOCCODE = ?) ");
		sqlStr.append("AND    DOCSTS = -1 ");
		sqlStr.append("AND    MSTRDOCCODE IS NULL ");

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableListHATS(
				sqlStr.toString(),
				new String[] { loginID, loginID });
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static String getDoctorPassword(String doccode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT SUBSTR(DOCIDNO, 1, 3) || to_char(DOCBDATE, 'MMDD') ");
		sqlStr.append("FROM   DOCTOR ");
		sqlStr.append("WHERE  DOCCODE = ? ");
		sqlStr.append("AND    DOCSTS = -1 ");
		sqlStr.append("AND    MSTRDOCCODE IS NULL ");
		sqlStr.append("AND    HKMCLICNO IS NOT NULL ");
		sqlStr.append("AND    DOCIDNO IS NOT NULL ");
		sqlStr.append("AND    DOCBDATE IS NOT NULL ");

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableListHATS(
				sqlStr.toString(),
				new String[] { doccode });
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else{
			return null;
		}
	}

	public static String getUserEmail(String staffID) {
		return getUserEmail(null, staffID);
	}

	public static String getUserEmail(String siteCode, String staffID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CO_EMAIL ");
		sqlStr.append("FROM   CO_USERS ");
		sqlStr.append("WHERE  CO_STAFF_ID = ? ");
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    CO_SITE_CODE = '");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
		}
		sqlStr.append("AND    CO_ENABLED = 1 " );

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
				sqlStr.toString(), new String[] { staffID });
		if (result.size() > 0) {
			if (result.get(0) == null) {
				return null;
			} else {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				return reportableListObject.getValue(0);
			}
		} else {
			return null;
		}
	}

	public static String getUserEmailByUserName(String siteCode, String userName) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CO_EMAIL ");
		sqlStr.append("FROM   CO_USERS ");
		sqlStr.append("WHERE  (CO_USERNAME = '");
		sqlStr.append(userName);
		sqlStr.append("' OR CO_STAFF_ID = '");
		sqlStr.append(userName);
		sqlStr.append("') ");
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    CO_SITE_CODE = '");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
		}
		sqlStr.append("AND    CO_ENABLED = 1 " );

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static String getSiteCode(String userName) {
		StringBuffer sqlStr = new StringBuffer();
		String userNameUpperC = userName == null ? null : userName.toUpperCase();

		sqlStr.append("SELECT CO_SITE_CODE ");
		sqlStr.append("FROM   CO_USERS ");
		sqlStr.append("WHERE  (UPPER(CO_USERNAME) = ? OR UPPER(CO_STAFF_ID) = ?) ");
		sqlStr.append("AND    CO_ENABLED = 1 " );

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(sqlStr.toString(), 
				new String[]{userNameUpperC, userNameUpperC});
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static String getUserID(String email) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CO_STAFF_ID ");
		sqlStr.append("FROM   CO_USERS ");
		sqlStr.append("WHERE  UPPER(CO_EMAIL) = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 " );

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
				sqlStr.toString(), new String[] { email.toUpperCase() });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			return reportableListObject.getValue(0);
		} else {
			return null;
		}
	}

	public static String getStaffID(String userName) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CO_STAFF_ID ");
		sqlStr.append("FROM	  CO_USERS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_USERNAME = ? ");
		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userName });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	public static String getUserName(String staffID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CO_USERNAME ");
		sqlStr.append("FROM   CO_USERS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_STAFF_ID = ? ");
		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID });
		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CO_USERS ");
		sqlStr.append("WHERE  CO_STAFF_ID = ?");
		sqlStr_isExistUser = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_USERS (");
		sqlStr.append("CO_SITE_CODE, CO_USERNAME, CO_PASSWORD, CO_STAFF_YN, ");
		sqlStr.append("CO_STAFF_ID, CO_GROUP_ID) ");
		sqlStr.append("VALUES (?, ?, ?, 'Y', ?, 'staff')");
		sqlStr_insertUser = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_USERS SET CO_ENABLED = 1, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE CO_SITE_CODE = ? AND CO_STAFF_ID = ? AND CO_ENABLED = 0 ");
		sqlStr_enableUserByStaffId = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_USERS (");
		sqlStr.append("CO_SITE_CODE, CO_USERNAME, CO_PASSWORD, CO_STAFF_YN, ");
		sqlStr.append("CO_STAFF_ID, CO_GROUP_ID) ");
		sqlStr.append("VALUES (?, ?, ?, 'Y', ?, 'doctor')");
		sqlStr_insertDoctor = sqlStr.toString();
	}
}