package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboProcPrim extends ComboBoxBase {

	public ComboProcPrim() {
		super(false);
		initContent();
	}

	public void initContent() {
		resetContent(ConstantsTx.PROCPRIM_TXCODE);
	}
}