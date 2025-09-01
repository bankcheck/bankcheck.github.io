/*
 * Created on October 13, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.cache;

import com.hkah.util.cache.ServerSideCache;
import com.hkah.util.db.UtilDBWeb;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class UserGroupIDCache extends ServerSideCache {

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
		setData(UtilDBWeb.getQueueResultsHATS("SELECT DISTINCT USER_GROUP_ID, USER_GROUP_DESC, USER_GROUP_LEVEL FROM MT_USER_GROUP ORDER BY USER_GROUP_ID"));
	}
}