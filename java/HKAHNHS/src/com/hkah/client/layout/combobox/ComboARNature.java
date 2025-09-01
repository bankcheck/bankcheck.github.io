package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboARNature extends ComboBoxBase {
	public ComboARNature() {
		super(false);
		initContent();
	}

	public void initContent() {
		resetContent(ConstantsTx.ARNATURE_TXCODE);
	}
}
