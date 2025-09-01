package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboMedRecLoc extends ComboBoxBase {

	public ComboMedRecLoc() {
		super(true);
		initContent();
	}

	public ComboMedRecLoc(boolean isShowKey) {
		super(isShowKey);
		initContent();
	}
	
	public ComboMedRecLoc(boolean isShowKey, String displayFormat) {
		super(isShowKey);
		setDefaultDisplayFormat(displayFormat);
		initContent();
	}
	
	public void initContent() {
		resetContent(ConstantsTx.MEDRECLOC_TXCODE);
	}
}