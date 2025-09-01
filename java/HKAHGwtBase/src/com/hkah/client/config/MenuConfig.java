/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.config;

import java.util.HashMap;

import com.hkah.client.layout.panel.DefaultPanel;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class MenuConfig {

	private static HashMap<String, String> resource = new HashMap<String, String>();
	private static HashMap<String, DefaultPanel> resourceClass = new HashMap<String, DefaultPanel>();
	public static final String NO_SUB_MENU_NAME = "";

	static {
		putMenu("menu.no", "1");
		putMenu("menu.1.name", "test");
		putMenu("menu.1.dest", "#");
		putMenu("menu.1.mnemonic", "F");
	}

	private static void putMenu(String key, String value) {
		resource.put(key, value);
	}

	private static void putPanel(String key, DefaultPanel panel) {
		resourceClass.put(key, panel);
	}

	public static String get(String key) {
		String result = null;
		try {
			result = resource.get(key);
		} catch (Exception ex) {
		}
		return result;
	}

	public static DefaultPanel getPanel(String key) {
		DefaultPanel  dp=resourceClass.get(key);
		return dp;
	}
}