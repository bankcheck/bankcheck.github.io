/*
 * Created on April 8, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class EventTypeDB {
	private static String sqlStr_insertEventType = null;
	private static String sqlStr_updateEventType = null;
	private static String sqlStr_deleteEventType = null;

	/**
	 * Add an event type
	 * @return parentEventType
	 */

	public static boolean add(UserBean userBean,
			String level, String parentEventType, String eventType, String eventDesc) {

		// try to insert a new record
		return UtilDBWeb.updateQueue(
				sqlStr_insertEventType,
				new String[] { level, parentEventType, eventType, eventDesc,
						userBean.getLoginID(), userBean.getLoginID() });
	}

	/**
	 * Modify an event type
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String level, String parentEventType, String eventType, String eventDesc) {

		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_updateEventType,
				new String[] { eventDesc,
						userBean.getLoginID(), level, parentEventType, eventType } );
	}

	public static boolean delete(UserBean userBean,
			String level, String parentEventType, String eventType) {

		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteEventType,
				new String[] { userBean.getLoginID(), level, parentEventType, eventType } );
	}

	public static ArrayList get(
			String level, String parentEventType, String eventType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_EVENT_DESC ");
		sqlStr.append("FROM   CO_EVENT_TYPES ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_LEVEL = ? ");
		sqlStr.append("AND    CO_PARENT_EVENT_TYPE = ? ");
		sqlStr.append("AND    CO_EVENT_TYPE = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { level, parentEventType, eventType });
	}

	public static ArrayList getList(
			String level, String parentEventType) {
		// fetch event
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_LEVEL, CO_PARENT_EVENT_TYPE, CO_EVENT_TYPE, CO_EVENT_DESC, TO_CHAR(CO_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CO_EVENT_TYPES ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		if (level != null && level.length() > 0) {
			sqlStr.append("AND    CO_LEVEL = '");
			sqlStr.append(level);
			sqlStr.append("' ");
		}
		if (parentEventType != null && parentEventType.length() > 0) {
			sqlStr.append("AND    CO_PARENT_EVENT_TYPE = '");
			sqlStr.append(parentEventType);
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY CO_LEVEL, CO_PARENT_EVENT_TYPE, CO_EVENT_TYPE");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_EVENT (");
		sqlStr.append("CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID, CO_EVENT_DESC, CO_EVENT_REMARK, CO_DEPARTMENT_CODE, ");
		sqlStr.append("CO_EVENT_CATEGORY, CO_EVENT_TYPE, CO_EVENT_TYPE2, CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
		sqlStr_insertEventType = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_EVENT ");
		sqlStr.append("SET    CO_EVENT_DESC = ?, CO_EVENT_REMARK = ?, CO_DEPARTMENT_CODE = ?, ");
		sqlStr.append("       CO_EVENT_CATEGORY = ?, CO_EVENT_TYPE = ?, CO_EVENT_TYPE2 = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr_updateEventType = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PHYSICAL_FIGURE_GROUP ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_FIGURE_GROUP_ID = ?");
		sqlStr_deleteEventType = sqlStr.toString();
	}
}