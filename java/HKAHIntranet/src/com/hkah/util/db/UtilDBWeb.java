package com.hkah.util.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.servlet.HKAHInitServlet;
import com.hkah.util.TextUtil;
import com.hkah.web.common.ReportableListObject;

public class UtilDBWeb extends UtilDB {

	/**
	 * SEED connection
	 */
	public static ArrayList<ReportableListObject> getReportableListSEED(String sqlStr, String[] parameter) {
		return getReportableList(HKAHInitServlet.getDataSourceSEED(), sqlStr, parameter);
	}

	public static ArrayList<ReportableListObject> getReportableListSEED(String sqlStr) {
		return getReportableListSEED(sqlStr, null);
	}

	public static boolean updateQueueSEED(String sqlStr) {
		return updateQueueSEED(sqlStr, null);
	}

	public static boolean updateQueueSEED(String sqlStr, String[] parameter) {
		return updateQueue(HKAHInitServlet.getDataSourceSEED(), sqlStr, parameter);
	}

	/**
	 * CIS connection
	 */
	public static ArrayList<ReportableListObject> getReportableListCIS(String sqlStr, String[] parameter) {
		return getReportableList(HKAHInitServlet.getDataSourceCIS(), sqlStr, parameter);
	}

	public static ArrayList<ReportableListObject> getReportableListCIS(String sqlStr) {
		return getReportableListCIS(sqlStr, null);
	}

	public static boolean updateQueueCIS(String sqlStr) {
		return updateQueueCIS(sqlStr, null);
	}

	public static boolean updateQueueCIS(String sqlStr, String[] parameter) {
		return updateQueue(HKAHInitServlet.getDataSourceCIS(), sqlStr, parameter);
	}

	public static boolean isExistCIS(String sqlStr, String[] parameter) {
		return isExist(HKAHInitServlet.getDataSourceCIS(), sqlStr, parameter);
	}

	public static boolean isExistCIS(String sqlStr) {
		return isExistCIS(sqlStr, null);
	}

	/**
	 * TAH connection
	 */

	public static ArrayList<ReportableListObject> getReportableListTAH(String sqlStr, String[] parameter) {
		return getReportableList(HKAHInitServlet.getDataSourceTAH(), sqlStr, parameter);
	}

	public static ArrayList<ReportableListObject> getReportableListTAH(String sqlStr) {
		return getReportableListTAH(sqlStr, null);
	}

	public static boolean updateQueueTAH(String sqlStr, String[] parameter) {
		return updateQueue(HKAHInitServlet.getDataSourceTAH(), sqlStr, parameter);
	}

	public static boolean updateQueueTAH(String sqlStr) {
		return updateQueueTAH(sqlStr, null);
	}

	public static boolean isExistTAH(String sqlStr, String[] parameter) {
		return isExist(HKAHInitServlet.getDataSourceTAH(), sqlStr, parameter);
	}

	public static boolean isExistTAH(String sqlStr) {
		return isExistTAH(sqlStr, null);
	}

	/**
	 * FSD connection
	 */
	public static ArrayList<ReportableListObject> getReportableListFSD(String sqlStr, String[] parameter) {
		return getReportableList(HKAHInitServlet.getDataSourceFSD(), sqlStr, parameter);
	}

	public static ArrayList<ReportableListObject> getReportableListFSD(String sqlStr) {
		return getReportableListFSD(sqlStr, null);
	}

	public static boolean updateQueueFSD(String sqlStr, String[] parameter) {
		return updateQueue(HKAHInitServlet.getDataSourceFSD(), sqlStr, parameter);
	}

	public static boolean updateQueueFSD(String sqlStr) {
		return updateQueueFSD(sqlStr, null);
	}

	public static boolean isExistFSD(String sqlStr, String[] parameter) {
		return isExist(HKAHInitServlet.getDataSourceFSD(), sqlStr, parameter);
	}

	public static boolean isExistFSD(String sqlStr) {
		return isExistFSD(sqlStr, null);
	}

	/**
	 * HATS connection
	 */
	public static ArrayList<ReportableListObject> getReportableListHATS(String sqlStr, String[] parameter) {
		return getReportableList(HKAHInitServlet.getDataSourceHATS(), sqlStr, parameter);
	}

	public static ArrayList<ReportableListObject> getReportableListHATS(String sqlStr) {
		return getReportableListHATS(sqlStr, null);
	}

	public static String getQueueResultsHATS(String sqlStr, String[] parameter) {
		return getQueueResults(HKAHInitServlet.getDataSourceHATS(), sqlStr, parameter, ConstantsServerSide.MAXIMUM_NO_OF_RECORDS);
	}

	public static String getQueueResultsHATS(String sqlStr) {
		return getQueueResultsHATS(sqlStr, null);
	}

	public static String getFunctionResultsStrHATS(String txCode, String[] inQueue) {
		return getFunctionResultsStr(HKAHInitServlet.getDataSourceHATS(), txCode, inQueue);
	}

