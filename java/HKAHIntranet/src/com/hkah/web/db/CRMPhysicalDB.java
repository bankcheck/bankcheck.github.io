/*
 * Created on April 29, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CRMPhysicalDB {
	private static String sqlStr_insertGroup = null;
	private static String sqlStr_updateGroup = null;
	private static String sqlStr_deleteGroup = null;

	private static String sqlStr_insertFigure = null;
	private static String sqlStr_updateFigure = null;
	private static String sqlStr_deleteFigure = null;

	private static String sqlStr_insertSet = null;

	private static String getNextPhysicalID() {
		String physicalID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CRM_FIGURE_GROUP_ID) + 1 FROM CRM_PHYSICAL_FIGURE_GROUP");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			physicalID = reportableListObject.getValue(0);

			// set 1 for initial
			if (physicalID == null || physicalID.length() == 0) return "1";
		}
		return physicalID;
	}

	private static String getNextFigureID() {
		String figureID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CRM_FIGURE_ID) + 1 FROM CRM_PHYSICAL_FIGURE");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			figureID = reportableListObject.getValue(0);

			// set 1 for initial
			if (figureID == null || figureID.length() == 0) return "1";
		}
		return figureID;
	}

	/**
	 * Add a group
	 */
	public static String addGroup(UserBean userBean,
			String groupDesc) {

		// get next physical ID
		String physicalID = getNextPhysicalID();

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertGroup,
				new String[] {
						physicalID, groupDesc, userBean.getLoginID(), userBean.getLoginID() })) {
			return physicalID;
		} else {
			return null;
		}
	}

	/**
	 * Modify a group
	 * @return whether it is successful to update the record
	 */
	public static boolean updateGroup(UserBean userBean,
			String physicalID, String groupDesc) {

		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_updateGroup,
				new String[] {
						groupDesc, userBean.getLoginID(), physicalID});
	}

	public static boolean deleteGroup(UserBean userBean,
			String physicalID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteGroup,
				new String[] { userBean.getLoginID(), physicalID } );
	}

	public static ArrayList getGroup(String physicalID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_FIGURE_GROUP_DESC ");
		sqlStr.append("FROM   CRM_PHYSICAL_FIGURE_GROUP ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_FIGURE_GROUP_ID = ?");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { physicalID });
	}

	public static ArrayList getGroupList(String groupDesc) {
		// fetch client
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_FIGURE_GROUP_ID, CRM_FIGURE_GROUP_DESC, ");
		sqlStr.append("       TO_CHAR(CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_PHYSICAL_FIGURE_GROUP  ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		if (groupDesc != null && groupDesc.length() > 0) {
			sqlStr.append("AND    CRM_FIGURE_GROUP_DESC LIKE '%");
			sqlStr.append(groupDesc);
			sqlStr.append("%' ");
		}
		sqlStr.append("ORDER BY CRM_FIGURE_GROUP_ID, CRM_FIGURE_GROUP_DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	/**
	 * Add a figure
	 */
	public static String addFigure(UserBean userBean,
			String physicalID, String figureDesc, String measure, String type) {

		// get next physical ID
		String figureID = getNextFigureID();

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertFigure,
				new String[] {
						figureID, figureDesc, measure, type, userBean.getLoginID(), userBean.getLoginID() })) {
			addSet(userBean, physicalID, figureID);
			return physicalID;
		} else {
			return null;
		}
	}

	/**
	 * Modify a figure
	 * @return whether it is successful to update the record
	 */
	public static boolean updateFigure(UserBean userBean,
			String physicalID, String figureID, String figureDesc, String measure, String type) {

		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_updateFigure,
				new String[] {
						figureDesc, measure, type, userBean.getLoginID(), figureID});
	}

	public static boolean deleteFigure(UserBean userBean,
			String physicalID, String figureID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteFigure,
				new String[] { userBean.getLoginID(), figureID } );
	}

	public static ArrayList getFigure(String figureID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_FIGURE_DESC, CRM_FIGURE_MEASURE, CRM_FIGURE_TYPE ");
		sqlStr.append("FROM   CRM_PHYSICAL_FIGURE ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_FIGURE_ID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { figureID });
	}

	public static ArrayList getFigureList(String groupID) {
		// fetch client
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT F.CRM_FIGURE_ID, F.CRM_FIGURE_DESC, F.CRM_FIGURE_MEASURE, F.CRM_FIGURE_TYPE, ");
		sqlStr.append("       TO_CHAR(F.CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_PHYSICAL_FIGURE F, CRM_PHYSICAL_FIGURE_SET S  ");
		sqlStr.append("WHERE  F.CRM_ENABLED = 1 ");
		sqlStr.append("AND    F.CRM_FIGURE_ID = S.CRM_FIGURE_ID ");
		sqlStr.append("AND    S.CRM_FIGURE_GROUP_ID = ? ");
		sqlStr.append("ORDER BY F.CRM_FIGURE_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { groupID });
	}

	/**
	 * Add a set
	 */
	public static void addSet(UserBean userBean,
			String physicalID, String figureID) {

		// try to insert a new record
		UtilDBWeb.updateQueue(
				sqlStr_insertSet,
				new String[] {
						physicalID, figureID, "1", userBean.getLoginID(), userBean.getLoginID() });
	}

	public static ArrayList getPhysicalList() {
		// fetch ce list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PFS.CRM_FIGURE_GROUP_ID, PFG.CRM_FIGURE_GROUP_DESC, ");
		sqlStr.append("       PFS.CRM_FIGURE_ID, PF.CRM_FIGURE_DESC, PF.CRM_FIGURE_MEASURE, ");
		sqlStr.append("       PF.CRM_FIGURE_MEASURE_CHI ");
		sqlStr.append("FROM   CRM_PHYSICAL_FIGURE_SET PFS, CRM_PHYSICAL_FIGURE PF, CRM_PHYSICAL_FIGURE_GROUP PFG ");
		sqlStr.append("WHERE  PFS.CRM_FIGURE_ID = PF.CRM_FIGURE_ID ");
		sqlStr.append("AND    PFS.CRM_FIGURE_GROUP_ID = PFG.CRM_FIGURE_GROUP_ID ");		
		sqlStr.append("AND    PF.CRM_ENABLED = 1 ");
		sqlStr.append("ORDER BY PFS.CRM_FIGURE_GROUP_ID, PFS.CRM_ORDER_SEQUENCE ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getPhysicalList(String groupID) {
		// fetch ce list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PFS.CRM_FIGURE_GROUP_ID, PFG.CRM_FIGURE_GROUP_DESC, ");
		sqlStr.append("       PFS.CRM_FIGURE_ID, PF.CRM_FIGURE_DESC, PF.CRM_FIGURE_MEASURE, ");
		sqlStr.append("       PF.CRM_FIGURE_MEASURE_CHI, PF.CRM_FIGURE_DESC_CHI ");
		sqlStr.append("FROM   CRM_PHYSICAL_FIGURE_SET PFS, CRM_PHYSICAL_FIGURE PF, CRM_PHYSICAL_FIGURE_GROUP PFG ");
		sqlStr.append("WHERE  PFS.CRM_FIGURE_ID = PF.CRM_FIGURE_ID ");
		sqlStr.append("AND    PFS.CRM_FIGURE_GROUP_ID = PFG.CRM_FIGURE_GROUP_ID ");		
		sqlStr.append("AND    PFG.CRM_FIGURE_GROUP_ID = "+groupID+" ");
		sqlStr.append("AND    PF.CRM_ENABLED = 1 ");
		sqlStr.append("ORDER BY PFS.CRM_FIGURE_GROUP_ID, PFS.CRM_ORDER_SEQUENCE ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getSeminarPhysicalList(
			String eventID, String scheduleID) {
		// fetch ce list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_FIGURE_ID ");
		sqlStr.append("FROM   CRM_SCHEDULE_PHYSICAL ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = 'crm' ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CRM_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, scheduleID });
	}

	public static ArrayList getClientPhysicalList(String eventID, String scheduleID, String clientID) {
		// fetch ce list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PFS.CRM_FIGURE_GROUP_ID, PFG.CRM_FIGURE_GROUP_DESC, ");
		sqlStr.append("       PFS.CRM_FIGURE_ID, PF.CRM_FIGURE_DESC, PF.CRM_FIGURE_MEASURE, CP.CRM_FIGURE_VALUE ");
		sqlStr.append("FROM   CRM_SCHEDULE_PHYSICAL SP, ");
		sqlStr.append("      (SELECT * FROM CRM_CLIENTS_PHYSICAL CP WHERE CRM_USER_TYPE = 'patient' AND CRM_USER_ID = ?) CP,  ");
		sqlStr.append("       CRM_PHYSICAL_FIGURE_SET PFS, CRM_PHYSICAL_FIGURE PF, CRM_PHYSICAL_FIGURE_GROUP PFG ");
		sqlStr.append("WHERE  SP.CRM_FIGURE_ID = PFS.CRM_FIGURE_ID ");
		sqlStr.append("AND    PFS.CRM_FIGURE_ID = PF.CRM_FIGURE_ID ");
		sqlStr.append("AND    PFS.CRM_FIGURE_GROUP_ID = PFG.CRM_FIGURE_GROUP_ID ");
		sqlStr.append("AND    SP.CRM_SITE_CODE = CP.CRM_SITE_CODE (+) ");
		sqlStr.append("AND    SP.CRM_MODULE_CODE = CP.CRM_MODULE_CODE (+) ");
		sqlStr.append("AND    SP.CRM_EVENT_ID = CP.CRM_EVENT_ID (+) ");
		sqlStr.append("AND    SP.CRM_SCHEDULE_ID = CP.CRM_SCHEDULE_ID (+) ");
		sqlStr.append("AND    SP.CRM_FIGURE_ID = CP.CRM_FIGURE_ID (+) ");
		sqlStr.append("AND    SP.CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    SP.CRM_MODULE_CODE = 'crm' ");
		sqlStr.append("AND    SP.CRM_EVENT_ID = ? ");
		sqlStr.append("AND    SP.CRM_SCHEDULE_ID = ? ");
		sqlStr.append("AND    SP.CRM_ENABLED = 1 ");
		sqlStr.append("ORDER BY PFS.CRM_FIGURE_GROUP_ID, PFS.CRM_ORDER_SEQUENCE ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, eventID, scheduleID });
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CRM_PHYSICAL_FIGURE_GROUP ");
		sqlStr.append("(CRM_FIGURE_GROUP_ID, CRM_FIGURE_GROUP_DESC, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?)");
		sqlStr_insertGroup = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PHYSICAL_FIGURE_GROUP ");
		sqlStr.append("SET    CRM_FIGURE_GROUP_DESC = ?, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_FIGURE_GROUP_ID = ?");
		sqlStr_updateGroup = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PHYSICAL_FIGURE_GROUP ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_FIGURE_GROUP_ID = ?");
		sqlStr_deleteGroup = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CRM_PHYSICAL_FIGURE ");
		sqlStr.append("(CRM_FIGURE_ID, CRM_FIGURE_DESC, CRM_FIGURE_MEASURE, CRM_FIGURE_TYPE, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ?)");
		sqlStr_insertFigure = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PHYSICAL_FIGURE ");
		sqlStr.append("SET    CRM_FIGURE_DESC = ?, ");
		sqlStr.append("       CRM_FIGURE_MEASURE = ?, ");
		sqlStr.append("       CRM_FIGURE_TYPE = ?, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_FIGURE_ID = ?");
		sqlStr_updateFigure = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PHYSICAL_FIGURE ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_FIGURE_ID = ?");
		sqlStr_deleteFigure = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CRM_PHYSICAL_FIGURE_SET ");
		sqlStr.append("(CRM_FIGURE_GROUP_ID, CRM_FIGURE_ID, CRM_ORDER_SEQUENCE, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?)");
		sqlStr_insertSet = sqlStr.toString();
	}
}