package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboWard extends ComboBoxBase {

	public ComboWard() {
		super(true);
		initContent();
	
	}
	
	public ComboWard(boolean showKey) {
		super(showKey);
		initContent();
	
	}


	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.WARDCB_TXCODE);
	}
}