	public static String getFunctionResultsStrHATS(String txCode) {
		return getFunctionResultsStrHATS(txCode, (String[]) null);
	}

	public static String getFunctionResultsStrHATS(String txCode, String inQueue) {
		return getFunctionResultsStrHATS(txCode, TextUtil.split(inQueue));
	}

	public static String callFunctionHATS(String txCode, String actionType, String inQueue) {
		return callFunctionHATS(txCode, actionType, TextUtil.split(inQueue));
	}

	public static String callFunctionHATS(String txCode, String actionType, String[] inQueue) {
		return callFunction(HKAHInitServlet.getDataSourceHATS(), txCode, actionType, inQueue, true);
	}

	public static boolean updateQueueHATS(String sqlStr) {
		return updateQueueHATS(sqlStr, null);
	}

	public static boolean updateQueueHATS(String sqlStr, String[] parameter) {
		return updateQueue(HKAHInitServlet.getDataSourceHATS(), sqlStr, parameter);
	}

	/**
	 * Intranet connection
	 */
	public static ArrayList<ReportableListObject> getReportableList(String sqlStr, String[] parameter, int noOfMaxRecord) {
		return getReportableList(HKAHInitServlet.getDataSourceIntranet(), sqlStr, parameter, noOfMaxRecord);
	}

	public static ArrayList<ReportableListObject> getReportableList(String sqlStr) {
		return getReportableList(sqlStr, null, 0);
	}

	public static ArrayList<ReportableListObject> getReportableList(String sqlStr, int noOfMaxRecord) {
		return getReportableList(sqlStr, null, noOfMaxRecord);
	}

	public static ArrayList<ReportableListObject> getReportableList(String sqlStr, String[] parameter) {
		return getReportableList(sqlStr, parameter, 0);
	}

	public static ArrayList<ReportableListObject> getFunctionResultsHATS(String txCode, String[] inQueue) {
		return getFunctionResults(HKAHInitServlet.getDataSourceHATS(), txCode, inQueue);
	}

	public static ArrayList<ReportableListObject> getFunctionResults(String txCode) {
		return getFunctionResults(txCode, null);
	}

	public static ArrayList<ReportableListObject> getFunctionResults(String txCode, String[] inQueue) {
		return getFunctionResults(HKAHInitServlet.getDataSourceIntranet(), txCode, inQueue);
	}

	public static boolean executeFunction(String txCode) {
		return executeFunction(HKAHInitServlet.getDataSourceIntranet(), txCode);
	}

	public static boolean updateQueue(String sqlStr, String[] parameter) {
		return updateQueue(HKAHInitServlet.getDataSourceIntranet(), sqlStr, parameter);
	}

	public static boolean updateQueue(String sqlStr) {
		return updateQueue(sqlStr, null);
	}

	public static int updateQueueInt(String sqlStr, String[] parameter) {
		return updateQueueInt(HKAHInitServlet.getDataSourceIntranet(), sqlStr, parameter);
	}

	public static int updateQueueInt(String sqlStr) {
		return updateQueueInt(sqlStr, null);
	}

	public static boolean isExist(String sqlStr, String[] parameter) {
		return isExist(HKAHInitServlet.getDataSourceIntranet(), sqlStr, parameter);
	}

	public static boolean isExist(String sqlStr) {
		return isExist(sqlStr, null);
	}

	public static String getFunctionResultsStr(String txCode, String[] inQueue) {
		return getFunctionResultsStr(HKAHInitServlet.getDataSourceIntranet(), txCode, inQueue);
	}

	public static String callFunction(String txCode, String actionType, String[] inQueue) {
		return callFunction(txCode, actionType, inQueue, null, null, false);
	}

	public static String callFunction(String txCode, String actionType, String[] inQueue, boolean withHeader) {
		return callFunction(txCode, actionType, inQueue, null, null, withHeader);
	}

	public static String callFunction(String txCode, String actionType, String[] inQueue, String structDescriptor, String tableQueue, boolean withHeader) {
		return callFunction(HKAHInitServlet.getDataSourceIntranet(), txCode, actionType, inQueue, structDescriptor, tableQueue, withHeader);
	}

	public static Object callFunctionHATS(String txCode, String actionType, Object[] inQueue, int[] inTypes, int outType) {
		return callFunctionGeneral(HKAHInitServlet.getDataSourceHATS(), txCode, actionType, inQueue, inTypes, outType);
	}

	protected static ArrayList<ReportableListObject> array2ArrayList(String[] record) {
		if (record != null) {
			ArrayList<ReportableListObject> reportableList = new ArrayList<ReportableListObject>();
			for (int i = 0; i < record.length; i++) {
				reportableList.add(new ReportableListObject(TextUtil.split(record[i])));
			}
			return reportableList;
		} else {
			return EMPTY_ARRAYLIST;
		}
	}
}