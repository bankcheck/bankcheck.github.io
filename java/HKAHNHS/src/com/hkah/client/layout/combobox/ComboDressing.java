package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboDressing extends ComboBoxBase {

	public ComboDressing() {
		super(false);
		initContent();
	}

	public void initContent() {
		resetContent(ConstantsTx.DRESSING_TXCODE);
	}
}