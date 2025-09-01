package com.hkah.client.services;

import java.util.Map;

import com.google.gwt.user.client.rpc.AsyncCallback;

/**
 * The async counterpart of <code>QueryUtil</code>.
 */
public interface FileIOUtilServiceAsync {
	void getARCardName(String arcCard, String filePath, AsyncCallback<Map<Integer,String>> callback);
	void listFile(String filePath, String[] fileExts, boolean recursive, AsyncCallback<Map<String, String>> callback);
}
