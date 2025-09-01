package com.hkah.db;

public class UserGroup extends ServerSideCallDB {

	protected String getAppendSQL() {
		// insert record
		return "INSERT INTO MT_USER_GROUP (USER_GROUP_ID, USER_GROUP_DESC, USER_GROUP_LEVEL, CREATED_BY, CREATED_DATE, LAST_UPDATED_BY, LAST_UPDATED_DATE) VALUES (?, ?, ?, ?, SYSDATE, ?, SYSDATE)";
	}

	protected String getModifySQL() {
		// update record
		return "UPDATE MT_USER_GROUP SET USER_GROUP_DESC = ?, USER_GROUP_LEVEL = ?, LAST_UPDATED_BY = ?, LAST_UPDATED_DATE = SYSDATE WHERE USER_GROUP_ID = ?";
	}

	protected String getDeleteSQL() {
		// delete record
		return "DELETE FROM MT_USER_GROUP WHERE USER_GROUP_ID = ?";
	}

	protected String getFetchSQL() {
		// list one record
		return "SELECT USER_GROUP_ID, USER_GROUP_DESC, USER_GROUP_LEVEL FROM MT_USER_GROUP WHERE USER_GROUP_ID = ?";
	}

	protected String getListSQL() {
		// list more records
		return "SELECT USER_GROUP_ID, USER_GROUP_DESC, USER_GROUP_LEVEL FROM MT_USER_GROUP WHERE USER_GROUP_ID LIKE ? ORDER BY USER_GROUP_ID";
	}

	protected String[] getAppendParameters(String[] inQueue) {
		// insert record parameters
		return new String[] { inQueue[0], inQueue[1], inQueue[2], getUserID(), getUserID() };
	}

	protected String[] getModifyParameters(String[] inQueue) {
		// modify record parameters
		return new String[] { inQueue[1], inQueue[2], getUserID(), inQueue[0] };
	}

	protected String[] getDeleteParameters(String[] inQueue) {
		// delete record parameters
		return new String[] { inQueue[0] };
	}

	protected String[] getFetchParameters(String[] inQueue) {
		// list one record parameters
		return new String[] { inQueue[0] };
	}

	protected String[] getListParameters(String[] inQueue) {
		// list more record parameters
		return new String[] { "%" + inQueue[0] + "%" };
	}
}