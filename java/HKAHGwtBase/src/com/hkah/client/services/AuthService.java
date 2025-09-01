package com.hkah.client.services;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;
import com.hkah.shared.model.UserInfo;

@RemoteServiceRelativePath("authservice")
public interface AuthService extends RemoteService {
	public UserInfo login(UserInfo userInfo);
	
	public Boolean logout();
	
	public String getPrincipalUserId();
	
	public UserInfo getCurrentUserInfo();
	
	public Boolean isLoggedIn();

	public Boolean checkPassword(String originalPwd, String inputPwd);
}
