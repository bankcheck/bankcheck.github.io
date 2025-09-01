package com.hkah.server.config;

import java.util.Locale;
import java.util.ResourceBundle;

public class MessageResources {
	
	private static final String RESOURCE_FILE = "MessageResources";

	public static String getMessageEnglish(String key) {
		return getMessage(Locale.ENGLISH, key);
	}

	public static String getMessageTraditionalChinese(String key) {
		return getMessage(Locale.TRADITIONAL_CHINESE, key);
	}

	public static String getMessageSimplifiedChinese(String key) {
		return getMessage(Locale.SIMPLIFIED_CHINESE, key);
	}

	public static String getMessage(Locale locale, String key) {
		String result = null;
		try {
			result = ResourceBundle.getBundle(RESOURCE_FILE, locale).getString(key);
		} catch (Exception e) {
			result = key;
		}
		return result;
	}
}
