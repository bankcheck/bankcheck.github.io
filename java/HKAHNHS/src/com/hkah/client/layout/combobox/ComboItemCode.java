package com.hkah.client.layout.combobox;

import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsTx;

public class ComboItemCode extends ComboBoxBase {

	public ComboItemCode() {
		super(true);
		initContent();
	}

	public ComboItemCode(boolean showKey) {
		super(showKey);
		initContent();
	}

	public ComboItemCode(TextReadOnly showTextPanel) {
		super(showTextPanel);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.ITEMCODE_TXCODE);
	}
}