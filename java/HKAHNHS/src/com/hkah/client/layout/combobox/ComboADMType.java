package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboADMType extends ComboBoxBase {

	public ComboADMType() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.ADMTYPE_TXCODE);
	}
}