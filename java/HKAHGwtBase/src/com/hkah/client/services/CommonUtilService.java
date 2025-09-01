/*
 * Created on September 28, 2011
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.services;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;
import com.hkah.shared.model.ClientConfigObject;
import com.hkah.shared.model.UserInfo;

/**
 * The client side stub for the RPC service.
 */
@RemoteServiceRelativePath("common-service")
public interface CommonUtilService extends RemoteService{
	public String getComputerName();

	public String getComputerIP();

	public UserInfo getUserInfo();

	public String getUserID();

	public String getPortalHost();

	public ClientConfigObject getClientConfigObject();
	
	public String getServerOS();

}