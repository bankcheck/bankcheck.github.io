/*
 * Created on October 14, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.util.cache;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import com.hkah.util.db.UtilDBWeb;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ServerSideCacheLoader {

	//======================================================================
	private final static String CALL_CACHE_PREFIX = "com.hkah.cache.";
	private final static String CALL_CACHE_SUFFIX = "Cache";
	private final static String COMBOBOX_FUNCTION_PREFIX = "NHS_CMB_";

	//======================================================================
	private HashMap<String, ServerSideCache> hashMapData = null;
	private HashMap<String, Date> hashMapTimestamp = null;

	//======================================================================
	private static ServerSideCacheLoader instance = null;

	private ServerSideCacheLoader() {
		hashMapData = new HashMap<String, ServerSideCache>();
		hashMapTimestamp = new HashMap<String, Date>();
	}

	public static ServerSideCacheLoader getInstance() {
		if (instance == null) {
			instance = new ServerSideCacheLoader();
		}
		return instance;
	}

	/**
	 * load data by transaction code
	 * @param txCode
	 * @return
	 */
	public Object getData(String txCode) {
		return getData(txCode, null);
	}

	/**
	 * load data by transaction code
	 * @param txCode
	 * @param refresh for reload data
	 * @return
	 */
	public Object getData(final String txCode, String[] inQueue) {
		Object result = null;
		ServerSideCache serverSideCache = null;
		boolean needToRefresh = false;

		if (hashMapData.containsKey(txCode)) {
			serverSideCache = hashMapData.get(txCode);
			// only check expire time if it is zero or positive integer
			if (serverSideCache.isExpired()
					|| inQueue != null											// with parameters
					|| (
							serverSideCache.getExpireTime() >= 0				// need to check expire time
							&&  Calendar.getInstance().getTime().getTime() >=	// current time
								hashMapTimestamp.get(txCode).getTime() +		// object create time
								serverSideCache.getExpireTime()					// expire time
					)
			) {
				needToRefresh = true;
			}
		}

		if (serverSideCache == null){
			try {
				// create new object
				Class klass = Class.forName(CALL_CACHE_PREFIX + txCode + CALL_CACHE_SUFFIX);
				serverSideCache = (ServerSideCache) klass.newInstance();
				needToRefresh = true;
			} catch (Exception e) {
				// if not found the class, create generic object
				serverSideCache = new ServerSideCache() {
					/**
					 * call database to re-load data
					 */
					public void loadData(String[] inQueue) {
						setData(UtilDBWeb.getFunctionResultsStr(COMBOBOX_FUNCTION_PREFIX + txCode, inQueue));
					}
				};
				needToRefresh = true;
			}
		}

		// need to refresh data and update timestamp?
		if (needToRefresh) {
			// reload data from database
			serverSideCache.loadData(inQueue);
			// set this object is not expired
			serverSideCache.setExpired(false);
			// refresh hashmap data for this object
			hashMapData.put(txCode, serverSideCache);
			// refresh timestamp for this object
			hashMapTimestamp.put(txCode, Calendar.getInstance().getTime());
		}

		// retrieve data
		if (serverSideCache != null) {
			result = serverSideCache.getData(inQueue);
		}
		return result;
	}

	public void setExpired(String txCode) {
		if (hashMapData.containsKey(txCode)) {
			ServerSideCache serverSideCache = hashMapData.get(txCode);
			serverSideCache.setExpired(true);
		}
	}

	/**
	 * preset load a set of data
	 */
	public void loadData() {
//		getData(ConstantsTx.BRANCH_CODE_TXCODE);
	}
}