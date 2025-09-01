package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboFaInfoSource extends ComboBoxBase {

	private final static String DEBIT_DISPLAY = "Father's original identity document checked";
	private final static String CREDIT_DISPLAY = "Father's copy of identity document checked";
	private final static String DRCR_DISPLAY = "Father's identity document not produced";
	private final static String DEPOSIT_DISPLAY = "Unwilling to disclose";
	private final static String DEBIT_VALUE = "1";
	private final static String CREDIT_VALUE = "2";
	private final static String DRCR_VALUE = "3";
	private final static String DEPOSIT_VALUE = "4";

	public ComboFaInfoSource() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(DEBIT_VALUE, DEBIT_DISPLAY);
		addItem(CREDIT_VALUE,CREDIT_DISPLAY);
		addItem(DRCR_VALUE,DRCR_DISPLAY);
		addItem(DEPOSIT_VALUE,DEPOSIT_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}