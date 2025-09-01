/*
 * Created on January 31, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.action;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.constant.ConstantsWebVariable;
import com.hkah.web.db.SsoUserDB;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public final class LogoffAction extends Action {
	public ActionForward execute(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws Exception {
	
		// clean up session
		HttpSession session = request.getSession();
		
		String mode = request.getParameter("mode");
		String rdURL = request.getParameter("rdURL");
		
		//delete sso session
		SsoUserDB.deleteSessionID(session.getId());
		
		session.invalidate();

		// clean up cookie from request
		Cookie cookies [] = request.getCookies();
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				if (ConstantsWebVariable.KEY_SESSION_LOGIN_STAFF_ID.equals(cookies[i].getName())) {
					cookies[i].setValue(ConstantsVariable.EMPTY_VALUE);
					break;
				}
			}
		}

		// clean up cookie from response
		Cookie cookie = new Cookie(ConstantsWebVariable.KEY_SESSION_LOGIN_STAFF_ID, ConstantsVariable.EMPTY_VALUE);
		response.addCookie(cookie);

		// Forward control to the specified success URI
		String ret = null;
		if (ConstantsServerSide.CAS_SINGLESIGNON) {
			ret = "successSingleSignOut";
		} else {
			ret = "success";
		}
		
		if (mode != null && mode.equals("redirect")) {
			ActionForward successAction = mapping.findForward(ret);
			ActionForward modifiedSuccessAction = new ActionForward();
			modifiedSuccessAction.setName(successAction.getName());
			modifiedSuccessAction.setPath(rdURL);
			modifiedSuccessAction.setRedirect(true);
			return modifiedSuccessAction;
		}
		return (mapping.findForward(ret));
	}
}