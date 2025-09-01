package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboOTLogReason extends ComboBoxBase {

	public ComboOTLogReason() {
		super(false);
		initContent();
	}

	public void initContent() {
		resetContent(ConstantsTx.OTLOGREASON_TXCODE);
	}
}