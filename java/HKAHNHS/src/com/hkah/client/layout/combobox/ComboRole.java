package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboRole extends ComboBoxBase {

	public ComboRole() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.ROLE_TXCODE);
	}
}