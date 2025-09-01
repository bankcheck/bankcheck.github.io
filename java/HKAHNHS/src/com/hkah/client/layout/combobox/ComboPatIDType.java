package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

public class ComboPatIDType extends ComboBoxBase {

	private final static String DEBIT_DISPLAY = "HKID";
	private final static String CREDIT_DISPLAY = "Passport No";
	private final static String DEBIT_VALUE = "HKID";
	private final static String CREDIT_VALUE = "PN";

	public ComboPatIDType() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(DEBIT_VALUE, DEBIT_DISPLAY);
		addItem(CREDIT_VALUE,CREDIT_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(1);
	}
}