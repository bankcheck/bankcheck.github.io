package com.hkah.web.common;

import java.util.HashMap;
import java.util.HashSet;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hkah.constant.ConstantsVariable;
import com.hkah.constant.ConstantsWebVariable;
import com.hkah.web.db.UserDB;

public class UserBean {

	private final static String FUNCTION_PREFIX = "function.";
	private final static String IT_DEPT_HKAH = "720";
	private final static String IM_DEPT_HKAH = "725";
	private final static String IT_DEPT_TWAH = "IT";

	// different user group
	public final static String ADMIN = "admin";
	public final static String VIEWADMIN = "viewadmin";
	public final static String AUTHOR = "author";
	public final static String MANAGER = "manager";
	public final static String OFFICE_ADMIN = "officeAdministrator";
	public final static String STAFF = "staff";
	public final static String DOCTOR = "doctor";
	public final static String GUEST = "guest";

	private String loginID = null;
	private String userName = null;
	private String userGroupID = null;
	private String userGroupDesc = null;
	private String siteCode = null;
	private String deptCode = null;
	private String deptDesc = null;
	private String staffID = null;
	private boolean switchUser = false;
	private HashSet<String> switchUserID = null;
	private boolean isDefaultPassword = false;
	private boolean isExpiredPassword = false;

	private HashSet<String> associatedDeptCode = null;
	private HashMap<String, String> accessControl = null;
	private HashSet<String> accessGroupID = null;
	private String staffStatus = null;
	private String staffCategory = null;

	private String remark1 = null;
	private String remark2 = null;
	private String remark3 = null;

	private int noOfRecPerPage = 0;
	private String hireDate = null;

	public UserBean() {
	}

	public UserBean(HttpServletRequest request) {
		this(request, true);
	}

	public UserBean(HttpServletRequest request, boolean readCookie) {
		readFromSession(request.getSession());
		if (readCookie && !isLogin()) {
			String staffID = readFromCookie(request);
			if (staffID != null) {
				UserBean userBean = UserDB.getUserBean(request, staffID);
				if (userBean != null) {
					readFromSession(userBean);
				}
			}
		}
	}

	/**
	 * @return loginID
	 */
	public String getLoginID() {
		return loginID;
	}

	/**
	 * @param loginID the loginID to set
	 */
	public void setLoginID(String loginID) {
		this.loginID = loginID;
	}

	public void resetLoginID() {
		this.loginID = null;
	}

	/**
	 * @return userName
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @param userName the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}

	/**
	 * @return userGroupID
	 */
	public String getUserGroupID() {
		return userGroupID;
	}

	/**
	 * @param userGroupID the userGroupID to set
	 */
	public void setUserGroupID(String userGroupID) {
		this.userGroupID = userGroupID;
	}

	/**
	 * @return the userGroupDesc
	 */
	public String getUserGroupDesc() {
		return userGroupDesc;
	}

	/**
	 * @param userGroupDesc the userGroupDesc to set
	 */
	public void setUserGroupDesc(String userGroupDesc) {
		this.userGroupDesc = userGroupDesc;
	}

	/**
	 * @return the siteCode
	 */
	public String getSiteCode() {
		return siteCode;
	}

	/**
	 * @param siteCode the siteCode to set
	 */
	public void setSiteCode(String siteCode) {
		this.siteCode = siteCode;
	}

	/**
	 * @return deptCode
	 */
	public String getDeptCode() {
		return deptCode;
	}

	/**
	 * @param deptCode the deptCode to set
	 */
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	/**
	 * @return deptDesc
	 */
	public String getDeptDesc() {
		return deptDesc;
	}

	/**
	 * @param deptDesc the deptDesc to set
	 */
	public void setDeptDesc(String deptDesc) {
		this.deptDesc = deptDesc;
	}

	/**
	 * @return staffID
	 */
	public String getStaffID() {
		return staffID;
	}

	/**
	 * @param staffID the staffID to set
	 */
	public void setStaffID(String staffID) {
		this.staffID = staffID;
	}

	/**
	 * @return the switchUser
	 */
	public boolean isSwitchUser() {
		return switchUser;
	}

	/**
	 * @param switchUser the switchUser to set
	 */
	public void setSwitchUser(boolean switchUser) {
		this.switchUser = switchUser;
	}

	/**
	 * @return the switchUserID
	 */
	public HashSet<String> getSwitchUserID() {
		return switchUserID;
	}

