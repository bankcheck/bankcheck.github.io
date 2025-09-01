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
public class CheckPermissionCache extends ServerSideCache {

	private HashMap<String, String> data = new HashMap<String, String>();

	/**
	 * set expire time for each object (in ms)
	 * @return integer
	 */
	public int getExpireTime() {
		return 60000;	// reload after one minute
	}

	/**
	 * call database to re-load data
	 */
	public void loadData(String[] inQueue) {
		if (inQueue != null) {
			String sqlStr = null;
			String []param = null;
			String key = getKey(inQueue);
			sqlStr = "SELECT BRANCH_CODE, FUNCTION_ID, FIELD_ID, USER_GROUP_ID, USER_ID, ACCESS_MODE FROM MT_ACCESS_CONTROL WHERE (BRANCH_CODE = 'ALL' OR BRANCH_CODE = ?) AND (FUNCTION_ID = 'ALL' OR FUNCTION_ID = ?)";
			param = new String[] { inQueue[0], inQueue[1] };
			data.put(key, UtilDBWeb.getQueueResultsHATS(sqlStr, param));
		}
	}

	/**
	 * return stored data object
	 * @return object
	 */
	public Object getData(String[] inQueue) {
		String result = null;
		if (inQueue != null && inQueue.length > 1) {
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
		return inQueue[0] + "-" + inQueue[1];
	}
}