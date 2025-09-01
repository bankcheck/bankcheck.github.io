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
public class ComboItemCat extends ComboBoxBase {

	private final static String DEBIT_DISPLAY = "Debit";
	private final static String CREDIT_DISPLAY = "Credit";
	private final static String DRCR_DISPLAY = "Both Dr. & Cr.";
	private final static String DEPOSIT_DISPLAY = "Deposit";
	private final static String DEBIT_VALUE = "D";
	private final static String CREDIT_VALUE = "C";
	private final static String DRCR_VALUE = "B";
	private final static String DEPOSIT_VALUE = "O";

	public ComboItemCat() {
		super();
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