package com.hkah.jasper;

import java.util.ArrayList;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRField;

import com.hkah.web.common.ReportableListObject;

public class ReportListDataSource implements JRDataSource {

	private ArrayList record = null;
	private int recordIndex = -1;

	public ReportListDataSource(ArrayList record) {
		this.record = record;
	}

	@Override
	public boolean next() throws JRException {
		// TODO Auto-generated method stub
		recordIndex++;
		return (record != null && recordIndex < record.size());
	}

	@Override
	public Object getFieldValue(JRField field) throws JRException {
		// TODO Auto-generated method stub
		String fieldName = field.getName();
		try {
			return getFieldValue(Integer.parseInt(fieldName) - 1);
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
}