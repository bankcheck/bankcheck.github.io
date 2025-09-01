package com.hkah.client.layout.textfield;

public class TextDateTimeWithoutSecond extends TextDate {

	public void setText(String value) {
		if (value.length() == 10) {
			value = value + " 00:00";
		} else if (value.length() > 16) {
			value = value.substring(0, 16);
		}
		super.setText(value);
	}

	@Override
	protected String getDateTimePattern() {
		return "dd/MM/yyyy HH:mm";
	}
}