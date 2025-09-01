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
import com.hkah.util.DateTimeUtil;
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.HelpDeskDB;
import com.hkah.web.db.UserDB;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ChangePasswordAction extends Action {

	private final static String DEFAULT_PASSWORD = "123456" ;

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ActionMessages messages = new ActionMessages();

		UserBean userBean = new UserBean(request);

		// Validate the request parameters specified by the user
		String oldPassword = (String) PropertyUtils.getSimpleProperty(form, "oldPassword");
		String newPassword = (String) PropertyUtils.getSimpleProperty(form, "password");
		String confirmPassword = (String) PropertyUtils.getSimpleProperty(form, "confirmPassword");
		String module = (String) PropertyUtils.getSimpleProperty(form, "module");
		boolean success = false;
		
		System.out.println(DateTimeUtil.getCurrentDateTime() + " [ChangePasswordAction] userBean.getLoginID()="+userBean.getLoginID()+", site="+ConstantsServerSide.SITE_CODE);

		try {
			if (DEFAULT_PASSWORD.equals(newPassword)) {
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.defaultPassword.invalid"));
			} else if (!newPassword.equals(confirmPassword)) {
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.confirmPassword.invalid"));
			} else if (!UserDB.isPortalUser(userBean.getLoginID(), PasswordUtil.cisEncryption(oldPassword))
					&& !UserDB.isCISUser(userBean.getLoginID(), PasswordUtil.cisEncryption(oldPassword))) {
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.loginPwd.invalid"));
			} else if (!UtilDBWeb.isExist(
					"SELECT 1 FROM CO_USERS WHERE (CO_USERNAME = ? OR CO_STAFF_ID = ?) AND CO_SITE_CODE = ?",
					new String[] { userBean.getLoginID(), userBean.getLoginID(), ConstantsServerSide.SITE_CODE })) {
				if (ConstantsServerSide.isHKAH()) {
					messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.siteCodeTwah.invalid"));
				} else {
					messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.siteCodeHkah.invalid"));
				}
			} else if (UserDB.updatePassword(userBean, newPassword)) {
				// update password
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.password.updated"));

				// sync helpdesk password
				HelpDeskDB.synchronizePortalPassword(userBean.getLoginID().toLowerCase());
				
				// sync AMC1/AMC2 password
				UserDB.syncPassword2AMC(userBean.getLoginID());

				success = true;
			} else {
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.password.updateFail"));
			}
		} catch (Exception e) {
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.server.error"));
			e.printStackTrace();
		}

		// Report any errors we have discovered back to the original form
		if (messages.size() != 0) {
			saveMessages(request, messages);
		}

		// Forward control to the specified success URI
		if (module != null && module.equals("crm.portal")) {
			return mapping.findForward("crm_success");
		} else {
			if (success) {
				return mapping.findForward("success");
			} else {
				return mapping.findForward("fail");
			}
		}
	}
}