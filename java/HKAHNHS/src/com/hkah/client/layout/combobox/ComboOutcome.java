package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboOutcome extends ComboBoxBase {

	public ComboOutcome() {
		super(false);
		initContent();
	}

	public void initContent() {
		resetContent(ConstantsTx.OUTCOME_TXCODE);
	}
}