	/**
	 * @param switchUserID the switchUserID to set
	 */
	private void setSwitchUserID(HashSet<String> switchUserID) {
		this.switchUserID = switchUserID;
	}

	public void addSwitchUserID(HttpServletRequest request, String userID) {
		if (switchUserID == null) {
			switchUserID = new HashSet<String>();
		}
		switchUserID.add(userID);
	}

	public boolean isDefaultPassword() {
		return isDefaultPassword;
	}

	public void setDefaultPassword(boolean isDefaultPassword) {
		this.isDefaultPassword = isDefaultPassword;
	}

	public boolean isExpiredPassword() {
		return isExpiredPassword;
	}

	public void setExpiredPassword(boolean isExpiredPassword) {
		this.isExpiredPassword = isExpiredPassword;
	}

	/**
	 * @return noOfRecPerPage
	 */
	public int getNoOfRecPerPage() {
		return noOfRecPerPage;
	}

	/**
	 * @param noOfRecPerPage the noOfRecPerPage to set
	 */
	public void setNoOfRecPerPage(int noOfRecPerPage) {
		this.noOfRecPerPage = noOfRecPerPage;
	}

	/**
	 * @return the associatedDeptCode
	 */
	public HashSet<String> getAssociatedDeptCode() {
		return associatedDeptCode;
	}

	/**
	 * check whether department code is associated
	 * @param deptCode
	 * @return
	 */
	public boolean isAssociatedDeptCode(String deptCode) {
		return getAssociatedDeptCode().contains(deptCode);
	}

	/**
	 * @param associatedDeptCode the associatedDeptCode to set
	 */
	public void setAssociatedDeptCode(HashSet<String> associatedDeptCode) {
		this.associatedDeptCode = associatedDeptCode;
	}

	/**
	 * @return the accessControl
	 */
	public HashMap<String, String> getAccessControl() {
		return accessControl;
	}

	/**
	 * @param accessControl the accessControl to set
	 */
	public void setAccessControl(HashMap<String, String> accessControl) {
		this.accessControl = accessControl;
	}

	/**
	 * @return the accessGroupID
	 */
	public HashSet<String> getAccessGroupID() {
		return accessGroupID;
	}

	/**
	 * @param accessGroupID the accessGroupID to set
	 */
	public void setAccessGroupID(HashSet<String> accessGroupID) {
		this.accessGroupID = accessGroupID;
	}

	/**
	 * @return the staffStatus
	 */
	public String getStaffStatus() {
		return staffStatus;
	}

	/**
	 * @param staffStatus the staffStatus to set
	 */
	public void setStaffStatus(String staffStatus) {
		this.staffStatus = staffStatus;
	}

	/**
	 * @return the staffCategory
	 */
	public String getStaffCategory() {
		return staffCategory;
	}

	/**
	 * @param staffCategory the staffCategory to set
	 */
	public void setStaffCategory(String staffCategory) {
		this.staffCategory = staffCategory;
	}

	/**
	 * @return the remark1
	 */
	public String getRemark1() {
		return remark1;
	}

	/**
	 * @param remark1 the remark1 to set
	 */
	public void setRemark1(String remark1) {
		this.remark1 = remark1;
	}

	/**
	 * @return the remark2
	 */
	public String getRemark2() {
		return remark2;
	}

	/**
	 * @param remark2 the remark2 to set
	 */
	public void setRemark2(String remark2) {
		this.remark2 = remark2;
	}

	/**
	 * @return the remark3
	 */
	public String getRemark3() {
		return remark3;
	}

	/**
	 * @param remark3 the remark3 to set
	 */
	public void setRemark3(String remark3) {
		this.remark3 = remark3;
	}

	/**
	 * @return the hireDate
	 */
	public String getHireDate() {
		return hireDate;
	}

	/**
	 * @param remark3 the remark3 to set
	 */
	public void setHireDate(String hireDate) {
		this.hireDate  = hireDate;
	}

	public void setAdmin(HttpServletRequest request) {
		UserDB.getUserBean(request, "0000");
	}

	public void setViewAdmin(HttpServletRequest request) {
		UserDB.getUserBean(request, "0001");
	}

	public boolean isAdmin() {
		return isLogin() && ADMIN.equals(getUserGroupID());
	}

	public boolean isViewAdmin() {
		return isLogin() && VIEWADMIN.equals(getUserGroupID());
	}

