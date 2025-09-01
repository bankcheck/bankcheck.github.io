/*
 * Created on January 31, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.SsoUserDB;
import com.hkah.web.db.StaffDB;
import com.hkah.web.db.UserDB;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class LogonAction extends Action {

	private final static String DEFAULT_PASSWORD = "123456" ;

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ActionMessages messages = new ActionMessages();

		// Validate the request parameters specified by the user
		String loginUserID = (String) PropertyUtils.getSimpleProperty(form, "loginID");
		String loginPwd = (String) PropertyUtils.getSimpleProperty(form, "loginPwd");
		String savePwd = (String) PropertyUtils.getSimpleProperty(form, "savePwd");
		boolean isNSMsg = false;
		UserBean userBean = null;

		try {
			if (loginUserID != null && loginUserID.length() > 4000) {
				// exceed oracle max varchar param length
				String errMsg = "Parameter loginUserID longer than max 4000, actual length:" + loginUserID.length();
//				System.out.println("[LogonAction] Error: " + errMsg);
				throw new Exception(errMsg);
			}

			// get site code
			String siteCode = UserDB.getSiteCode(loginUserID);
			
//			System.out.println("[LogonAction] login loginUserID=" + loginUserID + ",siteCode=" + siteCode);

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

			// check user from CIS
			if (userBean == null && !ConstantsServerSide.isAMC()) {
				String encryptedPwd = PasswordUtil.cisEncryption(loginPwd);
				if (UserDB.isCISUser(loginUserID.toLowerCase(), encryptedPwd)) {
					if (UserDB.isExistByStaffID(loginUserID.toUpperCase())) {
						// store cis password to co_users
						// UserDB.updatePassword(loginUserID.toUpperCase(), loginPwd);
					} else if (loginUserID.toUpperCase().startsWith("DR")) {
						// insert cis users to co_users and co_staffs
						// restrict to doctor only for hkah
						StaffDB.addDoctor(loginUserID.toUpperCase());
						UserDB.addDoctor(ConstantsServerSide.SITE_CODE, loginUserID, PasswordUtil.cisEncryption(loginPwd), loginUserID.toUpperCase());
						userBean = UserDB.getUserBean(request, loginUserID);
					}
				}
			}

			// create user id if only exists in staff table
			if (userBean == null
					&& StaffDB.isExistActive(loginUserID) && !UserDB.isExistByStaffID(loginUserID)) {
				UserDB.add(ConstantsServerSide.SITE_CODE, loginUserID, PasswordUtil.cisEncryption(DEFAULT_PASSWORD), loginUserID);

				// retrieve again
				userBean = UserDB.getUserBean(request, loginUserID, loginPwd);

				// force to change password
				userBean.setDefaultPassword(true);

				// store in session
				userBean.writeToSession(request);
			}

			// create user id if only exists in hats doctor table
			if (userBean == null) {
				String doccode = UserDB.getDoctorCode(loginUserID);

				if (doccode != null) {
					String docPwd = UserDB.getDoctorPassword(doccode);

					if (docPwd != null) {
						// create doctor in portal table
						UtilDBWeb.callFunction("HAT_ACT_CREATEDOCTOR", "ADD", new String[] { doccode,  PasswordUtil.cisEncryption(docPwd)});
					}

					// retrieve again
					userBean = UserDB.getUserBean(request, loginUserID, loginPwd);
				}
			}

			// create sso session id
			if (userBean != null) {
				SsoUserDB.addSessionID(request.getSession().getId(), userBean, request.getRemoteAddr());
			}

			if (userBean != null) {
				if (UserDB.isDoctor(userBean.getStaffID()) && ConstantsServerSide.SITE_CODE.equals(userBean.getSiteCode())) {
					if (!UserDB.isActiveDoctor(userBean.getStaffID())) {
						// inactive doctor cannot login
						messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.staffID.expired"));
					}
				} else if (!ConstantsVariable.ZERO_VALUE.equals(userBean.getStaffStatus())) {
					// check password
					if (loginPwd != null && DEFAULT_PASSWORD.equals(loginPwd)) {
						userBean.setDefaultPassword(true);

						// store in session
						userBean.writeToSession(request);
					}

					// write to cookie
					if (ConstantsVariable.YES_VALUE.equals(savePwd)) {
						userBean.writeToCookie(response);
					}
				} else {
					// staff status is expired
					messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.staffID.expired"));
				}
			} else {
				if (isNSMsg) {
					messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.nsNOAccessRight.invalid"));
				} else {
					// invalid password
					messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.loginPwd.invalid"));
				}
			}
		} catch (Exception e) {
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.server.error"));
			e.printStackTrace();
		}

		// Forward control to the specified success URI
		if (messages.size() == 0) {
			return mapping.findForward("success");
		} else {
			// Report any errors we have discovered back to the original form
			if (userBean != null) {
				userBean.resetLoginID();
				userBean.writeToSession(request);
			}
			saveMessages(request, messages);
			return mapping.findForward("fail");
		}
	}
}