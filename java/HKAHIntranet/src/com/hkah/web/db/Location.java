/*
 * Created on April 21, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Location {

	public static ArrayList getList() {
		// fetch location
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_LOCATION_ID, CO_LOCATION_DESC ");
		sqlStr.append("FROM   CO_LOCATION ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("ORDER BY CO_LOCATION_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
}