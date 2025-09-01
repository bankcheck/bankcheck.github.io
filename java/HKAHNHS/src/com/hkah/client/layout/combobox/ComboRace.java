package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboRace extends ComboBoxBase {

	public ComboRace() {
		super(false);
		initContent();
	}

	public void initContent() {
		// allow blank
		setShowClearButton(false);
		setAllowBlank(true);

		// initial combobox
		resetContent(ConstantsTx.RACE_TXCODE, false, true);
		resetText();
	}
}