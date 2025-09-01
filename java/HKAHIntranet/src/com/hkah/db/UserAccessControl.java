package com.hkah.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.sql.DataSource;

import com.hkah.util.QueryUtil;

public class UserAccessControl extends ServerSideCallDB {

	protected String getAppendSQL() {
		// insert record
		return "INSERT INTO MT_ACCESS_CONTROL (BRANCH_CODE, FUNCTION_ID, FIELD_ID, USER_GROUP_ID, USER_ID, ACCESS_MODE, CREATED_BY, CREATED_DATE, LAST_UPDATED_BY, LAST_UPDATED_DATE) VALUES (?, ?, ?, ?, ?, ?, ?, SYSDATE, ?, SYSDATE)";
	}

	protected String getModifySQL() {
		// update record
		return "UPDATE MT_ACCESS_CONTROL SET ACCESS_MODE = ?, LAST_UPDATED_BY = ?, LAST_UPDATED_DATE = SYSDATE WHERE BRANCH_CODE = ? AND FUNCTION_ID = ? AND FIELD_ID = ? AND USER_GROUP_ID = ? AND USER_ID = ?";
	}

	protected String getDeleteSQL() {
		// delete record
		return "DELETE FROM MT_ACCESS_CONTROL WHERE BRANCH_CODE = ? AND FUNCTION_ID = ? AND FIELD_ID = ? AND USER_GROUP_ID = ? AND USER_ID = ?";
	}

	protected String getFetchSQL() {
		// list one record
		return "SELECT BRANCH_CODE, FUNCTION_ID, FIELD_ID, USER_GROUP_ID, USER_ID, ACCESS_MODE FROM MT_ACCESS_CONTROL WHERE BRANCH_CODE = ? AND FUNCTION_ID = ? AND FIELD_ID = ? AND USER_GROUP_ID = ? AND USER_ID = ?";
	}

	protected String getListSQL() {
		// list more records
		return "SELECT BRANCH_CODE, FUNCTION_ID, FIELD_ID, USER_GROUP_ID, USER_ID, ACCESS_MODE FROM MT_ACCESS_CONTROL WHERE BRANCH_CODE LIKE ? AND FUNCTION_ID LIKE ? ORDER BY FUNCTION_ID";
	}

	protected String[] getAppendParameters(String[] inQueue) {
		// insert record parameters
		return new String[] { inQueue[0], inQueue[1], inQueue[2], inQueue[3], inQueue[4], inQueue[5], getUserID(), getUserID() };
	}

	protected String[] getModifyParameters(String[] inQueue) {
		// modify record parameters
		return new String[] { inQueue[5], getUserID(), inQueue[0], inQueue[1], inQueue[2], inQueue[3], inQueue[4] };
	}

	protected String[] getDeleteParameters(String[] inQueue) {
		// delete record parameters
		return new String[] { inQueue[0], inQueue[1], inQueue[2], inQueue[3], inQueue[4] };
	}

	protected String[] getFetchParameters(String[] inQueue) {
		// list one record parameters
		return new String[] { inQueue[0], inQueue[1], inQueue[2], inQueue[3], inQueue[4] };
	}

	protected String[] getListParameters(String[] inQueue) {
		// list more record parameters
		return new String[] { "%" + parseSQLValue(inQueue[0]) + "%", "%" + parseSQLValue(inQueue[1]) + "%"};
	}

	protected boolean isValid(DataSource dataSource, String actionType, String[] inQueue) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean found = false;

		try {
			conn = dataSource.getConnection();
			ps = conn.prepareStatement("SELECT 1 FROM MT_ACCESS_CONTROL WHERE BRANCH_CODE = ? AND FUNCTION_ID = ? AND FIELD_ID = ? AND USER_GROUP_ID = ? AND USER_ID = ?");
			ps.setString(1, inQueue[0]);
			ps.setString(2, inQueue[1]);
			ps.setString(3, inQueue[2]);
			ps.setString(4, inQueue[3]);
			ps.setString(5, inQueue[4]);
			rs = ps.executeQuery();

			if (rs.next()) {
				found = true;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (Exception ex) {
				}
			}
			if (ps != null) {
				try {
					ps.close();
				} catch (Exception ex) {
				}
			}
			if (conn != null) {
				try {
					conn.close();
				} catch (Exception ex) {
				}
			}
		}

		if (QueryUtil.ACTION_APPEND.equals(actionType) && found) {
			setReturnCode(false);
			setReturnMsg("Record Already Exist!");
			return false;
		} else if (QueryUtil.ACTION_MODIFY.equals(actionType) && !found) {
			setReturnCode(false);
			setReturnMsg("No Record Found for Modify!");
			return false;
		} else if (QueryUtil.ACTION_DELETE.equals(actionType) && !found) {
			setReturnCode(false);
			setReturnMsg("No Record Found for Removal!");
			return false;
		} else {
			return true;
		}
	}

	private String parseSQLValue(String value) {
		if (ALL_VALUE.equals(value)) {
			return EMPTY_VALUE;
		} else {
			return value;
		}
	}
}