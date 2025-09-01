package com.hkah.client.layout.combobox;

import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsTx;

public class ComboPatientCat extends ComboBoxBase  {
	public ComboPatientCat() {
		super();
		initContent();
	}

	public ComboPatientCat(boolean showKey) {
		super(showKey);
		initContent();
	}

	public ComboPatientCat(TextReadOnly showTextPanel) {
		super(showTextPanel);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.PATIENT_COMBO_CATEGORY_TXCODE);
	}
}
