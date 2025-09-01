package com.hkah.client.services;

import com.google.gwt.user.client.rpc.AsyncCallback;

public interface EhrServiceAsync {
	void isValidHkid(String hkid, AsyncCallback<String> callback);
}
