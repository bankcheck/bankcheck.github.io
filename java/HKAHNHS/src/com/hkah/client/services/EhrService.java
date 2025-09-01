package com.hkah.client.services;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;

@RemoteServiceRelativePath("ehrService")
public interface EhrService extends RemoteService {
	String isValidHkid(String hkid);
}
