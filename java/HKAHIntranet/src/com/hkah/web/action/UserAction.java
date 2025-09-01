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

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.validator.DynaValidatorForm;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.AccessControlDB;
import com.hkah.web.db.CRMClientDB;
import com.hkah.web.db.UserDB;
import com.hkah.web.db.UserGroupsDB;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class UserAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ActionMessages messages = new ActionMessages();

		UserBean userBean = new UserBean(request);

		//get the dynamic form
		DynaValidatorForm theForm = (DynaValidatorForm)form;

		// Validate the request parameters specified by the user
		String command = (String) theForm.get("command");
		String step = (String) theForm.get("step");
		String userName = (String) theForm.get("userName");
		String password = (String) theForm.get("password");
		String lastName = (String) theForm.get("lastName");
		String firstName = (String) theForm.get("firstName");
		String emailPrefix = (String) theForm.get("emailPrefix");
		String emailSuffix = (String) theForm.get("emailSuffix");
		String email = null;
		String staff_YN = null;
		String siteCode = (String) theForm.get("siteCode");
		String staffID = (String) theForm.get("staffID");
		String groupName = (String) theForm.get("groupName");
		String functionID[] = (String []) theForm.get("functionID");
		boolean select2IsEmpty = "Y".equals(request.getParameter("select2IsEmpty"));
		boolean hasFunctionID = "Y".equals(request.getParameter("hasFunctionID"));
		String noLevelGroupID[] = (String []) theForm.get("noLevelGroupID");
		boolean noLevelGroupIDSelect2IsEmpty = "Y".equals(request.getParameter("noLevelGroupIDSelect2IsEmpty"));
		String cID = (String) theForm.get("cID");
		String level = (String) theForm.get("level");
		String enabled = (String) theForm.get("enabled");

		boolean createAction = false;
		boolean updateAction = false;
		boolean deleteAction = false;
		boolean success = false;

		if ("create".equals(command)) {
			createAction = true;
		} else if ("update".equals(command)) {
			updateAction = true;
		} else if ("delete".equals(command)) {
			deleteAction = true;
		}

		boolean isLMC = false;
		if (userName != null && userName.substring(0,3).equals("LMC")) {
			isLMC = true;
		}

		// only admin or author can create user
		if (!isLMC) {
			if (deleteAction && !userBean.isAuthor()) {
				return mapping.findForward("main");
			} else if (!createAction && !updateAction && !deleteAction) {
				return mapping.findForward("user");
			}
		}

		String redirectUrl = "user";
		try {
			if (isLMC) {
				email = emailPrefix;
			} else {
				if (emailPrefix != null && emailPrefix.length() > 0) {
					email = emailPrefix + "@" + emailSuffix;
				}
			}

			if ("1".equals(step)) {
				if ((createAction || updateAction)) {
					if (isStaff(staffID)) {
						if (groupName == null || groupName.length() == 0) {
							groupName = "staff";
						}
						staff_YN = ConstantsVariable.YES_VALUE;
					} else {
						if (groupName == null || groupName.length() == 0) {
							groupName = "guest";
						}
						staff_YN = ConstantsVariable.NO_VALUE;
					}
				}

				if (!userBean.isAdmin() && createAction && UserDB.isCISUser(userBean.getUserName())) {
					messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.user.notAllowToChangeCIS"));
				} else if (createAction) {
					if (password == null || password.length() == 0)
						if (email != null && email.length() > 0 && !isLMC) {
							password = generatePwd();
						} else {
							password = userName;
						}

						if (UtilDBWeb.isExist(
								"SELECT 1 FROM CO_USERS WHERE CO_USERNAME = ? AND CO_ENABLED = 0",
								new String[] { userName } )) {

							UtilDBWeb.updateQueue(
									"UPDATE CO_USERS SET CO_PASSWORD = ?, " +
									"       CO_LASTNAME = ?, CO_FIRSTNAME = ?, CO_EMAIL = ?, CO_STAFF_YN = ?, " +
									"       CO_SITE_CODE = ?, CO_STAFF_ID = ?, CO_GROUP_ID = ?, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ?, CO_ENABLED = 1 " +
									"WHERE  CO_USERNAME = ? AND CO_ENABLED = 0",
									new String[] { PasswordUtil.cisEncryption(password), lastName, firstName, email, staff_YN, siteCode, staffID, groupName, userBean.getLoginID(), userName } );

							if (cID != null && cID.length() > 0) {
								updateClientUserName(cID,userName,userBean.getLoginID());
							}

							success = true;
						} else if (UtilDBWeb.updateQueue(
							"INSERT INTO CO_USERS (CO_USERNAME, CO_PASSWORD, " +
							"                      CO_LASTNAME, CO_FIRSTNAME, CO_EMAIL, CO_STAFF_YN, " +
							"                      CO_SITE_CODE, CO_STAFF_ID, CO_GROUP_ID, CO_CREATED_USER, CO_MODIFIED_USER) " +
							"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
							new String[] { userName, PasswordUtil.cisEncryption(password), lastName, firstName, email, staff_YN, siteCode, staffID, groupName, userBean.getLoginID(), userBean.getLoginID() } )) {

							if (cID != null && cID.length() > 0) {
								updateClientUserName(cID,userName,userBean.getLoginID());
							}

						success = true;
					}

					if (success) {
						if (email == null || email.length() == 0 || isLMC) {
							messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.user.idAndPwd", userName, password));
						} else {
							messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.password.thurEmail"));

							// send email
							UtilMail.sendMail(
								ConstantsServerSide.MAIL_ALERT,
								email,
								"Intranet Password",
								"Your Intranet Password is " + password);
						}

						// forward page
						if (userBean.isAuthor()||isLMC) {
							redirectUrl = "user";
						} else {
							redirectUrl = "logon";
						}
					} else {
						messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.user.alreadyExist"));
					}
				} else if (updateAction) {
					StringBuffer sqlStr = new StringBuffer();
					sqlStr.append("UPDATE CO_USERS ");
					sqlStr.append("SET    CO_LASTNAME = ?, ");
					sqlStr.append("       CO_FIRSTNAME = ?, ");
					if (password.length() > 0) {
						sqlStr.append("       CO_PASSWORD = '");
						sqlStr.append(PasswordUtil.cisEncryption(password));
						sqlStr.append("', ");
					}
					sqlStr.append("       CO_EMAIL = ?, ");
					sqlStr.append("       CO_STAFF_YN = ?, ");
					sqlStr.append("       CO_SITE_CODE = ?, ");
					sqlStr.append("       CO_STAFF_ID = ?, ");
					sqlStr.append("       CO_GROUP_ID = ?, ");
					sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, ");
					sqlStr.append("       CO_MODIFIED_USER = ?, ");
					sqlStr.append("       CO_ENABLED = ? ");
					sqlStr.append("WHERE  CO_USERNAME = ?");

					// update and reset password
					if (UtilDBWeb.updateQueue(
							sqlStr.toString(),
							new String[] { lastName, firstName, email, staff_YN, siteCode, staffID, groupName, userBean.getLoginID(), enabled, userName } )) {

						if (userName != null && userName.length() > 0) {
							updateClientInfo(userName, lastName, firstName, email, userBean.getLoginID());
						}

						if (level != null && level.length() > 0) {
							updateClientNEWSTARTLevel(userName, userBean.getLoginID(), level);
						}

						messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.user.updated"));
						redirectUrl = "user";
						success = true;
					} else {
						messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.user.notExist"));
					}
				} else if (deleteAction) {
					if (UtilDBWeb.updateQueue(
							"UPDATE CO_USERS SET CO_ENABLED = 0, " +
							"       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? " +
							"WHERE  CO_USERNAME = ?",
							new String[] { userBean.getLoginID(), userName } )) {

						if (userName != null && userName.length() > 0) {
							deleteClientInfoUserName(userBean.getLoginID(), userName);
						}

						messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.user.deleted"));
						success = true;
					} else {
						messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.user.notExist"));
					}
					redirectUrl = "user";
				}

				// update user access
				if (success) {
					// clean up the original
					request.setAttribute("command", ConstantsVariable.EMPTY_VALUE);
					request.setAttribute("step", ConstantsVariable.EMPTY_VALUE);
					if (createAction || updateAction) {
						request.setAttribute("userName", userName);
					} else {
						request.setAttribute("userName", ConstantsVariable.EMPTY_VALUE);
					}

					if (hasFunctionID) {
						AccessControlDB.delete(siteCode, staffID);
						UserGroupsDB.delete(siteCode, staffID);

						if ((createAction || updateAction)) {
							if (functionID != null) {
								if (select2IsEmpty) {
									functionID = new String[0];
								}
								for (int i = 0; i < functionID.length; i++) {
									if (AccessControlDB.add(userBean, functionID[i], siteCode, staffID)) {
										success = true;
									}
								}
							}

							if (noLevelGroupID != null) {
								if (noLevelGroupIDSelect2IsEmpty) {
									noLevelGroupID = new String[0];
								}
								for (int i = 0; i < noLevelGroupID.length; i++) {
									if (UserGroupsDB.add(userBean, noLevelGroupID[i], siteCode, staffID)) {
										success = true;
									}
								}
							}
						}
					}
				}
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
		return mapping.findForward(redirectUrl);
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

	private boolean isStaff(String userName) {
		if (userName != null && userName.length() > 0) {
			return UtilDBWeb.isExist("SELECT 1 FROM CO_STAFFS WHERE CO_STAFF_ID = ?", new String[] { userName } );
		} else {
			return false;
		}
	}

	private static boolean updateClientInfo(String userName,String lastName,String firstName,String email,String updateUser) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CRM_CLIENTS ");
		sqlStr.append("SET    CRM_LASTNAME = ?, ");
		sqlStr.append("       CRM_FIRSTNAME = ?, ");
		sqlStr.append("       CRM_EMAIL = ?, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("       CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = ?");

		// update and reset password
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { lastName, firstName, email, updateUser, CRMClientDB.getClientID(userName) } ) ;
	}

	private static boolean deleteClientInfoUserName(String deleteUser, String userName) {

		// update and reset password
		return UtilDBWeb.updateQueue(
				"UPDATE CRM_CLIENTS SET CRM_USERNAME = '', " +
				"       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? " +
				"WHERE  CRM_CLIENT_ID = ?",
				new String[] { deleteUser, CRMClientDB.getClientID(userName) } );
	}

	private static boolean updateClientUserName(String cID,String userName,String updateUser) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CRM_CLIENTS ");
		sqlStr.append("SET    CRM_USERNAME = '"+userName+"', ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("       CRM_MODIFIED_USER = '"+updateUser+"' ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = '"+cID+"' ");
		sqlStr.append("AND    CRM_USERNAME IS NULL ");

		return UtilDBWeb.updateQueue(sqlStr.toString()) ;
	}

	private boolean updateClientNEWSTARTLevel(String userName,String updateUser,String level) {
		StringBuffer sqlStr = new StringBuffer();
		if (isClientLevelExist(userName)) {
			sqlStr.append("UPDATE CRM_CLIENTS_NEWSTART ");
			sqlStr.append("SET    CRM_NS_LEVEL = '" + level + "', ");
			sqlStr.append("       CRM_NS_MODIFIED_DATE = SYSDATE, ");
			sqlStr.append("       CRM_NS_MODIFIED_USER = '"+updateUser+"' ");
			sqlStr.append("WHERE  CRM_CLIENT_ID = '"+CRMClientDB.getClientID(userName)+"' ");
			sqlStr.append("AND    CRM_NS_LEVEL IS NOT NULL ");
		} else {
			sqlStr.append("INSERT INTO CRM_CLIENTS_NEWSTART(CRM_NS_ID, CRM_CLIENT_ID, CRM_NS_CREATED_USER, CRM_NS_MODIFIED_USER, CRM_NS_ENABLED, CRM_NS_LEVEL) ");
			sqlStr.append("VALUES ("+ getNextNSID() + ",'" + CRMClientDB.getClientID(userName) + "','" + updateUser + "','" + updateUser + "',1,'" + level + "') ");

		}

		return UtilDBWeb.updateQueue(sqlStr.toString()) ;
	}

	private boolean isClientLevelExist(String userName) {
		if (userName != null && userName.length() > 0) {
			return UtilDBWeb.isExist("SELECT CRM_CLIENT_ID FROM CRM_CLIENTS_NEWSTART WHERE CRM_CLIENT_ID = ? AND CRM_NS_LEVEL IS NOT NULL", new String[] { CRMClientDB.getClientID(userName) } );
		} else {
			return false;
		}
	}

	private static String getNextNSID() {
		String nsID = null;

		ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CRM_NS_ID) + 1 FROM CRM_CLIENTS_NEWSTART");

		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			nsID = reportableListObject.getValue(0);
			// set 1 for initial

			if (nsID == null || nsID.length() == 0) return "1";
		}

		return nsID;
	}
}