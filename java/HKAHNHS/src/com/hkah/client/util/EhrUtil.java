package com.hkah.client.util;

import com.extjs.gxt.ui.client.Registry;
import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.rpc.ServiceDefTarget;
import com.hkah.client.AbstractEntryPoint;
import com.hkah.client.services.EhrServiceAsync;

public class EhrUtil {
	private static EhrServiceAsync async = null;

	private static EhrServiceAsync getEhrServiceAsync() {
		if (async == null) {
			async = Registry.get(AbstractEntryPoint.EHR_SERVICE);
			ServiceDefTarget endpoint = (ServiceDefTarget) async;
			endpoint.setServiceEntryPoint(GWT.getModuleBaseURL() + "ehrService");
		}
		return async;
	}
	
	public static void isValidHkid(String hkid, AsyncCallback<String> callback) {
		getEhrServiceAsync().isValidHkid(hkid, callback);
	}
	
	public static String getValidHkidFormat(String hkid) {
		String ret = hkid;
		if (hkid != null) {
			// leading space before alphabet for single alphabet HKID e.g. A123456(3)
			String pattern = "^[a-zA-Z][0-9](.+)";
			if (hkid.matches(pattern)) {
				ret = " " + hkid;
			}
		}
		return ret;
	}
}
