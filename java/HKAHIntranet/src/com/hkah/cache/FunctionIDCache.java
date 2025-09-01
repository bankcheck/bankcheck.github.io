/*
 * Created on October 15, 2008
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
public class FunctionIDCache extends ServerSideCache {

	/**
	 * call database to re-load data
	 */
	public void loadData(String[] inQueue) {
		setData(UtilDBWeb.getQueueResultsHATS("SELECT FUNCTION_ID, FUNCTION_DESC, CLASS_PACKAGE FROM MT_FUNCTION ORDER BY FUNCTION_ID"));
	}
}