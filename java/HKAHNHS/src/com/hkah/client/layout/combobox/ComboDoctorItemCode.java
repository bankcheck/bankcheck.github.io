package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboDoctorItemCode extends ComboBoxShowKey {

	public ComboDoctorItemCode() {
		super();
		setMinListWidth(400);
	}

	@Override
	public void initContent(String value) {
		// initial combobox
		resetContent(ConstantsTx.ITEMCODE_TXCODE);
	}
}	