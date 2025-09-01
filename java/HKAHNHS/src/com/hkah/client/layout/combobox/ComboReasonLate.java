package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboReasonLate extends ComboBoxBase {
	public ComboReasonLate() {
		super(false);
		initContent();
	}

	public void initContent() {
		resetContent(ConstantsTx.REASONLATE_TXCODE);
	}
}