	public boolean isAuthor() {
		return isLogin() && (AUTHOR.equals(getUserGroupID()) || isAdmin());
	}

	public boolean isEducationManager() {
		return isLogin() && ((getAccessGroupID() != null && getAccessGroupID().contains("managerEducation")) || isAdmin());
	}

	public boolean isSuperManager() {
		return isLogin() && (isHRManager() || isAuthor() || isAdmin());
	}

	public boolean isHRManager() {
		return isLogin() && ((getAccessGroupID() != null && getAccessGroupID().contains("managerHR")) || isAdmin());
	}

	public boolean isOfficeAdministrator() {
		return isLogin() && (OFFICE_ADMIN.equals(getUserGroupID()) || isAdmin());
	}

	public boolean isManager() {
		return isLogin() && (MANAGER.equals(getUserGroupID()) || isSuperManager() || isOfficeAdministrator() || isAdmin());
	}

	public boolean isStaff() {
		return isLogin() && (STAFF.equals(getUserGroupID()) || isManager() || isAdmin());
	}

	public boolean isDoctor() {
		return isLogin() && (DOCTOR.equals(getUserGroupID()) || isAdmin());
	}

	public boolean isIT() {
		return isLogin() && (IT_DEPT_HKAH.equals(getDeptCode()) || IM_DEPT_HKAH.equals(getDeptCode()) || IT_DEPT_TWAH.equals(getDeptCode()));
	}

	public boolean isAllowAdmin() {
		return isLogin() && isIT() && (getAccessGroupID() != null && getAccessGroupID().contains("managerPortal"));
	}

	public boolean isVolunteer(){
		return isLogin() && staffID != null && staffID.startsWith("SRCV");
	}

	public boolean isStudentUser(){
		return isLogin() && staffID != null && staffID.startsWith("SRCS");
	}

	public boolean isLogin() {
		return getLoginID() != null;
	}

	public boolean isAccessible(String functionID) {
		if (!isAdmin()
				&& getAccessControl() != null
				&& functionID != null
				&& functionID.startsWith(FUNCTION_PREFIX)) {
			return getAccessControl().containsKey(functionID);
		} else {
			return true;
		}
	}

	public boolean isGroupID(String groupID) {
		return isAdmin() || (getAccessGroupID() != null && getAccessGroupID().contains(groupID));
	}

	public boolean isGuest() {
		return GUEST.equals(getUserGroupID());
	}

	public boolean isNSUser() {
		return getLoginID() != null && getLoginID().toLowerCase().startsWith("ns");
	}

	/**
	 * @param HttpServletRequest
	 */
	public void writeToSession(HttpServletRequest request) {
		writeToSession(request.getSession());
	}

