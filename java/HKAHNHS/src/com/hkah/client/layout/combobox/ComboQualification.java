package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboQualification extends ComboBoxShowKey {

	public ComboQualification() {
		super();
		setMinListWidth(400);
	}

	@Override
	public void initContent(String value) {
		// initial combobox
		resetContent(ConstantsTx.QUALIFICATION_TXCODE);
	}
}	