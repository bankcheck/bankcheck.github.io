package com.hkah.client.services;

import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.shared.model.ClientConfigObject;
import com.hkah.shared.model.UserInfo;

/**
 * The async counterpart of <code>CommonUtil</code>.
 */
public interface CommonUtilServiceAsync {
	public void getComputerName(AsyncCallback<String> callback);

	public void getComputerIP(AsyncCallback<String> callback);

	public void getUserInfo(AsyncCallback<UserInfo> callback);

	public void getUserID(AsyncCallback<String> callback);

	public void getPortalHost(AsyncCallback<String> callback);

	public void getClientConfigObject(AsyncCallback<ClientConfigObject> callback);
	
	public void getServerOS(AsyncCallback<String> callback);
	
}