package com.hkah.client.util;

import java.util.HashMap;
import java.util.Map;

import com.google.gwt.core.client.JavaScriptObject;

public class JsonUtil {
	/*
	 * Takes in a trusted JSON String and evals it.
	 * @param JSON String that you trust
	 * @return JavaScriptObject that you can cast to an Overlay Type
	 */
	public static native JavaScriptObject parseJson(String jsonStr) /*-{
		eval('var res = ' + jsonStr);
		return res;
	}-*/;
	
	public static Map<String, String> jsonStr2Map(String jsonStr) {
		Map<String, String> ret = new HashMap<String, String>();
		if (jsonStr == null) {
			return ret;
		}
		if (jsonStr.startsWith("{")) {
			jsonStr = jsonStr.substring(1);
		}
		if (jsonStr.endsWith("}")) {
			jsonStr = jsonStr.substring(0, jsonStr.length() - 1);
		}
		String[] rows = jsonStr.split("\",\"");
		for (int i = 0; i < rows.length; i++) {
			String row = rows[i];
			String[] pairs = row.split("\":\"");
			if (pairs.length >= 2) {
				String key = pairs[0];
				if (key.startsWith("\"")) {
					key = key.substring(1);
				}
				String value = pairs[1];
				if (value.endsWith("\"")) {
					value = value.substring(0, value.length() - 1);
				}
				if (key.startsWith("ta_")) {
					value = value.replace("\\n", "<br />");
				}
				
				ret.put(key, value);
			}
		}
		return ret;
	}
}
