/*
 * Created on October 13, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.cache;

import java.util.HashMap;

import com.hkah.util.cache.ServerSideCache;
import com.hkah.util.db.UtilDBWeb;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class SystemParameterCache extends ServerSideCache {

	private String ROOT = "ROOT";
	private HashMap<String, String> data = new HashMap<String, String>();

	/**
	 * call database to re-load data
	 */
	public void loadData(String[] inQueue) {
		if (inQueue != null) {
			String sqlStr = null;
			String []param = null;
			String key = getKey(inQueue);
			if (inQueue.length == 2 && inQueue[0].length() > 0 && inQueue[1].length() > 0) {
				sqlStr = "SELECT DISTINCT TYPE DIST_TYPE FROM MT_SYSTEM_PARAMETER WHERE CRITERIA = ? AND BRANCH_CODE = ?";
				param = new String[] { inQueue[0], inQueue[1] };
			} else if (inQueue.length == 1 && inQueue[0].length() > 0) {
				sqlStr = "SELECT DISTINCT BRANCH_CODE DIST_BRANCH_CODE FROM MT_SYSTEM_PARAMETER WHERE CRITERIA = ?";
				param = new String[] { inQueue[0] };
			} else {
				sqlStr = "SELECT DISTINCT CRITERIA DIST_CRITERIA FROM MT_SYSTEM_PARAMETER";
				param = new String[] { };
			}
			data.put(key, UtilDBWeb.getQueueResultsHATS(sqlStr, param));
		}
	}

	/**
	 * return stored data object
	 * @return object
	 */
	public Object getData(String[] inQueue) {
		String result = null;
		if (inQueue != null && inQueue.length > 0) {
			// call loadData when first time calling
			String key = getKey(inQueue);

			if (!data.containsKey(key)) {
				loadData(inQueue);
			}

			// retrieve data from hash map
			result = data.get(key);
		}
		return result;
	}

	private String getKey(String[] inQueue) {
		String key = ROOT;
		if (inQueue.length == 2 && inQueue[0].length() > 0 && inQueue[1].length() > 0) {
			key = inQueue[0] + "-" + inQueue[1];
		} else if (inQueue.length == 1 && inQueue[0].length() > 0) {
			key = inQueue[0];
		}
		return key;
	}
}