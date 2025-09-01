package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboLocation extends ComboBoxBase {

	public ComboLocation() {
		super(false);
		initContent();
	}

	public void initContent() {
		// allow blank
		setShowClearButton(false);
		setAllowBlank(true);

		// initial combobox
		resetContent(ConstantsTx.LOCATION_TXCODE, false, true);
		resetText();
	}
}