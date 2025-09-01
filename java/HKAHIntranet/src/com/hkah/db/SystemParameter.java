/*
 * Created on July 25, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.db;

import javax.sql.DataSource;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class SystemParameter extends ServerSideCallDB {

	protected String getAppendSQL() {
		// insert record
		return null;
	}

	protected String getModifySQL() {
		// update record
		// , STRING_VALUE = ?, INTEGER_VALUE = ?, FLOAT_VALUE = ?, BOOL_VALUE = ?, DATE_VALUE = ?, TIME_VALUE = ?
		return "UPDATE MT_SYSTEM_PARAMETER SET DISPLAY_VALUE = ? WHERE CRITERIA = ? AND BRANCH_CODE = ? AND TYPE = ? AND PARA_CODE = ?";
	}

	protected String getDeleteSQL() {
		// delete record
		return null;
	}

	protected String getFetchSQL() {
		// list one record
		return "SELECT CRITERIA, BRANCH_CODE, TYPE, PARA_CODE, PARA_TYPE, DISPLAY_VALUE, PARA_REMARKS FROM MT_SYSTEM_PARAMETER WHERE CRITERIA = ? AND BRANCH_CODE = ? AND TYPE = ? AND PARA_CODE = ?";
	}

	protected String getListSQL() {
		// list more records
		return "SELECT CRITERIA, BRANCH_CODE, TYPE, PARA_CODE, DISPLAY_VALUE FROM MT_SYSTEM_PARAMETER WHERE CRITERIA = ? AND BRANCH_CODE = ? AND TYPE = ?";
	}

	protected String[] getAppendParameters(String[] pStrA_InQueue) {
		// insert record parameters
		return null;
	}

	protected String[] getModifyParameters(String[] pStrA_InQueue) {
		// modify record parameters
		// pStrA_InQueue[5], pStrA_InQueue[6], pStrA_InQueue[7], pStrA_InQueue[8], pStrA_InQueue[9], pStrA_InQueue[10],
		return new String[] { pStrA_InQueue[4], pStrA_InQueue[0], pStrA_InQueue[1], pStrA_InQueue[2], pStrA_InQueue[3] };
	}

	protected String[] getDeleteParameters(String[] pStrA_InQueue) {
		// delete record parameters
		return null;
	}

	protected String[] getFetchParameters(String[] pStrA_InQueue) {
		// list one record parameters
		return new String[] { pStrA_InQueue[0], pStrA_InQueue[1], pStrA_InQueue[2], pStrA_InQueue[3] };
	}

	protected String[] getListParameters(String[] pStrA_InQueue) {
		// list more record parameters
		return new String[] { pStrA_InQueue[0], pStrA_InQueue[1], pStrA_InQueue[2] };
	}

	protected boolean isValid(DataSource pObj_DataSource, String pStr_ActionType, String[] pStrA_InQueue) {
		if (pStrA_InQueue[0].trim().length() == 0) {
			setReturnCode(false);
			setReturnMsg("Empty Criteria!");
			return false;
		} else if (pStrA_InQueue[1].trim().length() == 0) {
			setReturnCode(false);
			setReturnMsg("Empty Branch Code!");
			return false;
		} else if (pStrA_InQueue[2].trim().length() == 0) {
			setReturnCode(false);
			setReturnMsg("Empty Type!");
			return false;
		} else {
			return true;
		}
	}
}