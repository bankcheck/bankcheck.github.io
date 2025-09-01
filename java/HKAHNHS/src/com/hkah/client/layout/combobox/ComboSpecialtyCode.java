package com.hkah.client.layout.combobox;

import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsTx;

public class ComboSpecialtyCode extends ComboBoxShowKey {

	public ComboSpecialtyCode() {
		super();
		setMinListWidth(400);
	}

	public ComboSpecialtyCode(TextReadOnly showTextPanel) {
		super(showTextPanel);
		setMinListWidth(400);
	}

	@Override
	public void initContent(String value) {
		// initial combobox
		resetContent(ConstantsTx.LIST_SPECIALTY_TXCODE);
	}
}
