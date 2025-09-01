package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class CRMClientInterest {

	private static String getNextInterestSeq(String clientID, String interestID, String interestType) {
		String interestSeq = null;

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUNT(1) + 1 ");
		sqlStr.append("FROM   CRM_CLIENTS_INTEREST ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_INTEREST_ID = ? ");
		sqlStr.append("AND    CRM_INTEREST_TYPE = ?");
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, interestID, interestType });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			interestSeq = row.getValue(0);

			// set 1 for initial
			if (interestSeq == null || interestSeq.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return interestSeq;
	}

	/**
	 * Add a client
	 * @return clientID
	 */
	public static String add(UserBean userBean,
			String clientID,
			String interestID,
			String interestType,
			String remarks) {
		return add(clientID, interestID, interestType, remarks, userBean.getLoginID());
	}

	/**
	 * Add a client interest
	 * @return interest seq
	 */
	public static String add(
			String clientID,
			String interestID,
			String interestType,
			String remarks,
			String createUser) {
		// set default interest id if empty
		if (interestID == null || interestID.length() == 0) {
			interestID = ConstantsVariable.ZERO_VALUE;
		}

		// check duplicate
		if (!isExist(clientID, interestID, interestType, remarks)) {
			// get next client ID
			String interestSeq = getNextInterestSeq(clientID, interestID, interestType);
	
			// try to insert a new record
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("INSERT INTO CRM_CLIENTS_INTEREST ");
			sqlStr.append("(CRM_CLIENT_ID, CRM_INTEREST_ID, CRM_INTEREST_SEQ, CRM_INTEREST_TYPE, CRM_INTEREST_REMARKS, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
			sqlStr.append("VALUES ");
			sqlStr.append("(?, ?, ?, ?, ?, ?, ?)");
	
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { clientID, interestID, interestSeq, interestType, remarks, createUser, createUser})) {
				return interestSeq;
			} else {
				return null;
			}
		} else {
			return null;
		}
	}

	/**
	 * Modify a client
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String clientID,
			String interestID,
			String interestSeq,
			String interestType,
			String remarks) {

		return update(clientID, interestID, interestSeq, interestType, remarks, userBean.getLoginID());
	}

	public static boolean update(
			String clientID,
			String interestID,
			String interestSeq,
			String interestType,
			String remarks,
			String modifiedUser) {

		// try to update selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CRM_CLIENTS_INTEREST ");
		sqlStr.append("SET    CRM_INTEREST_REMARKS = ?, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_INTEREST_ID = ? ");
		sqlStr.append("AND    CRM_INTEREST_SEQ = ? ");
		sqlStr.append("AND    CRM_INTEREST_TYPE = ?");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { remarks, modifiedUser, clientID, interestID, interestSeq, interestType } );
	}

	public static boolean delete(UserBean userBean,
			String clientID,
			String interestID,
			String interestSeq,
			String interestType) {

		// try to delete selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CRM_CLIENTS_INTEREST ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_INTEREST_ID = ? ");
		sqlStr.append("AND    CRM_INTEREST_SEQ = ? ");
		sqlStr.append("AND    CRM_INTEREST_TYPE = ?");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), clientID, interestID, interestSeq, interestType } );
	}

	public static ArrayList getList(
			String clientID,
			String interestType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_INTEREST_ID, CRM_INTEREST_SEQ, CRM_INTEREST_REMARKS, ");
		sqlStr.append("       TO_CHAR(CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_CLIENTS_INTEREST ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_INTEREST_TYPE = ? ");
		sqlStr.append("AND    CRM_ENABLED = 1 ");
		sqlStr.append("ORDER BY CRM_INTEREST_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, interestType });
	}

	public static ArrayList get(
			String clientID,
			String interestID,
			String interestSeq,
			String interestType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_INTEREST_REMARKS ");
		sqlStr.append("FROM   CRM_CLIENTS_INTEREST ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_INTEREST_ID = ? ");
		sqlStr.append("AND    CRM_INTEREST_SEQ = ? ");
		sqlStr.append("AND    CRM_INTEREST_TYPE = ?");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, interestID, interestSeq, interestType });
	}

	/**
	 * check client interest exist
	 * @return boolean
	 */
	public static boolean isExist(
			String clientID,
			String interestID,
			String interestType,
			String remarks) {

		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CRM_CLIENTS_INTEREST ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_INTEREST_ID = ? ");
		sqlStr.append("AND   (CRM_INTEREST_ID > 0 OR CRM_INTEREST_REMARKS = ?) ");	// id < 0 or other + remark as key
		sqlStr.append("AND    CRM_INTEREST_TYPE = ? ");
		sqlStr.append("AND    CRM_ENABLED = 1 ");

		return UtilDBWeb.isExist(
				sqlStr.toString(),
				new String[] { clientID, interestID, interestType, remarks});
	}
}