/*
 * Created on January 31, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.action;

import java.util.ArrayList;
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
import com.hkah.web.common.ReportableListObject;


/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CRMResetPasswordAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ActionMessages messages = new ActionMessages();
		// Validate the request parameters specified by the user
		String email = null;
		String userID = (String) PropertyUtils.getSimpleProperty(form, "userName");

		String newPassword = null;
		String siteCode = ConstantsServerSide.SITE_CODE;

		try {
			if (UtilDBWeb.isExist("SELECT 1 FROM CO_USERS WHERE LOWER(CO_USERNAME) = ? AND CO_STAFF_ID IS NULL ", new String[] { userID.toLowerCase() })) {
				ArrayList record = getClientEmailAddress(userID);
				if (record.size() != 0) {
					ReportableListObject clientRecord = (ReportableListObject)record.get(0);
					email = clientRecord.getValue(0);
				}
				if (email != null && email.length() > 0) {
					newPassword = generatePwd();
					if (UtilDBWeb.updateQueue(
						"UPDATE CO_USERS " +
						"SET    CO_PASSWORD = ?, " +
						"       CO_MODIFIED_DATE = SYSDATE, " +
						"       CO_MODIFIED_USER = 'GUEST' " +
						"WHERE  CO_SITE_CODE = '" + siteCode + "' AND LOWER(CO_USERNAME) = ?",
						new String[] { PasswordUtil.cisEncryption(newPassword), userID.toLowerCase() } )) {
						messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.password.thurEmail"));

						// send email
						UtilMail.sendMail(
							ConstantsServerSide.MAIL_ALERT,
							email,
							"Intranet Password",
							"Your New Intranet Password is " + newPassword + ".",
							true); // DO NOT send bcc to portal admin
					} else {
						messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.user.notExist"));
					}
				} else {
					messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.crm.email.notFound"));
				}
			} else {
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.user.notExist"));
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


	private static ArrayList getClientEmailAddress(String userName) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_EMAIL ");
		sqlStr.append("FROM CO_USERS ");
		sqlStr.append("WHERE LOWER(CO_USERNAME) ='"+userName.toLowerCase()+"' ");

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
}