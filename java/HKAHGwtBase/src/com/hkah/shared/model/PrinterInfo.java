package com.hkah.shared.model;

import java.io.Serializable;

public class PrinterInfo implements Serializable {
	private static final long serialVersionUID = 1L;
	private String labelPtrName = null;
	private String labelPtr1Name = null;
	private String wtbdAdultPtrName = null;
	private String wtbdBabyPtrName = null;

	public PrinterInfo() {
		super();
	}

	public void clear() {
		labelPtrName = null;
		wtbdAdultPtrName = null;
	}

	public String getPtrName(String type) {
		String Value = null;
		if ("Label".equals(type)) {
			Value = getLabelPtrName();
		} else if ("Label1".equals(type)) {
			Value = getLabelPtr1Name();
		} else if ("WRISTADULT".equals(type)) {
			Value = getWtbdAdultPtrName();
		} else if ("WRISTBABY".equals(type)) {
			Value = getWtbdBabyPtrName();
		}
		return Value;
	}

	public void setPtrName(String type,String value) {
		if ("LABEL".equals(type)) {
			setLabelPtrName(value);
		} else if ("LABEL1".equals(type)) {
			setLabelPtr1Name(value);
		} else if ("WRISTADULT".equals(type)) {
			setWtbdAdultPtrName(value);
		} else if ("WRISTBABY".equals(type)) {
			setWtbdBabyPtrName(value);
		}
	}

	public String getLabelPtrName() {
		return labelPtrName;
	}

	public String getWtbdAdultPtrName() {
		return wtbdAdultPtrName;
	}

	public void setWtbdAdultPtrName(String wtbdPtrName) {
		this.wtbdAdultPtrName = wtbdPtrName;
	}

	public void setLabelPtrName(String labelPtrName) {
		this.labelPtrName = labelPtrName;
	}

	public void setWtbdBabyPtrName(String wtbdBabyPtrName) {
		this.wtbdBabyPtrName = wtbdBabyPtrName;
	}

	public String getWtbdBabyPtrName() {
		return wtbdBabyPtrName;
	}

	public void setLabelPtr1Name(String labelPtr1Name) {
		this.labelPtr1Name = labelPtr1Name;
	}

	public String getLabelPtr1Name() {
		return labelPtr1Name;
	}
}