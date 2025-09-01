package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboUser extends ComboBoxBase {

	public ComboUser() {
		super(false);
		initContent();
	}

	public ComboUser(boolean isShowKey) {
		super(isShowKey);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.USER_TXCODE);
	}
}