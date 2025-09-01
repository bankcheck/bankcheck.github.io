package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboRefundMethod extends ComboBoxBase{

	public ComboRefundMethod() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.REFUND_METHOD);
	}
}