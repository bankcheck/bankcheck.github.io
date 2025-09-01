package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboSpecialty extends ComboBoxBase {

	public ComboSpecialty() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.LIST_DOCTOR_SPECIALTY_TXCODE);
	}
}