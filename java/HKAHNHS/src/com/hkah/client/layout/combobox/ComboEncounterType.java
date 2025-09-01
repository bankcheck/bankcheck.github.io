package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

public class ComboEncounterType extends ComboBoxBase {

	private final static String DEBIT_DISPLAY = "Consultation";
	private final static String CREDIT_DISPLAY = "Waiting";
	private final static String DEBIT_VALUE = "CT";
	private final static String CREDIT_VALUE = "WT";

	public ComboEncounterType() {
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
		setSelectedIndex(0);
	}
}