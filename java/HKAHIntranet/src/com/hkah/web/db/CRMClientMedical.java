/*
 * Created on April 23, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CRMClientMedical {

	private static String getNextMedicalSeq(String clientID, String medicalID, String medicalType) {
		String medicalSeq = null;

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUNT(1) + 1 ");
		sqlStr.append("FROM   CRM_CLIENTS_MEDICAL ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_MEDICAL_ID = ? ");
		sqlStr.append("AND    CRM_MEDICAL_TYPE = ?");
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, medicalID, medicalType });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			medicalSeq = row.getValue(0);

			// set 1 for initial
			if (medicalSeq == null || medicalSeq.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return medicalSeq;
	}

	/**
	 * Add a client
	 * @return clientID
	 */
	public static String add(UserBean userBean,
			String clientID,
			String medicalID,
			String medicalType,
			String remarks) {
		return add(clientID, medicalID, medicalType, remarks, userBean.getLoginID());
	}

	/**
	 * Add a client interest
	 * @return interest seq
	 */
	public static String add(
			String clientID,
			String medicalID,
			String medicalType,
			String remarks,
			String createUser) {
		// set default medical id if empty
		if (medicalID == null || medicalID.length() == 0) {
			medicalID = ConstantsVariable.ZERO_VALUE;
		}

		// check duplicate
		if (!isExist(clientID, medicalID, medicalType, remarks)) {
			// get next client ID
			String medicalSeq = getNextMedicalSeq(clientID, medicalID, medicalType);
	
			// try to insert a new record
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("INSERT INTO CRM_CLIENTS_MEDICAL ");
			sqlStr.append("(CRM_CLIENT_ID, CRM_MEDICAL_ID, CRM_MEDICAL_SEQ, CRM_MEDICAL_TYPE, CRM_MEDICAL_REMARKS, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
			sqlStr.append("VALUES ");
			sqlStr.append("(?, ?, ?, ?, ?, ?, ?)");
	
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { clientID, medicalID, medicalSeq, medicalType, remarks, createUser, createUser})) {
				return medicalSeq;
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
			String medicalID,
			String medicalSeq,
			String medicalType,
			String remarks) {

		return update(clientID, medicalID, medicalSeq, medicalType, remarks, userBean.getLoginID());
	}

	public static boolean update(
			String clientID,
			String medicalID,
			String medicalSeq,
			String medicalType,
			String remarks,
			String modifiedUser) {

		// try to update selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CRM_CLIENTS_MEDICAL ");
		sqlStr.append("SET    CRM_MEDICAL_REMARKS = ?, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_MEDICAL_ID = ? ");
		sqlStr.append("AND    CRM_MEDICAL_SEQ = ? ");
		sqlStr.append("AND    CRM_MEDICAL_TYPE = ?");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { remarks, modifiedUser, clientID, medicalID, medicalSeq, medicalType } );
	}

	public static boolean delete(UserBean userBean,
			String clientID,
			String medicalID,
			String medicalSeq,
			String medicalType) {

		// try to delete selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CRM_CLIENTS_MEDICAL ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_MEDICAL_ID = ? ");
		sqlStr.append("AND    CRM_MEDICAL_SEQ = ? ");
		sqlStr.append("AND    CRM_MEDICAL_TYPE = ?");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), clientID, medicalID, medicalSeq, medicalType } );
	}

	public static ArrayList getList(
			String clientID,
			String medicalType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_MEDICAL_ID, CRM_MEDICAL_SEQ, CRM_MEDICAL_REMARKS, ");
		sqlStr.append("       TO_CHAR(CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_CLIENTS_MEDICAL ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_MEDICAL_TYPE = ? ");
		sqlStr.append("ORDER BY CRM_MEDICAL_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, medicalType });
	}

	public static ArrayList get(
			String clientID,
			String medicalID,
			String medicalSeq,
			String medicalType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_MEDICAL_REMARKS ");
		sqlStr.append("FROM   CRM_CLIENTS_MEDICAL ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_MEDICAL_ID = ? ");
		sqlStr.append("AND    CRM_MEDICAL_SEQ = ? ");
		sqlStr.append("AND    CRM_MEDICAL_TYPE = ?");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, medicalID, medicalSeq, medicalType });
	}

	/**
	 * check client interest exist
	 * @return boolean
	 */
	public static boolean isExist(
			String clientID,
			String medicalID,
			String medicalType,
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
				new String[] { clientID, medicalID, medicalType, remarks});
	}
}