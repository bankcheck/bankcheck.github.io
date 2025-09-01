package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboOTAppCancelReason extends ComboBoxBase {

	private final static String MR_DISPLAY = "Medical Reason";
	private final static String CANBYDOC_DISPLAY = "Cancel by Doctor";
	private final static String OTHER_DISPLAY = "Other";
	private final static String DEBIT_VALUE = "01";
	private final static String CREDIT_VALUE = "02";
	private final static String DRCR_VALUE = "03";

	public ComboOTAppCancelReason() {
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(DEBIT_VALUE, MR_DISPLAY);
		addItem(CREDIT_VALUE,CANBYDOC_DISPLAY);
		addItem(DRCR_VALUE,OTHER_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}