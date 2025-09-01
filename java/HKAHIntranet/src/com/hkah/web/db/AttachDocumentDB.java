package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class AttachDocumentDB {

	private static String sqlStr_insertDocumentAction = null;
	private static String sqlStr_deleteDocumentAction = null;

	private static String getNextDocumentID(String moduleID, String keyID, String key2ID) {
		String documentID = null;

		// get next document id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CO_DOCUMENT_ID) + 1 FROM CO_ATTACH_DOCUMENTS WHERE CO_MODULE_CODE = ? AND CO_KEY_ID = ? AND CO_KEY2_ID = ?",
				new String[] { moduleID, keyID, key2ID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			documentID = reportableListObject.getValue(0);

			// set 1 for initial
			if (documentID == null || documentID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return documentID;
	}

	public static String insertDocument(UserBean userBean, String moduleID, String keyID, String document) {
		return insertDocument(userBean, moduleID, keyID, ConstantsVariable.ZERO_VALUE, document);
	}

	public static String insertDocument(UserBean userBean, String moduleID, String keyID, String key2ID, String document) {
		// set comment ID to 0 if empty
		if (key2ID == null || key2ID.length() == 0) {
			key2ID = ConstantsVariable.ZERO_VALUE;
		}

		// get next document ID
		String documentID = getNextDocumentID(moduleID, keyID, key2ID);

		// try to insert a new record
		if (UtilDBWeb.updateQueue(sqlStr_insertDocumentAction,
				new String[] { moduleID, keyID, key2ID, documentID, document,
					userBean.getLoginID(), userBean.getLoginID() })) {
			return documentID;
		} else {
			return null;
		}
	}

	public static boolean deleteDocument(UserBean userBean, String moduleID, String keyID, String key2ID, String documentID) {
		return UtilDBWeb.updateQueue(sqlStr_deleteDocumentAction, new String[] { userBean.getLoginID(), moduleID, keyID, key2ID, documentID });
	}

	public static ArrayList getDocument(String moduleID, String keyID, String key2ID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DOCUMENT_ID, CO_DOCUMENT_DESC ");
		sqlStr.append("FROM   CO_ATTACH_DOCUMENTS ");
		sqlStr.append("WHERE  CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_KEY_ID = ? ");
		if (key2ID != null && key2ID.length() > 0) {
			sqlStr.append("AND    CO_KEY2_ID = '");
			sqlStr.append(key2ID);
			sqlStr.append("' ");
		} else {
			sqlStr.append("AND    CO_KEY2_ID IS NULL ");
		}
		sqlStr.append("AND    CO_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleID, keyID });
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_ATTACH_DOCUMENTS ");
		sqlStr.append("(CO_MODULE_CODE, CO_KEY_ID, CO_KEY2_ID, CO_DOCUMENT_ID, CO_DOCUMENT_DESC, ");
		sqlStr.append(" CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ");
		sqlStr.append(" ?, ?)");
		sqlStr_insertDocumentAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_ATTACH_DOCUMENTS ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_KEY_ID = ? ");
		sqlStr.append("AND    CO_KEY2_ID = ? ");
		sqlStr.append("AND    CO_DOCUMENT_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_deleteDocumentAction = sqlStr.toString();
	}
}