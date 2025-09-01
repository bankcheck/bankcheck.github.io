package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboSpecDest extends ComboBoxBase {

	public ComboSpecDest() {
		super(false);
		initContent();
	}

	public void initContent() {
		resetContent(ConstantsTx.SPECDEST_TXCODE);
	}
}