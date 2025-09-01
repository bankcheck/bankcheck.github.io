/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboArea extends ComboBoxBase {

	private final static String DEBIT_DISPLAY = "Hong Kong";
	private final static String CREDIT_DISPLAY = "Kowloon";
	private final static String DRCR_DISPLAY = "New Territories";
	private final static String DEPOSIT_DISPLAY = "Others";
	private final static String DEBIT_VALUE = "H";
	private final static String CREDIT_VALUE = "K";
	private final static String DRCR_VALUE = "N";
	private final static String DEPOSIT_VALUE = "O";

	public ComboArea() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(DEBIT_VALUE, DEBIT_DISPLAY);
		addItem(CREDIT_VALUE, CREDIT_DISPLAY);
		addItem(DRCR_VALUE, DRCR_DISPLAY);
		addItem(DEPOSIT_VALUE, DEPOSIT_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}