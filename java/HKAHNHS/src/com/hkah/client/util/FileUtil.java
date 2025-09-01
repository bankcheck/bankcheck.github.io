package com.hkah.client.util;

import java.util.Map;

import com.extjs.gxt.ui.client.Registry;
import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.rpc.ServiceDefTarget;
import com.hkah.client.AbstractEntryPoint;
import com.hkah.client.services.FileIOUtilServiceAsync;

public class FileUtil {
	private static FileIOUtilServiceAsync async = null;

	private static FileIOUtilServiceAsync getFileIOUtilServiceAsync() {
		if (async == null) {
			async = Registry.get(AbstractEntryPoint.FILE_SERVICE);
			ServiceDefTarget endpoint = (ServiceDefTarget) async;
			endpoint.setServiceEntryPoint(GWT.getModuleBaseURL() + "fileioutilservice");
		}
		return async;
	}

	public static void getARCardName(String arcCard, String filePath, AsyncCallback<Map<Integer,String>> callback) {
		getFileIOUtilServiceAsync().getARCardName(arcCard, filePath, callback);
	}
	
	public static void listFile(String filePath, String[] fileExts, boolean recursive, AsyncCallback<Map<String, String>> callback) {
		getFileIOUtilServiceAsync().listFile(filePath, fileExts, recursive, callback);
	}
}