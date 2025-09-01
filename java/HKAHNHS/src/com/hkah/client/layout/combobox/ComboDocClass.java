package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboDocClass extends ComboBoxShowKey {

	public ComboDocClass() {
		super();
		setMinListWidth(400);
	}

	@Override
	public void initContent(String value) {
		// initial combobox
		resetContent(ConstantsTx.DOCCLASS_TXCODE);
	}
}	