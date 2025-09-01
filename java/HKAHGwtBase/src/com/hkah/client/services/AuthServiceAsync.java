package com.hkah.client.services;

import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.shared.model.UserInfo;

/**
 * The async counterpart of <code>Auth</code>.
 */
public interface AuthServiceAsync {
	public void login(UserInfo userInfo, AsyncCallback<UserInfo> callback);
	
	public void logout(AsyncCallback<Boolean> callback);
	
	public void getPrincipalUserId(AsyncCallback<String> callback);
	
	public void getCurrentUserInfo(AsyncCallback<UserInfo> callback);
	
	public void isLoggedIn(AsyncCallback<Boolean> callback);
	
	public void checkPassword(String originalPwd, String inputPwd, AsyncCallback<Boolean> callback);
}
