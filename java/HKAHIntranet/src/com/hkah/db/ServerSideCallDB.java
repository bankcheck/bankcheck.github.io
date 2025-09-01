/*
 * Created on July 28, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

import javax.sql.DataSource;

import com.hkah.constant.ConstantsErrorMessage;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.QueryUtil;
import com.hkah.util.TextUtil;
import com.hkah.util.queue.HKAHQUtl;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ServerSideCallDB implements ConstantsVariable, ConstantsErrorMessage {

	/***********************************************************************
	 * override this methods when using framework handle
	 ***********************************************************************/

	protected String getAppendSQL() { return null; };
	protected String getModifySQL() { return null; };
	protected String getDeleteSQL() { return null; };
	protected String getFetchSQL() { return null; };
	protected String getListSQL(String[] inQueue) { return getListSQL(); };
	protected String getListSQL() { return null; };


	protected String[] getAppendParameters(String[] inQueue) { return null; };
	protected String[] getModifyParameters(String[] inQueue) { return null; };
	protected String[] getDeleteParameters(String[] inQueue) { return null; };
	protected String[] getFetchParameters(String[] inQueue) { return null; };
	protected String[] getListParameters(String[] inQueue) { return null; };

	/***********************************************************************
	 * override this methods when using hibernate
	 ***********************************************************************/

	/**
	 * return output queue when action type = ADD/MOD/DEL
	 *
	 * @param dataSource - datasource
	 * @param txCode - transaction code
	 * @param actionType - action type: ADD/MOD/DEL
	 * @param inQueue - input queue
	 * @return output queue
	 */
	protected String getActionResult(DataSource dataSource, String txCode, String actionType, String[] inQueue) {
		Connection conn = null;
		PreparedStatement ps = null;
		StringBuffer result = new StringBuffer(0);
		String[] inputParameters = null;

		if (isValid(dataSource, actionType, inQueue)) {
			try {
				conn = dataSource.getConnection();
				if (QueryUtil.ACTION_APPEND.equals(actionType)) {

					ps = conn.prepareStatement(getAppendSQL());
					inputParameters = getAppendParameters(inQueue);
				} else if (QueryUtil.ACTION_MODIFY.equals(actionType)) {
					ps = conn.prepareStatement(getModifySQL());
					inputParameters = getModifyParameters(inQueue);
				} else if (QueryUtil.ACTION_DELETE.equals(actionType)) {
					ps = conn.prepareStatement(getDeleteSQL());
					inputParameters = getDeleteParameters(inQueue);
				}

				for (int i=0; i<inputParameters.length; i++) {
					ps.setString(i + 1, inputParameters[i]);
				}

				if (ps.executeUpdate() > 0) {
					result.append(TextUtil.FIELD_DELIMITER);
				} else {
					if (QueryUtil.ACTION_APPEND.equals(actionType)) {
						retCode = RETURN_FAIL;
						retMsg = FAIL_TO_APPEND;
					} else if (QueryUtil.ACTION_MODIFY.equals(actionType)) {
						retCode = RETURN_FAIL;
						retMsg = FAIL_TO_MODIFY;
					} else if (QueryUtil.ACTION_DELETE.equals(actionType)) {
						retCode = RETURN_FAIL;
						retMsg = FAIL_TO_DELETE;
					}
				}
			} catch (Exception ex) {
				ex.printStackTrace();
				retCode = RETURN_DB_ERROR;
				retMsg = ex.toString();
			} finally {
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
		}
		return getOutputQueue(txCode, result.toString());
	}

	/**
	 * special handle if particular column need massage in child class
	 * @param value
	 * @param location
	 * @return
	 */
	protected String getFetchResultHelper(String value, int location) {
		if (value != null) {
			return value;
		} else {
			return EMPTY_VALUE;
		}
	}

	/**
	 * return output queue when action type = GET/LST
	 *
	 * @param dataSource - datasource
	 * @param txCode - transaction type
	 * @param actionType - action type: GET/LST
	 * @param inQueue - input queue
	 * @return output queue
	 */
	protected String getFetchResult(DataSource dataSource, String txCode, String actionType, String[] inQueue) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		ResultSetMetaData metadata = null;
		StringBuffer result = new StringBuffer(0);
		String[] inputParameters = null;

		try {
			conn = dataSource.getConnection();
			if (QueryUtil.ACTION_FETCH.equals(actionType)) {
				ps = conn.prepareStatement(getFetchSQL());

				inputParameters = getFetchParameters(inQueue);
			} else {
				ps = conn.prepareStatement(getListSQL(inQueue));
				inputParameters = getListParameters(inQueue);
			}

			if (inputParameters != null){
			for (int i=0; i<inputParameters.length; i++) {
				ps.setString(i + 1, inputParameters[i]);
			}
			}

			rs = ps.executeQuery();
			metadata = rs.getMetaData();
			while (rs.next()) {
				for (int i = 1; i <= metadata.getColumnCount(); i++) {
					result.append(getFetchResultHelper(rs.getString(i), i));
					result.append(TextUtil.FIELD_DELIMITER);
				}
				result.append(TextUtil.LINE_DELIMITER);
			}

			// check whether it is empty record?
			if (result.length() == 0) {
				retCode = RETURN_FAIL;
				retMsg = NO_RECORD_FOUND;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			retCode = RETURN_DB_ERROR;
			retMsg = ex.toString();
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
		return getOutputQueue(txCode, result.toString());
	}

	protected String getBrowseResult(DataSource dataSource, String txCode, String actionType, String[] inQueue) {
		return getFetchResult(dataSource, txCode, actionType, inQueue);
	}

	/***********************************************************************
	 * generate method for all
	 ***********************************************************************/

	private String userID = null;
	protected String retCode = RETURN_PASS;
	protected String retMsg = OK;

	/**
	 * for append/modify/delete/get/list method forward
	 *
	 * @param dataSource - datasource
	 * @param txCode - transaction code
	 * @param actionType - action type: ADD/MOD/DEL
	 * @param userID - user id
	 * @param inQueue - input queue
	 * @return output queue
	 */
	public String getDBValue(DataSource dataSource, String txCode, String actionType, String userID, String inQueue) {
		this.userID = userID;
		String[] inQueueArray = TextUtil.split(inQueue);
		if (QueryUtil.ACTION_APPEND.equals(actionType) || QueryUtil.ACTION_MODIFY.equals(actionType) || QueryUtil.ACTION_DELETE.equals(actionType)) {
			return getActionResult(dataSource, txCode, actionType, inQueueArray);
		} else if (QueryUtil.ACTION_FETCH.equals(actionType)) {
			return getFetchResult(dataSource, txCode, actionType, inQueueArray);
		} else {
			return getBrowseResult(dataSource, txCode, actionType, inQueueArray);
		}
	}

	/**
	 * return error code
	 * set retCode 0 if normal or > 0 if fail
	 *
	 * @param retCode
	 */
	protected void setReturnCode(boolean retCode) {
		this.retCode = retCode ? RETURN_PASS : RETURN_FAIL;
	}

	/**
	 * return normal or error message
	 * set retMsg OK if normal or error message
	 *
	 * @param retMsg
	 */
	protected void setReturnMsg(String retMsg) {
		this.retMsg = retMsg;
	}

	/**
	 * for append/modify/delete checking before update database
	 *
	 * @param dataSource - database connection
	 * @param actionType - action type: ADD/MOD/DEL
	 * @param inQueue - input string array
	 * @return true if valid
	 */
	protected boolean isValid(DataSource dataSource, String actionType, String[] inQueue) { return true; };

	/**
	 * format queue header with output queue
	 *
	 * @param txCode - transaction code
	 * @param outQueue - output queue (without header)
	 * @return
	 */
	protected String getOutputQueue(String txCode, String outQueue) {
		StringBuffer dbResult = new StringBuffer(0);

		// prepare output header
		dbResult.append(HKAHQUtl.packHeader(txCode, retCode, retMsg));
		// append output queue
		dbResult.append(outQueue);

		return HKAHQUtl.replaceNullTokensToSpace(dbResult.toString());
	}

	/**
	 * store userid
	 *
	 * @return userid
	 */
	protected String getUserID() {
		return userID;
	}
}