package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboSource extends ComboBoxBase {

	public ComboSource() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.SOURCE_TXCODE);
	}
}