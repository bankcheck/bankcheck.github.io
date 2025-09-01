package com.hkah.server.services;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.google.gwt.user.server.rpc.RemoteServiceServlet;
import com.hkah.client.services.AuthService;
import com.hkah.client.util.PasswordUtil;
import com.hkah.shared.model.UserInfo;

@SuppressWarnings("serial")
public class AuthServiceImpl extends RemoteServiceServlet 
		implements AuthService {
	protected static Logger logger = Logger.getLogger(AuthServiceImpl.class);
	
	@Override
	public UserInfo login(UserInfo userInfo) {
		// TODO Auto-generated method stub
		boolean success = false;
		if (userInfo != null) {
			try {
				// TODO Authentication
				HttpSession session = this.getThreadLocalRequest().getSession();
				session.setAttribute("userInfo", userInfo);
				success = true;
			} catch (Exception e) {
			}
		}
		if (success) {
			logger.info("Login success (user: " + userInfo.getUserID() + ")");
			return userInfo;
		} else {
			logger.info("Login fail (user: " + userInfo.getUserID() + ")");
			return null;
		}
	}

	@Override
	public Boolean logout() {
		// TODO Auto-generated method stub
		boolean success = false;
		UserInfo userInfo = null;
		try {
			HttpSession session = this.getThreadLocalRequest().getSession();
			userInfo = (UserInfo) session.getAttribute("userInfo");
			session.setAttribute("userInfo", null);
			session.invalidate();
			success = true;
		} catch (Exception e) {
			success = false;
			logger.error("Logout user:" + userInfo.getUserID() + " failed ");
		}
		
		return success;
	}

	@Override
	public String getPrincipalUserId() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Boolean isLoggedIn() {
		// TODO Auto-generated method stub
		HttpSession session = this.getThreadLocalRequest().getSession();
		UserInfo userInfo = (UserInfo) session.getAttribute("userInfo");
		if (userInfo != null)
			return true;
		else 
			return false;
	}

	@Override
	public UserInfo getCurrentUserInfo() {
		// TODO Auto-generated method stub
		UserInfo userInfo = null;
		try {
			HttpSession session = this.getThreadLocalRequest().getSession();
			userInfo = (UserInfo) session.getAttribute("userInfo");
		} catch (Exception ex) {
			logger.error("Cannot get session userInfo");
		}
		return userInfo;
	}
	
	@Override
	public Boolean checkPassword(String originalPwd, String inputPwd) {
		if (PasswordUtil.cisDecryption(originalPwd).toLowerCase().equals(inputPwd.toLowerCase())) {
			return true;
		}
		return false;
	}
}
