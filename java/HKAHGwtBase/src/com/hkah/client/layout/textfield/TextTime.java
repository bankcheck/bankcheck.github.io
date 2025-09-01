package com.hkah.client.layout.textfield;

import com.hkah.client.common.Factory;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.shared.constants.ConstantsVariable;

public class TextTime extends TextString {

	public TextTime() {
		super(5);
	}

	@Override
	public void onBlur() {
		String value = getText().trim();
		if (!super.getText().equals(value)) {
			setText(value);
		}

		if (!isValid()) {
			Factory.getInstance().addErrorMessage("The time is invalid.", this);
			setText(ConstantsVariable.EMPTY_VALUE);
		}
	};

	@Override
	public boolean isValid() {
		String value = getText().trim(); 
		if (value.length() == 0 || DateTimeUtil.isValidTime(value)) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public String getText() {
		String time = super.getText();
		if (time.length() == 4 && time.charAt(1) == ':') {
			// append zero if length = 4
			return '0' + time;
		} else if (time.length() == 4 && time.indexOf(":") < 0) {
			// append ':' if length = 4
			return time.substring(0, 2) + ':' + time.substring(2);
		} else {
			return time;
		}
	}
}