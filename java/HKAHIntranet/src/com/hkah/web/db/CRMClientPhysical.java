package com.hkah.web.db;

import java.util.ArrayList;
import java.util.Calendar;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class CRMClientPhysical {

	/**
	 * Add a client physical
	 * @return boolean
	 */
	public static boolean add(UserBean userBean,
			String clientID,
			String eventID,
			String scheduleID,
			String figureID,
			String figureValue) {
		return add(clientID, eventID, scheduleID, figureID, figureValue, userBean.getLoginID());
	}
	
	/**
	 * Add a client physical
	 * @return boolean
	 */
	public static boolean add(
			String clientID,
			String eventID,
			String scheduleID,
			String figureID,
			String figureValue,
			String createUser) {
		// check duplicate
		if (!isExist(clientID, eventID, scheduleID, figureID)) {
			// try to insert a new record
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("INSERT INTO CRM_CLIENTS_PHYSICAL ");
			sqlStr.append("(CRM_SITE_CODE, CRM_MODULE_CODE, CRM_EVENT_ID, CRM_SCHEDULE_ID, CRM_USER_TYPE, CRM_USER_ID, CRM_FIGURE_ID, CRM_FIGURE_VALUE, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
			sqlStr.append("VALUES ");
			sqlStr.append("('" + ConstantsServerSide.SITE_CODE + "', 'crm', ?, ?, 'patient', ?, ?, ?, ?, ?)");
	
			return UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { eventID, scheduleID, clientID, figureID, figureValue, createUser, createUser});
		} else {
			return false;
		}
	}
	
	public static boolean addByClient(UserBean userBean, String clientID, String eventID, 
								String scheduleID, String figureID, String figureValue,String phyDate) {
		StringBuffer sqlStr = new StringBuffer();
		
		if(!isExist(clientID, eventID, scheduleID, figureID,phyDate)) {			
			sqlStr.append("INSERT INTO CRM_CLIENTS_PHYSICAL ");
			sqlStr.append("(CRM_SITE_CODE, CRM_MODULE_CODE, CRM_EVENT_ID, CRM_SCHEDULE_ID, CRM_USER_TYPE, CRM_USER_ID, CRM_FIGURE_ID, CRM_FIGURE_VALUE, CRM_CREATED_USER, CRM_MODIFIED_USER, CRM_RECORD_COUNT,CRM_CREATED_DATE,CRM_MODIFIED_DATE) ");
			sqlStr.append("VALUES ");
			sqlStr.append("('" + ConstantsServerSide.SITE_CODE + "', 'lmc.crm', ?, ?, 'patient', ?, ?, ?, ?, ?, ?,TO_DATE('"+phyDate+"', 'DD/MM/YYYY'),TO_DATE('"+phyDate+" ', 'DD/MM/YYYY'))");
			
			return UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { eventID, scheduleID,
						clientID, figureID, figureValue, userBean.getLoginID(), 
						userBean.getLoginID(), getNextRecordCount(clientID, eventID, scheduleID, figureID)});
		}
		else {
			return updateByClient(userBean, clientID, eventID, scheduleID, 
						figureID, figureValue,
						String.valueOf(Integer.parseInt(getNextRecordCount(clientID, eventID, scheduleID, figureID))-1),phyDate);
		}
	}

	public static boolean updateByClient(UserBean userBean, String clientID, String eventID, 
								String scheduleID, String figureID, String figureValue, String recordCount,String phyDate) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE CRM_CLIENTS_PHYSICAL ");
		sqlStr.append("SET    CRM_FIGURE_VALUE = ?, ");
		sqlStr.append("       CRM_ENABLED = 1, ");
		sqlStr.append("       CRM_MODIFIED_DATE = TO_DATE('"+phyDate+"', 'DD/MM/YYYY'), CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = 'lmc.crm' ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CRM_USER_TYPE = 'patient' ");
		sqlStr.append("AND    CRM_USER_ID = ? ");
		sqlStr.append("AND    CRM_FIGURE_ID = ? ");		
		sqlStr.append("AND 	CRM_MODIFIED_DATE >= TO_DATE('"+phyDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND 	CRM_MODIFIED_DATE <= TO_DATE('"+phyDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
			
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { figureValue, userBean.getLoginID(), eventID, scheduleID, clientID, figureID } );
	}
	
	public static boolean deleteByClient(UserBean userBean,  String eventID, 
			String scheduleID, String figureID,String userType,String userID,String recordCount) {

		// try to delete selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CRM_CLIENTS_PHYSICAL ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = 'lmc.crm' ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CRM_FIGURE_ID = ? ");
		sqlStr.append("AND    CRM_USER_TYPE = ? ");
		sqlStr.append("AND    CRM_USER_ID = ? ");		
		sqlStr.append("AND    CRM_RECORD_COUNT = ? ");
		
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), eventID, scheduleID, figureID, userType,userID,recordCount } );
	}
	
	private static boolean isExist(String clientID, String eventID, String scheduleID, String figureID,String phyDate) {
		Calendar cal = Calendar.getInstance();		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM CRM_CLIENTS_PHYSICAL ");
		sqlStr.append("WHERE CRM_MODULE_CODE = 'lmc.crm' ");
		sqlStr.append("AND CRM_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND CRM_USER_ID = '"+clientID+"' ");
		sqlStr.append("AND CRM_FIGURE_ID = '"+figureID+"' ");
		sqlStr.append("AND CRM_SCHEDULE_ID = '"+scheduleID+"' ");		
		sqlStr.append("AND CRM_MODIFIED_DATE >= TO_DATE('"+phyDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND CRM_MODIFIED_DATE <= TO_DATE('"+phyDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.isExist(sqlStr.toString());
	}
	
	private static String getNextRecordCount(String clientID, String eventID, 
								String scheduleID, String figureID) {
		String count = null;
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT MAX(CRM_RECORD_COUNT) + 1 ");
		sqlStr.append("FROM CRM_CLIENTS_PHYSICAL ");
		sqlStr.append("WHERE CRM_MODULE_CODE = 'lmc.crm' ");
		sqlStr.append("AND CRM_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND CRM_USER_ID = '"+clientID+"' ");
		sqlStr.append("AND CRM_FIGURE_ID = '"+figureID+"' ");
		sqlStr.append("AND CRM_SCHEDULE_ID = '"+scheduleID+"' ");
		sqlStr.append("AND CRM_ENABLED = '1' ");
		
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			count = reportableListObject.getValue(0);

			// set 1 for initial
			if (count == null || count.length() == 0) return "1";
		}
		return count;
	}
	
	/**
	 * Modify a client
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String clientID,
			String eventID,
			String scheduleID,
			String figureID,
			String figureValue) {

		return update(clientID, eventID, scheduleID, figureID, figureValue, userBean.getLoginID());
	}

	public static boolean update(
			String clientID,
			String eventID,
			String scheduleID,
			String figureID,
			String figureValue,
			String modifiedUser) {

		// try to update selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CRM_CLIENTS_PHYSICAL ");
		sqlStr.append("SET    CRM_FIGURE_VALUE = ?, ");
		sqlStr.append("       CRM_ENABLED = 1, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = 'crm' ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CRM_USER_TYPE = 'patient' ");
		sqlStr.append("AND    CRM_USER_ID = ? ");
		sqlStr.append("AND    CRM_FIGURE_ID = ? ");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { figureValue, modifiedUser, eventID, scheduleID, clientID, figureID } );
	}

	public static boolean delete(UserBean userBean,
			String clientID,
			String eventID,
			String scheduleID,
			String figureID) {

		// try to delete selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CRM_CLIENTS_PHYSICAL ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = 'crm' ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CRM_USER_TYPE = 'patient' ");
		sqlStr.append("AND    CRM_USER_ID = ? ");
		sqlStr.append("AND    CRM_FIGURE_ID = ? ");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), eventID, scheduleID, clientID, figureID } );
	}

	public static ArrayList getList(
			String clientID,
			String eventID,
			String scheduleID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_FIGURE_ID, CRM_FIGURE_VALUE, ");
		sqlStr.append("       TO_CHAR(CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_CLIENTS_PHYSICAL ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = 'crm' ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CRM_USER_TYPE = 'patient' ");
		sqlStr.append("AND    CRM_USER_ID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, scheduleID, clientID });
	}
	
	public static ArrayList getAllFigures(String clientID, String figureID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT CRM_FIGURE_ID, CRM_FIGURE_VALUE, ");
		sqlStr.append("TO_CHAR(CRM_MODIFIED_DATE, 'MM/dd/YYYY'), CRM_EVENT_ID, CRM_SCHEDULE_ID ,CRM_USER_TYPE, ");
		sqlStr.append("CRM_USER_ID ,CRM_RECORD_COUNT ");
		sqlStr.append("FROM   CRM_CLIENTS_PHYSICAL ");
		sqlStr.append("WHERE CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = 'lmc.crm' ");
		sqlStr.append("AND    CRM_USER_TYPE = 'patient' ");
		sqlStr.append("AND    CRM_USER_ID = ? ");
		sqlStr.append("AND    CRM_FIGURE_ID = ? ");
		sqlStr.append("AND CRM_ENABLED = '1' ");
		sqlStr.append("ORDER BY CRM_MODIFIED_DATE ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), 
					new String[] { clientID, figureID });
	}
	
	public static ArrayList getTeamAllFigures(String groupID, String figureID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT COUNT(DISTINCT(C.CRM_USERNAME)),ROUND(((SUM(CRM_FIGURE_VALUE))/(COUNT(CRM_FIGURE_VALUE))),2) , TO_CHAR(P.CRM_MODIFIED_DATE, 'MM/dd/YYYY')  ");
		sqlStr.append("FROM   CRM_CLIENTS_PHYSICAL P , CRM_CLIENTS C  ");
		sqlStr.append("WHERE  P.CRM_USER_ID = C.CRM_CLIENT_ID ");
		sqlStr.append("AND    P.CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    P.CRM_MODULE_CODE = 'lmc.crm' ");
		sqlStr.append("AND    P.CRM_USER_TYPE = 'patient' ");
		sqlStr.append("AND    C.CRM_GROUP_ID = '"+groupID+"' ");
		sqlStr.append("AND    P.CRM_FIGURE_ID = '"+figureID+"' ");
		sqlStr.append("AND    P.CRM_ENABLED = '1' ");
		sqlStr.append("GROUP BY TO_CHAR(P.CRM_MODIFIED_DATE, 'MM/dd/YYYY') ");
		sqlStr.append("ORDER BY TO_CHAR(P.CRM_MODIFIED_DATE , 'MM/dd/YYYY') ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	/**
	 * check client physical exist
	 * @return boolean
	 */
	public static boolean isExist(
			String clientID,
			String eventID,
			String scheduleID,
			String figureID) {

		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CRM_CLIENTS_PHYSICAL ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = 'crm' ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_SCHEDULE_ID = ? ");
		sqlStr.append("AND    CRM_USER_TYPE = 'patient' ");
		sqlStr.append("AND    CRM_USER_ID = ? ");
		sqlStr.append("AND    CRM_FIGURE_ID = ? ");

		return UtilDBWeb.isExist(
				sqlStr.toString(),
				new String[] { eventID, scheduleID, clientID, figureID });
	}
}