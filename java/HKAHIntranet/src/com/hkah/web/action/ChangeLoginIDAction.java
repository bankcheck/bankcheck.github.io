/*
 * Created on January 31, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.UserDB;


/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ChangeLoginIDAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ActionMessages messages = new ActionMessages();
		UserBean userBean = new UserBean(request);				
		String newLoginID = (String) PropertyUtils.getSimpleProperty(form, "newLoginID");
		String password = (String) PropertyUtils.getSimpleProperty(form, "password");
		String confirmPassword = (String) PropertyUtils.getSimpleProperty(form, "confirmPassword");
		
		boolean loginIDChanged = false;
		try {		
			if(!"admin".equals(userBean.getLoginID()) && !userBean.isAdmin()){
				if(newLoginID!= null && newLoginID.length()>0){
					if(!newLoginID.startsWith("LMC")){						
						if (password.equals(confirmPassword)) {
							if (!UtilDBWeb.isExist("SELECT 1 FROM CO_USERS WHERE UPPER(CO_USERNAME) = UPPER(?) OR UPPER(CO_STAFF_ID) = UPPER(?)", new String[] { newLoginID , newLoginID})
								&&	!UtilDBWeb.isExist("SELECT 1 FROM CRM_CLIENTS  WHERE UPPER(CRM_USERNAME) = UPPER(?) ", new String[] { newLoginID })
								&&  UtilDBWeb.isExist("SELECT 1 FROM CO_USERS WHERE CO_USERNAME = ?  AND CO_STAFF_ID IS NULL",new String[] { userBean.getLoginID()})) {							
								if (UserDB.updatePassword(userBean, password)&&
										UtilDBWeb.updateQueue(
										"UPDATE CO_USERS " +
										"SET    CO_USERNAME = ?, " +
										"       CO_MODIFIED_DATE = SYSDATE, " +
										"       CO_MODIFIED_USER = 'GUEST' " +
										"WHERE  CO_USERNAME = '" + userBean.getLoginID() + "' ",
										new String[] { newLoginID } )&&
									UtilDBWeb.updateQueue(
										"UPDATE CRM_CLIENTS " +
										"SET    CRM_USERNAME = ?, " +
										"       CRM_MODIFIED_DATE = SYSDATE, " +
										"       CRM_MODIFIED_USER = 'GUEST' " +
										"WHERE  CRM_USERNAME = '" + userBean.getLoginID() + "' ",
											new String[] { newLoginID } )) {
									
										loginIDChanged=true;
										if(loginIDChanged){
											UtilDBWeb.updateQueue(
													"UPDATE CRM_CLIENTS " +
													"SET    CRM_CHANGED_IDPW = 1, " +
													"       CRM_MODIFIED_DATE = SYSDATE, " +
													"       CRM_MODIFIED_USER = 'GUEST' " +
													"WHERE  CRM_USERNAME = '" + newLoginID + "' ");								
											
											messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.loginIDPW.changed"));		
			
											 HttpSession session = request.getSession();								  
											  session.setAttribute("loginUserName", newLoginID);
											  session.setAttribute("loginID", newLoginID);	
											  request.setAttribute("loginIDChanged", "true");										  
										}
									} else {
										messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.loginID.error"));
									}					
								
							} else {			
								messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.loginID.exist"));
							}
						}else{
							messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.confirmPassword.invalid"));
						}
					}else{
						messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.loginID.startWithLMC"));
					}
				}else{
					messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.loginID.empty"));
				}
			}else{
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.loginID.isAdmin"));
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
		if(loginIDChanged){
			return mapping.findForward("success");
		}else{
			return mapping.findForward("fail");
		}
	}
}