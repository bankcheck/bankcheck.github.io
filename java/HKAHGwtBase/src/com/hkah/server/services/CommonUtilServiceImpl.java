package com.hkah.server.services;

import java.net.InetAddress;
import java.net.UnknownHostException;

import com.google.gwt.user.server.rpc.RemoteServiceServlet;
import com.hkah.client.services.CommonUtilService;
import com.hkah.server.config.ClientConfig;
import com.hkah.shared.model.ClientConfigObject;
import com.hkah.shared.model.UserInfo;

@SuppressWarnings("serial")
public class CommonUtilServiceImpl extends RemoteServiceServlet implements CommonUtilService {

	public static final String HKAH_DOMAIN = ".AHHK.LOCAL";
	public static final String TWAH_DOMAIN = "TWAHDM5.LOCAL";
	
	@Override
	public String getComputerName() {
		String name = getThreadLocalRequest().getRemoteHost();
		try {
			name = InetAddress.getByName(name).getCanonicalHostName();
			int index = name.toUpperCase().indexOf(HKAH_DOMAIN);
			
			if (index > 0) {
				// remove domain suffix
				name = name.substring(0, index);
			}
			
			index = name.toUpperCase().indexOf(TWAH_DOMAIN);
			
			if (index > 0) {
				// remove domain suffix
				name = name.substring(0, index);
			}
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		return name;
	}

	@Override
	public String getComputerIP() {
		return getThreadLocalRequest().getRemoteAddr();
	}

	@Override
	public String getPortalHost() {
		return ClientConfig.getObject().getPortalHost() + ":" + ClientConfig.getObject().getPortalPort();
	}
	
	@Override
	public String getServerOS(){
		return  System.getProperty("os.name").toLowerCase();
	}

	@Override
	public UserInfo getUserInfo() {
		UserInfo userInfo = new UserInfo();
		userInfo.setSiteCode(ClientConfig.getObject().getSiteCode());
		userInfo.setSiteName(ClientConfig.getObject().getSiteName());
		userInfo.setUserID(ClientConfig.getObject().getDefaultUserID());
		userInfo.setUserName(ClientConfig.getObject().getDefaultUserName());
		userInfo.setDeptCode(ClientConfig.getObject().getDefaultUserDeptCode());

		return userInfo;
	}

	@Override
	public String getUserID() {
		return ClientConfig.getObject().getDefaultUserID();
	}

	@Override
	public ClientConfigObject getClientConfigObject() {
		return ClientConfig.getObject();
	}
}