package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboMedMediaType extends ComboBoxBase {

	public ComboMedMediaType() {
		super(false);
		initContent();
	}

	public void initContent() {
		resetContent(ConstantsTx.MEDRECTYPE_TXCODE);
	}
}