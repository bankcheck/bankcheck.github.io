package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboReligious extends ComboBoxBase {

	public ComboReligious() {
		super(false);
		initContent();
	}

	public void initContent() {
		// allow blank
		setShowClearButton(false);
		setAllowBlank(true);

		// initial combobox
		resetContent(ConstantsTx.RELIGIOUS_TXCODE, false, true);
		resetText();
	}
}