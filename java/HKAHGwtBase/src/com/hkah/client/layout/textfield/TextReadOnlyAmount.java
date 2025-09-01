package com.hkah.client.layout.textfield;

import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsVariable;

public class TextReadOnlyAmount extends TextReadOnly implements ConstantsVariable {

	@Override
	public void setText(String value) {
		if (value != null && value.trim().length() > 0) {
			super.setText(TextUtil.formatCurrency(value.replaceAll(COMMA_VALUE, EMPTY_VALUE)));
			if (rendered) {
				if (value.indexOf(MINUS_VALUE) == 0) {
					addInputStyleName("read-only-negative");
				} else {
					removeInputStyleName("read-only-negative");
				}
			}
		} else {
			super.setText(value);
			if (rendered) {
				removeInputStyleName("read-only-negative");
			}
		}
	}

	@Override
	public String getText() {
		return super.getText().replaceAll(COMMA_VALUE, EMPTY_VALUE);
	}
}
