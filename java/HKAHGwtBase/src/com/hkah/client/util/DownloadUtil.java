package com.hkah.client.util;

import com.google.gwt.http.client.URL;
import com.google.gwt.user.client.Window;

public class DownloadUtil {
	public static void download(String path) {
		download(false, path);
	}
	
	public static void download(String path, String wndName, String wndFeatures) {
		download(false, path, wndName, wndFeatures);
	}
	
	public static void download(boolean isAbsolutePath, String path) {
		download(isAbsolutePath, path, null, null);
	}
	
	public static void download(boolean isAbsolutePath, String path,
			String wndName, String wndFeatures) {
		if (isAbsolutePath) {
			Window.open("../download?directPath=" + URL.encode(path), wndName, wndFeatures);
		}
		else {
			Window.open("../download?path=" + path, wndName, wndFeatures);
		}
	}
}
