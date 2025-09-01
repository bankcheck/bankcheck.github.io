package com.hkah.shared.util;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import com.hkah.shared.constants.ConstantsVariable;

public class UrlUtil {
	public static String buildUrl(String url, Map<String, String> paras) {
		if (url == null) {
			return null;
		}
		
		StringBuilder sb = new StringBuilder();
		if (!url.endsWith(ConstantsVariable.QUESTION_MARK_VALUE)) {
			sb.append(ConstantsVariable.QUESTION_MARK_VALUE);
		}
		Set<String> keys = paras.keySet();
		Iterator<String> itr = keys.iterator();
		String key = null;
		String value = null;
		while (itr.hasNext()) {
			key = itr.next();
			value = paras.get(key);
			if (!sb.toString().equals(ConstantsVariable.QUESTION_MARK_VALUE)) {
				sb.append(ConstantsVariable.AND_VALUE);
			}
			sb.append(key);
			sb.append(ConstantsVariable.EQUAL_VALUE);
			sb.append(value);
		}

		return url + sb.toString();
	}
	
	public static Map<String, Object> encapUrlQueryParams(String url) {
		Map<String, Object> params = new HashMap<String, Object>();
		if (url != null) {
			int beginIdx = url.indexOf(ConstantsVariable.QUESTION_MARK_VALUE) == -1 ? 0 : url.indexOf(ConstantsVariable.QUESTION_MARK_VALUE) + 1;
			String queryStr = url.substring(beginIdx);
			if (queryStr != null) {
				String[] pairs = queryStr.split(ConstantsVariable.AND_VALUE);
				if (pairs != null) {
					for (String pair : pairs) {
						String[] keyValue = pair.split(ConstantsVariable.EQUAL_VALUE);
						if (keyValue != null && keyValue.length >= 2) {
							params.put(keyValue[0], keyValue[1]);
						}
					}
				}
				
			}
		}
		return params;
	}
	
	public static String formatQueryParams(Map<String, Object> params) {
		StringBuilder sb = new StringBuilder();
		Set<String> keys = params.keySet();
		Iterator<String> itr = keys.iterator();
		while (itr.hasNext()) {
			String key = itr.next();
			Object value = params.get(key);
			if (key != null && value != null) {
				if (sb.length() > 0) {
					sb.append(ConstantsVariable.AND_VALUE);
				}
				sb.append(encodeUrlSpecialChar(key));
				sb.append(ConstantsVariable.EQUAL_VALUE);
				sb.append(encodeUrlSpecialChar(value.toString()));
			}
		}
		return sb.toString();
	}
	
	public static String encodeUrlSpecialChar(String url) {
		String ret = null;
		if (url != null) {
			ret = url.replaceAll("\\+", "%2B");
		}
		return ret;
	}
	
	public static String encodeString4UrlQuery(String url) {
		String ret = null;
		if (url != null) {
			ret = url.replaceAll(ConstantsVariable.PERCENTAGE_VALUE, "%25")
					.replaceAll("\\+", "%2B")
					.replaceAll(ConstantsVariable.MENU_DELIMITER, "%23")
					.replaceAll(ConstantsVariable.AND_VALUE, "%26");
		}
		return ret;
	}
	
	public static boolean isUNCPath(String filePath) {
		if (filePath != null && filePath.startsWith("\\\\")) {
			return true;
		}
		return false;
	}
	
	// Copy from TextUtil.java
	/**
	 * to parse string for web
	 * @param value
	 * @return
	 */
	public static String parseStr(String value) {
		if (value != null) {
			return value.trim();
		} else {
			return "";
		}
	}
	
	/**
	 * to parse string for handle non-western character
	 * @param value
	 * @return
	 */
	public static String parseStrUTF8(String value) {
		if (value != null && value.length() > 0) {
			String newValue = parseStr(value);
			try {
				newValue = new String(newValue.getBytes("ISO-8859-1"), "UTF-8");
			} catch (UnsupportedEncodingException e) {}
			return newValue;
		} else {
			return value;
		}
	}
}
