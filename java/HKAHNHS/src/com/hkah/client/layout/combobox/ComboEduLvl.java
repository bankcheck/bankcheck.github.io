package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboEduLvl extends ComboBoxBase {

	public ComboEduLvl() {
		super(false);
		initContent();
	}

	public void initContent() {
		// allow blank
		setShowClearButton(false);
		setAllowBlank(true);

		// initial combobox
		resetContent(ConstantsTx.EDUCATIONLEVEL_TXCODE, false, true);
		resetText();
	}
}