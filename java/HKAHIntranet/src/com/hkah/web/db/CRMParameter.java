/*
 * Created on April 22, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.util.db.UtilDBWeb;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CRMParameter {

	public static ArrayList getList(String parameterType) {
		return getList(parameterType, null);
	}

	public static ArrayList getList(String parameterType, String parameterParentID) {
		// fetch PARAMETER
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_PARAMETER_ID, CRM_PARAMETER_DESC, CRM_PARAMETER_LABEL ");
		sqlStr.append("FROM   CRM_PARAMETER ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		if (parameterType != null && parameterType.length() > 0) {
			sqlStr.append("AND    CRM_PARAMETER_TYPE = '");
			sqlStr.append(parameterType);
			sqlStr.append("' ");
		}
		if (parameterParentID != null && parameterParentID.length() > 0) {
			sqlStr.append("AND    CRM_PARAMETER_PARENT_ID = '");
			sqlStr.append(parameterParentID);
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY CRM_PARAMETER_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
}