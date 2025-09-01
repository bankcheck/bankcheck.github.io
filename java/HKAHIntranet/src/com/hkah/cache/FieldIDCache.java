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
public class FieldIDCache extends ServerSideCache {

	private HashMap<String, String> data = new HashMap<String, String>();

	/**
	 * call database to re-load data
	 */
	public void loadData(String[] inQueue) {
		if (inQueue != null) {
			data.put(inQueue[0], UtilDBWeb.getQueueResultsHATS("SELECT DISTINCT FIELD_ID, FIELD_DESC FROM MT_FIELD WHERE FUNCTION_ID = ? ORDER BY FIELD_ID", new String[] { inQueue[0] }));
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
			if (!data.containsKey(inQueue[0])) {
				loadData(inQueue);
			}

			// retrieve data from hash map
			return data.get(inQueue[0]);
		}
		return result;
	}
}