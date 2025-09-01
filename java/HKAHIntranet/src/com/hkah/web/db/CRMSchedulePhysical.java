/*
 * Created on April 29, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CRMSchedulePhysical {

	private static String sqlStr_insert = null;
	private static String sqlStr_update = null;
	private static String sqlStr_delete = null;
	private static String sqlStr_isExist = null;

	/**
	 * update schedule physical
	 * @return boolean
	 */
	public static boolean update(UserBean userBean,
			String eventID,
			String scheduleID,
			String[] figureID) {
		return update(eventID, scheduleID, figureID, userBean.getLoginID());
	}
	
	/**
	 * update schedule physical
	 * @return boolean
	 */
	public static boolean update(
			String eventID,
			String scheduleID,
			String[] figureID,
			String updateUser) {
		delete(eventID, scheduleID, updateUser);

		boolean success = false;
		for (int i = 0; i < figureID.length; i++) {
			if (UtilDBWeb.isExist(sqlStr_isExist, new String[] { eventID, scheduleID, figureID[i] })) {
				if (UtilDBWeb.updateQueue(
						sqlStr_update,
						new String[] { updateUser, eventID, scheduleID, figureID[i] } )) {
					success = true;
				}
			} else if (UtilDBWeb.updateQueue(
					sqlStr_insert,
					new String[] { eventID, scheduleID, figureID[i], updateUser, updateUser } )) {
				success = true;
			}
		}
		return success;
	}

	/**
	 * delete schedule physical
	 * @return boolean
	 */
	public static boolean delete(UserBean userBean,
			String eventID,
			String scheduleID) {
		return delete(eventID, scheduleID, userBean.getLoginID());
	}

	/**
	 * delete schedule physical
	 * @return boolean
	 */
	public static boolean delete(
		String eventID,
		String scheduleID,
		String deleteUser) {
		// update flag to false
		return UtilDBWeb.updateQueue(
				sqlStr_delete,
				new String[] { deleteUser, eventID, scheduleID } );
	}

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO CRM_SCHEDULE_PHYSICAL ");
		sqlStr.append("(CRM_SITE_CODE, CRM_MODULE_CODE, CRM_EVENT_ID, CRM_SCHEDULE_ID, CRM_FIGURE_ID, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("('" + ConstantsServerSide.SITE_CODE + "', 'crm', ?, ?, ?, ?, ?)");
		sqlStr_insert = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_SCHEDULE_PHYSICAL ");
		sqlStr.append("SET    CRM_ENABLED = 1, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = 'crm' ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CRM_FIGURE_ID = ? ");
		sqlStr.append("AND    CRM_ENABLED = 0 ");
		sqlStr_update = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_SCHEDULE_PHYSICAL ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = 'crm' ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CRM_ENABLED = 1 ");
		sqlStr_delete = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CRM_SCHEDULE_PHYSICAL ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = 'crm' ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CRM_FIGURE_ID = ? ");
		sqlStr_isExist = sqlStr.toString();
	}
}