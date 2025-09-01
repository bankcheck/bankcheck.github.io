package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboMarketingSource extends ComboBoxBase {

	public ComboMarketingSource() {
		super(false);
		initContent();
	}

	public void initContent() {
		// allow blank
		setShowClearButton(false);
		setAllowBlank(true);

		// initial combobox
		resetContent(ConstantsTx.MARKETINGSOURCE_TXCODE, false, true);
		resetText();
	}
}