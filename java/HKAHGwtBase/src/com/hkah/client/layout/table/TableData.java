package com.hkah.client.layout.table;

import com.extjs.gxt.ui.client.data.BaseModelData;

public class TableData extends BaseModelData {

	/**
	 * Object to store table row record 
	 */
	private static final long serialVersionUID = 1L;
	private Object[] fields = null;
	private String[] columnIDs = null;

	public TableData(String[] columnIDs, Object[] values) {
		fields = new Object[values.length];
		this.columnIDs = columnIDs; 
		for (int i = 0; i < values.length; i++) {
			if (values[i] != null){				
				setValue(i, values[i]);
			} else {
				setValue(i, "");
			}
		}
	}

	public void setValue(int index, Object value) {
		if (value != null) {
			fields[index] = value;
			set(columnIDs[index], value);
		}
	}

	public Object getValue(int index) {
		return fields[index];
	}

	public Object[] toArray() {
		return fields;
	}

	public int getSize() {
		return fields.length;
	}
}