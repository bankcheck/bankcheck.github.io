/*
 * Created on January 31, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.action;

import java.util.Random;

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
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ResetPasswordAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ActionMessages messages = new ActionMessages();
		UserBean userBean = new UserBean(request);

		// Validate the request parameters specified by the user
		String email = (String) PropertyUtils.getSimpleProperty(form, "email");
		String staffID = (String) PropertyUtils.getSimpleProperty(form, "staffID");
		//System.out.println(staffID);
		String newPassword = null;
		String siteCode = ConstantsServerSide.SITE_CODE;
		// if session has login, use current user id as modified user
		String userId = userBean == null ? UserBean.GUEST : userBean.getLoginID();

		try {
			if (UtilDBWeb.isExist("SELECT 1 FROM CO_USERS WHERE CO_STAFF_ID  = ?", new String[] { staffID })) {
				newPassword = generatePwd();
				if (UtilDBWeb.updateQueue(
					"UPDATE CO_USERS " +
					"SET    CO_PASSWORD = ?, " +
					"       CO_MODIFIED_DATE = SYSDATE, " +
					"       CO_MODIFIED_USER = ? " +
					"WHERE  CO_SITE_CODE = '" + siteCode + "' AND CO_STAFF_ID = ?",
					new String[] { PasswordUtil.cisEncryption(newPassword), userId, staffID } )) {
					messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.password.thurEmail"));

					// send email
					UtilMail.sendMail(
						ConstantsServerSide.MAIL_ALERT,
						email,
						"New Password",
						"Your New Password is " + newPassword + ".",
						false); // DO NOT send bcc to portal admin
				} else {
					messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.user.notExist"));
				}
			} else {
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.user.notFound", staffID));
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
		return mapping.findForward("success");
	}

	private String generatePwd() {
		String result = "";
		Random random = new Random();

		while(result.length() < 6) {
			int randomnumber = random.nextInt();
			int tmpnumber = Math.abs((int)(36 * ((double)randomnumber / 32768)) + 48);
			/*  0 - 9, A - Z  */
			if ((tmpnumber > 47 && tmpnumber < 58) || (tmpnumber < 91 && tmpnumber > 64)) {
				/* ignore '0' and 'O' */
				if (!((char)tmpnumber == '0' || (char)tmpnumber == 'O')) {
					result = result + (char)tmpnumber;
				}
			}
		}
		return result;
	}
}