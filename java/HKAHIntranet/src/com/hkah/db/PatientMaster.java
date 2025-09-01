package com.hkah.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.sql.DataSource;

import com.hkah.util.QueryUtil;

public class PatientMaster extends ServerSideCallDB {

	protected String getAppendSQL() {
		// insert record
		return "INSERT INTO PATIENT (PATNO, PATFNAME, PATGNAME, PATSEX, LOCCODE, PATVCNT) VALUES (?, ?, ?, ?, ?, ?)";
	}

	protected String getModifySQL() {
		// update record
		return "UPDATE PATIENT SET PATFNAME = ?, PATGNAME = ?, PATVCNT = ?, PATSEX = ?, LOCCODE = ?, PATVCNT = ? WHERE PATNO = ?";
	}

	protected String getDeleteSQL() {
		// delete record
		return "DELETE FROM PATIENT WHERE PATNO = ?";
	}

	protected String getFetchSQL() {
		// list one record
		return "SELECT PATNO, PATFNAME, PATGNAME, PATSEX, LOCCODE, PATVCNT FROM PATIENT WHERE PATNO = ?";
	}

	protected String getListSQL() {
		// list more records
		return "SELECT PATNO, PATFNAME, PATGNAME, PATSEX, LOCCODE, PATVCNT FROM PATIENT WHERE PATNO LIKE ? ORDER BY PATNO";
	}

	protected String[] getAppendParameters(String[] inQueue) {
		// insert record parameters
		return new String[] { inQueue[0], inQueue[1], inQueue[2], inQueue[3], inQueue[4], inQueue[5] };
	}

	protected String[] getModifyParameters(String[] inQueue) {
		// modify record parameters
		return new String[] { inQueue[1], inQueue[2], inQueue[3], inQueue[4], inQueue[5], inQueue[0] };
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
		return new String[] { "%" + parseSQLValue(inQueue[0]) + "%"};
	}

	protected boolean isValid(DataSource dataSource, String actionType, String[] inQueue) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean found = false;

		try {
			conn = dataSource.getConnection();
			ps = conn.prepareStatement("SELECT 1 FROM PATIENT WHERE PATNO = ?");
			ps.setString(1, inQueue[0]);
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