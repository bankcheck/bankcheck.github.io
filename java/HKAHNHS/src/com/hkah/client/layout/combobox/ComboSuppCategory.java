package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboSuppCategory extends ComboBoxBase {

	public ComboSuppCategory() {
		super(true);
		initContent();
		this.setMinListWidth(400);
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.SUPP_CATEGORY_TXCODE);
	}
}