package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboPatCat extends ComboBoxBase{

	public ComboPatCat() {
		super(true);
		initContent();
	}

	public ComboPatCat(boolean showKey) {
		super(showKey);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.PAT_CAT);
	}
}