	/**
	 * @param HttpSession
	 */
	public void writeToSession(HttpSession session) {
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_ID, getLoginID());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_USER_NAME, getUserName());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_USER_GROUP_ID, getUserGroupID());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_USER_GROUP_DESC, getUserGroupDesc());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_SITE_CODE, getSiteCode());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_DEPT_CODE, getDeptCode());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_DEPT_DESC, getDeptDesc());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_STAFF_ID, getStaffID());

		session.setAttribute(ConstantsWebVariable.KEY_SESSION_SWITCH_USER, new Boolean(isSwitchUser()));
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_SWITCH_USER_ID, getSwitchUserID());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_DEFAULT_PASSWORD, new Boolean(isDefaultPassword()));
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_EXPIRED_PASSWORD, new Boolean(isExpiredPassword()));

		session.setAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_ASSOCIATED_DEPT_CODE, getAssociatedDeptCode());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_USER_ACCESS_CONTROL, getAccessControl());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_USER_ACCESS_GROUP_ID, getAccessGroupID());

		session.setAttribute(ConstantsWebVariable.KEY_SESSION_REMARK_1, getRemark1());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_REMARK_2, getRemark2());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_REMARK_3, getRemark3());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_HIRE_DATE, getHireDate());
		session.setAttribute(ConstantsWebVariable.KEY_SESSION_NO_OF_REC_PER_PAGE, new Integer(getNoOfRecPerPage()));
	}

	/**
	 * @param HttpServletRequest
	 */
	public void readFromSession(HttpServletRequest request) {
		readFromSession(request.getSession());
	}

	/**
	 * @param HttpSession
	 */
	@SuppressWarnings("unchecked")
	public void readFromSession(HttpSession session) {
		setLoginID((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_ID));
		setUserName((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_USER_NAME));
		setUserGroupID((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_USER_GROUP_ID));
		setUserGroupDesc((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_USER_GROUP_DESC));
		setSiteCode((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_SITE_CODE));
		setDeptCode((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_DEPT_CODE));
		setDeptDesc((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_DEPT_DESC));
		setStaffID((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_STAFF_ID));

		try {
			setSwitchUser(((Boolean) session.getAttribute(ConstantsWebVariable.KEY_SESSION_SWITCH_USER)).booleanValue());
		} catch (Exception e) {
			setSwitchUser(false);
		}
		setSwitchUserID((HashSet<String>) session.getAttribute(ConstantsWebVariable.KEY_SESSION_SWITCH_USER_ID));
		try {
			setDefaultPassword(((Boolean) session.getAttribute(ConstantsWebVariable.KEY_SESSION_DEFAULT_PASSWORD)).booleanValue());
		} catch (Exception e) {
			setDefaultPassword(false);
		}
		try {
			setExpiredPassword(((Boolean) session.getAttribute(ConstantsWebVariable.KEY_SESSION_EXPIRED_PASSWORD)).booleanValue());
		} catch (Exception e) {
			setExpiredPassword(false);
		}

		setAssociatedDeptCode((HashSet<String>) session.getAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_ASSOCIATED_DEPT_CODE));
		setAccessControl((HashMap<String, String>) session.getAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_USER_ACCESS_CONTROL));
		setAccessGroupID((HashSet<String>) session.getAttribute(ConstantsWebVariable.KEY_SESSION_LOGIN_USER_ACCESS_GROUP_ID));

		setRemark1((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_REMARK_1));
		setRemark2((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_REMARK_2));
		setRemark3((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_REMARK_3));
		setHireDate((String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_HIRE_DATE));
		try {
			setNoOfRecPerPage(((Integer) session.getAttribute(ConstantsWebVariable.KEY_SESSION_NO_OF_REC_PER_PAGE)).intValue());
		} catch (Exception e) {}
	}

	/**
	 * @param HttpSession
	 */
	public void readFromSession(UserBean userBean) {
		setLoginID(userBean.getLoginID());
		setUserName(userBean.getUserName());
		setUserGroupID(userBean.getUserGroupID());
		setUserGroupDesc(userBean.getUserGroupDesc());
		setSiteCode(userBean.getSiteCode());
		setDeptCode(userBean.getDeptCode());
		setDeptDesc(userBean.getDeptDesc());
		setStaffID(userBean.getStaffID());

		setSwitchUser(userBean.isSwitchUser());
		setSwitchUserID(userBean.getSwitchUserID());

		setAssociatedDeptCode(userBean.getAssociatedDeptCode());
		setAccessControl(userBean.getAccessControl());
		setAccessGroupID(userBean.getAccessGroupID());

		setRemark1(userBean.getRemark1());
		setRemark2(userBean.getRemark2());
		setRemark3(userBean.getRemark3());

		setNoOfRecPerPage(userBean.getNoOfRecPerPage());
	}

	/**
	 * @param HttpServletRequest
	 */
	public String readFromCookie(HttpServletRequest request) {
		String staffID = null;
		Cookie cookies [] = request.getCookies();
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				if (ConstantsWebVariable.KEY_SESSION_LOGIN_STAFF_ID.equals(cookies[i].getName())) {
					staffID = cookies[i].getValue();
					break;
				}
			}
		}
		return staffID;
	}

	/**
	 * @param HttpServletResponse
	 */
	public void writeToCookie(HttpServletResponse response) {
		// save staff id
		Cookie cookie = new Cookie(ConstantsWebVariable.KEY_SESSION_LOGIN_STAFF_ID, staffID);
		// only store one month
		cookie.setMaxAge(30 * 24 * 60 * 60);
		response.addCookie(cookie);
	}

	public void invalidate(HttpServletRequest request, HttpServletResponse response) {
		// clear session
		HttpSession session = request.getSession();
		session.invalidate();

		// clear cookie
		Cookie cookie = new Cookie(ConstantsWebVariable.KEY_SESSION_LOGIN_STAFF_ID, ConstantsVariable.EMPTY_VALUE);
		// set cookie expired
		cookie.setMaxAge(0);
		response.addCookie(cookie);
	}
}