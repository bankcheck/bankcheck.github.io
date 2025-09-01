package com.hkah.jasper;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRField;

import com.hkah.web.common.ReportableListObject;

public class ReportMapDataSource implements JRDataSource {
		private HashMap<String, Integer> columnNameMap = new HashMap<String, Integer>();
		private boolean[] isNumericColumn = null;
		private ArrayList<ReportableListObject> record = null;

		private int recordIndex = -1;

		public ReportMapDataSource(ArrayList<ReportableListObject> record,
				final String[] columnName) {
			this(record, columnName, null);
		}

		public ReportMapDataSource(ArrayList<ReportableListObject> record,
				final String[] columnName, boolean[] isNumericColumn) {
			this.record = record;
			
			if (columnName != null) {
				for (int i = 0; i < columnName.length; i++) {
					columnNameMap.put(columnName[i], new Integer(i));
				}
			}
			
			this.isNumericColumn = isNumericColumn;
		}

		@Override
		public boolean next() throws JRException {
			// TODO Auto-generated method stub
			recordIndex++;
			if (record != null && recordIndex < record.size()) {
				return true;
			} else {
				return false;
			}
		}

		@Override
		public Object getFieldValue(JRField field) throws JRException {
			// TODO Auto-generated method stub
			try {
				int index = ((Integer) columnNameMap.get(field.getName())).intValue();
				if (isNumericColumn != null && isNumericColumn[index]) {
					return BigDecimal.valueOf(Double.parseDouble((String)getFieldValue(index)));
				} else {
					return getFieldValue(index);
				}
			} catch (Exception e) {
				return null;
			}
		}
		
		public Object getFieldValue(int index) throws JRException {
			// TODO Auto-generated method stub
			try {
				ReportableListObject row = (ReportableListObject) record.get(recordIndex);
				return row.getValue(index);
			} catch (Exception e) {
				return null;
			}
		}
		
		public int getSize() {
			return record.size();
		}
}
