package com.hkah.server.util;

import java.math.BigDecimal;
import java.util.HashMap;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRField;

import com.hkah.client.util.TextUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

public class MessageQueueDataSource implements JRDataSource {
	private HashMap<String, Integer> columnNameMap = new HashMap<String, Integer>();
	private boolean[] isNumericColumn = null;
	private String[] record = null;
	private String[] fields = null;
	private int recordIndex = -1;
	
	public String[] getRecord() {
		return record;
	}

	public MessageQueueDataSource(UserInfo ui, String moduleCode, String prtName, String[] inParam,
			String[] columnName, boolean[] isNumericColumn, boolean isSubReport) throws Exception {
		init(ui, moduleCode, prtName, inParam, columnName, isNumericColumn, isSubReport, null, false);
	}
	
	public MessageQueueDataSource(UserInfo ui, String moduleCode, String prtName, String[] inParam,
			String[] columnName, boolean[] isNumericColumn, boolean isSubReport, boolean printWithNoData) throws Exception {
		init(ui, moduleCode, prtName, inParam, columnName, isNumericColumn, isSubReport, null, printWithNoData);
	}

	public MessageQueueDataSource(UserInfo ui, String moduleCode, String prtName, String[] inParam,
			String[] columnName, boolean[] isNumericColumn, boolean isSubReport, String directDB) throws Exception {
		if (directDB == null) {
			init(ui, moduleCode, prtName, inParam, columnName, isNumericColumn, isSubReport, null, false);
		} else {
			if ("Y".equals(directDB)) {
				init(ui, moduleCode, prtName, inParam, columnName, isNumericColumn, isSubReport, directDB, false);
			} else {
				init(ui, moduleCode, prtName, inParam, columnName, isNumericColumn, isSubReport, null, false);
			}
		}
	}

	public MessageQueueDataSource(UserInfo ui, String moduleCode, String prtName, String[] inParam,
			String[] columnName, boolean[] isNumericColumn, boolean isSubReport, String directDB, 
			boolean printWithNoData) throws Exception {
		if (directDB == null) {
			init(ui, moduleCode, prtName, inParam, columnName, isNumericColumn, isSubReport, null, printWithNoData);
		} else {
			if ("Y".equals(directDB)) {
				init(ui, moduleCode, prtName, inParam, columnName, isNumericColumn, isSubReport, directDB, printWithNoData);
			} else {
				init(ui, moduleCode, prtName, inParam, columnName, isNumericColumn, isSubReport, null, printWithNoData);
			}
		}
	}

	private void init(UserInfo ui, String moduleCode, String prtName, String[] inParam,
			String[] columnName, boolean[] isNumericColumn, boolean isSubReport, String directDB, 
			boolean printWithNoData) throws Exception {
		MessageQueue mQueue;
		if (directDB == null) {
			mQueue = QueryUtil.executeTx(ui, moduleCode, "RPT_" + prtName, inParam);
		}
		else {
			mQueue = QueryUtil.executeTx(ui, moduleCode, "RPT_" + prtName, inParam, directDB);
		}
		
		if (mQueue != null && mQueue.success()) {
			record = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
			// store column location
			if (columnName != null) {
				for (int i = 0; i < columnName.length; i++) {
					getColumnNameMap().put(columnName[i], new Integer(i));
				}
			}
			// store column class
			this.isNumericColumn = isNumericColumn;
		} else {
			if (!isSubReport && !printWithNoData) {
				throw new Exception("No data");
			}
		}
	}
	
	public Integer getRecordSize(){
		if (record != null) {
			return record.length;
		}else{
			return 0;
		}

	}

	public boolean next() throws JRException {
		recordIndex++;
		if (record != null && recordIndex < record.length) {
			setFields(TextUtil.split(record[recordIndex]));
			return true;
		} else {
			return false;
		}
	}

	public Object getFieldValue(JRField field) throws JRException {
		try {
			int index = ((Integer) getColumnNameMap().get(field.getName())).intValue();
			if (isNumericColumn != null && isNumericColumn[index]) {
				return new BigDecimal(getFields()[index]);
			} else {
				return getFields()[index];
			}
		} catch (Exception e) {
			return null;
		}
	}

	public HashMap<String, Integer> getColumnNameMap() {
		return columnNameMap;
	}

	private void setFields(String[] fields) {
		this.fields = fields;
	}

	public String[] getFields() {
		return fields;
	}

	/**
	 * @return the isNumericColumn
	 */
	public boolean[] getIsNumericColumn() {
		return isNumericColumn;
	}
}