/*
 * Created on July 10, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.config;

import java.util.Locale;
import java.util.ResourceBundle;

import javax.servlet.http.HttpSession;

import org.apache.struts.Globals;

import com.hkah.util.TextUtil;

public class MessageResources {

	private static final String ARG0_TAG = "{0}";
	private static final String RESOURCE_FILE = "MessageResources";
//	private static final Locale HONGKONG_LOCALE = new Locale("Zh", "HK", "");
//	private static final Locale JAPANESE_LOCALE = new Locale("jp", "JP", "");

	public static String getMessage(HttpSession session, String key) {
		return getMessage(session, key, null);
	}

	public static String getMessage(HttpSession session, String key, String arg0) {
		String result = null;
		try {
			Locale locale = (Locale) session.getAttribute(Globals.LOCALE_KEY);
			// set default locale as english
			if (locale == null) {
//				locale = Locale.getDefault();
//				if (HONGKONG_LOCALE.equals(locale)) {
//					locale = Locale.TRADITIONAL_CHINESE;
//				} else if (!Locale.TRADITIONAL_CHINESE.equals(locale)
//						&& !Locale.SIMPLIFIED_CHINESE.equals(locale)
//						&& !JAPANESE_LOCALE.equals(locale)) {
					locale = Locale.ENGLISH;
//				}
				session.setAttribute(Globals.LOCALE_KEY, locale);
			}
			result = getMessage(locale, key, arg0);
		} catch (Exception e) {
			result = key;
		}
		return result;
	}

	
	public static String getMessageEnglish(String key) {
		return getMessageEnglish(key, null);
	}
	
	public static String getMessageEnglish(String key, String arg0) {
		return getMessage(Locale.ENGLISH, key, arg0);
	}

	public static String getMessageTraditionalChinese(String key) {
		return getMessageTraditionalChinese(key, null);
	}
	
	public static String getMessageTraditionalChinese(String key, String arg0) {
		return getMessage(Locale.TRADITIONAL_CHINESE, key, arg0);
	}

	public static String getMessageSimplifiedChinese(String key) {
		return getMessageSimplifiedChinese(key, null);
	}
	
	public static String getMessageSimplifiedChinese(String key, String arg0) {
		return getMessage(Locale.SIMPLIFIED_CHINESE, key, arg0);
	}

	public static String getMessageJapanese(String key) {
		return getMessageJapanese(key, null);
	}
	
	public static String getMessageJapanese(String key, String arg0) {
		return getMessage(Locale.JAPAN, key, arg0);
	}

	public static String getMessage(Locale locale, String key) {
		return getMessage(locale, key, null);
	}

	public static String getMessage(Locale locale, String key, String arg0) {
		String result = null;
		try {
			result = ResourceBundle.getBundle(RESOURCE_FILE, locale).getString(key);

			if (arg0 != null) {
				result = TextUtil.replaceAll(result, ARG0_TAG, arg0);
			}
		} catch (Exception e) {
			result = key;
		}
		return result;
	}
}