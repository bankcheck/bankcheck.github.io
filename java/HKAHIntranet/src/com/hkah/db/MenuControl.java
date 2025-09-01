package com.hkah.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.sql.DataSource;

import com.hkah.util.QueryUtil;

public class MenuControl extends ServerSideCallDB {

	protected String getAppendSQL() {
		// insert record
		return "INSERT INTO MT_MENU (WORKSTATION_ID, MENU_ID, FUNCTION_ID, IS_SUBMENU, SUBMENU_ID, CREATED_BY, CREATED_DATE, LAST_UPDATED_BY, LAST_UPDATED_DATE) VALUES (?, ?, ?, ?, ?, ?, SYSDATE, ?, SYSDATE)";
	}

	protected String getModifySQL() {
		// update record
		return "UPDATE MT_MENU SET FUNCTION_ID = ?,  IS_SUBMENU = ?, SUBMENU_ID = ?, LAST_UPDATED_BY = ?, LAST_UPDATED_DATE = SYSDATE WHERE WORKSTATION_ID = ? AND MENU_ID = ?";
	}

	protected String getDeleteSQL() {
		// delete record
		return "DELETE FROM MT_MENU WHERE WORKSTATION_ID = ? AND MENU_ID = ?";
	}

	protected String getFetchSQL() {
		// list one record
		return "SELECT WORKSTATION_ID, MENU_ID, FUNCTION_ID, IS_SUBMENU, SUBMENU_ID FROM MT_MENU WHERE WORKSTATION_ID = ? AND MENU_ID = ?";
	}

	protected String getListSQL() {
		// list more records
		return "SELECT WORKSTATION_ID, MENU_ID, FUNCTION_ID, IS_SUBMENU, SUBMENU_ID FROM MT_MENU WHERE WORKSTATION_ID LIKE ? ORDER BY WORKSTATION_ID, MENU_ID";
	}

	protected String[] getAppendParameters(String[] inQueue) {
		// insert record parameters
		return new String[] { inQueue[0], inQueue[1], inQueue[2], inQueue[3], inQueue[4], getUserID(), getUserID() };
	}

	protected String[] getModifyParameters(String[] inQueue) {
		// modify record parameters
		return new String[] { inQueue[2], inQueue[3], inQueue[4], getUserID(), inQueue[0], inQueue[1] };
	}

	protected String[] getDeleteParameters(String[] inQueue) {
		// delete record parameters
		return new String[] { inQueue[0], inQueue[1] };
	}

	protected String[] getFetchParameters(String[] inQueue) {
		// list one record parameters
		return new String[] { inQueue[0], inQueue[1] };
	}

	protected String[] getListParameters(String[] inQueue) {
		// list more record parameters
		return new String[] { "%" + parseSQLValue(inQueue[0]) + "%"};
	}

	protected boolean isValid(DataSource dataSource, String actionType, String[] inQueue) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean found = false;

		try {
			conn = dataSource.getConnection();
			ps = conn.prepareStatement("SELECT 1 FROM MT_MENU WHERE WORKSTATION_ID = ? AND MENU_ID = ?");
			ps.setString(1, inQueue[0]);
			ps.setString(2, inQueue[1]);
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